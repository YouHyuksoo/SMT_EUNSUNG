TRIGGER "INFINITY21_JSMES"."TRGIP_PRODUCT_WS_IO_DEL"
 BEFORE 
 DELETE
 ON IP_PRODUCT_WORKSTAGE_IO  REFERENCING OLD AS OLD old AS old
 FOR EACH ROW
DECLARE

BEGIN
  
   null;
  
/*

   ---------------------------------------------------------------------------
    -- 2D 정보 원복 
    ---------------------------------------------------------------------------
       UPDATE IP_PRODUCT_2D_BARCODE X
            SET x.workstage_code =  :old.from_workstage_code, 
                x.line_code      =  '00', 
                x.is_progress    =  1 
                
          where x.SERIAL_NO      = :old.serial_no  ; 
    
    ---------------------------------------------------------------------------
    -- 재공 이동 / 추가 
    ---------------------------------------------------------------------------
    
          --다른 공정에 재고 빼기 
          update IP_PRODUCT_WORKSTAGE_INV X
             set INVENTORY_QTY    = INVENTORY_QTY - :old.IO_QTY  
           where x.model_name     = :old.model_name 
             and x.workstage_code =  :old.workstage_code 
             and x.line_code      =  '00'
              and x.organization_id = :old.organization_id
              and x.run_no = :old.run_no;    
             
          --내공정에 넣기 
          update IP_PRODUCT_WORKSTAGE_INV X
             set INVENTORY_QTY    = INVENTORY_QTY + :old.IO_QTY  
           where x.model_name     = :old.model_name 
             and x.workstage_code = :old.from_workstage_code 
             and x.line_code      =  '00'
             and x.organization_id = :old.organization_id
             and x.run_no = :old.run_no; 
             
 */
                
      
exception 
  when others then 
  
    raise_application_error (-20003, 'TRGIP_PRODUCT_WS_IO_INS '||SQLERRM);
END;
