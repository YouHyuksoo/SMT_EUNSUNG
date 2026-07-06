PACKAGE "PKG_PLANNING" 
AS
   FUNCTION plan_child_item_issue(
      p_product_date         IN   DATE,
      p_product_sequence     IN   NUMBER,
      p_mfs                  IN   VARCHAR2,
      p_item_code            IN   VARCHAR2,
      p_line_code            IN   VARCHAR2,
      p_workstage_code       IN   VARCHAR2,
      p_machine_code         IN   VARCHAR2,
      p_product_result_qty   IN   NUMBER,
      p_result_status        IN   VARCHAR2,
      p_org                  IN   NUMBER
   )
      RETURN NUMBER;

   FUNCTION plan_ws_child_item_issue(
      p_product_date         IN   DATE,
      p_product_sequence     IN   NUMBER,
      p_mfs                  IN   VARCHAR2,
      p_sub_mfs              IN   VARCHAR2,
      p_item_code            IN   VARCHAR2,
      p_line_code            IN   VARCHAR2,
      p_workstage_code       IN   VARCHAR2,
      p_machine_code         IN   VARCHAR2,
      p_product_result_qty   IN   NUMBER,
      p_product_result_weight   IN   NUMBER,
      p_result_status        IN   VARCHAR2,
      p_org                  IN   NUMBER
   )
      RETURN NUMBER;


   FUNCTION plan_ws_child_item_issue_gen(
      p_product_date         IN   DATE,
      p_product_sequence     IN   NUMBER,
      p_mfs                  IN   VARCHAR2,
      p_sub_mfs              IN   VARCHAR2,
      p_item_code            IN   VARCHAR2,
      p_line_code            IN   VARCHAR2,
      p_workstage_code       IN   VARCHAR2,
      p_machine_code         IN   VARCHAR2,
      p_product_result_qty   IN   NUMBER,
      p_product_result_weight   IN   NUMBER,
      p_result_status        IN   VARCHAR2,
      p_org                  IN   NUMBER
   )
      RETURN NUMBER;



   FUNCTION plan_prod_child_item_issue(
      p_product_date         IN   DATE,
      p_product_sequence     IN   NUMBER,
      p_mfs                  IN   VARCHAR2,
      p_item_code            IN   VARCHAR2,
      p_line_code            IN   VARCHAR2,
      p_workstage_code       IN   VARCHAR2,
      p_machine_code         IN   VARCHAR2,
      p_product_result_qty   IN   NUMBER,
      p_result_status        IN   VARCHAR2,
      p_org                  IN   NUMBER
   )
      RETURN NUMBER;

  FUNCTION plan_prod_child_item_bad_issue(
      p_product_date         IN   DATE,
      p_product_sequence     IN   NUMBER,
      p_mfs                  IN   VARCHAR2,
      p_item_code            IN   VARCHAR2,
      p_line_code            IN   VARCHAR2,
      p_workstage_code       IN   VARCHAR2,
      p_machine_code         IN   VARCHAR2,
      p_product_result_qty   IN   NUMBER,
      p_result_status        IN   VARCHAR2,
      p_org                  IN   NUMBER
   )
      RETURN NUMBER;

   -- ASSEMBLY PLAN GENERATE
   FUNCTION plan_assy_plan_gen(
      p_plan_date       IN   DATE,
      p_plan_sequence   IN   NUMBER,
      p_org             IN   NUMBER
   )
      RETURN NUMBER;

   -- wire ASSEMBLY PLAN GENERATE
   FUNCTION plan_assy_plan_gen_oneself(
      p_plan_date       IN   DATE,
      p_plan_sequence   IN   NUMBER,
      p_line_code       IN   VARCHAR2,
      p_org             IN   NUMBER
   )
      RETURN NUMBER;

   -- WORKSTAGE ASSY ITEM EXPLOSION
   FUNCTION plan_assy_explosion(
      p_plan_date       IN   DATE,
      p_plan_sequence   IN   NUMBER,
      p_org             IN   NUMBER
   )
      RETURN NUMBER;


   -- WORKSTAGE WIRE ASSY ITEM EXPLOSION
   FUNCTION plan_assy_explosion_oneself(
      p_plan_date       IN   DATE,
      p_plan_sequence   IN   NUMBER,
      p_org             IN   NUMBER
   )
      RETURN NUMBER;

-- WORKSTAGE ASSY ITEM EXPLOSION
   FUNCTION plan_prod_explosion(
      p_plan_date       IN   DATE,
      p_plan_sequence   IN   NUMBER,
      p_org             IN   NUMBER
   )
      RETURN NUMBER;
END pkg_planning;