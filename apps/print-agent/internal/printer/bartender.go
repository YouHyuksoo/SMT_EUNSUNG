package printer

import (
	"context"
	"encoding/base64"
	"errors"
	"fmt"
	"regexp"
	"strings"
)

// PrintBarTenderRequest 는 BarTender 양식(.btw)에 값 칸(V1~V20 등)을 넣어 출력하는 요청이다.
// 은성 MES 박스라벨은 PB 와 같이 ISYS_LABEL_FORM 의 양식 파일과 F_GEN_LABEL_DATA_4_BARTENDER 값을 쓴다.
type PrintBarTenderRequest struct {
	JobID string `json:"jobId"`
	// PrinterName 이 비어 있으면 양식에 저장된 프린터로 찍는다 (PB 와 같음). 에이전트 기본 프린터는 쓰지 않는다.
	PrinterName    string            `json:"printerName"`
	Copies         int               `json:"copies"`
	FileName       string            `json:"fileName"`
	TemplateBase64 string            `json:"templateBase64"`
	Values         map[string]string `json:"values"`
	// ExportPath 가 있으면 출력하지 않고 PNG 로 내보낸다 (확인용)
	ExportPath string `json:"exportPath,omitempty"`
}

// BarTenderRunner 는 BarTender 를 실제로 부르는 쪽이다 (Windows: PowerShell + BarTender ActiveX).
type BarTenderRunner interface {
	PrintBarTender(context.Context, PrintBarTenderRequest) (PrintResult, error)
}

var valueNamePattern = regexp.MustCompile(`^[A-Za-z][A-Za-z0-9_]{0,49}$`)

func (r *PrintBarTenderRequest) Normalize() {
	r.JobID = strings.TrimSpace(r.JobID)
	r.PrinterName = strings.TrimSpace(r.PrinterName)
	r.FileName = strings.TrimSpace(r.FileName)
	r.ExportPath = strings.TrimSpace(r.ExportPath)
	if r.Copies <= 0 {
		r.Copies = 1
	}
	if r.Values == nil {
		r.Values = map[string]string{}
	}
}

func (r PrintBarTenderRequest) Validate() error {
	if r.JobID == "" {
		return errors.New("jobId is required")
	}
	if strings.TrimSpace(r.TemplateBase64) == "" {
		return errors.New("templateBase64 is required")
	}
	data, err := base64.StdEncoding.DecodeString(r.TemplateBase64)
	if err != nil {
		return fmt.Errorf("templateBase64 is not valid base64: %w", err)
	}
	if len(data) == 0 {
		return errors.New("template is empty")
	}
	if r.Copies > 50 {
		return errors.New("copies must be 50 or less")
	}
	for name, value := range r.Values {
		if !valueNamePattern.MatchString(name) {
			return fmt.Errorf("invalid value name %q", name)
		}
		if len(value) > 4000 {
			return fmt.Errorf("value %s is too long", name)
		}
	}
	return nil
}
