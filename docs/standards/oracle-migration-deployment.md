---
sources:
  - AGENTS.md
  - apps/backend/src/migrations/
  - apps/backend/src/migrations/*.structure.test.mjs
verifiedCommit: e15be44
---

# Oracle 마이그레이션 배포 표준

## 적용 조건

JSIDC 같은 개발 DB에서 만든 테이블·컬럼 계약을 은성 운영 DB에 배포할 때 적용한다. 이미 모든 환경에 존재한다고 DB 메타데이터로 확인된 기존 테이블의 단순 데이터 보정에는 신규 생성 규칙을 강제하지 않는다.

## 장애에서 확인된 원인

- 직접 원인: `WORKER_MASTERS` 보정 스크립트가 테이블 존재를 전제로 `ALTER TABLE`만 수행해, 테이블 자체가 없는 운영 DB에서 `GET /master/workers`가 `ORA-00942`로 실패했다.
- 유입 원인: 개발 DB에서만 기존 테이블을 확인하고 운영 DB의 사전 객체 존재 여부를 확인하지 않았다.
- 검출 실패: 서비스 단위 테스트는 Repository mock만 사용했고, 마이그레이션에는 테이블 부재 계약을 검사하는 테스트가 없었다.
- 시스템 원인: 개발 DB에 우연히 남아 있는 객체를 신규 운영 환경에도 존재한다고 가정하면 다른 엔티티에서도 반복될 수 있다.

## 구현 규칙

1. DDL 전 대상 프로필의 `USER_TABLES`, `USER_TAB_COLUMNS`, `USER_CONSTRAINTS`를 조회한다.
2. 신규 테이블 마이그레이션은 파일 첫 토큰을 `DECLARE` 또는 `BEGIN`으로 둔다.
3. `USER_TABLES`에서 테이블 존재 여부를 확인하고, 없으면 전체 컬럼·기본값·PK를 `CREATE TABLE`로 생성한다.
4. 테이블이 있으면 필요한 컬럼·기본값·제약만 멱등 보정한다.
5. 정적 구조 테스트로 `USER_TABLES`, `CREATE TABLE`, 핵심 컬럼과 PK 계약을 강제한다.
6. connector로 대상 DB에 실제 적용한 뒤 같은 파일을 재실행해 멱등성을 확인한다.
7. `USER_OBJECTS`, 컬럼 수, PK 컬럼, 기대 데이터 건수, 인증된 API 응답 순으로 검증한다.

## 필수 검증 예시

```powershell
node --test apps/backend/src/migrations/worker-masters-organization-id.structure.test.mjs
python "$env:USERPROFILE\.codex\skills\oracle-db\scripts\oracle_connector.py" --site ESDBext --execute-file apps/backend/src/migrations/2026-09-09_worker_masters_organization_id.sql
```

컴파일·Repository mock 테스트·SQL 파일 생성만으로 운영 배포 완료를 판정하지 않는다.
