FUNCTION "F_GET_CREATE_CELLBIZ_BARCODE" (p_model varchar2, p_suffix varchar2, p_item varchar2,  p_workdate date, p_line varchar2, p_workstage varchar2 , p_pack_unit_qty number) return varchar2 is
  /* Cell Biz Line 박스포장 바코드 생성 */
  lvs_barcode varchar2(100); 
begin
  
  P_CREATE_CELL_BIZ_BARCODE(p_model, p_suffix, p_item, p_workdate, p_line , p_workstage, p_pack_unit_qty ,  lvs_barcode ); 
  
  return lvs_barcode ;  

end F_GET_CREATE_CELLBIZ_BARCODE;