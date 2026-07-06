CREATE OR REPLACE PROCEDURE PS_PROD_WS_IO_SPLIT_MAGAZINE( 
  /* ================================================================
   * 프로시저명  : PS_PROD_WS_IO_SPLIT_MAGAZINE
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2018-04-11
   * 수정이력:
   *   2018-04-11 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   프로시저 원본 로직의 업무 처리 흐름을 수행한다.
   *   참조 테이블과 입력 파라미터를 기반으로 조회, 등록, 갱신 또는 메시지 반환을 처리한다.
   *   원본 코드의 트랜잭션 및 예외 처리 흐름은 변경하지 않았다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_ORG - 원본 선언부 기준 입력/출력 파라미터
   *   P_MAGAZINE_NO - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT - 원본 선언부 기준 입력/출력 파라미터
   *   P_MSG - 원본 선언부 기준 입력/출력 파라미터
   *   PRODUCT - 원본 선언부 기준 입력/출력 파라미터
   *   PARENT_MAGAZINE_LABEL_NO - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_RUN_CARD_IO - 원본 로직 참조 테이블
   *   IP_PRODUCT_WORKSTAGE_IO - 원본 로직 참조 테이블
   * ================================================================
   * [AI 분석] 예외 처리:
   *   원본 EXCEPTION 절의 반환값, RAISE, COMMIT/ROLLBACK 흐름을 변경하지 않는다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 구현 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC PS_PROD_WS_IO_SPLIT_MAGAZINE(...)
   * ================================================================ */
                                                          p_org         in  number, 
                                                          p_magazine_no in  varchar2, 
                                                          p_out         out varchar2, 
                                                          p_msg         out varchar2 
                                                        ) is
/*********************************************************************
* 매거진 라벨 분할 실행시 Workstage IO 의 현재 공정 ( 최종 공정 ) 에 대하여 
* 원라벨을 재고 0 으로 하고, 
* 분리라벨을 해당 공정으로 재고 생성 하는 로직 
* 2018.04.11
* 
* p_magazine_no 은 분할 원 라벨임 
**********************************************************************/
lvs_workstage_code varchar2(30);  -- [AI] 내부 처리용 변수
lvl_wip_seq        number ; -- [AI] 내부 처리용 변수
lvl_lot_qty        number ;   -- [AI] 내부 처리용 변수

begin
   -- [AI] 주요 업무 처리 로직을 시작한다.
  /*******************************************************
   * 1. 해당 매거진이 WorkStage IO 로 Transaction 있는지 확인 한다. 
   *******************************************************/
  BEGIN 
    SELECT x.workstage_code, x.wip_seq, x.io_qty       
      INTO lvs_workstage_code, lvl_wip_seq , lvl_lot_qty 
      FROM IP_PRODUCT_WORKSTAGE_IO x 
     WHERE x.organization_id = p_org
       AND x.serial_no       = p_magazine_no
       AND x.io_deficit      = 'I'            -- 입고된 상태 ( 재고로 남아 있는 상태 )  
    ; 
  EXCEPTION 
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
    WHEN NO_DATA_FOUND THEN 
      p_out := 'OK'; 
      p_msg := '재고정리할 데이터가 없습니다.'; 
      return ; 
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
    WHEN OTHERS THEN 
      p_out := 'NG'; 
      p_msg := 'WS Check Error : '||substr(sqlerrm,1,100) ; 
      return ; 
  END ; 
  
  /*******************************************************
  * 2. 분할 할 Work Stage IO 가 확인 이 되면 원 라벨 재고 0 으로 업데이트 후 
  *    product run card io 를 기준으로 해당 공정으로 입고 작업 ( 재고생성 )을 한다. 
  * 
  *******************************************************/
  
  /*2.1 원라벨 재고 없애기 */
  UPDATE IP_PRODUCT_WORKSTAGE_IO IP 
     SET IP.IO_QTY          = 0, 
         IP.IO_DEFICIT      = 'S'         --분할 시킴 
   WHERE IP.Workstage_Code  = lvs_workstage_code
     AND IP.IO_DEFICIT      = 'I' 
     AND IP.WIP_SEQ         = lvl_wip_seq 
     AND IP.ORGANIZATION_ID = p_org
     AND IP.SERIAL_NO       = p_magazine_no  ; 

  /*원라벨에서 파생된 자식 라벨을 찾습니다.*/
  /**/
  FOR C01 IN ( 
    SELECT RC.MAGAZINE_LABEL_NO, 
           RC.LOT_QTY, 
           ROWNUM    AS ROWCNT          
      FROM IP_PRODUCT_RUN_CARD_IO RC 
     WHERE RC.PARENT_MAGAZINE_LABEL_NO = p_magazine_no
       AND RC.ORGANIZATION_ID          = p_org
  ) LOOP
   
    INSERT INTO IP_PRODUCT_WORKSTAGE_IO ( 
        io_date, 
        io_sequence, 
        run_no, 
        item_code, 
        serial_no, 
        line_code, 
        workstage_code, 
        io_deficit, 
        io_qty, 
        organization_id, 
        enter_date, 
        enter_by, 
        last_modify_date, 
        last_modify_by, 
        out_date, 
        model_name, 
        model_suffix, 
        workstage_type, 
        dest_line_code, 
        dest_workstage_code, 
        wip_seq, 
        lot_no, 
        /*actual_date, 
        shift_code, 
        work_time_zone, */
        from_line_code, 
        from_workstage_code, 
        /*actual_yyymmdd,*/ 
        split_flag, 
        origin_serial_no
    ) 
     SELECT sysdate, 
            SEQ_MAGAZINE_RECEIPT_SEQUENCE.NEXTVAL, 
            run_no, 
            item_code, 
            c01.magazine_label_no,      --분할 라벨  
            line_code, 
            workstage_code, 
            'I', 
            c01.lot_qty,                --불할 수량 
            
            organization_id, 
            SYSDATE, 
            'SPLIT', 
            SYSDATE, 
            'SPLIT', 
            
            out_date, 
            model_name, 
            model_suffix, 
            workstage_type, 
            dest_line_code, 
            dest_workstage_code, 
            
            wip_seq + c01.rowcnt,        --wip_seq, 
            
            lot_no, 
            /*actual_date, 
            shift_code, 
            work_time_zone,*/ 
            from_line_code, 
            from_workstage_code, 
            /*actual_yyymmdd, */
            'Y',                  --분할 
            serial_no             --불할 오리진 
      FROM IP_PRODUCT_WORKSTAGE_IO
     WHERE Workstage_Code  = lvs_workstage_code
       AND IO_DEFICIT      = 'S'                        --'S' 로 바꿨음. 
       AND WIP_SEQ         = lvl_wip_seq 
       AND ORGANIZATION_ID = p_org
       AND SERIAL_NO       = p_magazine_no  ;  
    
  END LOOP ;    
  
  
  p_out := 'OK'; 
  p_msg := 'Success Split Magazine'; 
 /* select *
    from ip_product_run_card_io x
     
    
  select *
    from ip_product_workstage_io*/ 
exception 
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
  when others then 
    p_out := 'NG' ; 
    p_msg := substr(sqlerrm,1,100); 

end PS_PROD_WS_IO_SPLIT_MAGAZINE;
