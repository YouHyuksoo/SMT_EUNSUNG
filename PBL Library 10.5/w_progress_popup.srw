HA$PBExportHeader$w_progress_popup.srw
forward
global type w_progress_popup from w_none_dw_popup_root
end type
type hpb_1 from hprogressbar within w_progress_popup
end type
type p_1 from picture within w_progress_popup
end type
type gb_1 from groupbox within w_progress_popup
end type
end forward

global type w_progress_popup from w_none_dw_popup_root
integer width = 2171
integer height = 640
windowtype windowtype = popup!
long backcolor = 16777215
boolean contexthelp = false
hpb_1 hpb_1
p_1 p_1
gb_1 gb_1
end type
global w_progress_popup w_progress_popup

forward prototypes
public subroutine f_stepit ()
public subroutine f_setstep (long arg_step)
public subroutine f_set_range (long arg_start, long arg_end)
public subroutine f_set_message (string arg_message)
end prototypes

public subroutine f_stepit ();hpb_1.StepIt( )	
end subroutine

public subroutine f_setstep (long arg_step);hpb_1.setstep = arg_step
end subroutine

public subroutine f_set_range (long arg_start, long arg_end);hpb_1.setrange( arg_start ,arg_end ) 
end subroutine

public subroutine f_set_message (string arg_message);st_msg.text = arg_message
end subroutine

on w_progress_popup.create
int iCurrent
call super::create
this.hpb_1=create hpb_1
this.p_1=create p_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.hpb_1
this.Control[iCurrent+2]=this.p_1
this.Control[iCurrent+3]=this.gb_1
end on

on w_progress_popup.destroy
call super::destroy
destroy(this.hpb_1)
destroy(this.p_1)
destroy(this.gb_1)
end on

type p_title from w_none_dw_popup_root`p_title within w_progress_popup
integer width = 2158
end type

type cb_close from w_none_dw_popup_root`cb_close within w_progress_popup
boolean visible = true
integer x = 1385
integer y = 588
end type

type st_msg from w_none_dw_popup_root`st_msg within w_progress_popup
boolean visible = true
integer x = 18
integer y = 440
integer width = 1746
integer height = 92
long backcolor = 16777215
string text = "Message"
boolean border = false
borderstyle borderstyle = stylebox!
end type

type hpb_1 from hprogressbar within w_progress_popup
integer x = 133
integer y = 296
integer width = 1518
integer height = 92
boolean bringtotop = true
boolean smoothscroll = true
end type

type p_1 from picture within w_progress_popup
integer x = 1760
integer y = 204
integer width = 343
integer height = 300
boolean bringtotop = true
boolean originalsize = true
string picturename = "timer.gif"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_progress_popup
integer x = 5
integer y = 208
integer width = 1742
integer height = 224
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 16777215
string text = "Progress "
end type

