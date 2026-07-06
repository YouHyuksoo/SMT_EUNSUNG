HA$PBExportHeader$uo_set_item_code.sru
$PBExportComments$Set Item Code ( Text() )
forward
global type uo_set_item_code from userobject
end type
type sle_set_item_code from so_singlelineedit within uo_set_item_code
end type
type sle_item_name from singlelineedit within uo_set_item_code
end type
end forward

global type uo_set_item_code from userobject
integer width = 1394
integer height = 100
long backcolor = 80269524
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
sle_set_item_code sle_set_item_code
sle_item_name sle_item_name
end type
global uo_set_item_code uo_set_item_code

forward prototypes
public function string text ()
public subroutine settext (string arg_text)
end prototypes

public function string text ();RETURN sle_set_item_code.text

end function

public subroutine settext (string arg_text);sle_set_item_code.text = arg_text
sle_item_name.text = f_get_item_name( arg_text)
	
end subroutine

on uo_set_item_code.create
this.sle_set_item_code=create sle_set_item_code
this.sle_item_name=create sle_item_name
this.Control[]={this.sle_set_item_code,&
this.sle_item_name}
end on

on uo_set_item_code.destroy
destroy(this.sle_set_item_code)
destroy(this.sle_item_name)
end on

type sle_set_item_code from so_singlelineedit within uo_set_item_code
integer width = 530
integer height = 84
integer taborder = 20
string pointer = "Help!"
textcase textcase = upper!
end type

event rbuttondown;call super::rbuttondown;open(w_des_set_item_popup)
if message.stringparm = '' then 
else
	this.text = message.stringparm
	sle_item_name.text = Gst_return.Gvs_return[4]
end if
end event

event modified;call super::modified;string lvs_item_name
select item_name into :lvs_item_name
from id_item
where item_code = :this.text
and organization_id = :gvi_organization_id ;

if f_sql_check() < 0 then
   return
end if

sle_item_name.text = lvs_item_name 
end event

type sle_item_name from singlelineedit within uo_set_item_code
integer x = 535
integer width = 859
integer height = 84
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

