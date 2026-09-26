-- PKG_MES_SMT — PB 이관 산출물 전용 SMT 패키지
--
-- 기존 전역 FUNCTION/PROCEDURE 와 이름이 충돌하지 않도록
-- 웹 이관으로 생기는 오브젝트는 전부 이 패키지 안에만 만든다.
-- standalone FUNCTION/PROCEDURE 로 만들지 않는다.
--
-- 오브젝트를 추가할 때는 이 파일에 얹어 SPEC/BODY 를 통째로 다시 배포한다.
--
-- ─────────────────────────────────────────────────────────────────────────
-- 이 패키지가 PB 원본과 의도적으로 다른 점 (전부 조직경계·데이터보존 문제)
--
--   1) PB w_smt_line_master cb_4('Delete All') 은 `delete from ib_machine_location;`
--      이었다. WHERE 가 아예 없어 모든 라인·설비·조직의 위치가 지워진다.
--      SP_SMT_LOCATION_DELETE 는 라인 + 설비 + 조직으로 범위를 좁혔다.
--
--   2) PB w_smt_location_master cb('Delete All') 은 라인 + 설비만 봤다.
--      ORGANIZATION_ID 가 없어 다른 조직의 위치까지 지워진다. 조직을 추가했다.
--
--   3) PB w_smt_plan_master 의 배포 전 활성계획 검사는
--      WHERE LINE_CODE / MODEL_NAME / PCB_ITEM 만 봤다. 조직이 없어 다른 조직의
--      활성계획 때문에 배포가 막히거나, 반대로 통과했다. 조직을 추가했다.
--
--   4) PB 배포 INSERT 의 원천 SELECT(ID_ENG_BOM_SMT / _REPLACE) 에도
--      ORGANIZATION_ID 조건이 없어 다른 조직 BOM 이 섞여 들어왔다. 조직을 추가했다.
--
--   5) PB 배포는 PLAN_DATE(VARCHAR2(30)) 에 일반품목은 SYSDATE 를 그대로,
--      대체품목은 TO_CHAR(SYSDATE,'YYYYMMDD') 를 넣었다. 앞쪽은 세션 NLS 에 따라
--      문자열이 달라진다 — 실제로 IB_PRODUCT_PLANDATA 18,568행이 'DD-MON-YY',
--      14행이 'YYYYMMDD' 다. 여기서는 **둘 다 'YYYYMMDD'** 로 넣는다.
--      기존 데이터는 건드리지 않는다 (데이터 정정은 별도 승인 사안).
-- ─────────────────────────────────────────────────────────────────────────

CREATE OR REPLACE PACKAGE PKG_MES_SMT AS

  /**
   * PB w_smt_line_master cb_3('Generate') 이관 (2026-09-27)
   *
   * 라인 + 설비에 대해 마운터 테이블·주소·좌우 위치 조합으로
   * IB_MACHINE_LOCATION 행을 한 번에 만든다.
   *   LOCATION_CODE = 테이블문자 || LPAD(주소,2,'0') || 위치문자
   *   예) p_table_id='C', 주소 1~3, 위치 'LR'  →  C01L C01R C02L C02R C03L C03R
   *
   * p_all_tables = 'Y' 이면 테이블문자를 'A' 부터 p_table_id 까지 전부 돈다.
   *   PB 의 cbx_all 분기와 같은 동작이다. 단 PB 는 그 분기에서
   *   좌/우 라디오버튼을 무시하고 언제나 L 과 R 을 만들었고, 주소 시작값도
   *   무시해 0 부터 시작했다. 여기서는 **화면이 넘긴 값을 그대로 쓴다** —
   *   PB 쪽이 입력을 버리는 것이 결함이고, 결과를 예측할 수 없기 때문이다.
   *
   * 키(LINE_CODE, LOCATION_CODE, ORGANIZATION_ID)가 이미 있으면 건너뛴다.
   * PB 는 유일인덱스 위반으로 저장 자체가 실패했다.
   *
   * p_result : 새로 만든 행수
   *           -1  라인 + 설비가 IB_LINE_MASTER 에 없음
   *           -2  테이블문자가 알파벳 한 글자가 아님
   *           -3  주소 범위가 뒤집혔거나 음수
   *           -4  위치문자에 L·R·N 아닌 것이 섞였음
   */
  PROCEDURE SP_SMT_LOCATION_GENERATE(
    p_line_code   IN  VARCHAR2,
    p_machine     IN  VARCHAR2,
    p_table_id    IN  VARCHAR2,
    p_addr_from   IN  NUMBER,
    p_addr_to     IN  NUMBER,
    p_positions   IN  VARCHAR2,          -- 'L' | 'R' | 'LR' | 'N'
    p_all_tables  IN  VARCHAR2,          -- 'Y' | 'N'
    p_org         IN  NUMBER,
    p_user        IN  VARCHAR2,
    p_result      OUT NUMBER
  );

  /**
   * PB w_smt_line_master cb_4 / w_smt_location_master 'Delete All' 이관 (2026-09-27)
   *
   * 라인 + 설비 + 조직의 위치를 지운다. 위 주석 1)·2) 대로 PB 보다 범위가 좁다.
   *
   * 배포된 계획(IB_PRODUCT_PLANDATA)이 그 위치를 이미 쓰고 있으면 지우지 않는다.
   * PB 에는 이 검사가 없어 위치를 지우면 계획행의 LOCATION_CODE 가 고아가 됐다.
   *
   * p_result : 지운 행수
   *           -1  라인 또는 설비가 비었음
   *           -2  그 위치를 쓰는 배포계획이 있음 (절대값이 참조 건수)
   */
  PROCEDURE SP_SMT_LOCATION_DELETE(
    p_line_code IN  VARCHAR2,
    p_machine   IN  VARCHAR2,
    p_org       IN  NUMBER,
    p_result    OUT NUMBER
  );

  /**
   * PB w_smt_plan_master cb('Create Feeder Layout') 이관 (2026-09-27)
   *
   * SMT BOM(ID_ENG_BOM_SMT) + 대체BOM(ID_ENG_BOM_SMT_REPLACE)을
   * 계획배포 테이블(IB_PRODUCT_PLANDATA)로 펼친다.
   *
   * PB 가 걸던 가드를 그대로 유지한다 — 둘 다 배포 사고를 막는 검사다:
   *   - 이미 활성(ACTIVE_YN='Y') 계획이 있으면 거부한다.
   *   - 이미 행이 있으면(비활성이라도) 거부한다. 지우고 다시 만들라는 뜻이다.
   * 단 검사 범위에 조직을 넣었다 (위 주석 3)).
   *
   * 새로 넣는 행은 PB 와 같다: CHECK_STATUS='W', CHECK_YN='N',
   * ACTIVE_YN='N', FULL_CHECK_YN='N', PLAN_DATE_SEQUENCE=1,
   * 일반품목 REPLACE_YN='N' / 대체품목 REPLACE_YN='Y'.
   *
   * p_result : 배포한 행수 (일반 + 대체)
   *           -1  활성계획이 이미 있음
   *           -2  비활성계획이 이미 있음 (절대값 아님 — 건수는 p_existing 으로 내린다)
   *           -3  배포할 BOM 이 없음
   */
  PROCEDURE SP_SMT_PLAN_DEPLOY(
    p_line_code    IN  VARCHAR2,
    p_model_name   IN  VARCHAR2,
    p_pcb_item     IN  VARCHAR2,
    p_feeder_shaft IN  VARCHAR2,
    p_org          IN  NUMBER,
    p_user         IN  VARCHAR2,
    p_existing     OUT NUMBER,
    p_result       OUT NUMBER
  );

  /**
   * PB w_smt_plan_master cb('Delete') 이관 (2026-09-27)
   *
   * 배포계획을 지운다. PB 와 같이 **비활성(ACTIVE_YN='N') 행만** 지우고,
   * 지우기 전에 IB_PRODUCT_PLANDATA_BACKUP 으로 통째로 옮겨 둔다.
   * 활성 계획은 건드리지 않는다 — 현장이 그 계획으로 자재를 물리고 있다.
   *
   * p_result : 지운 행수
   *           -1  라인 또는 모델이 비었음
   */
  PROCEDURE SP_SMT_PLAN_DELETE(
    p_line_code    IN  VARCHAR2,
    p_model_name   IN  VARCHAR2,
    p_pcb_item     IN  VARCHAR2,
    p_feeder_shaft IN  VARCHAR2,
    p_org          IN  NUMBER,
    p_result       OUT NUMBER
  );

  /**
   * PB w_smt_plan_master 의 활성/비활성 전환 이관 (2026-09-27)
   *
   * 한 라인·모델·면의 계획을 한꺼번에 활성(Y) 또는 비활성(N) 으로 바꾼다.
   * 활성화는 배타적이다 — 같은 라인의 다른 모델이 활성이면 거부한다.
   * 한 라인에 두 모델이 동시에 활성이면 어느 계획으로 자재를 물릴지 알 수 없다.
   *
   * p_result : 바꾼 행수
   *           -1  대상 계획이 없음
   *           -2  같은 라인의 다른 모델이 이미 활성 (활성화 요청일 때만)
   */
  PROCEDURE SP_SMT_PLAN_SET_ACTIVE(
    p_line_code  IN  VARCHAR2,
    p_model_name IN  VARCHAR2,
    p_pcb_item   IN  VARCHAR2,
    p_active_yn  IN  VARCHAR2,
    p_org        IN  NUMBER,
    p_user       IN  VARCHAR2,
    p_result     OUT NUMBER
  );

  /**
   * PB w_smt_bom_create_master cb('Model Rename') 이관 (2026-09-27)
   *
   * SMT BOM 의 모델명(PARENT_ITEM_CODE)을 바꾼다. PB 와 같이
   * ID_ENG_BOM_SMT 와 IB_PRODUCT_PLANDATA 를 함께 갱신한다 — 한쪽만 바꾸면
   * 배포계획이 없는 모델을 가리킨다.
   * PB 가 빠뜨린 ID_ENG_BOM_SMT_REPLACE 도 같이 바꾼다. 대체BOM 이 남으면
   * 다음 배포에서 옛 모델명 행이 섞여 들어온다.
   *
   * p_result : 바꾼 행수 합계
   *           -1  바꿀 모델의 BOM 이 없음
   *           -2  새 모델명으로 된 BOM 이 이미 있음
   */
  PROCEDURE SP_SMT_BOM_MODEL_RENAME(
    p_old_model IN  VARCHAR2,
    p_new_model IN  VARCHAR2,
    p_org       IN  NUMBER,
    p_user      IN  VARCHAR2,
    p_result    OUT NUMBER
  );

  /**
   * PB w_smt_bom_create_master 의 라인 교체 이관 (2026-09-27)
   *
   * 두 라인의 SMT BOM 을 서로 맞바꾼다. PB 는 '-X' 임시 접미어를 붙여
   * 네 번의 UPDATE 로 돌려막았다. 같은 순서를 유지한다 — 한 번에 바꾸면
   * 중간 상태에서 두 라인의 키가 겹친다.
   *   ① line1 → line2||'-X'   ② line2 → line1||'-X'
   *   ③ line1||'-X' → line1 + MACHINE 재조립
   *   ④ line2||'-X' → line2 + MACHINE 재조립
   *
   * MACHINE 은 `라인코드 || 설비순번` 규칙이다 (실측: LINE_CODE 2자리,
   * MACHINE 4자리, 28,417행 전부). 그래서 라인을 바꾸면 앞 두 자리도 바꿔야 한다.
   *
   * p_result : 바꾼 행수 합계 (③+④)
   *           -1  두 라인코드가 같음
   *           -2  '-X' 접미어 라인코드가 이미 데이터에 있음 (중간 상태와 충돌한다)
   *           -3  두 라인 중 한쪽에 BOM 이 없음
   */
  PROCEDURE SP_SMT_BOM_LINE_SWAP(
    p_line_code1 IN  VARCHAR2,
    p_line_code2 IN  VARCHAR2,
    p_org        IN  NUMBER,
    p_user       IN  VARCHAR2,
    p_result     OUT NUMBER
  );

  /**
   * PB w_smt_bom_create_master cb('Delete') 이관 (2026-09-27)
   *
   * 모델 + 라인 + 면 범위의 SMT BOM 과 대체 BOM 을 함께 지운다.
   * PB 와 같은 범위·같은 순서다.
   *
   * 이미 배포된 계획이 있으면 지우지 않는다. PB 에는 이 검사가 없어
   * BOM 을 지운 뒤에도 계획행이 남아 원천을 잃었다.
   *
   * p_result : 지운 행수 합계 (BOM + 대체BOM)
   *           -1  지울 BOM 이 없음
   *           -2  배포된 계획이 있음 (절대값/2 가 계획 건수)
   */
  PROCEDURE SP_SMT_BOM_DELETE_SCOPE(
    p_model_name IN  VARCHAR2,
    p_line_code  IN  VARCHAR2,
    p_pcb_item   IN  VARCHAR2,
    p_org        IN  NUMBER,
    p_result     OUT NUMBER
  );

END PKG_MES_SMT;
/

CREATE OR REPLACE PACKAGE BODY PKG_MES_SMT AS

  PROCEDURE SP_SMT_LOCATION_GENERATE(
    p_line_code   IN  VARCHAR2,
    p_machine     IN  VARCHAR2,
    p_table_id    IN  VARCHAR2,
    p_addr_from   IN  NUMBER,
    p_addr_to     IN  NUMBER,
    p_positions   IN  VARCHAR2,
    p_all_tables  IN  VARCHAR2,
    p_org         IN  NUMBER,
    p_user        IN  VARCHAR2,
    p_result      OUT NUMBER
  ) IS
    v_line_cnt   NUMBER;
    v_table_id   VARCHAR2(10) := UPPER(TRIM(p_table_id));
    v_positions  VARCHAR2(10) := UPPER(TRIM(p_positions));
    v_from_chr   NUMBER;
    v_to_chr     NUMBER;
    v_made       NUMBER := 0;
    v_tbl        VARCHAR2(1);
    v_pos        VARCHAR2(1);
    v_loc        VARCHAR2(100);
  BEGIN
    p_result := 0;

    SELECT COUNT(*) INTO v_line_cnt
      FROM IB_LINE_MASTER
     WHERE LINE_CODE = p_line_code
       AND MACHINE = p_machine
       AND ORGANIZATION_ID = p_org;
    IF v_line_cnt = 0 THEN
      p_result := -1;
      RETURN;
    END IF;

    IF v_table_id IS NULL OR LENGTH(v_table_id) <> 1
       OR NOT REGEXP_LIKE(v_table_id, '^[A-Z]$') THEN
      p_result := -2;
      RETURN;
    END IF;

    IF p_addr_from IS NULL OR p_addr_to IS NULL
       OR p_addr_from < 0 OR p_addr_to < p_addr_from THEN
      p_result := -3;
      RETURN;
    END IF;

    IF v_positions IS NULL OR LENGTH(v_positions) = 0
       OR NOT REGEXP_LIKE(v_positions, '^[LRN]+$') THEN
      p_result := -4;
      RETURN;
    END IF;

    -- p_all_tables='Y' 면 'A' 부터, 아니면 지정한 문자 하나만
    v_from_chr := CASE WHEN NVL(p_all_tables, 'N') = 'Y'
                       THEN ASCII('A') ELSE ASCII(v_table_id) END;
    v_to_chr   := ASCII(v_table_id);

    FOR t IN v_from_chr .. v_to_chr LOOP
      v_tbl := CHR(t);
      FOR a IN p_addr_from .. p_addr_to LOOP
        FOR p IN 1 .. LENGTH(v_positions) LOOP
          v_pos := SUBSTR(v_positions, p, 1);
          -- PB: table_id || lpad(주소,2,'0') || 위치. 'N' 은 위치문자를 붙이지 않는다.
          v_loc := v_tbl || LPAD(TO_CHAR(a), 2, '0')
                   || CASE WHEN v_pos = 'N' THEN '' ELSE v_pos END;

          INSERT INTO IB_MACHINE_LOCATION
            (LINE_CODE, MACHINE, ORGANIZATION_ID, LOCATION_CODE, TABLE_ID,
             ENTER_BY, ENTER_DATE, LAST_MODIFY_BY, LAST_MODIFY_DATE)
          SELECT p_line_code, p_machine, p_org, v_loc, v_tbl,
                 p_user, SYSDATE, p_user, SYSDATE
            FROM DUAL
           WHERE NOT EXISTS (
                   SELECT 1 FROM IB_MACHINE_LOCATION
                    WHERE LINE_CODE = p_line_code
                      AND LOCATION_CODE = v_loc
                      AND ORGANIZATION_ID = p_org);
          v_made := v_made + SQL%ROWCOUNT;

          -- 'N' 은 위치문자가 없으므로 한 번만 만든다
          IF v_pos = 'N' THEN
            EXIT;
          END IF;
        END LOOP;
      END LOOP;
    END LOOP;

    p_result := v_made;
  END SP_SMT_LOCATION_GENERATE;


  PROCEDURE SP_SMT_LOCATION_DELETE(
    p_line_code IN  VARCHAR2,
    p_machine   IN  VARCHAR2,
    p_org       IN  NUMBER,
    p_result    OUT NUMBER
  ) IS
    v_used NUMBER;
  BEGIN
    IF p_line_code IS NULL OR TRIM(p_line_code) IS NULL
       OR p_machine IS NULL OR TRIM(p_machine) IS NULL THEN
      p_result := -1;
      RETURN;
    END IF;

    SELECT COUNT(*) INTO v_used
      FROM IB_PRODUCT_PLANDATA d
     WHERE d.LINE_CODE = p_line_code
       AND d.MACHINE = p_machine
       AND d.ORGANIZATION_ID = p_org
       AND EXISTS (SELECT 1 FROM IB_MACHINE_LOCATION l
                    WHERE l.LINE_CODE = d.LINE_CODE
                      AND l.LOCATION_CODE = d.LOCATION_CODE
                      AND l.ORGANIZATION_ID = d.ORGANIZATION_ID
                      AND l.MACHINE = p_machine);
    IF v_used > 0 THEN
      p_result := -2 * v_used;
      RETURN;
    END IF;

    DELETE FROM IB_MACHINE_LOCATION
     WHERE LINE_CODE = p_line_code
       AND MACHINE = p_machine
       AND ORGANIZATION_ID = p_org;

    p_result := SQL%ROWCOUNT;
  END SP_SMT_LOCATION_DELETE;


  PROCEDURE SP_SMT_PLAN_DEPLOY(
    p_line_code    IN  VARCHAR2,
    p_model_name   IN  VARCHAR2,
    p_pcb_item     IN  VARCHAR2,
    p_feeder_shaft IN  VARCHAR2,
    p_org          IN  NUMBER,
    p_user         IN  VARCHAR2,
    p_existing     OUT NUMBER,
    p_result       OUT NUMBER
  ) IS
    v_active   VARCHAR2(1);
    v_shaft    VARCHAR2(10) := NVL(p_feeder_shaft, '%');
    v_plan_date VARCHAR2(30) := TO_CHAR(SYSDATE, 'YYYYMMDD');
    v_made     NUMBER := 0;
  BEGIN
    p_result := 0;
    p_existing := 0;

    -- PB 가드. 단 조직을 조건에 넣었다 (헤더 주석 3)).
    SELECT NVL(MAX(NVL(ACTIVE_YN, 'N')), 'N'), COUNT(*)
      INTO v_active, p_existing
      FROM IB_PRODUCT_PLANDATA
     WHERE LINE_CODE = p_line_code
       AND MODEL_NAME = p_model_name
       AND PCB_ITEM = p_pcb_item
       AND ORGANIZATION_ID = p_org;

    IF v_active = 'Y' THEN
      p_result := -1;
      RETURN;
    END IF;
    IF p_existing > 0 THEN
      p_result := -2;
      RETURN;
    END IF;

    -- 일반품목
    INSERT INTO IB_PRODUCT_PLANDATA
      (PLAN_DATE, MODEL_NAME, ITEM_CODE, CHIPNAME, CHECK_YN, SELECTED_DATE,
       MACHINE, LINE_CODE, CHECK_STATUS, ENTER_DATE, ENTER_BY,
       LAST_MODIFY_DATE, LAST_MODIFY_BY, ORGANIZATION_ID, PLAN_DATE_SEQUENCE,
       ITEM_BARCODE, LOCATION_CODE, TABLE_ID, PCB_ITEM, ACTIVE_YN, REPLACE_YN,
       ITEM_UNIT_QTY, FEEDER_SHAFT, REVISION, LOCATION_INFO, FULL_CHECK_YN,
       SMT_MODEL_NAME)
    SELECT v_plan_date, b.PARENT_ITEM_CODE, b.CHILD_ITEM_CODE, '', 'N', NULL,
           b.MACHINE, b.LINE_CODE, 'W', SYSDATE, p_user,
           SYSDATE, p_user, b.ORGANIZATION_ID, 1,
           NULL, b.LOCATION_CODE, b.TABLE_ID, b.PCB_ITEM, 'N', 'N',
           b.ITEM_UNIT_QTY, NVL(b.FEEDER_SHAFT, '*'), b.REVISION,
           b.LOCATION_INFO, 'N', b.SMT_MODEL_NAME
      FROM ID_ENG_BOM_SMT b
     WHERE b.LINE_CODE LIKE p_line_code
       AND b.PARENT_ITEM_CODE = p_model_name
       AND b.PCB_ITEM = p_pcb_item
       AND NVL(b.FEEDER_SHAFT, '*') LIKE v_shaft
       AND b.ORGANIZATION_ID = p_org
       AND NOT EXISTS (
             SELECT 1 FROM IB_PRODUCT_PLANDATA a
              WHERE a.LINE_CODE = b.LINE_CODE
                AND a.MODEL_NAME = b.PARENT_ITEM_CODE
                AND a.ITEM_CODE = b.CHILD_ITEM_CODE
                AND a.LOCATION_CODE = b.LOCATION_CODE
                AND a.PCB_ITEM = b.PCB_ITEM
                AND NVL(a.FEEDER_SHAFT, '*') = NVL(b.FEEDER_SHAFT, '*')
                AND a.ORGANIZATION_ID = b.ORGANIZATION_ID);
    v_made := v_made + SQL%ROWCOUNT;

    -- 대체품목. PB 는 여기 FEEDER_SHAFT 조건을 주석처리해 뒀다 — 그대로 둔다.
    INSERT INTO IB_PRODUCT_PLANDATA
      (PLAN_DATE, MODEL_NAME, ITEM_CODE, CHIPNAME, CHECK_YN, SELECTED_DATE,
       MACHINE, LINE_CODE, CHECK_STATUS, ENTER_DATE, ENTER_BY,
       LAST_MODIFY_DATE, LAST_MODIFY_BY, ORGANIZATION_ID, PLAN_DATE_SEQUENCE,
       ITEM_BARCODE, LOCATION_CODE, TABLE_ID, PCB_ITEM, ACTIVE_YN, REPLACE_YN,
       ITEM_UNIT_QTY, FEEDER_SHAFT, REVISION, LOCATION_INFO, FULL_CHECK_YN,
       SMT_MODEL_NAME)
    SELECT v_plan_date, b.PARENT_ITEM_CODE, b.REPLACE_ITEM_CODE, '', 'N', NULL,
           b.MACHINE, b.LINE_CODE, 'W', SYSDATE, p_user,
           SYSDATE, p_user, b.ORGANIZATION_ID, 1,
           NULL, b.LOCATION_CODE, b.TABLE_ID, b.PCB_ITEM, 'N', 'Y',
           b.ITEM_UNIT_QTY, NVL(b.FEEDER_SHAFT, '*'), b.REVISION,
           b.LOCATION_INFO, 'N', b.SMT_MODEL_NAME
      FROM ID_ENG_BOM_SMT_REPLACE b
     WHERE b.LINE_CODE LIKE p_line_code
       AND b.PARENT_ITEM_CODE = p_model_name
       AND b.PCB_ITEM = p_pcb_item
       AND b.ORGANIZATION_ID = p_org
       AND NOT EXISTS (
             SELECT 1 FROM IB_PRODUCT_PLANDATA a
              WHERE a.LINE_CODE = b.LINE_CODE
                AND a.MODEL_NAME = b.PARENT_ITEM_CODE
                AND a.ITEM_CODE = b.REPLACE_ITEM_CODE
                AND a.LOCATION_CODE = b.LOCATION_CODE
                AND a.PCB_ITEM = b.PCB_ITEM
                AND NVL(a.FEEDER_SHAFT, '*') = NVL(b.FEEDER_SHAFT, '*')
                AND a.ORGANIZATION_ID = b.ORGANIZATION_ID);
    v_made := v_made + SQL%ROWCOUNT;

    IF v_made = 0 THEN
      p_result := -3;
      RETURN;
    END IF;

    p_result := v_made;
  END SP_SMT_PLAN_DEPLOY;


  PROCEDURE SP_SMT_PLAN_DELETE(
    p_line_code    IN  VARCHAR2,
    p_model_name   IN  VARCHAR2,
    p_pcb_item     IN  VARCHAR2,
    p_feeder_shaft IN  VARCHAR2,
    p_org          IN  NUMBER,
    p_result       OUT NUMBER
  ) IS
    v_pcb   VARCHAR2(30) := NVL(p_pcb_item, '%');
    v_shaft VARCHAR2(10) := NVL(p_feeder_shaft, '%');
  BEGIN
    IF p_line_code IS NULL OR TRIM(p_line_code) IS NULL
       OR p_model_name IS NULL OR TRIM(p_model_name) IS NULL THEN
      p_result := -1;
      RETURN;
    END IF;

    -- PB 와 같이 지우기 전에 백업 테이블로 옮긴다
    INSERT INTO IB_PRODUCT_PLANDATA_BACKUP
    SELECT * FROM IB_PRODUCT_PLANDATA
     WHERE LINE_CODE = p_line_code
       AND MODEL_NAME = p_model_name
       AND ORGANIZATION_ID = p_org
       AND NVL(PCB_ITEM, '*') LIKE v_pcb
       AND NVL(FEEDER_SHAFT, '*') LIKE v_shaft
       AND ACTIVE_YN = 'N';

    DELETE FROM IB_PRODUCT_PLANDATA
     WHERE LINE_CODE = p_line_code
       AND MODEL_NAME = p_model_name
       AND ORGANIZATION_ID = p_org
       AND NVL(PCB_ITEM, '*') LIKE v_pcb
       AND NVL(FEEDER_SHAFT, '*') LIKE v_shaft
       AND ACTIVE_YN = 'N';

    p_result := SQL%ROWCOUNT;
  END SP_SMT_PLAN_DELETE;


  PROCEDURE SP_SMT_PLAN_SET_ACTIVE(
    p_line_code  IN  VARCHAR2,
    p_model_name IN  VARCHAR2,
    p_pcb_item   IN  VARCHAR2,
    p_active_yn  IN  VARCHAR2,
    p_org        IN  NUMBER,
    p_user       IN  VARCHAR2,
    p_result     OUT NUMBER
  ) IS
    v_pcb   VARCHAR2(30) := NVL(p_pcb_item, '%');
    v_target NUMBER;
    v_other  NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_target
      FROM IB_PRODUCT_PLANDATA
     WHERE LINE_CODE = p_line_code
       AND MODEL_NAME = p_model_name
       AND ORGANIZATION_ID = p_org
       AND NVL(PCB_ITEM, '*') LIKE v_pcb;
    IF v_target = 0 THEN
      p_result := -1;
      RETURN;
    END IF;

    IF p_active_yn = 'Y' THEN
      SELECT COUNT(*) INTO v_other
        FROM IB_PRODUCT_PLANDATA
       WHERE LINE_CODE = p_line_code
         AND MODEL_NAME <> p_model_name
         AND ORGANIZATION_ID = p_org
         AND ACTIVE_YN = 'Y';
      IF v_other > 0 THEN
        p_result := -2;
        RETURN;
      END IF;
    END IF;

    UPDATE IB_PRODUCT_PLANDATA
       SET ACTIVE_YN = p_active_yn,
           LAST_MODIFY_BY = p_user,
           LAST_MODIFY_DATE = SYSDATE
     WHERE LINE_CODE = p_line_code
       AND MODEL_NAME = p_model_name
       AND ORGANIZATION_ID = p_org
       AND NVL(PCB_ITEM, '*') LIKE v_pcb
       AND NVL(ACTIVE_YN, 'N') <> p_active_yn;

    p_result := SQL%ROWCOUNT;
  END SP_SMT_PLAN_SET_ACTIVE;


  PROCEDURE SP_SMT_BOM_MODEL_RENAME(
    p_old_model IN  VARCHAR2,
    p_new_model IN  VARCHAR2,
    p_org       IN  NUMBER,
    p_user      IN  VARCHAR2,
    p_result    OUT NUMBER
  ) IS
    v_old NUMBER;
    v_new NUMBER;
    v_sum NUMBER := 0;
  BEGIN
    SELECT COUNT(*) INTO v_old
      FROM ID_ENG_BOM_SMT
     WHERE PARENT_ITEM_CODE = p_old_model AND ORGANIZATION_ID = p_org;
    IF v_old = 0 THEN
      p_result := -1;
      RETURN;
    END IF;

    SELECT COUNT(*) INTO v_new
      FROM ID_ENG_BOM_SMT
     WHERE PARENT_ITEM_CODE = p_new_model AND ORGANIZATION_ID = p_org;
    IF v_new > 0 THEN
      p_result := -2;
      RETURN;
    END IF;

    UPDATE ID_ENG_BOM_SMT
       SET PARENT_ITEM_CODE = p_new_model,
           LAST_MODIFY_BY = p_user, LAST_MODIFY_DATE = SYSDATE
     WHERE PARENT_ITEM_CODE = p_old_model AND ORGANIZATION_ID = p_org;
    v_sum := v_sum + SQL%ROWCOUNT;

    -- PB 가 빠뜨린 대체BOM. 안 바꾸면 다음 배포에 옛 모델명 행이 섞인다.
    UPDATE ID_ENG_BOM_SMT_REPLACE
       SET PARENT_ITEM_CODE = p_new_model,
           LAST_MODIFY_BY = p_user, LAST_MODIFY_DATE = SYSDATE
     WHERE PARENT_ITEM_CODE = p_old_model AND ORGANIZATION_ID = p_org;
    v_sum := v_sum + SQL%ROWCOUNT;

    UPDATE IB_PRODUCT_PLANDATA
       SET MODEL_NAME = p_new_model,
           LAST_MODIFY_BY = p_user, LAST_MODIFY_DATE = SYSDATE
     WHERE MODEL_NAME = p_old_model AND ORGANIZATION_ID = p_org;
    v_sum := v_sum + SQL%ROWCOUNT;

    p_result := v_sum;
  END SP_SMT_BOM_MODEL_RENAME;

  PROCEDURE SP_SMT_BOM_LINE_SWAP(
    p_line_code1 IN  VARCHAR2,
    p_line_code2 IN  VARCHAR2,
    p_org        IN  NUMBER,
    p_user       IN  VARCHAR2,
    p_result     OUT NUMBER
  ) IS
    v_tmp1 VARCHAR2(30) := p_line_code1 || '-X';
    v_tmp2 VARCHAR2(30) := p_line_code2 || '-X';
    v_n    NUMBER;
    v_sum  NUMBER := 0;
  BEGIN
    IF p_line_code1 = p_line_code2 OR p_line_code1 IS NULL OR p_line_code2 IS NULL THEN
      p_result := -1;
      RETURN;
    END IF;

    SELECT COUNT(*) INTO v_n
      FROM ID_ENG_BOM_SMT
     WHERE LINE_CODE IN (v_tmp1, v_tmp2) AND ORGANIZATION_ID = p_org;
    IF v_n > 0 THEN
      p_result := -2;
      RETURN;
    END IF;

    SELECT COUNT(DISTINCT LINE_CODE) INTO v_n
      FROM ID_ENG_BOM_SMT
     WHERE LINE_CODE IN (p_line_code1, p_line_code2) AND ORGANIZATION_ID = p_org;
    IF v_n < 2 THEN
      p_result := -3;
      RETURN;
    END IF;

    -- ① ②  임시 접미어로 피신
    UPDATE ID_ENG_BOM_SMT SET LINE_CODE = v_tmp2
     WHERE LINE_CODE = p_line_code1 AND ORGANIZATION_ID = p_org;
    UPDATE ID_ENG_BOM_SMT SET LINE_CODE = v_tmp1
     WHERE LINE_CODE = p_line_code2 AND ORGANIZATION_ID = p_org;

    -- ③ ④  제자리로 내리면서 MACHINE 앞 두 자리를 새 라인코드로 바꾼다
    UPDATE ID_ENG_BOM_SMT
       SET LINE_CODE = p_line_code1,
           MACHINE = p_line_code1 || SUBSTR(MACHINE, 3, 2),
           LAST_MODIFY_BY = p_user, LAST_MODIFY_DATE = SYSDATE
     WHERE LINE_CODE = v_tmp1 AND ORGANIZATION_ID = p_org;
    v_sum := v_sum + SQL%ROWCOUNT;

    UPDATE ID_ENG_BOM_SMT
       SET LINE_CODE = p_line_code2,
           MACHINE = p_line_code2 || SUBSTR(MACHINE, 3, 2),
           LAST_MODIFY_BY = p_user, LAST_MODIFY_DATE = SYSDATE
     WHERE LINE_CODE = v_tmp2 AND ORGANIZATION_ID = p_org;
    v_sum := v_sum + SQL%ROWCOUNT;

    p_result := v_sum;
  END SP_SMT_BOM_LINE_SWAP;


  PROCEDURE SP_SMT_BOM_DELETE_SCOPE(
    p_model_name IN  VARCHAR2,
    p_line_code  IN  VARCHAR2,
    p_pcb_item   IN  VARCHAR2,
    p_org        IN  NUMBER,
    p_result     OUT NUMBER
  ) IS
    v_pcb  VARCHAR2(30) := NVL(p_pcb_item, '%');
    v_n    NUMBER;
    v_sum  NUMBER := 0;
  BEGIN
    SELECT COUNT(*) INTO v_n
      FROM ID_ENG_BOM_SMT
     WHERE PARENT_ITEM_CODE = p_model_name
       AND LINE_CODE = p_line_code
       AND NVL(PCB_ITEM, '*') LIKE v_pcb
       AND ORGANIZATION_ID = p_org;
    IF v_n = 0 THEN
      p_result := -1;
      RETURN;
    END IF;

    SELECT COUNT(*) INTO v_n
      FROM IB_PRODUCT_PLANDATA
     WHERE MODEL_NAME = p_model_name
       AND LINE_CODE = p_line_code
       AND NVL(PCB_ITEM, '*') LIKE v_pcb
       AND ORGANIZATION_ID = p_org;
    IF v_n > 0 THEN
      p_result := -2 * v_n;
      RETURN;
    END IF;

    DELETE FROM ID_ENG_BOM_SMT
     WHERE PARENT_ITEM_CODE = p_model_name
       AND LINE_CODE = p_line_code
       AND NVL(PCB_ITEM, '*') LIKE v_pcb
       AND ORGANIZATION_ID = p_org;
    v_sum := v_sum + SQL%ROWCOUNT;

    DELETE FROM ID_ENG_BOM_SMT_REPLACE
     WHERE PARENT_ITEM_CODE = p_model_name
       AND LINE_CODE = p_line_code
       AND NVL(PCB_ITEM, '*') LIKE v_pcb
       AND ORGANIZATION_ID = p_org;
    v_sum := v_sum + SQL%ROWCOUNT;

    p_result := v_sum;
  END SP_SMT_BOM_DELETE_SCOPE;

END PKG_MES_SMT;
/
