HA$PBExportHeader$w_my_job.srw
forward
global type w_my_job from w_none_dw_main_root
end type
type mle_1 from multilineedit within w_my_job
end type
type shl_4 from statichyperlink within w_my_job
end type
type p_4 from picture within w_my_job
end type
type p_2 from picture within w_my_job
end type
type shl_3 from statichyperlink within w_my_job
end type
type shl_2 from statichyperlink within w_my_job
end type
type p_1 from picture within w_my_job
end type
type shl_1 from statichyperlink within w_my_job
end type
type p_3 from picture within w_my_job
end type
end forward

global type w_my_job from w_none_dw_main_root
integer width = 2715
integer height = 2140
mle_1 mle_1
shl_4 shl_4
p_4 p_4
p_2 p_2
shl_3 shl_3
shl_2 shl_2
p_1 p_1
shl_1 shl_1
p_3 p_3
end type
global w_my_job w_my_job

on w_my_job.create
int iCurrent
call super::create
this.mle_1=create mle_1
this.shl_4=create shl_4
this.p_4=create p_4
this.p_2=create p_2
this.shl_3=create shl_3
this.shl_2=create shl_2
this.p_1=create p_1
this.shl_1=create shl_1
this.p_3=create p_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.mle_1
this.Control[iCurrent+2]=this.shl_4
this.Control[iCurrent+3]=this.p_4
this.Control[iCurrent+4]=this.p_2
this.Control[iCurrent+5]=this.shl_3
this.Control[iCurrent+6]=this.shl_2
this.Control[iCurrent+7]=this.p_1
this.Control[iCurrent+8]=this.shl_1
this.Control[iCurrent+9]=this.p_3
end on

on w_my_job.destroy
call super::destroy
destroy(this.mle_1)
destroy(this.shl_4)
destroy(this.p_4)
destroy(this.p_2)
destroy(this.shl_3)
destroy(this.shl_2)
destroy(this.p_1)
destroy(this.shl_1)
destroy(this.p_3)
end on

type mle_1 from multilineedit within w_my_job
integer x = 1691
integer y = 304
integer width = 937
integer height = 1468
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
boolean border = false
end type

type shl_4 from statichyperlink within w_my_job
integer x = 485
integer y = 1608
integer width = 992
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 16777215
long backcolor = 12632256
string text = "Receipt Master"
boolean focusrectangle = false
end type

type p_4 from picture within w_my_job
integer x = 183
integer y = 1568
integer width = 137
integer height = 120
boolean originalsize = true
string picturename = "D:\Project\ERP\Infinity21 ERP(HanSung) 10.5\PBL Library 10.5\Temp\sent_lg.gif"
boolean focusrectangle = false
end type

type p_2 from picture within w_my_job
integer x = 183
integer y = 1108
integer width = 137
integer height = 120
boolean originalsize = true
string picturename = "D:\Project\ERP\Infinity21 ERP(HanSung) 10.5\PBL Library 10.5\Temp\sent_lg.gif"
boolean focusrectangle = false
end type

type shl_3 from statichyperlink within w_my_job
integer x = 494
integer y = 1148
integer width = 992
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 16777215
long backcolor = 12632256
string text = "IQC Master"
boolean focusrectangle = false
end type

type shl_2 from statichyperlink within w_my_job
integer x = 466
integer y = 748
integer width = 992
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 16777215
long backcolor = 12632256
string text = "Departure Master"
boolean focusrectangle = false
end type

type p_1 from picture within w_my_job
integer x = 183
integer y = 708
integer width = 137
integer height = 120
boolean originalsize = true
string picturename = "D:\Project\ERP\Infinity21 ERP(HanSung) 10.5\PBL Library 10.5\Temp\sent_lg.gif"
boolean focusrectangle = false
end type

type shl_1 from statichyperlink within w_my_job
integer x = 466
integer y = 348
integer width = 992
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 16777215
long backcolor = 12632256
string text = "Purchase Order Master"
boolean focusrectangle = false
end type

type p_3 from picture within w_my_job
integer x = 183
integer y = 308
integer width = 137
integer height = 120
boolean originalsize = true
string picturename = "D:\Project\ERP\Infinity21 ERP(HanSung) 10.5\PBL Library 10.5\Temp\sent_lg.gif"
boolean focusrectangle = false
end type

