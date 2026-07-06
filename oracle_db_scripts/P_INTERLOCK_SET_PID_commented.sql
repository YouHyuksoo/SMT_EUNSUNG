CREATE OR REPLACE PROCEDURE "P_INTERLOCK_SET_PID" (
  /* ================================================================
   * 프로시저명  : P_INTERLOCK_SET_PID
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   프로시저 원본 로직의 업무 처리 흐름을 수행한다.
   *   참조 테이블과 입력 파라미터를 기반으로 조회, 등록, 갱신 또는 메시지 반환을 처리한다.
   *   원본 코드의 트랜잭션 및 예외 처리 흐름은 변경하지 않았다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_LINE_CODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_WORKSTAGE_CODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_MACHINE_CODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_SERIAL_NO - 원본 선언부 기준 입력/출력 파라미터
   *   P_CARRIER_BARCODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_ITEM_CODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_RUN_NO - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_2D_BARCODE - 원본 로직 참조 테이블
   *   IP_PRODUCT_LASER_MARKING - 원본 로직 참조 테이블
   *   IP_PRODUCT_MODEL_MASTER - 원본 로직 참조 테이블
   *   IP_PRODUCT_RUN_CARD - 원본 로직 참조 테이블
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
   *   EXEC P_INTERLOCK_SET_PID(...)
   * ================================================================ */
   p_line_code         IN     VARCHAR2,
   p_workstage_code    IN     VARCHAR2,
   p_machine_code      IN     VARCHAR2,
   p_serial_no         IN     VARCHAR2,
   p_carrier_barcode   IN     VARCHAR2,
   p_item_code         IN     VARCHAR2,
   p_run_no            IN     VARCHAR2,
   p_out                  OUT VARCHAR2)
IS
   lvs_model_name            VARCHAR2 (30); -- [AI] 내부 처리용 변수
   lvl_lot_qty               NUMBER; -- [AI] 내부 처리용 변수
   lvdt_run_date             DATE; -- [AI] 내부 처리용 변수
   lvi_org                   NUMBER; -- [AI] 내부 처리용 변수
   LVI_CARRIER_SIZE          NUMBER; -- [AI] 내부 처리용 변수
   lvs_customer_model_name   VARCHAR2 (30); -- [AI] 내부 처리용 변수
   lvs_part_no               VARCHAR2 (30); -- [AI] 내부 처리용 변수
   lvs_ec_no                 VARCHAR2 (30); -- [AI] 내부 처리용 변수
   lvs_parent_item_code      varchar2 (30) ; -- [AI] 내부 처리용 변수
   lvi_sel_count             NUMBER; -- [AI] 내부 처리용 변수
   
BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.

   -----------------------------------------------------------------------------------
   -- Run Card check
   -----------------------------------------------------------------------------------
   
   BEGIN
      SELECT model_name, parent_item_code ,
             lot_size,
             run_date,
             organization_id
        INTO lvs_model_name, lvs_parent_item_code ,
             lvl_lot_qty,
             lvdt_run_date,
             lvi_org
        FROM ip_product_run_card
       WHERE run_no = p_run_no;
   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN NO_DATA_FOUND
      THEN
         p_out := f_msg('런카드없음','C',1);
         raise_application_error (-20003, 'RUN CARD NOT FOUND');
   END;


   -----------------------------------------------------------------------------------
   -- Model Master check
   -----------------------------------------------------------------------------------
   
   BEGIN
      SELECT MAX (customer_model_name),
             MAX (part_no),
             MAX (ec_no),
             MAX (CARRIER_SIZE)
        INTO lvs_customer_model_name,
             lvs_part_no,
             lvs_ec_no,
             LVI_CARRIER_SIZE
        FROM ip_product_model_master
       WHERE model_name = lvs_model_name;
   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN NO_DATA_FOUND
      THEN
         p_out := f_msg('모델정보 없음','C',1);
         raise_application_error (-20003,
                                  lvs_model_name || ' MODEL NOT FOUND');
   END;

   -----------------------------------------------------------------------------------
   -- 2016/010/19 SHS, 연배열 mapping 이력 생성
   -----------------------------------------------------------------------------------

   BEGIN
     
      SELECT NVL(SUM(1),0)
        INTO lvi_sel_count
        FROM IP_PRODUCT_2D_BARCODE
       WHERE SERIAL_NO       = p_serial_no 
         AND ORGANIZATION_ID = lvi_org;    

     IF (lvi_sel_count > 0) THEN               -- 중복발생
       
         IF ( p_carrier_barcode = 'Y') THEN    -- Laser Marking 이력에서 Carrier barcode가 Y로 올라옴
         
              IF ( LVI_CARRIER_SIZE > 9 ) THEN -- Carrier size check
              
                 UPDATE IP_PRODUCT_LASER_MARKING
                    SET carrier_barcode = p_serial_no
                  WHERE serial_no like substr(p_serial_no, 1, length(p_serial_no)-2)||'%'
                    AND ORGANIZATION_ID = lvi_org;     
              
              ELSE
              
                 UPDATE IP_PRODUCT_LASER_MARKING
                    SET carrier_barcode = p_serial_no
                  WHERE serial_no like substr(p_serial_no, 1, length(p_serial_no)-1)||'%'
                    AND ORGANIZATION_ID = lvi_org;     

              END IF;
              
         ELSE   
             
           NULL;     
         
         END IF;  
     
     ELSE
                         
       INSERT INTO IP_PRODUCT_LASER_MARKING (
                                             serial_no,
                                             carrier_barcode,
                                             carrier_size,                                        
                                             organization_id,
                                             enter_date,
                                             enter_by,
                                             last_modify_date,
                                             last_modify_by
                                            )
       VALUES (
               p_serial_no,
               DECODE(LVI_CARRIER_SIZE, 1, p_serial_no, NULL),  -- 1연배는 본인이 대표바코드가 됨
               LVI_CARRIER_SIZE,            
               lvi_org,
               SYSDATE,
               'SYSTEM',
               SYSDATE,
               'SYSTEM'
              );                                     
       
       IF ( LVI_CARRIER_SIZE = 2 ) THEN  -- 2연배 경우 대표바코드를 설정 하지 않아 강제로 처리

            UPDATE IP_PRODUCT_LASER_MARKING
               SET carrier_barcode = substr(p_serial_no, 1, length(p_serial_no)-1)||'1'  -- 2연밴는 끝자리가 1번이 대표바코드로 지정 됨
             WHERE serial_no like substr(p_serial_no, 1, length(p_serial_no)-1)||'%'
               AND ORGANIZATION_ID = lvi_org;  
       
       END IF;         
              
     END IF;
     
   EXCEPTION
     
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
     WHEN OTHERS THEN
          NULL;
       
   END;  

   -----------------------------------------------------------------------------------
   -- 바코드 발행이력 생성
   -----------------------------------------------------------------------------------
   
   IF ( p_carrier_barcode  = 'Y') THEN  
        NULL;
   ELSE
       
       INSERT INTO ip_product_2d_barcode (
                                         line_code,
                                         workstage_code,
                                         machine_code,
                                         serial_no,
                                         carrier_barcode,
                                         label_text,
                                         item_code,
                                         model_name,
                                         run_no,
                                         run_date,
                                         lot_qty,
                                         organization_id,
                                         enter_date,
                                         enter_by,
                                         last_modify_date,
                                         last_modify_by,
                                         carrier_size,
                                         customer_model_name,
                                         part_no,
                                         ec_no,
                                         comments 
                                        )
      VALUES (
              p_line_code,
              p_workstage_code,
              p_machine_code,
              p_serial_no,
              p_carrier_barcode,
              p_serial_no,
              p_item_code,
              lvs_model_name,
              p_run_no,
              lvdt_run_date,
              lvl_lot_qty,
              lvi_org,
              SYSDATE,
              'SYSTEM',
              SYSDATE,
              'SYSTEM',
              NVL (LVI_CARRIER_SIZE, 1),
              lvs_customer_model_name,
              lvs_part_no,
              lvs_ec_no ,
              'RUN CARD PARENT='||lvs_parent_item_code||' ITEM CODE PARAM='||p_item_code
              );

   END IF;
    
   p_out := 'OK';
   COMMIT;
   
   RETURN;
   
EXCEPTION
  
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN OTHERS
   THEN
     
        p_out := substr(SQLERRM,1,100);
        raise_application_error (-20005, 'RUN NO: '||p_run_no||', '||'PID: '||p_serial_no || '마킹이력 저장시 이상 >> ' ||p_out);
   
        RETURN;
      
END;