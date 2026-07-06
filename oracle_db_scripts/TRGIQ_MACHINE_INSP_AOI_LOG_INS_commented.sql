CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRGIQ_MACHINE_INSP_AOI_LOG_INS
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IQ_MACHINE_INSPECT_AOI_LOG 테이블의 INSERT 발생 시 변경 이력 또는 감사 로그를 자동 기록한다.
   *   원본 로직 기준으로 변경 전후 값과 처리 정보를 보조 테이블에 남기는 트리거로 추정된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: INSERT
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IQ_MACHINE_INSPECT_AOI_LOG - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.BARCODE - 신규/변경 후 바코드 관련 값
   *   :NEW.CHECK_RESULT - 신규/변경 후 실적 관련 값
   *   :NEW.LINE_CODE - 신규/변경 후 라인 관련 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IQ_MACHINE_INSPECT_AOI_LOG - 설비 / 검사 / 로그 관련 트리거 대상 테이블
   *   IP_PRODUCT_MODEL_MASTER - 제품 / 모델 관련 트리거 내부 SQL에서 참조/변경
   *   IP_PRODUCT_2D_BARCODE - 제품 / 바코드 관련 트리거 내부 SQL에서 참조/변경
   *   IQ_INTERLOCK_CHECK_RESULT - 인터락 / 실적 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_GET_WORKSTAGE_TYPE - 트리거 내부 업무 처리 호출
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 10회 / 반복문: 0회
   *   DML: SELECT 2회, INSERT 1회, UPDATE 5회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRGIQ_MACHINE_INSP_AOI_LOG_INS';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRGIQ_MACHINE_INSP_AOI_LOG_INS';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRGIQ_MACHINE_INSP_AOI_LOG_INS" 
   BEFORE INSERT
   ON IQ_MACHINE_INSPECT_AOI_LOG
   REFERENCING NEW AS New OLD AS Old
   FOR EACH ROW
DECLARE

   LVS_MARKING_CONDITION          VARCHAR2 (10);
   LVI_CARRIER_SIZE               NUMBER;
   LVS_CARRIER_BARCODE_POSITION   VARCHAR2 (10);
   LVS_CUSTOMER_NAME              VARCHAR2 (30);
   LVS_SITE_CODE                  VARCHAR2 (30);
   LVI_SERIAL_NO_POSITION         NUMBER;

   LVS_BARCODE                    VARCHAR2 (30);

BEGIN

   ------------------------------------------------------
   -- 연배열 정보 확인
   ------------------------------------------------------
   BEGIN

     SELECT MARKING_CONDITION, CARRIER_SIZE, CARRIER_BARCODE_POSITION, CUSTOMER_NAME, SITE_CODE, SERIAL_NO_POSITION
       INTO LVS_MARKING_CONDITION,
            LVI_CARRIER_SIZE,
            LVS_CARRIER_BARCODE_POSITION,
            LVS_CUSTOMER_NAME,
            LVS_SITE_CODE,
            LVI_SERIAL_NO_POSITION
       FROM IP_PRODUCT_MODEL_MASTER
      WHERE ITEM_CODE = (
                         SELECT ITEM_CODE
                           FROM IP_PRODUCT_2D_BARCODE
                          WHERE SERIAL_NO = :NEW.BARCODE
                        )
        AND ROWNUM = 1;

   EXCEPTION
      WHEN OTHERS THEN
           NULL;
   END;

   ----------------------------------------------------------------------------
   -- 대표 바코드 인경우 연배열처리를 위한 PID 산출
   ----------------------------------------------------------------------------
   IF (LVI_CARRIER_SIZE >= 2) THEN

      IF (LVI_CARRIER_SIZE > 9) THEN
         LVS_BARCODE := SUBSTR (:NEW.BARCODE, 1, LENGTH (:NEW.BARCODE) - 2) || '%';  -- 10연배 이상
      ELSE
         LVS_BARCODE := SUBSTR (:NEW.BARCODE, 1, LENGTH (:NEW.BARCODE) - 1) || '%';  -- 2연배 에서 9연배 까지
      END IF;

   ELSE

      LVS_BARCODE := :NEW.BARCODE;

   END IF;

   ------------------------------------------------------
   -- HLDS 경우 바코드 중앙에 Serial 이 존재하여 예외 처리 함
   ------------------------------------------------------
   IF (LVS_CUSTOMER_NAME = 'HLDS') THEN

       IF (LVI_CARRIER_SIZE >= 2)  THEN

           IF ( LVS_CARRIER_BARCODE_POSITION = '1' ) THEN

                UPDATE /*+ INDEX(IQ_INTERLOCK_CHECK_RESULT INDXIQ_INTERLOCK_CHECK_RESULT2) */ IQ_INTERLOCK_CHECK_RESULT
                   SET CHECK_RESULT = DECODE (:NEW.CHECK_RESULT, '양품', 'OK', 'NG'),
                       BAD_REASON_COMMENTS = '설비판정:'
                                             || CHECK_RESULT
                                             || ' 로그판정(CSV): '
                                             || :NEW.CHECK_RESULT
                 WHERE SERIAL_NO >= :NEW.BARCODE
                   AND SERIAL_NO <= LVS_SITE_CODE||TRIM(TO_CHAR(TO_NUMBER(SUBSTR(:NEW.BARCODE,4,5))+ (( LVI_CARRIER_SIZE) -1),'00000'))||SUBSTR(:NEW.BARCODE,9,18)
                   AND IS_LAST_YN     = 'Y'
                   AND F_GET_WORKSTAGE_TYPE(WORKSTAGE_CODE) = 'AOI'
                   AND LINE_CODE      = :NEW.LINE_CODE
                   AND CHECK_RESULT   = 'PASS';

           ELSE

                UPDATE /*+ INDEX(IQ_INTERLOCK_CHECK_RESULT INDXIQ_INTERLOCK_CHECK_RESULT2) */ IQ_INTERLOCK_CHECK_RESULT
                   SET CHECK_RESULT = DECODE (:NEW.CHECK_RESULT, '양품', 'OK', 'NG'),
                       BAD_REASON_COMMENTS = '설비판정:'
                                             || CHECK_RESULT
                                             || ' 로그판정(CSV): '
                                             || :NEW.CHECK_RESULT
                 WHERE SERIAL_NO >= LVS_SITE_CODE||TRIM(TO_CHAR(TO_NUMBER(SUBSTR(:NEW.BARCODE,4,5))+ (( -1 * LVI_CARRIER_SIZE) +1),'00000'))||SUBSTR(:NEW.BARCODE,9,18)
                   AND SERIAL_NO <= :NEW.BARCODE
                   AND IS_LAST_YN     = 'Y'
                   AND F_GET_WORKSTAGE_TYPE(WORKSTAGE_CODE) = 'AOI'
                   AND LINE_CODE      = :NEW.LINE_CODE
                   AND CHECK_RESULT   = 'PASS';

           END IF;

       ELSE

           UPDATE IQ_INTERLOCK_CHECK_RESULT
              SET CHECK_RESULT = DECODE (:NEW.CHECK_RESULT, '양품', 'OK', 'NG'),
                  BAD_REASON_COMMENTS = '설비판정:'
                                        || CHECK_RESULT
                                        || ' 로그판정(CSV): '
                                        || :NEW.CHECK_RESULT
            WHERE SERIAL_NO LIKE LVS_BARCODE
              AND IS_LAST_YN     = 'Y'
              AND F_GET_WORKSTAGE_TYPE(WORKSTAGE_CODE) = 'AOI'
              AND LINE_CODE      = :NEW.LINE_CODE
              AND CHECK_RESULT   = 'PASS';

      END IF;

   ELSE

       UPDATE IQ_INTERLOCK_CHECK_RESULT
          SET CHECK_RESULT = DECODE (:NEW.CHECK_RESULT, '양품', 'OK', 'NG'),
              BAD_REASON_COMMENTS = '설비판정:'
                                    || CHECK_RESULT
                                    || ' 로그판정(CSV): '
                                    || :NEW.CHECK_RESULT
        WHERE SERIAL_NO LIKE LVS_BARCODE
          AND IS_LAST_YN     = 'Y'
          AND F_GET_WORKSTAGE_TYPE(WORKSTAGE_CODE) = 'AOI'
          AND LINE_CODE      = :NEW.LINE_CODE
          AND CHECK_RESULT   = 'PASS';                             -- 2016/05/26 조찬필K 요청으로 PASS 인 경우에 대해 update

   END IF;


EXCEPTION
   WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR( -20003 , SQLERRM ) ;
END;
