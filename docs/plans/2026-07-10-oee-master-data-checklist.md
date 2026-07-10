# OEE 기준정보관리 개발 체크리스트

플랜: `docs/plans/2026-07-10-oee-master-data-development-plan.md`

## Phase 0 — 발견/정비
- [ ] `IMCN_MACHINE` 위치(라인/셀/plant) 컬럼 실측 → verify: 컬럼 목록 문서화
- [ ] 기존 라우팅 버전 컬럼(`VALID_FROM/TO`) 유무 확인 → verify: 있으면 규칙 일치 확인
- [ ] 산재 `STD_TIME` 3곳(`ROUTING_PROCESSES`·`PROCESS_MAPS`·`PROCESS_CAPAS`) 정본 확인 → verify: 어느 값이 실사용인지 판정
- [ ] `IP_PRODUCT_LINE` → `PLANTS` LINE 시드승격 스크립트(`LINE_CODE`+`ORGANIZATION_ID`) → verify: 전 라인 노드 생성
- [ ] `PLANTS` 후공정 셀 실분할 현장 협의 → verify: 셀 목록 확정
- [ ] 공통 버전 유틸(as-of 선택, 겹침 검증) 뼈대 → verify: 단위테스트 통과

## Phase 1 — 트레이서: CT/ST/SETUP
- [ ] CT/ST/SETUP 행-버전 스키마 생성 + 마이그레이션 → verify: 스키마 배포, 백필 검증
- [ ] as-of 조회 서비스 적용 → verify: 임의 기준일 유효행 정확 조회 테스트
- [ ] 기간 겹침 검증 + 직전 버전 자동 절단 → verify: 겹침 저장 차단 테스트
- [ ] CT/ST 검증기 레지스트리 등록 → verify: 미등록 시 issue 반환 테스트
- [ ] 준비도 화면 CT/ST 탭 → verify: 미등록 신모델이 목록에 노출
- [ ] **Phase 1 완료 게이트**: end-to-end 시나리오 테스트 통과

## Phase 2 — 버전형 확장
- [ ] 라우팅 버전화 + as-of 적용 → verify: 미경유 공정 분모 제외 확인
- [ ] 월력 버전화 → verify: 휴일 OEE 0% 오산출 방지
- [ ] 근무시간표 버전화 → verify: 부하시간 = 근무 − 계획정지 산출
- [ ] 라인/셀·설비 매핑(신규) → verify: 설비→PLANTS 노드 매핑, 누락 검증
- [ ] `oee_resource` → PLANTS 참조+매핑 이관 → verify: `oee/entry`·`oee/dashboard` 회귀 테스트

## Phase 3 — 단순형 보강 + 통합
- [ ] 공정·설비·모델·무작업사유코드 마감검증 훅 + 공통 컬럼 → verify: 검증기 등록
- [ ] 준비도 화면 전체 기준정보 통합 → verify: 전 항목 심각도 표시

## Phase 4 — 마이그레이션 마감
- [ ] 전 버전형 `VALID_FROM/TO` 백필 → verify: NULL 없음
- [ ] PLANTS 라인/셀 실데이터 확정 + 매핑 초기 적재 → verify: 준비도 화면 무오류
