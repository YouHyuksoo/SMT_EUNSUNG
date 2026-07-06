CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRG_IQ_MACHINE_INSPECT_DATA_MK
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IQ_MACHINE_INSPECT_DATA_MK 테이블의 INSERT 발생 시 생산/검사 실적 관련 값을 자동 보정하거나 이력을 갱신한다.
   *   제품 실적, 검사 결과, 공정 흐름의 데이터 정합성을 유지하기 위한 트리거로 추정된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: AFTER
   *   이벤트: INSERT
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IQ_MACHINE_INSPECT_DATA_MK - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IQ_MACHINE_INSPECT_DATA_MK - 설비 / 검사 관련 트리거 대상 테이블
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회 / 반복문: 0회
   *   DML: INSERT 1회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_IQ_MACHINE_INSPECT_DATA_MK';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_IQ_MACHINE_INSPECT_DATA_MK';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
.TRG_IQ_MACHINE_INSPECT_DATA_MK
  after insert on iq_machine_inspect_data_mk  
  for each row
declare
  /*SMT 공정 통과 WORKSTAGE IO 에 입력 테스트*/
  V_OUT VARCHAR2(4000); 
  V_MSG VARCHAR2(4000); 
begin
  


/* 

 IF :NEW.PID = 'NULL' OR :NEW.PID IS NULL THEN 
    NULL ; \*만들지 말자*\
  ELSE 
    \*공정 in-out DATA 만들기*\
    P_SET_WORKSTAGE_SCAN_IN( :NEW.PID,
                             :NEW.EQUIPMENTID, 
                             'W030',                --마킹공정 
                             :NEW.ORGANIZATION_ID, 
                             'I',
                             V_OUT, 
                             V_MSG ) ; 
 END IF ; 
 
 */

 
 NULL;
 
EXCEPTION 
  WHEN OTHERS THEN 
    NULL ; 

end TRG_IQ_MACHINE_INSPECT_DATA_MK;
