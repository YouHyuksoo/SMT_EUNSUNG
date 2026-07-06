FUNCTION "F_GET_PLAN_MOLD_REQUEST_QTY" (p_plan_date IN DATE, p_plan_sequence IN NUMBER, p_break_qty in number  , p_org IN NUMBER
)
   RETURN NUMBER
IS
   lvf_plan_qty                  NUMBER;
   lvi_qty number ;
BEGIN

   SELECT plan_qty
   INTO   lvf_plan_qty
   FROM   ip_product_mi_plan
   WHERE  plan_date = p_plan_date AND plan_sequence = p_plan_sequence
          AND organization_id = p_org;



           lvi_qty := trunc(lvf_plan_qty / p_break_qty) ;

           if mod( lvf_plan_qty , p_break_qty ) > 0 then
              lvi_qty := lvi_qty + 1  ;
           end if ;

   RETURN lvi_qty;



EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
   WHEN OTHERS
   THEN
      raise_application_error(-20003, SQLERRM);
END;