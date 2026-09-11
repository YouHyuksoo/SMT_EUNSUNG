# 은성 전장 OEE 관리 매뉴얼(PPT) 체크리스트

작성일 2026-09-11 · 산출물 `docs/presentations/2026-09-11-eunsung-oee-manual.pptx`

## 0. 준비

- [x] 대상 메뉴 확정 (기준정보 16 + OEE 4 + 로그인 = 21화면)
- [x] 산출물 위치 결정 (`docs/README.md` 등록부의 `presentations/`)
- [ ] 캡처용 로그인 계정 확보 (ADMIN)
- [ ] dev 서버 기동 확인 (localhost:3100)

## 1. 화면 캡처 (Playwright)

- [ ] 00 로그인 `/login`
- [ ] 01 품목관리 `/master/part`
- [ ] 02 BOM관리 `/master/bom`
- [ ] 03 거래처관리 `/master/partner`
- [ ] 04 고객마스터 `/master/customer`
- [ ] 05 설비마스터 `/master/equip`
- [ ] 06 표준시간 관리 `/oee/master/standard-time`
- [ ] 07 설비 비가동 사유코드 `/oee/master/idle-reason`
- [ ] 08 설비별 비가동 사유 연계 `/oee/master/equip-reason-map`
- [ ] 09 공정관리 `/master/process`
- [ ] 10 생산라인관리 `/master/prod-line`
- [ ] 11 생산월력관리 `/master/work-calendar`
- [ ] 12 작업자관리 `/master/worker`
- [ ] 13 라벨다자인관리 `/master/label`
- [ ] 14 구매단가관리 `/master/purchase-price`
- [ ] 15 품목별 공급처 관리 `/master/item-supplier`
- [ ] 16 제품판매단가관리 `/master/sale-price`
- [ ] 17 OEE 비가동 입력 `/oee/multi-entry`
- [ ] 18 설비별 작업 실적관리 `/oee/equip-work-result`
- [ ] 19 설비 운영 현황 `/oee/equip-ops-status`
- [ ] 20 설비 운영 및 실적관리(현장) `/oee/field-ops`

## 2. 절차 텍스트

- [ ] 화면별 작업 절차 초안 (소스 기준 — 버튼/필터/모달/그리드 실제 동작)
- [ ] 번호 마커(①②③)와 절차 문장 번호 일치 확인

## 3. PPT 조립

- [ ] 표지 (타이틀 `은성 전장 OEE 관리`)
- [ ] 목차 (기준정보 16 / OEE 관리 4)
- [ ] 화면 슬라이드 21장 (좌 캡처 + 번호 마커 / 우 절차)
- [ ] 16:9 가로 양식 확인
- [ ] 파일 열림·슬라이드 수 검증

## 4. 마무리

- [ ] 미완료 항목이 남으면 `docs/reports/`에 기록
