HA$PBExportHeader$so_datawindow.sru
forward
global type so_datawindow from datawindow
end type
end forward

shared variables

end variables

global type so_datawindow from datawindow
integer width = 759
integer height = 568
string title = "dw_1"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
event ue_accepttext ( )
event ue_dwkey pbm_dwnkey
event ue_entertotab pbm_dwnprocessenter
event ue_unmoved pbm_syscommand
event ue_mousemove pbm_mousemove
event uo_mousemove pbm_dwnmousemove
end type
global so_datawindow so_datawindow

type variables
Long Setrow
string ivs_selected_row_yn= 'N'
string Ivs_modify_security = 'Y'
sTRING ivs_modify_mark = 'Y'
string ivs_retrice_cancel_popup_open = 'Y'
Any ls_anydata
end variables

event ue_accepttext();THIS.ACCEPTTEXT()
end event

event ue_dwkey;long row , I
string lvs_object_name , lvs_object_type
Long  lvl_x ,lvl_x2 ,  lvl_y  , lvl_y2 , lvl_width , lvl_height

if Gvi_dw_edit_mode = 0 then

					if keyflags = 2  then //ctrl key 
					
									if key = keya! then 
										
										
										if Upper(this.Describe( Getcolumnname()+'.Edit.Style')) = "CHECKBOX" then
											
										else
											f_msgbox1( 123 , Upper(this.Describe( Getcolumnname()+'.Edit.Style'))  )
											return
										end if
	                                             Msg = f_msgbox( 119 )							
										
										IF MSG = 1 THEN 
											
											     

//												IF ISVALID(THIS.OBJECT.CHECK_YN) THEN 
								
													DO
														I++
													     THIS.SETITEM( I ,GETCOLUMNNAME() , 'Y' )     														
//														THIS.OBJECT.CHECK_YN[I] = 'Y'
														
													LOOP UNTIL I = THIS.ROWCOUNT()
													
//												ELSE
//													RETURN
//												END IF			
//
											ELSEIF MSG = 2 THEN 
												
												
//												IF ISVALID(THIS.OBJECT.CHECK_YN) THEN 
								
													DO
														I++
													     THIS.SETITEM( I ,GETCOLUMNNAME() , 'N' )
//														THIS.OBJECT.CHECK_YN[I] = 'N'
														
													LOOP UNTIL I = THIS.ROWCOUNT()
													
//												ELSE
//													RETURN
//												END IF							
												
											
											ELSE
												RETURN
											END IF
								
								
									 elseif  key = keyleftarrow! then 
										
										Gvs_zoom_size = selected_data_window.Describe("Datawindow.Zoom")
										f_set_zoom(selected_data_window, string( long(Gvs_zoom_size) - 10) )
										
									elseif  key = keyrightarrow! then 
										Gvs_zoom_size = selected_data_window.Describe("Datawindow.Zoom")		
										f_set_zoom(selected_data_window, string(long(Gvs_zoom_size) + 10) )
										
									end if

				else
						
						if key = keyf12! then 
							
							post event rbuttondown(  0 , 0 , 1 , w_main_root.ls_anydata )
							
						elseif key=keyf8! then 
							
							if isvalid(w_clipboard) then 
								w_clipboard.show()	
							else
								open(w_clipboard)
							end if
							
							row = w_clipboard.dw_1.insertrow(0)
							w_clipboard.dw_1.setitem( row , 'text'  , Gvs_clipboard )
						
							::Clipboard(Gvs_clipboard)
							f_msg_mdi_help( 'Data='+Gvs_clipboard )
							this.setfocus()
						elseif key=keyf9! then 	
							
							if this.getrow() < 1 then return
							if this.getcolumnname() ='' then return	
							this.setitem( this.getrow() , this.getcolumnname()  , paste() )
							
						end if
						
					end if
					
elseif Gvi_dw_edit_mode = 1 then

	if  key = keyleftarrow! then 
		
				if Gst_edit_object.object_index > 0 then 
					
					do
						i++
						lvs_object_name = Gst_edit_object.object_name[i]
						lvs_object_type = Gst_edit_object.object_type[i]
						
                           	//$$HEX25$$6cc204d5b8d22000a4d07cb9200004b278b92000bdacb0c62000d0c594b22000f8c274c788c9200070c808c85cd5e4b22000$$ENDHEX$$
						if keyflags = 1 then
							
							    if  Upper(lvs_object_type) = 'LINE' then
									lvl_x2 = Gst_edit_object.object_x2[i] - 1
									selected_data_window.Modify( lvs_object_name+".x2="+string(lvl_x2) )
									Gst_edit_object.object_x2[i]  = lvl_x2
							    else
									lvl_width = Gst_edit_object.object_width[i] - 1
									selected_data_window.Modify( lvs_object_name+".width="+string(lvl_width) )
									Gst_edit_object.object_width[i]  = lvl_width
								end if
							
						else
								lvl_x = Gst_edit_object.object_x1[i] - 1
								 if  Upper(lvs_object_type) = 'LINE' then
									selected_data_window.Modify( lvs_object_name+".x1="+string(lvl_x) )
								else
									selected_data_window.Modify( lvs_object_name+".x="+string(lvl_x) )
								end if
								Gst_edit_object.object_x1[i]  = lvl_x
						end if
						
					loop Until i = Gst_edit_object.object_index
					
				end if
		
		elseif  key = keyrightarrow! then 
		
				if Gst_edit_object.object_index > 0 then 
					
					do
						i++
						lvs_object_name = Gst_edit_object.object_name[i]
						lvs_object_type = Gst_edit_object.object_type[i]
                             	//$$HEX25$$6cc204d5b8d22000a4d07cb9200004b278b92000bdacb0c62000d0c594b22000f8c274c788c9200070c808c85cd5e4b22000$$ENDHEX$$
						if keyflags = 1 then
							
							    if  Upper(lvs_object_type) = 'LINE' then
									lvl_x2 = Gst_edit_object.object_x2[i] + 1
									selected_data_window.Modify( lvs_object_name+".x2="+string(lvl_x2) )
									Gst_edit_object.object_x2[i]  = lvl_x2
							    else
									lvl_width = Gst_edit_object.object_width[i] + 1
									selected_data_window.Modify( lvs_object_name+".width="+string(lvl_width) )
									Gst_edit_object.object_width[i]  = lvl_width
								end if
							
						else
								lvl_x = Gst_edit_object.object_x1[i] + 1
																
								 if  Upper(lvs_object_type) = 'LINE' then
									selected_data_window.Modify( lvs_object_name+".x1="+string(lvl_x) )
								else
									selected_data_window.Modify( lvs_object_name+".x="+string(lvl_x) )
								end if
									Gst_edit_object.object_x1[i]  = lvl_x
						end if
						
					loop Until i = Gst_edit_object.object_index			
					
				end if
				
		elseif  key = keyuparrow! then 
		
				if Gst_edit_object.object_index > 0 then 
					
					do
						i++
						lvs_object_name = Gst_edit_object.object_name[i]
						lvs_object_type = Gst_edit_object.object_type[i]
						
                             	//$$HEX25$$6cc204d5b8d22000a4d07cb9200004b278b92000bdacb0c62000d0c594b22000f8c274c788c9200070c808c85cd5e4b22000$$ENDHEX$$
						if keyflags = 1 then						
								
								if upper(lvs_object_type) = 'LINE' then 
									lvl_y2 = Gst_edit_object.object_y2[i] - 1
									selected_data_window.Modify( lvs_object_name+".y2="+string(lvl_y2) )							
									Gst_edit_object.object_y2[i]  = lvl_y2														
								else
									lvl_height = Gst_edit_object.object_height[i] - 1
									selected_data_window.Modify( lvs_object_name+".height="+string(lvl_height) )
									Gst_edit_object.object_height[i]  = lvl_height							
								end if							
							
						else // $$HEX8$$04c758ce74ba2000c0bcbdac5cd5e4b2$$ENDHEX$$.
						
								lvl_y = Gst_edit_object.object_y1[i] - 1
								
								if upper(lvs_object_type) = 'LINE' then 
									selected_data_window.Modify( lvs_object_name+".y1="+string(lvl_y) )
									selected_data_window.Modify( lvs_object_name+".y2="+string(lvl_y) )							
									Gst_edit_object.object_y1[i]  = lvl_y							
									Gst_edit_object.object_y2[i]  = lvl_y														
								else
									selected_data_window.Modify( lvs_object_name+".y="+string(lvl_y) )
									Gst_edit_object.object_y1[i]  = lvl_y							
								end if
								
							end if
						
					loop Until i = Gst_edit_object.object_index			
					
				end if				
		
		elseif  key = keydownarrow! then 
		
				if Gst_edit_object.object_index > 0 then 
					
					do
						i++
						lvs_object_name = Gst_edit_object.object_name[i]
						lvs_object_type = Gst_edit_object.object_type[i]
						
                             	//$$HEX25$$6cc204d5b8d22000a4d07cb9200004b278b92000bdacb0c62000d0c594b22000f8c274c788c9200070c808c85cd5e4b22000$$ENDHEX$$
						if keyflags = 1 then						
								
								if upper(lvs_object_type) = 'LINE' then 
									lvl_y2 = Gst_edit_object.object_y2[i] + 1
									selected_data_window.Modify( lvs_object_name+".y2="+string(lvl_y2) )							
									Gst_edit_object.object_y2[i]  = lvl_y2														
								else
									lvl_height = Gst_edit_object.object_height[i] + 1
									selected_data_window.Modify( lvs_object_name+".height="+string(lvl_height) )
									Gst_edit_object.object_height[i]  = lvl_height							
								end if							
							
						else // $$HEX8$$04c758ceccb92000c0bcbdac5cd5e4b2$$ENDHEX$$.
							
								lvl_y = Gst_edit_object.object_y1[i] + 1								
								
								if upper(lvs_object_type) = 'LINE' then 
									selected_data_window.Modify( lvs_object_name+".y1="+string(lvl_y) )
									selected_data_window.Modify( lvs_object_name+".y2="+string(lvl_y) )							
									Gst_edit_object.object_y1[i]  = lvl_y							
									Gst_edit_object.object_y2[i]  = lvl_y														
								else
									selected_data_window.Modify( lvs_object_name+".y="+string(lvl_y) )
									Gst_edit_object.object_y1[i]  = lvl_y							
								end if
								
						end if

					loop Until i = Gst_edit_object.object_index			
					
				end if						
	  end if
	
end if
end event

event ue_entertotab;IF GVS_ENTERTOTAB_YN = 'Y' THEN

	SEND(HANDLE(THIS),256,9,983041)
	RETURN 1
END IF
end event

event ue_unmoved;CHOOSE CASE commandtype
	CASE 61456, 61458
		message.processed = true
		message.returnvalue = 0
END CHOOSE

return

end event

on so_datawindow.create
end on

on so_datawindow.destroy
end on

event clicked;//************************************************************************************
// QUICK SORT $$HEX2$$98ccacb9$$ENDHEX$$
//************************************************************************************
selected_data_window = this
IF Gvi_dw_edit_mode = 0 THEN  //$$HEX10$$18c215c8a8badcb400ac200044c5c8b274ba2000$$ENDHEX$$

			if keydown(KeyControl!) and  UPPER(DWO.TYPE) = 'TEXT' then
				
				IF row = 0 THEN 

					if Right(dwo.text , 1) = '^' then
					   dwo.text = mid( dwo.text , 1 , len(string(dwo.text)) - 1 )+'v'
					elseif Right(dwo.text , 1) = 'v' then
					   dwo.text = mid( dwo.text , 1 , len(string(dwo.text)) - 1 )+'^'						
					else
						dwo.text = dwo.text+'v'
					end if
					
					F_QUICK_SORT(THIS , MID(STRING(DWO.NAME),1,LEN(STRING(DWO.NAME)) - 2) )
				END IF
				
			ELSE
				 STRING LVS_VALUE
				 IF  UPPER(DWO.TYPE) = 'COLUMN' OR UPPER(DWO.TYPE) = 'OLE'  THEN
					  SELECTED_DATA_WINDOW = THIS
					
					IF ROW < 1 THEN RETURN
					if selected_data_window.Object.DataWindow.QueryMode = "yes" then 
						
					else
							LVS_VALUE = string(dwo.primary[row])	
							IF ISNULL(LVS_VALUE) THEN 
								 LVS_VALUE = ' '	
							END IF
							
							 F_MSG_MDI_HELP( upper(dwo.name)+' '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".Edit.Style")+' '+LVS_VALUE+' X= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".x")+' Y= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".y")    +' Width= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".width") )		
								
							Gvs_clipboard = string(dwo.primary[row])	
							Gvs_columnname = upper(dwo.name)
					end if
			
				ELSEIF  UPPER(DWO.TYPE) = 'TEXT' THEN
					 F_MSG_MDI_HELP( upper(dwo.name)+' '+dwo.text+' X= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".x")+' Y= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".y")    +' Width= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".width") )
				ELSEIF  UPPER(DWO.TYPE) = 'LINE' THEN
					 F_MSG_MDI_HELP( upper(dwo.name)+' X1= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".x1")+' Y1= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".y1") + ' X2= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".x2")+' Y2= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".y2") )
				ELSEIF  UPPER(DWO.TYPE) = 'GRAPH' THEN      
					 gs_anydata = dwo
					 F_MSG_MDI_HELP( upper(dwo.name)+' X= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".x")+' Y= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".y")    +' Width= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".width") )
				END IF
				
			END IF
			//=============================================================================
			//
			//=============================================================================
			IF  UPPER(DWO.TYPE) = 'COLUMN' THEN
				IF  F_CHECK_DRAG_YN( STRING(DWO.NAME) )   THEN
					THIS.DRAG(BEGIN!)
				END IF
			END IF
			
			IF ROW > 0 THEN 
				THIS.SETROW(ROW)
		     END IF	
			
ELSE //$$HEX8$$18c215c8a8badcb4200074c774ba2000$$ENDHEX$$
	string lvs_object_name , lvs_object_type  , lvs_null
	int lvi_upperbound , i
	
				 IF  UPPER(DWO.TYPE) = 'COLUMN' THEN					
					 F_MSG_MDI_HELP( upper(dwo.name)+' X= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".x")+' Y= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".y")    +' Width= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".width") )		
				ELSEIF  UPPER(DWO.TYPE) = 'TEXT' THEN
					 F_MSG_MDI_HELP( upper(dwo.name)+' '+dwo.text+' X= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".x")+' Y= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".y")    +' Width= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".width") )
				ELSEIF  UPPER(DWO.TYPE) = 'LINE' THEN
					 F_MSG_MDI_HELP( upper(dwo.name)+' X1= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".x1")+' Y1= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".y1") + ' X2= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".x2")+' Y2= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".y2") )
				ELSEIF  UPPER(DWO.TYPE) = 'COMPUTE' THEN					
					 F_MSG_MDI_HELP( upper(dwo.name)+' X= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".x")+' Y= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".y")    +' Width= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".width") )		
				ELSE
					
					lvi_upperbound = Gst_edit_object.object_index
					//$$HEX6$$08cd30ae54d620005cd5e4b2$$ENDHEX$$
					if 	lvi_upperbound > 0 then 
						do
							i++
							
							lvs_object_type = Upper(Gst_edit_object.object_type[i])
							lvs_object_name= Upper(Gst_edit_object.object_name[i])
							
							if  lvs_object_type = 'LINE' then
								
								selected_data_window.Modify( lvs_object_name+".pen.color=255" )
								
							else
								
								selected_data_window.Modify( 	 lvs_object_name+".border=2" )						 
								selected_data_window.Modify( 	 lvs_object_name +".Background.Color=16777215" ) //$$HEX4$$54d674c7b8d22000$$ENDHEX$$
								
							end if

							Gst_edit_object.object_name[i] = ""
							
						loop until i = lvi_upperbound
						
						Gst_edit_object.object_index = 0
						lvi_upperbound =  0
						
					end if
					
					Return	
				END IF
	
				if keydown(KeyControl!) then
					
					lvi_upperbound = Gst_edit_object.object_index 
					lvs_object_type = Upper(dwo.type)
					lvs_object_name=Upper(dwo.name)
					
				    	Gst_edit_object.object_name[lvi_upperbound+1] = lvs_object_name
				    	Gst_edit_object.object_type[lvi_upperbound+1]  = lvs_object_type
						 
					if 	lvs_object_type  = 'LINE' THEN  
							Gst_edit_object.object_x1[lvi_upperbound+1] = LONG(SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".x1"))
							Gst_edit_object.object_x2[lvi_upperbound+1] = LONG(SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".x2"))					 
							Gst_edit_object.object_Y1[lvi_upperbound+1] = LONG(SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".Y1"))
							Gst_edit_object.object_Y2[lvi_upperbound+1] = LONG(SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".Y2"))	
							Gst_edit_object.object_width[lvi_upperbound+1] = abs(LONG(SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".x2")) -LONG(SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".x1")))
							Gst_edit_object.object_height[lvi_upperbound+1] = abs(LONG(SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".y2")) -LONG(SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".y1")))							
							selected_data_window.Modify( lvs_object_name+".pen.color=16711680" )									
					else
							Gst_edit_object.object_x1[lvi_upperbound+1] = LONG(SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".x"))
							Gst_edit_object.object_x2[lvi_upperbound+1] = LONG(SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".x"))						 
							Gst_edit_object.object_Y1[lvi_upperbound+1] = LONG(SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".Y"))
							Gst_edit_object.object_Y2[lvi_upperbound+1] = LONG(SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".Y"))

							Gst_edit_object.object_width[lvi_upperbound+1] = LONG(SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".width"))
							Gst_edit_object.object_height[lvi_upperbound+1] = LONG(SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".height"))							
							selected_data_window.Modify( lvs_object_name+".border=3" )		
							selected_data_window.Modify( lvs_object_name+".Background.Color=16711680" )		//$$HEX9$$0cd380b7c9c0200009000900090009000900$$ENDHEX$$
					end if
					
					Gst_edit_object.object_index = lvi_upperbound+1
					
				else //$$HEX13$$e8b2c5b33cc75cb8200020c1ddd088d544c72000bdacb0c62000$$ENDHEX$$
					
		               lvi_upperbound = Gst_edit_object.object_index 
							
							
					if 	lvi_upperbound > 0 then 
						
						//$$HEX14$$74c704c8200020c1ddd01cb4200083ac2000a8ba50b4200074d51cc8$$ENDHEX$$
						do
							i++
							
							lvs_object_type = Upper(Gst_edit_object.object_type[i])
							
							if lvs_object_type = 'LINE' THEN 
								selected_data_window.Modify( Gst_edit_object.object_name[i] +".pen.color=255" )
							else
								selected_data_window.Modify( Gst_edit_object.object_name[i] +".border=2" )						 
								selected_data_window.Modify( Gst_edit_object.object_name[i] +".Background.Color=16777215" )	//$$HEX10$$54d674c7b8d22000090009000900090009000900$$ENDHEX$$
							end if
							
						loop until i = lvi_upperbound
						
						//$$HEX11$$6cad70c8b4cc200078c771b3a4c2200008cd30ae54d6$$ENDHEX$$
						Gst_edit_object.object_index = 0
						lvi_upperbound = 0
					end if
					lvs_object_type  = Upper(dwo.type) 
					lvs_object_name = Upper(dwo.name)
						
					Gst_edit_object.object_name[1] = lvs_object_name
					Gst_edit_object.object_type[1]  = lvs_object_type

					if 	lvs_object_type = 'LINE' THEN  
							Gst_edit_object.object_x1[lvi_upperbound+1] = LONG(SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".x1"))
							Gst_edit_object.object_x2[lvi_upperbound+1] = LONG(SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".x2"))					 
							Gst_edit_object.object_Y1[lvi_upperbound+1] = LONG(SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".Y1"))
							Gst_edit_object.object_Y2[lvi_upperbound+1] = LONG(SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".Y2"))	
							Gst_edit_object.object_width[lvi_upperbound+1] = abs(LONG(SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".x2")) -LONG(SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".x1")))							
							Gst_edit_object.object_height[lvi_upperbound+1] = abs(LONG(SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".y2")) -LONG(SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".y1")))

							selected_data_window.Modify( 	 lvs_object_name+".pen.color=16711680" )																	
							
					else
							Gst_edit_object.object_x1[lvi_upperbound+1] = LONG(SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".x"))
							Gst_edit_object.object_x2[lvi_upperbound+1] = LONG(SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".x"))						 
							Gst_edit_object.object_Y1[lvi_upperbound+1] = LONG(SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".Y"))
							Gst_edit_object.object_Y2[lvi_upperbound+1] = LONG(SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".Y"))
							Gst_edit_object.object_width[lvi_upperbound+1] = LONG(SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".width"))							
							Gst_edit_object.object_height[lvi_upperbound+1] = LONG(SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".height"))														
							
							selected_data_window.Modify( lvs_object_name+".border=3" )			
							selected_data_window.Modify( lvs_object_name+".Background.Color=16711680" ) //$$HEX3$$0cd380b7c9c0$$ENDHEX$$
							
					end if			
					//$$HEX13$$e8b2c5b3200020c1e3d074c7c0bb5cb8200078c771b3a4c22000$$ENDHEX$$1 $$HEX2$$24c115c8$$ENDHEX$$
					Gst_edit_object.object_index = 1

				end if

END IF
end event

event dberror;IF ISVALID(W_CANCEL_RETRIEVE_POP) THEN 
	CLOSE(W_CANCEL_RETRIEVE_POP)
END IF	
STRING LVS_COLUMN_NAME ,LVS_COLUMN_NAME_LOCAL , LVS_COLUMN_DESC_LOCAL , LVS_COLOR 
STRING LVS_TABLE_NAME , LVS_CONSTRAINTS_NAME
Gvs_DberrorMessage = sqlerrtext
Gvl_DberrorCode   = sqldbcode
Gvs_error_syntax = sqlsyntax
Gvl_error_row = row

IF   sqldbcode = 1 THEN // UNIQUE CHECK

      F_MSGBOX1( 125 , "Row NUmber="+STRING(Gvl_error_row) )
	 return  1

ELSEIF sqldbcode = 2291 THEN // CONSTRAINTS CHECK PARENT NOT FOUND
	
	LVS_CONSTRAINTS_NAME = MID( sqlerrtext , POS( sqlerrtext , '.' ,1 ) + 1 ,   POS(sqlerrtext , ')' ) - ( POS( sqlerrtext , '.' ,1 )  +1 )  )

ELSEIF sqldbcode = 2292 THEN // CONSTRAINTS CHECK CHILD  FOUND CAN`T DELETE

    //ORA-02292: integrity constraint (LANSHENG.SYS_C0047281) violated - child record found	
	 
	LVS_CONSTRAINTS_NAME = MID( sqlerrtext , POS( sqlerrtext , '.' ,1 ) + 1 ,   POS(sqlerrtext , ')' ) - ( POS( sqlerrtext , '.' ,1 )  +1 )  )
	
	LVS_TABLE_NAME = F_GET_CONSTRAINTS_TABLE_NAME(LVS_CONSTRAINTS_NAME) 
	F_MSGBOX2(162, LVS_CONSTRAINTS_NAME , LVS_TABLE_NAME )		
	return 1
ELSEIF sqldbcode = 1400 THEN // NULL CHECK
	
	//ORA-01400: CANNOT INSERT NULL INTO ("TAPM"."CORRELATOR"."CORRELATOR_ID")

	LVS_COLUMN_NAME = MID( sqlerrtext , POS( sqlerrtext , '.' ,1 ) + 2 ,   POS(sqlerrtext , ')' ) - POS( sqlerrtext , '.' ,1 ) + 2     )
	LVS_COLUMN_NAME = MID( LVS_COLUMN_NAME , POS( LVS_COLUMN_NAME , '.' ,1 ) + 2 , LEN(LVS_COLUMN_NAME)  -  POS( LVS_COLUMN_NAME , '.' ,1 )  - 6 ) 
	
	SELECT DECODE( :GVS_LANGUAGE , 'K' , WORD_KOR , 'E' , WORD_ENG , WORD_LOCAL) ,
             	   DECODE( :GVS_LANGUAGE , 'K' , WORD_DESCRIPTION_KOR , 'E' , WORD_DESCRIPTION_ENG , WORD_DESCRIPTION_LOCAL ) 
	   INTO :LVS_COLUMN_NAME_LOCAL , :LVS_COLUMN_DESC_LOCAL
	  FROM ISYS_WORD_DICTIONARY
    WHERE WORD_ENG = :LVS_COLUMN_NAME	  ;
	 
	IF F_SQL_CHECK() < 0 THEN 
		RETURN 1
	END IF
	
	LVS_COLOR = THIS.DESCRIBE( LVS_COLUMN_NAME+".Background.Color")	
	
	IF SQLCA.SQLCODE = 100 THEN 
		 THIS.Modify ( LVS_COLUMN_NAME+".Background.Color='"+"255"+"'" )
		 THIS.Modify ( LVS_COLUMN_NAME+".Background.Color='"+LVS_COLOR+"'" )	 
		 THIS.Modify ( LVS_COLUMN_NAME+".Background.Color='"+"255"+"'" )
		 F_MSGBOX1(111, LVS_COLUMN_NAME+'~r~n'+sqlerrtext )				 
	ELSE
		 THIS.Modify ( LVS_COLUMN_NAME+".Background.Color='"+"255"+"'" )
		 THIS.Modify ( LVS_COLUMN_NAME+".Background.Color='"+LVS_COLOR+"'" )	 
		 THIS.Modify ( LVS_COLUMN_NAME+".Background.Color='"+"255"+"'" )
		F_MSGBOX1(111, "["+LVS_COLUMN_NAME_LOCAL+"]"+'~r~n'+"["+LVS_COLUMN_DESC_LOCAL+"]"+'~r~n')		        
	END IF
	
	THIS.SETFOCUS()
	THIS.SETROW(row)
	THIS.SETCOLUMN( LVS_COLUMN_NAME )
     THIS.Modify ( LVS_COLUMN_NAME+".Background.Color='"+LVS_COLOR+"'" )	 			
	RETURN 1 
	
END IF

OPEN(W_ERROR_MESSAGE)

IF ISVALID(W_CANCEL_RETRIEVE_POP) THEN 
	CLOSE(W_CANCEL_RETRIEVE_POP)
END IF	
Return 1 // PB $$HEX33$$90c7b4ccd0c51cc12000b4b0f4bcb4b094b22000dcc2a4c25cd12000d0c5ecb7200054ba38c1c0c9200015bca4c220009ccd25b844c72000c9b930ae04c774d52000$$ENDHEX$$1 $$HEX7$$44c72000acb934d120005cd5e4b2$$ENDHEX$$.




end event

event doubleclicked;//======================================
//
//======================================
IF UPPER(dwo.type) = 'COLUMN' THEN 

	if row < 1 then 
	   return -1
     end if

	IF ivs_selected_row_yn = 'Y' THEN 
		
			THIS.SELECTROW(0 , FALSE )		
			THIS.SELECTROW(row , TRUE )
			THIS.SETROW(ROW)
		
	END IF

END IF
//=======================================

RETURN 1
end event

event error;f_msgbox1( 144 , STRING(ERRORNUMBER)+" "+ERRORTEXT+" "+errorwindowmenu+" "+errorobject+" "+errorscript+" "+STRING(errorline)+" ")
action  = EXCEPTIONiGNORE!
end event

event rbuttondown;String lvs_date , LVS_VALUE

THIS.ACCEPTTEXT()

if  UPPER(dwo.type) = 'COLUMN' then
	    if row < 1 then 
	    else
			LVS_VALUE = string(dwo.primary[row])	
			IF ISNULL(LVS_VALUE) THEN 
			 LVS_VALUE = ' '	
			END IF
		end if 
elseif UPPER(dwo.type) = 'TEXT' then

		LVS_VALUE = DWO.TEXT
		IF ISNULL(LVS_VALUE) THEN 
		 LVS_VALUE = ' '	
		END IF
	
elseif 	UPPER(dwo.type) = 'DATAWINDOW' then
		LVS_VALUE = THIS.CLASSNAME()
end if
//===================================================
// $$HEX18$$70b374c7c0d0200008c7c4b3b0c6200018c215c82000a8badcb47cc72000bdacb0c62000$$ENDHEX$$
//===================================================
if Gvi_dw_edit_mode = 1 then  
	gs_anydata = dwo
	
	     if  w_main_frame.menuname = 'm_main_frame_menu' then 
			m_main_frame_menu.m_system.m_reportmanage.m_reporteditmode.popmenu( w_main_frame.pointerx() , w_main_frame.pointery() ) 
		end if 
else
//===================================================
// $$HEX22$$70b374c7c0d0200008c7c4b3b0c6200018c215c82000a8badcb400ac200044c5ccb220002000bdacb0c62000$$ENDHEX$$
//===================================================	
	
	if upper(dwo.type) = 'DATAWINDOW'  or Upper(this.Describe( dwo.name+'.Edit.Style')) = "CHECKBOX" THEN 
		

	    if   Gst_set.Report_window = True then
			
			m_main_frame_menu.m_control.popmenu( w_main_frame.pointerx() , w_main_frame.pointery() ) 					
  	   else
			m_main_frame_menu.m_control.popmenu( w_main_frame.pointerx() , w_main_frame.pointery() ) 		
		end if
	end if
	
	if Gvi_language_direct_change = 1 then 
		 IF  UPPER(DWO.TYPE) = 'TEXT' THEN
			 OPENWITHPARM( W_DUAL_LANGUAGE_POPUP ,  string(dwo.text) )
			 RETURN
		END IF
	end if
	
	IF  UPPER(dwo.type ) = 'COLUMN' THEN 
		     if  this.Describe(dwo.name+".TabSequence") ='0' or   this.Describe(dwo.name+".Protect") = '1' then 
				return
			end if
		
			IF  Upper(this.describe( dwo.name+".ColType")) = 'DATE'  OR Upper(this.describe( dwo.name+".ColType")) = 'DATETIME' THEN 
				
				OPEN(W_CALENDAR_POPUP )
				
				if  Message.Stringparm = '' or isnull( Message.Stringparm) then 
				else
					lvs_date = message.stringparm
					dwo.Primary[row] = datetime( date(lvs_date))
				end if
			ELSEIF Upper(this.describe( dwo.name+".ColType")) = 'NUMBER'  or Mid( Upper(this.describe( dwo.name+".ColType")),1,3)  = 'DEC'  THEN
				  
				  OPENWITHPARM( W_NUMBER_PAD_POPUP , THIS.GETITEMNUMBER( ROW , string(dwo.name))) 
				  if gst_return.gvb_return = true then
					dwo.primary[row] = Dec(message.doubleparm)
				  else
				  end if							
			END IF


	END IF	
	
end if
end event

event retrieveend;if ivs_retrice_cancel_popup_open = 'Y' then 
	
	IF ISVALID(W_CANCEL_RETRIEVE_POP) THEN
		CLOSE(W_CANCEL_RETRIEVE_POP)
	ELSE
		
	END IF
	
	if  setrow = 0 then
		F_MSG_MDI_HELP ( F_MSG_ST( 117)  )
		THIS.SETFOCUS()		
		RETURN
	else
		F_MSG_MDI_HELP( F_MSG_ST1( 9013 , string(setrow) ))
		THIS.SCROLLTOROW(1)	
		THIS.SETFOCUS()
		RETURN
	end if
else
		F_MSG_MDI_HELP( F_MSG_ST1( 9013 , string(setrow) ))
		THIS.SCROLLTOROW(1)	
		THIS.SETFOCUS()
		RETURN	
end if 

end event

event retrieverow;if ivs_retrice_cancel_popup_open = 'Y' then 
	
	setrow++
	F_MSG_MDI_HELP( string(setrow)+" Rows Retrieve.." )
	
	IF ISVALID(W_CANCEL_RETRIEVE_POP) THEN 
		
		W_CANCEL_RETRIEVE_POP.SLE_RETRIEVED_ROWS.TEXT = STRING(SETROW)
	
	ELSE
		 THIS.Modify("DataWindow.Retrieve.AsNeeded=No")	
		 THIS.DBCANCEL()	 
		 RETURN 1
	END IF
ELSE 
	
		setrow++
	
end if 
end event

event retrievestart;IF ivs_modify_security = 'Y' THEN
		
		IF THIS.MODIFIEDCOUNT() > 0 OR DELETEDCOUNT() > 0 THEN 
			
			Msg = F_MSGBOX1( 9014 , String(THIS.MODIFIEDCOUNT()+THIS.DELETEDCOUNT()))
			
			if Msg = 1 then 	
				
				Gvs_Ue_DATA_control = 'UPDATE'
				Parent.Triggerevent("UE_DATA_CONTROL")
				
			ELSEIF Msg = 2 then 	
				
			ELSE
				 RETURN -1 
			END IF 
			
		END IF
		
	END IF
		
if ivs_retrice_cancel_popup_open = 'Y' then 
	
		SETROW = 0 
		IF ISVALID(W_CANCEL_RETRIEVE_POP) THEN
			CLOSE(W_CANCEL_RETRIEVE_POP)
		ELSE
			IF  ivs_retrice_cancel_popup_open = 'Y' THEN 
				OPEN(W_CANCEL_RETRIEVE_POP)
			END IF
		END IF
	else
				SETROW = 0 
end if 
end event

event rowfocuschanged;LONG I
IF currentrow = 0  or gvs_deleteselecte_mod = 'Y' THEN RETURN

IF ivs_selected_row_yn = 'Y' THEN 

		if keydown(keycontrol!) then 
			
		elseif keydown(keyshift!) then 
			
			IF  CURRENTROW > Gvl_CurrentRow THEN 
			          I = Gvl_CurrentRow
					DO
						I++
						
						THIS.SELECTROW(I , TRUE )

					LOOP UNTIL  I = CURRENTROW
			ELSE
				
			          I = Gvl_CurrentRow
					DO
						I = I - 1
						
						THIS.SELECTROW(I , TRUE )

					LOOP UNTIL  I = CURRENTROW				
				
			END IF		
			
		else
			THIS.SELECTROW(0 , FALSE )		
		end if
		
		THIS.SELECTROW(currentrow , TRUE )
		THIS.SETROW(currentrow)

END IF

Gvl_CurrentRow = currentrow		
RETURN 1 


end event

event sqlpreview;Gvs_last_sqlsyntax = sqlsyntax
end event

event updateend;if rowsdeleted + rowsupdated + rowsinserted = 0 then 
	return
end if

Gst_return.Gvf_return[1] = rowsinserted
Gst_return.Gvf_return[2] = rowsupdated
Gst_return.Gvf_return[3] = rowsdeleted
	
openwithparm(w_updateend_message_ontime , 0.5 )

end event

event updatestart;SETPOINTER(HourGlass!)
end event

event itemchanged;if THIS.AcceptText() = -1 then
	return
end if

//=============================================
// $$HEX11$$c0bcbdacacc06dd52000eccefcb712ac200024c115c8$$ENDHEX$$
//=============================================
IF ivs_modify_security = 'Y' THEN 
	F_SET_SECURITY_ROW( THIS , ROW , 'MODIFY' )
END IF

IF ivs_modify_mark = 'Y' THEN

	string ls_ColName , ls_text
	ls_ColName = this.GetColumnName()+'_t'
	ls_text = trim(this.describe(ls_ColName + ".text"))
	IF MID(ls_text,1,1) = '*' THEN 
	ELSE
		ls_text = '*'+ls_text
	END IF
	
	
	this.modify(ls_ColName + ".text = '" + ls_text + "'")
	
END IF
end event

event itemerror;f_MSGBOX1( 174 , DATA )
RETURN 1
end event

event itemfocuschanged; ls_anydata = dwo
if Gvs_popup_auto_active = 'Y' THEN
	TRIGGER EVENT RBUTTONDOWN( 0 , 0 , ROW , DWO )
end if
end event

