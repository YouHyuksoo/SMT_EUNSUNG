TRIGGER TIGIQ_MACHINE_INS_DATA_SP_INS
 BEFORE INSERT ON IQ_MACHINE_INSPECT_DATA_SP
 REFERENCING OLD AS OLD NEW AS NEW
 FOR EACH ROW
DECLARE

   LVI_COUNT             NUMBER ;
   LVS_RUN_NO            VARCHAR2(30) ;
   
   lvs_last_jig_lot_no   VARCHAR2(50) ;
   lvl_sequeeze_count    NUMBER ;
    
BEGIN
           
      BEGIN
         
          SELECT RUN_NO
            INTO :NEW.RUN_NO
            FROM IP_PRODUCT_2D_BARCODE
           WHERE serial_no       = :NEW.PID
             AND ORGANIZATION_ID = :NEW.ORGANIZATION_ID;     
          
       EXCEPTION 
             WHEN NO_DATA_FOUND THEN 
             
                  :NEW.RUN_NO := 'NULL';
       END;
           

      IF ( :NEW.RUN_NO = 'NULL' OR :NEW.RUN_NO = ''  OR :NEW.RUN_NO IS NULL ) THEN
            BEGIN
                    SELECT NVL(RUN_NO , '*')
                    INTO :NEW.RUN_NO
                    FROM IP_PRODUCT_LINE
                   WHERE LINE_CODE       = :NEW.LINE_CODE
                     AND ORGANIZATION_ID = :NEW.ORGANIZATION_ID;   
                     
             EXCEPTION 
             WHEN NO_DATA_FOUND THEN 
                          :NEW.RUN_NO := 'NULL';
             END;
      
      END IF;
  
    :new.pid    := nvl(:new.pid, 'NULL') ;
                             
    :NEW.EQUIPMENTID := NVL(:NEW.EQUIPMENTID , '*') ;                         
    :NEW.SEQ_NO := NVL(:NEW.SEQ_NO , '00' ) ;                                      
 
    ------------------------------------------------------------
    -- 최종데이타만 남도록 삭제
    ------------------------------------------------------------

 --   DELETE IQ_MACHINE_INSPECT_DATA_SP
 --    WHERE PID             = :NEW.PID
 --      AND ORGANIZATION_ID = :NEW.ORGANIZATION_ID; 
 --      
 --   DELETE IQ_MACHINE_INSPECT_DATA_SP
 --    WHERE PID             = 'NULL' ;    
 
    ------------------------------------------------------------
    -- 메탈마스크, 스퀴즈 사용횟수 반영
    ------------------------------------------------------------                             

    if ( (:new.line_code = '01') or (:new.line_code = '02') or (:new.line_code = '03') or (:new.line_code = '04') or (:new.line_code = '07') or (:new.line_code = '08') or (:new.line_code = '09') ) THEN             -- HIT : log 내 position 관련 정보가 있어 REAR 를 squeeze_lot_no2 로 본다
             
        if    ( :new.position = 'REAR SQUEEGEE' ) then
                               
              update imcn_jig 
                 set hit_value = nvl (hit_value, 0) + 1,
                     last_modify_date  = sysdate,
                     last_modify_by    = 'USED COUNT'
               where line_code         = :new.line_code
                 and jig_type          = 'M' ;
                    
              update imcn_jig
                 set hit_value = nvl(hit_value, 0) +1,
                     last_modify_date  = sysdate,
                     last_modify_by    = 'USED COUNT'
               where jig_lot_no        = (
                                            select squeeze_lot_no2
                                              from ip_product_line
                                             where line_code = :NEW.LINE_CODE           -- REAR
                                          ) ;
                                                            
        elsif ( :new.position = 'FRONT SQUEEGEE' ) then
            
              update imcn_jig 
                 set hit_value = nvl (hit_value, 0) + 1,
                     last_modify_date  = sysdate,
                     last_modify_by    = 'USED COUNT'
               where line_code         = :new.line_code
                 and jig_type          = 'M' ;
                         
              update imcn_jig
                 set hit_value = nvl(hit_value, 0) +1,
                     last_modify_date  = sysdate,
                     last_modify_by    = 'USED COUNT'
                     where jig_lot_no  = (
                                          select squeeze_lot_no
                                            from ip_product_line
                                           where line_code = :NEW.LINE_CODE     -- FRONT
                                         ) ;   
  
        elsif ( :new.position = 'DOUBLE PRINTING' ) then
            
               update imcn_jig 
                  set hit_value = nvl (hit_value, 0) + 2,
                     last_modify_date  = sysdate,
                     last_modify_by    = 'USED COUNT'
                where line_code        = :new.line_code
                  and jig_type         = 'M' ;
                                       
               update imcn_jig 
                  set hit_value         = nvl (hit_value, 0) + 1,                        -- REAR, FRONT
                      last_modify_date  = sysdate,
                      last_modify_by    = 'USED COUNT'
                where line_code         = :new.line_code
                  and jig_type          = 'S' ;                                    
                                       
        else
          
                null;       
                  
        end if;
                               
    elsif ( (:new.line_code = '05') or (:new.line_code = '06') ) THEN          -- SJ InnoTech : Printing Direction 을 가지고 확인
        
        if ( :new.DOUBLE_PRINTING_OPTION = 'Not Use' ) then                            -- 단면사용
       
                update imcn_jig 
                   set hit_value = nvl (hit_value, 0) + 1,
                       last_modify_date  = sysdate,
                       last_modify_by    = 'USED COUNT'
                 where line_code         = :new.line_code
                   and jig_type          = 'M' ;
                                    
                if    ( :new.PRINTING_DIRECTION = 'Backward' ) then
                                        
                      update imcn_jig
                         set hit_value         = nvl(hit_value, 0) +1,
                             last_modify_date  = sysdate,
                             last_modify_by    = 'USED COUNT'
                       where jig_lot_no        = (
                                                    select squeeze_lot_no2
                                                      from ip_product_line
                                                     where line_code = :NEW.LINE_CODE           -- REAR
                                                  ) ;
                                                                    
                elsif ( :new.PRINTING_DIRECTION = 'Forward' ) then
                    
                      update imcn_jig
                         set hit_value         = nvl(hit_value, 0) +1,
                             last_modify_date  = sysdate,
                             last_modify_by    = 'USED COUNT'
                             where jig_lot_no  = (
                                                  select squeeze_lot_no
                                                    from ip_product_line
                                                   where line_code = :NEW.LINE_CODE     -- FRONT
                                                 ) ;   
                                                
                else
                  
                      null;       
                          
                end if;
                
        else                                                                           -- 양면사용

               update imcn_jig 
                  set hit_value = nvl (hit_value, 0) + 2,
                      last_modify_date  = sysdate,
                     last_modify_by    = 'USED COUNT'
                where line_code = :new.line_code
                  and jig_type  = 'M' ;
                                       
               update imcn_jig 
                  set hit_value = nvl (hit_value, 0) + 1,                               -- Backward, Forward
                      last_modify_date  = sysdate,
                      last_modify_by    = 'USED COUNT'
                where line_code = :new.line_code
                  and jig_type  = 'S' ;
                                                         
        end if;
           
    else
      
           update imcn_jig 
              set hit_value = nvl (hit_value, 0) + 1,
                  last_modify_date  = sysdate,
                  last_modify_by    = 'USED COUNT'
            where line_code = :new.line_code
              and jig_type  = 'M' ;
                                    
           update imcn_jig 
              set hit_value = nvl (hit_value, 0) + 1,
                  last_modify_date  = sysdate,
                  last_modify_by    = 'USED COUNT'
            where line_code = :new.line_code
              and jig_type  = 'S' ;
  
    end if;   
                                                                                     

     
    ------------------------------------------------------------
    -- 온습도관리에 내용추가
    ------------------------------------------------------------
    
 /*   BEGIN
      
        INSERT INTO icom_temperature_raw (
                                           organization_id,
                                           gather_date,
                                           gw_id,
                                           nodeid,
                                           lqi,
                                           child_cnt,
                                           nodetype,
                                           batt,
                                           room_temperature,
                                           humidity,
                                           dew_point,
                                           sd4
                                        ) 
              select  :NEW.ORGANIZATION_ID,
                      TO_DATE(:NEW.INSPECT_DATE, 'YYYY/MM/DD HH24:MI:SS'),
                      :NEW.machine_code||'_'||:NEW.line_code||'_'||'TEMP',  
                      :NEW.machine_code||'_'||:NEW.line_code||'_'||'TEMP',   
                      0,  
                      0,  
                      1,
                      100,
                      TO_NUMBER(:NEW.TEMPRATURE),
                      0,
                      0,
                      0
                 from dual;

    EXCEPTION
       WHEN OTHERS THEN
   
            NULL;
    END;*/
       

EXCEPTION
    WHEN OTHERS THEN
   
        raise_application_error (
                                 -20003, 
                                 'SP INS TRRIGER ERROR '
                                 || ' '
                                 || SQLERRM
                                 );
END;
