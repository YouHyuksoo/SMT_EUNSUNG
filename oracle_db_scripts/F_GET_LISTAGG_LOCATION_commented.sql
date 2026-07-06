CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_LISTAGG_LOCATION
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
   *   P_MODEL_NAME  (IN, VARCHAR2) - 모델 / 명칭 관련 값
   *   P_ITEM_CODE  (IN, VARCHAR2) - 품목 코드
   *   P_PCB_ITEM  (IN, VARCHAR2) - PCB / 품목 관련 값
   * ================================================================
   * [AI 분석] 반환값:
   *   VARCHAR2 - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ID_ENG_BOM_SMT - BOM 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 2회
   *   DML: SELECT 2회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_LISTAGG_LOCATION(...) FROM DUAL;
   * ================================================================ */
 "F_GET_LISTAGG_LOCATION" (
   P_LINE_CODE    IN VARCHAR2,
   p_model_name   IN VARCHAR2,
   p_item_code    IN VARCHAR2,
   p_pcb_item     IN VARCHAR2 )
   RETURN VARCHAR2
IS
   lvs_return      VARCHAR2 (4000);
   lvs_substring   NUMBER;
   i               NUMBER;
BEGIN
   SELECT listagg (NVL (location_info, '*'), ',')
             WITHIN GROUP (ORDER BY child_item_code, location_info)
             AS location_info
     INTO lvs_return
     FROM (SELECT *
             FROM id_eng_bom_smt
            WHERE     PARENT_ITEM_CODE = p_model_name
                  AND CHILD_ITEM_CODE = p_item_code
                  AND pcb_item = p_pcb_item
                  AND line_code = p_line_code

           ORDER BY child_item_code, location_info)
    WHERE     PARENT_ITEM_CODE = p_model_name
          AND CHILD_ITEM_CODE = p_item_code
          AND pcb_item = p_pcb_item
          AND line_code = p_line_code

   GROUP BY CHILD_ITEM_CODE;


   --
   --   LOOP
   --      i := i + 1;
   --
   --      lvs_substring := SUBSTR (lvs_return, 1, INSTR (lvs_return, ',', 1) - 1);
   --
   --
   --
   --   END LOOP;



   RETURN lvs_return;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN '*';
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;
