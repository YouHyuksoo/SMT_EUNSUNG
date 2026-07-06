HA$PBExportHeader$w_report_where_condition_popup.srw
$PBExportComments$$$HEX11$$acb9ecd3b8d208c7c4b3b0c670c874ac08c81dd3c5c5$$ENDHEX$$
forward
global type w_report_where_condition_popup from w_popup_root
end type
type cb_retrieve from commandbutton within w_report_where_condition_popup
end type
type cb_reset from commandbutton within w_report_where_condition_popup
end type
type gb_2 from so_groupbox within w_report_where_condition_popup
end type
end forward

global type w_report_where_condition_popup from w_popup_root
integer width = 3063
integer height = 1768
string title = "Where Condition"
boolean controlmenu = false
windowtype windowtype = popup!
cb_retrieve cb_retrieve
cb_reset cb_reset
gb_2 gb_2
end type
global w_report_where_condition_popup w_report_where_condition_popup

type variables
datawindow ivd_dw
String ivs_window_name , ivs_datawindow_name
end variables

on w_report_where_condition_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.cb_reset=create cb_reset
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.cb_reset
this.Control[iCurrent+3]=this.gb_2
end on

on w_report_where_condition_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.cb_reset)
destroy(this.gb_2)
end on

event open;call super::open;ivd_dw =  message.Powerobjectparm

ivs_datawindow_name = Gst_return.gvs_return[1] 

cb_reset.triggerevent( clicked!)
end event

event resize;return
end event

event key;call super::key;if key = keyf1! then
	
	cb_retrieve.triggerevent( clicked!)
	
end if 
end event

type p_title from w_popup_root`p_title within w_report_where_condition_popup
boolean visible = false
integer width = 3054
end type

type cb_sort from w_popup_root`cb_sort within w_report_where_condition_popup
boolean visible = true
integer x = 0
integer y = 2168
integer width = 402
integer taborder = 0
end type

type cb_close from w_popup_root`cb_close within w_report_where_condition_popup
boolean visible = true
integer x = 2606
integer y = 72
integer width = 402
integer height = 128
integer taborder = 0
end type

type st_msg from w_popup_root`st_msg within w_report_where_condition_popup
boolean visible = true
integer y = 232
integer width = 3054
end type

type dw_1 from w_popup_root`dw_1 within w_report_where_condition_popup
boolean visible = true
integer y = 324
integer width = 3054
integer height = 1304
integer taborder = 0
string dataobject = "d_report_source_where_condition_lst"
end type

type dw_2 from w_popup_root`dw_2 within w_report_where_condition_popup
boolean visible = true
integer y = 324
integer width = 530
integer height = 336
integer taborder = 0
end type

type dw_3 from w_popup_root`dw_3 within w_report_where_condition_popup
integer y = 416
integer width = 530
integer height = 336
integer taborder = 0
end type

type cb_retrieve from commandbutton within w_report_where_condition_popup
integer x = 59
integer y = 72
integer width = 512
integer height = 128
integer taborder = 1
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Retrieve [F1]"
boolean default = true
end type

event clicked;string lvs_sql_old , lvs_sql , lvs_dest_string , lvs_data_type
int i 

dw_1.accepttext( )

//================================================
//
//================================================

lvs_sql = f_get_data_window_source( ivs_datawindow_name )

//=============================================
//
//=============================================
if lvs_sql = '' then 
	ivd_dw.dataobject = 'd_null_datawindow'
	return
else
	ivd_dw.Create ( lvs_sql) 
	ivd_dw.Modify("DataWindow.Print.Preview=yes")
	ivd_dw.Modify("DataWindow.Print.Preview.Rulers=yes")	
end if 
//=============================================
//
//=============================================
if dw_1.getrow() < 0 then 
else
		do
			i++
			//===================================================
			//$$HEX21$$85c725b81cb4200012ac74c72000c6c53cc774ba200030aef8bc12ac44c72000acc0a9c65cd5e4b22000$$ENDHEX$$
			//===================================================
			lvs_data_type = dw_1.object.data_type[i]
			
			if lvs_data_type = 'STRING' then
				
				//$$HEX8$$85c725b812ac74c72000c6c5e0ac2000$$ENDHEX$$
				if dw_1.object.argument_data[i] = '' or isnull(dw_1.object.argument_data[i]) then 
					
					//$$HEX10$$30aef8bc12acc4b3200010b178c7bdacb0c62000$$ENDHEX$$
					if isnull(dw_1.object.default_value[i]) or dw_1.object.default_value[i] = '' then 
						
						dw_1.object.argument_data[i] = "%"
					else
						
						dw_1.object.argument_data[i] =dw_1.object.default_value[i]
						
					end if 
				else
					//$$HEX21$$85c725b81cb4200012ac74c7200088c73cc7c0bb5cb8200030aef8bc12ac40c7200034bbdcc25cd5e4b2$$ENDHEX$$.
				end if 			
				
			elseif lvs_data_type = 'NUMBER'  OR lvs_data_type = 'DECIMAL' then
				
				//$$HEX8$$85c725b812ac74c72000c6c5e0ac2000$$ENDHEX$$
				if dw_1.object.argument_data[i] = '' or isnull(dw_1.object.argument_data[i]) then 
					
					//$$HEX10$$30aef8bc12acc4b3200010b178c7bdacb0c62000$$ENDHEX$$
					if isnull(dw_1.object.default_value[i]) or dw_1.object.default_value[i] = '' then 
						
						if dw_1.object.column_name_origin[i] = 'ORGANIZATION ID' then
							dw_1.object.argument_data[i] =string(Gvi_organization_id)
						else
							dw_1.object.argument_data[i] ='0'
						end if 
					else
						
						dw_1.object.argument_data[i] =dw_1.object.default_value[i]
						
					end if 
				else
					//$$HEX21$$85c725b81cb4200012ac74c7200088c73cc7c0bb5cb8200030aef8bc12ac40c7200034bbdcc25cd5e4b2$$ENDHEX$$.
				end if 			
				
			elseif lvs_data_type = 'DATETIME' then
				
				//$$HEX8$$85c725b812ac74c72000c6c5e0ac2000$$ENDHEX$$
				if dw_1.object.argument_data[i] = '' or isnull(dw_1.object.argument_data[i]) then 				
					
						//$$HEX10$$30aef8bc12acc4b3200010b178c7bdacb0c62000$$ENDHEX$$
					if isnull(dw_1.object.default_value[i]) or dw_1.object.default_value[i] = '' then 
						
						 //$$HEX11$$f9b27cc75cb8200030aef8bc12ac200024c115c82000$$ENDHEX$$
						dw_1.object.argument_data[i] = string( f_t_sysdate() , 'YYYYMMDD')						
						
					else
					            //$$HEX10$$30aef8bc12ac74c7200088c794b2bdacb0c62000$$ENDHEX$$
							if dw_1.object.default_value[i] = 'SYSDATE' then
								
								dw_1.object.argument_data[i] = string( f_t_sysdate() , 'YYYYMMDD')
								
							elseif dw_1.object.default_value[i] = 'SYSDATE-15' then
								
								dw_1.object.argument_data[i] = string( f_v_sysdate(15) , 'YYYYMMDD')	
								
							elseif dw_1.object.default_value[i] = 'SYSDATE+15' then
								
								dw_1.object.argument_data[i] = string( f_v_sysdate(-15) , 'YYYYMMDD')						
								
							end if
						end if 
					else
						
						//$$HEX21$$85c725b81cb4200012ac74c7200088c73cc7c0bb5cb8200030aef8bc12ac40c7200034bbdcc25cd5e4b2$$ENDHEX$$.
						
					end if 
				
			end if 
			//===================================================
			
			if  lvs_data_type = 'STRING' then 
				
				   lvs_dest_string = "'"+dw_1.object.argument_data[i]+"'"
				   
				   lvs_sql = f_replace_string( lvs_sql , dw_1.object.argument_name[i]  ,  lvs_dest_string )
				   
			elseif lvs_data_type = 'NUMBER' or lvs_data_type = 'DECIMAL' then 
				
				   lvs_dest_string = dw_1.object.argument_data[i]	   
				   lvs_sql = f_replace_string( lvs_sql , dw_1.object.argument_name[i]  ,  lvs_dest_string)
				   
			elseif lvs_data_type = 'DATETIME' then 
			  
			         //$$HEX24$$04c7d0c51cc120003cba00c82000a0b0dcc9200012ac3cc75cb82000c0bcbdac18b4c8c5e4b2e0ac2000f4bce0ac2000$$ENDHEX$$
				   
				   lvs_dest_string = "TO_DATE(~'"+dw_1.object.argument_data[i]+"~'"+",~'YYYYMMDD~'"+")"
//				   lvs_dest_string = f_replace_string( lvs_dest_string , "-" , "")
				   lvs_dest_string = f_replace_string( lvs_dest_string , "/" , "")
				   
				   
				   if isnull(lvs_dest_string) then 
					lvs_dest_string = "TO_DATE(~'"+string(f_t_sysdate(),'YYYYMMDD')+"~'"+",~'YYYYMMDD~')"
				   end if 
				   
				   lvs_sql = f_replace_string( lvs_sql , dw_1.object.argument_name[i]  ,  lvs_dest_string )
				   
			end if 
		
		loop until i = dw_1.rowcount()

end if 

//===============================================
// $$HEX16$$d0c698b7200088c758b3200044c5dcad3cbab8d27cb92000c6c564c5e4b22000$$ENDHEX$$
//===============================================
int lvi_pos1 , lvi_Pos2 

lvi_pos1 = pos(lvs_sql , "arguments=((" , 1 )
lvi_pos2 = pos(lvs_sql , "))" , lvi_pos1 ) 

if lvi_pos1 > 0 and lvi_pos2 > lvi_pos1 then

      lvi_pos2 = lvi_pos2 + 1
	  
	lvs_sql = replace( lvs_sql , lvi_pos1 , lvi_pos2 - lvi_pos1 + 1 , '' )
	
end if 

if lvs_sql = '' then 
	ivd_dw.dataobject = 'd_null_datawindow'
	return
else
	ivd_dw.Create ( lvs_sql) 
	ivd_dw.Modify("DataWindow.Print.Preview=yes")
	ivd_dw.Modify("DataWindow.Print.Preview.Rulers=yes")	
	ivd_dw.settransobject( sqlca)
end if 

//====================================
// $$HEX7$$e4b26dadb4c52000c0bcbdac2000$$ENDHEX$$
//====================================
f_dual_lang_change_dwtext(ivd_dw)
//=============================================
//$$HEX13$$dcb46db8e4b2b4c62000200070b374c730d1200070c88cd62000$$ENDHEX$$
//=============================================

f_set_column_dddw(ivd_dw)
//=============================================
// $$HEX10$$e4c21cc8200070b374c730d1200070c88cd62000$$ENDHEX$$
//=============================================
ivd_dw.retrieve()
//=============================================
//
//=============================================
if isvalid(w_report_where_condition_popup) then 
	w_report_where_condition_popup.hide()	
end if 

end event

type cb_reset from commandbutton within w_report_where_condition_popup
integer x = 2199
integer y = 72
integer width = 402
integer height = 128
integer taborder = 11
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Reset"
boolean default = true
end type

event clicked;dw_1.retrieve( ivs_datawindow_name , gvs_language ,  gvi_organization_id )
dw_1.setfocus( )
end event

type gb_2 from so_groupbox within w_report_where_condition_popup
integer width = 3049
integer height = 232
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

