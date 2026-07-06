CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRGIQ_MCN_INSPECT_AOI_R_TF_INS
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IQ_MACHINE_INSPECT_AOI_R_TF 테이블의 INSERT 발생 시 생산/검사 실적 관련 값을 자동 보정하거나 이력을 갱신한다.
   *   제품 실적, 검사 결과, 공정 흐름의 데이터 정합성을 유지하기 위한 트리거로 추정된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: INSERT
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IQ_MACHINE_INSPECT_AOI_R_TF - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.IS_LAST_YN - 신규/변경 후 값 값
   *   :NEW.BARCODE - 신규/변경 후 바코드 관련 값
   *   :NEW.LINE_CODE - 신규/변경 후 라인 관련 값
   *   :NEW.IMAGENAME - 신규/변경 후 값 값
   *   :NEW.LOCATIONID - 신규/변경 후 값 값
   *   :NEW.PARTNUMBER - 신규/변경 후 값 값
   *   :NEW.TESTDATA - 신규/변경 후 값 값
   *   :NEW.REVIEW - 신규/변경 후 값 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IQ_MACHINE_INSPECT_AOI_R_TF - 설비 / 검사 관련 트리거 대상 테이블
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
   *   조건 분기: IF 12회 / 반복문: 0회
   *   DML: SELECT 3회, INSERT 1회, UPDATE 5회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRGIQ_MCN_INSPECT_AOI_R_TF_INS';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRGIQ_MCN_INSPECT_AOI_R_TF_INS';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRGIQ_MCN_INSPECT_AOI_R_TF_INS" 
BEFORE INSERT
ON IQ_MACHINE_INSPECT_AOI_R_TF
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
DECLARE

   LVS_MARKING_CONDITION          VARCHAR2 (10);
   LVS_BARCODE                    VARCHAR2 (30);
   LVS_CUSTOMER_NAME              VARCHAR2 (30);
   LVS_SITE_CODE                  VARCHAR2 (30);

   LVI_CARRIER_SIZE               NUMBER;
   LVI_SERIAL_NO_POSITION         NUMBER;
   LVS_CARRIER_BARCODE_POSITION   VARCHAR2 (10);

   LVI_NG_COUNT                   NUMBER;

BEGIN

    :NEW.IS_LAST_YN := 'Y' ;

   ------------------------------------------------------
   -- ？？ ？？？？？？？？ LS_LAST_FLAG N？？？？ ？？？？
   ------------------------------------------------------
     UPDATE IQ_MACHINE_INSPECT_AOI_R_TF
       SET IS_LAST_YN = 'N'
     WHERE BARCODE     = :NEW.BARCODE
        AND LINE_CODE  = :NEW.LINE_CODE
        AND IMAGENAME  = :NEW.IMAGENAME
        AND LOCATIONID = :NEW.LOCATIONID
        AND PARTNUMBER = :NEW.PARTNUMBER ;

   ------------------------------------------------------
   -- ？？？ ？？？？？？ ？？？？ ？ð？？뿡 NG？？ ？？？？？？？ o？？ ？？？？？ ？？？
   ------------------------------------------------------
   BEGIN

      SELECT NVL(SUM(1),0)
        INTO LVI_NG_COUNT
        FROM IQ_MACHINE_INSPECT_AOI_R_TF
       WHERE BARCODE         = :NEW.BARCODE
         AND TESTDATA        = :NEW.TESTDATA
         AND LINE_CODE       = :NEW.LINE_CODE
         AND NVL(REVIEW,'*') <> '？？？';

   EXCEPTION
      WHEN OTHERS THEN
           LVI_NG_COUNT := 0;
   END;

IF (LVI_NG_COUNT = 0) THEN

   ------------------------------------------------------
   -- ？？？迭 ？？？？ ？？？
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
   -- ？？？ ？？？？？ ？？？？？ ？？？迭o？？？？ ？？？？ PID ？？？？
   ----------------------------------------------------------------------------
   IF ( LVI_CARRIER_SIZE >= 2 )  THEN

      IF LVI_CARRIER_SIZE > 9   THEN
         LVS_BARCODE := SUBSTR (:NEW.BARCODE, 1, LENGTH (:NEW.BARCODE) - 2) || '%';
      ELSE
         LVS_BARCODE := SUBSTR (:NEW.BARCODE, 1, LENGTH (:NEW.BARCODE) - 1) || '%';
      END IF;
   ELSE
      LVS_BARCODE := :NEW.BARCODE;
   END IF;

   ------------------------------------------------------
   -- HLDS ？？？？ ？？？？？ ？？？？ Serial ？？ ？？？？？？？ ？？？？ o？？ ？？
   ------------------------------------------------------
   IF LVS_CUSTOMER_NAME = 'HLDS' THEN

      IF (LVI_CARRIER_SIZE >= 2)  THEN

          IF ( LVS_CARRIER_BARCODE_POSITION = '1' ) THEN

               UPDATE /*+ INDEX(IQ_INTERLOCK_CHECK_RESULT INDXIQ_INTERLOCK_CHECK_RESULT2) */ IQ_INTERLOCK_CHECK_RESULT
                  SET AOI_REVIEW_RESULT =  :NEW.REVIEW
                WHERE IS_LAST_YN = 'Y'
                  AND LINE_CODE = :NEW.LINE_CODE
                  AND F_GET_WORKSTAGE_TYPE(WORKSTAGE_CODE) = 'AOI'
                  AND SERIAL_NO >= :NEW.BARCODE
                  AND SERIAL_NO <= LVS_SITE_CODE||TRIM(TO_CHAR(TO_NUMBER(SUBSTR(:NEW.BARCODE,4,5))+ (( LVI_CARRIER_SIZE) -1),'00000'))||SUBSTR(:NEW.BARCODE,9,18);

          ELSE

               UPDATE /*+ INDEX(IQ_INTERLOCK_CHECK_RESULT INDXIQ_INTERLOCK_CHECK_RESULT2) */ IQ_INTERLOCK_CHECK_RESULT
                  SET AOI_REVIEW_RESULT =  :NEW.REVIEW
                WHERE IS_LAST_YN = 'Y'
                  AND LINE_CODE = :NEW.LINE_CODE
                  AND F_GET_WORKSTAGE_TYPE(WORKSTAGE_CODE) = 'AOI'
                  AND SERIAL_NO >= LVS_SITE_CODE||TRIM(TO_CHAR(TO_NUMBER(SUBSTR(:NEW.BARCODE,4,5))+ (( -1 * LVI_CARRIER_SIZE) +1),'00000'))||SUBSTR(:NEW.BARCODE,9,18)
                  AND SERIAL_NO <= :NEW.BARCODE;

          END IF;

      ELSE

          UPDATE IQ_INTERLOCK_CHECK_RESULT
             SET AOI_REVIEW_RESULT =  :NEW.REVIEW
           WHERE SERIAL_NO      = :NEW.BARCODE
             AND IS_LAST_YN     = 'Y'
             AND LINE_CODE      = :NEW.LINE_CODE
             AND F_GET_WORKSTAGE_TYPE(WORKSTAGE_CODE) = 'AOI';

      END IF;

   ELSE

       UPDATE  IQ_INTERLOCK_CHECK_RESULT
          SET AOI_REVIEW_RESULT =  :NEW.REVIEW
        WHERE SERIAL_NO      LIKE LVS_BARCODE    --SERIAL_NO = :NEW.BARCODE
          AND IS_LAST_YN     = 'Y'
          AND LINE_CODE      = :NEW.LINE_CODE
          AND F_GET_WORKSTAGE_TYPE(WORKSTAGE_CODE) = 'AOI' ;

   END IF;


END IF ;


EXCEPTION
     WHEN OTHERS THEN

       RAISE_APPLICATION_ERROR( -20003 , SQLERRM ) ;

END TRGIQ_MCN_INSPECT_AOI_R_TF_INS;
