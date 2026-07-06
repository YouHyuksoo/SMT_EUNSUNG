FUNCTION "F_GET_REFLOW_STATUS" (  p_gubun          IN VARCHAR2,
                                                p_line_code      IN VARCHAR2,
                                                p_org            IN NUMBER   )
    RETURN NUMBER
IS

     lvs_top_set1    VARCHAR2(10);
     lvs_top_value1  VARCHAR2(10);
     lvs_bot_set1    VARCHAR2(10);
     lvs_bot_value1  VARCHAR2(10);
     lvs_top_set2    VARCHAR2(10);
     lvs_top_value2  VARCHAR2(10);
     lvs_bot_set2    VARCHAR2(10);
     lvs_bot_value2  VARCHAR2(10);
     lvs_top_set3    VARCHAR2(10);
     lvs_top_value3  VARCHAR2(10);
     lvs_bot_set3    VARCHAR2(10);
     lvs_bot_value3  VARCHAR2(10);
     lvs_top_set4    VARCHAR2(10);
     lvs_top_value4  VARCHAR2(10);
     lvs_bot_set4    VARCHAR2(10);
     lvs_bot_value4  VARCHAR2(10);
     lvs_top_set5    VARCHAR2(10);
     lvs_top_value5  VARCHAR2(10);
     lvs_bot_set5    VARCHAR2(10);
     lvs_bot_value5  VARCHAR2(10);
     lvs_top_set6    VARCHAR2(10);
     lvs_top_value6  VARCHAR2(10);
     lvs_bot_set6    VARCHAR2(10);
     lvs_bot_value6  VARCHAR2(10);
     lvs_top_set7    VARCHAR2(10);
     lvs_top_value7  VARCHAR2(10);
     lvs_bot_set7    VARCHAR2(10);
     lvs_bot_value7  VARCHAR2(10);
     lvs_top_set8    VARCHAR2(10);
     lvs_top_value8  VARCHAR2(10);
     lvs_bot_set8    VARCHAR2(10);
     lvs_bot_value8  VARCHAR2(10);
     lvs_top_set9    VARCHAR2(10);
     lvs_top_value9  VARCHAR2(10);
     lvs_bot_set9    VARCHAR2(10);
     lvs_bot_value9  VARCHAR2(10);
     lvs_top_set10   VARCHAR2(10);
     lvs_top_value10 VARCHAR2(10);
     lvs_bot_set10   VARCHAR2(10);
     lvs_bot_value10 VARCHAR2(10);

     lvl_std    NUMBER;
     lvl_air    NUMBER;
     lvl_return NUMBER;

BEGIN
    ---------------------------------------------------------
    -- p_gubun : S(기준값)
    --           A(AIR)
    --           R(결과)
    --           T(온도)
    ---------------------------------------------------------

    IF p_gubun = 'S' THEN      --기준값

       lvl_return := 1000;

    ELSIF p_gubun = 'A' THEN  --AIR값

      BEGIN
        SELECT AIR
          INTO lvl_return
          FROM IQ_INTERLOCK_REFLOW_DATA
         WHERE LINE_CODE         = p_line_code
           AND ORGANIZATION_ID  = p_org
           AND ENTER_DATE IN (SELECT MAX(ENTER_DATE)
                                 FROM IQ_INTERLOCK_REFLOW_DATA
                                WHERE LINE_CODE         = p_line_code
                                  AND ORGANIZATION_ID  = p_org
                                  AND ENTER_DATE        >= TO_DATE(SYSDATE,'YYYY-MM-DD'));

      EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                 lvl_return := 0;
      END;


    ELSIF p_gubun = 'R' THEN  --결과

       BEGIN
        SELECT AIR
          INTO lvl_air
          FROM IQ_INTERLOCK_REFLOW_DATA
         WHERE LINE_CODE        = p_line_code
           AND ORGANIZATION_ID  = p_org
           AND ENTER_DATE IN (SELECT MAX(ENTER_DATE)
                                 FROM IQ_INTERLOCK_REFLOW_DATA
                                WHERE LINE_CODE         = p_line_code
                                  AND ORGANIZATION_ID  = p_org
                                  AND ENTER_DATE        >= TO_DATE(SYSDATE,'YYYY-MM-DD'));

       EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                 lvl_air := 0;
       END;

       lvl_std := 1000;

       IF lvl_air <= 0 OR lvl_air > lvl_std THEN
          lvl_return := 0;  --NG
       ELSE
          lvl_return := 1;  --OK
       END IF;

    ELSIF p_gubun = 'T' THEN  --TEMPERATURE값

      BEGIN
        SELECT  top_set1  ,
               top_value1,
               bot_set1  ,
               bot_value1,
               top_set2  ,
               top_value2,
               bot_set2  ,
               bot_value2,
               top_set3  ,
               top_value3,
               bot_set3  ,
               bot_value3,
               top_set4  ,
               top_value4,
               bot_set4  ,
               bot_value4,
               top_set5  ,
               top_value5,
               bot_set5  ,
               bot_value5,
               top_set6  ,
               top_value6,
               bot_set6  ,
               bot_value6,
               top_set7  ,
               top_value7,
               bot_set7  ,
               bot_value7,
               top_set8  ,
               top_value8,
               bot_set8  ,
               bot_value8,
               top_set9  ,
               top_value9,
               bot_set9  ,
               bot_value9,
               top_set10 ,
               top_value10,
               bot_set10 ,
               bot_value10
          INTO  lvs_top_set1   ,
               lvs_top_value1 ,
               lvs_bot_set1   ,
               lvs_bot_value1 ,
               lvs_top_set2   ,
               lvs_top_value2 ,
               lvs_bot_set2   ,
               lvs_bot_value2 ,
               lvs_top_set3   ,
               lvs_top_value3 ,
               lvs_bot_set3   ,
               lvs_bot_value3 ,
               lvs_top_set4   ,
               lvs_top_value4 ,
               lvs_bot_set4   ,
               lvs_bot_value4 ,
               lvs_top_set5   ,
               lvs_top_value5 ,
               lvs_bot_set5   ,
               lvs_bot_value5 ,
               lvs_top_set6   ,
               lvs_top_value6 ,
               lvs_bot_set6   ,
               lvs_bot_value6 ,
               lvs_top_set7   ,
               lvs_top_value7 ,
               lvs_bot_set7   ,
               lvs_bot_value7 ,
               lvs_top_set8   ,
               lvs_top_value8 ,
               lvs_bot_set8   ,
               lvs_bot_value8 ,
               lvs_top_set9   ,
               lvs_top_value9 ,
               lvs_bot_set9   ,
               lvs_bot_value9 ,
               lvs_top_set10  ,
               lvs_top_value10 ,
               lvs_bot_set10  ,
               lvs_bot_value10
          FROM IQ_INTERLOCK_REFLOW_DATA
         WHERE LINE_CODE         = p_line_code
           AND ORGANIZATION_ID  = p_org
           AND ENTER_DATE IN (SELECT MAX(ENTER_DATE)
                                 FROM IQ_INTERLOCK_REFLOW_DATA
                                WHERE LINE_CODE         = p_line_code
                                  AND ORGANIZATION_ID  = p_org
                                  AND ENTER_DATE        >= TO_DATE(SYSDATE,'YYYY-MM-DD'));

      EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
               lvs_top_set1    := '';
               lvs_top_value1  := '';
               lvs_bot_set1    := '';
               lvs_bot_value1  := '';
               lvs_top_set2    := '';
               lvs_top_value2  := '';
               lvs_bot_set2    := '';
               lvs_bot_value2  := '';
               lvs_top_set3    := '';
               lvs_top_value3  := '';
               lvs_bot_set3    := '';
               lvs_bot_value3  := '';
               lvs_top_set4    := '';
               lvs_top_value4  := '';
               lvs_bot_set4    := '';
               lvs_bot_value4  := '';
               lvs_top_set5    := '';
               lvs_top_value5  := '';
               lvs_bot_set5    := '';
               lvs_bot_value5  := '';
               lvs_top_set6    := '';
               lvs_top_value6  := '';
               lvs_bot_set6    := '';
               lvs_bot_value6  := '';
               lvs_top_set7    := '';
               lvs_top_value7  := '';
               lvs_bot_set7    := '';
               lvs_bot_value7  := '';
               lvs_top_set8    := '';
               lvs_top_value8  := '';
               lvs_bot_set8    := '';
               lvs_bot_value8  := '';
               lvs_top_set9    := '';
               lvs_top_value9  := '';
               lvs_bot_set9    := '';
               lvs_bot_value9  := '';
               lvs_top_set10   := '';
               lvs_top_value10 := '';
               lvs_bot_set10   := '';
               lvs_bot_value10 := '';

      END;

      IF p_line_code = '09' THEN
          IF (lvs_top_set1 + 10 < lvs_top_value1 OR lvs_top_value1 < lvs_top_set1 - 10) OR
             (lvs_bot_set1 + 10 < lvs_bot_value1 OR lvs_bot_value1 < lvs_bot_set1 - 10) OR
             (lvs_top_set2 + 10 < lvs_top_value2 OR lvs_top_value2 < lvs_top_set2 - 10) OR
             (lvs_bot_set2 + 10 < lvs_bot_value2 OR lvs_bot_value2 < lvs_bot_set2 - 10) OR
             (lvs_top_set3 + 10 < lvs_top_value3 OR lvs_top_value3 < lvs_top_set3 - 10) OR
             (lvs_bot_set3 + 10 < lvs_bot_value3 OR lvs_bot_value3 < lvs_bot_set3 - 10) OR
             (lvs_top_set4 + 10 < lvs_top_value4 OR lvs_top_value4 < lvs_top_set4 - 10) OR
             (lvs_bot_set4 + 10 < lvs_bot_value4 OR lvs_bot_value4 < lvs_bot_set4 - 10) OR
             (lvs_top_set5 + 10 < lvs_top_value5 OR lvs_top_value5 < lvs_top_set5 - 10) OR
             (lvs_bot_set5 + 10 < lvs_bot_value5 OR lvs_bot_value5 < lvs_bot_set5 - 10) OR
             (lvs_top_set6 + 10 < lvs_top_value6 OR lvs_top_value6 < lvs_top_set6 - 10) OR
             (lvs_bot_set6 + 10 < lvs_bot_value6 OR lvs_bot_value6 < lvs_bot_set6 - 10) OR
             (lvs_top_set7 + 10 < lvs_top_value7 OR lvs_top_value7 < lvs_top_set7 - 10) OR
             (lvs_bot_set7 + 10 < lvs_bot_value7 OR lvs_bot_value7 < lvs_bot_set7 - 10) OR
             (lvs_top_set8 + 10 < lvs_top_value8 OR lvs_top_value8 < lvs_top_set8 - 10) OR
             (lvs_bot_set8 + 10 < lvs_bot_value8 OR lvs_bot_value8 < lvs_bot_set8 - 10) OR
             (lvs_top_set9 + 10 < lvs_top_value9 OR lvs_top_value9 < lvs_top_set9 - 10) OR
             (lvs_bot_set9 + 10 < lvs_bot_value9 OR lvs_bot_value9 < lvs_bot_set9 - 10) OR
             (lvs_top_set10 + 10 < lvs_top_value10 OR lvs_top_value10 < lvs_top_set10 - 10) OR
             (lvs_bot_set10 + 10 < lvs_bot_value10 OR lvs_bot_value10 < lvs_bot_set10 - 10)
           THEN
               lvl_return := 0;
           ELSE
               lvl_return := 1;
           END IF;
      ELSE
          IF (lvs_top_set1 + 5 < lvs_top_value1 OR lvs_top_value1 < lvs_top_set1 - 5) OR
             (lvs_bot_set1 + 5 < lvs_bot_value1 OR lvs_bot_value1 < lvs_bot_set1 - 5) OR
             (lvs_top_set2 + 5 < lvs_top_value2 OR lvs_top_value2 < lvs_top_set2 - 5) OR
             (lvs_bot_set2 + 5 < lvs_bot_value2 OR lvs_bot_value2 < lvs_bot_set2 - 5) OR
             (lvs_top_set3 + 5 < lvs_top_value3 OR lvs_top_value3 < lvs_top_set3 - 5) OR
             (lvs_bot_set3 + 5 < lvs_bot_value3 OR lvs_bot_value3 < lvs_bot_set3 - 5) OR
             (lvs_top_set4 + 5 < lvs_top_value4 OR lvs_top_value4 < lvs_top_set4 - 5) OR
             (lvs_bot_set4 + 5 < lvs_bot_value4 OR lvs_bot_value4 < lvs_bot_set4 - 5) OR
             (lvs_top_set5 + 5 < lvs_top_value5 OR lvs_top_value5 < lvs_top_set5 - 5) OR
             (lvs_bot_set5 + 5 < lvs_bot_value5 OR lvs_bot_value5 < lvs_bot_set5 - 5) OR
             (lvs_top_set6 + 5 < lvs_top_value6 OR lvs_top_value6 < lvs_top_set6 - 5) OR
             (lvs_bot_set6 + 5 < lvs_bot_value6 OR lvs_bot_value6 < lvs_bot_set6 - 5) OR
             (lvs_top_set7 + 5 < lvs_top_value7 OR lvs_top_value7 < lvs_top_set7 - 5) OR
             (lvs_bot_set7 + 5 < lvs_bot_value7 OR lvs_bot_value7 < lvs_bot_set7 - 5) OR
             (lvs_top_set8 + 5 < lvs_top_value8 OR lvs_top_value8 < lvs_top_set8 - 5) OR
             (lvs_bot_set8 + 5 < lvs_bot_value8 OR lvs_bot_value8 < lvs_bot_set8 - 5) OR
             (lvs_top_set9 + 5 < lvs_top_value9 OR lvs_top_value9 < lvs_top_set9 - 5) OR
             (lvs_bot_set9 + 5 < lvs_bot_value9 OR lvs_bot_value9 < lvs_bot_set9 - 5) OR
             (lvs_top_set10 + 5 < lvs_top_value10 OR lvs_top_value10 < lvs_top_set10 - 5) OR
             (lvs_bot_set10 + 5 < lvs_bot_value10 OR lvs_bot_value10 < lvs_bot_set10 - 5)
           THEN
               lvl_return := 0;
           ELSE
               lvl_return := 1;
           END IF;
      END IF;
     /* IF   lvs_top_set1 <> lvs_top_value1 OR  lvs_bot_set1 <> lvs_bot_value1 OR
           lvs_top_set2 <> lvs_top_value2 OR  lvs_bot_set2 <> lvs_bot_value2 OR
           lvs_top_set3 <> lvs_top_value3 OR  lvs_bot_set3 <> lvs_bot_value3 OR
           lvs_top_set4 <> lvs_top_value4 OR  lvs_bot_set4 <> lvs_bot_value4 OR
           lvs_top_set5 <> lvs_top_value5 OR  lvs_bot_set5 <> lvs_bot_value5 OR
           lvs_top_set6 <> lvs_top_value6 OR  lvs_bot_set6 <> lvs_bot_value6 OR
           lvs_top_set7 <> lvs_top_value7 OR  lvs_bot_set7 <> lvs_bot_value7 OR
           lvs_top_set8 <> lvs_top_value8 OR  lvs_bot_set8 <> lvs_bot_value8 OR
           lvs_top_set9 <> lvs_top_value9 OR  lvs_bot_set9 <> lvs_bot_value9 OR
           lvs_top_set10 <> lvs_top_value10 OR  lvs_bot_set10 <> lvs_bot_value10
       THEN
           lvl_return := 0;
       ELSE
           lvl_return := 1;
       END IF;*/




    END IF;

    RETURN lvl_return ;

EXCEPTION
    WHEN OTHERS
    THEN
        RETURN 0;
END;