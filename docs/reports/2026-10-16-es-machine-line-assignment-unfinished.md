# ES- 설비 75대 라인 지정 — 미완료

- 작성: 2026-10-16
- 상태: 현장 확인 대기
- 관련: [ADR 0003](../adr/0003-oee-downtime-entry-machine-scoped.md)

## 남은 일

`IMCN_MACHINE`에서 `MACHINE_CODE LIKE 'ES-%'`이고 `LINE_CODE='*'`인 75대에 실제 설치 라인을 넣어야 OEE 비가동 입력(SMT/ASSY)에서 고를 수 있다.

| 공정 | 대수 | 비고 |
|---|---|---|
| W091 코팅 | 8 | 코팅1~8라인 후보 |
| W120 콘포멀 | 2 | |
| W090 ICT | 5 | ICT 1~4라인 후보. 지금 ICT 라인에 붙은 1대씩은 옛 코드라 비가동 대상에서 빠진다 |
| W100 라우터 | 9 | 라우터 라인 없음 |
| W095 성능검사 | 10 | |
| SMT(마킹·SP·SPI·마운트·AOI) | 41 | SMT J·K·L라인(10~12) 등 |

- 엑셀 업로드 양식(`docs/Fill_Up_Template/설비마스터_업로드양식.xlsx`)에 라인 칸이 없어 데이터로는 정할 수 없다.
- 현장 기입용 시트: `C:\Users\hsyou\Downloads\설비라인지정_ES미지정75대_2026-10-16.xlsx` (노란 칸에 라인코드, 라인목록 시트에서 선택)

## 다음 세션

1. 돌려받은 시트의 라인코드를 `IP_PRODUCT_LINE`에 있는 코드인지 확인한다.
2. `IMCN_MACHINE` 트리거 없음(2026-10-16 확인). `UPDATE IMCN_MACHINE SET LINE_CODE=:1 WHERE ORGANIZATION_ID=1 AND MACHINE_CODE=:2` 로 반영하고 반영 전후를 이 문서에 적는다.
3. `/oee/multi-entry-assy`에서 라인별 설비가 나오는지 확인한다.
