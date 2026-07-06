CREATE OR REPLACE procedure P_GET_EDI_XML_TEST (
  /* ================================================================
   * 프로시저명  : P_GET_EDI_XML_TEST
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2021-01-14
   * 수정이력:
   *   2021-01-14 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   테스트용 EDI XML 데이터를 CLOB 형태로 생성하여 반환한다.
   *   XXADM_XML_TEST의 메시지 헤더와 본문을 CustomXML 루트로 감싸 XMLTYPE으로 변환한다.
   *   고정 MESSAGE_ID 값을 조회하므로 특정 테스트 메시지 확인 용도로 보인다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_CLOB  (OUT, CLOB) - 생성된 XML CLOB 문자열, 오류 시 NG
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   XXADM_XML_TEST - EDI XML 테스트 메시지 저장 테이블
   *     조건: MESSAGE_ID = 'LG9999999000001'
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN OTHERS - 모든 오류 발생 시 P_CLOB에 NG 문자열을 설정한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 없음
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   EXEC P_GET_EDI_XML_TEST(:P_CLOB)
   * ================================================================ */
 p_clob OUT clob )  is

  l_output_clob CLOB; -- [AI] XMLTYPE을 CLOB으로 변환한 출력값 보관 변수
  p_xmldata     XMLtype; -- [AI] 헤더와 본문을 조합한 XML 데이터 보관 변수
  --xTest raw(32767);
begin
    /*xxadm_xml_test에 출하정보 생성*/
    -- [AI] 고정 테스트 메시지 ID의 헤더와 본문을 CustomXML 구조로 조합한다.
    select  xmltype( '<?xml version="1.0" encoding="UTF-8"?>'||chr(13)||'<CustomXML>'||chr(13)||
                       messageheader||
                       messagebody||'</CustomXML>'
                    )
       into p_xmldata
     from xxadm_xml_test 
     where message_id = 'LG9999999000001' 
       ;

     -- [AI] XMLTYPE 결과를 CLOB으로 변환하여 OUT 파라미터에 반환한다.
     l_output_clob := p_xmldata.getClobVal();
     p_clob := l_output_clob ;
     --FunctionResult := UTL_RAW.CAST_TO_RAW(l_output_clob);
    -- xTest := utl_raw.cast_to_raw(c => l_output_clob);

exception
  -- [AI] 오류 발생 시 호출부가 실패를 식별할 수 있도록 NG 문자열을 반환한다.
  when others then
    p_clob :=  'NG';
end P_GET_EDI_XML_TEST;
