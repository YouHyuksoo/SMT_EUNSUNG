HA$PBExportHeader$uo_feeder_shaft_dynamic.sru
forward
global type uo_feeder_shaft_dynamic from dropdownlistbox
end type
type st_vendor from structure within uo_feeder_shaft_dynamic
end type
end forward

type st_vendor from structure
	string		vendor_name
	string		vendor_name_eng
end type

global type uo_feeder_shaft_dynamic from dropdownlistbox
integer width = 626
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
global uo_feeder_shaft_dynamic uo_feeder_shaft_dynamic

forward prototypes
public function string text ()
public subroutine settext (double arg_text)
public function string getcode ()
public function string redraw (string arg_line_code, string arg_model_name)
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

public function string redraw (string arg_line_code, string arg_model_name);STRING LVS_CODE_TYPE

DECLARE CL1 CURSOR FOR
SELECT DISTINCT  FEEDER_SHAFT
 FROM ID_ENG_BOM_SMT
WHERE LINE_CODE             like :arg_line_code
   AND PARENT_ITEM_CODE like :ARG_MODEL_name
   AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
	
 THIS.RESET()
 OPEN CL1;
 
 DO 
 FETCH CL1 INTO :LVS_CODE_TYPE ;
 
 IF F_SQL_CHECK() < 0 THEN 
	 CLOSE CL1 ;
	 RETURN '*'
 END IF
 
 IF SQLCA.SQLCODE = 100 THEN 
	 CLOSE CL1 ;
	 EXIT
 END IF
 
	THIS.ADDITEM( LVS_CODE_TYPE ) 
	THIS.SELECTITEM(1)				
		
LOOP UNTIL 1 = 2

THIS.SELECTITEM( 1)
end function

on uo_feeder_shaft_dynamic.create
end on

on uo_feeder_shaft_dynamic.destroy
end on

