CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_CHECK_MASTER_SAMPLE
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
   *   P_PID  (IN, VARCHAR2) - 제품 식별자
   * ================================================================
   * [AI 분석] 반환값:
   *   NUMBER - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_MODEL_MASTER - 제품 / 모델 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회 / 반복문: 0회
   *   DML: SELECT 4회
   * ================================================================
   * 사용 예시:
   *   SELECT F_CHECK_MASTER_SAMPLE(...) FROM DUAL;
   * ================================================================ */
 "F_CHECK_MASTER_SAMPLE" (P_PID  IN VARCHAR2) RETURN NUMBER
IS

    lvl_row_count  NUMBER;
    lvl_return     NUMBER;

BEGIN

--------------------------------------------------------------------------
-- 2016/08/29 SHS, PID？？ Master sample ？？？？ ？？？
--------------------------------------------------------------------------

    lvl_return := 0;

    BEGIN

       SELECT NVL(sum(1),0)
         INTO lvl_row_count
         FROM (
               SELECT MASTER_SAMPLE_PID1
                 FROM IP_PRODUCT_MODEL_MASTER
                WHERE MASTER_SAMPLE_PID1 = P_PID
                  AND ORGANIZATION_ID    = 1
                UNION ALL
               SELECT MASTER_SAMPLE_PID2
                 FROM IP_PRODUCT_MODEL_MASTER
                WHERE MASTER_SAMPLE_PID2 = P_PID
                  AND ORGANIZATION_ID    = 1
                UNION ALL
               SELECT MASTER_SAMPLE_PID3
                 FROM IP_PRODUCT_MODEL_MASTER
                WHERE MASTER_SAMPLE_PID3 = P_PID
                  AND ORGANIZATION_ID    = 1
               );

    EXCEPTION

       WHEN OTHERS THEN

            lvl_return := 0;
            RETURN lvl_return;

    END;

    IF lvl_row_count > 0 THEN
       lvl_return := 1;
    ELSE
       lvl_return := 0;
    END IF;

    RETURN lvl_return;


EXCEPTION

    WHEN OTHERS THEN
        lvl_return := 0;
        RETURN lvl_return;

END;
