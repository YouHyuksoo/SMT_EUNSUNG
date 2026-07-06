HA$PBExportHeader$uo_company_code.sru
forward
global type uo_company_code from dropdownlistbox
end type
type st_vendor from structure within uo_company_code
end type
end forward

type st_vendor from structure
	string		vendor_name
	string		vendor_name_eng
end type

global type uo_company_code from dropdownlistbox
integer width = 389
integer height = 676
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type
global uo_company_code uo_company_code

event constructor;STRING LVS_COMPANY_CODE

DECLARE CL1 CURSOR FOR
SELECT COMPANY_CODE FROM ISYS_COMPANY;
	
 THIS.RESET()
 THIS.ADDITEM('%') 
 OPEN CL1;
 
 
 DO 
 FETCH CL1 INTO :LVS_COMPANY_CODE ;
 
 IF F_SQL_CHECK() < 0 THEN 
	 CLOSE CL1 ;
	 RETURN 
 END IF
 
 IF SQLCA.SQLCODE = 100 THEN 
	 CLOSE CL1 ;
	 EXIT
 END IF
 
      THIS.ADDITEM( LVS_COMPANY_CODE ) 
		
		
LOOP UNTIL 1 = 2
end event

on uo_company_code.create
end on

on uo_company_code.destroy
end on

