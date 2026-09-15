# 다중입력 현재 상태 확인 완료 검증

- 작성일: 2026-09-10
- 승인 계약: `docs/specs/2026-09-10-oee-multi-entry-pending-confirmation-design.md`
- 상태: 승인된 잠금 해제 구현 및 모의 API 브라우저 검증 완료. 실제 인증 API·Oracle 연계 렌더 검증은 계속 미완료.

## 반영 내용

- 모든 pending 대상의 최신 GET 상태 조회가 성공해야 `현재 상태 확인 완료` 버튼 활성화.
- 미조회, 일부 실패, 조회 중, 오프라인, 제출 중에는 비활성화.
- pending 객체·인증 저장소 키·조회 generation을 확인하여 늦은 응답 차단.
- 확인 시 저장소 삭제 성공 후 메모리 잠금 해제. 삭제 실패 시 오류 표시 및 잠금 유지.
- 최신 조회 상태를 선택 카드에 반영하고 기존 선택·사유·메모·결과를 초기화. 기존 일반 상태 조회 generation도 무효화하여 늦은 응답이 확인한 상태를 덮어쓰지 않도록 처리.
- 해제 동작에서 POST 없음. 이전 불명확한 명령을 성공 처리하지 않음.
- 한국어/영어/베트남어/중국어 문구 반영.
- 7인치 1024×600에서 확인 버튼이 viewport 밖에 놓이는 문제를 렌더 검사로 발견하여 pending 안내를 지표 앞에 배치하고 내부 내용을 세로로 정렬했다.

## 검증 결과

- canConfirmPendingSubmission 구현 전 실패 → 구현 후 통과.
- 늦은 일반 조회 응답 무효화 구조 회귀 검사 실패 → 수정 후 통과.
- 프론트 전체 테스트: 90개 통과.
- 프론트 typecheck 및 변경 파일 대상 ESLint 통과.
- `git diff --check` 통과.

### 실제 브라우저 + 모의 API

기존 프론트 서버 3100을 사용했다. 설치된 시스템 Chrome을 Playwright로 headless 실행하고 새 격리 컨텍스트를 사용했다. 사용자 Chrome 프로필 및 실제 인증 세션은 사용하지 않았다. `/api/**`는 모두 모의 응답으로 가로챘으며 백엔드 인증을 우회하거나 DB에 데이터를 쓰지 않았다.

| 검사 | 결과 |
|---|---|
| 전체 대상 조회 성공 → 확인 버튼 → 잠금 해제 | 통과. POST 0회, 저장소 삭제, 잠금 제거, 상태 카드 표시 |
| 일부 대상 조회 실패 | 통과. 확인 버튼 비활성화, pending 유지, POST 0회 |
| 실패 후 최신 GET 재조회 성공 | 통과. 확인 버튼 활성화, POST 0회 |
| 저장소 removeItem 실패 | 통과. 오류 표시, 저장소 및 잠금 유지, POST 0회 |

- 임시 검증 스크립트: `C:\Users\imarr\AppData\Local\Temp\opencode\verify-oee-pending-confirmation.cjs`
- 7인치 캡처: `C:\Users\imarr\AppData\Local\Temp\opencode\oee-multi-entry-confirmation-7in.png`
- 10인치 캡처: `C:\Users\imarr\AppData\Local\Temp\opencode\oee-multi-entry-confirmed-10in.png`
- 위 파일은 로컬 임시 검증 자료이며 저장소 배포 산출물이 아니다.

## 남은 검증

이전 `2026-09-10-oee-multi-entry-batch-verification.md`의 미확정 잠금 해제 방식은 이번 사용자 승인 및 구현으로 해결했다. 다만 모의 API 브라우저 검증을 실제 인증 데이터 검증으로 간주하지 않는다.

- 실제 로그인 세션에서 인증 백엔드 → 프론트 프록시 → 10인치/7인치 화면의 데이터를 대조해야 한다.
- 실제 두 Oracle 세션 동시 요청 실험은 미실행이다.
- 전체 프론트 lint의 기존 별도 파일 오류는 이번 범위에서 수정하지 않았다.
