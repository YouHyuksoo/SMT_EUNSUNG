TRIGGER "INFINITY21_JSMES"."TRG_IP_RUN_CARD_DETAIL_DEL" 
 AFTER
  DELETE
 ON ip_product_run_card_detail
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
BEGIN
    UPDATE   im_item_inventory
       SET   inventory_hold = 'W'
     WHERE   material_mfs = :old.material_mfs
             AND organization_id = :old.organization_id;
END;