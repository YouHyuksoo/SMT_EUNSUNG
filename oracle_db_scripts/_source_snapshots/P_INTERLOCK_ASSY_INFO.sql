PROCEDURE "P_INTERLOCK_ASSY_INFO" (
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

   lvs_child_item_code         VARCHAR2 (30);
   lvs_set_item_code_cond      VARCHAR2 (30);
   lvi_model_count             NUMBER;
   lvi_child_item_code_count   NUMBER;
   lvs_dup_item                VARCHAR2 (100);
   phase                       VARCHAR2 (10);
   lvs_pcb_item VARCHAR2(10) ;
------------------------------------------------------------------
-- 탑바텀 구분이 올라왔는지 체크 한다
------------------------------------------------------------------

BEGIN
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
   WHEN NO_DATA_FOUND
   THEN
      p_out := 'NOTFOUND';


      RETURN;
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