HA$PBExportHeader$w_item_eco_notify_image_popup.srw
forward
global type w_item_eco_notify_image_popup from window
end type
type pb_1 from so_commandbutton within w_item_eco_notify_image_popup
end type
type st_item_code from statictext within w_item_eco_notify_image_popup
end type
type mle_1 from multilineedit within w_item_eco_notify_image_popup
end type
type p_image from so_picture within w_item_eco_notify_image_popup
end type
end forward

global type w_item_eco_notify_image_popup from window
integer width = 4155
integer height = 1912
boolean titlebar = true
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "OleGenReg!"
boolean center = true
event ue_post_open ( )
pb_1 pb_1
st_item_code st_item_code
mle_1 mle_1
p_image p_image
end type
global w_item_eco_notify_image_popup w_item_eco_notify_image_popup

event ue_post_open();string lvs_item_code
int lvi_count
lvs_item_code  = message.stringparm
if lvs_item_code = '' or isnull(lvs_item_code) then
	return
else
	st_item_code.text = lvs_item_code
end if 

 select count(*) 
   into :lvi_count
  from id_item_image
where item_code       = :lvs_item_code
   and organization_id = :gvi_organization_id ;
	
   if f_sql_check() < 0 then 
		return
	end if 
	
   if lvi_count < 1 then 
	
  else
	
	p_image.setpicture( f_download_item_eco_image( lvs_item_code ) )	

   end if

	this.setredraw( true)

mle_1.text = Gst_return.gvs_return[1] 
end event

on w_item_eco_notify_image_popup.create
this.pb_1=create pb_1
this.st_item_code=create st_item_code
this.mle_1=create mle_1
this.p_image=create p_image
this.Control[]={this.pb_1,&
this.st_item_code,&
this.mle_1,&
this.p_image}
end on

on w_item_eco_notify_image_popup.destroy
destroy(this.pb_1)
destroy(this.st_item_code)
destroy(this.mle_1)
destroy(this.p_image)
end on

event open;this.setredraw( false)
f_set_layered_window( handle(this) , 85 )
postevent('ue_post_open')
end event

type pb_1 from so_commandbutton within w_item_eco_notify_image_popup
integer x = 3643
integer height = 88
integer taborder = 10
string text = "Exit"
boolean default = true
end type

event clicked;call super::clicked;Close(parent)
end event

type st_item_code from statictext within w_item_eco_notify_image_popup
integer x = 23
integer y = 8
integer width = 2007
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = center!
boolean focusrectangle = false
end type

type mle_1 from multilineedit within w_item_eco_notify_image_popup
integer x = 2075
integer y = 96
integer width = 2071
integer height = 1696
integer textsize = -22
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type p_image from so_picture within w_item_eco_notify_image_popup
integer x = 5
integer y = 92
integer width = 2057
integer height = 1708
boolean originalsize = false
end type

