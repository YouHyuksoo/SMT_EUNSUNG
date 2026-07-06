CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_PCB_FIRST_MARKING_BY_BOXNO
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
   *   P_BOX_NO  (IN, VARCHAR2) - 함수 입력값
   * ================================================================
   * [AI 분석] 반환값:
   *   DATE - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IQ_MACHINE_INSPECT_DATA_MK - 검사 관련 값 조회 또는 참조
   *   IP_PRODUCT_2D_BARCODE - 바코드 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: SELECT 2회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_PCB_FIRST_MARKING_BY_BOXNO(...) FROM DUAL;
   * ================================================================ */
 F_GET_PCB_FIRST_MARKING_BY_BOXNO 
(
  P_BOX_NO IN VARCHAR2 
) RETURN DATE AS 


LVDT_MARKING_DATE DATE ;
BEGIN
 
     SELECT MIN(TO_DATE(DATESET, 'YYYY/MM/DD HH24:MI:SS')) INTO LVDT_MARKING_DATE
      FROM IQ_MACHINE_INSPECT_DATA_MK
     WHERE RUN_NO = ( SELECT max(RUN_NO)  FROM IP_PRODUCT_2D_BARCODE WHERE BOX_NO = P_BOX_NO ) ;

  RETURN NVL(LVDT_MARKING_DATE , SYSDATE - 1000 ) ;
  
  EXCEPTION WHEN OTHERS THEN 
       RETURN NVL(LVDT_MARKING_DATE , SYSDATE - 1000 ) ;
       
END F_GET_PCB_FIRST_MARKING_BY_BOXNO;
