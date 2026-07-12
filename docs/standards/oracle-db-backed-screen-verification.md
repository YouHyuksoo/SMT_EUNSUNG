---
sources:
  - AGENTS.md
  - apps/backend/src/common/guards/jwt-auth.guard.ts
  - apps/backend/src/common/decorators/tenant.decorator.ts
  - apps/backend/src/modules/master/controllers/
  - apps/backend/src/modules/master/services/
  - apps/frontend/src/services/api.ts
verifiedCommit: 1bd1735
---

# Oracle DB 기반 화면 개발·검증 표준

이 문서는 `docs/standards/incident-to-standard-process.md`에 따라 구매단가 장애에서 프로젝트 공통 규칙으로 승격되었다.

Oracle 기준정보나 운영 데이터를 조회·저장하는 화면은 컴파일과 단위 테스트만으로 완료 처리하지 않는다. 인증된 실제 API에서 기대 데이터가 반환되는지 확인해야 한다.

## 1. 인증과 조직 범위

이 저장소는 `JwtAuthGuard`를 모든 컨트롤러에 자동 적용하지 않는다. `@OrganizationId()`를 사용하는 컨트롤러는 다음 조건을 모두 만족해야 한다.

1. 컨트롤러에 `@UseGuards(JwtAuthGuard)`를 명시한다.
2. 모듈이 Guard 생성에 필요한 `IsysUser`, `IsysOrganization` 리포지토리를 제공한다.
3. 서비스는 요청 body/query의 `organizationId`를 신뢰하지 않고 Guard가 주입한 값만 사용한다.
4. 조직 ID가 없으면 전체 조회로 완화하지 않고 즉시 인증 또는 잘못된 요청 오류를 반환한다.

필수 회귀 테스트:

```ts
const guards = Reflect.getMetadata(GUARDS_METADATA, TargetController) ?? [];
expect(guards).toContain(JwtAuthGuard);
```

서비스 테스트에서는 목록, 상세, 영향도, 기준정보 옵션, 등록, 수정 등 모든 경로가 서버 주입 조직 ID를 사용하는지 확인한다.

## 2. Oracle named bind 객체

TypeORM의 `DataSource.query()`에 전달한 Oracle named bind 객체는 드라이버 실행 과정에서 변경될 수 있다. 같은 객체를 COUNT 조회와 데이터 조회 등에 재사용하지 않는다.

```ts
// 금지
await dataSource.query(countSql, binds);
await dataSource.query(dataSql, binds);

// 필수
await dataSource.query(countSql, { ...binds } as unknown as unknown[]);
await dataSource.query(dataSql, { ...binds } as unknown as unknown[]);
```

공통 query helper가 있으면 helper 경계에서 복제한다. 테스트 mock도 첫 호출의 bind 객체를 변경하도록 구성해 다음 호출이 영향을 받지 않는지 검증한다.

## 3. DB 기반 화면 완료 기준

다음 검증을 순서대로 모두 수행한다.

1. **Oracle 기준값 확인**: 대상 테이블의 전체 건수와 조직별 건수, 화면 기본 필터에 해당하는 기대 건수를 read-only SQL로 확인한다.
2. **서비스 테스트**: 테넌트 격리, 필터, 오류 원문, 저장 영향도를 검증한다.
3. **타입 검사**: 변경된 프론트·백엔드 워크스페이스에서 filtered `tsc`를 실행한다.
4. **인증된 백엔드 API**: 실제 사용자 인증을 적용해 백엔드 URL에서 데이터 건수와 대표 행을 확인한다.
5. **프론트 프록시 API**: Next.js `/api` 경로에서도 같은 건수와 대표 행이 반환되는지 확인한다.
6. **렌더링 확인**: 로그인된 브라우저에서 필터 기본값, 행 렌더링, 오류 표시를 확인한다.

Swagger 경로 존재, HTTP 200, 페이지 컴파일 성공은 각각 라우트 로드만 증명한다. 실제 데이터 조회 성공의 대체 증거로 사용하지 않는다.

## 4. 조회 실패 진단 순서

화면에 데이터가 없을 때 UI부터 수정하지 않는다.

1. 브라우저 요청이 빈 성공 응답인지 오류 응답인지 구분한다.
2. 같은 조건의 Oracle SQL로 기대 건수를 확인한다.
3. 인증된 백엔드 API를 직접 호출한다.
4. SQL debug 정보에서 조직 bind와 필터 bind를 확인한다.
5. 프론트 프록시 API를 호출해 프록시·base URL 문제를 분리한다.
6. API 데이터가 정상일 때만 프론트 응답 매핑과 그리드 렌더링을 조사한다.

프론트의 `catch`에서 빈 배열을 설정하더라도 전역 오류 모달의 서버 원문을 덮어쓰면 안 된다.

## 5. 구매단가관리에서 확인된 사례

`MST_PURCHASE_PRICE` 최초 구현에서는 다음 두 문제가 연속으로 발생했다.

- 컨트롤러에 `JwtAuthGuard`가 없어 `@OrganizationId()`가 `undefined`였다.
- COUNT와 목록 조회가 같은 bind 객체를 재사용해 첫 쿼리 이후 조직 bind가 사라졌다.

컴파일, 초기 단위 테스트, Swagger 확인, 페이지 HTTP 200은 모두 통과했지만 실제 목록은 0건이었다. Guard 메타데이터 테스트, 드라이버 bind 변경 회귀 테스트, 인증된 실제 API 건수 확인을 완료 기준에 추가한 이유다.
