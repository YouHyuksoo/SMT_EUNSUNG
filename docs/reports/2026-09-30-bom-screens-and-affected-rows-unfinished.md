# 원단위BOM·제조BOM 이관과 영향 행수 결함 수정 — 미완료 검증 기록 (2026-09-30)

## 한 일 (커밋 전)

- **원단위BOM마스터** `w_des_raw_bom_master` → `/bom/raw-bom` (메뉴 `BOM_RAW`): 조회·수정·순환 검사(CONNECT BY NOCYCLE, 작업 테이블 없음).
- **제조BOM관리** `w_des_mfs_bom_master` → `/bom/mfs-bom` (메뉴 `BOM_MFS`): 모델 → MFS 목록 → 상세·피더 레이아웃, 생성(PKG_DESIGN.BOM_QUERY/_ALL)·삭제·복사·승인·승인취소·전체 사용/미사용.
  PB 결함 보완: 승인된 MFS 생성·삭제 차단, 복사 대상 중복 차단, 승인취소 전체 적용, PCB 면 갱신에 조직 조건 추가.
- **영향 행수 결함:** TypeORM(Oracle) `query()` 는 DML 결과로 행수 숫자(0행은 undefined)를 돌려주는데 38개 서비스가 `result.rowsAffected` 로 읽어 항상 0 이 됐다.
  ESDB 실측(1행 UPDATE → `1`, `.rowsAffected` → undefined, 롤백). `common/utils/affected-rows.util.ts` 의 `affectedRows()` 로 83곳 + 1곳 치환.

## 검증한 것

- 프론트·백엔드 tsc 통과, 프론트 등록 검사 통과, 백엔드 jest 16 스위트 97개 + 헬퍼 3개 통과.
- ESDB 에서 원단위BOM 목록·순환 검사 SQL, 제조BOM 생성·복사 흐름(롤백 트랜잭션) 실행.

## 확인 못 한 것

- 로컬 백엔드가 외부 DB 주소로 붙어 현장 로컬망에서 DB 에 닿지 않아 **API 호출·화면 렌더를 확인하지 못했다.**
- 영향 행수 수정으로 저장 경로가 실제로 통과하는지(지그·창고·공정수불·포장·구매·SMT 등)는 서버에서 확인해야 한다.
- 원단위BOM 수정(UPDATE), 제조BOM 삭제·승인취소·사용여부 UPDATE 는 DB 에서 실행하지 않았다.
- ESLint 는 설치 문제(`@eslint/eslintrc/universal`)로 실행 불가.

다음 세션은 백엔드가 DB 에 붙는 환경에서 위 저장 경로와 두 화면을 실제로 확인한다.
