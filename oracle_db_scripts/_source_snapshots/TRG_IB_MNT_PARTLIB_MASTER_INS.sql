TRIGGER "INFINITY21_JSMES"."TRG_IB_MNT_PARTLIB_MASTER_INS" 
BEFORE INSERT
ON IB_MNT_PARTLIB_MASTER
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE

PRAGMA AUTONOMOUS_TRANSACTION;

phase varchar2(10) ;
BEGIN


phase := '20' ;
   -----------------------------------------------------------------------------
   -- ？？？？？？？？？？？？？？？？？？？？？o？？
   --
   -----------------------------------------------------------------------------

   UPDATE IB_MNT_PARTLIB_MASTER
      SET IS_NEW_YN = 'N'
    WHERE     LINE_CODE = :NEW.LINE_CODE
          AND MACHINE_CODE = :NEW.MACHINE_CODE
          AND MASTER_YN <> 'Y'
          AND IS_NEW_YN = 'Y'
          AND PARTNAME = :NEW.PARTNAME
          AND APPLY_LOCATION = :NEW.APPLY_LOCATION
          AND ORGANIZATION_ID = :NEW.ORGANIZATION_ID;


   phase := '30' ;
   -------------------------------------------------------------------------------
   ---- ？？？？？？？？？
   -------------------------------------------------------------------------------
   DELETE FROM IB_MNT_PARTLIB_MASTER
    WHERE     LINE_CODE = :NEW.LINE_CODE
          AND MACHINE_CODE = :NEW.MACHINE_CODE
          AND MASTER_YN <> 'Y'

          AND APPLY_LOCATION = :NEW.APPLY_LOCATION
          AND PARTNAME = :NEW.PARTNAME
          AND (   LINE_CODE
               || MACHINE_CODE
               || APPLY_LOCATION
               || PARTNAME
               || PART_TYPE
               || SIZE_L
               || SIZE_W
               || SIZE_T
               || VISION_CODE
               || NOZZLE_A
               || NOZZLE_B
               || SPEED_DETACT
               || SPEED_MOUNT
               || SPEED_PICKUP
               || GAP_PICKUP
               || GAP_MOUNT
               || DETACT_ANGLE
               || STYLE_VALUE
               || RECOVERY_COUNT
               || FIX_PICKUP_OFFSET_X
               || FIX_PICKUP_OFFSET_Y
               || FIX_PICKUP_OFFSET_Z
               || LAST_UPDATE_DATE
               || MATERIAL_FEEDER_PITCH
               || MATERIAL_REEL_SIZE
               || MATERIAL_PART_PER_REEL
               || NOZZLE_C
               || NOZZLE_D) =
                 (   :NEW.LINE_CODE
                  || :NEW.MACHINE_CODE
                  || :NEW.APPLY_LOCATION
                  || :NEW.PARTNAME
                  || :NEW.PART_TYPE
                  || :NEW.SIZE_L
                  || :NEW.SIZE_W
                  || :NEW.SIZE_T
                  || :NEW.VISION_CODE
                  || :NEW.NOZZLE_A
                  || :NEW.NOZZLE_B
                  || :NEW.SPEED_DETACT
                  || :NEW.SPEED_MOUNT
                  || :NEW.SPEED_PICKUP
                  || :NEW.GAP_PICKUP
                  || :NEW.GAP_MOUNT
                  || :NEW.DETACT_ANGLE
                  || :NEW.STYLE_VALUE
                  || :NEW.RECOVERY_COUNT
                  || :NEW.FIX_PICKUP_OFFSET_X
                  || :NEW.FIX_PICKUP_OFFSET_Y
                  || :NEW.FIX_PICKUP_OFFSET_Z
                  || :NEW.LAST_UPDATE_DATE
                  || :NEW.MATERIAL_FEEDER_PITCH
                  || :NEW.MATERIAL_REEL_SIZE
                  || :NEW.MATERIAL_PART_PER_REEL
                  || :NEW.NOZZLE_C
                  || :NEW.NOZZLE_D);

                    :NEW.IS_NEW_YN := 'Y';
      COMMIT ;
EXCEPTION
   WHEN OTHERS
   THEN
      ROLLBACK;
      RAISE_APPLICATION_ERROR (-20003, 'PHASE='||phase||' '||SQLERRM);
END TRG_IB_MNT_PARTLIB_MASTER_INS;