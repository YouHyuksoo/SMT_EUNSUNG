CREATE OR REPLACE PROCEDURE "P_PRODUCT_FG_INV_DEVIDE" (p_barcode varchar2, p_div_qty number,  p_commit varchar2, p_out out varchar2, p_msg out varchar2) is
  /* ================================================================
   * 프로시저명  : P_PRODUCT_FG_INV_DEVIDE
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
   *   P_DIV_QTY - 원본 선언부 기준 입력/출력 파라미터
   *   P_COMMIT - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT - 원본 선언부 기준 입력/출력 파라미터
   *   P_MSG - 원본 선언부 기준 입력/출력 파라미터
   *   PACK - 원본 선언부 기준 입력/출력 파라미터
   *   PACK_TYPE - 원본 선언부 기준 입력/출력 파라미터
   *   PALLET_FLAG - 원본 선언부 기준 입력/출력 파라미터
   *   PACK_QTY - 원본 선언부 기준 입력/출력 파라미터
   *   PACK_BARCODE - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_FG_INVENTORY - 원본 로직 참조 테이블
   *   IP_PRODUCT_PACK_MASTER - 원본 로직 참조 테이블
   *   IP_PRODUCT_PACK_SERIAL - 원본 로직 참조 테이블
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_MSG
   *   P_PRODUCT_FG_RECEIPT
   * ================================================================
   * [AI 분석] 예외 처리:
   *   원본 EXCEPTION 절의 반환값, RAISE, COMMIT/ROLLBACK 흐름을 변경하지 않는다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 구현 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_PRODUCT_FG_INV_DEVIDE(...)
   * ================================================================ */
   /****************************************************
    *재고 분할
    *  1. 원 바코드 수불 정리 해준다 입고 취소
    *  2. 분할 A -> B, C 로 분할 된다.
    *  3. Pack Master , Pack Serial 생성 해주고
    *  4, 분할된 Serial 모두 입고 처리 한다.
    ****************************************************/
    lvl_inv_qty number ; -- [AI] 내부 처리용 변수
    lvs_out  varchar2(4000); -- [AI] 내부 처리용 변수
    lvs_oMsg varchar2(4000); -- [AI] 내부 처리용 변수
begin
   -- [AI] 주요 업무 처리 로직을 시작한다.
    /******************************
    * 바코드 확인
    ******************************/
    begin
      select qty
        into lvl_inv_qty
        from ip_product_fg_inventory x
       where barcode  = p_barcode
         and pack_type   = 'M'  --메거진 라벨이고
         and pallet_flag = 'N'  --파렛 되지 않은
       ;
    exception
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      when no_data_found then
        p_out := 'NG' ;
        p_msg := f_msg('존재하지 않는 Barcode 입니다.','C',1);
        return ;
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      when others then
        p_out := 'NG';
        p_msg := substr(sqlerrm,1,200);
        return ;
    end ;


    /******************************
    * 입고 취소 를 한다.
    *******************************/
    P_PRODUCT_FG_RECEIPT(p_barcode, 'P01',  '2',  'N', lvs_out, lvs_oMsg) ;

    if lvs_out = 'NG' then
      if p_commit = 'Y' then
         rollback ;
      end if;
      p_out := 'NG';
      p_msg := lvs_oMsg ;
      return ;
    end if ;


    /*****************************
    * Pack Master / Serial 분할
    ******************************/
    insert into ip_product_pack_master (
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
          parent_barcode,
          divide_flag

     )
     select pack_barcode||'-'||decode(lvl,1,'A','B'),
        pack_type,
        model_name,
        part_no,
        sysdate,
        packing_pcs_qty,
        decode(lvl,1, pack_qty - p_div_qty, p_div_qty),
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
        'Y',
        'Y',
        'N',
        'N',
        'N',
        'N',
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
        sysdate,
        'FG_DIVDE',
        sysdate,
        'FG_DEVIDE',
        model_suffix,
        customer_code,
        pack_barcode,
        'N'
  from ip_product_pack_master  ,
       ( select level lvl
          from dual
          connect by level < 3 )
 where pack_barcode = p_barcode ;



 update ip_product_pack_master
    set divide_flag = 'Y',
        last_modify_date = sysdate,
        last_modify_by   = 'FG_DEVIDE'
  where pack_barcode = p_barcode ;

  insert into ip_product_pack_serial (
      barcode,
      pack_barcode,
      workstage_code,
      line_code,
      run_no,
      attr1,
      attr2,
      attr3,
      attr4,
      attr5,
      attr6,
      attr7,
      attr8,
      attr9,
      attr10,
      attr11,
      attr12,
      final_inspect_date,
      final_inspect_flag,
      scan_date,
      organization_id,
      enter_date,
      enter_by,
      last_modify_date,
      last_modify_by,
      barcode_qty

  )
  select barcode||'-'||decode(lvl,1,'A','B'),
        pack_barcode||'-'||decode(lvl,1,'A','B'),
        workstage_code,
        line_code,
        run_no,
        attr1,
        attr2,
        attr3,
        attr4,
        attr5,
        attr6,
        attr7,
        attr8,
        attr9,
        attr10,
        attr11,
        attr12,
        final_inspect_date,
        final_inspect_flag,
        scan_date,
        organization_id,
        sysdate,
        enter_by,
        sysdate,
        last_modify_by,
        decode(lvl,1, barcode_qty - p_div_qty, p_div_qty )
  from ip_product_pack_serial ,
       ( select level lvl
          from dual
          connect by level < 3 )
 where barcode = p_barcode ;




   /******************************
    * 분할 건 입고 한다.
    *******************************/
    P_PRODUCT_FG_RECEIPT(p_barcode||'-A', 'P01',  '1',  'N', lvs_out, lvs_oMsg) ;

    if lvs_out = 'NG' then
      if p_commit = 'Y' then
         rollback ;
      end if;
      p_out := 'NG';
      p_msg := lvs_oMsg ;
      return ;
    end if ;


    /******************************
    * 분할 건 입고 .
    *******************************/
    P_PRODUCT_FG_RECEIPT(p_barcode||'-B', 'P01',  '1',  'N', lvs_out, lvs_oMsg) ;


    if lvs_out = 'NG' then
      if p_commit = 'Y' then
         rollback ;
      end if;
      p_out := 'NG';
      p_msg := lvs_oMsg ;
      return ;
    end if ;


     if p_commit = 'Y' then
         commit ;
     end if;

     p_out := 'OK' ;
     p_msg := p_barcode||'-'||'A'||':'|| p_barcode||'-'||'B' ;




exception
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
  when others then
    p_out := 'NG' ;
    p_msg := substr(sqlerrm,1,200);

    if p_commit = 'Y' then
      rollback ;
    end if;

end P_PRODUCT_FG_INV_DEVIDE;