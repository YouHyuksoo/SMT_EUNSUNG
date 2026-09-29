# 다중입력 기존 설비 실적·화면 모드·메뉴 삭제 검증

- 작성일: 2026-09-11
- 승인 계약: `docs/specs/2026-09-11-oee-multi-entry-legacy-lines-design.md`
- 상태: 구현, Oracle 서비스 경로, 회귀 테스트 및 모의 API 렌더 검증 완료. 실제 사용자 인증 API → 프록시 → 렌더 전체 연결 검증은 미완료.

## 변경 사항

### 기존 실적 포함

- 실적의 LINE_CODE 우선, NULL이면 동일 조직의 MACHINE_CODE로 IMCN_MACHINE.LINE_CODE 조회.
- 상태·업무일 이력·시작 차단·종료·저장 후 조회에 같은 유효 라인 식 적용.
- 원장 LINE_CODE를 backfill하지 않고 조회 시 해결한다. 두 값이 모두 NULL이면 라인에 귀속시키지 않는다.
- 상태 응답은 단일 openEvent 대신 openEvents 배열이다. 복수 미종료는 정상 비가동 상태로 반환한다.
- 선택 라인의 모든 미종료 DT_SEQ를 하나의 종료 요청에 포함한다. 같은 라인의 서로 다른 DT_SEQ는 허용한다.
- 서버는 라인 마스터와 원장 행을 잠근 후 요청 집합과 실제 미종료 전체 집합을 대조한다. 누락·이미 종료·새로 추가된 대상이면 전체 취소한다.
- 최종 사유와 종료 시각은 전체 대상에 동일하게 적용한다. 미종료가 하나라도 있는 라인은 새 시작을 막는다.
- pending 저장소 및 수동 확인 동작도 라인당 복수 items를 지원한다.

### 화면 및 메뉴

- 메뉴 표시 모드: `전체화면` 버튼 하나.
- 전체화면 모드: `메뉴` 버튼 하나.
- 인치 문구 제거 및 4개 언어 반영.
- 메뉴가 있는 1280×800 화면의 제목이 좁게 세로 줄바꿈되는 문제를 렌더 검토에서 발견했다. 해당 모드의 헤더 수평 배치 breakpoint를 2xl로 조정하여 해결했다. 전체화면의 xl 배치는 유지한다.
- frontend menuConfig에서 OEE_MULTI_ENTRY_7IN leaf 제거. generator가 backend seed/validator/default layout을 동기화했다.
- 기존 별칭 URL은 메뉴 leaf 없이 유지한다. 기본 다중입력 메뉴에서 모드를 전환한다.

## DB 메뉴 삭제

- 적용 프로필: `EUNSUNG_DEV_ESDBPDB`.
- 이전 조회: 조직1의 OEE_MULTI_ENTRY와 OEE_MULTI_ENTRY_7IN 각각 한 건.
- 실행 SQL: `oracle_db_scripts/oee/manual/16_remove_oee_multi_entry_7in_menu.sql`.
- MENU_CATEGORY_ITEMS에서 ORGANIZATION_ID=1 AND MENU_CODE='OEE_MULTI_ENTRY_7IN'인 행만 삭제.
- connector execute-file: 1개 블록 성공.
- 사후 조회: OEE_MULTI_ENTRY 한 건 유지, OEE_MULTI_ENTRY_7IN 0건.
- manualCleanup manifest에 등록. 일반 배포의 자동 정리 DML에는 넣지 않았다.

## 실제 Oracle 서비스 검증

- 백엔드 .env와 개발 connector 프로필 일치, thick client 사용.
- 기존 원장 조직1 48건은 모두 저장 LINE_CODE NULL이지만 설비 라인으로 귀속됨.
- 기존 미종료 조회 결과: 03라인 8건, 22라인 2건. 서비스 openEvents 전체 반환과 시작 차단 확인.
- 기존 미종료 실적에 대한 종료 DML은 수행하지 않았다.
- 별도 신규 테스트 행 2건을 한 바깥 트랜잭션에 만들고 실제 설비 라인 대체 조회 → 종료 → readback → stale END 거부를 확인한 후 rollback했다.
- 테스트 중 총50건, rollback 후48건. 기존48건에 대한 DML 및 LINE_CODE backfill 없음.
- 실제 Oracle UPDATE 결과는 숫자1 두 번. 새로운 테스트 행의 저장 LINE_CODE는 종료 후에도 NULL 유지.
- 임시 검증 스크립트: `C:\Users\imarr\AppData\Local\Temp\opencode\oee-multi-entry-legacy-live-verify-2026-09-11.cjs`.
- QueryRunner를 통해 서비스 SQL을 실제 Oracle에 실행한 검증이다. HTTP 인증 경로 검증은 아니다. 시퀀스 NEXTVAL 소비는 rollback되지 않는다.

## 자동 및 렌더 검증

- 변경 전 RED: 설비 라인 NVL 식 부재, 단일 openEvent 계약, 복수 미종료 거부, 같은 라인 dtSeq 허용 실패, 유효 라인 END 조건 누락을 재현했다.
- backend 다중입력 집중 테스트27개 및 전체 OEE158개/14 suites 통과.
- 메뉴 제거 SQL/fixture 반영 후 main 재검증:
  `pnpm --filter @eunsung/backend test --runInBand --runTestsByPath src/modules/oee/oee-multi-entry.service.spec.ts src/modules/oee/oee-mobile-ddl.spec.ts src/modules/menu-categories/services/menu-categories.service.spec.ts` → 47개/3 suites 통과.
- backend tsc, 변경 production ESLint 통과.
- frontend 전체 테스트94개 통과. 후속 헤더 수정 뒤 페이지37개 및 batch9개 집중 테스트 통과.
- frontend typecheck: 38 pages / 35 menu leaves 검증 통과. 변경 파일 ESLint 및 diff whitespace 검사 통과.
- 격리된 시스템 Chrome, 기존 frontend3100, 전체 API fixture 사용. 실제 사용자 프로필이나 인증 토큰을 사용하지 않았다.
- 렌더 검증: 정상/전체화면에서 반대 모드 버튼 하나 표시와 전환, 메뉴 leaf 삭제, 단일 POST에 모든3개 dtSeq(동일 라인 복수 포함) 전송, 복수 pending END 복원 및 추가 POST 없는 수동 확인 통과.
- 후속 헤더 수정 후 브라우저 verifier4/4 재통과. normal/full 캡처를 직접 확인했다.
- 임시 캡처: `C:\Users\imarr\AppData\Local\Temp\opencode\oee-multi-entry-legacy-{normal,full,end-targets,pending}.png`.

## 남은 확인

- 로그인된 실제 사용자로 인증 backend → frontend proxy → rendered row까지 대조해야 한다. 모의 API 렌더 및 직접 서비스 SQL 검증을 이 경로의 완료로 주장하지 않는다.
- 기존 개발 서버는 재사용했고 별도 서버나 대체 포트를 기동하지 않았다.
- 실제 Oracle 두 세션의 동시 종료/시작 실험은 수행하지 않았다. 단위 테스트의 상태 집합 변경/rollback 검증과 구분한다.
- 전체 frontend lint에는 이번 범위 밖의 기존 오류가 남아 있다.
