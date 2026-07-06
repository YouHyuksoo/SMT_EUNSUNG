CREATE OR REPLACE PROCEDURE "P_INTERLOCK_SET_REFLOW" (p_line_code     IN     VARCHAR2,
  /* ================================================================
   * 프로시저명  : P_INTERLOCK_SET_REFLOW
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   리플로우 검사 결과를 라인별 상태 테이블에 등록 또는 갱신한다.
   *   라인, 파일명, 검사일자, 존번호, 온도, 산소농도, 솔더 타입, 결과 값을 저장한다.
   *   기존 라인 데이터 존재 여부에 따라 INSERT 또는 UPDATE를 수행한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_LINE_CODE (IN, VARCHAR2) - 라인 코드
   *   P_FILE_NAME (IN, VARCHAR2) - 검사 파일명
   *   P_CHECK_DATE (IN, VARCHAR2) - 검사 일시
   *   P_ZONE_NO (IN, VARCHAR2) - 리플로우 존 번호
   *   P_SET_TEMP (IN, VARCHAR2) - 설정 온도
   *   P_CHECK_TEMP (IN, VARCHAR2) - 측정 온도
   *   P_AIR_DENSITY (IN, VARCHAR2) - 산소 농도
   *   P_AIR_N2_TYPE (IN, VARCHAR2) - Air/N2 구분
   *   P_SOLDER_TYPE (IN, VARCHAR2) - 솔더 타입
   *   P_RESULT (IN, VARCHAR2) - 검사 결과
   *   P_OUT (OUT, VARCHAR2) - 처리 결과
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IQ_INTERLOCK_REFLOW_STATUS - 리플로우 온도 검사 상태 테이블
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN OTHERS/NO_DATA_FOUND 등 원본 예외 처리 흐름을 유지한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 로직 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_INTERLOCK_SET_REFLOW('L1','FILE',SYSDATE,'1','250','245','100','N2','S','OK',:P_OUT)
   * ================================================================ */
                                  p_file_name     IN     VARCHAR2, -- [AI] 내부 처리용 변수
                                  p_check_date    IN     VARCHAR2, -- [AI] 내부 처리용 변수
                                  p_zone_no       IN     VARCHAR2, -- [AI] 내부 처리용 변수
                                  p_set_temp      IN     VARCHAR2, -- [AI] 내부 처리용 변수
                                  p_check_temp    IN     VARCHAR2, -- [AI] 내부 처리용 변수
                                  p_air_density   IN     VARCHAR2, -- [AI] 내부 처리용 변수
                                  p_air_n2_type   IN     VARCHAR2, -- [AI] 내부 처리용 변수
                                  p_solder_type   IN     VARCHAR2,  --FILE NAME PREFIX 2 DIGIT -- [AI] 내부 처리용 변수
                                  p_result        IN     VARCHAR2, -- [AI] 내부 처리용 변수
                                  p_out              OUT VARCHAR2) -- [AI] 내부 처리용 변수
IS
    r_count   INTEGER := 0; -- [AI] 내부 처리용 변수
BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.
    BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.
        SELECT   COUNT (1)
          INTO   r_count
          FROM   iq_interlock_reflow_status
         WHERE   line_code = p_line_code;
    EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
        WHEN NO_DATA_FOUND
        THEN
            r_count := 0;
    END;

    IF r_count > 0
    THEN
        UPDATE   iq_interlock_reflow_status
           SET   file_name = p_file_name,
                 check_date = SYSDATE,
                 zone_no = zone_no,
                 set_temp = p_set_temp,
                 check_temp = p_check_temp,
                 reflow_result = p_result,
                 air_density = p_air_density,
                 air_n2_type = p_air_n2_type,
                 solder_type = p_solder_type,
                 comments = p_check_date,
                 organization_id = 1
         WHERE   line_code = p_line_code;
    ELSE
        INSERT INTO iq_interlock_reflow_status (line_code,
                                                file_name,
                                                check_date,
                                                zone_no,
                                                set_temp,
                                                check_temp,
                                                air_density,
                                                air_n2_type,
                                                solder_type,
                                                reflow_result,
                                                comments,
                                                organization_id)
          VALUES   (p_line_code,
                    p_file_name,
                    SYSDATE,
                    p_zone_no,
                    p_set_temp,
                    p_check_temp,
                    p_air_density,
                    p_air_n2_type,
                    p_solder_type,
                    p_result,
                    p_check_date,
                    1);
    END IF;

    p_out := 'OK';

    COMMIT;
    RETURN;
EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
    WHEN OTHERS
    THEN
        raise_application_error (-20003, SQLERRM);
END;