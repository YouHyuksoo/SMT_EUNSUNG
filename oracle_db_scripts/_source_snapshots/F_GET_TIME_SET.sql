FUNCTION "F_GET_TIME_SET" (p_date IN DATE, p_org IN NUMBER)
/* Formatted on 2015-06-19 10:30:31 (QP5 v5.126) */
    RETURN VARCHAR2
IS
    lvs_time_set   VARCHAR2 (20);
BEGIN
    IF TO_CHAR (p_date, 'HH24MI') > '0820' AND TO_CHAR (p_date, 'HH24MI') <= '1020'
    THEN
        lvs_time_set := '1A 0820-1020';
    ELSIF TO_CHAR (p_date, 'HH24MI') > '1020' AND TO_CHAR (p_date, 'HH24MI') <= '1320'
    THEN
        lvs_time_set := '1B 1020-1320';
    ELSIF TO_CHAR (p_date, 'HH24MI') > '1320' AND TO_CHAR (p_date, 'HH24MI') <= '1520'
    THEN
        lvs_time_set := '1C 1320-1520';
    ELSIF TO_CHAR (p_date, 'HH24MI') > '1520' AND TO_CHAR (p_date, 'HH24MI') <= '1730'
    THEN
        lvs_time_set := '1D 1520-1730';
    ELSIF TO_CHAR (p_date, 'HH24MI') > '1730' AND TO_CHAR (p_date, 'HH24MI') <= '2020'
    THEN
        lvs_time_set := '1E 1730-2020';
    ELSIF TO_CHAR (p_date, 'HH24MI') > '2020' AND TO_CHAR (p_date, 'HH24MI') <= '2220'
    THEN
        lvs_time_set := '2A 2020-2220';

    ELSIF TO_CHAR (p_date, 'HH24MI') > '2220' AND TO_CHAR (p_date, 'HH24MI') <= '2359'
    THEN
        lvs_time_set := '2B 2220-0120';

    ELSIF TO_CHAR (p_date, 'HH24MI') >= '0000' AND TO_CHAR (p_date, 'HH24MI') <= '0120'
    THEN
        lvs_time_set := '2B 2220-0120';
    ELSIF TO_CHAR (p_date, 'HH24MI') > '0120' AND TO_CHAR (p_date, 'HH24MI') <= '0320'
    THEN
        lvs_time_set := '2C 0120-0320';
    ELSIF TO_CHAR (p_date, 'HH24MI') > '0320' AND TO_CHAR (p_date, 'HH24MI') <= '0530'
    THEN
        lvs_time_set := '2D 0320-0530';
    ELSIF TO_CHAR (p_date, 'HH24MI') > '0530' AND TO_CHAR (p_date, 'HH24MI') <= '0820'
    THEN
        lvs_time_set := '2E 0530-0820';
    ELSE
        lvs_time_set := TO_CHAR (p_date, 'HH24MI');
    END IF;

    RETURN lvs_time_set;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        RETURN '*';
    WHEN otherS
    THEN
        raise_application_error (-20003, SQLERRM);
END;