HA$PBExportHeader$uo_route_code.sru
$PBExportComments$Line ddlb Object
forward
global type uo_route_code from dropdownlistbox
end type
end forward

global type uo_route_code from dropdownlistbox
integer width = 631
integer height = 832
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type
global uo_route_code uo_route_code

forward prototypes
public function string text ()
public subroutine selectitem (string arg_text)
public function string getcode ()
public function string getname ()
public subroutine redraw ()
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

public subroutine redraw ();LONG I
STRING LVS_ROUTE_CODE , LVS_ROUTE_NAME 


DECLARE CUR_01 CURSOR FOR 
	SELECT ROUTE_NO, ROUTE_NAME
  	  FROM IP_PRODUCT_ROUTING_MASTER
	 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
	 
OPEN CUR_01 ;

THIS.RESET()
THIS.ADDITEM('%')

IF F_SQL_CHECK_WITH_MSG('OPEN FROM IP_PRODUCT_LINE') < 0 THEN 
	CLOSE CUR_01 ;

END IF	

DO 
	FETCH CUR_01 INTO :LVS_ROUTE_CODE , :LVS_ROUTE_NAME ;
	
	IF F_SQL_CHECK_WITH_MSG('SELECT FROM IP_PRODUCT_LINE') < 0 THEN 
		CLOSE CUR_01 ;

	END IF	
	
	IF SQLCA.SQLCODE = 100 THEN 
		CLOSE CUR_01 ;		
		EXIT
	END IF 
	
	LVS_ROUTE_CODE = LVS_ROUTE_CODE + ' : ' + LVS_ROUTE_NAME
	THIS.ADDITEM(LVS_ROUTE_CODE)
I++
F_MSG_MDI_HELP('UO_ROUTE_CODE : Construnctor-> '+STRING(I)+"Rows")  			
LOOP UNTIL 1 = 2






end subroutine

event constructor;LONG I
STRING LVS_ROUTE_CODE , LVS_ROUTE_NAME , LVS_ROUTE_CODE_CONDITION

IF  POS( THIS.TEXT , ':' ) <= 0  THEN 
	LVS_ROUTE_CODE_CONDITION =	THIS.TEXT
ELSE
 
LVS_ROUTE_CODE_CONDITION = TRIM(MID( THIS.TEXT,  1, POS( THIS.TEXT , ':' ) -1 ))

END IF

IF THIS.TEXT = '%' THEN RETURN

DECLARE CUR_01 CURSOR FOR 
	SELECT ROUTE_NO, ROUTE_NAME
  	  FROM IP_PRODUCT_ROUTING_MASTER
	 WHERE ROUTE_NO LIKE :LVS_ROUTE_CODE_CONDITION||'%'
	      AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
	 
OPEN CUR_01 ;

THIS.RESET()
THIS.ADDITEM('%')

IF F_SQL_CHECK_WITH_MSG('OPEN FROM IP_PRODUCT_LINE') < 0 THEN 
	CLOSE CUR_01 ;
	RETURN
END IF	

DO 
	FETCH CUR_01 INTO :LVS_ROUTE_CODE , :LVS_ROUTE_NAME ;
	
	IF F_SQL_CHECK_WITH_MSG('SELECT FROM IP_PRODUCT_LINE') < 0 THEN 
		CLOSE CUR_01 ;
		RETURN
	END IF	
	
	IF SQLCA.SQLCODE = 100 THEN 
		CLOSE CUR_01 ;		
		EXIT
	END IF 
	
	LVS_ROUTE_CODE = LVS_ROUTE_CODE + ' : ' + LVS_ROUTE_NAME
	THIS.ADDITEM(LVS_ROUTE_CODE)
I++
F_MSG_MDI_HELP('UO_ROUTE_CODE : Construnctor-> '+STRING(I)+"Rows")  			
LOOP UNTIL 1 = 2
 





end event

on uo_route_code.create
end on

on uo_route_code.destroy
end on

