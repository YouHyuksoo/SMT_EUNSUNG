CREATE OR REPLACE PROCEDURE P_SCAN_PID
  (
  /* ================================================================
   * 프로시저명  : P_SCAN_PID
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2021-02-15
   * 수정이력:
   *   2021-02-15 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   SSCD 데이터 체크 대상 PID의 스캔 이력을 등록 또는 갱신한다.
   *   기존 PID가 없으면 신규 INSERT하고, 있으면 스캔일자와 체크 상태를 UPDATE한다.
   *   정상 처리 시 OK와 준비 메시지를 반환하고 COMMIT한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_PID           (IN, VARCHAR2) - 스캔한 PID
   *   P_LINE_CODE     (IN, VARCHAR2) - 스캔 라인 코드
   *   P_MACHINE_CODE  (IN, VARCHAR2) - 스캔 설비 코드
   *   P_OUT           (OUT, VARCHAR2) - 처리 결과, OK 또는 NG
   *   P_MESSAGE       (OUT, VARCHAR2) - 처리 메시지 또는 오류 메시지
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_SSCD_DATA_CHECK - PID별 SSCD 데이터 체크 상태 테이블
   *     처리: PID 미존재 시 INSERT, 존재 시 UPDATE
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN OTHERS - P_OUT에 NG, P_MESSAGE에 SQLERRM을 설정한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 1회 / 반복문: 없음
   *   DML: SELECT 1회, INSERT 1회 또는 UPDATE 1회
   *   주의: COMMIT 포함
   * ================================================================
   * 사용 예시:
   *   EXEC P_SCAN_PID('PID01', 'L1', 'MC01', :P_OUT, :P_MESSAGE)
   * ================================================================ */
 P_PID IN varchar2,
    P_LINE_CODE IN varchar2,
    P_MACHINE_CODE IN varchar2,
    P_OUT out varchar2,
    P_MESSAGE out varchar2)
IS
   lv_count    integer; -- [AI] PID 기존 등록 건수
BEGIN
   -- [AI] 출력 결과와 메시지를 초기화한다.
   P_OUT := '';
   P_MESSAGE := '';
   
   -- [AI] 입력 PID의 기존 스캔 체크 데이터 존재 여부를 확인한다.
   select count(1)
     into lv_count
     from ip_product_sscd_data_check
    where pid = p_pid;
    
   -- [AI] PID 존재 여부에 따라 신규 등록 또는 기존 이력 갱신을 수행한다.
   if (lv_count = 0) then 
     insert into ip_product_sscd_data_check(pid, 
                                            scan_date,
                                            line_code,
                                            machine_code,
                                            check_status,
                                            enter_date,
                                            enter_by)
     values (p_pid, 
             sysdate, 
             p_line_code, 
             P_MACHINE_CODE, 
             1, 
             sysdate, 
             'SCAN');
   else
     update ip_product_sscd_data_check t
        set t.last_modify_date = sysdate,
            t.last_modify_by = 'SCAN',
            t.scan_date = sysdate,
            t.check_status = 1
      where t.pid = p_pid;
            
   end if;
   
   -- [AI] 정상 처리 결과와 현재 시각 메시지를 반환하고 변경 사항을 확정한다.
   P_OUT := 'OK' ;
   P_MESSAGE := 'Ready 바코드입니다 '||TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS') ;      
   COMMIT;
   RETURN;
EXCEPTION
   -- [AI] 오류 발생 시 실패 코드와 오류 메시지를 반환한다.
   WHEN others THEN
     P_OUT := 'NG' ;
     P_MESSAGE := SQLERRM ;
END;
