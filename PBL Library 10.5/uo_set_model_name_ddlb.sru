HA$PBExportHeader$uo_set_model_name_ddlb.sru
$PBExportComments$Item Code
forward
global type uo_set_model_name_ddlb from dropdownlistbox
end type
end forward

global type uo_set_model_name_ddlb from dropdownlistbox
integer width = 809
integer height = 1608
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 65535
boolean allowedit = true
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type
global uo_set_model_name_ddlb uo_set_model_name_ddlb

forward prototypes
public function string text ()
public subroutine selectitem (string arg_text)
public function string getcode ()
public function string getname ()
public function string getitem ()
public subroutine redraw (string arg_model_name)
public subroutine redraw_customer (string arg_customer_code)
end prototypes

public function string text ();// RETURN UPPER(THIS.TEXT)

RETURN THIS.TEXT
end function

public subroutine selectitem (string arg_text);INT LVI_RETURN
LVI_RETURN = THIS.SELECTITEM( ARG_TEXT , 0 )

end subroutine

public function string getcode ();//IF  POS( upper(THIS.TEXT) , '@' ) <= 0  THEN 
//	RETURN	THIS.TEXT
//ELSE
// 
//	RETURN TRIM(MID( upper(THIS.TEXT),  1, POS( upper(THIS.TEXT) , '@' ) -1 ))
//
//END IF


IF  POS( THIS.TEXT , '@' ) <= 0  THEN 
	RETURN	THIS.TEXT
ELSE
 
	RETURN TRIM(MID( THIS.TEXT,  1, POS( THIS.TEXT , '@' ) -1 ))

END IF
end function

public function string getname ();// RETURN TRIM(MID( upper(THIS.TEXT) ,  POS( upper(THIS.TEXT ) , ':' ) +1 , LEN(upper(THIS.TEXT)) -POS( upper(THIS.TEXT) , ':' )   ))// 

RETURN TRIM(MID( THIS.TEXT ,  POS( THIS.TEXT  , ':' ) +1 , LEN(THIS.TEXT) -POS( THIS.TEXT , ':' )   ))
end function

public function string getitem ();//INT LVI_POS 
//LVI_POS = POS( upper(THIS.TEXT) , ':' )
//
//IF LVI_POS <= 0  THEN 
//	RETURN	upper(THIS.TEXT)
//ELSE
//
//	RETURN TRIM(MID( upper(THIS.TEXT),  LVI_POS +1 , 100  ))
//
//END IF

INT LVI_POS 

LVI_POS = POS( THIS.TEXT , ':' )

IF LVI_POS <= 0  THEN 
	RETURN	THIS.TEXT
ELSE

	RETURN TRIM(MID( THIS.TEXT,  LVI_POS +1 , 100  ))

END IF
end function

public subroutine redraw (string arg_model_name);LONG I
STRING LVS_MODEL_NAME , LVS_MODEL_SUFFIX , LVS_ITEM_CODE  


DECLARE CUR_01 CURSOR FOR 
  SELECT MODEL_NAME,   
  			NVL(MODEL_SUFFIX , '*') ,
              ITEM_CODE 
     FROM IP_PRODUCT_MODEL_MASTER  
   WHERE MODEL_NAME LIKE :arg_model_name||'%'
	  AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID    
 GROUP BY ITEM_CODE  , MODEL_NAME , NVL(MODEL_SUFFIX , '*') ;	
	
	
OPEN CUR_01 ;

THIS.RESET()
THIS.ADDITEM('%')

IF F_SQL_CHECK_WITH_MSG('OPEN FROM ID_ITEM') < 0 THEN 
	CLOSE CUR_01 ;
	RETURN
END IF	

DO 
	FETCH CUR_01 INTO :LVS_MODEL_NAME , :LVS_MODEL_SUFFIX , :LVS_ITEM_CODE    ;
	
	IF F_SQL_CHECK_WITH_MSG('SELECT FROM ID_ITEM') < 0 THEN 
		CLOSE CUR_01 ;
		RETURN
	END IF	
	
	IF SQLCA.SQLCODE = 100 THEN 
		CLOSE CUR_01 ;		
		EXIT
	END IF 
	
	LVS_MODEL_NAME = LVS_MODEL_NAME + '@'+LVS_MODEL_SUFFIX+':'+ LVS_ITEM_CODE
	THIS.ADDITEM(LVS_MODEL_NAME)
I++
F_MSG_MDI_HELP('UO_MODEL_NAME : Construnctor-> '+STRING(I)+"Rows")  			
LOOP UNTIL 1 = 2

THIS.SELECTITEM( 1)





end subroutine

public subroutine redraw_customer (string arg_customer_code);LONG I
STRING LVS_MODEL_NAME , LVS_MODEL_SUFFIX , LVS_ITEM_CODE  

DECLARE CUR_01 CURSOR FOR 
  SELECT MODEL_NAME,   
  			NVL(MODEL_SUFFIX , '*') ,
              ITEM_CODE 
     FROM IP_PRODUCT_MODEL_MASTER  
   WHERE  ORGANIZATION_ID = :GVI_ORGANIZATION_ID    
	  AND CUSTOMER_CODE LIKE :ARG_CUSTOMER_CODE||'%'
 GROUP BY ITEM_CODE  , MODEL_NAME , NVL(MODEL_SUFFIX , '*') ;

	 
OPEN CUR_01 ;

THIS.RESET()
THIS.ADDITEM('%')

IF F_SQL_CHECK_WITH_MSG('OPEN FROM ID_ITEM') < 0 THEN 
	CLOSE CUR_01 ;
	RETURN
END IF	

DO 
	FETCH CUR_01 INTO :LVS_MODEL_NAME , :LVS_MODEL_SUFFIX , :LVS_ITEM_CODE    ;
	
	IF F_SQL_CHECK_WITH_MSG('SELECT FROM ID_ITEM') < 0 THEN 
		CLOSE CUR_01 ;
		RETURN
	END IF	
	
	IF SQLCA.SQLCODE = 100 THEN 
		CLOSE CUR_01 ;		
		EXIT
	END IF 
	
	LVS_MODEL_NAME = LVS_MODEL_NAME + '@'+LVS_MODEL_SUFFIX+':'+ LVS_ITEM_CODE
	THIS.ADDITEM(LVS_MODEL_NAME)
I++
F_MSG_MDI_HELP('UO_MODEL_NAME : Construnctor-> '+STRING(I)+"Rows")  			
LOOP UNTIL 1 = 2

THIS.SELECTITEM( 1)





end subroutine

on uo_set_model_name_ddlb.create
end on

on uo_set_model_name_ddlb.destroy
end on

event rbuttondown;OPEN(w_des_set_item_popup  )

if message.stringparm = '' then 
else
	this.text = Gst_return.Gvs_return[9]
end if
end event

event modified;// THIS.TEXT = UPPER(THIS.TEXT)

THIS.TEXT = THIS.TEXT

end event

event constructor;THIS.REdraw( '%' )
end event

