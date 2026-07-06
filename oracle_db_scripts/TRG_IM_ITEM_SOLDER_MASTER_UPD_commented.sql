CREATE OR REPLACE TRIGGER "TRG_IM_ITEM_SOLDER_MASTER_UPD"
  /* ================================================================
   * 트리거명  : TRG_IM_ITEM_SOLDER_MASTER_UPD
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IM_ITEM_SOLDER_MASTER 테이블의 UPDATE 이벤트 발생 시 원본 트리거 로직에 정의된 후속 처리를 자동 수행한다.
   *   업무 데이터의 기본값 설정, 검증, 이력 기록 또는 연계 테이블 갱신에 사용된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: UPDATE
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IM_ITEM_SOLDER_MASTER - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.ITEM_BARCODE - 신규/변경 후 품목 / 바코드 관련 값
   *   :NEW.RECEIPT_DATE - 신규/변경 후 입고 / 일자 관련 값
   *   :NEW.ISSUE_DATE - 신규/변경 후 출고 / 일자 관련 값
   *   :NEW.INPUT_DATE - 신규/변경 후 일자 관련 값
   *   :NEW.DESTROY_DATE - 신규/변경 후 일자 관련 값
   *   :NEW.VISCOSITY_START_DATE - 신규/변경 후 일자 관련 값
   *   :NEW.VISCOSITY_END_DATE - 신규/변경 후 일자 관련 값
   *   :NEW.VALID_DATE - 신규/변경 후 일자 관련 값
   *   :OLD.RECEIPT_DATE - 변경/삭제 전 입고 / 일자 관련 값
   *   :OLD.ISSUE_DATE - 변경/삭제 전 출고 / 일자 관련 값
   *   :OLD.INPUT_DATE - 변경/삭제 전 일자 관련 값
   *   :OLD.DESTROY_DATE - 변경/삭제 전 일자 관련 값
   *   :OLD.VISCOSITY_START_DATE - 변경/삭제 전 일자 관련 값
   *   :OLD.VISCOSITY_END_DATE - 변경/삭제 전 일자 관련 값
   *   :OLD.VALID_DATE - 변경/삭제 전 일자 관련 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IM_ITEM_SOLDER_MASTER - 품목 / 솔더 관련 트리거 대상 테이블
   *   IM_ITEM_SOLDER_MASTER_HIS - 품목 / 솔더 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: SELECT 1회, INSERT 1회, UPDATE 1회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_IM_ITEM_SOLDER_MASTER_UPD';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_IM_ITEM_SOLDER_MASTER_UPD';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */

 BEFORE
   UPDATE OF RECEIPT_DATE, ISSUE_DATE, DESTROY_DATE, VALID_DATE  ON IM_ITEM_SOLDER_MASTER
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   lvi_count   NUMBER;
BEGIN

  
       INSERT INTO IM_ITEM_SOLDER_MASTER_HIS (
                                             item_barcode,
                                             
                                             OLD_RECEIPT_DATE           ,
                                             OLD_ISSUE_DATE             , 
                                             OLD_INPUT_DATE             ,
                                             OLD_DESTROY_DATE           ,  
  
                                             OLD_VISCOSITY_START_DATE   , 
                                             OLD_VISCOSITY_END_DATE     ,  
                                             OLD_VALID_DATE             ,    
               
                                             NEW_RECEIPT_DATE           ,
                                             NEW_ISSUE_DATE             , 
                                             NEW_INPUT_DATE             ,
                                             NEW_DESTROY_DATE           ,  
  
                                             NEW_VISCOSITY_START_DATE   , 
                                             NEW_VISCOSITY_END_DATE     ,  
                                             NEW_VALID_DATE             ,
                                             
                                             enter_date                 ,
                                             enter_by                   ,   
                                             last_modify_date           ,     
                                             last_modify_by             ,
                                             organization_id                   
                                         )
                                 SELECT :NEW.item_barcode           ,
                                 
                                        :OLD.RECEIPT_DATE           ,
                                        :OLD.ISSUE_DATE             , 
                                        :OLD.INPUT_DATE             ,
                                        :OLD.DESTROY_DATE           , 
               
                                        :OLD.VISCOSITY_START_DATE   , 
                                        :OLD.VISCOSITY_END_DATE     ,  
                                        :OLD.VALID_DATE             ,    
               
                                        :NEW.RECEIPT_DATE           ,
                                        :NEW.ISSUE_DATE             , 
                                        :NEW.INPUT_DATE             ,
                                        :NEW.DESTROY_DATE           ,  
               
                                        :NEW.VISCOSITY_START_DATE   , 
                                        :NEW.VISCOSITY_END_DATE     ,  
                                        :NEW.VALID_DATE             ,

                                        sysdate                     ,
                                        'UPD TRIGGER'               ,
						                            sysdate                     ,
                                        'UPD TRIGGER'               ,
						                            1
                                   FROM DUAL;					



EXCEPTION
   WHEN OTHERS THEN
        raise_application_error (-20003, SQLERRM);
END;
