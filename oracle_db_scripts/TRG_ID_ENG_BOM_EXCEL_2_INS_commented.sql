CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRG_ID_ENG_BOM_EXCEL_2_INS
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   ID_ENG_BOM_EXCEL_2 테이블에 엑셀 업로드 데이터가 반영될 때 기준정보 또는 BOM 관련 후속 처리를 수행한다.
   *   업로드 원천 데이터를 업무 테이블 구조에 맞춰 검증/전개하는 트리거로 추정된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: AFTER
   *   이벤트: INSERT
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   ID_ENG_BOM_EXCEL_2 - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.PARENT_PART_NO - 신규/변경 후 값 값
   *   :NEW.PART_NO - 신규/변경 후 값 값
   *   :NEW.LINE_CODE - 신규/변경 후 라인 관련 값
   *   :NEW.MACHINE - 신규/변경 후 설비 관련 값
   *   :NEW.LOCATION - 신규/변경 후 값 값
   *   :NEW.PCB_ITEM - 신규/변경 후 PCB / 품목 관련 값
   *   :NEW.CREATE_DATE - 신규/변경 후 일자 관련 값
   *   :NEW.SEQ - 신규/변경 후 값 값
   *   :NEW.COMPONENT_QTY - 신규/변경 후 수량 관련 값
   *   :NEW.CHARGER - 신규/변경 후 값 값
   *   :NEW.LOCATION_INFO - 신규/변경 후 값 값
   *   :NEW.VERSION - 신규/변경 후 값 값
   *   :NEW.MARKING_NO - 신규/변경 후 값 값
   *   :NEW.COMMENTS - 신규/변경 후 값 값
   *   :NEW.TABLE_ID - 신규/변경 후 값 값
   *   :NEW.REPLACE_ITEM_CODE - 신규/변경 후 품목 관련 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ID_ENG_BOM_EXCEL_2 - BOM / 엑셀 관련 트리거 대상 테이블
   *   ID_ENG_BOM_SMT - BOM 관련 트리거 내부 SQL에서 참조/변경
   *   ID_ENG_BOM_SMT_REPLACE - BOM 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 10회 / 반복문: 0회
   *   DML: SELECT 2회, INSERT 3회, DELETE 2회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_ID_ENG_BOM_EXCEL_2_INS';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_ID_ENG_BOM_EXCEL_2_INS';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRG_ID_ENG_BOM_EXCEL_2_INS" 
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
