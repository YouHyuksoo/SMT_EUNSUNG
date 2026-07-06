CREATE OR REPLACE PROCEDURE "P_INTERLOCK_CUSTOMER_INFO" (
  /* ================================================================
   * 프로시저명  : P_INTERLOCK_CUSTOMER_INFO
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2015-07-12
   * 수정이력:
   *   2015-07-12 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   고객 코드와 조직 기준으로 고객 코드, 고객명, 영문 고객명을 조회한다.
   *   P_TYPE 값에 따라 조회된 고객 정보 중 하나를 P_OUT에 반환한다.
   *   고객 데이터가 없으면 NOTFOUND를 반환하고, 기타 오류는 애플리케이션 오류로 처리한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_CUSTOMER_CODE  (IN, VARCHAR2) - 고객 코드
   *   P_TYPE           (IN, VARCHAR2) - 반환 구분, CODE/NAME/NAME_ENG
   *   P_ORG            (IN, NUMBER) - 조직 ID
   *   P_OUT            (OUT, VARCHAR2) - 요청 구분에 해당하는 고객 정보
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ICOM_CUSTOMER - CUSTOMER MASTER
   *     조건: CUSTOMER_CODE, ORGANIZATION_ID 일치
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN NO_DATA_FOUND - P_OUT에 NOTFOUND를 설정하고 종료한다.
   *   WHEN OTHERS - P_OUT에 SQLERRM 설정 후 ORA-20003을 발생시킨다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 1회, ELSIF 2회 / 반복문: 없음
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   EXEC P_INTERLOCK_CUSTOMER_INFO('CUST01', 'NAME', 1, :P_OUT)
   * ================================================================ */
p_customer_code   IN     VARCHAR2,
/* Formatted on 2015-07-12 15:52:55 (QP5 v5.126) */
                                     p_type            IN     VARCHAR2,
                                     p_org             IN     NUMBER,
                                     p_out                OUT VARCHAR2)
IS
    -- ---------   ------  -------------------------------------------
    lvs_customer_code       VARCHAR2 (20); -- [AI] 조회된 고객 코드
    lvs_customer_name       VARCHAR2 (100); -- [AI] 조회된 고객명
    lvl_customer_name_eng   VARCHAR2 (100); -- [AI] 조회된 영문 고객명
------------------------------------------------------------------

BEGIN
    -- [AI] 고객 코드와 조직 기준으로 고객 기본 정보를 조회한다.
    SELECT   customer_code, customer_name, customer_name_eng
      INTO   lvs_customer_code, lvs_customer_name, lvl_customer_name_eng
      FROM   icom_customer
     WHERE   customer_code = p_customer_code AND organization_id = p_org;

    --------------------------------------------------------------------------
    --
    --------------------------------------------------------------------------

    -- [AI] 요청 타입에 따라 고객 코드, 고객명, 영문명을 선택해 반환한다.
    IF p_type = 'CODE'
    THEN
        p_out := lvs_customer_code;
    ELSIF p_type = 'NAME'
    THEN
        p_out := lvs_customer_name;
    ELSIF p_type = 'NAME_ENG'
    THEN
        p_out := lvl_customer_name_eng;
    ELSE
        p_out := '*';
    END IF;


    --------------------------------------------------------------------------
    --
    --------------------------------------------------------------------------

    RETURN;
EXCEPTION
    -- [AI] 고객 정보가 없으면 NOTFOUND를 반환한다.
    WHEN NO_DATA_FOUND
    THEN
        p_out := 'NOTFOUND';

        RETURN;
    -- [AI] 기타 오류는 OUT 값에도 기록한 뒤 애플리케이션 오류로 전달한다.
    WHEN OTHERS
    THEN
       p_out :=SQLERRM ;
        raise_application_error (-20003, SQLERRM);
END;
