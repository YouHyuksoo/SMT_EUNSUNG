# OEE MOBILE 개발 DB 검증 체크포인트

- 작성일: 2026-08-06
- 작성 계기: Master가 OEE MOBILE 개발에 사용할 Oracle 개발 DB를 지정함
- Oracle profile: `EUNSUNG_DEV_ESDBPDB`
- schema: `INFINITY21_JSMES`
- 검증 방식: `oracle-db` connector를 사용한 읽기 전용 dictionary 및 기준정보 조회
- 변경 여부: **DDL/DML 미실행**

## 요약 (결론 먼저)

- 지정된 개발 DB 연결은 성공했다.
- `OEE_*` 테이블은 현재 하나도 없다.
- `V_OEE_PLAN_TIME`, `V_OEE_LIVE`, `P_OEE_BUILD_SUMMARY`만 남아 있고 모두 `INVALID`다.
- INVALID 원문은 `ORA-00942: 테이블 또는 뷰가 존재하지 않습니다`다.
- 현재 코드의 `/oee/entry` 조회·저장 API는 이 DB에서 OEE 테이블 부재로 정상 동작할 수 없다.
- SMT는 실제 A~L 라인과 라인별 설비가 존재한다. 2층 조립은 조립 H/Y/A/D/B/K 라인이 존재하지만 조립 전용 설비·셀 매핑은 확인되지 않았다.
- 저장소의 OEE DDL과 시드에는 미확정 사유코드와 임시 근무시간이 포함되어 있어 이번 확인만으로 배포하지 않았다.

## 상세

### 1. OEE 객체 상태

| 객체 | 상태 | 확인 결과 |
|---|---|---|
| `OEE_RESOURCE` | 없음 | backend entity와 API가 참조하지만 DB table 부재 |
| `OEE_DOWNTIME_REASON` | 없음 | reason API가 참조하지만 DB table 부재 |
| `OEE_OPERATION_LOG` | 없음 | log API가 참조하지만 DB table 부재 |
| 기타 `OEE_*` table | 없음 | `user_tables` 조회 0건 |
| `V_OEE_PLAN_TIME` | INVALID | `ORA-00942` |
| `V_OEE_LIVE` | INVALID | `ORA-00942` |
| `P_OEE_BUILD_SUMMARY` | INVALID | `ORA-00942` |

저장소에는 `oracle_db_scripts/oee/01_tables.sql`부터 `06_proc_build_summary.sql`까지 배포 후보가 있다. 그러나 `02_seed_reason.sql`의 사유 7건은 실무 미확정이고, `03_tables_ext.sql`은 SMT 근무시간을 `08:30~17:30`, `20:30~05:30`으로 임시 시드한다. 실제 DB의 `ICOM_WORKTIME_RANGES`는 `SMTWORKTIME`과 `WORKTIME`을 A~J 구간으로 관리하므로 그대로 배포하기 전에 데이터 계약을 다시 설계해야 한다.

### 2. SMT 리소스 근거

`IP_PRODUCT_LINE`에서 조직 1의 SMT 계열은 A~L 라인(`01`~`12`)과 `SMT1`, `SMT2`, `OFFLINE`이 확인됐다. A~H 라인은 `DAY_START_TIME=0830`, `NIGHT_START_TIME=2030`을 보유하고 I~L 및 SMT1/2는 해당 시각이 비어 있다.

`IMCN_MACHINE`에는 라인별 MARKER, SCREEN PRINTER, SPI, MOUNTER, REFLOW, AOI, NG BUFFER 등 실제 설비가 연결되어 있다. 예를 들어 A라인은 다음 식별자를 가진다.

| 설비 | `MACHINE_CODE` | `WORKSTAGE_CODE` |
|---|---|---|
| SCREEN PRINTER | `HIT-188E03` | `W020` |
| SPI | `PMX12-018` | `W030` |
| MOUNTER 1 | `CV0648-J5` | `W040` |
| REFLOW | `1014Q3-B7N8S-38272-02` | `W050` |
| AOI | `17090805-0434` | `W060` |

따라서 SMT OEE 리소스는 모바일 초기 범위에서 **라인 단위**로 정의하고, 설비 스캔값은 라인을 찾는 보조 식별자로 사용할 수 있다. 개별 설비 OEE까지 확장하려면 하나의 라인에 여러 설비가 있는 상태에서 가동구간과 생산수량을 어떤 설비에 귀속할지 별도 계약이 필요하다.

### 3. 2층 조립 리소스 근거

`IP_PRODUCT_LINE`에는 다음 조립 라인이 있다.

| `LINE_CODE` | `LINE_NAME` | `LINE_DIVISION` |
|---|---|---|
| `34` | 조립 H라인 | `W` |
| `35` | 조립 Y라인 | `W` |
| `36` | 조립 A라인 | `W` |
| `37` | 조립 D라인 | `W` |
| `38` | 조립 B라인 | `W` |
| `39` | 조립 K라인 | `W` |

반면 `IP_PRODUCT_WORKSTAGE`는 조직 1 데이터가 0건이며, 조회한 `IMCN_MACHINE`에서는 조립 34~39 라인에 연결된 설비가 확인되지 않았다. 2층 설비로 직접 확인되는 행은 ICT 1~4호기(`ICT01`~`ICT04`)이며 라인 26~29에 연결된다.

따라서 조립 OEE MOBILE은 현재 **조립 라인 단위**로 설계한다. `셀/설비` 명칭과 식별자는 실제 기준정보가 추가되거나 별도 원천이 확인되기 전에는 만들지 않는다.

### 4. 근무시간 근거

`ICOM_WORKTIME_RANGES`에는 조직 1 기준 다음 데이터가 존재한다.

- `SMTWORKTIME`: A~J 10개 구간, `08:30`부터 다음날 `08:30`까지
- `WORKTIME`: A~J 10개 구간, `08:30`부터 다음날 `08:30`까지
- `MAIN LINE TARGET`: A~E 5개 구간

기존 OEE 스펙의 단순 `DAY/NIGHT` 2교대와 실제 A~J 작업구간의 관계는 아직 정의되지 않았다. MOBILE 화면에서 교대를 사용자가 임의 선택하거나 `netLoadMinutes=480`을 기본값으로 저장하면 안 된다. 서버가 실제 근무시간 데이터로 업무일·현재 구간·계획가동시간을 결정하도록 계약해야 한다.

### 5. 현재 결정

- 개발 DB profile은 후속 Oracle 검증의 기준 접속으로 사용한다.
- OEE DDL/DML은 실제 사유코드, 리소스 생성 규칙, 근무시간 변환 규칙을 승인한 뒤 배포한다.
- planner에는 SMT와 조립 모두 라인 단위를 확정 근거로 전달한다.
- 생산수량 원천과 작업자 사번 조회 원천은 추가 DB 조사 항목으로 남긴다.
- 구현 완료 판정은 OEE schema 배포 후 실제 API와 렌더 데이터까지 확인해야 한다.

## 후속 조치

1. `luna_planner` 요구사항·화면설계에 이 DB 검증 결과를 반영한다.
2. Coach가 OEE 최소 스키마, reason seed, resource seed, 근무시간 변환 계약을 설계한다.
3. DDL/DML 실행 전 배포 대상과 seed 값을 다시 검토한다.
4. 배포 시 객체 상태, table row count, API 결과를 pre/post로 기록한다.
