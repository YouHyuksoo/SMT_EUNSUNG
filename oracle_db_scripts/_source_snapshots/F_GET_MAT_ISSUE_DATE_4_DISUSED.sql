FUNCTION "F_GET_MAT_ISSUE_DATE_4_DISUSED" 
  ( p_mfs in VARCHAR2 ,
    p_item_code IN varchar2 ,p_line_type IN varchar2 ,
    p_month_term in number ,
    p_org IN number)
  RETURN  date IS

-- ---------   ------  -------------------------------------------
   lvdt_issue_date date ;

BEGIN

    select min(issue_date) into lvdt_issue_date
     from im_item_issue
    where item_code = p_item_code
      and line_type = p_line_type
      and issue_date >= trunc(sysdate) - p_month_term
      and issue_account in ( 'M001' , 'M002' )
      and issue_status = 'N'
      and organization_id = p_org ;



    RETURN lvdt_issue_date ;

EXCEPTION
   WHEN NO_DATA_FOUND THEN
        RETURN null ;
   WHEN others THEN
       raise_application_error( -20003 , sqlerrm ) ;
END;