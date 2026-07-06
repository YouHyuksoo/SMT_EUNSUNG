HA$PBExportHeader$w_mat_item_set_msl_location_popup.srw
$PBExportComments$$$HEX8$$6cade4b9e8b200ac20c1ddd01dd3c5c5$$ENDHEX$$
forward
global type w_mat_item_set_msl_location_popup from w_popup_root
end type
type cb_2 from so_commandbutton within w_mat_item_set_msl_location_popup
end type
type cb_insert from so_commandbutton within w_mat_item_set_msl_location_popup
end type
type mle_log from so_multilineedit within w_mat_item_set_msl_location_popup
end type
type rb_item from so_radiobutton within w_mat_item_set_msl_location_popup
end type
type rb_model_name from so_radiobutton within w_mat_item_set_msl_location_popup
end type
type cb_1 from so_commandbutton within w_mat_item_set_msl_location_popup
end type
type gb_3 from so_groupbox within w_mat_item_set_msl_location_popup
end type
type gb_1 from so_groupbox within w_mat_item_set_msl_location_popup
end type
end forward

global type w_mat_item_set_msl_location_popup from w_popup_root
integer width = 4123
integer height = 2232
cb_2 cb_2
cb_insert cb_insert
mle_log mle_log
rb_item rb_item
rb_model_name rb_model_name
cb_1 cb_1
gb_3 gb_3
gb_1 gb_1
end type
global w_mat_item_set_msl_location_popup w_mat_item_set_msl_location_popup

on w_mat_item_set_msl_location_popup.create
int iCurrent
call super::create
this.cb_2=create cb_2
this.cb_insert=create cb_insert
this.mle_log=create mle_log
this.rb_item=create rb_item
this.rb_model_name=create rb_model_name
this.cb_1=create cb_1
this.gb_3=create gb_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.cb_insert
this.Control[iCurrent+3]=this.mle_log
this.Control[iCurrent+4]=this.rb_item
this.Control[iCurrent+5]=this.rb_model_name
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.gb_3
this.Control[iCurrent+8]=this.gb_1
end on

on w_mat_item_set_msl_location_popup.destroy
call super::destroy
destroy(this.cb_2)
destroy(this.cb_insert)
destroy(this.mle_log)
destroy(this.rb_item)
destroy(this.rb_model_name)
destroy(this.cb_1)
destroy(this.gb_3)
destroy(this.gb_1)
end on

event open;call super::open;dw_1.settransobject(sqlca)


end event

event activate;call super::activate;IVS_resize_type = 'DEFAULT'
end event

type p_title from w_popup_root`p_title within w_mat_item_set_msl_location_popup
integer width = 4128
end type

type cb_sort from w_popup_root`cb_sort within w_mat_item_set_msl_location_popup
integer x = 2930
integer y = 276
integer height = 132
end type

type cb_close from w_popup_root`cb_close within w_mat_item_set_msl_location_popup
boolean visible = true
integer x = 3589
integer y = 280
integer width = 485
integer height = 132
end type

event cb_close::clicked;call super::clicked;Gst_return.gvb_return = false
end event

type st_msg from w_popup_root`st_msg within w_mat_item_set_msl_location_popup
boolean visible = true
integer x = 5
integer y = 484
integer width = 4128
end type

type dw_1 from w_popup_root`dw_1 within w_mat_item_set_msl_location_popup
boolean visible = true
integer x = 5
integer y = 576
integer width = 2651
integer height = 1504
boolean titlebar = true
string dataobject = "d_des_item_set_msl_location_popup"
end type

type dw_2 from w_popup_root`dw_2 within w_mat_item_set_msl_location_popup
integer y = 580
end type

type dw_3 from w_popup_root`dw_3 within w_mat_item_set_msl_location_popup
integer y = 668
end type

type cb_2 from so_commandbutton within w_mat_item_set_msl_location_popup
integer x = 69
integer y = 284
integer width = 494
integer height = 136
integer taborder = 60
boolean bringtotop = true
string text = "Excel Paste"
end type

event clicked;call super::clicked;

dw_1.reset()
dw_1.importclipboard( )

end event

type cb_insert from so_commandbutton within w_mat_item_set_msl_location_popup
integer x = 571
integer y = 284
integer width = 485
integer height = 136
integer taborder = 70
boolean bringtotop = true
string text = "Save [F2]"
end type

event clicked;call super::clicked;string lvs_item_code , lvs_msl_level , lvs_location_address , lvs_part_no , lvs_feeder_size , lvs_pcb_item_code
long i , lvi_count , lvl_msl_max_time , lvl_life_cycle
//=========================================
//
//=========================================

if dw_1.rowcount( ) < 1 then return 


if rb_item.checked = true then 

				open(w_progress_popup)
				w_progress_popup.f_set_range( 1,  dw_1.rowcount( ) )
				w_progress_popup.f_setstep(1)
				//========================================================
				//
				//========================================================										
				do
					i++
					lvs_item_code = dw_1.object.item_code[i]
					lvs_msl_level = dw_1.object.msl_level[i]
					lvl_msl_max_time= long(dw_1.object.msl_max_time[i])
					lvs_location_address  = dw_1.object.location_address[i]
					lvs_part_no  = dw_1.object.part_no[i]
					lvl_life_cycle = long(dw_1.object.life_cycle[i])
					lvs_feeder_size  = dw_1.object.feeder_size[i]
					
					lvi_count = 0
					select count(*) into :lvi_count from id_item
					where item_code = :lvs_item_code
						  and organization_id = :gvi_organization_id ;
						  
					  if f_sql_check() < 0 then 
						close(w_progress_popup)
						return
					  end if 
						  
					if lvi_count < 1 then 
						
						mle_log.text = mle_log.text + lvs_item_code+'~r~n'
					//	close(w_progress_popup)
					//	f_msgbox1(815 , string(i)+"  "+lvs_item_code )
						continue 
					end if 		
					
				//========================================================
				//
				//========================================================
					  update id_item set msl_level = nvl( :lvs_msl_level ,msl_level ) ,
														 location_address = nvl(:lvs_location_address , location_address ) , 
											 msl_max_time =  nvl(:lvl_msl_max_time , msl_max_time ) ,
											 part_no   =  nvl(:lvs_part_no , part_no ) ,
											 life_cycle = nvl(:lvl_life_cycle  , life_cycle ) ,
											 feeder_size =  nvl(:lvs_feeder_size  , feeder_size ) 
						where item_code = :lvs_item_code
						and organization_id = :gvi_organization_id ;
				
				//========================================================
				//
				//========================================================
					  if f_sql_check() < 0 then 
						close(w_progress_popup)
						return
					  end if 
					
					w_progress_popup.f_stepit()
					
					
					st_msg.text = string(i)	
					yield()
				loop until i = dw_1.rowcount( )
				close(w_progress_popup)
				
				commit ;
else
	
				open(w_progress_popup)
				w_progress_popup.f_set_range( 1,  dw_1.rowcount( ) )
				w_progress_popup.f_setstep(1)
				//========================================================
				//
				//========================================================										
				do
					i++
					lvs_item_code = dw_1.object.item_code[i]

					lvs_pcb_item_code  = dw_1.object.pcb_item_code[i]
					
					lvi_count = 0
					select count(*) into :lvi_count from ip_product_model_master
					where item_code = :lvs_item_code
					    and organization_id = :gvi_organization_id ;
						  
					  if f_sql_check() < 0 then 
						close(w_progress_popup)
						return
					  end if 
						  
					if lvi_count < 1 then 
						
						mle_log.text = mle_log.text + lvs_item_code+'~r~n'

						continue 
					end if 		
					
				//========================================================
				//
				//========================================================
					  update ip_product_model_master
					        set   pcb_item_code =  nvl(:lvs_pcb_item_code  , pcb_item_code ) 
						where item_code = :lvs_item_code
						and organization_id = :gvi_organization_id ;
				
				//========================================================
				//
				//========================================================
					  if f_sql_check() < 0 then 
						close(w_progress_popup)
						return
					  end if 
					
					w_progress_popup.f_stepit()
					
					
					st_msg.text = string(i)	
					yield()
				loop until i = dw_1.rowcount( )
				close(w_progress_popup)
				
				commit ;	
	
end if
f_msgbox(170)

end event

type mle_log from so_multilineedit within w_mat_item_set_msl_location_popup
integer x = 2665
integer y = 584
integer width = 1445
integer height = 1484
integer taborder = 120
boolean bringtotop = true
string text = ""
boolean hscrollbar = true
boolean vscrollbar = true
boolean autohscroll = true
boolean autovscroll = true
end type

type rb_item from so_radiobutton within w_mat_item_set_msl_location_popup
integer x = 1207
integer y = 264
boolean bringtotop = true
string text = "Item Master"
boolean checked = true
end type

type rb_model_name from so_radiobutton within w_mat_item_set_msl_location_popup
integer x = 1207
integer y = 352
boolean bringtotop = true
string text = "Model Master"
end type

type cb_1 from so_commandbutton within w_mat_item_set_msl_location_popup
integer x = 3008
integer y = 276
integer width = 485
integer height = 136
integer taborder = 80
boolean bringtotop = true
string text = "Save Form"
end type

event clicked;call super::clicked;string     docname, named 
Long iret

SETPOINTER(HOURGLASS!)		
iret = GetFileSaveName("Select Excel File ("+dw_1.classname()+")" , docname, named, "xls", "Excel Files (*.xls),*.xls")		

IF iret =1 THEN 
	
	     dw_1.insertrow( 0)
		uf_save_dw_as_excel( dw_1  , docname )
ELSE
	RETURN
END IF
		

end event

type gb_3 from so_groupbox within w_mat_item_set_msl_location_popup
integer x = 3525
integer y = 196
integer width = 571
integer height = 264
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_1 from so_groupbox within w_mat_item_set_msl_location_popup
integer x = 27
integer y = 212
integer width = 1723
integer height = 240
integer taborder = 30
long textcolor = 16711680
string text = "Process"
end type

