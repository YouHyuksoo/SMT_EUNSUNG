HA$PBExportHeader$uo_year.sru
forward
global type uo_year from editmask
end type
end forward

global type uo_year from editmask
integer width = 302
integer height = 100
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
string mask = "yyyy"
boolean autoskip = true
boolean spin = true
double increment = 1
end type
global uo_year uo_year

on uo_year.create
end on

on uo_year.destroy
end on

event constructor;select to_char(sysdate,'yyyy') 
  into :text
  from dual ;
end event

