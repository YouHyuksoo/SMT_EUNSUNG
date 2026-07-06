CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRG_IP_PRODUCT_LINE_UPD
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IP_PRODUCT_LINE 테이블의 UPDATE 이벤트 발생 시 원본 트리거 로직에 정의된 후속 처리를 자동 수행한다.
   *   업무 데이터의 기본값 설정, 검증, 이력 기록 또는 연계 테이블 갱신에 사용된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: AFTER
   *   이벤트: UPDATE
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IP_PRODUCT_LINE - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.LINE_STATUS - 신규/변경 후 라인 / 상태 관련 값
   *   :NEW.ACTION_DATE - 신규/변경 후 일자 관련 값
   *   :OLD.LINE_CODE - 변경/삭제 전 라인 관련 값
   *   :OLD.ORGANIZATION_ID - 변경/삭제 전 값 값
   *   :OLD.LAST_MODIFY_BY - 변경/삭제 전 값 값
   *   :OLD.ENTER_BY - 변경/삭제 전 값 값
   *   :OLD.ENTER_DATE - 변경/삭제 전 일자 관련 값
   *   :OLD.LAST_MODIFY_DATE - 변경/삭제 전 일자 관련 값
   *   :OLD.LINE_STATUS - 변경/삭제 전 라인 / 상태 관련 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_LINE - 제품 / 라인 관련 트리거 대상 테이블
   *   IP_LINE_DAILY_OPERATION - 라인 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 4회, ELSIF 1회 / 반복문: 0회
   *   DML: SELECT 1회, INSERT 1회, UPDATE 2회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_IP_PRODUCT_LINE_UPD';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_IP_PRODUCT_LINE_UPD';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRG_IP_PRODUCT_LINE_UPD" 
 AFTER
   UPDATE OF line_status
 ON ip_product_line
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   lvi_count   NUMBER;
BEGIN
----------------------------------------------
-- LINE STATUS CODE
----------------------------------------------
-- S = NORMAL START
-- N = NORMAL END
-- P = STOP
-- R = REPAIR
-- I = IDLE
-- M = MODEL CHANGE
-- C = CLEAN
-- W = POWER OFF



   ----------------------------------------------
   IF :NEW.line_status IN ('S', 'P', 'R', 'I', 'M', 'C', 'W')
   THEN
      BEGIN
         SELECT COUNT (*)
           INTO lvi_count
           FROM ip_line_daily_operation
          WHERE plan_date = nvl(TRUNC (:NEW.action_date) , trunc(sysdate) )
            AND line_code = :OLD.line_code
            AND line_status_code = :NEW.line_status
            AND NVL (action_close_yn, 'N') = 'N'
            AND organization_id = :OLD.organization_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            lvi_count := 0;
      END;

-----------------------------------------------
--
-----------------------------------------------
      IF lvi_count = 0
      THEN
         INSERT INTO ip_line_daily_operation
                     (plan_date,
                      line_operation_sequence, line_status_code,
                      organization_id, line_code, shift_code,
                      start_time, end_time, total_operation_time,
                      action_close_yn, operation_by, repair_by,
                      enter_by, enter_date, last_modify_by,
                      last_modify_date , action_date
                     )
              VALUES (nvl(TRUNC (:NEW.action_date),trunc(sysdate))   ,                --PLAN_DATE,
                      seq_line_operation_sequence.NEXTVAL,
                                                   -- LINE_OPERATION_SEQUENCE,
                                                          :NEW.line_status,
                      :OLD.organization_id, :OLD.line_code, '*', --SHIFT_CODE,
                      nvl(TRUNC (:NEW.action_date),trunc(sysdate)) ,                           --START_TIME
                                       NULL,                        --END_TIME
                                            0,         --TOTAL_OPERATION_TIME,
                      'N',                                  --ACTION_CLOSE_YN,
                          :OLD.last_modify_by,                 --OPERATION_BY,
                                              :OLD.last_modify_by,
                                                                  --REPAIR_BY,
                      :OLD.enter_by, :OLD.enter_date, :OLD.last_modify_by,
                      :OLD.last_modify_date ,
                      :new.action_date
                     );
      END IF;
   ELSIF :NEW.line_status = 'N'
   THEN                                                              -- NORMAL
      UPDATE ip_line_daily_operation
         SET end_time = nvl(TRUNC (:NEW.action_date),trunc(sysdate)) ,
             total_operation_time =
                     ROUND ((nvl(TRUNC (:NEW.action_date),trunc(sysdate))  - start_time) * 24 * 60 * 60, 2),
             action_close_yn = 'Y'
       WHERE plan_date = nvl(TRUNC (:NEW.action_date),trunc(sysdate))
         AND line_code = :OLD.line_code
         AND line_status_code = :OLD.line_status
         AND NVL (action_close_yn, 'N') = 'N'
         AND organization_id = :OLD.organization_id;
   ELSE
      NULL;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;
