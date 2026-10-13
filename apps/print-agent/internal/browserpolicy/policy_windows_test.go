//go:build windows

package browserpolicy

import (
	"os/exec"
	"strings"
	"testing"
)

// 실제 reg.exe 로 임시 키(HKCU\SOFTWARE\EUNSUNGTest\...)에 쓰고 지운다 — 브라우저 정책 키는 건드리지 않는다.
func TestSyncMergesWithExistingValues(t *testing.T) {
	saved := policyKeys
	testKey := `HKCU\SOFTWARE\EUNSUNGTest\browserpolicy\LocalNetworkAccessAllowedForUrls`
	policyKeys = []string{testKey}
	t.Cleanup(func() {
		policyKeys = saved
		_ = exec.Command("reg", "delete", `HKCU\SOFTWARE\EUNSUNGTest`, "/f").Run()
	})

	if err := Sync([]string{"https://mes.eunsung.example", "https://mes.example.com:8443"}); err != nil {
		t.Fatalf("Sync: %v", err)
	}
	out, err := exec.Command("reg", "query", testKey).CombinedOutput()
	if err != nil {
		t.Fatalf("reg query: %v\n%s", err, out)
	}
	text := string(out)
	if !strings.Contains(text, "https://mes.eunsung.example") || !strings.Contains(text, "https://mes.example.com:8443") {
		t.Fatalf("values not written:\n%s", text)
	}
	if n, _ := Registered(); n != 2 {
		t.Fatalf("Registered = %d, want 2", n)
	}

	// 다른 도구가 넣은 값은 지우지 않고, 겹치는 값은 다시 넣지 않는다 (HANES Print Agent 와 같은 키를 나눠 쓴다)
	if err := exec.Command("reg", "add", testKey, "/v", "9", "/t", "REG_SZ", "/d", "https://hswbs.haengsung.com", "/f").Run(); err != nil {
		t.Fatalf("seed other value: %v", err)
	}
	if err := Sync([]string{"https://mes.eunsung.example/"}); err != nil {
		t.Fatalf("Sync merge: %v", err)
	}
	out, _ = exec.Command("reg", "query", testKey).CombinedOutput()
	text = string(out)
	if !strings.Contains(text, "https://hswbs.haengsung.com") || !strings.Contains(text, "https://mes.example.com:8443") {
		t.Fatalf("existing values were removed:\n%s", text)
	}
	if n, _ := Registered(); n != 3 {
		t.Fatalf("Registered = %d, want 3 (no duplicate)\n%s", n, text)
	}

	// 비어 있으면 아무것도 바꾸지 않는다
	if err := Sync(nil); err != nil {
		t.Fatalf("Sync empty: %v", err)
	}
	if n, _ := Registered(); n != 3 {
		t.Fatalf("empty sync changed values: %d", n)
	}
}
