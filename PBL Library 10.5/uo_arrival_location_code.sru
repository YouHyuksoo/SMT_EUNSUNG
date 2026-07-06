HA$PBExportHeader$uo_arrival_location_code.sru
forward
global type uo_arrival_location_code from dropdownlistbox
end type
type st_vendor from structure within uo_arrival_location_code
end type
end forward

type st_vendor from structure
	string		vendor_name
	string		vendor_name_eng
end type

global type uo_arrival_location_code from dropdownlistbox
integer width = 521
integer height = 692
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean allowedit = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type
global uo_arrival_location_code uo_arrival_location_code

forward prototypes
public function string text ()
public subroutine settext (double arg_text)
public function string getcode ()
end prototypes

public function string text ();RETURN THIS.TEXT
end function

public subroutine settext (double arg_text);THIS.SELECTITEM(THIS.ADDITEM(STRING(ARG_TEXT)))

end subroutine

public function string getcode ();IF  POS( THIS.TEXT , ':' ) <= 0  THEN 
	RETURN	THIS.TEXT
ELSE
 
RETURN TRIM(MID( THIS.TEXT,  1, POS( THIS.TEXT , ':' ) -1 ))

END IF
end function

event constructor;STRING LVS_CODE_NAME , LVS_CODE_NAME_FULL

DECLARE CL1 CURSOR FOR
SELECT DISTINCT CODE_NAME , CODE_NAME||':'||DECODE(:GVS_LANGUAGE, 'K', CODE_MEAN_KOR, 'E', CODE_MEAN_ENG, CODE_MEAN_LOCAL)
 FROM ISYS_BASECODE
WHERE CODE_TYPE = 'ARRIVAL LOCATION CODE' 
   AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
	
 THIS.RESET()
 OPEN CL1;
 
 DO 
 FETCH CL1 INTO :LVS_CODE_NAME , :LVS_CODE_NAME_FULL;
 
 IF F_SQL_CHECK() < 0 THEN 
	 CLOSE CL1 ;
	 RETURN 
 END IF
 
 IF SQLCA.SQLCODE = 100 THEN 
	 CLOSE CL1 ;
	 EXIT
 END IF
 
 
      IF GVS_USE_HUB_WAREHOUSE = 'Y' THEN
	      THIS.ADDITEM( LVS_CODE_NAME_FULL ) 
	ELSE
		IF  LVS_CODE_NAME = 'INSIDE' THEN
		      THIS.ADDITEM( LVS_CODE_NAME_FULL ) 		
		END IF
	END IF
		
LOOP UNTIL 1 = 2

THIS.SELECTITEM(1)
end event

on uo_arrival_location_code.create
end on

on uo_arrival_location_code.destroy
end on

