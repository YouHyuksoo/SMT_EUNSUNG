CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_BACODE_CODE128
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   원본 함수 로직을 기준으로 업무 값을 계산, 조회 또는 변환하여 반환한다.
   *   반환 타입은 NVARCHAR2이며 호출 위치에서 후속 판단/표시에 사용된다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_CODE_TYPE  (IN, VARCHAR2) - 함수 입력값
   *   P_SOURCETEXT  (IN, VARCHAR2) - 함수 입력값
   * ================================================================
   * [AI 분석] 반환값:
   *   NVARCHAR2 - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   없음 (순수 연산 함수 또는 원본 소스 기준 명시 테이블 없음)
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 12회 / 반복문: 9회
   *   DML: 없음
   * ================================================================
   * 사용 예시:
   *   SELECT F_BACODE_CODE128(...) FROM DUAL;
   * ================================================================ */
 "F_BACODE_CODE128" ( p_code_type IN VARCHAR2, p_sourcetext IN VARCHAR2)
  RETURN  NVARCHAR2 IS lvs_return NVARCHAR2(100);
   -- Declare program variables as shown above
   lvi_asc_total    NUMBER;
   lvi_asc_temp     NUMBER;
   lvi_check_digit  NUMBER;
   i                NUMBER;
   lvc_start        NCHAR;
   lvc_stop         NCHAR;
   lvs_check_digit  NVARCHAR2(1);

BEGIN

    CASE p_code_type
    WHEN 'A' THEN
        lvi_asc_total := 104;
        lvc_start := NCHR(209);  --code128B
        lvc_stop  := NCHR(211);

        i :=1;

        WHILE i <= LENGTH(p_sourcetext) loop    --check_code
        lvi_asc_temp := ASCII(SUBSTR(p_sourcetext,i,1));
        if lvi_asc_temp >= 32 then
            lvi_asc_total := lvi_asc_total + (lvi_asc_temp - 32)*i;
        else
            lvi_asc_total := lvi_asc_total + (lvi_asc_temp + 64 )*i;
        end if;
        i := i +1;
        end loop;

        lvi_check_digit :=MOD(lvi_asc_total , 103);
        if lvi_check_digit >= 95 then   --
            lvi_check_digit := lvi_check_digit + 100;
        ELSE
            lvi_check_digit := lvi_check_digit + 32;
        end if;

        lvs_check_digit := nchr(lvi_check_digit);

        lvs_return := lvc_start || p_sourcetext || lvs_check_digit || lvc_stop;
        RETURN lvs_return;
        RETURN lvs_return;
    WHEN 'B' THEN
        lvi_asc_total := 104;
         lvc_start := CHR(204 USING NCHAR_CS) ; -- NCHR(204);  --code128B
        lvc_stop  := CHR(206 USING NCHAR_CS) ; -- NCHR(206);

        i :=1;

        WHILE i <= LENGTH(p_sourcetext) loop    --check_code
        lvi_asc_temp := ASCII(SUBSTR(p_sourcetext,i,1));
        if lvi_asc_temp >= 32 then
            lvi_asc_total := lvi_asc_total + (lvi_asc_temp - 32)*i;
        else
            lvi_asc_total := lvi_asc_total + (lvi_asc_temp + 64 )*i;
        end if;
        i := i +1;
        end loop;

        lvi_check_digit :=MOD(lvi_asc_total , 103);
        if lvi_check_digit >= 95 then   --
            lvi_check_digit := lvi_check_digit + 100;
        ELSE
            lvi_check_digit := lvi_check_digit + 32;
        end if;

        --lvs_check_digit := nchr(lvi_check_digit);
        lvs_check_digit := CHR(lvi_check_digit USING NCHAR_CS);

        lvs_return := lvc_start || p_sourcetext || lvs_check_digit || lvc_stop;
        RETURN lvs_return;
    WHEN 'C' THEN
        lvi_asc_total := 104;
        lvc_start := NCHR(204);  --code128B
        lvc_stop  := NCHR(206);

        i :=1;

        WHILE i <= LENGTH(p_sourcetext) loop    --check_code
        lvi_asc_temp := ASCII(SUBSTR(p_sourcetext,i,1));
        if lvi_asc_temp >= 32 then
            lvi_asc_total := lvi_asc_total + (lvi_asc_temp - 32)*i;
        else
            lvi_asc_total := lvi_asc_total + (lvi_asc_temp + 64 )*i;
        end if;
        i := i +1;
        end loop;

        lvi_check_digit :=MOD(lvi_asc_total , 103);
        if lvi_check_digit >= 95 then   --
            lvi_check_digit := lvi_check_digit + 100;
        ELSE
            lvi_check_digit := lvi_check_digit + 32;
        end if;

        lvs_check_digit := nchr(lvi_check_digit);

        lvs_return := lvc_start || p_sourcetext || lvs_check_digit || lvc_stop;
        RETURN lvs_return;
    ELSE
        RETURN lvc_start ;
    END CASE;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN '';
   WHEN others THEN
       raise_application_error( -20003 , sqlerrm ) ;
END;
