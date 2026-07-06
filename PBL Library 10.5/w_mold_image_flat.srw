HA$PBExportHeader$w_mold_image_flat.srw
forward
global type w_mold_image_flat from window
end type
type st_item_code from so_statictext within w_mold_image_flat
end type
type p_image from so_picture within w_mold_image_flat
end type
end forward

global type w_mold_image_flat from window
integer width = 645
integer height = 688
boolean titlebar = true
boolean controlmenu = true
windowtype windowtype = popup!
long backcolor = 67108864
string icon = "OleGenReg!"
event ue_post_open ( )
st_item_code st_item_code
p_image p_image
end type
global w_mold_image_flat w_mold_image_flat

event ue_post_open();string lvs_mold_code
double lvdb_version ,lvdb_set_serial
int lvi_count

lvs_mold_code  = message.stringparm

if lvs_mold_code = '' or isnull(lvs_mold_code) then
	return
else
	st_item_code.text = lvs_mold_code
end if 

 select count(*) 
   into :lvi_count
  from imcn_mold
where mold_code       = :lvs_mold_code
   and organization_id = :gvi_organization_id ;
	
   if f_sql_check() < 0 then 
		return
	end if 
	
   if lvi_count < 1 then 
	
  else
	
	p_image.setpicture( f_download_mold_image( lvs_mold_code ) )	

   end if

	this.setredraw( true)

if p_image.width < 618 then 
	
else
	this.width = p_image.width + 20
end if 

this.height = p_image.y + p_image.height +120
end event

on w_mold_image_flat.create
this.st_item_code=create st_item_code
this.p_image=create p_image
this.Control[]={this.st_item_code,&
this.p_image}
end on

on w_mold_image_flat.destroy
destroy(this.st_item_code)
destroy(this.p_image)
end on

event open;this.setredraw( false)
//f_set_layered_window( handle(this) , 85 )
postevent('ue_post_open')
end event

type st_item_code from so_statictext within w_mold_image_flat
integer x = 105
integer y = 4
integer width = 530
integer weight = 700
long backcolor = 67108864
end type

type p_image from so_picture within w_mold_image_flat
integer x = 5
integer y = 92
integer width = 617
integer height = 516
end type

