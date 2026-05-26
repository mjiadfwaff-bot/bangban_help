package sys

import (
	"context"
	"fmt"
	"strings"
	"time"

	"github.com/go-telegram/bot"
	"github.com/go-telegram/bot/models"
	"github.com/gogf/gf/v2/errors/gerror"
	"hotgo/internal/dao"
)

func (s *sLazySheepTGGo) telegramClientByToken(ctx context.Context, token string) (*bot.Bot, error) {
	token = strings.TrimSpace(token)
	if token == "" {
		return nil, gerror.New("Telegram Bot Token 不能为空")
	}
	httpClient, err := s.telegramHTTPClient(ctx)
	if err != nil {
		return nil, err
	}
	return bot.New(token, bot.WithHTTPClient(telegramHTTPTimeout-time.Second, httpClient))
}

func (s *sLazySheepTGGo) sendTelegramText(ctx context.Context, token string, chatID int64, text string) error {
	if chatID == 0 {
		return gerror.New("通知目标不能为空")
	}
	client, err := s.telegramClientByToken(ctx, token)
	if err != nil {
		return err
	}
	_, err = client.SendMessage(ctx, &bot.SendMessageParams{
		ChatID:    chatID,
		Text:      strings.TrimSpace(text),
		ParseMode: models.ParseModeHTML,
	})
	return err
}

func (s *sLazySheepTGGo) sendTelegramTextRemoveKeyboard(ctx context.Context, token string, chatID int64, text string) error {
	if chatID == 0 {
		return gerror.New("通知目标不能为空")
	}
	client, err := s.telegramClientByToken(ctx, token)
	if err != nil {
		return err
	}
	_, err = client.SendMessage(ctx, &bot.SendMessageParams{
		ChatID:    chatID,
		Text:      strings.TrimSpace(text),
		ParseMode: models.ParseModeHTML,
		ReplyMarkup: &models.ReplyKeyboardRemove{
			RemoveKeyboard: true,
		},
	})
	return err
}

func (s *sLazySheepTGGo) NotifyUser(ctx context.Context, botKey string, chatID int64, text string) error {
	if chatID == 0 {
		return nil
	}
	state, err := s.GetState(ctx)
	if err != nil {
		return err
	}
	cfg := state.Bots[botKey]
	if cfg == nil {
		return fmt.Errorf("bot not found: %s", botKey)
	}
	return s.sendTelegramText(ctx, cfg.Token, chatID, text)
}

func (s *sLazySheepTGGo) NotifyUsers(ctx context.Context, botKey string, chatIDs []int64, text string) (sent int, failed int, err error) {
	for _, chatID := range chatIDs {
		if chatID == 0 {
			continue
		}
		if sendErr := s.NotifyUser(ctx, botKey, chatID, text); sendErr != nil {
			failed++
			continue
		}
		sent++
	}
	return sent, failed, nil
}

func (s *sLazySheepTGGo) NotifyAllUsers(ctx context.Context, botKey string, text string) (sent int, failed int, err error) {
	cols := dao.AddonLazysheepTggoUser.Columns()
	var users []struct {
		TelegramID int64 `json:"telegramId"`
	}
	if err = dao.AddonLazysheepTggoUser.Ctx(ctx).
		Fields(cols.TelegramId).
		Where("bot_key", botKey).
		Where(cols.Status, 1).
		Scan(&users); err != nil {
		return 0, 0, err
	}
	chatIDs := make([]int64, 0, len(users))
	for _, user := range users {
		chatIDs = append(chatIDs, user.TelegramID)
	}
	return s.NotifyUsers(ctx, botKey, chatIDs, text)
}

func formatBotDeleteNotice(name, username string) string {
	lines := []string{"你的机器人已删除。"}
	if strings.TrimSpace(name) != "" {
		lines = append(lines, "名称："+strings.TrimSpace(name))
	}
	if strings.TrimSpace(username) != "" {
		lines = append(lines, "用户名：@"+strings.TrimPrefix(strings.TrimSpace(username), "@"))
	}
	return strings.Join(lines, "\n")
}
