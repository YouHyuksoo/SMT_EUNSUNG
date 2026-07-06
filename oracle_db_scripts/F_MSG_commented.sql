CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_MSG
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   원본 함수 로직을 기준으로 업무 값을 계산, 조회 또는 변환하여 반환한다.
   *   반환 타입은 varchar2이며 호출 위치에서 후속 판단/표시에 사용된다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_MESSAGE  (IN, varchar2) - 함수 입력값
   *   P_LANG  (IN, varchar2) - 함수 입력값
   *   P_ORG  (IN, number) - 함수 입력값
   * ================================================================
   * [AI 분석] 반환값:
   *   varchar2 - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ISYS_DUAL_MESSAGE_DIRECT - 업무 기준/거래 데이터 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: SELECT 1회, INSERT 1회 / 주의: COMMIT 포함
   * ================================================================
   * 사용 예시:
   *   SELECT F_MSG(...) FROM DUAL;
   * ================================================================ */
 "F_MSG" (p_message varchar2, p_lang varchar2, p_org number ) return varchar2 is
  /*******************************************************/
  /*P_MESSAGE, P_LANG, P_ORG                             */
  /* 2017.03.27 추가 PDA 에서 호출하는 Procedure Multi Lang 처리*/
  /*******************************************************/
  
  pragma autonomous_transaction ; 
  lvs_return varchar2(4000);
  lvs_msg    varchar2(4000); 
begin
  
  begin 
    select decode( p_lang , 'K' , msg_kor , 'E' , msg_eng , 'C', msg_chn, lvs_msg )
      into lvs_msg
      from isys_dual_message_direct
     where origin_msg      = p_message
       and organization_id = nvl(p_org,1)  ;
     
     lvs_return := nvl(lvs_msg,p_message) ; 
      
  exception 
    when no_data_found then
         
      begin 
        insert into isys_dual_message_direct ( 
               origin_msg , 
               enter_date , 
               enter_by , 
               last_modify_date , 
               last_moDiFy_by , 
               organization_id 
        ) 
        values ( 
               p_message , 
               sysdate , 
               'F_MSG' , 
               sysdate , 
               'F_MSG' , 
               nvl(p_org,1) 
        ) ;
        
        commit ; 
        lvs_return := p_message ; 
        
      exception 
        when others then 
          rollback ; 
          lvs_return := p_message ; 
      end ; 
         
  end ; 
  
  return lvs_return  ; 
   
end F_MSG;
