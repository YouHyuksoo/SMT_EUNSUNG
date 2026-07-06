function f_get_invenotry_location(
                                                    p_org       number,
                                                    p_lot_no    varchar2
                                                   )
   RETURN VARCHAR2
IS
   lvs_location_code   VARCHAR2(10);
BEGIN

  BEGIN
   
     select location_code
       into lvs_location_code
       from im_item_inventory
      where organization_id = p_org
        and material_mfs    = p_lot_no
        and inventory_qty   > 0;
    
  EXCEPTION
     WHEN NO_DATA_FOUND THEN
          lvs_location_code := '*' ;
  END;

  return lvs_location_code ;
  
EXCEPTION
  WHEN OTHERS THEN
       return '*' ;

end;
