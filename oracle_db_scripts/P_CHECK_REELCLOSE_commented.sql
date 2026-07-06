CREATE OR REPLACE PROCEDURE "P_CHECK_REELCLOSE" (
  /* ================================================================
   * 프로시저명  : P_CHECK_REELCLOSE
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-11-16
   * 수정이력:
   *   2020-11-16 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   입력 조건을 기준으로 업무 데이터의 유효성 또는 상태를 확인한다.
   *   조회 결과와 원본 분기 조건에 따라 OUT 파라미터 또는 상태 값을 설정한다.
   *   호출부가 결과 코드와 메시지로 후속 처리를 판단할 수 있게 한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_REEL_BCR - 원본 선언부 기준 입력/출력 파라미터
   *   P_DEFICIT - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IB_PRODUCT_PLANDATA - 원본 로직 참조 테이블
   *   IB_SMT_CHECKHIST - 원본 로직 참조 테이블
   *   IM_ITEM_BAKING_MASTER - 원본 로직 참조 테이블
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
   *   EXEC P_CHECK_REELCLOSE(...)
   * ================================================================ */
                                                 p_reel_bcr varchar2, 
                                                 p_deficit  varchar2, 
                                                 p_out out  varchar2
                                                ) is
   lvs_reel_destroy_yn   varchar2(10);   -- [AI] 내부 처리용 변수
   lvs_ISSUE_COMPARE_YN  varchar2(10);  -- [AI] 내부 처리용 변수
   LVS_FEEDING_YN        varchar2(10);  -- [AI] 내부 처리용 변수
   
   LVS_LOT_NO            varchar2(10);  -- [AI] 내부 처리용 변수
   
   LVL_COUNT             number; -- [AI] 내부 처리용 변수
   LVS_RET_MESSAGE       varchar2(100);  -- [AI] 내부 처리용 변수
 
begin
   -- [AI] 주요 업무 처리 로직을 시작한다.
  
   BEGIN
     
       SELECT NVL(REEL_DESTROY_YN,'N'), NVL(ISSUE_COMPARE_YN,'N'), NVL(FEEDING_YN,'N'), LOT_NO
         INTO LVS_REEL_DESTROY_YN, lvs_ISSUE_COMPARE_YN, LVS_FEEDING_YN, LVS_LOT_NO            
         FROM IM_ITEM_RECEIPT_BARCODE
        WHERE ITEM_BARCODE = P_REEL_BCR;
   
   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN OTHERS THEN
                 
           P_OUT := F_MSG('[REEL CLOSE] 등록되지 않은 바코드 입니다.', 'K', 1)    --  NOT FOUND MATERIAL BARCODE
                    || ' = '   
                    || P_REEL_BCR;
                  
           RETURN ;
    
   END ;
   
   IF ( lvs_ISSUE_COMPARE_YN <> 'Y' ) THEN
     
        P_OUT := F_MSG('[REEL CLOSE] 출고되지 않은 바코드 입니다.', 'K', 1)    --  NOT ISSUE MATERIAL BARCODE
                 || ' = '   
                 || P_REEL_BCR;
                 
        RETURN ;
     
   END IF;
   
   IF ( LVS_REEL_DESTROY_YN = 'Y'  AND p_deficit = 'N'  ) THEN
     
        P_OUT := F_MSG('[REEL CLOSE] 이미 종료된 바코드 입니다.', 'K', 1)    --  ALREADY CLOSE MATERIAL BARCODE
                 || ' = '   
                 || P_REEL_BCR;
                 
        RETURN ;
        
   END IF;     
   
   ---------------------------------------------------------------------------
   -- 베이킹에 입고된 자재인지 확인 한다
   ---------------------------------------------------------------------------
         
   SELECT COUNT(*), 
          MAX(DECODE(CHAMBER_TYPE, 'B', '베이킹', 'D', '제습함', 'V', '진공포장', CHAMBER_TYPE) || ' 재고 입니다')
     INTO LVL_COUNT, LVS_RET_MESSAGE
     FROM IM_ITEM_BAKING_MASTER
    WHERE ITEM_BARCODE     = P_REEL_BCR
      AND INPUT_SCAN_DATE  IS NOT NULL
      AND OUTPUT_SCAN_DATE IS NULL;
   
   
   IF ( LVL_COUNT > 0) THEN
     
        P_OUT := F_MSG('[REEL CLOSE] '||LVS_RET_MESSAGE, 'K', 1)    --  NOT ISSUE MATERIAL BARCODE
                 || ' = '   
                 || P_REEL_BCR;
                 
        RETURN ;
     
   END IF;     

   ---------------------------------------------------------------------------
   --  장착이력이 존재하는지 확인
   ---------------------------------------------------------------------------         
   
   LVL_COUNT := 0;
   
   SELECT COUNT(*)
     INTO LVL_COUNT
     FROM IB_SMT_CHECKHIST
    WHERE SCAN_PARTNAME = P_REEL_BCR;
 
  

 IF ( LVL_COUNT = 0 ) THEN
     
        P_OUT := F_MSG('[REEL CLOSE] 장착이력이 존재하지 않는 자재 입니다.', 'K', 1)    --  NOT FEED MATERIAL BARCODE
                 || ' = '   
                 || P_REEL_BCR;
                 
        RETURN ;
     
   END IF;
   

	
      
     IF ( p_deficit = 'N' ) THEN
        
   ---------------------------------------------------------------------------
   --  2020/11/16, SHS : 장착된 자재인지 체크 
   ---------------------------------------------------------------------------    
   
          SELECT count(*)
            INTO LVL_COUNT
            FROM ib_product_plandata
           WHERE lot_no     = LVS_LOT_NO
             AND active_yn  = 'Y'
             AND ROWNUM     = 1 ;
        
          IF ( LVL_COUNT > 0 ) THEN
           
              P_OUT := F_MSG('[REEL CLOSE] 현재 장착된 바코드 입니다.', 'K', 1)    
                       || ' = '   
                       || P_REEL_BCR;
                       
              RETURN ;    
               
          ELSE    
            
             
                 UPDATE IM_ITEM_RECEIPT_BARCODE
                    SET REEL_DESTROY_YN   = 'Y',
                        reel_destroy_date = sysdate,
                        MSL_PASSED_TIME   = NVL(MSL_PASSED_TIME,0) + ((SYSDATE - NVL(MSL_OPEN_DATE,SYSDATE)) * 24),
                        LAST_MODIFY_DATE  = SYSDATE,
                        MSL_OPEN_DATE     = NULL
                  WHERE ITEM_BARCODE      = P_REEL_BCR;
                  
           END IF;
     
     ELSE
       
           UPDATE IM_ITEM_RECEIPT_BARCODE
              SET REEL_DESTROY_YN   = 'N',
                  reel_destroy_date = NULL,
                  LAST_MODIFY_DATE  = SYSDATE
            WHERE ITEM_BARCODE      = P_REEL_BCR;       
       
     END IF;
    	
     
   COMMIT; 
   
   p_out := 'OK';
   
EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN OTHERS THEN
     
        p_out := 'NG, [P_CHECK_REELCLOSE] ' 
                 || SQLERRM;   
  
end ;
