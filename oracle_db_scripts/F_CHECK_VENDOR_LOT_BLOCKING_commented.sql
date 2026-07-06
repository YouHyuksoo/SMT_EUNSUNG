CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_CHECK_VENDOR_LOT_BLOCKING
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   입력 조건 또는 기준 데이터의 존재/상태를 확인하여 검증 결과를 반환한다.
   *   화면, 설비, 인터락 로직에서 사전 체크용으로 호출되는 함수로 추정된다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_OUR_BARCODE  (IN, VARCHAR2) - 바코드
   *   P_VENDOR_LOT  (IN, VARCHAR2) - 거래처 / LOT 관련 값
   * ================================================================
   * [AI 분석] 반환값:
   *   VARCHAR2 - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IM_ITEM_RECEIPT_BARCODE - 바코드 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 4회 / 반복문: 0회
   *   DML: SELECT 3회
   * ================================================================
   * 사용 예시:
   *   SELECT F_CHECK_VENDOR_LOT_BLOCKING(...) FROM DUAL;
   * ================================================================ */
 "F_CHECK_VENDOR_LOT_BLOCKING" (
   p_our_barcode  IN VARCHAR2,
   p_vendor_lot   IN VARCHAR2)
   RETURN VARCHAR2
IS
   lvi_count   NUMBER;
   lvi_cnt     NUMBER;
   lvs_str     varchar2(2);
   lvs_return  varchar2(200);
BEGIN
      SELECT COUNT(*)
        INTO LVI_COUNT
        FROM IM_ITEM_RECEIPT_BARCODE X,
             ID_ITEM                 Y
       WHERE X.ITEM_BARCODE = p_our_barcode
         AND X.ITEM_CODE    = Y.ITEM_CODE
         AND ( Y.VENDOR_CODE  = 'US000163' or Y.VENDOR_CODE1  = 'US000163' or Y.VENDOR_CODE2  = 'US000163' or Y.VENDOR_CODE3  = 'US000163')  ; --？？？？ ？？？？


      lvs_return := 'OK' ;

      lvs_str := substr(p_vendor_lot,1,2) ;


      IF LVI_COUNT > 0 THEN                  --？？？？ ？？？？？？？


       /* SELECT COUNT(*)
          INTO lvi_cnt
          FROM (
                 SELECT p_vendor_lot as lot
                   FROM dual
                )
         WHERE regexp_like ( lot,'^[1-9][A-Z].') ;*/



         IF lvs_str <> '1T' THEN
           lvs_return := 'NG' ;
         ELSE
           lvs_return := 'OK' ;
         END IF;

      END IF ;


     return lvs_return ;
EXCEPTION
   WHEN OTHERS
   THEN
     return 'DB'||substr(sqlerrm,1,100) ;
END ;
