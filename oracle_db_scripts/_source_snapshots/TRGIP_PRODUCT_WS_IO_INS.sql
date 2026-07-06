TRIGGER "INFINITY21_JSMES"."TRGIP_PRODUCT_WS_IO_INS"
 BEFORE 
 INSERT
 ON IP_PRODUCT_WORKSTAGE_IO  REFERENCING OLD AS OLD NEW AS NEW
 FOR EACH ROW
DECLARE
    lvi_exists      NUMBER;
    lvd_actual_date DATE ;
    last_wip_seq    number ;  
    lvs_shift_code  varchar2(2); 
    lvs_worktime_zone varchar2(2); 
    lvi_count       NUMBER; 
    lvs_from_line   varchar2(20); 
    lvs_from_workstage varchar2(20); 
    
    lvs_workstage_type varchar2(2); 
    lvl_lot_qty number ;
    
    --------------------------------------------------
    -- WIP_SEQ 를 통해 바로 앞의 공정이 어디 인지 확인 한다. 
    --------------------------------------------------
BEGIN


    ---------------------------------------------------------------------------
    -- 패킹된넘 못들어오도록 설정 
    -- 1 차 ui 에서 제어함.
    ---------------------------------------------------------------------------


    ---------------------------------------------------------------------------
    lvs_shift_code  := f_get_work_shift_code(:new.io_date) ; 
    lvd_actual_date := F_GET_WORK_ACTUAL_DATE(:new.io_date,'A') ;
    lvs_worktime_zone := f_get_worktime_zone(to_char(:new.io_date,'yyyymmdd'), to_char(:new.io_date,'hh24mi'),'ZONE');     
    :new.Actual_Date := lvd_actual_date; 
    :new.shift_code  := lvs_shift_code ; 
    :new.work_time_zone := lvs_worktime_zone ; 
    :new.actual_yyymmdd := to_char(lvd_actual_date,'yyyymmdd'); 
    
   
/*

    \************************************************************
    분할 일 경우는 form workstage 를 본인 W/S 로 지정 한다. 2018.04.11
    재고 관련된 로직은 이미 원라벨에서 처리 되었기에 의미 없음
    *************************************************************\
    if :new.split_flag = 'Y' then 
      :new.from_line_code      := :new.line_code; 
      :new.from_workstage_code := :new.workstage_code ;
      return ; 
    else  
      \**********************************\
      \* 앞공정명,WIP_SEQ 2016.09.26       *\
      \**********************************\
      begin 
        select LINE_CODE, 
               workstage_code, 
               wip_seq 
          into lvs_from_line, lvs_from_workstage, last_wip_seq 
          from ( 
            select io_date , lead(io_date) over ( partition by serial_no order by wip_seq ) is_last,  line_code, workstage_code , wip_seq 
              from ip_product_workstage_io x   
             where x.serial_no = :new.serial_no
        ) where is_last is null  ;
        
      exception 
        when no_data_found then 
          lvs_from_line      := null; 
          lvs_from_workstage := null; 
          last_wip_seq       := 0 ;   
         when others then 
          lvs_from_line      := 'ERR'; 
          lvs_from_workstage := 'ERR'; 
          last_wip_seq       := 0 ; 
      end ;  
     
      --from 추가  2016.09.26
      :new.from_line_code      := lvs_from_line ; 
      :new.from_workstage_code := lvs_from_workstage; 
      \*************************************\
    end if;
    
     
    if last_wip_seq > 0 then --처음 공정으로 들어오는 넘이 아니면 
      UPDATE   ip_product_workstage_io
         SET   io_deficit = 'O',
               out_date = SYSDATE,
               dest_line_code = '00',
               dest_workstage_code = :new.workstage_code
       WHERE   serial_no = :new.serial_no 
         AND   wip_seq   = last_wip_seq     ;   --바로 앞공정의 데이터를 출고 데이터로 생성 바꾸고 목적지를 넣어 준다 
    end if ; 
    
    UPDATE IP_PRODUCT_2D_BARCODE X
      SET x.workstage_code =  :new.workstage_code, 
          x.actual_date    =  :new.enter_date,
          x.line_code      =  '00', 
          x.is_progress    =  1
    where x.SERIAL_NO      = :new.serial_no  ; 
      
    ---------------------------------- 
    --현재 나의 Wip Seq 를 만들어 준다 
    ----------------------------------
    :new.wip_seq := last_wip_seq + 1  ; 

   -----------------------------------------------------------------------------
    BEGIN 
    SELECT COUNT(*) 
      INTO LVI_COUNT 
     FROM IP_PRODUCT_WORKSTAGE_INV X
       WHERE  x.model_name  = :new.model_name 
       and x.line_code      = '00' 
       and x.workstage_code = :new.workstage_code 
       and x.run_no = :new.run_no;
       
    EXCEPTION WHEN NO_DATA_FOUND THEN 
      LVI_COUNT := 0 ;
    END ;
    
    ---------------------------------------------------------------------------
    -- 재공 이동 / 추가 
    ---------------------------------------------------------------------------
    if LVI_COUNT > 0 then 
    
          --다른 공정에 재고 빼기 
          update IP_PRODUCT_WORKSTAGE_INV X
             set INVENTORY_QTY    = INVENTORY_QTY - :new.IO_QTY  
           where x.model_name     = :new.model_name 
            and x.workstage_code =  :new.from_workstage_code 
            and x.line_code      =  '00'
            and x.organization_id = :new.organization_id
            and x.run_no = :new.run_no;    
             
          --내공정에 넣기 
          update IP_PRODUCT_WORKSTAGE_INV X
             set INVENTORY_QTY           = INVENTORY_QTY + :new.IO_QTY  
           where x.model_name     = :new.model_name 
             and x.workstage_code = :new.workstage_code 
             and x.line_code      =  '00'
             and x.organization_id = :new.organization_id
             and x.run_no = :new.run_no;   
         
    else 
    
        INSERT
        INTO IP_PRODUCT_WORKSTAGE_INV
          (
            RUN_NO,
            MODEL_NAME,
            MODEL_SUFFIX,
            INVENTORY_QTY,
            LAST_RECEIPT_DATE,
            LAST_ISSUE_DATE,
            LINE_CODE,
            WORKSTAGE_CODE,
            ENTER_DATE,
            ENTER_BY,
            LAST_MODIFY_DATE,
            LAST_MODIFY_BY,
            ORGANIZATION_ID,
            INVENTORY_TYPE
          )
          VALUES
          (
            :new.run_no,
            :new.model_name ,
            :new.model_suffix,
            :new.IO_QTY  ,
            SYSDATE,
            NULL,
            '00', -- COMMON LINE
            :new.workstage_code,
            SYSDATE,
            'IO TRRIGER',
            SYSDATE,
            'IO TRRIGER',
            :new.organization_id,
            'P'
          );
          
          --다른 공정에 재고 빼기 
          update IP_PRODUCT_WORKSTAGE_INV X
             set INVENTORY_QTY    = INVENTORY_QTY - :new.IO_QTY  
           where x.model_name     = :new.model_name 
             and x.workstage_code =  :new.from_workstage_code 
             and x.line_code      =  '00' 
             and x.organization_id = :new.organization_id
             and x.run_no = :new.run_no;    
          --내공정에 넣기   
    
    end if ;
    
    
 */
    
    
--    ----------------------------------
--    --해당 공정에 실적이 존재 하는지 먼저 검사 
--    -----------------------------------
--    select count(*) 
--      into lvi_count  
--      from ip_product_result_4_workstage x 
--     where x.actual_date    = lvd_actual_date
--       and x.shift_code     = lvs_shift_code
--       and x.work_time_zone = lvs_worktime_zone 
--       and x.model_name     = :new.model_name 
--       and x.model_suffix   = :new.model_suffix
--       and x.workstage_code = :new.workstage_code
--       and x.line_code      =  nvl(:new.line_code,'*') -- 2016.11.3 오후 12:00 decode(:new.workstage_code,'W50',:new.line_code,'*') 
--       and rownum =1 ;
--     
--    
--    if lvi_count > 0 then 
--      /*존재 하면 수량 업데이트*/ 
--      update ip_product_result_4_workstage x
--         set actual           = actual + :new.IO_QTY  
--       where x.actual_date    = lvd_actual_date
--         and x.shift_code     = lvs_shift_code
--         and x.work_time_zone = lvs_worktime_zone 
--         and x.model_name     = :new.model_name 
--         and x.model_suffix   = :new.model_suffix
--         and x.workstage_code = :new.workstage_code 
--         and x.line_code      =  nvl(:new.line_code,'*')  -- 2016.11.3 오후 12:00 decode(:new.workstage_code,'W50',:new.line_code,'*') 
--        ;     
--    
--    else 
--      begin 
--        select x.WORKSTAGE_SORT_ORDER
--          into lvi_ws_seq  
--          from IP_PRODUCT_WORKSTAGE x 
--         where x.workstage_code = :new.workstage_code   ;
--      exception 
--        when no_data_found then 
--          lvi_ws_seq := 0 ; 
--      end ; 
--      
--      INSERT INTO ip_product_result_4_workstage ( 
--          actual_date, 
--          shift_code, 
--          work_time_zone, 
--          model_name, 
--          model_suffix, 
--          item_code, 
--          workstage_code, 
--          actual, 
--          seq, 
--          lg_work_order, 
--          line_code
--
--      ) VALUES ( 
--         lvd_actual_date, 
--         lvs_shift_code, 
--         lvs_worktime_zone, 
--         :new.model_name, 
--         nvl(:new.model_suffix,'*') , 
--         :new.item_code, 
--         :new.workstage_code , 
--         :new.IO_QTY, --  1, 
--         lvi_ws_seq,
--         '', 
--         nvl(:new.line_code,'*')             -- 2016.11.3 오후 12:00 decode(:new.workstage_code,'W50',:new.line_code,'*')    
--      ) ; 
--    end if; 
--       
    
    /*begin 
     select workstage_type 
       into lvs_workstage_type 
       from ip_product_workstage 
      where workstage_code = :new.workstage_code  
     ; 
    exception 
      when others then 
        lvs_workstage_type := '*' ; 
    end ;  */
    
--    ---------------------------------------------
--    --폐기 관련 공정 실적 수집  
--    --16.09.27  workstage_type = 'R' ( 폐기 관련 ) 
--    ---------------------------------------------       
--    IF :new.workstage_type = 'R' THEN 
--     
--
--      MERGE INTO ip_product_ws_disuse_rslt 
--        USING DUAL 
--        ON (   actual_date     = lvd_actual_date 
--           and model_name      = :new.model_name 
--           and model_suffix    = :new.model_suffix 
--           and disuse_sum_type = 0   
--           and from_workstage_code = nvl(lvs_from_workstage,'*')
--           and workstage_code  = :new.workstage_code
--        ) 
--        
--      WHEN MATCHED THEN 
--        UPDATE SET qty = qty + :new.IO_QTY
--
--      WHEN NOT MATCHED THEN 
--        INSERT ( 
--          actual_date, 
--          yyyymmdd, 
--          model_name, 
--          model_suffix, 
--          item_code, 
--          disuse_sum_type, 
--          from_workstage_code, 
--          workstage_code, 
--          qty, 
--          yyyymm
--
--        ) VALUES ( 
--          lvd_actual_date, 
--          to_char(lvd_actual_date,'yyyymmdd'), 
--          :new.model_name, 
--          :new.model_suffix, 
--          :new.item_code, 
--           0,                --default 
--           nvl(lvs_from_workstage,'*'),  --from workstage 
--          :new.workstage_code, 
--          :new.IO_QTY, --1, 
--          to_char(lvd_actual_date,'yyyymm')
--         
--        ) ; 
--    
--    END IF ; 
    --------------------------------------------------
    
    ---------------------------------------------
    --최종공정일때 
    --실적만들기 일자별 당일 실적은 = 당일07:30 ~ 익일 07:30
    --0000~0730 실적은 전일 실적으로 보내기       
    IF :new.workstage_type = 'L'
    THEN
      NULL ;
    END IF;
exception 
  when others then 
    raise_application_error (-20003, 'TRGIP_PRODUCT_WS_IO_INS '||SQLERRM);
END;
