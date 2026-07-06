PROCEDURE "P_PRODUCT_FG_INV_DEVIDE" (p_barcode varchar2, p_div_qty number,  p_commit varchar2, p_out out varchar2, p_msg out varchar2) is
   /****************************************************
    *재고 분할
    *  1. 원 바코드 수불 정리 해준다 입고 취소
    *  2. 분할 A -> B, C 로 분할 된다.
    *  3. Pack Master , Pack Serial 생성 해주고
    *  4, 분할된 Serial 모두 입고 처리 한다.
    ****************************************************/
    lvl_inv_qty number ;
    lvs_out  varchar2(4000);
    lvs_oMsg varchar2(4000);
begin
    /******************************
    * 바코드 확인
    ******************************/
    begin
      select qty
        into lvl_inv_qty
        from ip_product_fg_inventory x
       where barcode  = p_barcode
         and pack_type   = 'M'  --메거진 라벨이고
         and pallet_flag = 'N'  --파렛 되지 않은
       ;
    exception
      when no_data_found then
        p_out := 'NG' ;
        p_msg := f_msg('존재하지 않는 Barcode 입니다.','C',1);
        return ;
      when others then
        p_out := 'NG';
        p_msg := substr(sqlerrm,1,200);
        return ;
    end ;


    /******************************
    * 입고 취소 를 한다.
    *******************************/
    P_PRODUCT_FG_RECEIPT(p_barcode, 'P01',  '2',  'N', lvs_out, lvs_oMsg) ;

    if lvs_out = 'NG' then
      if p_commit = 'Y' then
         rollback ;
      end if;
      p_out := 'NG';
      p_msg := lvs_oMsg ;
      return ;
    end if ;


    /*****************************
    * Pack Master / Serial 분할
    ******************************/
    insert into ip_product_pack_master (
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
          parent_barcode,
          divide_flag

     )
     select pack_barcode||'-'||decode(lvl,1,'A','B'),
        pack_type,
        model_name,
        part_no,
        sysdate,
        packing_pcs_qty,
        decode(lvl,1, pack_qty - p_div_qty, p_div_qty),
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
        'Y',
        'Y',
        'N',
        'N',
        'N',
        'N',
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
        sysdate,
        'FG_DIVDE',
        sysdate,
        'FG_DEVIDE',
        model_suffix,
        customer_code,
        pack_barcode,
        'N'
  from ip_product_pack_master  ,
       ( select level lvl
          from dual
          connect by level < 3 )
 where pack_barcode = p_barcode ;



 update ip_product_pack_master
    set divide_flag = 'Y',
        last_modify_date = sysdate,
        last_modify_by   = 'FG_DEVIDE'
  where pack_barcode = p_barcode ;

  insert into ip_product_pack_serial (
      barcode,
      pack_barcode,
      workstage_code,
      line_code,
      run_no,
      attr1,
      attr2,
      attr3,
      attr4,
      attr5,
      attr6,
      attr7,
      attr8,
      attr9,
      attr10,
      attr11,
      attr12,
      final_inspect_date,
      final_inspect_flag,
      scan_date,
      organization_id,
      enter_date,
      enter_by,
      last_modify_date,
      last_modify_by,
      barcode_qty

  )
  select barcode||'-'||decode(lvl,1,'A','B'),
        pack_barcode||'-'||decode(lvl,1,'A','B'),
        workstage_code,
        line_code,
        run_no,
        attr1,
        attr2,
        attr3,
        attr4,
        attr5,
        attr6,
        attr7,
        attr8,
        attr9,
        attr10,
        attr11,
        attr12,
        final_inspect_date,
        final_inspect_flag,
        scan_date,
        organization_id,
        sysdate,
        enter_by,
        sysdate,
        last_modify_by,
        decode(lvl,1, barcode_qty - p_div_qty, p_div_qty )
  from ip_product_pack_serial ,
       ( select level lvl
          from dual
          connect by level < 3 )
 where barcode = p_barcode ;




   /******************************
    * 분할 건 입고 한다.
    *******************************/
    P_PRODUCT_FG_RECEIPT(p_barcode||'-A', 'P01',  '1',  'N', lvs_out, lvs_oMsg) ;

    if lvs_out = 'NG' then
      if p_commit = 'Y' then
         rollback ;
      end if;
      p_out := 'NG';
      p_msg := lvs_oMsg ;
      return ;
    end if ;


    /******************************
    * 분할 건 입고 .
    *******************************/
    P_PRODUCT_FG_RECEIPT(p_barcode||'-B', 'P01',  '1',  'N', lvs_out, lvs_oMsg) ;


    if lvs_out = 'NG' then
      if p_commit = 'Y' then
         rollback ;
      end if;
      p_out := 'NG';
      p_msg := lvs_oMsg ;
      return ;
    end if ;


     if p_commit = 'Y' then
         commit ;
     end if;

     p_out := 'OK' ;
     p_msg := p_barcode||'-'||'A'||':'|| p_barcode||'-'||'B' ;




exception
  when others then
    p_out := 'NG' ;
    p_msg := substr(sqlerrm,1,200);

    if p_commit = 'Y' then
      rollback ;
    end if;

end P_PRODUCT_FG_INV_DEVIDE;