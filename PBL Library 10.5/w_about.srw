HA$PBExportHeader$w_about.srw
$PBExportComments$About window
forward
global type w_about from window
end type
type p_3 from picture within w_about
end type
type p_2 from picture within w_about
end type
type mle_license from multilineedit within w_about
end type
type st_11 from statictext within w_about
end type
type st_10 from so_statictext within w_about
end type
type st_mac_address from so_statictext within w_about
end type
type st_ip_address from so_statictext within w_about
end type
type st_9 from statictext within w_about
end type
type r_1 from rectangle within w_about
end type
type st_8 from statictext within w_about
end type
type st_6 from statictext within w_about
end type
type st_5 from statictext within w_about
end type
type st_4 from statictext within w_about
end type
type st_3 from statictext within w_about
end type
type p_1 from picture within w_about
end type
type shl_mail from so_statichyperlink within w_about
end type
type st_7 from so_statictext within w_about
end type
type st_2 from so_statictext within w_about
end type
type cb_1 from so_commandbutton within w_about
end type
type st_version from so_statictext within w_about
end type
type gb_1 from groupbox within w_about
end type
type ln_1 from line within w_about
end type
type ln_2 from line within w_about
end type
end forward

global type w_about from window
integer x = 1047
integer y = 664
integer width = 4064
integer height = 1280
boolean titlebar = true
string title = "About"
windowtype windowtype = response!
long backcolor = 16777215
toolbaralignment toolbaralignment = alignatleft!
boolean center = true
p_3 p_3
p_2 p_2
mle_license mle_license
st_11 st_11
st_10 st_10
st_mac_address st_mac_address
st_ip_address st_ip_address
st_9 st_9
r_1 r_1
st_8 st_8
st_6 st_6
st_5 st_5
st_4 st_4
st_3 st_3
p_1 p_1
shl_mail shl_mail
st_7 st_7
st_2 st_2
cb_1 cb_1
st_version st_version
gb_1 gb_1
ln_1 ln_1
ln_2 ln_2
end type
global w_about w_about

type variables
integer ii_cb_width,ii_cb_height,ii_win_height,ii_win_width
end variables

on w_about.create
this.p_3=create p_3
this.p_2=create p_2
this.mle_license=create mle_license
this.st_11=create st_11
this.st_10=create st_10
this.st_mac_address=create st_mac_address
this.st_ip_address=create st_ip_address
this.st_9=create st_9
this.r_1=create r_1
this.st_8=create st_8
this.st_6=create st_6
this.st_5=create st_5
this.st_4=create st_4
this.st_3=create st_3
this.p_1=create p_1
this.shl_mail=create shl_mail
this.st_7=create st_7
this.st_2=create st_2
this.cb_1=create cb_1
this.st_version=create st_version
this.gb_1=create gb_1
this.ln_1=create ln_1
this.ln_2=create ln_2
this.Control[]={this.p_3,&
this.p_2,&
this.mle_license,&
this.st_11,&
this.st_10,&
this.st_mac_address,&
this.st_ip_address,&
this.st_9,&
this.r_1,&
this.st_8,&
this.st_6,&
this.st_5,&
this.st_4,&
this.st_3,&
this.p_1,&
this.shl_mail,&
this.st_7,&
this.st_2,&
this.cb_1,&
this.st_version,&
this.gb_1,&
this.ln_1,&
this.ln_2}
end on

on w_about.destroy
destroy(this.p_3)
destroy(this.p_2)
destroy(this.mle_license)
destroy(this.st_11)
destroy(this.st_10)
destroy(this.st_mac_address)
destroy(this.st_ip_address)
destroy(this.st_9)
destroy(this.r_1)
destroy(this.st_8)
destroy(this.st_6)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.p_1)
destroy(this.shl_mail)
destroy(this.st_7)
destroy(this.st_2)
destroy(this.cb_1)
destroy(this.st_version)
destroy(this.gb_1)
destroy(this.ln_1)
destroy(this.ln_2)
end on

event open;st_ip_address.text = Gvs_ip_address
st_mac_address.text = Gvs_mac_address
end event

type p_3 from picture within w_about
integer width = 1701
integer height = 800
boolean originalsize = true
string picturename = "jsad.gif"
boolean border = true
boolean focusrectangle = false
end type

type p_2 from picture within w_about
integer x = 1829
integer y = 524
integer width = 142
integer height = 120
boolean originalsize = true
string picturename = "phone.gif"
boolean border = true
boolean focusrectangle = false
end type

type mle_license from multilineedit within w_about
integer x = 18
integer y = 1012
integer width = 1682
integer height = 160
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_11 from statictext within w_about
integer x = 18
integer y = 948
integer width = 1417
integer height = 52
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 255
long backcolor = 16777215
string text = "$$HEX28$$74c72000dcc2a4c25cd140c7200044c598b72000acc0a9c690c7d0c58cac2000acc0a9c674c72000c8d500ac200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$."
boolean focusrectangle = false
end type

type st_10 from so_statictext within w_about
integer y = 848
integer width = 379
integer weight = 700
boolean underline = true
long backcolor = 16777215
string text = "NetWork:"
end type

type st_mac_address from so_statictext within w_about
integer x = 1125
integer y = 848
integer width = 590
long backcolor = 16777215
end type

type st_ip_address from so_statictext within w_about
integer x = 393
integer y = 848
integer width = 718
long backcolor = 16777215
end type

type st_9 from statictext within w_about
integer x = 2679
integer y = 312
integer width = 402
integer height = 64
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
string text = "Contact Us :"
boolean focusrectangle = false
end type

type r_1 from rectangle within w_about
long linecolor = 33554432
integer linethickness = 4
long fillcolor = 1073741824
integer x = 1746
integer width = 2295
integer height = 1172
end type

type st_8 from statictext within w_about
integer x = 2816
integer y = 652
integer width = 402
integer height = 56
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
string text = "Address:"
boolean focusrectangle = false
end type

type st_6 from statictext within w_about
integer x = 2821
integer y = 732
integer width = 1102
integer height = 96
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
string text = "$$HEX14$$1cc1b8c6dcc22000a1c10cd36cad200031bc1cc8e0ac84bd5cb82000$$ENDHEX$$45$$HEX2$$38ae2000$$ENDHEX$$19 $$HEX5$$38c104d64cbe29b52000$$ENDHEX$$2$$HEX2$$35ce2000$$ENDHEX$$"
boolean focusrectangle = false
end type

type st_5 from statictext within w_about
integer x = 1851
integer y = 836
integer width = 951
integer height = 64
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
string text = "http://www.jisheng.co.kr"
boolean focusrectangle = false
end type

type st_4 from statictext within w_about
integer x = 1851
integer y = 748
integer width = 951
integer height = 64
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
string text = "Fax: +82-2-456-7921"
boolean focusrectangle = false
end type

type st_3 from statictext within w_about
integer x = 1851
integer y = 660
integer width = 951
integer height = 64
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
string text = "Tel: +82-2-2135-4509"
boolean focusrectangle = false
end type

type p_1 from picture within w_about
integer x = 1829
integer y = 936
integer width = 247
integer height = 196
boolean originalsize = true
string picturename = "jslogo.jpg"
boolean focusrectangle = false
end type

event clicked;OPEN(W_OPENNING_POPUP)
end event

type shl_mail from so_statichyperlink within w_about
integer x = 3127
integer y = 312
integer width = 795
integer height = 64
integer weight = 700
long backcolor = 16777215
string text = "jisheng@jisheng.co.kr"
alignment alignment = center!
string url = "mailto:lansheng.co.kr"
end type

type st_7 from so_statictext within w_about
integer x = 2034
integer y = 436
integer width = 1074
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
long textcolor = 16711680
long backcolor = 16777215
string text = "Infinity21 All Right Reserved 2005"
alignment alignment = right!
end type

type st_2 from so_statictext within w_about
integer x = 2153
integer y = 152
integer width = 1746
integer height = 108
integer textsize = -12
integer weight = 700
long backcolor = 16777215
string text = "Perfect Innovator Jisheng Solution Consulting"
alignment alignment = right!
end type

type cb_1 from so_commandbutton within w_about
integer x = 3607
integer y = 1040
integer width = 402
integer height = 104
integer taborder = 10
fontcharset fontcharset = hangeul!
string text = "Exit"
end type

event clicked;close(Parent)
end event

type st_version from so_statictext within w_about
integer x = 3145
integer y = 436
integer width = 759
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
long textcolor = 0
long backcolor = 16777215
string text = "Version 2019/07/11 V 1.0"
alignment alignment = left!
end type

event constructor;call super::constructor;this.text = String(GVF_SYSTEM_VERSION)
end event

type gb_1 from groupbox within w_about
integer x = 2139
integer y = 96
integer width = 1851
integer height = 324
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
end type

type ln_1 from line within w_about
long linecolor = 33554432
integer linethickness = 8
integer beginx = 2523
integer beginy = 284
integer endx = 3726
integer endy = 284
end type

type ln_2 from line within w_about
long linecolor = 16711680
integer linethickness = 6
integer beginx = 1856
integer beginy = 572
integer endx = 3931
integer endy = 572
end type

