//go:build windows

package browserpolicy

import (
	"fmt"
	"os/exec"
	"strconv"
	"strings"
	"syscall"
)

// 브라우저별 정책 키(HKCU = 현재 사용자, 관리자 권한 불필요). 테스트에서 임시 키로 바꿔 쓴다.
var policyKeys = []string{
	`HKCU\SOFTWARE\Policies\Google\Chrome\LocalNetworkAccessAllowedForUrls`,
	`HKCU\SOFTWARE\Policies\Microsoft\Edge\LocalNetworkAccessAllowedForUrls`,
}

func hiddenCmd(name string, args ...string) *exec.Cmd {
	cmd := exec.Command(name, args...)
	cmd.SysProcAttr = &syscall.SysProcAttr{HideWindow: true}
	return cmd
}

// Sync 는 정책 키에 origins 를 더한다(1..n 값). 이미 있는 값은 지우지 않는다 —
// 같은 PC 의 다른 에이전트(HANES Print Agent 등)나 관리 도구가 등록한 origin 을 덮어쓰지 않기 위해서다.
// 그래서 허용 목록에서 뺀 origin 은 정책에 남는다(직접 지워야 한다).
func Sync(origins []string) error {
	var firstErr error
	for _, key := range policyKeys {
		if err := syncKey(key, origins); err != nil && firstErr == nil {
			firstErr = err
		}
	}
	return firstErr
}

func syncKey(key string, origins []string) error {
	merged := mergeOrigins(existingValues(key), origins)
	if len(merged) == 0 {
		return nil
	}
	// 키가 없을 때 reg delete 는 exit 1 → 무시
	_ = hiddenCmd("reg", "delete", key, "/f").Run()
	for i, origin := range merged {
		if err := hiddenCmd("reg", "add", key, "/v", strconv.Itoa(i+1), "/t", "REG_SZ", "/d", origin, "/f").Run(); err != nil {
			return fmt.Errorf("browser policy %s: %w", key, err)
		}
	}
	return nil
}

// existingValues 는 정책 키의 REG_SZ 값들을 돌려준다 (키가 없으면 빈 목록).
func existingValues(key string) []string {
	out, err := hiddenCmd("reg", "query", key).CombinedOutput()
	if err != nil {
		return nil
	}
	var values []string
	for _, line := range splitLines(string(out)) {
		fields := strings.Fields(line)
		if len(fields) >= 3 && strings.EqualFold(fields[1], "REG_SZ") {
			values = append(values, strings.Join(fields[2:], " "))
		}
	}
	return values
}

// Registered 는 첫 번째 정책 키에 등록된 값 개수를 돌려준다(상태 확인용).
func Registered() (int, error) {
	out, err := hiddenCmd("reg", "query", policyKeys[0]).CombinedOutput()
	if err != nil {
		return 0, nil // 미등록
	}
	count := 0
	for _, line := range splitLines(string(out)) {
		if containsFold(line, "REG_SZ") {
			count++
		}
	}
	return count, nil
}
