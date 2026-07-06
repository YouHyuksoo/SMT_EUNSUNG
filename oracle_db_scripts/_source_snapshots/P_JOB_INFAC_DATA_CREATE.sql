PROCEDURE P_JOB_INFAC_DATA_CREATE
IS

   lvl_count1     number default 0 ;
   lvl_count2     number default 0 ;
   lvs_message    varchar2(200);

BEGIN

-------------------------------------------------------------------
--  공정출고생성 
--  E2011000050 제외
-------------------------------------------------------------------

INSERT INTO im_item_workstage_issue (
            issue_date,
            issue_sequence,
            organization_id,
            item_code,
            issue_deficit,
            issue_qty,
            enter_date,
            enter_by,
            last_modify_date,
            last_modify_by
        ) 
 
  SELECT P.PACK_DATE AS issue_date ,
         SEQ_WORKSTAGE_ISSUE_SEQ.NEXTVAL AS issue_sequence ,
         P.ORGANIZATION_ID AS ORGANIZATION_ID ,
         B.CHILD_ITEM_CODE  AS item_code,
         '3' AS issue_deficit, 
         P.PACKING_PCS_QTY * B.ITEM_UNIT_QTY  AS issue_qty ,
         SYSDATE ,
         'ADMIN' ,
         SYSDATE ,
         PART_NO 
  FROM IP_PRODUCT_PACK_MASTER P , ID_ENG_BOM  B 
 WHERE P.PART_NO = B.ITEM_CODE
  -- AND P.RUN_NO IN ( SELECT RUN_NO FROM IP_PRODUCT_RUN_CARD WHERE RUN_DATE >= TO_DATE('20230701' , 'YYYYMMDD') )
   AND NVL(P.WIP_PROCESS_FLAG,'N') = 'N'
   AND B.ITEM_CODE IN ( SELECT ITEM_CODE FROM IP_PRODUCT_MODEL_MASTER WHERE CUSTOMER_CODE = 'IP' ) 
   AND B.CHILD_ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM WHERE SUPPLIER_CODE = 'IP' ) 
   AND P.MODEL_NAME NOT IN ( 'DANA-LPS-680pF') 
   AND P.PACK_DATE >=  TO_DATE('20230701' , 'YYYYMMDD') ;

  UPDATE IP_PRODUCT_PACK_MASTER 
     SET WIP_PROCESS_FLAG = 'Y' , WIP_PROCESS_DATE = SYSDATE
   WHERE NVL(WIP_PROCESS_FLAG,'N') = 'N' ;

-------------------------------------------------------------------
--  원자재 창고재고 생성 
-------------------------------------------------------------------
    INSERT INTO eseai_m107_temp (
                                dt_if,
                                cd_sl,
                                cd_item,
                                yn_process,
                                dc_errormsg,
                                qt_im,
                                dts_create,
                                transfer_date,
                                transfer_yn )
                         SELECT TO_CHAR(SYSDATE , 'YYYYMMDD') AS dt_if,
                                'ESEM' AS cd_sl ,
                                ITEM_CODE AS cd_item ,
                                NULL AS yn_process,
                                NULL AS dc_errormsg,
                                SUM( INVENTORY_QTY ) AS qt_im,
                                TO_CHAR(SYSDATE , 'HH24:MI:SS') AS dts_create ,
                                NULL AS transfer_date ,
                                'N' transfer_yn
                           FROM IM_ITEM_INVENTORY
                          WHERE ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM WHERE SUPPLIER_CODE = 'IP'  )
                          GROUP BY ITEM_CODE ;
       -------------------------------------------------------------------
       --  원자재 공정재고 생성 
       --
       -------------------------------------------------------------------
    INSERT INTO eseai_m107_temp (
                                dt_if,
                                cd_sl,
                                cd_item,
                                yn_process,
                                dc_errormsg,
                                qt_im,
                                dts_create,
                                transfer_date,
                                transfer_yn )
                         SELECT TO_CHAR(SYSDATE , 'YYYYMMDD') AS dt_if,
                                'ESEF' AS cd_sl ,
                                ITEM_CODE AS cd_item ,
                                NULL AS yn_process,
                                NULL AS dc_errormsg,
                                SUM( INVENTORY_QTY ) AS qt_im,
                                TO_CHAR(SYSDATE , 'HH24:MI:SS') AS dts_create ,
                                NULL AS transfer_date ,
                                'N' transfer_yn
                           FROM IM_ITEM_WORKSTAGE_INVENTORY
                          WHERE ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM WHERE SUPPLIER_CODE = 'IP'  )
                          GROUP BY ITEM_CODE ;
 
      -------------------------------------------------------------------
      --  제품 공정재고 생성 
      --  E2011000050  제외
      -------------------------------------------------------------------
    INSERT INTO eseai_m107_temp (
                                dt_if,
                                cd_sl,
                                cd_item,
                                yn_process,
                                dc_errormsg,
                                qt_im,
                                dts_create,
                                transfer_date,
                                transfer_yn
                                )
                                
                        SELECT  TO_CHAR(SYSDATE , 'YYYYMMDD') AS dt_if,
                                'ESEG'  cd_sl,
                                cd_item,
                                NULL yn_process,
                                NULL dc_errormsg,
                                SUM(qt_im) qt_im,
                                TO_CHAR(SYSDATE , 'HH24:MI:SS') AS dts_create,
                                NULL transfer_date,
                                'N' transfer_yn
                            FROM 
                            (     
                                  SELECT 
                                        PART_NO AS cd_item ,
                                        SUM( PACKING_PCS_QTY ) AS qt_im
                                     
                                   FROM IP_PRODUCT_PACK_MASTER
                                  WHERE MODEL_NAME  IN ( SELECT MODEL_NAME FROM IP_PRODUCT_MODEL_MASTER WHERE CUSTOMER_CODE = 'IP'  )
                                    AND MODEL_NAME NOT IN ( 'DANA-LPS-680pF')
                                    AND RECEIPT_FLAG = 'N'
                                    AND PACKING_PCS_QTY > 0 
                                  GROUP BY PART_NO 
                                                          
                                     UNION ALL
                                     
                                 SELECT 
                                        ITEM_CODE AS cd_item ,
                                        SUM( QTY ) AS qt_im
                                   FROM IP_PRODUCT_FG_INVENTORY
                                  WHERE MODEL_NAME  IN ( SELECT MODEL_NAME FROM IP_PRODUCT_MODEL_MASTER WHERE CUSTOMER_CODE = 'IP'  )
                                    AND MODEL_NAME NOT IN ( 'DANA-LPS-680pF')
                                    AND NVL(QTY ,0) > 0 
                                  GROUP BY ITEM_CODE 
                                  )
                              WHERE CD_ITEM NOT IN ( 'E2011000050')    
                              GROUP BY  cd_item   ;
       -------------------------------------------------------------------
       -- insert log 생성
       -------------------------------------------------------------------

      lvs_message := 'INSERT => '||to_char(lvl_count1)||', UPDATE => '||to_char(lvl_count2);

      insert into isys_batchjoberrlog ( 
                                        batch_job_seq ,
                                        organization_id,
                                        batch_job_process_name,
                                        batch_job_object_name,
                                        batch_job_status_code,
                                        batch_job_remark,
                                        enter_by,
                                        log_date  
                                      )
                               values (
                                        null,
                                        1,
                                        'INFAC_DATA_CREATE',
                                        'P_JOB_INFAC_DATA_CREATE',
                                        'CREATE OK',
                                        lvs_message,
                                        'JOB',
                                        sysdate
                                      );

      COMMIT;


-------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------
EXCEPTION

 WHEN OTHERS THEN

      lvs_message := substr(SQLERRM, 1, 200);

      insert into isys_batchjoberrlog ( 
                                        batch_job_seq ,
                                        organization_id,
                                        batch_job_process_name,
                                        batch_job_object_name,
                                        batch_job_status_code,
                                        batch_job_remark,
                                        enter_by,
                                        log_date  
                                      )
                               values (
                                        null,
                                        1,
                                        'INFAC_DATA_CREATE',
                                        'P_JOB_INFAC_DATA_CREATE',
                                        'CREATE NG',
                                        lvs_message,
                                        'JOB',
                                        sysdate
                                      );

      commit;

END;