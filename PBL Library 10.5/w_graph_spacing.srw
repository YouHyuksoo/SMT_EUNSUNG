HA$PBExportHeader$w_graph_spacing.srw
$PBExportComments$General response window to set graph spacing.
forward
global type w_graph_spacing from w_none_dw_main_root
end type
type em_spacing from editmask within w_graph_spacing
end type
type cb_cancel from commandbutton within w_graph_spacing
end type
type cb_ok from commandbutton within w_graph_spacing
end type
end forward

global type w_graph_spacing from w_none_dw_main_root
integer x = 1079
integer y = 368
integer width = 1056
integer height = 540
string title = "Select Spacing Percent"
windowtype windowtype = response!
long backcolor = 74481808
toolbaralignment toolbaralignment = alignatleft!
em_spacing em_spacing
cb_cancel cb_cancel
cb_ok cb_ok
end type
global w_graph_spacing w_graph_spacing

type variables
object io_passed
graph igr_parm
datawindow idw_parm
int ii_original_spacing
end variables

event open;call super::open;///////////////////////////////////////////////////////////////////////////////////////////////////////
// open script for w_graph_spacing
///////////////////////////////////////////////////////////////////////////////////////////////////////

graphicobject lgro_hold

lgro_hold = Message.PowerObjectParm

If lgro_hold.TypeOf() = Graph! Then
	io_passed = Graph!
	igr_parm = Message.PowerObjectParm
	em_spacing.text = string(igr_parm.spacing)
	ii_original_spacing = igr_parm.spacing
Elseif lgro_hold.TypeOf() = Datawindow! Then
	io_passed = Datawindow!
	idw_parm = Message.PowerObjectParm
	em_spacing.text = idw_parm.Object.gr_1.spacing
	ii_original_spacing = Integer(em_spacing.text)
End If
end event

on w_graph_spacing.create
int iCurrent
call super::create
this.em_spacing=create em_spacing
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_spacing
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.cb_ok
end on

on w_graph_spacing.destroy
call super::destroy
destroy(this.em_spacing)
destroy(this.cb_cancel)
destroy(this.cb_ok)
end on

type em_spacing from editmask within w_graph_spacing
event ue_enchange pbm_enchange
integer x = 261
integer y = 76
integer width = 457
integer height = 100
integer taborder = 10
integer textsize = -9
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 41943040
borderstyle borderstyle = stylelowered!
string mask = "#####"
boolean spin = true
double increment = 10
string minmax = "0~t100"
end type

event ue_enchange;///////////////////////////////////////////////////////////////////////////////////////////////////////
// ue_enchange script for em_spacing
///////////////////////////////////////////////////////////////////////////////////////////////////////

If io_passed = Graph! Then
	igr_parm.spacing = integer (em_spacing.text)
Elseif io_passed = Datawindow! Then
	idw_parm.Object.gr_1.spacing = em_spacing.text
End If

end event

type cb_cancel from commandbutton within w_graph_spacing
integer x = 512
integer y = 244
integer width = 265
integer height = 96
integer taborder = 20
integer textsize = -9
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;///////////////////////////////////////////////////////////////////////////////////////////////////////
// clicked script for cb_cancel
///////////////////////////////////////////////////////////////////////////////////////////////////////

// Reset the spacing since the user hit the Cancel button.
If io_passed = Graph! Then
	igr_parm.spacing = ii_original_spacing
Elseif io_passed = Datawindow! Then
	idw_parm.Object.gr_1.spacing= string(ii_original_spacing)
End If

Close (parent)
end event

type cb_ok from commandbutton within w_graph_spacing
integer x = 215
integer y = 244
integer width = 265
integer height = 96
integer taborder = 30
integer textsize = -9
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&OK"
boolean default = true
end type

event clicked;///////////////////////////////////////////////////////////////////////////////////////////////////////
// close script for cb_ok
///////////////////////////////////////////////////////////////////////////////////////////////////////

Close (parent) 
end event

