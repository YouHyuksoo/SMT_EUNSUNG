CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"."TRG_IP_PRODUCT_RESULT_DEL" 
 AFTER
  DELETE
 ON ip_product_result
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
    lvi_count            NUMBER;
    lvi_seq              NUMBER;
    lvi_return           NUMBER;
    lvs_line_code        VARCHAR2 (20);
    lvs_workstage_code   VARCHAR2 (20);
    lvs_machine_code     VARCHAR2 (20);
    lvs_config_value     VARCHAR2 (1);
BEGIN
    /* ================================================================
     * 트리거명  : TRG_IP_PRODUCT_RESULT_DEL
     * 작성일  : 2026-07-02
     * 수정이력: 2026-07-02 - AI(Codex) - 한글 주석 자동 추가
     * ================================================================
     * [AI 분석] 기능 설명:
     *   IP_PRODUCT_RESULT 테이블의 DELETE 이벤트 발생 시 원본 로직에 정의된 자동 처리를 수행한다.
     * ================================================================
     * [AI 분석] 발화 조건:
     *   시점/단위: AFTER EACH ROW / 이벤트: DELETE / 조건: 없음
     * ================================================================
     * [AI 분석] 대상 객체:
     *   IP_PRODUCT_RESULT - 트리거가 걸린 테이블/뷰
     * ================================================================
     * [AI 분석] OLD/NEW 사용:
     *   :OLD - PRODUCT_ACTUAL_QTY, PLAN_DATE, PLAN_DATE_SEQUENCE, ORGANIZATION_ID, ITEM_CODE, LINE_CODE, WORKSTAGE_CODE, MACHINE_CODE, MOLD_CODE, MOLD_VERSION 변경 전 값 참조
     * ================================================================
     * [AI 분석] 예외 처리:
     *   원본 EXCEPTION 블록 기준으로 오류를 처리한다.
     * ================================================================
     * [AI 분석] 복잡도:
     *   조건 분기: IF 10회 / 반복문: 0회 / DML: SELECT 4회, INSERT 1회, UPDATE 5회, DELETE 1회
     * ================================================================
     * 검증 방법: USER_OBJECTS, USER_ERRORS, USER_SOURCE, USER_TRIGGERS 조회만 사용한다.
     * 주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
     * ================================================================ */

    IF :old.product_actual_qty = 0
    THEN
        NULL;
    ELSE
        BEGIN
            SELECT   COUNT ( * )
              INTO   lvi_count
              FROM   ip_product_master_plan
             WHERE       plan_date = :old.plan_date
                     AND plan_date_sequence = :old.plan_date_sequence
                     AND organization_id = :old.organization_id;

            IF lvi_count = 0
            THEN
                NULL;
            -- raise_application_error (-20003,    'Plan Not Found'|| SQLERRM);
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                NULL;
        --  raise_application_error (-20003,    'Plan Not Found'                                          || SQLERRM);
        END;

        UPDATE   ip_product_master_plan
           SET   product_actual_qty =
                     NVL (product_actual_qty, 0) - :old.product_actual_qty,
                 plan_status = 'P'
         WHERE       plan_date = :old.plan_date
                 AND plan_date_sequence = :old.plan_date_sequence
                 AND organization_id = :old.organization_id;


        ----------------------------------------------------------
        -- Plan Status Flag Change
        ----------------------------------------------------------
        UPDATE   ip_product_master_plan
           SET   plan_status = 'W'
         WHERE       plan_date = :old.plan_date
                 AND plan_date_sequence = :old.plan_date_sequence
                 AND product_actual_qty = 0
                 AND organization_id = :old.organization_id;


        ----------------------------------------------------------
        -- Machine Capacity
        ----------------------------------------------------------

        UPDATE   ip_product_daily_mcn_capacity
           SET   reserved_capacity =
                     NVL (reserved_capacity, 0)
                     + (NVL (:old.product_actual_qty, 0)
                        * NVL (f_get_product_st (:old.item_code,
                                                 :old.line_code,
                                                 :old.workstage_code,
                                                 :old.machine_code,
                                                 :old.organization_id), 0))
         WHERE       machine_code = :old.machine_code
                 AND plan_date = :old.plan_date
                 AND organization_id = :old.organization_id;


        ------------------------------------
        -- MOLD ACTUAL CHANGE
        ------------------------------------
        -- SYSTEM CONFIG VALUE GET
        -- CURRENT VALUE = Y
        ------------------------------------
        BEGIN
            SELECT   NVL (config_value, 'P')
              INTO   lvs_config_value
              FROM   isys_config
             WHERE       config_name = 'MOLD_ACTUAL_TYPE'
                     AND use_yn = 'Y'
                     AND organization_id = :old.organization_id;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                lvs_config_value := 'P';                      --PRODUCT RESULT
            WHEN OTHERS
            THEN
                raise_application_error (-20003, SQLERRM);
        END;

        IF lvs_config_value = 'S'                                       --SALE
        THEN
            NULL;
        ELSE
            UPDATE   imcn_mold_inventory
               SET   actual_value =
                         NVL (actual_value, 0)
                         - NVL (:old.product_actual_qty, 0)
             WHERE       mold_code = :old.mold_code
                     AND mold_version = :old.mold_version
                     AND mold_set_serial = :old.mold_set_serial
                     AND organization_id = :old.organization_id;
        END IF;

        BEGIN
            SELECT   a.line_code, a.workstage_code, a.machine_code
              INTO   lvs_line_code, lvs_workstage_code, lvs_machine_code
              FROM   ip_product_master_plan a
             WHERE       a.plan_date = :old.plan_date
                     AND a.plan_date_sequence = :old.plan_date_sequence
                     AND a.organization_id = :old.organization_id;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                raise_application_error (
                    -20003,
                    'Product Master Plan Not Found ' || SQLERRM);
        END;


        -------------------------------------------------------
        -- Workstage Inventory
        -------------------------------------------------------

        UPDATE   im_item_workstage_receipt
           SET   receipt_status = 'C'
         WHERE       item_code = :old.item_code
                 AND line_type = :old.product_line_type
                 AND mfs = :old.mfs
                 AND line_code = :old.line_code
                 AND workstage_code = :old.workstage_code
                 AND transfer_date = :old.product_date
                 AND transfer_sequence = :old.product_sequence
                 AND plan_date = :old.plan_date
                 AND plan_date_sequence = :old.plan_date_sequence
                 AND organization_id = :old.organization_id;

        INSERT INTO im_item_workstage_receipt (receipt_date,
                                               receipt_sequence,
                                               organization_id,
                                               workstage_code,
                                               from_workstage_code,
                                               machine_code,
                                               material_mfs,
                                               mfs,
                                               item_code,
                                               item_type,
                                               line_type,
                                               line_code,
                                               receipt_deficit,
                                               receipt_price,
                                               receipt_qty,
                                               receipt_weight,
                                               receipt_amt,
                                               receipt_type,
                                               receipt_account,
                                               item_unit_weight,
                                               issue_date,
                                               issue_sequence,
                                               work_order_no,
                                               receipt_status,
                                               transfer_date,
                                               transfer_sequence,
                                               transfer_type,
                                               invoice_no,
                                               enter_date,
                                               enter_by,
                                               last_modify_date,
                                               last_modify_by,
                                               plan_date,
                                               plan_date_sequence)
          VALUES   (:old.product_date,
                    seq_workstage_receipt_seq.NEXTVAL,
                    :old.organization_id,
                    :old.workstage_code,
                    'WH',
                    :old.machine_code,
                    :old.mfs,
                    :old.mfs,
                    :old.item_code,
                    'T',                                     --:NEW.item_type,
                    :old.product_line_type,
                    :old.line_code,
                    2,                                       --receipt_deficit
                    0,                                   --:NEW.receipt_price,
                    :old.product_actual_qty * -1,
                    :old.product_actual_qty * -1,            --RECEIPT_WEIGHT,
                    0,                                     --:NEW.receipt_amt,
                    'N',     --:NEW.receipt_type, --RECEIPT_TYPE,AUTO / NORMAL
                    'M001',                            --:NEW.receipt_account,
                    1,                                     --ITEM_UNIT_WEIGHT,
                    NULL,                                        --ISSUE_DATE,
                    NULL,                                    --ISSUE_SEQUENCE,
                    '',                                  --:NEW.work_order_no,
                    'C',                                     --RECEIPT_STATUS,
                    :old.product_date,                        --transfer_date,
                    seq_workstage_receipt_seq.NEXTVAL,    --TRANSFER_SEQUENCE,
                    'C',
                    '',                                     --:NEW.invoice_no,
                    SYSDATE,
                    :old.enter_by,
                    SYSDATE,
                    :old.last_modify_by,
                    :old.plan_date,
                    :old.plan_date_sequence);


        ------------------------------------------------------------
        -- Child Item Auto Issue
        ------------------------------------------------------------
        ------------------------------------
        -- SYSTEM CONFIG VALUE GET
        -- CURRENT VALUE = Y
        ------------------------------------
        BEGIN
            SELECT   NVL (config_value, 'N')
              INTO   lvs_config_value
              FROM   isys_config
             WHERE       config_name = 'PRODUCT_WORKSTAGE_ISSUE_YN'
                     AND use_yn = 'Y'
                     AND organization_id = :old.organization_id;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                lvs_config_value := 'N';
            WHEN OTHERS
            THEN
                raise_application_error (-20003, SQLERRM);
        END;

        IF lvs_config_value = 'N'
        THEN
            NULL;
        ELSE
            BEGIN
                lvi_return :=
                    pkg_planning.plan_prod_child_item_issue (
                        :old.product_date                          /*IN DATE*/
                                         ,
                        :old.product_sequence                    /*IN NUMBER*/
                                             ,
                        :old.mfs                               /*IN VARCHAR2*/
                                ,
                        :old.item_code                         /*IN VARCHAR2*/
                                      ,
                        lvs_line_code                          /*IN VARCHAR2*/
                                     ,
                        lvs_workstage_code                     /*IN VARCHAR2*/
                                          ,
                        lvs_machine_code                       /*IN VARCHAR2*/
                                        ,
                        :old.product_actual_qty                  /*IN NUMBER*/
                                               ,
                        'C'                                    /*IN VARCHAR2*/
                           ,
                        :old.organization_id                     /*IN NUMBER*/
                                            );

                IF lvi_return < 0
                THEN
                    raise_application_error (-20003,
                                             'Child Item Issue ' || SQLERRM);
                END IF;
            EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                    raise_application_error (-20003,
                                             'Child Item Issue ' || SQLERRM);
            END;
        END IF;
    ------------------------------------------------------------

    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        raise_application_error (-20003, SQLERRM);
    WHEN OTHERS
    THEN
        raise_application_error (
            -20003,
               'Plan Date ='
            || :old.plan_date
            || 'Plan Sequence='
            || :old.plan_date_sequence
            || ' '
            || SQLERRM);
END;
