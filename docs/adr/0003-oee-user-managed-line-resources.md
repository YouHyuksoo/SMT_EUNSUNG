# 0003. OEE 사용자 관리형 LINE/CELL 리소스

- 결정일: 2026-08-21
- 상태: 승인
- 대상: OEE 리소스 관리, 모바일 입력, 대시보드, Oracle OEE 리소스
- 대체 결정: `0002-oee-confirmed-line-resources.md`

## 배경

`0002`는 SMT `01~12`, ASSY `19~24`를 모두 LINE으로 고정하고 배포 seed와 모바일 코드가 같은 목록을 강제했다. 이 구조에서는 현장 관리자가 OEE 대상 라인과 공정·유형을 바꿀 수 없고, 모바일 입력과 대시보드의 기준이 서로 다른 경로로 관리된다.

OEE 대상은 원천 라인 마스터를 변경하지 않고 별도 OEE 리소스로 선택·관리해야 한다. 공정과 유형도 라인코드로 추론하지 않고 등록 시 사용자가 결정한다.

## 결정

1. OEE 리소스의 원천은 인증 조직의 `IP_PRODUCT_LINE`으로 유지한다.
2. OEE 대상 여부는 `OEE_RESOURCE` 등록 여부로 결정한다.
3. 등록 시 사용자가 `PROCESS_CODE`를 `SMT` 또는 `ASSY` 중에서 선택한다.
4. 등록 시 사용자가 `RESOURCE_TYPE`을 `LINE` 또는 `CELL` 중에서 선택한다.
5. LINE과 CELL 모두 `OEE_RESOURCE.REF_CODE = IP_PRODUCT_LINE.LINE_CODE`로 연결한다.
6. 별도 CELL 부모 마스터가 없으므로 모바일 `PARENT_LINE_CODE`는 `REF_CODE`와 동일하게 사용한다.
7. 같은 조직의 한 `LINE_CODE`는 하나의 OEE 리소스로만 등록한다.
8. 모바일 목록·입력 검증과 대시보드 계산은 활성 `OEE_RESOURCE`를 공통 기준으로 사용한다.
9. 근무시간은 유형이 아니라 공정으로 결정한다. SMT는 `SMTWORKTIME`, ASSY는 `WORKTIME`을 사용한다.
10. 리소스 제외는 `OEE_RESOURCE` 물리 삭제로 처리하되, 실적·계획·요약·가동일지·비가동 이벤트가 하나라도 있으면 삭제와 공정·유형 변경을 거부한다.
11. `IP_PRODUCT_LINE`은 조회만 하며 OEE 등록·수정·삭제 과정에서 변경하지 않는다.
12. 고정 18개 리소스 seed는 routine deployment에서 제거하고 one-time manual bootstrap으로만 보존한다.

## 결과

- 기존 SMT 12건과 ASSY 6건은 현재 등록 데이터로 유지되지만 더 이상 코드나 routine seed가 고정 범위를 강제하지 않는다.
- 관리 화면에서 라인을 선택하고 SMT/ASSY, LINE/CELL을 직접 지정한다.
- `UNIQUE (ORGANIZATION_ID, REF_CODE)`가 라인당 한 건 계약을 강제한다.
- `V_OEE_PLAN_TIME`은 SMT/ASSY의 LINE/CELL을 모두 계획시간 대상으로 포함한다.
- 모바일에서 삭제·비활성·타 조직·원천 라인 누락 리소스를 선택하거나 입력할 수 없다.
- 이력이 있는 리소스는 물리 삭제할 수 없으므로 과거 이벤트와 OEE 계산 연결이 보존된다.
