HA$PBExportHeader$w_user_change.srw
$PBExportComments$$$HEX5$$acc0a9c690c7c0bcbdac$$ENDHEX$$
forward
global type w_user_change from w_none_dw_popup_root
end type
type cb_change from commandbutton within w_user_change
end type
type st_password from statictext within w_user_change
end type
type st_userid from statictext within w_user_change
end type
type sle_password from singlelineedit within w_user_change
end type
type sle_user_id from singlelineedit within w_user_change
end type
type p_1 from picture within w_user_change
end type
end forward

global type w_user_change from w_none_dw_popup_root
integer x = 1056
integer y = 484
integer width = 1943
integer height = 804
string title = "User Change"
long backcolor = 16777215
cb_change cb_change
st_password st_password
st_userid st_userid
sle_password sle_password
sle_user_id sle_user_id
p_1 p_1
end type
global w_user_change w_user_change

forward prototypes
public function integer wf_language_change (string as_language, string as_org)
end prototypes

public function integer wf_language_change (string as_language, string as_org);
if as_language = 'C' THEN
	
  st_userid.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "USERIDTITLE_C", st_userid.text)
  st_password.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "PASSWORDTITLE_C", st_password.text)		
  cb_change.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "CHANGE_C", cb_change.text)		    
  cb_close.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "EXITTITLE_C", cb_close.text)		  
  
elseif as_language = 'K' THEN
   st_userid.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "USERIDTITLE_K", st_userid.text)
  st_password.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "PASSWORDTITLE_K", st_password.text)		
  cb_change.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "CHANGE_K", cb_change.text)		    
  cb_close.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "EXITTITLE_K", cb_close.text)		
  
elseif  as_language = 'E' THEN 
  st_userid.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "USERIDTITLE_E", st_userid.text)
  st_password.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "PASSWORDTITLE_E", st_password.text)		
  cb_change.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "CHANGE_E", cb_change.text)		    
  cb_close.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "EXITTITLE_E", cb_close.text)		
  
end if

RETURN 0
end function

on w_user_change.create
int iCurrent
call super::create
this.cb_change=create cb_change
this.st_password=create st_password
this.st_userid=create st_userid
this.sle_password=create sle_password
this.sle_user_id=create sle_user_id
this.p_1=create p_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_change
this.Control[iCurrent+2]=this.st_password
this.Control[iCurrent+3]=this.st_userid
this.Control[iCurrent+4]=this.sle_password
this.Control[iCurrent+5]=this.sle_user_id
this.Control[iCurrent+6]=this.p_1
end on

on w_user_change.destroy
call super::destroy
destroy(this.cb_change)
destroy(this.st_password)
destroy(this.st_userid)
destroy(this.sle_password)
destroy(this.sle_user_id)
destroy(this.p_1)
end on

event open;call super::open;sle_user_id.setfocus()
end event

type p_title from w_none_dw_popup_root`p_title within w_user_change
integer x = 5
integer width = 1925
end type

type cb_close from w_none_dw_popup_root`cb_close within w_user_change
boolean visible = true
integer x = 1646
integer y = 392
integer taborder = 30
integer weight = 400
end type

type st_msg from w_none_dw_popup_root`st_msg within w_user_change
boolean visible = true
integer x = 5
integer y = 632
integer width = 1925
end type

type cb_change from commandbutton within w_user_change
integer x = 1646
integer y = 280
integer width = 274
integer height = 108
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Change"
boolean default = true
end type

event clicked;STRING USER_ID, PASSWD, NEWPASSWD
LONG  CHECK
  
  
USER_ID    = SLE_USER_ID.TEXT 
PASSWD    = SLE_PASSWORD.TEXT


IF USER_ID = '' OR PASSWD = '' THEN 
	f_msgbox(118)//	('Error','You Must Insert USER ID, PASSWD Check Condition!')
	RETURN
END IF 

SELECT COUNT(*)
  INTO :CHECK
  FROM ISYS_USERS 
 WHERE USER_ID  			= :USER_ID 
   AND PASSWORD 			= :PASSWD
	AND ORGANIZATION_ID  = :Gvi_organization_id ;
	
IF F_SQL_CHECK() < 0 THEN 
	RETURN
END IF

IF CHECK < 1 THEN 
	f_msgbox(118) //	('CONFIRM','Unregistered User ! ~rCheck Your ID, PassWord!')
	RETURN
END IF 

//======================================================
//
//======================================================
String Lvs_user_name  ,  Lvs_email_address , Lvs_User_Role
Int     Lvi_user_level
Select A.USER_NAME ,
		 A.EMAIL_ADDRESS,
		 A.USER_LEVEL
    into :Lvs_user_name  ,  :Lvs_email_address , :Lvi_user_level
   from ISYS_USERS A , ISYS_ORGANIZATION  B
 where A.user_id             = :USER_ID 
	and A.PASSWORD     = :PASSWD
	and A.ORGANIZATION_ID  = :Gvi_organization_id 
	and A.ORGANIZATION_ID = B.ORGANIZATION_ID;
	
if f_sql_check() < 1 then Return 

if sqlca.sqlcode = 100 then 
	f_msgbox( 118 ) //userid / password invalid
	Return
end if

SELECT DISTINCT MAX(ROLE_CODE) INTO :Lvs_User_Role
   FROM ISYS_PRIVILEGE
WHERE USER_ID = :USER_ID
    AND ORGANIZATION_ID = :Gvi_organization_id ;

if f_sql_check() < 1 then Return 

Gvs_user_id             = USER_ID
Gvs_password         = PASSWD
Gvs_user_name       = Lvs_user_name  
Gvs_email_address  = Lvs_email_address 
Gvs_User_Role        =Lvs_User_Role
Gvi_user_level         = Lvi_user_level
w_main_frame.title = w_main_frame.title+ "[User ID="+gvs_user_id+"][Level="+string(gvi_user_level)+'][DB='+ Gvs_database+"][ Computer="+f_get_computer_name()+"-"+f_get_computer_login_user_name()+"-"+TRIM(f_get_ip_address('IP'))+"]"

CLOSE(PARENT)

end event

type st_password from statictext within w_user_change
integer x = 654
integer y = 396
integer width = 421
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean enabled = false
string text = "PassWord"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_userid from statictext within w_user_change
integer x = 654
integer y = 304
integer width = 421
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean enabled = false
string text = "User ID"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_password from singlelineedit within w_user_change
integer x = 1079
integer y = 388
integer width = 526
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean autohscroll = false
boolean password = true
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type sle_user_id from singlelineedit within w_user_change
integer x = 1079
integer y = 292
integer width = 526
integer height = 92
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean autohscroll = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type p_1 from picture within w_user_change
integer x = 46
integer y = 212
integer width = 727
integer height = 396
boolean bringtotop = true
string picturename = "login.jpg"
boolean focusrectangle = false
end type

