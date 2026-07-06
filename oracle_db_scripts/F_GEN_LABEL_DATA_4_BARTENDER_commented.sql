CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GEN_LABEL_DATA_4_BARTENDER
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   원본 함수 로직을 기준으로 업무 값을 계산, 조회 또는 변환하여 반환한다.
   *   반환 타입은 VARCHAR2이며 호출 위치에서 후속 판단/표시에 사용된다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_RUN_NO  (IN, VARCHAR2) - 작업지시/런 번호
   *   P_MODEL_NAME  (IN, VARCHAR2) - 모델 / 명칭 관련 값
   *   P_LABEL_FORM_TYPE  (IN, VARCHAR2) - 함수 입력값
   *   P_VALUE  (IN, VARCHAR2) - 함수 입력값
   *   P_DATE  (IN, DATE) - 일자 관련 값
   *   P_QTY  (IN, VARCHAR2) - 수량
   *   P_PARAM  (IN, VARCHAR2) - 함수 입력값
   *   P_SERIAL_NO  (IN, VARCHAR2) - 시리얼 관련 값
   * ================================================================
   * [AI 분석] 반환값:
   *   VARCHAR2 - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ISYS_LABEL_FORM - 업무 기준/거래 데이터 조회 또는 참조
   *   IP_PRODUCT_PACK_MASTER - 제품 관련 값 조회 또는 참조
   *   IP_PRODUCT_MODEL_MASTER - 제품 / 모델 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_GET_BASECODE - 관련 업무 함수 호출
   * ================================================================
   * [AI 분석] 예외 처리:
   *   명시적 EXCEPTION 블록 없음 - 호출부에서 표준 Oracle 예외를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 16회, ELSIF 38회 / 반복문: 0회
   *   DML: SELECT 16회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GEN_LABEL_DATA_4_BARTENDER(...) FROM DUAL;
   * ================================================================ */
 "F_GEN_LABEL_DATA_4_BARTENDER" (
        p_run_no         IN  VARCHAR2,
        p_model_name     IN  VARCHAR2,  --모델 명 
        p_label_form_type  IN  VARCHAR2,   --라벨 구분 타입 
        p_value          IN  VARCHAR2,  --V1 - V20 컬럼값 
        p_date           IN  DATE,      --적용일자 
        p_qty            IN  VARCHAR2, --수량
        p_param          IN  VARCHAR2,  --파라메터 ( 롯트번호가 될수도 있고 , 박스번호가 될수도 있고...)
        p_serial_no      IN  VARCHAR2
) RETURN VARCHAR2 AS

    lvs_return     VARCHAR2(100);
    lvs_condition  VARCHAR2(100);
    lvi_count      NUMBER;
    lvs_lot_size   VARCHAR2(10);
---------------------------------------------------------
-- 호출후 리턴값에 * 가 섞여 있으면 오류로 판단 할것 
---------------------------------------------------------
BEGIN
    SELECT
        CASE
            WHEN p_value = 'V1'   THEN
                v1
            WHEN p_value = 'V2'   THEN
                v2
            WHEN p_value = 'V3'   THEN
                v3
            WHEN p_value = 'V4'   THEN
                v4
            WHEN p_value = 'V5'   THEN
                v5
            WHEN p_value = 'V6'   THEN
                v6
            WHEN p_value = 'V7'   THEN
                v7
            WHEN p_value = 'V8'   THEN
                v8
            WHEN p_value = 'V9'   THEN
                v9
            WHEN p_value = 'V10'  THEN
                v10
            WHEN p_value = 'V11'  THEN
                v11
            WHEN p_value = 'V12'  THEN
                v12
            WHEN p_value = 'V13'  THEN
                v13
            WHEN p_value = 'V14'  THEN
                v14
            WHEN p_value = 'V15'  THEN
                v15
            WHEN p_value = 'V16'  THEN
                v16
            WHEN p_value = 'V17'  THEN
                v17
            WHEN p_value = 'V18'  THEN
                v18
            WHEN p_value = 'V19'  THEN
                v19
            WHEN p_value = 'V20'  THEN
                v20
        END
    INTO lvs_condition
    FROM
        isys_label_form
    WHERE
            model_name = p_model_name
        AND label_form_type = p_label_form_type;

    IF lvs_condition = '' OR lvs_condition IS NULL THEN
        RETURN 'NOTFOUND';
    END IF;

 -----------------------------------------------------------------------
 --
 -----------------------------------------------------------------------
   IF lvs_condition = 'BARCODE' THEN
        RETURN p_param;
        
        
   ELSIF lvs_condition = 'PACK_CHARGER' THEN 
        
           SELECT NVL(ATTR7 , '-') INTO lvs_return
             from ip_product_pack_master
            where pack_barcode = p_param ;
            
            return lvs_return ;
            
     ELSIF lvs_condition = 'QC_PACK_CHARGER' THEN 
        
           SELECT NVL(ATTR8,'-') INTO lvs_return
             from ip_product_pack_master
            where pack_barcode = p_param ;
            
            return lvs_return ;          
            
   ELSIF lvs_condition = 'ITEM_CODE' THEN
        SELECT
            nvl(item_code, '*')
        INTO lvs_return
        FROM
            ip_product_model_master
        WHERE
            model_name = p_model_name;
        RETURN lvs_return;
    ELSIF lvs_condition = 'LOT_NO' THEN
        RETURN p_param;
    ELSIF lvs_condition = 'MADE_IN_VETNAM' THEN
        RETURN 'MADE IN VETNAM';
    ELSIF lvs_condition = 'MFG_DATE' THEN
        RETURN to_char(p_date, 'DD');
    ELSIF lvs_condition = 'MFG_MONTH_MM' THEN
        RETURN to_char(p_date, 'MM');
    ELSIF lvs_condition = 'MFG_MONTH' THEN
        IF to_char(p_date, 'MM') = '10' THEN
            RETURN 'A';
        ELSIF to_char(p_date, 'MM') = '11' THEN
            RETURN 'B';
        ELSIF to_char(p_date, 'MM') = '12' THEN
            RETURN 'C';
        ELSE
            RETURN to_number(to_char(p_date, 'MM'));
        END IF;
    ELSIF lvs_condition = 'MFG_YEAR' THEN
        RETURN to_char(p_date, 'YY');
    ELSIF lvs_condition = 'YYYY' THEN
        RETURN to_char(p_date, 'YYYY');
    ELSIF lvs_condition = 'MFG_YEAR_LAST' THEN
        RETURN to_char(p_date, 'Y');

    ELSIF lvs_condition = 'MODEL_DESC' THEN
        SELECT
            model_desc
        INTO lvs_return
        FROM
            ip_product_model_master
        WHERE
            model_name = p_model_name;

        RETURN lvs_return;
    ELSIF lvs_condition = 'MODEL_NAME' THEN
        SELECT
            model_name
        INTO lvs_return
        FROM
            ip_product_model_master
        WHERE
            model_name = p_model_name;

        RETURN lvs_return;
    ELSIF lvs_condition = 'MODEL_SPEC' THEN
        SELECT
            nvl(model_spec, '*')
        INTO lvs_return
        FROM
            ip_product_model_master
        WHERE
            model_name = p_model_name;

        RETURN lvs_return;
    ELSIF lvs_condition = 'PART_NO' THEN
        SELECT
            nvl(part_no, '*')
        INTO lvs_return
        FROM
            ip_product_model_master
        WHERE
            model_name = p_model_name;

        RETURN lvs_return;
 
 
    ELSIF lvs_condition = 'CUSTOMER_NAME' THEN
        SELECT
            nvl(customer_name, '*')
        INTO lvs_return
        FROM
            ip_product_model_master
        WHERE
            model_name = p_model_name;

        RETURN lvs_return;
        
    ELSIF lvs_condition = 'PRODUCT_CLASS' THEN
        SELECT
            nvl(product_class, '*')
        INTO lvs_return
        FROM
            ip_product_model_master
        WHERE
            model_name = p_model_name;

        RETURN lvs_return;
  
    ELSIF lvs_condition = 'PRODUCT_CLASS_NAME' THEN
        SELECT
              F_GET_BASECODE( 'PRODUCT CLASS' , nvl(product_class, '*') , 'K' , ORGANIZATION_ID ) 
        INTO lvs_return
        FROM
            ip_product_model_master
        WHERE
            model_name = p_model_name;

        RETURN lvs_return;
               
    ELSIF lvs_condition = 'CUSTOMER_MODEL_NAME' THEN
        SELECT
            nvl(customer_model_name, '*')
        INTO lvs_return
        FROM
            ip_product_model_master
        WHERE
            model_name = p_model_name;

        RETURN lvs_return;

    ELSIF lvs_condition = 'COUNTRY_CODE' THEN
        SELECT
            nvl(country_code, '*')
        INTO lvs_return
        FROM
            ip_product_model_master
        WHERE
            model_name = p_model_name;

        RETURN lvs_return;
    ELSIF lvs_condition = 'COMPANY_CODE' THEN
        SELECT
            nvl(company_code, '*')
        INTO lvs_return
        FROM
            ip_product_model_master
        WHERE
            model_name = p_model_name;

        RETURN lvs_return;

    ELSIF lvs_condition = 'QTY' THEN
        RETURN p_qty;
    ELSIF lvs_condition = 'QTY3' THEN
        RETURN trim(to_char(to_number(p_qty), '000'));
    ELSIF lvs_condition = 'QTY4' THEN
        RETURN trim(to_char(to_number(p_qty), '0000'));
    ELSIF lvs_condition = 'QTY5' THEN
        RETURN trim(to_char(to_number(p_qty), '00000'));

    ELSIF lvs_condition = 'SERIAL3' THEN
        IF p_param = 'PREVIEW' THEN
            RETURN '001';
        END IF;
        SELECT
            TRIM(to_char(seq_label_3_sequence.NEXTVAL, '000'))
        INTO lvs_return
        FROM
            dual;

        RETURN lvs_return;
    ELSIF lvs_condition = 'SERIAL4' THEN
        IF p_param = 'PREVIEW' THEN
            RETURN '0001';
        END IF;
        SELECT
            TRIM(to_char(seq_label_4_sequence.NEXTVAL, '0000'))
        INTO lvs_return
        FROM
            dual;

        RETURN lvs_return;
    ELSIF lvs_condition = 'YY/MM/DD' THEN
        RETURN to_char(p_date, 'YY/MM/DD');
    ELSIF lvs_condition = 'YYMMDD' THEN
        RETURN to_char(p_date, 'YYMMDD');
    ELSIF lvs_condition = 'YYYY.MM.DD' THEN
        RETURN to_char(p_date, 'YYYY.MM.DD');
    ELSIF lvs_condition = 'YYYYMMDD' THEN
        RETURN to_char(p_date, 'YYYYMMDD');
        
    ELSIF lvs_condition = 'YYMMDDNN' THEN   -- YYMMDDNN 해당 item 에 대한 롯트순번 , BOX 번호에서 채번 한다 ( 2023/02/11 이대리요청 )
        RETURN substr(p_param, 1, 8);    
        
    ELSIF lvs_condition = 'BARCODE' THEN
        RETURN p_serial_no;
    ELSIF lvs_condition = 'SERIAL_NUMBER4' THEN
        IF p_param = 'PREVIEW' THEN
            RETURN '0001';
        END IF;
        RETURN trim(to_char(to_number(p_param), '0000'));
    ELSIF lvs_condition = 'SERIAL_NUMBER5' THEN
        IF p_param = 'PREVIEW' THEN
            RETURN '00001';
        END IF;
        RETURN trim(to_char(to_number(p_param), '00000'));
    ELSIF lvs_condition = 'SERIAL_NUMBER6' THEN
        IF p_param = 'PREVIEW' THEN
            RETURN '000001';
        END IF;
        RETURN trim(to_char(to_number(p_param), '000000'));
    ELSE
        RETURN lvs_condition; --고정 문자로 판단 그냥 리턴 
                END IF;

END;
