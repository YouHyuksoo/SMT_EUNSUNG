# OEE 다중입력 저장 구조 미완료·승인 대기 기록

- 작성일: 2026-09-09
- 작성 계기: 모바일 다중입력의 비가동 저장 기준과 저장 구조의 미확정 사항 기록
- 상태: **미완료 — 구현 승인 대기**

## 요약 (결론 먼저)

- 범위는 **모바일 다중입력만**이다. 작업실적(work-result)은 범위에서 제외하며 기존 코드는 건드리지 않았다.
- 요청 기준은 `IP_EQUIP_DOWNTIME_RESULT`를 authoritative store로 사용하고, RUN/설비 선택 없이 저장하는 것이다. 작업장 `ALL` 옵션은 제거하며, 시작 사유는 optional, 최종 END는 mandatory 및 overwrite로 처리한다.
- 대상 테이블은 조직+`DT_SEQ` 기준의 실제 PK와 요청 식별·리소스/컨텍스트 메타데이터 부재 때문에, DDL 없이 깔끔한 identity/idempotency 보장 방안을 확인하지 못했다.
- 구현 전 별도 승인이 필요하다. 현재까지 코드 변경, DDL, DML은 없다.

## 상세

### 범위와 요청 기준

- 대상: OEE 모바일 다중입력 저장 흐름
- 제외: work-result 화면·API·저장 규칙
- 저장 원장: `IP_EQUIP_DOWNTIME_RESULT`
- 입력/처리 기준:
  - RUN 선택 없음
  - 설비(machine) 선택 없음
  - 작업장 `ALL` 옵션 제거
  - 시작 사유는 optional
  - 최종 END는 mandatory이며 overwrite 요구

### 확인된 DB 사실과 확인 경계

설정과 일치하는 개발 프로필 `EUNSUNG_DEV_ESDBPDB`를 기준으로 스키마를 확인했다. 다만 이 프로필 확인만으로 현재 실행 중인 앱 세션의 DB·조직·세션 identity가 동일하다고 주장할 수 없으며, 완전한 runtime 확인은 아니다.

- `IP_EQUIP_DOWNTIME_RESULT` 실제 PK: `DT_SEQ + ORGANIZATION_ID`
- 시퀀스: `SEQ_IP_EQUIP_DOWNTIME`
- nullable 컬럼: `RUN_NO`, `MACHINE_CODE`, `REASON_CODE`
- 리소스/컨텍스트/요청 metadata 컬럼은 대상 테이블에서 확인되지 않음
- 위 구조만으로는 모바일 요청의 immutable identity와 idempotency를 DDL 없이 안정적으로 저장·재검증할 수 있는 clean solution이 없다.

### 충돌 및 미해결 cutover

- 기존 work-result의 RUN-scoped `MAX+1` 방식은 조직 전체 key인 대상 PK 구조와 충돌한다. 보호된 work-result 코드를 별도 승인 없이 조직 범위 방식으로 바꾸지 않는다.
- 기존 live view는 여전히 구 event store를 읽는다.
- 기존 모바일 open-event를 새 authoritative store로 전환하는 cutover가 미해결이다. 저장 대상만 바꾸고 live view/open-event 경로를 그대로 두면 원장과 화면이 분리될 수 있다.

## 후속 조치

1. 구현 전에 저장 identity, idempotency, live view/open-event cutover에 대한 별도 승인을 받는다.
2. 승인 시 `organization_id + DT_SEQ`로 연결되는 **additive companion metadata** 구조를 검토한다. 이 보조 구조에는 resource/context와 immutable request identities를 두고, downtime 사실 데이터는 `IP_EQUIP_DOWNTIME_RESULT`에만 유지한다(dual ledger는 만들지 않는다).
3. 승인 전에는 앱 코드, DDL, DML을 변경하지 않는다.
