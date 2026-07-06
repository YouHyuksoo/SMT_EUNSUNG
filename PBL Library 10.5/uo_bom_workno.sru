HA$PBExportHeader$uo_bom_workno.sru
forward
global type uo_bom_workno from dropdownlistbox
end type
type st_vendor from structure within uo_bom_workno
end type
end forward

type st_vendor from structure
	string		vendor_name
	string		vendor_name_eng
end type

global type uo_bom_workno from dropdownlistbox
integer width = 535
integer height = 692
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type
global uo_bom_workno uo_bom_workno

forward prototypes
public function string text ()
public subroutine settext (double arg_text)
public subroutine redraw ()
end prototypes

public function string text ();RETURN THIS.TEXT
end function

public subroutine settext (double arg_text);THIS.SELECTITEM(THIS.ADDITEM(STRING(ARG_TEXT)))

end subroutine

public subroutine redraw ();this.triggerevent(constructor!)
end subroutine

event constructor;STRING LVS_WORKNO

DECLARE CL1 CURSOR FOR
SELECT DISTINCT BOM_WORK_NO FROM ID_ENG_BOM_WORKSPACE
 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID
 ORDER BY BOM_WORK_NO DESC;
	
 THIS.RESET()
 THIS.ADDITEM('%') 
 OPEN CL1;
 
 
 DO 
 FETCH CL1 INTO :LVS_WORKNO ;
 
 IF F_SQL_CHECK() < 0 THEN 
	 CLOSE CL1 ;
	 RETURN 
 END IF
 
 IF SQLCA.SQLCODE = 100 THEN 
	 CLOSE CL1 ;
	 EXIT
 END IF
 
      THIS.ADDITEM( LVS_WORKNO ) 
		
		
LOOP UNTIL 1 = 2
end event

on uo_bom_workno.create
end on

on uo_bom_workno.destroy
end on

event rbuttondown;OPEN(W_DES_WORK_NO_POPUP )

IF MESSAGE.DOUBLEPARM = 0 OR ISNULL(MESSAGE.DOUBLEPARM) THEN 
ELSE
	THIS.TEXT = STRING(MESSAGE.DOUBLEPARM)
	THIS.TRIGGEREVENT( SELECTIONCHANGED!)
END IF
end event

