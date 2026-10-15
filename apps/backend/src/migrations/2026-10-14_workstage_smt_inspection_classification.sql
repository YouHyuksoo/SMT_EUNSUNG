-- =====================================================================
-- 2026-10-14 공정관리 마스터(IP_PRODUCT_WORKSTAGE) 공정 분류 — ESDBext 적용 완료
--
-- 설비별 작업 실적관리(/oee/equip-work-result)는 실적을 넣는 후공정만 다룬다.
-- SMT 공정(공정그룹 SMT)과 검사공정(공정유형 Q)은 화면에서 뺀다 — 사용자 확정(2026-10-14).
-- 적용 전: 34건 모두 WORKSTAGE_TYPE='I', WORKSTAGE_CODE_GROUP='N'.
-- 적용 후: I/N 14 · I/SMT 15 · Q/PBA 5. 새 INVALID 객체 없음.
--
-- 참고: DB 인터락(P_INTERLOCK_SET_CHECK_DATA, F_GET_INTERLOCK_CHECK_ACTIVE 등)은 공정유형이
--       'REFLOW'·'SPI'·'ICT'·'AOI'·'MAGAZINE' 이라고 가정한다. 적용 전에도 모두 'I' 라 그 분기는 타지 않았고,
--       이번 변경(I → Q)으로 인터락 동작이 달라지지 않는다. 인터락 분기 정상화는 별도 확인 대상이다.
-- =====================================================================

-- SMT 공정 → 공정그룹 SMT
UPDATE IP_PRODUCT_WORKSTAGE
   SET WORKSTAGE_CODE_GROUP = 'SMT', LAST_MODIFY_BY = 'CLAUDE_OEE', LAST_MODIFY_DATE = SYSDATE
 WHERE ORGANIZATION_ID = 1
   AND WORKSTAGE_CODE IN ('W005','W010','W015','W020','W030','W040','W041','W045','W050','W060',
                          'W070','W080','W081','W082','W180');
/
-- 검사공정 → 공정유형 Q, 공정그룹 후공정(PBA) — 공정그룹은 사용자 지시로 같은 날 추가 적용
UPDATE IP_PRODUCT_WORKSTAGE
   SET WORKSTAGE_TYPE = 'Q', WORKSTAGE_CODE_GROUP = 'PBA', LAST_MODIFY_BY = 'CLAUDE_OEE', LAST_MODIFY_DATE = SYSDATE
 WHERE ORGANIZATION_ID = 1
   AND WORKSTAGE_CODE IN ('W090','W095','W205','W210','W400');
/
-- 나머지 공정(공정그룹 N 14건: 코팅·ROUTER·ROM WRITE·COMPERMUL·WAVE·SELECTIVE·ASSY·INSERT·T/U·
-- 2층(후공정)·FINAL·PACKING·REPAIR·Return) → 공정그룹 후공정(PBA) (사용자 지시, 같은 날)
-- 결과: 제조/PBA 14 · 제조/SMT 15 · 검사/PBA 5
UPDATE IP_PRODUCT_WORKSTAGE
   SET WORKSTAGE_CODE_GROUP = 'PBA', LAST_MODIFY_BY = 'CLAUDE_OEE', LAST_MODIFY_DATE = SYSDATE
 WHERE ORGANIZATION_ID = 1 AND WORKSTAGE_CODE_GROUP = 'N';
/

-- 공정유형 I 의 이름: 일반공정 → 제조공정 (사용자 지시, 같은 날)
UPDATE ISYS_BASECODE
   SET CODE_MEAN_KOR = '제조공정', CODE_MEAN_ENG = 'Manufacturing', CODE_MEAN_LOCAL = 'Manufacturing',
       LAST_MODIFY_BY = 'CLAUDE_OEE', LAST_MODIFY_DATE = SYSDATE
 WHERE CODE_TYPE = 'WORKSTAGE TYPE' AND CODE_NAME = 'I' AND ORGANIZATION_ID = 1;
/
COMMIT;
/

-- 되돌리기
-- UPDATE ISYS_BASECODE SET CODE_MEAN_KOR='일반공정', CODE_MEAN_ENG='General', CODE_MEAN_LOCAL='General'
--  WHERE CODE_TYPE='WORKSTAGE TYPE' AND CODE_NAME='I' AND ORGANIZATION_ID=1;
-- (적용 전에는 34건 모두 공정유형 I · 공정그룹 N)
-- UPDATE IP_PRODUCT_WORKSTAGE SET WORKSTAGE_TYPE='I', WORKSTAGE_CODE_GROUP='N' WHERE ORGANIZATION_ID=1;
