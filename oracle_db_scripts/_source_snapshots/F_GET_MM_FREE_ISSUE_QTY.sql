FUNCTION "F_GET_MM_FREE_ISSUE_QTY" 
(   as_supplier_code IN varchar2,
    as_item_code IN varchar2,
    as_yyyymm IN varchar2,
    as_flag IN VARCHAR2,
    ai_org   IN  NUMBER)
  RETURN  number IS
  al_issue_qty  number  ;

BEGIN

   if as_flag = 'M' then
    select nvl(sum(issue_qty),0)
    into   al_issue_qty
    from   im_item_free_issue
    where  supplier_code = as_supplier_code
    and    item_code = as_item_code
    and    issue_date between F_GET_INVENTORY_CLOSE_DATE( as_yyyymm , 'START' , organization_id )
			 AND F_GET_INVENTORY_CLOSE_DATE( as_yyyymm , 'END' , organization_id )
    and    issue_account like 'M001'
    and    organization_id = ai_org
--    and    issue_status <> 'C'
    ;
   elsif as_flag = 'B' then
    select nvl(sum(issue_qty),0)
    into   al_issue_qty
    from   im_item_free_issue
    where  supplier_code = as_supplier_code
    and    item_code = as_item_code
    and    issue_date between F_GET_INVENTORY_CLOSE_DATE( as_yyyymm , 'START' , organization_id )
			 AND F_GET_INVENTORY_CLOSE_DATE( as_yyyymm , 'END' , organization_id )
    and    issue_account like 'M002'
    and    organization_id = ai_org
--    and    issue_status <> 'C'
     ;
   elsif as_flag = 'F' then
    select nvl(sum(issue_qty),0)
    into   al_issue_qty
    from   im_item_free_issue
    where  supplier_code = as_supplier_code
    and    item_code = as_item_code
    and    issue_date between F_GET_INVENTORY_CLOSE_DATE( as_yyyymm , 'START' , organization_id )
			 AND F_GET_INVENTORY_CLOSE_DATE( as_yyyymm , 'END' , organization_id )
    and    issue_account like 'M003'
    and    organization_id = ai_org
--    and    issue_status <> 'C'
    ;
   elsif as_flag = 'E' then
    select nvl(sum(issue_qty),0)
    into   al_issue_qty
    from   im_item_free_issue
    where  supplier_code = as_supplier_code
    and    item_code = as_item_code
    and    issue_date between F_GET_INVENTORY_CLOSE_DATE( as_yyyymm , 'START' , organization_id )
			 AND F_GET_INVENTORY_CLOSE_DATE( as_yyyymm , 'END' , organization_id )
    and    issue_account not in('M001','M002','M003','M004')
    and    organization_id = ai_org
--    and    issue_status <> 'C'
    ;
   elsif as_flag = 'S' then
    select nvl(sum(issue_qty),0)
    into   al_issue_qty
    from   im_item_free_issue
    where  supplier_code = as_supplier_code
    and    item_code = as_item_code
    and    issue_date between F_GET_INVENTORY_CLOSE_DATE( as_yyyymm , 'START' , organization_id )
			 AND F_GET_INVENTORY_CLOSE_DATE( as_yyyymm , 'END' , organization_id )
    and    issue_account like 'M004'
    and    organization_id = ai_org
--    and    issue_status <> 'C'
    ;

   else
    select nvl(sum(issue_qty),0)
    into   al_issue_qty
    from   im_item_free_issue
    where  supplier_code = as_supplier_code
    and    item_code = as_item_code
    and    issue_date between F_GET_INVENTORY_CLOSE_DATE( as_yyyymm , 'START' , organization_id )
			 AND F_GET_INVENTORY_CLOSE_DATE( as_yyyymm , 'END' , organization_id )
    and    organization_id = ai_org
--    and    issue_status <> 'C'
    ;
    end if ;
   return al_issue_qty ;

EXCEPTION
       when no_data_found then
            raise_application_error( -20003 ,sqlerrm );
       when others  then
            rollback;
            raise_application_error( -20003 ,sqlerrm );
END;