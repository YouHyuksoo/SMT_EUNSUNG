PACKAGE BODY "PKG_GETAREA" as
  PROCEDURE GetArea(inStartRowIndex in number, inEndRowIndex in number, inSortExp in varchar2, outTotalRows out number, outAreaCur OUT MyRefCur)  IS
    
  BEGIN
    select count(*) 
      into outTotalRows 
      from tb_area_mst;
    
    if(inEndRowIndex = -1) then
       open outAreaCur for select CODE_TYPE, CODE_NAME, CODE_MEAN_KOR
                             from ISYS_BASECODE  
                             order by CODE_TYPE;
    else
      begin
        open outAreaCur for select CODE_TYPE, CODE_NAME, CODE_MEAN_KOR
                              from (
                                    select  CODE_TYPE, CODE_NAME, CODE_MEAN_KOR, 
                                            ROW_NUMBER()
                                            OVER
                                            (
                                              ORDER BY
                                              Decode(CODE_TYPE,'CODE_TYPE ASC',CODE_TYPE) ASC,
                                              Decode(CODE_NAME,'CODE_NAME DESC',CODE_NAME) DESC,
                                              Decode(CODE_MEAN_KOR,'CODE_MEAN_KOR ASC',CODE_MEAN_KOR) ASC
                                             )
                                            R 
                                       FROM ISYS_BASECODE
                                    )
                               WHERE R BETWEEN inStartRowIndex AND inEndRowIndex;
       end;
      End if;
    END;
 END;