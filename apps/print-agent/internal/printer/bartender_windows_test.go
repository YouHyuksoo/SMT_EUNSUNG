//go:build windows

package printer

import (
	"context"
	"encoding/base64"
	"encoding/json"
	"os"
	"path/filepath"
	"testing"
)

// 실제 BarTender 로 PNG 를 내보내는 확인. BarTender 가 설치된 PC 에서만 돈다:
// EUNSUNG_BARTENDER_IT=<template.btw 와 values.json 이 있는 폴더> go test ./internal/printer -run BarTenderExport
func TestBarTenderExportIntegration(t *testing.T) {
	dir := os.Getenv("EUNSUNG_BARTENDER_IT")
	if dir == "" {
		t.Skip("EUNSUNG_BARTENDER_IT 가 없어 건너뜀")
	}
	template, err := os.ReadFile(filepath.Join(dir, "test.btw"))
	if err != nil {
		t.Fatal(err)
	}
	var job struct {
		Values map[string]string `json:"values"`
	}
	raw, err := os.ReadFile(filepath.Join(dir, "job.json"))
	if err != nil {
		t.Fatal(err)
	}
	if err := json.Unmarshal(raw, &job); err != nil {
		t.Fatal(err)
	}
	out := filepath.Join(dir, "agent-export.png")
	_ = os.Remove(out)
	result, err := NewBarTender().PrintBarTender(context.Background(), PrintBarTenderRequest{
		JobID: "IT", Copies: 1, TemplateBase64: base64.StdEncoding.EncodeToString(template), Values: job.Values, ExportPath: out,
	})
	if err != nil {
		t.Fatal(err)
	}
	if info, err := os.Stat(out); err != nil || info.Size() == 0 {
		t.Fatalf("export missing: %v", err)
	}
	t.Logf("result %+v", result)
}
