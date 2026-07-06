CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRGIQ_INTERLOCK_CHECK_RESULT_U
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IQ_INTERLOCK_CHECK_RESULT 테이블의 UPDATE 발생 시 생산/검사 실적 관련 값을 자동 보정하거나 이력을 갱신한다.
   *   제품 실적, 검사 결과, 공정 흐름의 데이터 정합성을 유지하기 위한 트리거로 추정된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: UPDATE
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IQ_INTERLOCK_CHECK_RESULT - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :OLD.SERIAL_NO - 변경/삭제 전 시리얼 관련 값
   *   :OLD.ITEM_CODE - 변경/삭제 전 품목 관련 값
   *   :OLD.MACHINE_CODE - 변경/삭제 전 설비 관련 값
   *   :OLD.RECEIPT_DATE - 변경/삭제 전 입고 / 일자 관련 값
   *   :OLD.LINE_CODE - 변경/삭제 전 라인 관련 값
   *   :OLD.MODEL_NAME - 변경/삭제 전 모델 / 명칭 관련 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IQ_INTERLOCK_CHECK_RESULT - 인터락 / 실적 관련 트리거 대상 테이블
   *   IB_SMT_CHECKHIST - 업무 데이터 트리거 내부 SQL에서 참조/변경
   *   IP_PROD_MATERIAL_TRACKING_KFC - 자재 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 예외 처리:
   *   명시적 EXCEPTION 블록 없음 - 호출부/Oracle 표준 예외 처리를 따른다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: SELECT 2회, INSERT 1회, UPDATE 1회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRGIQ_INTERLOCK_CHECK_RESULT_U';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRGIQ_INTERLOCK_CHECK_RESULT_U';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRGIQ_INTERLOCK_CHECK_RESULT_U" 
 BEFORE
 UPDATE OF ENTER_BY
 ON IQ_INTERLOCK_CHECK_RESULT
 REFERENCING OLD AS OLD NEW AS NEW
 FOR EACH ROW
BEGIN
    INSERT INTO ip_prod_material_tracking_kfc (p_pcb,
                                               p_kefilot,
                                               p_material,
                                               m_material,
                                               p_prog,
                                               p_equip,
                                               p_process_time,
                                               p_status)
        SELECT   :old.serial_no,
                 a.lot_no,
                 :old.item_code,
                 a.partname,
                 a.line_code,
                 :old.machine_code,
                 :old.receipt_date,
                 a.pcb_item
          FROM   ib_smt_checkhist a
         WHERE   (a.check_date, a.line_code, a.lot_name, a.pcb_item, a.location_code) IN
                         (  SELECT   MAX (check_date),
                                     line_code,
                                     lot_name,
                                     pcb_item,
                                     location_code
                              FROM   ib_smt_checkhist
                             WHERE   check_date <= :old.receipt_date
                                 AND check_type IN (1, 2)
                                 AND line_code = :old.line_code
                                 and lot_name = :old.model_name

                          GROUP BY   line_code,
                                     lot_name,
                                     pcb_item,
                                     location_code)
             AND a.check_type IN (1, 2)
             AND a.line_code = :old.line_code
             AND a.lot_name  = :old.model_name ;
END;
