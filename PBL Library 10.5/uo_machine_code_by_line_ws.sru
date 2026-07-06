HA$PBExportHeader$uo_machine_code_by_line_ws.sru
$PBExportComments$Line ddlb Object
forward
global type uo_machine_code_by_line_ws from dropdownlistbox
end type
end forward

global type uo_machine_code_by_line_ws from dropdownlistbox
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
global uo_machine_code_by_line_ws uo_machine_code_by_line_ws

forward prototypes
public function string text ()
public subroutine selectitem (string arg_text)
public function string getcode ()
public function string getname ()
public subroutine redraw (string arg_line_code, string arg_workstage_code)
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

public subroutine redraw (string arg_line_code, string arg_workstage_code);LONG I
STRING LVS_MACHINE_CODE , LVS_MACHINE_NAME 

THIS.RESET()

//IF arg_line_code = '%' THEN 
//	THIS.ADDITEM('%')
//	THIS.SELectitem(1)
//	RETURN
//ELSE
	
DECLARE CUR_01 CURSOR FOR 
  SELECT distinct 
             
		     IMCN_MACHINE.MACHINE_CODE,   
              IMCN_MACHINE.MACHINE_NAME
    FROM IMCN_MACHINE  
  WHERE IMCN_MACHINE.LINE_CODE like :ARG_LINE_CODE
       AND IMCN_MACHINE.WORKSTAGE_CODE like :arg_workstage_code 
       AND IMCN_MACHINE.ORGANIZATION_ID = :GVI_ORGANIZATION_ID    ;

	 
OPEN CUR_01 ;

THIS.RESET()
THIS.ADDITEM('%')

IF F_SQL_CHECK_WITH_MSG('OPEN FROM IP_PRODUCT_WORKSTAGE') < 0 THEN 
	CLOSE CUR_01 ;
	RETURN
END IF	

DO 
	FETCH CUR_01 INTO :LVS_MACHINE_CODE , :LVS_MACHINE_NAME ;
	
	IF F_SQL_CHECK_WITH_MSG('SELECT FROM IP_PRODUCT_WORKSTAGE') < 0 THEN 
		CLOSE CUR_01 ;
		RETURN
	END IF	
	
	IF SQLCA.SQLCODE = 100 THEN 
		CLOSE CUR_01 ;		
		EXIT
	END IF 
	
	LVS_MACHINE_CODE = LVS_MACHINE_CODE + ' : ' + LVS_MACHINE_NAME
	THIS.ADDITEM(LVS_MACHINE_CODE)
I++
F_MSG_MDI_HELP('UO_MACHINE_CODE : Construnctor-> '+STRING(I)+'Rows')  			
LOOP UNTIL 1 = 2






end subroutine

on uo_machine_code_by_line_ws.create
end on

on uo_machine_code_by_line_ws.destroy
end on

event constructor;LONG I
STRING LVS_MACHINE_CODE , LVS_MACHINE_NAME 

THIS.RESET()

DECLARE CUR_01 CURSOR FOR 
  SELECT distinct 
              IMCN_MACHINE.MACHINE_CODE,   
              IMCN_MACHINE.MACHINE_NAME
    FROM IMCN_MACHINE  
  WHERE IMCN_MACHINE.LINE_CODE like '%'
       AND IMCN_MACHINE.WORKSTAGE_CODE like '%' 
       AND IMCN_MACHINE.ORGANIZATION_ID = :GVI_ORGANIZATION_ID    ;

	 
OPEN CUR_01 ;

THIS.RESET()
THIS.ADDITEM('%')

IF F_SQL_CHECK_WITH_MSG('OPEN FROM IP_PRODUCT_WORKSTAGE') < 0 THEN 
	CLOSE CUR_01 ;
	RETURN
END IF	

DO 
	FETCH CUR_01 INTO :LVS_MACHINE_CODE , :LVS_MACHINE_NAME ;
	
	IF F_SQL_CHECK_WITH_MSG('SELECT FROM IP_PRODUCT_WORKSTAGE') < 0 THEN 
		CLOSE CUR_01 ;
		RETURN
	END IF	
	
	IF SQLCA.SQLCODE = 100 THEN 
		CLOSE CUR_01 ;		
		EXIT
	END IF 
	
	LVS_MACHINE_CODE = LVS_MACHINE_CODE + ' : ' + LVS_MACHINE_NAME
	THIS.ADDITEM(LVS_MACHINE_CODE)
I++
F_MSG_MDI_HELP('UO_MACHINE_CODE : Construnctor-> '+STRING(I)+'Rows')  			
LOOP UNTIL 1 = 2





end event

