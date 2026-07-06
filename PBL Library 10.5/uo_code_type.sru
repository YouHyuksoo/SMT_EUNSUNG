HA$PBExportHeader$uo_code_type.sru
forward
global type uo_code_type from dropdownlistbox
end type
type st_vendor from structure within uo_code_type
end type
end forward

type st_vendor from structure
	string		vendor_name
	string		vendor_name_eng
end type

global type uo_code_type from dropdownlistbox
integer width = 850
integer height = 692
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
global uo_code_type uo_code_type

forward prototypes
public function string text ()
public subroutine settext (double arg_text)
end prototypes

public function string text ();RETURN THIS.TEXT
end function

public subroutine settext (double arg_text);THIS.SELECTITEM(THIS.ADDITEM(STRING(ARG_TEXT)))

end subroutine

event constructor;STRING LVS_CODE_TYPE

DECLARE CL1 CURSOR FOR
SELECT DISTINCT CODE_TYPE
 FROM ISYS_BASECODE 
 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
	
 THIS.RESET()
 THIS.ADDITEM('%') 
 OPEN CL1;
 
 
 DO 
 FETCH CL1 INTO :LVS_CODE_TYPE ;
 
 IF F_SQL_CHECK() < 0 THEN 
	 CLOSE CL1 ;
	 RETURN 
 END IF
 
 IF SQLCA.SQLCODE = 100 THEN 
	 CLOSE CL1 ;
	 EXIT
 END IF
 
      THIS.ADDITEM( LVS_CODE_TYPE ) 
		
		
LOOP UNTIL 1 = 2
end event

on uo_code_type.create
end on

on uo_code_type.destroy
end on

