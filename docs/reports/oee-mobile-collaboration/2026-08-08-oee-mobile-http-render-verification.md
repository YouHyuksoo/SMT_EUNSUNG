# OEE MOBILE 인증 HTTP·렌더 후속 검증

- 작성일: 2026-08-08
- 대상 branch/worktree: 현재 작업 트리
- 개발 DB: `EUNSUNG_DEV_ESDBPDB`, schema `INFINITY21_JSMES`
- 상태: 인증 HTTP·데스크톱 렌더 완료, 1280x800 고정 viewport 캡처 미완료

## 실행 환경

- 루트 `pnpm dev`를 Orca 지속 터미널에서 실행했다.
- backend는 `http://localhost:3003`, frontend는 `http://localhost:3100`에서 수신했다.
- backend bootstrap은 `JSIDC2_ESDB`를 `139.150.82.207:1521/ESDBPDB`로 해석했다.
- Oracle pool 생성과 Nest application startup을 확인했다.
- Windows에서 `pnpm.cmd`를 직접 spawn할 때 발생한 `spawn EINVAL`은 Windows에서만 command shell을 사용하도록 교정했다.

## 인증 HTTP 검증

- `POST /api/v1/auth/login`: 201
- `GET /api/v1/auth/me`: 200
- `GET /api/v1/health`: 200
- `GET /api/v1/db-info`: 200
- `GET /api/v1/oee/mobile/workers/ADMIN`: 200
- `GET /api/v1/oee/mobile/resources?processCode=SMT`: 200, LINE 12건
- `GET /api/v1/oee/mobile/resources?processCode=ASSY`: 200, CELL 15건
- `GET /api/v1/oee/mobile/reasons`: 200, 17건
- SMT LINE `01` 상태: 업무일 `2026-08-08`, 근무구간 `A`, `RUNNING`, 열린 이벤트 없음
- ASSY CELL `50`/`PROD2` 상태: 업무일 `2026-08-08`, 근무구간 `A`, `RUNNING`, 열린 이벤트 없음

## 브라우저 렌더 검증

- Chrome 인증 세션에서 `/oee/entry`가 로그인 화면으로 되돌아가지 않고 렌더됐다.
- DB 연결 표시는 `ESDBPDB @ 139.150.82.207`, 로그인 사용자는 `ADMIN`이었다.
- 작업자 `ADMIN` 확인 후 성공 상태와 작업자 표시를 확인했다.
- 화면은 SMT/ASSY 공정 선택, 리소스 영역, 현재 상태, 현재 업무일 이력 영역을 렌더했다.
- canonical 화면 메뉴 라벨을 `OEE 비가동 입력`으로 교정했다.
- 참고 Mock 화면은 실제 입력 화면과 혼동되지 않도록 `설비비가동 스캔 (Mock)`으로 표시했다.
- 새로고침 후 두 라벨이 실제 사이드바와 열린 탭에 반영된 것을 확인했다.

## 코드 검증

- backend profile bootstrap focused Jest: 1 suite, 1 test passed
- frontend typecheck: passed
- frontend structure tests: 32 tests passed
- page/menu registration: 38 pages, 36 menu leaves passed
- shared watch compilation: 0 errors
- `git diff --check`: passed (기존 line-ending 경고만 출력)

## 남은 수동 검증

- Computer Use provider가 창 크기 변경을 지원하지 않고 내장 브라우저 CLI가 이 버전에서 viewport 명령을 제공하지 않아 1280x800 고정 viewport 캡처는 수행하지 못했다.
- responsive touch target 구조 테스트는 통과했지만 실제 10인치 Android MOBILE에서 회전, 가상 키보드, 터치 조작은 실기기에서 최종 확인해야 한다.
- 이번 후속 검증에서는 운영성 데이터를 만들지 않기 위해 비가동 시작·종료 POST를 호출하지 않았다. 시작·재시도·종료·재시도 무결성은 선행 Oracle DML 검증과 자동 테스트 결과를 유지한다.
