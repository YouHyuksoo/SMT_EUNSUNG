CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_TRACE_NO_FROM_BARCODE
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
   *   VARCHAR2 - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IM_ITEM_RECEIPT - 품목 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회 / 반복문: 0회
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_TRACE_NO_FROM_BARCODE(...) FROM DUAL;
   * ================================================================ */
 "F_GET_TRACE_NO_FROM_BARCODE" (
   p_barcode IN VARCHAR2)
   RETURN VARCHAR2
IS
   lvi_pos1     NUMBER;
   lvi_pos2     NUMBER;
   lvi_pos3     NUMBER;
   lvi_pos4     NUMBER;

   lvi_gap      NUMBER;
   lvs_return   VARCHAR2 (30);
   LVS_LOT_NO   VARCHAR2 (50);
BEGIN
   ------------------------------------------------------------------
   -- KEFICO
   -- 8 - 9 TRAACE NO = LOT NO
   -- [)>06P9990932163ZZD20150328SB00017VDF33L20250328I20170328Q2984TID15C26157UEAXCAPACITOR;06034N???????G20150
   ------------------------------------------------------------------

   IF SUBSTR (p_barcode, 1, 1) = '['
   THEN
      lvi_pos1 :=
         INSTR (p_barcode,
                CHR (29),
                1,
                8);
      lvi_pos2 := INSTR (p_barcode, CHR (29), lvi_pos1 + 1);


      lvs_return :=
         SUBSTR (p_barcode, lvi_pos1 + 2, (lvi_pos2 - lvi_pos1) - 2);
   ELSE
      BEGIN
         SELECT ORIGIN_MFS
           INTO LVS_LOT_NO
           FROM IM_ITEM_RECEIPT
          WHERE     BARCODE = p_barcode
                AND ORIGIN_MFS IS NOT NULL
                AND RECEIPT_STATUS = 'N'
                AND ROWNUM = 1;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            LVS_LOT_NO := '';
      END;

      lvs_return := NVL (LVS_LOT_NO, '');
   END IF;

   RETURN lvs_return;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN NULL;
END;
