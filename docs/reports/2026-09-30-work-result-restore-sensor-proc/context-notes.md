# 컨텍스트 노트 — 실적 구 테이블 복원 + 센서 프로시저 연계

계획: `docs/plans/2026-09-30-work-result-restore-sensor-proc.md`

작업 중 내린 결정과 그 이유를 계속 덧붙인다.

## 2026-09-30 — 조사 단계

### 프로시저가 건별 이력과 맞지 않는 이유

`P_INTERLOCK_SENSOR_ACTUAL_NEO`는 센서 인터락 경로용이다. `IP_PRODUCT_SENSOR_ACTUAL`을
`(LINE_CODE, MODEL_NAME, ORGANIZATION_ID)` 단위 누적 행 1개로 보고, 이미 행이 있으면
INSERT 대신 수량을 가산한다. UPDATE 분기(`neo.sql:344`)에 `IS_LAST_YN`·`RECEIPT_SEQUENCE`
한정이 없어 같은 라인·모델의 **기존 행 전부**가 대상이 된다. `RUN_NO`와 `ENTER_BY`까지
덮어쓴다. 수기 실적을 같은 테이블에 건별로 쌓으면 과거 실적이 조용히 변형된다.

그래서 원장을 분리했다. 이력은 `IP_PRODUCT_WORK_RESULT`, 센서 누적은 프로시저가 담당한다.

### `P_COUNT`를 1로 고정한 근거

`neo.sql:291`에 `-- P_COUNT 는 계속 1 만 넘어와야 함`이라고 적혀 있다. 사용자 판단과
소스가 일치했다. `ORIGIN_COUNT`에만 저장되고 주석에 "참조정보로만 사용"이라 명시돼 있다.

### 파라미터 이름이 의미와 반대다

`P_ACC_COUNT`가 이번 증분(실적수량)이고 `P_COUNT`가 누적 계수다. `ACC`라는 이름 때문에
반대로 넘기기 쉽다. 호출부에 주석을 남겨야 한다.

### `P_MACHINE_CODE`는 실적 행에 안 남는다

프로시저 안에서 `P_INTERLOCK_SET_JIG` 호출에만 쓰인다(`neo.sql:616`). 설비별 실적인데
설비가 센서 실적 행에 남지 않는다. 설비 정보는 복원 테이블의 `MACHINE_CODE`가 보관한다.

### `callProcScalar`는 그대로 쓰면 롤백된다

`oracle.service.ts:254`가 `executeWithRetry(conn, sql, bindVars)`를 옵션 없이 호출해
oracledb 기본값 `autoCommit: false`로 실행된다. 같은 파일 167행 주석이 이 동작을 의도로
설명한다 — 함수의 부수 INSERT를 커넥션 반납 시 롤백시키려는 것이다. 쓰기 프로시저에는
맞지 않으므로 optional 옵션을 추가한다. 기존 호출부는 `P_INTERLOCK_CHECK` 하나뿐이고
점검용이라 기본값 `false` 유지로 영향이 없다.

이 헬퍼는 TypeORM 트랜잭션이 아닌 자체 풀 커넥션을 쓴다. 따라서 실적 저장 트랜잭션과
프로시저 호출은 별개 트랜잭션이다. "실적은 커밋하고 프로시저 실패는 경고" 결정과
구조가 일치하므로 그대로 둔다.

### 반영 상태를 컬럼으로 저장하는 이유

빨간색 표기와 `실적반영` 버튼이 둘 다 "이 실적이 센서에 반영됐는가"를 읽어야 한다.
`RESULT_STATUS`만으로는 표현할 수 없어 `SENSOR_APPLY_YN`·`SENSOR_APPLY_MSG`를 추가한다.

진행(`WIP`)은 애초에 호출하지 않으니 `'N'`이지만 실패가 아니다. 별도 상태값을 만들지 않고
`RESULT_STATUS = 'DONE' AND NVL(SENSOR_APPLY_YN,'N') <> 'Y'` 하나로 실패를 판정한다.

### 프로시저가 정하는 RUN_NO를 그대로 인정한다

프로시저는 `IP_PRODUCT_LINE`에서 라인의 현재 `RUN_NO`를 읽어 센서 실적에 쓴다
(`neo.sql:213`). 팝업이 고른 작업지시와 다를 수 있다. 사용자가 라인 기준을 인정하기로
확정했다. 실적 이력 원장은 팝업이 고른 `RUN_NO`를 쓰므로 두 축이 다를 수 있다는 점을
기억해야 한다.

### 활성 계획이 없으면 아무것도 저장되지 않는다

`IB_PRODUCT_PLANDATA`에 해당 라인의 `ACTIVE_YN='Y'` 행이 없으면 `P_OUT`에
`'NG ACTIVE PLAN NOT FOUND'`를 담고 즉시 리턴한다(`neo.sql:170`). 이 경우가 얼마나 흔한지는
확인하지 못했다 — 이 화면의 대상 설비가 전부 SMT 라인 소속이면 드물고, 아니면 잦다.
실패해도 실적 등록은 되도록 설계했으므로 현장이 막히지는 않는다.

### 확인하지 못한 것

- ES_JSIDC(운영 DB)는 1521 포트 차단으로 접속 불가. 스키마 실측과 DDL 적용을 못 했다.
- ES_JSIDC 휴지통의 `BIN$koAumyN1TTaJP/V4de49KQ==$0`이 아직 살아 있는지 미확인. 휴지통은
  공간 압박 시 자동으로 비워지므로 접속이 열리면 `USER_RECYCLEBIN`을 먼저 봐야 한다.
- 조사는 `es_mesi`(192.168.175.100/XE)에서 했다. 이 DB는 앱이 쓰던 DB가 아니다. 테이블
  603개·패키지 15개로 스키마가 다르고 `PKG_DASHBOARD`가 없다. 프로시저 본문과 파라미터는
  이 DB에서 읽은 것이므로, ES_JSIDC의 같은 오브젝트와 동일한지 접속 복구 후 대조해야 한다.
