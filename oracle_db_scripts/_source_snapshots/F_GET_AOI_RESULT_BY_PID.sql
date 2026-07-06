FUNCTION "F_GET_AOI_RESULT_BY_PID" (
                                                        p_pid          IN VARCHAR2 ,
                                                        p_repair_date  in date
                                                     )
   RETURN VARCHAR2
IS

   lvs_result         varchar2(50);
   lvs_review         varchar2(50);
   lvs_inspect_date   varchar2(50);
   
BEGIN
---------------------------------------------------------------
-- AOI  최종 Result 확인
---------------------------------------------------------------

    if ( p_repair_date is null ) then
         RETURN NULL;
    end if;
    
    select RESULT, REVIEW_RESULT, inspect_date
      into lvs_result, lvs_review, lvs_inspect_date
      from iq_machine_inspect_data_aoi
     where pid = p_pid
       and inspect_date = (
                            select max(inspect_date)
                              from iq_machine_inspect_data_aoi
                             where pid = p_pid
                               and inspect_date >= to_char(p_repair_date, 'YYYY/MM/DD HH24:MI:ss')
                         );
                         
                         
  --  if ( lvs_result = 'OK' ) THEN
      
  --       RETURN lvs_result;      
         
  --  else
       
         if ( lvs_review is not null ) then
              return lvs_review; --||' : '||lvs_inspect_date; 
         else
              return lvs_result; --||' : '||lvs_inspect_date; 
         end if;
     
  --  end if;           
                      
                      

---------------------------------------------------------------
--
---------------------------------------------------------------

EXCEPTION
   WHEN OTHERS THEN
        RETURN NULL;
END;
