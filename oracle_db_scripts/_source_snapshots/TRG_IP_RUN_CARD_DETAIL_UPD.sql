TRIGGER "INFINITY21_JSMES"."TRG_IP_RUN_CARD_DETAIL_UPD" 
 AFTER
   UPDATE OF enter_date
 ON ip_product_run_card_detail
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
BEGIN
   UPDATE im_item_inventory
      SET inventory_hold = 'Y'
    WHERE material_mfs = :NEW.material_mfs
      AND organization_id = :NEW.organization_id;
END;