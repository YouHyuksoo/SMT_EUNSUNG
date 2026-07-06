CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_MSL_PASSED_TIME
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
   *   P_BARCODE  (IN, VARCHAR2) - 바코드
   * ================================================================
   * [AI 분석] 반환값:
   *   NUMBER - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IM_ITEM_RECEIPT_BARCODE - 바코드 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: SELECT 2회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_MSL_PASSED_TIME(...) FROM DUAL;
   * ================================================================ */
 "F_GET_MSL_PASSED_TIME" (p_barcode IN VARCHAR2)
    RETURN NUMBER
IS
    lvs_return   number;
BEGIN

/*
    SELECT NVL(MSL_PASSED_TIME,0) + ((SYSDATE - NVL(FEEDING_DATE,SYSDATE)) * 24)
      INTO lvs_return
      FROM im_item_receipt_barcode
     WHERE item_barcode = p_barcode
        or lot_no       = p_barcode;
*/
       
    SELECT nvl(msl_passed_time,0) + nvl(((SYSDATE - NVL(MSL_OPEN_DATE,SYSDATE)) * 24),0) 
      INTO lvs_return
      FROM im_item_receipt_barcode
     WHERE item_barcode = p_barcode
        or lot_no       = p_barcode;        


    RETURN NVL(lvs_return,0);
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
         RETURN NULL;
END;
