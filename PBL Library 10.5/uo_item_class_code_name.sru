HA$PBExportHeader$uo_item_class_code_name.sru
forward
global type uo_item_class_code_name from dropdownlistbox
end type
type st_vendor from structure within uo_item_class_code_name
end type
end forward

type st_vendor from structure
	string		vendor_name
	string		vendor_name_eng
end type

global type uo_item_class_code_name from dropdownlistbox
integer width = 521
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
global uo_item_class_code_name uo_item_class_code_name

forward prototypes
public function string text ()
public subroutine settext (double arg_text)
public function string getcode ()
end prototypes

public function string text ();RETURN THIS.TEXT
end function

public subroutine settext (double arg_text);THIS.SELECTITEM(THIS.ADDITEM(STRING(ARG_TEXT)))

end subroutine

public function string getcode ();IF  POS( THIS.TEXT , ':' ) <= 0  THEN 
	RETURN	THIS.TEXT
ELSE
 
RETURN TRIM(MID( THIS.TEXT,  1, POS( THIS.TEXT , ':' ) -1 ))

END IF
end function

event constructor;STRING LVS_CODE_TYPE

DECLARE CL1 CURSOR FOR
SELECT DISTINCT ITEM_CLASS||':'||DECODE(:GVS_LANGUAGE, 'K', ITEM_CLASS_NAME, 'E', ITEM_CLASS_NAME, ITEM_CLASS_NAME)
FROM ID_ITEM_CLASS
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
	 THIS.SELECTITEM(1)	
		
LOOP UNTIL 1 = 2
end event

on uo_item_class_code_name.create
end on

on uo_item_class_code_name.destroy
end on

