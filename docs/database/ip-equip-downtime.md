---
sources:
  - apps/backend/src/modules/work-result/work-result.service.ts
  - apps/backend/src/modules/work-result/work-result.dto.ts
  - apps/backend/src/modules/equip-ops/equip-ops.service.ts
verifiedCommit: dee4f7e
---

# 설비 비가동 — IP_EQUIP_DOWNTIME_*

## 구성

```
IP_EQUIP_DOWNTIME_RESULT    비가동 실적
  PK DT_SEQ + ORGANIZATION_ID          ← RUN_NO는 PK가 아니다
       │ REASON_CODE
       ▼
IP_EQUIP_DOWNTIME_REASON    사유 마스터
  PK REASON_CODE + ORGANIZATION_ID
       ▲ REASON_CODE
       │
IP_EQUIP_DOWNTIME_MAP_DTL   설비별 사유 연계
  PK MACHINE_CODE + REASON_CODE + ORGANIZATION_ID
```

## 핵심 규칙

**작업지시와 분리 (ADR 0002)** — `RUN_NO`는 NULL을 허용한다. 작업지시 없이 발생한 비가동을
설비 기준으로 기록하기 위해서다. 식별은 `DT_SEQ` 단독이며 채번은 전역 시퀀스
`SEQ_IP_EQUIP_DOWNTIME`을 쓴다.

**진행중 판정** — `END_TIME IS NULL`이면 진행중이다. 같은 설비에 진행중 비가동이 이미 있으면
새 시작을 막는다.

**계획/비계획** — `IP_EQUIP_DOWNTIME_REASON.REASON_TYPE`이 `PLAN`(6건) / `UNPLAN`(4건)이다.
`OEE_REFLECT_YN`으로 OEE 반영 여부가 갈린다(계획은 대체로 `'N'`).

## 계획 비가동 일괄 등록 (2026-08-31)

`POST /oee/work-result/downtimes/plan`이 체크한 일자 × 선택 설비에 같은 사유·시간을 적용해
한 트랜잭션으로 등록한다.

- 시간대가 겹치는 기존 행이 **PLAN이면 지우고 다시 넣고**(replaced), **UNPLAN이면 건드리지
  않고 건너뛴다**(skipped + 사유명 반환). 실제 발생한 고장을 계획이 덮어쓰지 않게 하는 규칙이다.
- 자정 넘김을 허용하지 않는다 — 종료 ≤ 시작이면 400.
- `RUN_NO`는 NULL, `WORKSTAGE_CODE`는 설비의 공정코드로 채운다.

## 주의

- FK 제약이 없다. `MACHINE_CODE`·`REASON_CODE` 연결은 애플리케이션 규약이다.
- `IP_EQUIP_DOWNTIME_MAP_DTL`은 2026-09-02 기준 1,200건으로 설비 120대 × 사유 10개
  전조합이 매핑돼 있다.
