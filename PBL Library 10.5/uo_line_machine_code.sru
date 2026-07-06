HA$PBExportHeader$uo_line_machine_code.sru
$PBExportComments$Line ddlb Object
forward
global type uo_line_machine_code from dropdownlistbox
end type
end forward

global type uo_line_machine_code from dropdownlistbox
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
global uo_line_machine_code uo_line_machine_code

forward prototypes
public function string text ()
public subroutine selectitem (string arg_text)
public subroutine redraw ()
public function string getmachine ()
public function string getline ()
end prototypes

public function string text ();RETURN THIS.TEXT
end function

public subroutine selectitem (string arg_text);INT LVI_RETURN
LVI_RETURN = THIS.SELECTITEM( ARG_TEXT , 0 )

end subroutine

public subroutine redraw ();LONG I
STRING LVS_LINE_CODE , LVS_MACHINE 

DECLARE CUR_01 CURSOR FOR 
	SELECT LINE_CODE, MACHINE
  	  FROM IB_LINE_MASTER
	 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
	 
OPEN CUR_01 ;

THIS.RESET()
THIS.ADDITEM('%')

IF F_SQL_CHECK_WITH_MSG('OPEN FROM LINE CODE') < 0 THEN 
	CLOSE CUR_01 ;

END IF	

DO 
	FETCH CUR_01 INTO :LVS_LINE_CODE , :LVS_MACHINE ;
	
	IF F_SQL_CHECK_WITH_MSG('SELECT FROM LINE CODE') < 0 THEN 
		CLOSE CUR_01 ;

	END IF	
	
	IF SQLCA.SQLCODE = 100 THEN 
		CLOSE CUR_01 ;		
		EXIT
	END IF 
	
	LVS_LINE_CODE = LVS_LINE_CODE + ' : ' + LVS_MACHINE
	THIS.ADDITEM(LVS_LINE_CODE)
I++
F_MSG_MDI_HELP('UO_LINE_MACHINE_CODE : Construnctor-> '+STRING(I)+"Rows")  			
LOOP UNTIL 1 = 2






end subroutine

public function string getmachine ();RETURN TRIM(MID( THIS.TEXT ,  POS( THIS.TEXT , ':' ) +1 , len(this.text)) )
end function

public function string getline ();IF  POS( THIS.TEXT , ':' ) <= 0  THEN 
	RETURN	THIS.TEXT
ELSE
 
RETURN TRIM(MID( THIS.TEXT,  1, POS( THIS.TEXT , ':' ) -1 ))

END IF
end function

event constructor;LONG I
STRING LVS_LINE_CODE , LVS_MACHINE

DECLARE CUR_01 CURSOR FOR 
	SELECT LINE_CODE, MACHINE
  	  FROM IB_LINE_MASTER
	 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID
	     AND MACHINE <> '*' ;
	 
OPEN CUR_01 ;

THIS.RESET()
THIS.ADDITEM('%')

IF F_SQL_CHECK_WITH_MSG('OPEN FROM LINE CODE') < 0 THEN 
	CLOSE CUR_01 ;
	RETURN
END IF	

DO 
	FETCH CUR_01 INTO :LVS_LINE_CODE , :LVS_MACHINE ;
	
	IF F_SQL_CHECK_WITH_MSG('SELECT FROM LINE CODE') < 0 THEN 
		CLOSE CUR_01 ;
		RETURN
	END IF	
	
	IF SQLCA.SQLCODE = 100 THEN 
		CLOSE CUR_01 ;		
		EXIT
	END IF 
	
	LVS_LINE_CODE = LVS_LINE_CODE + ' : ' + LVS_MACHINE
	THIS.ADDITEM(LVS_LINE_CODE)
I++
F_MSG_MDI_HELP('UO_LINE_CODE : Construnctor-> '+STRING(I)+"Rows")  			
LOOP UNTIL 1 = 2
 





end event

on uo_line_machine_code.create
end on

on uo_line_machine_code.destroy
end on

