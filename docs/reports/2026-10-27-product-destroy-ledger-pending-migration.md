# 공정폐기 원장 이관 — 배포 후 재실행 대기 (미완료 기록)

- 작성: 2026-10-27
- 관련 커밋: `c98b650e` (공정폐기 원장), `173d8dc7` (제품 선입선출)
- 담당: 현장 담당자가 직접 실행한다 (사용자 결정 2026-10-27)

## 남은 일

`c98b650e`를 배포한 뒤 `apps/backend/src/migrations/2026-10-27_product_destroy_ledger.sql`을 ESDBext에 한 번 더 실행한다.

배포 전까지 운영 백엔드는 옛 코드라서 공정폐기를 `IP_PRODUCT_WORK_QC`(검사처리 D)에 쓴다. 다시 실행하면 그 사이에 쌓인 D 행만 `IP_PRODUCT_DESTROY`로 옮긴다. 원본 키(`SOURCE_SERIAL_NO`, `SOURCE_QC_SEQUENCE`)로 거르기 때문에 이미 옮긴 행은 다시 들어가지 않는다.

## 이미 끝난 것 (2026-10-27, ESDBext)

- 테이블 `IP_PRODUCT_DESTROY`, 시퀀스 `SEQ_IP_PRODUCT_DESTROY`, 인덱스 3개 생성 — 모두 VALID
- 공통코드 `DESTROY STATUS` 3건 (C 취소, D 폐기보관, R 반품)
- 옛 폐기 821건 이관 — 폐기보관 680, 반품 141, 수량 합 824 (원본과 같음). 재실행해도 821건 그대로
- `ISYS_CONFIG.PRODUCT_FIFO_YN = N` 추가 (`2026-10-27_product_fifo_config.sql`)

## 재실행 뒤 확인

```sql
-- 두 값이 같아야 한다
SELECT (SELECT COUNT(*) FROM IP_PRODUCT_WORK_QC WHERE QC_INSPECT_HANDLING = 'D') AS QC_D,
       (SELECT COUNT(*) FROM IP_PRODUCT_DESTROY WHERE SOURCE_QC_SEQUENCE IS NOT NULL) AS MOVED
  FROM DUAL;
```

## 참고

- PB 공정폐기 화면을 현장에서 계속 쓰면, 그 등록분은 계속 `WORK_QC`에만 들어간다. 사용 여부는 아직 확인하지 못했다.
