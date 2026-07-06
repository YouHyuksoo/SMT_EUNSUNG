CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_ITEM_CODE_FROM_BARCODE_S
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
   *   P_SUPPLIER_CODE  (IN, VARCHAR2) - 공급사 관련 값
   * ================================================================
   * [AI 분석] 반환값:
   *   VARCHAR2 - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ID_ITEM - 품목 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_GET_PREPARE_SUPPLIER_BARCODE - 관련 업무 함수 호출
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 10회, ELSIF 2회 / 반복문: 0회
   *   DML: SELECT 5회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_ITEM_CODE_FROM_BARCODE_S(...) FROM DUAL;
   * ================================================================ */
 "F_GET_ITEM_CODE_FROM_BARCODE_S" (
   p_barcode IN VARCHAR2,
   p_supplier_code IN VARCHAR2)
   RETURN VARCHAR2
IS
   lvi_pos1     NUMBER;
   lvi_pos2     NUMBER;
   lvi_pos3   number ;
   lvi_gap      NUMBER;
   lvs_return   VARCHAR2 (300);
   lvs_barcode  varchar2(300);
   lvs_item     VARCHAR2 (30);
   lvi_count    NUMBER;

BEGIN
   ---------------------------------------------------------
   --
   ---------------------------------------------------------
   lvs_barcode := F_GET_PREPARE_SUPPLIER_BARCODE(p_barcode) ;
   
   --------------------------------------------------------
   --  item code 찾는 로직
   --------------------------------------------------------

   BEGIN
   
         BEGIN 
          -- 1차적으로 정확하게 맞는것 체크 
           select item_code
           into lvs_item
           from id_item
          where supplier_code = p_supplier_code AND 
             ( item_code = lvs_barcode  or TRIM(part_no) like TRIM(lvs_barcode)   )
             and length(item_code) > 5
             ;
            
            IF ( SQL%ROWCOUNT  = 1 ) THEN
              RETURN lvs_item;
            END IF;
            
           EXCEPTION WHEN NO_DATA_FOUND THEN 
                NULL ;
           END ;
  
        BEGIN         -- 시작문자로 시작하면서 포함 여부 체크 
         select item_code
           into lvs_item
           from id_item
          where supplier_code = p_supplier_code AND 
             ( item_code = lvs_barcode
             or TRIM(part_no)   like TRIM(lvs_barcode)
             or instr( part_no, lvs_barcode ) > 0
             or instr( lvs_barcode, part_no ) = 1)
             and length(item_code) > 5
             ;

        IF ( SQL%ROWCOUNT  = 1 ) THEN
             RETURN lvs_item;
        END IF;


         EXCEPTION WHEN NO_DATA_FOUND THEN 
                NULL ;
          END ;
  
  
  
       BEGIN         -- 시작 포함 중간어딘가에 포함 여부 체크 
         select item_code
           into lvs_item
           from id_item
          where supplier_code = p_supplier_code AND 
             ( item_code = lvs_barcode
             or TRIM(part_no)   like TRIM(lvs_barcode)
             or instr( part_no, lvs_barcode ) > 0
             or instr( lvs_barcode, part_no ) > 0)
             and length(item_code) > 5
             ;

        IF ( SQL%ROWCOUNT  = 1 ) THEN
             RETURN lvs_item;
        END IF;


         EXCEPTION WHEN NO_DATA_FOUND THEN 
                NULL ;
          END ;
           
           
   EXCEPTION
            WHEN OTHERS THEN               
                 NULL; 
   END; 
   
   
 --  RETURN p_barcode ;   -- 더이상 찾지 않는다
   
   

   --------------------------------------------------------
   -- 자사바코드 포맷
   --------------------------------------------------------
   lvi_pos1 := INSTR (lvs_barcode, '-', 1,1);
   lvi_pos2 := INSTR (lvs_barcode, '-', 1,2);
   lvi_pos3 := INSTR (lvs_barcode, '-', 1,3);
   
  
   IF lvi_pos1 = 0  THEN 
      lvs_return :=   lvs_barcode ;
   ELSIF  lvi_pos1 > 0 AND  lvi_pos2 > 0 AND lvi_pos3 = 0 THEN 
         lvs_return := TRIM (SUBSTR (lvs_barcode, 1, INSTR (lvs_barcode, '-', 1,1) - 1));       
   --품목코드에 "-" 가 포함되어 있다는 의미로 두번쨰꺼 까지 포함해서 품목으로 잘나냄      
   ELSIF  lvi_pos1 > 0 AND  lvi_pos2 > 0 AND lvi_pos3 > 0 THEN 
         lvs_return := TRIM (SUBSTR (lvs_barcode, 1,INSTR (lvs_barcode, '-', 1,2) - 1   ));  
   END IF;

   --------------------------------------------------------
   -- 원자재 바코드 확인
   --------------------------------------------------------
 begin 
   SELECT COUNT(*)
     INTO lvi_count
     FROM ID_ITEM
    WHERE ITEM_CODE = lvs_return
      AND supplier_code = p_supplier_code;
  EXCEPTION
            WHEN no_data_found THEN               
                 lvi_count := 0 ;       
end ;

   IF ( lvi_count = 0 ) THEN

        lvs_item := lvs_return;

        BEGIN

           SELECT item_code
             INTO lvs_return
             FROM ID_ITEM
            WHERE supplier_code = p_supplier_code
              AND ( INSTR(lvs_return, part_no) > 0 OR   INSTR(part_no , lvs_return) > 0 ) 
              AND ROWNUM = 1;

        EXCEPTION
            WHEN OTHERS THEN               
                 lvs_return := lvs_item; 
        END; 
        
        RETURN NVL(lvs_return , '*') ;
   ELSE
        RETURN NVL(lvs_return , '*') ;
   END IF;
   

-----------------------------------------------------------------------------
EXCEPTION
   WHEN OTHERS THEN
        RETURN lvs_barcode;
END;
