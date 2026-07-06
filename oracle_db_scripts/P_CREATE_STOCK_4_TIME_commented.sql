CREATE OR REPLACE PROCEDURE "P_CREATE_STOCK_4_TIME" is
  /* ================================================================
   * 프로시저명  : P_CREATE_STOCK_4_TIME
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   정해진 시점의 자재 재고 스냅샷을 IM_ITEM_INVENTORY_4_TIME에 생성한다.
   *   재고/품목/위치 정보를 집계하여 시간대별 재고 이력으로 저장하는 배치성 프로시저이다.
   *   원본 주석 기준 매일 오전 6시에 자동 실행되는 용도로 보인다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   없음
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IM_ITEM_INVENTORY_4_TIME - 시간대별 자재 재고 스냅샷 테이블
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN OTHERS/NO_DATA_FOUND 등 원본 예외 처리 흐름을 유지한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 로직 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_CREATE_STOCK_4_TIME
   * ================================================================ */
/*매일 오전 6시에 자동 실행*/
begin
   -- [AI] 주요 업무 처리 로직을 시작한다.
  INSERT INTO  IM_ITEM_INVENTORY_4_TIME (
    inventory_time,
    warehouse_type,
    item_code,
    organization_id,
    line_type,
    inventory_hold,
    inventory_price,
    inventory_qty,
    inventory_amt,
    reel_qty,
    last_inventory_qty,
    time_inv_qty,
    ws_inv_qty,
    location_code,
    location_address,
    item_spec,
    item_name,
    item_division,
    safety_inventory,
    unit_price,
    supplier_code,
    created_date,
    create_by,
    MATERIAL_MFS

)
  SELECT TRUNC(SYSDATE)+6/24  as Inventory_Time,
         'INTERNAL' WAREHOUSE_TYPE ,
         "IM_ITEM_INVENTORY"."ITEM_CODE",
         "IM_ITEM_INVENTORY"."ORGANIZATION_ID",
         "IM_ITEM_INVENTORY"."LINE_TYPE",
         "IM_ITEM_INVENTORY"."INVENTORY_HOLD",
         DECODE ( SUM("IM_ITEM_INVENTORY"."INVENTORY_QTY") , 0 , 0 , SUM("IM_ITEM_INVENTORY"."INVENTORY_AMT") /  SUM("IM_ITEM_INVENTORY"."INVENTORY_QTY") ) INVENTORY_PRICE,
         SUM("IM_ITEM_INVENTORY"."INVENTORY_QTY") INVENTORY_QTY,
         SUM("IM_ITEM_INVENTORY"."INVENTORY_AMT") INVENTORY_AMT,
         f_get_reel_qty( "IM_ITEM_INVENTORY"."ITEM_CODE", 1,  SUM("IM_ITEM_INVENTORY"."INVENTORY_QTY") , "IM_ITEM_INVENTORY"."ORGANIZATION_ID" ) REEL_QTY ,
         NVL(f_get_mm_last_mon_loc_inv_qty( TO_CHAR(SYSDATE,'YYYYMM') , IM_ITEM_INVENTORY.ITEM_CODE , IM_ITEM_INVENTORY.LINE_TYPE , IM_ITEM_INVENTORY.LOCATION_CODE , IM_ITEM_INVENTORY.ORGANIZATION_ID ) ,0 ) LAST_INVENTORY_QTY ,

         SUM("IM_ITEM_INVENTORY"."INVENTORY_QTY") as TIME_INV_QTY,
         f_get_mat_ws_inv_qty_4_time( IM_ITEM_INVENTORY.ITEM_CODE, IM_ITEM_INVENTORY.MATERIAL_MFS, IM_ITEM_INVENTORY.ORGANIZATION_ID ) as WS_INV_QTY,

         "IM_ITEM_INVENTORY"."LOCATION_CODE",
         MAX("ID_ITEM"."LOCATION_ADDRESS") LOCATION_ADDRESS,
         MAX("ID_ITEM"."ITEM_SPEC") ITEM_SPEC,
         MAX("ID_ITEM"."ITEM_NAME") ITEM_NAME,
         MAX("ID_ITEM"."ITEM_DIVISION") ITEM_DIVISION ,
         MAX("ID_ITEM"."SAFETY_INVENTORY") SAFETY_INVENTORY    ,
         F_GET_MAT_MAX_UNIT_PRICE_CFM( IM_ITEM_INVENTORY.ITEM_CODE , IM_ITEM_INVENTORY.LINE_TYPE , SYSDATE , IM_ITEM_INVENTORY.ORGANIZATION_ID ) UNIT_PRICE ,
         IM_ITEM_INVENTORY.SUPPLIER_CODE  SUPPLIER_CODE,
         SYSDATE AS CREATED_DATE,
         'BATCH' AS CREATE_BY ,
           IM_ITEM_INVENTORY.MATERIAL_MFS

    FROM "IM_ITEM_INVENTORY",   "ID_ITEM"
   WHERE ( "ID_ITEM"."ITEM_CODE"               = "IM_ITEM_INVENTORY"."ITEM_CODE" ) and
         ( "ID_ITEM"."ORGANIZATION_ID"         = "IM_ITEM_INVENTORY"."ORGANIZATION_ID" ) and
         ( "IM_ITEM_INVENTORY"."ORGANIZATION_ID" =  1 )
GROUP BY
         "IM_ITEM_INVENTORY"."ITEM_CODE",
         "IM_ITEM_INVENTORY"."LINE_TYPE",
         "IM_ITEM_INVENTORY"."LOCATION_CODE" ,
         "IM_ITEM_INVENTORY"."SUPPLIER_CODE" ,
         "IM_ITEM_INVENTORY"."ORGANIZATION_ID",
         "IM_ITEM_INVENTORY"."INVENTORY_HOLD",
         "IM_ITEM_INVENTORY"."MATERIAL_MFS"
         ;

COMMIT ;
exception
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
  when others then
    rollback ;
    null;
end P_CREATE_STOCK_4_TIME;