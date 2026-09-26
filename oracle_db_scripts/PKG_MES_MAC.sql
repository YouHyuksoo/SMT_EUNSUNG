-- PKG_MES_MAC — PB 이관 산출물 전용 설비·지그(MAC) 패키지
--
-- 기존 전역 FUNCTION/PROCEDURE 와 이름이 충돌하지 않도록
-- 웹 이관으로 생기는 오브젝트는 전부 이 패키지 안에만 만든다.
-- standalone FUNCTION/PROCEDURE 로 만들지 않는다.
--
-- 오브젝트를 추가할 때는 이 파일에 얹어 SPEC/BODY 를 통째로 다시 배포한다.

CREATE OR REPLACE PACKAGE PKG_MES_MAC AS

  /**
   * PB w_mcn_jig_master cb_9(Apply Model Copy) 이관 (2026-09-26)
   *
   * 원본 지그의 적용모델을 대상 지그로 통째로 복사한다.
   *   1) 원본 지그가 실제로 있는지 확인한다 (지그유형 + 지그LOT).
   *   2) 대상 지그의 기존 적용모델을 전부 지운다.
   *   3) 원본의 적용모델을 대상 이름으로 INSERT 한다. 등록자는 'COPY' 로 남긴다.
   *
   * PB 원본 그대로 유지하는 것 두 가지 — 바꾸면 PB 화면과 결과가 갈린다:
   *   - JIG_CODE 와 JIG_LOT_NO 에 **둘 다 대상 지그LOT** 을 넣는다.
   *   - DELETE/INSERT 의 WHERE 는 JIG_LOT_NO 만 본다 (ORGANIZATION_ID 조건 없음).
   *     ORGANIZATION_ID 는 원본 행의 값을 그대로 복사한다.
   *
   * p_result : 복사된 행수 (PB 원본의 sqlca.sqlnrows)
   *           -1  원본 지그가 없음 (PB: "원본 지그가 없습니다" 메시지박스)
   *           -2  원본과 대상이 같음
   */
  PROCEDURE SP_COPY_APPLY_MODEL(
    p_jig_type      IN  VARCHAR2,
    p_from_jig_lot  IN  VARCHAR2,
    p_to_jig_lot    IN  VARCHAR2,
    p_result        OUT NUMBER
  );

  /**
   * PB w_mcn_jig_squeeze_check_master sle_barcode.modified + wf_insert_inspect 이관 (2026-09-26)
   *
   * 스퀴즈 지그 바코드를 한 번 스캔하면 조회·판정·등록·상태변경이 한 트랜잭션으로 돈다.
   *   1) 지그LOT 으로 IMCN_JIG(JIG_TYPE='S') 에서 한계수명·사용횟수·지그코드를 읽는다.
   *   2) 판정: 한계수명 < 사용횟수 이면 'N'(수명초과), 아니면 'P'.
   *   3) IMCN_JIG_SQUEZE_CHECK 에 SEQ_JIG_CHECK_SEQUENCE 순번으로 1건 넣는다.
   *   4) 'P' 면 IMCN_JIG.USE_STATUS='U', 아니면 'S' 로 바꾼다.
   *
   * p_result : 1  합격(P) 등록   0  불합격(N) 등록   -1  등록되지 않은 스퀴즈 바코드
   */
  PROCEDURE SP_SQUEEZE_CHECK_SCAN(
    p_jig_lot_no      IN  VARCHAR2,
    p_organization_id IN  NUMBER,
    p_user_id         IN  VARCHAR2,
    p_result          OUT NUMBER
  );

  /**
   * PB w_mcn_jig_mask_tension_check_master 저장부 이관 (2026-09-26)
   *
   * 메탈마스크 장력검사 1건을 등록하고 지그 상태를 갱신한다.
   *   1) IMCN_JIG_MASK_CHECK 에 SEQ_JIG_CHECK_SEQUENCE 순번으로 넣는다.
   *      MAX_TENSION 은 PB 와 동일하게 0 으로 저장한다(기준치는 IMCN_JIG 가 갖는다).
   *   2) IMCN_JIG 의 USE_STATUS='U', LAST_INSPECT_DATE=SYSDATE, LINE_CODE='*',
   *      TENSION_CHECK_YN='Y' 로 갱신한다 (JIG_TYPE='M').
   *
   * p_result : 1 정상 등록   -1 등록되지 않은 메탈마스크 바코드
   */
  PROCEDURE SP_MASK_TENSION_CHECK(
    p_jig_lot_no      IN  VARCHAR2,
    p_check_status    IN  VARCHAR2,
    p_clean_yn        IN  VARCHAR2,
    p_tension1        IN  NUMBER,
    p_tension2        IN  NUMBER,
    p_tension3        IN  NUMBER,
    p_tension4        IN  NUMBER,
    p_tension5        IN  NUMBER,
    p_comments        IN  VARCHAR2,
    p_organization_id IN  NUMBER,
    p_user_id         IN  VARCHAR2,
    p_result          OUT NUMBER
  );

END PKG_MES_MAC;
/

CREATE OR REPLACE PACKAGE BODY PKG_MES_MAC AS

  /** PB w_mcn_jig_master cb_9 이관 (2026-09-26) — 상세는 SPEC 주석 참조 */
  PROCEDURE SP_COPY_APPLY_MODEL(
    p_jig_type      IN  VARCHAR2,
    p_from_jig_lot  IN  VARCHAR2,
    p_to_jig_lot    IN  VARCHAR2,
    p_result        OUT NUMBER
  ) IS
    l_count NUMBER;
  BEGIN
    IF p_to_jig_lot = p_from_jig_lot THEN
      p_result := -2;
      RETURN;
    END IF;

    -- PB: select count(*) from imcn_jig where jig_type = :type and jig_lot_no = :from
    SELECT COUNT(*)
      INTO l_count
      FROM IMCN_JIG
     WHERE JIG_TYPE   = p_jig_type
       AND JIG_LOT_NO = p_from_jig_lot;

    IF l_count = 0 THEN
      p_result := -1;
      RETURN;
    END IF;

    DELETE FROM IMCN_JIG_APPLY_MODEL
     WHERE JIG_LOT_NO = p_to_jig_lot;

    INSERT INTO IMCN_JIG_APPLY_MODEL (
      JIG_CODE, JIG_LOT_NO, ITEM_CODE, ORGANIZATION_ID,
      ENTER_BY, ENTER_DATE, LAST_MODIFY_BY, LAST_MODIFY_DATE,
      APPLY_SMT_MODEL_NAME
    )
    SELECT p_to_jig_lot,          -- PB 원본이 JIG_CODE 자리에 대상 LOT 을 넣는다
           p_to_jig_lot,
           ITEM_CODE,
           ORGANIZATION_ID,
           'COPY', SYSDATE, 'COPY', SYSDATE,
           APPLY_SMT_MODEL_NAME
      FROM IMCN_JIG_APPLY_MODEL
     WHERE JIG_LOT_NO = p_from_jig_lot;

    p_result := SQL%ROWCOUNT;   -- PB 원본의 sqlca.sqlnrows
  END SP_COPY_APPLY_MODEL;

  /** PB w_mcn_jig_squeeze_check_master 이관 (2026-09-26) — 상세는 SPEC 주석 참조 */
  PROCEDURE SP_SQUEEZE_CHECK_SCAN(
    p_jig_lot_no      IN  VARCHAR2,
    p_organization_id IN  NUMBER,
    p_user_id         IN  VARCHAR2,
    p_result          OUT NUMBER
  ) IS
    l_jig_code    IMCN_JIG.JIG_CODE%TYPE;
    l_break_value NUMBER;
    l_hit_value   NUMBER;
    l_line_code   IMCN_JIG.LINE_CODE%TYPE;
    l_status      VARCHAR2(1);
    l_sequence    NUMBER;
  BEGIN
    BEGIN
      SELECT JIG_CODE, BREAK_VALUE, HIT_VALUE, LINE_CODE
        INTO l_jig_code, l_break_value, l_hit_value, l_line_code
        FROM IMCN_JIG
       WHERE JIG_LOT_NO      = p_jig_lot_no
         AND JIG_TYPE        = 'S'
         AND ORGANIZATION_ID = p_organization_id;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_result := -1;   -- PB: "등록되지 않은 바코드" 메시지
        RETURN;
    END;

    -- PB: if break_value < hit_value then 'N'(수명초과) else 'P'
    l_status := CASE WHEN NVL(l_break_value, 0) < NVL(l_hit_value, 0) THEN 'N' ELSE 'P' END;

    SELECT SEQ_JIG_CHECK_SEQUENCE.NEXTVAL INTO l_sequence FROM DUAL;

    INSERT INTO IMCN_JIG_SQUEZE_CHECK (
      JIG_CODE, JIG_LOT_NO, ORGANIZATION_ID, JIG_CHECK_SEQUENCE, JIG_CHECK_DATE,
      JIG_CHECK_STATUS, LINE_CODE, BREAK_VALUE, HIT_VALUE, USED_BY,
      ENTER_BY, ENTER_DATE, LAST_MODIFY_BY, LAST_MODIFY_DATE
    ) VALUES (
      l_jig_code, p_jig_lot_no, p_organization_id, l_sequence, SYSDATE,
      l_status, l_line_code, l_break_value, l_hit_value, p_user_id,
      p_user_id, SYSDATE, p_user_id, SYSDATE
    );

    -- PB: 합격이면 사용중(U), 불합격이면 미사용(S)
    UPDATE IMCN_JIG
       SET USE_STATUS = CASE WHEN l_status = 'P' THEN 'U' ELSE 'S' END,
           LAST_MODIFY_BY = p_user_id,
           LAST_MODIFY_DATE = SYSDATE
     WHERE JIG_LOT_NO      = p_jig_lot_no
       AND JIG_TYPE        = 'S'
       AND ORGANIZATION_ID = p_organization_id;

    p_result := CASE WHEN l_status = 'P' THEN 1 ELSE 0 END;
  END SP_SQUEEZE_CHECK_SCAN;

  /** PB w_mcn_jig_mask_tension_check_master 이관 (2026-09-26) — 상세는 SPEC 주석 참조 */
  PROCEDURE SP_MASK_TENSION_CHECK(
    p_jig_lot_no      IN  VARCHAR2,
    p_check_status    IN  VARCHAR2,
    p_clean_yn        IN  VARCHAR2,
    p_tension1        IN  NUMBER,
    p_tension2        IN  NUMBER,
    p_tension3        IN  NUMBER,
    p_tension4        IN  NUMBER,
    p_tension5        IN  NUMBER,
    p_comments        IN  VARCHAR2,
    p_organization_id IN  NUMBER,
    p_user_id         IN  VARCHAR2,
    p_result          OUT NUMBER
  ) IS
    l_jig_code    IMCN_JIG.JIG_CODE%TYPE;
    l_break_value NUMBER;
    l_hit_value   NUMBER;
    l_line_code   IMCN_JIG.LINE_CODE%TYPE;
    l_sequence    NUMBER;
  BEGIN
    BEGIN
      SELECT JIG_CODE, BREAK_VALUE, HIT_VALUE, LINE_CODE
        INTO l_jig_code, l_break_value, l_hit_value, l_line_code
        FROM IMCN_JIG
       WHERE JIG_LOT_NO      = p_jig_lot_no
         AND JIG_TYPE        = 'M'
         AND ORGANIZATION_ID = p_organization_id;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_result := -1;
        RETURN;
    END;

    SELECT SEQ_JIG_CHECK_SEQUENCE.NEXTVAL INTO l_sequence FROM DUAL;

    INSERT INTO IMCN_JIG_MASK_CHECK (
      JIG_CODE, JIG_LOT_NO, ORGANIZATION_ID, JIG_CHECK_SEQUENCE, JIG_CHECK_DATE,
      JIG_CHECK_STATUS, LINE_CODE, CLEAN_YN,
      TENSION_CHECK1, TENSION_CHECK2, TENSION_CHECK3, TENSION_CHECK4, TENSION_CHECK5,
      MAX_TENSION, BREAK_VALUE, HIT_VALUE, USED_BY, COMMENTS,
      ENTER_BY, ENTER_DATE, LAST_MODIFY_BY, LAST_MODIFY_DATE
    ) VALUES (
      l_jig_code, p_jig_lot_no, p_organization_id, l_sequence, SYSDATE,
      p_check_status, l_line_code, p_clean_yn,
      p_tension1, p_tension2, p_tension3, p_tension4, p_tension5,
      0,                                   -- PB 원본이 0 으로 저장한다
      l_break_value, l_hit_value, p_user_id, p_comments,
      p_user_id, SYSDATE, p_user_id, SYSDATE
    );

    UPDATE IMCN_JIG
       SET USE_STATUS        = 'U',
           LAST_INSPECT_DATE = SYSDATE,
           LINE_CODE         = '*',
           TENSION_CHECK_YN  = 'Y',
           LAST_MODIFY_BY    = p_user_id,
           LAST_MODIFY_DATE  = SYSDATE
     WHERE JIG_LOT_NO      = p_jig_lot_no
       AND JIG_TYPE        = 'M'
       AND ORGANIZATION_ID = p_organization_id;

    p_result := 1;
  END SP_MASK_TENSION_CHECK;

END PKG_MES_MAC;
/
