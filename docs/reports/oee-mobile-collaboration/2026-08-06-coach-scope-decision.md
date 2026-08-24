# OEE MOBILE Coach 범위 결정 체크포인트

- 작성일: 2026-08-06
- 기록 시각: 2026-08-06 09:54 KST
- 작성 계기: Master가 MOBILE의 목적과 Coach 주도 협업·보고 방식을 확정함
- 브랜치: `tech1_oee_mobile1`
- 기준 커밋: `3b90360`
- Orca Run: `run_a4ec6d89786b`
- 전체 상태: **범위 재고정 완료, 요구사항·화면설계 재위임 준비**

## 요약 (결론 먼저)

- PDA와 태블릿을 모두 `MOBILE`로 통일한다.
- 대상은 10인치 Android 가로 화면에서 사용하는 1층 SMT·2층 조립공정 OEE 현장입력이다.
- 기존 `/oee/entry`를 canonical MOBILE route로 결정한다.
- `/oee/equip-downtime-mobile`은 스캔 경험을 참고할 Mock일 뿐 별도 제품·API 계약으로 확장하지 않는다.
- Coach가 범위와 설계 대상을 결정하고 `luna_planner` 요구사항·화면설계 → Coach 승인 → `lunar_impl` TDD 구현 순서로 진행한다.
- Master에게 오전·오후·저녁 최소 3회와 주요 결정 게이트마다 진행상황을 기록한다.

## 상세

### 1. 이전 체크포인트 정정

`2026-08-04-initial-coordination.md`는 `/oee/equip-downtime-mobile`만 직접 모바일 근거가 있고 `/oee/entry`는 모바일 범위 밖이라고 판정했다. 최신 Master 지시와 다음 근거에 따라 이 판정은 이번 체크포인트로 supersede한다.

| 근거 | 확인 내용 |
|---|---|
| `docs/specs/2026-07-06-oee-management-design.md:239-265` | `/oee/entry`를 태블릿 핵심 입력으로 명시하고 작업자 스캔, 가동·비가동 일지, 생산수량, 공유 검증을 요구한다. |
| `apps/frontend/src/app/(authenticated)/oee/entry/page.tsx:35-149` | 리소스·사유 조회, 근무조 로그 로드·저장, 작업자 사번, 공유 검증이 실제 연결되어 있다. |
| `apps/backend/src/modules/oee/oee.controller.ts:66-81` | 근무조 가동일지 조회·저장 API가 존재한다. |
| `apps/frontend/src/app/(authenticated)/oee/equip-downtime-mobile/page.tsx:15-34,136-140` | 설비·사유가 로컬 샘플이고 저장은 React 상태와 toast만 변경한다. |
| `docs/presentations/2026-07-10-inventory-oee-visual-review.html:2214-2265` | 현장 흐름은 사번·설비 스캔, 비가동 시작, 사유, 선택 메모, 종료다. |

따라서 두 route를 각각 제품화하면 작업자 흐름, 상태 용어, 저장 계약과 메뉴가 중복된다. canonical `/oee/entry`에 Mock의 유효한 스캔 UX만 통합하는 것이 최소 변경이다.

### 2. 확정 범위

| 구분 | 결정 |
|---|---|
| 사용자 | 1층 SMT와 2층 조립공정의 현장 작업자 |
| 기기 | 10인치 Android, 가로 화면 가정 |
| route | `/oee/entry` |
| 핵심 흐름 | 사번 식별 → 공정·라인/셀 확인 → 리소스 스캔/선택 → 비가동 시작 → 사유 → 선택 메모 → 종료 |
| 저장 | 인증된 백엔드 API, 서버 시각, 중복 방지, 성공 후 상태 확정 |
| 네트워크 | 온라인 우선, 실패 시 초안 유지·재시도. 오프라인 큐 제외 |
| 용어 | UI와 문서에서 `MOBILE` 사용. 상태 계약은 `RUN/DOWN` 기준으로 통일 검토 |

### 3. 제외 범위

- 재고·수불·실사 MOBILE
- OEE 대시보드와 손실 분석
- OEE 마감과 스냅샷 확정
- 리소스·사유·근무시간 기준정보 관리
- 설비 원격 제어 또는 긴급정지
- 검증되지 않은 오프라인 큐와 자동 동기화

### 4. 구현 전에 해소할 계약 격차

| 격차 | 현재 사실 | Coach 처리 |
|---|---|---|
| 인증·조직 | OEE 컨트롤러 전체가 `@Public()`이고 body의 `organizationId`를 사용 | Guard와 `@OrganizationId()` 계약 및 테스트 승인 후 구현 |
| 기록 시각 | 기존 `/oee/entry`는 사용자가 분 단위를 입력하고 Mock은 client 시각을 편집 가능 | 시작·종료 기본 흐름은 서버 KST 시각으로 설계 |
| 저장 모델 | 기존 API는 근무조 전체 DELETE+INSERT replace | 현장 이벤트 동시성 손실을 평가하고 별도 상태 전이 계약 여부 결정 |
| 리소스 키 | Mock은 `E01` 샘플, OEE는 `resourceId`와 `refCode`를 보유 | 실제 SMT 라인·조립 셀/설비 매핑을 Oracle로 검증 |
| 사유코드 | Mock `DWN-*`와 OEE reason master가 분리 | 승인된 OEE reason만 표시 |
| 생산수량 | 기존 설계에는 포함되지만 현재 `/oee/entry`에 없음 | 실제 수집 원천·책임자 확인 후 동일 화면 또는 후속 단계 결정 |
| 테스트 | shared 검증 테스트 외 OEE controller/service/UI focused test가 없음 | 계약별 red test를 구현 선행조건으로 지정 |

### 5. 협업 상태

| 역할 | 상태 | 다음 산출물 |
|---|---|---|
| Master | 최신 범위와 Coach 권한 확정 | 주요 게이트 확인 |
| Coach | 범위·canonical route·마일스톤 결정 | planner 결과 검토와 계약 결정 |
| `luna_planner` | 이전 PDF 체크리스트 Task 진행 중 | 체크리스트 완료 후 새 요구사항·화면설계 Task |
| `lunar_impl` | idle, Task 미배정 | 승인 설계와 acceptance criteria 대기 |

현재 PDF Task:

- Task: `task_692077188ac1`
- Dispatch: `ctx_5014cd661d7d`
- 상태: `dispatched`
- 용도: 설계 양식의 요구사항→설계 진입 체크리스트 추출
- 제한: 상세 OEE 화면설계나 코드 수정에 사용하지 않음

## 후속 조치

1. PDF 체크리스트 Task를 완료하고 결과를 설계 진입 게이트에 반영한다.
2. 최신 확정 범위로 `luna_planner` 요구사항·화면설계 Task를 생성한다.
3. planner가 제안한 route 내 화면 state/step 대상을 Coach가 명시 승인한다.
4. 상세 설계와 API·DB 계약을 Coach가 검토한다.
5. 구현 가능한 acceptance criteria가 고정된 뒤에만 `lunar_impl`에 TDD Task를 배정한다.
6. 실제 Oracle 데이터와 인증 API 경로까지 검증한 뒤 완료 처리한다.
