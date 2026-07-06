CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_PLAN_QTY_BY_PRODUCT_ST
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
   *   P_PCB_ITEM  (IN, VARCHAR2) - PCB / 품목 관련 값
   *   P_WORKSTAGE_CODE  (IN, VARCHAR2) - 공정 코드
   *   P_TIMEZONE  (IN, VARCHAR2) - 함수 입력값
   *   P_MC_TIME  (IN, NUMBER) - 시간 관련 값
   *   P_ORG  (IN, NUMBER) - 함수 입력값
   * ================================================================
   * [AI 분석] 반환값:
   *   NUMBER - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ICOM_WORKTIME_RANGES - 업무 기준/거래 데이터 조회 또는 참조
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_GET_MODEL_PRODUCT_ST - 관련 업무 함수 호출
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 4회 / 반복문: 0회
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_PLAN_QTY_BY_PRODUCT_ST(...) FROM DUAL;
   * ================================================================ */
 "F_GET_PLAN_QTY_BY_PRODUCT_ST" (
   P_lINE_CODE    IN VARCHAR2,
   P_MODEL_NAME   IN VARCHAR2,
   P_PCB_ITEM     IN VARCHAR2,
   P_WORKSTAGE_CODE IN VARCHAR2 ,
   P_TIMEZONE     IN VARCHAR2,
   P_MC_TIME IN NUMBER ,
   P_ORG          IN NUMBER)
   RETURN NUMBER
IS
   LVL_TIME   NUMBER;
   LVL_ST     NUMBER;
   LVL_LOSS   NUMBER;
BEGIN

  SELECT ( (TO_DATE ('19000101' || END_TIME, 'YYYYMMDDHH24MI')
             - TO_DATE ('19000101' || START_TIME, 'YYYYMMDDHH24MI'))
           * 24
           * 60
           * 60
           - ( NVL (ATTRIBUTE03 * 60 , 0)+ (NVL(P_MC_TIME,0) * 60)  )  ),
          F_GET_MODEL_PRODUCT_ST (P_MODEL_NAME,
                          P_lINE_CODE,
                          P_PCB_ITEM,
                          P_WORKSTAGE_CODE ,
                          P_ORG),
          (NVL (ATTRIBUTE04, 1) / 100)
     INTO LVL_TIME, LVL_ST, LVL_LOSS
     FROM ICOM_WORKTIME_RANGES
    WHERE RANGE_TYPE = 'SMTWORKTIME' AND WORK_TYPE = P_TIMEZONE;

   IF LVL_TIME < 0
   THEN
      LVL_TIME := 86400 - ABS (LVL_TIME);
   END IF;

if LVL_ST = 0 then 
    return 0  ;
else
   RETURN ROUND (LVL_TIME / LVL_ST, 0) * LVL_LOSS;  
end if ;
  
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
   WHEN OTHERS
   THEN
      RAISE_APPLICATION_ERROR (-20003, SQLERRM);
END ;
