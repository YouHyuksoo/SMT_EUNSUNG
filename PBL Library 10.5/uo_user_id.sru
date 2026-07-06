HA$PBExportHeader$uo_user_id.sru
forward
global type uo_user_id from userobject
end type
type st_2 from statictext within uo_user_id
end type
type st_1 from statictext within uo_user_id
end type
type sle_user_name from singlelineedit within uo_user_id
end type
type ddlb_user_id from dropdownlistbox within uo_user_id
end type
end forward

global type uo_user_id from userobject
integer width = 859
integer height = 160
long backcolor = 12632256
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
st_2 st_2
st_1 st_1
sle_user_name sle_user_name
ddlb_user_id ddlb_user_id
end type
global uo_user_id uo_user_id

forward prototypes
public function string text ()
public function string getid ()
public function string getname ()
end prototypes

public function string text ();RETURN DDLB_USER_ID.TEXT
end function

public function string getid ();RETURN DDLB_USER_ID.TEXT
end function

public function string getname ();RETURN SLE_USER_NAME.TEXT
end function

on uo_user_id.create
this.st_2=create st_2
this.st_1=create st_1
this.sle_user_name=create sle_user_name
this.ddlb_user_id=create ddlb_user_id
this.Control[]={this.st_2,&
this.st_1,&
this.sle_user_name,&
this.ddlb_user_id}
end on

on uo_user_id.destroy
destroy(this.st_2)
destroy(this.st_1)
destroy(this.sle_user_name)
destroy(this.ddlb_user_id)
end on

type st_2 from statictext within uo_user_id
integer x = 448
integer width = 407
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
string text = "User Name"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within uo_user_id
integer width = 439
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
string text = "User ID"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_user_name from singlelineedit within uo_user_id
integer x = 448
integer y = 64
integer width = 407
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

type ddlb_user_id from dropdownlistbox within uo_user_id
integer y = 64
integer width = 439
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
boolean allowedit = true
boolean autohscroll = true
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event constructor;STRING LS_USER_ID, LS_USER_NAME , LS_FULL_USER_NAME

DECLARE CUR_01 CURSOR FOR 
	SELECT USER_ID, USER_NAME
  	  FROM ISYS_USERS
	 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;

 THIS.RESET()
 THIS.ADDITEM('%') 
 
OPEN CUR_01 ;

DO WHILE SQLCA.SQLCODE = 0 
	FETCH CUR_01 INTO :LS_USER_ID, :LS_USER_NAME;
	
	IF F_SQL_CHECK_WITH_MSG('SELECT FROM ISYS_USERS') < 0 THEN 
		CLOSE CUR_01 ;
		RETURN
	END IF
	
	IF SQLCA.SQLCODE = 100 THEN 
		EXIT
     END IF 
	
	LS_FULL_USER_NAME = LS_USER_ID
	
	THIS.ADDITEM(LS_FULL_USER_NAME)
LOOP

THIS.SELECTITEM(1)
CLOSE CUR_01 ;
end event

event selectionchanged;select user_name into :message.stringparm
from ISYS_USERS
where user_id = :this.text 
  and organization_id = :gvi_organization_id;

if f_sql_check() < 0 then 
   return	
end if

if sqlca.sqlcode = 100 then 
   sle_user_name.text = ''
else
	sle_user_name.text = message.stringparm
end if




end event

event rbuttondown;OPEN(W_USER_POPUP )

IF MESSAGE.STRINGPARM = '' THEN 
    RETURN
ELSE
	
	THIS.TEXT =  MESSAGE.STRINGPARM
END IF

end event

