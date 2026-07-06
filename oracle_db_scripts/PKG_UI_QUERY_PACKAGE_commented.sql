CREATE OR REPLACE PACKAGE
  /* ================================================================
   * 패키지명  : PKG_UI_QUERY
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   UI 화면 조회에 필요한 공통 커서/조회 로직을 제공하는 패키지이다.
   *   화면별 반복 SQL을 패키지 단위로 묶어 관리한다.
   * ================================================================
   * [AI 분석] 공개/구현 객체:
   *   FUNCTION FN_LOSS_RATE - 패키지 내 업무 처리 단위
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   없음 (패키지 선언부 또는 명시 테이블 없음)
   * ================================================================
   * [AI 분석] 예외 처리:
   *   명시적 EXCEPTION 블록 없음 - 호출부에서 표준 Oracle 예외를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: 없음
   * ================================================================
   * 사용 예시:
   *   EXEC PKG_UI_QUERY.<PROCEDURE_NAME>(...);
   *   SELECT {clean(name)}.<FUNCTION_NAME>(...) FROM DUAL;
   * ================================================================ */
 "PKG_UI_QUERY" is

  -- Author  : ZETHANI
  -- Created : 2015-05-20 ???? 10:50:51
  -- Purpose : Ui ??ackage
  TYPE T_LOSS_RATE_R IS RECORD( LINE_CODE    VARCHAR2(20),
                                RATE_M1       NUMBER,
                                VAL_M1       NUMBER,
                                RATE_M2       NUMBER,
                                VAL_M2       NUMBER,
                                RATE_M3       NUMBER,
                                VAL_M3       NUMBER,
                                RATE_M4       NUMBER,
                                VAL_M4       NUMBER,
                                RATE_M5       NUMBER,
                                VAL_M5       NUMBER,
                                RATE_M6       NUMBER,
                                VAL_M6       NUMBER,
                                RATE_TTL     NUMBER,
                                VAL_TTL      NUMBER
                               );

  TYPE T_LOSS_RATE_T IS TABLE OF T_LOSS_RATE_R ;

  FUNCTION FN_LOSS_RATE RETURN T_LOSS_RATE_T PIPELINED;


end PKG_UI_QUERY;
