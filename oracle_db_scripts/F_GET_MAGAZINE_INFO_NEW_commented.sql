CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_MAGAZINE_INFO_NEW
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
   *   P_PID  (IN, VARCHAR2) - 제품 식별자
   *   P_LINE_CODE  (IN, VARCHAR2) - 라인 코드
   *   P_OPTION  (IN, VARCHAR2) - 함수 입력값
   * ================================================================
   * [AI 분석] 반환값:
   *   VARCHAR2 - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_MAGAZINE_HIS - 제품 / 매거진 관련 값 조회 또는 참조
   *   IP_PRODUCT_2D_BARCODE - 바코드 조회 또는 참조
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_GET_RUN_NO_INFO - 관련 업무 함수 호출
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회 / 반복문: 0회
   *   DML: SELECT 5회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_MAGAZINE_INFO_NEW(...) FROM DUAL;
   * ================================================================ */
 "F_GET_MAGAZINE_INFO_NEW" (p_pid         IN VARCHAR2,
                                                    p_line_code   IN VARCHAR2,
                                                    p_option      IN VARCHAR2)
    RETURN VARCHAR2
IS
    lvs_return        VARCHAR2 (100);

    lvs_charge_qty    VARCHAR2 (100);
    lvs_lot_no_count  VARCHAR2 (100);

BEGIN

   CASE p_option

         WHEN 'LGEIVI LAST CHARGE QTY'  THEN

              BEGIN

                 select TO_CHAR(NVL(MAX(charge_qty),0))
                   into lvs_charge_qty
                   from ip_product_magazine_his
                  where customer_code = 'LGIVI'
                    and line_code     = p_line_code
                    and work_order    = f_get_run_no_info(p_pid, 'WO');

              EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                      lvs_charge_qty := '0';
              END;

              lvs_return := lvs_charge_qty;

         WHEN 'HLDS LAST LOT NO'   THEN

              IF (p_line_code = 'VC') THEN

                  BEGIN

                    -- select trim(to_char(SEQ_MAGAZINE_HLDS.NEXTVAL, '0000'))
                    --  into lvs_lot_no_count
                    --  from dual;

                     select trim(to_char(to_number(nvl(max(lot_no_count),0))+1, '0000'))
                       into lvs_lot_no_count
                       from ip_product_magazine_his
                      where line_code     =  p_line_code
                        and customer_code =  'HLDS'
                        and print_date    >= trunc(sysdate)
                        and part_no = (
                                        select part_no
                                          from ip_product_2d_barcode
                                         where serial_no = p_pid
                                      );

                  EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                          lvs_lot_no_count := '0001';
                  END;

              ELSE

                  BEGIN

                     select to_char(sysdate, 'YYYY-MM-DD HH24:MI')
                       into lvs_lot_no_count
                       from dual;

                  EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                          lvs_lot_no_count := to_char(sysdate, 'YYYY-MM-DD HH24:MI');
                  END;

              END IF;

              lvs_return := lvs_lot_no_count;

         ELSE
              lvs_return := 'ERROR';

    END CASE;

    RETURN lvs_return;

EXCEPTION

    WHEN OTHERS THEN
         RETURN 'ERROR';

END;
