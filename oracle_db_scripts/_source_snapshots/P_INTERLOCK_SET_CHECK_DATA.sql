PROCEDURE "P_INTERLOCK_SET_CHECK_DATA" (
   p_line_code        IN     VARCHAR2,
   p_workstage_code   IN     VARCHAR2,
   p_machine_code     IN     VARCHAR2,
   p_item_code        IN     VARCHAR2,
   p_serial_no        IN     VARCHAR2,
   p_result           IN     VARCHAR2,
   p_magazine_no      IN     VARCHAR2,
   p_mapping_label    IN     VARCHAR2,
   p_attribute1       IN     VARCHAR2,                         -- top / bottom
   p_attribute2       IN     VARCHAR2,
   p_attribute3       IN     VARCHAR2,
   p_out                 OUT VARCHAR2)
------------------------------------------------------------------------
--p_attribute1 미사용
-------------------------------------------------------------------------
IS
   lvs_set_item_code         VARCHAR2 (30);
   lvs_run_no                VARCHAR2 (30);
   lvs_model_name            VARCHAR2 (30);
   lvs_pcb_item              VARCHAR2 (30);
   lvs_child_item_code       VARCHAR2 (30);
   lvs_customer_model_name   VARCHAR2 (30);
   lvs_part_no               VARCHAR2 (30);
   lvs_ec_no                 VARCHAR2 (30);
   PHASE                     VARCHAR2 (1000);
   LVS_ERRORMSG              VARCHAR2 (1000);
   lvi_exists                NUMBER;
   lvi_carrier_size          NUMBER;
   lvs_out                   VARCHAR2 (1000);
   LVI_DUP_CHECK             NUMBER;
   LVD_SYSDATE               DATE;
   -- JIG 사용 Logging 2016.04.27
   LVS_MASK_LOT_NO           VARCHAR2 (50);
   LVS_SOLDER_LOT_NO         VARCHAR2 (50);
   LVS_SQUEZE_LOT_NO         VARCHAR2 (50);

   LVS_MAPPING_MODEL_NAME    VARCHAR2 (30);
   LVI_POS1                  NUMBER;
   LVI_POS2                  NUMBER;

   LVI_MAGAZINE_IN_QTY       NUMBER;

BEGIN
   PHASE := '10';

  

   IF p_magazine_no IS NULL OR p_magazine_no = ''
   THEN
      NULL;
   ELSE

      ----------------------------------------------------------------------------------------------------------
      -- 2016/06/16 SHS, f_get_magazine_unissued_cur() 에서 clear 시 MAGAZINE Mapping 이상 해결을 위해
      --                 공정 진행중인 MAGAZINE에 대해 해당 공정에만 반영 함
      ----------------------------------------------------------------------------------------------------------

           UPDATE ip_product_2d_barcode
             SET magazine_no = p_magazine_no, magazine_date = SYSDATE
           WHERE serial_no = p_serial_no;

          ------------------------------------------
          -- 이전에 통과한 이력도 같이 변경

          ------------------------------------------

          IF p_magazine_no = '*' OR p_magazine_no = '-' THEN

             UPDATE iq_interlock_check_result
                SET magazine_no    = p_magazine_no
              WHERE serial_no      = p_serial_no
                AND workstage_code = p_workstage_code;

          ELSE

             UPDATE iq_interlock_check_result
                SET magazine_no = p_magazine_no
              WHERE serial_no   = p_serial_no;

          END IF;

      --------------------------------------------------------------------------------------------------
      -- 2016/06/14 SHS, MAGAZINE 라벨에 mapping PID 이상으로 추적을 위해 MAGAZINE mappig 이력을 별도로 남김

      --------------------------------------------------------------------------------------------------

      BEGIN
         SELECT DECODE(REGEXP_INSTR (p_attribute2, '[^[:DIGIT:]]'),0,TO_NUMBER(p_attribute2),0) -- number 인지 확인하여 문자면 0으로 return 한다
           INTO LVI_MAGAZINE_IN_QTY
           FROM DUAL;
      EXCEPTION
        WHEN OTHERS THEN
             LVI_MAGAZINE_IN_QTY := 0;
      END;

      INSERT INTO IP_PRODUCT_MAGAZINE (
                                       LINE_CODE,
                                       WORKSTAGE_CODE,
                                       SERIAL_NO,
                                       MAGAZINE_NO,
                                       MAPPING_LABEL,
                                       MAGAZINE_IN_QTY,
                                       ORGANIZATION_ID,
                                       ENTER_DATE,
                                       ENTER_BY,
                                       LAST_MODIFY_DATE,
                                       LAST_MODIFY_BY
                                      )
             VALUES (
                     p_line_code,
                     p_workstage_code,
                     p_serial_no,
                     p_magazine_no,
                     p_mapping_label,
                     LVI_MAGAZINE_IN_QTY,
                     1,
                     sysdate,
                     'TRIGGER',
                     sysdate,
                     'TRIGGER'
                    );

   END IF;

   PHASE := '20';

   --------------------------------------------------------------------
   -- 매핑 라벨이 없으면 그냥 무시
   -- 매핑 공정에서 라벨이 올라오므로
   --------------------------------------------------------------------
   IF    p_mapping_label IS NULL
      OR p_mapping_label = '*'
      OR p_mapping_label = ''
   THEN
      NULL;
   ELSE
      PHASE := PHASE || '60=>';

      LVI_POS1 :=
         INSTR (p_mapping_label,
                '/',
                1,
                2);
      LVI_POS2 :=
         INSTR (p_mapping_label,
                '/',
                1,
                3);

      LVS_MAPPING_MODEL_NAME :=
         UPPER (
            TRIM (
               SUBSTR (p_mapping_label,
                       LVI_POS1 + 1,
                       LVI_POS2 - LVI_POS1 - 1)));


      UPDATE ip_product_2d_barcode
         SET mapping_label = p_mapping_label,
             mapping_model_name = LVS_MAPPING_MODEL_NAME
       WHERE serial_no = p_serial_no;

      --------------------------------------
      -- 이전에 통과한 이력도 같이 변경

      --------------------------------------
      UPDATE iq_interlock_check_result
         SET mapping_label = p_mapping_label,
             mapping_model_name = LVS_MAPPING_MODEL_NAME
       WHERE serial_no = p_serial_no;
   END IF;

   PHASE := '30';

   --------------------------------------------------------------------------
   -- 2D 마스터에서 정보추출
   --------------------------------------------------------------------------
   BEGIN
      SELECT item_code,
             model_name,
             run_no,
             customer_model_name,
             part_no,
             ec_no,
             carrier_size
        INTO lvs_set_item_code,
             lvs_model_name,
             lvs_run_no,
             lvs_customer_model_name,
             lvs_part_no,
             lvs_ec_no,
             lvi_carrier_size
        FROM ip_product_2d_barcode
       WHERE serial_no = p_serial_no;
   EXCEPTION
      WHEN OTHERS
      THEN
         NULL;
   END;

   PHASE := '40';

   -------------------------------------------------------------------
   -- 라인정보에 런번호 저장
   -- 라인에 런번호 설정하는 로직이 없어 여기서 처리
   ------------------------------------------------------------------
   UPDATE ip_product_line
      SET run_no = lvs_run_no,
          COMMENTS =
                'LINE='
             || p_line_code
             || ' WS='
             || p_workstage_code
             || 'RUN NO='
             || lvs_run_no
             || ' PID='
             || p_serial_no
             || ' Time='
             || TO_CHAR (SYSDATE, 'YYYYMMDD HH24MISS')
             || ' Set Item='
             || lvs_set_item_code
             || ' Model='
             || model_name
             || ' Attribute1='
             || p_attribute1
    WHERE line_code = p_line_code;

   PHASE := '50';


   ----------------------------------------------------------------------
   -- 라인정보에 최종적으로 저장되어 있는 자품목 과 TOP/BOTTOM 구분 가져옴
   -- 현재 시점상에 문제가 있어보임 매거진을 나중에 구성할 경우 이전정보를
   -- 가져올지 못 이미 라인은 다른모델로 바뀌어 있음
   --
   ----------------------------------------------------------------------

   BEGIN
      SELECT NVL (child_item_code, '*'), NVL (pcb_item, '*')
        INTO lvs_child_item_code, lvs_pcb_item
        FROM ip_product_line
       WHERE line_code = p_line_code      -- AND item_code = lvs_set_item_code
                                    ;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         lvs_child_item_code := '*';
         lvs_pcb_item := '*';
      WHEN OTHERS
      THEN
         NULL;
   END;

   PHASE := '60';

   ---------------------------------------------------------------
   -- 라인에 다른 정보가 걸려 있을 경우
   -- 현재 라인에서 올라온 탑 바텁 정보를 저장한다 .
   ---------------------------------------------------------------
   IF ( lvs_pcb_item = '*' OR lvs_pcb_item IS NULL ) AND p_attribute1 IN ('T', 'B')
   THEN
      lvs_pcb_item := NVL (p_attribute1, '*');
   END IF;

   -------------------------------------------------------------------
   -- 모델 마스터에서
   -- 부가적인 정보 가져옴
   -------------------------------------------------------------------
   IF lvi_carrier_size = 0 OR lvi_carrier_size IS NULL
   THEN
      BEGIN
         PHASE := PHASE || '100=>';

         SELECT customer_model_name,
                part_no,
                ec_no,
                carrier_size
           INTO lvs_customer_model_name,
                lvs_part_no,
                lvs_ec_no,
                lvi_carrier_size
           FROM ip_product_model_master
          WHERE (item_code = p_item_code OR part_no = p_item_code)
                AND ROWNUM = 1;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
         WHEN OTHERS
         THEN
            NULL;
      END;
   END IF;

   PHASE := '70';

   ----------------------------------------------------------------------
   -- 중복 스캔 방지
   -- 동일 데이터 있을경우 스킵
   ----------------------------------------------------------------------
   BEGIN
      SELECT COUNT (*)
        INTO LVI_DUP_CHECK
        FROM iq_interlock_check_result
       WHERE     SERIAL_NO = p_serial_no
             AND RECEIPT_DATE = SYSDATE
             AND LINE_CODE = P_LINE_CODE
             AND WORKSTAGE_CODE = P_WORKSTAGE_CODE
             AND MACHINE_CODE = p_machine_code
             AND CHECK_RESULT = p_result
             AND MODEL_NAME = lvs_model_name
             AND PCB_ITEM = lvs_pcb_item
             AND ITEM_CODE = lvs_set_item_code
             AND CHILD_ITEM_CODE = lvs_child_item_code;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         LVI_DUP_CHECK := 0;
   END;


   IF NVL (LVI_DUP_CHECK, 0) = 0
   THEN
      ----------------------------------------------------------------------
      -- 센서 대체 수량 카운트
      -- AND P_LINE_CODE = '05'
      -- 리플로우 공정일경우에만 실적으로 반영해서 함수 호출
      ----------------------------------------------------------------------
      IF f_get_workstage_type(p_workstage_code) = 'REFLOW'
      THEN
         P_INTERLOCK_SENSOR_ACTUAL_NEO (P_LINE_CODE,
                                        P_WORKSTAGE_CODE,
                                        P_MACHINE_CODE,
                                        1, --반영 수량 기본 ( 1 , Network 등문제시  1이상 값 )
                                        1,                          --누적 계수 수량
                                        P_OUT);
      END IF;

      PHASE := '80';



      -------------------------------------------------------------------
      --공정 통과 이력 저장

      -------------------------------------------------------------------
      LVD_SYSDATE := SYSDATE;

      INSERT INTO iq_interlock_check_result (receipt_date,
                                             item_code,
                                             child_item_code,
                                             serial_no,
                                             line_code,
                                             workstage_code,
                                             machine_code,
                                             check_result,
                                             magazine_no,
                                             run_no,
                                             model_name,
                                             pcb_item,
                                             enter_date,
                                             enter_by,
                                             last_modify_date,
                                             last_modify_by,
                                             organization_id,
                                             customer_model_name,
                                             part_no,
                                             ec_no,
                                             mapping_label,
                                             ORIGIN_ITEM_CODE,
                                             DEBUG_LOG,
                                             mapping_model_name) -- 2016/05/09, 공정통과이력 생성시 mapping model 추가
      VALUES (LVD_SYSDATE,                                         -- SYSDATE,
              lvs_set_item_code,
              lvs_child_item_code,                      --lvs_child_item_code,
              p_serial_no,
              p_line_code,
              p_workstage_code,
              p_machine_code,
              p_result,
              p_magazine_no,
              NVL (lvs_run_no, '*'),
              lvs_model_name,
              lvs_pcb_item,
              SYSDATE,
              NVL (p_attribute2, 'SYSTEM'),
              SYSDATE,
              'SYSTEM',
              1,
              lvs_customer_model_name,
              lvs_part_no,
              lvs_ec_no,
              p_mapping_label,
              P_ITEM_CODE,
              PHASE,
              LVS_MAPPING_MODEL_NAME);

      -------------------------------------------------------------------
      -- 실적 및 현재 공정 위치 정보를 2d Barcode 에  Update 한다.
      -- 2016.04.26
      -------------------------------------------------------------------
      PHASE := '85';

      -- 2016/05/11 SHS
      IF p_workstage_code <> 'W135'
      THEN      -- 완성공정 이후 Verification 공정 Scan 시 2D barcode에 actual date 변경으로
         -- 강제로 막음, 차후 Verificatiob 공정은 최종 공정이전으로 예정, 조찬필K
         BEGIN
            UPDATE ip_product_2d_barcode x
               SET x.actual_date = f_get_work_actual_date (LVD_SYSDATE, 'A'), --RECEIPT DATE
                   x.actual_line_code = p_line_code,          --LINE CODE 실적라인
                   x.worktime_zone =
                      f_get_worktime_zone (TO_CHAR (LVD_SYSDATE, 'yyyymmdd'),
                                           TO_CHAR (LVD_SYSDATE, 'hh24mi'),
                                           'ZONE'),           --Work Time Zone
                   x.c_workstage_code = p_workstage_code,          --현재 작업장 위치
                   x.shift_code = f_get_work_shift_code (SYSDATE),
                   x.is_last =
                      DECODE (f_get_workstage_type(p_workstage_code) ,'REFLOW', DECODE (lvs_pcb_item, 'T', 1, 2),  0)
             /*제품실적  ::  LG출하공정 W240,DY 박스라벨 W140, 보쉬 WAVE SOLDER 메거진 W160 , KEFICO 메거진 W190*/
             /*반제품실적 :: W050 Reflow "T" 1 , "B", 2*/
             WHERE serial_no = p_serial_no;
         EXCEPTION
            WHEN OTHERS
            THEN
               NULL;
         END;
      END IF;

      -------------------------------------------------------------------
      -- SPI 공정 통과시 Solder Lot 정보 및 Mask Lot 정보를 시리얼 단위로 Logging 한다.
      -- ICT 공정 통과시 Squeeze Lot 정보 를 시리얼 단위로 Logging 한다
      -- 2016.04.27
      -------------------------------------------------------------------
      BEGIN
         PHASE := '86';

         SELECT NVL (X.MASK_LOT_NO, '*'),
                NVL (X.SQUEZE_LOT_NO, '*'),
                NVL (X.SOLDER_LOT_NO, '*')
           INTO LVS_MASK_LOT_NO, LVS_SQUEZE_LOT_NO, LVS_SOLDER_LOT_NO
           FROM IP_PRODUCT_LINE X
          WHERE LINE_CODE = p_line_code AND ORGANIZATION_ID = 1;


         IF f_get_workstage_type(p_workstage_code) = 'SPI'
         THEN                                                      --SPI 공정 이면

            PHASE := '86';

            UPDATE ip_product_2d_barcode T
               SET T.MASK_LOT_NO = LVS_MASK_LOT_NO,
                   T.SOLDER_LOT_NO = LVS_SOLDER_LOT_NO
             WHERE T.SERIAL_NO = p_serial_no;
         ELSIF f_get_workstage_type(p_workstage_code) = 'ICT'
         THEN                                                         --ICT 공정
            PHASE := '87';

--            UPDATE ip_product_2d_barcode T
--               SET T.SQUEZE_LOT_NO = LVS_SQUEZE_LOT_NO
--             WHERE T.SERIAL_NO = p_serial_no;
--         -- 동얄 공정만 해당

         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;
   END IF;


   -------------------------------------------------------------------
   -- 2016/08/30, Master sample 이력 저장

   -------------------------------------------------------------------

  PHASE := '89';

  BEGIN

     lvi_exists := 0;

     SELECT F_CHECK_MASTER_SAMPLE(p_serial_no)
       INTO lvi_exists
       FROM dual;

     IF ( f_get_workstage_type(p_workstage_code) = 'AOI' and lvi_exists > 0) THEN

        UPDATE ip_product_run_model
           SET aoi_master_sample_check = DECODE(p_result,'PASS','Y','OK','Y','N'),
               aoi_master_sample_pid   = p_serial_no,
               aoi_master_sample_date  = sysdate
         WHERE line_code               = p_line_code
           AND organization_id         = 1;

     END IF;

  EXCEPTION

     WHEN OTHERS THEN
          NULL;

  END;

 PHASE := '90';

      -------------------------------------------------------------------
      -- 2016/07/01, 생산실적 집계를 위한 table 생성
      -------------------------------------------------------------------

   select nvl(sum(1),0)
     into lvi_exists
     from IP_PRODUCT_SERIAL_RESULT
    where serial_no       = p_serial_no
      and workstage_code  = p_workstage_code
      and line_code       = p_line_code
      and organization_id = 1
      and rownum          = 1;

   if  lvi_exists = 0 then

       insert into IP_PRODUCT_SERIAL_RESULT (
                                             organization_id,
                                             receipt_date,
                                             line_code,
                                             workstage_code,
                                             serial_no,
                                             model_name,
                                             item_code,
                                             pcb_item,
                                             enter_date,
                                             enter_by,
                                             last_modify_date,
                                             last_modify_by,
                                             run_no
                                            )
       VALUES (
               1,
               LVD_SYSDATE,
               p_line_code,
               p_workstage_code,
               p_serial_no,
               lvs_model_name,
               lvs_set_item_code,
               lvs_pcb_item,
               sysdate,
               'INTERLOCK_CHK_DATA',
               sysdate,
               'INTERLOCK_CHK_DATA',
               lvs_run_no
              );
   else

       insert into IP_PRODUCT_REINPUT_RESULT (
                                              organization_id,
                                              receipt_date,
                                              line_code,
                                              workstage_code,
                                              serial_no,
                                              model_name,
                                              item_code,
                                              pcb_item,
                                              enter_date,
                                              enter_by,
                                              last_modify_date,
                                              last_modify_by,
                                              run_no
                                             )
       VALUES (
               1,
               LVD_SYSDATE,
               p_line_code,
               p_workstage_code,
               p_serial_no,
               lvs_model_name,
               lvs_set_item_code,
               lvs_pcb_item,
                sysdate,
               'INTERLOCK_CHK_DATA',
               sysdate,
               'INTERLOCK_CHK_DATA',
               lvs_run_no
             );

   end if;

      -------------------------------------------------------------------
      -- 2016/07/01, 생산실적 집계를 위한 table 생성
      -------------------------------------------------------------------


   p_out := 'OK';
   COMMIT;
   PHASE := '90';
   RETURN;
--------------------------------------------------------------------
--
--------------------------------------------------------------------

EXCEPTION
   WHEN OTHERS
   THEN
      p_out := SQLERRM;
      raise_application_error (
         -20003,
            'PHASE='
         || PHASE
         || ' '
         || 'LINE='
         || p_line_code
         || ' WS='
         || p_workstage_code
         || ' MC='
         || p_machine_code
         || ' ITEM='
         || p_item_code
         || ' PID='
         || p_serial_no
         || ' R='
         || p_result
         || ' '
         || SQLERRM);
END;