PROCEDURE "P_INSERT_NPM_RAW" (
   p_partsdata     IN ARRAY3_PARAMS_T,
   p_chipdata      IN ARRAY3_PARAMS_T,
   p_info          IN ARRAY3_PARAMS_T
)
IS
     LVS_ERRORMSG      VARCHAR2 (300);
     LVS_FILE_NAME     VARCHAR2 (50) := '';
     LVS_LINE_CODE     VARCHAR2 (30) := '';
     LVS_MACHINE_CODE     VARCHAR2 (30) := '';
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

     INSERT INTO IB_MNT_PARTLIB_MASTER

      (   MACHINE_CODE,
            LINE_CODE,
            APPLY_LOCATION,
            PARTNAME,
            PART_TYPE,

            SIZE_L,
            SIZE_W,
            SIZE_T,
            VISION_CODE,

            NOZZLE_A,
            NOZZLE_B,
            NOZZLE_C,
            NOZZLE_D,

            SPEED_DETACT,
            SPEED_MOUNT,
            SPEED_PICKUP,

            GAP_PICKUP,
            GAP_MOUNT,

            DETACT_ANGLE,

            STYLE_VALUE,
            RECOVERY_COUNT,

            FIX_PICKUP_OFFSET_X,
            FIX_PICKUP_OFFSET_Y,
            FIX_PICKUP_OFFSET_Z,
            LAST_UPDATE_DATE,

            MATERIAL_FEEDER_PITCH,
            MATERIAL_REEL_SIZE,
            MATERIAL_PART_PER_REEL,

            ENTER_DATE,
            ENTER_BY,
            LAST_MODIFY_DATE,
            LAST_MODIFY_BY,
            ORGANIZATION_ID,
            MASTER_YN ,
            WORK_NO )
        VALUES
      (
                'NPM' ,
                REPLACE(TRIM(LVS_LINE_CODE),'"'),
                '*', -- APPLY_LOCATION,
                REPLACE(TRIM(p_partsdata(2)),'"'), --A.NAME      PARTNAME,
                '*',                  --  PART_TYPE,

                REPLACE(TRIM(p_chipdata(2)),'"'),       --B.L       SIZE_L,
                REPLACE(TRIM(p_chipdata(3)),'"'),       --B.W      SIZE_W,
                REPLACE(TRIM(p_chipdata(4)),'"'),       --B.T       SIZE_T,

                REPLACE(TRIM(p_chipdata(8)),'"'),       --B.REF  VISION_CODE,

                REPLACE(TRIM(p_chipdata(28)),'"'),       --B.NOZZLEA,
                REPLACE(TRIM(p_chipdata(29)),'"'),       --B.NOZZLEB,
                REPLACE(TRIM(p_chipdata(30)),'"'),       --B.NOZZLEC,
                REPLACE(TRIM(p_chipdata(31)),'"'),       --B.NOZZLED,

                REPLACE(TRIM(p_chipdata(5)),'"'),       --B.RCGSP SPEED_DETACT,
                REPLACE(TRIM(p_chipdata(40)),'"'),       --B.TSPD SPEED_MOUNT,
                REPLACE(TRIM(p_chipdata(41)),'"'),       --B.MSPD SPEED_PICKUP,

                REPLACE(TRIM(p_chipdata(33)),'"'),       --B.TGAP GAP_PICKUP,
                REPLACE(TRIM(p_chipdata(34)),'"'),       --B.MGAP GAP_MOUNT,

                '',    -- DETACT_ANGLE,

                REPLACE(TRIM(p_partsdata(24)),'"'), --A.PACK STYLE_VALUE,
                REPLACE(TRIM(p_partsdata(27)),'"'), --A.RETRY RECOVERY_COUNT,

                REPLACE(TRIM(p_chipdata(35)),'"'),       --B.TUPX FIX_PICKUP_OFFSET_X,
                REPLACE(TRIM(p_chipdata(36)),'"'),       --B.TUPY FIX_PICKUP_OFFSET_Y,
                REPLACE(TRIM(p_chipdata(37)),'"'),       --B.TUPX FIX_PICKUP_OFFSET_Z,
                TO_CHAR(SYSDATE ,'YYYY-MM-DD HH24:MI:SS'),  --LAST_UPDATE_DATE,
                '',
                '',
                '',             -- MATERIAL_PART_PER_REEL,

                SYSDATE ,
                'SYSTEM' ,
                SYSDATE ,
                'SYSTEM' ,
                1,
                'N' ,
                TO_CHAR(SYSDATE ,'YYMMDDHH24MI')
        );

      COMMIT ;
EXCEPTION
   WHEN OTHERS
   THEN
      LVS_ERRORMSG := '[P_INSERT_NPM_RAW]' ||  SUBSTR(SQLERRM,1,200)  ;
   --    INSERT INTO ICOM_MACHINE_INSERT_LOG( LOG_DATE , ERROR_MESSAGE , ERROR_DESC )
   --    VALUES ( SYSDATE  , LVS_ERRORMSG  , lvs_file_name||' LINE='||lvs_line_code  ) ;
    --  COMMIT ;
      NULL;

END P_INSERT_NPM_RAW;