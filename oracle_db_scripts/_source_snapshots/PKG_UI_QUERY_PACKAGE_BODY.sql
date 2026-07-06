PACKAGE BODY "PKG_UI_QUERY" is

FUNCTION FN_LOSS_RATE RETURN T_LOSS_RATE_T PIPELINED IS
 R_TBL T_LOSS_RATE_R;
 R_CNT NUMBER := 0 ;  --RECORD COUNT

 R_LINE VARCHAR2(20) := null ;
BEGIN
   FOR C01 IN (

                          SELECT LINE_CODE,
                                 NVL(MACHINE_CODE,LINE_CODE||' LINE_TTL') MACHINE_CODE,
                                 TRUNC(AVG(TACT_TIME),2) TACT_TIME,
                                 TRUNC(1 - (SUM(PICKERROR) + SUM(VISIONERROR)) / SUM(PICKUP),4) as RATE
                            FROM IQ_MACHINE_INSPECT_PICKUP T
                           GROUP BY ROLLUP (LINE_CODE, MACHINE_CODE)
                           HAVING LINE_CODE IS NOT NULL

                 )
   LOOP


     IF NVL(R_LINE,'X') <> C01.LINE_CODE THEN
       IF R_LINE <> 'X' THEN
         PIPE ROW (R_TBL);

         R_TBL.LINE_CODE := NULL ;
         R_TBL.VAL_M1:= NULL ;
         R_TBL.VAL_M2:= NULL ;
         R_TBL.VAL_M3 := NULL ;
         R_TBL.VAL_M4 := NULL ;
         R_TBL.VAL_M5 := NULL ;
         R_TBL.VAL_M6 := NULL ;
         R_TBL.VAL_TTL := NULL ;
         R_TBL.RATE_M1 := NULL ;
         R_TBL.RATE_M2 := NULL ;
         R_TBL.RATE_M3 := NULL ;
         R_TBL.RATE_M4 := NULL ;
         R_TBL.RATE_M5 := NULL ;
         R_TBL.RATE_M6 := NULL ;
         R_TBL.RATE_TTL := NULL ;

       END IF ;
       --?????????
       R_LINE := C01.LINE_CODE ;
     END IF ;


     IF C01.MACHINE_CODE = 'M1' THEN
        R_TBL.LINE_CODE := C01.LINE_CODE ;
        R_TBL.VAL_M1    := C01.TACT_TIME ;
        R_TBL.RATE_M1   := C01.RATE      ;
     ELSIF C01.MACHINE_CODE = 'M2' THEN
        R_TBL.LINE_CODE := C01.LINE_CODE ;
        R_TBL.VAL_M2    := C01.TACT_TIME ;
        R_TBL.RATE_M2   := C01.RATE      ;
     ELSIF C01.MACHINE_CODE = 'M3' THEN
        R_TBL.LINE_CODE := C01.LINE_CODE ;
        R_TBL.VAL_M3    := C01.TACT_TIME ;
        R_TBL.RATE_M3   := C01.RATE      ;
     ELSIF C01.MACHINE_CODE = 'M4' THEN
        R_TBL.LINE_CODE := C01.LINE_CODE ;
        R_TBL.VAL_M4    := C01.TACT_TIME ;
        R_TBL.RATE_M4   := C01.RATE      ;
     ELSIF C01.MACHINE_CODE = 'M5' THEN
        R_TBL.LINE_CODE := C01.LINE_CODE ;
        R_TBL.VAL_M5    := C01.TACT_TIME ;
        R_TBL.RATE_M5   := C01.RATE      ;
     ELSIF C01.MACHINE_CODE = 'M6' THEN
        R_TBL.LINE_CODE := C01.LINE_CODE ;
        R_TBL.VAL_M6    := C01.TACT_TIME ;
        R_TBL.RATE_M6   := C01.RATE      ;
     ELSE
        R_TBL.LINE_CODE := C01.LINE_CODE  ;
        R_TBL.VAL_TTL    := C01.TACT_TIME ;
        R_TBL.RATE_TTL   := C01.RATE      ;
     END IF ;


   END LOOP ;

   PIPE ROW (R_TBL);

   RETURN ;
EXCEPTION
   WHEN OTHERS THEN

           raise_application_error(-20001,sqlerrm);
END ;

end PKG_UI_QUERY;