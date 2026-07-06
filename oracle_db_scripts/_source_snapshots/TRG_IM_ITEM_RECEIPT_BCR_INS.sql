TRIGGER "TRG_IM_ITEM_RECEIPT_BCR_INS"
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
