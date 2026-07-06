TRIGGER "INFINITY21_JSMES".TRGIQ_MACHINE_INSPECT_MASK_INS
 BEFORE INSERT ON IQ_MACHINE_INSPECT_DATA_MASK
 FOR EACH ROW
DECLARE

   LVL_COUNT            NUMBER;
   LVL_BREAK_VALE       NUMBER;
   LVL_HIT_VALUE        NUMBER;
   LVS_JIG_CHECK_STATUS VARCHAR2(10);
   PHASE                VARCHAR2(10);
   
BEGIN

   PHASE := '10';
   
   -- 타발후 확인
   BEGIN
      
      SELECT NVL(BREAK_VALUE,0), NVL(HIT_VALUE,0)
        INTO LVL_BREAK_VALE, LVL_HIT_VALUE  
        FROM IMCN_JIG
       WHERE JIG_TYPE   = 'M'     
         AND JIG_LOT_NO = :NEW.C3;
                  
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
           LVL_BREAK_VALE := 0;
           LVL_HIT_VALUE := 0;
   END;
   
   PHASE := '20';
   
   -- 텐션 측정결과 확인  
   IF :NEW.C2 = 'Accept' THEN  
      LVS_JIG_CHECK_STATUS := 'P';    
   ELSE
      LVS_JIG_CHECK_STATUS := 'N';
   END IF;
   
   PHASE := '30';
   
   -- 지그마스타에 텐션 측정결과 저장
   IF LVS_JIG_CHECK_STATUS = 'N' OR LVL_BREAK_VALE <= LVL_HIT_VALUE THEN

    -- 사용중지 
    UPDATE IMCN_JIG 
       SET USE_STATUS = 'S' , 
           LAST_INSPECT_DATE = SYSDATE ,  
           LINE_CODE = '*' ,  
           TENSION_CHECK_YN = 'Y'
     WHERE JIG_TYPE   = 'M'     
       AND JIG_LOT_NO = :NEW.C3;  
   
   ELSE 
   
    -- 라인 코드는 회수 되었으므로 * 로 초기화 
    UPDATE IMCN_JIG 
       SET USE_STATUS = 'U',  
           LAST_INSPECT_DATE = SYSDATE ,
           LINE_CODE = '*' , 
           TENSION_CHECK_YN = 'Y'
     WHERE JIG_TYPE   = 'M'     
       AND JIG_LOT_NO = :NEW.C3;
             
    END IF;
   
   PHASE := '40';
   
   -- 결과값 등록
   INSERT INTO IMCN_JIG_MASK_CHECK (
                                    JIG_CODE, 
                                    JIG_LOT_NO, 
                                    ORGANIZATION_ID, 
                                    JIG_CHECK_SEQUENCE, 
                                    JIG_CHECK_DATE, 
                                    JIG_CHECK_STATUS,
                                    CLEAN_YN, 
                                    TENSION_CHECK1, 
                                    TENSION_CHECK2, 
                                    TENSION_CHECK3, 
                                    TENSION_CHECK4, 
                                    TENSION_CHECK5, 
                                    ENTER_BY, 
                                    ENTER_DATE, 
                                    LAST_MODIFY_BY, 
                                    LAST_MODIFY_DATE, 
                                    BREAK_VALUE, 
                                    HIT_VALUE
                                   )
                            VALUES (
                                    :NEW.C3, 
                                    :NEW.C3, 
                                    1, 
                                    SEQ_JIG_CHECK_SEQUENCE.NEXTVAL, 
                                    TO_DATE(SUBSTR(:NEW.C1,1,14),'YYYYMMDDHH24MISS'), 
                                    LVS_JIG_CHECK_STATUS, 
                                    'Y', 
                                    TO_NUMBER(:NEW.C4), 
                                    TO_NUMBER(:NEW.C5), 
                                    TO_NUMBER(:NEW.C6), 
                                    TO_NUMBER(:NEW.C7), 
                                    TO_NUMBER(:NEW.C9), 
                                    'TRIGGER', 
                                    SYSDATE,
                                    'TRIGGER', 
                                    SYSDATE, 
                                    LVL_BREAK_VALE, 
                                    LVL_HIT_VALUE);
                                  
EXCEPTION
   WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR (-20003, 'PHASE='
                                         || PHASE
                                         || ' '
                                         || SQLERRM);
END;
