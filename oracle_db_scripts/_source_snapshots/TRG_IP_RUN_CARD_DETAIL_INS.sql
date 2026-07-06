TRIGGER "INFINITY21_JSMES"."TRG_IP_RUN_CARD_DETAIL_INS" 
 AFTER
  INSERT
 ON ip_product_run_card_detail
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
BEGIN
   UPDATE im_item_inventory
      SET inventory_hold = 'Y'
    WHERE material_mfs = :new.material_mfs
      AND organization_id = :new.organization_id;
END;