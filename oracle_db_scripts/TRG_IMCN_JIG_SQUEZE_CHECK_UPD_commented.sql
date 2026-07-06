CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRG_IMCN_JIG_SQUEZE_CHECK_UPD
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IMCN_JIG_SQUEZE_CHECK 테이블의 UPDATE 이벤트 발생 시 원본 트리거 로직에 정의된 후속 처리를 자동 수행한다.
   *   업무 데이터의 기본값 설정, 검증, 이력 기록 또는 연계 테이블 갱신에 사용된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: UPDATE
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IMCN_JIG_SQUEZE_CHECK - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.CLEAN_YN - 신규/변경 후 값 값
   *   :NEW.PIN_HOLE_YN - 신규/변경 후 값 값
   *   :NEW.JIG_CHECK_STATUS - 신규/변경 후 지그 / 상태 관련 값
   *   :NEW.JIG_LOT_NO - 신규/변경 후 지그 / LOT 관련 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IMCN_JIG_SQUEZE_CHECK - 지그 관련 트리거 대상 테이블
   *   IMCN_JIG - 지그 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회 / 반복문: 0회
   *   DML: UPDATE 3회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_IMCN_JIG_SQUEZE_CHECK_UPD';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_IMCN_JIG_SQUEZE_CHECK_UPD';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRG_IMCN_JIG_SQUEZE_CHECK_UPD"
 BEFORE UPDATE ON IMCN_JIG_SQUEZE_CHECK
 FOR EACH ROW
DECLARE

BEGIN
   
   IF (:NEW.CLEAN_YN = 'N' OR :NEW.PIN_HOLE_YN = 'N' OR :NEW.JIG_CHECK_STATUS = 'N') THEN
     
       update imcn_jig
          set use_status      = 'S' 
        where jig_lot_no      = :NEW.jig_lot_no
          and jig_type        = 'S' 
          and organization_id = 1 ; 
          
   ELSE
           
       update imcn_jig
          set use_status      = 'U' 
        where jig_lot_no      = :NEW.jig_lot_no
          and jig_type        = 'S' 
          and organization_id = 1 ; 
          
   END IF;
   
EXCEPTION
    WHEN OTHERS THEN
         raise_application_error (-20003, SQLERRM);

END;
