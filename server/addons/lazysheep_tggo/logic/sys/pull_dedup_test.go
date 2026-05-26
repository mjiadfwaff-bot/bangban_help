package sys

import "testing"

func TestNoteFingerprintUsesMediaURLsOnly(t *testing.T) {
	first, _ := noteFingerprint(noteContent{Items: []noteItem{
		{Type: noteTypeImage, Content: "https://img.example/a.jpg", Title: "深圳测试 v1"},
		{Type: noteTypeVideo, Content: "https://img.example/b.mp4"},
		{Type: noteTypeText, Content: "第一段文案"},
	}})
	second, _ := noteFingerprint(noteContent{Items: []noteItem{
		{Type: noteTypeText, Content: "第二段文案"},
		{Type: noteTypeVideo, Content: "https://img.example/b.mp4", Title: "深圳测试 v2"},
		{Type: noteTypeImage, Content: "https://img.example/a.jpg"},
	}})
	if first == "" {
		t.Fatal("fingerprint should not be empty")
	}
	if first != second {
		t.Fatalf("same media urls should produce same fingerprint, got %s and %s", first, second)
	}
}

func TestNoteFingerprintKeepsMediaURLCount(t *testing.T) {
	first, _ := noteFingerprint(noteContent{Items: []noteItem{
		{Type: noteTypeImage, Content: "https://img.example/a.jpg"},
	}})
	second, _ := noteFingerprint(noteContent{Items: []noteItem{
		{Type: noteTypeImage, Content: "https://img.example/a.jpg"},
		{Type: noteTypeVideo, Content: "https://img.example/a.jpg"},
	}})
	if first == second {
		t.Fatal("different media url counts should not produce same fingerprint")
	}
}

func TestNoteFingerprintWithoutMediaIsEmpty(t *testing.T) {
	fingerprint, _ := noteFingerprint(noteContent{Items: []noteItem{
		{Type: noteTypeTitle, Content: "标题"},
		{Type: noteTypeText, Content: "纯文本"},
	}})
	if fingerprint != "" {
		t.Fatalf("expected empty fingerprint for note without media, got %s", fingerprint)
	}
}
