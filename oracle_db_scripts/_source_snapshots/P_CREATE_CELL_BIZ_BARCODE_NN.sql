PROCEDURE P_CREATE_CELL_BIZ_BARCODE_NN (
                                                           p_model varchar2, 
                                                           p_suffix varchar2, 
                                                           p_item varchar2,  
                                                           p_date date, 
                                                           p_line varchar2, 
                                                           p_workstage varchar2, 
                                                           p_pack_unit_qty number ,  
                                                           p_run_no varchar2, 
                                                           p_out out varchar2
                                                        ) is

  -- YYYYMMDDNN 생산일에 품목코드 대비 생산롯트순번 표기 대응
  
  Pragma autonomous_transaction ; 

  lvs_seq                varchar2(7) ;
  lvs_date               varchar2(8);
  lvs_pack_barcode       varchar2(100) ;
  lvs_company_no         varchar2(10) ;
  lvs_marking_condition  varchar2(1) ;
  
  lvs_yyyymmddnn         varchar2(100);

begin
  
    lvs_seq  := to_char( SEQ_BOX4_SEQUENCE.NEXTVAL,'FM0000') ; 
    lvs_date := to_char( p_date,'YYYYMMDD') ; 
    
------------------------------------------------------------------
--
------------------------------------------------------------------
    select company_no , marking_condition
      into lvs_company_no , lvs_marking_condition
      from ip_product_model_master 
    where model_name = p_model  ; 
 
------------------------------------------------------------------
--
------------------------------------------------------------------

 if nvl(lvs_marking_condition , 'N') = 'Y' then 

    lvs_pack_barcode := lvs_date||p_item||TRIM(TO_CHAR(p_pack_unit_qty,'0000000'))||lvs_seq ;
    
 elsif nvl(lvs_marking_condition , 'N') = 'T' then
   
     select substr( f_get_product_box_yyyymmddnn ( lvs_date, p_run_no ), 1, 100 )
       into lvs_yyyymmddnn
       from dual;
   
     if ( substr(lvs_yyyymmddnn,1,2) <> 'NG') then
       
          lvs_pack_barcode := substr(lvs_yyyymmddnn, 3, 8)||p_item||TRIM(TO_CHAR(p_pack_unit_qty,'0000'))||lvs_seq ;    -- YYYYMMDDNN 을 YYMMDDNN
       
     else
       
           DBMS_OUTPUT.put_line(lvs_yyyymmddnn);
           p_out := 'ERROR' ; 
       
     end if;
  
 else
  
    lvs_pack_barcode := p_item||'/'||lvs_date||lvs_seq||'/'||p_pack_unit_qty||'/'||lvs_company_no||'//'||p_item||'/'||'120'||'/'||lvs_date||lvs_seq||'/////'   ;
    
 end if  ;
 
 

    insert into ip_product_pack_master ( 
      pack_barcode, 
      pack_type, -- 'C' Cell Biz 
      model_name, 
      MODEL_SUFFIX,
      part_no, 
      pack_date, 
      packing_pcs_qty, 
      pack_qty, 
      
      line_code, 
      workstage_code, 
      
      attr1, 
      attr2, 
      attr3, 
      attr4, 
      attr5, 
      
      complete_flag, 
      print_flag, 
      reprint, 
          
      organization_id, 
      enter_date, 
      enter_by, 
      last_modify_date, 
      last_modify_by

    ) values ( 
      --p_model||lvs_supplier||lvs_date||lvs_seq, 
      lvs_pack_barcode, 
      'C',
      --'6871L-'||p_model,
      p_model, 
      p_suffix, 
      p_item,                             --'*', 
      p_date,
      p_pack_unit_qty, 
      0, 
      
      p_line, 
      p_workstage, 
      
      '', 
      '', 
      lvs_date,
      '',  
      'EUNSUNG',
      'N',
      'N',
      0, 
      1, 
      sysdate, 
      'PRC',
      sysdate,
      'PRC'
          
    ) ; 
    
    commit ; 
    
    p_out := lvs_pack_barcode ;
    
exception 
  when others then 
    rollback ;
    DBMS_OUTPUT.put_line(SQLERRM);
    p_out := 'ERROR' ; 
end ;
