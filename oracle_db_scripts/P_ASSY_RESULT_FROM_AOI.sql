CREATE OR REPLACE PROCEDURE P_ASSY_RESULT_FROM_AOI (
   p_lookback_hours IN NUMBER   DEFAULT 48,    -- 마지막으로 처리한 검사시각에서 이만큼 거슬러 다시 본다
   p_from           IN VARCHAR2 DEFAULT NULL,  -- 범위 지정(재처리용, 'YYYY/MM/DD HH24:MI:SS'). 주면 lookback 을 무시한다
   p_to             IN VARCHAR2 DEFAULT NULL
)
  /* ================================================================
   * 프로시저명 : P_ASSY_RESULT_FROM_AOI
   * 작성일     : 2026-10-17
   * 수정이력:
   *   2026-10-17 - AI(Claude) - AOI 양품을 조립실적(IP_ASSEMBLY_RESULT)으로 적재
   *   2026-10-17 - AI(Claude) - 실시간은 트리거 TRG_IQ_AOI_ASSY_RESULT 가 맡는다. 이 프로시저는
   *                             트리거가 놓친 PID 를 채우는 보정용이다 (매일 07:40 잡, 기준정보 수정 뒤 재처리)
   * ================================================================
   * 기능 설명:
   *   (PID, 면)의 최신 AOI 판정이 양품인데 아직 조립실적에 없는 것을 P_ASSY_RESULT_ADD_PID 로 더한다.
   *   - 판정: NVL(REVIEW_RESULT, RESULT) 가 OK·GOOD·PASS·USEROK. 같은 시각 판정이 엇갈리면 불량으로 본다.
   *           MasterOK/MasterNG 는 뺀다. 트리거와 같은 기준이다.
   *   - 시작 시각: ISYS_CONFIG ASSY_RESULT_AOI_FROM 이전 AOI 는 읽지 않는다.
   *   COMMIT 은 호출한 쪽(잡)이 한다.
   *   설계: docs/specs/2026-10-17-wip-semi-product-from-aoi-design.md
   * ================================================================ */
IS
   v_start  VARCHAR2(30);
   v_from   VARCHAR2(30);
   v_to     VARCHAR2(30);
   v_last   VARCHAR2(30);
   v_added  NUMBER;
   v_seen   NUMBER := 0;
   v_total  NUMBER := 0;
BEGIN
   SELECT MAX(CONFIG_VALUE) INTO v_start
     FROM ISYS_CONFIG
    WHERE CONFIG_NAME = 'ASSY_RESULT_AOI_FROM' AND ORGANIZATION_ID = 1 AND NVL(USE_YN, 'Y') = 'Y';
   IF v_start IS NULL THEN RETURN; END IF;

   IF p_from IS NOT NULL THEN
      v_from := p_from;
   ELSE
      SELECT MAX(INSPECT_DATE) INTO v_last FROM IP_ASSEMBLY_RESULT_PID WHERE ORGANIZATION_ID = 1;
      v_from := NVL(TO_CHAR(TO_DATE(v_last, 'YYYY/MM/DD HH24:MI:SS') - p_lookback_hours / 24, 'YYYY/MM/DD HH24:MI:SS'), v_start);
   END IF;
   IF v_from < v_start THEN v_from := v_start; END IF;
   v_to := NVL(p_to, TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS'));

   FOR x IN (
      SELECT c.PID, c.RUN_NO, c.LINE_CODE, c.INSPECT_DATE
        FROM (SELECT a.*, ROW_NUMBER() OVER (PARTITION BY a.PID, a.RUN_NO ORDER BY a.INSPECT_DATE DESC, a.GOOD ASC) AS RN
                FROM (SELECT TRIM(PID) AS PID, TRIM(RUN_NO) AS RUN_NO, LINE_CODE, INSPECT_DATE,
                             CASE WHEN UPPER(TRIM(NVL(REVIEW_RESULT, RESULT))) IN ('OK', 'GOOD', 'PASS', 'USEROK')
                                  THEN 1 ELSE 0 END AS GOOD
                        FROM IQ_MACHINE_INSPECT_AOI
                       WHERE INSPECT_DATE >= v_from AND INSPECT_DATE <= v_to AND ORGANIZATION_ID = 1
                         AND PID IS NOT NULL AND UPPER(TRIM(PID)) <> 'NULL'
                         AND RUN_NO IS NOT NULL AND TRIM(RUN_NO) <> '*'
                         AND (RESULT IS NULL OR UPPER(TRIM(RESULT)) NOT IN ('MASTEROK', 'MASTERNG'))) a) c
       WHERE c.RN = 1 AND c.GOOD = 1
         -- 미리 거르기만 한다. 정확한 중복 판정(PID·면)은 P_ASSY_RESULT_ADD_PID 가 한다
         AND NOT EXISTS (SELECT 1 FROM IP_ASSEMBLY_RESULT_PID p
                          WHERE p.PID = c.PID AND p.RUN_NO = c.RUN_NO AND p.ORGANIZATION_ID = 1))
   LOOP
      v_seen := v_seen + 1;
      P_ASSY_RESULT_ADD_PID(x.PID, x.RUN_NO, x.LINE_CODE, x.INSPECT_DATE, v_added);
      v_total := v_total + v_added;
   END LOOP;

   INSERT INTO ISYS_BATCHJOBERRLOG (BATCH_JOB_SEQ, ORGANIZATION_ID, BATCH_JOB_PROCESS_NAME, BATCH_JOB_OBJECT_NAME,
                                    BATCH_JOB_STATUS_CODE, BATCH_JOB_REMARK, ENTER_BY, LOG_DATE)
   VALUES (NULL, 1, 'ASSY_RESULT_FROM_AOI', 'P_ASSY_RESULT_FROM_AOI', 'OK',
           SUBSTR(v_from || ' ~ ' || v_to || ' 후보 ' || v_seen || ' / 더함 ' || v_total, 1, 200), 'JOB', SYSDATE);
END P_ASSY_RESULT_FROM_AOI;
