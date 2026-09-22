# 설비 작업·검사결과 조회 — 미완료 런타임 검증

## 구현 범위

- 설비관리 메뉴에 SP, SPI, ICT, AOI, ROUTER, ROM WRITE, 솔더점도, REFLOW, 성능(EOL) 결과조회 9개 화면 등록
- PB DataWindow 원천 테이블과 조회조건을 NestJS 조회 API 및 공통 Next.js DataGrid 화면으로 이식
- JWT Guard, 조직 ID 범위, 기간/라인/식별정보 필터, 메뉴 권한, 4개 언어 메뉴명, 사용자·운영자 도움말 등록

## 완료된 검증

- 백엔드 결과조회 서비스 및 Guard 테스트: 4건 통과
- 프론트 전체 구조 테스트: 121건 통과
- 프론트/백엔드 typecheck 통과
- `JSIDCESDB`에서 9개 원천 테이블 존재 확인
- `IQ_MACHINE_INSPECT_DATA_REFLOW` 조직 1의 6,404,781건 확인 및 실제 최신 행 3건 조회

## 미완료 항목

1. 백엔드 4003이 실행되지 않아 인증된 `/equipment/result-queries/:type` HTTP 응답을 확인하지 못함.
2. 프론트 4010은 실행 중이나 Chrome 확장 통신이 `Unable to load browser request-header policy`로 두 차례 실패하여 메뉴 클릭, 탭 전환, 렌더링, 네트워크/콘솔을 확인하지 못함.
3. REFLOW 외 8개 테이블은 현재 `NUM_ROWS=0`이므로 실제 행 렌더링 검증이 불가능함.

## 다음 검증 절차

1. 사용자가 기존 명령으로 백엔드 4003을 기동한다.
2. Chrome Browser 플러그인 연결을 복구한다.
3. 정상 로그인 상태에서 설비관리 메뉴의 9개 항목을 각각 클릭한다.
4. URL·활성 메뉴·탭·화면 제목이 함께 바뀌는지 확인한다.
5. REFLOW 기간을 `2026-07-12`로 조회해 `REF4`, `REF11`, `REF7` 등 실제 행이 렌더링되는지 확인한다.
6. 각 화면 직접 URL 새로고침과 뒤로 갔다 재진입을 확인하고, 콘솔 오류와 실패 네트워크 요청이 없는지 확인한다.

## 실패 원문

- Oracle 내부 프로필 `ESDB`: `ORA-12170: TNS:Connect timeout occurred` (실제 백엔드 `.env` 호스트와 일치하는 `JSIDCESDB`로 검증 완료)
- Chrome: `Unable to load browser request-header policy. Retry the browser command.`
