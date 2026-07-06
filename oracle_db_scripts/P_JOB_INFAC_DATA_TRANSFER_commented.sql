CREATE OR REPLACE PROCEDURE P_JOB_INFAC_DATA_TRANSFER
  /* ================================================================
   * 프로시저명  : P_JOB_INFAC_DATA_TRANSFER
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   프로시저 원본 로직의 업무 처리 흐름을 수행한다.
   *   참조 테이블과 입력 파라미터를 기반으로 조회, 등록, 갱신 또는 메시지 반환을 처리한다.
   *   원본 코드의 트랜잭션 및 예외 처리 흐름은 변경하지 않았다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   없음
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ESEAI_M107_TEMP - 원본 로직 참조 테이블
   *   ISYS_BATCHJOBERRLOG - 원본 로직 참조 테이블
   * ================================================================
   * [AI 분석] 예외 처리:
   *   원본 EXCEPTION 절의 반환값, RAISE, COMMIT/ROLLBACK 흐름을 변경하지 않는다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 구현 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_JOB_INFAC_DATA_TRANSFER(...)
   * ================================================================ */
IS

   lvl_count1     number default 0 ; -- [AI] 내부 처리용 변수
   lvl_count2     number default 0 ; -- [AI] 내부 처리용 변수
   lvs_message    varchar2(200); -- [AI] 내부 처리용 변수
   
BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.
  
      -------------------------------------------------------------------
      -- DATA 생성
      -------------------------------------------------------------------

      P_JOB_INFAC_DATA_CREATE;

      -------------------------------------------------------------------
      -- INFAC DATA 전송
      -------------------------------------------------------------------
      
      INSERT INTO ESEAI_M107 ( 
                               DT_IF, 
                               CD_SL, 
                               CD_ITEM, 
                               YN_PROCESS, 
                               DC_ERRORMSG, 
                               QT_IM, 
                               DTS_CREATE
                            )
      SELECT DT_IF, 
             CD_SL, 
             CD_ITEM, 
             YN_PROCESS, 
             DC_ERRORMSG, 
             CASE WHEN QT_IM < 0 THEN 0 ELSE QT_IM END AS QT_IM , 
             DTS_CREATE
        FROM ESEAI_M107_TEMP
       WHERE TRANSFER_YN = 'N'
         AND DT_IF       =  to_char(sysdate, 'YYYYMMDD')
         AND DTS_CREATE  >= to_char(sysdate - (5/(24*60)), 'HH24:MI:SS')
         AND DTS_CREATE  <= to_char(sysdate + (5/(24*60)), 'HH24:MI:SS');
       
       lvl_count1 := SQL%ROWCOUNT;
       
       ------------------------------------------------------------------- 
       -- 전송후 처리완료 flag setting
       -------------------------------------------------------------------
       
       UPDATE ESEAI_M107_TEMP
          SET TRANSFER_DATE = sysdate,
              TRANSFER_YN   = 'Y'
        WHERE TRANSFER_YN   = 'N'
          AND DT_IF       =  to_char(sysdate, 'YYYYMMDD')
          AND DTS_CREATE  >= to_char(sysdate - (5/(24*60)), 'HH24:MI:SS')
          AND DTS_CREATE  <= to_char(sysdate + (5/(24*60)), 'HH24:MI:SS');
        
       lvl_count2 := SQL%ROWCOUNT;
        
       -------------------------------------------------------------------
       -- insert log 생성
       -------------------------------------------------------------------
      
      lvs_message := 'INSERT => '||to_char(lvl_count1)||', UPDATE => '||to_char(lvl_count2);
       
      insert into isys_batchjoberrlog ( 
                                        batch_job_seq ,
                                        organization_id,
                                        batch_job_process_name,
                                        batch_job_object_name,
                                        batch_job_status_code,
                                        batch_job_remark,
                                        enter_by,
                                        log_date  
                                      )
                               values (
                                        null,
                                        1,
                                        'INFAC_DATA_TRANSFER',
                                        'P_JOB_INFAC_DATA_TRANSFER',
                                        'SEND OK',
                                        lvs_message,
                                        'JOB',
                                        sysdate
                                      );
                 
      COMMIT;
 

-------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------
EXCEPTION
       
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
 WHEN OTHERS THEN
      
      lvs_message := substr(SQLERRM, 1, 200);
      
      insert into isys_batchjoberrlog ( 
                                        batch_job_seq ,
                                        organization_id,
                                        batch_job_process_name,
                                        batch_job_object_name,
                                        batch_job_status_code,
                                        batch_job_remark,
                                        enter_by,
                                        log_date  
                                      )
                               values (
                                        null,
                                        1,
                                        'INFAC_DATA_TRANSFER',
                                        'P_JOB_INFAC_DATA_TRANSFER',
                                        'SEND NG',
                                        lvs_message,
                                        'JOB',
                                        sysdate
                                      );
                 
      commit;
      
END;