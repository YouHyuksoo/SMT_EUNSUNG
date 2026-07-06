CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_ASSEMBLY_TARGET_BY_LINE
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
   * ================================================================
   * [AI 분석] 반환값:
   *   NUMBER - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ICOM_WORKTIME_RANGES - 업무 기준/거래 데이터 조회 또는 참조
   *   IP_PRODUCT_MODEL_ST_MASTER - 제품 / 모델 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 4회 / 반복문: 0회
   *   DML: SELECT 2회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_ASSEMBLY_TARGET_BY_LINE(...) FROM DUAL;
   * ================================================================ */
 "F_GET_ASSEMBLY_TARGET_BY_LINE" (p_line_code      IN VARCHAR2,
/* Formatted on 2015-04-25 17:01:41 (QP5 v5.126) */
                                        p_model_name     IN VARCHAR2,
                                        p_model_suffix   IN VARCHAR2,
                                        p_pcb_item       IN VARCHAR2)
    RETURN NUMBER
IS
    lvl_st_value   NUMBER;
    lvl_time       NUMBER;
    lvl_return     NUMBER;
    LVS_START_TIME varchar2(10) ;
BEGIN


SELECT START_TIME INTO LVS_START_TIME 
   FROM ICOM_WORKTIME_RANGES 
  WHERE range_type = 'SMTWORKTIME'  AND work_type = 'A' ;
 

  IF LVS_START_TIME = '' OR LVS_START_TIME IS NULL THEN 
      LVS_START_TIME := '0830' ;
  END IF ;
  
  
  
    IF TO_CHAR (SYSDATE, 'HH24MI') < LVS_START_TIME
    THEN
        lvl_time :=
           ABS(( (SYSDATE - 1) - TO_DATE (TO_CHAR (SYSDATE, 'YYYYMMDD') || LVS_START_TIME , 'YYYYMMDDHH24MI')) * 24 * 60 * 60);
    ELSE
        lvl_time := (SYSDATE - TO_DATE (TO_CHAR (SYSDATE, 'YYYYMMDD') || LVS_START_TIME, 'YYYYMMDDHH24MI')) * 24 * 60 * 60;
    END IF;

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
