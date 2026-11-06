package browserpolicy

import "strings"

func splitLines(s string) []string {
	return strings.Split(strings.ReplaceAll(s, "\r\n", "\n"), "\n")
}

// mergeOrigins 는 기존 값 뒤에 새 origin 을 붙인다 (대소문자·끝 슬래시 무시하고 중복 제거).
func mergeOrigins(existing, add []string) []string {
	seen := map[string]bool{}
	out := make([]string, 0, len(existing)+len(add))
	for _, list := range [][]string{existing, add} {
		for _, origin := range list {
			origin = strings.TrimRight(strings.TrimSpace(origin), "/")
			key := strings.ToLower(origin)
			if origin == "" || seen[key] {
				continue
			}
			seen[key] = true
			out = append(out, origin)
		}
	}
	return out
}

func containsFold(s, sub string) bool {
	return strings.Contains(strings.ToUpper(s), strings.ToUpper(sub))
}
