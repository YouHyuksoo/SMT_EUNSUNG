HA$PBExportHeader$uo_workstage_code_mcnmachine_by_line.sru
$PBExportComments$workstage ( IMCN_MACHINE $$HEX3$$30ae00c92000$$ENDHEX$$LINE $$HEX2$$30ae00c9$$ENDHEX$$)
forward
global type uo_workstage_code_mcnmachine_by_line from dropdownlistbox
end type
end forward

global type uo_workstage_code_mcnmachine_by_line from dropdownlistbox
integer width = 631
integer height = 832
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type
global uo_workstage_code_mcnmachine_by_line uo_workstage_code_mcnmachine_by_line

forward prototypes
public function string text ()
public subroutine selectitem (string arg_text)
public function string getcode ()
public function string getname ()
public subroutine redraw (string arg_line_code)
end prototypes

public function string text ();RETURN THIS.TEXT
end function

public subroutine selectitem (string arg_text);
INT LVI_RETURN
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

public subroutine redraw (string arg_line_code);LONG I
STRING LVS_WORKSTAGE_CODE , LVS_WORKSTAGE_NAME , LVS_WORKSTAGE_CODE_CONDITION

DECLARE CUR_01 CURSOR FOR 
	 select  distinct workstage_code ,f_get_workstage_name( workstage_code ) workstage_name 
		from imcn_machine 
	WHERE  LINE_CODE LIKE :arg_line_code
	     AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
	 
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
	
	LVS_WORKSTAGE_CODE = LVS_WORKSTAGE_CODE + ':' + LVS_WORKSTAGE_NAME
	THIS.ADDITEM(LVS_WORKSTAGE_CODE)
I++
F_MSG_MDI_HELP('UO_WORKSTAGE_CODE : Construnctor-> '+STRING(I)+"Rows")  			
LOOP UNTIL 1 = 2
 
THIS.SELECTITEM(1)




end subroutine

on uo_workstage_code_mcnmachine_by_line.create
end on

on uo_workstage_code_mcnmachine_by_line.destroy
end on

event constructor;LONG I
STRING LVS_WORKSTAGE_CODE , LVS_WORKSTAGE_NAME , LVS_WORKSTAGE_CODE_CONDITION

DECLARE CUR_01 CURSOR FOR 
	 select  distinct workstage_code ,f_get_workstage_name( workstage_code ) workstage_name 
		from imcn_machine 
	WHERE  LINE_CODE LIKE '%'
	     AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
	 
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
	
	LVS_WORKSTAGE_CODE = LVS_WORKSTAGE_CODE + ':' + LVS_WORKSTAGE_NAME
	THIS.ADDITEM(LVS_WORKSTAGE_CODE)
I++
F_MSG_MDI_HELP('UO_WORKSTAGE_CODE : Construnctor-> '+STRING(I)+"Rows")  			
LOOP UNTIL 1 = 2
 
THIS.SELECTITEM(1)




end event

