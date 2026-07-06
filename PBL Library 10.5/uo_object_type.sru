HA$PBExportHeader$uo_object_type.sru
$PBExportComments$Object Type
forward
global type uo_object_type from dropdownlistbox
end type
end forward

global type uo_object_type from dropdownlistbox
integer width = 722
integer height = 800
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type
global uo_object_type uo_object_type

forward prototypes
public function string getcode ()
end prototypes

public function string getcode ();RETURN THIS.TEXT 
end function

event constructor;STRING LVS_OBJECT_TYPE

DECLARE CUR_01 CURSOR FOR 
	SELECT OBJECT_TYPE
  	  FROM ISYS_OBJECT
   GROUP BY OBJECT_TYPE		 ;
		 
OPEN CUR_01 ;

DO WHILE SQLCA.SQLCODE = 0 
	FETCH CUR_01 INTO :LVS_OBJECT_TYPE ;
	
	IF F_SQL_CHECK_WITH_MSG('SELECT FROM ISYS_OBJECT') < 0 THEN 
		CLOSE CUR_01 ;
		RETURN
	END IF	
	
	IF SQLCA.SQLCODE = 100 THEN 
		EXIT
	END IF 
	

	THIS.ADDITEM(LVS_OBJECT_TYPE)
LOOP
	THIS.ADDITEM('%')
	THIS.SELECTITEM(1)
CLOSE CUR_01 ;
end event

on uo_object_type.create
end on

on uo_object_type.destroy
end on

