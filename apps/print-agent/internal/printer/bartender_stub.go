//go:build !windows

package printer

import (
	"context"
	"errors"
)

type bartenderRunner struct{}

func NewBarTender() BarTenderRunner { return bartenderRunner{} }

func (bartenderRunner) PrintBarTender(context.Context, PrintBarTenderRequest) (PrintResult, error) {
	return PrintResult{}, errors.New("BarTender printing is only implemented on Windows")
}
