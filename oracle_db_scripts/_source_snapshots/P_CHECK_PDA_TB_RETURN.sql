PROCEDURE "P_CHECK_PDA_TB_RETURN" (
   P_LINE_CODE    IN     VARCHAR2,
   P_MODEL_NAME   IN     VARCHAR2,
   P_TOPBOT       IN     VARCHAR2,
   P_ADDRESS      IN     VARCHAR2,
   P_BARCODE      IN     VARCHAR2,
   P_RETURN          OUT VARCHAR2)
IS
   LVI_COUNT         NUMBER;
   LVS_OUT           VARCHAR2 (1000);
   LVS_MODEL_NAME    VARCHAR2 (30);

   LVL_FIRST         NUMBER;
   LVL_SECOND        NUMBER;
   LVS_ITEM_CODE     VARCHAR2(30);
   LVS_NEW_BARCODE   VARCHAR2 (100);
   LVL_ITEM_QTY      NUMBER;
   LVS_LOT_NO        VARCHAR2 (30);
   LVL_REMAIN_QTY    NUMBER;
   phase varchar2(10);
BEGIN

    LVS_NEW_BARCODE := SUBSTR (UPPER (P_BARCODE), 1, 100);
  
   ------------------------------------------------------------------------------
   --
   ------------------------------------------------------------------------------

   IF LENGTH (LVS_NEW_BARCODE) < 10
   THEN
      P_RETURN := f_msg('[REEL RETURN] 바코드가 올바르지 않습니다.','K',1)
                  || ' = '
                  || P_ADDRESS
                  || ', '
                  || LVS_NEW_BARCODE;
      RETURN;
   END IF;
phase := '10' ;



 LVS_ITEM_CODE := f_get_item_code_from_barcode (lvs_new_barcode);
 lvs_lot_no := f_get_lot_no_from_barcode (lvs_new_barcode);
   
   
--   ----------------------------------------------------------------------------
--   --
--   ----------------------------------------------------------------------------
--   LVL_FIRST := INSTR (LVS_NEW_BARCODE, '-', 7);
--   phase := '14' ;
--   IF LVL_FIRST <= 0
--   THEN
--      LVL_SECOND := 0;
--   ELSE
--      LVL_SECOND := INSTR (LVS_NEW_BARCODE, '-', LVL_FIRST + 1);
--   END IF;
--   phase := '15' ;
--   IF LVL_FIRST <= 0
--   THEN
--      phase := '16' ;
--      LVS_ITEM_CODE := TRIM (SUBSTR (LVS_NEW_BARCODE, 1, 11));
--      phase := '17' ;
--   ELSE
--      phase := '18' ;
--      LVS_ITEM_CODE := SUBSTR (LVS_NEW_BARCODE, 1, LVL_FIRST - 1);
--      phase := '19' ;
--   END IF;
--   
--   phase := '20' ;
--   -----------------------------------------------------------------------------
--   --
--   -----------------------------------------------------------------------------
--   IF LVL_FIRST <= 0 AND LVL_SECOND <= 0
--   THEN
--      LVS_LOT_NO := LVS_NEW_BARCODE;
--   ELSIF LVL_FIRST > 0 AND LVL_SECOND <= 0
--   THEN
--      BEGIN
--         LVS_LOT_NO :=
--            TO_NUMBER (
--               SUBSTR (LVS_NEW_BARCODE,
--                       INSTR (LVS_NEW_BARCODE, '-', 7) + 1,
--                       100));
--      EXCEPTION
--         WHEN OTHERS
--         THEN
--            LVS_LOT_NO :=
--               SUBSTR (LVS_NEW_BARCODE,
--                       INSTR (LVS_NEW_BARCODE, '-', 1) + 1,
--                       100);
--      END;
--   ELSE
--      BEGIN
--         LVS_LOT_NO :=
--            TO_NUMBER (
--               SUBSTR (LVS_NEW_BARCODE,
--                       INSTR (LVS_NEW_BARCODE, '-', 7) + 1,
--                       (LVL_SECOND - LVL_FIRST) - 1));
--      EXCEPTION
--         WHEN OTHERS
--         -- CHAR TO NUMBER ERROR
--         THEN
--            LVS_LOT_NO :=
--               SUBSTR (LVS_NEW_BARCODE,
--                       INSTR (LVS_NEW_BARCODE, '-', 7) + 1,
--                       (LVL_SECOND - LVL_FIRST) - 1);
--      END;
--
--
--phase := '30' ;
--      -----------------------------------------------------------------
--      --
--      ----------------------------------------------------------------
--      BEGIN
--         LVL_ITEM_QTY :=
--            NVL (TO_NUMBER (SUBSTR (LVS_NEW_BARCODE, LVL_SECOND + 1, 10)), 0);
--      EXCEPTION
--         WHEN OTHERS
--         THEN
--            LVL_ITEM_QTY := 0;
--      END;
--   END IF;

   BEGIN
      lvl_item_qty := f_get_lot_qty_from_barcode (lvs_new_barcode);
   EXCEPTION
      WHEN OTHERS
      THEN
      p_return := f_msg('[REEL RETURN] 바코드 내 수량정보 오류 입니다.','K',1)   --'01 Qty Invalid in baarcoe '
                  || ' = '
                  || lvs_new_barcode ; 
      RETURN;
 
   END;
   
   
phase := '40' ;
   ----------------------------------------------------------------------------
   -- LINE OFF
   ---------------------------------------------------------------------------

   BEGIN
     
      SELECT COUNT (*)
        INTO LVI_COUNT
        FROM IB_PRODUCT_PLANDATA
       WHERE LINE_CODE = SUBSTR (P_LINE_CODE, 1, 2)
         AND MODEL_NAME = UPPER (P_MODEL_NAME);
             
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
           P_RETURN := f_msg('[REEL RETURN] 피더 레이아웃에 라인/적용모델이 없습니다.','K',1);   -- '1 Line/Model Notfound in Feeder Layout'
           RETURN;
   END;

   IF LVI_COUNT = 0 THEN
      P_RETURN := f_msg('[REEL RETURN] 피더 레이아웃에 라인/적용모델이 없습니다.','K',1);      -- '1 Line/Model Notfound in Feeder Layout'
      RETURN;
   END IF;

   LVI_COUNT := 0;
   phase := '50' ;
   -------------------------------------------------------------------
   -- 해당 모델이 활성화 상태인지 체크
   --
   -------------------------------------------------------------------
   BEGIN
     
      SELECT COUNT (*)
        INTO LVI_COUNT
        FROM IB_PRODUCT_PLANDATA
       WHERE LINE_CODE = SUBSTR (P_LINE_CODE, 1, 2)
         AND MODEL_NAME = UPPER (P_MODEL_NAME)
         AND ITEM_CODE = LVS_ITEM_CODE
         AND LOT_NO = LVS_LOT_NO
         AND LOCATION_CODE = P_ADDRESS
         AND ACTIVE_YN = 'Y';
         
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
           LVI_COUNT := 0;
   END;
   
phase := '60' ;
   IF LVI_COUNT = 0 THEN
     
      P_RETURN := f_msg('[REEL RETURN] 생산중인 모델/해당자재가 없습니다.','K',1)    -- '2 There is no model/material in production'
                  || ' = '
                  || P_ADDRESS
                  || ', '
                  || LVS_ITEM_CODE
                  || ', '
                  || LVS_LOT_NO;
      RETURN;
   --------------------------------------------------------------------
   --  남아있는 잔량을 조회 한다.
   --------------------------------------------------------------------
   ELSE
     
      BEGIN
        
         SELECT FEEDING_QTY - NVL (PRODUCT_ACTUAL_QTY, 0)
           INTO LVL_REMAIN_QTY
           FROM IB_PRODUCT_PLANDATA
          WHERE LINE_CODE = SUBSTR (P_LINE_CODE, 1, 2)
            AND MODEL_NAME = UPPER (P_MODEL_NAME)
            AND ITEM_CODE = LVS_ITEM_CODE
            AND LOT_NO = LVS_LOT_NO
            AND LOCATION_CODE = P_ADDRESS
            AND ACTIVE_YN = 'Y'
            AND CHECK_YN = 'Y';
                
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
           
            P_RETURN := f_msg('[REEL RETURN] 생산중인 모델/해당자재가 없습니다.','K',1)    -- '3 There is no model/material in production.'
                        || ' = '
                        || P_ADDRESS
                        || ', '
                        || LVS_ITEM_CODE
                        || ', '
                        || LVS_LOT_NO;
            RETURN;
            
      END;
phase := '70' ;
     -----------------------------------------------------------------
      -- 0 보다 작으면 리턴할수 없도록 조치 
      -- 20171026 yhs
      -----------------------------------------------------------------

      IF LVL_REMAIN_QTY < 0 THEN 
        
            P_RETURN := f_msg('[REEL RETURN] 리텅 수량이 0 보다 작습니다.','K',1)     -- 'Return QTY less then zero.'
                        || ' = '
                        || P_ADDRESS
                        || ', '
                        || LVS_ITEM_CODE
                        || ', '
                        || LVS_LOT_NO;
            RETURN;     
      
      END IF ;

      -----------------------------------------------------------------
      -- 바코드 이력 조회
      -----------------------------------------------------------------
      LVI_COUNT := 0;

      BEGIN
        
         SELECT COUNT (*)
           INTO LVI_COUNT
           FROM IM_ITEM_RECEIPT_BARCODE
          WHERE ITEM_CODE = LVS_ITEM_CODE
            AND LOT_NO = LVS_LOT_NO
            AND ORGANIZATION_ID = 1;
                
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
           
            P_RETURN := f_msg('[REEL RETURN] 자재가 바코드 입출고 이력에 없습니다.','K',1)   -- 'Material is not in receive/issue history.'
                        || ' = '
                        || P_ADDRESS
                        || ', '
                        || LVS_ITEM_CODE
                        || ', '
                        || LVS_LOT_NO;
            RETURN;
            
      END;
------------------------------------------------------------------
-- 바코드 마스터에  회수된 잔량을 기록해서 
-- 릴 체인지 또는 CCS 시에 NEW_SCAN_QTY 를 바코드수량보다 우선하여 
-- 장착수량으로 사용하도록 함.
-- 만약음수 상태에서 리턴하면 ?
--
------------------------------------------------------------------

      UPDATE IM_ITEM_RECEIPT_BARCODE
         SET NEW_SCAN_QTY = LVL_REMAIN_QTY
       WHERE ITEM_CODE = LVS_ITEM_CODE
         AND LOT_NO = LVS_LOT_NO
         AND ORGANIZATION_ID = 1;


phase := '80' ;
      ---------------------------------------------------------------
      -- 초기화
      -- 되돌릴수 없음 주의.
      -- 단일릴 회수 이므로 REEL_COLLECT_YN = 로 설정
      -- 회수 된 상태에서 는 릴교환이 안되므로 
      -- 릴교환 로직에 REEL_COLLECT_YN 인경우 제외하고 처리하도록 수
      ---------------------------------------------------------------
      UPDATE IB_PRODUCT_PLANDATA
         SET CCS_YN = 'N',
             CHECK_YN = 'N',
             FEEDING_END_DATE = NULL,
             FEEDING_QTY = FEEDING_QTY - LVL_REMAIN_QTY,
             CHECK_STATUS = 'W' ,
             REEL_COLLECT_YN = 'Y',
             LOT_NO = NULL,
             ITEM_BARCODE = '*'||ITEM_BARCODE
       WHERE LINE_CODE = SUBSTR (P_LINE_CODE, 1, 2)
         AND MODEL_NAME = UPPER (P_MODEL_NAME)
         AND ITEM_CODE = LVS_ITEM_CODE
         AND LOT_NO = LVS_LOT_NO
         AND LOCATION_CODE = P_ADDRESS
         AND ACTIVE_YN = 'Y'
         AND CHECK_YN = 'Y';
         
   END IF;
   
phase := '90' ;

   COMMIT;
   P_RETURN := 'OK';
   RETURN;
-------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------
EXCEPTION
   WHEN OTHERS
   THEN
      P_RETURN := 'NG, [REEL RETURN] ' ||'PHASE='||phase||' '||SQLERRM;
END;
