HA$PBExportHeader$w_item_image_flat.srw
forward
global type w_item_image_flat from window
end type
type pb_btn from so_picturebutton within w_item_image_flat
end type
type st_item_code from so_statictext within w_item_image_flat
end type
type p_image from so_picture within w_item_image_flat
end type
end forward

global type w_item_image_flat from window
integer width = 645
integer height = 688
boolean titlebar = true
boolean controlmenu = true
windowtype windowtype = popup!
long backcolor = 67108864
string icon = "OleGenReg!"
event ue_post_open ( )
pb_btn pb_btn
st_item_code st_item_code
p_image p_image
end type
global w_item_image_flat w_item_image_flat

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
	 this.visible = false
  else
	 this.visible = true
	p_image.setpicture( f_download_item_image( lvs_item_code ) )	

   end if

	this.setredraw( true)

if p_image.width < 618 then 
	
else
	this.width = p_image.width + 20
end if 

this.height = p_image.y + p_image.height +120
end event

on w_item_image_flat.create
this.pb_btn=create pb_btn
this.st_item_code=create st_item_code
this.p_image=create p_image
this.Control[]={this.pb_btn,&
this.st_item_code,&
this.p_image}
end on

on w_item_image_flat.destroy
destroy(this.pb_btn)
destroy(this.st_item_code)
destroy(this.p_image)
end on

event open;this.setredraw( false)
f_set_layered_window( handle(this) , 85 )
postevent('ue_post_open')
end event

type pb_btn from so_picturebutton within w_item_image_flat
integer x = 5
integer width = 101
integer height = 88
integer taborder = 10
boolean originalsize = false
string picturename = "PictureButton!"
alignment htextalign = center!
vtextalign vtextalign = vcenter!
string powertiptext = "Image Upload"
end type

event clicked;call super::clicked;if f_object_role_check() = false then  return

int    li_filenum , loops, i , lvi_count
long   flen, bytes_read , bytes_read_sum , new_pos
blob   lib_file , b
double lvdb_version
string is_filename, is_fullname , lvs_drawing_no , lvs_item_code
		
		if  st_item_code.text = '' then 
			 return
		end if
			
		lvs_item_code  =st_item_code.text
	
		if lvs_item_code ='' or isnull(lvs_item_code) then 
			return
		end if		
		
		if getfileopenname("select file", is_fullname, is_filename, "jpg", &
			 + "jpg files (*.jpg),*.jpg," &	
			 + "gif files (*.gif),*.gif," &
			 + "bmp files (*.bmp),*.bmp," &			 
			 + "all files (*.*), *.*") < 1 then return
		
		flen = filelength(is_fullname)
		
		if flen < 0 then 
			rollback;			
			f_msgbox1(9020 ,is_fullname )
			return 
		end if
		
		li_filenum = fileopen(is_fullname,  streammode!, read!, lockread!)
		
		if li_filenum <> -1 then
				
					setpointer(hourglass!)
					if flen > 32765 then
					
							  if mod(flen, 32765) = 0 then
									loops = flen/32765
							  else
									loops = (flen/32765) + 1
							  end if
					else
							  loops = 1
					end if
					
					new_pos = 1
					for i = 1 to loops
							  bytes_read = fileread(li_filenum, b)
							  bytes_read_sum = bytes_read_sum + bytes_read
							  lib_file = lib_file + b
							  f_msg_mdi_help( string(bytes_read_sum)+"/"+string(flen)+" bytes read" )
					next
					
					fileclose(li_filenum)
					
					select count(*) into :lvi_count
					  from id_item_image
					 where item_code    = :lvs_item_code
						and organization_id = :gvi_organization_id ;
						  
					if f_sql_check() < 0 then 
						return
					end if				  
					
					if lvi_count = 0 then 
						
						insert into id_item_image ( item_code , organization_id ) 
						   values ( :lvs_item_code , :gvi_organization_id ) ;
								  
						if f_sql_check() < 0 then 
							return
						end if				  
										
					end if
						  
					updateblob id_item_image set item_image = :lib_file 
					where item_code       = :lvs_item_code
					  and organization_id = :gvi_organization_id ;

				  if sqlca.sqlnrows > 0 then

				  else
					  rollback ;
					  messagebox("error" , is_filename+" file upload to database failed" )
					  return
				  end if;
			  
				  commit ;
			         f_msgbox(9022)

		end if
changedirectory(gvs_default_directory)

end event

type st_item_code from so_statictext within w_item_image_flat
integer x = 105
integer y = 4
integer width = 530
integer weight = 700
long backcolor = 67108864
end type

type p_image from so_picture within w_item_image_flat
integer x = 5
integer y = 92
integer width = 617
integer height = 516
end type

