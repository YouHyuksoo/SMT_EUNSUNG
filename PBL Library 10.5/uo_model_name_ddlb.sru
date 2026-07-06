HA$PBExportHeader$uo_model_name_ddlb.sru
$PBExportComments$Item Code
forward
global type uo_model_name_ddlb from dropdownlistbox
end type
end forward

global type uo_model_name_ddlb from dropdownlistbox
integer width = 809
integer height = 832
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
global uo_model_name_ddlb uo_model_name_ddlb

forward prototypes
public function string text ()
public subroutine selectitem (string arg_text)
public function string getcode ()
public function integer redraw ()
end prototypes

public function string text ();RETURN UPPER(THIS.TEXT)
end function

public subroutine selectitem (string arg_text);INT LVI_RETURN
LVI_RETURN = THIS.SELECTITEM( ARG_TEXT , 0 )

end subroutine

public function string getcode ();RETURN	THIS.TEXT

end function

public function integer redraw ();LONG I
STRING LVS_MODEL_NAME , LVS_MODEL_SUFFIX , LVS_ITEM_CODE  

DECLARE CUR_01 CURSOR FOR 
  SELECT DISTINCT MODEL_NAME	  
    FROM IP_PRODUCT_MODEL_MASTER
   WHERE MODEL_NAME <> '*'
	 AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID    
	 ;
	  
OPEN CUR_01 ;

THIS.RESET()
THIS.ADDITEM('%')

IF F_SQL_CHECK_WITH_MSG('OPEN FROM ID_ITEM') < 0 THEN 
	CLOSE CUR_01 ;
	RETURN 0
END IF	

DO 
	FETCH CUR_01 INTO :LVS_MODEL_NAME  ;
	
	IF F_SQL_CHECK_WITH_MSG('SELECT FROM ID_ITEM') < 0 THEN 
		CLOSE CUR_01 ;
		RETURN 0
	END IF	
	
	IF SQLCA.SQLCODE = 100 THEN 
		CLOSE CUR_01 ;		
		EXIT
	END IF 
	
	THIS.ADDITEM(LVS_MODEL_NAME)
I++
F_MSG_MDI_HELP('UO_MODEL_NAME : Construnctor-> '+STRING(I)+'Rows')  			
LOOP UNTIL 1 = 2

THIS.SELECTITEM( 1)





end function

on uo_model_name_ddlb.create
end on

on uo_model_name_ddlb.destroy
end on

event rbuttondown;//OPEN(w_des_set_item_popup  )
OPEN(w_des_model_master_popup)
if message.stringparm = '' then 
else
	this.text = MESSAGE.STRINGPARM //Gst_return.Gvs_return[9]
end if
end event

event modified;THIS.TEXT = UPPER(THIS.TEXT)

end event

event constructor;this.redraw( )
end event

