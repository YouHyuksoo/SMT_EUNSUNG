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

END PKG_MES_MAC;
/
