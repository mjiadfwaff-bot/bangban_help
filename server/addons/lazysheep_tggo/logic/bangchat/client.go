// Package bangchat implements the authorized BangChat browser API client.
package bangchat

import (
	"bytes"
	"context"
	"crypto/aes"
	"crypto/cipher"
	"crypto/ecdh"
	"crypto/ecdsa"
	"crypto/rand"
	"crypto/sha256"
	"encoding/base64"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"math"
	"net/http"
	"net/url"
	"strconv"
	"strings"
	"time"

	"github.com/ethereum/go-ethereum/crypto"
)

const apiBaseURL = "https://seats.bangchats.top/api"

var httpClient = &http.Client{
	Transport: &http.Transport{Proxy: nil},
	Timeout:   30 * time.Second,
}

var streamHTTPClient = &http.Client{
	Transport: &http.Transport{Proxy: nil},
}

type Client struct {
	secret string
	iv     string
	pubKey string
	priv   *ecdsa.PrivateKey
	jwt    string
}

type PullOption struct {
	URL      string
	Limit    int
	MaxPages int
}

type PullResult struct {
	PairID   string
	Messages []json.RawMessage
}

type Session struct {
	Client *Client
	PairID string
}

func Pull(ctx context.Context, opt PullOption) (*PullResult, error) {
	if opt.Limit <= 0 {
		opt.Limit = 50
	}
	session, err := OpenSession(ctx, opt.URL)
	if err != nil {
		return nil, err
	}
	messages, err := session.Client.CollectMessages(ctx, session.PairID, opt.Limit, opt.MaxPages)
	if err != nil {
		return nil, err
	}
	return &PullResult{PairID: session.PairID, Messages: messages}, nil
}

func OpenSession(ctx context.Context, sourceURL string) (*Session, error) {
	token, err := ResolveToken(ctx, sourceURL)
	if err != nil {
		return nil, err
	}
	client, err := NewClient(ctx)
	if err != nil {
		return nil, err
	}
	pairID, err := client.RegisterByToken(ctx, token)
	if err != nil {
		return nil, err
	}
	return &Session{Client: client, PairID: pairID}, nil
}

func ResolveToken(ctx context.Context, input string) (string, error) {
	input = strings.TrimSpace(input)
	if u, err := url.Parse(input); err == nil {
		if token := u.Query().Get("token"); token != "" {
			return token, nil
		}
		if u.Scheme == "http" || u.Scheme == "https" {
			req, _ := http.NewRequestWithContext(ctx, http.MethodGet, input, nil)
			resp, err := httpClient.Do(req)
			if err != nil {
				return "", err
			}
			defer resp.Body.Close()
			if token := resp.Request.URL.Query().Get("token"); token != "" {
				return token, nil
			}
		}
	}
	if strings.HasPrefix(input, "http") {
		return "", fmt.Errorf("token not found in %s", input)
	}
	if input == "" {
		return "", errors.New("source url is empty")
	}
	return input, nil
}

func NewClient(ctx context.Context) (*Client, error) {
	pub, err := getPublicKey(ctx)
	if err != nil {
		return nil, err
	}
	serverPubBytes, err := base64.StdEncoding.DecodeString(pub)
	if err != nil {
		return nil, err
	}
	curve := ecdh.P256()
	serverPub, err := curve.NewPublicKey(serverPubBytes)
	if err != nil {
		return nil, err
	}
	priv, err := curve.GenerateKey(rand.Reader)
	if err != nil {
		return nil, err
	}
	shared, err := priv.ECDH(serverPub)
	if err != nil {
		return nil, err
	}
	secret, iv := deriveSecretIV(shared)
	wallet, err := crypto.GenerateKey()
	if err != nil {
		return nil, err
	}
	return &Client{
		secret: secret,
		iv:     iv,
		pubKey: base64.StdEncoding.EncodeToString(priv.PublicKey().Bytes()),
		priv:   wallet,
	}, nil
}

func (c *Client) RegisterByToken(ctx context.Context, token string) (pairID string, err error) {
	seat, err := c.signedPost(ctx, "/v1.Passport/GetSeatInfoByToken", map[string]string{"token": token})
	if err != nil {
		return "", err
	}
	var seatResp struct {
		RoomID  string `json:"roomId"`
		RoomID2 string `json:"room_id"`
		UserID  string `json:"userId"`
		UserID2 string `json:"user_id"`
		Expire  string `json:"expire"`
	}
	_ = json.Unmarshal([]byte(seat), &seatResp)

	reg, err := c.signedPost(ctx, "/v1.Passport/CasualRoomChatRegister", map[string]any{
		"token":    token,
		"uid":      firstNonEmpty(seatResp.UserID, seatResp.UserID2),
		"id":       firstNonEmpty(seatResp.RoomID, seatResp.RoomID2),
		"expire":   seatResp.Expire,
		"password": "",
	})
	if err != nil {
		return "", err
	}
	var regResp struct {
		Token struct {
			AccessToken string `json:"accessToken"`
		} `json:"token"`
		Room struct {
			RoomID string `json:"roomId"`
			ID     string `json:"id"`
		} `json:"room"`
	}
	_ = json.Unmarshal([]byte(reg), &regResp)
	c.jwt = regResp.Token.AccessToken
	roomID := firstNonZero(parseInt64(regResp.Room.RoomID), parseInt64(regResp.Room.ID), parseInt64(seatResp.RoomID), parseInt64(seatResp.RoomID2))
	return roomPair(roomID), nil
}

func (c *Client) CollectMessages(ctx context.Context, pairID string, limit int, maxPages int) ([]json.RawMessage, error) {
	all := make([]json.RawMessage, 0, limit)
	seen := make(map[string]struct{})
	maxID := int64(0)
	for page := 1; ; page++ {
		if maxPages > 0 && page > maxPages {
			break
		}
		pageResp, err := c.signedPost(ctx, "/v1.Message/List", map[string]any{
			"pair_id":       pairID,
			"max_id":        maxID,
			"include_quote": true,
			"pager":         map[string]any{"limit": limit},
		})
		if err != nil {
			return nil, err
		}
		var parsed struct {
			Code    int               `json:"code"`
			Message string            `json:"message"`
			List    []json.RawMessage `json:"list"`
			Data    struct {
				List []json.RawMessage `json:"list"`
			} `json:"data"`
		}
		if err := json.Unmarshal([]byte(pageResp), &parsed); err != nil {
			return nil, fmt.Errorf("parse message page failed: %w: %s", err, pageResp)
		}
		list := parsed.List
		if len(list) == 0 && len(parsed.Data.List) > 0 {
			list = parsed.Data.List
		}
		if parsed.Code != 0 && len(list) == 0 {
			return nil, fmt.Errorf("message list failed: %s", parsed.Message)
		}
		if len(list) == 0 {
			break
		}
		for _, raw := range list {
			id := rawMessageID(raw)
			if id == "" {
				continue
			}
			if _, ok := seen[id]; ok {
				continue
			}
			seen[id] = struct{}{}
			all = append(all, raw)
		}
		oldestID := rawMessageID(list[len(list)-1])
		nextID := parseInt64(oldestID)
		if nextID == 0 || nextID == maxID || len(list) < limit {
			break
		}
		maxID = nextID
	}
	return all, nil
}

func getPublicKey(ctx context.Context) (string, error) {
	req, _ := http.NewRequestWithContext(ctx, http.MethodPost, apiBaseURL+"/v1.Setting/GetPublicKey", strings.NewReader("{}"))
	req.Header.Set("Content-Type", "application/json")
	resp, err := httpClient.Do(req)
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()
	body, _ := io.ReadAll(resp.Body)
	var parsed struct {
		PublicKey string `json:"publicKey"`
		Publickey string `json:"public_key"`
		Data      struct {
			PublicKey string `json:"public_key"`
		} `json:"data"`
	}
	if err := json.Unmarshal(body, &parsed); err != nil {
		return "", fmt.Errorf("public key parse failed: %w: %s", err, string(body))
	}
	pub := firstNonEmpty(parsed.PublicKey, parsed.Publickey, parsed.Data.PublicKey)
	if pub == "" {
		return "", fmt.Errorf("public key is empty: %s", string(body))
	}
	return pub, nil
}

func (c *Client) signedPost(ctx context.Context, apiPath string, payload any) (string, error) {
	req, random, err := c.newSignedRequest(ctx, apiPath, payload)
	if err != nil {
		return "", err
	}
	req.Header.Set("Content-Type", "text/plain")
	resp, err := httpClient.Do(req)
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()
	raw, _ := io.ReadAll(resp.Body)
	if dec, derr := xorBase64Decode(string(raw), []byte(random)); derr == nil {
		return string(dec), nil
	}
	return string(raw), nil
}

func (c *Client) newSignedRequest(ctx context.Context, apiPath string, payload any) (*http.Request, string, error) {
	plain, err := json.Marshal(payload)
	if err != nil {
		return nil, "", err
	}
	random := randomString(32)
	encBody := xorBase64(plain, []byte(random))
	key, sign, ts, err := c.signRequest(encBody, random)
	if err != nil {
		return nil, "", err
	}
	req, err := http.NewRequestWithContext(ctx, http.MethodPost, apiBaseURL+apiPath, strings.NewReader(encBody))
	if err != nil {
		return nil, "", err
	}
	req.Header.Set("token", c.jwt)
	req.Header.Set("sign", sign)
	req.Header.Set("key", key)
	req.Header.Set("c-request-time", fmt.Sprintf("%d", ts))
	req.Header.Set("X-Client-Key", c.pubKey)
	req.Header.Set("dno", randomUUID())
	req.Header.Set("isWeb", "true")
	return req, random, nil
}

func (c *Client) signRequest(encBody string, random string) (string, string, int64, error) {
	if c == nil || c.priv == nil {
		return "", "", 0, errors.New("missing wallet")
	}
	key, err := c.encryptRandom(random)
	if err != nil {
		return "", "", 0, err
	}
	ts := time.Now().Unix()
	hash := crypto.Keccak256([]byte(encBody), []byte(key), []byte(fmt.Sprintf("%d", ts)))
	sig, err := crypto.Sign(hash, c.priv)
	if err != nil {
		return "", "", 0, err
	}
	if sig[64] == 27 || sig[64] == 28 {
		sig[64] -= 27
	}
	return key, strings.ToLower(crypto.PubkeyToAddress(c.priv.PublicKey).Hex()) + fmt.Sprintf("%x", sig), ts, nil
}

func (c *Client) encryptRandom(plain string) (string, error) {
	secret, err := mustBase64(c.secret)
	if err != nil {
		return "", err
	}
	iv, err := mustBase64(c.iv)
	if err != nil {
		return "", err
	}
	ciphertext, err := aesCBCEncrypt([]byte(plain), secret, iv)
	if err != nil {
		return "", err
	}
	return base64.StdEncoding.EncodeToString(ciphertext), nil
}

func aesCBCEncrypt(plain, key, iv []byte) ([]byte, error) {
	block, err := aes.NewCipher(key)
	if err != nil {
		return nil, err
	}
	pad := aes.BlockSize - len(plain)%aes.BlockSize
	padded := append(append([]byte{}, plain...), bytes.Repeat([]byte{byte(pad)}, pad)...)
	out := make([]byte, len(padded))
	cipher.NewCBCEncrypter(block, iv).CryptBlocks(out, padded)
	return out, nil
}

func deriveSecretIV(shared []byte) (string, string) {
	sum := sha256.Sum256(shared)
	prefix := append([]byte("BangOS-IV"), shared...)
	ivSum := sha256.Sum256(prefix)
	return base64.StdEncoding.EncodeToString(sum[:]), base64.StdEncoding.EncodeToString(ivSum[:16])
}

func mustBase64(raw string) ([]byte, error) {
	return base64.StdEncoding.DecodeString(raw)
}

func xorBase64(plain []byte, key []byte) string {
	out := make([]byte, len(plain))
	for i := range plain {
		out[i] = plain[i] ^ key[i%len(key)]
	}
	return base64.StdEncoding.EncodeToString(out)
}

func xorBase64Decode(enc string, key []byte) ([]byte, error) {
	raw, err := base64.StdEncoding.DecodeString(enc)
	if err != nil {
		return nil, err
	}
	out := make([]byte, len(raw))
	for i := range raw {
		out[i] = raw[i] ^ key[i%len(key)]
	}
	return out, nil
}

func randomString(n int) string {
	if n <= 10 {
		n = 32
	}
	const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz013456789"
	r := make([]byte, n-10)
	_, _ = rand.Read(r)
	sb := strings.Builder{}
	sb.Grow(n)
	for i := range r {
		sb.WriteByte(chars[int(r[i])%len(chars)])
	}
	sb.WriteString(fmt.Sprintf("%010d", time.Now().Unix()))
	return sb.String()
}

func randomUUID() string {
	b := make([]byte, 16)
	_, _ = rand.Read(b)
	b[6] = (b[6] & 0x0f) | 0x40
	b[8] = (b[8] & 0x3f) | 0x80
	return fmt.Sprintf("%x-%x-%x-%x-%x", b[0:4], b[4:6], b[6:8], b[8:10], b[10:16])
}

func firstNonEmpty(vals ...string) string {
	for _, v := range vals {
		if strings.TrimSpace(v) != "" {
			return v
		}
	}
	return ""
}

func firstNonZero(vals ...int64) int64 {
	for _, v := range vals {
		if v != 0 {
			return v
		}
	}
	return 0
}

func parseInt64(s string) int64 {
	v, _ := strconv.ParseInt(strings.TrimSpace(s), 10, 64)
	return v
}

func roomPair(roomID int64) string {
	if roomID == 0 || roomID > math.MaxInt {
		return ""
	}
	return encodeBase32(0) + encodeBase32(int(roomID))
}

func encodeBase32(v int) string {
	const alphabet = "0123456789abcdefghijklmnopqrstuv"
	if v < 0 {
		return ""
	}
	if v == 0 {
		return "00000000"
	}
	out := ""
	for v > 0 {
		out = string(alphabet[v%32]) + out
		v /= 32
	}
	for len(out) < 8 {
		out = "0" + out
	}
	return out
}

func rawMessageID(raw json.RawMessage) string {
	var v struct {
		ID   string `json:"id"`
		UpID string `json:"upId"`
	}
	if err := json.Unmarshal(raw, &v); err != nil {
		return ""
	}
	return firstNonEmpty(v.ID, v.UpID)
}
