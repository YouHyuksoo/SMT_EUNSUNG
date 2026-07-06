CREATE OR REPLACE PROCEDURE "P_IF_MATERIAL_LIST" (
  /* ================================================================
   * 프로시저명  : P_IF_MATERIAL_LIST
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2015-06-02
   * 수정이력:
   *   2015-06-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   외부 연계 자재 정보를 IF_KF_MATERIAL_LIST 인터페이스 테이블에 저장한다.
   *   품목, LOT, 수량, 추적코드, 벤더, 일자, 고객 등 입력 값을 그대로 INSERT한다.
   *   정상 저장 시 OK, 오류 발생 시 ERROR를 OUT 파라미터로 반환한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_ITEMNO     (IN, VARCHAR2) - 품목 번호
   *   P_LOTNO      (IN, VARCHAR2) - LOT 번호
   *   P_QTY        (IN, VARCHAR2) - 수량
   *   P_TRACECODE  (IN, VARCHAR2) - 추적 코드
   *   P_VENDOR     (IN, VARCHAR2) - 벤더
   *   P_SNO        (IN, VARCHAR2) - 시리얼/순번 입력값
   *   P_DT         (IN, VARCHAR2) - 기준 일자 입력값
   *   P_QDT        (IN, VARCHAR2) - QDT 입력값
   *   P_LDT        (IN, VARCHAR2) - LDT 입력값
   *   P_PDT        (IN, VARCHAR2) - PDT 입력값
   *   P_ITEMNM     (IN, VARCHAR2) - 품목명
   *   P_CUST       (IN, VARCHAR2) - 고객
   *   P_OUT        (OUT, VARCHAR2) - 처리 결과, OK 또는 ERROR
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IF_KF_MATERIAL_LIST - 외부 자재 리스트 인터페이스 테이블
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN OTHERS - P_OUT에 ERROR를 설정하고 종료한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 없음
   *   DML: INSERT 1회
   * ================================================================
   * 사용 예시:
   *   EXEC P_IF_MATERIAL_LIST('ITEM', 'LOT', '1', 'TRACE', 'VENDOR', 'SNO', 'DT', 'QDT', 'LDT', 'PDT', 'NAME', 'CUST', :P_OUT)
   * ================================================================ */
                                               /* Formatted on 2015-06-02 14:19:40 (QP5 v5.126) */p_ITEMNO    IN VARCHAR2,
                                               p_LOTNO     IN VARCHAR2,
                                               p_QTY       IN VARCHAR2,
                                               p_TRACECODE IN VARCHAR2,
                                               p_VENDOR    IN VARCHAR2,
                                               p_SNO       IN VARCHAR2,
                                               p_DT        IN VARCHAR2,
                                               p_QDT       IN VARCHAR2,
                                               p_LDT       IN VARCHAR2,
                                               p_PDT       IN VARCHAR2,
                                               p_ITEMNM    IN VARCHAR2,
                                               p_CUST      IN VARCHAR2,
                                               p_out       OUT VARCHAR2) IS
BEGIN
  -- [AI] 외부 연계 자재 입력값을 인터페이스 테이블에 등록한다.
  INSERT INTO if_kf_material_list
    (ITEMNO,
     LOTNO,
     QTY,
     TRACECODE,
     VENDOR,
     SNO,
     DT,
     QDT,
     LDT,
     PDT,
     ITEMNM,
     CUST,
     enter_date,
     enter_by)
  VALUES
    (p_ITEMNO,
     p_LOTNO,
     p_QTY,
     p_TRACECODE,
     p_VENDOR,
     p_SNO,
     p_DT,
     p_QDT,
     p_LDT,
     p_PDT,
     p_ITEMNM,
     p_CUST,
     SYSDATE,
     'SYSTEM');

  -- [AI] 정상 처리 결과를 반환한다.
  p_out := 'OK';
  RETURN;
EXCEPTION
  -- [AI] 오류 발생 시 실패 결과만 반환한다.
  WHEN OTHERS THEN
    p_out := 'ERROR';
    RETURN;
END;
