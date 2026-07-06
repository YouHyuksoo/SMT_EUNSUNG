CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_ITEM_CODE_FROM_BARCODE
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
   *   P_BARCODE  (IN, VARCHAR2) - 바코드
   * ================================================================
   * [AI 분석] 반환값:
   *   VARCHAR2 - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ID_ITEM - 품목 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 10회 / 반복문: 0회
   *   DML: SELECT 5회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_ITEM_CODE_FROM_BARCODE(...) FROM DUAL;
   * ================================================================ */
 F_GET_ITEM_CODE_FROM_BARCODE (
   p_barcode IN VARCHAR2)
   RETURN VARCHAR2
IS
   lvi_pos1     NUMBER;
   lvi_pos2     NUMBER;
   lvi_pos3     NUMBER; 

   lvi_gap      NUMBER;
   lvs_return   VARCHAR2 (300);
   lvs_barcode  varchar2(300);
   
   lvs_item     VARCHAR2 (30);
   lvi_count    NUMBER;
   
BEGIN
   
   
   lvs_barcode :=  p_barcode ;
  
   --------------------------------------------------------
   --  
   --------------------------------------------------------

   select regexp_count( lvs_barcode, '-') 
     into lvi_count
     from dual;
    
    
   if ( lvi_count = 2 ) then
             
        select regexp_substr( lvs_barcode, '[^-]+', 1,1 ) 
          into lvs_item
          from dual;
          
        if ( length( lvs_item ) > 9 and length( lvs_item ) < 14 ) then
          
              return lvs_item;   
        
        end if;
             
    end if;         
             
   
   --------------------------------------------------------
   --  item code 찾는 로직
   --------------------------------------------------------
   
   BEGIN
     
         select item_code
           into lvs_item
           from id_item
          where ( item_code = p_barcode
             or part_no   like p_barcode
             or instr( part_no, p_barcode ) > 0
             or instr( p_barcode, part_no ) > 0)
             and length(item_code) > 5
             ;
             
        IF ( SQL%ROWCOUNT = 1 ) THEN
          
             RETURN lvs_item;
             
        END IF;
     
   EXCEPTION
            WHEN OTHERS THEN               
                 NULL; 
   END; 
          
   --------------------------------------------------------
   -- 자사바코드 포맷
   --------------------------------------------------------
   lvi_pos1 := INSTR (lvs_barcode, '-', 1,1);
   lvi_pos2 := INSTR (lvs_barcode, '-', 1,2);
   lvi_pos3 := INSTR (lvs_barcode, '-', 1,3);
   
   --두개짜리 바코드 이면 
   IF lvi_pos3 = 0  THEN 
        lvs_return := TRIM (SUBSTR (lvs_barcode, 1, INSTR (lvs_barcode, '-', 1,1) - 1));        
   ELSE
        lvs_return := TRIM (SUBSTR (lvs_barcode, 1,INSTR (lvs_barcode, '-', 1,2) - 1   ));  
   END IF;
   
   --------------------------------------------------------
   -- 원자재 바코드 확인
   --------------------------------------------------------
   
   SELECT COUNT(*)
     INTO lvi_count
     FROM ID_ITEM
    WHERE ITEM_CODE = lvs_return;
    
   IF ( lvi_count = 0 ) THEN
     
        lvs_item := lvs_return;
     
        BEGIN
          
           SELECT item_code
             INTO lvs_return
             FROM ID_ITEM
            WHERE ( INSTR(lvs_return, part_no) > 0 OR INSTR( part_no , lvs_return) > 0 ) 
              AND ROWNUM = 1;
        
        EXCEPTION
            WHEN OTHERS THEN               
                 lvs_return := lvs_item; 
        END; 
   
   END IF;
        
   RETURN lvs_return;
         
   
EXCEPTION
   WHEN OTHERS THEN
        RETURN lvs_barcode;
END;
