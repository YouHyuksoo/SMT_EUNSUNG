# 은성 전장 OEE 관리 매뉴얼 v2 (등록/수정 팝업 포함) 체크리스트

작성일 2026-09-14 · 산출물 `docs/presentations/2026-09-14-eunsung-oee-manual-v2.pptx`

## 0. 대상 (v1 대비 변경)

| 구분 | v1 (2026-09-11) | v2 |
|---|---|---|
| 기준정보 | 16화면 | **15화면** — 라벨디자인관리 추가 제외 |
| OEE 관리 | 4화면 | **5화면** — OEE 종합 현황 포함 |
| 로그인 | 포함 | 제외 (이번 범위는 기준정보·OEE) |
| 팝업 | 없음 | **등록/수정 팝업·슬라이드 패널 포함** |

제외 대상: `MST_ROUTING` · `MST_WORK_INST` · `MST_WAREHOUSE` · `MST_LABEL` · `OEE_DASHBOARD`

## 1. 목록 화면 캡처

- [x] 01 품목관리 `/master/part`
- [x] 02 BOM관리 `/master/bom`
- [x] 03 거래처관리 `/master/partner`
- [x] 04 고객마스터 `/master/customer`
- [x] 05 설비마스터 `/master/equip`
- [x] 06 표준시간 관리 `/oee/master/standard-time`
- [x] 07 설비 비가동 사유코드 `/oee/master/idle-reason`
- [x] 08 설비별 비가동 사유 연계 `/oee/master/equip-reason-map`
- [x] 09 공정관리 `/master/process`
- [x] 10 생산라인관리 `/master/prod-line`
- [x] 11 생산월력관리 `/master/work-calendar`
- [x] 12 작업자관리 `/master/worker`
- [x] 13 구매단가관리 `/master/purchase-price`
- [x] 14 품목별 공급처 관리 `/master/item-supplier`
- [x] 15 제품판매단가관리 `/master/sale-price`
- [x] 16 OEE 비가동 입력 `/oee/multi-entry`
- [x] 17 OEE 종합 현황 `/oee/overall-status`
- [x] 18 설비별 작업 실적관리 `/oee/equip-work-result`
- [x] 19 설비 운영 현황 `/oee/equip-ops-status`
- [x] 20 설비 운영 및 실적관리(현장) `/oee/field-ops`

## 2. 등록/수정 팝업 캡처

- [x] 화면별 등록 버튼을 눌러 등록 팝업 캡처
- [x] 행 편집(연필/행 클릭)으로 수정 팝업 캡처
- [x] 팝업이 없는 화면(인라인 편집·조회 전용) 식별해 기록

## 3. 절차 텍스트

- [x] 목록 화면 — 조회/필터/등록 진입까지
- [x] 등록·수정 팝업 — 필수 입력, 운영 조건, 저장 규칙
- [x] 번호 마커와 문장 번호 일치 확인

## 4. PPT 조립

- [x] 표지 · 목차
- [x] 화면당 1장 (좌 캡처 + 마커 / 우 조작방법·운영 조건)
- [x] 16:9 가로, 프로젝트 웹 화면 색(차콜·마젠타) 반영
- [x] 슬라이드 밖으로 나간 도형 0건 확인

## 5. 마무리

- [x] 미완료·미확인 항목 기록

## 6. 결과 · 남은 이슈

- 산출물 `docs/presentations/2026-09-14-eunsung-oee-manual-v2.pptx` — 54장(표지·목차 + 화면 52장), 16:9, 14MB
- 화면 20개 · 캡처 52컷: 목록 20, 등록 15, 수정 12, 특수 5(설비배치·실적등록×2·비가동관리)
- **BOM관리 수정 팝업 미수록** — 수정 아이콘이 루트가 아닌 자품목 행에만 있고(BomTab.tsx:319) 자동 조작으로
  열지 못했다. 등록(BOM 추가) 팝업으로 대체했다.
- 생산월력관리는 일자 편집이 달력 셀 클릭이라 '등록' 팝업만 수록(연간 생성).
- OEE 종합 현황·비가동 입력은 조회 전용/명령형 화면이라 등록·수정 팝업이 없다.
- 캡처 원본은 세션 스크래치패드에 있다(저장소 미포함). 재생성 시 checklist의 화면 목록 순번을 따른다.
