CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRG_IP_PRODUCT_PDA_SCAN_INS
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IP_PRODUCT_PDA_SCAN_MASTER 테이블의 INSERT 이벤트 발생 시 원본 트리거 로직에 정의된 후속 처리를 자동 수행한다.
   *   업무 데이터의 기본값 설정, 검증, 이력 기록 또는 연계 테이블 갱신에 사용된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: AFTER
   *   이벤트: INSERT
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IP_PRODUCT_PDA_SCAN_MASTER - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.MATERIAL_MFS - 신규/변경 후 자재 관련 값
   *   :NEW.RUN_NO - 신규/변경 후 작업지시/런 관련 값
   *   :NEW.LINE_CODE - 신규/변경 후 라인 관련 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_PDA_SCAN_MASTER - 제품 관련 트리거 대상 테이블
   *   IP_PRODUCT_RUN_CARD - 제품 / 작업지시/런 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 4회 / 반복문: 0회
   *   DML: SELECT 1회, INSERT 1회, UPDATE 4회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_IP_PRODUCT_PDA_SCAN_INS';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_IP_PRODUCT_PDA_SCAN_INS';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRG_IP_PRODUCT_PDA_SCAN_INS" 
 AFTER
  INSERT
 ON ip_product_pda_scan_master
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
    lvi_count   NUMBER;
BEGIN
    IF :new.material_mfs IS NULL
    THEN
        NULL;
    ELSE
        BEGIN
            SELECT   COUNT ( * )
              INTO   lvi_count
              FROM   ip_product_run_card
             WHERE       run_date >= TRUNC (SYSDATE) - 3
                     AND run_no = :new.run_no
                     AND active_yn = 'Y'
                     AND line_code = :new.line_code;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                lvi_count := 0;
        END;


        IF lvi_count = 0
        THEN
            UPDATE   ip_product_run_card
               SET   active_yn = 'N'
                  --active_date = SYSDATE
             WHERE       run_date >= TRUNC (SYSDATE) - 3
                     --   AND run_no <> :new.run_no
                     AND NVL (active_yn, 'N') = 'L'
                     AND line_code = :new.line_code;

            UPDATE   ip_product_run_card
               SET   active_yn = 'L' --, active_date = SYSDATE
             WHERE       run_date >= TRUNC (SYSDATE) - 3
                     AND run_no <> :new.run_no
                     AND NVL (active_yn, 'N') = 'Y'
                     AND line_code = :new.line_code;

            UPDATE   ip_product_run_card
               SET   run_status = '4', active_yn = 'Y' --, active_date = SYSDATE
             WHERE   run_no = :new.run_no AND line_code = :new.line_code;



          --  UPDATE   ip_product_pcb_scan_master
              -- SET   pda_scan_date = SYSDATE
         --    WHERE   run_no = :new.run_no AND pda_scan_date IS NULL;

            COMMIT;
        END IF;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        NULL;
    WHEN OTHERS
    THEN
        NULL;
END;
