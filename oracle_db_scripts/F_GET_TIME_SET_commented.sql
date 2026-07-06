CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_TIME_SET
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
   *   P_DATE  (IN, DATE) - 일자 관련 값
   *   P_ORG  (IN, NUMBER) - 함수 입력값
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
   *   조건 분기: IF 2회, ELSIF 10회 / 반복문: 0회
   *   DML: 없음
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_TIME_SET(...) FROM DUAL;
   * ================================================================ */
 "F_GET_TIME_SET" (p_date IN DATE, p_org IN NUMBER)
/* Formatted on 2015-06-19 10:30:31 (QP5 v5.126) */
    RETURN VARCHAR2
IS
    lvs_time_set   VARCHAR2 (20);
BEGIN
    IF TO_CHAR (p_date, 'HH24MI') > '0820' AND TO_CHAR (p_date, 'HH24MI') <= '1020'
    THEN
        lvs_time_set := '1A 0820-1020';
    ELSIF TO_CHAR (p_date, 'HH24MI') > '1020' AND TO_CHAR (p_date, 'HH24MI') <= '1320'
    THEN
        lvs_time_set := '1B 1020-1320';
    ELSIF TO_CHAR (p_date, 'HH24MI') > '1320' AND TO_CHAR (p_date, 'HH24MI') <= '1520'
    THEN
        lvs_time_set := '1C 1320-1520';
    ELSIF TO_CHAR (p_date, 'HH24MI') > '1520' AND TO_CHAR (p_date, 'HH24MI') <= '1730'
    THEN
        lvs_time_set := '1D 1520-1730';
    ELSIF TO_CHAR (p_date, 'HH24MI') > '1730' AND TO_CHAR (p_date, 'HH24MI') <= '2020'
    THEN
        lvs_time_set := '1E 1730-2020';
    ELSIF TO_CHAR (p_date, 'HH24MI') > '2020' AND TO_CHAR (p_date, 'HH24MI') <= '2220'
    THEN
        lvs_time_set := '2A 2020-2220';

    ELSIF TO_CHAR (p_date, 'HH24MI') > '2220' AND TO_CHAR (p_date, 'HH24MI') <= '2359'
    THEN
        lvs_time_set := '2B 2220-0120';

    ELSIF TO_CHAR (p_date, 'HH24MI') >= '0000' AND TO_CHAR (p_date, 'HH24MI') <= '0120'
    THEN
        lvs_time_set := '2B 2220-0120';
    ELSIF TO_CHAR (p_date, 'HH24MI') > '0120' AND TO_CHAR (p_date, 'HH24MI') <= '0320'
    THEN
        lvs_time_set := '2C 0120-0320';
    ELSIF TO_CHAR (p_date, 'HH24MI') > '0320' AND TO_CHAR (p_date, 'HH24MI') <= '0530'
    THEN
        lvs_time_set := '2D 0320-0530';
    ELSIF TO_CHAR (p_date, 'HH24MI') > '0530' AND TO_CHAR (p_date, 'HH24MI') <= '0820'
    THEN
        lvs_time_set := '2E 0530-0820';
    ELSE
        lvs_time_set := TO_CHAR (p_date, 'HH24MI');
    END IF;

    RETURN lvs_time_set;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        RETURN '*';
    WHEN otherS
    THEN
        raise_application_error (-20003, SQLERRM);
END;
