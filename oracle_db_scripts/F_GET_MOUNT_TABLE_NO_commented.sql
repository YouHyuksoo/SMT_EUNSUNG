CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_MOUNT_TABLE_NO
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
   *   P_LINE_CODE  (IN, varchar2) - 라인 코드
   *   P_MACHINE_CODE  (IN, varchar2) - 함수 입력값
   *   P_TABLE_CODE  (IN, varchar2) - 함수 입력값
   * ================================================================
   * [AI 분석] 반환값:
   *   varchar2 - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   없음 (순수 연산 함수 또는 원본 소스 기준 명시 테이블 없음)
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 26회, ELSIF 30회 / 반복문: 0회
   *   DML: 없음
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_MOUNT_TABLE_NO(...) FROM DUAL;
   * ================================================================ */
 "F_GET_MOUNT_TABLE_NO" 
  (
    p_line_code    IN varchar2,
    p_machine_code IN varchar2,
    p_table_code   IN varchar2
  )
  RETURN  varchar2 IS

   ls_return   VARCHAR2(100);

BEGIN

    -- 01 ？？
    IF p_line_code in ('01') THEN

       -- 1？？？
       IF   substr(p_machine_code,-2) = '01' THEN

          IF    p_table_code = '1' THEN
                ls_return := 'A';
          ELSIF p_table_code = '2' THEN
                ls_return := 'B';
          ELSIF p_table_code = '3' THEN
                ls_return := 'C';
          ELSIF p_table_code = '4' THEN
                ls_return := 'D';
          ELSE
                ls_return := p_table_code;
          END IF;

       -- 2？？？
       ELSIF substr(p_machine_code,-2) = '02' THEN

          IF    p_table_code = '1' THEN
                ls_return := 'E';
          ELSIF p_table_code = '2' THEN
                ls_return := 'F';
          ELSIF p_table_code = '3' THEN
                ls_return := 'G';
          ELSIF p_table_code = '4' THEN
                ls_return := 'H';
          ELSE
                ls_return := p_table_code;
          END IF;

       ELSIF substr(p_machine_code,-2) = '03' THEN

          IF    p_table_code = '1' THEN
                ls_return := 'I';
          ELSIF p_table_code = '2' THEN
                ls_return := 'J';
          ELSIF p_table_code = '3' THEN
                ls_return := 'K';
          ELSIF p_table_code = '4' THEN
                ls_return := 'L';
          ELSE
                ls_return := p_table_code;
          END IF;

       ELSIF substr(p_machine_code,-2) = '04' THEN

          IF    p_table_code = '1' THEN
                ls_return := 'N';
          ELSIF p_table_code = '2' THEN
                ls_return := 'M';
          ELSIF p_table_code = '3' THEN
                ls_return := 'O';
          ELSIF p_table_code = '4' THEN
                ls_return := 'P';
          ELSE
                ls_return := p_table_code;
          END IF;

       ELSIF substr(p_machine_code,-2) = '05' THEN

          IF    p_table_code = '1' THEN
                ls_return := 'Q';
          ELSIF p_table_code = '2' THEN
                ls_return := 'R';
          ELSE
                ls_return := p_table_code;
          END IF;

       ELSE

          ls_return := p_table_code;

       END IF;

    ELSIF p_line_code in ('05','06','07') THEN

       IF   substr(p_machine_code,-2) = '01' THEN

          IF    p_table_code = '1' THEN
                ls_return := 'A';
          ELSIF p_table_code = '2' THEN
                ls_return := 'B';
          ELSIF p_table_code = '3' THEN
                ls_return := 'C';
          ELSIF p_table_code = '4' THEN
                ls_return := 'D';
          ELSE
                ls_return := p_table_code;
          END IF;

       ELSIF substr(p_machine_code,-2) = '02' THEN

          IF    p_table_code = '1' THEN
                ls_return := 'E';
          ELSIF p_table_code = '2' THEN
                ls_return := 'F';
          ELSIF p_table_code = '3' THEN
                ls_return := 'G';
          ELSIF p_table_code = '4' THEN
                ls_return := 'H';
          ELSE
                ls_return := p_table_code;
          END IF;

       ELSIF substr(p_machine_code,-2) = '03' THEN

          IF    p_table_code = '1' THEN
                ls_return := 'I';
          ELSIF p_table_code = '2' THEN
                ls_return := 'J';
          ELSE
                ls_return := p_table_code;
          END IF;

       ELSIF substr(p_machine_code,-2) = '04' THEN

          IF    p_table_code = '1' THEN
                ls_return := 'K';
          ELSIF p_table_code = '2' THEN
                ls_return := 'L';
          ELSE
                ls_return := p_table_code;
          END IF;

       ELSIF substr(p_machine_code,-2) = '05' THEN

          IF    p_table_code = '1' THEN
                ls_return := 'M';
          ELSE
                ls_return := p_table_code;
          END IF;

       ELSE

           ls_return := p_table_code;

       END IF;

    ELSE

       ls_return := p_table_code;

    END IF;

    return ls_return;

EXCEPTION
   WHEN others THEN
       raise_application_error( -20003 , sqlerrm ) ;
END;
