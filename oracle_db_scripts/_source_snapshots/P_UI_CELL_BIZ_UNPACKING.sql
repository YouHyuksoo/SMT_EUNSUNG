PROCEDURE "P_UI_CELL_BIZ_UNPACKING" (p_packcode in varchar2, p_out out varchar2 , p_outmsg out varchar2 ) is
pragma autonomous_transaction ; 
--P CREATE CELL BIZ BARCODE
lvl_checkSum number ; 

begin
       lvl_checkSum := 9; 
             
       begin 
         
         select /*decode(x.boxing_flag,         'Y',1,0) + 
                decode(x.pallet_flag,         'Y',1,0) + 
                decode(x.ship_flag,           'Y',1,0) + */
                decode(nvl(x.receipt_flag,'N'),        'Y',1,0) 
           into lvl_checkSum
           from ip_product_pack_master x
          where x.pack_barcode = p_packcode ; 
          
       exception 
          when no_data_found then 
               lvl_checkSum := -1 ; 
       end; 
       
       if lvl_checkSum >= 1 then 
         
         p_out := 'NG';
         p_outmsg := f_msg('이미입고되었습니다','K',1); 
         
         return ; 
         
       elsif lvl_checkSum < 0 then 
         
         p_out := 'NG';
         p_outmsg :=  f_msg('데이터를 찾을수 없습니다' ,'K',1) 
                    ||p_packcode
                    ||f_msg('데이터를 찾을수 없습니다!','K',1); 
                    
         return ; 
         
       elsif lvl_checkSum = 0 then 
         
         --삭제 가능 일때 
         
           UPDATE IP_PRODUCT_2D_BARCODE 
              SET BOX_NO = NULL,
	                last_modify_date = sysdate,
		              last_modify_by   = 'UNPACK',
                  enter_by         = 'UNPACK'
            WHERE BOX_NO           = p_packcode ;
                     
           delete from ip_product_pack_serial 
           where pack_barcode = p_packcode ; 
           
           delete from ip_product_pack_master 
           where pack_barcode = p_packcode ; 
           
           insert into ip_product_pack_master_del (
                                                    pack_barcode, 
                                                    pack_type, 
                                                    model_name, 
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
                                                    attr6, 
                                                    attr7, 
                                                    attr8, 
                                                    complete_flag, 
                                                    print_flag, 
                                                    receipt_flag, 
                                                    boxing_flag, 
                                                    pallet_flag, 
                                                    ship_flag, 
                                                    box_no, 
                                                    pallet_no, 
                                                    ship_no, 
                                                    receipt_no, 
                                                    receipt_date, 
                                                    boxing_date, 
                                                    pallet_date, 
                                                    ship_date, 
                                                    reprint, 
                                                    organization_id, 
                                                    enter_date, 
                                                    enter_by, 
                                                    last_modify_date, 
                                                    last_modify_by, 
                                                    model_suffix, 
                                                    customer_code, 
                                                    divide_flag, 
                                                    parent_barcode,
                                                    del_date,
                                                    del_pc           
                                                  )
           select pack_barcode, 
                  pack_type, 
                  model_name, 
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
                  attr6, 
                  attr7, 
                  attr8, 
                  complete_flag, 
                  print_flag, 
                  receipt_flag, 
                  boxing_flag, 
                  pallet_flag, 
                  ship_flag, 
                  box_no, 
                  pallet_no, 
                  ship_no, 
                  receipt_no, 
                  receipt_date, 
                  boxing_date, 
                  pallet_date, 
                  ship_date, 
                  reprint, 
                  organization_id, 
                  enter_date, 
                  enter_by, 
                  last_modify_date, 
                  last_modify_by, 
                  model_suffix, 
                  customer_code, 
                  divide_flag, 
                  parent_barcode,
                  sysdate,                              -- 삭제일
                  sys_context('USERENV', 'IP_ADDRESS')  -- 삭제 PC
             from ip_product_pack_master 
            where pack_barcode = p_packcode ; 
  
       end if; 

        p_out := 'OK' ; 
        p_outmsg := f_msg('포장이 취소 되었습니다' ,'K',1) 
                 || p_packcode ||f_msg('취소완료','K',1);
        commit ; 

exception 
  when others then 
    
       p_out := 'NG' ; 
       p_outmsg := 'DB Error ' || substr(sqlerrm,1,200);
       
       rollback ;  
       return ; 
     
end p_ui_cell_biz_unpacking;
