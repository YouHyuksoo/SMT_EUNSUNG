CREATE OR REPLACE PROCEDURE "P_JOB_SQUEEZE_RESET" 
    /* ================================================================
     * 프로시저명  : P_JOB_SQUEEZE_RESET
     * 작성자  : 지성솔루션컨설팅
     * 작성일  : 2021-07-09
     * 수정이력:
     *   2021-07-09 - 지성솔루션컨설팅 - 최초 작성
     *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
     * ================================================================
     * [AI 분석] 기능 설명:
     *   전일 라인에 투입된 스퀴즈 지그의 장력 점검 여부를 미점검 상태로 초기화한다.
     *   IMCN_JIG_INPUT_HIST에서 전일 투입 이력이 있는 스퀴즈 지그를 찾는다.
     *   대상 IMCN_JIG의 TENSION_CHECK_YN을 N으로 변경하고 수정 정보를 RESET BATCH로 기록한다.
     *   처리 후 COMMIT을 수행하며, 오류 시 ROLLBACK한다.
     * ================================================================
     * [AI 분석] 파라미터:
     *   없음
     * ================================================================
     * [AI 분석] 참조 테이블:
     *   IMCN_JIG - 지그 마스터 테이블
     *     처리: TENSION_CHECK_YN, LAST_MODIFY_DATE, LAST_MODIFY_BY 갱신
     *   IMCN_JIG_INPUT_HIST - 지그 라인 투입 이력 테이블
     *     조건: 전일 INPUT_DATE 범위 및 JIG_TYPE = 'S'
     * ================================================================
     * [AI 분석] 예외 처리:
     *   WHEN OTHERS - 오류 발생 시 ROLLBACK 후 종료한다.
     * ================================================================
     * [AI 분석] 복잡도:
     *   조건 분기: IF 0회 / 반복문: 없음
     *   DML: UPDATE 1회, SELECT 1회
     *   주의: COMMIT 및 ROLLBACK 포함
     * ================================================================
     * 사용 예시:
     *   EXEC P_JOB_SQUEEZE_RESET
     * ================================================================ */
    /******************************************************************************/
    /* Object Name  : worklog_start                                               */
    /* Description  : Work시작시 Log생성                                          */
    /* Parameter                                                                  */
    /******************************************************************************/
    IS
        
    BEGIN
      
        -- [AI] 전일 투입 이력이 있는 스퀴즈 지그의 장력 점검 상태를 초기화한다.
        update imcn_jig
           set tension_check_yn = 'N',
               last_modify_date = sysdate,
               last_modify_by   = 'RESET BATCH'
         where jig_type         = 'S'
           and ( jig_code, jig_lot_no ) in (
                                             select jig_code, jig_lot_no
                                               from imcn_jig_input_hist
                                              where input_date >= trunc(sysdate -1)
                                                and input_date <  trunc(sysdate)
                                                and jig_type = 'S'
                                           );

        -- [AI] 스퀴즈 점검 상태 초기화 결과를 확정한다.
        COMMIT;
        
    EXCEPTION
        -- [AI] 처리 중 오류 발생 시 변경 내용을 되돌린다.
        WHEN OTHERS THEN
             ROLLBACK;

    END;
