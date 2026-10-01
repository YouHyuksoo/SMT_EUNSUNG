HA$PBExportHeader$uo_smt_model_name_dynamic.sru
$PBExportComments$Item Code
forward
global type uo_smt_model_name_dynamic from dropdownlistbox
end type
end forward

global type uo_smt_model_name_dynamic from dropdownlistbox
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
event ue_entertotab pbm_dwnprocessenter
end type
global uo_smt_model_name_dynamic uo_smt_model_name_dynamic

forward prototypes
public function string text ()
public subroutine selectitem (string arg_text)
public function string getcode ()
public function string getname ()
public subroutine redraw (string arg_model)
end prototypes

public function string text ();// RETURN UPPER(THIS.TEXT)

RETURN THIS.TEXT
end function

public subroutine selectitem (string arg_text);INT LVI_RETURN
LVI_RETURN = THIS.SELECTITEM( ARG_TEXT , 0 )

end subroutine

public function string getcode ();RETURN	THIS.TEXT

end function

public function string getname ();RETURN TRIM(MID( upper(THIS.TEXT) ,  POS( upper(THIS.TEXT ) , ':' ) +1 , LEN(upper(THIS.TEXT)) -POS( upper(THIS.TEXT) , ':' )   ))
end function

public subroutine redraw (string arg_model);LONG I
STRING LVS_TEXT , LVS_MODEL_NAME 
LVS_TEXT = arg_model

DECLARE CUR_01 CURSOR FOR 

//  SELECT DISTINCT MODEL_NAME
//    FROM ID_ITEM  
//   WHERE MODEL_NAME  LIKE :LVS_TEXT||'%'  
//	   AND ID_ITEM.ORGANIZATION_ID = :GVI_ORGANIZATION_ID    
//	  AND MODEL_NAME <> '*'
//	  AND ITEM_DIVISION = 'F'
//	  AND SET_ITEM_YN = 'Y'
//	  AND DATEEND >= TRUNC(SYSDATE) 
//	UNION 
 SELECT DISTINCT NVL( SMT_MODEL_NAME , MODEL_NAME ) 
    FROM IP_PRODUCT_MODEL_MASTER  
   WHERE SMT_MODEL_NAME  LIKE :LVS_TEXT||'%' 
	   AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID	
	    AND DATEEND >= TRUNC(SYSDATE) ;


OPEN CUR_01 ;

THIS.RESET()

IF F_SQL_CHECK_WITH_MSG('OPEN FROM ID_ITEM') < 0 THEN 
	CLOSE CUR_01 ;
END IF	

DO 
	FETCH CUR_01 INTO :LVS_MODEL_NAME ;
	
	IF F_SQL_CHECK_WITH_MSG('SELECT FROM ID_ITEM') < 0 THEN 
		CLOSE CUR_01 ;
	END IF	
	
	IF SQLCA.SQLCODE = 100 THEN 
		CLOSE CUR_01 ;		
		EXIT
	END IF 
	
	LVS_MODEL_NAME = LVS_MODEL_NAME 
	THIS.ADDITEM(LVS_MODEL_NAME)
I++
F_MSG_MDI_HELP('UO_SMT_MODEL_NAME_DYNAMIC : Construnctor-> '+STRING(I)+"Rows")  			
LOOP UNTIL 1 = 2

THIS.SELECTITEM( 1)





end subroutine

event constructor;//LONG I
//STRING LVS_MODEL_NAME , LVS_MODEL_SUFFIX , LVS_ITEM_CODE  
//
//
//DECLARE CUR_01 CURSOR FOR 
//  SELECT "ID_ITEM"."MODEL_NAME",   "ID_ITEM"."MODEL_SUFFIX",
//              "ID_ITEM"."ITEM_CODE" 
//				  
//    FROM "ID_ITEM"  
//   WHERE "ID_ITEM"."ORGANIZATION_ID" = :GVI_ORGANIZATION_ID    
//	  AND MODEL_NAME <> '*'
//	  AND ITEM_DIVISION = 'F'
//	  AND SET_ITEM_YN = 'Y';
//
//	 
//OPEN CUR_01 ;
//
//THIS.RESET()
//THIS.ADDITEM('%')
//
//IF F_SQL_CHECK_WITH_MSG('OPEN FROM ID_ITEM') < 0 THEN 
//	CLOSE CUR_01 ;
//	RETURN
//END IF	
//
//DO 
//	FETCH CUR_01 INTO :LVS_MODEL_NAME , :LVS_MODEL_SUFFIX , :LVS_ITEM_CODE    ;
//	
//	IF F_SQL_CHECK_WITH_MSG('SELECT FROM IP_PRODUCT_WORKSTAGE') < 0 THEN 
//		CLOSE CUR_01 ;
//		RETURN
//	END IF	
//	
//	IF SQLCA.SQLCODE = 100 THEN 
//		CLOSE CUR_01 ;		
//		EXIT
//	END IF 
//	
//	LVS_MODEL_NAME = LVS_MODEL_NAME + '.'+LVS_MODEL_SUFFIX+':'+ LVS_ITEM_CODE
//	THIS.ADDITEM(LVS_MODEL_NAME)
//I++
//F_MSG_MDI_HELP('UO_MODEL_NAME : Construnctor-> '+STRING(I)+"Rows")  			
//LOOP UNTIL 1 = 2
//
//THIS.SELECTITEM( 1)
//
//
//
//
//
end event

on uo_smt_model_name_dynamic.create
end on

on uo_smt_model_name_dynamic.destroy
end on

event rbuttondown;OPEN(w_des_set_item_popup  )

if message.stringparm = '' then 
else
	this.text = Gst_return.Gvs_return[9]
end if
end event

