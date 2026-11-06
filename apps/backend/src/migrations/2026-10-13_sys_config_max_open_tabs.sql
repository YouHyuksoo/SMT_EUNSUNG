-- =====================================================================
-- 2026-10-13 시스템 환경설정(ISYS_CONFIG)에 최대 탭 수(MAX_OPEN_TABS) 추가 — ESDB 적용
--
-- 프론트 탭바는 MAX_OPEN_TABS 를 읽고, 없으면 코드 기본값 10 을 쓴다
-- (apps/frontend/src/stores/tabStore.ts DEFAULT_MAX_TABS). 키가 DB 에 없어서
-- 환경설정 화면에 나오지 않았다. 기본값과 같은 10 으로 넣는다. (멱등)
-- =====================================================================

MERGE INTO ISYS_CONFIG t
USING (SELECT 'MAX_OPEN_TABS' AS CONFIG_NAME, 1 AS ORGANIZATION_ID FROM DUAL) s
ON (t.CONFIG_NAME = s.CONFIG_NAME AND t.ORGANIZATION_ID = s.ORGANIZATION_ID)
WHEN NOT MATCHED THEN
  INSERT (CONFIG_NAME, ORGANIZATION_ID, CONFIG_DESCRIPTION, CONFIG_VALUE, CONFIG_VALUE_DESCRIPTION,
          ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY, USE_YN)
  VALUES (s.CONFIG_NAME, s.ORGANIZATION_ID, '최대 탭 수', '10', '한 번에 열 수 있는 화면 탭 개수',
          SYSDATE, 'SYSTEM', SYSDATE, 'SYSTEM', 'Y');
/
