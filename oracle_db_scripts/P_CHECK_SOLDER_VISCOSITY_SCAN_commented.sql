CREATE OR REPLACE PROCEDURE p_check_solder_viscosity_scan (
  /* ================================================================
   * 프로시저명  : P_CHECK_SOLDER_VISCOSITY_SCAN
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-04-16
   * 수정이력:
   *   2020-04-16 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   입력 조건을 기준으로 업무 데이터의 유효성 또는 상태를 확인한다.
   *   조회 결과와 원본 분기 조건에 따라 OUT 파라미터 또는 상태 값을 설정한다.
   *   호출부가 결과 코드와 메시지로 후속 처리를 판단할 수 있게 한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_BARCODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_VISCOSITY - 원본 선언부 기준 입력/출력 파라미터
   *   P_DEFICIT - 원본 선언부 기준 입력/출력 파라미터
   *   P_USERID - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IM_ITEM_SOLDER_MASTER - 원본 로직 참조 테이블
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
   *   EXEC P_CHECK_SOLDER_VISCOSITY_SCAN(...)
   * ================================================================ */
   p_barcode      IN     VARCHAR2,
   p_viscosity    IN     VARCHAR2,
   p_deficit      IN     VARCHAR2,
   p_userid       IN     VARCHAR2,
   p_out          OUT    VARCHAR2)
IS
   lvi_count          NUMBER; -- [AI] 내부 처리용 변수
   
   lvs_item_code      VARCHAR2 (100); -- [AI] 내부 처리용 변수
   lvdt_valid_date    DATE; -- [AI] 내부 처리용 변수

BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.

   --------------------------------------------------
   -- 솔더라벨 유무 확인
   --------------------------------------------------
      SELECT count(*)
        INTO lvi_count
        FROM im_item_solder_master   
       WHERE item_barcode    = p_barcode
         AND ROWNUM          = 1
         AND organization_id = 1;              
         
  IF lvi_count = 0 THEN
  
           p_out :=  f_msg('미 등록된 솔더 바코드 입니다.', 'K', 1)   -- Not found Solder label info.
                     || ' = '
                     || p_barcode;
                     
           RETURN;
           
   END IF;
   
     
   --------------------------------------------------
   -- 솔더정보 조회
   --------------------------------------------------
  
      BEGIN
        
      SELECT count(*), NVL(max(item_code),'*'), max(valid_date)
        INTO lvi_count, lvs_item_code, lvdt_valid_date
        FROM im_item_solder_master   
       WHERE item_barcode    = p_barcode   
         AND   mix_end_date  IS NOT NULL
     --    AND viscosity_start_date IS NULL
         AND input_date      IS NULL
         AND organization_id = 1;    
         
     EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
        WHEN OTHERS THEN
             lvi_count          := 0;
             lvs_item_code      := 'NULL';
             lvdt_valid_date    :=  NULL;
     END;             
         
  IF lvi_count = 0 THEN
    
           p_out :=  f_msg('스캔한 솔더가 교반완료 상태이면서 미투입 상태가 아닙니다.', 'K', 1)   -- Not found Solder label info.
                     || ' = '
                     || p_barcode;
                     
           RETURN;
           
   END IF;
   

   --------------------------------------------------
   -- 솔더정보에 점도측정 정보 업데이트
   --------------------------------------------------
      
   IF ( p_deficit = 'N' ) THEN
      
        select count(*)
          into lvi_count
          from im_item_solder_master
         where item_barcode = p_barcode
           and viscosity is not null;
         
        IF ( lvi_count = 0 ) THEN
          
              update im_item_solder_master
                 set viscosity_start_date = sysdate,
                     viscosity_end_date   = sysdate,
                     viscosity            = p_viscosity,
                     viscosity_operator   = p_userid,
                     last_modify_date     = sysdate,
                     last_modify_by       = 'PDA SCAN' 
               where item_barcode         = p_barcode
                 AND ORGANIZATION_ID      = 1;
              
           --   IF ( SQL%ROWCOUNT > 0 ) THEN   -- 점도계설치 후 측정로그 기준으로 처리하기에 스캔한 solder 기준으로만 처리 함
              IF ( 1=2 ) THEN
                 
   /*          
                    update im_item_solder_master
                       set viscosity_end_date   = sysdate,
                           viscosity            = p_viscosity,
                           viscosity_operator   = p_userid,
                           last_modify_date     = sysdate,
                           last_modify_by       = p_userid 
                     where item_barcode         <> p_barcode              
                       and VALID_DATE           = lvdt_valid_date   -- 2020-04-16 김현동씨 요청 --  WHERE ITEM_BARCODE         like substr(lvs_barcode, 1,7)||'%' 
                       AND ITEM_CODE            = lvs_item_code
                       AND DESTROY_DATE         is null             -- 폐기된 솔더 확인
                       AND ORGANIZATION_ID      = 1;
   */                   
                       
    
               UPDATE IM_ITEM_SOLDER_MASTER
                  SET viscosity_start_date = sysdate,
                     viscosity_end_date   = sysdate,
                     viscosity            = p_viscosity,
                     viscosity_operator   = p_userid,
                     last_modify_date     = sysdate,
                     last_modify_by       = p_userid      
                WHERE VALID_DATE           = lvdt_valid_date   -- 2020-04-16 김현동씨 요청 --  WHERE ITEM_BARCODE         like substr(lvs_barcode, 1,7)||'%' 
                  AND ITEM_CODE            = LVS_ITEM_CODE
                  AND ITEM_BARCODE         > p_barcode
                  AND DESTROY_DATE         IS NULL             -- 폐기 안되고 
                  AND RECEIPT_DATE         IS NOT NULL         -- 냉장고 입고 후
                  AND ORGANIZATION_ID      = 1;
                                     
                       
              END IF;
                 
        ELSE
          
              update im_item_solder_master
                 set viscosity_start_date = sysdate,
                     viscosity_end_date   = sysdate,
                     last_modify_date     = sysdate,
                     last_modify_by       = 'PDA SCAN'  
               where item_barcode         = p_barcode
                 AND ORGANIZATION_ID      = 1;      
          
        END IF;
         
   ELSE
     
   --------------------------------------------------
   -- 솔더정보에 점도측정 정보 업데이트 취소
   --------------------------------------------------
     
        update im_item_solder_master
           set viscosity_start_date = NULL,
               viscosity_end_date   = NULL,
           --    viscosity            = NULL,
           --    viscosity_operator   = NULL,
               last_modify_date     = sysdate,
               last_modify_by       = 'PDA SCAN'   
         where item_barcode         = p_barcode
           AND ORGANIZATION_ID      = 1;
            
   END IF;
   
   
   COMMIT;
   
   p_out := 'OK';
   
EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN OTHERS THEN
     
        p_out := '[P_CHECK_SOLDER_VISCOSITY_SCAN] ' 
                 || SQLERRM;
                 
END;
