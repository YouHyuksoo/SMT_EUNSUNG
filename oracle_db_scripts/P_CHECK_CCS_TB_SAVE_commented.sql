CREATE OR REPLACE PROCEDURE "P_CHECK_CCS_TB_SAVE" (
  /* ================================================================
   * 프로시저명  : P_CHECK_CCS_TB_SAVE
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2015-04-24
   * 수정이력:
   *   2015-04-24 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   라인, 모델, Top/Bottom 기준으로 CCS 검사 완료 정보를 저장한다.
   *   생산 계획 데이터의 장착 완료일과 CCS 여부를 갱신하고, SMT 검사 이력의 CCS 종료일을 기록한다.
   *   제품 라인 마스터의 CCS 일자를 현재 시각으로 갱신한 뒤 COMMIT한다.
   *   오류 발생 시 반환값에 NG와 오류 메시지를 설정한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_LINE_CODE   (IN, VARCHAR2) - 라인 코드, 앞 2자리 사용
   *   P_MODEL_NAME  (IN, VARCHAR2) - 모델명 또는 LOT명
   *   P_TOPBOT      (IN, VARCHAR2) - PCB Top/Bottom 구분
   *   P_RETURN      (OUT, VARCHAR2) - 처리 결과, OK 또는 NG 메시지
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IB_PRODUCT_PLANDATA - 생산 계획/장착 데이터
   *   IB_SMT_CHECKHIST - SMT 검사 이력
   *   IP_PRODUCT_LINE - Product Line Master
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN OTHERS - P_RETURN에 NG와 SQLERRM을 설정한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 없음
   *   DML: UPDATE 3회
   *   주의: COMMIT 포함
   * ================================================================
   * 사용 예시:
   *   EXEC P_CHECK_CCS_TB_SAVE('L1', 'MODEL01', 'T', :P_RETURN)
   * ================================================================ */
p_line_code    IN     VARCHAR2,
/* Formatted on 2015-04-24 ??? 11:01:14 (QP5 v5.126) */
                                                   p_model_name   IN     VARCHAR2,
                                                   p_topbot       IN     VARCHAR2,
                                                   p_return          OUT VARCHAR2) IS
BEGIN
    ---------------------------------------------------------
    --
    ---------------------------------------------------------
    -- [AI] 활성 생산 계획의 CCS 완료 여부와 장착 완료일을 갱신한다.
    UPDATE  ib_product_plandata
       SET  feeding_end_date = SYSDATE, 
            ccs_yn = 'Y' 
             --full_check_yn = 'N'
     WHERE line_code  = SUBSTR (p_line_code, 1, 2)
       AND model_name = p_model_name
       AND pcb_item   = p_topbot
       AND active_yn  = 'Y'
    --     AND ccs_yn = 'N'
      ;
   --------------------------------------------------------
   --
   --------------------------------------------------------
    -- [AI] SMT 검사 이력의 CCS 종료일을 기록한다.
    UPDATE ib_smt_checkhist
       SET ccs_end_date  = SYSDATE
     WHERE line_code     = SUBSTR (p_line_code, 1, 2)
       AND lot_name      = p_model_name
       AND pcb_item      = p_topbot
       AND check_type    = 1
       AND ccs_end_date IS NULL;
   --------------------------------------------------------
   --
   --------------------------------------------------------
    -- [AI] 제품 라인 마스터의 CCS 일자를 현재 시각으로 갱신한다.
    UPDATE ip_product_line
       SET ccs_date = SYSDATE
     WHERE line_code = SUBSTR (p_line_code, 1, 2);

    -- [AI] CCS 저장 결과를 확정한다.
    COMMIT;

    p_return := 'OK';
    
EXCEPTION
    -- [AI] 오류 발생 시 호출부에 실패 메시지를 반환한다.
    WHEN OTHERS THEN
        p_return := 'NG, [CCS] 저장 ERROR ' || SQLERRM;
END;                                                                                                        -- Procedure

