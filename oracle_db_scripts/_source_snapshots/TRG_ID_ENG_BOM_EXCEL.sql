TRIGGER "INFINITY21_JSMES"."TRG_ID_ENG_BOM_EXCEL" 
   AFTER INSERT
   ON INFINITY21_JSMES.ID_ENG_BOM_EXCEL    REFERENCING NEW AS NEW OLD AS OLD
   FOR EACH ROW
DECLARE
   LVI_CHILD_COUNT        NUMBER;
   LVI_PARENT_COUNT       NUMBER;
   LVI_BOM_COUNT          NUMBER;
   LVS_PARENT_ITEM_CODE   VARCHAR2 (20);
   PHASE                  VARCHAR2 (10);
BEGIN
   PHASE := '10';


-------------------------------------------------------------------
--
-------------------------------------------------------------------
   BEGIN
      SELECT COUNT (*)
        INTO LVI_PARENT_COUNT
        FROM ID_ITEM
       WHERE ITEM_CODE = :NEW.ITEM_CODE;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         LVI_PARENT_COUNT := 0;
      WHEN OTHERS
      THEN
         RAISE_APPLICATION_ERROR (-20003, SQLERRM);
   END;

   PHASE := '20';

-------------------------------------------------------------------
--
-------------------------------------------------------------------
   IF LVI_PARENT_COUNT > 0
   THEN
      NULL;
   ELSE
      PHASE := '30';

      INSERT INTO ID_ITEM (ITEM_CODE,
                           ORGANIZATION_ID,
                           ITEM_SPEC,
                           ITEM_UOM,
                           ITEM_CLASS,
                           ITEM_TYPE,
                           VIRTUAL_RECEIPT_YN,
                           ITEM_NAME,
                           LINE_TYPE,
                           ROUTE_NO,
                           BARCODE,
                           ABC_GRADE,
                           ENTER_DATE,
                           RAW_MATERIAL,
                           SAFETY_INVENTORY,
                           WORK_BAD_RATE,
                           TRANSFER_UOM,
                           MANUFACTURE_LEADTIME,
                           ORDER_CYCLE,
                           ORDER_RULE,
                           HS_CODE,
                           ENTER_BY,
                           SVC_CODE,
                           CAPACITY,
                           LAST_MODIFY_DATE,
                           LENGTH,
                           LAST_MODIFY_BY,
                           DATESET,
                           DATEEND,
                           SET_ITEM_YN,
                           SPECIAL_PROPERTY,
                           LAYER,
                           PART_NO,
                           HEIGHT,
                           WEIGHT,
                           DRAWING_NO,
                           GRADIENT,
                           DENSITY,
                           ITEM_DIVISION,
                           ISSUE_PACKING_QTY,
                           INNER_DIAMETER,
                           OUTER_DIAMETER,
                           WIDTH,
                           HS_NAME,
                           HS_SPEC,
                           HS_CODE_SCRAP,
                           HS_NAME_SCRAP,
                           HS_SPEC_SCRAP,
                           TRANSFER_YN,
                           LINE_CODE,
                           TARIFF_RATE,
                           SUPPLIER_CODE,
                           CUSTOMER_CODE,
                           MODEL_NAME,
                           MODEL_SUFFIX,
                           AUTO_ISSUE_YN,
                           AUTO_RECEIPT_YN,
                           AUTO_ISSUE_PLAN_YN,
                           BUY_PRICE,
                           SALE_PRICE,
                           SALE_PRICE_APPLY_TYPE 
                         
                           )
      VALUES (:NEW.ITEM_CODE,
              1,                                            --ORGANIZATION_ID,
              NVL (SUBSTR (:NEW.ITEM_SPEC, 1, 200), '*'),           --ITEM_SPEC,
              'EA',                                                --ITEM_UOM,
              :NEW.ITEM_CLASS,                                     --ITEM_CLASS,
              'T',                                                --ITEM_TYPE,
              'N',                                       --VIRTUAL_RECEIPT_YN,
              :NEW.ITEM_NAME, --SUBSTR (:NEW.item_spec, 1, 100),               --ITEM_NAME,
              'T',                                                --LINE_TYPE,
              '*',                                                 --ROUTE_NO,
              '*' || :NEW.PARENT_ITEM_CODE || '*',                  --BARCODE,
              'A',                                                --ABC_GRADE,
              SYSDATE,                                           --ENTER_DATE,
              '*',                                             --RAW_MATERIAL,
              0,                                           --SAFETY_INVENTORY,
              0,                                              --WORK_BAD_RATE,
              'EA',                                            --TRANSFER_UOM,
              0,                                       --MANUFACTURE_LEADTIME,
              0,                                                --ORDER_CYCLE,
              'A',                                               --ORDER_RULE,
              '*',                                                  --HS_CODE,
              'SYSTEM',                                            --ENTER_BY,
              '*',                                                 --SVC_CODE,
              0,                                                   --CAPACITY,
              SYSDATE,                                     --LAST_MODIFY_DATE,
              0,                                                     --LENGTH,
              'SYSTEM',                                      --LAST_MODIFY_BY,
              TRUNC(SYSDATE),                                              --DATESET,
              TO_DATE ('99991231', 'YYYYMMDD'),                     --DATEEND,
              'Y',                                              --SET_ITEM_YN,
              '*',                                         --SPECIAL_PROPERTY,
              0,                                                      --LAYER,
              :NEW.PART_NO,                                --PART_NO,
              0,                                                     --HEIGHT,
              0,                                                     --WEIGHT,
              '*',                                               --DRAWING_NO,
              0,                                                   --GRADIENT,
              0,                                                    --DENSITY,
              'F',                                            --ITEM_DIVISION,
              0,                                          --ISSUE_PACKING_QTY,
              0,                                             --INNER_DIAMETER,
              0,                                             --OUTER_DIAMETER,
              0,                                                      --WIDTH,
              '*',                                                  --HS_NAME,
              '*',                                                  --HS_SPEC,
              '*',                                            --HS_CODE_SCRAP,
              '*',                                            --HS_NAME_SCRAP,
              '*',                                            --HS_SPEC_SCRAP,
              'N',                                              --TRANSFER_YN,
              '*',                                                --LINE_CODE,
              0,                                                --TARIFF_RATE,
              '*',                                            --SUPPLIER_CODE,
              '*',                                            --CUSTOMER_CODE,
              :new.model_name,                                   --MODEL_NAME,
              :new.model_suffix,                               --MODEL_SUFFIX,
              'N',                                            --AUTO_ISSUE_YN,
              'N',                                          --AUTO_RECEIPT_YN,
              'N',     --AUTO_ISSUE_PLAN_YN,
              0,                                                  --BUY_PRICE,
              0,                                                 --SALE_PRICE,
              '*'                                    --SALE_PRICE_APPLY_TYPE

                 );
   END IF;

   PHASE := '40';

-------------------------------------------------------------------
--
-------------------------------------------------------------------
   BEGIN
      SELECT COUNT (*)
        INTO LVI_CHILD_COUNT
        FROM ID_ITEM
       WHERE ITEM_CODE = :NEW.CHILD_ITEM_CODE;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         LVI_CHILD_COUNT := 0;
      WHEN OTHERS
      THEN
         RAISE_APPLICATION_ERROR (-20003, SQLERRM);
   END;

   PHASE := '50';

-------------------------------------------------------------------
--
-------------------------------------------------------------------

   IF LVI_CHILD_COUNT > 0
   THEN
      NULL;
   ELSE
      PHASE := '60';
-------------------------------------------------------------------
--
-------------------------------------------------------------------
      INSERT INTO ID_ITEM (ITEM_CODE,
                           ORGANIZATION_ID,
                           ITEM_SPEC,
                           ITEM_UOM,
                           ITEM_CLASS,
                           ITEM_TYPE,
                           VIRTUAL_RECEIPT_YN,
                           ITEM_NAME,
                           LINE_TYPE,
                           ROUTE_NO,
                           BARCODE,
                           ABC_GRADE,
                           ENTER_DATE,
                           RAW_MATERIAL,
                           SAFETY_INVENTORY,
                           WORK_BAD_RATE,
                           TRANSFER_UOM,
                           MANUFACTURE_LEADTIME,
                           ORDER_CYCLE,
                           ORDER_RULE,
                           HS_CODE,
                           ENTER_BY,
                           SVC_CODE,
                           CAPACITY,
                           LAST_MODIFY_DATE,
                           LENGTH,
                           LAST_MODIFY_BY,
                           DATESET,
                           DATEEND,
                           SET_ITEM_YN,
                           SPECIAL_PROPERTY,
                           LAYER,
                           PART_NO,
                           HEIGHT,
                           WEIGHT,
                           DRAWING_NO,
                           GRADIENT,
                           DENSITY,
                           ITEM_DIVISION,
                           ISSUE_PACKING_QTY,
                           INNER_DIAMETER,
                           OUTER_DIAMETER,
                           WIDTH,
                           HS_NAME,
                           HS_SPEC,
                           HS_CODE_SCRAP,
                           HS_NAME_SCRAP,
                           HS_SPEC_SCRAP,
                           TRANSFER_YN,
                           LINE_CODE,
                           TARIFF_RATE,
                           SUPPLIER_CODE,
                           CUSTOMER_CODE,
                           MODEL_NAME,
                           MODEL_SUFFIX,
                           AUTO_ISSUE_YN,
                           AUTO_RECEIPT_YN,
                           AUTO_ISSUE_PLAN_YN,
                           BUY_PRICE,
                           SALE_PRICE,
                           SALE_PRICE_APPLY_TYPE,
                           MATERIAL_TYPE)
      VALUES (:NEW.CHILD_ITEM_CODE,
              1,                                            --ORGANIZATION_ID,
              NVL (SUBSTR (:NEW.ITEM_SPEC, 1, 100), '*'),
              'EA',                                                --ITEM_UOM,
              :NEW.ITEM_CLASS,                                --ITEM_CLASS,
              'T',                                                --ITEM_TYPE,
              'N',                                       --VIRTUAL_RECEIPT_YN,
              :NEW.ITEM_NAME,                               --ITEM_NAME,
              'G' ,                                                --LINE_TYPE,
              '*',                                                 --ROUTE_NO,
              '*' || :NEW.CHILD_ITEM_CODE || '*',                  --BARCODE,
              'A',                                                --ABC_GRADE,
              SYSDATE,                                           --ENTER_DATE,
              '*',                                             --RAW_MATERIAL,
              0,                                           --SAFETY_INVENTORY,
              0,                                              --WORK_BAD_RATE,
              'EA',                                            --TRANSFER_UOM,
              0,                                       --MANUFACTURE_LEADTIME,
              0,                                                --ORDER_CYCLE,
              'A',                                               --ORDER_RULE,
              '*',                                                  --HS_CODE,
              'SYSTEM',                                            --ENTER_BY,
              '*',                                                 --SVC_CODE,
              0,                                                   --CAPACITY,
              SYSDATE,                                     --LAST_MODIFY_DATE,
              0,                                                     --LENGTH,
              'SYSTEM',                                      --LAST_MODIFY_BY,
              TRUNC (SYSDATE), --:NEW.create_date,                                --DATESET,
              TO_DATE ('99991231', 'YYYYMMDD'),                     --DATEEND,
              'N',                                              --SET_ITEM_YN,
              '*',                                         --SPECIAL_PROPERTY,
              0,                                                      --LAYER,
              :NEW.PART_NO,                         --child_item_code,
              0,                                                     --HEIGHT,
              0,                                                     --WEIGHT,
              '*',                                               --DRAWING_NO,
              0,                                                   --GRADIENT,
              0,                                                    --DENSITY,
              'R',          --ITEM_DIVISION,
              0,                                          --ISSUE_PACKING_QTY,
              0,                                             --INNER_DIAMETER,
              0,                                             --OUTER_DIAMETER,
              0,                                                      --WIDTH,
              '*',                                                  --HS_NAME,
              '*',                                                  --HS_SPEC,
              '*',                                            --HS_CODE_SCRAP,
              '*',                                            --HS_NAME_SCRAP,
              '*',                                            --HS_SPEC_SCRAP,
              'N',                                              --TRANSFER_YN,
              '*',                                                --LINE_CODE,
              0,                                                --TARIFF_RATE,
              '*',                                            --SUPPLIER_CODE,
              '*',                                            --CUSTOMER_CODE,
              :NEW.MODEL_NAME,                                               --MODEL_NAME,
              :NEW.MODEL_SUFFIX,                                             --MODEL_SUFFIX,
              'N',                                            --AUTO_ISSUE_YN,
              'N',                                          --AUTO_RECEIPT_YN,
              'N',                                       --AUTO_ISSUE_PLAN_YN,
              0,                                                  --BUY_PRICE,
              0,                                                 --SALE_PRICE,
              '*' ,                                      --SALE_PRICE_APPLY_TYPE
              DECODE( :NEW.ITEM_CLASS , 'PCB' , '10' , NULL )  --UNIT ID 중요 삼성 기준 코드
                        
            );
   END IF;



      -------------------------------------------------------------
      --
      -------------------------------------------------------------

      PHASE := '110';
      lvi_bom_count := 0;

      BEGIN
         SELECT COUNT (*)
           INTO lvi_bom_count
           FROM id_eng_bom_workspace
          WHERE parent_item_code = :new.parent_item_code
                AND child_item_code = :new.child_item_code
                AND bom_work_no      = :new.bom_work_no
                AND item_code = :new.item_code ;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            lvi_bom_count := 0;
      END;
---------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------
      IF NVL(lvi_bom_count ,0) > 0
      THEN

        DELETE FROM id_eng_bom_workspace
         WHERE     parent_item_code = :new.parent_item_code
                AND child_item_code  = :new.child_item_code
                AND bom_work_no      = :new.bom_work_no
                AND item_code = :new.item_code
        ;

--         UPDATE id_eng_bom_workspace
--            SET location_info = location_info || ',' || NVL (:new.location_info, ''),
--                item_unit_qty = item_unit_qty + :new.item_unit_qty
--          WHERE     parent_item_code = :new.parent_item_code
--                AND child_item_code  = :new.child_item_code
--                AND bom_work_no      = :new.bom_work_no
--        ;
      ELSE
             NULL ;
      END IF ;
      ---------------------------------------------------------------
      --
      ---------------------------------------------------------------
         INSERT INTO ID_ENG_BOM_WORKSPACE (PARENT_ITEM_CODE,
                                           CHILD_ITEM_CODE,
                                           DATESET,
                                           ORGANIZATION_ID,
                                           SORT_SEQUENCE,
                                           ITEM_UNIT_QTY,
                                           ITEM_UNIT_QTY_EXT,
                                           WORKSTAGE_CODE,
                                           DATEEND,
                                           BOM_WORK_NO,
                                           ITEM_TYPE,
                                           LINE_TYPE,
                                           LOSS_RATE,
                                           SCRAP_RATE,
                                           ENTER_BY,
                                           ENTER_DATE,
                                           LAST_MODIFY_BY,
                                           LAST_MODIFY_DATE,
                                           ASSY_EXPLOSION_YN,
                                           REQUEST_YN,
                                           ITEM_CODE,
                                           NEW_BOM_YN,
                                           LOCATION_INFO,
                                           PCB_ITEM)
            SELECT :NEW.PARENT_ITEM_CODE, --id_eng_bom_excel.parent_item_code,
                   :NEW.CHILD_ITEM_CODE,   --id_eng_bom_excel.child_item_code,
                   NVL(MAX (TRUNC(ID_ITEM.DATESET)), TRUNC(SYSDATE)),
                   ID_ITEM.ORGANIZATION_ID,
                   :NEW.SEQ,               --MAX (id_eng_bom_v.sort_sequence),
                   MAX (:NEW.ITEM_UNIT_QTY),            --SUM (item_unit_qty),
                   MAX (:NEW.ITEM_UNIT_QTY),                      -- COUNT(*),
                   '*',                                --id_item.workstage_code,
                   ID_ITEM.DATEEND,
                   :NEW.BOM_WORK_NO,         --MAX (id_eng_bom_v.bom_work_no),
                   'T',                                   --id_item.item_type,
                   DECODE( :NEW.PCB_ITEM , 'M' , 'F' , 'T') ,                                   --id_item.line_type,
                   0,                          --SUM (id_eng_bom_v.loss_rate),
                   0,                         --SUM (id_eng_bom_v.scrap_rate),
                   MAX (ID_ITEM.ENTER_BY),
                   SYSDATE,                         --max(id_item.enter_date),
                   MAX (ID_ITEM.LAST_MODIFY_BY),
                   SYSDATE,                   --max(id_item.last_modify_date),
                   'Y',
                   'N',
                   :NEW.ITEM_CODE,
                   'Y',
                   :NEW.LOCATION_INFO,
                   :NEW.PCB_ITEM
              FROM ID_ITEM
             WHERE     ID_ITEM.ITEM_CODE = :NEW.CHILD_ITEM_CODE
                 --  AND ID_ITEM.DATESET <= TRUNC (SYSDATE)
                 --  AND ID_ITEM.DATEEND >= TRUNC (SYSDATE)
            GROUP BY ID_ITEM.ITEM_CODE,
                     ID_ITEM.ITEM_CODE,
                     TRUNC(ID_ITEM.DATESET),
                     ID_ITEM.ORGANIZATION_ID,
                     ID_ITEM.DATEEND,
                     ID_ITEM.ITEM_TYPE,
                     ID_ITEM.LINE_TYPE;

   EXCEPTION
      WHEN OTHERS
      THEN
         RAISE_APPLICATION_ERROR (
            -20003,
               'PHASE='
            || PHASE
            || ' Parent Item='
            || :NEW.PARENT_ITEM_CODE
            || '  '
            || SQLERRM);
   END;