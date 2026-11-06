-- =====================================================================
-- 2026-10-15 라인그룹 공통코드 (ISYS_BASECODE 'LINE CODE GROUP') — ESDBext 적용
--
-- 생산라인관리(/master/prod-line)의 라인그룹(IP_PRODUCT_LINE.LINE_CODE_GROUP)을 공통코드로 보여주고 고른다.
-- 이 코드형이 없어 화면이 코드값을 그대로 보여주고 자유 입력을 받았다.
-- 값은 지금 라인에 쓰인 5개 그대로다 (적용 전 실측: SMD 16 · SUB 17 · ASM 15 · INSP 7 · COMMON 1).
-- =====================================================================

INSERT INTO ISYS_BASECODE
  (CODE_TYPE, CODE_NAME, ORGANIZATION_ID, CODE_MEAN_KOR, CODE_MEAN_ENG, CODE_MEAN_LOCAL, CODE_GROUP,
   ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY)
SELECT 'LINE CODE GROUP', s.code, 1, s.kor, s.eng, s.eng, 'SYSTEM', SYSDATE, 'ADMIN', SYSDATE, 'ADMIN'
  FROM (SELECT 'SMD' code, 'SMD' kor, 'SMD' eng FROM DUAL
        UNION ALL SELECT 'SUB', '서브', 'SUB' FROM DUAL
        UNION ALL SELECT 'ASM', '조립', 'ASSEMBLY' FROM DUAL
        UNION ALL SELECT 'INSP', '검사', 'INSPECTION' FROM DUAL
        UNION ALL SELECT 'COMMON', '공용', 'COMMON' FROM DUAL) s
 WHERE NOT EXISTS (SELECT 1 FROM ISYS_BASECODE b
                    WHERE b.CODE_TYPE = 'LINE CODE GROUP' AND b.CODE_NAME = s.code AND b.ORGANIZATION_ID = 1)
/
COMMIT
/
