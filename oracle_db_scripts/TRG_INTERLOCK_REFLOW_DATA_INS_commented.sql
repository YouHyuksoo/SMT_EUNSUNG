CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRG_INTERLOCK_REFLOW_DATA_INS
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IQ_INTERLOCK_REFLOW_DATA 테이블의 INSERT 이벤트 발생 시 원본 트리거 로직에 정의된 후속 처리를 자동 수행한다.
   *   업무 데이터의 기본값 설정, 검증, 이력 기록 또는 연계 테이블 갱신에 사용된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: INSERT
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IQ_INTERLOCK_REFLOW_DATA - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.FILE_NAME - 신규/변경 후 명칭 관련 값
   *   :NEW.PF_TYPE - 신규/변경 후 값 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IQ_INTERLOCK_REFLOW_DATA - 인터락 관련 트리거 대상 테이블
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: SELECT 1회, INSERT 1회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_INTERLOCK_REFLOW_DATA_INS';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_INTERLOCK_REFLOW_DATA_INS';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRG_INTERLOCK_REFLOW_DATA_INS" 
  before insert on iq_interlock_reflow_data
  for each row
declare
  -- local variables here
  lvs_PF_TYPE varchar2(1) ;
begin
/*  CHECK_DATE, ENTER_DATE, FILE_NAME, instr(FILE_NAME,'？？？？',1) , instr(FILE_NAME,'？？？？',1)
  DECODE( SIGN(instr(FILE_NAME,'？？？？',1) - instr(FILE_NAME,'？？？？',1)),1,'？？？？',-1,'？？？？')

    substr(CHECK_DATE,1,10),
       TRIM(substr(CHECK_DATE,11,4)),
       substr(CHECK_DATE,15,10) */

    SELECT DECODE( SIGN(instr(:NEW.FILE_NAME,'？？？？',1) - instr(:NEW.FILE_NAME,'？？？？',1)),1,'F',-1,'P')
      INTO lvs_pf_type
      FROM DUAL ;

   :NEW.PF_TYPE := lvs_pf_type ;
exception
  when others then
    null ;
end TRG_interlock_reflow_data_ins;
