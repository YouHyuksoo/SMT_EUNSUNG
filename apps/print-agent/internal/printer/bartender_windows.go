//go:build windows

package printer

import (
	"bytes"
	"context"
	_ "embed"
	"encoding/base64"
	"encoding/json"
	"errors"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"sync"
	"syscall"
	"time"
)

//go:embed bartender.ps1
var bartenderScript []byte

// BarTender 는 한 번에 한 작업만 돌린다 (ActiveX 인스턴스를 동시에 여러 개 띄우지 않도록)
var bartenderMu sync.Mutex

const bartenderTimeout = 2 * time.Minute

type bartenderRunner struct{}

// NewBarTender 는 PowerShell 로 BarTender ActiveX 를 부르는 실행기를 돌려준다.
func NewBarTender() BarTenderRunner { return bartenderRunner{} }

func (bartenderRunner) PrintBarTender(ctx context.Context, req PrintBarTenderRequest) (PrintResult, error) {
	bartenderMu.Lock()
	defer bartenderMu.Unlock()

	dir, err := os.MkdirTemp("", "eunsung-bartender-")
	if err != nil {
		return PrintResult{}, err
	}
	defer os.RemoveAll(dir)

	template, err := base64.StdEncoding.DecodeString(req.TemplateBase64)
	if err != nil {
		return PrintResult{}, err
	}
	templatePath := filepath.Join(dir, "label.btw")
	if err := os.WriteFile(templatePath, template, 0o600); err != nil {
		return PrintResult{}, err
	}
	// Windows PowerShell 5.1 은 BOM 없는 UTF-8 스크립트를 ANSI 로 읽어 한글 주석이 코드 줄을 삼킨다 — BOM 을 붙인다
	script := bartenderScript
	if !bytes.HasPrefix(script, []byte{0xEF, 0xBB, 0xBF}) {
		script = append([]byte{0xEF, 0xBB, 0xBF}, script...)
	}
	scriptPath := filepath.Join(dir, "bartender.ps1")
	if err := os.WriteFile(scriptPath, script, 0o600); err != nil {
		return PrintResult{}, err
	}
	job, err := json.Marshal(map[string]any{
		"template":   templatePath,
		"values":     req.Values,
		"copies":     req.Copies,
		"printer":    req.PrinterName,
		"exportPath": req.ExportPath,
	})
	if err != nil {
		return PrintResult{}, err
	}
	jobPath := filepath.Join(dir, "job.json")
	if err := os.WriteFile(jobPath, job, 0o600); err != nil {
		return PrintResult{}, err
	}

	printerName, err := runBarTenderScript(ctx, powershellPath(false), scriptPath, jobPath)
	// 64비트 PowerShell 에 BarTender ActiveX 가 등록돼 있지 않으면 32비트로 다시 부른다
	if err != nil && isClassNotRegistered(err) {
		printerName, err = runBarTenderScript(ctx, powershellPath(true), scriptPath, jobPath)
	}
	if err != nil {
		return PrintResult{}, err
	}
	status := "printed"
	if req.ExportPath != "" {
		status = "exported"
	}
	return PrintResult{JobID: req.JobID, PrinterName: printerName, Copies: req.Copies, Status: status, OutputPath: req.ExportPath}, nil
}

func runBarTenderScript(ctx context.Context, exe, scriptPath, jobPath string) (string, error) {
	ctx, cancel := context.WithTimeout(ctx, bartenderTimeout)
	defer cancel()
	cmd := exec.CommandContext(ctx, exe, "-NoProfile", "-NonInteractive", "-ExecutionPolicy", "Bypass", "-File", scriptPath, jobPath)
	cmd.SysProcAttr = &syscall.SysProcAttr{HideWindow: true, CreationFlags: 0x08000000} // CREATE_NO_WINDOW
	var stdout, stderr bytes.Buffer
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr
	err := cmd.Run()
	if errors.Is(ctx.Err(), context.DeadlineExceeded) {
		return "", fmt.Errorf("BarTender 가 %s 안에 끝나지 않았습니다", bartenderTimeout)
	}
	if err != nil {
		message := strings.TrimSpace(stderr.String())
		if message == "" {
			message = strings.TrimSpace(stdout.String())
		}
		if message == "" {
			message = err.Error()
		}
		return "", errors.New(message)
	}
	for _, line := range strings.Split(stdout.String(), "\n") {
		line = strings.TrimSpace(line)
		if strings.HasPrefix(line, "OK|") {
			return strings.TrimPrefix(line, "OK|"), nil
		}
	}
	return "", fmt.Errorf("BarTender 실행 결과를 알 수 없습니다: %s", strings.TrimSpace(stdout.String()))
}

func powershellPath(wow64 bool) string {
	root := os.Getenv("SystemRoot")
	if root == "" {
		root = `C:\Windows`
	}
	if wow64 {
		return filepath.Join(root, "SysWOW64", "WindowsPowerShell", "v1.0", "powershell.exe")
	}
	return filepath.Join(root, "System32", "WindowsPowerShell", "v1.0", "powershell.exe")
}

func isClassNotRegistered(err error) bool {
	text := strings.ToLower(err.Error())
	return strings.Contains(text, "80040154") || strings.Contains(text, "class not registered") || strings.Contains(text, "클래스가 등록되지")
}
