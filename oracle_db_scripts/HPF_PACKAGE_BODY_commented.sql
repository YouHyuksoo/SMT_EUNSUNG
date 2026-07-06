CREATE OR REPLACE PACKAGE BODY
  /* ================================================================
   * 패키지 본문명  : HPF
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   관련 업무 프로시저와 함수를 하나의 네임스페이스로 묶어 제공하는 패키지이다.
   *   PACKAGE BODY 소스 기준으로 공개 선언 또는 구현 로직을 관리한다.
   * ================================================================
   * [AI 분석] 공개/구현 객체:
   *   PROCEDURE XML_HEADER - 패키지 내 업무 처리 단위
   *   PROCEDURE XML_FOOTER - 패키지 내 업무 처리 단위
   *   PROCEDURE XML_BEGIN_TAG - 패키지 내 업무 처리 단위
   *   PROCEDURE XML_END_TAG - 패키지 내 업무 처리 단위
   *   PROCEDURE XML_PRINT_ELEMENT - 패키지 내 업무 처리 단위
   *   PROCEDURE XML_MESSAGE - 패키지 내 업무 처리 단위
   *   PROCEDURE XML_ERROR - 패키지 내 업무 처리 단위
   *   PROCEDURE XML_EXCEPTION - 패키지 내 업무 처리 단위
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   없음 (패키지 선언부 또는 명시 테이블 없음)
   * ================================================================
   * [AI 분석] 예외 처리:
   *   명시적 EXCEPTION 블록 없음 - 호출부에서 표준 Oracle 예외를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: 없음 / 주의: COMMIT 포함
   * ================================================================
   * 사용 예시:
   *   EXEC HPF.<PROCEDURE_NAME>(...);
   *   SELECT {clean(name)}.<FUNCTION_NAME>(...) FROM DUAL;
   * ================================================================ */
 "HPF" as

   procedure xml_header is

   begin

      owa_util.mime_header('text/xml',false);

      htp.print('Cache-Control: no-cache');

      owa_util.http_header_close;

--      htp.print('<?xml version="1.0" encoding="'||lower(owa_util.get_cgi_env('REQUEST_IANA_CHARSET'))||'"?>');
      htp.print('<?xml version="1.0" encoding="'||'utf-8'||'"?>');

      htp.print('<root>');

      g_error_found := false;

   end;

   procedure xml_footer is

   begin

      htp.print('</root>');

      commit;

   end;

   procedure xml_begin_tag (

      p_tag_name in varchar2

   ) is

   begin

      htp.print('<'||p_tag_name||'>');

   end;

   procedure xml_end_tag (

      p_tag_name in varchar2

   ) is

   begin

      htp.print('</'||p_tag_name||'>');

   end;

   procedure xml_print_element (

      p_element_name  in varchar2,
      p_element_value in varchar2

   ) is

   begin

      htp.print('<'||p_element_name||'>'||utl_i18n.escape_reference(p_element_value)||'</'||p_element_name||'>');

   end;

   procedure xml_message (

      p_message_text in varchar2

   ) is

   begin

      hpf.xml_print_element('message_text',p_message_text);

   end;

   procedure xml_error (

      p_error_text in varchar2

   ) is

   begin

      hpf.xml_print_element('error_text',p_error_text);

      g_error_found := true;

   end;

   procedure xml_exception is

      l_exception_text varchar2(2048);
      l_call_stack     varchar2(1024);
      l_error_stack    varchar2(1024);

   begin

      l_call_stack  := replace(dbms_utility.format_call_stack,'----- PL/SQL Call Stack -----','Call Stack:'||chr(10));

      l_error_stack := 'Error Stack:'||chr(10)||chr(10)||dbms_utility.format_error_stack||dbms_utility.format_error_backtrace;

      l_exception_text := l_call_stack||chr(10)||l_error_stack;

      rollback;

      htp.init;

      hpf.xml_header;

      hpf.xml_print_element('exception_text',l_exception_text);

      hpf.xml_footer;

   end;

end;
