HA$PBExportHeader$w_send_mail_popup.srw
forward
global type w_send_mail_popup from w_popup_root
end type
type cb_retrieve from commandbutton within w_send_mail_popup
end type
type cb_2 from commandbutton within w_send_mail_popup
end type
type mle_msg from multilineedit within w_send_mail_popup
end type
type sle_user_name from singlelineedit within w_send_mail_popup
end type
type st_14 from statictext within w_send_mail_popup
end type
type ole_smtp from olecustomcontrol within w_send_mail_popup
end type
type cb_1 from commandbutton within w_send_mail_popup
end type
type gb_1 from so_groupbox within w_send_mail_popup
end type
type gb_2 from so_groupbox within w_send_mail_popup
end type
end forward

global type w_send_mail_popup from w_popup_root
integer width = 3589
integer height = 2460
string title = "Send Mail"
cb_retrieve cb_retrieve
cb_2 cb_2
mle_msg mle_msg
sle_user_name sle_user_name
st_14 st_14
ole_smtp ole_smtp
cb_1 cb_1
gb_1 gb_1
gb_2 gb_2
end type
global w_send_mail_popup w_send_mail_popup

type variables

end variables

on w_send_mail_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.cb_2=create cb_2
this.mle_msg=create mle_msg
this.sle_user_name=create sle_user_name
this.st_14=create st_14
this.ole_smtp=create ole_smtp
this.cb_1=create cb_1
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.mle_msg
this.Control[iCurrent+4]=this.sle_user_name
this.Control[iCurrent+5]=this.st_14
this.Control[iCurrent+6]=this.ole_smtp
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.gb_1
this.Control[iCurrent+9]=this.gb_2
end on

on w_send_mail_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.cb_2)
destroy(this.mle_msg)
destroy(this.sle_user_name)
destroy(this.st_14)
destroy(this.ole_smtp)
destroy(this.cb_1)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;call super::open;cb_retrieve.triggerevent( clicked!)
end event

type p_title from w_popup_root`p_title within w_send_mail_popup
integer width = 3561
end type

type cb_sort from w_popup_root`cb_sort within w_send_mail_popup
integer x = 23
integer y = 2456
end type

type cb_close from w_popup_root`cb_close within w_send_mail_popup
boolean visible = true
integer x = 1573
integer y = 348
integer width = 343
end type

type st_msg from w_popup_root`st_msg within w_send_mail_popup
integer y = 540
integer width = 3561
end type

type dw_1 from w_popup_root`dw_1 within w_send_mail_popup
boolean visible = true
integer x = 5
integer y = 632
integer width = 3561
integer height = 1740
boolean titlebar = true
string dataobject = "d_user_popup"
end type

type dw_2 from w_popup_root`dw_2 within w_send_mail_popup
integer x = 5
integer y = 632
end type

type dw_3 from w_popup_root`dw_3 within w_send_mail_popup
integer x = 5
integer y = 632
end type

type cb_retrieve from commandbutton within w_send_mail_popup
integer x = 530
integer y = 348
integer width = 343
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Retrieve"
end type

event clicked;dw_1.retrieve( SLE_USER_NAME.TEXT+'%' , gvi_organization_id )
end event

type cb_2 from commandbutton within w_send_mail_popup
integer x = 878
integer y = 348
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


IF DW_1.GETROW() < 1 THEN RETURN
Open(w_please_wait_popup)
//**********************************************************************
//MAIL SETTING
//**********************************************************************

STRING LVS_MAIL_SERVER, LVS_SERVER_USER, LVS_SERVER_PWD
STRING LVS_RECIPIENT_NAME , LVS_RECIPIENT_EMAIL

LVS_RECIPIENT_NAME = DW_1.GETITEMSTRING( DW_1.GETROW() , 'EMAIL_ADDRESS' )
LVS_RECIPIENT_EMAIL= DW_1.GETITEMSTRING( DW_1.GETROW() , 'EMAIL_ADDRESS' )

if LVS_RECIPIENT_EMAIL ='' or isnull(LVS_RECIPIENT_EMAIL) then 
	Close(w_please_wait_popup)	
	f_msgbox(145)
	return
end if


LVS_RECIPIENT_NAME  = MID( LVS_RECIPIENT_NAME , 1 , POS(LVS_RECIPIENT_NAME , '@') -1 ) 
//LVS_RECIPIENT_EMAIL = MID( LVS_RECIPIENT_EMAIL , POS(LVS_RECIPIENT_EMAIL , '@')  +1 , LEN(LVS_RECIPIENT_EMAIL) - POS(LVS_RECIPIENT_EMAIL , '@')  ) 


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

type mle_msg from multilineedit within w_send_mail_popup
integer x = 1943
integer y = 232
integer width = 1605
integer height = 308
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

type sle_user_name from singlelineedit within w_send_mail_popup
event ue_editchange pbm_enchange
integer x = 46
integer y = 368
integer width = 421
integer height = 92
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "h_beam.cur"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN = "USER_NAME"

IF ISNULL(LVS_COLUMN) OR LEN(LVS_COLUMN) = 0 THEN RETURN 

IVD_SELECTED_DATA_WINDOW.SETFILTER('')
IVD_SELECTED_DATA_WINDOW.FILTER()

IF THIS.TEXT = '' THEN 
	IVD_SELECTED_DATA_WINDOW.SETFILTER('')
	IVD_SELECTED_DATA_WINDOW.FILTER()
	RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

IVD_SELECTED_DATA_WINDOW.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
IVD_SELECTED_DATA_WINDOW.FILTER()

end event

event getfocus;this.selecttext( 1 , len( this.text) )
this.Borderstyle = styleraised!
end event

event losefocus;this.Borderstyle = styleLowered!
end event

type st_14 from statictext within w_send_mail_popup
integer x = 46
integer y = 296
integer width = 421
integer height = 56
boolean bringtotop = true
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

type ole_smtp from olecustomcontrol within w_send_mail_popup
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
string binarykey = "w_send_mail_popup.win"
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

type cb_1 from commandbutton within w_send_mail_popup
integer x = 1225
integer y = 348
integer width = 343
integer height = 100
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Save"
end type

event clicked;if dw_1.update() < 0 then 
	rollback;
else
	commit;
end if 
end event

type gb_1 from so_groupbox within w_send_mail_popup
integer x = 512
integer y = 216
integer width = 1422
integer height = 320
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_send_mail_popup
integer x = 9
integer y = 216
integer width = 498
integer height = 320
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type


Start of PowerBuilder Binary Data Section : Do NOT Edit
0Cw_send_mail_popup.bin 
2B00000a00e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfffffffefffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff000000010000000000000000000000000000000000000000000000000000000008758ee001c805e900000003000001400000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000102001affffffff00000002ffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000d400000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000001001affffffffffffffff00000003a2e26c9643ce71b5e0741da9406963c10000000008758ee001c805e908758ee001c805e9000000000000000000000000006f00430074006e006e00650073007400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000040000001000000000000000010000000200000003fffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
29ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000fffe00020105a2e26c9643ce71b5e0741da9406963c100000001fb8f0821101b01640008ed8413c72e2b00000030000000a400000005000001000000003000000101000000380000010200000040000001030000004800000000000000500000000300010000000000030000027b000000030000024600000003000000000000000500000000000000010001030000000c0074735f00706b636f73706f72000101000000090078655f00746e65740102007800090000655f00006e65747800007974090000015f00000073726576006e6f6900650066006500720063006e00200065006100530073006e005300200072006500660069004d000000200053000100000000027b0000024600000000002000650070005300630065006100690074006c0000007900720042006400610065006c00200079006100480064006e0049002000430054004600000065007200730065007900740065006c0053002000720063007000690000007400720046006e006500680063005300200072006300700069002000740054004d004a000000690075006500630049002000430054004b00000069007200740073006e00650049002000430054004c0000006300750064006900200061006100480064006e0072007700740069006e0069000000670069004d00740073006100720000006c00610050007900700075007200000073000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1Cw_send_mail_popup.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
