PACKAGE "PKG_GETAREA" as
 TYPE MyRefCur is REF CURSOR;
 
 procedure GetArea(inStartRowIndex in number, inEndRowIndex in number, inSortExp in varchar2, outTotalRows out number,outAreaCur OUT MyRefCur);
 
END;