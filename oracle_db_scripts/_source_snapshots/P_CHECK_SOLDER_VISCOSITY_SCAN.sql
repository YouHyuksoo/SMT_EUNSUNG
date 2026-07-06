PROCEDURE p_check_solder_viscosity_scan (
   p_barcode      IN     VARCHAR2,
   p_viscosity    IN     VARCHAR2,
   p_deficit      IN     VARCHAR2,
   p_userid       IN     VARCHAR2,
   p_out          OUT    VARCHAR2)
IS
   lvi_count          NUMBER;
   
   lvs_item_code      VARCHAR2 (100);
   lvdt_valid_date    DATE;

BEGIN

   --------------------------------------------------
   -- 솔더라벨 유무 확인
   --------------------------------------------------
      SELECT count(*)
        INTO lvi_count
        FROM im_item_solder_master   
       WHERE item_barcode    = p_barcode
         AND ROWNUM          = 1
         AND organization_id = 1;              
         
  IF lvi_count = 0 THEN
  
           p_out :=  f_msg('미 등록된 솔더 바코드 입니다.', 'K', 1)   -- Not found Solder label info.
                     || ' = '
                     || p_barcode;
                     
           RETURN;
           
   END IF;
   
     
   --------------------------------------------------
   -- 솔더정보 조회
   --------------------------------------------------
  
      BEGIN
        
      SELECT count(*), NVL(max(item_code),'*'), max(valid_date)
        INTO lvi_count, lvs_item_code, lvdt_valid_date
        FROM im_item_solder_master   
       WHERE item_barcode    = p_barcode   
         AND   mix_end_date  IS NOT NULL
     --    AND viscosity_start_date IS NULL
         AND input_date      IS NULL
         AND organization_id = 1;    
         
     EXCEPTION
        WHEN OTHERS THEN
             lvi_count          := 0;
             lvs_item_code      := 'NULL';
             lvdt_valid_date    :=  NULL;
     END;             
         
  IF lvi_count = 0 THEN
    
           p_out :=  f_msg('스캔한 솔더가 교반완료 상태이면서 미투입 상태가 아닙니다.', 'K', 1)   -- Not found Solder label info.
                     || ' = '
                     || p_barcode;
                     
           RETURN;
           
   END IF;
   

   --------------------------------------------------
   -- 솔더정보에 점도측정 정보 업데이트
   --------------------------------------------------
      
   IF ( p_deficit = 'N' ) THEN
      
        select count(*)
          into lvi_count
          from im_item_solder_master
         where item_barcode = p_barcode
           and viscosity is not null;
         
        IF ( lvi_count = 0 ) THEN
          
              update im_item_solder_master
                 set viscosity_start_date = sysdate,
                     viscosity_end_date   = sysdate,
                     viscosity            = p_viscosity,
                     viscosity_operator   = p_userid,
                     last_modify_date     = sysdate,
                     last_modify_by       = 'PDA SCAN' 
               where item_barcode         = p_barcode
                 AND ORGANIZATION_ID      = 1;
              
           --   IF ( SQL%ROWCOUNT > 0 ) THEN   -- 점도계설치 후 측정로그 기준으로 처리하기에 스캔한 solder 기준으로만 처리 함
              IF ( 1=2 ) THEN
                 
   /*          
                    update im_item_solder_master
                       set viscosity_end_date   = sysdate,
                           viscosity            = p_viscosity,
                           viscosity_operator   = p_userid,
                           last_modify_date     = sysdate,
                           last_modify_by       = p_userid 
                     where item_barcode         <> p_barcode              
                       and VALID_DATE           = lvdt_valid_date   -- 2020-04-16 김현동씨 요청 --  WHERE ITEM_BARCODE         like substr(lvs_barcode, 1,7)||'%' 
                       AND ITEM_CODE            = lvs_item_code
                       AND DESTROY_DATE         is null             -- 폐기된 솔더 확인
                       AND ORGANIZATION_ID      = 1;
   */                   
                       
    
               UPDATE IM_ITEM_SOLDER_MASTER
                  SET viscosity_start_date = sysdate,
                     viscosity_end_date   = sysdate,
                     viscosity            = p_viscosity,
                     viscosity_operator   = p_userid,
                     last_modify_date     = sysdate,
                     last_modify_by       = p_userid      
                WHERE VALID_DATE           = lvdt_valid_date   -- 2020-04-16 김현동씨 요청 --  WHERE ITEM_BARCODE         like substr(lvs_barcode, 1,7)||'%' 
                  AND ITEM_CODE            = LVS_ITEM_CODE
                  AND ITEM_BARCODE         > p_barcode
                  AND DESTROY_DATE         IS NULL             -- 폐기 안되고 
                  AND RECEIPT_DATE         IS NOT NULL         -- 냉장고 입고 후
                  AND ORGANIZATION_ID      = 1;
                                     
                       
              END IF;
                 
        ELSE
          
              update im_item_solder_master
                 set viscosity_start_date = sysdate,
                     viscosity_end_date   = sysdate,
                     last_modify_date     = sysdate,
                     last_modify_by       = 'PDA SCAN'  
               where item_barcode         = p_barcode
                 AND ORGANIZATION_ID      = 1;      
          
        END IF;
         
   ELSE
     
   --------------------------------------------------
   -- 솔더정보에 점도측정 정보 업데이트 취소
   --------------------------------------------------
     
        update im_item_solder_master
           set viscosity_start_date = NULL,
               viscosity_end_date   = NULL,
           --    viscosity            = NULL,
           --    viscosity_operator   = NULL,
               last_modify_date     = sysdate,
               last_modify_by       = 'PDA SCAN'   
         where item_barcode         = p_barcode
           AND ORGANIZATION_ID      = 1;
            
   END IF;
   
   
   COMMIT;
   
   p_out := 'OK';
   
EXCEPTION
   WHEN OTHERS THEN
     
        p_out := '[P_CHECK_SOLDER_VISCOSITY_SCAN] ' 
                 || SQLERRM;
                 
END;
