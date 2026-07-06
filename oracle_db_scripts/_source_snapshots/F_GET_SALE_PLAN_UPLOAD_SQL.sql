FUNCTION "F_GET_SALE_PLAN_UPLOAD_SQL" (
   p_division   IN   VARCHAR2,
   p_org        IN   NUMBER
)
   RETURN VARCHAR2
IS
   lvs_sql                       VARCHAR2(2000);
BEGIN
   IF p_division = 'LGESY'
   THEN
      lvs_sql :=
            'SELECT PART_NO,
           MARKET,
           TYPE,
           ORDER_NO,
           ORDER_DATE,
           DUE_DATE,
           ORDER_QTY,
           ORDER_REMAIN_QTY,
           WORK_ORDER,
           ORDER_TYPE,
           DESCRIPTION,
           ITEM_SPEC,
           ITEM_UOM,
           CURRENCY,
           UNIT_PRICE,
           DEPARTURE_QTY,
           RECEIVED_QTY,
           ASSY_PART_NIO,
           SUFFIX,
           LINE,
           REQUESTOR,
           REQUESTOR_DEPT,
           DIVISION,
           MIXED_MODEL,
           CANCEL,
           UPLOAD_DATE,
           ORGANIZATION_ID ,
           CUSTOMER_CODE ,
           EXCHANGE_RATE
      FROM IS_PRODUCT_SALE_PLAN_UPLOAD
     WHERE ORGANIZATION_ID ='
            || p_org;
   ELSIF p_division = 'LGETA'
   THEN
      lvs_sql :=
            'SELECT LINE,
            WORK_ORDER,
            MODEL_SUFFIX,
            TOTAL_QTY,
            REMAINS,
            DATE1,
            DATE2,
            DATE3,
            DATE4,
            DATE5,
            DATE6,
            DATE7,
            DATE8,
            DATE9,
            DATE10,
            DATE11,
            DATE12,
            DATE13,
            DATE14,
            DATE15,
            DATE16,
            DATE17,
            DATE18,
            DATE19,
            DATE20,
            DATE21,
            DATE22,
            DATE23,
            DATE24,
            DATE25,
            DATE26,
            DATE27,
            DATE28,
            DATE29,
            DATE30,
            DATE31,
            DATE32,
            DATE33,
            DATE34,
            DATE35,
            DUE_DATE,
            MARKET,
            BUYER,
            SERISE,
            MIXED_MODEL,
            MIXED_SEQ,
            NEW_MODEL_CLASS,
            PRODUCTION_INPUT_TIME,
            DIVISION,
            ITEM_CODE,
            CURRENCY ,
            UPLOAD_DATE,
            UPLOAD_YN,
            CUSTOMER_CODE,
            EXCHANGE_RATE,
            ORGANIZATION_ID
       FROM IS_PRODUCT_SALE_PLAN_UPLOAD2
      WHERE ORGANIZATION_ID ='
            || p_org;
   ELSIF p_division = 'LGERP'
   THEN

      lvs_sql :=
            'SELECT NO ,
                LINE_CODE,
                SCHEDULE,
                WORK_ORDER,
                PART_NO,
                TOTAL,
                REMAIN_QTY,
                DATE1,
                DATE2,
                DATE3,
                DATE4,
                DATE5,
                DATE6,
                DATE7,
                DATE8,
                DATE9,
                DATE10,
                DATE11,
                DATE12,
                DATE13,
                DATE14,
                DATE15,
                PROD_PERIOD,
                PRIORITY,
                NEED_BY_DATE,
                MARKET,
                BUYER,
                MIX_SEQ_NO,
                MIX_INFO,
                MIX_RATE,
                START_TIME,
                ITEM_CODE,
                CURRENCY ,
                UPLOAD_DATE,
                UPLOAD_YN,
                CUSTOMER_CODE,
                EXCHANGE_RATE,
                ORGANIZATION_ID
       FROM IS_PRODUCT_SALE_PLAN_UPLOAD4
      WHERE ORGANIZATION_ID ='|| p_org
       ;
   ELSIF p_division = 'SAMSUNG'
   THEN
      lvs_sql :=
            'SELECT
            START_DATE, START_TIME,
            END_DATE,
            DO_NO, PO_NO,
            ITEM_CODE,
            MAIN_ITEM,
            ITEM_PROPERTY,
            ORDER_QTY,
            LINE_CODE,
            UPLOAD_DATE,
            UPLOAD_YN,
            ORGANIZATION_ID
       FROM IS_PRODUCT_SALE_PLAN_UPLOAD3
     WHERE ORGANIZATION_ID ='
            || p_org;
   END IF;

   RETURN lvs_sql;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error(-20003, SQLERRM);
END;