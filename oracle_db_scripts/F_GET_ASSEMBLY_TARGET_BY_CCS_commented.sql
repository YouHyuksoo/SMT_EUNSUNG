CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_ASSEMBLY_TARGET_BY_CCS
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
   *   P_MODEL_SUFFIX  (IN, VARCHAR2) - 모델 관련 값
   *   P_PCB_ITEM  (IN, VARCHAR2) - PCB / 품목 관련 값
   *   P_CCS_DATE  (IN, DATE) - 일자 관련 값
   * ================================================================
   * [AI 분석] 반환값:
   *   NUMBER - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_MODEL_ST_MASTER - 제품 / 모델 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_ASSEMBLY_TARGET_BY_CCS(...) FROM DUAL;
   * ================================================================ */
 "F_GET_ASSEMBLY_TARGET_BY_CCS" (p_line_code      IN VARCHAR2,
                                        p_model_name     IN VARCHAR2,
                                        p_model_suffix   IN VARCHAR2,
                                        p_pcb_item       IN VARCHAR2,
                                        p_ccs_date       IN DATE)
    RETURN NUMBER
IS
    lvl_st_value   NUMBER;
    lvl_time       NUMBER;
    lvl_return     NUMBER;
BEGIN
  
    lvl_time := (SYSDATE - p_ccs_date) * 24 * 60 * 60;

        SELECT   MAX(assy_st)
          INTO   lvl_st_value
          FROM   ip_product_model_st_master
         WHERE   line_code = p_line_code
             AND model_name = p_model_name AND pcb_item = p_pcb_item;

    lvl_return := lvl_time / lvl_st_value;

    RETURN lvl_return;


EXCEPTION
    WHEN OTHERS
    THEN
        RETURN 0;
END;
