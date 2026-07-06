CREATE OR REPLACE TRIGGER TIGIQ_MACHINE_INS_DATA_BMA_INS
  /* ================================================================
   * 트리거명  : TIGIQ_MACHINE_INS_DATA_BMA_INS
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IQ_MACHINE_INSPECT_DATA_BMA 테이블의 INSERT 이벤트 발생 시 원본 트리거 로직에 정의된 후속 처리를 자동 수행한다.
   *   업무 데이터의 기본값 설정, 검증, 이력 기록 또는 연계 테이블 갱신에 사용된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: INSERT
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IQ_MACHINE_INSPECT_DATA_BMA - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.RUN_NO - 신규/변경 후 작업지시/런 관련 값
   *   :NEW.PID - 신규/변경 후 제품 식별자 관련 값
   *   :NEW.ORGANIZATION_ID - 신규/변경 후 값 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IQ_MACHINE_INSPECT_DATA_BMA - 설비 / 검사 관련 트리거 대상 테이블
   *   IP_PRODUCT_2D_BARCODE - 제품 / 바코드 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회 / 반복문: 0회
   *   DML: SELECT 1회, INSERT 1회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TIGIQ_MACHINE_INS_DATA_BMA_INS';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TIGIQ_MACHINE_INS_DATA_BMA_INS';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */

 BEFORE INSERT ON IQ_MACHINE_INSPECT_DATA_BMA
 REFERENCING OLD AS OLD NEW AS NEW
 FOR EACH ROW
DECLARE
    
    LVS_OUT             VARCHAR2(4000); 
    LVS_MSG             VARCHAR2(4000); 
    LVS_WORKSTAGE_CODE  VARCHAR2(30);  
  

  
BEGIN
  

    IF ( :NEW.RUN_NO = 'NULL' OR :NEW.RUN_NO = ''  OR :NEW.RUN_NO IS NULL OR :NEW.RUN_NO = '*') THEN
           
              BEGIN
                 
                  SELECT RUN_NO
                    INTO :NEW.RUN_NO
                    FROM IP_PRODUCT_2D_BARCODE
                   WHERE serial_no       = :NEW.PID
                     AND ORGANIZATION_ID = :NEW.ORGANIZATION_ID;     
                  
               EXCEPTION 
                  WHEN OTHERS THEN 
                          :NEW.RUN_NO    := '*';   
                          
               END;
           
   END IF;
    
   :new.pid    := nvl(:new.pid, '*') ;

      

EXCEPTION
    WHEN OTHERS THEN
   
        raise_application_error (
                                 -20003, 
                                 'BMA INS TRRIGER ERROR '
                                 || ' '
                                 || SQLERRM
                                 );
END;
