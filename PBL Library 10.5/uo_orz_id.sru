HA$PBExportHeader$uo_orz_id.sru
$PBExportComments$Organization
forward
global type uo_orz_id from dropdownlistbox
end type
end forward

global type uo_orz_id from dropdownlistbox
integer width = 512
integer height = 784
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type
global uo_orz_id uo_orz_id

forward prototypes
public function string getcode ()
public function string getname ()
end prototypes

public function string getcode ();RETURN TRIM(MID( THIS.TEXT ,  1, POS( THIS.TEXT , ':' ) -1 ))
end function

public function string getname ();RETURN TRIM(MID( THIS.TEXT ,  POS( THIS.TEXT , ':' )+1  , LEN(THIS.TEXT) ))
end function

event constructor;STRING LS_ORZ_NAME, LS_ORZ_NAME_USER
LONG   LI_ORZ_ID

 DECLARE CUR_01 CURSOR FOR 
	SELECT ORGANIZATION_ID, ORGANIZATION_NAME
  	  FROM ISYS_ORGANIZATION;
		 
OPEN CUR_01 ;

DO WHILE SQLCA.SQLCODE = 0 
	FETCH CUR_01 INTO :LI_ORZ_ID, :LS_ORZ_NAME ;
	IF F_SQL_CHECK_WITH_MSG('SELECT FROM ISYS_ORGANIZATION') < 0 THEN 
		CLOSE CUR_01 ;
		RETURN
	END IF	
	
	IF SQLCA.SQLCODE = 100 THEN 
		EXIT
	END IF 
	
	LS_ORZ_NAME = STRING(LI_ORZ_ID) + ' : ' + LS_ORZ_NAME
	IF gvi_organization_id = LI_ORZ_ID THEN
		LS_ORZ_NAME_USER = LS_ORZ_NAME
   END IF
	
	THIS.ADDITEM(LS_ORZ_NAME)
LOOP
	THIS.ADDITEM('%')

THIS.SELECTITEM(LS_ORZ_NAME_USER,1)

CLOSE CUR_01 ;
end event

on uo_orz_id.create
end on

on uo_orz_id.destroy
end on

