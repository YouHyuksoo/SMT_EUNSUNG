//go:build !windows

package main

import (
	"log"

	"eunsung/print-agent/internal/config"
	"eunsung/print-agent/internal/printer"
	"eunsung/print-agent/internal/server"
)

func runAgent(cfg config.Config, _ string, srv *server.Server, _ printer.Backend) error {
	log.Printf("EUNSUNG Print Agent listening on http://%s", cfg.ListenAddress)
	return srv.ListenAndServe()
}
