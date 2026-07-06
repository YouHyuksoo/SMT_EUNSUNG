PROCEDURE "P_CHECK_REELCLOSE" (
                                                 p_reel_bcr varchar2, 
                                                 p_deficit  varchar2, 
                                                 p_out out  varchar2
                                                ) is
   lvs_reel_destroy_yn   varchar2(10);  
   lvs_ISSUE_COMPARE_YN  varchar2(10); 
   LVS_FEEDING_YN        varchar2(10); 
   
   LVS_LOT_NO            varchar2(10); 
   
   LVL_COUNT             number;
   LVS_RET_MESSAGE       varchar2(100); 
 
begin
  
   BEGIN
     
       SELECT NVL(REEL_DESTROY_YN,'N'), NVL(ISSUE_COMPARE_YN,'N'), NVL(FEEDING_YN,'N'), LOT_NO
         INTO LVS_REEL_DESTROY_YN, lvs_ISSUE_COMPARE_YN, LVS_FEEDING_YN, LVS_LOT_NO            
         FROM IM_ITEM_RECEIPT_BARCODE
        WHERE ITEM_BARCODE = P_REEL_BCR;
   
   EXCEPTION
      WHEN OTHERS THEN
                 
           P_OUT := F_MSG('[REEL CLOSE] 등록되지 않은 바코드 입니다.', 'K', 1)    --  NOT FOUND MATERIAL BARCODE
                    || ' = '   
                    || P_REEL_BCR;
                  
           RETURN ;
    
   END ;
   
   IF ( lvs_ISSUE_COMPARE_YN <> 'Y' ) THEN
     
        P_OUT := F_MSG('[REEL CLOSE] 출고되지 않은 바코드 입니다.', 'K', 1)    --  NOT ISSUE MATERIAL BARCODE
                 || ' = '   
                 || P_REEL_BCR;
                 
        RETURN ;
     
   END IF;
   
   IF ( LVS_REEL_DESTROY_YN = 'Y'  AND p_deficit = 'N'  ) THEN
     
        P_OUT := F_MSG('[REEL CLOSE] 이미 종료된 바코드 입니다.', 'K', 1)    --  ALREADY CLOSE MATERIAL BARCODE
                 || ' = '   
                 || P_REEL_BCR;
                 
        RETURN ;
        
   END IF;     
   
   ---------------------------------------------------------------------------
   -- 베이킹에 입고된 자재인지 확인 한다
   ---------------------------------------------------------------------------
         
   SELECT COUNT(*), 
          MAX(DECODE(CHAMBER_TYPE, 'B', '베이킹', 'D', '제습함', 'V', '진공포장', CHAMBER_TYPE) || ' 재고 입니다')
     INTO LVL_COUNT, LVS_RET_MESSAGE
     FROM IM_ITEM_BAKING_MASTER
    WHERE ITEM_BARCODE     = P_REEL_BCR
      AND INPUT_SCAN_DATE  IS NOT NULL
      AND OUTPUT_SCAN_DATE IS NULL;
   
   
   IF ( LVL_COUNT > 0) THEN
     
        P_OUT := F_MSG('[REEL CLOSE] '||LVS_RET_MESSAGE, 'K', 1)    --  NOT ISSUE MATERIAL BARCODE
                 || ' = '   
                 || P_REEL_BCR;
                 
        RETURN ;
     
   END IF;     

   ---------------------------------------------------------------------------
   --  장착이력이 존재하는지 확인
   ---------------------------------------------------------------------------         
   
   LVL_COUNT := 0;
   
   SELECT COUNT(*)
     INTO LVL_COUNT
     FROM IB_SMT_CHECKHIST
    WHERE SCAN_PARTNAME = P_REEL_BCR;
 
  

 IF ( LVL_COUNT = 0 ) THEN
     
        P_OUT := F_MSG('[REEL CLOSE] 장착이력이 존재하지 않는 자재 입니다.', 'K', 1)    --  NOT FEED MATERIAL BARCODE
                 || ' = '   
                 || P_REEL_BCR;
                 
        RETURN ;
     
   END IF;
   

	
      
     IF ( p_deficit = 'N' ) THEN
        
   ---------------------------------------------------------------------------
   --  2020/11/16, SHS : 장착된 자재인지 체크 
   ---------------------------------------------------------------------------    
   
          SELECT count(*)
            INTO LVL_COUNT
            FROM ib_product_plandata
           WHERE lot_no     = LVS_LOT_NO
             AND active_yn  = 'Y'
             AND ROWNUM     = 1 ;
        
          IF ( LVL_COUNT > 0 ) THEN
           
              P_OUT := F_MSG('[REEL CLOSE] 현재 장착된 바코드 입니다.', 'K', 1)    
                       || ' = '   
                       || P_REEL_BCR;
                       
              RETURN ;    
               
          ELSE    
            
             
                 UPDATE IM_ITEM_RECEIPT_BARCODE
                    SET REEL_DESTROY_YN   = 'Y',
                        reel_destroy_date = sysdate,
                        MSL_PASSED_TIME   = NVL(MSL_PASSED_TIME,0) + ((SYSDATE - NVL(MSL_OPEN_DATE,SYSDATE)) * 24),
                        LAST_MODIFY_DATE  = SYSDATE,
                        MSL_OPEN_DATE     = NULL
                  WHERE ITEM_BARCODE      = P_REEL_BCR;
                  
           END IF;
     
     ELSE
       
           UPDATE IM_ITEM_RECEIPT_BARCODE
              SET REEL_DESTROY_YN   = 'N',
                  reel_destroy_date = NULL,
                  LAST_MODIFY_DATE  = SYSDATE
            WHERE ITEM_BARCODE      = P_REEL_BCR;       
       
     END IF;
    	
     
   COMMIT; 
   
   p_out := 'OK';
   
EXCEPTION
   WHEN OTHERS THEN
     
        p_out := 'NG, [P_CHECK_REELCLOSE] ' 
                 || SQLERRM;   
  
end ;
