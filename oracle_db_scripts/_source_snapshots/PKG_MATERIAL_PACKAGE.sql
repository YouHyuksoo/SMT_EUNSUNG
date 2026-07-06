PACKAGE "PKG_MATERIAL" 
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



   FUNCTION mat_mfs_result_net_cost(
      p_org      IN   NUMBER,
      p_yyyymm   IN   VARCHAR2
   )
      RETURN NUMBER;

   FUNCTION mat_mfs_shipping_net_cost(
      p_org      IN   NUMBER,
      p_yyyymm   IN   VARCHAR2
   )
      RETURN NUMBER;

   FUNCTION mat_mfs_total_cost(
      p_org      IN   NUMBER,
      p_yyyymm   IN   VARCHAR2
   )
      RETURN NUMBER;

   FUNCTION mat_mfs_total_4_profit_cost(
      p_org      IN   NUMBER,
      p_yyyymm   IN   VARCHAR2
   )
      RETURN NUMBER;

   FUNCTION mat_auto_purchase_order(
      p_item_code   IN   VARCHAR2,
      p_order_qty   IN   NUMBER,
      p_line_type   IN   VARCHAR2,
      p_org         IN   NUMBER
   )
      RETURN NUMBER;
END; -- Package spec