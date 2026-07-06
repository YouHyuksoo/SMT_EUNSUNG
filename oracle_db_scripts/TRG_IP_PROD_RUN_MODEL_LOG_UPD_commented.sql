CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRG_IP_PROD_RUN_MODEL_LOG_UPD
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IP_PRODUCT_RUN_MODEL 테이블의 UPDATE 발생 시 변경 이력 또는 감사 로그를 자동 기록한다.
   *   원본 로직 기준으로 변경 전후 값과 처리 정보를 보조 테이블에 남기는 트리거로 추정된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: UPDATE
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IP_PRODUCT_RUN_MODEL - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :OLD.ORGANIZATION_ID - 변경/삭제 전 값 값
   *   :OLD.LINE_CODE - 변경/삭제 전 라인 관련 값
   *   :OLD.WORKSTAGE_CODE - 변경/삭제 전 공정 관련 값
   *   :OLD.MODEL_NAME - 변경/삭제 전 모델 / 명칭 관련 값
   *   :OLD.ITEM_CODE - 변경/삭제 전 품목 관련 값
   *   :OLD.PCB_ITEM - 변경/삭제 전 PCB / 품목 관련 값
   *   :OLD.RUN_NO - 변경/삭제 전 작업지시/런 관련 값
   *   :OLD.ENTER_DATE - 변경/삭제 전 일자 관련 값
   *   :OLD.ENTER_BY - 변경/삭제 전 값 값
   *   :OLD.LAST_MODIFY_DATE - 변경/삭제 전 일자 관련 값
   *   :OLD.LAST_MODIFY_BY - 변경/삭제 전 값 값
   *   :OLD.AOI_MASTER_SAMPLE_CHECK - 변경/삭제 전 값 값
   *   :OLD.AOI_MASTER_SAMPLE_PID - 변경/삭제 전 제품 식별자 관련 값
   *   :OLD.AOI_MASTER_SAMPLE_DATE - 변경/삭제 전 일자 관련 값
   *   :OLD.CHILD_ITEM_CODE - 변경/삭제 전 품목 관련 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_RUN_MODEL - 제품 / 작업지시/런 / 모델 관련 트리거 대상 테이블
   *   IP_PRODUCT_RUN_MODEL_LOG - 제품 / 작업지시/런 / 모델 / 로그 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: SELECT 1회, INSERT 1회, UPDATE 3회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_IP_PROD_RUN_MODEL_LOG_UPD';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_IP_PROD_RUN_MODEL_LOG_UPD';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRG_IP_PROD_RUN_MODEL_LOG_UPD" 
  before update on IP_PRODUCT_RUN_MODEL
  for each row
declare
  -- local variables here
begin

          -- Interlock condition update？？？？？？？？？

         INSERT INTO IP_PRODUCT_RUN_MODEL_LOG (
                                                ORGANIZATION_ID,
                                                LINE_CODE,
                                                WORKSTAGE_CODE,
                                                MODEL_NAME,
                                                ITEM_CODE,
                                                PCB_ITEM,
                                                RUN_NO,
                                                ENTER_DATE,
                                                ENTER_BY,
                                                LAST_MODIFY_DATE,
                                                LAST_MODIFY_BY,
                                                AOI_MASTER_SAMPLE_CHECK,
                                                AOI_MASTER_SAMPLE_PID,
                                                AOI_MASTER_SAMPLE_DATE,
                                                TERMINAL,
                                                CURRENT_USER,
                                                HOST,
                                                IP_ADDRESS,
                                                TRIGGER_MODE,
                                                TRIGGER_DATE,
                                                CHILD_ITEM_CODE
                                               )
        SELECT :OLD.ORGANIZATION_ID,
               :OLD.LINE_CODE,
               :OLD.WORKSTAGE_CODE,
               :OLD.MODEL_NAME,
               :OLD.ITEM_CODE,
               :OLD.PCB_ITEM,
               :OLD.RUN_NO,
               :OLD.ENTER_DATE,
               :OLD.ENTER_BY,
               :OLD.LAST_MODIFY_DATE,
               :OLD.LAST_MODIFY_BY,
               :OLD.AOI_MASTER_SAMPLE_CHECK,
               :OLD.AOI_MASTER_SAMPLE_PID,
               :OLD.AOI_MASTER_SAMPLE_DATE,
               SYS_CONTEXT('USERENV','TERMINAL'),     -- terminal ,
               SYS_CONTEXT('USERENV','CURRENT_USER'), -- current_user,
               SYS_CONTEXT('USERENV','HOST'),         -- host,
               SYS_CONTEXT('USERENV','IP_ADDRESS'),   -- ip_address,
               'UPDATE',
               SYSDATE,
               :OLD.CHILD_ITEM_CODE
          FROM DUAL;

  EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);

end;
