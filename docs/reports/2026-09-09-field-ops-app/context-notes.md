# 컨텍스트 노트 — 현장 설비 운영 및 실적관리

## 2026-09-09 착수 (그릴미 결과)

### 실적 등록 화면은 모달이 아니었다
`equip-work-result/page.tsx:323`의 실적 패널은 `w-[560px]` 우측 슬라이드 패널
(`animate-slide-in-right`)이다. "팝업으로 출력"하려면 그대로 못 쓰고 폼 본문을
공용 컴포넌트로 빼야 한다. 기존 화면 코드를 건드리는 유일한 지점이라 회귀 확인이 필요하다.

### 품명이 목록에 없었다
`RunRow`에 `itemName`이 없고 `modelName`(MODEL_NAME)만 있었다. 실측하니
`ID_ITEM.ITEM_NAME`에 진짜 품명이 있고 둘은 다른 값이다.
예) MODEL_NAME `IG-MAIN-PCB ASSY` vs ITEM_NAME `PCB-B, IG MAIN (BOT)`.
목록 쿼리가 이미 `ID_ITEM`을 unit·itemClass로 조인하고 있어 같은 패턴으로 추가한다.

### 설비 단위 필터가 없었다
`list()`는 `lineCode`와 `keyword`만 받는다. `keyword`가 MACHINE_CODE에도 걸려서
설비코드를 keyword로 넘기면 "되긴" 하지만, ITEM_CODE·MODEL_NAME에도 매칭돼
엉뚱한 작업지시가 섞인다. `machineCode` 파라미터를 따로 받는다.

### 메뉴는 반드시 맨 뒤
`menu-config.json`의 배열 순서가 sortOrder다. 2026-09-01에 `OEE_OVERALL_STATUS`를
앞에 넣었다가 `OEE_MULTI_ENTRY`가 30→40으로 밀려 원격 팀 테스트가 깨졌다.

### 작업자 마스터가 비어 있다
`WORKER_MASTERS` 0건. 콤보가 빈 채로 나온다. 기능은 정상이지만 현장에서 쓰려면
작업자관리에서 먼저 등록해야 한다. 같은 날 스키마 보정(ORGANIZATION_ID,
COMPANY/PLANT_CD 기본값)으로 등록 자체는 가능해졌다.

### 저장 형식
사번을 어디에 넣을지 갈렸다. 비가동 `WORKER`는 사번, 실적 `WORKER_NAME`은 이름으로
정리했다 — 컬럼 이름과 내용이 어긋나지 않게 하는 쪽을 택했다. 동명이인 구분이 필요해지면
실적 쪽에 사번 컬럼을 따로 두는 게 맞다.

## 2026-09-09 구현 중

### 자동 생성 파일을 손으로 고쳤다
`menu-code-validator.ts`, `default-menu-category-layout.ts`, `seeds/menu-config.json`은
모두 `menuConfig.ts`에서 생성된다(헤더에 AUTO-GENERATED). 셋을 직접 편집했는데,
`pnpm --filter @eunsung/frontend gen:menu`를 돌리니 같은 결과가 나와 문제는 없었다.
다음부터는 `menuConfig.ts`만 고치고 생성기를 돌린다.

### 실적 폼 추출이 구조 테스트를 깼다
`equip-work-result-optional-machine.eunsung.structure.test.mjs`가
`machineCode: form.machineCode || undefined`를 page.tsx에서 찾고 있었다. 규칙이 사는
새 파일을 보도록 고치고, 페이지가 공용 컴포넌트에 위임하는지 검사를 하나 더 넣었다.

### 컨트롤러 위치 인자가 밀렸다
`@Query('machineCode')`를 `@OrganizationId()` 앞에 넣어 스펙의 위치 호출에서 조직ID가
machineCode 자리로 들어갔다. 실제 HTTP는 데코레이터 바인딩이라 무해하지만, 위치로
호출하는 테스트가 있으면 드러난다. 커밋 후에 발견해 별도 커밋으로 바로잡았다.

### WorkerSelect는 쓰지 않았다
`detailed` 옵션을 넣었다가 되돌렸다. 실적 팝업에 작업자 **이름**을 넘겨야 해서 원본
목록이 어차피 필요했고, 그러면 라벨은 화면에서 만드는 게 낫다. 대신
`useWorkerOptions`가 원본 목록(`workers`)도 반환하도록 했다.

### 검증
운영 DB에 작업자가 0건이라 E9001(김현장)을 임시 등록해 콤보·실적 기본값까지 확인한 뒤
삭제했다. 이력보기 팝업, 실적 등록 팝업, 작업지시 2줄 그리드, 하단 고정 버튼 모두
브라우저에서 확인했고 페이지 에러는 없었다.
