CREATE OR REPLACE function
  /* ================================================================
   * 함수명  : F_GET_EDI_XML_TEST
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   입력 파라미터와 기준 테이블을 이용해 업무 코드, 명칭, 수량, 상태 등의 조회 값을 반환한다.
   *   조회 실패 또는 예외 상황에서는 원본 로직에 정의된 기본값/NULL/오류 처리를 따른다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   없음 - 입력 파라미터 없이 내부 기준값 또는 시스템 값을 반환
   * ================================================================
   * [AI 분석] 반환값:
   *   clob - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   XXADM_XML_TEST - 업무 기준/거래 데이터 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   명시적 EXCEPTION 블록 없음 - 호출부에서 표준 Oracle 예외를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_EDI_XML_TEST(...) FROM DUAL;
   * ================================================================ */
 F_GET_EDI_XML_TEST return clob is
  FunctionResult CLOB;
  l_output_clob CLOB;
  p_xmldata     XMLtype;
  xTest raw(32767); 
begin
    /*xxadm_xml_test에 출하정보 생성*/
    select  xmltype( '<?xml version="1.0" encoding="UTF-8"?>'||chr(13)||'<CustomXML>'||chr(13)||
                       messageheader||  
                       messagebody||'</CustomXML>'
                    )
       into p_xmldata
     from xxadm_xml_test 
     where message_id = 'LG9999999000001'    ; 
     
     l_output_clob := p_xmldata.getClobVal();
     FunctionResult := l_output_clob ;
     --FunctionResult := UTL_RAW.CAST_TO_RAW(l_output_clob);
     xTest := utl_raw.cast_to_raw(c => l_output_clob); 
     
  return(FunctionResult);
end F_GET_EDI_XML_TEST;
