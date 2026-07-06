HA$PBExportHeader$uo_workstage_code_all.sru
$PBExportComments$Line ddlb Object
forward
global type uo_workstage_code_all from dropdownlistbox
end type
end forward

global type uo_workstage_code_all from dropdownlistbox
integer width = 631
integer height = 832
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean autohscroll = true
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type
global uo_workstage_code_all uo_workstage_code_all

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

public function string getcode ();IF  POS( THIS.TEXT , ':' ) <= 0  THEN 
	RETURN	THIS.TEXT
ELSE
 
RETURN TRIM(MID( THIS.TEXT,  1, POS( THIS.TEXT , ':' ) -1 ))

END IF
end function

public function string getname ();RETURN TRIM(MID( THIS.TEXT ,  POS( THIS.TEXT , ':' ) +1 , 1  ))
end function

event constructor;//LONG I
//STRING LVS_LINE_CODE , LVS_LINE_NAME , LVS_LINE_CODE_CONDITION
//
//DECLARE CUR_01 CURSOR FOR 
//	SELECT LINE_CODE, LINE_NAME
//  	  FROM  IP_PRODUCT_LINE
//	 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
//	      AND LINE_CODE <> '*' ;
//	 
//OPEN CUR_01 ;
//
//THIS.RESET()
//THIS.ADDITEM('%')
//
//IF F_SQL_CHECK_WITH_MSG('OPEN FROM IP_PRODUCT_LINE') < 0 THEN 
//	CLOSE CUR_01 ;
//	RETURN
//END IF	
//
//DO 
//	FETCH CUR_01 INTO :LVS_LINE_CODE , :LVS_LINE_NAME ;
//	
//	IF F_SQL_CHECK_WITH_MSG('SELECT FROM IP_PRODUCT_LINE') < 0 THEN 
//		CLOSE CUR_01 ;
//		RETURN
//	END IF	
//	
//	IF SQLCA.SQLCODE = 100 THEN 
//		CLOSE CUR_01 ;		
//		EXIT
//	END IF 
//	
//	LVS_LINE_CODE = LVS_LINE_CODE + ' : ' + LVS_LINE_NAME
//	THIS.ADDITEM(LVS_LINE_CODE)
//I++
//F_MSG_MDI_HELP('UO_LINE_CODE : Construnctor-> '+STRING(I)+"Rows")  			
//LOOP UNTIL 1 = 2
// THIS.Selectitem( 1)
//
LONG I
STRING LVS_WORKSTAGE_CODE , LVS_WORKSTAGE_NAME , LVS_WORKSTAGE_CODE_CONDITION

DECLARE CUR_01 CURSOR FOR 
	SELECT WORKSTAGE_CODE, WORKSTAGE_NAME
  	  FROM IP_PRODUCT_WORKSTAGE
	 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID
	      AND NVL(WORKSTAGE_STATUS , '*') <> 'X'
		  AND WORKSTAGE_CODE <> '*' ;
	 
OPEN CUR_01 ;

THIS.RESET()
THIS.ADDITEM('%')

IF F_SQL_CHECK_WITH_MSG('OPEN FROM IP_PRODUCT_WORKSTAGE') < 0 THEN 
	CLOSE CUR_01 ;
	RETURN
END IF	

DO 
	FETCH CUR_01 INTO :LVS_WORKSTAGE_CODE , :LVS_WORKSTAGE_NAME ;
	
	IF F_SQL_CHECK_WITH_MSG('SELECT FROM IP_PRODUCT_WORKSTAGE') < 0 THEN 
		CLOSE CUR_01 ;
		RETURN
	END IF	
	
	IF SQLCA.SQLCODE = 100 THEN 
		CLOSE CUR_01 ;		
		EXIT
	END IF 
	
	LVS_WORKSTAGE_CODE = LVS_WORKSTAGE_CODE + ' : ' + LVS_WORKSTAGE_NAME
	THIS.ADDITEM(LVS_WORKSTAGE_CODE)
I++
F_MSG_MDI_HELP('UO_WORKSTAGE_CODE : Construnctor-> '+STRING(I)+"Rows")  			
LOOP UNTIL 1 = 2

THIS.selectitem(1)
 





end event

on uo_workstage_code_all.create
end on

on uo_workstage_code_all.destroy
end on

