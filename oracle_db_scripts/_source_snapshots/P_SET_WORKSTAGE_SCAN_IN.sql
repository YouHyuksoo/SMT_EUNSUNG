procedure P_SET_WORKSTAGE_SCAN_IN(
                                                    P_SERIAL    IN VARCHAR2, 
                                                    P_LINE      IN VARCHAR2, 
                                                    P_WORKSTAGE IN VARCHAR2, 
                                                    P_ORGID     IN NUMBER, 
                                                    P_TYPE      IN VARCHAR2, 
                                                    P_OUT       OUT VARCHAR2, 
                                                    P_MSG       OUT VARCHAR2 ) is

 /*****************************************************************
  * 공정 스캔 
  * 바코드 마스터는 IP_PRODUCT_2D_BARCODE 
  * TXN TABLE 은 IP_PRODUCT_WORKSTAGE_IO 
  * P_IO_TYPE 'I' 입력 'C' 취소 해당 공정 취소 2018.05.13
  ******************************************************************/
  LVS_ITEMCODE       VARCHAR2(30);
  LVS_MODEL          VARCHAR2(30);
  LVS_SUFFIX         VARCHAR2(30);
  LVS_BARCODE_STATUS VARCHAR2(5);
  LVS_WORKSTAGE_TYPE VARCHAR2(20); 
  
  LVS_REPAIR_MSG     VARCHAR2(100);
  
  --취소 
  LVI_COUNT               NUMBER ; 
  LVS_DEST_LINE_CODE      VARCHAR2(10);
  LVS_DEST_WORKSTAGE_CODE VARCHAR2(10); 
  LVI_WIP_SEQ             NUMBER;
  LVI_LAST_WIP_SEQ        NUMBER ; 
 
begin
  /******************************
	 * 1.  모델명 조회 
	 ******************************/
   BEGIN 
     
     SELECT ITEM_CODE,    MODEL_NAME, NVL(MODEL_SUFFIX,'*'), BARCODE_STATUS 
       INTO LVS_ITEMCODE, LVS_MODEL,  LVS_SUFFIX,            LVS_BARCODE_STATUS 
       FROM IP_PRODUCT_2D_BARCODE 
      WHERE SERIAL_NO       = P_SERIAL 
        AND ORGANIZATION_ID = P_ORGID ; 
        
   EXCEPTION 
     WHEN NO_DATA_FOUND THEN 
          P_OUT := 'NG' ; 
          P_MSG := '잘못된 바코드 정보 입니다' ; 
          RETURN ;
     WHEN OTHERS THEN 
          P_OUT := 'NG' ; 
          P_MSG := '1.바코드 확인 '||substr(sqlerrm,1,100) ; 
          RETURN ; 
	 END ; 	
   
   /******************************
	 * 2.  수리실에 존재 하는지 체크 
	 ******************************/
   LVS_REPAIR_MSG := F_CHECK_PID_STATUS_4_WS(P_SERIAL) ; 
   
   IF LVS_REPAIR_MSG <> 'OK' THEN 
      P_OUT := 'NG';
      P_MSG := '2.수리실에 존재하는 PID 입니다.';
      RETURN;
   END IF ; 
   
   /******************************
	 * 2-1.  공정 TYPE  
	 ******************************/
   BEGIN 
     
     SELECT WORKSTAGE_TYPE
       INTO LVS_WORKSTAGE_TYPE 
       FROM IP_PRODUCT_WORKSTAGE X
      WHERE ORGANIZATION_ID = P_ORGID
        AND WORKSTAGE_CODE  = P_WORKSTAGE ; 
        
   EXCEPTION 
     WHEN NO_DATA_FOUND THEN 
          P_OUT := 'NG'; 
          P_MSG := '존재하지 않는 공정 입니다.';
          RETURN ; 
     WHEN OTHERS THEN 
          P_OUT := 'NG'; 
          P_MSG := '3.공정 검사 오류 '||SUBSTR(SQLERRM,1,100);
          RETURN ; 
   END ; 
   
   /******************************
	 * 1.  실적발행 여부확인
	 ******************************/
   BEGIN 
     
     SELECT COUNT(*)
       INTO LVI_COUNT
       FROM IP_PRODUCT_WORKSTAGE_IO 
      WHERE line_code      = P_LINE 
			  AND workstage_code = P_WORKSTAGE
			  AND SERIAL_NO      = P_SERIAL ; 
        
   EXCEPTION 
     WHEN OTHERS THEN 
          P_OUT := 'NG' ; 
          P_MSG := '1.바코드 확인 '||substr(sqlerrm,1,100) ; 
          RETURN ; 
	 END ; 
   
   IF LVI_COUNT > 0 THEN
     
       P_OUT := 'NG' ; 
       P_MSG := '1.이미 실적발행' ; 
       RETURN ;
       
   END IF;	
   
   
  /******************************
	 * 3. 취소 할것 
	 ******************************/
   IF P_TYPE = 'C' THEN 
     
     /*****************************
     * 6. 취소스캔  대상 확인 
     ******************************/
     SELECT COUNT(*)  , MAX( DEST_LINE_CODE ) , MAX(DEST_WORKSTAGE_CODE) , MAX(WIP_SEQ)
		   INTO LVI_COUNT , LVS_DEST_LINE_CODE ,    LVS_DEST_WORKSTAGE_CODE,   LVI_WIP_SEQ
			 FROM IP_PRODUCT_WORKSTAGE_IO 
			WHERE line_code      = P_LINE 
			  AND workstage_code = P_WORKSTAGE
			  AND SERIAL_NO      = P_SERIAL  
			  AND io_deficit     = 'I' ;  --현재 있는공정만 가능 함 
							 
			IF LVI_COUNT = 0 THEN 
        
        /************************
        * 취소대상이 없음 
        *************************/
        P_OUT := 'NG'; 
        P_MSG := '5.취소대상이 존재 하지 않습니다.'; 
        RETURN ; 
        
      ELSE
        
        BEGIN 	
          
 /*     
   	
            \*********************
            * 취소대상 존재 
            ***********************\
            SELECT nvl(max(wip_seq),0)
              INTO LVI_LAST_WIP_SEQ 
              FROM IP_PRODUCT_WORKSTAGE_IO
             WHERE serial_no = P_SERIAL 
               AND wip_seq   < LVI_WIP_SEQ ; 
  												 
            \*취소할 공정 앞공정 처리 데이터 원복 작업 진행*\
            BEGIN 
              
              UPDATE IP_PRODUCT_WORKSTAGE_IO 
                 SET IO_DEFICIT           = 'I' , 
                     OUT_DATE             = NULL, 
                     DEST_LINE_CODE       = NULL, 
                     DEST_WORKSTAGE_CODE  = NULL
               WHERE  SERIAL_NO           = P_SERIAL 
                 AND  DEST_LINE_CODE      = P_LINE
                 AND  DEST_WORKSTAGE_CODE = P_WORKSTAGE
                 AND  IO_DEFICIT          = 'O' 
                 AND  WIP_SEQ             = LVI_LAST_WIP_SEQ ;	
                 
            EXCEPTION 
              WHEN NO_DATA_FOUND THEN 
                   NULL; 
            END ; 						 
 */ 		
 				
           /*현공정의 데이터 삭제*/
           DELETE FROM IP_PRODUCT_WORKSTAGE_IO
            WHERE line_code      = P_LINE
              AND workstage_code = P_WORKSTAGE 
              AND SERIAL_NO      = P_SERIAL
              AND io_deficit     = 'I' ;
          --    AND wip_seq        = LVI_WIP_SEQ ; 
        
        EXCEPTION 
          WHEN OTHERS THEN 
               P_OUT := 'NG'; 
               P_MSG := '6.취소작업오류'||SUBSTR(SQLERRM,1,100); 
               RETURN ; 
        END ; 
        
      END IF ; 
      
   ELSE 
     
    /*****************************
     * 5. 정상스캔  
     ******************************/
     BEGIN 
       
      INSERT INTO IP_PRODUCT_WORKSTAGE_IO  
            ( IO_DATE,   
              IO_SEQUENCE,   
              RUN_NO,   
              ITEM_CODE,   
              SERIAL_NO,   
              LINE_CODE,   
              WORKSTAGE_CODE,   
              IO_DEFICIT,   
              IO_QTY,   
              ORGANIZATION_ID,   
              ENTER_DATE,   
              ENTER_BY,   
              LAST_MODIFY_DATE,   
              LAST_MODIFY_BY ,
              MODEL_NAME ,
              MODEL_SUFFIX,
              WORKSTAGE_TYPE )  
      VALUES (SYSDATE,   
              SEQ_MAGAZINE_RECEIPT_SEQUENCE.NEXTVAL,   
              F_GET_RUN_NO_BY_PID(P_SERIAL) , --RUN_NO,   2D 바코드 마스터를 먼저 뒤지고 없으면 롯트라 판단해서 매거진 뒤짐 
              LVS_ITEMCODE,   
              P_SERIAL,                       --magazine label_no
              P_LINE,   
              P_WORKSTAGE,   
              'I' ,                           --IO_DEFICIT,   
              1   ,                           --IO_QTY, PID 이기에    
              P_ORGID,   
              SYSDATE ,                       --ENTER_DATE,   
              'PROC' ,                        --ENTER_BY,   
              SYSDATE,   
              'PROC' ,
              LVS_MODEL,
              LVS_SUFFIX,
              LVS_WORKSTAGE_TYPE
           )  ;
     EXCEPTION 
       WHEN OTHERS THEN 
            P_OUT := 'NG'; 
            P_MSG := '7.공정이동 작업오류'||SUBSTR(SQLERRM,1,100); 
            RETURN ; 
     END; 
     
  END IF ; 
  
  P_OUT := 'OK'; 
  P_MSG := 'SUCCESS'; 
  
EXCEPTION 
  WHEN OTHERS THEN 
       P_OUT := 'NG'; 
       P_MSG := '99.LAST OTHERS :'||SUBSTR(SQLERRM,1,100) ;   
end P_SET_WORKSTAGE_SCAN_IN;
