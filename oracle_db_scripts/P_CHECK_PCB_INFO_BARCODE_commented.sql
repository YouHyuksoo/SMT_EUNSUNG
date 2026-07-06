CREATE OR REPLACE PROCEDURE "P_CHECK_PCB_INFO_BARCODE" (
  /* ================================================================
   * 프로시저명  : P_CHECK_PCB_INFO_BARCODE
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2016-08-29
   * 수정이력:
   *   2016-08-29 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   입력 조건을 기준으로 업무 데이터의 유효성 또는 상태를 확인한다.
   *   조회 결과와 원본 분기 조건에 따라 OUT 파라미터 또는 상태 값을 설정한다.
   *   호출부가 결과 코드와 메시지로 후속 처리를 판단할 수 있게 한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_PCB_BARCODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_INPUT_FIELD - 원본 선언부 기준 입력/출력 파라미터
   *   PART - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT_RESULT - 원본 선언부 기준 입력/출력 파라미터
   *   PCB - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT_TYPE - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT_PART_NO - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT_SUPPLIER - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT_QTY - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT_LOT_NO - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   없음 (순수 연산/외부 처리 프로시저)
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_GET_PCB_INFO_FROM_BARCODE
   * ================================================================
   * [AI 분석] 예외 처리:
   *   원본 EXCEPTION 절의 반환값, RAISE, COMMIT/ROLLBACK 흐름을 변경하지 않는다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 구현 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_CHECK_PCB_INFO_BARCODE(...)
   * ================================================================ */
                                                      p_pcb_barcode       IN     VARCHAR2,   -- scan된 barcode 정보
                                                      p_input_field       IN     VARCHAR2,   -- P:part no, V:supplier, Q:Qty, H:Lot No, 입력 filed 위치     
                                                          
                                                      p_out_result        OUT    VARCHAR2,   -- PCB barcode 검토 결과 OK/NG
                                                      p_out_type          OUT    VARCHAR2,   -- U:통합, S:개별
                                                      p_out_part_no       OUT    VARCHAR2,   -- PCB barcode 내 part no
                                                      p_out_supplier      OUT    VARCHAR2,   -- PCB barcode 내 supplier
                                                      p_out_qty           OUT    VARCHAR2,   -- PCB barcode 내 qty
                                                      p_out_lot_no        OUT    VARCHAR2    -- PCB barcode 내 lot no                  
                                                     )
IS

   lvs_type   VARCHAR2(10); -- [AI] 내부 처리용 변수
                            
BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.
  
   --------------------------------------------------------------------------------------------------------------------------------------------------
   -- 2016/08/29 SHS, Laser marking 시 PCB 정보 등록을 위한 PCB barcode 정보 parsing
   --------------------------------------------------------------------------------------------------------------------------------------------------
   
   -- return 변수 초기화
  
   p_out_result   := 'NG';
   p_out_type     := '';
   
   p_out_part_no  := '';   
   p_out_supplier := '';     
   p_out_qty      := '';     
   p_out_lot_no   := '';


   -- 통합 Barcode check
         
   IF  (SUBSTR(p_pcb_barcode, 1,6) = '[)>@06') or (SUBSTR(p_pcb_barcode, 1,6) = '[)>'||CHR(30)||'06')  or (REGEXP_COUNT(p_pcb_barcode, ',') = 3 or (SUBSTR(p_pcb_barcode, 1,5) = '[)>06')) THEN
      
        p_out_type := 'U';
        
        BEGIN
          
           SELECT F_GET_PCB_INFO_FROM_BARCODE(p_pcb_barcode, 'P'),
                  F_GET_PCB_INFO_FROM_BARCODE(p_pcb_barcode, 'V'),
                  F_GET_PCB_INFO_FROM_BARCODE(p_pcb_barcode, 'Q'),
                  F_GET_PCB_INFO_FROM_BARCODE(p_pcb_barcode, 'S')
             INTO p_out_part_no,       
                  p_out_supplier,      
                  p_out_qty,           
                  p_out_lot_no
             FROM dual;
             
        END; 
        
        p_out_result := 'OK';
        
   ELSE
     
   -- 개별 Barcode 확인
   
       p_out_type := 'S';
   
       lvs_type := substr(p_pcb_barcode, 1,1);
              
       -- Part no
       IF    lvs_type = 'P' then
         
             BEGIN
                
                SELECT F_GET_PCB_INFO_FROM_BARCODE(p_pcb_barcode, 'P')                  
                  INTO p_out_part_no      
                  FROM dual;
             
             END;
             
             p_out_result := 'OK';
      
       -- supplier       
       ELSIF lvs_type = 'V' THEN
       
             BEGIN
               
                SELECT F_GET_PCB_INFO_FROM_BARCODE(p_pcb_barcode, 'V')                   
                  INTO p_out_supplier      
                  FROM dual;
             
             END;
             
             p_out_result := 'OK';

       -- qty    
       ELSIF lvs_type = 'Q' then
       
             begin
               
                SELECT F_GET_PCB_INFO_FROM_BARCODE(p_pcb_barcode, 'Q')                  
                  INTO p_out_qty       
                  FROM dual;
             
             END;
             
             p_out_result := 'OK';

       -- Lot no
       ELSIF lvs_type = 'H' or lvs_type = 'S'then      
       
             BEGIN
               
                SELECT F_GET_PCB_INFO_FROM_BARCODE(p_pcb_barcode, 'S')                  
                  INTO p_out_lot_no      
                  FROM dual;
             
             END;
             
             p_out_result := 'OK';

       ELSE
         
              p_out_result   := 'NG';
              
              p_out_part_no  := '';   
              p_out_supplier := '';     
              p_out_qty      := '';     
              p_out_lot_no   := '';
         
       END IF;  
     
   END IF;   
                  
   
EXCEPTION
  
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN OTHERS THEN
     
       p_out_result   := 'NG';
       p_out_type     := '';
   
       p_out_part_no  := '';   
       p_out_supplier := '';     
       p_out_qty      := '';     
       p_out_lot_no   := '';
          
END;