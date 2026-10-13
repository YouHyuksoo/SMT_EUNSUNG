# 제품포장관리(PID) 운영 가이드

## 박스라벨 출력 경로

1. 화면이 `GET /product/pack/box-label?packBarcode=` 로 출력 데이터를 받는다 (읽기 전용).
   - `IP_PRODUCT_PACK_MASTER` 에서 모델·포장수량·포장일
   - `ISYS_LABEL_FORM` 에서 그 모델의 박스(B) 양식 `.btw` (모델·유형별 하나)
   - V1~V20: `F_GEN_LABEL_DATA_4_BARTENDER('', 모델, 'B', 'Vn', 포장일, 수량, 박스바코드, '')`
2. 화면이 작업자 PC 의 Print Agent(`http://127.0.0.1:37111/print/bartender`)로 양식과 값을 넘긴다.
3. Agent 가 PowerShell 로 BarTender ActiveX 를 불러 양식을 열고, 빈 값·`NOTFOUND` 를 뺀 값을 넣고 매수만큼 찍는다.

PB(`w_com_bartneder_form_popup`)와 같은 데이터·순서다. 포장완료는 출력 매수, 재출력은 1장.

## 장애 확인

- "박스 라벨 양식이 없습니다" — 제품별 라벨양식 관리에서 그 모델의 박스 양식을 등록한다.
- "출력 에이전트가 실행 중이 아닙니다" — 작업자 PC 에서 Print Agent 를 실행한다. 로그는 `%AppData%\EUNSUNG\print-agent\logs`.
- "값 칸 Vn 을(를) 넣지 못했습니다" — 양식(.btw)에 그 이름의 값 칸이 없다. 양식을 고치거나 라벨양식의 Vn 을 비운다.
- 배포 MES 가 http 공인 주소면 브라우저(Chrome/Edge)가 로컬 에이전트 요청을 막을 수 있다. 이 경우 MES 를 https 로 접속해야 한다.
