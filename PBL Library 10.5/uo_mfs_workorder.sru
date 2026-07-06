HA$PBExportHeader$uo_mfs_workorder.sru
forward
global type uo_mfs_workorder from dropdownlistbox
end type
type st_customer from structure within uo_mfs_workorder
end type
end forward

type st_customer from structure
	string		customer_name
	string		customer_name_eng
end type

global type uo_mfs_workorder from dropdownlistbox
integer width = 800
integer height = 920
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
global uo_mfs_workorder uo_mfs_workorder

forward prototypes
public subroutine redraw ()
end prototypes

public subroutine redraw ();STRING LVS_MFS

DECLARE CL1 CURSOR FOR

SELECT LOT_NO FROM IP_PRODUCT_RUN_CARD
 WHERE RUN_DATE >= SYSDATE - 7
      AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID  ;
	
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
end subroutine

event rbuttondown;open(w_plan_master_popup) 

if gst_return.gvb_return = true then
	this.text = gst_return.gvs_return[1] 
end if

end event

on uo_mfs_workorder.create
end on

on uo_mfs_workorder.destroy
end on

event constructor;STRING LVS_MFS

DECLARE CL1 CURSOR FOR
SELECT LOT_NO FROM IP_PRODUCT_RUN_CARD
 WHERE RUN_DATE >= SYSDATE - 7
      AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID  ;

	
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

