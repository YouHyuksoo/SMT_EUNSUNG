PROCEDURE "P_CHECK_FIXASSET_SCAN" ( p_location in varchar2 default '*' , p_type in varchar2 default '*'  , P_AssetCode varchar2,  p_qty in number default 1 , p_out out varchar2, p_msg out varchar2) is
   --PDA 고정자산 스캔 
   --PDA 2017.02.20 
   
   
LVI_COUNT NUMBER ;

begin
  
 
  if p_type = 'F' then 
  
  
    SELECT COUNT(*) INTO LVI_COUNT FROM IMCN_JIG WHERE JIG_LOT_NO = P_ASSETCODE 
      AND JIG_TYPE = 'F' ;
      
      
      IF LVI_COUNT > 0 THEN 
        NULL  ;
      ELSE
        
  
            INSERT INTO  IMCN_JIG
            (
            JIG_CODE,
            ORGANIZATION_ID,
            JIG_NAME,
            JIG_TYPE,
            CAPACITY,
            RESERVED_CAPACITY,
            ACQUISITION_DATE,
            ACQUISITION_TYPE,
            JIG_MODEL_NAME,
            LINE_CODE,
            CUSTOMER_CODE,
            USE_STATUS,
            MANUAL_LOCATION_COMMENT,
            NATION_CODE,
            WORKSTAGE_CODE,
            ENTER_BY,
            ENTER_DATE,
            LAST_MODIFY_BY,
            LAST_MODIFY_DATE,
            USE_RATE,
            UPH_VALUE,
            CAPACITY_UOM,
            SUPPLIER_CODE,
            JIG_STATUS,
            JIG_IMAGE,
            JIG_IMAGE_FILE_NAME,
            USE_TPM_YN,
            JIG_LOT_NO,
            MACHINE_CODE,
            BREAK_VALUE,
            HIT_VALUE,
            JIG_SPEC,
            ITEM_CODE,
            LOCATION_ADDRESS,
            SOLDER_TYPE,
            USE_NSNP_YN,
            MANAGEMENT_COMMNETS,
            RECEIPT_DATE,
            LAST_INSPECT_DATE,
            ISSUE_DATE,
            DESTROY_DATE,
            TENSION_CHECK_YN
          )
          VALUES
          (
            P_AssetCode , --JIG_CODE,
            1 , --ORGANIZATION_ID,
            P_AssetCode, --JIG_NAME,
            'F' , --JIG_TYPE,
            NULL , -- CAPACITY,
            NULL , --RESERVED_CAPACITY,
            SYSDATE , --ACQUISITION_DATE,
            'N'  , --ACQUISITION_TYPE,
            P_ASSETCODE  , --JIG_MODEL_NAME,
            P_LOCATION  , --LINE_CODE,
            '*'  , --CUSTOMER_CODE,
            'Y'  , --USE_STATUS,
            '*', --MANUAL_LOCATION_COMMENT,
            '*', --NATION_CODE,
            '*', --WORKSTAGE_CODE,
            'SYSTEM' , --ENTER_BY,
            SYSDATE , --ENTER_DATE,
            'SYSTEM' , --LAST_MODIFY_BY,
            SYSDATE , --LAST_MODIFY_DATE,
            100 , --USE_RATE,
            0 , --UPH_VALUE,
            NULL , --CAPACITY_UOM,
            '*' , --SUPPLIER_CODE,
            'N' , --JIG_STATUS,
            NULL , --JIG_IMAGE,
            NULL , --JIG_IMAGE_FILE_NAME,
            'Y' , --USE_TPM_YN,
            P_ASSETCODE , --JIG_LOT_NO,
            '*' , --MACHINE_CODE,
            0 , --BREAK_VALUE,
            0 , --HIT_VALUE,
            '*' , --JIG_SPEC,
            '*' , --ITEM_CODE,
            P_LOCATION , --LOCATION_ADDRESS,
            NULL , --SOLDER_TYPE,
            'N' , --USE_NSNP_YN,
            NULL , --MANAGEMENT_COMMNETS,
            NULL , --RECEIPT_DATE,
            NULL , --LAST_INSPECT_DATE,
            NULL , --ISSUE_DATE,
            NULL , --DESTROY_DATE,
            'N'  --TENSION_CHECK_YN
          );
  END IF ;
  
  commit ;
  end if ;
  
  
   p_out := 'OK';
   p_msg := P_AssetCode||chr(10)||'P_CHECK_FIXASSET_SCAN'  ; 
  
end P_CHECK_FIXASSET_SCAN;