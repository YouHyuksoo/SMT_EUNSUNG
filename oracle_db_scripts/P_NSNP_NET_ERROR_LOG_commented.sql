CREATE OR REPLACE procedure P_NSNP_NET_ERROR_LOG (
  /* ================================================================
   * 프로시저명  : P_NSNP_NET_ERROR_LOG
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   NSNP 네트워크 오류 정보를 IQ_MACHINE_INSPECT_NSNP에 기록한다.
   *   라인에서 현재 RUN_NO를 조회하고, 오류 원인/메시지/호스트/상세 오류를 결합해 로그로 저장한다.
   *   자율 트랜잭션으로 오류 로그를 별도 COMMIT하며 오류 발생 시 ROLLBACK한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_LINE_CODE          (IN, VARCHAR2) - 라인 또는 설비 라인 코드
   *   P_MODEL_NAME         (IN, VARCHAR2) - 모델명
   *   P_MODEL_SUFFIX       (IN, VARCHAR2) - 모델 서픽스
   *   P_NSNP_REASON        (IN, VARCHAR2) - NSNP 오류 원인
   *   P_NSNP_ERROR_MESSAGE (IN, VARCHAR2) - NSNP 오류 메시지
   *   P_HOST               (IN, VARCHAR2) - 통신 대상 호스트
   *   P_ERROR_MSG          (IN, VARCHAR2) - 상세 오류 메시지
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_LINE - Product Line Master, RUN_NO 조회
   *   IQ_MACHINE_INSPECT_NSNP - NSNP 검사/오류 로그 테이블
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN OTHERS - 오류 발생 시 ROLLBACK 후 종료한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 없음
   *   DML: SELECT 1회, INSERT 1회
   *   주의: AUTONOMOUS_TRANSACTION, COMMIT 및 ROLLBACK 포함
   * ================================================================
   * 사용 예시:
   *   EXEC P_NSNP_NET_ERROR_LOG('L1', 'MODEL', 'SFX', 'REASON', 'MESSAGE', 'HOST', 'ERROR')
   * ================================================================ */
 p_line_code varchar2 ,
                                                   p_model_name varchar2, 
                                                   p_model_suffix varchar2, 
                                                   p_nsnp_reason  varchar2, 
                                                   p_nsnp_error_message varchar2, 
                                                   p_host varchar2, 
                                                   p_error_msg varchar2 )  
                                                   
is

LVL_RUN_NO VARCHAR2(30) ; -- [AI] 라인 기준 현재 Run No

pragma autonomous_transaction ; 

begin
  
             /* UPDATE ip_product_line
                 SET nsnp_status = 'ERROR',
                     nsnp_start_date = NULL,
                     COMMENTS = SUBSTR (p_error_msg, 1, 500)
               WHERE line_code = SUBSTR (p_line_code, 1, 2);*/


                -- [AI] 라인의 현재 Run No를 조회한다.
                SELECT RUN_NO INTO LVL_RUN_NO 
                  FROM IP_PRODUCT_LINE 
                WHERE LINE_CODE = P_LINE_CODE ;

               -- [AI] NSNP 네트워크 오류 상세 정보를 검사 로그 테이블에 기록한다.
               INSERT INTO iq_machine_inspect_nsnp (line_code,
                                                    machine_code,
                                                    model_name,
                                                    model_suffix,
                                                    nsnp_reason,
                                                    nsnp_error_message,
                                                    action_code,
                                                    enter_date,
                                                    enter_by,
                                                    last_modify_date,
                                                    last_modify_by,
                                                    organization_id,
                                                    run_no)
               VALUES (
                         SUBSTR (p_line_code, 1, 2),
                         p_line_code,
                         p_model_name,
                         p_model_suffix,
                         p_nsnp_reason,
                         p_nsnp_error_message
                         || ' '
                         || p_host
                         || ' '
                         || SUBSTR (p_error_msg, 1, 300),
                         'NETERROR',
                         SYSDATE,
                         'NSNP TIME',
                         SYSDATE,
                         'SYSTEM',
                         1,
                         LVL_RUN_NO);     
                         
               -- [AI] 자율 트랜잭션의 오류 로그를 확정한다.
               commit ; 
exception 
  -- [AI] 오류 발생 시 로그 기록을 되돌린다.
  when others then 
       rollback ; 
end P_NSNP_NET_ERROR_LOG;
