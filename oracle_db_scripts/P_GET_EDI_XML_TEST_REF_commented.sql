CREATE OR REPLACE procedure P_GET_EDI_XML_TEST_REF (
  /* ================================================================
   * 프로시저명  : P_GET_EDI_XML_TEST_REF
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2021-02-09
   * 수정이력:
   *   2021-02-09 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   전송 대기 상태의 EDI XML 테스트 데이터를 전송 준비 상태로 변경하고 커서로 반환한다.
   *   날짜와 SEQ_XML_TRANSFER_ID 시퀀스를 조합해 전송 ID를 생성한다.
   *   TRANSFER_FLAG가 N인 데이터를 R로 변경한 뒤 XML CLOB, MESSAGE_ID, TRANSFER_ID를 조회한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_CURSOR  (OUT, SYS_REFCURSOR) - 전송 준비 XML 데이터 조회 결과 커서
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   XXADM_XML_TEST - EDI XML 테스트 메시지 저장 테이블
   *     처리: TRANSFER_FLAG N -> R, TRANSFER_ID 설정 후 커서 반환
   * ================================================================
   * [AI 분석] 호출 객체:
   *   SEQ_XML_TRANSFER_ID - 전송 ID 순번 생성 시퀀스
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN NO_DATA_FOUND - 아무 동작 없이 종료한다.
   *   WHEN OTHERS - 원 예외를 다시 발생시킨다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 없음
   *   DML: SELECT 2회, UPDATE 1회
   *   주의: COMMIT 포함
   * ================================================================
   * 사용 예시:
   *   EXEC P_GET_EDI_XML_TEST_REF(:P_CURSOR)
   * ================================================================ */
  p_cursor OUT sys_refcursor )  is


  --xTest raw(32767);
  lvl_transfer_id number ; -- [AI] 전송 대상 묶음을 식별하는 전송 ID
begin
     /**************************
     * 1.처리대상 확정 
        create sequence SEQ_XML_TRANSFER_ID
        minvalue 1
        maxvalue 99999
        start with 1
        increment by 1
        cache 2
        cycle; 
     **************************/
     -- [AI] 현재일자와 시퀀스를 조합해 전송 ID를 생성한다.
     select to_number(to_char(sysdate,'yyyymmdd')||trim(to_char(SEQ_XML_TRANSFER_ID.NEXTVAL,'00000')))
       into lvl_transfer_id 
       from dual ; 
     

     -- [AI] 전송 대기 데이터를 전송 준비 상태로 표시하고 전송 ID를 부여한다.
     update xxadm_xml_test t
        set t.transfer_flag = 'R', 
            t.transfer_id   = lvl_transfer_id 
      where t.transfer_flag = 'N' 
     ;
     
     commit ;
     /*******************************
     * 2.헤드 + body , Message_id Key 
     ********************************/
     /*xxadm_xml_test에 출하정보 생성*/
     -- [AI] 전송 준비 상태의 XML 메시지를 CLOB 형태로 커서 반환한다.
     OPEN p_cursor FOR
     select xmltype( '<?xml version="1.0" encoding="UTF-8"?>'||chr(13)||'<CustomXML>'||chr(13)||
                        messageheader||
                        messagebody||'</CustomXML>'
                     ).getclobval() as xml_data,
            message_id as message_id, 
            transfer_id
           
       from xxadm_xml_test
      where transfer_flag = 'R'
       -- and transfer_id   = lvl_transfer_id 
    ;
    /********************************************************************************
    * 3.정상처리시 UI 에서 Message ID, trasfer_flag = 'R' 기준으로 Transfer_Flag = 'Y' 처리 *
    *********************************************************************************/
    -- l_output_clob := p_xmldata.getClobVal();
    -- p_clob := l_output_clob ;
    --FunctionResult := UTL_RAW.CAST_TO_RAW(l_output_clob);
    -- xTest := utl_raw.cast_to_raw(c => l_output_clob);

exception
  -- [AI] 처리 대상이 없으면 별도 반환 없이 종료한다.
  WHEN NO_DATA_FOUND THEN
   NULL;
  -- [AI] 기타 오류는 호출부가 처리하도록 다시 발생시킨다.
  WHEN OTHERS THEN
   RAISE;
end P_GET_EDI_XML_TEST_REF;
