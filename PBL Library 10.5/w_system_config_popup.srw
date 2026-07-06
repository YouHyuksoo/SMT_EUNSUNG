HA$PBExportHeader$w_system_config_popup.srw
forward
global type w_system_config_popup from w_none_dw_popup_root
end type
type tab_1 from tab within w_system_config_popup
end type
type tabpage_1 from userobject within tab_1
end type
type cb_2 from so_commandbutton within tabpage_1
end type
type cb_1 from so_commandbutton within tabpage_1
end type
type st_8 from so_statictext within tabpage_1
end type
type st_7 from so_statictext within tabpage_1
end type
type st_6 from so_statictext within tabpage_1
end type
type st_5 from so_statictext within tabpage_1
end type
type st_4 from so_statictext within tabpage_1
end type
type st_3 from so_statictext within tabpage_1
end type
type cbx_1 from so_checkbox within tabpage_1
end type
type st_2 from so_statictext within tabpage_1
end type
type st_1 from so_statictext within tabpage_1
end type
type sle_1 from so_singlelineedit within tabpage_1
end type
type tabpage_1 from userobject within tab_1
cb_2 cb_2
cb_1 cb_1
st_8 st_8
st_7 st_7
st_6 st_6
st_5 st_5
st_4 st_4
st_3 st_3
cbx_1 cbx_1
st_2 st_2
st_1 st_1
sle_1 sle_1
end type
type tab_1 from tab within w_system_config_popup
tabpage_1 tabpage_1
end type
end forward

global type w_system_config_popup from w_none_dw_popup_root
integer width = 2734
integer height = 2032
tab_1 tab_1
end type
global w_system_config_popup w_system_config_popup

on w_system_config_popup.create
int iCurrent
call super::create
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
end on

on w_system_config_popup.destroy
call super::destroy
destroy(this.tab_1)
end on

type p_title from w_none_dw_popup_root`p_title within w_system_config_popup
integer width = 2720
integer height = 244
boolean border = true
borderstyle borderstyle = styleraised!
end type

type cb_close from w_none_dw_popup_root`cb_close within w_system_config_popup
end type

type st_msg from w_none_dw_popup_root`st_msg within w_system_config_popup
end type

type tab_1 from tab within w_system_config_popup
integer x = 5
integer y = 268
integer width = 2697
integer height = 1664
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.Control[]={this.tabpage_1}
end on

on tab_1.destroy
destroy(this.tabpage_1)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2661
integer height = 1536
long backcolor = 12632256
string text = "Environment"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Environment!"
long picturemaskcolor = 536870912
string powertiptext = "System Config"
cb_2 cb_2
cb_1 cb_1
st_8 st_8
st_7 st_7
st_6 st_6
st_5 st_5
st_4 st_4
st_3 st_3
cbx_1 cbx_1
st_2 st_2
st_1 st_1
sle_1 sle_1
end type

on tabpage_1.create
this.cb_2=create cb_2
this.cb_1=create cb_1
this.st_8=create st_8
this.st_7=create st_7
this.st_6=create st_6
this.st_5=create st_5
this.st_4=create st_4
this.st_3=create st_3
this.cbx_1=create cbx_1
this.st_2=create st_2
this.st_1=create st_1
this.sle_1=create sle_1
this.Control[]={this.cb_2,&
this.cb_1,&
this.st_8,&
this.st_7,&
this.st_6,&
this.st_5,&
this.st_4,&
this.st_3,&
this.cbx_1,&
this.st_2,&
this.st_1,&
this.sle_1}
end on

on tabpage_1.destroy
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.st_8)
destroy(this.st_7)
destroy(this.st_6)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.cbx_1)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.sle_1)
end on

type cb_2 from so_commandbutton within tabpage_1
integer x = 2126
integer y = 1404
integer width = 443
integer height = 96
integer taborder = 30
string text = "Close"
end type

type cb_1 from so_commandbutton within tabpage_1
integer x = 1664
integer y = 1400
integer width = 443
integer height = 96
integer taborder = 20
string text = "Apply"
end type

type st_8 from so_statictext within tabpage_1
integer x = 55
integer y = 1268
integer width = 699
integer weight = 700
string text = "Number Format"
alignment alignment = right!
end type

type st_7 from so_statictext within tabpage_1
integer x = 55
integer y = 1108
integer width = 699
integer weight = 700
string text = "Dateend Range"
alignment alignment = right!
end type

type st_6 from so_statictext within tabpage_1
integer x = 55
integer y = 952
integer width = 699
integer weight = 700
string text = "Dateset Range"
alignment alignment = right!
end type

type st_5 from so_statictext within tabpage_1
integer x = 55
integer y = 800
integer width = 699
integer weight = 700
string text = "DW BackGround Color"
alignment alignment = right!
end type

type st_4 from so_statictext within tabpage_1
integer x = 55
integer y = 652
integer width = 699
integer weight = 700
string text = "DW Border Style"
alignment alignment = right!
end type

type st_3 from so_statictext within tabpage_1
integer x = 55
integer y = 500
integer width = 699
integer weight = 700
string text = "DW Title BackGround Color"
alignment alignment = right!
end type

type cbx_1 from so_checkbox within tabpage_1
integer x = 887
integer y = 344
end type

type st_2 from so_statictext within tabpage_1
integer x = 55
integer y = 344
integer width = 699
integer weight = 700
string text = "Aceess Control"
alignment alignment = right!
end type

type st_1 from so_statictext within tabpage_1
integer x = 55
integer y = 188
integer width = 699
integer weight = 700
string text = "Local Currency"
alignment alignment = right!
end type

type sle_1 from so_singlelineedit within tabpage_1
integer x = 878
integer y = 176
integer taborder = 10
end type

