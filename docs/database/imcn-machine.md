---
sources:
  - docs/database/generated/infinity21-jsmes-schema.json
  - docs/database/ip-product-line.md
verifiedCommit: 0480e7d
---

# IMCN_MACHINE — 설비 마스터

## 확인된 역할

`IMCN_MACHINE`은 생산에 사용하는 개별 설비 기준정보다. 설비는 `LINE_CODE`로
생산라인에 소속되고 `WORKSTAGE_CODE`로 공정을 참조한다.

2026-07-12 라이브 데이터는 설비 140개, 연결 라인 18개, 공정코드 10종이다.

## 주요 정보

- 설비코드·설비명·설비유형·설비모델
- 취득일·취득유형·공급처
- 생산능력·UPH·사용률
- 사용상태·설비상태·상태 상세
- 소속 라인·공정·담당 부서
- 설비 이미지와 규격

## 레거시 책임 혼합

같은 행에 PLC·IP·통신포트·스캐너 주소·DIO 주소 등 통신설정과 온습도 기준,
지그·금형 상태, 현재 설비상태가 함께 저장된다.

`LINE_CODE`에 대한 Oracle FK는 없지만 실제 값과 업무 합의로 생산라인 소속 관계를
확정한다. Oracle PK 제약조건도 없으나 현재 `MACHINE_CODE` 140개는 모두 고유하다.
