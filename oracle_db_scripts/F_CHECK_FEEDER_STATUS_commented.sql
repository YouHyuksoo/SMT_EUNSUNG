CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_CHECK_FEEDER_STATUS
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
   *   P_BARCODE  (IN, VARCHAR2) - 바코드
   * ================================================================
   * [AI 분석] 반환값:
   *   VARCHAR2 - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IMCN_MOLD - 업무 기준/거래 데이터 조회 또는 참조
   *   IMCN_MOLD_INVENTORY - 재고 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 4회 / 반복문: 0회
   *   DML: SELECT 5회
   * ================================================================
   * 사용 예시:
   *   SELECT F_CHECK_FEEDER_STATUS(...) FROM DUAL;
   * ================================================================ */
 "F_CHECK_FEEDER_STATUS" (p_barcode IN VARCHAR2)
   RETURN VARCHAR2
IS
-- ---------   ------  -------------------------------------------
   lvs_status              VARCHAR2 (10);
   lvs_mold_group          VARCHAR2 (10);
   lvdt_last_adjust_date   DATE;
BEGIN
   BEGIN
      SELECT mold_group
        INTO lvs_mold_group
        FROM imcn_mold
       WHERE mold_code = (SELECT mold_code
                            FROM imcn_mold_inventory
                           WHERE barcode = p_barcode);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN 'NotFound';
   END;

   IF lvs_mold_group = 'PD'
   THEN
      SELECT last_adjust_date
        INTO lvdt_last_adjust_date
        FROM imcn_mold_inventory
       WHERE barcode = p_barcode;

      IF NVL (lvdt_last_adjust_date, SYSDATE) < SYSDATE - 60
      THEN
         RETURN 'T';
      ELSE
         SELECT mold_use_status
           INTO lvs_status
           FROM imcn_mold_inventory
          WHERE barcode = p_barcode;

         RETURN lvs_status;
      END IF;
   ELSE
      SELECT CASE
                WHEN NVL (break_value, 200000) - NVL (actual_value, 0) > 0
                   THEN 'U'
                ELSE 'T'
             END
        INTO lvs_status
        FROM imcn_mold_inventory
       WHERE barcode = p_barcode;
   END IF;

   RETURN lvs_status;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 'NotFound';
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;
