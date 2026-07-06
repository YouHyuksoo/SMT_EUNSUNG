CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_MAGAZINE_PID_CUR
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   입력 파라미터와 기준 테이블을 이용해 업무 코드, 명칭, 수량, 상태 등의 조회 값을 반환한다.
   *   조회 실패 또는 예외 상황에서는 원본 로직에 정의된 기본값/NULL/오류 처리를 따른다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_LINE_CODE  (IN, VARCHAR2) - 라인 코드
   *   P_WORKSTAGE_CODE  (IN, VARCHAR2) - 공정 코드
   *   P_MACHINE_CODE  (IN, VARCHAR2) - 함수 입력값
   * ================================================================
   * [AI 분석] 반환값:
   *   sys_refcursor - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_2D_BARCODE - 바코드 조회 또는 참조
   *   IQ_INTERLOCK_CHECK_RESULT - 인터락 관련 값 조회 또는 참조
   *   IP_PRODUCT_RUN_MODEL - 제품 / 작업지시/런 / 모델 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_GET_WORKSTAGE_TYPE - 관련 업무 함수 호출
   * ================================================================
   * [AI 분석] 예외 처리:
   *   명시적 EXCEPTION 블록 없음 - 호출부에서 표준 Oracle 예외를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: SELECT 4회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_MAGAZINE_PID_CUR(...) FROM DUAL;
   * ================================================================ */
 "F_GET_MAGAZINE_PID_CUR" (
                                                  p_line_code      IN VARCHAR2,
                                                  p_workstage_code IN VARCHAR2,
                                                  p_machine_code   IN VARCHAR2
                                                  )
RETURN sys_refcursor
IS
  o_cursor sys_refcursor;

BEGIN


  -- 20161223 SHS, ？？？？？？？ ？？？？？？ ？？？ ？？？ ？？？？？ run model ？？？？ ？？？？ ？？ ？？？？ ？？？ 30？？ ？？？ magazine pid list？？ ？？？？？

  OPEN o_cursor FOR
       select magazine_no, serial_no, sysdate
         from ip_product_2d_barcode
         where magazine_no in (
                            select magazine_no
                              from iq_interlock_check_result
                             where line_code      = p_line_code
                           --    and machine_code   = 'YSS-G-141'
                               and F_GET_WORKSTAGE_TYPE( WORKSTAGE_CODE )  =  'MAGAZINE' 
                               and receipt_date in (
                                                    select max(receipt_date)
                                                      from iq_interlock_check_result
                                                     where receipt_date   >= sysdate - (0.5/24)
                                                       and line_code      = p_line_code
                                                       and machine_code   = p_machine_code
                                                       and workstage_code = p_workstage_code
                                                       and  magazine_no <> '*'
                                                   )
                              and rownum = 1
                          )
        and model_name = (
                    select model_name
                      from ip_product_run_model
                     where line_code      = p_line_code
                       and workstage_code = p_workstage_code
                   );

  RETURN o_cursor;

END;
