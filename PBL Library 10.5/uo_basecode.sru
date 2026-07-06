HA$PBExportHeader$uo_basecode.sru
$PBExportComments$$$HEX5$$f5acb5d154cfdcb42000$$ENDHEX$$DDLBMethod ~r~n( Getcode(return code), Getname(return name), Redraw(string parm organization_id) )
forward
global type uo_basecode from dropdownlistbox
end type
end forward

global type uo_basecode from dropdownlistbox
integer width = 731
integer height = 904
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type
global uo_basecode uo_basecode

type variables
string ivs_type
end variables

forward prototypes
public function string text ()
public function string getcode ()
public function string getname ()
public subroutine redraw (string arg_code_type)
public function integer selectitemno (integer arg_number)
public subroutine selectitem (string arg_text)
end prototypes

public function string text ();RETURN THIS.TEXT
end function

public function string getcode ();IF POS( THIS.TEXT , ':' )  > 0 THEN 
	RETURN TRIM(MID( THIS.TEXT ,  1, POS( THIS.TEXT , ':' ) -1 ))
ELSE
	RETURN  THIS.TEXT
END IF
end function

public function string getname ();RETURN TRIM(MID( THIS.TEXT ,  POS( THIS.TEXT , ':' ) +1 , len(this.text)  ))
end function

public subroutine redraw (string arg_code_type);STRING LVS_CODE_NAME , LVS_CODE_MEAN

ivs_type = arg_code_type 

DECLARE CUR_01 CURSOR FOR 
	SELECT CODE_NAME, 
	       DECODE(:gvs_language, 'C', CODE_MEAN_LOCAL, 'K', CODE_MEAN_KOR, CODE_MEAN_ENG) AS CODE_MEAN
  	  FROM ISYS_BASECODE
	 WHERE CODE_TYPE       = :arg_code_type
	   AND ORGANIZATION_ID = :gvi_organization_id;
		 
THIS.RESET()		 
OPEN CUR_01 ;

DO WHILE SQLCA.SQLCODE = 0 
	FETCH CUR_01 INTO :LVS_CODE_NAME , :LVS_CODE_MEAN ;

	IF F_SQL_CHECK_WITH_MSG('SELECT FROM ISYS_BASECODE') < 0 THEN 
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

public function integer selectitemno (integer arg_number);this.selectitem( arg_number)
return 0
end function

public subroutine selectitem (string arg_text);
INT LVI_RETURN
LVI_RETURN = THIS.SELECTITEM( ARG_TEXT , 0 )

end subroutine

on uo_basecode.create
end on

on uo_basecode.destroy
end on

event rbuttondown;Openwithparm(w_value_list_popup , ivs_type)
end event

