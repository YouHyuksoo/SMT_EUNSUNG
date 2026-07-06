PROCEDURE "P_INSERT_RUN_MODEL" (p_line_code        IN     VARCHAR2,
                                                    p_workstage_code   IN     VARCHAR2,
                                                    p_model_name       IN     VARCHAR2,
                                                    p_item_code        IN     VARCHAR2,
                                                    p_pcb_item         IN     VARCHAR2,
                                                    p_run_no           IN     VARCHAR2,
                                                    p_child_item_code  IN     VARCHAR2,
                                                    p_out              OUT    VARCHAR2)
IS

    lvl_count      NUMBER;

BEGIN

--------------------------------------------------------------------------
-- 2016/10/12 SHS, 동일모델에 대해서는 Master sample을 흘리지 않음 
--------------------------------------------------------------------------

    BEGIN
      
       SELECT nvl(sum(1),0)
         INTO lvl_count
         FROM ip_product_run_model
        WHERE organization_id = 1
          AND LINE_CODE       = p_line_code
          AND WORKSTAGE_CODE  = p_workstage_code
          AND MODEL_NAME      = p_model_name
          AND ITEM_CODE       = p_item_code
          AND PCB_ITEM||'*'   = decode(p_pcb_item,'T','T','B','B','')||'*';
    
    EXCEPTION
       WHEN OTHERS THEN        
            lvl_count := 0;
            
    END;
 
--------------------------------------------------------------------------
-- 2016/08/19 SHS, 매거진 모델 매칭을 위한 공정APP 등록 모듈 
--------------------------------------------------------------------------
      
    IF lvl_count = 0 THEN   

       DELETE FROM ip_product_run_model
        WHERE organization_id = 1
          AND LINE_CODE       = p_line_code
          AND WORKSTAGE_CODE  = p_workstage_code;
       
       
       INSERT INTO ip_product_run_model (
                                         organization_id,
                                         line_code,
                                         workstage_code,
                                         model_name,
                                         item_code,
                                         pcb_item,
                                         run_no,

                                         enter_date,
                                         enter_by,
                                         last_modify_date,
                                         last_modify_by,
                                         child_item_code
                                         )
         VALUES   (
                   1,
                   p_line_code,
                   p_workstage_code,
                   p_model_name,
                   p_item_code,
                   decode(p_pcb_item,'T','T','B','B',''),
                   p_run_no,

                   SYSDATE,
                   'MAGAZINE APP',
                   SYSDATE,
                   'MAGAZINE APP',
                   p_child_item_code
                   );

    END IF;
    
    p_out := 'OK';
    
    COMMIT;
    
EXCEPTION
  
    WHEN OTHERS THEN
      
        ROLLBACK;
        p_out := 'ERROR';
        
        RETURN;
        
END;