CREATE OR REPLACE PROCEDURE p_check_baking_scan_user_bak (
  /* ================================================================
   * 프로시저명  : P_CHECK_BAKING_SCAN_USER_BAK
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-11-13
   * 수정이력:
   *   2020-11-13 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   입력 조건을 기준으로 업무 데이터의 유효성 또는 상태를 확인한다.
   *   조회 결과와 원본 분기 조건에 따라 OUT 파라미터 또는 상태 값을 설정한다.
   *   호출부가 결과 코드와 메시지로 후속 처리를 판단할 수 있게 한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_CHAMBER_CODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_CHAMBER_LOCATION - 원본 선언부 기준 입력/출력 파라미터
   *   P_BARCODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_TYPE - 원본 선언부 기준 입력/출력 파라미터
   *   P_DEFICIT - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT - 원본 선언부 기준 입력/출력 파라미터
   *   P_USERID - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IB_PRODUCT_PLANDATA - 원본 로직 참조 테이블
   *   IMCN_MACHINE - 원본 로직 참조 테이블
   *   IM_ITEM_BAKING_MASTER - 원본 로직 참조 테이블
   *   IM_ITEM_INVENTORY - Item Inventory Master
   *   IM_ITEM_RECEIPT_BARCODE - 원본 로직 참조 테이블
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_MSG
   * ================================================================
   * [AI 분석] 예외 처리:
   *   원본 EXCEPTION 절의 반환값, RAISE, COMMIT/ROLLBACK 흐름을 변경하지 않는다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 구현 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_CHECK_BAKING_SCAN_USER_BAK(...)
   * ================================================================ */
   p_chamber_code       IN     VARCHAR2,
   p_chamber_location   IN     VARCHAR2,
   p_barcode            IN     VARCHAR2,
   p_type               IN     VARCHAR2,
   p_deficit            IN     VARCHAR2,
   p_out                OUT    VARCHAR2,
   p_userid             IN     VARCHAR2
)
IS
   lvi_count              NUMBER; -- [AI] 내부 처리용 변수
   lvs_item_code          VARCHAR2 (20); -- [AI] 내부 처리용 변수
   lvs_lot_no             VARCHAR2 (20); -- [AI] 내부 처리용 변수

   lvs_chamber_type       VARCHAR2 (20); -- [AI] 내부 처리용 변수
   lvs_chamber_code       VARCHAR2 (20); -- [AI] 내부 처리용 변수

BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.

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
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
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
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
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
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
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
							 SET -- msl_remain_time   =  msl_passed_time  ,
									 baking_start_date = sysdate  ,
								   baking_end_date   = null,
                   MSL_OPEN_DATE     = null
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
                         SET output_scan_date = sysdate
                        WHERE item_code        = lvs_item_code
                            AND lot_no         = lvs_lot_no
                            AND output_scan_date is null
                            AND organization_id  = 1
                            AND chamber_type     = p_type
                            ;                         
                             
                             

       ELSIF ( p_type = 'D' ) THEN

           	UPDATE im_item_receipt_barcode
							 SET msl_passed_time       = NVL(MSL_PASSED_TIME,0) + ((SYSDATE - NVL(MSL_OPEN_DATE,SYSDATE)) * 24),
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
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
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
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
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
						     SET  msl_passed_time   = 0.01  ,                 -- 0 일경우 자재장착 이력을 추적하기에 이를 회피를 위해 지정
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
						     SET MSL_OPEN_DATE       = decode( MSL_OPEN_DATE, null, null, sysdate),
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
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN OTHERS THEN
      p_out := 'NG' || SQLERRM;
      RETURN;
END;
