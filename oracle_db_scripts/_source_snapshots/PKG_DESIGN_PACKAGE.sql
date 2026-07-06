PACKAGE "PKG_DESIGN" 
IS

--
-- To modify this template, edit file PKGSPEC.TXT in TEMPLATE
-- directory of SQL Navigator
--
-- Purpose: Briefly explain the functionality of the package
--
-- MODIFICATION HISTORY
-- Person      Date    Comments
-- ---------   ------  ------------------------------------------
   -- Enter package declarations as shown below


   FUNCTION bom_query(
      p_parent_item_code   IN   VARCHAR2,
      p_dateset            IN   DATE,
      p_org                IN   NUMBER
   )
      RETURN NUMBER;

   FUNCTION bom_query_all(
      p_parent_item_code   IN   VARCHAR2,
      p_dateset            IN   DATE,
      p_org                IN   NUMBER
   )
      RETURN NUMBER;

   FUNCTION bom_model_qty(
      p_org          IN   VARCHAR2,
      p_session_id   IN   NUMBER
   )
      RETURN NUMBER;

   FUNCTION bom_translation(
      p_work_no         IN   NUMBER,
      p_set_item_code   IN   VARCHAR2,
      p_org             IN   NUMBER
   )
      RETURN NUMBER;

   FUNCTION bom_newins_check(
      p_work_no            IN   NUMBER,
      p_set_item_code      IN   VARCHAR2,
      p_parent_item_code   IN   VARCHAR2,
      p_child_item_code    IN   VARCHAR2,
      p_dateset            IN   DATE,
      p_org                IN   NUMBER
   )
      RETURN NUMBER;

   FUNCTION bom_loop_check(
      p_parent_item_code   IN   VARCHAR2,
      p_child_item_code    IN   VARCHAR2,
      p_dateset            IN   DATE,
      p_org                IN   NUMBER
   )
      RETURN NUMBER;

   FUNCTION bom_loop_check_eco(
      p_parent_item_code   IN   VARCHAR2,
      p_child_item_code    IN   VARCHAR2,
      p_dateset            IN   DATE,
      p_org                IN   NUMBER
   )
      RETURN NUMBER;

   FUNCTION bom_eco_confirm(
      p_eco_work_no   IN   NUMBER,
      p_org           IN   NUMBER
   )
      RETURN NUMBER;

   FUNCTION bom_explosion(
      p_parent_item_code   IN   VARCHAR2,
      p_dateset            IN   DATE,
      p_org                IN   NUMBER
   )
      RETURN NUMBER;

   FUNCTION bom_explosion_all(
      p_parent_item_code   IN   VARCHAR2,
      p_dateset            IN   DATE,
      p_org                IN   NUMBER
   )
      RETURN NUMBER;

   FUNCTION bom_assy_explosion(
      p_parent_item_code   IN   VARCHAR2,
      p_child_item_code    IN   VARCHAR2,
      p_dateset            IN   DATE,
      p_org                IN   NUMBER
   )
      RETURN NUMBER;

   -- wire assy explosion
   FUNCTION bom_oneself_assy_explosion(
      p_parent_item_code   IN   VARCHAR2,
      p_dateset            IN   DATE,
      p_org                IN   NUMBER
   )
      RETURN NUMBER;

   -- FREE ASSY ITEM EXPLOSION
   FUNCTION bom_free_assy_explosion(
      p_parent_item_code   IN   VARCHAR2,
      p_dateset            IN   DATE,
      p_org                IN   NUMBER
   )
      RETURN NUMBER;

   -- BOM COPY
   FUNCTION bom_copy(
      p_bom_work_no             IN   NUMBER,
      p_source_item_code        IN   VARCHAR2,
      p_dest_parent_item_code   IN   VARCHAR2,
      p_dest_item_code          IN   VARCHAR,
      p_dateset                      DATE,
      p_org                     IN   NUMBER
   )
      RETURN NUMBER;

   FUNCTION bom_count(
      p_parent_item_code   IN   VARCHAR2,
      p_dateset            IN   DATE,
      p_org                IN   NUMBER
   )
      RETURN NUMBER;

   FUNCTION bom_material_cost(
      p_parent_item_code   IN   VARCHAR2,
      p_dateset            IN   DATE,
      p_price_type         IN   VARCHAR2,
      p_org                IN   NUMBER
   )
      RETURN NUMBER;
END; -- Package spec


-- End of DDL Script for Package HSRM.PKG_DESIGN