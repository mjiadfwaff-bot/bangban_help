// Package sys
// @Link  https://github.com/bufanyun/hotgo
// @Copyright  Copyright (c) 2023 HotGo CLI
// @Author  Codex
// @License  https://github.com/bufanyun/hotgo/blob/master/LICENSE
package sys

import (
	"bytes"
	"context"
	"crypto/hmac"
	"crypto/sha256"
	"encoding/json"
	"errors"
	"fmt"
	"html"
	"io"
	"net"
	"net/http"
	"net/url"
	"path"
	"strings"
	"sync"
	"time"

	"github.com/go-telegram/bot"
	"github.com/go-telegram/bot/models"
	"github.com/gogf/gf/v2/errors/gerror"
	"github.com/gogf/gf/v2/frame/g"
	"hotgo/addons/lazysheep_tggo/model"
)

const (
	quickMediaGroupLimit          = 10
	quickMediaMaxBytes            = 48 << 20
	quickMediaDownloadConcurrency = 5
	bangchatMediaSecret           = "dc7f7fbb4f36fbb43071882d4a1ae7a514996adcb21464e6988eccaa64aa3ed3"
)

var quickMediaHTTPClient = &http.Client{
	Timeout: 90 * time.Second,
	Transport: &http.Transport{
		Proxy: http.ProxyFromEnvironment,
		DialContext: (&net.Dialer{
			Timeout:   15 * time.Second,
			KeepAlive: 30 * time.Second,
		}).DialContext,
		TLSHandshakeTimeout:   15 * time.Second,
		ResponseHeaderTimeout: 60 * time.Second,
		ExpectContinueTimeout: 1 * time.Second,
	},
}

func (s *sLazySheepTGGo) pushQuickCollectedNote(ctx context.Context, botKey string, binding *model.BindingRecord, raw json.RawMessage, fallbackChatID int64) error {
	if binding == nil {
		return nil
	}
	rt := s.runtime.get(botKey)
	if rt == nil || rt.client == nil {
		return gerror.New("机器人运行实例不存在，请先启动机器人")
	}

	targetChatID := binding.PublishChatID
	if targetChatID == 0 {
		targetChatID = fallbackChatID
	}
	if targetChatID == 0 {
		return nil
	}

	var msg sourceMessage
	if err := json.Unmarshal(raw, &msg); err != nil {
		return gerror.Wrap(err, "解析消息失败")
	}
	if msg.Type != "MESSAGE_TYPE_NOTES" {
		return nil
	}
	var note noteContent
	if err := json.Unmarshal([]byte(msg.Content), &note); err != nil {
		return gerror.Wrap(err, "解析笔记内容失败")
	}

	title, text := noteText(note.Items)
	g.Log().Debugf(ctx, "快速推送开始 botKey:%s binding:%s targetChat:%d title:%s", botKey, binding.Key, targetChatID, title)
	plugins := s.collectorPlugins(ctx, botKey)
	settings := map[string]any{}
	if cfg := plugins["collector"]; cfg != nil && cfg.Settings != nil {
		settings = cfg.Settings
	}
	locations := collectQuickLocations(note.Items)
	caption := buildQuickCaption(title, text, settings, locations)
	mediaAssets := buildQuickMediaAssets(ctx, note.Items)
	g.Log().Debugf(ctx, "快速推送媒体准备完成 botKey:%s binding:%s assets:%d", botKey, binding.Key, len(mediaAssets))
	if len(mediaAssets) == 0 {
		return s.sendQuickText(ctx, rt.client, targetChatID, caption)
	}

	chunks := chunkQuickMediaAssets(mediaAssets, quickMediaGroupLimit)
	var firstMsgID int
	for i, chunk := range chunks {
		chunkCaption := ""
		if i == 0 {
			chunkCaption = caption
		}
		var reply *models.ReplyParameters
		if i > 0 && firstMsgID > 0 {
			reply = &models.ReplyParameters{
				MessageID:                firstMsgID,
				AllowSendingWithoutReply: true,
			}
		}
		msgs, err := sendQuickMediaChunk(ctx, rt.client, targetChatID, chunk, chunkCaption, reply)
		if err != nil {
			return err
		}
		g.Log().Debugf(ctx, "快速推送媒体分片完成 botKey:%s binding:%s chunk:%d messages:%d", botKey, binding.Key, i+1, len(msgs))
		if firstMsgID == 0 && len(msgs) > 0 {
			firstMsgID = msgs[0].ID
		}
	}
	g.Log().Debugf(ctx, "快速推送完成 botKey:%s binding:%s targetChat:%d", botKey, binding.Key, targetChatID)
	return nil
}

func (s *sLazySheepTGGo) sendQuickText(ctx context.Context, client *bot.Bot, chatID int64, text string) error {
	if strings.TrimSpace(text) == "" {
		return nil
	}
	_, err := client.SendMessage(ctx, &bot.SendMessageParams{
		ChatID:    chatID,
		Text:      text,
		ParseMode: models.ParseModeHTML,
	})
	return err
}

func buildQuickCaption(title, text string, settings map[string]any, locations []quickLocationItem) string {
	footer := pushSettingString(settings, "footer", "")
	parts := make([]string, 0, 4)
	if strings.TrimSpace(title) != "" {
		parts = append(parts, html.EscapeString(title))
	}
	if trimmed := strings.TrimSpace(text); trimmed != "" {
		parts = append(parts, html.EscapeString(limitCaption(trimmed, 650)))
	}
	if footer != "" {
		parts = append(parts, html.EscapeString(footer))
	}
	if locationBlock := buildQuickLocationBlock(locations); locationBlock != "" {
		parts = append(parts, locationBlock)
	}
	return strings.Join(parts, "\n\n")
}

type quickMediaAsset struct {
	Type         string
	Filename     string
	Data         []byte
	SourceURL    string
	ThumbnailURL string
	Duration     int
	AspectRatio  float64
}

func buildQuickMediaAssets(ctx context.Context, items []noteItem) []quickMediaAsset {
	results := make([]*quickMediaAsset, len(items))
	thumbURL := ""
	for _, item := range items {
		if item.Type == noteTypeImage && thumbURL == "" {
			thumbURL = strings.TrimSpace(item.Content)
		}
	}
	var wg sync.WaitGroup
	sem := make(chan struct{}, quickMediaDownloadConcurrency)
	for index, item := range items {
		switch item.Type {
		case noteTypeImage:
			wg.Add(1)
			go func(idx int, item noteItem) {
				defer wg.Done()
				sem <- struct{}{}
				defer func() { <-sem }()
				g.Log().Debugf(ctx, "下载快速推送图片开始 index:%d url:%s", idx, item.Content)
				filename, data, err := downloadQuickMedia(ctx, item.Content, item.Type, idx)
				if err != nil {
					g.Log().Warningf(ctx, "下载快速推送图片失败 url:%s err:%+v", item.Content, err)
					return
				}
				g.Log().Debugf(ctx, "下载快速推送图片完成 index:%d bytes:%d", idx, len(data))
				results[idx] = &quickMediaAsset{
					Type:      noteTypeImage,
					Filename:  filename,
					Data:      data,
					SourceURL: strings.TrimSpace(item.Content),
				}
			}(index, item)
		case noteTypeVideo:
			wg.Add(1)
			go func(idx int, item noteItem) {
				defer wg.Done()
				sem <- struct{}{}
				defer func() { <-sem }()
				g.Log().Debugf(ctx, "下载快速推送视频开始 index:%d url:%s", idx, item.Content)
				filename, data, err := downloadQuickMedia(ctx, item.Content, item.Type, idx)
				if err != nil {
					g.Log().Warningf(ctx, "下载快速推送视频失败 url:%s err:%+v", item.Content, err)
					return
				}
				g.Log().Debugf(ctx, "下载快速推送视频完成 index:%d bytes:%d", idx, len(data))
				results[idx] = &quickMediaAsset{
					Type:         noteTypeVideo,
					Filename:     filename,
					Data:         data,
					SourceURL:    strings.TrimSpace(item.Content),
					ThumbnailURL: thumbURL,
					Duration:     item.Duration,
					AspectRatio:  item.AspectRatio,
				}
			}(index, item)
		}
	}
	wg.Wait()
	out := make([]quickMediaAsset, 0, len(items))
	for _, asset := range results {
		if asset == nil {
			continue
		}
		out = append(out, *asset)
	}
	return out
}

type quickLocationItem struct {
	Title    string
	SubTitle string
	Content  string
}

func collectQuickLocations(items []noteItem) []quickLocationItem {
	out := make([]quickLocationItem, 0, len(items))
	for _, item := range items {
		if item.Type != noteTypeLocation {
			continue
		}
		out = append(out, quickLocationItem{
			Title:    item.Title,
			SubTitle: item.SubTitle,
			Content:  item.Content,
		})
	}
	return out
}

func buildQuickLocationBlock(items []quickLocationItem) string {
	parts := make([]string, 0, len(items))
	for _, item := range items {
		blockParts := make([]string, 0, 2)
		if strings.TrimSpace(item.Title) != "" {
			blockParts = append(blockParts, html.EscapeString(item.Title))
		}
		if strings.TrimSpace(item.SubTitle) != "" {
			blockParts = append(blockParts, html.EscapeString(item.SubTitle))
		}
		if len(blockParts) == 0 {
			continue
		}
		parts = append(parts, "<blockquote>"+strings.Join(blockParts, "\n")+"</blockquote>")
	}
	return strings.Join(parts, "\n\n")
}

func sendQuickMediaChunk(ctx context.Context, client *bot.Bot, chatID int64, assets []quickMediaAsset, caption string, reply *models.ReplyParameters) ([]*models.Message, error) {
	var lastErr error
	for attempt := 0; attempt < 3; attempt++ {
		media := quickMediaAssetsToInput(assets)
		applyCaptionToFirstMedia(media, caption)
		params := &bot.SendMediaGroupParams{
			ChatID:          chatID,
			Media:           media,
			ReplyParameters: reply,
		}
		msgs, err := client.SendMediaGroup(ctx, params)
		if err == nil {
			return msgs, nil
		}
		lastErr = err
		var rateErr *bot.TooManyRequestsError
		if !errors.As(err, &rateErr) {
			return nil, err
		}
		waitSeconds := rateErr.RetryAfter + 1
		if waitSeconds <= 0 {
			waitSeconds = 2
		}
		select {
		case <-ctx.Done():
			return nil, ctx.Err()
		case <-time.After(time.Duration(waitSeconds) * time.Second):
		}
	}
	return nil, lastErr
}

func quickMediaAssetsToInput(assets []quickMediaAsset) []models.InputMedia {
	out := make([]models.InputMedia, 0, len(assets))
	for _, asset := range assets {
		switch asset.Type {
		case noteTypeImage:
			out = append(out, &models.InputMediaPhoto{
				Media:           "attach://" + asset.Filename,
				MediaAttachment: bytes.NewReader(asset.Data),
			})
		case noteTypeVideo:
			width, height := videoDimensions(asset.AspectRatio)
			video := &models.InputMediaVideo{
				Media:             "attach://" + asset.Filename,
				MediaAttachment:   bytes.NewReader(asset.Data),
				SupportsStreaming: true,
				Duration:          asset.Duration,
				Width:             width,
				Height:            height,
			}
			if strings.TrimSpace(asset.ThumbnailURL) != "" {
				video.Thumbnail = &models.InputFileString{Data: asset.ThumbnailURL}
			}
			out = append(out, video)
		}
	}
	return out
}

func videoDimensions(aspectRatio float64) (int, int) {
	if aspectRatio <= 0 {
		return 0, 0
	}
	width := 720
	height := int(float64(width) / aspectRatio)
	if height <= 0 {
		return 0, 0
	}
	return width, height
}

func downloadQuickMedia(ctx context.Context, rawURL, itemType string, index int) (filename string, data []byte, err error) {
	rawURL = strings.TrimSpace(rawURL)
	if rawURL == "" {
		return "", nil, fmt.Errorf("媒体地址为空")
	}
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, rawURL, nil)
	if err != nil {
		return "", nil, err
	}
	req.Header.Set("User-Agent", "Mozilla/5.0")
	req.Header.Set("Accept", "image/*,video/*,*/*;q=0.8")
	resp, err := quickMediaHTTPClient.Do(req)
	if err != nil {
		return "", nil, err
	}
	defer resp.Body.Close()
	if resp.StatusCode < http.StatusOK || resp.StatusCode >= http.StatusMultipleChoices {
		return "", nil, fmt.Errorf("下载媒体失败，HTTP状态：%d", resp.StatusCode)
	}
	body, err := io.ReadAll(io.LimitReader(resp.Body, quickMediaMaxBytes+1))
	if err != nil {
		return "", nil, err
	}
	if len(body) == 0 {
		return "", nil, fmt.Errorf("媒体内容为空")
	}
	if len(body) > quickMediaMaxBytes {
		return "", nil, fmt.Errorf("媒体文件超过 %dMB", quickMediaMaxBytes>>20)
	}
	body = decodeBangchatMedia(rawURL, body)
	return quickMediaFilename(rawURL, itemType, index), body, nil
}

func decodeBangchatMedia(rawURL string, body []byte) []byte {
	if len(body) == 0 {
		return body
	}
	if mimeFromBytes(body) != "" {
		return body
	}
	decoded, err := decodeBangchatMediaBytes(rawURL, body)
	if err != nil || len(decoded) == 0 {
		return body
	}
	if mimeFromBytes(decoded) != "" {
		return decoded
	}
	return decoded
}

func decodeBangchatMediaBytes(rawURL string, body []byte) ([]byte, error) {
	parts := strings.Split(rawURL, "/")
	if len(parts) < 4 {
		return nil, fmt.Errorf("invalid media url: %s", rawURL)
	}
	key := hmac.New(sha256.New, []byte(bangchatMediaSecret))
	_, _ = key.Write([]byte(strings.Join(parts[3:], "/")))
	xorKey := key.Sum(nil)
	if len(xorKey) == 0 {
		return nil, fmt.Errorf("media xor key is empty")
	}
	start := int(body[0]) + 1
	if start > len(body) {
		return nil, fmt.Errorf("invalid media offset")
	}
	payload := body[start:]
	out := make([]byte, len(payload))
	for i := range payload {
		out[i] = payload[i] ^ xorKey[i%len(xorKey)]
	}
	return out, nil
}

func quickMediaFilename(rawURL, itemType string, index int) string {
	ext := ".jpg"
	if itemType == noteTypeVideo {
		ext = ".mp4"
	}
	if u, err := url.Parse(rawURL); err == nil {
		base := path.Base(u.Path)
		if base != "." && base != "/" && strings.Contains(base, ".") {
			return fmt.Sprintf("lazy_%d_%s", index, sanitizeQuickMediaFilename(base))
		}
	}
	return fmt.Sprintf("lazy_%d%s", index, ext)
}

func sanitizeQuickMediaFilename(name string) string {
	var b strings.Builder
	b.Grow(len(name))
	for _, r := range name {
		if r >= 'a' && r <= 'z' || r >= 'A' && r <= 'Z' || r >= '0' && r <= '9' || r == '.' || r == '_' || r == '-' {
			b.WriteRune(r)
			continue
		}
		b.WriteByte('_')
	}
	if b.Len() == 0 {
		return "media"
	}
	return b.String()
}

func chunkQuickMediaAssets(items []quickMediaAsset, size int) [][]quickMediaAsset {
	if size <= 0 {
		size = quickMediaGroupLimit
	}
	if len(items) == 0 {
		return nil
	}
	out := make([][]quickMediaAsset, 0, (len(items)+size-1)/size)
	for start := 0; start < len(items); start += size {
		end := start + size
		if end > len(items) {
			end = len(items)
		}
		out = append(out, items[start:end])
	}
	return out
}

func applyCaptionToFirstMedia(chunk []models.InputMedia, caption string) {
	if len(chunk) == 0 || strings.TrimSpace(caption) == "" {
		return
	}
	switch media := chunk[0].(type) {
	case *models.InputMediaPhoto:
		media.Caption = caption
		media.ParseMode = models.ParseModeHTML
	case *models.InputMediaVideo:
		media.Caption = caption
		media.ParseMode = models.ParseModeHTML
	}
}

func limitCaption(text string, max int) string {
	if max <= 0 || len(text) <= max {
		return text
	}
	if max < 3 {
		return text[:max]
	}
	return text[:max-3] + "..."
}

func mimeFromBytes(body []byte) string {
	if len(body) >= 3 && body[0] == 0xff && body[1] == 0xd8 && body[2] == 0xff {
		return "image/jpeg"
	}
	if len(body) >= 8 && bytes.Equal(body[:8], []byte{0x89, 'P', 'N', 'G', 0x0d, 0x0a, 0x1a, 0x0a}) {
		return "image/png"
	}
	if len(body) >= 6 && (bytes.Equal(body[:6], []byte("GIF87a")) || bytes.Equal(body[:6], []byte("GIF89a"))) {
		return "image/gif"
	}
	if len(body) >= 12 && bytes.Equal(body[:4], []byte("RIFF")) && bytes.Equal(body[8:12], []byte("WEBP")) {
		return "image/webp"
	}
	if len(body) >= 12 && bytes.Equal(body[4:8], []byte("ftyp")) {
		return "video/mp4"
	}
	if len(body) >= 12 && bytes.Equal(body[:4], []byte("\x00\x00\x00\x14")) && bytes.Equal(body[4:8], []byte("ftyp")) {
		return "video/mp4"
	}
	if len(body) > 0 && body[0] == '<' {
		return "image/svg+xml"
	}
	return ""
}
