PROCEDURE p_check_baking_scan_user_shs (
   p_chamber_code       IN     VARCHAR2,
   p_chamber_location   IN     VARCHAR2,
   p_barcode            IN     VARCHAR2,
   p_type               IN     VARCHAR2,
   p_deficit            IN     VARCHAR2,
   p_out                OUT    VARCHAR2,
   p_userid             IN     VARCHAR2
)
IS
   lvi_count              NUMBER;
   lvs_item_code          VARCHAR2 (20);
   lvs_lot_no             VARCHAR2 (20);

   lvs_chamber_type       VARCHAR2 (20);
   lvs_chamber_code       VARCHAR2 (20);

BEGIN

   ------------------------------------------------------------------------
   -- 입력 바코드 확인
   --
   -- where receipt_compare_yn = 'Y'
   -- and issue_compare_yn   = 'Y'
   -- and reel_destroy_yn = 'Y'
   ------------------------------------------------------------------------

   BEGIN

      SELECT item_code, lot_no
        INTO lvs_item_code, lvs_lot_no
        FROM im_item_receipt_barcode
       WHERE item_barcode    = p_barcode
         AND organization_id = 1;

   EXCEPTION
      WHEN NO_DATA_FOUND THEN
           p_out := f_msg('Invalid barcode, check it barcode plz.', 'K', 1)
                    || ' = '
                    || p_barcode;
           RETURN;
   END;

   SELECT count(*)
     into lvi_count
     FROM im_item_receipt_barcode
    WHERE item_barcode       = p_barcode
      AND receipt_compare_yn = 'Y'
      AND organization_id    = 1;

   IF ( lvi_count = 0 ) THEN

           p_out := f_msg('Not receipt barcode, check it barcode plz.', 'K', 1)
                    || ' = '
                    || p_barcode;
           RETURN;

   END IF;

   SELECT count(*)
     into lvi_count
     FROM im_item_receipt_barcode
    WHERE item_barcode             = p_barcode
      AND NVL(reel_destroy_yn,'N') = 'Y'
      AND organization_id          = 1;

   IF ( lvi_count > 0 ) THEN

           p_out := f_msg('Aready Destroy barcode, check it barcode plz.', 'K', 1)
                    || ' = '
                    || p_barcode;
           RETURN;

   END IF;

   --------------------------------------------------------------------
   -- 입고 할 냉장고 창고확인
   --------------------------------------------------------------------

   select count(*)
     into lvi_count
     from imcn_machine
    where machine_type in DECODE(p_type, 'B', 'BAKING', 'V', 'VACUUM', 'D', 'DEHUMIDIFY')
      and machine_code = p_chamber_code;

  IF ( lvi_count = 0 ) THEN

        p_out := f_msg('Invalid chamber location, Check it Plz.', 'K', 1)
                 || ' = '
                 ||p_type
                 || ' = '
                 ||p_chamber_code;
        RETURN;

   END IF;

   --------------------------------------------------------------------
   -- 입출고 처리
   --------------------------------------------------------------------

   IF ( p_deficit = '1' ) THEN

   ------------------------------------------------------------------------
   -- 입력상태 확인
   ------------------------------------------------------------------------

         BEGIN

            SELECT count(*), max(chamber_type), max(chamber_code)
				      INTO lvi_count, lvs_chamber_type, lvs_chamber_code
              FROM im_item_baking_master
			       WHERE item_code        = lvs_item_code
				       AND lot_no           = lvs_lot_no
				       AND output_scan_date is null
				       AND organization_id  = 1;
				       -- AND chamber_type     = p_type;

         EXCEPTION
            WHEN NO_DATA_FOUND THEN
                 lvi_count := 0;
         END;

         IF ( lvi_count > 0 ) THEN

              p_out := f_msg('Already Receipt.', 'K', 1)   -- Not found Solder label info.
                          || ' = '
                          || p_barcode
                          || ' = '
                          || lvs_chamber_type
                          || ' = '
                          || lvs_chamber_code;
              RETURN;

         END IF;

        BEGIN

            SELECT count(*), max(chamber_type), max(chamber_code)
				      INTO lvi_count, lvs_chamber_type, lvs_chamber_code
              FROM im_item_baking_master
			       WHERE item_code        = lvs_item_code
				       AND lot_no           = lvs_lot_no
				       AND output_scan_date is null
				       AND organization_id  = 1
				       AND chamber_type     = p_type
               AND chamber_code     = p_chamber_code;

         EXCEPTION
            WHEN NO_DATA_FOUND THEN
                 lvi_count := 0;
         END;

         IF ( lvi_count > 0 ) THEN

              p_out := f_msg('Already Receipt.', 'K', 1)   -- Not found Solder label info.
                          || ' = '
                          || p_barcode
                          || ' = '
                          || lvs_chamber_type
                          || ' = '
                          || lvs_chamber_code;
              RETURN;

         END IF;


   ------------------------------------------------------------------------
   -- 종료된 자재인지 확인
   ------------------------------------------------------------------------

	  select count(*) --a.item_barcode, a.issue_compare_yn, a.reel_destroy_yn
      INTO lvi_count
      from im_item_receipt_barcode a
     where reel_destroy_yn = 'Y'
       and item_barcode    = p_barcode;
       
    IF ( lvi_count > 0 ) THEN

              p_out := f_msg('이미 폐기된 자재 입니다.', 'K', 1)   
                          || ' = '
                          || p_barcode
                          || ' = '
                          || lvs_chamber_type
                          || ' = '
                          || lvs_chamber_code;
              RETURN;

    END IF;       
   
  
   ------------------------------------------------------------------------
   -- 마운터기에 장착된 자재인지 확인
   ------------------------------------------------------------------------

    select count(*)
      INTO lvi_count
      from ib_product_plandata 
     where active_yn    ='Y'
       and item_barcode = p_barcode;
       
    IF ( lvi_count > 0 ) THEN

              p_out := f_msg('마운터기에 장착된 자재 입니다.', 'K', 1)   
                          || ' = '
                          || p_barcode
                          || ' = '
                          || lvs_chamber_type
                          || ' = '
                          || lvs_chamber_code;
              RETURN;

    END IF;       
       
       
   ------------------------------------------------------------------------
   -- 입력처리
   ------------------------------------------------------------------------

				 INSERT INTO IM_ITEM_BAKING_MASTER (
						                                CHAMBER_CODE,
						                                INPUT_SCAN_DATE,
					        	                        OUTPUT_SCAN_DATE,
						                                SCAN_BY,
						                                ITEM_CODE,
						                                ITEM_BARCODE,
						                                LOT_NO,
						                                LOT_QTY,
						                                ORGANIZATION_ID,
						                                ENTER_DATE,
						                                ENTER_BY,
						                                LAST_MODIFY_DATE,
						                                LAST_MODIFY_BY,
						                                CHAMBER_TYPE,
						                                CHAMBER_LOCATION
						                               )
				SELECT p_chamber_code,
               SYSDATE,
               NULL,
               p_userid,
               item_code,
               p_barcode,
               lot_no,
               scan_qty,
               organization_id,
               sysdate,
               p_userid,
               sysdate,
               p_userid,
               p_type,
               p_chamber_location
          FROM im_item_receipt_barcode
         WHERE item_barcode    = p_barcode
           AND organization_id = 1;

   ------------------------------------------------------------------------
   -- 챔버타입이 베이킹 이면 MSL 경과시간을 reset 및 베이킹 시작시간 저장
   ------------------------------------------------------------------------

				IF ( p_type = 'B' ) THEN

				   	UPDATE im_item_receipt_barcode
							 SET msl_remain_time   = null,
                   MSL_OPEN_DATE     = null,
									 baking_start_date = sysdate,
								   baking_end_date   = null
						 WHERE item_code         = lvs_item_code
							 AND lot_no            = lvs_lot_no
							 AND organization_id   = 1 ;

						UPDATE im_item_inventory
							 SET baking_date     = sysdate
						 WHERE item_code       = lvs_item_code
							 AND material_mfs    = lvs_lot_no
							 AND organization_id = 1 ;

        ELSIF ( p_type = 'V' ) THEN
        
                   --진공포장은 입고와 동시 출고처리 로 변경 yhs 20201113 은성 포장후 바코드 안읽힌다고 투덜거려서 이기수 요청

				   	UPDATE im_item_receipt_barcode
							 SET msl_passed_time   = NVL(MSL_PASSED_TIME,0) + ((SYSDATE - NVL(MSL_OPEN_DATE,SYSDATE)) * 24),
                   msl_remain_time   = null,
                   MSL_OPEN_DATE     = null,
                   vacuum_start_date = sysdate,
                   vacuum_end_date   = sysdate  -- 은성요청으로 동시처리로 변경 
						 WHERE item_code         = lvs_item_code
							 AND lot_no            = lvs_lot_no
							 AND organization_id   = 1 ;

						UPDATE im_item_inventory
							 SET vacuum_date = sysdate
						 WHERE item_code       = lvs_item_code
							 AND material_mfs    = lvs_lot_no
							 AND organization_id = 1 ;
                             
                             
                        -- 은성요청으로 입고 와 동시 출고 처리로 변경       
                        UPDATE im_item_baking_master
                         SET output_scan_date    = sysdate
                        WHERE item_code          = lvs_item_code
                            AND lot_no           = lvs_lot_no
                            AND output_scan_date is null
                            AND organization_id  = 1
                            AND chamber_type     = p_type
                            ;                         
                             
                             

       ELSIF ( p_type = 'D' ) THEN

           	UPDATE im_item_receipt_barcode
							 SET msl_passed_time       = NVL(MSL_PASSED_TIME,0) + ((SYSDATE - NVL(MSL_OPEN_DATE,SYSDATE)) * 24),
                   msl_remain_time       = null,
									 MSL_OPEN_DATE         = null,
									 dehumidify_start_date = sysdate  ,
								   dehumidify_end_date   = null
						 WHERE item_code             = lvs_item_code
							 AND lot_no                = lvs_lot_no
							 AND organization_id       = 1 ;

						UPDATE im_item_inventory
							 SET dehumidify_date = sysdate
						 WHERE item_code       = lvs_item_code
							 AND material_mfs    = lvs_lot_no
							 AND organization_id = 1 ;

				END IF;

   ELSE

   ------------------------------------------------------------------------
   -- 입고상태 확인
   ------------------------------------------------------------------------

         BEGIN

           SELECT count(*), max(chamber_type), max(chamber_code)
				      INTO lvi_count, lvs_chamber_type, lvs_chamber_code
              FROM im_item_baking_master
			       WHERE item_code        = lvs_item_code
				       AND lot_no           = lvs_lot_no
				       AND output_scan_date is null
				       AND organization_id  = 1;
				    --   AND chamber_type     = p_type;

         EXCEPTION
            WHEN NO_DATA_FOUND THEN
                 lvi_count := 0;
         END;

         IF ( lvi_count = 0 ) THEN

              p_out := f_msg('Not Receipt State, check it plz.', 'K', 1)   -- Not found Solder label info.
                          || ' = '
                          || p_barcode;
              RETURN;

         END IF;

         BEGIN

           SELECT count(*), max(chamber_type), max(chamber_code)
				      INTO lvi_count, lvs_chamber_type, lvs_chamber_code
              FROM im_item_baking_master
			       WHERE item_code        = lvs_item_code
				       AND lot_no           = lvs_lot_no
				       AND output_scan_date is null
				       AND organization_id  = 1
				       AND chamber_type     = p_type
               AND chamber_code     = p_chamber_code;

         EXCEPTION
            WHEN NO_DATA_FOUND THEN
                 lvi_count := 0;
         END;

         IF ( lvi_count = 0 ) THEN

              p_out := f_msg('Not Receipt State, check it plz.', 'K', 1)   -- Not found Solder label info.
                          || ' = '
                          || p_barcode
                          || ' = '
                          || p_type
                          || ' = '
                          || p_chamber_code;
              RETURN;

         END IF;

   ------------------------------------------------------------------------
   -- 출고처리
   ------------------------------------------------------------------------

         UPDATE im_item_baking_master
					  SET output_scan_date = sysdate
				  WHERE item_code        = lvs_item_code
					  AND lot_no           = lvs_lot_no
						AND output_scan_date is null
						AND organization_id  = 1
						AND chamber_type     = p_type
            AND chamber_code     = p_chamber_code;

   ------------------------------------------------------------------------
   -- 챔버타입이 베이킹 이면 베이킹 완료시간 저장
   ------------------------------------------------------------------------
				IF ( p_type = 'B' ) THEN

						  UPDATE im_item_receipt_barcode
						     SET msl_passed_time = 0.01,                 -- 0 일경우 자재장착 이력을 추적하기에 이를 회피를 위해 지정
                     MSL_OPEN_DATE   = sysdate,              -- 진공포장을 하지 않기에 출고시 MSL count
									   baking_end_date = sysdate
					     WHERE item_code       = lvs_item_code
						     AND lot_no          = lvs_lot_no
						     AND organization_id = 1 ;

        ELSIF ( p_type = 'V' ) THEN

						  UPDATE im_item_receipt_barcode
						     SET vacuum_end_date = sysdate
					     WHERE item_code       = lvs_item_code
						     AND lot_no          = lvs_lot_no
						     AND organization_id = 1 ;

        ELSIF ( p_type = 'D' ) THEN

						  UPDATE im_item_receipt_barcode
						     SET MSL_OPEN_DATE       = sysdate,          -- 진공포장을 하지 않기에 출고시 MSL count   --decode( MSL_OPEN_DATE, null, null, sysdate),
                     dehumidify_end_date = sysdate
					     WHERE item_code           = lvs_item_code
						     AND lot_no              = lvs_lot_no
						     AND organization_id     = 1 ;

			 	END IF;

   END IF;

   IF ( p_deficit = '1' ) THEN
        p_out := 'OK, Receipt (Start)';
   ELSE
        p_out := 'OK, Issue (End)';
   END IF;

   COMMIT;

   RETURN;

EXCEPTION
   WHEN OTHERS THEN
      p_out := 'NG' || SQLERRM;
      RETURN;
END;
