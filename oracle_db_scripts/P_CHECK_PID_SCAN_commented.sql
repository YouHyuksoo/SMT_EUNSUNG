CREATE OR REPLACE PROCEDURE "P_CHECK_PID_SCAN" (
  /* ================================================================
   * 프로시저명  : P_CHECK_PID_SCAN
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   기존 PID와 신규 PID의 품목 코드가 같은지 확인한다.
   *   각 PID를 IP_PRODUCT_2D_BARCODE에서 조회하고, 하나라도 없으면 NG와 메시지를 반환한다.
   *   두 PID의 품목 코드가 같으면 OK, 다르면 NG를 반환하며 모델명과 신규 품목 코드를 메시지로 제공한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_OLD_PID  (IN, VARCHAR2) - 기존 PID
   *   P_NEW_PID  (IN, VARCHAR2) - 신규 PID
   *   P_OUT      (OUT, VARCHAR2) - 검사 결과, OK 또는 NG
   *   P_MSG      (OUT, VARCHAR2) - 상세 메시지
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_2D_BARCODE - PID별 2D 바코드 및 품목 정보 테이블
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_MSG - PID 미존재 메시지 조회
   * ================================================================
   * [AI 분석] 예외 처리:
   *   내부 WHEN NO_DATA_FOUND - 각 PID 미존재 시 NG와 메시지 반환
   *   외부 WHEN OTHERS - P_OUT에 NG, P_MSG에 SQLERRM을 설정한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회 / 반복문: 없음
   *   DML: SELECT 2회
   * ================================================================
   * 사용 예시:
   *   EXEC P_CHECK_PID_SCAN('OLDPID', 'NEWPID', :P_OUT, :P_MSG)
   * ================================================================ */
p_old_pid   IN     VARCHAR2,
                                p_new_pid   IN     VARCHAR2,
                                p_out          OUT VARCHAR2,
                                p_msg          OUT VARCHAR2)
IS
    lvs_old_item_code   VARCHAR2 (30); -- [AI] 기존 PID의 품목 코드
    lvs_new_item_code   VARCHAR2 (30); -- [AI] 신규 PID의 품목 코드
    lvs_model_name      VARCHAR2 (20); -- [AI] 신규 PID의 모델명
 
BEGIN
    -- [AI] 동일 PID가 입력되면 비교 대상이 아니므로 NG로 종료한다.
    IF p_old_pid = p_new_pid
    THEN
        p_out := 'NG';
        RETURN;
    END IF;

    BEGIN
        -- [AI] 기존 PID의 품목 코드를 조회한다.
        SELECT   item_code
          INTO   lvs_old_item_code
          FROM   IP_PRODUCT_2D_BARCODE
         WHERE   serial_no = p_old_pid;
    EXCEPTION
        -- [AI] 기존 PID가 없으면 NG와 다국어 메시지를 반환한다.
        WHEN NO_DATA_FOUND
        THEN
            p_out := 'NG';
            p_msg := f_msg('PID 1 NOT FOUND','C',1);
            RETURN;
    END;

    ------------------------------------------------------------------------------
    --
    ------------------------------------------------------------------------------
    BEGIN
        -- [AI] 신규 PID의 품목 코드와 모델명을 조회한다.
        SELECT   item_code, model_name
        INTO   lvs_new_item_code, lvs_model_name
          FROM   IP_PRODUCT_2D_BARCODE
         WHERE   serial_no = p_new_pid;
    EXCEPTION
        -- [AI] 신규 PID가 없으면 NG와 다국어 메시지를 반환한다.
        WHEN NO_DATA_FOUND
        THEN
            p_out := 'NG';
            p_msg := f_msg('PID 2 NOT FOUND','C',1);
            RETURN;
    END;


    -- [AI] 기존 PID와 신규 PID의 품목 코드 일치 여부를 판단한다.
    IF lvs_old_item_code = lvs_new_item_code
    THEN
        p_out := 'OK';
        p_msg := lvs_model_name || ' ' || lvs_new_item_code;
    ELSE
        p_out := 'NG';
        p_msg := lvs_model_name || ' ' || lvs_new_item_code;
    END IF;

    RETURN;
EXCEPTION
    -- [AI] 기타 오류 발생 시 실패 코드와 오류 메시지를 반환한다.
    WHEN OTHERS
    THEN
        p_out := 'NG';
        p_msg := SQLERRM;
        RETURN;
END;
