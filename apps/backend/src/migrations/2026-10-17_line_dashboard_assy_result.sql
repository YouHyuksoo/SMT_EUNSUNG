-- 라인 대시보드(IRPT_PRODUCT_LINE_DASHBOARD) SENSOR_COUNT: 센서실적 → 생산실적(조립실적) 런 합계
-- 원복: docs/sql/irpt-product-line-dashboard-before-2026-10-17.sql 실행 + DROP INDEX IX_IP_ASSEMBLY_RESULT_MFS
CREATE INDEX IX_IP_ASSEMBLY_RESULT_MFS ON IP_ASSEMBLY_RESULT (MFS, ORGANIZATION_ID)
/
CREATE OR REPLACE VIEW IRPT_PRODUCT_LINE_DASHBOARD ("ORGANIZATION_ID", "ORGANIZATION_NAME", "ACTUAL_DATE", "WORK_SHIFT_CODE", "LINE_CODE", "LINE_NAME", "MES_DISPLAY_GROUP", "MES_DISPLAY_YN", "MES_DISPLAY_SEQUENCE", "LINE_STATUS", "LINE_STATUS_NAME", "LINE_STATUS_CODE", "LINE_STATUS_CODE_NAME", "NSNP_LOCK_TYPE", "NSNP_LOCK_TYPE_NAME", "NSNP_REASON", "NSNP_START_DATE", "NSNP_STATUS", "NSNP_STATUS_NAME", "RUNNING_RUN_NO", "RUNNING_MODEL_NAME", "RUNNING_RUN_DATE", "RUN_NO_CHANGED_BY", "SOLDER_LOT_NO", "SOLDER_CHECK_DATE", "RUNNING_LOT_PLAN_QTY", "RUNNING_LOT_INPUT_QTY", "RUNNING_LOT_ACTUAL_QTY", "RUNNING_LOT_NG_QTY", "RUN_DATE", "ITEM_CODE", "MODEL_NAME", "RUN_STATUS", "RUN_STATUS_NAME", "CARRIER_SIZE", "PRODUCT_RUN_TYPE", "PRODUCT_RUN_TYPE_NAME", "MASK_CHECK", "MASK_CHECK_DATE", "SQUEEZE_CHECK", "SQUEEZE_CHECK_DATE", "SOLDER_CHECK", "SOLDER_CHECK_VAL", "SOLDER_CHECK_HOUR", "CCS_CHECK", "CCS_CHECK_DATE", "FULL_CHECK", "FULL_CHECK_DATE", "XRAY_CHECK", "XRAY_CHECK_DATE", "SAMPLE_CHECK", "SAMPLE_CHECK_DATE", "SPEC_CHECK", "SPEC_CHECK_DATE", "JIG_CHECK_FIXTURE", "JIG_CHECK_FIXTURE_LOT", "QC_COMMENTS", "MASK_LOT_NO", "MASK_LOT_NO2", "SQUEEZE_LOT_NO", "SQUEEZE_LOT_NO2", "SPI_PASS_RATE", "AOI_PASS_RATE", "MASK_BREAK_VALUE", "MASK_HIT_VALUE", "SQUEEZE_BREAK_VALUE", "SQUEEZE_HIT_VALUE", "MASK_BREAK_VALUE2", "MASK_HIT_VALUE2", "SQUEEZE_BREAK_VALUE2", "SQUEEZE_HIT_VALUE2", "SOLDER_TYPE", "CUSTOMER_NAME", "PRODUCT_CLASS", "CUSTOMER_MODEL_NAME", "PCB_ITEM", "FIRST_MARKING_DATE", "LAST_MARKING_DATE", "FIRST_SPI_DATE", "FIRST_AOI_DATE", "MODEL_ST", "SENSOR_COUNT", "SPI_COUNT", "AOI_COUNT", "SOLDER_REMAIN_TIME", "PCB_INPUT_QTY", "NOZZLE_CHECK", "NOZZLE_CHECK_DATE", "BACKUPBLOCK_CHECK", "BACKUPBLOCK_CHECK_DATE") AS
select
       pl.organization_id                   as organization_id,
       f_get_org_name(pl.organization_id)   as organization_name,
       f_get_work_actual_date(sysdate, 'A') as ACTUAL_DATE,     --실적 귀속 일자 RUN DATE 조인시 사용
       f_get_work_shift_code(sysdate)       as WORK_SHIFT_CODE, --실적 귀속 주/야 구분 ( 현재 주 / 야 인지 구분 )
       pl.line_code                         as line_code ,
       pl.line_name                         as line_name ,
       pl.mes_display_group    as mes_display_group,
       pl.mes_display_yn       as mes_display_yn,
       pl.mes_display_sequence as mes_display_sequence,
       pl.line_status          as line_status ,
       f_get_basecode('LINE STATUS',pl.line_status,'K',pl.organization_id) as line_status_name,
       pl.line_status_code     as line_status_code,
       f_get_basecode('LINE STATUS CODE',pl.line_status_code,'K',pl.organization_id) as line_status_code_name,
       pl.nsnp_lock_type       as nsnp_lock_type,
       f_get_basecode('NSNP LOCK TYPE',pl.nsnp_lock_type, 'K',pl.organization_id) as nsnp_lock_type_name,
       pl.NSNP_REASON          as nsnp_reason,
       pl.NSNP_START_DATE      as nsnp_start_date,
       nvl(pl.NSNP_STATUS,'N') as nsnp_status,
       F_GET_BASECODE('NSNP STATUS',pl.nsnp_status, 'K', pl.organization_id ) as nsnp_status_name,
       --현재 Running RUN NO 에 대한
       pl.run_no             as running_run_no,
       pl.model_name         as running_model_name,
       pl.run_date           as running_run_date,
       pl.run_no_changed_by  as run_no_changed_by,
       pl.solder_lot_no      as solder_lot_no,    --
       pl.solder_check_date  as solder_check_date,
       F_GET_RUN_LOT_QTY(PL.RUN_NO)   as running_lot_plan_qty,
       F_GET_RUN_LINE_INPUT_QTY(pl.run_no,  pl.line_code, pl.organization_id)  as running_lot_input_qty,
       F_GET_RUN_LINE_ACTUAL_QTY(pl.run_no, pl.line_code, pl.organization_id)  as running_lot_actual_qty,
       F_GET_RUN_NG_QTY(pl.run_no, pl.organization_id)    as running_lot_ng_qty,
       rc.run_date     as run_date,
       rc.item_code    as item_code,
       rc.model_name   as model_name,
       rc.run_status   as run_status,
       f_get_basecode('RUN STATUS',rc.run_status,'K',rc.organization_id) as run_status_name,
       rc.carrier_size     as carrier_size,
       rc.product_run_type as product_run_type,
       f_get_basecode('PRODUCT RUN TYPE',rc.product_run_type, 'K', rc.organization_id ) as product_run_type_name,
decode( pl.run_no, null, '-', decode(pl.mask_check_date,null,decode(pl.mask_check_date2,null,'NG','OK'),'OK'))                                                                                        as mask_check,
decode( pl.run_no, null, '-', decode(pl.mask_check_date,null,decode(pl.mask_check_date2,null,'Mask Check!!',pl.mask_lot_no2) ,to_char(pl.mask_check_date,'YYYY/MM/DD HH24:MI')))                              as mask_check_date,
decode( pl.run_no, null, '-', decode(pl.squeeze_check_date,null,decode(pl.squeeze_check_date2,null,'NG','OK'),'OK'))                                                                                  as squeeze_check,
decode( pl.run_no, null, '-', decode(pl.squeeze_check_date,null,decode(pl.squeeze_check_date2,null,'Squeeze Check!!',pl.squeeze_lot_no2),to_char(pl.squeeze_check_date,'YYYY/MM/DD HH24:MI')))             as squeeze_check_date,
decode( pl.run_no, null, '-', decode(pl.solder_check_date,null,'NG','OK'))                                                 as solder_check,
decode( pl.run_no, null, '-', decode(pl.solder_check_date,null,'Solder Check!!',  PL.solder_lot_no||'    '||SUBSTR( NUMTODSINTERVAL(sysdate - PL.solder_check_date,'DAY') , 12, 8 ) )) as solder_check_val,
       DECODE( TO_NUMBER(SUBSTR( NUMTODSINTERVAL(sysdate - pl.solder_check_date,'DAY') , 12, 2 )),23,'WN',DECODE( TO_NUMBER(SUBSTR( NUMTODSINTERVAL(sysdate - pl.solder_check_date,'DAY'), 2, 9)),1, 'NG','OK')) AS SOLDER_CHECK_HOUR,
decode( pl.run_no, null, '-', decode(pl.ccs_date,null,'NG','OK'))                                                                 as ccs_check,
decode( pl.run_no, null, '-', decode(pl.ccs_date,null,'부품 Check!!',to_char(pl.ccs_date,'YYYY/MM/DD HH24:MI')))                   as ccs_check_date ,
decode( pl.run_no, null, '-', decode(pl.full_check_date,null,'WAIT','OK'))                                                                                                           as full_check,
decode( pl.run_no, null, '-', decode(pl.full_check_date,null,'Full Check!!',to_char(pl.full_check_date,'YYYY/MM/DD HH24:MI')))                                                       as full_check_date ,
decode( pl.run_no, null, '-', decode(pl.xray_check_date,null,'NG','OK'))                                                                                                             as xray_check,
decode( pl.run_no, null, '-', decode(pl.xray_check_date,null,'X-Ray Check!!',to_char(pl.xray_check_date,'YYYY/MM/DD HH24:MI')))                                                      as xray_check_date,

decode( pl.run_no, null, '-', decode(pl.sample_check_date,null,decode(pl.sample_check_date2,null,'NG','OK'),'OK'))                                                                   as sample_check,
decode( pl.run_no, null, '-', decode(pl.sample_check_date,null,decode(pl.sample_check_date2,null,'Master Check!!',pl.sample_lot_no2 ), to_char(pl.sample_check_date,'YYYY/MM/DD HH24:MI') )) as sample_check_date,

decode( pl.run_no, null, '-', decode(pl.spec_check_status,null,decode( sign(sysdate - (trunc(sysdate)+(12.5/24))),1,'NG',0,'NG','WAIT'),decode(pl.spec_check_status, 'P', 'OK', 'NG')))  as spec_check,
decode( pl.run_no, null, '-', decode(pl.spec_check_date,null,'Spec Check!!',to_char(pl.spec_check_date,'YYYY/MM/DD HH24:MI')))                                                           as spec_check_date ,


decode( pl.run_no, null, '-', decode(pl.fixture_lot_no,null,'NG','OK'))                                                              as jig_check_fixture,
decode( pl.run_no, null, '-', decode(pl.fixture_lot_no,null,'Jig Check!!',fixture_lot_no))                                           as jig_check_fixture_lot ,
       rc.qc_comments         as qc_comments ,
       pl.mask_lot_no ,      pl.mask_lot_no2 ,
       pl.squeeze_lot_no,
       pl.squeeze_lot_no2 ,
            F_GET_SPI_PASS_RATE_BY_RUNNO( pl.run_no ) SPI_PASS_RATE ,
       F_GET_AOI_PASS_RATE_BY_RUNNO( pl.run_no ) AOI_PASS_RATE ,

       F_GET_JIG_VALUE_QTY( PL.MASK_LOT_NO , 'BREAK' ) MASK_BREAK_VALUE ,
       F_GET_JIG_VALUE_QTY( PL.MASK_LOT_NO , 'HIT' ) MASK_HIT_VALUE ,
       F_GET_JIG_VALUE_QTY( PL.SQUEEZE_LOT_NO , 'BREAK' ) SQUEEZE_BREAK_VALUE ,
       F_GET_JIG_VALUE_QTY( PL.SQUEEZE_LOT_NO , 'HIT' ) SQUEEZE_HIT_VALUE ,


       F_GET_JIG_VALUE_QTY( PL.MASK_LOT_NO2 , 'BREAK' ) MASK_BREAK_VALUE2 ,
       F_GET_JIG_VALUE_QTY( PL.MASK_LOT_NO2 , 'HIT' ) MASK_HIT_VALUE2 ,
       F_GET_JIG_VALUE_QTY( PL.SQUEEZE_LOT_NO2 , 'BREAK' ) SQUEEZE_BREAK_VALUE2 ,
       F_GET_JIG_VALUE_QTY( PL.SQUEEZE_LOT_NO2 , 'HIT' ) SQUEEZE_HIT_VALUE2 ,
           md.solder_type as solder_type ,
       md.customer_name as customer_name ,
       md.product_class as product_class ,
       md.customer_model_name as customer_model_name ,

       rc.pcb_item as pcb_item ,

       ( SELECT MIN( "IQ_MACHINE_INSPECT_DATA_MK"."DATESET") FROM IQ_MACHINE_INSPECT_DATA_MK WHERE RUN_NO = PL.RUN_NO ) FIRST_MARKING_DATE ,
       ( SELECT MAX( "IQ_MACHINE_INSPECT_DATA_MK"."DATESET") FROM IQ_MACHINE_INSPECT_DATA_MK WHERE RUN_NO = PL.RUN_NO ) LAST_MARKING_DATE ,
       ( SELECT MIN( "IQ_MACHINE_INSPECT_DATA_SPI"."INSPECT_DATE") FROM IQ_MACHINE_INSPECT_DATA_SPI WHERE RUN_NO = PL.RUN_NO ) FIRST_SPI_DATE ,
       ( SELECT MIN( "IQ_MACHINE_INSPECT_DATA_AOI"."INSPECT_DATE") FROM IQ_MACHINE_INSPECT_DATA_AOI WHERE RUN_NO = PL.RUN_NO ) FIRST_AOI_DATE ,
       F_GET_MODEL_ST( pl.MODEL_NAME , pl.LINE_CODE , rc.PCB_ITEM , pl.ORGANIZATION_ID ) MODEL_ST ,

       -- 2026-10-17 생산실적(조립실적) 기준. 칼럼 이름은 화면 호환으로 유지
       ( SELECT  SUM(PRODUCT_ACTUAL_QTY) FROM  IP_ASSEMBLY_RESULT WHERE MFS = PL.RUN_NO AND ORGANIZATION_ID = PL.ORGANIZATION_ID ) AS SENSOR_COUNT,

      ( SELECT  COUNT(*) FROM  IQ_MACHINE_INSPECT_DATA_SPI WHERE RUN_NO = PL.RUN_NO ) AS SPI_COUNT,
      ( SELECT  COUNT(*) FROM  IQ_MACHINE_INSPECT_DATA_AOI WHERE RUN_NO = PL.RUN_NO AND NVL(RESULT, '*') not in ( 'MasterOK', 'MasterNG') )  AS AOI_COUNT,

       decode( pl.run_no, null, '-',
               decode( nvl(sd.viscosity_start_date, pl.solder_check_date), null,'Solder Check!!',
                       decode( sign(12/24 - ( sysdate - nvl(sd.viscosity_start_date, pl.solder_check_date) )), 1, SUBSTR( NUMTODSINTERVAL((12/24) - (sysdate - nvl(sd.viscosity_start_date, pl.solder_check_date) ),'DAY') , 12, 8 ),
                                                                                                                 '12H Over!!'
                             )
                     )
             )  as solder_remain_time,
       ( SELECT NVL(SUM( lot_qty),0) FROM IP_PRODUCT_PCB_SCAN_MASTER WHERE RUN_NO = pl.run_no ) pcb_input_qty,

       decode( pl.run_no, null, '-', decode(pl.nozzle_check_status,'P', 'OK', 'NG'))                                                         as nozzle_check,
       decode( pl.run_no, null, '-', decode(pl.nozzle_check_date,null,'Nozzle Check!!',to_char(pl.nozzle_check_date,'YYYY/MM/DD HH24:MI')))  as nozzle_check_date,

       decode( pl.run_no, null, '-', decode(pl.backupblock_check_date,null, 'WAIT', 'OK'))                                                                  as backupblock_check,
       decode( pl.run_no, null, '-', decode(pl.backupblock_check_date,null,'BackupBlock Check!!',to_char(pl.backupblock_check_date,'YYYY/MM/DD HH24:MI')))  as backupblock_check_date


  from ip_product_line     pl,
       ip_product_run_card rc ,
       ip_product_model_master md,
       im_item_solder_master   sd
  where pl.mes_display_yn = 'Y'
    and pl.organization_id= rc.organization_id(+)
    and pl.run_no         = rc.run_no(+)
    and pl.model_name     = md.model_name(+)
    and pl.solder_lot_no  = sd.item_barcode(+)
  order by pl.mes_display_sequence
/
