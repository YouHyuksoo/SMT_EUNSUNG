# OEE 기준 메뉴 이동 설계

## 목적

OEE 관리에 있는 기준정보성 메뉴 세 개를 기준정보 카테고리로 이동하여 업무 성격에 맞게 탐색할 수 있도록 한다.

## 대상 메뉴

| 메뉴 | 메뉴코드 | 기존 경로 |
|---|---|---|
| 표준시간관리 | `OEE_MST_STD_TIME` | `/oee/master/standard-time` |
| 설비비가동 사유코드 | `OEE_MST_IDLE_REASON` | `/oee/master/idle-reason` |
| 설비별 비가동 사유 연계 | `OEE_MST_EQUIP_REASON` | `/oee/master/equip-reason-map` |

## 승인된 설계

- 세 메뉴는 `OEE` 카테고리에서 제거하고 `MASTER` 카테고리로 이동한다.
- 기준정보 내 배치 순서는 다음과 같다.
  1. 설비마스터
  2. 표준시간관리
  3. 설비비가동 사유코드
  4. 설비별 비가동 사유 연계
  5. 공정관리
- 메뉴코드, 번역 키, URL은 변경하지 않는다. 기존 RBAC 권한과 직접 URL을 그대로 유지한다.
- 화면 컴포넌트, API, 서비스, Oracle 테이블과 데이터는 변경하지 않는다.
- `apps/frontend/src/config/menuConfig.ts`만 메뉴 구조의 원본으로 수정한다.
- 백엔드 메뉴 시드, 코드 검증 목록, 기본 카테고리 배치는 기존 `gen:menu` 생성기로 갱신하며 생성 파일을 직접 편집하지 않는다.

## 검증

- 구조 테스트에서 세 메뉴가 `MASTER`의 설비마스터와 공정관리 사이에 지정 순서로 존재하는지 확인한다.
- 같은 테스트에서 세 메뉴가 `OEE` 자식 목록에는 남지 않았는지 확인한다.
- 각 메뉴의 코드, 번역 키, URL이 기존 값과 동일한지 확인한다.
- `pnpm --filter @eunsung/frontend test`로 프론트 메뉴와 백엔드 생성물이 동기화되는지 확인한다.
- `pnpm --filter @eunsung/frontend typecheck`로 페이지·메뉴 등록과 타입을 검증한다.

## 제외 범위

- 메뉴코드를 `MST_*` 형식으로 변경하거나 권한 데이터를 이관하는 작업
- URL을 `/master/*`로 이전하는 작업
- 화면 제목이나 내부 기능 변경
- OEE 관련 테이블·API·데이터 변경
