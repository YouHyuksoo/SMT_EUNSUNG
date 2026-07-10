---
menuCode: MST_PART
audience: operator
title: 품목마스터
summary: 은성전장 품목 기준정보 화면의 실제 소스, API, ID_ITEM 컬럼 매핑, 검증 규칙을 정리한 운영자 도움말
tags: [기준정보, 품목, 운영, ID_ITEM]
keywords: [ID_ITEM, ORGANIZATION_ID, ITEM_CODE, PART_NO, ITEM_CLASS, MES_DISPLAY_YN, FEEDER_LAYOUT_COMMENTS, master parts]
related: [MST_BOM, MST_WAREHOUSE, MST_ROUTING]
---

# 품목마스터 - 운영자 도움말

## 소스 위치

| 구분 | 위치 |
|------|------|
| 메뉴 설정 | `apps/frontend/src/config/menuConfig.ts` (`MST_PART`, `/master/part`) |
| 화면 | `apps/frontend/src/app/(authenticated)/master/part/page.tsx` |
| 그리드 컬럼 | `apps/frontend/src/app/(authenticated)/master/part/partColumns.tsx` |
| 입력 패널 | `apps/frontend/src/app/(authenticated)/master/part/components/PartFormPanel.tsx` |
| 프론트 타입 | `apps/frontend/src/app/(authenticated)/master/part/types.ts` |
| API 컨트롤러 | `apps/backend/src/modules/master/part/part.controller.ts` |
| 서비스 | `apps/backend/src/modules/master/part/part.service.ts` |
| DTO | `apps/backend/src/modules/master/part/dto/part.dto.ts` |
| 엔티티 | `apps/backend/src/modules/master/part/entities/item-master.entity.ts` |

## 데이터 기준

주 테이블은 `ID_ITEM`입니다. 품목은 `ORGANIZATION_ID`와 `ITEM_CODE`를 복합 키로 식별합니다.

| 화면/API 필드 | DB 컬럼 | 비고 |
|---------------|---------|------|
| organizationId | ORGANIZATION_ID | 조직 범위 키 |
| itemCode | ITEM_CODE | 품목코드, PK |
| itemNo | PART_NO | 품번 |
| itemName | ITEM_NAME | 품목명 |
| custPartNo | CUSTOMER_PART_NO | 고객품번 |
| itemType | ITEM_TYPE | 공통코드 `ITEM_TYPE` |
| productType | ITEM_CLASS | 공통코드 `PRODUCT_TYPE` |
| lineType | LINE_TYPE | 서비스 기본값 `*` |
| itemDivision | ITEM_DIVISION | 기본값은 품목유형 |
| modelName | MODEL_NAME | 차종 |
| defectModelGroup | MODEL_SUFFIX | 모델구분 |
| spec | ITEM_SPEC | 규격 |
| rev | ABC_GRADE | 리비전 호환 매핑 |
| markingText | BARCODE | 마킹문구 |
| unit | ITEM_UOM | 단위, 기본값 `EA` |
| color | MODEL_COLOR | 색상 |
| safetyStock | SAFETY_INVENTORY | 안전재고 |
| lotUnitQty | MATERIAL_QTY | 묶음단위수량 |
| boxQty | ISSUE_PACKING_QTY | 박스장입수량 |
| minPackQty | MATERIAL_QTY2 | 최소불출단위수량 |
| expiryDate | LIFE_CYCLE | 유효기간 |
| expiryExtDays | MSL_MAX_TIME | 유효기간 연장 |
| packUnit | CARRIER_SIZE | 팔레트구성단위 |
| storageLocation | LOCATION_ADDRESS | 품목고정 적재로케이션 |
| imageUrl | FEEDER_LAYOUT_COMMENTS | 품목 사진 경로 호환 저장 |
| remark | COMMENTS | 비고 |
| useYn | MES_DISPLAY_YN | 사용여부 |
| createdBy / createdAt | ENTER_BY / ENTER_DATE | 등록 감사 정보 |
| updatedBy / updatedAt | LAST_MODIFY_BY / LAST_MODIFY_DATE | 수정 감사 정보 |

## API

| 메서드 | 경로 | 기능 |
|--------|------|------|
| GET | `/master/parts` | 품목 목록 조회 |
| GET | `/master/parts/:id` | 단건 조회 |
| GET | `/master/parts/code/:itemCode` | 품목코드 기준 조회 |
| GET | `/master/parts/types/:type` | 품목유형 기준 조회 |
| POST | `/master/parts` | 품목 등록 |
| PUT | `/master/parts/:id` | 품목 수정 |
| DELETE | `/master/parts/:id` | 품목 삭제 |
| POST | `/master/parts/:id/image` | 품목 사진 업로드 |
| DELETE | `/master/parts/:id/image` | 품목 사진 삭제 |
| POST | `/interface/inbound/item-master` | ERP 품목 마스터 동기화 |

목록 조회는 `itemType`, `useYn`, `search`, `limit` 쿼리를 사용합니다. 검색어는 품목코드, 품목명, 품번, 고객품번, 차종, 규격, 마킹문구에 적용됩니다.

## 화면 동작

- 화면 최초 진입 시 `/master/parts?limit=5000` 기준으로 목록을 조회합니다.
- 검색어 입력은 300ms 디바운스를 거쳐 목록을 다시 조회합니다.
- 행 수정, 행 더블클릭, **품목 추가** 버튼은 모두 우측 `PartFormPanel`을 사용합니다.
- 변경 중 다른 행을 선택하거나 패널을 닫으면 변경사항 유실 방지 확인을 거칩니다.

## 검증 규칙

| 규칙 | 위치 |
|------|------|
| 품목코드, 품번, 품목명, 제품유형은 저장 필수 | `PartFormPanel.tsx`, `part.dto.ts` |
| 품목코드는 등록 후 수정 불가 | `PartFormPanel.tsx`, `PartService.update()` |
| 중복 품목코드는 등록 불가 | `PartService.create()` |
| 삭제 전 참조 데이터 확인 | `PartService.assertDeletable()` |

삭제 차단 대상에는 입고, 재고, LOT, BOM 상위/하위 품목, 생산계획 참조가 포함됩니다. 참조가 있으면 실제 삭제 대신 `useYn=N` 처리를 우선 검토합니다.

## 공통코드와 참조 데이터

| 항목 | 기준 |
|------|------|
| 품목유형 | 공통코드 `ITEM_TYPE` |
| 제품유형 | 공통코드 `PRODUCT_TYPE` |
| 모델구분 | 공통코드 `DEFECT_MODEL_GROUP` |
| 단위 | 공통코드 `UNIT_TYPE` |
| 사용여부 | `Y/N` 선택 |
| 적재로케이션 | 공용 위치 옵션 훅의 창고/로케이션 기준정보 |

## 운영 점검 포인트

- DB 접속 대상이 ESDB 계열인지 확인한 뒤 `ID_ITEM` 기준으로 데이터를 점검합니다.
- 그리드의 SQL 표시 문자열은 사용자 안내용일 수 있으므로 실제 테이블 판단은 백엔드 엔티티와 서비스 SQL을 기준으로 합니다.
- ERP 동기화 후에는 신규/변경 건수, `ITEM_CODE`, `PART_NO`, `MES_DISPLAY_YN`, `ENTER_BY` 값을 확인합니다.
- 사진이 목록에 표시되지 않으면 `FEEDER_LAYOUT_COMMENTS`의 경로와 `/master/parts/:id/image` 응답을 함께 확인합니다.

## 변경 시 영향 범위

품목 필드를 추가하거나 의미를 바꿀 때는 DB 컬럼, 엔티티, DTO, 서비스 매핑, 프론트 타입, 입력 패널, 그리드 컬럼, 번역 키, 도움말을 같이 확인해야 합니다. 프론트와 백엔드가 함께 쓰는 규칙은 공유 모듈에 두고 양쪽에서 같은 함수를 사용합니다.
