HA$PBExportHeader$uo_role_code.sru
forward
global type uo_role_code from userobject
end type
type pb_1 from so_picturebutton within uo_role_code
end type
type st_2 from statictext within uo_role_code
end type
type st_1 from statictext within uo_role_code
end type
type sle_role_name from singlelineedit within uo_role_code
end type
type ddlb_role_code from dropdownlistbox within uo_role_code
end type
end forward

global type uo_role_code from userobject
integer width = 1111
integer height = 160
long backcolor = 12632256
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
pb_1 pb_1
st_2 st_2
st_1 st_1
sle_role_name sle_role_name
ddlb_role_code ddlb_role_code
end type
global uo_role_code uo_role_code

forward prototypes
public function string text ()
public function string getname ()
public function string getcode ()
public subroutine redraw ()
end prototypes

public function string text ();RETURN DDLB_ROLE_CODE.TEXT
end function

public function string getname ();RETURN SLE_ROLE_NAME.TEXT
end function

public function string getcode ();RETURN DDLB_ROLE_CODE.TEXT
end function

public subroutine redraw ();STRING LS_ROLE_CODE, LS_ROLE_NAME 

ddlb_role_code.RESET()
SLE_ROLE_NAME.TEXT = ''

DECLARE CUR_01 CURSOR FOR 
	SELECT DISTINCT ROLE_CODE
  	  FROM ISYS_ROLE
	 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;

ddlb_role_code.ADDITEM('%')

OPEN CUR_01 ;

DO WHILE SQLCA.SQLCODE = 0 
	FETCH CUR_01 INTO :LS_ROLE_CODE ;
	
	IF F_SQL_CHECK_WITH_MSG('SELECT FROM ISYS_ORGANIZATION') < 0 THEN 
		CLOSE CUR_01 ;
	END IF	
	
	IF SQLCA.SQLCODE = 100 THEN 
		EXIT
	END IF 
	
	ddlb_role_code.ADDITEM(LS_ROLE_CODE)
LOOP

ddlb_role_code.SELECTITEM(1)

CLOSE CUR_01 ;
end subroutine

on uo_role_code.create
this.pb_1=create pb_1
this.st_2=create st_2
this.st_1=create st_1
this.sle_role_name=create sle_role_name
this.ddlb_role_code=create ddlb_role_code
this.Control[]={this.pb_1,&
this.st_2,&
this.st_1,&
this.sle_role_name,&
this.ddlb_role_code}
end on

on uo_role_code.destroy
destroy(this.pb_1)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.sle_role_name)
destroy(this.ddlb_role_code)
end on

type pb_1 from so_picturebutton within uo_role_code
integer x = 503
integer y = 60
integer width = 101
integer height = 88
integer taborder = 30
string picturename = "Continue!"
boolean map3dcolors = true
end type

event clicked;call super::clicked;parent.redraw()
end event

type st_2 from statictext within uo_role_code
integer x = 603
integer width = 503
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
string text = "Role Name"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within uo_role_code
integer width = 503
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
string text = "Role Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_role_name from singlelineedit within uo_role_code
integer x = 603
integer y = 64
integer width = 503
integer height = 84
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type ddlb_role_code from dropdownlistbox within uo_role_code
integer y = 64
integer width = 503
integer height = 788
integer taborder = 10
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

event constructor;STRING LS_ROLE_CODE, LS_ROLE_NAME 

ddlb_role_code.RESET()
SLE_ROLE_NAME.TEXT = ''

DECLARE CUR_01 CURSOR FOR 
	SELECT DISTINCT ROLE_CODE
  	  FROM ISYS_ROLE
	 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;

THIS.ADDITEM('%')

OPEN CUR_01 ;

DO WHILE SQLCA.SQLCODE = 0 
	FETCH CUR_01 INTO :LS_ROLE_CODE ;
	
	IF F_SQL_CHECK_WITH_MSG('SELECT FROM ISYS_ORGANIZATION') < 0 THEN 
		CLOSE CUR_01 ;
	END IF	
	
	IF SQLCA.SQLCODE = 100 THEN 
		EXIT
	END IF 
	
	THIS.ADDITEM(LS_ROLE_CODE)
LOOP

ddlb_role_code.SELECTITEM(1)

CLOSE CUR_01 ;
end event

event selectionchanged;select distinct role_name into :message.stringparm
from ISYS_ROLE
where role_code = :this.text 
   and organization_id = :gvi_organization_id ;

if f_sql_check() < 0 then 
   return	
end if

if sqlca.sqlcode = 100 then 
   sle_role_name.text = ''
else
	sle_role_name.text = message.stringparm
end if




end event

event rbuttondown;OPEN(W_ROLE_POPUP )

IF MESSAGE.STRINGPARM = '' THEN 
    RETURN
ELSE
	THIS.TEXT =  MESSAGE.STRINGPARM
END IF

end event

