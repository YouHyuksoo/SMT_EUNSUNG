-- SEQ_IQC_INSPECT_HISTORY_SEQ 생성
--
-- 배경:
--   PB w_qc_iqc_inspect_history_master 가 검사항번을 채번할 때
--   F_GET_SEQUENCE('SEQ_IQC_INSPECT_HISTORY_SEQ') 를 부르는데
--   이 DB 에 그 시퀀스가 없어 등록 경로가 동작하지 않았다.
--   (PB 가 부르는 시퀀스 5개 중 이것만 없었고, IQ_IQC_INSPECT_HISTORY 도 0행이다.)
--
-- 형태는 이 DB 의 기존 순환 시퀀스 관행을 그대로 따른다 —
--   SEQ_CART_ISSUE_SEQUENCE / SEQ_CUSTOMER_DOCUMENT 와 같은
--   MINVALUE 1 / MAXVALUE 999999 / CYCLE / NOCACHE / NOORDER.
--   IQ_IQC_INSPECT_HISTORY 는 (검사일시 + 검사항번) 으로 행을 가르므로
--   항번이 999999 에서 1 로 돌아도 같은 시각에 겹치지 않는 한 충돌하지 않는다.
--
-- 재실행해도 안전하다 — 이미 있으면 건너뛴다.

DECLARE
  l_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO l_count
    FROM user_sequences
   WHERE sequence_name = 'SEQ_IQC_INSPECT_HISTORY_SEQ';

  IF l_count = 0 THEN
    EXECUTE IMMEDIATE '
      CREATE SEQUENCE SEQ_IQC_INSPECT_HISTORY_SEQ
        START WITH 1
        INCREMENT BY 1
        MINVALUE 1
        MAXVALUE 999999
        CYCLE
        NOCACHE
        NOORDER';
    DBMS_OUTPUT.PUT_LINE('SEQ_IQC_INSPECT_HISTORY_SEQ 생성');
  ELSE
    DBMS_OUTPUT.PUT_LINE('SEQ_IQC_INSPECT_HISTORY_SEQ 이미 있음 — 건너뜀');
  END IF;
END;
/
