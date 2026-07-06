CREATE OR REPLACE PROCEDURE "P_INTERLOCK_ASSY_INFO" (
  /* ================================================================
   * 프로시저명  : P_INTERLOCK_ASSY_INFO
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
   *   P_SET_ITEM_CODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_TOPBOT - 원본 선언부 기준 입력/출력 파라미터
   *   P_ORG - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IB_PRODUCT_PLANDATA - 원본 로직 참조 테이블
   *   ID_ENG_BOM - DESIGN BOM
   *   ID_ITEM - Item Master
   *   IP_PRODUCT_LINE - Product Line Master
   *   IP_PRODUCT_MODEL_MASTER - 원본 로직 참조 테이블
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
   *   EXEC P_INTERLOCK_ASSY_INFO(...)
   * ================================================================ */
   p_line_code       IN     VARCHAR2,
   p_set_item_code   IN     VARCHAR2,
   p_topbot          IN     VARCHAR2,
   p_org             IN     NUMBER,
   p_out                OUT VARCHAR2)
IS
   ------------------------------------------------------------------
   -- spi 에서 호출 하는 프로시져 
   --
   -- ---------   ------  -------------------------------------------

   lvs_child_item_code         VARCHAR2 (30); -- [AI] 내부 처리용 변수
   lvs_set_item_code_cond      VARCHAR2 (30); -- [AI] 내부 처리용 변수
   lvi_model_count             NUMBER; -- [AI] 내부 처리용 변수
   lvi_child_item_code_count   NUMBER; -- [AI] 내부 처리용 변수
   lvs_dup_item                VARCHAR2 (100); -- [AI] 내부 처리용 변수
   phase                       VARCHAR2 (10); -- [AI] 내부 처리용 변수
   lvs_pcb_item VARCHAR2(10) ; -- [AI] 내부 처리용 변수
------------------------------------------------------------------
-- 탑바텀 구분이 올라왔는지 체크 한다
------------------------------------------------------------------

BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.
   phase := '10';

   IF p_topbot NOT IN ('T', 'B')
   THEN
      p_out := f_msg('TOP/BOTTOM NG','C',1);
      RETURN;
   END IF;

   phase := '20';


   ------------------------------------------------------------------
   -- 
   --  pda  장착 되었는지 체크 한다
   ------------------------------------------------------------------
   BEGIN
      SELECT MAX (PCB_ITEM)
        INTO LVS_PCB_ITEM
        FROM IB_PRODUCT_PLANDATA
       WHERE LINE_CODE = P_LINE_CODE AND ACTIVE_YN = 'Y';
   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN OTHERS
      THEN
         NULL;
   END;


   if LVS_PCB_ITEM is null THEN 
      p_out := p_line_code || f_msg(' : CCS 장착이력 없음.','C',1);
      RETURN;
   
   end if ;

    IF p_topbot <> LVS_PCB_ITEM then 
    
      p_out := p_line_code ||':'||LVS_PCB_ITEM||f_msg(':CCS 장착이력과 다름.','C',1);
      RETURN;      
    
    END IF ;
  
   ------------------------------------------------------------------
   -- 모델마스터에 등록된 품목코드인지 체크한다
   ------------------------------------------------------------------
   BEGIN
      SELECT COUNT (*)
        INTO lvi_model_count
        FROM ip_product_model_master
       WHERE item_code = p_set_item_code AND organization_id = p_org;
   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN NO_DATA_FOUND
      THEN
         lvi_model_count := 0;
   END;

   phase := '30';

   IF lvi_model_count > 0
   THEN
      lvs_set_item_code_cond := p_set_item_code;
   ELSE
      p_out := p_set_item_code || f_msg(' : 모델 미등록 품목 입니다.','C',1);
      RETURN;
   END IF;

   phase := '40';

   ---------------------------------------------------------------------
   --   탑바텀 구분값에 해당하는 자품목코드가 무엇인지
   --   BOM 에서 가져와서 공정인터락 장비에 넘겨준다.
   --   모델 마스터에 관리를 잘 할 경우 모델마스터에서 가져오는게 안정적임.
   ---------------------------------------------------------------------
   BEGIN
      SELECT MAX (item_code)
        INTO lvs_child_item_code
        FROM id_item
       WHERE item_code IN
                (SELECT PARENT_ITEM_CODE
                   FROM id_eng_bom m
                 START WITH m.child_item_code = lvs_set_item_code_cond
                 CONNECT BY PRIOR child_item_code = parent_item_code)
             AND item_class = LVS_PCB_ITEM ;
   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN NO_DATA_FOUND
      THEN
         NULL;
   END;

   phase := '50';

   IF LVS_CHILD_ITEM_CODE IS NULL
   THEN
      p_out :=
         f_msg('BOM 이없거나 품목관리에 탑바텀을 등록하세요 : '  ,'C',1) 
         || lvs_set_item_code_cond
         || ' T/B :'
         || p_topbot;
      RETURN;
   END IF;

   --------------------------------------------------------------------------
   -- 라인 마스터에 최종 정보 변경
   --------------------------------------------------------------------------

   UPDATE ip_product_line
      SET pcb_item = p_topbot,
          child_item_code = lvs_child_item_code,
          item_code = nvl(p_set_item_code , '*') ,
          comments = 'P_INTERLOCK_ASSY_INFO : '||SYSDATE
    WHERE line_code = substr(p_line_code , 1,2) ;

   COMMIT;
   --------------------------------------------------------------------------
   --
   -- 자품목을 리런해 준다.
   --------------------------------------------------------------------------
   p_out := lvs_child_item_code;
   phase := '60';

   RETURN;

   phase := '70';
EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN NO_DATA_FOUND
   THEN
      p_out := 'NOTFOUND';


      RETURN;
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN OTHERS
   THEN
      raise_application_error (
         -20003,
            'PHASE='
         || phase
         || ' SET ITEM CODE='
         || p_set_item_code
         || ' T/b='
         || p_topbot
         || ' '
         || SQLERRM);
END;