CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRGIQ_MACHINE_INSPECT_MASK_INS
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IQ_MACHINE_INSPECT_DATA_MASK 테이블의 INSERT 발생 시 생산/검사 실적 관련 값을 자동 보정하거나 이력을 갱신한다.
   *   제품 실적, 검사 결과, 공정 흐름의 데이터 정합성을 유지하기 위한 트리거로 추정된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: INSERT
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IQ_MACHINE_INSPECT_DATA_MASK - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.C3 - 신규/변경 후 값 값
   *   :NEW.C2 - 신규/변경 후 값 값
   *   :NEW.C1 - 신규/변경 후 값 값
   *   :NEW.C4 - 신규/변경 후 값 값
   *   :NEW.C5 - 신규/변경 후 값 값
   *   :NEW.C6 - 신규/변경 후 값 값
   *   :NEW.C7 - 신규/변경 후 값 값
   *   :NEW.C9 - 신규/변경 후 값 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IQ_MACHINE_INSPECT_DATA_MASK - 설비 / 검사 / 마스크 관련 트리거 대상 테이블
   *   IMCN_JIG - 지그 관련 트리거 내부 SQL에서 참조/변경
   *   IMCN_JIG_MASK_CHECK - 지그 / 마스크 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 4회 / 반복문: 0회
   *   DML: SELECT 1회, INSERT 2회, UPDATE 2회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRGIQ_MACHINE_INSPECT_MASK_INS';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRGIQ_MACHINE_INSPECT_MASK_INS';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
.TRGIQ_MACHINE_INSPECT_MASK_INS
 BEFORE INSERT ON IQ_MACHINE_INSPECT_DATA_MASK
 FOR EACH ROW
DECLARE

   LVL_COUNT            NUMBER;
   LVL_BREAK_VALE       NUMBER;
   LVL_HIT_VALUE        NUMBER;
   LVS_JIG_CHECK_STATUS VARCHAR2(10);
   PHASE                VARCHAR2(10);
   
BEGIN

   PHASE := '10';
   
   -- 타발후 확인
   BEGIN
      
      SELECT NVL(BREAK_VALUE,0), NVL(HIT_VALUE,0)
        INTO LVL_BREAK_VALE, LVL_HIT_VALUE  
        FROM IMCN_JIG
       WHERE JIG_TYPE   = 'M'     
         AND JIG_LOT_NO = :NEW.C3;
                  
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
           LVL_BREAK_VALE := 0;
           LVL_HIT_VALUE := 0;
   END;
   
   PHASE := '20';
   
   -- 텐션 측정결과 확인  
   IF :NEW.C2 = 'Accept' THEN  
      LVS_JIG_CHECK_STATUS := 'P';    
   ELSE
      LVS_JIG_CHECK_STATUS := 'N';
   END IF;
   
   PHASE := '30';
   
   -- 지그마스타에 텐션 측정결과 저장
   IF LVS_JIG_CHECK_STATUS = 'N' OR LVL_BREAK_VALE <= LVL_HIT_VALUE THEN

    -- 사용중지 
    UPDATE IMCN_JIG 
       SET USE_STATUS = 'S' , 
           LAST_INSPECT_DATE = SYSDATE ,  
           LINE_CODE = '*' ,  
           TENSION_CHECK_YN = 'Y'
     WHERE JIG_TYPE   = 'M'     
       AND JIG_LOT_NO = :NEW.C3;  
   
   ELSE 
   
    -- 라인 코드는 회수 되었으므로 * 로 초기화 
    UPDATE IMCN_JIG 
       SET USE_STATUS = 'U',  
           LAST_INSPECT_DATE = SYSDATE ,
           LINE_CODE = '*' , 
           TENSION_CHECK_YN = 'Y'
     WHERE JIG_TYPE   = 'M'     
       AND JIG_LOT_NO = :NEW.C3;
             
    END IF;
   
   PHASE := '40';
   
   -- 결과값 등록
   INSERT INTO IMCN_JIG_MASK_CHECK (
                                    JIG_CODE, 
                                    JIG_LOT_NO, 
                                    ORGANIZATION_ID, 
                                    JIG_CHECK_SEQUENCE, 
                                    JIG_CHECK_DATE, 
                                    JIG_CHECK_STATUS,
                                    CLEAN_YN, 
                                    TENSION_CHECK1, 
                                    TENSION_CHECK2, 
                                    TENSION_CHECK3, 
                                    TENSION_CHECK4, 
                                    TENSION_CHECK5, 
                                    ENTER_BY, 
                                    ENTER_DATE, 
                                    LAST_MODIFY_BY, 
                                    LAST_MODIFY_DATE, 
                                    BREAK_VALUE, 
                                    HIT_VALUE
                                   )
                            VALUES (
                                    :NEW.C3, 
                                    :NEW.C3, 
                                    1, 
                                    SEQ_JIG_CHECK_SEQUENCE.NEXTVAL, 
                                    TO_DATE(SUBSTR(:NEW.C1,1,14),'YYYYMMDDHH24MISS'), 
                                    LVS_JIG_CHECK_STATUS, 
                                    'Y', 
                                    TO_NUMBER(:NEW.C4), 
                                    TO_NUMBER(:NEW.C5), 
                                    TO_NUMBER(:NEW.C6), 
                                    TO_NUMBER(:NEW.C7), 
                                    TO_NUMBER(:NEW.C9), 
                                    'TRIGGER', 
                                    SYSDATE,
                                    'TRIGGER', 
                                    SYSDATE, 
                                    LVL_BREAK_VALE, 
                                    LVL_HIT_VALUE);
                                  
EXCEPTION
   WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR (-20003, 'PHASE='
                                         || PHASE
                                         || ' '
                                         || SQLERRM);
END;
