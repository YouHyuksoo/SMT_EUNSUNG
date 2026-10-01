HA$PBExportHeader$uo_smt_layout_model_name_ddlb.sru
$PBExportComments$Item Code
forward
global type uo_smt_layout_model_name_ddlb from dropdownlistbox
end type
end forward

global type uo_smt_layout_model_name_ddlb from dropdownlistbox
integer width = 809
integer height = 2184
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean allowedit = true
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type
global uo_smt_layout_model_name_ddlb uo_smt_layout_model_name_ddlb

forward prototypes
public function string text ()
public subroutine selectitem (string arg_text)
public function string getcode ()
public function integer redraw ()
end prototypes

public function string text ();// RETURN UPPER(THIS.TEXT)

RETURN THIS.TEXT
end function

public subroutine selectitem (string arg_text);INT LVI_RETURN
LVI_RETURN = THIS.SELECTITEM( ARG_TEXT , 0 )

end subroutine

public function string getcode ();RETURN	THIS.TEXT

end function

public function integer redraw ();LONG I
STRING LVS_MODEL_NAME , LVS_MODEL_SUFFIX , LVS_ITEM_CODE  
// $$HEX31$$04c81cc8200085ba44c72000acb934d1200058d5c0bb5cb82000a8ba78b385ba2000a4b4d0c52000e4b278b970ac200099bd74c7c0c92000d0b983ac2000$$ENDHEX$$

DECLARE CUR_01 CURSOR FOR 

 SELECT DISTINCT PARENT_ITEM_CODE
    FROM ID_ENG_BOM_SMT   
   WHERE  PARENT_ITEM_CODE <> '*'
	   AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID	 ;

OPEN CUR_01 ;

THIS.RESET()
THIS.ADDITEM('%')

IF F_SQL_CHECK_WITH_MSG('OPEN FROM ID_ENG_BOM_SMT') < 0 THEN 
	CLOSE CUR_01 ;
	RETURN 0
END IF	

DO 
	FETCH CUR_01 INTO :LVS_MODEL_NAME  ;
	
	IF F_SQL_CHECK_WITH_MSG('SELECT FROM ID_ENG_BOM_SMT') < 0 THEN 
		CLOSE CUR_01 ;
		RETURN 0
	END IF	
	
	IF SQLCA.SQLCODE = 100 THEN 
		CLOSE CUR_01 ;		
		EXIT
	END IF 
	
	THIS.ADDITEM(LVS_MODEL_NAME)
I++
F_MSG_MDI_HELP('UO_SMT_MODEL_NAME : REDRAW-> '+STRING(I)+'Rows')  			
LOOP UNTIL 1 = 2

THIS.SELECTITEM( 1)





end function

on uo_smt_layout_model_name_ddlb.create
end on

on uo_smt_layout_model_name_ddlb.destroy
end on

event rbuttondown;OPEN(w_des_model_master_popup  )

if message.stringparm = '' then 
else
	this.text = Gst_return.Gvs_return[1]
end if
end event

event modified;THIS.TEXT = THIS.TEXT

end event

event constructor;this.redraw( )
end event

