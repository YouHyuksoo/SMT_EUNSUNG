FUNCTION                    "UNIX_TS_TO_DATE" (p_unix_dt number) return date is
  Result date;
begin

   SELECT TO_DATE('19700102','yyyymmdd') + (p_unix_dt/24/60/60)
     INTO Result
     FROM dual;

  return(Result);
end UNIX_TS_TO_DATE;

