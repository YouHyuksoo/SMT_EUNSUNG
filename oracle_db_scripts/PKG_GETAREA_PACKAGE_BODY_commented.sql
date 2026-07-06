CREATE OR REPLACE PACKAGE BODY
  /* ================================================================
   * 패키지 본문명  : PKG_GETAREA
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
   *   PROCEDURE GETAREA - 패키지 내 업무 처리 단위
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   TB_AREA_MST - 업무 기준/거래 데이터 조회 또는 변경
   *   ISYS_BASECODE - 기준코드 관련 조회 또는 변경
   * ================================================================
   * [AI 분석] 예외 처리:
   *   명시적 EXCEPTION 블록 없음 - 호출부에서 표준 Oracle 예외를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회 / 반복문: 0회
   *   DML: SELECT 4회
   * ================================================================
   * 사용 예시:
   *   EXEC PKG_GETAREA.<PROCEDURE_NAME>(...);
   *   SELECT {clean(name)}.<FUNCTION_NAME>(...) FROM DUAL;
   * ================================================================ */
 "PKG_GETAREA" as
  PROCEDURE GetArea(inStartRowIndex in number, inEndRowIndex in number, inSortExp in varchar2, outTotalRows out number, outAreaCur OUT MyRefCur)  IS
    
  BEGIN
    select count(*) 
      into outTotalRows 
      from tb_area_mst;
    
    if(inEndRowIndex = -1) then
       open outAreaCur for select CODE_TYPE, CODE_NAME, CODE_MEAN_KOR
                             from ISYS_BASECODE  
                             order by CODE_TYPE;
    else
      begin
        open outAreaCur for select CODE_TYPE, CODE_NAME, CODE_MEAN_KOR
                              from (
                                    select  CODE_TYPE, CODE_NAME, CODE_MEAN_KOR, 
                                            ROW_NUMBER()
                                            OVER
                                            (
                                              ORDER BY
                                              Decode(CODE_TYPE,'CODE_TYPE ASC',CODE_TYPE) ASC,
                                              Decode(CODE_NAME,'CODE_NAME DESC',CODE_NAME) DESC,
                                              Decode(CODE_MEAN_KOR,'CODE_MEAN_KOR ASC',CODE_MEAN_KOR) ASC
                                             )
                                            R 
                                       FROM ISYS_BASECODE
                                    )
                               WHERE R BETWEEN inStartRowIndex AND inEndRowIndex;
       end;
      End if;
    END;
 END;
