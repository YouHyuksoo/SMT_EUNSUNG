CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_NEW_RUN_NO
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
   *   P_SMT_DATE  (IN, DATE) - 일자 관련 값
   *   P_MODEL_NAME  (IN, VARCHAR2) - 모델 / 명칭 관련 값
   *   P_LINE_CODE  (IN, VARCHAR2) - 라인 코드
   *   P_SHIFT_CODE  (IN, VARCHAR2) - 함수 입력값
   *   P_ORG  (IN, NUMBER) - 함수 입력값
   * ================================================================
   * [AI 분석] 반환값:
   *   VARCHAR2 - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   없음 (순수 연산 함수 또는 원본 소스 기준 명시 테이블 없음)
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_GET_YEAR_CODE - 관련 업무 함수 호출
   *   F_GET_MONTH_CODE - 관련 업무 함수 호출
   *   F_GET_DAY_CODE - 관련 업무 함수 호출
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회, ELSIF 1회 / 반복문: 0회
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_NEW_RUN_NO(...) FROM DUAL;
   * ================================================================ */
 "F_GET_NEW_RUN_NO" (
   p_smt_date     IN DATE,
   p_model_name   IN VARCHAR2,
   p_line_code    IN VARCHAR2,
   p_shift_code   IN VARCHAR2,
   p_org          IN NUMBER)
   RETURN VARCHAR2
IS
   lvs_return     VARCHAR2 (20);
   lvl_sequence   NUMBER;
   pahse          VARCHAR2 (10);
   lvs_yyyy       VARCHAR2 (4);
BEGIN
   pahse := '10';
 
   lvs_return := p_line_code||p_shift_code ;
 
   lvs_return := lvs_return||f_get_year_code (p_model_name, TO_CHAR (p_smt_date, 'YYYY')); --temp
   pahse := '30';
   lvs_return :=
      lvs_return
      || f_get_month_code (p_model_name, TO_CHAR (p_smt_date, 'YYYYMM'));
   pahse := '40';
   lvs_return := lvs_return || f_get_day_code (TO_CHAR (p_smt_date, 'DD'));

   pahse := '60';

   SELECT seq_run_no_sequence.NEXTVAL INTO lvl_sequence FROM DUAL;

   pahse := '50';


   IF lvl_sequence <= 15
   THEN
      lvs_return := lvs_return || '00' || TRIM (TO_CHAR (lvl_sequence, 'XXX'));
   ELSIF lvl_sequence <= 255
   THEN
      lvs_return := lvs_return || '0' || TRIM (TO_CHAR (lvl_sequence, 'XXX'));
   ELSE
      lvs_return := lvs_return || TRIM (TO_CHAR (lvl_sequence, 'XXX'));
   END IF;

   RETURN lvs_return;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (
         -20003,
         'PAHSE=' || pahse || '  ' || p_model_name || ' ' || SQLERRM);
END;
