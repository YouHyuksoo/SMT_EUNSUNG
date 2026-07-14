---
sources:
  - apps/backend/src/entities/com-code.entity.ts
  - apps/backend/src/modules/master/services/com-code.service.ts
  - apps/frontend/src/hooks/useComCode.ts
  - apps/frontend/src/components/shared/ComCodeSelect.tsx
  - apps/frontend/src/components/ui/ComCodeBadge.tsx
verifiedCommit: working-tree
---

# ISYS_BASECODE 컬럼 매핑 표준

Oracle 업무 테이블의 코드성 컬럼은 `ISYS_BASECODE`를 기준으로 코드명과 선택 항목을 제공한다. 코드값을 화면에 그대로 노출하거나 화면별 코드명 사전을 만들지 않는다.

## 매칭 규칙

테이블 컬럼명과 `ISYS_BASECODE.CODE_TYPE`을 각각 대문자로 바꾸고 공백, `_`, 기타 구분자를 제거한 값으로 비교한다.

```text
PRODUCT_LINE_TYPE -> PRODUCTLINETYPE
PRODUCT LINE TYPE -> PRODUCTLINETYPE
productLineType   -> PRODUCTLINETYPE
```

따라서 세 표현은 모두 `CODE_TYPE='PRODUCT LINE TYPE'` 그룹을 사용한다. 실제 코드값은 `CODE_NAME`, 표시명은 `CODE_MEAN_KOR`이며 언어별 표시명은 기존 공통코드 훅의 다국어 폴백 규칙을 따른다.

## 화면 적용

- 엔티티·DTO·API·프론트 타입은 DB 컬럼의 lowerCamelCase 이름을 동일하게 사용한다.
- 기존 프로젝트에서 가져온 의미 별칭은 호환 목적으로 유지하지 않고 실제 컬럼명 계약으로 교체한다.
- 필터와 폼: `ComCodeSelect`의 `groupCode`에 가능하면 실제 테이블 컬럼명을 전달한다.
- 그리드: `ComCodeBadge` 또는 `useComCodeLabel`을 사용해 코드명을 표시한다.
- API 저장·검색 값: 코드명 대신 원래 `CODE_NAME` 값을 유지한다.
- 코드 그룹이 없으면 공용 컴포넌트는 원시 값을 폴백 표시한다. 임의 코드명을 하드코딩하지 않는다.

## 신규 페이지 점검

1. 대상 테이블의 코드성 컬럼을 식별한다.
2. 정규키가 일치하는 `ISYS_BASECODE.CODE_TYPE`과 실제 데이터 존재 여부를 확인한다.
3. 필터·폼 옵션과 그리드 표시 양쪽에 같은 컬럼명을 사용한다.
4. 코드값과 코드명이 다른 실제 행으로 렌더링을 확인한다.
5. 구조 테스트에서 코드성 그리드 컬럼이 공용 렌더러를 사용하는지 검사한다.
