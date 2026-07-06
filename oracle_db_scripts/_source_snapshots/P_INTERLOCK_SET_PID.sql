PROCEDURE "P_INTERLOCK_SET_PID" (
   p_line_code         IN     VARCHAR2,
   p_workstage_code    IN     VARCHAR2,
   p_machine_code      IN     VARCHAR2,
   p_serial_no         IN     VARCHAR2,
   p_carrier_barcode   IN     VARCHAR2,
   p_item_code         IN     VARCHAR2,
   p_run_no            IN     VARCHAR2,
   p_out                  OUT VARCHAR2)
IS
   lvs_model_name            VARCHAR2 (30);
   lvl_lot_qty               NUMBER;
   lvdt_run_date             DATE;
   lvi_org                   NUMBER;
   LVI_CARRIER_SIZE          NUMBER;
   lvs_customer_model_name   VARCHAR2 (30);
   lvs_part_no               VARCHAR2 (30);
   lvs_ec_no                 VARCHAR2 (30);
   lvs_parent_item_code      varchar2 (30) ;
   lvi_sel_count             NUMBER;
   
BEGIN

   -----------------------------------------------------------------------------------
   -- Run Card check
   -----------------------------------------------------------------------------------
   
   BEGIN
      SELECT model_name, parent_item_code ,
             lot_size,
             run_date,
             organization_id
        INTO lvs_model_name, lvs_parent_item_code ,
             lvl_lot_qty,
             lvdt_run_date,
             lvi_org
        FROM ip_product_run_card
       WHERE run_no = p_run_no;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         p_out := f_msg('런카드없음','C',1);
         raise_application_error (-20003, 'RUN CARD NOT FOUND');
   END;


   -----------------------------------------------------------------------------------
   -- Model Master check
   -----------------------------------------------------------------------------------
   
   BEGIN
      SELECT MAX (customer_model_name),
             MAX (part_no),
             MAX (ec_no),
             MAX (CARRIER_SIZE)
        INTO lvs_customer_model_name,
             lvs_part_no,
             lvs_ec_no,
             LVI_CARRIER_SIZE
        FROM ip_product_model_master
       WHERE model_name = lvs_model_name;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         p_out := f_msg('모델정보 없음','C',1);
         raise_application_error (-20003,
                                  lvs_model_name || ' MODEL NOT FOUND');
   END;

   -----------------------------------------------------------------------------------
   -- 2016/010/19 SHS, 연배열 mapping 이력 생성
   -----------------------------------------------------------------------------------

   BEGIN
     
      SELECT NVL(SUM(1),0)
        INTO lvi_sel_count
        FROM IP_PRODUCT_2D_BARCODE
       WHERE SERIAL_NO       = p_serial_no 
         AND ORGANIZATION_ID = lvi_org;    

     IF (lvi_sel_count > 0) THEN               -- 중복발생
       
         IF ( p_carrier_barcode = 'Y') THEN    -- Laser Marking 이력에서 Carrier barcode가 Y로 올라옴
         
              IF ( LVI_CARRIER_SIZE > 9 ) THEN -- Carrier size check
              
                 UPDATE IP_PRODUCT_LASER_MARKING
                    SET carrier_barcode = p_serial_no
                  WHERE serial_no like substr(p_serial_no, 1, length(p_serial_no)-2)||'%'
                    AND ORGANIZATION_ID = lvi_org;     
              
              ELSE
              
                 UPDATE IP_PRODUCT_LASER_MARKING
                    SET carrier_barcode = p_serial_no
                  WHERE serial_no like substr(p_serial_no, 1, length(p_serial_no)-1)||'%'
                    AND ORGANIZATION_ID = lvi_org;     

              END IF;
              
         ELSE   
             
           NULL;     
         
         END IF;  
     
     ELSE
                         
       INSERT INTO IP_PRODUCT_LASER_MARKING (
                                             serial_no,
                                             carrier_barcode,
                                             carrier_size,                                        
                                             organization_id,
                                             enter_date,
                                             enter_by,
                                             last_modify_date,
                                             last_modify_by
                                            )
       VALUES (
               p_serial_no,
               DECODE(LVI_CARRIER_SIZE, 1, p_serial_no, NULL),  -- 1연배는 본인이 대표바코드가 됨
               LVI_CARRIER_SIZE,            
               lvi_org,
               SYSDATE,
               'SYSTEM',
               SYSDATE,
               'SYSTEM'
              );                                     
       
       IF ( LVI_CARRIER_SIZE = 2 ) THEN  -- 2연배 경우 대표바코드를 설정 하지 않아 강제로 처리

            UPDATE IP_PRODUCT_LASER_MARKING
               SET carrier_barcode = substr(p_serial_no, 1, length(p_serial_no)-1)||'1'  -- 2연밴는 끝자리가 1번이 대표바코드로 지정 됨
             WHERE serial_no like substr(p_serial_no, 1, length(p_serial_no)-1)||'%'
               AND ORGANIZATION_ID = lvi_org;  
       
       END IF;         
              
     END IF;
     
   EXCEPTION
     
     WHEN OTHERS THEN
          NULL;
       
   END;  

   -----------------------------------------------------------------------------------
   -- 바코드 발행이력 생성
   -----------------------------------------------------------------------------------
   
   IF ( p_carrier_barcode  = 'Y') THEN  
        NULL;
   ELSE
       
       INSERT INTO ip_product_2d_barcode (
                                         line_code,
                                         workstage_code,
                                         machine_code,
                                         serial_no,
                                         carrier_barcode,
                                         label_text,
                                         item_code,
                                         model_name,
                                         run_no,
                                         run_date,
                                         lot_qty,
                                         organization_id,
                                         enter_date,
                                         enter_by,
                                         last_modify_date,
                                         last_modify_by,
                                         carrier_size,
                                         customer_model_name,
                                         part_no,
                                         ec_no,
                                         comments 
                                        )
      VALUES (
              p_line_code,
              p_workstage_code,
              p_machine_code,
              p_serial_no,
              p_carrier_barcode,
              p_serial_no,
              p_item_code,
              lvs_model_name,
              p_run_no,
              lvdt_run_date,
              lvl_lot_qty,
              lvi_org,
              SYSDATE,
              'SYSTEM',
              SYSDATE,
              'SYSTEM',
              NVL (LVI_CARRIER_SIZE, 1),
              lvs_customer_model_name,
              lvs_part_no,
              lvs_ec_no ,
              'RUN CARD PARENT='||lvs_parent_item_code||' ITEM CODE PARAM='||p_item_code
              );

   END IF;
    
   p_out := 'OK';
   COMMIT;
   
   RETURN;
   
EXCEPTION
  
   WHEN OTHERS
   THEN
     
        p_out := substr(SQLERRM,1,100);
        raise_application_error (-20005, 'RUN NO: '||p_run_no||', '||'PID: '||p_serial_no || '마킹이력 저장시 이상 >> ' ||p_out);
   
        RETURN;
      
END;