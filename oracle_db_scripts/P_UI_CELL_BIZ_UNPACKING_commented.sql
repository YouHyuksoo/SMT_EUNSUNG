CREATE OR REPLACE PROCEDURE "P_UI_CELL_BIZ_UNPACKING" (p_packcode in varchar2, p_out out varchar2 , p_outmsg out varchar2 ) is
  /* ================================================================
   * 프로시저명  : P_UI_CELL_BIZ_UNPACKING
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   프로시저 원본 로직의 업무 처리 흐름을 수행한다.
   *   참조 테이블과 입력 파라미터를 기반으로 조회, 등록, 갱신 또는 메시지 반환을 처리한다.
   *   원본 코드의 트랜잭션 및 예외 처리 흐름은 변경하지 않았다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_PACKCODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUTMSG - 원본 선언부 기준 입력/출력 파라미터
   *   PRAGMA - 원본 선언부 기준 입력/출력 파라미터
   *   P - 원본 선언부 기준 입력/출력 파라미터
   *   PACK_BARCODE - 원본 선언부 기준 입력/출력 파라미터
   *   PC - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_2D_BARCODE - 원본 로직 참조 테이블
   *   IP_PRODUCT_PACK_MASTER - 원본 로직 참조 테이블
   *   IP_PRODUCT_PACK_MASTER_DEL - 원본 로직 참조 테이블
   *   IP_PRODUCT_PACK_SERIAL - 원본 로직 참조 테이블
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
   *   EXEC P_UI_CELL_BIZ_UNPACKING(...)
   * ================================================================ */
pragma autonomous_transaction ; 
--P CREATE CELL BIZ BARCODE
lvl_checkSum number ;  -- [AI] 내부 처리용 변수

begin
   -- [AI] 주요 업무 처리 로직을 시작한다.
       lvl_checkSum := 9; 
             
       begin 
         
         select /*decode(x.boxing_flag,         'Y',1,0) + 
                decode(x.pallet_flag,         'Y',1,0) + 
                decode(x.ship_flag,           'Y',1,0) + */
                decode(nvl(x.receipt_flag,'N'),        'Y',1,0) 
           into lvl_checkSum
           from ip_product_pack_master x
          where x.pack_barcode = p_packcode ; 
          
       exception 
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
          when no_data_found then 
               lvl_checkSum := -1 ; 
       end; 
       
       if lvl_checkSum >= 1 then 
         
         p_out := 'NG';
         p_outmsg := f_msg('이미입고되었습니다','K',1); 
         
         return ; 
         
       elsif lvl_checkSum < 0 then 
         
         p_out := 'NG';
         p_outmsg :=  f_msg('데이터를 찾을수 없습니다' ,'K',1) 
                    ||p_packcode
                    ||f_msg('데이터를 찾을수 없습니다!','K',1); 
                    
         return ; 
         
       elsif lvl_checkSum = 0 then 
         
         --삭제 가능 일때 
         
           UPDATE IP_PRODUCT_2D_BARCODE 
              SET BOX_NO = NULL,
	                last_modify_date = sysdate,
		              last_modify_by   = 'UNPACK',
                  enter_by         = 'UNPACK'
            WHERE BOX_NO           = p_packcode ;
                     
           delete from ip_product_pack_serial 
           where pack_barcode = p_packcode ; 
           
           delete from ip_product_pack_master 
           where pack_barcode = p_packcode ; 
           
           insert into ip_product_pack_master_del (
                                                    pack_barcode, 
                                                    pack_type, 
                                                    model_name, 
                                                    part_no, 
                                                    pack_date, 
                                                    packing_pcs_qty, 
                                                    pack_qty, 
                                                    line_code, 
                                                    workstage_code, 
                                                    attr1, 
                                                    attr2, 
                                                    attr3, 
                                                    attr4, 
                                                    attr5, 
                                                    attr6, 
                                                    attr7, 
                                                    attr8, 
                                                    complete_flag, 
                                                    print_flag, 
                                                    receipt_flag, 
                                                    boxing_flag, 
                                                    pallet_flag, 
                                                    ship_flag, 
                                                    box_no, 
                                                    pallet_no, 
                                                    ship_no, 
                                                    receipt_no, 
                                                    receipt_date, 
                                                    boxing_date, 
                                                    pallet_date, 
                                                    ship_date, 
                                                    reprint, 
                                                    organization_id, 
                                                    enter_date, 
                                                    enter_by, 
                                                    last_modify_date, 
                                                    last_modify_by, 
                                                    model_suffix, 
                                                    customer_code, 
                                                    divide_flag, 
                                                    parent_barcode,
                                                    del_date,
                                                    del_pc           
                                                  )
           select pack_barcode, 
                  pack_type, 
                  model_name, 
                  part_no, 
                  pack_date, 
                  packing_pcs_qty, 
                  pack_qty, 
                  line_code, 
                  workstage_code, 
                  attr1, 
                  attr2, 
                  attr3, 
                  attr4, 
                  attr5, 
                  attr6, 
                  attr7, 
                  attr8, 
                  complete_flag, 
                  print_flag, 
                  receipt_flag, 
                  boxing_flag, 
                  pallet_flag, 
                  ship_flag, 
                  box_no, 
                  pallet_no, 
                  ship_no, 
                  receipt_no, 
                  receipt_date, 
                  boxing_date, 
                  pallet_date, 
                  ship_date, 
                  reprint, 
                  organization_id, 
                  enter_date, 
                  enter_by, 
                  last_modify_date, 
                  last_modify_by, 
                  model_suffix, 
                  customer_code, 
                  divide_flag, 
                  parent_barcode,
                  sysdate,                              -- 삭제일
                  sys_context('USERENV', 'IP_ADDRESS')  -- 삭제 PC
             from ip_product_pack_master 
            where pack_barcode = p_packcode ; 
  
       end if; 

        p_out := 'OK' ; 
        p_outmsg := f_msg('포장이 취소 되었습니다' ,'K',1) 
                 || p_packcode ||f_msg('취소완료','K',1);
        commit ; 

exception 
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
  when others then 
    
       p_out := 'NG' ; 
       p_outmsg := 'DB Error ' || substr(sqlerrm,1,200);
       
       rollback ;  
       return ; 
     
end p_ui_cell_biz_unpacking;
