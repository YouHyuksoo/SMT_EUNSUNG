# 0003. OEE 비가동 입력도 설비 단위로 처리하고, 비가동 대상 설비는 ES- 코드로 한정한다

- 결정일: 2026-10-16
- 상태: 승인
- 대상: `/oee/multi-entry`(SMT), `/oee/multi-entry-assy`(ASSY), `IP_EQUIP_DOWNTIME_RESULT`, `IMCN_MACHINE`
- 관련: [0002](0002-equip-downtime-machine-scoped.md)

## 배경

OEE 비가동 입력은 라인 단위 행(`MACHINE_CODE` NULL, `LINE_CODE`만)을 만들었다. 설비정지(설비별 작업·검사실적,
설비 운영 현황, 현장 운영)는 설비 행을 만든다. 같은 테이블을 두 단위로 쓰면서 아래 문제가 있었다.

- 라인 정지가 설비 화면에 보이지 않아 같은 시간에 설비정지를 또 걸 수 있었다.
- 설비 한 대 정지가 비가동 입력에서는 라인 전체 비가동으로 보였고, 거기서 종료하면 남이 건 설비정지까지 닫혔다.
- 설비정지 종료가 이미 닫힌 행인지 보지 않아 다른 화면이 닫은 종료시각·사유를 덮어썼다.
- 같은 설비가 ES- 코드 행과 옛 시리얼 코드 행으로 두 번 있어(2026-10-14 엑셀 업로드) 화면마다 다른 행을 고를 수 있었다.

## 결정

1. 라인은 설비를 묶어 보여 주는 단위일 뿐이다. 비가동은 항상 설비 행으로 시작·종료한다(ADR 0002 확장).
2. OEE 비가동 입력은 설비정지와 같은 API(`POST /oee/work-result/downtimes/bulk`)를 쓴다.
   보드 조회는 `GET /oee/work-result/downtime-board?processCode=`. 라인 행을 만들던 `/oee/multi-entry/*` API는 제거했다.
3. 설비 비가동 처리 규칙을 `work-result.service.ts` 한 곳에 둔다.
   - 대상 설비 행을 코드 순서로 `FOR UPDATE` 잠근 뒤 진행중 여부(`MACHINE_CODE`, `END_TIME IS NULL`)를 본다.
   - 종료는 `END_TIME IS NULL` 행만 닫고 영향 행이 1이 아니면 거절한다.
   - 종료 때 새 사유가 없으면 시작 사유를 유지하고, 시작 사유도 없으면 막는다.
4. 비가동 대상 설비 = ES- 코드, 사용중(U), 온도계(TEMP) 제외 — `common/utils/downtime-target.ts`.
   설비 목록을 쓰는 비가동 화면은 `GET /oee/equip-ops/machines?downtimeTarget=Y`로 같은 집합을 본다. 옛 행은 지우지 않는다.

## 결과

- 기존 라인 행(`MACHINE_CODE` NULL)은 종료된 4건뿐이라 이력으로만 남는다. OEE 비가동 산정의 라인 행 규칙은 이 이력 때문에 그대로 둔다.
- 라인이 지정되지 않은 ES- 설비 75대(`LINE_CODE='*'`)는 보드에 나오지 않는다. ASSY 라인은 전부, SMT J·K·L라인은 "설비 미지정"으로만 보인다.
  라인 지정은 현장 확인 후 반영한다(`docs/reports/2026-10-16-es-machine-line-assignment-unfinished.md`).
- 이 화면은 같은 요청을 다시 보내도 이미 처리된 설비를 서버가 건너뛰므로, 전송 결과를 모를 때 잠그던 장치(sessionStorage 잠금)를 없앴다.

## 추가 결정 (같은 날)

- 동반정지(원인설비, `CAUSE_YN`) 구분을 없앴다. 비가동 한 건은 "설비 · 사유 · 시작~종료"뿐이다. 컬럼은 남아 있으나 아무도 읽지 않는다.
- 비가동을 쓰는 API는 `POST /oee/work-result/downtimes/bulk` 하나다. 설비정지 패널의 단건 `POST/PUT /oee/work-result/downtimes`는 제거했다(설비 1대도 이 API로).
