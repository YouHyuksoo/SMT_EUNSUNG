CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_MAGAZINE_BARCODE
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   입력 파라미터와 기준 테이블을 이용해 업무 코드, 명칭, 수량, 상태 등의 조회 값을 반환한다.
   *   조회 실패 또는 예외 상황에서는 원본 로직에 정의된 기본값/NULL/오류 처리를 따른다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_BOX_BARCODE  (IN, VARCHAR2) - 바코드
   * ================================================================
   * [AI 분석] 반환값:
   *   VARCHAR2 - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   없음 (순수 연산 함수 또는 원본 소스 기준 명시 테이블 없음)
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회, ELSIF 2회 / 반복문: 0회
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_MAGAZINE_BARCODE(...) FROM DUAL;
   * ================================================================ */
 "F_GET_MAGAZINE_BARCODE" (P_BOX_BARCODE IN VARCHAR2) RETURN VARCHAR2 IS

  LVS_MAGAZINE_BARCODE VARCHAR2(500);
  LVS_BARCODE_LENGTH   NUMBER;

  LVI_POS1             NUMBER;
  LVI_POS2             NUMBER;
  LVI_GAP              NUMBER;

BEGIN

  LVS_MAGAZINE_BARCODE := P_BOX_BARCODE;
  LVS_BARCODE_LENGTH   := 0;

  -- GET MAGAZINE NO

  IF SUBSTR(P_BOX_BARCODE,1,6) = '[)>@06' THEN

  ------------------------------------------------------------------------------------------------------------
  -- 2016/08/31 SHS, BOSCH ？？？？？？ART NUMBER ？？ ？？？？？？？？？？ o？？ ？
  -- "[)>@06@P1038408234BA@1P1038408234.005@1T20160830@2T8709@Q8@V5390507009@30PN@20PyyyyMMddHHmm@@"
  --                                          --------   ----
  ------------------------------------------------------------------------------------------------------------

           LVI_POS1  := INSTR (P_BOX_BARCODE, '@1T');
           LVI_POS2  := INSTR (P_BOX_BARCODE, '@2T', LVI_POS1+1);
           LVI_GAP   := LVI_POS2 - LVI_POS1;

           LVS_MAGAZINE_BARCODE := SUBSTR(P_BOX_BARCODE, LVI_POS1+3, LVI_GAP-3);

           LVI_POS1  := INSTR (P_BOX_BARCODE, '@2T');
           LVI_POS2  := INSTR (P_BOX_BARCODE, '@Q', LVI_POS1+1);
           LVI_GAP   := LVI_POS2 - LVI_POS1;

           LVS_MAGAZINE_BARCODE := LVS_MAGAZINE_BARCODE||SUBSTR(P_BOX_BARCODE, LVI_POS1+3, LVI_GAP-3);

  ELSIF SUBSTR(P_BOX_BARCODE, 1,6) = '[)>'||CHR(30)||'06' THEN

  ------------------------------------------------------------------------------------------------------------
  -- HYUNDAE KEFICO
  -- "[)>06VSNWPP9101200343Q2T20160817SB01627D20160817UEA"
  --                          --------   ----
  ------------------------------------------------------------------------------------------------------------

           lvi_pos1  := INSTR (P_BOX_BARCODE, CHR(29)||'T');
           lvi_pos2  := INSTR (P_BOX_BARCODE, CHR(29), lvi_pos1+1);
           lvi_gap   := lvi_pos2 - lvi_pos1;

           LVS_MAGAZINE_BARCODE := SUBSTR(P_BOX_BARCODE, lvi_pos1+2, lvi_gap-2);

           lvi_pos1  := INSTR (P_BOX_BARCODE, CHR(29)||'SB');
           lvi_pos2  := INSTR (P_BOX_BARCODE, CHR(29), lvi_pos1+1);
           lvi_gap   := lvi_pos2 - lvi_pos1;

           LVS_MAGAZINE_BARCODE := LVS_MAGAZINE_BARCODE||SUBSTR(P_BOX_BARCODE, lvi_pos1+4, lvi_gap-4);

  ELSIF SUBSTR(P_BOX_BARCODE, 1,6) = 'AD-TAS' THEN

  ------------------------------------------------------------------------------------------------------------
  -- LG ？？？
  -- "AD-TAS@MKCM-N031A@A0_001@2016051161693@2016-05-11 13:27@60@10000@"
  --                           -------------
  ------------------------------------------------------------------------------------------------------------

           LVS_MAGAZINE_BARCODE := SUBSTR(P_BOX_BARCODE,26,13);

  ELSE

     -- BARCODE SIZE ？？？
     BEGIN

        SELECT NVL(LENGTH(P_BOX_BARCODE),0)
          INTO LVS_BARCODE_LENGTH
          FROM DUAL;

     EXCEPTION
         WHEN OTHERS THEN
              NULL;
     END;


     CASE LVS_BARCODE_LENGTH

          WHEN 12 THEN
               LVS_MAGAZINE_BARCODE := P_BOX_BARCODE;                                          -- DY,        "201605052488"

     END CASE;

  END IF;

  RETURN LVS_MAGAZINE_BARCODE;


EXCEPTION

   WHEN OTHERS THEN
       RETURN P_BOX_BARCODE;

END;
