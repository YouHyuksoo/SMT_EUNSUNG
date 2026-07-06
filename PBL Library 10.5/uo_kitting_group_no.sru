HA$PBExportHeader$uo_kitting_group_no.sru
forward
global type uo_kitting_group_no from dropdownlistbox
end type
type st_customer from structure within uo_kitting_group_no
end type
end forward

type st_customer from structure
	string		customer_name
	string		customer_name_eng
end type

global type uo_kitting_group_no from dropdownlistbox
integer width = 594
integer height = 676
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean allowedit = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type
global uo_kitting_group_no uo_kitting_group_no

event constructor;STRING LVS_KITTING_GROUP_NO

DECLARE CL1 CURSOR FOR
SELECT DISTINCT kitting_group_no FROM IP_PRODUCT_KITTING_MASTER
 WHERE STATUS = 'N'
      AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
	
 THIS.RESET()
 THIS.ADDITEM('%') 
 OPEN CL1;
 
 IF F_SQL_CHECK() < 0 THEN 
	 CLOSE CL1 ;
	 RETURN 
 END IF
 
 DO 
 FETCH CL1 INTO :LVS_KITTING_GROUP_NO ;
 
 IF F_SQL_CHECK() < 0 THEN 
	 CLOSE CL1 ;
	 RETURN 
 END IF
 
 IF SQLCA.SQLCODE = 100 THEN 
	 CLOSE CL1 ;
	 EXIT
 END IF
 
      THIS.ADDITEM( LVS_KITTING_GROUP_NO ) 
		
LOOP UNTIL 1 = 2

THIS.SELECTITEM(1)
end event

on uo_kitting_group_no.create
end on

on uo_kitting_group_no.destroy
end on

