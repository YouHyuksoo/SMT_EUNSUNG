FUNCTION "F_GET_CHILD_ITEM_CODE_CUR" (p_item_code IN VARCHAR2,
                                                     p_org IN NUMBER)
  RETURN sys_refcursor IS
  o_cursor sys_refcursor;

BEGIN

  OPEN o_cursor FOR
    SELECT item_code, item_class
      FROM id_item
     WHERE organization_id = p_org
       AND item_code like p_item_code||'%'
       order by item_code;

  RETURN o_cursor;

END;