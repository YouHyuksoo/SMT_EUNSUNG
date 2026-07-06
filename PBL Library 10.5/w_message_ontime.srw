HA$PBExportHeader$w_message_ontime.srw
$PBExportComments$$$HEX13$$7cc715c8dcc204acd9b348c5200054ba38c1c0c97cb99ccd25b8$$ENDHEX$$
forward
global type w_message_ontime from w_none_dw_popup_root
end type
type pb_info_msg from so_picturebutton within w_message_ontime
end type
type p_1 from picture within w_message_ontime
end type
type hpb_progress from hprogressbar within w_message_ontime
end type
end forward

global type w_message_ontime from w_none_dw_popup_root
integer x = 1074
integer y = 840
integer width = 1957
integer height = 960
string title = "Please Know..."
windowtype windowtype = popup!
long backcolor = 16777215
pb_info_msg pb_info_msg
p_1 p_1
hpb_progress hpb_progress
end type
global w_message_ontime w_message_ontime

forward prototypes
public subroutine wf_stepit ()
public subroutine wf_setstep (integer arg_step)
public subroutine wf_setrange (integer arg_start, integer arg_end)
public subroutine wf_setposition (integer arg_position)
end prototypes

public subroutine wf_stepit ();hpb_progress.stepit()
end subroutine

public subroutine wf_setstep (integer arg_step);hpb_progress.setstep = arg_step
end subroutine

public subroutine wf_setrange (integer arg_start, integer arg_end);hpb_progress.setrange( arg_start , arg_end )
end subroutine

public subroutine wf_setposition (integer arg_position);hpb_progress.position = arg_position
end subroutine

event open;IF Gvf_time = 0 THEN 
	pb_info_msg.text = message.stringparm	
ELSE
	
	TIMER(Gvf_time)
	pb_info_msg.text = message.stringparm
END IF
end event

event close;Timer(0)
end event

on w_message_ontime.create
int iCurrent
call super::create
this.pb_info_msg=create pb_info_msg
this.p_1=create p_1
this.hpb_progress=create hpb_progress
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_info_msg
this.Control[iCurrent+2]=this.p_1
this.Control[iCurrent+3]=this.hpb_progress
end on

on w_message_ontime.destroy
call super::destroy
destroy(this.pb_info_msg)
destroy(this.p_1)
destroy(this.hpb_progress)
end on

event timer;Close(This)
end event

type p_title from w_none_dw_popup_root`p_title within w_message_ontime
boolean visible = false
integer x = 14
integer width = 1902
end type

type cb_close from w_none_dw_popup_root`cb_close within w_message_ontime
integer x = 46
integer y = 908
end type

type st_msg from w_none_dw_popup_root`st_msg within w_message_ontime
integer x = 14
integer y = 1028
end type

type pb_info_msg from so_picturebutton within w_message_ontime
integer x = 18
integer y = 316
integer width = 1906
integer height = 556
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
alignment htextalign = center!
vtextalign vtextalign = multiline!
end type

type p_1 from picture within w_message_ontime
integer x = 1582
integer width = 343
integer height = 300
boolean bringtotop = true
boolean originalsize = true
string picturename = "Timer.gif"
boolean focusrectangle = false
end type

type hpb_progress from hprogressbar within w_message_ontime
integer x = 27
integer y = 96
integer width = 1563
integer height = 76
boolean bringtotop = true
unsignedinteger maxposition = 100
integer setstep = 1
end type

