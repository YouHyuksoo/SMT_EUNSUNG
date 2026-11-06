-- =====================================================================
-- 2026-10-13 공정폐기(IP_PRODUCT_WORK_QC, QC_INSPECT_HANDLING='D')에 부서코드 칸 추가 — ESDB 적용
--
-- 공정폐기 등록 시 폐기를 낸 부서(ISYS_DEPARTMENT.DEPARTMENT_CODE)를 함께 남긴다.
-- 기존 행은 NULL 그대로 둔다. 컬럼명·길이는 다른 테이블의 DEPARTMENT_CODE VARCHAR2(20) 과 맞췄다.
-- 사용처: apps/backend/src/modules/quality/services/product-destroy.service.ts
-- =====================================================================

ALTER TABLE IP_PRODUCT_WORK_QC ADD (DEPARTMENT_CODE VARCHAR2(20));
/
COMMENT ON COLUMN IP_PRODUCT_WORK_QC.DEPARTMENT_CODE IS '부서코드 (ISYS_DEPARTMENT, 공정폐기 등록 부서)';
/

-- 되돌리기
-- ALTER TABLE IP_PRODUCT_WORK_QC DROP (DEPARTMENT_CODE);
