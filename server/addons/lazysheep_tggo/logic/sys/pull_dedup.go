package sys

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"strings"
	"time"

	"github.com/gogf/gf/v2/errors/gerror"
	"hotgo/internal/library/cache"
)

const pullDedupTTL = time.Hour * 24 * 180

type noteFingerprintItem struct {
	Type        string `json:"type"`
	Title       string `json:"title"`
	SubTitle    string `json:"subTitle"`
	Content     string `json:"content"`
	Duration    int    `json:"duration"`
	VerifyVideo bool   `json:"verifyVideo"`
	AspectRatio string `json:"aspectRatio"`
}

type pullDedupRecord struct {
	Fingerprint string   `json:"fingerprint"`
	SourceURLs  []string `json:"sourceUrls"`
	NoteID      int64    `json:"noteId"`
	SeenAt      string   `json:"seenAt"`
}

func noteFingerprint(note noteContent) (string, []string) {
	items := make([]noteFingerprintItem, 0, len(note.Items))
	sourceURLs := make([]string, 0, len(note.Items))
	for _, item := range note.Items {
		items = append(items, noteFingerprintItem{
			Type:        strings.TrimSpace(item.Type),
			Title:       strings.TrimSpace(item.Title),
			SubTitle:    strings.TrimSpace(item.SubTitle),
			Content:     strings.TrimSpace(item.Content),
			Duration:    item.Duration,
			VerifyVideo: item.VerifyVideo,
			AspectRatio: fmt.Sprintf("%.4f", item.AspectRatio),
		})
		if isRemoteMedia(item.Type) && strings.TrimSpace(item.Content) != "" {
			sourceURLs = append(sourceURLs, strings.TrimSpace(item.Content))
		}
	}
	if len(items) == 0 {
		return "", sourceURLs
	}
	raw, _ := json.Marshal(items)
	sum := sha256.Sum256(raw)
	return hex.EncodeToString(sum[:]), sourceURLs
}

func pullDedupKey(botKey, fingerprint string) string {
	return fmt.Sprintf("lazysheep_tggo:pull:dedup:%s:%s", strings.TrimSpace(botKey), strings.TrimSpace(fingerprint))
}

func pullDedupSeen(ctx context.Context, botKey, fingerprint string) (bool, error) {
	if strings.TrimSpace(botKey) == "" || strings.TrimSpace(fingerprint) == "" {
		return false, nil
	}
	val, err := cache.Instance().Get(ctx, pullDedupKey(botKey, fingerprint))
	if err != nil {
		return false, gerror.Wrap(err, "查询重复采集记录失败")
	}
	return !val.IsNil() && val.String() != "", nil
}

func pullDedupRemember(ctx context.Context, botKey, fingerprint string, noteID int64, sourceURLs []string) error {
	if strings.TrimSpace(botKey) == "" || strings.TrimSpace(fingerprint) == "" {
		return nil
	}
	payload, err := json.Marshal(pullDedupRecord{
		Fingerprint: fingerprint,
		SourceURLs:  sourceURLs,
		NoteID:      noteID,
		SeenAt:      time.Now().Format(time.RFC3339),
	})
	if err != nil {
		return gerror.Wrap(err, "编码重复采集记录失败")
	}
	if err := cache.Instance().Set(ctx, pullDedupKey(botKey, fingerprint), string(payload), pullDedupTTL); err != nil {
		return gerror.Wrap(err, "保存重复采集记录失败")
	}
	return nil
}

func pullCursorFromMessages(messages []json.RawMessage) (int64, string) {
	var maxContentID int64
	var latestCursor string
	for _, raw := range messages {
		var msg sourceMessage
		if err := json.Unmarshal(raw, &msg); err != nil {
			continue
		}
		contentID := parseInt(msg.ContentId)
		if contentID > maxContentID {
			maxContentID = contentID
			latestCursor = msg.Id
		}
	}
	return maxContentID, latestCursor
}
