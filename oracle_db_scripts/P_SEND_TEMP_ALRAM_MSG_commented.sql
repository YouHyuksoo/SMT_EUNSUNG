CREATE OR REPLACE PROCEDURE P_SEND_TEMP_ALRAM_MSG 
  /* ================================================================
   * 프로시저명  : P_SEND_TEMP_ALRAM_MSG
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-10-05
   * 수정이력:
   *   2020-10-05 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   온습도 데이터가 설비 기준 범위를 벗어난 항목이 있는지 확인하고 알림 문자를 발송한다.
   *   ICOM_TEMPERATURE_DATA와 IMCN_MACHINE을 비교해 이상 설비명을 집계한다.
   *   이상 건수가 있으면 알림 수신 사용자 휴대폰 번호를 모아 TEST_P_ALIGO_HTTP_SEND를 호출한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   없음
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ICOM_TEMPERATURE_DATA - 온습도데이터
   *   IMCN_MACHINE - 설비 마스터
   *   ISYS_USERS - User Master
   * ================================================================
   * [AI 분석] 호출 객체:
   *   TEST_P_ALIGO_HTTP_SEND - 알림 문자 발송 처리
   * ================================================================
   * [AI 분석] 예외 처리:
   *   별도 EXCEPTION 절 없음 - 오류 발생 시 호출부로 전달된다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 1회 / 반복문: 없음
   *   DML: SELECT 2회
   * ================================================================
   * 사용 예시:
   *   EXEC P_SEND_TEMP_ALRAM_MSG
   * ================================================================ */
AS 

lvs_receiver varchar2(100) ; -- [AI] 알림 문자 수신자 휴대폰 번호 목록
lvs_msg varchar2(200) ; -- [AI] 발송할 온습도 이상 알림 메시지
lvi_count  number ; -- [AI] 온습도 이상 설비 건수

BEGIN

    -------------------------------------------------------
    --  온도 이상점 있는지 체크 
    -------------------------------------------------------
    -- [AI] 설비별 기준 범위를 벗어난 온습도 데이터 건수와 설비명을 집계한다.
    select cnt  ,to_char(sysdate, 'YYYY/MM/DD HH24:MI:SS')||' 온습도 이상발생 '|| machine_name
     into lvi_count , LVS_MSG
     from 
     (
       select count(*) as cnt ,  LISTAGG(m.machine_name, ',') WITHIN GROUP (ORDER BY m.machine_name) as machine_name
       from ICOM_TEMPERATURE_DATA t , IMCN_MACHINE m 
      where t.nodeid = m.machine_code
        and ( t.room_temperature  < m.min_temp_value or 
              t.room_temperature  > m.max_temp_value or 
              t.humidity < m.min_humidity_value or 
              t.humidity > m.max_humidity_value
            )
  
        and m.workstage_code <> 'W020' 

     );
     
    -- [AI] 이상 설비가 있으면 알림 수신자를 조회해 문자 발송 프로시저를 호출한다.
    if NVL(lvi_count,0) > 0 then 
    
         select LISTAGG(HANDPHONE_NO, ',') WITHIN GROUP (ORDER BY HANDPHONE_NO) as HANDPHONE_NO
           into lvs_receiver
             FROM ISYS_USERS 
           where alram_msg_receiver = 'Y'
           and HANDPHONE_NO is not null 
        ;
        
       --  LVS_MSG := to_char(sysdate, 'YYYY/MM/DD HH24:MI:SS')||' 온습도 이상발생 알림 조치 바랍니다.' ;
    
         TEST_P_ALIGO_HTTP_SEND( lvs_receiver , lvs_msg , 'N' ) ;
    else
       null ;
    end if ;
    
END P_SEND_TEMP_ALRAM_MSG;
