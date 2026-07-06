CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_WIP_STATE_BY_SERIAL
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
   *   P_SERIAL  (IN, VARCHAR2) - 시리얼 관련 값
   * ================================================================
   * [AI 분석] 반환값:
   *   VARCHAR2 - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_WORK_QC - 제품 관련 값 조회 또는 참조
   *   IP_PRODUCT_2D_BARCODE - 바코드 조회 또는 참조
   *   IQ_INTERLOCK_CHECK_RESULT - 인터락 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_GET_LINE_NAME - 관련 업무 함수 호출
   *   F_GET_WORKSTAGE_NAME - 관련 업무 함수 호출
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 4회 / 반복문: 0회
   *   DML: SELECT 4회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_WIP_STATE_BY_SERIAL(...) FROM DUAL;
   * ================================================================ */
 "F_GET_WIP_STATE_BY_SERIAL" (p_serial IN VARCHAR2)
/* Formatted on 2015-07-07 10:59:40 (QP5 v5.126) */
    RETURN VARCHAR2
IS
    --
    -- To modify this template, edit file FUNC.TXT in TEMPLATE
    -- directory of SQL Navigator
    --
    -- Purpose: Briefly explain the functionality of the function
    --
    -- MODIFICATION HISTORY
    -- Person      Date    Comments
    -- ---------   ------  -------------------------------------------
    -- SHS         2016/10/04   WIP 재공위치 정보를 추

    lvs_return   VARCHAR2 (100);
-- Declare program variables as shown above
BEGIN

   -- 불량창고 check
   BEGIN

     SELECT NVL(F_GET_LINE_NAME('Z1',1)||' '||F_GET_WORKSTAGE_NAME('W900'), '*')
       INTO LVS_RETURN
       FROM IP_PRODUCT_WORK_QC
      WHERE SERIAL_NO       = P_SERIAL
        AND RECEIPT_DEFICIT = 1
        AND ROWNUM          = 1;

   EXCEPTION

     WHEN OTHERS THEN
          lvs_return := '*';

   END;

   -- 제품창고 check
   IF LVS_RETURN = '*' THEN

      BEGIN

        SELECT NVL(DECODE(SHIPPING_DEFICIT, '1', '제품창고 입고', '3', '제품창고 출하', '*'),'*')
          INTO LVS_RETURN
          FROM IP_PRODUCT_2D_BARCODE
         WHERE SERIAL_NO = P_SERIAL
           AND ROWNUM    = 1;

      EXCEPTION

        WHEN OTHERS THEN
             lvs_return := '*';

      END;

   END IF;

   -- 톡과이력 check
   IF LVS_RETURN = '*' THEN

      BEGIN

        SELECT NVL(F_GET_LINE_NAME(LINE_CODE,ORGANIZATION_ID)||' '||F_GET_WORKSTAGE_NAME(WORKSTAGE_CODE),'*')
          INTO LVS_RETURN
          FROM IQ_INTERLOCK_CHECK_RESULT
         WHERE SERIAL_NO    = P_SERIAL
           AND RECEIPT_DATE IN (
                                SELECT MAX(RECEIPT_DATE)
                                  FROM IQ_INTERLOCK_CHECK_RESULT
                                 WHERE SERIAL_NO= P_SERIAL
                               )
           AND ROWNUM = 1;

      EXCEPTION

        WHEN OTHERS THEN
             lvs_return := '*';

      END;

   END IF;

   -- 데이타가 없을경우 '*'로 표기

   RETURN lvs_return;

EXCEPTION
    WHEN OTHERS
    THEN
        RETURN '*';
END;
