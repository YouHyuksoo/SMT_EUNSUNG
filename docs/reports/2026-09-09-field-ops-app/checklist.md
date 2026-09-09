# 체크리스트 — 현장 설비 운영 및 실적관리

## 백엔드
- [x] `work-result` 목록에 `itemName`(ID_ITEM.ITEM_NAME) 추가
- [x] 목록에 `machineCode` 필터 파라미터 추가 (DTO·서비스·컨트롤러)
- [x] 작업자 목록 API 확인 — 사번·이름·부서 반환 여부

## 공용 컴포넌트 추출
- [x] 실적 등록 폼을 `components/shared`로 추출
- [x] 기존 `equip-work-result`가 추출본을 쓰도록 교체 (슬라이드 패널 유지)
- [x] 기존 화면 회귀 확인 (실적 조회·저장·완료 잠금)

## 신규 화면
- [x] `/oee/field-ops` page.tsx + 하위 컴포넌트
- [x] 상단: 라인/설비 선택 + 바코드 + 작업자 콤보
- [x] 좌: 당일 지표 (기존 DailyMetrics 재사용)
- [x] 중: 비가동 대상 설비 + 원인설비 체크 + [이력보기] 팝업
- [x] 우: 작업실적 관리 — 날짜(당일) + 조회 + 2줄 그리드 + 하단 고정 버튼
- [x] 작업 실적 등록 Modal 연결 (작업자 기본값 주입)
- [x] 자동갱신·상단 조회 제거 확인

## 등록·i18n
- [x] `menu-config.json` OEE 맨 뒤에 `OEE_FIELD_OPS`
- [x] 메뉴 시드/권한 반영
- [x] i18n ko/en/vi/zh
- [x] pageRegistry 생성 결과 확인

## 검증
- [x] 프론트 `tsc --noEmit` · `pnpm test`(생성기+전수검증 포함)
- [x] 백엔드 `tsc --noEmit` · work-result/equip-ops 스펙
- [x] 원격 팀 메뉴 sortOrder 테스트 미영향 확인
- [x] 실제 화면 확인 (비가동 시작/종료 · 실적 등록 · 이력보기)
