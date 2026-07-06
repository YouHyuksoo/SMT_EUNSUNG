CREATE OR REPLACE PROCEDURE "P_CHECK_PM_SCAN" (p_barcode    IN     VARCHAR2,
  /* ================================================================
   * 프로시저명  : P_CHECK_PM_SCAN
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
   *   P_BARCODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_DIVISION - 원본 선언부 기준 입력/출력 파라미터
   *   P_DEFICIT - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IMCN_JIG - 원본 로직 참조 테이블
   *   IMCN_JIG_PM_MASTER - 원본 로직 참조 테이블
   *   IMCN_JIG_PM_MASTER_HIST - 원본 로직 참조 테이블
   *   IMCN_MACHINE_PM_MASTER - 원본 로직 참조 테이블
   *   IMCN_MACHINE_PM_MASTER_HIST - 원본 로직 참조 테이블
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_MSG
   * ================================================================
   * [AI 분석] 예외 처리:
   *   원본 EXCEPTION 절의 반환값, RAISE, COMMIT/ROLLBACK 흐름을 변경하지 않는다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 구현 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_CHECK_PM_SCAN(...)
   * ================================================================ */
                           p_division   IN     VARCHAR2,
                           p_deficit    IN     VARCHAR2,
                           p_out           OUT VARCHAR2)
IS
    lvs_line_code      VARCHAR2 (10); -- [AI] 내부 처리용 변수
    lvs_pm_type        VARCHAR2 (10); -- [AI] 내부 처리용 변수
    lvs_machine_code   VARCHAR2 (20); -- [AI] 내부 처리용 변수
    lvs_jig_lot_no     VARCHAR2 (20); -- [AI] 내부 처리용 변수
    phase              VARCHAR2 (20); -- [AI] 내부 처리용 변수
    lvl_first          NUMBER; -- [AI] 내부 처리용 변수
    lvl_second         NUMBER; -- [AI] 내부 처리용 변수
    lvi_count          NUMBER; -- [AI] 내부 처리용 변수
    lvi_checck_hit_value NUMBER ; -- [AI] 내부 처리용 변수
BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.
    phase := '10';

    ---------------------------------------------------------------------------------------
    -- pm 라벨의 규격이 맞게 라인 + 공백 + 바코드 + 공백 + pm 유형 인데 
    -- 동도는 그렇게 안하므로 
    ---------------------------------------------------------------------------------------

--    lvl_first := INSTR (p_barcode, ' ', 1);
--    lvl_second := INSTR (p_barcode, ' ', lvl_first + 1);

    ---------------------------------------------------------------------------------------
    -- MACHINE
    ---------------------------------------------------------------------------------------
    IF p_division = 'M'
    THEN
        lvs_line_code := SUBSTR (p_barcode, 1, lvl_first - 1);
        lvs_machine_code := SUBSTR (p_barcode, lvl_first + 1, (lvl_second - lvl_first) - 1);
        lvs_pm_type := TRIM (SUBSTR (p_barcode, lvl_second + 1, 100));

        IF p_deficit = 'N'
        THEN
            BEGIN
                SELECT   COUNT ( * )
                  INTO   lvi_count
                  FROM   imcn_machine_pm_master_hist
                 WHERE   machine_code = lvs_machine_code
                     AND pm_type = lvs_pm_type
                     AND TRUNC (pm_date) = TRUNC (SYSDATE)
                     AND organization_id = 1;
            EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
                WHEN NO_DATA_FOUND
                THEN
                    lvi_count := 0;
            END;

            IF lvi_count = 0
            THEN
                INSERT INTO imcn_machine_pm_master_hist (organization_id,
                                                         line_code,
                                                         machine_code,
                                                         break_value,
                                                         plan_date,
                                                         pm_date,
                                                         comments,
                                                         enter_date,
                                                         enter_by,
                                                         last_modify_date,
                                                         last_modify_by,
                                                         hit_value,
                                                         pm_type,
                                                         confirm_yn,
                                                         pm_division)
                    SELECT   organization_id,
                             line_code,
                             machine_code,
                             break_value,
                             plan_date,
                             SYSDATE pm_date,
                             comments,
                             SYSDATE,
                             enter_by,
                             SYSDATE,
                             last_modify_by,
                             hit_value,
                             lvs_pm_type pm_type,
                             'N' confirm_yn,
                             pm_division
                      FROM   imcn_machine_pm_master
                     WHERE   machine_code = lvs_machine_code AND pm_type = lvs_pm_type AND organization_id = 1;
            ELSE
                p_out := f_msg('ALREADY EXISTS','C',1);
                RETURN;
            END IF;
        ELSE
            DELETE FROM   imcn_machine_pm_master_hist
                  WHERE   machine_code = lvs_machine_code
                      AND pm_type = lvs_pm_type
                      AND TRUNC (pm_date) = TRUNC (SYSDATE)
                      AND organization_id = 1;
        END IF;
    ---------------------------------------------------------------------------------------
    -- JIG 수명 관리만 하기로 해서 
    -- 다른거 다 막고 바코드를 기준으로 수명만 체크하게 
    ---------------------------------------------------------------------------------------
    ELSE
    
    
          lvs_line_code := '*' ; --SUBSTR (p_barcode, 1, lvl_first - 1);
          lvs_jig_lot_no := p_barcode ; --SUBSTR (p_barcode, lvl_first + 1, (lvl_second - lvl_first) - 1);
          lvs_pm_type := '*' ; --TRIM (SUBSTR (p_barcode, lvl_second + 1, 100));

        ------------------------------------------------------------------------
        -- 정상 등록이면 
        -- 수명 등록 
        ------------------------------------------------------------------------
   
           
        IF p_deficit = 'N'
        THEN
        
            BEGIN 
            
               select count(*) into lvi_checck_hit_value 
                 from imcn_jig
                where jig_lot_no = lvs_jig_lot_no
                  and nvl(break_value,0) < nvl(hit_value,0)
                  and organization_id = 1;
                  
                EXCEPTION WHEN NO_DATA_FOUND THEN 
                 lvi_checck_hit_value := 0 ;
                
             END ;
              
             -----------------------------------------
             -- 수명 초과면 
             -----------------------------------------
             IF nvl(lvi_checck_hit_value,0) > 0  then 
             
                p_out := f_msg('LIFE CYCLE OVER','C',1);
                RETURN;
                
              else
                  update imcn_jig set hit_value = nvl(hit_value ,0) + 1
                  where jig_lot_no = lvs_jig_lot_no
                  and organization_id = 1;               
             end if ;

            BEGIN
                SELECT   COUNT ( * )
                  INTO   lvi_count
                  FROM   imcn_jig_pm_master_hist
                 WHERE   jig_lot_no = lvs_jig_lot_no
                     AND pm_type = lvs_pm_type
                     AND TRUNC (pm_date) = TRUNC (SYSDATE)
                     AND organization_id = 1;
            EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
                WHEN NO_DATA_FOUND
                THEN
                    lvi_count := 0;
            END;

                IF lvi_count = 0
                THEN
                    INSERT INTO imcn_jig_pm_master_hist (organization_id,
                                                         line_code,
                                                         jig_code,
                                                         jig_lot_no,
                                                         break_value,
                                                         plan_date,
                                                         pm_date,
                                                         comments,
                                                         enter_date,
                                                         enter_by,
                                                         last_modify_date,
                                                         last_modify_by,
                                                         hit_value,
                                                         pm_type,
                                                         confirm_yn,
                                                         pm_division)
                        SELECT   organization_id,
                                 line_code,
                                 jig_code,
                                 jig_lot_no,
                                 break_value,
                                 plan_date,
                                 SYSDATE pm_date,
                                 comments,
                                 SYSDATE,
                                 enter_by,
                                 SYSDATE,
                                 last_modify_by,
                                 hit_value,
                                 lvs_pm_type pm_type,
                                 'N' confirm_yn,
                                 pm_division
                          FROM   imcn_jig_pm_master
                         WHERE   jig_lot_no = lvs_jig_lot_no AND pm_type = lvs_pm_type AND organization_id = 1;
                ELSE
                    p_out := f_msg('ALREADY EXISTS','C',1);
                    RETURN;
                END IF;
        ELSE
        
        ---------------------------------------------------
        -- 원래는 바코드에 지그 번호 PM 타입이 같이 있어야 하는데 없으면
        ---------------------------------------------------
            DELETE FROM   imcn_jig_pm_master_hist
                  WHERE   jig_lot_no = lvs_jig_lot_no
                      AND pm_type = lvs_pm_type
                      AND TRUNC (pm_date) = TRUNC (SYSDATE)
                      AND organization_id = 1;
        END IF;
    END IF;

    p_out := 'OK';
    RETURN;
-------------------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------------------
EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
    WHEN OTHERS
    THEN
        p_out := 'NG ' || 'PHASE=' || phase || ' ' || SQLERRM;
        RETURN;
END;