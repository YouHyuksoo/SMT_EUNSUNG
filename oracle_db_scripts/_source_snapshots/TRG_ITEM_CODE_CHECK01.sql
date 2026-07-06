TRIGGER "INFINITY21_JSMES"."TRG_ITEM_CODE_CHECK01" 
BEFORE INSERT
ON ID_ENG_BOM_SMT
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE
    numrows   INTEGER;

BEGIN
--    SELECT   COUNT ( * )
--      INTO   numrows
--      FROM   ip_product_model_master
--     WHERE   master_model_name = :new.master_model_name
--             AND organization_id = :new.organization_id;
--
--    IF numrows = 0
--    THEN
--        raise_application_error (
--            -20003,
--            :new.parent_item_code || '품목정보에 모델명이 등록되어 있지 않습니다.');
--    END IF;


    numrows := 0;

    SELECT   COUNT ( * )
      INTO   numrows
      FROM   id_item
     WHERE   item_code = :new.child_item_code
             AND organization_id = :new.organization_id;

    IF numrows = 0
    THEN
        raise_application_error (
            -20003,
            'cHILD='||:new.child_item_code || ' Child Item Not Found in Item Master');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        raise_application_error (-20003, 'Item Not Found in Item Master');
END;