FUNCTION "F_GET_MM_FREE_RECEIPT_QTY" 
  ( as_supplier_code IN varchar2,
    as_item_code IN varchar2,
    as_yyyymm IN varchar2,
    ai_org   IN  NUMBER)
  RETURN  number IS
  al_receipt_qty number ;
BEGIN

    select nvl(sum(receipt_qty),0)
    into   al_receipt_qty
    from   im_item_free_receipt
    where  supplier_code = as_supplier_code
    and    item_code = as_item_code
    and    receipt_date between F_GET_INVENTORY_CLOSE_DATE( as_yyyymm , 'START' , organization_id )
			 AND F_GET_INVENTORY_CLOSE_DATE( as_yyyymm , 'END' , organization_id )
--    and    receipt_status <> 'C'
    and    organization_id = ai_org
    ;

   return al_receipt_qty ;

EXCEPTION
       when no_data_found then
            raise_application_error( -20003 ,sqlerrm );
       when others  then
            rollback;
            raise_application_error( -20003 ,sqlerrm );
END;