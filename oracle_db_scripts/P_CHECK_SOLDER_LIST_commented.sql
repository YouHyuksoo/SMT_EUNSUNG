CREATE OR REPLACE PROCEDURE p_check_solder_list (
  /* ================================================================
   * 프로시저명  : P_CHECK_SOLDER_LIST
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   솔더 바코드 기준으로 솔더 마스터의 주요 이력 일자를 조회한다.
   *   입고, 출고, 상온방치, 교반, 폐기, 점도, 라인 투입 일자를 문자열로 변환한다.
   *   조회 결과는 SYS_REFCURSOR로 반환되어 PDA 또는 화면에서 솔더 이력 확인에 사용된다.
   *   조직 파라미터는 현재 SQL 조건에는 사용되지 않는다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_BARCODE  (IN, VARCHAR2) - 조회할 솔더 품목 바코드
   *   P_ORG      (IN, NUMBER) - 조직 ID 입력값, 현재 로직에서는 미사용
   *   P_OUT      (OUT, SYS_REFCURSOR) - 솔더 이력 일자 조회 결과 커서
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IM_ITEM_SOLDER_MASTER - 솔더 품목 및 사용 이력 마스터
   *     조건: ITEM_BARCODE = UPPER(P_BARCODE)
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN OTHERS - 발생한 오류 메시지를 ORA-20003 애플리케이션 오류로 재발생시킨다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 없음
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   EXEC P_CHECK_SOLDER_LIST('SOLDER_BARCODE', 82, :P_OUT)
   * ================================================================ */
   p_barcode IN VARCHAR2,
   p_org IN NUMBER,
   p_out OUT sys_refcursor
   )
IS
BEGIN
  -- [AI] 솔더 바코드 기준으로 솔더 주요 이력 일자를 커서로 반환한다.
  OPEN p_out FOR
    

            select to_char(solder_lot_no),
                    to_char(receipt_date,'yyyy/mm/dd hh24:mi:ss'),
                    to_char(ISSUE_DATE,'yyyy/mm/dd hh24:mi:ss'),
                    to_char(UNFREEZING_START_DATE,'yyyy/mm/dd hh24:mi:ss'),
                    to_char(UNFREEZING_END_DATE,'yyyy/mm/dd hh24:mi:ss'),
                    to_char(MIX_START_DATE,'yyyy/mm/dd hh24:mi:ss'),
                    to_char(MIX_END_DATE,'yyyy/mm/dd hh24:mi:ss'),
                    to_char(DESTROY_DATE,'yyyy/mm/dd hh24:mi:ss'),
                    to_char(VISCOSITY_START_DATE,'yyyy/mm/dd hh24:mi:ss'), 
                    to_char(INPUT_DATE,'yyyy/mm/dd hh24:mi:ss')                     
            from im_item_solder_master
            where item_barcode = UPPER(p_barcode);
      
EXCEPTION
    -- [AI] 조회 중 발생한 모든 오류를 애플리케이션 오류 코드로 변환한다.
    WHEN OTHERS THEN  
         raise_application_error (-20003, SQLERRM);
END;
