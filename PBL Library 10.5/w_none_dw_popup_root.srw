HA$PBExportHeader$w_none_dw_popup_root.srw
$PBExportComments$(Item Query)-$$HEX4$$80bd88d470c88cd6$$ENDHEX$$
forward
global type w_none_dw_popup_root from window
end type
type p_title from picture within w_none_dw_popup_root
end type
type cb_close from so_commandbutton within w_none_dw_popup_root
end type
type st_msg from so_statictext within w_none_dw_popup_root
end type
end forward

global type w_none_dw_popup_root from window
integer width = 1787
integer height = 876
boolean titlebar = true
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 12632256
boolean contexthelp = true
boolean center = true
event ue_post_open ( )
p_title p_title
cb_close cb_close
st_msg st_msg
end type
global w_none_dw_popup_root w_none_dw_popup_root

type variables
DOUBLE setrow
DATAWINDOW IVD_SELECTED_DATA_WINDOW

//==============================
// ANIMATEWINDOW CONSTASNT
//==============================
CONSTANT LONG AW_HOR_POSITIVE = 1
CONSTANT LONG AW_HOR_NEGATIVE = 2
CONSTANT LONG AW_VER_POSITIVE = 4
CONSTANT LONG AW_VER_NEGATIVE = 8
CONSTANT LONG AW_CENTER = 16
CONSTANT LONG AW_HIDE = 65536
CONSTANT LONG AW_ACTIVATE = 131072
CONSTANT LONG AW_SLIDE = 262144
CONSTANT LONG AW_BLEND = 524288 


end variables

event ue_post_open();p_title.resize(width -5,  p_title.height)	
end event

on w_none_dw_popup_root.create
this.p_title=create p_title
this.cb_close=create cb_close
this.st_msg=create st_msg
this.Control[]={this.p_title,&
this.cb_close,&
this.st_msg}
end on

on w_none_dw_popup_root.destroy
destroy(this.p_title)
destroy(this.cb_close)
destroy(this.st_msg)
end on

event open;cb_close.setfocus()

if gds_dual.rowcount() < 1 then 
	f_msgbox(136) //There is not a possibility of knowing multi national language information		
	return
end if

this.st_msg.text = "Language Change..."
f_dual_lang_change_text(this)

this.st_msg.text = "Language Change Done."

end event

event resize;st_msg.resize(newwidth - 5 , st_msg.height )	
p_title.resize(newwidth - 5 , p_title.height )	

end event

event rbuttondown;msg = f_msgbox( 143) // "Language Extract ?"
IF MSG =1 THEN
ELSE
	RETURN 
END IF
window activesheet
activesheet = w_main_frame.GetActiveSheet( )
Selected_window = THIS

if Gvs_language = 'E' then
	IF IsValid(activesheet) THEN
		w_main_frame.SetMicroHelp("Searching...")
	
		f_dual_lang_gettext( Selected_window ) 
		
		w_main_frame.SetMicroHelp("Done.")	
	END IF
else
	f_msgbox( 101 )
//	('Information', " If you want to get text Then change current language set by 'English'.")
end if
end event

event key;if Key = KeyEscape! then 
	
	MSG = F_MSGBOX( 9039) //$$HEX10$$04d6acc73dcc44c72000ebb244c74cae94c62000$$ENDHEX$$?
	
	if Msg = 1 then
	else
		 Return
	end if

	close(this)
end if
end event

type p_title from picture within w_none_dw_popup_root
integer width = 1778
integer height = 200
boolean enabled = false
string picturename = "title_back.gif"
boolean focusrectangle = false
end type

type cb_close from so_commandbutton within w_none_dw_popup_root
boolean visible = false
integer x = 1435
integer y = 568
integer width = 274
integer height = 100
integer taborder = 10
string text = "Close"
end type

event clicked;close(parent)
end event

type st_msg from so_statictext within w_none_dw_popup_root
boolean visible = false
integer y = 692
integer width = 1778
integer height = 88
integer weight = 700
long textcolor = 16711680
boolean enabled = false
boolean border = true
borderstyle borderstyle = styleraised!
end type

