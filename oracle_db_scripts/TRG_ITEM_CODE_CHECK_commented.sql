CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRG_ITEM_CODE_CHECK
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   ID_ENG_BOM 테이블의 INSERT 이벤트 발생 시 원본 트리거 로직에 정의된 후속 처리를 자동 수행한다.
   *   업무 데이터의 기본값 설정, 검증, 이력 기록 또는 연계 테이블 갱신에 사용된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: INSERT
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   ID_ENG_BOM - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.PARENT_ITEM_CODE - 신규/변경 후 품목 관련 값
   *   :NEW.ORGANIZATION_ID - 신규/변경 후 값 값
   *   :NEW.CHILD_ITEM_CODE - 신규/변경 후 품목 관련 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ID_ENG_BOM - BOM 관련 트리거 대상 테이블
   *   ID_ITEM - 품목 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 4회 / 반복문: 0회
   *   DML: SELECT 2회, INSERT 1회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_ITEM_CODE_CHECK';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_ITEM_CODE_CHECK';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRG_ITEM_CODE_CHECK" 
 BEFORE
  INSERT
 ON id_eng_bom
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   numrows   INTEGER;
BEGIN
   SELECT COUNT (*)
     INTO numrows
     FROM id_item
    WHERE item_code = :NEW.parent_item_code
      AND organization_id = :NEW.organization_id;

   IF numrows = 0
   THEN
      raise_application_error (
         -20003,
            :NEW.parent_item_code
         || ' Parent Item Not Found in Item Master'
      );
   END IF;

   numrows := 0;
   SELECT COUNT (*)
     INTO numrows
     FROM id_item
    WHERE item_code = :NEW.child_item_code
      AND organization_id = :NEW.organization_id;

   IF numrows = 0
   THEN
      raise_application_error (
         -20003,
            NVL(:NEW.child_item_code , 'null')
         || ' Child Item Not Found in Item Master'
      );
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      raise_application_error (-20003, 'Item Not Found in Item Master');
END;
