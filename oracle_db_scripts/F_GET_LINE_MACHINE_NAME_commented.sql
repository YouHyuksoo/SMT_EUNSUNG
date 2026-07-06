CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_LINE_MACHINE_NAME
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
   *   P_ORG  (IN, number) - 함수 입력값
   * ================================================================
   * [AI 분석] 반환값:
   *   VARCHAR2 - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_LINE - 제품 / 라인 관련 값 조회 또는 참조
   *   IMCN_MACHINE - 업무 기준/거래 데이터 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 4회 / 반복문: 0회
   *   DML: SELECT 2회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_LINE_MACHINE_NAME(...) FROM DUAL;
   * ================================================================ */
                    "F_GET_LINE_MACHINE_NAME" (p_line_code IN VARCHAR2 , p_org IN number)
-- "F_GET_LINE_NAME" (p_line_code IN VARCHAR2, p_org IN number)
   RETURN VARCHAR2
IS
   lvs_return   VARCHAR2 (100);
BEGIN

    lvs_return := p_line_code;

    ----------------------------------------------------------
    -- ¿¿ ¿¿
    ----------------------------------------------------------
    BEGIN

       SELECT line_name
         INTO lvs_return
         FROM ip_product_line
        WHERE line_code = p_line_code
          AND ORGANIZATION_ID =  p_org ;

       IF ( NVL( lvs_return, '*') <> '*' ) THEN   
            RETURN lvs_return;
       END IF;

    EXCEPTION
       WHEN OTHERS THEN
          lvs_return := p_line_code;
    END;

    ----------------------------------------------------------
    -- ¿¿ ¿¿
    ----------------------------------------------------------    
    BEGIN

       SELECT machine_name
         INTO lvs_return
         FROM imcn_machine
        WHERE machine_code = p_line_code
          AND ORGANIZATION_ID =  p_org ;

       IF ( NVL( lvs_return, '*') <> '*' ) THEN   
            RETURN lvs_return;
       END IF;          

    EXCEPTION
       WHEN OTHERS THEN
          lvs_return := p_line_code;
    END;            

    RETURN lvs_return;

EXCEPTION
   WHEN OTHERS THEN
        RETURN lvs_return ;
END;
