CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRG_ID_ENG_BOM_SMT_UPD
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   ID_ENG_BOM_SMT 테이블의 UPDATE 이벤트 발생 시 원본 트리거 로직에 정의된 후속 처리를 자동 수행한다.
   *   업무 데이터의 기본값 설정, 검증, 이력 기록 또는 연계 테이블 갱신에 사용된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: UPDATE
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   ID_ENG_BOM_SMT - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ID_ENG_BOM_SMT - BOM 관련 트리거 대상 테이블
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: UPDATE 3회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_ID_ENG_BOM_SMT_UPD';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_ID_ENG_BOM_SMT_UPD';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRG_ID_ENG_BOM_SMT_UPD" 
 BEFORE
   UPDATE OF table_id, item_unit_qty, location_code
 ON id_eng_bom_smt
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
BEGIN
  NULL;
  
--    UPDATE   ib_product_plandata a
--       SET   a.location_code = :new.location_code,
--             a.last_location_code = a.location_code ,
--             a.table_id = :new.table_id,
--             a.machine = :new.machine,
--             a.check_status = 'W',
--             a.check_yn = 'N' ,
--             a.item_unit_qty = :new.item_unit_qty
--     WHERE   a.line_code = :old.line_code
--         AND a.model_name = :old.parent_item_code
--         and a.table_id   = :old.table_id
--         and a.pcb_item   = :old.pcb_item
--      --   AND a.item_code = :old.child_item_code
--         AND a.location_code = :old.location_code;
--
------------------------------------------------------------------
----
------------------------------------------------------------------
--    UPDATE   id_eng_bom_smt_replace a
--       SET   a.location_code = :new.location_code,
--             a.table_id = :new.table_id,
--             a.machine = :new.machine,
--             a.item_unit_qty = :new.item_unit_qty
--     WHERE   a.line_code = :old.line_code
--         AND a.parent_item_code = :old.parent_item_code
--         AND a.child_item_code = :old.child_item_code
--         and a.table_id   = :old.table_id
--         and a.pcb_item   = :old.pcb_item
--         AND a.location_code = :old.location_code;
 ---------------------------------------------------------------
 --
 ---------------------------------------------------------------
EXCEPTION
    WHEN OTHERS
    THEN
        raise_application_error (-20003, SQLERRM);
END;
