# OEE 모드 전환 검증 잔여 간극 기록

- 작성일: 2026-09-09
- 작성 계기: OEE 모드 전환 구현 완료 후 남은 브라우저 검증 간극 기록

## 요약 (결론 먼저)

- 구현은 완료되었고 프론트엔드 테스트 81건과 typecheck를 통과했다.
- 브라우저에서 full → normal → full 전환 시 동일 alias route를 유지하고 `SMT`, `resource01` A라인, `ADMIN`, 미전송 메모가 보존되는 것을 확인했다. start/end write는 발생하지 않았다.
- Windows DPI 및 native window sizing 불일치로 정확한 `1024x600` CSS viewport는 검증하지 못했다.

## 상세

- 이 작업에는 Oracle DDL 변경이나 routing contract 변경이 없다.
- 기존의 무관한 dirty docs/DDL은 건드리지 않았으며, 본 작업의 변경으로 귀속하지 않는다.

## 후속 조치

1. 향후 브라우저에서 실제 CSS viewport가 정확히 `1024x600`인지 측정한다.
2. 해당 viewport에서 모드 전환 화면이 잘리지 않고 맞는지(fit) 검증한다.
