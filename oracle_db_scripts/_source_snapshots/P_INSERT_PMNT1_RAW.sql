PROCEDURE "P_INSERT_PMNT1_RAW" (
   p_data          IN ARRAY3_PARAMS_T,
   p_info          IN ARRAY3_PARAMS_T
)
IS
     LVS_ERRORMSG      VARCHAR2 (300);
     LVS_FILE_NAME     VARCHAR2 (50) := '';
     LVS_LINE_CODE     VARCHAR2 (30) := '';
     LVS_MACHINE_CODE     VARCHAR2 (30) := '';
     LVS_PROGRAM_NAME     VARCHAR2 (50) := '';
     LVS_LOG_DATE         VARCHAR2 (30) := '';
     
     LS_FIND_PATTERN      VARCHAR2(30) := 'PRODUCT';
     LI_FIND_POSITION     INT := 35; --PRODUCT...(35th)H790-BOT(16G)
     LVI_START_PRODUCT     INT := 0;
     
     LVS_MACHINE_TYPE  VARCHAR2(20) ; --CM601-1
BEGIN

  if p_info.Last >= 1
    then
    LVS_FILE_NAME := TRIM(p_info(1));
  end if;

  if p_info.Last >= 2
    then
    LVS_LINE_CODE := TRIM(p_info(2));
  end if;

  if p_info.Last >= 3
    then
    LVS_MACHINE_CODE := TRIM(p_info(3));
  end if;

  if p_data.Last >= 69 -- #1=(1st line)
     then
    if LVI_START_PRODUCT = 0 then
      LVI_START_PRODUCT := INSTR(p_data(69), LS_FIND_PATTERN, 1,1);
      if LVI_START_PRODUCT > 0 
        then
        LVS_PROGRAM_NAME :=  TRIM(SUBSTR(p_data(69),LVI_START_PRODUCT + LI_FIND_POSITION, INSTR(p_data(69), ' ', LVI_START_PRODUCT,1) - LVI_START_PRODUCT - LI_FIND_POSITION));
        --LVS_PROGRAM_NAME :=   p_data(69); 
        LVS_MACHINE_TYPE := TRIM(SUBSTR(p_data(69), INSTR(p_data(69),'CM',1,1), 7 )); 
        
        --DEBUG
        IF SUBSTR(LVS_MACHINE_TYPE,1,2) <> 'CM' THEN
          begin 
                LVS_ERRORMSG := '[P_INSERT_PMNT1_RAW] ' || 'SUBSTR(LVS_MACHINE_TYPE,1,2) <> CM' ;
           --     INSERT INTO ICOM_MACHINE_INSERT_LOG( LOG_DATE , ERROR_MESSAGE , ERROR_DESC ) 
           --          VALUES ( SYSDATE  , LVS_ERRORMSG  , substr(p_data(69),1,2000)  ) ;
          exception 
            when others then 
              null ;
          end ;
        END IF ;
        --DEBUG 
      end if;
    end if;
  end if;
  
  if p_data.Last >= 70 -- #2=(2nd line)
     then
    if LVI_START_PRODUCT = 0 then
      LVI_START_PRODUCT := INSTR(p_data(70), LS_FIND_PATTERN, 1,1);
      if LVI_START_PRODUCT > 0 
        then
        LVS_PROGRAM_NAME :=  TRIM(SUBSTR(p_data(70),LVI_START_PRODUCT + LI_FIND_POSITION, INSTR(p_data(70), ' ', LVI_START_PRODUCT,1) - LVI_START_PRODUCT - LI_FIND_POSITION));
        --LVS_PROGRAM_NAME :=   p_data(69); 
        LVS_MACHINE_TYPE := TRIM(SUBSTR(p_data(70), INSTR(p_data(70),'CM',1,1), 7 )); 
        
        --DEBUG
        IF SUBSTR(LVS_MACHINE_TYPE,1,2) <> 'CM' THEN
          begin 
                           LVS_ERRORMSG := '[P_INSERT_PMNT1_RAW] ' || 'SUBSTR(LVS_MACHINE_TYPE,1,2) <> CM' ;
           --     INSERT INTO ICOM_MACHINE_INSERT_LOG( LOG_DATE , ERROR_MESSAGE , ERROR_DESC ) 
           --          VALUES ( SYSDATE  , LVS_ERRORMSG  , substr(p_data(70),1,2000)  ) ;
          exception 
            when others then 
              null ;
          end ;
        END IF ;
        --DEBUG 
      end if;
    end if;
  end if;
  
  if p_data.Last >= 71 --Date= 
     then
    LVS_LOG_DATE :=  TRIM(p_data(71));
  end if;

     INSERT INTO IQ_MACHINE_INSPECT_PMNT1

      (     ADDRESS,
            SUBADD,
            FDRTYPE,
            NAME,
            NPA,
            NPB,
            NPC,
            NPD,
            NPE,
            NPF,
            NPG,
            NPH,
            NPI,
            NPJ,
            NPK,
            NPL,
            NS11,
            NS12,
            NS13,
            NS14,
            NS15,
            NS16,
            NS17,
            NS18,
            NS19,
            NS21,
            NS22,
            NS23,
            NS24,
            NS25,
            NS26,
            NS27,
            NS28,
            NS29,
            NS31,
            NS32,
            NS33,
            NS34,
            NS35,
            NS36,
            NS37,
            NS38,
            NS39,
            NS41,
            NS42,
            NS43,
            NS44,
            NS45,
            NS46,
            NS47,
            NS48,
            NS49,
            NS51,
            NS52,
            NS53,
            NS54,
            NS55,
            NS56,
            NS61,
            NS62,
            NS63,
            NS64,
            NS65,
            NS66,
            SNA,
            SNB,
            STA,
            STB,

            PROGRAM_NAME,
            LOG_DATE,

            ENTER_DATE       ,
            ENTER_BY         ,
            LAST_MODIFY_DATE ,
            LAST_MODIFY_BY   ,
            ORGANIZATION_ID  ,
            FILE_NAME        ,
            LINE_CODE        ,
            MACHINE_CODE     ,
            RUN_NO
      )
      VALUES
      (
        REPLACE(TRIM(p_data(1)),'"'),
        REPLACE(TRIM(p_data(2)),'"'),
        REPLACE(TRIM(p_data(3)),'"'),
        REPLACE(TRIM(p_data(4)),'"'),
        REPLACE(TRIM(p_data(5)),'"'),

        REPLACE(TRIM(p_data(6)),'"'),
        REPLACE(TRIM(p_data(7)),'"'),
        REPLACE(TRIM(p_data(8)),'"'),
        REPLACE(TRIM(p_data(9)),'"'),
        REPLACE(TRIM(p_data(10)),'"'),

        REPLACE(TRIM(p_data(11)),'"'),
        REPLACE(TRIM(p_data(12)),'"'),
        REPLACE(TRIM(p_data(13)),'"'),
        REPLACE(TRIM(p_data(14)),'"'),
        REPLACE(TRIM(p_data(15)),'"'),

        REPLACE(TRIM(p_data(16)),'"'),
        REPLACE(TRIM(p_data(17)),'"'),
        REPLACE(TRIM(p_data(18)),'"'),
        REPLACE(TRIM(p_data(19)),'"'),
        REPLACE(TRIM(p_data(20)),'"'),

        REPLACE(TRIM(p_data(21)),'"'),
        REPLACE(TRIM(p_data(22)),'"'),
        REPLACE(TRIM(p_data(23)),'"'),
        REPLACE(TRIM(p_data(24)),'"'),
        REPLACE(TRIM(p_data(25)),'"'),
        
        REPLACE(TRIM(p_data(26)),'"'),
        REPLACE(TRIM(p_data(27)),'"'),
        REPLACE(TRIM(p_data(28)),'"'),
        REPLACE(TRIM(p_data(29)),'"'),
        REPLACE(TRIM(p_data(30)),'"'), 

        REPLACE(TRIM(p_data(31)),'"'),
        REPLACE(TRIM(p_data(32)),'"'),
        REPLACE(TRIM(p_data(33)),'"'),
        REPLACE(TRIM(p_data(34)),'"'),
        REPLACE(TRIM(p_data(35)),'"'),

        REPLACE(TRIM(p_data(36)),'"'),
        REPLACE(TRIM(p_data(37)),'"'),
        REPLACE(TRIM(p_data(38)),'"'),
        REPLACE(TRIM(p_data(39)),'"'),
        REPLACE(TRIM(p_data(40)),'"'),

        REPLACE(TRIM(p_data(41)),'"'),
        REPLACE(TRIM(p_data(42)),'"'),
        REPLACE(TRIM(p_data(43)),'"'),
        REPLACE(TRIM(p_data(44)),'"'),
        REPLACE(TRIM(p_data(45)),'"'),

        REPLACE(TRIM(p_data(46)),'"'),
        REPLACE(TRIM(p_data(47)),'"'),
        REPLACE(TRIM(p_data(48)),'"'),
        REPLACE(TRIM(p_data(49)),'"'),
        REPLACE(TRIM(p_data(50)),'"'),

        REPLACE(TRIM(p_data(51)),'"'),
        REPLACE(TRIM(p_data(52)),'"'),
        REPLACE(TRIM(p_data(53)),'"'),
        REPLACE(TRIM(p_data(54)),'"'),
        REPLACE(TRIM(p_data(55)),'"'),

        REPLACE(TRIM(p_data(56)),'"'),
        REPLACE(TRIM(p_data(57)),'"'),
        REPLACE(TRIM(p_data(58)),'"'),
        REPLACE(TRIM(p_data(59)),'"'),
        REPLACE(TRIM(p_data(60)),'"'),

        REPLACE(TRIM(p_data(61)),'"'),
        REPLACE(TRIM(p_data(62)),'"'),
        REPLACE(TRIM(p_data(63)),'"'),
        REPLACE(TRIM(p_data(64)),'"'),
        REPLACE(TRIM(p_data(65)),'"'),

        REPLACE(TRIM(p_data(66)),'"'),
        REPLACE(TRIM(p_data(67)),'"'),
        REPLACE(TRIM(p_data(68)),'"'),
        LVS_PROGRAM_NAME,
        LVS_LOG_DATE,

        SYSDATE ,
        'SYSTEM' ,
        SYSDATE ,
        'SYSTEM' ,
        1,
        REPLACE(TRIM(LVS_FILE_NAME),'"'),
        LVS_LINE_CODE,
        LVS_MACHINE_TYPE,  --LVS_MACHINE_CODE 
        TO_CHAR(SYSDATE ,'YYMMDDHH24MI')
        );

      COMMIT ;
EXCEPTION
   WHEN OTHERS
   THEN
      LVS_ERRORMSG := '[P_INSERT_PMNT1_RAW]' ||  SUBSTR(SQLERRM,1,200)  ;
      INSERT INTO ICOM_MACHINE_INSERT_LOG( LOG_DATE , ERROR_MESSAGE , ERROR_DESC ) 
       VALUES ( SYSDATE  , LVS_ERRORMSG  , lvs_file_name||' LINE='||lvs_line_code  ) ;
      COMMIT ;
      NULL;

END P_INSERT_PMNT1_RAW;