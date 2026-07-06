CREATE OR REPLACE PROCEDURE "P_CREATE_DZ_INTERLOCK_NG_HIS" 
  /* ================================================================
   * 프로시저명  : P_CREATE_DZ_INTERLOCK_NG_HIS
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   업무 기준 데이터 또는 바코드를 생성하고 대상 테이블에 등록한다.
   *   시퀀스, 현재일자, 입력 파라미터 등 원본 생성 규칙을 그대로 사용한다.
   *   정상 처리 또는 오류 결과는 원본 OUT 파라미터/예외 처리 흐름을 따른다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_TYPE - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IDZ_INTERLOCK_NG_HIS_DAY - 원본 로직 참조 테이블
   *   IDZ_INTERLOCK_NG_HIS_LINE - 원본 로직 참조 테이블
   *   IDZ_INTERLOCK_NG_HIS_TOP10 - 원본 로직 참조 테이블
   *   IDZ_INTERLOCK_NG_HIS_WORKSTAGE - 원본 로직 참조 테이블
   *   IQ_INTERLOCK_CHECK_RESULT - 원본 로직 참조 테이블
   *   ISYS_BATCHJOBERRLOG - 원본 로직 참조 테이블
   * ================================================================
   * [AI 분석] 호출 객체:
   *   FROM
   *   F_GET_LINE_NAME
   *   F_GET_WORKSTAGE_NAME
   * ================================================================
   * [AI 분석] 예외 처리:
   *   원본 EXCEPTION 절의 반환값, RAISE, COMMIT/ROLLBACK 흐름을 변경하지 않는다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 구현 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_CREATE_DZ_INTERLOCK_NG_HIS(...)
   * ================================================================ */
(
    P_TYPE IN VARCHAR2
)
IS

    LVS_SYSDATE       DATE; -- [AI] 내부 처리용 변수
    LVS_ERRORMSG      VARCHAR2(500);   -- [AI] 내부 처리용 변수
   
BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.
  
    LVS_SYSDATE := SYSDATE;
    
    IF P_TYPE = 'Y' THEN  -- YESTERDAY
      
       --------------------------------------------
       -- 공정통과 일자별(3일)
       --------------------------------------------
           
       delete from idz_interlock_ng_his_day
       where receipt_date >= trunc(LVS_SYSDATE -1)
         and receipt_date <  trunc(LVS_SYSDATE);
       
       insert into idz_interlock_ng_his_day
       select receipt_date , 
              total_qty , 
              ng_qty , 
              ( ng_qty / total_qty * 1000000 )  as ppm,
              1,
              sysdate,
              'BATCH',
              sysdate,
              'BATCH'
         from (
                select trunc(receipt_date ) as receipt_date ,
                       count(*) total_qty ,
                       sum( decode ( check_result , 'NG' ,1 ,0 )) as ng_qty
                  from iq_interlock_check_result 
                 where receipt_date >= trunc(LVS_SYSDATE -1)
                   and receipt_date <  trunc(LVS_SYSDATE)
                 group by trunc(receipt_date )
              );
              
    ELSE                  -- TODAY
 
       delete from idz_interlock_ng_his_day
       where receipt_date >= TRUNC(LVS_SYSDATE);
       
       insert into idz_interlock_ng_his_day
       select receipt_date , 
              total_qty , 
              ng_qty , 
              ( ng_qty / total_qty * 1000000 )  as ppm,
              1,
              sysdate,
              'BATCH',
              sysdate,
              'BATCH'
         from (
                select trunc(receipt_date ) as receipt_date ,
                       count(*) total_qty ,
                       sum( decode ( check_result , 'NG' ,1 ,0 )) as ng_qty
                  from iq_interlock_check_result 
                 where receipt_date >= TRUNC(LVS_SYSDATE)
                 group by trunc(receipt_date )
              );
                   
        
       --------------------------------------------
       -- 공정통과 라인별(3일)
       --------------------------------------------
       
       delete from idz_interlock_ng_his_line;
       
       insert into idz_interlock_ng_his_line
       select line_name , 
              total_qty , 
              ng_qty , 
              ( ng_qty / total_qty * 1000000 )  as ppm,
              1,
              sysdate,
              'BATCH',
              sysdate,
              'BATCH'
        from ( 
               select f_get_line_name( line_code, 1 ) as line_name ,
                      count(*) total_qty ,
                      sum( decode ( check_result , 'NG' ,1 ,0 )) as ng_qty
                 from iq_interlock_check_result 
                where receipt_date >= (LVS_SYSDATE - 3)
                group by  line_code
             );

       COMMIT;
          
       --------------------------------------------
       -- 공정통과 일자별(3일)
       --------------------------------------------                    
       
       delete from idz_interlock_ng_his_top10;
       
       insert into idz_interlock_ng_his_top10 
       SELECT model_name, 
              ng_qty,
              1,
              sysdate,
              'BATCH',
              sysdate,
              'BATCH'
         FROM ( 
                select model_name, ng_qty
                  from ( 
                         select model_name , sum( decode ( check_result , 'NG' ,1 ,0 )) as ng_qty 
                           from iq_interlock_check_result 
                          where receipt_date >= (LVS_SYSDATE - 3)
                          group by model_name 
                       )
                 ORDER BY NG_QTY  DESC 
               ) 
        WHERE ROWNUM < 11;
        
        COMMIT;        
        
       --------------------------------------------
       -- 공정통과 공정별(3일)
       --------------------------------------------        
        delete from IDZ_INTERLOCK_NG_HIS_WORKSTAGE;
        
        insert into idz_interlock_ng_his_WORKSTAGE
        select workstage_name, 
               total_qty , 
               ng_qty , 
               ( ng_qty / total_qty * 1000000 )  as ppm,
              1,
              sysdate,
              'BATCH',
              sysdate,
              'BATCH'
          from ( 
                 select f_get_workstage_name( workstage_code) as workstage_name,
                        count(*) total_qty ,
                        sum( decode ( check_result , 'NG' ,1 ,0 )) as ng_qty
                   from iq_interlock_check_result 
                  where receipt_date >= (LVS_SYSDATE - 3)
                  group by  workstage_code
               );
        
                 
    END IF;
  
    COMMIT;
    
EXCEPTION
  
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
    WHEN OTHERS THEN
        
         LVS_ERRORMSG := SUBSTR(SQLERRM, 1, 200); 
         ROLLBACK;
        
         BEGIN
          
             INSERT INTO ISYS_BATCHJOBERRLOG(
                                              batch_job_seq,
                                              organization_id,
                                              batch_job_process_name,
                                              batch_job_object_name,
                                              batch_job_status_code,
                                              batch_job_remark,
                                              enter_by,
                                              log_date      
                                             )
            SELECT 1,
                   1,
                   'DATAZEN',
                   'P_CREATE_DZ_INTERLOCK_NG_HIS',
                   'ERROR',
                   LVS_ERRORMSG,
                   'BATCH', 
                   sysdate 
              FROM DUAL;
              
             COMMIT;
              
        EXCEPTION
  
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
           WHEN OTHERS THEN
                NULL;
       
        END;  
  
END;