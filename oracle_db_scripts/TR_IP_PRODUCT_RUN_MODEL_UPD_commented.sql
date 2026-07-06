CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TR_IP_PRODUCT_RUN_MODEL_UPD
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IP_PRODUCT_RUN_MODEL 테이블의 UPDATE 이벤트 발생 시 원본 트리거 로직에 정의된 후속 처리를 자동 수행한다.
   *   업무 데이터의 기본값 설정, 검증, 이력 기록 또는 연계 테이블 갱신에 사용된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: AFTER
   *   이벤트: UPDATE
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IP_PRODUCT_RUN_MODEL - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.AOI_MASTER_SAMPLE_PID - 신규/변경 후 제품 식별자 관련 값
   *   :NEW.ORGANIZATION_ID - 신규/변경 후 값 값
   *   :NEW.LINE_CODE - 신규/변경 후 라인 관련 값
   *   :NEW.MODEL_NAME - 신규/변경 후 모델 / 명칭 관련 값
   *   :NEW.ITEM_CODE - 신규/변경 후 품목 관련 값
   *   :NEW.PCB_ITEM - 신규/변경 후 PCB / 품목 관련 값
   *   :NEW.AOI_MASTER_SAMPLE_CHECK - 신규/변경 후 값 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_RUN_MODEL - 제품 / 작업지시/런 / 모델 관련 트리거 대상 테이블
   *   IQ_INSPECT_MASTER_SAMPLE_LOG - 검사 / 로그 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_GET_WORKSTAGE_CODE_BY_TYPE - 트리거 내부 업무 처리 호출
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회 / 반복문: 0회
   *   DML: SELECT 1회, INSERT 1회, UPDATE 1회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TR_IP_PRODUCT_RUN_MODEL_UPD';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TR_IP_PRODUCT_RUN_MODEL_UPD';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TR_IP_PRODUCT_RUN_MODEL_UPD" 
 AFTER UPDATE ON IP_PRODUCT_RUN_MODEL   FOR EACH ROW
DECLARE

BEGIN

  IF LENGTH(NVL(:NEW.AOI_MASTER_SAMPLE_PID,'')) > 1 THEN
  -----------------------------------------------------------------
  -- 2016/08/30 SHS, Master sample ？？？？？？ ？？？？

  -----------------------------------------------------------------

     INSERT INTO IQ_INSPECT_MASTER_SAMPLE_LOG (
                                               ORGANIZATION_ID,
                                               INPUT_DATE,
                                               LINE_CODE,
                                               WORKSTAGE_CODE,
                                               MODEL_NAME,
                                               ITEM_CODE,
                                               PCB_ITEM,
                                               MASTER_SAMPLE_PID,
                                               ENTER_DATE,
                                               ENTER_BY,
                                               LAST_MODIFY_DATE,
                                               LAST_MODIFY_BY,
                                               AOI_MASTER_SAMPLE_CHECK
                                              )
     SELECT :NEW.ORGANIZATION_ID ,
            SYSDATE,
            :NEW.LINE_CODE,
            f_get_workstage_code_by_type('AOI'),
            :NEW.MODEL_NAME,
            :NEW.ITEM_CODE,
            :NEW.PCB_ITEM,
            :NEW.AOI_MASTER_SAMPLE_PID,
            SYSDATE,
            'TRIGGER',
            SYSDATE,
            'TRIGGER',
            :NEW.AOI_MASTER_SAMPLE_CHECK
       FROM DUAL;

  END IF;

EXCEPTION

  WHEN OTHERS THEN
       NULL ;

END;
