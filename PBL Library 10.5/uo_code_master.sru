HA$PBExportHeader$uo_code_master.sru
$PBExportComments$$$HEX5$$f5acb5d154cfdcb42000$$ENDHEX$$DDLBMethod ~r~n( Getcode(return code), Getname(return name), Redraw(string parm organization_id) )
forward
global type uo_code_master from dropdownlistbox
end type
end forward

global type uo_code_master from dropdownlistbox
integer width = 731
integer height = 904
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type
global uo_code_master uo_code_master

type variables
String Ivs_type
end variables

forward prototypes
public function string text ()
public function string getcode ()
public function string getname ()
public subroutine redraw (string arg_code_type)
public function string gettype ()
end prototypes

public function string text ();RETURN THIS.TEXT
end function

public function string getcode ();IF  POS( THIS.TEXT , ':' ) = 0 OR ISNULL( POS( THIS.TEXT , ':' )) THEN
	RETURN THIS.TEXT
ELSE
	RETURN TRIM(MID( THIS.TEXT,  1, POS( THIS.TEXT , ':' ) -1 ))
END IF
end function

public function string getname ();RETURN TRIM(MID( THIS.TEXT ,  POS( THIS.TEXT , ':' ) +1 , 1  ))
end function

public subroutine redraw (string arg_code_type);STRING LVS_CODE_NAME , LVS_CODE_MEAN

Ivs_type = arg_code_type

DECLARE CUR_01 CURSOR FOR 
	SELECT CODE_NAME, DECODE(:gvs_language, 'C', CODE_MEAN_LOCAL, 'K', CODE_MEAN_KOR, CODE_MEAN_ENG) AS CODE_MEAN
  	  FROM ISYS_CODE_MASTER
	 WHERE CODE_TYPE       = :arg_code_type
	   AND ORGANIZATION_ID = :gvi_organization_id;
		 
THIS.RESET()		 
OPEN CUR_01 ;

DO WHILE SQLCA.SQLCODE = 0 
	FETCH CUR_01 INTO :LVS_CODE_NAME , :LVS_CODE_MEAN ;
	
	IF F_SQL_CHECK_WITH_MSG('SELECT FROM ISYS_CODE_MASTER') < 0 THEN 
		CLOSE CUR_01 ;
		RETURN
	END IF	
	
	IF SQLCA.SQLCODE = 100 THEN 
		EXIT
	END IF 
	
	LVS_CODE_NAME = LVS_CODE_NAME + ' : ' + LVS_CODE_MEAN
	THIS.ADDITEM(LVS_CODE_NAME)
LOOP

THIS.ADDITEM('%')

THIS.SELECTITEM(1)
CLOSE CUR_01 ;



end subroutine

public function string gettype ();Return Ivs_type
end function

on uo_code_master.create
end on

on uo_code_master.destroy
end on

event getfocus;//Modify Code Text
// this.redraw('code text'')
end event

event rbuttondown;openwithparm(w_standard_code_select_popup , ivs_type )

if gst_return.gvb_return = true then 
   this.text =message.stringparm
end if
end event

