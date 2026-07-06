HA$PBExportHeader$uo_table_name.sru
$PBExportComments$Workstage Code
forward
global type uo_table_name from dropdownlistbox
end type
end forward

global type uo_table_name from dropdownlistbox
integer width = 1157
integer height = 2320
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean allowedit = true
boolean autohscroll = true
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type
global uo_table_name uo_table_name

forward prototypes
public function string getcode ()
end prototypes

public function string getcode ();RETURN THIS.TEXT 
end function

event constructor;STRING LVS_TABLE_NAME

DECLARE CUR_01 CURSOR FOR 
	SELECT TABLE_NAME
  	  FROM USER_TABLES ;
		 
OPEN CUR_01 ;

DO WHILE SQLCA.SQLCODE = 0 
	FETCH CUR_01 INTO :LVS_TABLE_NAME ;
	IF F_SQL_CHECK_WITH_MSG('SELECT FROM USER_TABLES') < 0 THEN 
		CLOSE CUR_01 ;
		RETURN
	END IF	
	
	IF SQLCA.SQLCODE = 100 THEN 
		EXIT
	END IF 
	

	THIS.ADDITEM(LVS_TABLE_NAME)
LOOP
	THIS.ADDITEM('%')

CLOSE CUR_01 ;
end event

on uo_table_name.create
end on

on uo_table_name.destroy
end on

