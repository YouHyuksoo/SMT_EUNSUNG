CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRG_ID_ENG_BOM_EXCEL_INS
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   ID_ENG_BOM_SMT_EXCEL 테이블에 엑셀 업로드 데이터가 반영될 때 기준정보 또는 BOM 관련 후속 처리를 수행한다.
   *   업로드 원천 데이터를 업무 테이블 구조에 맞춰 검증/전개하는 트리거로 추정된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: AFTER
   *   이벤트: INSERT
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   ID_ENG_BOM_SMT_EXCEL - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.PARENT_PART_NO - 신규/변경 후 값 값
   *   :NEW.ITEM_SPEC - 신규/변경 후 품목 관련 값
   *   :NEW.UOM - 신규/변경 후 값 값
   *   :NEW.ITEM_DESC - 신규/변경 후 품목 관련 값
   *   :NEW.FROM_DATE - 신규/변경 후 일자 관련 값
   *   :NEW.PART_NO - 신규/변경 후 값 값
   *   :NEW.LINE_CODE - 신규/변경 후 라인 관련 값
   *   :NEW.MACHINE - 신규/변경 후 설비 관련 값
   *   :NEW.REMARKS - 신규/변경 후 값 값
   *   :NEW.BOM_LEVEL - 신규/변경 후 BOM 관련 값
   *   :NEW.TO_DATE - 신규/변경 후 일자 관련 값
   *   :NEW.SEQ - 신규/변경 후 값 값
   *   :NEW.COMPONENT_QTY - 신규/변경 후 수량 관련 값
   *   :NEW.LOCATION_INFO - 신규/변경 후 값 값
   *   :NEW.SUBSTITUTE_ITEM - 신규/변경 후 품목 관련 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ID_ENG_BOM_SMT_EXCEL - BOM / 엑셀 관련 트리거 대상 테이블
   *   ID_ITEM - 품목 관련 트리거 내부 SQL에서 참조/변경
   *   ID_ENG_BOM - BOM 관련 트리거 내부 SQL에서 참조/변경
   *   ID_ENG_BOM_REPLACE - BOM 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 14회 / 반복문: 0회
   *   DML: SELECT 4회, INSERT 5회, DELETE 2회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_ID_ENG_BOM_EXCEL_INS';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_ID_ENG_BOM_EXCEL_INS';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRG_ID_ENG_BOM_EXCEL_INS" 
 AFTER
  INSERT
 ON id_eng_bom_smt_excel
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   lvi_child_count    NUMBER;
   lvi_parent_count   NUMBER;
   lvi_bom_count      NUMBER;
   PHASE VARCHAR2(10) ;
BEGIN

PHASE := '10' ;
   BEGIN
      SELECT COUNT (*)
        INTO lvi_parent_count
        FROM id_item
       WHERE item_code = :NEW.parent_part_no;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         lvi_parent_count := 0;
      WHEN OTHERS
      THEN
         raise_application_error (-20003, SQLERRM);
   END;
PHASE := '20' ;
   IF lvi_parent_count > 0
   THEN
      NULL;
   ELSE
PHASE := '30' ;
      INSERT INTO id_item
                  (item_code,
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
                   sale_price_apply_type
                  )
           VALUES (:NEW.parent_part_no,
                   1, --ORGANIZATION_ID,
                   SUBSTR (:NEW.item_spec, 1, 100),
                   :NEW.uom, --ITEM_UOM,
                   '*', --ITEM_CLASS,
                   'T', --ITEM_TYPE,
                   'N', --VIRTUAL_RECEIPT_YN,
                   :NEW.item_desc, --ITEM_NAME,
                   'T', --LINE_TYPE,
                   '*', --ROUTE_NO,
                      '*'
                   || :NEW.parent_part_no
                   || '*', --BARCODE,
                   'A', --ABC_GRADE,
                   SYSDATE, --ENTER_DATE,
                   '*', --RAW_MATERIAL,
                   0, --SAFETY_INVENTORY,
                   0, --WORK_BAD_RATE,
                   :NEW.uom, --TRANSFER_UOM,
                   0, --MANUFACTURE_LEADTIME,
                   0, --ORDER_CYCLE,
                   'A', --ORDER_RULE,
                   '*', --HS_CODE,
                   'SYSTEM', --ENTER_BY,
                   '*', --SVC_CODE,
                   0, --CAPACITY,
                   SYSDATE, --LAST_MODIFY_DATE,
                   0, --LENGTH,
                   'SYSTEM', --LAST_MODIFY_BY,
                   :NEW.from_date, --DATESET,
                   TO_DATE ('99991231', 'YYYYMMDD'), --DATEEND,
                   'Y', --SET_ITEM_YN,
                   '*', --SPECIAL_PROPERTY,
                   0, --LAYER,
                   :NEW.parent_part_no, --PART_NO,
                   0, --HEIGHT,
                   0, --WEIGHT,
                   '*', --DRAWING_NO,
                   0, --GRADIENT,
                   0, --DENSITY,
                   'F', --ITEM_DIVISION,
                   0, --ISSUE_PACKING_QTY,
                   0, --INNER_DIAMETER,
                   0, --OUTER_DIAMETER,
                   0, --WIDTH,
                   '*', --HS_NAME,
                   '*', --HS_SPEC,
                   '*', --HS_CODE_SCRAP,
                   '*', --HS_NAME_SCRAP,
                   '*', --HS_SPEC_SCRAP,
                   'N', --TRANSFER_YN,
                   '*', --LINE_CODE,
                   0, --TARIFF_RATE,
                   '*', --SUPPLIER_CODE,
                   '*', --CUSTOMER_CODE,
                   '*', --MODEL_NAME,
                   '*', --MODEL_SUFFIX,
                   'N', --AUTO_ISSUE_YN,
                   'N', --AUTO_RECEIPT_YN,
                   'N', --AUTO_ISSUE_PLAN_YN,
                   0, --BUY_PRICE,
                   0, --SALE_PRICE,
                   '*' --SALE_PRICE_APPLY_TYPE
                  );
   END IF;
PHASE := '40' ;

------------------------------------------------------
--
------------------------------------------------------
   BEGIN
      SELECT COUNT (*)
        INTO lvi_child_count
        FROM id_item
       WHERE item_code = :NEW.part_no;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         lvi_child_count := 0;
      WHEN OTHERS
      THEN
         raise_application_error (-20003, SQLERRM);
   END;
PHASE := '50' ;
   IF lvi_child_count > 0
   THEN
      NULL;
   ELSE
PHASE := '60' ;
      INSERT INTO id_item
                  (item_code,
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
                   sale_price_apply_type
                  )
           VALUES (:NEW.part_no,
                   1, --ORGANIZATION_ID,
                   SUBSTR (:NEW.item_spec, 1, 100),
                   :NEW.uom, --ITEM_UOM,
                   '*', --ITEM_CLASS,
                   'T', --ITEM_TYPE,
                   'N', --VIRTUAL_RECEIPT_YN,
                   :NEW.item_desc, --ITEM_NAME,
                   'D', --LINE_TYPE,
                   '*', --ROUTE_NO,
                      '*'
                   || :NEW.parent_part_no
                   || '*', --BARCODE,
                   'A', --ABC_GRADE,
                   SYSDATE, --ENTER_DATE,
                   '*', --RAW_MATERIAL,
                   0, --SAFETY_INVENTORY,
                   0, --WORK_BAD_RATE,
                   :NEW.uom, --TRANSFER_UOM,
                   0, --MANUFACTURE_LEADTIME,
                   0, --ORDER_CYCLE,
                   'A', --ORDER_RULE,
                   '*', --HS_CODE,
                   'SYSTEM', --ENTER_BY,
                   '*', --SVC_CODE,
                   0, --CAPACITY,
                   SYSDATE, --LAST_MODIFY_DATE,
                   0, --LENGTH,
                   'SYSTEM', --LAST_MODIFY_BY,
                   :NEW.from_date, --DATESET,
                   TO_DATE ('99991231', 'YYYYMMDD'), --DATEEND,
                   'N', --SET_ITEM_YN,
                   '*', --SPECIAL_PROPERTY,
                   0, --LAYER,
                   :NEW.part_no, --PART_NO,
                   0, --HEIGHT,
                   0, --WEIGHT,
                   '*', --DRAWING_NO,
                   0, --GRADIENT,
                   0, --DENSITY,
                   'R', --ITEM_DIVISION,
                   0, --ISSUE_PACKING_QTY,
                   0, --INNER_DIAMETER,
                   0, --OUTER_DIAMETER,
                   0, --WIDTH,
                   '*', --HS_NAME,
                   '*', --HS_SPEC,
                   '*', --HS_CODE_SCRAP,
                   '*', --HS_NAME_SCRAP,
                   '*', --HS_SPEC_SCRAP,
                   'N', --TRANSFER_YN,
                   '*', --LINE_CODE,
                   0, --TARIFF_RATE,
                   '*', --SUPPLIER_CODE,
                   '*', --CUSTOMER_CODE,
                   '*', --MODEL_NAME,
                   '*', --MODEL_SUFFIX,
                   'N', --AUTO_ISSUE_YN,
                   'N', --AUTO_RECEIPT_YN,
                   'N', --AUTO_ISSUE_PLAN_YN,
                   0, --BUY_PRICE,
                   0, --SALE_PRICE,
                   '*' --SALE_PRICE_APPLY_TYPE
                  );
   END IF;
PHASE := '70' ;

------------------------------------------------------------
--
------------------------------------------------------------

   BEGIN
      SELECT COUNT (*)
        INTO lvi_bom_count
        FROM id_eng_bom
       WHERE parent_item_code = :NEW.parent_part_no
         AND child_item_code = :NEW.part_no
         AND line_code = :new.line_code
         and machine = :new.machine
         AND location_code = :new.remarks
         AND organization_id = 1;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         lvi_bom_count := 0;
      WHEN OTHERS
      THEN
         raise_application_error (-20003, SQLERRM);
   END;
PHASE := '80' ;
   IF lvi_bom_count > 0  THEN

      DELETE FROM id_eng_bom
       WHERE parent_item_code = :NEW.parent_part_no
         AND child_item_code = :NEW.part_no
         AND line_code = :new.line_code
         AND  machine = :new.machine
         AND location_code = :new.remarks
         AND organization_id = 1;


   END IF;
   PHASE := '90' ;

      if nvl(:NEW.LINE_CODE ,'*')= '*' or nvl(:NEW.MACHINE,'*') = '' or nvl(:new.remarks ,'*') = '*' then
          null;
     else
      INSERT INTO id_eng_bom
                  (parent_item_code,
                   child_item_code,
                   bom_level,
                   dateset,
                   dateend,
                   location_code,
                   organization_id,
                   sort_sequence,
                   item_unit_qty,
                   workstage_code,
                   bom_work_no,
                   item_type,
                   line_type,
                   enter_by,
                   enter_date,
                   last_modify_by,
                   last_modify_date,
                   location_info,
                   line_code,
                   machine

                  )
           VALUES (:NEW.parent_part_no,
                   :NEW.part_no,
                   :NEW.bom_level,
                   :NEW.from_date, --DATESET,
                   DECODE (
                      :NEW.TO_DATE,
                      NULL, TO_DATE ('99991231', 'YYYYMMDD'),
                      :NEW.TO_DATE
                   ), --DATEEND,

                   :new.remarks,
                   1, --ORGANIZATION_ID,
                   :NEW.seq, --SORT_SEQUENCE,
                   :NEW.component_qty,
                   '*', --WORKSTAGE_CODE,
                   0, --BOM_WORK_NO,
                   'T', --ITEM_TYPE,
                   'G', --LINE_TYPE,
                   'SYSTEM', --ENTER_BY,
                   SYSDATE, --ENTER_DATE,
                   'SYSTEM', --LAST_MODIFY_BY,
                   SYSDATE, --LAST_MODIFY_DATE
                   :NEW.location_info,
                   :NEW.line_code,
                   :NEW.machine

                  );

     end if ;
     if nvl(:new.SUBSTITUTE_ITEM,'*') <> '*'  then

PHASE := '100' ;
          BEGIN
              SELECT COUNT (*)
                INTO lvi_bom_count
                FROM id_eng_bom_replace
               WHERE parent_item_code  = :NEW.parent_part_no
                 AND child_item_code   = :NEW.part_no
                 AND location_code     = :new.remarks
                 AND replace_item_code = :new.SUBSTITUTE_ITEM
                 AND organization_id   = 1;
           EXCEPTION
              WHEN NO_DATA_FOUND
              THEN
                 lvi_bom_count := 0;
              WHEN OTHERS
              THEN
                 raise_application_error (-20003, SQLERRM);
           END;
PHASE := '110' ;
           IF lvi_bom_count > 0         THEN

              DELETE FROM id_eng_bom_replace
               WHERE parent_item_code  = :NEW.parent_part_no
                 AND child_item_code   = :NEW.part_no
                 AND location_code     = :new.remarks
                 AND replace_item_code =:new.SUBSTITUTE_ITEM
                 AND organization_id   = 1;


           END IF ;
   PHASE := '120' ;
       if nvl(:NEW.LINE_CODE ,'*')= '*' or nvl(:NEW.MACHINE,'*') = '' or nvl(:new.remarks ,'*') = '*' then
          null ;
       else
         INSERT INTO id_eng_bom_replace
                  (parent_item_code,
                   child_item_code,
                   REPLACE_ITEM_CODE ,
                   bom_level,
                   dateset,
                   dateend,
                   location_code,
                   organization_id,
                   sort_sequence,
                   item_unit_qty,
                   workstage_code,
                   bom_work_no,
                   item_type,
                   line_type,
                   enter_by,
                   enter_date,
                   last_modify_by,
                   last_modify_date,
                   line_code,
                   machine

                  )
           VALUES (:NEW.parent_part_no,
                   :NEW.part_no,
                   :new.SUBSTITUTE_ITEM ,
                   :NEW.bom_level,
                   :NEW.from_date, --DATESET,
                   DECODE (
                      :NEW.TO_DATE,
                      NULL, TO_DATE ('99991231', 'YYYYMMDD'),
                      :NEW.TO_DATE
                   ), --DATEEND,

                   :new.remarks,
                   1, --ORGANIZATION_ID,
                   :NEW.seq, --SORT_SEQUENCE,
                   :NEW.component_qty,
                   '*', --WORKSTAGE_CODE,
                   0, --BOM_WORK_NO,
                   'T', --ITEM_TYPE,
                   'G', --LINE_TYPE,
                   'SYSTEM', --ENTER_BY,
                   SYSDATE, --ENTER_DATE,
                   'SYSTEM', --LAST_MODIFY_BY,
                   SYSDATE, --LAST_MODIFY_DATE
                   :NEW.line_code,
                   :NEW.machine
                  );
        end if ;
       end if ;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003,'PHASE='||PHASE||' '|| :NEW.parent_part_no||' '||:NEW.part_no||'  line='||:NEW.LINE_CODE||' Machine='||:NEW.MACHINE||' Pos='||:new.remarks||' '||SQLERRM);
END;
