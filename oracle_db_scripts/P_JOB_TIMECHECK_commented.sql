CREATE OR REPLACE PROCEDURE "P_JOB_TIMECHECK" (
  /* ================================================================
   * 프로시저명  : P_JOB_TIMECHECK
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   작업 번호 기준으로 작업 시간 측정 시작 또는 종료 시각을 기록한다.
   *   P_FLAG가 S이면 ISYS_JOB_TIMECHECK에 시작 이력을 INSERT한다.
   *   그 외 값이면 같은 작업 번호의 END_DATE를 현재 시각으로 UPDATE한다.
   *   자율 트랜잭션으로 처리되어 호출 트랜잭션과 별도로 COMMIT/ROLLBACK된다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_WORK_NO  (IN, NUMBER) - 시간 측정 대상 작업 번호
   *   P_FLAG     (IN, VARCHAR2) - 처리 구분, S는 시작, 그 외는 종료
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ISYS_JOB_TIMECHECK - 작업 시간 측정 이력 테이블
   *     처리: 시작 시 INSERT, 종료 시 END_DATE UPDATE
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN OTHERS - 오류 발생 시 ROLLBACK 후 종료한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 1회 / 반복문: 없음
   *   DML: INSERT 1회 또는 UPDATE 1회
   *   주의: AUTONOMOUS_TRANSACTION, COMMIT 및 ROLLBACK 포함
   * ================================================================
   * 사용 예시:
   *   EXEC P_JOB_TIMECHECK(1001, 'S')
   * ================================================================ */
 p_work_no NUMBER,
                                             p_flag    varchar2 )
    /******************************************************************************/
    /* Object Name  : worklog_start                                               */
    /* Description  : Work시작시 Log생성                                          */
    /* Parameter                                                                  */
    /******************************************************************************/
    IS
        PRAGMA AUTONOMOUS_TRANSACTION;

    BEGIN
        -- [AI] 플래그에 따라 작업 시간 시작 등록 또는 종료 갱신을 수행한다.
        if p_flag = 'S' then
           INSERT INTO ISYS_JOB_TIMECHECK
           ( start_date,
              end_date,
              workno,
              attr2,
              attr3
           )
            VALUES
            (
              sysdate,
              null,
              p_work_no,
              'a',
              'a'

            );
        else
           update isys_job_timecheck
              set end_date = sysdate
            where workno = p_work_no ;

        end if;



        -- [AI] 자율 트랜잭션으로 시간 측정 기록을 확정한다.
        COMMIT;
    EXCEPTION
        -- [AI] 오류 발생 시 자율 트랜잭션 변경 사항을 되돌린다.
        WHEN OTHERS THEN
            ROLLBACK;

    END p_job_timecheck;
