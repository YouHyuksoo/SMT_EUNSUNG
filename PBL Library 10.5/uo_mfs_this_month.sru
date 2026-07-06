HA$PBExportHeader$uo_mfs_this_month.sru
forward
global type uo_mfs_this_month from dropdownlistbox
end type
type st_customer from structure within uo_mfs_this_month
end type
end forward

type st_customer from structure
	string		customer_name
	string		customer_name_eng
end type

global type uo_mfs_this_month from dropdownlistbox
integer width = 549
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
global uo_mfs_this_month uo_mfs_this_month

event constructor;STRING LVS_MFS

DECLARE CL1 CURSOR FOR
SELECT MFS FROM IP_PRODUCT_MASTER_PLAN
 WHERE PLAN_YYYYMM         = TO_CHAR( SYSDATE , 'YYYYMM')
      AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
	
 THIS.RESET()
 THIS.ADDITEM('%') 
 OPEN CL1;
 
 IF F_SQL_CHECK() < 0 THEN 
	 CLOSE CL1 ;
	 RETURN 
 END IF
 
 DO 
 FETCH CL1 INTO :LVS_MFS ;
 
 IF F_SQL_CHECK() < 0 THEN 
	 CLOSE CL1 ;
	 RETURN 
 END IF
 
 IF SQLCA.SQLCODE = 100 THEN 
	 CLOSE CL1 ;
	 EXIT
 END IF
 
      THIS.ADDITEM( LVS_MFS ) 
		
LOOP UNTIL 1 = 2

THIS.SELECTITEM(1)
end event

on uo_mfs_this_month.create
end on

on uo_mfs_this_month.destroy
end on

