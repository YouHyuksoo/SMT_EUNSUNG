HA$PBExportHeader$uo_line_code_lb.sru
$PBExportComments$Line Code List Box
forward
global type uo_line_code_lb from listbox
end type
end forward

global type uo_line_code_lb from listbox
integer width = 645
integer height = 476
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean hscrollbar = true
boolean vscrollbar = true
boolean multiselect = true
borderstyle borderstyle = stylelowered!
end type
global uo_line_code_lb uo_line_code_lb

on uo_line_code_lb.create
end on

on uo_line_code_lb.destroy
end on

event constructor;LONG I
STRING LVS_LINE_CODE , LVS_LINE_NAME , LVS_LINE_CODE_CONDITION


DECLARE CUR_01 CURSOR FOR 
	SELECT DISTINCT LINE_CODE
  	  FROM IB_LINE_MASTER
	 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
	 
OPEN CUR_01 ;

THIS.RESET()

IF F_SQL_CHECK_WITH_MSG('OPEN FROM IP_PRODUCT_LINE') < 0 THEN 
	CLOSE CUR_01 ;
	RETURN
END IF	

DO 
	FETCH CUR_01 INTO :LVS_LINE_CODE  ;
	
	IF F_SQL_CHECK_WITH_MSG('SELECT FROM IP_PRODUCT_LINE') < 0 THEN 
		CLOSE CUR_01 ;
		RETURN
	END IF	
	
	IF SQLCA.SQLCODE = 100 THEN 
		CLOSE CUR_01 ;		
		EXIT
	END IF 
	
	LVS_LINE_CODE = LVS_LINE_CODE 
	THIS.ADDITEM(LVS_LINE_CODE)
I++
F_MSG_MDI_HELP('UO_LINE_CODE : Construnctor-> '+STRING(I)+"Rows")  			
LOOP UNTIL 1 = 2
 





end event

