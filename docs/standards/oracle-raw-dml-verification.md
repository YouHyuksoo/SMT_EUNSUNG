---
sources:
  - apps/backend/src/modules/oee/oee-multi-entry.service.ts
  - apps/backend/src/modules/oee/oee-multi-entry.service.spec.ts
verifiedCommit: 654f302
---

# TypeORM Oracle raw DML 검증

## 적용 범위

TypeORM Oracle `DataSource.query()` / `EntityManager.query()`로 raw SQL DML을 실행하는 경로에 적용한다. `Repository.update()`의 UpdateResult나 `QueryRunner.query(..., true)`의 구조화 반환값을 raw query 반환값과 혼동하지 않는다.

## 드라이버 계약

- node-oracledb의 배열 bind는 SQL에 placeholder가 나타나는 순서다. `:1` 같은 이름의 숫자가 배열 인덱스를 지정하는 것으로 가정하지 않는다.
- SQL의 순서와 배열의 순서를 일치시킨다. 같은 named bind 객체를 여러 호출에 재사용하지 않는다.
- TypeORM OracleQueryRunner의 비구조화 결과는 `raw.rowsAffected` 숫자를 그대로 반환할 수 있다. 성공 UPDATE `1`, 영향 없음 `0` 또는 undefined를 구분하고 객체만 처리하는 검사를 두지 않는다.

```ts
const result: unknown = await manager.query(
  'UPDATE EXAMPLE SET VALUE = :1 WHERE ORGANIZATION_ID = :2 AND ROW_ID = :3',
  [value, organizationId, rowId],
);
const affected = typeof result === 'number' ? result : 0;
if (affected !== 1) throw new Error('Expected exactly one updated row');
```

## 검증 및 진단 순서

1. 실제 스키마와 설치된 드라이버의 query 반환 경로를 확인한다.
2. 단위 테스트의 fake는 SQL의 실제 placeholder 출현 순서로 bind를 해석한다. 서비스 구현의 잘못된 배열 인덱스를 fake가 그대로 복제하면 안 된다.
3. 숫자 1 성공, 0/undefined 실패, 늦은 DML 오류의 전체 rollback을 테스트한다.
4. 아래 명령을 필수 실행한다.

```bash
pnpm --filter @eunsung/backend test --runInBand --runTestsByPath src/modules/oee/oee-multi-entry.service.spec.ts
```

5. 실제 Oracle 연결에서 테스트 전용 신규 행에만 DML을 수행하고 rollback하여 bind와 반환값을 확인한다. 검증용 데이터 변경 범위가 허용된 경우에만 실행하며 기존 업무 데이터는 수정하지 않는다.
6. 위 검증은 인증 API·프록시·화면 검증의 대체가 아니다. `oracle-db-backed-screen-verification.md` 완료 기준도 적용한다.

## 근거

`docs/reports/2026-09-10-oee-multi-entry-batch-verification.md`의 신규 일괄 종료 검토에서, 객체형 affected mock과 숫자 suffix 기준의 bind mock이 잘못된 구현을 통과시킨 사례를 재현했다. 드라이버 경계 회귀 테스트와 실제 rollback 검증을 추가했다.
