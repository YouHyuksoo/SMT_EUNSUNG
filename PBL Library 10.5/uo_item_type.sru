HA$PBExportHeader$uo_item_type.sru
$PBExportComments$Item Type
forward
global type uo_item_type from dropdownlistbox
end type
end forward

global type uo_item_type from dropdownlistbox
integer width = 731
integer height = 904
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "Help!"
long textcolor = 33554432
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type
global uo_item_type uo_item_type

forward prototypes
public function string text ()
public function string getcode ()
public function string getname ()
public subroutine setcode (string arg_code)
end prototypes

public function string text ();RETURN THIS.TEXT
end function

public function string getcode ();RETURN TRIM(MID( THIS.TEXT,  1, POS( THIS.TEXT , ':' ) -1 ))
end function

public function string getname ();RETURN TRIM(MID( THIS.TEXT ,  POS( THIS.TEXT , ':' ) +1 , 1  ))
end function

public subroutine setcode (string arg_code);THIS.TEXT = ARG_CODE
end subroutine

on uo_item_type.create
end on

on uo_item_type.destroy
end on

event constructor;STRING LVS_CODE_NAME , LVS_CODE_MEAN

DECLARE CUR_01 CURSOR FOR 
	SELECT CODE_NAME , DECODE( :GVS_LANGUAGE , 'K' , CODE_MEAN_KOR , 'E' , CODE_MEAN_ENG , CODE_MEAN_LOCAL ) CODE_MEAN
  	  FROM ISYS_BASECODE	 
	 WHERE CODE_TYPE = 'ITEM TYPE'
	      AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
		 
OPEN CUR_01 ;

DO WHILE SQLCA.SQLCODE = 0 
	FETCH CUR_01 INTO :LVS_CODE_NAME , :LVS_CODE_MEAN ;
	IF SQLCA.SQLCODE = 100 THEN 
		EXIT
	ELSEIF SQLCA.SQLCODE < 0 THEN 
		MESSAGEBOX('CONFIRM','ITEM Type Code FETCH ERROR!!')
		RETURN
	END IF 
	
	LVS_CODE_NAME = LVS_CODE_NAME + ' : ' + LVS_CODE_MEAN
	THIS.ADDITEM(LVS_CODE_NAME)
LOOP

THIS.ADDITEM('%')

THIS.SELECTITEM(1)
CLOSE CUR_01 ;



end event

