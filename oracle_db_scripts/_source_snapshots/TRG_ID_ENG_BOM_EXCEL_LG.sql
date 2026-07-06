TRIGGER "INFINITY21_JSMES"."TRG_ID_ENG_BOM_EXCEL_LG" AFTER
    INSERT ON ID_ENG_BOM_EXCEL_LG REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW DECLARE lvi_child_count NUMBER;
    lvi_parent_count                                                                                                      NUMBER;
    lvi_bom_count                                                                                                         NUMBER;
    lvs_parent_part_no                                                                                                    VARCHAR2 (20);
    phase                                                                                                                 VARCHAR2 (10);
    lvs_bom_level                                                                                                         VARCHAR2 (10);
    LVI_POS                                                                                                               NUMBER;
    LVS_REPLACE_ITEM_CODE                                                                                                 VARCHAR2 (100);
    LVS_REPLACE_ITEM_CODE_org                                                                                             VARCHAR2 (100);
    
    BEGIN
      
      ------ 
      phase         := '10';
      
      lvs_bom_level := REPLACE (:new.bom_level, '..', '');
      lvs_bom_level := REPLACE (:new.bom_level, '.', '');
      lvs_bom_level := REPLACE (lvs_bom_level, '0.', '');
      
      BEGIN
        SELECT COUNT (*)
        INTO lvi_parent_count
        FROM id_item
       WHERE item_code = :new.parent_part_no;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
        lvi_parent_count := 0;
      WHEN OTHERS THEN
        raise_application_error (-20003, SQLERRM);
      END;
      
      phase              := '20';
      
      IF lvi_parent_count > 0 THEN
        NULL;
      ELSE
        phase := '30';
        INSERT
        INTO id_item
          (
            item_code,
            organization_id,
            item_spec,
            item_uom,
            item_class,
            item_type,
            virtual_receipt_yn,
            item_name,
            line_type,
            route_no,
            barcode,
            abc_grade,
            enter_date,
            raw_material,
            safety_inventory,
            work_bad_rate,
            transfer_uom,
            manufacture_leadtime,
            order_cycle,
            order_rule,
            hs_code,
            enter_by,
            svc_code,
            capacity,
            last_modify_date,
            LENGTH,
            last_modify_by,
            dateset,
            dateend,
            set_item_yn,
            special_property,
            layer,
            part_no,
            height,
            weight,
            drawing_no,
            gradient,
            density,
            item_division,
            issue_packing_qty,
            inner_diameter,
            outer_diameter,
            width,
            hs_name,
            hs_spec,
            hs_code_scrap,
            hs_name_scrap,
            hs_spec_scrap,
            transfer_yn,
            line_code,
            tariff_rate,
            supplier_code,
            customer_code,
            model_name,
            model_suffix,
            auto_issue_yn,
            auto_receipt_yn,
            auto_issue_plan_yn,
            buy_price,
            sale_price,
            sale_price_apply_type,
            is_new_yn,
            MSL_LEVEL ,
            MSL_MAX_TIME
          )
          VALUES
          (
            :new.parent_part_no,
            1, --ORGANIZATION_ID,
            NVL(:new.item_spec, '*'),
            :NEW.SVC_CODE,                                               --ITEM_UOM,
            :NEW.ITEM_CLASS,                                                --ITEM_CLASS,
            'T',            --ITEM_TYPE,
            'N',            --VIRTUAL_RECEIPT_YN,
            NVL(:new.item_desc,'*') , --ITEM_NAME,
            'T',            --LINE_TYPE,
            '*',            --ROUTE_NO,
            '*'
            || :new.parent_part_no
            || '*',                                   --BARCODE,
            'C',                                      --ABC_GRADE,
            SYSDATE,                                  --ENTER_DATE,
            '*',                                      --RAW_MATERIAL,
            0,                                        --SAFETY_INVENTORY,
            0,                                        --WORK_BAD_RATE,
            'EA',                                     --TRANSFER_UOM,
            0,                                        --MANUFACTURE_LEADTIME,
            0,                                        --ORDER_CYCLE,
            'A',                                      --ORDER_RULE,
            '*',                                      --HS_CODE,
            'SYSTEM',                                 --ENTER_BY,
            '*',                                      --SVC_CODE,
            0,                                        --CAPACITY,
            SYSDATE,                                  --LAST_MODIFY_DATE,
            0,                                        --LENGTH,
            'SYSTEM',                                 --LAST_MODIFY_BY,
            TRUNC(SYSDATE) , --TO_DATE (:new.expiry_date, 'yyyy-mm-dd'), --SYSDATE,                                            --DATESET,
            TO_DATE ('99991231', 'YYYYMMDD'),         --DATEEND,
            'Y',                                      --SET_ITEM_YN,
            '*',                                      --SPECIAL_PROPERTY,
            0,                                        --LAYER,
            NVL(:new.comments,:new.parent_part_no),   --PART_NO,      -- 20200425 김현동씨 요청으로 comments 값 사용      
            -- :new.parent_part_no,                   --PART_NO,
            0,                                        --HEIGHT,
            0,                                        --WEIGHT,
            '*',                                      --DRAWING_NO,
            0,                                        --GRADIENT,
            0,                                        --DENSITY,
            'F',                                      --ITEM_DIVISION,
            0,                                        --ISSUE_PACKING_QTY,
            0,                                        --INNER_DIAMETER,
            0,                                        --OUTER_DIAMETER,
            0,                                        --WIDTH,
            '*',                                      --HS_NAME,
            '*',                                      --HS_SPEC,
            '*',                                      --HS_CODE_SCRAP,
            '*',                                      --HS_NAME_SCRAP,
            '*',                                      --HS_SPEC_SCRAP,
            'N',                                      --TRANSFER_YN,
            '*',                                      --LINE_CODE,
            0,                                        --TARIFF_RATE,
            'LGD',                                    --SUPPLIER_CODE,
            'LGD',                                    --CUSTOMER_CODE,
            :NEW.MODEL_NAME,                          --MODEL_NAME,
            '*',                                      --MODEL_SUFFIX,
            'N',                                      --AUTO_ISSUE_YN,
            'N',                                      --AUTO_RECEIPT_YN,
            'Y',                                      --AUTO_ISSUE_PLAN_YN,
            0,                                        --BUY_PRICE,
            0,                                        --SALE_PRICE,
            '*',                                      --SALE_PRICE_APPLY_TYPE
            'Y',
            :NEW.MSL_LEVEL ,
            F_GET_BASECODE_VALUE( 'MSL LEVEL' , :NEW.MSL_LEVEL , 1 ) 
          );
      END IF;
      
      phase := '40';
      ------------------------------------------------------
      --
      ------------------------------------------------------
      BEGIN
        SELECT COUNT (*)
        INTO lvi_child_count
        FROM id_item
        WHERE item_code = :new.part_no;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
        lvi_child_count := 0;
      WHEN OTHERS THEN
        raise_application_error (-20003, SQLERRM);
      END;
      
      phase             := '50';
      
      IF lvi_child_count > 0 THEN
      
        UPDATE ID_ITEM 
           SET ITEM_SPEC  = NVL(:new.item_spec ,'*') ,
               ITEM_CLASS = :NEW.ITEM_CLASS 
         WHERE ITEM_CODE = :new.part_no;
         
      ELSE
        -------------------------------------------------------------
        --
        -------------------------------------------------------------
        phase := '60';
        
        INSERT
        INTO id_item
          (
            item_code,
            organization_id,
            item_spec,
            item_uom,
            item_class,
            item_type,
            virtual_receipt_yn,
            item_name,
            line_type,
            route_no,
            barcode,
            abc_grade,
            enter_date,
            raw_material,
            safety_inventory,
            work_bad_rate,
            transfer_uom,
            manufacture_leadtime,
            order_cycle,
            order_rule,
            hs_code,
            enter_by,
            svc_code,
            capacity,
            last_modify_date,
            LENGTH,
            last_modify_by,
            dateset,
            dateend,
            set_item_yn,
            special_property,
            layer,
            part_no,
            height,
            weight,
            drawing_no,
            gradient,
            density,
            item_division,
            issue_packing_qty,
            inner_diameter,
            outer_diameter,
            width,
            hs_name,
            hs_spec,
            hs_code_scrap,
            hs_name_scrap,
            hs_spec_scrap,
            transfer_yn,
            line_code,
            tariff_rate,
            supplier_code,
            customer_code,
            model_name,
            model_suffix,
            auto_issue_yn,
            auto_receipt_yn,
            auto_issue_plan_yn,
            buy_price,
            sale_price,
            sale_price_apply_type,
            is_new_yn,
            MSL_LEVEL,
            MSL_MAX_TIME
          )
          VALUES
          (
            :new.part_no,
            1, --ORGANIZATION_ID,
            NVL(:new.item_spec,'*'),
            :NEW.SVC_CODE,                                               --ITEM_UOM,
            :NEW.ITEM_CLASS,                                                --ITEM_CLASS,
            'T',                                                 --ITEM_TYPE,
            'N',                                                 --VIRTUAL_RECEIPT_YN,
            :new.item_desc,                                      --ITEM_NAME,
            'F' , --LINE_TYPE,
            '*',                                                 --ROUTE_NO,
            '*'|| :new.part_no|| '*',                            --BARCODE,
            'C',                                      --ABC_GRADE,
            SYSDATE,                                  --ENTER_DATE,
            '*',                                      --RAW_MATERIAL,
            0,                                        --SAFETY_INVENTORY,
            0,                                        --WORK_BAD_RATE,
            'EA',                                     --TRANSFER_UOM,
            0,                                        --MANUFACTURE_LEADTIME,
            0,                                        --ORDER_CYCLE,
            'A',                                      --ORDER_RULE,
            '*',                                      --HS_CODE,
            'SYSTEM',                                 --ENTER_BY,
            '*',                                      --SVC_CODE,
            0,                                        --CAPACITY,
            SYSDATE,                                  --LAST_MODIFY_DATE,
            0,                                        --LENGTH,
            'SYSTEM',                                 --LAST_MODIFY_BY,
            TRUNC(SYSDATE),                           --:NEW.create_date,                                --DATESET,
            TO_DATE ('99991231', 'YYYYMMDD'),         --DATEEND,
            'N',                                      --SET_ITEM_YN,
            '*',                                      --SPECIAL_PROPERTY,
            0,                                        --LAYER,
            NVL(:new.comments,:new.part_no),    --PART_NO,     -- 20200425 김현동씨 요청으로 comments 값 사용         
            -- :new.parent_part_no,                   --PART_NO,
            0,                                        --HEIGHT,
            0,                                        --WEIGHT,
            '*',                                      --DRAWING_NO,
            0,                                        --GRADIENT,
            0,                                        --DENSITY,
            DECODE( :NEW.LOCATION_INFO , NULL , 'W' , 'R')  ,                                     --ITEM_DIVISION,
            0,                                        --ISSUE_PACKING_QTY,
            0,                                        --INNER_DIAMETER,
            0,                                        --OUTER_DIAMETER,
            0,                                        --WIDTH,
            '*',                                      --HS_NAME,
            '*',                                      --HS_SPEC,
            '*',                                      --HS_CODE_SCRAP,
            '*',                                      --HS_NAME_SCRAP,
            '*',                                      --HS_SPEC_SCRAP,
            'N',                                      --TRANSFER_YN,
            '*',                                      --LINE_CODE,
            0,                                        --TARIFF_RATE,
            'LGD',                                    --SUPPLIER_CODE,
            'LGD',                                    --CUSTOMER_CODE,
            :NEW.MODEL_NAME,                          --MODEL_NAME,
            '*',                                      --MODEL_SUFFIX,
            'N',                                      --AUTO_ISSUE_YN,
            'N',                                      --AUTO_RECEIPT_YN,
            'Y',                                      --AUTO_ISSUE_PLAN_YN,
            0,                                        --BUY_PRICE,
            0,                                        --SALE_PRICE,
            '*',                                      --SALE_PRICE_APPLY_TYPE
            'Y',
            :NEW.MSL_LEVEL ,
            F_GET_BASECODE_VALUE( 'MSL LEVEL' , :NEW.MSL_LEVEL , 1 ) 
          );
          
      END IF;
      
      -----------------------------------------------------------
      --REPLACE ITEM
      -----------------------------------------------------------
      
      LVS_REPLACE_ITEM_CODE_org := :new.substitute_item;
      
      LOOP
        --대체자재 없으면 통과
        IF NVL (TRIM (LVS_REPLACE_ITEM_CODE_org), '*') = '*' THEN
          EXIT;
        END IF;
        
        --만약 두개 라면 콤마 구분자가 있으므로 찾는다
        LVI_POS := INSTR (LVS_REPLACE_ITEM_CODE_org, ',', 1);
        
        -- 없으먄 한개므로 자신의 길이 +1 로 가상 위치 로 설정
        IF LVI_POS = 0 THEN
          LVI_POS := LENGTH (LVS_REPLACE_ITEM_CODE_org) + 1;
        END IF;
        
        LVS_REPLACE_ITEM_CODE := TRIM (SUBSTR (LVS_REPLACE_ITEM_CODE_org, 1, LVI_POS - 1));
        -- 처리된 만큼 떼어내고 다시 보관
        LVS_REPLACE_ITEM_CODE_org := TRIM (SUBSTR (LVS_REPLACE_ITEM_CODE_org, LVI_POS + 1, 100));
        
        --    IF NVL (:new.substitute_item, '*') <> '*'
        IF NVL (LVS_REPLACE_ITEM_CODE, '*') <> '*' THEN
          
          BEGIN
            SELECT COUNT (*)
            INTO lvi_child_count
            FROM id_item
            WHERE item_code = LVS_REPLACE_ITEM_CODE;
          EXCEPTION
          WHEN NO_DATA_FOUND THEN
            lvi_child_count := 0;
          WHEN OTHERS THEN
            raise_application_error (-20003, SQLERRM);
          END;
          
          phase                      := '70';
          
          IF NVL (lvi_child_count, 0) > 0 THEN
            NULL;
          ELSE
            -------------------------------------------------------------
            --
            -------------------------------------------------------------
            phase := '80';
            
            INSERT
            INTO id_item
              (
                item_code,
                organization_id,
                item_spec,
                item_uom,
                item_class,
                item_type,
                virtual_receipt_yn,
                item_name,
                line_type,
                route_no,
                barcode,
                abc_grade,
                enter_date,
                raw_material,
                safety_inventory,
                work_bad_rate,
                transfer_uom,
                manufacture_leadtime,
                order_cycle,
                order_rule,
                hs_code,
                enter_by,
                svc_code,
                capacity,
                last_modify_date,
                LENGTH,
                last_modify_by,
                dateset,
                dateend,
                set_item_yn,
                special_property,
                layer,
                part_no,
                height,
                weight,
                drawing_no,
                gradient,
                density,
                item_division,
                issue_packing_qty,
                inner_diameter,
                outer_diameter,
                width,
                hs_name,
                hs_spec,
                hs_code_scrap,
                hs_name_scrap,
                hs_spec_scrap,
                transfer_yn,
                line_code,
                tariff_rate,
                supplier_code,
                customer_code,
                model_name,
                model_suffix,
                auto_issue_yn,
                auto_receipt_yn,
                auto_issue_plan_yn,
                buy_price,
                sale_price,
                sale_price_apply_type,
                is_new_yn ,
                MSL_LEVEL ,
                MSL_MAX_TIME
              )
              VALUES
              (
                :new.substitute_item,
                1, --ORGANIZATION_ID,
                NVL(:new.item_spec ,'*') ,
                :NEW.SVC_CODE,                                               --ITEM_UOM,
                :NEW.ITEM_CLASS,                                                --ITEM_CLASS,
                'T',                                                --ITEM_TYPE,
                'N',                                                --VIRTUAL_RECEIPT_YN,
                :new.item_desc,                                     --ITEM_NAME,
                DECODE (SUBSTR(:new.item_type,1,1), 'P', 'G', 'F'), --LINE_TYPE,
                '*',                                                --ROUTE_NO,
                '*'
                || :new.part_no
                || '*',                                   --BARCODE,
                'C',                                      --ABC_GRADE,
                SYSDATE,                                  --ENTER_DATE,
                '*',                                      --RAW_MATERIAL,
                0,                                        --SAFETY_INVENTORY,
                0,                                        --WORK_BAD_RATE,
                'EA',                                     --TRANSFER_UOM,
                0,                                        --MANUFACTURE_LEADTIME,
                0,                                        --ORDER_CYCLE,
                'A',                                      --ORDER_RULE,
                '*',                                      --HS_CODE,
                'SYSTEM',                                 --ENTER_BY,
                '*',                                      --SVC_CODE,
                0,                                        --CAPACITY,
                SYSDATE,                                  --LAST_MODIFY_DATE,
                0,                                        --LENGTH,
                'SYSTEM',                                 --LAST_MODIFY_BY,
                TRUNC(SYSDATE), --:NEW.create_date,                                --DATESET,
                TO_DATE ('99991231', 'YYYYMMDD'),         --DATEEND,
                'N',                                      --SET_ITEM_YN,
                '*',                                      --SPECIAL_PROPERTY,
                0,                                        --LAYER,
                NVL(:new.comments,:new.substitute_item),    --PART_NO,           -- 20200425 김현동씨 요청으로 comments 값 사용  
                -- :new.parent_part_no,                   --PART_NO,
                0,                                        --HEIGHT,
                0,                                        --WEIGHT,
                '*',                                      --DRAWING_NO,
                0,                                        --GRADIENT,
                0,                                        --DENSITY,
                 DECODE( :NEW.LOCATION_INFO , NULL , 'W' , 'R'),                                      --ITEM_DIVISION,
                0,                                        --ISSUE_PACKING_QTY,
                0,                                        --INNER_DIAMETER,
                0,                                        --OUTER_DIAMETER,
                0,                                        --WIDTH,
                '*',                                      --HS_NAME,
                '*',                                      --HS_SPEC,
                '*',                                      --HS_CODE_SCRAP,
                '*',                                      --HS_NAME_SCRAP,
                '*',                                      --HS_SPEC_SCRAP,
                'N',                                      --TRANSFER_YN,
                '*',                                      --LINE_CODE,
                0,                                        --TARIFF_RATE,
                'LGD',                                    --SUPPLIER_CODE,
                'LGD',                                    --CUSTOMER_CODE,
                :NEW.SET_ITEM_CODE,                       --MODEL_NAME,
                '*',                                      --MODEL_SUFFIX,
                'N',                                      --AUTO_ISSUE_YN,
                'N',                                      --AUTO_RECEIPT_YN,
                'N',                                      --AUTO_ISSUE_PLAN_YN,
                0,                                        --BUY_PRICE,
                0,                                        --SALE_PRICE,
                '*',                                      --SALE_PRICE_APPLY_TYPE
                'Y',
                :NEW.MSL_LEVEL ,
                F_GET_BASECODE_VALUE( 'MSL LEVEL' , :NEW.MSL_LEVEL , 1 ) 
              );
          END IF;
          
          BEGIN
            
            INSERT
            INTO ID_ITEM_REPLACE
              (
                PARENT_ITEM_CODE,
                CHILD_ITEM_CODE,
                REPLACE_ITEM_CODE,
                ORGANIZATION_ID,
                REPLACE_SEQUENCE,
                DATESET,
                DATEEND,
                ITEM_UNIT_QTY,
                WORKSTAGE_CODE,
                ITEM_UNIT_QTY_EXT,
                ENTER_BY,
                ENTER_DATE,
                LAST_MODIFY_BY,
                LAST_MODIFY_DATE,
                BOM_LOCATION_CODE
              )
              VALUES
              (
                :new.set_item_code,                       --PARENT_ITEM_CODE,
                :new.part_no,                             --CHILD_ITEM_CODE,
                NVL (LVS_REPLACE_ITEM_CODE, '*'),         --REPLACE_ITEM_CODE,
                1,                                        --ORGANIZATION_ID,
                1,                                        --REPLACE_SEQUENCE,
                TRUNC(SYSDATE), --DATESET,
                TO_DATE ('99991231', 'YYYYMMDD'),         --DATEEND,
                :new.component_qty,
                '*',                --WORKSTAGE_CODE,
                :new.component_qty, --ITEM_UNIT_QTY_EXT,
                'SYSTEM',           --ENTER_BY,
                SYSDATE,            --ENTER_DATE,
                'SYSTEM',           --LAST_MODIFY_BY,
                SYSDATE,            --LAST_MODIFY_DATE,
                '*'                 --BOM_LOCATION_CODE
              );
     
          EXCEPTION
          WHEN OTHERS THEN
            NULL;
            --   RAISE_APPLICATION_ERROR (-20007, SQLERRM);
          END;
          
        END IF;
        
      END LOOP;
      
      ------------------------------------------------------------
      -- BOM CREATE YN
      ------------------------------------------------------------
      IF NVL(:NEW.BOM_CREATE_YN ,'Y') = 'N' THEN
        NULL;
      ELSE
        
        BEGIN
          
          phase := '70';
          
          SELECT COUNT (*)
          INTO lvi_bom_count
          FROM id_eng_bom_workspace
          WHERE child_item_code = :new.parent_part_no;
          
          IF lvi_bom_count      > 0 THEN
            NULL;
          ELSE
            
            -------------------------------------------------------------
            ------
            -------------------------------------------------------------
            phase := 'AAA100';
            
            INSERT
            INTO id_eng_bom_workspace
              (
                parent_item_code,
                child_item_code,
                dateset,
                organization_id,
                sort_sequence,
                item_unit_qty,
                item_unit_qty_ext,
                workstage_code,
                dateend,
                bom_work_no,
                item_type,
                line_type,
                loss_rate,
                scrap_rate,
                enter_by,
                enter_date,
                last_modify_by,
                last_modify_date,
                assy_explosion_yn,
                request_yn,
                item_code,
                new_bom_yn
              )
            SELECT '*',            --PARENT_PART_NO,
              :new.parent_part_no, --part_no,
              TRUNC(SYSDATE),
              organization_id,
              0 sort_sequence,
              1,   --ITEM_UNIT_QTY,
              1,   --ITEM_UNIT_QTY_EXT,
              '*', --WORKSTAGE_CODE,
              dateend,
              -- :new.comments, --BOM_WORK_NO,
              :new.BOM_WORK_NO, --BOM_WORK_NO,
              'T',           --ITEM_TYPE,
              'T',           --LINE_TYPE,
              0 loss_rate,
              0 scrap_rate,
              id_item.enter_by,       --ENTER_BY,
              SYSDATE,                --ENTER_DATE,
              id_item.last_modify_by, --LAST_MODIFY_BY,
              SYSDATE,                --LAST_MODIFY_DATE,
              'Y',                    --ASSY_EXPLOSION_YN
              'N',
              :new.set_item_code,
              'Y'
            FROM id_item
           WHERE item_code = :new.parent_part_no;
            
          END IF;
          -------------------------------------------------------------
          --BOM
          -------------------------------------------------------------
          phase         := '110';
         
         lvi_bom_count := 0 ;
          
          SELECT COUNT (*)
            INTO lvi_bom_count
            FROM id_eng_bom_workspace
           WHERE child_item_code = :new.part_no;
          
          
          IF lvi_bom_count      > 0 THEN
            NULL;
          ELSE
            
            INSERT
            INTO id_eng_bom_workspace
              (
                parent_item_code,
                child_item_code,
                dateset,
                organization_id,
                sort_sequence,
                item_unit_qty,
                item_unit_qty_ext,
                workstage_code,
                dateend,
                bom_work_no,
                item_type,
                line_type,
                loss_rate,
                scrap_rate,
                enter_by,
                enter_date,
                last_modify_by,
                last_modify_date,
                assy_explosion_yn,
                request_yn,
                item_code,
                new_bom_yn,
                location_info,
                replace_item_code
              )
            SELECT :new.parent_part_no, --id_eng_bom_excel.PARENT_PART_NO,
              :new.part_no,             --id_eng_bom_excel.part_no,
              MAX (id_item.dateset),
              id_item.organization_id,
              :new.no,                  --MAX (id_eng_bom_v.sort_sequence),
              MAX (:new.component_qty), --SUM (item_unit_qty),
              MAX (:new.extended_qty),  -- COUNT(*),
              '*',                      --id_item.workstage_code,
              id_item.dateend,
              -- :new.comments,                          --MAX (id_eng_bom_v.bom_work_no),
              :new.bom_work_no,                          --MAX (id_eng_bom_v.bom_work_no),
              'T',                                    --id_item.item_type,
              DECODE (:new.item_type, 'P', 'T', 'F'), --id_item.line_type,
              0,                                      --SUM (id_eng_bom_v.loss_rate),
              0,                                      --SUM (id_eng_bom_v.scrap_rate),
              MAX (id_item.enter_by),
              SYSDATE, --max(id_item.enter_date),
              MAX (id_item.last_modify_by),
              SYSDATE, --max(id_item.last_modify_date),
              'Y',
              'N',
              :new.set_item_code,
              'Y',
              :new.location_info,
              :new.substitute_item
            FROM id_item
            WHERE id_item.item_code = :new.part_no
            AND id_item.dateset    <= TRUNC (SYSDATE)
            AND id_item.dateend    >= TRUNC (SYSDATE)
            GROUP BY id_item.item_code,
              id_item.item_code,
              id_item.dateset,
              id_item.organization_id,
              id_item.dateend,
              id_item.item_type,
              id_item.line_type;
          END IF ;
          
        EXCEPTION
        WHEN OTHERS THEN
          raise_application_error ( -20003, 'PHASE=' || phase || ' Parent Item=' || :new.parent_part_no || '  ' || SQLERRM);
        END;
      END IF;
      
    EXCEPTION
    WHEN OTHERS THEN
      raise_application_error ( -20004, 'PHASE=' || phase || ' Parent Item=' || :new.parent_part_no || '  ' || SQLERRM);
      
    END;
