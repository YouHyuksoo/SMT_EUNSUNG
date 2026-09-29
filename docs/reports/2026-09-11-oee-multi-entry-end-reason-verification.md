# 다중입력 종료 사유 유지·변경 검증

- 작성일: 2026-09-11
- 계약: `docs/specs/2026-09-11-oee-multi-entry-end-reason-design.md`
- 상태: 구현·자동 테스트·실제 Oracle 서비스 경로·모의 API 브라우저 검증 완료. 실제 로그인 API부터 렌더까지의 연속 검증은 미완료.

## 구현

- 동일 기존 사유: 사유명과 `사유구분 · 사유코드` 표시, 오른쪽에 작업자변경과 유사한 별도 `사유변경` 버튼 배치.
- 서로 다른 사유가 모두 입력됨: 혼재 표시, 기존 사유를 각각 유지한 채 종료 가능.
- 일부 미입력: `미입력 사유 포함`, 공통 최종 사유 선택 전 종료 차단.
- 모두 미입력: `사유 선택`, 사유 선택 전 종료 차단.
- 대상 선택이나 실적 스냅샷 변경 후 이전 override를 적용하지 않는다. 표시용 기존 사유와 명시적 변경 선택을 분리했다.
- 기존 사유 유지 요청은 END body의 reasonCode를 생략한다. 새 선택 사유만 reasonCode로 전달한다.
- 백엔드는 모든 종료 대상을 잠그고 집합을 확인한 후 사유 유지/변경을 판정한다. 유지 경로에서 하나라도 blank면 DML 전 전체 거부한다.
- 유지 UPDATE는 REASON_CODE를 SET하지 않는다. 변경 UPDATE만 활성 사유 검증 및 전체 overwrite를 수행한다. 두 경로 모두 공통 종료 시각, 정확한 positional bind, 숫자 affected count, 전체 rollback 기준을 유지한다.
- null/blank/non-string 변경 사유 입력은 거부한다. DTO에서 implicit string 변환이 비문자열을 허용하지 않도록 원래 입력값을 검증한다.
- START의 선택 사유 입력 및 기존 모드 버튼/메뉴/복수 미종료/pending 확인 흐름은 유지한다.

## 데이터 및 실제 Oracle 검증

- 사전 read-only 확인: 기존 미종료10건은 QC01(품질 확인 대기 / UNPLAN / 활성)8건, EB01(설비 고장 / UNPLAN / 활성)2건.
- 프로필 EUNSUNG_DEV_ESDBPDB와 백엔드 환경 일치, thick client로 실제 서비스 SQL 실행.
- 기존 원장48건 및 기존 미종료03라인8건/22라인2건은 검증 중 수정하지 않았다.
- 전용 신규 행만 바깥 QueryRunner 트랜잭션에 생성하여 다음을 검사했다.
  - 사유 생략: 두 테스트 행의 서로 다른 QC01/EB01을 그대로 보존하고 응답에서도 일치.
  - 명시적 변경: 별도 두 테스트 행에 하나의 활성 사유를 공통 적용.
  - 사유 미입력: 잠금 후 유지 요청 거부, UPDATE 없음.
  - 설비 라인 대체 조회와 저장 LINE_CODE NULL 유지.
- 실제 Oracle UPDATE 반환값: 성공4회 모두 숫자1.
- 트랜잭션 중 원장 건수50 → 52 → 54, rollback 후 원래48건 복원. 새 테스트 행은 커밋하지 않았으며 시퀀스 NEXTVAL만 소비했다.
- 임시 재현 스크립트: `C:\Users\imarr\AppData\Local\Temp\opencode\oee-multi-entry-end-reason-live-verify-2026-09-11.cjs`.

## 자동 테스트

- backend 집중33개 통과, 전체 OEE164개/14 suites 통과.
- backend tsc, 대상 ESLint/Prettier 통과.
- frontend 페이지38개, batch12개, 전체 직접 구조 테스트99개 통과.
- frontend typecheck 통과: 38 pages / 35 menu leaves.
- 변경 frontend 파일 대상 ESLint 및 diff whitespace 검사 통과.
- RED 증거: optional DTO 계약, 유지/변경 SQL 차이, 서로 다른 사유 유지, 잠긴 행의 미입력 차단, 네 가지 요약 및 override 판정에 대한 실패를 확인한 뒤 구현했다.

## 모의 API 렌더 검증

기존 frontend3100과 격리된 시스템 Chrome을 사용했다. 모든 API는 fixture이며 실제 사용자 인증/DB와 연결된 화면 검증이 아니다.

- 4/4 시나리오 통과:
  1. 동일 사유의 이름/구분/코드, 별도 사유변경 버튼, 메뉴/전체화면 전환.
  2. 서로 다른 사유 유지 종료 POST에 reasonCode 없음.
  3. 일부 미입력 시 종료 차단, 선택 후 EB01 override 요청.
  4. 모두 미입력 시 차단, 대상 변경 후 override 해제.
- normal/full 캡처를 직접 확인했다.
- 임시 자료:
  - `C:\Users\imarr\AppData\Local\Temp\opencode\verify-oee-multi-entry-end-reasons.cjs`
  - `C:\Users\imarr\AppData\Local\Temp\opencode\oee-multi-entry-end-reason-normal.png`
  - `C:\Users\imarr\AppData\Local\Temp\opencode\oee-multi-entry-end-reason-full.png`

## 남은 검증

- 실제 로그인 세션에서 backend → frontend proxy → rendered UI의 데이터를 연속 대조해야 한다. 모의 인증과 직접 SQL 실행을 실제 인증 검증으로 보고하지 않는다.
- 실제 두 Oracle 세션의 동시성 실험은 기존과 같이 미실행이다.
- 전체 frontend lint에는 별도 기존 화면의 오류가 남아 있으며 이번 범위에서 수정하지 않았다.
