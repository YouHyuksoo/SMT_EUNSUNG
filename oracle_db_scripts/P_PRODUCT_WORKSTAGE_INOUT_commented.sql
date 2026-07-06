CREATE OR REPLACE PROCEDURE "P_PRODUCT_WORKSTAGE_INOUT" (p_barcode varchar2, p_line varchar2, P_workstage varchar2,  p_txn number,  p_commit varchar2, p_out out varchar2, p_msg out varchar2) is
  /* ================================================================
   * 프로시저명  : P_PRODUCT_WORKSTAGE_INOUT
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   제품, 재고, 입출고 관련 업무 데이터를 등록 또는 갱신한다.
   *   대상 데이터의 존재 여부와 수량 조건을 확인한 뒤 원본 로직에 따라 처리한다.
   *   COMMIT/ROLLBACK 포함 여부는 원본 트랜잭션 흐름을 그대로 유지한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_BARCODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_LINE - 원본 선언부 기준 입력/출력 파라미터
   *   P_WORKSTAGE - 원본 선언부 기준 입력/출력 파라미터
   *   P_TXN - 원본 선언부 기준 입력/출력 파라미터
   *   P_COMMIT - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT - 원본 선언부 기준 입력/출력 파라미터
   *   P_MSG - 원본 선언부 기준 입력/출력 파라미터
   *   PID - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_RUN_CARD_IO - 원본 로직 참조 테이블
   *   IP_PRODUCT_WORKSTAGE_IO - 원본 로직 참조 테이블
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
   *   EXEC P_PRODUCT_WORKSTAGE_INOUT(...)
   * ================================================================ */
   /****************************************************
    * 공정인아웃 스캔
    *
    * 1. 공정 이동라벨을 스캔하여 통과이력을 남긴다 
    *    화면에서는 interlock 등 check 하는 내용이 많으나
    *    여기서는 다순 통과이력을 남기는 것으로 구현한다
    ****************************************************/

    lvs_item_code    varchar2(50);  -- [AI] 내부 처리용 변수
    lvs_model_name   varchar2(50);  -- [AI] 내부 처리용 변수
    lvs_model_suffix varchar2(50);  -- [AI] 내부 처리용 변수
    lvs_run_no       varchar2(50);  -- [AI] 내부 처리용 변수
    lvl_lot_qty      number; -- [AI] 내부 처리용 변수
    
    LVS_DEST_LINE_CODE        varchar2(50);  -- [AI] 내부 처리용 변수
    LVS_DEST_WORKSTAGE_CODE   varchar2(50);  -- [AI] 내부 처리용 변수
    LVL_WIP_SEQ               number; -- [AI] 내부 처리용 변수
    LVL_LAST_WIP_SEQ          number; -- [AI] 내부 처리용 변수
    
    lvl_count                 number; -- [AI] 내부 처리용 변수
    
begin
   -- [AI] 주요 업무 처리 로직을 시작한다.
   
    -- ***********************************
    -- 매거진 라벨 확인
    -- ***********************************
    
    BEGIN
      
        SELECT item_code,     model_name,     nvl(model_suffix , '*'), run_no ,    lot_qty
          INTO lvs_item_code, lvs_model_name, lvs_model_suffix,       lvs_run_no , lvl_lot_qty
          FROM IP_PRODUCT_RUN_CARD_IO
         WHERE MAGAZINE_LABEL_NO  = p_barcode
           and rownum = 1 ;		
     
    exception 
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
       when NO_DATA_FOUND then 
            p_out := 'NG' ; 
            p_msg := '미등록 이동 라벨 입니다' ;
            return;
    END;
        
    -- ************************************************************
    -- PID 처리가 아니기에 불량 확인 SKIP : IP_PRODUCT_WORK_QC
    -- ************************************************************
    
    -- ************************************************************
    -- 작업유형 구분
    -- ************************************************************      
    
    IF ( p_txn = 1 ) THEN
      
    -- ************************************************************
    -- 이동처리
    -- ************************************************************  
    
    
         SELECT COUNT(*) 
				   INTO lvl_count 
				   FROM  IP_PRODUCT_WORKSTAGE_IO
					WHERE SERIAL_NO      = p_barcode
					  AND LINE_CODE      = p_line
					  AND WORKSTAGE_CODE = p_workstage
					  AND IO_DEFICIT     = 'I' ;     -- 해당 공정을 빠져 나가지 못한 데이터 
            
        IF ( lvl_count > 0 ) THEN
             p_out := 'NG' ; 
             p_msg := '이미 이동 된 바코드 입니다' ;
             return;
        ELSE
          
/*             -- 이전처리 이력 찾기
             SELECT nvl(max(wip_seq),0)
							 into LVL_LAST_WIP_SEQ
						   FROM IP_PRODUCT_WORKSTAGE_IO
						  where serial_no  = p_barcode
                and io_deficit = 'I'  ;         
          
             -- 이전 처리이력을 투입에서 완성상태 변경   
             UPDATE IP_PRODUCT_WORKSTAGE_IO 
								SET IO_DEFICIT          = 'O' , 
									  OUT_DATE            = sysdate  , 
									  DEST_LINE_CODE      = p_line , 
									  DEST_WORKSTAGE_CODE = p_workstage
							where SERIAL_NO           = p_barcode
							  and io_deficit          = 'I' 
							  and wip_seq             = LVL_LAST_WIP_SEQ ;	
*/
                        
             INSERT INTO IP_PRODUCT_WORKSTAGE_IO (
                                                   IO_DATE,   
                                   								 IO_SEQUENCE,   
                                    							 RUN_NO,   
							                                   	 ITEM_CODE,   
								                                   SERIAL_NO,   
								                                   LINE_CODE,   
								                                   WORKSTAGE_CODE,   
								                                   IO_DEFICIT,   
								                                   IO_QTY,   
								                                   ORGANIZATION_ID,   
								                                   ENTER_DATE,   
								                                   ENTER_BY,   
								                                   LAST_MODIFY_DATE,   
								                                   LAST_MODIFY_BY ,
								                                   MODEL_NAME ,
								                                   MODEL_SUFFIX,
								                                   WORKSTAGE_TYPE 
                                                )  
						                              VALUES (
                                                   SYSDATE,   
                                                   SEQ_MAGAZINE_RECEIPT_SEQUENCE.NEXTVAL,
							                                     lvs_run_no,
							                                     LVS_ITEM_CODE,   
							                                     p_barcode,
							                                     p_line,   
							                                     p_workstage,   
							                                     'I' , --IO_DEFICIT,   
							                                     lvl_lot_qty,   
							                                     1,
							                                     SYSDATE , 
							                                     'PDA',   
							                                     SYSDATE,   
							                                     'PDA', 
							                                     lvs_model_name,
                                                   lvs_model_suffix,
                                                   'I'
							                                   ) ;        
                       
        END IF;
        
    ELSE
    -- ************************************************************
    -- 취소처리
    -- ************************************************************  
    
        SELECT COUNT(*)  --, MAX(DEST_LINE_CODE),  MAX(DEST_WORKSTAGE_CODE),  MAX(WIP_SEQ)
			    INTO lvl_count --, LVS_DEST_LINE_CODE,   LVS_DEST_WORKSTAGE_CODE,   LVL_WIP_SEQ
				  from IP_PRODUCT_WORKSTAGE_IO 
			   where SERIAL_NO       = p_barcode
			     and line_code       = p_line
				   and workstage_code  = p_workstage
				   and io_deficit      = 'I' ; 
             
    
        IF ( lvl_count = 0 ) THEN
             p_out := 'NG' ; 
             p_msg := '해당 라인과 공정에 이동 된 이력이 없습니다' ;
             return;
        ELSE
 
/*         
             -- 이전처리 이력 찾기
             SELECT nvl(max(wip_seq),0)
							 into LVL_LAST_WIP_SEQ
						   FROM IP_PRODUCT_WORKSTAGE_IO
						  where serial_no = p_barcode
							  and wip_seq   < LVL_WIP_SEQ ;               
                
             -- 이전 처리이력을 완료에서 투입상태 변경   
             UPDATE IP_PRODUCT_WORKSTAGE_IO 
								SET IO_DEFICIT          = 'I' , 
									  OUT_DATE            = NULL  , 
									  DEST_LINE_CODE      = NULL , 
									  DEST_WORKSTAGE_CODE = NULL
							where SERIAL_NO           = p_barcode
						--	  and dest_line_code      = LVS_DEST_LINE_CODE
						--	  and dest_workstage_code = LVS_DEST_WORKSTAGE_CODE
							  and io_deficit          = 'O' 
							  and wip_seq             = LVL_LAST_WIP_SEQ ;	
                
*/
              
              -- 현재이력 삭제                  
					  	delete from IP_PRODUCT_WORKSTAGE_IO 
							  where  SERIAL_NO        = p_barcode 
							   and line_code          = p_line
								 and workstage_code     = p_workstage
								 and io_deficit         = 'I' ;
					 --			 and wip_seq            = LVL_WIP_SEQ ;       
                 
           --   if ( SQL%ROWCOUNT = 0 ) THEN
           --        p_out := 'NG' ; 
           --        p_msg := '투입이력 대비 삭제 할 이력이 없습니다' ;    
           --        return;          
           --   end if;
                         
        END IF;
          
    END IF;    
    
    
    -- ************************************************************
    -- 완료처리
    -- ************************************************************ 
        
    if p_commit = 'Y' then 
       commit ; 
    end if; 
    
    p_out := 'OK'; 
    
    if p_txn = 1 then 
       p_msg := f_msg('정상 이동처리 되었습니다.','C',1);
    else 
       p_msg := f_msg('정상 취소처리 되었습니다.','C',1);
    end if; 
    
exception 
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
  when others then 
    p_out := 'NG' ; 
    p_msg := substr(sqlerrm,1,200); 
    
    if p_commit = 'Y' then 
       rollback ; 
    end if; 
      
end P_PRODUCT_WORKSTAGE_INOUT;
