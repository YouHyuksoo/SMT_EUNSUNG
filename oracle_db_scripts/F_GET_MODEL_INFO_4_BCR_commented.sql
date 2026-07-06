CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_MODEL_INFO_4_BCR
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
   *   P_RUN_NO  (IN, VARCHAR2) - 작업지시/런 번호
   *   P_TYPE  (IN, varchar2) - 함수 입력값
   * ================================================================
   * [AI 분석] 반환값:
   *   varchar2 - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_2D_BARCODE - 바코드 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_MODEL_INFO_4_BCR(...) FROM DUAL;
   * ================================================================ */
 "F_GET_MODEL_INFO_4_BCR" (p_run_no IN VARCHAR2, p_type in varchar2 default 'MODEL_SPEC' )
   RETURN varchar2
IS
   lvs_return   varchar2(50);
BEGIN

     SELECT decode(p_type, 'HW_VERSION', NVL(substr(serial_no, 14, 2),''),
                           'SW_VERSION', NVL(substr(serial_no, 16, 2),''),
                           'INDEX',      NVL(substr(serial_no, 18, 2),''),
                           'ERROR' )
       INTO lvs_return
       FROM ip_product_2d_barcode
      WHERE run_no          = p_run_no
        AND rownum          = 1;

   RETURN lvs_return;
   
EXCEPTION
   WHEN OTHERS THEN
        RETURN '';
END;
