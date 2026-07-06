CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_INTERLOCK_CHECK_BY_MODEL
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
   *   P_LINE_CODE  (IN, VARCHAR2) - 라인 코드
   *   P_MODEL_NAME  (IN, VARCHAR2) - 모델 / 명칭 관련 값
   *   P_DATE  (IN, DATE) - 일자 관련 값
   * ================================================================
   * [AI 분석] 반환값:
   *   NUMBER - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IQ_INTERLOCK_CHECK_RESULT - 인터락 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_GET_WORKSTAGE_TYPE - 관련 업무 함수 호출
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회 / 반복문: 0회
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_INTERLOCK_CHECK_BY_MODEL(...) FROM DUAL;
   * ================================================================ */
 "F_GET_INTERLOCK_CHECK_BY_MODEL" ( p_line_code      IN VARCHAR2,
                                                                p_model_name     IN VARCHAR2,
                                                                p_date            IN DATE)
    RETURN NUMBER
IS
    lvl_return   NUMBER;
    lvd_date     Date;
BEGIN

    IF TO_CHAR (p_date, 'HH24MI') < '0820'
    THEN
        lvd_date := p_date - 1;
    ELSE
        lvd_date := p_date;
    END IF;

    BEGIN
        SELECT  NVL( COUNT(SERIAL_NO) , 0)
          INTO  lvl_return
          FROM  IQ_INTERLOCK_CHECK_RESULT
         WHERE  LINE_CODE = p_line_code
           AND  MODEL_NAME = p_model_name
           AND  CHECK_RESULT   <> 'NG'
           AND  IS_LAST_YN     = 'Y'
           AND  F_GET_WORKSTAGE_TYPE( WORKSTAGE_CODE )  =  'MAGAZINE' 
           AND  MAGAZINE_NO    IS NOT NULL
           AND  RECEIPT_DATE   >= TO_DATE (TO_CHAR (lvd_date, 'YYYYMMDD') || '0820', 'YYYYMMDDHH24MI');
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            lvl_return := 0;
    END;

    RETURN nvl(lvl_return , 0) ;

EXCEPTION
    WHEN OTHERS
    THEN
        RETURN 0;
END;
