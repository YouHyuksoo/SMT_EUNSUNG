FUNCTION "F_GET_MAT_ISSUE_QTY_4_DISUSED" 
  ( p_mfs in VARCHAR2 ,
    p_item_code IN varchar2 ,p_line_type IN varchar2 ,
    p_month_term in number ,
    p_org IN number)
  RETURN  number IS

-- ---------   ------  -------------------------------------------
   lvf_issue_qty number ;
   lvf_count number ;

BEGIN

   select count(*)
   into lvf_count
   from im_item_receipt
   where receipt_date <= trunc(sysdate) - p_month_term
      and item_code = p_item_code
      and line_type = p_line_type
      and organization_id = p_org ;

  if lvf_count = 0 then
   return -1;
  else
    select nvl(sum(issue_qty),0)
    into lvf_issue_qty
    from im_item_issue
    where item_code = p_item_code
      and line_type = p_line_type
      and issue_date >= trunc(sysdate) - p_month_term
      and issue_account in ( 'M001' , 'M002' )
      and issue_status = 'N'
      and organization_id = p_org ;

     RETURN nvl(lvf_issue_qty,0) ;
   end if;

EXCEPTION
   WHEN NO_DATA_FOUND THEN
        RETURN 0 ;
   WHEN others THEN
       raise_application_error( -20003 , sqlerrm ) ;
END;