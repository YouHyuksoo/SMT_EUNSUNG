HA$PBExportHeader$uo_ym.sru
$PBExportComments$Datetime(yyymm)
forward
global type uo_ym from editmask
end type
end forward

global type uo_ym from editmask
integer width = 325
integer height = 88
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "yyyymm"
boolean autoskip = true
boolean spin = true
end type
global uo_ym uo_ym

event constructor;select to_char(sysdate,'yyyymm') 
  into :text
  from dual ;
end event

on uo_ym.create
end on

on uo_ym.destroy
end on

