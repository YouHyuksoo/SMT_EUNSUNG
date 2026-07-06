FUNCTION "F_GET_LAST_LINE" (p_item_code      IN VARCHAR2,
                          p_material_mfs   IN VARCHAR2,
                          p_enter_date     IN DATE)
    RETURN VARCHAR2
IS
    lvs_line   VARCHAR2 (30);
BEGIN
    SELECT   DISTINCT line_code
      INTO   lvs_line
      FROM   im_item_issue
     WHERE       material_mfs = p_material_mfs
             AND item_code = p_item_code
             AND issue_deficit = '3'
             AND line_code IN
                        ('01',
                         '02',
                         '03',
                         '04',
                         '05',
                         '06',
                         '07',
                         '08',
                         '09',
                         '10',
                         '11',
                         '12',
                         '13',
                         '14',
                         '21',
                         '22',
                         '23',
                         '24',
                         '31',
                         '32',
                         '33',
                         '34',
                         '35',
                         '36')
             AND enter_date =
                    (SELECT   MAX (enter_date)
                       FROM   im_item_issue a
                      WHERE       a.material_mfs = p_material_mfs
                              AND a.item_code = p_item_code
                              AND a.issue_deficit = '3'
                              AND a.enter_date < p_enter_date
                              AND line_code IN
                                         ('01',
                                          '02',
                                          '03',
                                          '04',
                                          '05',
                                          '06',
                                          '07',
                                          '08',
                                          '09',
                                          '10',
                                          '11',
                                          '12',
                                          '13',
                                          '14',
                                          '21',
                                          '22',
                                          '23',
                                          '24',
                                          '31',
                                          '32',
                                          '33',
                                          '34',
                                          '35',
                                          '36'));


    RETURN lvs_line;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        RETURN 'NOT FOUND';
    WHEN OTHERS
    THEN
        raise_application_error (-20003, SQLERRM);
END;