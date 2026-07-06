PROCEDURE "P_PRODUCT_FG_MODEL_RECEIPT" (p_barcode varchar2, p_qty varchar2, p_location varchar2,  p_txn number,  p_commit varchar2, p_out out varchar2, p_msg out varchar2) is
   /****************************************************
    * 제품 입고
    * 1. Packing 된 제품을 창고로 입고 한다.
    *    PDA / UI 동시 사용 가능
    *    p_locatoin ( isys basecode PRODUCT LOCATION CODE )
    *    p_commit 'Y" procedure 내에서 Txn 종료
    *             'N' 호출 UI 에서 Txn 종료 처리
    *    p_txn  1 정상 , 2 취소
    ****************************************************
    * IP_PRODUCT_PACK_MASTER RECEIPT_FLAG = 'N' 인것
    ****************************************************/
    lvs_receipt_flag varchar2(1);
    lvs_pallet_flag  varchar2(1);
    lvs_ship_flag    varchar2(1);
    lvs_pack_type    varchar2(2);
    lvl_pack_qty     number     ;
    lvs_model_name   varchar2(50);
    lvs_item_code    varchar2(50);
    
begin
    /******************************
    * 바코드 확인
    ******************************/
    begin
      
      select model_name, item_code, to_number( p_qty ), 'G'
        into lvs_model_name, lvs_item_code, lvl_pack_qty, lvs_pack_type
        from ip_product_model_master
       where model_name = p_barcode 
         and rownum     = 1;
       
    exception
      when no_data_found then
        p_out := 'NG' ;
        p_msg := f_msg('존재하지 않는 모델 입니다.','C',1);
        return ;
      when others then
        p_out := 'NG';
        p_msg := substr(sqlerrm,1,200);
        return ;
    end ;

    /******************************
    * Pack 수량 없는건은 입고 안됨
    ******************************/
    if lvl_pack_qty < 1 then
        p_out := 'NG' ;
        p_msg := f_msg('Packing 수량을 확인하세요.','C',1);
        return ;
    end if ;

    -- 처리
          insert into ip_product_fg_receipt (
                                             receipt_date,
                                             receipt_sequence,
                                             barcode,
                                             pack_type,
                                             txn_deficit,
                                             qty,

                                             model_name,
                                             model_suffix,

                                             item_code,

                                             line_code,
                                             workstage_code,

                                             location_code,
                                             enter_by,
                                             enter_date,
                                             last_modify_by,
                                             last_modify_date,
                                             organization_id ,
                                             actual_date,
                                             work_time_zone,
                                             shift_code

          )
          select sysdate,
                 seq_fg_receipt_seq.nextval,
                 p_barcode,
                 lvs_pack_type,
                 p_txn,
                 lvl_pack_qty,

                 lvs_model_name,
                 '*',
                 lvs_item_code,

                 '*',
                 '*',

                 p_location,
                 'FG_RECEIPT',
                 sysdate,
                 'FG_RECEIPT',
                 sysdate,
                 1      ,
                 f_get_work_actual_date(sysdate,'A'),
                 f_get_worktime_zone(to_char(sysdate,'yyyymmdd'), to_char(sysdate,'hh24mi'),'ZONE'),
                 f_get_work_shift_code(sysdate)
           from dual;

         if p_commit = 'Y' then
           commit ;
         end if;
 

         if p_commit = 'Y' then
           commit ;
         end if;

    p_out := 'OK';

    if p_txn = 1 then
       p_msg := lvs_model_name||', '||to_char(lvl_pack_qty)||'  '||'Receipt '||' '||f_msg('정상처리 되었습니다.','C',1);
    else
       p_msg := lvs_model_name||', '||to_char(lvl_pack_qty)||'  '||'Cancel '||' '||f_msg('정상처리 되었습니다.','C',1);
    end if;

exception
  when others then
    p_out := 'NG' ;
    p_msg := substr(sqlerrm,1,200);

    if p_commit = 'Y' then
      rollback ;
    end if;

end P_PRODUCT_FG_MODEL_RECEIPT;
