# OEE 다중입력 사유구분 실데이터 검증 미완료 기록

- 작성일: 2026-08-28
- 작성 계기: `OEE_MULTI_ENTRY`의 ON/OFF 표시와 `OEE_MST_IDLE_REASON` 기반 사유 그룹 구현 후 인증 API 및 렌더 검증 상태 기록

## 요약 (결론 먼저)

- 구현, 백엔드 OEE 테스트 120건, 프론트 구조 테스트 82건, 양쪽 typecheck는 통과했다.
- Oracle `IP_EQUIP_DOWNTIME_REASON`에서 조직 1의 활성 사유 10건(`PLAN` 6건, `UNPLAN` 4건)을 확인했다.
- 작업 중 인증된 MES Chrome 탭이 다른 Chrome 프로필로 전환되어 `GET /api/v1/oee/mobile/reasons`의 인증 응답과 변경 후 최종 화면 렌더는 확인하지 못했다.

## 상세

- 대상 화면: `/oee/multi-entry`
- 기대 API 계약: `reasonCode`, `reasonName`, `reasonType`, `displayOrder`
- 기대 화면: 작업장 선택 다음 ON/OFF 모드, 기존 가능 리소스 전체 선택 유지, 계획/비계획 그룹별 2행 사유 카드
- Oracle 확인 결과:
  - `PLAN`: 6건
  - `UNPLAN`: 4건
  - 모든 확인 행은 `ORGANIZATION_ID = 1`, `USE_YN = 'Y'`
- 실행 완료:
  - `pnpm --filter @eunsung/backend test -- --runInBand src/modules/oee`
  - `pnpm --filter @eunsung/backend exec tsc --noEmit --pretty false`
  - `pnpm --filter @eunsung/frontend test`
  - `pnpm --filter @eunsung/frontend typecheck`

## 후속 조치

1. 인증된 브라우저에서 `/oee/multi-entry`를 새로고침한다.
2. `GET /api/v1/oee/mobile/reasons` 응답이 계획 6건, 비계획 4건이며 표시순서대로 반환되는지 확인한다.
3. 작업장 선택이 ON/OFF보다 먼저 노출되고 기존 `가능 리소스 전체 선택`이 유지되는지 확인한다.
4. 가동 리소스를 선택해 계획/비계획 그룹, 사유명·코드 2행 카드, 다열 배치와 선택 후 요약 접기를 확인한다.
5. 확인 후 이 기록을 완료 근거로 대체하지 말고 실제 API 응답 건수와 렌더 결과를 작업 보고에 남긴다.
