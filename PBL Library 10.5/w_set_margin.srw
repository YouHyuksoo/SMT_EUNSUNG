HA$PBExportHeader$w_set_margin.srw
$PBExportComments$Datawindow Margin Setup
forward
global type w_set_margin from w_none_dw_popup_root
end type
type st_12 from so_statictext within w_set_margin
end type
type em_top from so_editmask within w_set_margin
end type
type em_rgt from so_editmask within w_set_margin
end type
type st_4 from so_statictext within w_set_margin
end type
type em_botm from so_editmask within w_set_margin
end type
type em_lft from so_editmask within w_set_margin
end type
type st_5 from so_statictext within w_set_margin
end type
type st_13 from so_statictext within w_set_margin
end type
type cb_1 from so_commandbutton within w_set_margin
end type
type gb_1 from so_groupbox within w_set_margin
end type
end forward

global type w_set_margin from w_none_dw_popup_root
integer width = 1847
integer height = 788
st_12 st_12
em_top em_top
em_rgt em_rgt
st_4 st_4
em_botm em_botm
em_lft em_lft
st_5 st_5
st_13 st_13
cb_1 cb_1
gb_1 gb_1
end type
global w_set_margin w_set_margin

on w_set_margin.create
int iCurrent
call super::create
this.st_12=create st_12
this.em_top=create em_top
this.em_rgt=create em_rgt
this.st_4=create st_4
this.em_botm=create em_botm
this.em_lft=create em_lft
this.st_5=create st_5
this.st_13=create st_13
this.cb_1=create cb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_12
this.Control[iCurrent+2]=this.em_top
this.Control[iCurrent+3]=this.em_rgt
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.em_botm
this.Control[iCurrent+6]=this.em_lft
this.Control[iCurrent+7]=this.st_5
this.Control[iCurrent+8]=this.st_13
this.Control[iCurrent+9]=this.cb_1
this.Control[iCurrent+10]=this.gb_1
end on

on w_set_margin.destroy
call super::destroy
destroy(this.st_12)
destroy(this.em_top)
destroy(this.em_rgt)
destroy(this.st_4)
destroy(this.em_botm)
destroy(this.em_lft)
destroy(this.st_5)
destroy(this.st_13)
destroy(this.cb_1)
destroy(this.gb_1)
end on

event open;call super::open;string l
//***********************************
//$$HEX2$$ecc531bc$$ENDHEX$$
//***********************************

if isvalid(selected_data_window) then 

	  l = selected_data_window.Describe("datawindow.print.margin.Top")
	  em_top.text = l
	  l = selected_data_window.Describe("datawindow.print.margin.Bottom")
	  em_botm.text = l
	  l = selected_data_window.Describe("datawindow.print.margin.Left")
	  em_lft.text = l
	  l = selected_data_window.Describe("datawindow.print.margin.Right")
	  em_rgt.text = l
	  
end if
end event

type p_title from w_none_dw_popup_root`p_title within w_set_margin
integer width = 1833
end type

type cb_close from w_none_dw_popup_root`cb_close within w_set_margin
boolean visible = true
integer x = 942
integer y = 596
integer width = 416
integer weight = 400
boolean default = true
end type

type st_msg from w_none_dw_popup_root`st_msg within w_set_margin
boolean visible = true
integer y = 496
integer width = 1833
end type

type st_12 from so_statictext within w_set_margin
integer x = 311
integer y = 284
integer width = 270
integer height = 64
boolean bringtotop = true
integer weight = 700
string pointer = "HyperLink!"
string text = "Top"
alignment alignment = right!
end type

type em_top from so_editmask within w_set_margin
event ue_change pbm_enchange
integer x = 622
integer y = 272
integer width = 247
integer taborder = 10
boolean bringtotop = true
string pointer = "HyperLink!"
string mask = "####0"
boolean spin = true
string displaydata = ""
double increment = 1
string minmax = "1~~9991"
end type

event ue_change;string l 
l = text 
selected_data_window.Modify("datawindow.print.margin.top = " + "'" + l + "'")
st_msg.text = (l)
end event

event modified;string l 
l = text 
selected_data_window.Modify("datawindow.print.margin.top = " + "'" + l + "'")
end event

type em_rgt from so_editmask within w_set_margin
event ue_change pbm_enchange
integer x = 622
integer y = 376
integer width = 247
integer taborder = 50
boolean bringtotop = true
string pointer = "HyperLink!"
string mask = "####0"
boolean spin = true
string displaydata = ""
double increment = 1
string minmax = "1~~9991"
end type

event ue_change;string l 
l = text 
selected_data_window.Modify("datawindow.print.margin.right = " + "'" + l + "'")
st_msg.text = (l)
end event

event modified;string l 
l = text 
selected_data_window.Modify("datawindow.print.margin.right = " + "'" + l + "'")

end event

type st_4 from so_statictext within w_set_margin
integer x = 311
integer y = 384
integer width = 270
integer height = 72
boolean bringtotop = true
integer weight = 700
string pointer = "HyperLink!"
string text = "Right"
alignment alignment = right!
end type

type em_botm from so_editmask within w_set_margin
event ue_change pbm_enchange
integer x = 1184
integer y = 376
integer width = 247
integer taborder = 60
boolean bringtotop = true
string pointer = "HyperLink!"
string mask = "####0"
boolean spin = true
string displaydata = ""
double increment = 1
string minmax = "1~~9991"
end type

event ue_change;string l 
l = text 
selected_data_window.Modify("datawindow.print.margin.bottom = " + "'" + l + "'")
st_msg.text = (l)
end event

event modified;string l 
l = text 
selected_data_window.Modify("datawindow.print.margin.bottom = " + "'" + l + "'")

end event

type em_lft from so_editmask within w_set_margin
event ue_change pbm_enchange
integer x = 1184
integer y = 268
integer width = 247
integer taborder = 10
boolean bringtotop = true
string pointer = "HyperLink!"
string mask = "####0"
boolean spin = true
string displaydata = ""
double increment = 1
string minmax = "1~~9991"
end type

event ue_change;string l 
l = text 
selected_data_window.Modify("datawindow.print.margin.left = " + "'" + l + "'")

st_msg.text = (l)
end event

event modified;string l 
l = text 
selected_data_window.Modify("datawindow.print.margin.left = " + "'" + l + "'")

end event

type st_5 from so_statictext within w_set_margin
integer x = 882
integer y = 276
integer width = 270
integer height = 60
boolean bringtotop = true
integer weight = 700
string pointer = "HyperLink!"
string text = "Left"
alignment alignment = right!
end type

type st_13 from so_statictext within w_set_margin
integer x = 882
integer y = 392
integer width = 270
integer height = 52
boolean bringtotop = true
integer weight = 700
string pointer = "HyperLink!"
string text = "Bottom"
alignment alignment = right!
end type

type cb_1 from so_commandbutton within w_set_margin
integer x = 521
integer y = 596
integer width = 416
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer weight = 400
string text = "Set Default"
end type

event clicked;call super::clicked;em_top.text = '96'
em_botm.text = '96'
em_lft.text = '110'
em_rgt.text = '110'
end event

type gb_1 from so_groupbox within w_set_margin
integer x = 283
integer y = 196
integer width = 1243
integer height = 292
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Margin Control"
end type

