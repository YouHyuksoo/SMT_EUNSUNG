TRIGGER "INFINITY21_JSMES"."TRG_ID_ENG_BOM_EXCEL_2_INS" 
 AFTER
 INSERT
 ON ID_ENG_BOM_EXCEL_2  REFERENCING OLD AS OLD NEW AS NEW
 FOR EACH ROW
DECLARE
    lvi_child_count    NUMBER;
    lvi_parent_count   NUMBER;
    lvi_bom_count      NUMBER;
    phase              VARCHAR2 (10);
BEGIN
    phase := '10';


    ------------------------------------------------------------
    --
    ------------------------------------------------------------
    BEGIN
        SELECT   COUNT ( * )
          INTO   lvi_bom_count
          FROM   id_eng_bom_smt
         WHERE       parent_item_code = :new.parent_part_no
                 AND child_item_code = :new.part_no
                 AND line_code = :new.line_code
                 AND machine = :new.machine
                 AND location_code = :new.location
                 AND pcb_item = :new.pcb_item
                 AND organization_id = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            lvi_bom_count := 0;
        WHEN OTHERS
        THEN
            raise_application_error (-20003, SQLERRM);
    END;

    phase := '80';

    IF lvi_bom_count > 0
    THEN
        DELETE FROM   id_eng_bom_smt
              WHERE       parent_item_code = :new.parent_part_no
                      AND child_item_code = :new.part_no
                      AND line_code = :new.line_code
                      AND machine = :new.machine
                      AND location_code = :new.location
                      AND pcb_item = :new.pcb_item
                      AND organization_id = 1;
    END IF;

    phase := '90';

    IF    NVL (:new.line_code, '*') = '*'
       OR NVL (:new.machine, '*') = ''
       OR NVL (:new.location, '*') = '*'
    THEN
        NULL;
    ELSE
        INSERT INTO id_eng_bom_smt (parent_item_code,
                                    child_item_code,
                                    bom_level,
                                    dateset,
                                    dateend,
                                    location_code,
                                    organization_id,
                                    sort_sequence,
                                    item_unit_qty,
                                    workstage_code,
                                    bom_work_no,
                                    item_type,
                                    line_type,
                                    enter_by,
                                    enter_date,
                                    last_modify_by,
                                    last_modify_date,
                                    location_info,
                                    line_code,
                                    machine,
                                    version,
                                    pcb_item,
                                    marking_no,
                                    comments,
                                    table_id)
          VALUES   (:new.parent_part_no,
                    :new.part_no,
                    1,
                    :new.create_date,                               --DATESET,
                    TO_DATE ('99991231', 'YYYYMMDD'),
                    --DATEEND,
                    :new.location,
                    1,                                      --ORGANIZATION_ID,
                    :new.seq,                                 --SORT_SEQUENCE,
                    :new.component_qty,
                    '*',                                     --WORKSTAGE_CODE,
                    0,                                          --BOM_WORK_NO,
                    'T',                                          --ITEM_TYPE,
                    'G',                                          --LINE_TYPE,
                    :new.charger,                                  --ENTER_BY,
                    :new.create_date,                            --ENTER_DATE,
                    :new.charger,                            --LAST_MODIFY_BY,
                    SYSDATE,                                --LAST_MODIFY_DATE
                    :new.location_info,
                    :new.line_code,
                    :new.machine,
                    NVL (:new.version, 0),
                    :new.pcb_item,
                    NVL (:new.marking_no, '*'),
                    :new.comments,
                    :new.table_id);
    END IF;

    ---------------------------------------------------
    --REPLACE
    ---------------------------------------------------
    IF NVL (:new.replace_item_code, '*') <> '*'
    THEN
        phase := '100';

        BEGIN
            SELECT   COUNT ( * )
              INTO   lvi_bom_count
              FROM   id_eng_bom_smt_replace
             WHERE       parent_item_code = :new.parent_part_no
                     AND child_item_code = :new.part_no
                     AND location_code = :new.location
                     AND replace_item_code = :new.replace_item_code
                     AND line_code = :new.line_code
                     AND machine = :new.machine
                     AND pcb_item = :new.pcb_item
                     AND organization_id = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                lvi_bom_count := 0;
            WHEN OTHERS
            THEN
                raise_application_error (-20003, SQLERRM);
        END;

        phase := '110';

        IF lvi_bom_count > 0
        THEN
            DELETE FROM   id_eng_bom_smt_replace
                  WHERE       parent_item_code = :new.parent_part_no
                          AND child_item_code = :new.part_no
                          AND location_code = :new.location
                          AND replace_item_code = :new.replace_item_code
                          AND line_code = :new.line_code
                          AND machine = :new.machine
                          AND pcb_item = :new.pcb_item
                          AND organization_id = 1;
        END IF;

        phase := '120';

        IF    NVL (:new.line_code, '*') = '*'
           OR NVL (:new.machine, '*') = ''
           OR NVL (:new.location, '*') = '*'
        THEN
            NULL;
        ELSE
            INSERT INTO id_eng_bom_smt_replace (parent_item_code,
                                                child_item_code,
                                                replace_item_code,
                                                bom_level,
                                                dateset,
                                                dateend,
                                                location_code,
                                                organization_id,
                                                sort_sequence,
                                                item_unit_qty,
                                                workstage_code,
                                                bom_work_no,
                                                item_type,
                                                line_type,
                                                enter_by,
                                                enter_date,
                                                last_modify_by,
                                                last_modify_date,
                                                line_code,
                                                machine,
                                                table_id,
                                                pcb_item)
              VALUES   (:new.parent_part_no,
                        :new.part_no,
                        :new.replace_item_code,
                        1,
                        :new.create_date,                           --DATESET,
                        TO_DATE ('99991231', 'YYYYMMDD'),           --DATEEND,
                        :new.location,
                        1,                                  --ORGANIZATION_ID,
                        :new.seq,                             --SORT_SEQUENCE,
                        :new.component_qty,
                        '*',                                 --WORKSTAGE_CODE,
                        0,                                      --BOM_WORK_NO,
                        'T',                                      --ITEM_TYPE,
                        'G',                                      --LINE_TYPE,
                        :new.charger,                            --ENTER_DATE,
                        :new.create_date,                        --ENTER_DATE,
                        :new.charger,                        --LAST_MODIFY_BY,
                        SYSDATE,                            --LAST_MODIFY_DATE
                        :new.line_code,
                        :new.machine,
                        :new.table_id,
                        :new.pcb_item);
        END IF;
    END IF;
EXCEPTION
    WHEN OTHERS
    THEN
        raise_application_error (
            -20003,
             SQLERRM||' PHASE='
            || phase
            || ' '
            || :new.parent_part_no
            || ' '
            || :new.part_no
            || '  line='
            || :new.line_code
            || ' Machine='
            || :new.machine
            || ' Pos='
            || :new.location
             );
END;