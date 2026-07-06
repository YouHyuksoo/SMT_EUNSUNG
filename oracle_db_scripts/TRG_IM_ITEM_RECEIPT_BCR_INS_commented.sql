CREATE OR REPLACE TRIGGER "TRG_IM_ITEM_RECEIPT_BCR_INS"
  /* ================================================================
   * 트리거명  : TRG_IM_ITEM_RECEIPT_BCR_INS
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IM_ITEM_RECEIPT_BARCODE 테이블의 INSERT 이벤트 발생 시 원본 트리거 로직에 정의된 후속 처리를 자동 수행한다.
   *   업무 데이터의 기본값 설정, 검증, 이력 기록 또는 연계 테이블 갱신에 사용된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: INSERT
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IM_ITEM_RECEIPT_BARCODE - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.ITEM_CODE - 신규/변경 후 품목 관련 값
   *   :NEW.ORGANIZATION_ID - 신규/변경 후 값 값
   *   :NEW.LOT_NO - 신규/변경 후 LOT 관련 값
   *   :NEW.ITEM_BARCODE - 신규/변경 후 품목 / 바코드 관련 값
   *   :NEW.VALID_DATE - 신규/변경 후 일자 관련 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IM_ITEM_RECEIPT_BARCODE - 품목 / 입고 / 바코드 관련 트리거 대상 테이블
   *   ID_ITEM - 품목 관련 트리거 내부 SQL에서 참조/변경
   *   IM_ITEM_SOLDER_MASTER - 품목 / 솔더 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_GET_SOLDER_TYPE - 트리거 내부 업무 처리 호출
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회 / 반복문: 0회
   *   DML: SELECT 1회, INSERT 2회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_IM_ITEM_RECEIPT_BCR_INS';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_IM_ITEM_RECEIPT_BCR_INS';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */

 BEFORE INSERT ON IM_ITEM_RECEIPT_BARCODE
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   lvl_cnt                     NUMBER       := 0;
   phase                       NUMBER       := 0;
BEGIN
  
     ----------------------------------------------------------------------------
     -- 등록 품목이 솔더라벨인지 확인
     ----------------------------------------------------------------------------
     
phase := 100;
     
     SELECT COUNT(*)
       INTO lvl_cnt
       FROM ID_ITEM
      where item_class      = 'SOLDER'
        and item_code       = :NEW.item_code
        and organization_id = :NEW.organization_id;
        
     IF ( lvl_cnt > 0 ) THEN       
       
     ----------------------------------------------------------------------------
     -- Solder 입/출고 이력상으로 자동입고 처리
     ----------------------------------------------------------------------------                  
            
phase := 200;
           
         INSERT INTO im_item_solder_master (item_code,
                                            solder_lot_no,
                                            receipt_date,
                                            issue_date,
                                            open_date,
                                            return_date,
                                            line_code,
                                            workstage_code,
                                            machine_code,
                                            enter_date,
                                            enter_by,
                                            last_modify_date,
                                            last_modify_by,
                                            organization_id,
                                            item_barcode,
                                            model_name,
                                            solder_type,
                                            valid_date)
         VALUES (:NEW.item_code,
                 :NEW.lot_no,          --f_get_lot_no_from_barcode (p_barcode),
                 SYSDATE,                                      --RECEIPT_DATE,
                 NULL,                                           --ISSUE_DATE,
                 NULL,                                            --OPEN_DATE,
                 NULL,                                          --RETURN_DATE,
                 NULL,                                            --LINE_CODE,
                 NULL,                                       --WORKSTAGE_CODE,
                 DECODE( length(:NEW.item_barcode),11, SUBSTR(:NEW.item_barcode, 11, 1), 'A') , --MACHINE_CODE,  11 자리에 Factory A or B
                 SYSDATE,                                        --ENTER_DATE,
                 'SYSTEM',                                         --ENTER_BY,
                 SYSDATE,                                  --LAST_MODIFY_DATE,
                 'SYSTEM',                                   --LAST_MODIFY_BY,
                 :NEW.organization_id,
                 :NEW.item_barcode,
                 NULL,
                 NVL(F_GET_SOLDER_TYPE (:NEW.item_code),'*'),
                 :NEW.valid_date
                 );
      END IF;

EXCEPTION
   WHEN OTHERS THEN
     
        raise_application_error (
                                  -20003,
                                  '[TRG_IM_ITEM_RECEIPT_BCR_INS} ERROR, Phase = '
                                  || TO_CHAR (phase)
                                  || ', '
                                  || SQLERRM
      );
END;
