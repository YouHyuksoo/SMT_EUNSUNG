FUNCTION "F_GET_MAT_WS_ISSUE_QTY" 
  ( P_WORKSTAGE_code IN VARCHAR2 , P_MFS in VARCHAR2 , P_ITEM_CODE IN VARCHAR2 ,
    P_ORG IN NUMBER)
  RETURN  NUMBER IS


   lvf_issue_qty                number;

BEGIN
    select sum(issue_qty)
      into lvf_issue_qty
      from im_item_workstage_issue
     where workstage_code = P_WORKSTAGE_code
       and mfs = p_mfs
       and item_code = p_item_code
       and organization_id = p_org ;



    RETURN lvf_issue_qty ;
EXCEPTION
when no_data_found then
return 0 ;

   WHEN others THEN
       raise_application_error( -20003 , sqlerrm ) ;
END;