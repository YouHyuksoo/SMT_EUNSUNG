HA$PBExportHeader$w_passchange.srw
$PBExportComments$$$HEX7$$28d3a4c2ccc6dcb42000c0bcbdac$$ENDHEX$$
forward
global type w_passchange from w_none_dw_popup_root
end type
type p_1 from picture within w_passchange
end type
type cb_change from commandbutton within w_passchange
end type
type st_new_password from statictext within w_passchange
end type
type st_organization from statictext within w_passchange
end type
type st_password from statictext within w_passchange
end type
type st_userid from statictext within w_passchange
end type
type sle_new_password from singlelineedit within w_passchange
end type
type ddlb_org from dropdownlistbox within w_passchange
end type
type sle_password from singlelineedit within w_passchange
end type
type sle_user_id from singlelineedit within w_passchange
end type
type st_1 from statictext within w_passchange
end type
type sle_check_password from singlelineedit within w_passchange
end type
end forward

global type w_passchange from w_none_dw_popup_root
integer x = 1056
integer y = 484
integer height = 1032
string title = "Password Change"
p_1 p_1
cb_change cb_change
st_new_password st_new_password
st_organization st_organization
st_password st_password
st_userid st_userid
sle_new_password sle_new_password
ddlb_org ddlb_org
sle_password sle_password
sle_user_id sle_user_id
st_1 st_1
sle_check_password sle_check_password
end type
global w_passchange w_passchange

forward prototypes
public function integer wf_language_change (string as_language, string as_org)
end prototypes

public function integer wf_language_change (string as_language, string as_org);
if as_language = 'C' THEN
	
  st_userid.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "USERIDTITLE_C", st_userid.text)
  st_password.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "PASSWORDTITLE_C", st_password.text)		
  st_new_password.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "NEWPASSWORDTITLE_C", st_new_password.text)		  
  st_organization.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "ORGANIZATIONTITLE_C", st_organization.text)		  
  cb_change.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "CHANGE_C", cb_change.text)		    
  cb_close.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "EXITTITLE_C", cb_close.text)		  
  
elseif as_language = 'K' THEN
   st_userid.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "USERIDTITLE_K", st_userid.text)
  st_password.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "PASSWORDTITLE_K", st_password.text)		
  st_new_password.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "NEWPASSWORDTITLE_K", st_new_password.text)		  
  st_organization.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "ORGANIZATIONTITLE_K", st_organization.text)		  
  cb_change.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "CHANGE_K", cb_change.text)		    
  cb_close.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "EXITTITLE_K", cb_close.text)		
  
elseif  as_language = 'E' THEN 
  st_userid.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "USERIDTITLE_E", st_userid.text)
  st_password.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "PASSWORDTITLE_E", st_password.text)		
  st_new_password.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "NEWPASSWORDTITLE_E", st_new_password.text)		  
  st_organization.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "ORGANIZATIONTITLE_E", st_organization.text)		
  cb_change.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "CHANGE_E", cb_change.text)		    
  cb_close.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "EXITTITLE_E", cb_close.text)		
  
end if

RETURN 0
end function

on w_passchange.create
int iCurrent
call super::create
this.p_1=create p_1
this.cb_change=create cb_change
this.st_new_password=create st_new_password
this.st_organization=create st_organization
this.st_password=create st_password
this.st_userid=create st_userid
this.sle_new_password=create sle_new_password
this.ddlb_org=create ddlb_org
this.sle_password=create sle_password
this.sle_user_id=create sle_user_id
this.st_1=create st_1
this.sle_check_password=create sle_check_password
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_1
this.Control[iCurrent+2]=this.cb_change
this.Control[iCurrent+3]=this.st_new_password
this.Control[iCurrent+4]=this.st_organization
this.Control[iCurrent+5]=this.st_password
this.Control[iCurrent+6]=this.st_userid
this.Control[iCurrent+7]=this.sle_new_password
this.Control[iCurrent+8]=this.ddlb_org
this.Control[iCurrent+9]=this.sle_password
this.Control[iCurrent+10]=this.sle_user_id
this.Control[iCurrent+11]=this.st_1
this.Control[iCurrent+12]=this.sle_check_password
end on

on w_passchange.destroy
call super::destroy
destroy(this.p_1)
destroy(this.cb_change)
destroy(this.st_new_password)
destroy(this.st_organization)
destroy(this.st_password)
destroy(this.st_userid)
destroy(this.sle_new_password)
destroy(this.ddlb_org)
destroy(this.sle_password)
destroy(this.sle_user_id)
destroy(this.st_1)
destroy(this.sle_check_password)
end on

event open;POSTEVENT('UE_POST_OPEN')
end event

event ue_post_open;call super::ue_post_open;//================================================================================
// $$HEX4$$b8c5b4c5c0bcbdac$$ENDHEX$$
//================================================================================
WF_LANGUAGE_CHANGE( Gvs_language , STRING(GVI_ORGANIZATION_ID ))
end event

type p_title from w_none_dw_popup_root`p_title within w_passchange
integer x = 14
end type

type cb_close from w_none_dw_popup_root`cb_close within w_passchange
boolean visible = true
integer x = 1253
integer y = 380
integer width = 366
integer taborder = 0
integer weight = 400
end type

type st_msg from w_none_dw_popup_root`st_msg within w_passchange
boolean visible = true
integer x = 9
integer y = 852
integer width = 1783
end type

type p_1 from picture within w_passchange
integer x = 1390
integer y = 560
integer width = 73
integer height = 64
boolean originalsize = true
string picturename = "CreateIndex!"
boolean focusrectangle = false
end type

type cb_change from commandbutton within w_passchange
integer x = 1253
integer y = 268
integer width = 366
integer height = 108
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Change"
boolean default = true
end type

event clicked;STRING USER_ID, PASSWD, NEWPASSWD , CHECK_PASSWD
  LONG ORG, CHECK
  
  
USER_ID    = SLE_USER_ID.TEXT 
PASSWD  	  = SLE_PASSWORD.TEXT
ORG		  = LONG(MID(DDLB_ORG.TEXT,1,1))
NEWPASSWD = SLE_NEW_PASSWORD.TEXT
CHECK_PASSWD = SLE_CHECK_PASSWORD.TEXT


IF USER_ID = '' OR PASSWD = '' OR ORG = 0 OR ISNULL(ORG) OR NEWPASSWD = '' THEN 
	f_msgbox(118)
//	('Error','You Must Insert USER ID, PASSWD, ORG, NEW PASSWD ! Check Condition!')
	RETURN
END IF 

IF NEWPASSWD <> CHECK_PASSWD THEN 
	f_msgbox(118)
//	('Error','You Must Insert USER ID, PASSWD, ORG, NEW PASSWD ! Check Condition!')
	RETURN
END IF 


SELECT COUNT(*)
  INTO :CHECK
  FROM ISYS_USERS 
 WHERE USER_ID  			= :USER_ID 
   AND PASSWORD 			= :PASSWD
	AND ORGANIZATION_ID  = :ORG ;
	
IF F_SQL_CHECK() < 0 THEN 
	RETURN
END IF

IF CHECK < 1 THEN 
	f_msgbox(118)
//	('CONFIRM','Unregistered User ! ~rCheck Your ID, PassWord!')
	RETURN
END IF 

IF NEWPASSWD = '' THEN 
	f_msgbox(118)	
	//('CONFIRM','CHECK YOUR NEW PASSWORD!')
	RETURN
END IF 

UPDATE ISYS_USERS
   SET PASSWORD = :NEWPASSWD
 WHERE USER_ID  			= :USER_ID 
   AND PASSWORD 			= :PASSWD
	AND ORGANIZATION_ID  = :ORG ;

IF F_SQL_CHECK() < 0 THEN 
	ROLLBACK ;
	RETURN
END IF 
 f_msgbox1(149 , NEWPASSWD )
//('CHANGE SUCCESS','PASSWORD IS CHANGED~rYour New PassWord : ' + NEWPASSWD)

COMMIT ;

CLOSE(PARENT)

end event

type st_new_password from statictext within w_passchange
integer x = 9
integer y = 480
integer width = 421
integer height = 68
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 255
long backcolor = 12632256
boolean enabled = false
string text = "New Passwd"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_organization from statictext within w_passchange
integer x = 5
integer y = 660
integer width = 421
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean enabled = false
string text = "Organization Id"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_password from statictext within w_passchange
integer x = 14
integer y = 372
integer width = 421
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean enabled = false
string text = "PassWord"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_userid from statictext within w_passchange
integer x = 14
integer y = 280
integer width = 421
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean enabled = false
string text = "User ID"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_new_password from singlelineedit within w_passchange
integer x = 439
integer y = 464
integer width = 526
integer height = 92
integer taborder = 30
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

type ddlb_org from dropdownlistbox within w_passchange
integer x = 439
integer y = 664
integer width = 526
integer height = 268
integer taborder = 50
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

type sle_password from singlelineedit within w_passchange
integer x = 439
integer y = 364
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

type sle_user_id from singlelineedit within w_passchange
integer x = 439
integer y = 268
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

event modified;STRING LS_ORG
LONG   LL_CNT, LS_LANGUAGE
DDLB_ORG.RESET()

DECLARE C_ORG CURSOR FOR
SELECT DISTINCT (TO_CHAR(A.ORGANIZATION_ID)||' : '||B.ORGANIZATION_NAME)
  FROM ISYS_USERS A, ISYS_ORGANIZATION B
 WHERE A.ORGANIZATION_ID = B.ORGANIZATION_ID
   AND A.USER_ID = :this.TEXT ;
 
OPEN C_ORG ;
if f_sql_check() < 0 then 
	return
end if 

DO WHILE SQLCA.SQLCODE = 0 
	FETCH C_ORG INTO :LS_ORG ;
	IF SQLCA.SQLCODE = 100 THEN 
		EXIT
	END IF 
	
	LL_CNT ++
	DDLB_ORG.ADDITEM(LS_ORG) 
	
LOOP

CLOSE C_ORG ;

IF LL_CNT < 1 THEN 
	f_msgbox( 118 ) //('Confirm','Your ID Unregister !')
	THIS.TEXT = ''
	THIS.SETFOCUS()
END IF 

DDLB_ORG.SelectItem(1)

SLE_PASSWORD.setfocus()


end event

type st_1 from statictext within w_passchange
integer x = 9
integer y = 580
integer width = 421
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 255
long backcolor = 12632256
boolean enabled = false
string text = "Check Passwd"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_check_password from singlelineedit within w_passchange
integer x = 439
integer y = 564
integer width = 526
integer height = 92
integer taborder = 40
boolean bringtotop = true
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

