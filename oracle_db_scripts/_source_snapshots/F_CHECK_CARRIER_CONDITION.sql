FUNCTION F_CHECK_CARRIER_CONDITION 
(
  P_MASTER_PID IN VARCHAR2 
, P_PID IN VARCHAR2 
, P_CARRIER_SIZE IN NUMBER 
) RETURN NUMBER AS 

p_master_min_serial varchar2(10) ;
p_master_max_serial varchar2(10) ;
p_serial varchar2(10) ;

BEGIN

   p_master_min_serial :=  SUBSTR(P_MASTER_PID,9,3) ;
   p_master_max_serial :=  LPAD( TO_CHAR( TO_NUMBER( SUBSTR(P_MASTER_PID,9,3) , 'XXX') + (P_CARRIER_SIZE-1) , 'fmXXX') , 3,0)  ; 
    
   p_serial :=  SUBSTR(P_PID , 9,3) ;
   
   if p_serial >= p_master_min_serial and p_serial <= p_master_max_serial then 
       return 1 ; -- 'OK '||p_master_min_serial||' '||p_serial||' '||p_master_max_serial ;
   else
       return -1 ; --'NG '||p_master_min_serial||' '||p_serial||' '||p_master_max_serial ;
   end if ;
 --  LPAD( TO_CHAR(p_master_serial + ( P_CARRIER_SIZE -1 ) , 'fmXXX')  , 3 , 0 )
   


  RETURN NULL;
END F_CHECK_CARRIER_CONDITION;