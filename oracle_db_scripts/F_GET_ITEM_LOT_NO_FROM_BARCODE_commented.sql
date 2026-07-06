CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_ITEM_LOT_NO_FROM_BARCODE
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
   *   P_BARCODE  (IN, VARCHAR2) - 바코드
   * ================================================================
   * [AI 분석] 반환값:
   *   VARCHAR2 - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   없음 (순수 연산 함수 또는 원본 소스 기준 명시 테이블 없음)
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회, ELSIF 2회 / 반복문: 0회
   *   DML: 없음
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_ITEM_LOT_NO_FROM_BARCODE(...) FROM DUAL;
   * ================================================================ */
 "F_GET_ITEM_LOT_NO_FROM_BARCODE" (
    p_barcode IN VARCHAR2)
    RETURN VARCHAR2
IS
    lvs_return   VARCHAR2 (100);
    lvi_pos_exists NUMBER ; 
    lvi_pos1     NUMBER;
BEGIN
    lvi_pos_exists := INSTR (p_barcode, '-', 1,1) ;
    lvi_pos1 := INSTR (p_barcode, '-', 1,3);

    -- 없으면 
    IF lvi_pos_exists = 0
    THEN
        lvs_return := TRIM (SUBSTR (p_barcode, 1, 100));
    ELSIF lvi_pos_exists > 0 AND  lvi_pos1 = 0 
    THEN -- 두개짜리 바코드 
        lvs_return := TRIM (SUBSTR (p_barcode, 1, INSTR (p_barcode, '-', 1,1) - 1));
    ELSIF  lvi_pos_exists > 0 AND  lvi_pos1  > 0   -- 3개짜리 바코드 면 두번째 - 까지 품목 코드로 구분 
    THEN
        lvs_return := TRIM (SUBSTR (p_barcode, 1, INSTR (p_barcode, '-', 1,2) - 1));
    END IF;


    RETURN lvs_return;
EXCEPTION
    WHEN OTHERS
    THEN
        RETURN NULL;
END;
