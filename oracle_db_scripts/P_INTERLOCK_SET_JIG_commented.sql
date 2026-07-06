CREATE OR REPLACE PROCEDURE "P_INTERLOCK_SET_JIG" (
  /* ================================================================
   * 프로시저명  : P_INTERLOCK_SET_JIG
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   프로시저 원본 로직의 업무 처리 흐름을 수행한다.
   *   참조 테이블과 입력 파라미터를 기반으로 조회, 등록, 갱신 또는 메시지 반환을 처리한다.
   *   원본 코드의 트랜잭션 및 예외 처리 흐름은 변경하지 않았다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_LINE_CODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_WORKSTAGE_CODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_MACHINE_CODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_RESULT - 원본 선언부 기준 입력/출력 파라미터
   *   P_HIT_VALUE - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IMCN_JIG - 원본 로직 참조 테이블
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_GET_WORKSTAGE_TYPE
   * ================================================================
   * [AI 분석] 예외 처리:
   *   원본 EXCEPTION 절의 반환값, RAISE, COMMIT/ROLLBACK 흐름을 변경하지 않는다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 구현 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_INTERLOCK_SET_JIG(...)
   * ================================================================ */
   p_line_code        IN     VARCHAR2,
   p_workstage_code   IN     VARCHAR2,
   p_machine_code     IN     VARCHAR2,
   p_result              OUT VARCHAR2,
   p_hit_value           OUT VARCHAR2)
IS
   lvl_hit_value        NUMBER; -- [AI] 내부 처리용 변수
   lvs_jit_type_param   VARCHAR2 (10); -- [AI] 내부 처리용 변수
   LVS_LAST_JIG_LOT_NO   VARCHAR2(100) ; -- [AI] 내부 처리용 변수
BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.
   ------------------------------------------------------------------------------
   --
   ------------------------------------------------------------------------------
   BEGIN
      IF F_GET_WORKSTAGE_TYPE(p_workstage_code) = 'ICT'                                       --ICT
      THEN
         lvs_jit_type_param := 'T';                                 -- FIXTURE
      ELSE
         lvs_jit_type_param := 'M';                           -- MASK , SQUEZE
      END IF;


   -- 2016011 SHS, hit수량을 1에서 기존 hit 수량에 1을 더한 값을 return 한다

      SELECT hit_value
        INTO lvl_hit_value
        FROM imcn_jig
       WHERE     line_code = p_line_code
         -- AND machine_code = p_machine_code
         AND jig_type = lvs_jit_type_param;
         
   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN NO_DATA_FOUND
      THEN
         lvl_hit_value := 0;
   END;

--   -----------------------------------------------------------------------------
--   --  FIXTURE METAL MASK , SQUEZE LIFE CYCLE
--   ------------------------------------------------------------------------------

/*

   IF lvs_jit_type_param = 'T'
   THEN
      UPDATE imcn_jig
         SET hit_value = NVL (hit_value, 0) + 1
       WHERE     line_code = p_line_code
             AND jig_type = 'T';
   ELSE
     
      -------------------------------------------------------------
      -- 해당 라인으로 출고 처리된 마스크 전부
      -------------------------------------------------------------
      UPDATE imcn_jig
         SET hit_value = NVL (hit_value, 0) + 1
       WHERE line_code = p_line_code
          AND jig_type = 'M';
         --   AND jig_type IN ('M' , 'S' );
         
           ------------------------------------------------------------------
           -- 해당 라인으로 출고 처리된 스퀴지 전부
           -------------------------------------------------------------
           BEGIN 
                   SELECT JIG_LOT_NO 
                     INTO LVS_LAST_JIG_LOT_NO
                     FROM IMCN_JIG
                    WHERE LINE_CODE = p_line_code
                      AND NVL(LAST_HIT_YN ,'N') = 'Y'
                      AND jig_type = 'S'
                      AND ROWNUM = 1 ;
                      
             EXCEPTION WHEN OTHERS THEN 
                      LVS_LAST_JIG_LOT_NO := NULL ;
             END ;
             
            IF   LVS_LAST_JIG_LOT_NO IS NULL THEN 
            
              UPDATE imcn_jig SET hit_value = NVL (hit_value, 0) + 1 , LAST_HIT_YN = 'Y'
               WHERE line_code = p_line_code
                 AND jig_type = 'S'
                 AND NVL(LAST_HIT_YN,'N') = 'N'
                 AND JIG_LOT_NO = ( SELECT MIN(JIG_LOT_NO) FROM imcn_jig WHERE  line_code = p_line_code  AND jig_type = 'S' AND NVL( LAST_HIT_YN ,'N')  <> 'Y' )
                 ;     
            ELSE
            
            
               UPDATE imcn_jig SET LAST_HIT_YN = 'N'
               WHERE line_code = p_line_code
                 AND jig_type = 'S'
                 AND NVL(LAST_HIT_YN,'N') = 'Y'
                 AND JIG_LOT_NO = LVS_LAST_JIG_LOT_NO ;
                 
              UPDATE imcn_jig SET hit_value = NVL (hit_value, 0) + 1 , LAST_HIT_YN = 'Y'
               WHERE line_code = p_line_code
                 AND jig_type = 'S'
                 AND JIG_LOT_NO <> LVS_LAST_JIG_LOT_NO ;       
            
            END IF ;        
         
   END IF;
   
*/
      
   ------------------------------------------------------------------
   --
   ------------------------------------------------------------------
   p_result := 'OK';
   p_hit_value := lvl_hit_value + 1 ;
   
   COMMIT;
   RETURN;
   
EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN OTHERS
   THEN
      p_result := SQLERRM;
      raise_application_error (-20003, SQLERRM);
END;
