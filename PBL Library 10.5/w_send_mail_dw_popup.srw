HA$PBExportHeader$w_send_mail_dw_popup.srw
forward
global type w_send_mail_dw_popup from w_popup_root
end type
type cb_send from commandbutton within w_send_mail_dw_popup
end type
type mle_msg from multilineedit within w_send_mail_dw_popup
end type
type ole_smtp from olecustomcontrol within w_send_mail_dw_popup
end type
type sle_email_address from so_singlelineedit within w_send_mail_dw_popup
end type
type sle_name from so_singlelineedit within w_send_mail_dw_popup
end type
type st_1 from so_statictext within w_send_mail_dw_popup
end type
type st_2 from so_statictext within w_send_mail_dw_popup
end type
type gb_1 from so_groupbox within w_send_mail_dw_popup
end type
end forward

global type w_send_mail_dw_popup from w_popup_root
integer width = 1989
integer height = 1984
string title = "Send Mail"
boolean minbox = true
windowtype windowtype = popup!
boolean contexthelp = false
cb_send cb_send
mle_msg mle_msg
ole_smtp ole_smtp
sle_email_address sle_email_address
sle_name sle_name
st_1 st_1
st_2 st_2
gb_1 gb_1
end type
global w_send_mail_dw_popup w_send_mail_dw_popup

type variables

end variables

on w_send_mail_dw_popup.create
int iCurrent
call super::create
this.cb_send=create cb_send
this.mle_msg=create mle_msg
this.ole_smtp=create ole_smtp
this.sle_email_address=create sle_email_address
this.sle_name=create sle_name
this.st_1=create st_1
this.st_2=create st_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_send
this.Control[iCurrent+2]=this.mle_msg
this.Control[iCurrent+3]=this.ole_smtp
this.Control[iCurrent+4]=this.sle_email_address
this.Control[iCurrent+5]=this.sle_name
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.gb_1
end on

on w_send_mail_dw_popup.destroy
call super::destroy
destroy(this.cb_send)
destroy(this.mle_msg)
destroy(this.ole_smtp)
destroy(this.sle_email_address)
destroy(this.sle_name)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.gb_1)
end on

type p_title from w_popup_root`p_title within w_send_mail_dw_popup
integer width = 1970
end type

type cb_sort from w_popup_root`cb_sort within w_send_mail_dw_popup
integer x = 23
integer y = 2456
end type

type cb_close from w_popup_root`cb_close within w_send_mail_dw_popup
boolean visible = true
integer x = 379
integer y = 320
integer width = 343
end type

type st_msg from w_popup_root`st_msg within w_send_mail_dw_popup
integer y = 540
integer width = 1975
end type

type dw_1 from w_popup_root`dw_1 within w_send_mail_dw_popup
boolean visible = true
integer y = 1940
boolean titlebar = true
end type

type dw_2 from w_popup_root`dw_2 within w_send_mail_dw_popup
integer y = 1940
end type

type dw_3 from w_popup_root`dw_3 within w_send_mail_dw_popup
integer x = 5
integer y = 1940
end type

type cb_send from commandbutton within w_send_mail_dw_popup
integer x = 32
integer y = 320
integer width = 343
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Send"
boolean default = true
end type

event clicked;DATAWINDOW LVO_DATAWINDOW
LVO_DATAWINDOW = message.PowerObjectParm
window lvs_window
lvs_window = w_main_frame.GetActiveSheet ( )
if isvalid(lvs_window) then 
else
	return
end if 

mle_msg.TEXT = ''


IF LVO_DATAWINDOW.GETROW() < 1 THEN RETURN
Open(w_please_wait_popup)
//**********************************************************************
//MAIL SETTING
//**********************************************************************

STRING LVS_MAIL_SERVER, LVS_SERVER_USER, LVS_SERVER_PWD
STRING LVS_RECIPIENT_NAME , LVS_RECIPIENT_EMAIL

LVS_RECIPIENT_NAME = sle_name.text
LVS_RECIPIENT_EMAIL= sle_email_address.text

if LVS_RECIPIENT_EMAIL ='' or isnull(LVS_RECIPIENT_EMAIL) then 
	Close(w_please_wait_popup)	
	f_msgbox(145)
	return
end if


LVS_RECIPIENT_NAME  = MID( LVS_RECIPIENT_NAME , 1 , POS(LVS_RECIPIENT_NAME , '@') -1 ) 

SELECT MAX(MAIL_SVR) , MAX(MAIL_SVR_USER_ID) , MAX(MAIL_SVR_PASSWORD)
 INTO :LVS_MAIL_SERVER, :LVS_SERVER_USER, :LVS_SERVER_PWD
FROM 
(

SELECT DECODE( CONFIG_NAME  , 'MAIL_SVR' , CONFIG_VALUE ,'')  MAIL_SVR,
		DECODE( CONFIG_NAME  , 'MAIL_SVR_USER_ID' , CONFIG_VALUE , '') MAIL_SVR_USER_ID,
		DECODE( CONFIG_NAME  , 'MAIL_SVR_PASSWORD' , CONFIG_VALUE ,'') MAIL_SVR_PASSWORD 
  FROM ISYS_CONFIG 
 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
 ) ;
 
IF F_SQL_CHECK() < 0 OR SQLCA.SQLCODE = 100 THEN 
	Close(w_please_wait_popup)	
	f_msgbox(148) 	//("Error" , "Mail Server Confuration Error" )
	RETURN
END IF

IF LVS_MAIL_SERVER ='' OR ISNULL(LVS_MAIL_SERVER) THEN 
	 Close(w_please_wait_popup)	
	 Messagebox("Notify" , "Mail Server Information Invalid")
	 Return

END IF

MSG = Messagebox("Notify" ,  &
                           +'Send Mail Server Address : '+LVS_MAIL_SERVER+'~r~n' &
                           +'     Send Mail Server User : '+LVS_SERVER_USER+'~r~n' &
			       +'                             Sender : '+'ERP'+'~r~n' &
			       +'      Sender Email Address : '+'erp@jisheng.co.kr'+'~r~n' &
                           +'                 Recipient User : '+LVS_RECIPIENT_NAME+'~r~n' &							
                           +'  Recipient Email Address : '+LVS_RECIPIENT_EMAIL , QUESTION! , YESNO!)
IF MSG = 1 THEN 
ELSE
	Close(w_please_wait_popup)	
	RETURN
END IF
							
OLE_SMTP.OBJECT.ServerName = LVS_MAIL_SERVER
OLE_SMTP.OBJECT.setAuthentication(LVS_SERVER_USER, LVS_SERVER_PWD)

OLE_SMTP.OBJECT.setSender( 'erp@jisheng.co.kr','ERP System')

OLE_SMTP.OBJECT.SetRecipient(LVS_RECIPIENT_EMAIL ,LVS_RECIPIENT_NAME )


LVO_DATAWINDOW.Object.DataWindow.HTMLTable.GenerateCSS
LVO_DATAWINDOW.Object.DataWindow.HTMLTable.NoWrap
OLE_SMTP.OBJECT.AddBody( LVO_DATAWINDOW.Object.DataWindow.Data.HTMLTable , TRUE) 
OLE_SMTP.OBJECT.SetSubject( lvs_window.title+'  ['+w_main_frame.getactivesheet().Classname()+' Report]')

	//************************************************************************
	//$$HEX7$$54ba7cc72000f4bcb4b030ae2000$$ENDHEX$$
	//************************************************************************
	int Lvb_return
      Lvb_return = ole_smtp.object.send() 
		
		IF Lvb_return < 0  THEN
		  Close(w_please_wait_popup)			
		  f_msgbox1( 147  , "Fail")   //('Notify',"Mail Send Failure Code=["+string(Lvi_return)+"]")
		END IF
		
OLE_SMTP.OBJECT.RemoveAllBody()		

Close(w_please_wait_popup)
end event

type mle_msg from multilineedit within w_send_mail_dw_popup
integer y = 640
integer width = 1970
integer height = 1260
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 65280
long backcolor = 0
boolean hscrollbar = true
boolean vscrollbar = true
boolean autohscroll = true
boolean autovscroll = true
borderstyle borderstyle = styleraised!
end type

type ole_smtp from olecustomcontrol within w_send_mail_dw_popup
event onprogress ( long sent,  long total )
event onerror ( string errormsg )
event onwarning ( string warningmsg )
event oncommandresponse ( string cmdmsg,  string responsemsg )
integer x = 23
integer y = 44
integer width = 110
integer height = 88
integer taborder = 20
boolean bringtotop = true
boolean border = false
boolean focusrectangle = false
string binarykey = "w_send_mail_dw_popup.win"
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
end type

event onprogress(long sent, long total);mle_msg.text=mle_msg.text+"Sent="+string(sent)+"   Total="+string(total)+'~r~n' 
end event

event onerror(string errormsg);mle_msg.text = mle_msg.text + 'Error'+ "  => " +errormsg+'~r~n'
end event

event onwarning(string warningmsg);mle_msg.text = mle_msg.text + 'Warning'+ "  => " +warningmsg+'~r~n'
end event

event oncommandresponse(string cmdmsg, string responsemsg);mle_msg.text = mle_msg.text + cmdmsg+ "  => " +responsemsg+'~r~n'
end event

type sle_email_address from so_singlelineedit within w_send_mail_dw_popup
integer x = 795
integer y = 428
integer width = 1143
integer taborder = 20
boolean bringtotop = true
end type

type sle_name from so_singlelineedit within w_send_mail_dw_popup
integer x = 800
integer y = 276
integer width = 1143
integer taborder = 30
boolean bringtotop = true
end type

type st_1 from so_statictext within w_send_mail_dw_popup
integer x = 800
integer y = 212
integer width = 1129
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Supplier Name"
end type

type st_2 from so_statictext within w_send_mail_dw_popup
integer x = 800
integer y = 364
integer width = 1129
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "E-MAil Address"
end type

type gb_1 from so_groupbox within w_send_mail_dw_popup
integer x = 5
integer y = 200
integer width = 750
integer height = 320
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type


Start of PowerBuilder Binary Data Section : Do NOT Edit
06w_send_mail_dw_popup.bin 
2900000a00e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfffffffefffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff0000000100000000000000000000000000000000000000000000000000000000d9e9e00001c8115300000003000001400000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000102001affffffff00000002ffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000d400000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000001001affffffffffffffff00000003a2e26c9643ce71b5e0741da9406963c100000000d9e9e00001c81153d9e9e00001c81153000000000000000000000000006f00430074006e006e00650073007400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000040000001000000000000000010000000200000003fffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
24ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000fffe00020105a2e26c9643ce71b5e0741da9406963c100000001fb8f0821101b01640008ed8413c72e2b00000030000000a400000005000001000000003000000101000000380000010200000040000001030000004800000000000000500000000300010000000000030000027b000000030000024600000003000000000000000500000000000000010001030000000c0074735f00706b636f73706f72000101000000090078655f00746e65740102007800090000655f00006e65747800007974090000015f00000073726576006e6f6900300030002d0037003000310030002d00200036003500310032003a003a0035003400320000002000770077000100000000027b00000246000000000073006500610073006500670077002e006e00690028002000290078002800200033003300320030002900320032002000300030002d0037003000310031002d00200032003900300031003a003a00310035003100000020007700770065005f007200720072006f006c005f0067006f0074005f00610072006500630070005f0070006f007000750077002e006e006900280020002900780028002000300035003000310020002900300032003700300031002d002d00300036003000310020003a0035003500320031003a002000350000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
16w_send_mail_dw_popup.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
