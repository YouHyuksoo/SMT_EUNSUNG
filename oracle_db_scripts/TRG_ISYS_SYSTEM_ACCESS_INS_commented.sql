CREATE OR REPLACE trigger trg_isys_system_access_ins
  /* ================================================================
   * 트리거명  : TRG_ISYS_SYSTEM_ACCESS_INS
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   ISYS_SYSTEM_ACCESS 테이블의 INSERT 이벤트 발생 시 원본 트리거 로직에 정의된 후속 처리를 자동 수행한다.
   *   업무 데이터의 기본값 설정, 검증, 이력 기록 또는 연계 테이블 갱신에 사용된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: INSERT
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   ISYS_SYSTEM_ACCESS - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.SYSTEM_ACCESS_TYPE - 신규/변경 후 값 값
   *   :NEW.ACCESS_BY - 신규/변경 후 값 값
   *   :NEW.IP_ADDRESS - 신규/변경 후 값 값
   *   :NEW.ACCESS_DATE - 신규/변경 후 일자 관련 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ISYS_SYSTEM_ACCESS - 업무 데이터 트리거 대상 테이블
   *   SMART_FACTORY_USE_LOG_IF - 로그 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 호출 객체:
   *   P_SMART_FACTORY_API_LOG_POST - 트리거 내부 업무 처리 호출
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회 / 반복문: 0회
   *   DML: INSERT 2회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_ISYS_SYSTEM_ACCESS_INS';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_ISYS_SYSTEM_ACCESS_INS';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */

  before insert
  on ISYS_SYSTEM_ACCESS 
  for each row
declare
  -- local variables here
  lvs_out varchar2(200);
  
begin
  

  if :new.system_access_type IN ( 'LOGON','LOGOFF') then  
    
 
       -- API 전송 
       
   

       P_SMART_FACTORY_API_LOG_POST('$5$API$PwbkISAXo.TR1E0pJIbzZ89D3G3kzar7gmjZTFaHCNA',                      -- 은성전장 로그 API KEY
                                    to_char(systimestamp,'yyyy-mm-dd hh24:mi:ss.ff3'), 
                                    :new.system_access_type, 
                                    :new.access_by,
                                    :NEW.IP_ADDRESS,
                                    '0',
                                    lvs_out);
      --                         

      insert into smart_factory_use_log_if ( 
                                             crtfckey, 
                                             logdt_date, 
                                             logdt, 
                                             usese, 
                                             sysuser, 
                                             conectip, 
                                             datausgqty, 
                                             api_message,
                                             transfer_flag, 
                                             transfer_date
                                           ) 
                                    values ( 
                                             '$5$API$PwbkISAXo.TR1E0pJIbzZ89D3G3kzar7gmjZTFaHCNA',              -- 은성전장 로그 API KEY
                                             to_char(:new.access_date,'yyyy-mm-dd hh24:mi:ss')||'.000', 
                                             to_char(systimestamp,'yyyy-mm-dd hh24:mi:ss.ff3'), 
                                             decode(:new.system_access_type,'LOGON','접속','LOGOFF','종료'), 
                                             :new.access_by, 
                                             :NEW.IP_ADDRESS, 
                                             '0', 
                                             lvs_out, 
                                             'Y', 
                                             sysdate 
                                          ) ;
       
 
       
   end if ;
   
   
exception 
  
  when others then 
       null ; 
    
end trg_isys_system_access_ins;
