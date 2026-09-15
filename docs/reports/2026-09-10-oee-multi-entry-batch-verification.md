# OEE 다중입력 일괄 저장 구현 및 검증 결과

- 작성일: 2026-09-10
- 상태: 구현·집중 테스트·Oracle rollback 검증 완료, 인증 API 및 렌더 검증 미완료.
- 승인 계약: `docs/specs/2026-09-10-oee-multi-entry-batch-design.md`.

## 구현

- `oee-multi-entry.controller/dto/service` 추가 및 모듈 등록. JwtAuthGuard 적용.
- 다중입력 상태/시작/종료를 전용 API로 전환. 기존 단건 모바일 및 작업실적 서비스는 유지.
- 원장은 IP_EQUIP_DOWNTIME_RESULT, 식별은 조직 + DT_SEQ. LINE_CODE NULL인 기존 건은 제외.
- 시작 시 사유 선택 입력, 종료 시 필수 최종 사유를 전체 대상에 덮어쓰기.
- 일괄 시작/종료 각각 단일 트랜잭션, 공통 서버 시각. 정렬된 라인 마스터 잠금 후 상태 재검증. 오래된 종료 요청과 중복 시작은 전체 실패.
- 작업장 ALL 제거, 선택 공정 안의 라인 전체 선택 유지. 7인치 별칭과 기존 화면 모드 보존.
- 통신 오류/408/5xx/응답 계약 불일치 시 POST 자동 재전송 없음. GET 재조회, 결과 미확정 상태 유지. 인증 조직/사용자별 sessionStorage 제출 잠금. 저장소 오류도 fail-closed.
- 응답의 대상·조직·시각·종료 사유를 검증한 뒤에만 성공 표시.

## 자동 검증

- 백엔드 다중입력 집중 Jest: 24개 통과.
- 백엔드 OEE Jest: 14 suites / 155개 통과.
- 백엔드 TypeScript 검사 통과.
- 프론트 전체 구조 테스트: 87개 통과.
- 프론트 typecheck 및 registry 검증 통과: 38 routes / 36 menu leaves.
- 변경 프론트 파일 대상 ESLint 통과. 전체 프론트 lint에는 기존 별도 파일 오류가 남아 있다.
- `git diff --check` 통과.

## 실제 Oracle 검증

- Connector 프로필 EUNSUNG_DEV_ESDBPDB와 백엔드 .env 설정 일치를 비밀정보 출력 없이 확인.
- thick client 사용, LINE_CODE VARCHAR2(20 BYTE) 확인.
- 실제 OeeMobileService/OeeMultiEntryService와 TypeORM repository 사용.
- 검증 전 기존 원장: 조직 1, 총 48건, LINE_CODE NULL 48건, 신규 라인 실적 0건.
- 전용 QueryRunner 바깥 트랜잭션에 서비스 트랜잭션을 연결하여 commit 없이 검사했다. 신규 테스트 행만 INSERT/UPDATE한 후 finally rollback/release.

| 시점 | 원장 전체 | LINE_CODE 입력 | LINE_CODE NULL |
|---|---:|---:|---:|
| 이전 | 48 | 0 | 48 |
| 트랜잭션 내부 | 50 | 2 | 48 |
| rollback 이후 | 48 | 0 | 48 |

- 실제 유효 라인 2개, 작업자, 활성 사유를 사용했다.
- 사유 없는 일괄 시작, 동일 START_TIME, status의 openEvent 조회 성공.
- 중복 시작 ConflictException 확인.
- 일괄 종료 최종 사유 overwrite, 공통 종료 시각 및 실제 Oracle UPDATE 숫자 반환값 1/1 확인.
- 이미 종료한 DT_SEQ 재종료 ConflictException, 추가 UPDATE 없음.
- 종료 후 RUNNING 및 종료 이력 확인. 기존 48건에 대한 DML 및 테스트 데이터 commit 없음. 시퀀스 NEXTVAL 소비는 rollback 대상이 아니다.
- 임시 재현 스크립트: `C:\Users\imarr\AppData\Local\Temp\opencode\oee-multi-entry-live-verify.cjs` (저장소 산출물 아님).
- 이 검증은 서비스/드라이버 경계 검증이며 사용자 인증 HTTP 검증이 아니다.

## 발견 결함과 재발 방지

| 항목 | 내용 |
|---|---|
| 직접 원인 | 초기 UPDATE 성공 판정이 객체만 허용하여 실제 숫자 1을 실패로 취급. UPDATE SET 절보다 WHERE 절의 bind를 앞에 전달하여 실제 위치 바인딩 순서 불일치 |
| 유입 원인 | SQL 숫자 placeholder 이름을 배열 인덱스로 해석하고 raw query 반환을 repository/driver 객체와 혼동 |
| 검출 실패 | fake가 객체형 결과와 잘못된 배열 순서를 그대로 복제하여 초기 단위 테스트 통과 |
| 시스템 원인 | 이 프로젝트의 TypeORM Oracle raw DML 경계에서 다른 모듈에도 재현 가능 |
| 적용 범위 | 프로젝트 공통. AGENTS.md에 드라이버 경계 검증 규칙 추가 |
| 강제 장치 | 실제 출현 순서 bind 해석 회귀 테스트, 숫자 1/0/undefined 영향 행수 테스트, 필수 focused Jest 명령, Oracle rollback 검증 |

상세 표준: `docs/standards/oracle-raw-dml-verification.md`.

## 미완료 검증 및 후속

1. 기존 서버는 직접 기동하지 않고 접속만 확인했다. 프론트 3100 로그인 페이지 200, 백엔드 3003 및 프론트 프록시의 새 status 경로는 인증 없이 401을 반환했다.
2. 로그인 세션/테스트 인증 정보가 제공되지 않았다. E2E_EMAIL/E2E_PASSWORD 없음, 기존 CDP 9222 연결 불가. 인증 우회나 토큰 위조는 수행하지 않았다.
3. 실제 사용자 인증으로 백엔드 `/api/v1/oee/multi-entry/*` → 프론트 `/api/oee/multi-entry/*` → 10인치/7인치 렌더의 데이터 및 조작을 대조해야 한다.
4. 통신 결과가 불명확한 요청은 현재 저장 계약에 영구 요청 식별자가 없어 GET만으로 자기 요청 성공을 확정할 수 없다. 화면은 자동 해제하지 않고 잠금을 유지한다. 실제 운영에서의 확인 후 잠금 해제 방식은 별도 확정이 필요하며, 상태 변화만으로 성공 처리하는 우회는 넣지 않았다.
5. 실제 Oracle 두 세션 동시 요청 및 브라우저 네트워크 차단 실험은 아직 수행하지 않았다. 단위 테스트와 순차 실제 DB 검증을 동시성 실험으로 보고하지 않는다.

전체 화면 기능을 검증 완료로 선언하지 않는다. 다음 세션은 위 남은 경로를 현재 코드·DB로 재확인한다.
