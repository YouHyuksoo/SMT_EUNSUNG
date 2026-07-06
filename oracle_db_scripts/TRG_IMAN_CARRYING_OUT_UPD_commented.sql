CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRG_IMAN_CARRYING_OUT_UPD
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IMAN_CARRYING_OUT 테이블의 UPDATE 이벤트 발생 시 원본 트리거 로직에 정의된 후속 처리를 자동 수행한다.
   *   업무 데이터의 기본값 설정, 검증, 이력 기록 또는 연계 테이블 갱신에 사용된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: UPDATE
   *   단위: FOR EACH ROW
   *   조건: 
new.confirm_yn = 'Y'
      
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IMAN_CARRYING_OUT - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.ORGANIZATION_ID - 신규/변경 후 값 값
   *   :NEW.ENTER_BY - 신규/변경 후 값 값
   *   :NEW.LAST_MODIFY_DATE - 신규/변경 후 일자 관련 값
   *   :NEW.LAST_MODIFY_BY - 신규/변경 후 값 값
   *   :OLD.CARRYING_OUT_GROUP_NO - 변경/삭제 전 값 값
   *   :OLD.ORGANIZATION_ID - 변경/삭제 전 값 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IMAN_CARRYING_OUT - 업무 데이터 트리거 대상 테이블
   *   ISYS_AUDIT_MESSAGE - 업무 데이터 트리거 내부 SQL에서 참조/변경
   *   ISYS_AUDIT_MESSAGE_HISTORY - 이력 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회 / 반복문: 0회
   *   DML: SELECT 2회, INSERT 1회, UPDATE 1회, DELETE 1회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_IMAN_CARRYING_OUT_UPD';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_IMAN_CARRYING_OUT_UPD';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRG_IMAN_CARRYING_OUT_UPD" 
 BEFORE
   UPDATE OF confirm_yn
 ON iman_carrying_out
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
 WHEN (
new.confirm_yn = 'Y'
      ) DECLARE
   lvi_count   NUMBER;
BEGIN
   SELECT COUNT (*)
     INTO lvi_count
     FROM isys_audit_message
    WHERE carrying_out_group_no = :OLD.carrying_out_group_no
      and confirm_yn = 'N'
      and organization_id = :OLD.organization_id;

   IF lvi_count < 0
   
   THEN
      NULL;
   ELSE
       INSERT INTO "ISYS_AUDIT_MESSAGE_HISTORY"  
         ( AUDIT_MESSAGE_ID,   
           AUDIT_DATE,   
           ORGANIZATION_ID,   
           MSG_ID,   
           CONFIRM_YN,   
           CONFIRM_BY,   
           CONFIRM_DATE,   
           ENTER_DATE,   
           ENTER_BY,   
           LAST_MODIFY_DATE,   
           LAST_MODIFY_BY )  
     SELECT seq_audit_msg_sequence.NEXTVAL,-- :NEW.AUDIT_MESSAGE_ID,   
           SYSDATE ,  --:NEW.AUDIT_DATE,   
           :NEW.ORGANIZATION_ID,   
           30200 , --MSG_ID,   
           'Y' , --CONFIRM_YN,   
           :NEW.ENTER_BY , --CONFIRM_BY,   
           SYSDATE , --CONFIRM_DATE,   
           SYSDATE , --ENTER_DATE,   
           ENTER_BY,   
           :NEW.LAST_MODIFY_DATE,   
           :NEW.LAST_MODIFY_BY 
       FROM ISYS_AUDIT_MESSAGE  
       WHERE carrying_out_group_no = :OLD.carrying_out_group_no
         and organization_id = :OLD.organization_id;
   END IF;
   
    delete from  ISYS_AUDIT_MESSAGE
    WHERE carrying_out_group_no = :OLD.carrying_out_group_no
      and organization_id = :OLD.organization_id;
      
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;
