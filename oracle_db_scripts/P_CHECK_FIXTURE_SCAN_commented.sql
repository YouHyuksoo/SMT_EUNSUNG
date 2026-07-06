CREATE OR REPLACE PROCEDURE "P_CHECK_FIXTURE_SCAN" (
  /* ================================================================
   * 프로시저명  : P_CHECK_FIXTURE_SCAN
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   입력 조건을 기준으로 업무 데이터의 유효성 또는 상태를 확인한다.
   *   조회 결과와 원본 분기 조건에 따라 OUT 파라미터 또는 상태 값을 설정한다.
   *   호출부가 결과 코드와 메시지로 후속 처리를 판단할 수 있게 한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_LINE_CODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_MODEL_NAME - 원본 선언부 기준 입력/출력 파라미터
   *   P_BARCODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_DEFICIT - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IMCN_JIG - 원본 로직 참조 테이블
   *   IMCN_JIG_APPLY_MODEL - 원본 로직 참조 테이블
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_MSG
   *   P_INTERLOCK_SET_NSNP_MSG
   * ================================================================
   * [AI 분석] 예외 처리:
   *   원본 EXCEPTION 절의 반환값, RAISE, COMMIT/ROLLBACK 흐름을 변경하지 않는다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 구현 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_CHECK_FIXTURE_SCAN(...)
   * ================================================================ */
   p_line_code    IN     VARCHAR2,
   p_model_name   IN     VARCHAR2,
   p_barcode      IN     VARCHAR2,
   p_deficit      IN     VARCHAR2,
   p_out             OUT VARCHAR2)
IS
   lvs_jig_status    VARCHAR2 (20); -- [AI] 내부 처리용 변수
   lvs_item_code     VARCHAR2 (20); -- [AI] 내부 처리용 변수
   lvl_break_value   NUMBER; -- [AI] 내부 처리용 변수
   lvl_hit_value     NUMBER; -- [AI] 내부 처리용 변수
   lvs_ip_address    VARCHAR2 (20); -- [AI] 내부 처리용 변수
   lvs_use_nsnp_yn   VARCHAR2 (1); -- [AI] 내부 처리용 변수
   phase             VARCHAR2 (20); -- [AI] 내부 처리용 변수
BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.
   phase := '10';

   BEGIN
      SELECT NVL (item_code, '*'),
             NVL (break_value, 0),
             NVL (hit_value, 0),
             jig_status,
             NVL (use_nsnp_yn, 'N')
        INTO lvs_item_code,
             lvl_break_value,
             lvl_hit_value,
             lvs_jig_status,
             lvs_use_nsnp_yn
        FROM imcn_jig
       WHERE     jig_lot_no = p_barcode
             AND organization_id = 1
             AND jig_type = 'T';

      phase := '20';
   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN NO_DATA_FOUND
      THEN
         IF lvs_use_nsnp_yn = 'Y'
         THEN
            NULL;
         --            BEGIN
         --               --------------------------------------------------------------------------------
         --               -- NSNP START
         --               --------------------------------------------------------------------------------
         --               p_interlock_set_nsnp_msg (p_line_code,
         --                                         1,
         --                                         p_model_name,
         --                                         '*',
         --                                         'FIXTURE CHECK',
         --                                         'NO NOT FOUND ' || p_barcode);
         --            --------------------------------------------------------------------------------
         --            -- NSNP END
         --            --------------------------------------------------------------------------------
         --            EXCEPTION
         --               WHEN OTHERS
         --               THEN
         --                  NULL;
         --            END;
         END IF;

         --------------------------------------------------------------------------------
         -- NSNP END
         --------------------------------------------------------------------------------
         p_out := f_msg('픽스쳐정보가 없습니다.', 'K', 1)
                  || ' = '
                  ||'Line='
                  || p_line_code
                  || ', '
                  || 'Model='
                  || p_model_name
                  || ', '
                  || 'Barcode='
                  || p_barcode ;
         RETURN;
   END;

  phase := '30';

   IF p_deficit = 'N'
   THEN
      ---------------------------------------------------------------------------
      --
      ---------------------------------------------------------------------------
      BEGIN
         SELECT NVL (item_code, '*')
           INTO lvs_item_code
           FROM imcn_jig_apply_model
          WHERE     jig_lot_no = p_barcode
                AND item_code = p_model_name
                AND organization_id = 1;
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN NO_DATA_FOUND
         THEN
            lvs_item_code := '*';
      END;
  phase := '40';
      --------------------------------------------------------------------------
      -- ITEM UNMATCH ERROR
      --------------------------------------------------------------------------
      IF NVL(lvs_item_code, '*') <> p_model_name THEN
        
         p_out :=  f_msg('적용모델이 일치하지 않습니다.', 'K', 1)    -- Model Unmatch
                   || ' = '
                   || lvs_item_code
                   || ', '
                   || p_model_name;
         RETURN;
         
      END IF;


      phase := '50';

      -------------------------------------------------------------------------------------------
      --
      -------------------------------------------------------------------------------------------

      IF lvs_jig_status <> 'Z'
      THEN
         IF lvs_use_nsnp_yn = 'Y'
         THEN
            NULL;
         --            BEGIN
         --               --------------------------------------------------------------------------------
         --               -- NSNP START
         --               --------------------------------------------------------------------------------
         --               p_interlock_set_nsnp_msg (p_line_code,
         --                                         1,
         --                                         p_model_name,
         --                                         '*',
         --                                         'FIXTURE CHECK',
         --                                         'STATUS NOT NORMAL ' || p_barcode);
         --            --------------------------------------------------------------------------------
         --            -- NSNP END
         --            --------------------------------------------------------------------------------
         --            EXCEPTION
         --               WHEN OTHERS
         --               THEN
         --                  NULL;
         --            END;
         END IF;

         --------------------------------------------------------------------------------
         -- NSNP END
         --------------------------------------------------------------------------------
         p_out := f_msg('픽스쳐 상태가 비정상 입니다.', 'K', 1);     --Fixture Status Invalid
         RETURN;
         
      END IF;
      
      phase := '60';
      
      -------------------------------------------------------------------------------------------
      --
      -------------------------------------------------------------------------------------------

      IF lvl_break_value <= lvl_hit_value
      THEN
         IF lvs_use_nsnp_yn = 'Y'
         THEN
            NULL;
         --            BEGIN
         --               --------------------------------------------------------------------------------
         --               -- NSNP START
         --               --------------------------------------------------------------------------------
         --               p_interlock_set_nsnp_msg (p_line_code,
         --                                         1,
         --                                         p_model_name,
         --                                         '*',
         --                                         'FIXTURE CHECK',
         --                                         'LIFE CYCLE OVER ' || p_barcode);
         --            --------------------------------------------------------------------------------
         --            -- NSNP END
         --            --------------------------------------------------------------------------------
         --            EXCEPTION
         --               WHEN OTHERS
         --               THEN
         --                  NULL;
         --            END;
         END IF;
         
  phase := '70';
  
         p_out := f_msg('유효수명초을 초과 했습니다.', 'K', 1);  -- Life Cycle Over
         RETURN;
         
      ELSE
         --------------------------------------------------------------------
         -- 기존 라인에서 뺴고 신규 라인으로 설정
         --------------------------------------------------------------------

         UPDATE imcn_jig
            SET line_code = '*'                         --, machine_code = '*'
          WHERE     jig_lot_no <> p_barcode
            AND line_code = SUBSTR (p_line_code, 1, 2) 
                AND organization_id = 1
                AND jig_type = 'T';


         UPDATE imcn_jig
            SET line_code = SUBSTR (p_line_code, 1, 2)      --, machine_code = p_machine_code
          WHERE     jig_lot_no = p_barcode
                AND organization_id = 1
                AND jig_type = 'T';

  phase := '90';
         COMMIT;

         p_out := 'OK';
         RETURN;
      END IF;
   ELSE
      --------------------------------------------------------------------
      -- 기존 라인에서 뺴고 신규 라인으로 설정
      --------------------------------------------------------------------

      UPDATE imcn_jig
         SET line_code = '*'                            --, machine_code = '*'
       WHERE     jig_lot_no = p_barcode
             AND organization_id = 1
             AND jig_type = 'T';

      COMMIT;

      p_out := 'OK';
      RETURN;
   END IF;

   phase := '70';
-------------------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------------------
EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN OTHERS
   THEN
      p_out := 'NG '
               || 'PHASE='
               || phase
               || ', '
               || p_barcode
               || ', '
               || SQLERRM;
      RETURN;
END;