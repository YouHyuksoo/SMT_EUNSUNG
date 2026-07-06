CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRG_IQ_INTERLOCK_CHK_COND_UPD
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IQ_INTERLOCK_CHECK_CONDITION 테이블의 UPDATE 이벤트 발생 시 원본 트리거 로직에 정의된 후속 처리를 자동 수행한다.
   *   업무 데이터의 기본값 설정, 검증, 이력 기록 또는 연계 테이블 갱신에 사용된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: UPDATE
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IQ_INTERLOCK_CHECK_CONDITION - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.CHECK_LIMT_TIME - 신규/변경 후 시간 관련 값
   *   :NEW.CHECK_SEQUENCE - 신규/변경 후 값 값
   *   :NEW.ITEM_CODE - 신규/변경 후 품목 관련 값
   *   :NEW.USE_YN - 신규/변경 후 값 값
   *   :NEW.LAST_MODIFY_DATE - 신규/변경 후 일자 관련 값
   *   :NEW.LAST_MODIFY_BY - 신규/변경 후 값 값
   *   :OLD.ORGANIZATION_ID - 변경/삭제 전 값 값
   *   :OLD.LINE_CODE - 변경/삭제 전 라인 관련 값
   *   :OLD.WORKSTAGE_CODE - 변경/삭제 전 공정 관련 값
   *   :OLD.MACHINE_CODE - 변경/삭제 전 설비 관련 값
   *   :OLD.INTERLOCK_CHECK_TYPE - 변경/삭제 전 인터락 관련 값
   *   :OLD.CHECK_LIMT_TIME - 변경/삭제 전 시간 관련 값
   *   :OLD.CHECK_SEQUENCE - 변경/삭제 전 값 값
   *   :OLD.ITEM_CODE - 변경/삭제 전 품목 관련 값
   *   :OLD.USE_YN - 변경/삭제 전 값 값
   *   :OLD.LAST_MODIFY_DATE - 변경/삭제 전 일자 관련 값
   *   :OLD.LAST_MODIFY_BY - 변경/삭제 전 값 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IQ_INTERLOCK_CHECK_CONDITION - 인터락 관련 트리거 대상 테이블
   *   IQ_INTERLOCK_CHECK_COND_LOG - 인터락 / 로그 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: SELECT 1회, INSERT 1회, UPDATE 3회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_IQ_INTERLOCK_CHK_COND_UPD';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_IQ_INTERLOCK_CHK_COND_UPD';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRG_IQ_INTERLOCK_CHK_COND_UPD" 
  before update on iq_interlock_check_condition
  for each row
declare
  -- local variables here
begin

          -- Interlock condition update？？？？？？？？？

          INSERT INTO IQ_INTERLOCK_CHECK_COND_LOG (ORGANIZATION_ID,
                                                   LINE_CODE,
                                                   WORKSTAGE_CODE,
                                                   MACHINE_CODE,
                                                   INTERLOCK_CHECK_TYPE,
                                                   OLD_CHECK_LIMT_TIME,
                                                   OLD_CHECK_SEQUENCE,
                                                   OLD_ITEM_CODE,
                                                   OLD_USE_YN,
                                                   OLD_MODIFY_DATE,
                                                   OLD_MODIFY_BY,
                                                   NEW_CHECK_LIMT_TIME,
                                                   NEW_CHECK_SEQUENCE,
                                                   NEW_ITEM_CODE,
                                                   NEW_USE_YN,
                                                   NEW_MODIFY_DATE,
                                                   NEW_MODIFY_BY,
                                                   TERMINAL,
                                                   CURRENT_USER,
                                                   HOST,
                                                   IP_ADDRESS,
                                                   TRIGGER_MODE,
                                                   TRIGGER_DATE
                                                  )
        SELECT :OLD.ORGANIZATION_ID,
               :OLD.LINE_CODE,
               :OLD.WORKSTAGE_CODE,
               :OLD.MACHINE_CODE,
               :OLD.INTERLOCK_CHECK_TYPE,
               :OLD.CHECK_LIMT_TIME,
               :OLD.CHECK_SEQUENCE,
               :OLD.ITEM_CODE,
               :OLD.USE_YN,
               :OLD.LAST_modify_date,
               :OLD.LAST_MODIFY_BY,
               :NEW.CHECK_LIMT_TIME,
               :NEW.CHECK_SEQUENCE,
               :NEW.ITEM_CODE,
               :NEW.USE_YN ,
               :NEW.LAST_MODIFY_DATE,
               :NEW.LAST_MODIFY_BY,
               SYS_CONTEXT('USERENV','TERMINAL'),     -- terminal ,
               SYS_CONTEXT('USERENV','CURRENT_USER'), -- current_user,
               SYS_CONTEXT('USERENV','HOST'),         -- host,
               SYS_CONTEXT('USERENV','IP_ADDRESS'),   -- ip_address,
               'UPDATE',
               SYSDATE
          FROM DUAL;

	EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);

end TRG_IQ_INTERLOCK_CHK_COND_UPD;
