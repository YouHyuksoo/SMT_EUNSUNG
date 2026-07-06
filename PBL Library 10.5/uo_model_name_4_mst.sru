HA$PBExportHeader$uo_model_name_4_mst.sru
$PBExportComments$Item Code
forward
global type uo_model_name_4_mst from dropdownlistbox
end type
end forward

global type uo_model_name_4_mst from dropdownlistbox
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
global uo_model_name_4_mst uo_model_name_4_mst

forward prototypes
public function string text ()
public subroutine selectitem (string arg_text)
public function string getcode ()
public function string getname ()
end prototypes

public function string text ();RETURN THIS.TEXT
end function

public subroutine selectitem (string arg_text);INT LVI_RETURN
LVI_RETURN = THIS.SELECTITEM( ARG_TEXT , 0 )

end subroutine

public function string getcode ();IF  POS( THIS.TEXT , '@' ) <= 0  THEN 
	RETURN	THIS.TEXT
ELSE
 
RETURN TRIM(MID( THIS.TEXT,  1, POS( THIS.TEXT , '@' ) -1 ))

END IF
end function

public function string getname ();RETURN TRIM(MID( THIS.TEXT ,  POS( THIS.TEXT , ':' ) +1 , LEN(THIS.TEXT) -POS( THIS.TEXT , ':' )   ))
end function

on uo_model_name_4_mst.create
end on

on uo_model_name_4_mst.destroy
end on

event rbuttondown;OPEN(w_des_set_item_popup  )

if message.stringparm = '' then 
else
	this.text = Gst_return.Gvs_return[9]
end if
end event

event constructor;LONG I
STRING LVS_MODEL_NAME , LVS_ITEM_NAME  


DECLARE CUR_01 CURSOR FOR 
  SELECT DISTINCT "IP_PRODUCT_MODEL_MASTER"."MODEL_NAME"
    FROM "IP_PRODUCT_MODEL_MASTER"  
   WHERE "IP_PRODUCT_MODEL_MASTER"."ORGANIZATION_ID" = :GVI_ORGANIZATION_ID    
	  AND MODEL_NAME <> '*'
   GROUP BY MODEL_NAME ;
	 
OPEN CUR_01 ;

IF F_SQL_CHECK_WITH_MSG('OPEN FROM IP_PRODUCT_MODEL_MASTER') < 0 THEN 
	CLOSE CUR_01 ;
	RETURN
END IF	

THIS.RESET()
THIS.ADDITEM('%')

DO 
	FETCH CUR_01 INTO :LVS_MODEL_NAME ;
	IF F_SQL_CHECK_WITH_MSG('SELECT FROM IP_PRODUCT_WORKSTAGE') < 0 THEN 
		CLOSE CUR_01 ;
		RETURN
	END IF	
	
	IF SQLCA.SQLCODE = 100 THEN 
		CLOSE CUR_01 ;		
		EXIT
	END IF 
	
	THIS.ADDITEM(LVS_MODEL_NAME)
I++
F_MSG_MDI_HELP('UO_MODEL_NAME : Construnctor-> '+STRING(I)+"Rows")  			
LOOP UNTIL 1 = 2

THIS.SELECTITEM( 1)







end event

