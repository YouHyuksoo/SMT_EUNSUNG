CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRG_IMCN_SAMPLE_BEF_UP
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IMCN_SAMPLE 테이블의 UPDATE 이벤트 발생 시 원본 트리거 로직에 정의된 후속 처리를 자동 수행한다.
   *   업무 데이터의 기본값 설정, 검증, 이력 기록 또는 연계 테이블 갱신에 사용된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: UPDATE
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IMCN_SAMPLE - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.VERIFICATION_STATE1 - 신규/변경 후 값 값
   *   :NEW.VERIFICATION_DATE1 - 신규/변경 후 값 값
   *   :NEW.VERIFICATION_STATE2 - 신규/변경 후 값 값
   *   :NEW.VERIFICATION_DATE2 - 신규/변경 후 값 값
   *   :NEW.VERIFICATION_STATE3 - 신규/변경 후 값 값
   *   :NEW.VERIFICATION_DATE3 - 신규/변경 후 값 값
   *   :NEW.VERIFICATION_STATE4 - 신규/변경 후 값 값
   *   :NEW.VERIFICATION_DATE4 - 신규/변경 후 값 값
   *   :NEW.VERIFICATION_STATE5 - 신규/변경 후 값 값
   *   :NEW.VERIFICATION_DATE5 - 신규/변경 후 값 값
   *   :NEW.VERIFICATION_STATE6 - 신규/변경 후 값 값
   *   :NEW.VERIFICATION_DATE6 - 신규/변경 후 값 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IMCN_SAMPLE - 업무 데이터 트리거 대상 테이블
   * ================================================================
   * [AI 분석] 예외 처리:
   *   명시적 EXCEPTION 블록 없음 - 호출부/Oracle 표준 예외 처리를 따른다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 12회 / 반복문: 0회
   *   DML: UPDATE 1회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_IMCN_SAMPLE_BEF_UP';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_IMCN_SAMPLE_BEF_UP';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
.TRG_IMCN_SAMPLE_BEF_UP
  before update on imcn_sample  
  for each row
declare
  -- local variables here
begin
  
  if ( :new.verification_state1 = '*' ) then
    
       :new.verification_date1 := NULL;
       
  end if;
  
  if ( :new.verification_state2 = '*' ) then
    
       :new.verification_date2 := NULL;
       
  end if;
  
  if ( :new.verification_state3 = '*' ) then
    
       :new.verification_date3 := NULL;
       
  end if;
  
  if ( :new.verification_state4 = '*' ) then
    
       :new.verification_date4 := NULL;
       
  end if;
  
  if ( :new.verification_state5 = '*' ) then
    
       :new.verification_date5 := NULL;
       
  end if;
  
  if ( :new.verification_state6 = '*' ) then
    
       :new.verification_date6 := NULL;
       
  end if;

end;
