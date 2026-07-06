HA$PBExportHeader$uo_product_class_code.sru
forward
global type uo_product_class_code from dropdownlistbox
end type
type st_vendor from structure within uo_product_class_code
end type
end forward

type st_vendor from structure
	string		vendor_name
	string		vendor_name_eng
end type

global type uo_product_class_code from dropdownlistbox
integer width = 654
integer height = 692
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "Help!"
long textcolor = 33554432
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type
global uo_product_class_code uo_product_class_code

forward prototypes
public function string text ()
public subroutine settext (double arg_text)
public subroutine reload ()
end prototypes

public function string text ();RETURN THIS.TEXT
end function

public subroutine settext (double arg_text);THIS.SELECTITEM(THIS.ADDITEM(STRING(ARG_TEXT)))

end subroutine

public subroutine reload ();THIS.TRIGGEREVENT( CONSTRUCTOR!)
end subroutine

event constructor;STRING LVS_DRAWING_NO

DECLARE CL1 CURSOR FOR
SELECT DISTINCT PRODUCT_CLASS_CODE FROM ID_PRODUCT_CLASS
 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
	
 THIS.RESET()
 THIS.ADDITEM('%') 
 OPEN CL1;
 
 
 DO 
 FETCH CL1 INTO :LVS_DRAWING_NO ;
 
 IF F_SQL_CHECK() < 0 THEN 
	 CLOSE CL1 ;
	 RETURN 
 END IF
 
 IF SQLCA.SQLCODE = 100 THEN 
	 CLOSE CL1 ;
	 EXIT
 END IF
 
      THIS.ADDITEM( LVS_DRAWING_NO ) 
		
		
LOOP UNTIL 1 = 2


 
end event

on uo_product_class_code.create
end on

on uo_product_class_code.destroy
end on

