# 은성 전장 OEE 관리 매뉴얼(PPT) 체크리스트

작성일 2026-09-11 · 산출물 `docs/presentations/2026-09-11-eunsung-oee-manual.pptx`

## 0. 준비

- [x] 대상 메뉴 확정 (기준정보 16 + OEE 4 + 로그인 = 21화면)
- [x] 산출물 위치 결정 (`docs/README.md` 등록부의 `presentations/`)
- [x] 캡처용 로그인 계정 확보 (ADMIN)
- [x] dev 서버 기동 확인 (localhost:3100)

## 1. 화면 캡처 (Playwright)

- [x] 00 로그인 `/login`
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
- [x] 13 라벨다자인관리 `/master/label`
- [x] 14 구매단가관리 `/master/purchase-price`
- [x] 15 품목별 공급처 관리 `/master/item-supplier`
- [x] 16 제품판매단가관리 `/master/sale-price`
- [x] 17 OEE 비가동 입력 `/oee/multi-entry`
- [x] 18 설비별 작업 실적관리 `/oee/equip-work-result`
- [x] 19 설비 운영 현황 `/oee/equip-ops-status`
- [x] 20 설비 운영 및 실적관리(현장) `/oee/field-ops`

## 2. 절차 텍스트

- [x] 화면별 작업 절차 초안 (소스 기준 — 버튼/필터/모달/그리드 실제 동작)
- [x] 번호 마커(①②③)와 절차 문장 번호 일치 확인

## 3. PPT 조립

- [x] 표지 (타이틀 `은성 전장 OEE 관리`)
- [x] 목차 (기준정보 16 / OEE 관리 4)
- [x] 화면 슬라이드 21장 (좌 캡처 + 번호 마커 / 우 절차)
- [x] 16:9 가로 양식 확인
- [x] 파일 열림·슬라이드 수 검증

## 4. 마무리

- [x] 미완료 항목이 남으면 `docs/reports/`에 기록 — 아래 "남은 이슈" 참고

## 5. 남은 이슈 (매뉴얼 범위 밖)

- 라벨다자인관리(`/master/label`): `GET /master/label-templates`가 500(ORA-00942)으로 실패한다.
  엔티티는 `ICOM_LABEL_TEMPLATES`(`apps/backend/src/entities/label-template.entity.ts:21`)를 보는데
  운영 DB(ESDBPDB)에는 `LABEL_TEMPLATES`만 있다. 템플릿 저장·조회 불가 상태로 매뉴얼에 주의 문구를 넣었다.
- 작업자관리(`/master/worker`): `WORKER_MASTERS` 0건이라 목록이 비어 있는 화면으로 캡처됐다.
