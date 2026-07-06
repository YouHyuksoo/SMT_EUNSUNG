HA$PBExportHeader$uo_smt_bom_revision_dynamic.sru
forward
global type uo_smt_bom_revision_dynamic from dropdownlistbox
end type
type st_vendor from structure within uo_smt_bom_revision_dynamic
end type
end forward

type st_vendor from structure
	string		vendor_name
	string		vendor_name_eng
end type

global type uo_smt_bom_revision_dynamic from dropdownlistbox
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
global uo_smt_bom_revision_dynamic uo_smt_bom_revision_dynamic

forward prototypes
public function string text ()
public subroutine settext (double arg_text)
public function string getcode ()
public function string redraw (string arg_line_code, string arg_item_code, string arg_feeder_shaft)
public function string redraw_active (string arg_line_code, string arg_model_name, string arg_feeder_shaft)
end prototypes

public function string text ();RETURN THIS.TEXT
end function

public subroutine settext (double arg_text);THIS.SELECTITEM(THIS.ADDITEM(STRING(ARG_TEXT)))

end subroutine

public function string getcode ();IF  POS( THIS.TEXT , ':' ) <= 0  THEN 
	
	
	if Len( this.text) = 0 then 
		return '0000'
	else
		RETURN	THIS.TEXt
	end if 
ELSE
 
RETURN TRIM(MID( THIS.TEXT,  1, POS( THIS.TEXT , ':' ) -1 ))

END IF
end function

public function string redraw (string arg_line_code, string arg_item_code, string arg_feeder_shaft);STRING LVS_REVISION

DECLARE CL1 CURSOR FOR

SELECT MAX(REVISION)
 FROM ID_ENG_BOM_SMT
WHERE LINE_CODE = :ARG_LINE_CODE
   AND PARENT_ITEM_CODE = :ARG_ITEM_CODE
   AND FEEDER_SHAFT = :arg_feeder_shaft
   AND REVISION <> '0000' 
   AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID
;
	
 THIS.RESET()
 
//THIS.ADDITEM( '0000' ) 
 OPEN CL1;
 
 DO 
 FETCH CL1 INTO :LVS_REVISION ;
 
	 IF F_SQL_CHECK() < 0 THEN 
		 CLOSE CL1 ;
		 RETURN '*'
	 END IF
	 
	 IF SQLCA.SQLCODE = 100 THEN 
		 CLOSE CL1 ;
		 EXIT
	 END IF
 
	THIS.ADDITEM( LVS_REVISION ) 
	THIS.SELECTITEM(1)				
		
LOOP UNTIL 1 = 2

THIS.SELECTITEM( 1)
end function

public function string redraw_active (string arg_line_code, string arg_model_name, string arg_feeder_shaft);STRING LVS_MFS

DECLARE CL1 CURSOR FOR

SELECT MAX(REVISION)
 FROM IB_PRODUCT_PLANDATA
WHERE LINE_CODE = :ARG_LINE_CODE
   AND MODEL_NAME = :ARG_MODEL_NAME
   AND FEEDER_SHAFT = :ARG_FEEDER_SHAFT 
   AND ACTIVE_YN = 'Y' 
   AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID
GROUP BY LINE_CODE , MODEL_NAME , FEEDER_SHAFT 	;
	
 THIS.RESET()
 OPEN CL1;
 
 DO 
 FETCH CL1 INTO :LVS_MFS ;
 
	 IF F_SQL_CHECK() < 0 THEN 
		 CLOSE CL1 ;
		 RETURN '0000'
	 END IF
	 
	 IF SQLCA.SQLCODE = 100 THEN 
		 CLOSE CL1 ;
		 EXIT
	 END IF
 
	THIS.ADDITEM( LVS_MFS ) 
	THIS.SELECTITEM(1)				
		
LOOP UNTIL 1 = 2

THIS.SELECTITEM( 1)
end function

on uo_smt_bom_revision_dynamic.create
end on

on uo_smt_bom_revision_dynamic.destroy
end on

