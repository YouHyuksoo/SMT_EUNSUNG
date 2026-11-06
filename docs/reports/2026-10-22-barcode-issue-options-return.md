# 자재바코드출고관리 출고형태·옵션·반품 (2026-10-22)

화면: `/warehouse/barcode-issue` (PB `w_mat_other_issue_barcode_master`).

## 반영 내용

- 위쪽 영역에 작업(출고/반품)과 출고 형태를 두고, 좌측 패널(2열)에 조건을 모았다.
- 출고 형태: PCB Assy 출고(P, PB 기본값)와 SMT 출고(K).
  - P는 `PKG_DESIGN.BOM_QUERY`로 제품 모델의 설계BOM을 풀어 대조한다.
  - K는 SMT 모델·라인·면의 피더 BOM으로 대조하고, 맞은 줄의 피더 위치를 남긴다.
  - 운영 실적은 P가 전체 기간 188만 건이고 K는 20건(마지막 2024-05), R은 0건이다.
- PB Option·Process 묶음을 옮겼다. 사용자 결정으로 뺀 것: MFS·Show Plan, Plan Qty, Include Inventory, Item Code(BOM 필터), Mass Reball Wait Return. 기본값은 ISYS_CONFIG 값이고, 없으면 PB `f_config_setup` NVL 기본값이다.
  - 잠금 옵션: FIFO · Model Not Check · No Origin Barcode. 비밀번호(`FIFO_ISSUE_PASSWORD`)를 맞춰야 바꾸며, 판정·출고 때마다 서버가 다시 맞춘다.
  - MSL · 원라벨 대조 · Issue By Feeder는 설정값에 따라 잠겨 있다. IQC는 품목 검사규칙으로 자동이다.
  - MFS Auto Generate · With Location Information은 PB에서도 동작 코드가 없어 표시만 한다.
- 판정 사전검사를 PB 순서로 추가했다: IQC, 챔버 미출고, 불량창고 M02, 생산유형↔재고유형, 원라벨(거래처 바코드).
- 출고 취소: 스캔 영역의 '출고 취소' 버튼 → 바코드를 찍어 그 롯트의 가장 늦은 출고를 취소한다 (PB w_mat_issue_cancel_4_barcode_popup). 바코드 원장 되돌리기와 258 출고취소의 역분개(`IssueManageService.cancelIssue`)를 한 트랜잭션으로 한다.
- 출고 원장 값을 PB와 맞췄다.
  - LOCATION_CODE는 라벨유형으로 정한다 (N M01 · R M06 · B M05).
  - INVENTORY_TYPE은 Inv Type(라인 생산유형), ORIGIN_MFS는 원라벨이다. MFS는 '*'다.
- 반품(Mass Return): Bad, Line Manual Check, Auto Print(릴 라벨), Auto Set Qty, Invoice.

## 검증

- 실제 DB 한 트랜잭션 롤백 시험으로 확인했다.
  - 판정 9가지: 원라벨 없음/불일치, FIFO 기본, 비밀번호 틀림/맞음, NB, BOM 밖, Model Not Check, 샘플 유형.
  - 쓰기: 출고 → 양품 반품 → 불량 반품, 출고 취소(원출고 'C' + 역분개 행 + 원장 ISSUE_COMPARE_YN 'N').
  - 출고행이 M01 · P · 원라벨 · P구분으로 들어간 것을 확인했다.
- 최근 30일 실제 P 출고 1만여 건을 새 BOM 대조로 다시 돌려 99.9% 이상 통과했다.
- 화면에서 확인한 것: 옵션 기본값, 잠금 해제(틀린 비밀번호), 반품 풀어 보기, Bad 전환, 출고 취소 창 풀어 보기, 좌측 패널 스크롤 없음. 출고·반품·취소 버튼은 누르지 않았다.
- BOM 전개 임시행(ID_ENG_BOM_TEMP) 누수는 0건이다.
- 프론트·백엔드 타입체크, 팝업 계약 테스트, 프론트 구조 테스트를 통과했다.

## PB와 일부러 다르게 둔 것

- PB 반품 INSERT의 BARCODE는 직전 출고에 쓴 바코드 변수(stale)를 넣는다. 실제 원장에 다른 품목 바코드가 찍힌 반품 행이 있다. 웹은 찍은 반품 바코드를 넣는다.
- PB 수명주기 검사는 비교가 뒤집혀 있다 (지난 일수 ≤ 수명이면 거절). 웹은 수명을 넘었을 때 거절한다. 설정 기본값은 꺼짐이다.
- 출고는 판정 → 출고 버튼 → 확인 2단계다. PB는 찍는 즉시 출고했다.

## 미완료 · 후속

- PB Category의 SMT Request Issue(R), SMT Bom Report(인쇄), Monitoring(생산계획 조회)은 모드라서 만들지 않았다. Mass Reball Wait Return은 사용자 결정으로 뺐다 (PB에서도 늘 오류로 끝나던 갈래).
- 250 출고바코드반품(`issue-return.service.ts`)도 출고 원장 LOCATION_CODE를 `dto.locationCode ?? null`로 넣는다. PB 250은 라벨유형으로 정한다. 같은 결함이며 아직 고치지 않았다 (웹으로 쓴 null 행은 0건).
- 269 총재고조회의 BOM 기준 조회도 "세션 임시표라 못 읽는다"는 같은 틀린 전제로 빠져 있다.
