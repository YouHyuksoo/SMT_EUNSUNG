FUNCTION "F_GET_REEL_QTY" (p_item_code   IN VARCHAR2,
/* Formatted on 29-11-2014 15:50:56 (QP5 v5.126) */
                         p_type        IN NUMBER,
                         p_qty         IN NUMBER,
                         p_org         IN NUMBER)
    RETURN NUMBER
IS
    lvl_return          NUMBER;
    lvl_material_qty    NUMBER;
    lvl_material_qty2   NUMBER;
BEGIN
    SELECT   NVL (material_qty, 0), NVL (material_qty2, 0)
      INTO   lvl_material_qty, lvl_material_qty2
      FROM   id_item
     WHERE   item_code = p_item_code AND organization_id = p_org;


    IF p_type = 1
    THEN
        IF lvl_material_qty = 0
        THEN
            RETURN 0;
        END IF;

        lvl_return := TRUNC (p_qty / lvl_material_qty, 0);

        IF MOD (p_qty, lvl_material_qty) > 0
        THEN
            lvl_return := lvl_return + 1;
        END IF;
    ELSE
        IF lvl_material_qty2 = 0
        THEN
            RETURN 0;
        END IF;

        lvl_return := TRUNC (p_qty / lvl_material_qty2, 0);

        IF MOD (p_qty, lvl_material_qty2) > 0
        THEN
            lvl_return := lvl_return + 1;
        END IF;
    END IF;

    RETURN lvl_return;
EXCEPTION
    WHEN OTHERS
    THEN
        RETURN 0;
END;