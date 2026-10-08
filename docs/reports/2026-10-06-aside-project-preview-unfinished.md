# Aside 프로젝트 실행 — 미완료 기록

- 요청: 은성 MES를 실행해 Aside에서 표시.
- 실행: 저장소 루트에서 `pnpm dev`. 서버 프로세스는 유지 중.
- 최초 실패: `PLN_WIP_STOCKTAKE`의 pbEvidence 서비스 파일에 `w_mat_workstage_inventory_check_master` 문자열이 없어 predev 검증 중단.
- 수정: PB 원본 SRW의 실사표 및 공정출고 참조를 확인한 뒤 서비스 헤더에 PB 원본 경로 한 줄 추가. 업무 로직 변경 없음.
- 재실행: 페이지 등록, PB 연결 계약, 팝업 및 함수 카탈로그 검증 통과. shared 및 backend 컴파일 오류 0건.
- 프론트: 4010 LISTEN 및 `GET http://localhost:4010` HTTP 200 확인.
- 백엔드: 최종 확인에서 4003 LISTEN 확인. API 및 DB 정상 동작은 미검증.
- Aside: MCP listBrowserTabs는 빈 목록 반환. openTab에서 `The task browser window is no longer available in its original browser mode. Reopen the task in the intended window.` 오류. 대체 브라우저나 새 실행 파일은 사용하지 않음.
- 다음 확인: Aside 작업 창 연결 복구 후 4010 화면 렌더 확인, 백엔드 로그와 4003 포트 상태 확인.
