FUNCTION F_GET_CREATE_CELLBIZ_BARCODE_N (p_model varchar2, p_suffix varchar2, p_item varchar2,  p_workdate date, p_line varchar2, p_workstage varchar2,  p_pack_unit_qty number, p_scan_barcode varchar2 
                                                          )
return varchar2 is

  /* Cell Biz Line 박스포장 바코드 생성 */
  lvs_barcode varchar2(100); 
  
begin
  
  P_CREATE_CELL_BIZ_BARCODE_NN (p_model, p_suffix, p_item, p_workdate, p_line , p_workstage, p_pack_unit_qty , p_scan_barcode, lvs_barcode ); 
  
  return lvs_barcode ;  

end;
