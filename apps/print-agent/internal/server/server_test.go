package server

import (
	"context"
	"encoding/base64"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"

	"eunsung/print-agent/internal/printer"
)

func TestRoutesExposeLocalPrintAgentContract(t *testing.T) {
	srv := New(nil, nil)
	if srv == nil {
		t.Fatal("expected server")
	}
}

type fakeBarTender struct{ got printer.PrintBarTenderRequest }

func (f *fakeBarTender) PrintBarTender(_ context.Context, req printer.PrintBarTenderRequest) (printer.PrintResult, error) {
	f.got = req
	return printer.PrintResult{JobID: req.JobID, PrinterName: "ZDesigner", Copies: req.Copies, Status: "printed"}, nil
}

func TestPrintBarTenderPassesTemplateAndValues(t *testing.T) {
	srv := New(nil, nil)
	fake := &fakeBarTender{}
	srv.SetBarTender(fake)
	body := `{"jobId":"BOX-1","copies":2,"templateBase64":"` + base64.StdEncoding.EncodeToString([]byte("btw")) + `","values":{"V1":"M1590","V7":"박스/바코드"}}`
	req := httptest.NewRequest(http.MethodPost, "http://127.0.0.1:37111/print/bartender", strings.NewReader(body))
	req.Host = "127.0.0.1:37111"
	rec := httptest.NewRecorder()
	srv.ServeHTTP(rec, req)
	if rec.Code != http.StatusOK {
		t.Fatalf("status %d: %s", rec.Code, rec.Body.String())
	}
	if fake.got.Copies != 2 || fake.got.Values["V7"] != "박스/바코드" || fake.got.PrinterName != "" {
		t.Fatalf("unexpected request %+v", fake.got)
	}
}

func TestPrintBarTenderRejectsBadValueName(t *testing.T) {
	srv := New(nil, nil)
	srv.SetBarTender(&fakeBarTender{})
	body := `{"jobId":"BOX-1","templateBase64":"YnR3","values":{"V1; rm":"x"}}`
	req := httptest.NewRequest(http.MethodPost, "http://127.0.0.1:37111/print/bartender", strings.NewReader(body))
	req.Host = "127.0.0.1:37111"
	rec := httptest.NewRecorder()
	srv.ServeHTTP(rec, req)
	if rec.Code != http.StatusBadRequest {
		t.Fatalf("expected 400, got %d", rec.Code)
	}
}
