HA$PBExportHeader$w_graph_root.srw
$PBExportComments$$$HEX9$$f8ad98b704d508c7c4b3b0c6c8b9a4c2c0d0$$ENDHEX$$
forward
global type w_graph_root from window
end type
type rb_count from radiobutton within w_graph_root
end type
type rb_max from radiobutton within w_graph_root
end type
type rb_sum from radiobutton within w_graph_root
end type
type rb_avg from radiobutton within w_graph_root
end type
type rb_min from radiobutton within w_graph_root
end type
type cbx_count from so_checkbox within w_graph_root
end type
type cbx_data from so_checkbox within w_graph_root
end type
type pb_color from so_picturebutton within w_graph_root
end type
type pb_print from so_picturebutton within w_graph_root
end type
type pb_spacing from so_picturebutton within w_graph_root
end type
type pb_title from so_picturebutton within w_graph_root
end type
type pb_type from so_picturebutton within w_graph_root
end type
type st_label from so_statictext within w_graph_root
end type
type lb_category from listbox within w_graph_root
end type
type st_category from so_statictext within w_graph_root
end type
type st_value from so_statictext within w_graph_root
end type
type plb_value from picturelistbox within w_graph_root
end type
type dw_5 from datawindow within w_graph_root
end type
type dw_4 from datawindow within w_graph_root
end type
type dw_3 from datawindow within w_graph_root
end type
type dw_2 from datawindow within w_graph_root
end type
type dw_1 from datawindow within w_graph_root
end type
type gb_view from so_groupbox within w_graph_root
end type
type gb_process from so_groupbox within w_graph_root
end type
type gr_1 from graph within w_graph_root
end type
end forward

global type w_graph_root from window
integer width = 4567
integer height = 2628
boolean titlebar = true
string title = "Workspace"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 12632256
string icon = "AppIcon!"
boolean center = true
event ue_data_control ( )
event ue_post_open ( )
event ue_unmoved pbm_syscommand
rb_count rb_count
rb_max rb_max
rb_sum rb_sum
rb_avg rb_avg
rb_min rb_min
cbx_count cbx_count
cbx_data cbx_data
pb_color pb_color
pb_print pb_print
pb_spacing pb_spacing
pb_title pb_title
pb_type pb_type
st_label st_label
lb_category lb_category
st_category st_category
st_value st_value
plb_value plb_value
dw_5 dw_5
dw_4 dw_4
dw_3 dw_3
dw_2 dw_2
dw_1 dw_1
gb_view gb_view
gb_process gb_process
gr_1 gr_1
end type
global w_graph_root w_graph_root

type variables
DWObject ls_anydata
Double setrow
int	Ivi_paper

STRING IVS_RESIZE_TYPE
STRING ivs_modify_security='Y'
STRING ivs_modify_mark = 'N'

STRING ivs_dw_1_use_focusindicator ='Y'
STRING ivs_dw_2_use_focusindicator ='N'
STRING ivs_dw_3_use_focusindicator ='N'
STRING ivs_dw_4_use_focusindicator ='N'
STRING ivs_dw_5_use_focusindicator ='N'

STRING ivs_dw_1_selected_row_yn = 'Y' 
STRING ivs_dw_2_selected_row_yn = 'N'
STRING ivs_dw_3_selected_row_yn = 'N'
STRING ivs_dw_4_selected_row_yn = 'N'
STRING ivs_dw_5_selected_row_yn = 'N'

STRING ivs_dw_1_retrice_cancel_popup_open = 'Y'
STRING ivs_dw_2_retrice_cancel_popup_open = 'Y'
STRING ivs_dw_3_retrice_cancel_popup_open = 'Y'
STRING ivs_dw_4_retrice_cancel_popup_open = 'Y'
STRING ivs_dw_5_retrice_cancel_popup_open = 'Y'


STRING ivs_dw_1_deleteselected_yn = 'Y' 
STRING ivs_dw_2_deleteselected_yn = 'Y' 
STRING ivs_dw_3_deleteselected_yn = 'Y' 
STRING ivs_dw_4_deleteselected_yn = 'Y' 
STRING ivs_dw_5_deleteselected_yn = 'Y' 


STRING ivs_set_column_dddw1 = 'N'
STRING ivs_set_column_dddw2 = 'N'
STRING ivs_set_column_dddw3 = 'N'
STRING ivs_set_column_dddw4 = 'N'
STRING ivs_set_column_dddw5 = 'N'

//=====================================
// Free Resize Variable
//=====================================
int ii_win_width, ii_win_height, ii_win_frame_w, ii_win_frame_h
str_size size_ctrl [] 

//Boolean variable to stop recursion
boolean ib_exec = false

//==============================
// ANIMATEWINDOW CONSTASNT
//==============================
CONSTANT LONG AW_HOR_POSITIVE = 1
CONSTANT LONG AW_HOR_NEGATIVE = 2
CONSTANT LONG AW_VER_POSITIVE = 4
CONSTANT LONG AW_VER_NEGATIVE = 8
CONSTANT LONG AW_CENTER = 16
CONSTANT LONG AW_HIDE = 65536
CONSTANT LONG AW_ACTIVATE = 131072
CONSTANT LONG AW_SLIDE = 262144
CONSTANT LONG AW_BLEND = 524288 



STRING 	Ivs_datawindow_resize,	&
			Ivs_print_title

//STRING ivs_retrieve_run = 'N'
//BOOLEAN ivb_dbcancel = FALSE 
//

//
//
//DWObject ls_anydata
//Double setrow
//
//STRING IVS_RESIZE_TYPE
//STRING ivs_modify_security='Y'
//
//STRING ivs_dw_1_use_focusindicator ='Y'
//STRING ivs_dw_2_use_focusindicator ='N'
//STRING ivs_dw_3_use_focusindicator ='N'
//STRING ivs_dw_4_use_focusindicator ='N'
//STRING ivs_dw_5_use_focusindicator ='N'
//
//STRING ivs_dw_1_selected_row_yn = 'Y' 
//STRING ivs_dw_2_selected_row_yn = 'N'
//STRING ivs_dw_3_selected_row_yn = 'N'
//STRING ivs_dw_4_selected_row_yn = 'N'
//STRING ivs_dw_5_selected_row_yn = 'N'
//
//STRING ivs_dw_1_retrice_cancel_popup_open = 'Y'
//STRING ivs_dw_2_retrice_cancel_popup_open = 'Y'
//STRING ivs_dw_3_retrice_cancel_popup_open = 'Y'
//STRING ivs_dw_4_retrice_cancel_popup_open = 'Y'
//STRING ivs_dw_5_retrice_cancel_popup_open = 'Y'
//
//
//STRING ivs_dw_1_deleteselected_yn = 'Y' 
//STRING ivs_dw_2_deleteselected_yn = 'Y' 
//STRING ivs_dw_3_deleteselected_yn = 'Y' 
//STRING ivs_dw_4_deleteselected_yn = 'Y' 
//STRING ivs_dw_5_deleteselected_yn = 'Y' 
//
////=====================================
//// Free Resize Variable
////=====================================
//int ii_win_width, ii_win_height, ii_win_frame_w, ii_win_frame_h
//str_size size_ctrl [] 
//
////Boolean variable to stop recursion
//boolean ib_exec = false
//
end variables

forward prototypes
public function integer wf_set_window_property (string arg_window_name)
public function integer wf_size_it ()
public function integer wf_resize_it (double size_factor)
public subroutine wf_zoom (string as_type)
public subroutine wf_set_listbox ()
public subroutine wf_set_a_series (string as_title, string as_value, string as_category, string as_calc_type)
end prototypes

event ue_data_control();Long Row  , lvl_count
String null_str
window activesheet
DOUBLE  LD_LEN , LD_TEMP , I,  J, K

IF ISVALID( SELECTED_DATA_WINDOW) THEN 
ELSE
	 RETURN
END IF
//====================================================
//
//====================================================
		if ivs_set_column_dddw1 = 'Y' then 
		else
		   f_set_column_dddw( dw_1 )
		   ivs_set_column_dddw1 = 'Y'		
		end if
		
		if ivs_set_column_dddw2 = 'Y' then 
		else
		   f_set_column_dddw( dw_2 )
		   ivs_set_column_dddw2 = 'Y'		
		end if
		if ivs_set_column_dddw3 = 'Y' then 
		else
		   f_set_column_dddw( dw_3 )
		   ivs_set_column_dddw3 = 'Y'		
		end if
		if ivs_set_column_dddw4 = 'Y' then 
		else
		   f_set_column_dddw( dw_4 )
		   ivs_set_column_dddw4 = 'Y'		
		end if
		if ivs_set_column_dddw5 = 'Y' then 
		else
		   f_set_column_dddw( dw_5 )
		   ivs_set_column_dddw5 = 'Y'		
		end if
		
//		if isvalid(w_item_search_flat) then 
//			close(w_item_search_flat)
//		end if 
//====================================================
//
//====================================================
CHOOSE CASE Gvs_ue_data_control
		
	CASE 'RETRIEVE'
			SETPOINTER(HOURGLASS!)
			
	CASE 'DYNAMIC RETRIEVE'
		
		    Gst_return.Gvs_return[1] = selected_window.Classname()
		    Gst_return.Gvs_return[2] = selected_data_window.Classname()			 
			 
      //        OPENWITHPARM( w_dynamic_where_condition_popup  , SELECTED_DATA_WINDOW )
				
	CASE 'SELECTALL'
			
         ROW = 0 
		    DO
				 ROW++
				 selected_data_window.SETITEM( ROW , 'check_yn' ,'Y')

         LOOP UNTIL ROW = selected_data_window.ROWCOUNT()
			
   CASE 'RELEASEALL'		
		
         ROW = 0 
		    DO
				 ROW++
				 selected_data_window.SETITEM( ROW , 'check_yn' ,'N')

         LOOP UNTIL ROW = selected_data_window.ROWCOUNT()		
	
	CASE 'FIRSTROW'			
			selected_data_window.SCROLLTOROW(1)
	CASE 'NEXTPAGE'					
			selected_data_window.SCROLLNEXTPAGE()
	CASE 'PREVPAGE'					
			selected_data_window.SCROLLPRIORPAGE()						
	CASE 'LASTROW'					
			selected_data_window.SCROLLTOROW(selected_data_window.ROWCOUNT())		
			
	CASE 'CANCEL'
	   	CLOSE(W_CANCEL_RETRIEVE_POP)
			DW_1.DBCANCEL()
			DW_2.DBCANCEL()
			DW_3.DBCANCEL()			
			DW_4.DBCANCEL()			
			DW_5.DBCANCEL()			
			GVS_DB_CANCEL = 'N'
			
	CASE 'UNDO'		

         IF selected_data_window.CANUNDO() THEN 
             selected_data_window.UNDO()
		END IF
			
	CASE 'SORT'
			f_sort()
	CASE 'FILTER'		
		
				SetNull(null_str)
				gst_return.gvs_return[1] = selected_data_window.classname()
				openwithparm(w_set_filter , selected_data_window)
			
	CASE 'DELETESELECTED' 
			       
				if selected_data_window.classname() = 'dw_1' and ivs_dw_1_deleteselected_yn = 'N' then 
					f_msgbox(100)			
					return			
				elseif selected_data_window.classname() = 'dw_2' and ivs_dw_2_deleteselected_yn = 'N' then 
					f_msgbox(100)								
					return
				elseif selected_data_window.classname() = 'dw_3' and ivs_dw_3_deleteselected_yn = 'N' then 
					f_msgbox(100)								
					return
				elseif selected_data_window.classname() = 'dw_4' and ivs_dw_4_deleteselected_yn = 'N' then 
					f_msgbox(100)								
					return
				elseif selected_data_window.classname() = 'dw_5' and ivs_dw_5_deleteselected_yn = 'N' then 
					f_msgbox(100)								
					return						  
				end if
				
			    open(w_progress_popup)
			       gvs_deleteselecte_mod = 'Y'
				lvl_count =  selected_data_window.rowcount()
				w_progress_popup.f_set_range( 0 ,  lvl_count )
				w_progress_popup.f_setstep(1)					
				w_progress_popup.f_set_message(string(selected_data_window))
				I = 1  ; k = 0 ; j = 0 
				do
					k++
					IF selected_data_window.isselected(i) THEN 
					     j++
					     selected_data_window.deleterow(i)
					ELSE
						 i++
					END IF
					
					 w_progress_popup.f_stepit()
				
			loop until k = lvl_count

		     Close(w_progress_popup)
//================================================
//
//================================================

	     	       MSG = F_MSGBOX1( 9030 , STRING(J))
			IF MSG = 1 THEN 
				if selected_data_window.Update() < 0 then 
					Rollback;
					Return
				else
					Commit;
				end if
			ELSE	
				
                    F_RETRIEVE()
						  
			END IF
			gvs_deleteselecte_mod = 'N'
			
			
	CASE 'UNDELETE'
		
			row = selected_data_window.DeletedCount()
			IF ROW < 1 THEN RETURN 
			    selected_data_window.SetRedraw(false)
			   if selected_data_window.RowsMove(1, row, delete!, selected_data_window, 1, primary!) = -1 then
				
				F_MSGBOX(9019) //$$HEX4$$f5bc6cade4c228d3$$ENDHEX$$
				
			   else
				selected_data_window.SetFocus()
				selected_data_window.ScrollToRow(Gvl_row_deleted)
				selected_data_window.SetColumn(1)
			   end if
			
				selected_data_window.ResetUpdate()
				selected_data_window.SetRedraw(true)
				Gvl_row_deleted = 0
			
	CASE 'REFRESH'						
			selected_data_window.GROUPCALC()	
			
	CASE 'RESET'			
			Msg=f_msgbox( 184) //("Check Confirm" , "Note : Window Screen Clear ?" , stopsign! , yesno! )
			if Msg = 1 then 
				selected_data_window.Reset()
			end if

	CASE 'ROWCOPY'
			LONG LVS_ROW 
			
			DATAWINDOW LVS_DATAWINDOW
			LVS_DATAWINDOW = selected_data_window
			
   		   Msg= F_MSGBOX( 9016 ) //$$HEX10$$f5bcacc0200058d5dcc2a0acb5c2c8b24cae2000$$ENDHEX$$?
			
		   IF MSG = 1 THEN 
				selected_data_window = LVS_DATAWINDOW
				selected_data_window.selectrow( 0 , FALSE)
				LVS_ROW  = selected_data_window.GetRow()
				
				IF selected_data_window = LVS_DATAWINDOW THEN 
					selected_data_window.RowsCopy(selected_data_window.GetRow(), selected_data_window.GetRow(), Primary!, selected_data_window, selected_data_window.GetRow(), Primary!)
					selected_data_window.SCROLLTOROW(LVS_ROW)
					selected_data_window.SELECTROW(LVS_ROW , TRUE)
				ELSE
					 MESSAGEBOX("Error" ,"Datawindow Changed...")
				END IF				
			ELSE
				 RETURN
			END IF
			
	CASE 'ROWSCOPY'
			Msg= F_MSGBOX( 9016 ) //$$HEX10$$f5bcacc0200058d5dcc2a0acb5c2c8b24cae2000$$ENDHEX$$?
			if Msg = 1 then 
				selected_data_window.RowsCopy(selected_data_window.GetRow(), selected_data_window.rowcount() , Primary!, selected_data_window, 1, Primary!)
                    end if
			
     	CASE 'BASECODE RELOAD'			
				activesheet = w_main_frame.GetActiveSheet( )
				Selected_window = activesheet
				
				IF IsValid(activesheet) THEN			    
					activesheet.TRIGGEREVENT('UE_POST_OPEN')
					f_set_column_dddw( dw_1 )
					f_set_column_dddw( dw_2 )
					f_set_column_dddw( dw_3 )
					f_set_column_dddw( dw_4 )
					f_set_column_dddw( dw_5 )					
				END IF

		CASE 'SAVEASEXCEL'

				activesheet = w_main_frame.GetActiveSheet( )
				Selected_window = activesheet
				
				IF IsValid(activesheet) THEN
							
							string  li_Filename ,docname, named
							integer li_FileNum  ,value  , li_ret
							long    ll_FLength 
							boolean lb_exist
				

							 
							 
							Msg = 1
							if Msg = 1 then 
							   SETPOINTER(HOURGLASS!)		
									li_ret = GetFileSaveName("Select Excel File," , docname, named, "xls", "Excel Files (*.xls),*.xls")		

										IF li_ret = 1 THEN 
									
												li_FileNum = FileOpen( docname ,StreamMode!, Write!, Shared!, Append! , EncodingUTF8! )

												
												LD_LEN = LEN(SELECTED_DATA_WINDOW.Describe("DataWindow.Data.HTMLtable"))
												f_msgbox1( 183 , STRING(LD_LEN))
												//("Notify" , 'File Size ='+STRING(LD_LEN))
												J = 1 
												K = 32765
												
												FOR I = 1 TO 4294967295										
													IF LD_LEN > K THEN 
				
														IF FileWrite(li_FileNum, MID(SELECTED_DATA_WINDOW.Describe("DataWindow.Data.HTMLtable"),J, J + 32765) ) <> 1 THEN 
														ELSE
															F_MSGBOX(173)
															RETURN
														END IF
													ELSE
				
				                                             IF J >= 32765 AND LD_LEN < K THEN 
														     Fileclose(li_FileNum)	
                                                                           F_MSGBOX(170) ;
														     SETPOINTER(ARROW!)															
															EXIT
														END IF
																						
														IF FileWrite(li_FileNum, MID(SELECTED_DATA_WINDOW.Describe("DataWindow.Data.HTMLtable"),J, LD_LEN) ) <> 1 THEN 
															Fileclose(li_FileNum)			
														ELSE
															F_MSGBOX(173)
															RETURN
														END IF
														
														F_MSGBOX(170) ;
														SETPOINTER(ARROW!)
														EXIT 
													END IF
													
													J = J + 32765
													
													K = J + 32765 
													F_MSG_MDI_HELP( STRING(K) )
												NEXT
										END IF
							END IF
				END IF					
			
	CASE 'EXPANDALL'
			 SELECTED_DATA_WINDOW.EXpandall( )
		CASE 'COLLAPSEALL' 
			 SELECTED_DATA_WINDOW.Collapseall( )			
	CASE ELSE
END CHOOSE
end event

event ue_post_open();/***********************************************************
* DATA WINDOW SIZE $$HEX2$$c0bcbdac$$ENDHEX$$
************************************************************/

IF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL_1_G_2345' THEN //1345_2

     dw_1.resize(width  - dw_1.x -34, dw_1.height )			
     gr_1.resize(width   - gr_1.x  -34 , HEIGHT - ( gr_1.y +  120))
	 
//     dw_2.y = gr_1.y + gr_1.height 
//     dw_2.resize(width  - dw_2.x -34 , dw_2.height )			
	 
ELSEIF UPPER(IVS_RESIZE_TYPE) = 'GRAPH' THEN //GR_1_DW_1-DW_5
	
	gr_1.resize(width - gr_1.x -34, height - ( gr_1.y + dw_1.height +120 ))
	
	dw_1.y = gr_1.y + gr_1.HEIGHT
     dw_1.resize(width - dw_1.x -34, dw_1.height )		  
	dw_2.y = gr_1.y + gr_1.HEIGHT
     dw_2.resize(width - dw_2.x -34, dw_2.height )		  	  
	  
	dw_3.y = gr_1.y + gr_1.HEIGHT
     dw_3.resize(width - dw_3.x -34, dw_3.height )	
	  
	dw_4.y = gr_1.y + gr_1.HEIGHT
     dw_4.resize(width - dw_4.x -34, dw_4.height )	
	  
	dw_5.y = gr_1.y + gr_1.HEIGHT
     dw_5.resize(width - dw_5.x -34, dw_5.height )	
	  
ELSEIF UPPER(IVS_RESIZE_TYPE) = 'FREEFORM' THEN
	
////////////////////////////////////////////////////////////////////////////////////////////////////
// resize script for w_scale
////////////////////////////////////////////////////////////////////////////////////////////////////
		
		double ratiow, ratio, ratioh
		int rc
		
		// recalculate the new ratios and then use the minimum
		if ib_exec then  // Check to see if wf_resize_it is already running.
			ratioh  = this.height /ii_win_height
			ratiow = this.width / ii_win_width
			ratio = min (ratioh, ratiow)
			rc = wf_resize_it(ratio)  //RATIO = SIZE FACTOR
		end if	  	  
END IF

/*********************************************************
* $$HEX19$$e4b26dadb4c5200098ccacb97cb9200004c75cd5200090c7ccb8200088bdecb724c630ae2000$$ENDHEX$$: w_genapp_frame$$HEX5$$d0c51cc1200020c1b8c5$$ENDHEX$$
* $$HEX16$$74c7f3acd0c51cc194b22000c0bc58d6200091c7c5c5ccb9200018c289d568d5$$ENDHEX$$
* BY KIM, YONG-CHUL
**********************************************************/
if	Gvs_language =	'C' or Gvs_language = 'K' then

	if gds_dual.rowcount() < 1 then 
		f_msgbox(136) //There is not a possibility of knowing multi national language information		
//		("Error" , "Language Info Not Found ")
		return
	else
		F_MSG_MDI_HELP( "Dual Source "+string(gds_dual.rowcount())+" Rows Found" )
	end if
  
	w_main_frame.SetMicroHelp("Language Change...")
	
	f_dual_lang_change_text(this)
	
	w_main_frame.SetMicroHelp("Language Change Done.")
	  	
end if

//====================================================
// $$HEX14$$70b374c7c0d0200008c7c4b3b0c62000a4c2c0d07cc72000c0bcbdac$$ENDHEX$$
//====================================================
if     Gvs_border_style = '2' then 
       dw_1.Borderstyle = StyleBox!
       dw_2.Borderstyle = StyleBox!
       dw_3.Borderstyle = StyleBox!		 
       dw_4.Borderstyle = StyleBox!		 
       dw_5.Borderstyle = StyleBox!		 		 
elseif Gvs_border_style = '5' then 
       dw_1.Borderstyle = StyleLowered!
       dw_2.Borderstyle = StyleLowered!
       dw_3.Borderstyle = StyleLowered!		 
       dw_4.Borderstyle = StyleLowered!		 
       dw_5.Borderstyle = StyleLowered!		
elseif Gvs_border_style = '6' then 
       dw_1.Borderstyle = StyleRaised!
       dw_2.Borderstyle = StyleRaised!
       dw_3.Borderstyle = StyleRaised!		 
       dw_4.Borderstyle = StyleRaised!		 
       dw_5.Borderstyle = StyleRaised!		 		 
end if

//========================================================
// $$HEX13$$70b374c7c0d0200008c7c4b3b0c62000ecceecb72000c0bcbdac$$ENDHEX$$
//========================================================
if ISNULL(Gvs_datawindow_color)  or  Gvs_datawindow_color = '' then 
else
dw_1.modify("datawindow.color = '"+Gvs_datawindow_color+"'")
dw_2.modify("datawindow.color = '"+Gvs_datawindow_color+"'")
dw_3.modify("datawindow.color = '"+Gvs_datawindow_color+"'")
dw_4.modify("datawindow.color = '"+Gvs_datawindow_color+"'")
dw_5.modify("datawindow.color = '"+Gvs_datawindow_color+"'")
end if

IF ivs_dw_1_use_focusindicator = 'Y' THEN
	dw_1.SETROWFOCUSINDICATOR( HAND!)
END IF
IF ivs_dw_2_use_focusindicator = 'Y' THEN
	dw_2.SETROWFOCUSINDICATOR( HAND!)
END IF

IF ivs_dw_3_use_focusindicator = 'Y' THEN
	dw_3.SETROWFOCUSINDICATOR( HAND!)
END IF

IF ivs_dw_4_use_focusindicator = 'Y' THEN
	dw_4.SETROWFOCUSINDICATOR( HAND!)
END IF

IF ivs_dw_5_use_focusindicator = 'Y' THEN
	dw_5.SETROWFOCUSINDICATOR( HAND!)
END IF

close(w_please_wait_popup)

//=================================
//
//=================================
//if isvalid(w_collapsemenu) then 
//	if  w_collapsemenu.ib_locked = false then
//	   w_collapsemenu.pb_close.triggerevent(clicked!)
//	end if 
//end if 
//=================================
// $$HEX15$$68d518c2d0c51cc12000edd000ad28b82000acc06dd5200098ccacb92000$$ENDHEX$$
//=================================

//GVI_OPENTAB_COUNT ++

end event

event ue_unmoved;CHOOSE CASE commandtype
	CASE 61456, 61458
		message.processed = true
		message.returnvalue = 0
END CHOOSE

return

end event

public function integer wf_set_window_property (string arg_window_name);  SELECT UPPER(:ARG_WINDOW_NAME) , UPPER(DECODE( :GVS_LANGUAGE , 'K' ,  WINDOW_DESCRIPTION_KOR,  'E' ,  WINDOW_DESCRIPTION_ENG , WINDOW_DESCRIPTION_LOCAL )) WINDOW_DESCRIPTION ,
               UPPER(WINDOW_TYPE),
			VERSION
    INTO  :Gst_set.window_id,   
	          :Gst_set.window_comment,   
               :Gst_set.window_type,
               :Gst_set.version
    FROM ISYS_WINDOW  
	WHERE WINDOW_NAME     = UPPER(:ARG_WINDOW_NAME)
	  AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;

IF F_SQL_CHECK() < 0 THEN 
	 RETURN -1
ELSE

END IF

IF SQLCA.SQLCODE = 100 THEN 
	Gst_set.window_id =    UPPER(ARG_WINDOW_NAME)
	Gst_set.window_title     = W_MAIN_FRAME.GETACTIVESHEET().title
     Gst_set.window_comment   = 'Unknown'   
     Gst_set.window_type      = 'None'
     Gst_set.version	       = 0

ELSE
	
	Gst_set.window_title     = W_MAIN_FRAME.GETACTIVESHEET().title
	
END IF

//======================================================================
//
//======================================================================
STRING LVS_WINDOW_NAME , LVS_DATAWINDOW_NAME , LVS_OBJECT_TYPE
STRING LVS_COLUMN_NAME , LVS_VISIBLE_YN , LVS_WIDTH , LVS_HEIGHT , LVS_FORMAT , LVS_EDITMASK
STRING LVS_OBJECT_X1 , LVS_OBJECT_X2 , LVS_OBJECT_Y1 , LVS_OBJECT_Y2 , LVS_OBJECT_ALIGNMENT
STRING LVS_COLUMN_ORDER , LVS_SPARSE , LVS_SPARSE_YN

INT I , J  
DECLARE CL1 CURSOR FOR
 SELECT OBJECT_TYPE , WINDOW_NAME  , DATAWINDOW_NAME , COLUMN_NAME , VISIBLE_YN , 
              COLUMN_WIDTH , COLUMN_HEIGHT , COLUMN_FORMAT , EDITMASK , COLUMN_ORDER , 
		    OBJECT_X1 , OBJECT_X2  , OBJECT_Y1 , OBJECT_Y2,  SPARSE , OBJECT_ALIGN
   FROM ISYS_WINDOW_PROPERTY
 WHERE WINDOW_NAME = UPPER(:ARG_WINDOW_NAME)
      AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
ORDER BY 	ORGANIZATION_ID , WINDOW_NAME , DATAWINDOW_NAME ,OBJECT_TYPE , TO_NUMBER(DECODE( OBJECT_X1 , '?' , -1 , OBJECT_X1 ))	 ASC ;

OPEN CL1 ;
	IF F_SQL_CHECK_WITH_MSG('CURSOR OPEN') < 0 THEN 
         RETURN -1
	END IF
DO
	I++
	
	FETCH CL1   INTO :LVS_OBJECT_TYPE , :LVS_WINDOW_NAME , :LVS_DATAWINDOW_NAME , :LVS_COLUMN_NAME , :LVS_VISIBLE_YN  , :LVS_WIDTH ,:LVS_HEIGHT , :LVS_FORMAT ,
	                              :LVS_EDITMASK , :LVS_COLUMN_ORDER , :LVS_OBJECT_X1 , :LVS_OBJECT_X2 , :LVS_OBJECT_Y1 , :LVS_OBJECT_Y2 , 
							:LVS_OBJECT_ALIGNMENT , :LVS_SPARSE_YN;
	IF F_SQL_CHECK() < 0 THEN 
		CLOSE CL1;
		EXIT
	END IF
	IF SQLCA.SQLCODE = 100 THEN 
		CLOSE CL1;
		EXIT
	END IF
	
	IF  UPPER(LVS_DATAWINDOW_NAME) = 'DW_1' THEN

			IF  UPPER(LVS_OBJECT_TYPE) = 'COLUMN' THEN

						DW_1.Modify(LVS_COLUMN_NAME + ".Format='"+LVS_FORMAT+"'")	
						DW_1.Modify(LVS_COLUMN_NAME + ".Alignment='"+LVS_OBJECT_ALIGNMENT+"'")							
						
						if lvs_visible_yn = '0' THEN 
							DW_1.Modify(LVS_COLUMN_NAME + ".Visible='"+lvs_visible_yn+"'")		
						end if
						
						DW_1.Modify(LVS_COLUMN_NAME + ".width='"+lvs_width+"'")			
						DW_1.Modify(LVS_COLUMN_NAME + ".height='"+lvs_height+"'")									
						
						IF LONG(LVS_COLUMN_ORDER) < 0  OR LVS_COLUMN_ORDER = '?' OR ISNULL(LVS_COLUMN_ORDER) THEN 
						ELSE
							DW_1.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")									
							DW_1.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																
						END IF
								
						IF lvs_editmask <> '?' THEN 
							DW_1.Modify(LVS_COLUMN_NAME + ".EditMask.Mask='"+lvs_editmask+"'")		
						END IF
						
						IF LVS_SPARSE_YN = 'Y' THEN 
									J++
							IF J = 1 THEN 
								  lvs_sparse = lvs_sparse + LVS_COLUMN_NAME
							ELSE 
								 lvs_sparse = lvs_sparse + '~t'+LVS_COLUMN_NAME
							END IF
							
						END IF 
						
			ELSEIF LVS_OBJECT_TYPE = 'TEXT' THEN 

						DW_1.Modify(LVS_COLUMN_NAME + ".Format='"+LVS_FORMAT+"'")	
						DW_1.Modify(LVS_COLUMN_NAME + ".Alignment='"+LVS_OBJECT_ALIGNMENT+"'")							
						
						if lvs_visible_yn = '0' THEN 
							DW_1.Modify(LVS_COLUMN_NAME + ".Visible='"+lvs_visible_yn+"'")		
						end if
						
						DW_1.Modify(LVS_COLUMN_NAME + ".width='"+lvs_width+"'")			
						DW_1.Modify(LVS_COLUMN_NAME + ".height='"+lvs_height+"'")		
						
						IF LONG(LVS_COLUMN_ORDER) < 0  OR LVS_COLUMN_ORDER = '?' OR ISNULL(LVS_COLUMN_ORDER) THEN 
						ELSE
							DW_1.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")		
							DW_1.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																							
						END IF
				
			ELSEIF LVS_OBJECT_TYPE = 'COMPUTE' THEN 	
				
						DW_1.Modify(LVS_COLUMN_NAME + ".Format='"+LVS_FORMAT+"'")	
						DW_1.Modify(LVS_COLUMN_NAME + ".Alignment='"+LVS_OBJECT_ALIGNMENT+"'")						
						
						if lvs_visible_yn = '0' THEN 
							DW_1.Modify(LVS_COLUMN_NAME + ".Visible='"+lvs_visible_yn+"'")		
						end if
						
						DW_1.Modify(LVS_COLUMN_NAME + ".width='"+lvs_width+"'")		
						DW_1.Modify(LVS_COLUMN_NAME + ".height='"+lvs_height+"'")								
						
						IF LONG(LVS_COLUMN_ORDER) < 0  OR LVS_COLUMN_ORDER = '?' OR ISNULL(LVS_COLUMN_ORDER) THEN 
						ELSE
							DW_1.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")		
							DW_1.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																							
						END IF
								
						IF lvs_editmask <> '?' THEN 
							DW_1.Modify(LVS_COLUMN_NAME + ".EditMask.Mask='"+lvs_editmask+"'")		
						END IF
						
						IF LVS_SPARSE_YN = 'Y' THEN 
									J++
							IF J = 1 THEN 
								  lvs_sparse = lvs_sparse + LVS_COLUMN_NAME
							ELSE 
								 lvs_sparse = lvs_sparse + '~t'+LVS_COLUMN_NAME
							END IF
							
						END IF 				
				
			ELSEIF LVS_OBJECT_TYPE = 'LINE' THEN 	
				
						
						if lvs_visible_yn = '0' THEN 
							DW_1.Modify(LVS_COLUMN_NAME + ".Visible='"+lvs_visible_yn+"'")		
						end if

						DW_1.Modify(LVS_COLUMN_NAME + ".x1='"+LVS_OBJECT_X1+"'")									
						DW_1.Modify(LVS_COLUMN_NAME + ".x2='"+LVS_OBJECT_X2+"'")									
						DW_1.Modify(LVS_COLUMN_NAME + ".y1='"+LVS_OBJECT_Y1+"'")									
						DW_1.Modify(LVS_COLUMN_NAME + ".y2='"+LVS_OBJECT_Y2+"'")															
 				
				
			ELSEIF LVS_OBJECT_TYPE = 'RECTANGLE' THEN
				
			END IF
//================================================================================
//
//================================================================================
	ELSEIF UPPER(LVS_DATAWINDOW_NAME) = 'DW_2' THEN 
		
			DW_2.Modify(LVS_COLUMN_NAME + ".Format='"+LVS_FORMAT+"'")	
			DW_2.Modify(LVS_COLUMN_NAME + ".Visible='"+lvs_visible_yn+"'")		
			DW_2.Modify(LVS_COLUMN_NAME + ".width='"+lvs_width+"'")				
			IF LVS_COLUMN_ORDER = '0' OR LVS_COLUMN_ORDER = '?' OR ISNULL(LVS_COLUMN_ORDER) THEN 
			ELSE
				DW_2.Modify(LVS_COLUMN_NAME + ".X='"+LVS_COLUMN_ORDER+"'")									
			END IF
			
			IF lvs_editmask <> '?' THEN 
				DW_2.Modify(LVS_COLUMN_NAME + ".EditMask.Mask='"+lvs_editmask+"'")		
			END IF
			
			IF LVS_SPARSE_YN = 'Y' THEN 
						J++
				IF J = 1 THEN 
					  lvs_sparse = lvs_sparse + LVS_COLUMN_NAME
				ELSE 
					 lvs_sparse = lvs_sparse + '~t'+LVS_COLUMN_NAME
				END IF
			END IF 
			
	ELSEIF UPPER(LVS_DATAWINDOW_NAME) = 'DW_3' THEN 		
			DW_3.Modify(LVS_COLUMN_NAME + ".Format='"+LVS_FORMAT+"'")	
			DW_3.Modify(LVS_COLUMN_NAME + ".Visible='"+lvs_visible_yn+"'")		
			DW_3.Modify(LVS_COLUMN_NAME + ".width='"+lvs_width+"'")				  				
			
			IF LVS_COLUMN_ORDER = '0' OR LVS_COLUMN_ORDER = '?' OR ISNULL(LVS_COLUMN_ORDER) THEN 
			ELSE
				DW_3.Modify(LVS_COLUMN_NAME + ".X='"+LVS_COLUMN_ORDER+"'")									
			END IF
			
			IF lvs_editmask <> '?' THEN 
				DW_3.Modify(LVS_COLUMN_NAME + ".EditMask.Mask='"+lvs_editmask+"'")		
			END IF
			IF LVS_SPARSE_YN = 'Y' THEN 
						J++
				IF J = 1 THEN 
					  lvs_sparse = lvs_sparse + LVS_COLUMN_NAME
				ELSE 
					 lvs_sparse = lvs_sparse + '~t'+LVS_COLUMN_NAME
				END IF
			END IF 



	ELSEIF UPPER(LVS_DATAWINDOW_NAME) = 'DW_4' THEN 		
			DW_4.Modify(LVS_COLUMN_NAME + ".Format='"+LVS_FORMAT+"'")	
			DW_4.Modify(LVS_COLUMN_NAME + ".Visible='"+lvs_visible_yn+"'")		
			DW_4.Modify(LVS_COLUMN_NAME + ".width='"+lvs_width+"'")				  				
			
			IF LVS_COLUMN_ORDER = '0' OR LVS_COLUMN_ORDER = '?' OR ISNULL(LVS_COLUMN_ORDER) THEN 
			ELSE
				DW_4.Modify(LVS_COLUMN_NAME + ".X='"+LVS_COLUMN_ORDER+"'")									
			END IF
			
			IF lvs_editmask <> '?' THEN 
				DW_4.Modify(LVS_COLUMN_NAME + ".EditMask.Mask='"+lvs_editmask+"'")		
			END IF
			IF LVS_SPARSE_YN = 'Y' THEN 
						J++
				IF J = 1 THEN 
					  lvs_sparse = lvs_sparse + LVS_COLUMN_NAME
				ELSE 
					 lvs_sparse = lvs_sparse + '~t'+LVS_COLUMN_NAME
				END IF
			END IF 

	ELSEIF UPPER(LVS_DATAWINDOW_NAME) = 'DW_5' THEN 		
			DW_5.Modify(LVS_COLUMN_NAME + ".Format='"+LVS_FORMAT+"'")	
			DW_5.Modify(LVS_COLUMN_NAME + ".Visible='"+lvs_visible_yn+"'")		
			DW_5.Modify(LVS_COLUMN_NAME + ".width='"+lvs_width+"'")				  				
			
			IF LVS_COLUMN_ORDER = '0' OR LVS_COLUMN_ORDER = '?' OR ISNULL(LVS_COLUMN_ORDER) THEN 
			ELSE
				DW_5.Modify(LVS_COLUMN_NAME + ".X='"+LVS_COLUMN_ORDER+"'")									
			END IF
			
			IF lvs_editmask <> '?' THEN 
				DW_5.Modify(LVS_COLUMN_NAME + ".EditMask.Mask='"+lvs_editmask+"'")		
			END IF
			IF LVS_SPARSE_YN = 'Y' THEN 
						J++
				IF J = 1 THEN 
					  lvs_sparse = lvs_sparse + LVS_COLUMN_NAME
				ELSE 
					 lvs_sparse = lvs_sparse + '~t'+LVS_COLUMN_NAME
				END IF
			END IF 

END IF 	
	
LOOP UNTIL 1 = 2

IF LVS_sparse = '' OR LEN(LVS_sparse) = 0 THEN 
ELSE
	
	IF UPPER(LVS_DATAWINDOW_NAME)  = 'DW_1'  THEN 
		DW_1.Modify("DATAWINDOW.SPARSE='"+LVS_sparse+"'")
	ELSEIF UPPER(LVS_DATAWINDOW_NAME)  = 'DW_2'  THEN 	
		DW_2.Modify("DATAWINDOW.SPARSE='"+LVS_sparse+"'")	
	ELSEIF UPPER(LVS_DATAWINDOW_NAME)  = 'DW_3'  THEN 		
		DW_3.Modify("DATAWINDOW.SPARSE='"+LVS_sparse+"'")	
	ELSEIF UPPER(LVS_DATAWINDOW_NAME)  = 'DW_4'  THEN 		
		DW_4.Modify("DATAWINDOW.SPARSE='"+LVS_sparse+"'")	
	ELSEIF UPPER(LVS_DATAWINDOW_NAME)  = 'DW_5'  THEN 		
		DW_5.Modify("DATAWINDOW.SPARSE='"+LVS_sparse+"'")			
	END IF
END IF

RETURN 0 
end function

public function integer wf_size_it ();////////////////////////////////////////////////////////////////////////////////////////////////////
// function: wf_size_it
////////////////////////////////////////////////////////////////////////////////////////////////////

// save the original sizes of the window and all of the objects on the window
// NOTE !!!! this process does not work on objects that are not descended
// from the dragobject class.

dragobject temp
int cnt,i
ii_win_width  = this.width
ii_win_height = this.height

//ii_win_frame_w = 0
//ii_win_frame_h = 0

ii_win_frame_w = this.width - this.WorkSpaceWidth()
ii_win_frame_h = this.height - this.WorkSpaceHeight()

cnt = upperbound(this.control)
for i = cnt to 1 step -1
	temp = this.control[i]
	
	// everything has a x,y,width and height
	size_ctrl[i].x = temp.x 
	size_ctrl[i].width = temp.width 
	size_ctrl[i].y = temp.y
	size_ctrl[i].height = temp.height 

	// now go get text size information
	choose case typeof(temp)
		case commandbutton!
			commandbutton cb
			cb = temp
			size_ctrl[i].fontsize = cb.textsize 

		case singlelineedit!
			singlelineedit sle
			sle = temp
			size_ctrl[i].fontsize = sle.textsize 

		case editmask!
			editmask em
			em = temp
			size_ctrl[i].fontsize  	=	em.textsize 

		case statictext!
			statictext st
			st = temp
			size_ctrl[i].fontsize  	=	st.textsize 
	
		case picturebutton!
			picturebutton pb
			pb = temp
			size_ctrl[i].fontsize = pb.textsize 

		case checkbox!
			so_checkbox cbx
			cbx = temp
			size_ctrl[i].fontsize  	=	cbx.textsize 

		case dropdownlistbox!
			dropdownlistbox ddlb
			ddlb = temp
			size_ctrl[i].fontsize  	=	ddlb.textsize 

		case groupbox!
			groupbox gb
			gb = temp
			size_ctrl[i].fontsize  	=	gb.textsize 
		case graph!
			graph gp
			gp = temp
//			size_ctrl[i].fontsize  	=	gb.textsize 			

		case listbox!
			listbox lb
			lb = temp
			size_ctrl[i].fontsize  	=	lb.textsize 

		case multilineedit!
			multilineedit mle
			mle = temp
			size_ctrl[i].fontsize  	=	mle.textsize 
			
		case radiobutton!
			radiobutton rb
			rb = temp
			size_ctrl[i].fontsize  	=	rb.textsize 
	end choose
next

return 1
end function

public function integer wf_resize_it (double size_factor);////////////////////////////////////////////////////////////////////////////////////////////////////
// function: wf_resize_it
////////////////////////////////////////////////////////////////////////////////////////////////////


// loop through off of the objects captured in the wf_size_it function and resize them
// Note !! radio buttons and checkboxes do not size properly as they are of fixed size.

dragobject temp
int cnt,i

ib_exec = false // keep the function from being called recursively

//this.hide()
// resize the window
//this.width = ((  ii_win_width - ii_win_frame_w) * size_factor) + ii_win_frame_w
//this.height = ((  ii_win_height - ii_win_frame_h) * size_factor) + ii_win_frame_h

// for each control in the list, resize it and it's textsize (as applicable)
cnt = upperbound(this.control)
for i = cnt to 1 step -1
	
	temp = this.control[i]
//	temp.x		 = size_ctrl[i].x * size_factor
//	temp.width   = size_ctrl[i].width  * size_factor
//	temp.y		 = size_ctrl[i].y * size_factor
////	temp.height  = size_ctrl[i].height * size_factor 
	
	choose case typeof(temp)
		case commandbutton!
			commandbutton cb
			cb = temp
//			cb.textsize =  size_ctrl[i].fontsize * size_factor 

		case singlelineedit!
			singlelineedit sle
			sle = temp
			sle.textsize =  size_ctrl[i].fontsize * size_factor 
		
		case editmask!
			editmask em
			em = temp
//			em.textsize =  size_ctrl[i].fontsize * size_factor 
		
		case statictext!
			statictext st
			st = temp
//			st.textsize =  size_ctrl[i].fontsize * size_factor 

		case datawindow! // datawindows get zoomed
			datawindow dw
			dw = temp
			
			dw.x		 = size_ctrl[i].x * size_factor
			dw.width   = size_ctrl[i].width  * size_factor
			dw.y		 = size_ctrl[i].y * size_factor			
          	dw.height  = size_ctrl[i].height * size_factor 			
//			dw.Object.DataWindow.zoom = string(int(size_factor*100))

		case picturebutton!
			picturebutton pb
			pb = temp
//			pb.textsize =  size_ctrl[i].fontsize * size_factor 

		case checkbox!
			so_checkbox cbx
			cbx = temp
//			cbx.textsize =  size_ctrl[i].fontsize * size_factor 

		case dropdownlistbox!
			dropdownlistbox ddlb
			ddlb = temp
//			ddlb.textsize =  size_ctrl[i].fontsize * size_factor 

		case graph!
			graph gp
			gp = temp
			gp.x		 = size_ctrl[i].x * size_factor
			gp.width   = size_ctrl[i].width  * size_factor
			gp.y		 = size_ctrl[i].y * size_factor			
          	gp.height  = size_ctrl[i].height * size_factor 			

		case groupbox!
			groupbox gb
			gb = temp
          	gb.height  = size_ctrl[i].height * size_factor 				
//			gb.textsize =  size_ctrl[i].fontsize * size_factor 
		case listbox!
			listbox lb
			lb = temp
//			lb.textsize  =  size_ctrl[i].fontsize * size_factor 

		case multilineedit!
			multilineedit mle
			mle = temp
          	mle.height  = size_ctrl[i].height * size_factor 				
//			mle.textsize =  size_ctrl[i].fontsize * size_factor 

		case radiobutton!
			radiobutton rb
			rb = temp
//			rb.textsize =  size_ctrl[i].fontsize * size_factor 

	end choose
next

//this.Show()
ib_exec = true
return 1
end function

public subroutine wf_zoom (string as_type);//dw_1.Object.DataWindow.Zoom = as_zoom 
// $$HEX17$$01ac200028cc7cc7e4b4d0c51cc1200015c858c774d51cc12000acc0a9c65cd5e4b2$$ENDHEX$$.
end subroutine

public subroutine wf_set_listbox ();string		ls_names_list,	  	ls_names
string		ls_object_name,	ls_datatype, ls_desc
	ls_names_list = DW_1.Object.DataWindow.objects
	
	// Get each object from the list and add it to the objects listbox
	//The character fields are added to the category list box and the
	//number fields are added to the value listbox
	ls_names = ls_names_list
	
	lb_category.reset()
	plb_value.reset()
	
	do 
		ls_object_name = f_get_token (ls_names, "~t")
		if DW_1.Describe(ls_object_name + ".type") = "column" then
			ls_datatype = DW_1.Describe(ls_object_name + ".coltype")
			ls_desc		= DW_1.Describe(ls_object_name+'_t' + ".text")
			if ls_datatype = "int" or ls_datatype = "long" or ls_datatype = "number" or left(ls_datatype,7) = "decimal" or left(ls_datatype, 4) = "char"  or ls_datatype = "datetime" or ls_datatype = "datet" then
				//messagebox('', ls_desc)
				lb_category.AddItem (ls_desc+'                                                  :'+ls_object_name)
			end if 
			if left(ls_datatype, 4) = "char"  or ls_datatype = "int" or ls_datatype = "long" or ls_datatype = "number" or left(ls_datatype,7) = "decimal" then
				plb_value.AddItem (ls_desc+'                                                  :'+ls_object_name, 1)
			end if
		end if
	loop until ls_names = ""

//select initial values (defaults is first selections)

lb_category.selectitem(1)
plb_value.selectitem(1)
plb_value.SetState (1, True)

gr_1.Category.Label = TRIM(MID(   lb_category.SelectedItem ( ), 1, POS(   lb_category.SelectedItem ( ) , ':' )-1 ))   
end subroutine

public subroutine wf_set_a_series (string as_title, string as_value, string as_category, string as_calc_type);LONG 		     LL_ROW, LL_INDEX , LC_AMT_COUNT
DECIMAL  	LC_AMT , LC_AMT_SUM , LC_AMT_MIN , LC_AMT_MAX
INT			LI_SERIES_NUM
STRING		LS_TITLE, ls_origin_sort , ls_datatype
string ls_seriesname
	
if as_category = '' then return 

LI_SERIES_NUM = GR_1.findseries( AS_TITLE ) 

if LI_SERIES_NUM < 0 or isnull(LI_SERIES_NUM) then 

		IF left(AS_TITLE,1) = '+'  THEN
			LI_SERIES_NUM = GR_1.ADDSERIES ( "@overlay~t" + AS_TITLE)
		ELSE
			LI_SERIES_NUM = GR_1.ADDSERIES ( AS_TITLE )
		END IF
end if 
//==============================================
//
//==============================================
IF	LI_SERIES_NUM < 1 THEN RETURN

	LL_ROW = ROWCOUNT (DW_1)
	IF LL_ROW < 1 THEN
		RETURN
	END IF
	
	//====================================
	// $$HEX14$$74ce4cd1e0acacb92000eccefcb72000c0d085c7200084bd1dc12000$$ENDHEX$$
	//====================================
	ls_datatype = DW_1.Describe(AS_CATEGORY + ".coltype")
	
	dw_1.setredraw( false)
	ls_origin_sort = dw_1.Describe("DataWindow.Table.Sort")
	
	dw_1.setredraw( True)
	  
	IF ls_datatype   = 'datetime' then 
		LS_TITLE	=	STRING(DW_1.GETITEMDATETIME( 1 , AS_CATEGORY ))
	ELSEif  mid(ls_datatype,1,4) = 'char' then 
		LS_TITLE     = DW_1.GETITEMSTRING( 1 , AS_CATEGORY )

	else
		LS_TITLE = string(DW_1.GETITEMNUMBER( 1 , AS_CATEGORY ))
	end if

	ls_seriesname = gr_1.SeriesName(LI_SERIES_NUM)
	gr_1.setseriesstyle(ls_seriesname, Nosymbol!)
	//=====================================
	// $$HEX18$$abcc88bcf8c9200089d558c7200038bc58b9200012ac44c7200000ac38c828c6e4b22000$$ENDHEX$$
	//===================================== 	
	if left(dw_1.Describe(AS_VALUE + ".coltype"),4) = 'char' then 
		
			//$$HEX16$$38bb90c715d674c774ba20002bc290c75cb82000c0bc58d620005cd5e4b22000$$ENDHEX$$
			LC_AMT 	=	dec(DW_1.GETITEMSTRING( 1 , AS_VALUE)) 
			
			if isnull(LC_AMT) then 
				LC_AMT = 0
			end if 
		    //==========================
			// 
			//========================== 
			if as_calc_type = 'COUNT' then
				LC_AMT = 1 
			end if 
		
	elseif left(dw_1.Describe(AS_VALUE + ".coltype"),4) = 'date' then
			
			if as_calc_type = 'COUNT' then
				LC_AMT = 1 
			end if
			
	//=======================================
	//  $$HEX5$$2bc290c7200015d62000$$ENDHEX$$
	//=======================================
    else
		
		LC_AMT 	=	DW_1.GETITEMNUMBER( 1 , AS_VALUE)
		if isnull(LC_AMT) then 
			LC_AMT = 0
		end if
		
		if as_calc_type = 'COUNT' then
			LC_AMT = 1 
		end if 		
		
	end if 
//=========================================
//
//=========================================

	FOR	LL_INDEX = 2 TO LL_ROW
		
			ls_seriesname = gr_1.SeriesName(LI_SERIES_NUM)
			gr_1.setseriesstyle(ls_seriesname, Nosymbol!)

			
			ls_datatype = DW_1.Describe(AS_CATEGORY + ".coltype")
//==============================================================
//  $$HEX8$$7cc790c7200074ce4cd1e0acacb92000$$ENDHEX$$
//==============================================================			
			IF ls_datatype = 'datetime' or ls_datatype= 'date' then 
				        	//====================================================
						// $$HEX12$$d9b37cc72000200074ce4cd1e0acacb9200074c774ba2000$$ENDHEX$$
						//====================================================
						IF	STRING(DW_1.GETITEMDATETIME( LL_INDEX , AS_CATEGORY )) = LS_TITLE THEN
							
										if left(dw_1.Describe(AS_VALUE + ".coltype"),4) = 'char' then 
											
														if isnull(dec(DW_1.GETITEMSTRING(LL_INDEX , AS_VALUE))) then 
														
															if as_calc_type = 'COUNT' then
																LC_AMT ++
															else	
																	//$$HEX4$$12acc6c54cc72000$$ENDHEX$$
															end if
														else
																if as_calc_type = 'COUNT' then
																	LC_AMT++
																elseif as_calc_type = 'SUM' then
																	LC_AMT	+= dec(DW_1.GETITEMSTRING(LL_INDEX , AS_VALUE))
																	
																elseif as_calc_type = 'AVG' then
																	LC_AMT_COUNT++
																	LC_AMT_SUM	+= dec(DW_1.GETITEMSTRING(LL_INDEX , AS_VALUE))																	
																	LC_AMT = LC_AMT_SUM /  LC_AMT_COUNT
																end if 
														end if 
													
														
										elseif 	left(dw_1.Describe(AS_VALUE + ".coltype"),4) = 'date' then 
											
															if as_calc_type = 'COUNT' then
																LC_AMT ++
															else	
																	//$$HEX4$$12acc6c54cc72000$$ENDHEX$$
															end if
										//===========================================
										// $$HEX4$$2bc290c715d62000$$ENDHEX$$
										//===========================================
										else
												if as_calc_type = 'COUNT' then
													LC_AMT++
												elseif as_calc_type = 'SUM' then 
													LC_AMT	+= DW_1.GETITEMNUMBER(LL_INDEX , AS_VALUE)	
												elseif as_calc_type = 'AVG' then
													LC_AMT_COUNT++
													LC_AMT_SUM	+=DW_1.GETITEMNUMBER(LL_INDEX , AS_VALUE)																
													LC_AMT = LC_AMT_SUM /  LC_AMT_COUNT													
												end if 
										end if 
						//====================================================
						////$$HEX11$$e4b278b9200074ce4cd1e0acacb9200074c774ba2000$$ENDHEX$$
						//====================================================
						ELSE 
							
									GR_1.ADDDATA (LI_SERIES_NUM, LC_AMT, LS_TITLE )	
			
									if mid(ls_datatype,1,4) = 'char' then 
										LS_TITLE	=	DW_1.GETITEMSTRING( LL_INDEX , AS_CATEGORY )
									elseif mid(ls_datatype,1,4) = 'date' then 
										LS_TITLE = STRING(DW_1.GETITEMDATETIME( LL_INDEX , AS_CATEGORY ))
									else
										LS_TITLE	=	STRING(DW_1.GETITEMNUMBER( LL_INDEX , AS_CATEGORY )	)
									end if 						
				
									
										if left(dw_1.Describe(AS_VALUE + ".coltype"),4) = 'char' then 
											
														if isnull(dec(DW_1.GETITEMSTRING(LL_INDEX , AS_VALUE))) then 
														
															if as_calc_type = 'COUNT' then
																LC_AMT =1
															else	
																	//$$HEX4$$12acc6c54cc72000$$ENDHEX$$
															end if
														else
																if as_calc_type = 'COUNT' then
																	LC_AMT =1
																else
																	LC_AMT	=dec(DW_1.GETITEMSTRING(LL_INDEX , AS_VALUE))
																end if 
														end if 
													
														
										elseif 	left(dw_1.Describe(AS_VALUE + ".coltype"),4) = 'date' then 
											
													if as_calc_type = 'COUNT' then
														LC_AMT =1
													else	
															//$$HEX4$$12acc6c54cc72000$$ENDHEX$$
													end if
											
										else
										 
												if as_calc_type = 'COUNT' then
													LC_AMT = 1
												else
													LC_AMT	= DW_1.GETITEMNUMBER(LL_INDEX , AS_VALUE)	
												end if 
										end if 
							
						END IF				
//==============================================================
//
//==============================================================
			ELSEIF   mid(ls_datatype,1,4) = 'char'  THEN  // $$HEX14$$74ce4cd1e0acacb92000eccefcb7200020c715d674c7200038bb90c7$$ENDHEX$$
					
					//$$HEX8$$d9b37cc7200074ce4cd1e0acacb92000$$ENDHEX$$
					IF	DW_1.GETITEMSTRING( LL_INDEX , AS_CATEGORY ) = LS_TITLE THEN
						
								if left(dw_1.Describe(AS_VALUE + ".coltype"),4) = 'char' then 
									
											if isnull(dec(DW_1.GETITEMSTRING(LL_INDEX , AS_VALUE))) then 
													
													if as_calc_type = 'COUNT' then
														LC_AMT ++
													else	
														//$$HEX4$$12acc6c54cc72000$$ENDHEX$$
													end if
											else
													if as_calc_type = 'COUNT' then
														LC_AMT++
													elseif as_calc_type = 'SUM' then 
														LC_AMT	+=dec(DW_1.GETITEMSTRING(LL_INDEX , AS_VALUE))
													elseif as_calc_type = 'AVG' then
														LC_AMT_COUNT++
														LC_AMT_SUM	+=dec(DW_1.GETITEMSTRING(LL_INDEX , AS_VALUE))														
														LC_AMT = LC_AMT_SUM /  LC_AMT_COUNT																	
													end if 													
											end if 
												
												
									elseif 	left(dw_1.Describe(AS_VALUE + ".coltype"),4) = 'date' then 
								
													if as_calc_type = 'COUNT' then
														LC_AMT ++
													else	
															//$$HEX4$$12acc6c54cc72000$$ENDHEX$$
													end if				
						
									else //$$HEX3$$2bc290c72000$$ENDHEX$$
											if as_calc_type = 'COUNT' then
											      LC_AMT++
											elseif as_calc_type = 'SUM' then							
												  LC_AMT	+= DW_1.GETITEMNUMBER(LL_INDEX , AS_VALUE)	
											elseif as_calc_type = 'AVG' then
														LC_AMT_COUNT++
														LC_AMT_SUM	+=DW_1.GETITEMNUMBER(LL_INDEX , AS_VALUE)																
														LC_AMT = LC_AMT_SUM /  LC_AMT_COUNT		  
											end if 
								end if 
								
					ELSE //$$HEX18$$74ce4cd1e0acacb900ac2000e4b274b974ba2000e0c2dcad70b374c730d194cd00ac2000$$ENDHEX$$
						
						GR_1.ADDDATA (LI_SERIES_NUM, LC_AMT, LS_TITLE )		
						
						if mid(ls_datatype,1,4) = 'char' then 
							LS_TITLE	=	DW_1.GETITEMSTRING( LL_INDEX , AS_CATEGORY )
						elseif mid(ls_datatype,1,4) = 'date' then 
						else
							LS_TITLE	=	STRING(DW_1.GETITEMNUMBER( LL_INDEX , AS_CATEGORY )	)
						end if 
						
						if left(dw_1.Describe(AS_VALUE + ".coltype"),4) = 'char' then 
							
								        if isnull(dec(DW_1.GETITEMSTRING(LL_INDEX , AS_VALUE))) then 
												
												if as_calc_type = 'COUNT' then //$$HEX8$$74ac18c2ccb9200074ceb4c6b8d22000$$ENDHEX$$
													  LC_AMT = 1 
												  else
													//$$HEX9$$44c5c8b274ba200012ac2000c6c54cc72000$$ENDHEX$$
												end if									
										else				
												if as_calc_type = 'COUNT' then //$$HEX8$$74ac18c2ccb9200074ceb4c6b8d22000$$ENDHEX$$
													LC_AMT = 1
												else
													LC_AMT	= dec(DW_1.GETITEMSTRING(LL_INDEX , AS_VALUE))
												end if
										end if 
										
							elseif 	left(dw_1.Describe(AS_VALUE + ".coltype"),4) = 'date' then 
								
												if as_calc_type = 'COUNT' then
													LC_AMT  =1
												else	
														//$$HEX4$$12acc6c54cc72000$$ENDHEX$$
												end if															
							else		//$$HEX11$$2bc290c715d6200074c774ba20000900090009000900$$ENDHEX$$
									if as_calc_type = 'COUNT' then //$$HEX8$$74ac18c2ccb9200074ceb4c6b8d22000$$ENDHEX$$
										LC_AMT= 1 
									else							
										LC_AMT	= DW_1.GETITEMNUMBER(LL_INDEX , AS_VALUE)
									end if
							end if
						
					END IF
//==============================================================
//
//==============================================================					
			ELSE  //$$HEX15$$74ce4cd1e0acacb900ac20002bc290c72000c0d085c7200074c774ba2000$$ENDHEX$$
				
						IF	STRING(DW_1.GETITEMNUMBER( LL_INDEX , AS_CATEGORY )) = LS_TITLE THEN
								
										//$$HEX9$$12ac74c7200038bb90c72000c0d085c72000$$ENDHEX$$
										if left(dw_1.Describe(AS_VALUE + ".coltype"),4) = 'char' then 
											
													if isnull(dec(DW_1.GETITEMSTRING(LL_INDEX , AS_VALUE))) then 
														
															if as_calc_type = 'COUNT' then
																LC_AMT ++
															else	
																	//$$HEX4$$12acc6c54cc72000$$ENDHEX$$
															end if
													 else
															if as_calc_type = 'COUNT' then
																LC_AMT++
															elseif as_calc_type = 'SUM' then
																LC_AMT	+= dec(DW_1.GETITEMSTRING(LL_INDEX , AS_VALUE))								
															elseif as_calc_type = 'AVG' then
																LC_AMT_COUNT++
																LC_AMT_SUM	+=dec(DW_1.GETITEMSTRING(LL_INDEX , AS_VALUE))		
																LC_AMT	+= dec(DW_1.GETITEMSTRING(LL_INDEX , AS_VALUE))					
															end if
													end if 
										elseif left(dw_1.Describe(AS_VALUE + ".coltype"),4) = 'date' then 
															if as_calc_type = 'COUNT' then
																LC_AMT ++
															else	
																	//$$HEX4$$12acc6c54cc72000$$ENDHEX$$
															end if											
										//==========================================
										//
										//==========================================
										else //$$HEX3$$2bc290c72000$$ENDHEX$$
													if as_calc_type = 'COUNT' then
														LC_AMT++
													elseif as_calc_type = 'SUM' then					
															LC_AMT	+= DW_1.GETITEMNUMBER(LL_INDEX , AS_VALUE)	
													elseif as_calc_type = 'AVG' then
														LC_AMT_COUNT++
														LC_AMT_SUM	+=DW_1.GETITEMNUMBER(LL_INDEX , AS_VALUE)																
														LC_AMT = LC_AMT_SUM /  LC_AMT_COUNT		  																		
													end if 
										end if 
								
							ELSE //$$HEX18$$74ce4cd1e0acacb900ac2000e4b274b974ba2000e0c2dcad70b374c730d194cd00ac2000$$ENDHEX$$
								
										GR_1.ADDDATA (LI_SERIES_NUM, LC_AMT, LS_TITLE )		
										
										if mid(ls_datatype,1,4) = 'char' then 
											LS_TITLE	=	DW_1.GETITEMSTRING( LL_INDEX , AS_CATEGORY )
										elseif mid(ls_datatype,1,4) = 'date' then 
											
										else //$$HEX3$$2bc290c72000$$ENDHEX$$
											LS_TITLE	=	STRING(DW_1.GETITEMNUMBER( LL_INDEX , AS_CATEGORY )	)
										end if 
										
										if left(dw_1.Describe(AS_VALUE + ".coltype"),4) = 'char' then 
											
												  if isnull(dec(DW_1.GETITEMSTRING(LL_INDEX , AS_VALUE))) then 
															
															if as_calc_type = 'COUNT' then //$$HEX8$$74ac18c2ccb9200074ceb4c6b8d22000$$ENDHEX$$
																LC_AMT = 1
															else			//$$HEX9$$44c5c8b274ba200012ac2000c6c54cc72000$$ENDHEX$$
																
															end if									
													else				
															if as_calc_type = 'COUNT' then //$$HEX8$$74ac18c2ccb9200074ceb4c6b8d22000$$ENDHEX$$
																LC_AMT= 1
															else
																LC_AMT	= dec(DW_1.GETITEMSTRING(LL_INDEX , AS_VALUE))
															end if
													end if 
										elseif left(dw_1.Describe(AS_VALUE + ".coltype"),4) = 'date' then 
															if as_calc_type = 'COUNT' then
																LC_AMT =1
															else	
																	//$$HEX4$$12acc6c54cc72000$$ENDHEX$$
															end if																
										//============================================
										//
										//============================================
										else		//$$HEX11$$2bc290c715d6200074c774ba20000900090009000900$$ENDHEX$$
												if as_calc_type = 'COUNT' then //$$HEX8$$74ac18c2ccb9200074ceb4c6b8d22000$$ENDHEX$$
													LC_AMT= 1 
												else							
													LC_AMT	= DW_1.GETITEMNUMBER(LL_INDEX , AS_VALUE)
												end if
										end if
								
							END IF				
			END IF
			
			
			IF	LL_INDEX = LL_ROW THEN
				GR_1.ADDDATA (LI_SERIES_NUM, LC_AMT, LS_TITLE )
			END IF
	
	NEXT

end subroutine

on w_graph_root.create
this.rb_count=create rb_count
this.rb_max=create rb_max
this.rb_sum=create rb_sum
this.rb_avg=create rb_avg
this.rb_min=create rb_min
this.cbx_count=create cbx_count
this.cbx_data=create cbx_data
this.pb_color=create pb_color
this.pb_print=create pb_print
this.pb_spacing=create pb_spacing
this.pb_title=create pb_title
this.pb_type=create pb_type
this.st_label=create st_label
this.lb_category=create lb_category
this.st_category=create st_category
this.st_value=create st_value
this.plb_value=create plb_value
this.dw_5=create dw_5
this.dw_4=create dw_4
this.dw_3=create dw_3
this.dw_2=create dw_2
this.dw_1=create dw_1
this.gb_view=create gb_view
this.gb_process=create gb_process
this.gr_1=create gr_1
this.Control[]={this.rb_count,&
this.rb_max,&
this.rb_sum,&
this.rb_avg,&
this.rb_min,&
this.cbx_count,&
this.cbx_data,&
this.pb_color,&
this.pb_print,&
this.pb_spacing,&
this.pb_title,&
this.pb_type,&
this.st_label,&
this.lb_category,&
this.st_category,&
this.st_value,&
this.plb_value,&
this.dw_5,&
this.dw_4,&
this.dw_3,&
this.dw_2,&
this.dw_1,&
this.gb_view,&
this.gb_process,&
this.gr_1}
end on

on w_graph_root.destroy
destroy(this.rb_count)
destroy(this.rb_max)
destroy(this.rb_sum)
destroy(this.rb_avg)
destroy(this.rb_min)
destroy(this.cbx_count)
destroy(this.cbx_data)
destroy(this.pb_color)
destroy(this.pb_print)
destroy(this.pb_spacing)
destroy(this.pb_title)
destroy(this.pb_type)
destroy(this.st_label)
destroy(this.lb_category)
destroy(this.st_category)
destroy(this.st_value)
destroy(this.plb_value)
destroy(this.dw_5)
destroy(this.dw_4)
destroy(this.dw_3)
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.gb_view)
destroy(this.gb_process)
destroy(this.gr_1)
end on

event resize;IF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL_1_G_2345' THEN //1345_2

     dw_1.resize(newwidth  - dw_1.x , dw_1.height )			
     gr_1.resize(newwidth   - gr_1.x , newheight - gr_1.y )
  //   dw_2.y = gr_1.y + gr_1.height + 10
 //    dw_2.resize(newwidth  - dw_2.x , dw_2.height )			
	 
ELSEIF UPPER(IVS_RESIZE_TYPE) = 'GRAPH' THEN //1345_2
	gr_1.resize(newwidth  - gr_1.x , newheight - ( gr_1.y + dw_1.height ))
	
	dw_1.y = gr_1.y + gr_1.HEIGHT 
	dw_1.resize(newwidth  - dw_1.x , dw_1.height )		
	dw_2.y = gr_1.y + gr_1.HEIGHT 
	dw_2.resize(newwidth  - dw_2.x , dw_2.height )			  
	dw_3.y = gr_1.y + gr_1.HEIGHT 
	dw_3.resize(newwidth  - dw_3.x , dw_3.height )		
	dw_4.y = gr_1.y + gr_1.HEIGHT 
	dw_4.resize(newwidth  - dw_4.x , dw_4.height )		
	dw_5.y = gr_1.y + gr_1.HEIGHT 
	dw_5.resize(newwidth  - dw_5.x , dw_5.height )			  
	  
ELSEIF UPPER(IVS_RESIZE_TYPE) = 'FREEFORM' THEN
	
////////////////////////////////////////////////////////////////////////////////////////////////////
// resize script for w_scale
////////////////////////////////////////////////////////////////////////////////////////////////////
		
		double ratiow, ratio, ratioh
		int rc
		
		// recalculate the new ratios and then use the minimum
		if ib_exec then  // Check to see if wf_resize_it is already running.
			ratioh  = this.height /ii_win_height
			ratiow = this.width / ii_win_width
			ratio = MIN (ratioh, ratiow)
			rc = wf_resize_it(ratio)  //RATIO = SIZE FACTOR
		end if

END IF
end event

event open;dw_1.settransobject(sqlca)
dw_2.settransobject(sqlca)
dw_3.settransobject(sqlca)
dw_4.settransobject(sqlca)
dw_5.settransobject(sqlca)

SELECTED_DATA_WINDOW = DW_1

//int	rc
//int	series_nbr
//// save off the size data
//rc = wf_size_it()
//ib_exec = true
//Gvi_dw_edit_mode = 0

PostEvent("ue_post_open")

end event

event activate;SELECTED_WINDOW = THIS

end event

event close;// $$HEX18$$70b374c7c0d008c7c4b3b0c6200018c215c8a8badcb47cb9200074d51cc85cd5e4b22000$$ENDHEX$$
Gvi_dw_edit_mode = 0
end event

type rb_count from radiobutton within w_graph_root
integer x = 3945
integer y = 156
integer width = 343
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
string text = "Count"
end type

type rb_max from radiobutton within w_graph_root
integer x = 3168
integer y = 244
integer width = 343
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
string text = "Max"
end type

type rb_sum from radiobutton within w_graph_root
integer x = 3557
integer y = 244
integer width = 343
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
string text = "Sum"
end type

type rb_avg from radiobutton within w_graph_root
integer x = 3168
integer y = 156
integer width = 343
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
string text = "Avg"
end type

type rb_min from radiobutton within w_graph_root
integer x = 3557
integer y = 156
integer width = 343
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
string text = "Min"
end type

type cbx_count from so_checkbox within w_graph_root
integer x = 3607
integer y = 24
integer width = 411
string text = "Count"
end type

type cbx_data from so_checkbox within w_graph_root
integer x = 3159
integer y = 36
integer width = 411
integer height = 64
boolean bringtotop = true
integer weight = 700
long textcolor = 128
string text = "Print Data"
end type

type pb_color from so_picturebutton within w_graph_root
integer x = 2949
integer y = 60
integer width = 101
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
string picturename = "ArrangeIcons!"
boolean map3dcolors = true
string powertiptext = "Graph Color..."
end type

event clicked;SetPointer(HourGlass!)

//open the change color window and pass the graph to it in the 
//message.powerobjectparm
OpenWithParm (w_graph_color, gr_1)
end event

type pb_print from so_picturebutton within w_graph_root
integer x = 2949
integer y = 260
integer width = 101
integer height = 88
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
string picturename = "Print!"
boolean map3dcolors = true
string powertiptext = "Print..."
end type

event clicked;

integer		li_answer
string			ls_rowcount,	&
				ls_graph_title
long 			ll_rowcount,		&
				ll_total, 			&
				ll_paper_orientation

li_answer = messagebox( "Question" , & 
							  "Do you want to Print the Graph object? ~n",  &
							  question! , &
							  yesno! , &
							  1 & 
							)

if li_answer = 2 &
then
	return
end if

ls_graph_title	=	gr_1.title
gr_1.title	=	""

long 		Job
int			i
string		sPrintName, sPrintDriver, sPrintPort

setpointer( hourglass! )

//print$$HEX5$$1dacb4cc2000ddc031c1$$ENDHEX$$
nvo_PowerPrn = CREATE n_PowerPrinter

// get $$HEX3$$04d5b0b930d1$$ENDHEX$$
nvo_PowerPrn.of_getdefaultprinterex(sPrintName, sPrintDriver, sPrintPort)
//(sPrintPort, sPrintName)
//sPrintName	=	nvo_PowerPrn.of_getdefaultprintername()
//sPrintName	=	trim(sPrintName)

// $$HEX8$$a9c6c0c994b2200034bb70c874ac2000$$ENDHEX$$A4$$HEX10$$c0c97cb9200030ae00c93cc75cb820005cd5e4b2$$ENDHEX$$.
if Ivi_paper > 0 then
	nvo_PowerPrn.of_setpapersize(Ivi_paper)
end if

ll_paper_orientation	=	LONG(dw_1.Object.DataWindow.Print.Orientation)

// $$HEX4$$00ac5cb878c7c4c1$$ENDHEX$$
IF	ll_paper_orientation = 1 THEN
	
//	i = nvo_PowerPrn.of_SetPrinterOrientation(nvo_PowerPrn.DMORIENT_LANDSCAPE)
	
//	if i >= 0 then
//		st_msg.text = nvo_PowerPrn.of_GetPrinterOrientationString()
//	else
//		("PowerPrinter", "Unable to change orientation. Error code = " + string(i))
//		return
//	end if
	
	Job = printopen(sPrintName, false)
	
	//PrintDefineFont ( job, 1 , "Tahoma", 125 , 400,	Default!, Anyfont!, TRUE, FALSE )	
	PrintDefineFont ( job, 2 , "Tahoma", 250 , 250,	Default!, Modern!, FALSE, TRUE )

	// print title
	PrintText (job , Ivs_print_title , 0 , 200 , 2 )
	
	gr_1.Print(Job, 0, 700 , 11000, 3700)
	
	wf_zoom('+-')
	dw_1.Object.DataWindow.Print.Margin.Left	=	'0'
	dw_1.Object.DataWindow.Print.Margin.Top	=	'1900'
	dw_1.Object.DataWindow.Print.Page.Range 	=	'1'
	
	PrintDataWindow(job, dw_1 )
	
	// $$HEX25$$50b488bcf8c9200098d374c7c0c9200080bd30d194b22000c8b9c4c944c7200001c88cac74d51cc1200004d5b0b9b8d268d5$$ENDHEX$$
	dw_1.Modify("DataWindow.Print.Preview=yes")
	ls_rowcount = 	dw_1.Object.DataWindow.LastRowOnPage
	dw_1.Modify("DataWindow.Print.Preview=no")
	
	ll_rowcount		= 	long(ls_rowcount)
	dw_1.setfilter( 'getrow() > ' + ls_rowcount )
	dw_1.filter()
	ll_total		=	dw_1.rowcount()
	
	// $$HEX19$$90c7ccb800ac200088c744c74cb5ccb92000e4b24cc7200098d374c7c0c9200098ccacb968d5$$ENDHEX$$.
	if ll_total > 0 then
		dw_1.Object.DataWindow.Print.Margin.Left	=	'0'
		dw_1.Object.DataWindow.Print.Margin.Top	=	'96'
		dw_1.Object.DataWindow.Print.Page.Range 	=	''
		PrintDataWindow(job, dw_1 )
	end if
ELSE
	
	i = nvo_PowerPrn.of_SetPrinterOrientation(nvo_PowerPrn.DMORIENT_PORTRAIT)

	if i >= 0 then
		f_msg_mdi_help( nvo_PowerPrn.of_GetPrinterOrientationString() )
	else
		MessageBox("PowerPrinter", "Unable to change orientation. Error code = " + string(i))
		return
	end if
	
	Job = printopen(sPrintName, false)
	
	//PrintDefineFont ( job, 1 , "Tahoma", 125 , 400,	Default!, Anyfont!, TRUE, FALSE )	
	PrintDefineFont ( job, 2 , "Tahoma", 250 , 250,	Default!, Modern!, FALSE, TRUE )
	
	// print title
	PrintText (job , Ivs_print_title , 0 , 200 , 2 )
	
	gr_1.Print(Job, 0, 700 , 7850, 3700)
	
	wf_zoom('+-')
	dw_1.Object.DataWindow.Print.Margin.Left	=	'0'
	dw_1.Object.DataWindow.Print.Margin.Top	=	'1900'
	dw_1.Object.DataWindow.Print.Page.Range 	=	'1'
	
	PrintDataWindow(job, dw_1 )
	
	// $$HEX25$$50b488bcf8c9200098d374c7c0c9200080bd30d194b22000c8b9c4c944c7200001c88cac74d51cc1200004d5b0b9b8d268d5$$ENDHEX$$
	dw_1.Modify("DataWindow.Print.Preview=yes")
	ls_rowcount = 	dw_1.Object.DataWindow.LastRowOnPage
	dw_1.Modify("DataWindow.Print.Preview=no")
	
	ll_rowcount		= 	long(ls_rowcount)
	dw_1.setfilter( 'getrow() > ' + ls_rowcount )
	dw_1.filter()
	ll_total		=	dw_1.rowcount()
	
	// $$HEX19$$90c7ccb800ac200088c744c74cb5ccb92000e4b24cc7200098d374c7c0c9200098ccacb968d5$$ENDHEX$$.
	if ll_total > 0 then
		dw_1.Object.DataWindow.Print.Margin.Left	=	'0'
		dw_1.Object.DataWindow.Print.Margin.Top	=	'96'
		dw_1.Object.DataWindow.Print.Page.Range 	=	''
		PrintDataWindow(job, dw_1 )
	end if
	
END IF

gr_1.title	=	ls_graph_title

//PrintClose(Job)
PrintClose(job)

dw_1.setfilter('')
dw_1.filter()
dw_1.sort()
wf_zoom('')

/***********************************************************************************
*    										End of Script 
************************************************************************************/

end event

type pb_spacing from so_picturebutton within w_graph_root
integer x = 2757
integer y = 260
integer width = 101
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
string picturename = "SpaceHorizontal!"
boolean map3dcolors = true
string powertiptext = "Graph Spacing..."
end type

event clicked;SetPointer(HourGlass!)

// Open the response window to set spacing. Pass it the graph so it
// can make changes.
OpenWithParm (w_graph_spacing, gr_1)

end event

type pb_title from so_picturebutton within w_graph_root
integer x = 2757
integer y = 160
integer width = 101
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
string picturename = "StaticText!"
boolean map3dcolors = true
string powertiptext = "Graph Title..."
end type

event clicked;SetPointer(HourGlass!)

// Open a response window to prompt for the new graph title. Pass the
// graph object as a parameter. The response window will handle the 
// rest.
OpenWithParm (w_graph_title, gr_1)

end event

type pb_type from so_picturebutton within w_graph_root
integer x = 2757
integer y = 60
integer width = 101
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
string picturename = "Graph!"
boolean map3dcolors = true
string powertiptext = "Graph Type..."
end type

event clicked;SetPointer(HourGlass!)

// Open the response window to set the graph type. Pass it the graph
// object and it will do the rest.
OpenWithParm (w_graph_properties_popup , gr_1)
end event

type st_label from so_statictext within w_graph_root
boolean visible = false
integer x = 4050
integer y = 484
integer width = 402
integer height = 68
boolean bringtotop = true
integer weight = 700
long textcolor = 8421376
long backcolor = 65535
end type

type lb_category from listbox within w_graph_root
event ue_mousemove pbm_mousemove
integer x = 576
integer y = 32
integer width = 727
integer height = 336
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
boolean extendedselect = true
end type

event ue_mousemove;this.setfocus( )
end event

event selectionchanged;//gr_1.reset ( all! )

//// When the category changes, we need to reconfigure everything on
//// the graph. The selectionchanged event for the value list does this.
//TriggerEvent (plb_value, selectionchanged!)
//// set category label
//
//integer 	li_ItemTotal, li_ItemCount
//string	ls_label
//// Get the number of items in the ListBox.
//li_ItemTotal = this.TotalItems( )
//// Loop through all the items.
//FOR li_ItemCount = 1 to li_ItemTotal
//
//// Is the item selected? If so, display the text
//	IF this.State(li_ItemCount) = 1 THEN 
//		ls_label	= ls_label + ' ' + TRIM(MID(  this.text(li_ItemCount),  1, POS(  this.text(li_ItemCount) , ':' )-1 ))
//	END IF
//	
//NEXT
//
//gr_1.Category.Label = ls_label


end event

event doubleclicked;// When the category changes, we need to reconfigure everything on
// the graph. The selectionchanged event for the value list does this.
TriggerEvent (plb_value, selectionchanged!)
// set category label

integer 	li_ItemTotal, li_ItemCount
string	ls_label
// Get the number of items in the ListBox.
li_ItemTotal = this.TotalItems( )
// Loop through all the items.
FOR li_ItemCount = 1 to li_ItemTotal

// Is the item selected? If so, display the text
	IF this.State(li_ItemCount) = 1 THEN 
		ls_label	= ls_label + ' ' + TRIM(MID(  this.text(li_ItemCount),  1, POS(  this.text(li_ItemCount) , ':' )-1 ))
	END IF
	
NEXT

gr_1.Category.Label = ls_label
end event

type st_category from so_statictext within w_graph_root
integer x = 27
integer y = 64
integer width = 521
integer height = 68
boolean bringtotop = true
integer weight = 700
long textcolor = 128
boolean enabled = false
string text = "Category"
end type

type st_value from so_statictext within w_graph_root
integer x = 1390
integer y = 40
integer width = 343
integer height = 124
boolean bringtotop = true
integer weight = 700
long textcolor = 128
string text = "Values To Graph"
alignment alignment = right!
end type

type plb_value from picturelistbox within w_graph_root
event ue_mousemove pbm_mousemove
integer x = 1778
integer y = 32
integer width = 837
integer height = 336
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean vscrollbar = true
boolean multiselect = true
string item[] = {"","",""}
borderstyle borderstyle = stylelowered!
boolean extendedselect = true
integer itempictureindex[] = {0,0,0}
string picturename[] = {"Graph!","Custom038!"}
long picturemaskcolor = 536870912
end type

event ue_mousemove;this.setfocus( )
end event

event selectionchanged;int 		i
string	ls_colname, ls_title



// Clear out all categories, series and data from the graph
gr_1.reset ( all! )
gr_1.SetRedraw (False)
OPEN(w_please_wait_popup)
// Loop through all selected values and create as many series as the
// user specified.
for i = 1 to totalitems ( )
	If this.state ( i ) = 1 then
		ls_colname	= 	TRIM(MID(  this.text ( i ),  POS(   this.text ( i ) , ':' ) +1, 200 ))
		ls_title		= 	TRIM(MID(  this.text ( i ),  1, POS(   this.text ( i ) , ':' ) -1 ))
		
		if rb_count.checked = true then
			wf_set_a_series (ls_title, ls_colname, TRIM(MID(  lb_category.text(lb_category.SelectedIndex()),  POS(  lb_category.text(lb_category.SelectedIndex()) , ':' ) +1, 200 )) , 'COUNT')		
		elseif rb_sum.checked = true then 
			wf_set_a_series (ls_title, ls_colname, TRIM(MID(  lb_category.text(lb_category.SelectedIndex()),  POS(  lb_category.text(lb_category.SelectedIndex()) , ':' ) +1, 200 )) , 'SUM')					
		elseif rb_max.checked = true then 
			wf_set_a_series (ls_title, ls_colname, TRIM(MID(  lb_category.text(lb_category.SelectedIndex()),  POS(  lb_category.text(lb_category.SelectedIndex()) , ':' ) +1, 200 )) , 'MAX')					
		elseif rb_min.checked = true then 
			wf_set_a_series (ls_title, ls_colname, TRIM(MID(  lb_category.text(lb_category.SelectedIndex()),  POS(  lb_category.text(lb_category.SelectedIndex()) , ':' ) +1, 200 )) , 'MIN')					
		elseif rb_avg.checked = true then 
			wf_set_a_series (ls_title, ls_colname, TRIM(MID(  lb_category.text(lb_category.SelectedIndex()),  POS(  lb_category.text(lb_category.SelectedIndex()) , ':' ) +1, 200 )) , 'AVG')					
		end if 
	end if
next
CLOSE(w_please_wait_popup)
gr_1.SetRedraw (True)
end event

event doubleclicked;string	ls_text

ls_text	=	this.text (index )

this.deleteitem(index)

if left(ls_text,1)  <>  '+' then
	this.insertitem( '+' + ls_text, 2, index)
else
	this.insertitem( mid(ls_text,2,100), 1, index)
end if


end event

type dw_5 from datawindow within w_graph_root
event ue_accepttext ( )
event ue_entertotab pbm_dwnprocessenter
event ue_dwkey pbm_dwnkey
event uo_mousemove pbm_dwnmousemove
event ue_unmoved pbm_syscommand
integer x = 5
integer y = 2132
integer width = 4507
integer height = 388
integer taborder = 10
string dragicon = "DataPipeline!"
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_accepttext;THIS.ACCEPTTEXT()
end event

event ue_entertotab;IF GVS_ENTERTOTAB_YN = 'Y' THEN

	SEND(HANDLE(THIS),256,9,983041)
	RETURN 1
END IF
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
//											( "Notify" , Upper(this.Describe( Getcolumnname()+'.Edit.Style')) +" Is not the check box type" ) 
											return
										end if
	                                             Msg = f_msgbox( 119 )															
//										Msg = ("Confirm" , "Name="+Getcolumnname()+ "  The whole it selects? [Yes = Select , No = Cancel ]" , question! , yesnocancel!)
										
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
							
							post event rbuttondown(  0 , 0 , 1 , ls_anydata )
							
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

event ue_unmoved;CHOOSE CASE commandtype
	CASE 61456, 61458
		message.processed = true
		message.returnvalue = 0
END CHOOSE

return

end event

event clicked;//************************************************************************************
// QUICK SORT $$HEX2$$98ccacb9$$ENDHEX$$
//************************************************************************************
selected_data_window = this
IF Gvi_dw_edit_mode = 0 THEN 

			if keydown(KeyControl!) and  UPPER(DWO.TYPE) = 'TEXT' then
				IF row = 0 THEN 
					F_QUICK_SORT(THIS , MID(STRING(DWO.NAME),1,LEN(STRING(DWO.NAME)) - 2) )
				END IF
				
			ELSE
				 STRING LVS_VALUE
				 IF  UPPER(DWO.TYPE) = 'COLUMN' THEN
						SELECTED_DATA_WINDOW = THIS
					
					IF ROW < 1 THEN RETURN
					if selected_data_window.Object.DataWindow.QueryMode = "yes" then 
					else
							LVS_VALUE = string(dwo.primary[row])	
							IF ISNULL(LVS_VALUE) THEN 
								 LVS_VALUE = ' '	
							END IF
							
							 F_MSG_MDI_HELP( upper(dwo.name)+' '+LVS_VALUE+' X= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".x")+' Y= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".y")    +' Width= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".width") )		
								
							Gvs_clipboard = string(dwo.primary[row])	
							Gvs_columnname = upper(dwo.name)
					end if
			
				ELSEIF  UPPER(DWO.TYPE) = 'TEXT' THEN
					 F_MSG_MDI_HELP( upper(dwo.name)+' '+dwo.text+' X= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".x")+' Y= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".y")    +' Width= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".width") )
				ELSEIF  UPPER(DWO.TYPE) = 'LINE' THEN
					 F_MSG_MDI_HELP( upper(dwo.name)+' X1= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".x1")+' Y1= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".y1") + ' X2= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".x2")+' Y2= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".y2") )
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
				THIS.SCROLLTOROW(ROW)
			END IF
			
ELSE
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


      F_MSGBOX1( 125 , STRING(Gvl_error_row)+" Row " )

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
	
	SELECT DECODE( :GVS_LANGUAGE , 'K' , WORD_KOR , 'E' , WORD_ENG , WORD_LOCAL ) ,
             	   DECODE( :GVS_LANGUAGE , 'K' , WORD_DESCRIPTION_KOR , 'E' , WORD_DESCRIPTION_ENG , WORD_DESCRIPTION_LOCAL ) 
	   INTO :LVS_COLUMN_NAME_LOCAL , :LVS_COLUMN_DESC_LOCAL
	  FROM ISYS_WORD_DICTIONARY
    WHERE WORD_ENG = :LVS_COLUMN_NAME
 	    AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID;	 
	 
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

	IF ivs_dw_5_selected_row_yn = 'Y' THEN 
		
			THIS.SELECTROW(0 , FALSE )		
			THIS.SELECTROW(row , TRUE )
			THIS.SETROW(ROW)
		
	END IF

END IF
//=======================================

RETURN 1
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


string ls_ColName , ls_text
ls_ColName = this.GetColumnName()+'_t'
ls_text = trim(this.describe(ls_ColName + ".text"))
IF MID(ls_text,1,1) = '*' THEN 
ELSE
	ls_text = '*'+ls_text
END IF


this.modify(ls_ColName + ".text = '" + ls_text + "'")

end event

event itemerror;f_MSGBOX1( 174 , DATA )

//("Data Input Error" , 'Data Invalid Check Data Length or Data Type ( String , Number , Date ...)  =>' + data ) 
RETURN 1
end event

event itemfocuschanged; ls_anydata = dwo
//if Gvs_popup_auto_active = 'Y' THEN
//	TRIGGER EVENT RBUTTONDOWN( 0 , 0 , ROW , DWO )
//end if
end event

event retrieveend;IF ISVALID(W_CANCEL_RETRIEVE_POP) THEN
	CLOSE(W_CANCEL_RETRIEVE_POP)
ELSE
	
END IF

if setrow = 0 then
	F_MSG_MDI_HELP ( F_MSG_ST( 117)  )
	THIS.SETFOCUS()		
	Return
else
 	F_MSG_MDI_HELP( F_MSG_ST1( 9013 , string(setrow) ))
	THIS.SCROLLTOROW(1)	
	THIS.SETFOCUS()
end if


end event

event retrieverow;setrow++
F_MSG_MDI_HELP( string(setrow)+" Rows Retrieve.." )

IF ISVALID(W_CANCEL_RETRIEVE_POP) THEN 
	
	W_CANCEL_RETRIEVE_POP.SLE_RETRIEVED_ROWS.TEXT = STRING(SETROW)

ELSE
	 THIS.Modify("DataWindow.Retrieve.AsNeeded=No")	
	 THIS.DBCANCEL()	 
	 RETURN 1
END IF

end event

event retrievestart;IF ivs_modify_security = 'Y' THEN
		
		IF THIS.MODIFIEDCOUNT() > 0 OR DELETEDCOUNT() > 0 THEN 
			
			Msg = F_MSGBOX1( 9014 , String(THIS.MODIFIEDCOUNT()+THIS.DELETEDCOUNT()))
			
			if Msg = 1 then 	
				
				Gvs_Ue_DATA_control = 'UPDATE'
				Parent.Triggerevent("UE_DATA_CONTROL")
				
			ELSEIF Msg = 2 then 	//NO 
				
				ROLLBACK ;
				RETURN
				
			ELSE // CANCEL
				 RETURN
			END IF 
			
		END IF
		
	END IF
	
	SETROW = 0 
	IF ISVALID(W_CANCEL_RETRIEVE_POP) THEN
		CLOSE(W_CANCEL_RETRIEVE_POP)
	ELSE
		IF ivs_dw_5_retrice_cancel_popup_open = 'Y' THEN 
			OPEN(W_CANCEL_RETRIEVE_POP)
		END IF
	END IF

end event

event rowfocuschanged;LONG I
IF currentrow = 0  THEN RETURN
IF ivs_dw_5_selected_row_yn = 'Y' THEN 

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

event updatestart;SETPOINTER(HourGlass!)
end event

event error;if f_msgbox1( 144 , STRING(ERRORNUMBER)+" "+ERRORTEXT+" "+errorwindowmenu+" "+errorobject+" "+errorscript+" "+STRING(errorline)+" ") = 1 then 
   Rollback;
   Disconnect ;
   Halt Close
else
	action  = EXCEPTIONiGNORE!
end if
end event

event sqlpreview;Gvs_last_sqlsyntax = sqlsyntax
end event

event updateend;if rowsdeleted + rowsupdated + rowsinserted = 0 then 
	return
end if

openwithparm(w_updateend_message_ontime , 0.5 )

if isvalid(w_updateend_message_ontime) then 
	
	w_updateend_message_ontime.sle_insert.text = string(rowsinserted)
	w_updateend_message_ontime.sle_update.text = string(rowsupdated)
	w_updateend_message_ontime.sle_delete.text = string(rowsdeleted)	
	w_updateend_message_ontime.st_rows.text =string( rowsdeleted + rowsupdated + rowsinserted)	
	
end if

end event

event rbuttondown;String lvs_date , LVS_VALUE

if  UPPER(dwo.type) = 'COLUMN' then

		LVS_VALUE = string(dwo.primary[row])	
		IF ISNULL(LVS_VALUE) THEN 
		 LVS_VALUE = ' '	
		END IF
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
//	m_main_frame_menu.m_system.m_reportmanage.m_reporteditmode.popmenu( w_main_frame.pointerx() , w_main_frame.pointery() ) 
else
//===================================================
// $$HEX22$$70b374c7c0d0200008c7c4b3b0c6200018c215c82000a8badcb400ac200044c5ccb220002000bdacb0c62000$$ENDHEX$$
//===================================================	
	
	if upper(dwo.type) = 'DATAWINDOW'  or Upper(this.Describe( dwo.name+'.Edit.Style')) = "CHECKBOX" THEN 
		m_main_frame_menu.m_control.popmenu( w_main_frame.pointerx() , w_main_frame.pointery() ) 		
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
			END IF
	END IF	
	
end if
end event

type dw_4 from datawindow within w_graph_root
event ue_accepttext ( )
event ue_entertotab pbm_dwnprocessenter
event ue_dwkey pbm_dwnkey
event uo_mousemove pbm_dwnmousemove
event ue_unmoved pbm_syscommand
integer x = 5
integer y = 2132
integer width = 4507
integer height = 388
integer taborder = 10
string dragicon = "DataPipeline!"
boolean bringtotop = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_accepttext;THIS.ACCEPTTEXT()
end event

event ue_entertotab;IF GVS_ENTERTOTAB_YN = 'Y' THEN

	SEND(HANDLE(THIS),256,9,983041)
	RETURN 1
END IF
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
//											( "Notify" , Upper(this.Describe( Getcolumnname()+'.Edit.Style')) +" Is not the check box type" ) 
											return
										end if
	                                             Msg = f_msgbox( 119 )															
//										Msg = ("Confirm" , "Name="+Getcolumnname()+ "  The whole it selects? [Yes = Select , No = Cancel ]" , question! , yesnocancel!)
										
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
							
							post event rbuttondown(  0 , 0 , 1 , ls_anydata )
							
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

event ue_unmoved;CHOOSE CASE commandtype
	CASE 61456, 61458
		message.processed = true
		message.returnvalue = 0
END CHOOSE

return

end event

event clicked;//************************************************************************************
// QUICK SORT $$HEX2$$98ccacb9$$ENDHEX$$
//************************************************************************************
selected_data_window = this
IF Gvi_dw_edit_mode = 0 THEN 

			if keydown(KeyControl!) and  UPPER(DWO.TYPE) = 'TEXT' then
				IF row = 0 THEN 
					F_QUICK_SORT(THIS , MID(STRING(DWO.NAME),1,LEN(STRING(DWO.NAME)) - 2) )
				END IF
				
			ELSE
				 STRING LVS_VALUE
				 IF  UPPER(DWO.TYPE) = 'COLUMN' THEN
						SELECTED_DATA_WINDOW = THIS
					
					IF ROW < 1 THEN RETURN
					if selected_data_window.Object.DataWindow.QueryMode = "yes" then 
					else
							LVS_VALUE = string(dwo.primary[row])	
							IF ISNULL(LVS_VALUE) THEN 
								 LVS_VALUE = ' '	
							END IF
							
							 F_MSG_MDI_HELP( upper(dwo.name)+' '+LVS_VALUE+' X= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".x")+' Y= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".y")    +' Width= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".width") )		
								
							Gvs_clipboard = string(dwo.primary[row])	
							Gvs_columnname = upper(dwo.name)
					end if
			
				ELSEIF  UPPER(DWO.TYPE) = 'TEXT' THEN
					 F_MSG_MDI_HELP( upper(dwo.name)+' '+dwo.text+' X= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".x")+' Y= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".y")    +' Width= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".width") )
				ELSEIF  UPPER(DWO.TYPE) = 'LINE' THEN
					 F_MSG_MDI_HELP( upper(dwo.name)+' X1= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".x1")+' Y1= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".y1") + ' X2= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".x2")+' Y2= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".y2") )
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
				THIS.SCROLLTOROW(ROW)
			END IF
			
ELSE
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


      F_MSGBOX1( 125 , STRING(Gvl_error_row)+" Row " )

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
	
	SELECT DECODE( :GVS_LANGUAGE , 'K' , WORD_KOR , 'E' , WORD_ENG , WORD_LOCAL ) ,
             	   DECODE( :GVS_LANGUAGE , 'K' , WORD_DESCRIPTION_KOR , 'E' , WORD_DESCRIPTION_ENG , WORD_DESCRIPTION_LOCAL ) 
	   INTO :LVS_COLUMN_NAME_LOCAL , :LVS_COLUMN_DESC_LOCAL
	  FROM ISYS_WORD_DICTIONARY
    WHERE WORD_ENG = :LVS_COLUMN_NAME
 	    AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID;	 
	 
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

	IF ivs_dw_4_selected_row_yn = 'Y' THEN 
		
			THIS.SELECTROW(0 , FALSE )		
			THIS.SELECTROW(row , TRUE )
			THIS.SETROW(ROW)
		
	END IF

END IF
//=======================================

RETURN 1
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


string ls_ColName , ls_text
ls_ColName = this.GetColumnName()+'_t'
ls_text = trim(this.describe(ls_ColName + ".text"))
IF MID(ls_text,1,1) = '*' THEN 
ELSE
	ls_text = '*'+ls_text
END IF


this.modify(ls_ColName + ".text = '" + ls_text + "'")

end event

event itemerror;f_MSGBOX1( 174 , DATA )

//("Data Input Error" , 'Data Invalid Check Data Length or Data Type ( String , Number , Date ...)  =>' + data ) 
RETURN 1
end event

event itemfocuschanged; ls_anydata = dwo
//if Gvs_popup_auto_active = 'Y' THEN
//	TRIGGER EVENT RBUTTONDOWN( 0 , 0 , ROW , DWO )
//end if
end event

event retrieveend;IF ISVALID(W_CANCEL_RETRIEVE_POP) THEN
	CLOSE(W_CANCEL_RETRIEVE_POP)
ELSE
	
END IF

if setrow = 0 then
	F_MSG_MDI_HELP ( F_MSG_ST( 117)  )
	THIS.SETFOCUS()		
	Return
else
 	F_MSG_MDI_HELP( F_MSG_ST1( 9013 , string(setrow) ))
	THIS.SCROLLTOROW(1)	
	THIS.SETFOCUS()
	RETURN
end if


end event

event retrieverow;setrow++
F_MSG_MDI_HELP( string(setrow)+" Rows Retrieve.." )

IF ISVALID(W_CANCEL_RETRIEVE_POP) THEN 
	
	W_CANCEL_RETRIEVE_POP.SLE_RETRIEVED_ROWS.TEXT = STRING(SETROW)

ELSE
	 THIS.Modify("DataWindow.Retrieve.AsNeeded=No")	
	 THIS.DBCANCEL()	 
	 RETURN 1
END IF

end event

event retrievestart;IF ivs_modify_security = 'Y' THEN
		
		IF THIS.MODIFIEDCOUNT() > 0 OR DELETEDCOUNT() > 0 THEN 
			
			Msg = F_MSGBOX1( 9014 , String(THIS.MODIFIEDCOUNT()+THIS.DELETEDCOUNT()))
			
			if Msg = 1 then 	
				
				Gvs_Ue_DATA_control = 'UPDATE'
				Parent.Triggerevent("UE_DATA_CONTROL")
				
			ELSEIF Msg = 2 then 	//NO 
				
				ROLLBACK ;
				RETURN
				
			ELSE // CANCEL
				 RETURN
			END IF 
			
		END IF
		
	END IF
		
	
	SETROW = 0 
	IF ISVALID(W_CANCEL_RETRIEVE_POP) THEN
		CLOSE(W_CANCEL_RETRIEVE_POP)
	ELSE
		IF ivs_dw_4_retrice_cancel_popup_open = 'Y' THEN 
			OPEN(W_CANCEL_RETRIEVE_POP)
		END IF
	END IF

end event

event rowfocuschanged;LONG I
IF currentrow = 0  THEN RETURN
IF ivs_dw_4_selected_row_yn = 'Y' THEN 

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

event updatestart;SETPOINTER(HourGlass!)
end event

event error;if f_msgbox1( 144 , STRING(ERRORNUMBER)+" "+ERRORTEXT+" "+errorwindowmenu+" "+errorobject+" "+errorscript+" "+STRING(errorline)+" ") = 1 then 
   Rollback;
   Disconnect ;
   Halt Close
else
	action  = EXCEPTIONiGNORE!
end if
end event

event sqlpreview;Gvs_last_sqlsyntax = sqlsyntax
end event

event updateend;if rowsdeleted + rowsupdated + rowsinserted = 0 then 
	return
end if

openwithparm(w_updateend_message_ontime , 0.5 )

if isvalid(w_updateend_message_ontime) then 
	
	w_updateend_message_ontime.sle_insert.text = string(rowsinserted)
	w_updateend_message_ontime.sle_update.text = string(rowsupdated)
	w_updateend_message_ontime.sle_delete.text = string(rowsdeleted)	
	
	w_updateend_message_ontime.st_rows.text =string( rowsdeleted + rowsupdated + rowsinserted)	
end if

end event

event rbuttondown;String lvs_date , LVS_VALUE

if  UPPER(dwo.type) = 'COLUMN' then

		LVS_VALUE = string(dwo.primary[row])	
		IF ISNULL(LVS_VALUE) THEN 
		 LVS_VALUE = ' '	
		END IF
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
//	m_main_frame_menu.m_system.m_reportmanage.m_reporteditmode.popmenu( w_main_frame.pointerx() , w_main_frame.pointery() ) 
else
//===================================================
// $$HEX22$$70b374c7c0d0200008c7c4b3b0c6200018c215c82000a8badcb400ac200044c5ccb220002000bdacb0c62000$$ENDHEX$$
//===================================================	
	
	if upper(dwo.type) = 'DATAWINDOW'  or Upper(this.Describe( dwo.name+'.Edit.Style')) = "CHECKBOX" THEN 
		m_main_frame_menu.m_control.popmenu( w_main_frame.pointerx() , w_main_frame.pointery() ) 		
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
			END IF
	END IF	
	
end if
end event

type dw_3 from datawindow within w_graph_root
event ue_accepttext ( )
event ue_entertotab pbm_dwnprocessenter
event ue_dwkey pbm_dwnkey
event uo_mousemove pbm_dwnmousemove
event ue_unmoved pbm_syscommand
integer x = 5
integer y = 2132
integer width = 4507
integer height = 388
integer taborder = 10
string dragicon = "DataPipeline!"
boolean bringtotop = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_accepttext;THIS.ACCEPTTEXT()
end event

event ue_entertotab;IF GVS_ENTERTOTAB_YN = 'Y' THEN

	SEND(HANDLE(THIS),256,9,983041)
	RETURN 1
END IF
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
//											( "Notify" , Upper(this.Describe( Getcolumnname()+'.Edit.Style')) +" Is not the check box type" ) 
											return
										end if
	                                             Msg = f_msgbox( 119 )															
//										Msg = ("Confirm" , "Name="+Getcolumnname()+ "  The whole it selects? [Yes = Select , No = Cancel ]" , question! , yesnocancel!)
										
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
							
							post event rbuttondown(  0 , 0 , 1 , ls_anydata )
							
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

event ue_unmoved;CHOOSE CASE commandtype
	CASE 61456, 61458
		message.processed = true
		message.returnvalue = 0
END CHOOSE

return

end event

event clicked;//************************************************************************************
// QUICK SORT $$HEX2$$98ccacb9$$ENDHEX$$
//************************************************************************************
selected_data_window = this
IF Gvi_dw_edit_mode = 0 THEN 

			if keydown(KeyControl!) and  UPPER(DWO.TYPE) = 'TEXT' then
				IF row = 0 THEN 
					F_QUICK_SORT(THIS , MID(STRING(DWO.NAME),1,LEN(STRING(DWO.NAME)) - 2) )
				END IF
				
			ELSE
				 STRING LVS_VALUE
				 IF  UPPER(DWO.TYPE) = 'COLUMN' THEN
						SELECTED_DATA_WINDOW = THIS
					
					IF ROW < 1 THEN RETURN
					if selected_data_window.Object.DataWindow.QueryMode = "yes" then 
					else
							LVS_VALUE = string(dwo.primary[row])	
							IF ISNULL(LVS_VALUE) THEN 
								 LVS_VALUE = ' '	
							END IF
							
							 F_MSG_MDI_HELP( upper(dwo.name)+' '+LVS_VALUE+' X= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".x")+' Y= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".y")    +' Width= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".width") )		
								
							Gvs_clipboard = string(dwo.primary[row])	
							Gvs_columnname = upper(dwo.name)
					end if
			
				ELSEIF  UPPER(DWO.TYPE) = 'TEXT' THEN
					 F_MSG_MDI_HELP( upper(dwo.name)+' '+dwo.text+' X= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".x")+' Y= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".y")    +' Width= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".width") )
				ELSEIF  UPPER(DWO.TYPE) = 'LINE' THEN
					 F_MSG_MDI_HELP( upper(dwo.name)+' X1= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".x1")+' Y1= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".y1") + ' X2= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".x2")+' Y2= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".y2") )
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
				THIS.SCROLLTOROW(ROW)
			END IF
			
ELSE
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

      F_MSGBOX1( 125 , STRING(Gvl_error_row)+" Row " )
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
	
	SELECT DECODE( :GVS_LANGUAGE , 'K' , WORD_KOR , 'E' , WORD_ENG , WORD_LOCAL ) ,
             	   DECODE( :GVS_LANGUAGE , 'K' , WORD_DESCRIPTION_KOR , 'E' , WORD_DESCRIPTION_ENG , WORD_DESCRIPTION_LOCAL ) 
	   INTO :LVS_COLUMN_NAME_LOCAL , :LVS_COLUMN_DESC_LOCAL
	  FROM ISYS_WORD_DICTIONARY
    WHERE WORD_ENG = :LVS_COLUMN_NAME	
 	    AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID;	 
	 
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

	IF ivs_dw_3_selected_row_yn = 'Y' THEN 
		
			THIS.SELECTROW(0 , FALSE )		
			THIS.SELECTROW(row , TRUE )
			THIS.SETROW(ROW)
		
	END IF

END IF
//=======================================

RETURN 1
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


string ls_ColName , ls_text
ls_ColName = this.GetColumnName()+'_t'
ls_text = trim(this.describe(ls_ColName + ".text"))
IF MID(ls_text,1,1) = '*' THEN 
ELSE
	ls_text = '*'+ls_text
END IF


this.modify(ls_ColName + ".text = '" + ls_text + "'")

end event

event itemerror;f_MSGBOX1( 174 , DATA )

//("Data Input Error" , 'Data Invalid Check Data Length or Data Type ( String , Number , Date ...)  =>' + data ) 
RETURN 1
end event

event itemfocuschanged; ls_anydata = dwo
//if Gvs_popup_auto_active = 'Y' THEN
//	TRIGGER EVENT RBUTTONDOWN( 0 , 0 , ROW , DWO )
//end if
end event

event retrieveend;IF ISVALID(W_CANCEL_RETRIEVE_POP) THEN
	CLOSE(W_CANCEL_RETRIEVE_POP)
ELSE
	
END IF

if setrow = 0 then
	F_MSG_MDI_HELP ( F_MSG_ST( 117)  )
	THIS.SETFOCUS()		
	Return
else
 	F_MSG_MDI_HELP( F_MSG_ST1( 9013 , string(setrow) ))
	THIS.SCROLLTOROW(1)	
	THIS.SETFOCUS()
	RETURN
end if


end event

event retrieverow;setrow++
F_MSG_MDI_HELP( string(setrow)+" Rows Retrieve.." )

IF ISVALID(W_CANCEL_RETRIEVE_POP) THEN 
	
	W_CANCEL_RETRIEVE_POP.SLE_RETRIEVED_ROWS.TEXT = STRING(SETROW)

ELSE
	 THIS.Modify("DataWindow.Retrieve.AsNeeded=No")	
	 THIS.DBCANCEL()	 
	 RETURN 1
END IF

end event

event retrievestart;IF ivs_modify_security = 'Y' THEN
		
		IF THIS.MODIFIEDCOUNT() > 0 OR DELETEDCOUNT() > 0 THEN 
			
			Msg = F_MSGBOX1( 9014 , String(THIS.MODIFIEDCOUNT()+THIS.DELETEDCOUNT()))
			
			if Msg = 1 then 	
				
				Gvs_Ue_DATA_control = 'UPDATE'
				Parent.Triggerevent("UE_DATA_CONTROL")
				
			ELSEIF Msg = 2 then 	//NO 
				
				ROLLBACK ;
				RETURN
				
			ELSE // CANCEL
				 RETURN
			END IF 
			
		END IF
		
	END IF
		
	
	SETROW = 0 
	IF ISVALID(W_CANCEL_RETRIEVE_POP) THEN
		CLOSE(W_CANCEL_RETRIEVE_POP)
	ELSE
		IF ivs_dw_3_retrice_cancel_popup_open = 'Y' THEN 
			OPEN(W_CANCEL_RETRIEVE_POP)
		END IF
	END IF

end event

event rowfocuschanged;LONG I
IF currentrow = 0  THEN RETURN
IF ivs_dw_3_selected_row_yn = 'Y' THEN 

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

event updatestart;SETPOINTER(HourGlass!)
end event

event error;if f_msgbox1( 144 , STRING(ERRORNUMBER)+" "+ERRORTEXT+" "+errorwindowmenu+" "+errorobject+" "+errorscript+" "+STRING(errorline)+" ") = 1 then 
   Rollback;
   Disconnect ;
   Halt Close
else
	action  = EXCEPTIONiGNORE!
end if
end event

event sqlpreview;Gvs_last_sqlsyntax = sqlsyntax
end event

event updateend;if rowsdeleted + rowsupdated + rowsinserted = 0 then 
	return
end if

openwithparm(w_updateend_message_ontime , 0.5 )

if isvalid(w_updateend_message_ontime) then 
	
	w_updateend_message_ontime.sle_insert.text = string(rowsinserted)
	w_updateend_message_ontime.sle_update.text = string(rowsupdated)
	w_updateend_message_ontime.sle_delete.text = string(rowsdeleted)	
	w_updateend_message_ontime.st_rows.text =string( rowsdeleted + rowsupdated + rowsinserted)	
	
end if

end event

event rbuttondown;String lvs_date , LVS_VALUE

if  UPPER(dwo.type) = 'COLUMN' then

		LVS_VALUE = string(dwo.primary[row])	
		IF ISNULL(LVS_VALUE) THEN 
		 LVS_VALUE = ' '	
		END IF
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
//	m_main_frame_menu.m_system.m_reportmanage.m_reporteditmode.popmenu( w_main_frame.pointerx() , w_main_frame.pointery() ) 
else
//===================================================
// $$HEX22$$70b374c7c0d0200008c7c4b3b0c6200018c215c82000a8badcb400ac200044c5ccb220002000bdacb0c62000$$ENDHEX$$
//===================================================	
	
	if upper(dwo.type) = 'DATAWINDOW'  or Upper(this.Describe( dwo.name+'.Edit.Style')) = "CHECKBOX" THEN 
		m_main_frame_menu.m_control.popmenu( w_main_frame.pointerx() , w_main_frame.pointery() ) 		
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
			END IF
	END IF	
	
end if
end event

type dw_2 from datawindow within w_graph_root
event ue_accepttext ( )
event ue_entertotab pbm_dwnprocessenter
event ue_dwkey pbm_dwnkey
event uo_mousemove pbm_dwnmousemove
event ue_unmoved pbm_syscommand
integer x = 5
integer y = 2132
integer width = 4507
integer height = 388
integer taborder = 10
string dragicon = "DataPipeline!"
boolean bringtotop = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_accepttext;THIS.ACCEPTTEXT()
end event

event ue_entertotab;IF GVS_ENTERTOTAB_YN = 'Y' THEN

	SEND(HANDLE(THIS),256,9,983041)
	RETURN 1
END IF
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
//											( "Notify" , Upper(this.Describe( Getcolumnname()+'.Edit.Style')) +" Is not the check box type" ) 
											return
										end if
	                                             Msg = f_msgbox( 119 )															
//										Msg = ("Confirm" , "Name="+Getcolumnname()+ "  The whole it selects? [Yes = Select , No = Cancel ]" , question! , yesnocancel!)
										
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
							
							post event rbuttondown(  0 , 0 , 1 , ls_anydata )
							
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

event ue_unmoved;CHOOSE CASE commandtype
	CASE 61456, 61458
		message.processed = true
		message.returnvalue = 0
END CHOOSE

return

end event

event clicked;//************************************************************************************
// QUICK SORT $$HEX2$$98ccacb9$$ENDHEX$$
//************************************************************************************
selected_data_window = this
IF Gvi_dw_edit_mode = 0 THEN 

			if keydown(KeyControl!) and  UPPER(DWO.TYPE) = 'TEXT' then
				IF row = 0 THEN 
					F_QUICK_SORT(THIS , MID(STRING(DWO.NAME),1,LEN(STRING(DWO.NAME)) - 2) )
				END IF
				
			ELSE
				 STRING LVS_VALUE
				 IF  UPPER(DWO.TYPE) = 'COLUMN' THEN
						SELECTED_DATA_WINDOW = THIS
					
					IF ROW < 1 THEN RETURN
					if selected_data_window.Object.DataWindow.QueryMode = "yes" then 
					else
							LVS_VALUE = string(dwo.primary[row])	
							IF ISNULL(LVS_VALUE) THEN 
								 LVS_VALUE = ' '	
							END IF
							
							 F_MSG_MDI_HELP( upper(dwo.name)+' '+LVS_VALUE+' X= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".x")+' Y= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".y")    +' Width= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".width") )		
								
							Gvs_clipboard = string(dwo.primary[row])	
							Gvs_columnname = upper(dwo.name)
					end if
			
				ELSEIF  UPPER(DWO.TYPE) = 'TEXT' THEN
					 F_MSG_MDI_HELP( upper(dwo.name)+' '+dwo.text+' X= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".x")+' Y= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".y")    +' Width= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".width") )
				ELSEIF  UPPER(DWO.TYPE) = 'LINE' THEN
					 F_MSG_MDI_HELP( upper(dwo.name)+' X1= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".x1")+' Y1= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".y1") + ' X2= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".x2")+' Y2= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".y2") )
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
				THIS.SCROLLTOROW(ROW)
			END IF
			
ELSE
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

      F_MSGBOX1( 125 , STRING(Gvl_error_row)+" Row " )
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
	
	SELECT DECODE( :GVS_LANGUAGE , 'K' , WORD_KOR , 'E' , WORD_ENG , WORD_LOCAL ) ,
             	   DECODE( :GVS_LANGUAGE , 'K' , WORD_DESCRIPTION_KOR , 'E' , WORD_DESCRIPTION_ENG , WORD_DESCRIPTION_LOCAL ) 
	   INTO :LVS_COLUMN_NAME_LOCAL , :LVS_COLUMN_DESC_LOCAL
	  FROM ISYS_WORD_DICTIONARY
    WHERE WORD_ENG = :LVS_COLUMN_NAME
	    AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID;
	 
	IF F_SQL_CHECK_WITH_MSG( 'Word Dictionary Select ' ) < 0 THEN 
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

	IF ivs_dw_2_selected_row_yn = 'Y' THEN 
		
			THIS.SELECTROW(0 , FALSE )		
			THIS.SELECTROW(row , TRUE )
			THIS.SETROW(ROW)
		
	END IF

END IF
//=======================================

RETURN 1
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


string ls_ColName , ls_text
ls_ColName = this.GetColumnName()+'_t'
ls_text = trim(this.describe(ls_ColName + ".text"))
IF MID(ls_text,1,1) = '*' THEN 
ELSE
	ls_text = '*'+ls_text
END IF


this.modify(ls_ColName + ".text = '" + ls_text + "'")

end event

event itemerror;f_MSGBOX1( 174 , DATA )

//("Data Input Error" , 'Data Invalid Check Data Length or Data Type ( String , Number , Date ...)  =>' + data ) 
RETURN 1
end event

event itemfocuschanged; ls_anydata = dwo
//if Gvs_popup_auto_active = 'Y' THEN
//	TRIGGER EVENT RBUTTONDOWN( 0 , 0 , ROW , DWO )
//end if
end event

event retrieveend;IF ISVALID(W_CANCEL_RETRIEVE_POP) THEN
	CLOSE(W_CANCEL_RETRIEVE_POP)
ELSE
	
END IF

if setrow = 0 then
	F_MSG_MDI_HELP ( F_MSG_ST( 117)  )
	THIS.SETFOCUS()		
	Return
else
 	F_MSG_MDI_HELP( F_MSG_ST1( 9013 , string(setrow) ))
	THIS.SCROLLTOROW(1)	
	THIS.SETFOCUS()
	RETURN
end if


end event

event retrieverow;setrow++
F_MSG_MDI_HELP( string(setrow)+" Rows Retrieve.." )

IF ISVALID(W_CANCEL_RETRIEVE_POP) THEN 
	
	W_CANCEL_RETRIEVE_POP.SLE_RETRIEVED_ROWS.TEXT = STRING(SETROW)

ELSE
	 THIS.Modify("DataWindow.Retrieve.AsNeeded=No")	
	 THIS.DBCANCEL()	 
	 RETURN 1
END IF

end event

event retrievestart;	IF ivs_modify_security = 'Y' THEN
		
		IF THIS.MODIFIEDCOUNT() > 0 OR DELETEDCOUNT() > 0 THEN 
			
			Msg = F_MSGBOX1( 9014 , String(THIS.MODIFIEDCOUNT()+THIS.DELETEDCOUNT()))
			
			if Msg = 1 then 	
				
				Gvs_Ue_DATA_control = 'UPDATE'
				Parent.Triggerevent("UE_DATA_CONTROL")
				
			ELSEIF Msg = 2 then 	//NO 
				
				ROLLBACK ;
//				RETURN
				
			ELSE // CANCEL
//				 RETURN
			END IF 
			
		END IF
		
	END IF
		
	
	SETROW = 0 
	
	
	
	
	IF ISVALID(W_CANCEL_RETRIEVE_POP) THEN
		CLOSE(W_CANCEL_RETRIEVE_POP)
	ELSE
		
		IF ivs_dw_2_retrice_cancel_popup_open = 'Y' THEN 
			OPEN(W_CANCEL_RETRIEVE_POP)
		END IF
	END IF

end event

event rowfocuschanged;LONG I
IF currentrow = 0  THEN RETURN
IF ivs_dw_2_selected_row_yn = 'Y' THEN 

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

event updatestart;SETPOINTER(HourGlass!)
end event

event error;if f_msgbox1( 144 , STRING(ERRORNUMBER)+" "+ERRORTEXT+" "+errorwindowmenu+" "+errorobject+" "+errorscript+" "+STRING(errorline)+" ") = 1 then 
   Rollback;
   Disconnect ;
   Halt Close
else
	action  = EXCEPTIONiGNORE!
end if
end event

event sqlpreview;Gvs_last_sqlsyntax = sqlsyntax
end event

event updateend;if rowsdeleted + rowsupdated + rowsinserted = 0 then 
	return
end if


openwithparm(w_updateend_message_ontime , 0.5 )

if isvalid(w_updateend_message_ontime) then 
	
	w_updateend_message_ontime.sle_insert.text = string(rowsinserted)
	w_updateend_message_ontime.sle_update.text = string(rowsupdated)
	w_updateend_message_ontime.sle_delete.text = string(rowsdeleted)	
	
	w_updateend_message_ontime.st_rows.text =string( rowsdeleted + rowsupdated + rowsinserted)
	
end if

end event

event rbuttondown;String lvs_date , LVS_VALUE

if  UPPER(dwo.type) = 'COLUMN' then

		LVS_VALUE = string(dwo.primary[row])	
		IF ISNULL(LVS_VALUE) THEN 
		 LVS_VALUE = ' '	
		END IF
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
//	m_main_frame_menu.m_system.m_reportmanage.m_reporteditmode.popmenu( w_main_frame.pointerx() , w_main_frame.pointery() ) 
else
//===================================================
// $$HEX22$$70b374c7c0d0200008c7c4b3b0c6200018c215c82000a8badcb400ac200044c5ccb220002000bdacb0c62000$$ENDHEX$$
//===================================================	
	
	if upper(dwo.type) = 'DATAWINDOW'  or Upper(this.Describe( dwo.name+'.Edit.Style')) = "CHECKBOX" THEN 
		m_main_frame_menu.m_control.popmenu( w_main_frame.pointerx() , w_main_frame.pointery() ) 		
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
			END IF
	END IF	
	
end if
end event

type dw_1 from datawindow within w_graph_root
event ue_accepttext ( )
event ue_entertotab pbm_dwnprocessenter
event ue_dwkey pbm_dwnkey
event uo_mousemove pbm_dwnmousemove
event ue_unmoved pbm_syscommand
integer x = 5
integer y = 2132
integer width = 4507
integer height = 388
integer taborder = 10
string dragicon = "DataPipeline!"
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_accepttext;THIS.ACCEPTTEXT()
end event

event ue_entertotab;IF GVS_ENTERTOTAB_YN = 'Y' THEN

	SEND(HANDLE(THIS),256,9,983041)
	RETURN 1
END IF
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
//											( "Notify" , Upper(this.Describe( Getcolumnname()+'.Edit.Style')) +" Is not the check box type" ) 
											return
										end if
	                                             Msg = f_msgbox( 119 )															
//										Msg = ("Confirm" , "Name="+Getcolumnname()+ "  The whole it selects? [Yes = Select , No = Cancel ]" , question! , yesnocancel!)
										
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
							
							post event rbuttondown(  0 , 0 , 1 , ls_anydata )
							
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

event ue_unmoved;CHOOSE CASE commandtype
	CASE 61456, 61458
		message.processed = true
		message.returnvalue = 0
END CHOOSE

return

end event

event clicked;//************************************************************************************
// QUICK SORT $$HEX2$$98ccacb9$$ENDHEX$$
//************************************************************************************
selected_data_window = this
IF Gvi_dw_edit_mode = 0 THEN  //$$HEX10$$18c215c8a8badcb400ac200044c5c8b274ba2000$$ENDHEX$$

			if keydown(KeyControl!) and  UPPER(DWO.TYPE) = 'TEXT' then
				IF row = 0 THEN 
					F_QUICK_SORT(THIS , MID(STRING(DWO.NAME),1,LEN(STRING(DWO.NAME)) - 2) )
				END IF
				
			ELSE
				 STRING LVS_VALUE
				 IF  UPPER(DWO.TYPE) = 'COLUMN' THEN
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
				THIS.SCROLLTOROW(ROW)
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
	F_MSGBOX2(162, STRING(SQLCA.SQLCODE)+'  '+LVS_CONSTRAINTS_NAME , LVS_TABLE_NAME )		
	return 1
ELSEIF sqldbcode = 1400 THEN // NULL CHECK
	
	//ORA-01400: CANNOT INSERT NULL INTO ("TAPM"."CORRELATOR"."CORRELATOR_ID")

	LVS_COLUMN_NAME = MID( sqlerrtext , POS( sqlerrtext , '.' ,1 ) + 2 ,   POS(sqlerrtext , ')' ) - POS( sqlerrtext , '.' ,1 ) + 2     )
	LVS_COLUMN_NAME = MID( LVS_COLUMN_NAME , POS( LVS_COLUMN_NAME , '.' ,1 ) + 2 , LEN(LVS_COLUMN_NAME)  -  POS( LVS_COLUMN_NAME , '.' ,1 )  - 6 ) 
	
	SELECT DECODE( :GVS_LANGUAGE , 'K' , WORD_KOR , 'E' , WORD_ENG , WORD_LOCAL ) ,
             	   DECODE( :GVS_LANGUAGE , 'K' , WORD_DESCRIPTION_KOR , 'E' , WORD_DESCRIPTION_ENG , WORD_DESCRIPTION_LOCAL ) 
	   INTO :LVS_COLUMN_NAME_LOCAL , :LVS_COLUMN_DESC_LOCAL
	  FROM ISYS_WORD_DICTIONARY
    WHERE WORD_ENG = :LVS_COLUMN_NAME
	    AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID;
	 
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

	IF ivs_dw_1_selected_row_yn = 'Y' THEN 
		
			THIS.SELECTROW(0 , FALSE )		
			THIS.SELECTROW(row , TRUE )
			THIS.SETROW(ROW)
		
	END IF

END IF
//=======================================

RETURN 1
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


string ls_ColName , ls_text
ls_ColName = this.GetColumnName()+'_t'
ls_text = trim(this.describe(ls_ColName + ".text"))
IF MID(ls_text,1,1) = '*' THEN 
ELSE
	ls_text = '*'+ls_text
END IF


this.modify(ls_ColName + ".text = '" + ls_text + "'")
//
end event

event itemerror;f_MSGBOX1( 174 , DATA )

//("Data Input Error" , 'Data Invalid Check Data Length or Data Type ( String , Number , Date ...)  =>' + data ) 
RETURN 1
end event

event itemfocuschanged; ls_anydata = dwo
//if Gvs_popup_auto_active = 'Y' THEN
//	TRIGGER EVENT RBUTTONDOWN( 0 , 0 , ROW , DWO )
//end if
end event

event retrieveend;IF ISVALID(W_CANCEL_RETRIEVE_POP) THEN
	CLOSE(W_CANCEL_RETRIEVE_POP)
ELSE
	
END IF

if setrow = 0 then
	F_MSG_MDI_HELP ( F_MSG_ST( 117)  )
	THIS.SETFOCUS()		
	RETURN
else
 	F_MSG_MDI_HELP( F_MSG_ST1( 9013 , string(setrow) ))
	THIS.SCROLLTOROW(1)	
	THIS.SETFOCUS()
	RETURN
end if


end event

event retrieverow;setrow++
F_MSG_MDI_HELP( string(setrow)+" Rows Retrieve.." )

IF ISVALID(W_CANCEL_RETRIEVE_POP) THEN 
	
	W_CANCEL_RETRIEVE_POP.SLE_RETRIEVED_ROWS.TEXT = STRING(SETROW)

ELSE
	 THIS.Modify("DataWindow.Retrieve.AsNeeded=No")	
	 THIS.DBCANCEL()	 
	 RETURN 1
END IF

end event

event retrievestart;	IF ivs_modify_security = 'Y' THEN
		
		IF THIS.MODIFIEDCOUNT() > 0 OR DELETEDCOUNT() > 0 THEN 
			
			Msg = F_MSGBOX1( 9014 , String(THIS.MODIFIEDCOUNT()+THIS.DELETEDCOUNT()))
			
			if Msg = 1 then 	
				
				Gvs_Ue_DATA_control = 'UPDATE'
				Parent.Triggerevent("UE_DATA_CONTROL")
				
			ELSEIF Msg = 2 then 	//NO 
				
				ROLLBACK ;
				RETURN
				
			ELSE // CANCEL
				 RETURN
			END IF 
			
		END IF
		
	END IF
		
	
	SETROW = 0 
	IF ISVALID(W_CANCEL_RETRIEVE_POP) THEN
		CLOSE(W_CANCEL_RETRIEVE_POP)
	ELSE
		IF ivs_dw_1_retrice_cancel_popup_open = 'Y' THEN 
			OPEN(W_CANCEL_RETRIEVE_POP)
		END IF
	END IF

end event

event updatestart;SETPOINTER(HourGlass!)
end event

event error;if f_msgbox1( 144 , STRING(ERRORNUMBER)+" "+ERRORTEXT+" "+errorwindowmenu+" "+errorobject+" "+errorscript+" "+STRING(errorline)+" ") = 1 then 
   Rollback;
   Disconnect ;
   Halt Close
else
	action  = EXCEPTIONiGNORE!
end if
end event

event sqlpreview;Gvs_last_sqlsyntax = sqlsyntax
end event

event updateend;if rowsdeleted + rowsupdated + rowsinserted = 0 then 
	return
end if


openwithparm(w_updateend_message_ontime , 0.5 )

if isvalid(w_updateend_message_ontime) then 
	
	w_updateend_message_ontime.sle_insert.text = string(rowsinserted)
	w_updateend_message_ontime.sle_update.text = string(rowsupdated)
	w_updateend_message_ontime.sle_delete.text = string(rowsdeleted)	
	
	w_updateend_message_ontime.st_rows.text =string( rowsdeleted + rowsupdated + rowsinserted)
	
end if

end event

event rbuttondown;String lvs_date , LVS_VALUE

if  UPPER(dwo.type) = 'COLUMN' then

		LVS_VALUE = string(dwo.primary[row])	
		IF ISNULL(LVS_VALUE) THEN 
		 LVS_VALUE = ' '	
		END IF
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
//	m_main_frame_menu.m_system.m_reportmanage.m_reporteditmode.popmenu( w_main_frame.pointerx() , w_main_frame.pointery() ) 
else
//===================================================
// $$HEX22$$70b374c7c0d0200008c7c4b3b0c6200018c215c82000a8badcb400ac200044c5ccb220002000bdacb0c62000$$ENDHEX$$
//===================================================	
	
	if upper(dwo.type) = 'DATAWINDOW'  or Upper(this.Describe( dwo.name+'.Edit.Style')) = "CHECKBOX" THEN 
		m_main_frame_menu.m_control.popmenu( w_main_frame.pointerx() , w_main_frame.pointery() ) 		
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
			END IF
	END IF	
	
end if
end event

event rowfocuschanged;LONG I
IF currentrow = 0  or gvs_deleteselecte_mod = 'Y' THEN RETURN

IF ivs_dw_1_selected_row_yn = 'Y' THEN 

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

type gb_view from so_groupbox within w_graph_root
integer width = 2651
integer height = 392
integer taborder = 10
integer weight = 700
long textcolor = 65535
string text = "Where Condition"
borderstyle borderstyle = styleraised!
end type

type gb_process from so_groupbox within w_graph_root
integer x = 2670
integer width = 448
integer height = 388
integer taborder = 20
integer weight = 700
long textcolor = 255
string text = "Process"
borderstyle borderstyle = styleraised!
end type

type gr_1 from graph within w_graph_root
event ue_mousemove pbm_mousemove
event create ( )
event destroy ( )
integer y = 388
integer width = 4507
integer height = 1736
boolean border = true
grgraphtype graphtype = colgraph!
long backcolor = 67108864
long shadecolor = 6316128
integer spacing = 100
integer elevation = 20
integer rotation = -20
integer perspective = 2
integer depth = 100
grlegendtype legend = atbottom!
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event ue_mousemove;integer 	SeriesNbr, ItemNbr

string 	data_value,	&
			old_data

grObjectType	object_type
string 	SeriesName,			&
			ls_CategoryName,		&
			ls_SeriesName
string 	ls_name
long		ll_width

object_type 		      = 	gr_1.ObjectAtPointer(SeriesNbr, ItemNbr)
ls_CategoryName	=	gr_1.CategoryName(ItemNbr)
ls_SeriesName		=	gr_1.SeriesName (SeriesNbr )
setpointer(arrow!)

IF object_type = TypeData! THEN 
	
	old_data		=	data_value
	data_value 	= 	String( gr_1.GetData(SeriesNbr, ItemNbr) , "###,###,##0.00")
		
	if st_label.visible and old_data = data_value then
		return
	end if
	
	ll_width	=	len( data_value ) * 40
	st_label.text = data_value
//	st_label.x 	=   xpos - 2
//	st_label.y	=	ypos + 250
	st_label.x 	=   parent.pointerx( ) - 2
	st_label.y	=   parent.pointery( ) + 250
	
	st_label.width	=	ll_width
	st_label.visible = true	
	
	f_msg_mdi_help( ls_SeriesName + ' ** ' + ls_CategoryName + ' ** (' + data_value + ')' )
	
ELSEIF object_type = TypeCategory! THEN
		
	ll_width	=	len( ls_CategoryName ) * 40
	st_label.text = ls_CategoryName
	
	st_label.x 	=   parent.pointerx( ) - 2
	st_label.y	=   parent.pointery( ) + 250
	
//	st_label.x 	=  xpos - 2
//	st_label.y	=	ypos + 250
	st_label.width	=	ll_width
	st_label.visible = true	
	
	f_msg_mdi_help( ls_CategoryName )
ELSE
	f_msg_mdi_help("")
	st_label.visible 	= 	false	
END IF

end event

on gr_1.create
TitleDispAttr = create grDispAttr
LegendDispAttr = create grDispAttr
PieDispAttr = create grDispAttr
Series = create grAxis
Series.DispAttr = create grDispAttr
Series.LabelDispAttr = create grDispAttr
Category = create grAxis
Category.DispAttr = create grDispAttr
Category.LabelDispAttr = create grDispAttr
Values = create grAxis
Values.DispAttr = create grDispAttr
Values.LabelDispAttr = create grDispAttr
TitleDispAttr.Weight=700
TitleDispAttr.FaceName="Tahoma"
TitleDispAttr.FontCharSet=DefaultCharSet!
TitleDispAttr.FontFamily=Swiss!
TitleDispAttr.FontPitch=Variable!
TitleDispAttr.Alignment=Center!
TitleDispAttr.BackColor=553648127
TitleDispAttr.Format="[General]"
TitleDispAttr.DisplayExpression=" title "
TitleDispAttr.AutoSize=true
Category.AutoScale=true
Category.ShadeBackEdge=true
Category.SecondaryLine=transparent!
Category.MinorGridLine=transparent!
Category.DropLines=transparent!
Category.OriginLine=transparent!
Category.MajorTic=Straddle!
Category.DataType=adtText!
Category.DispAttr.TextSize=11
Category.DispAttr.Weight=400
Category.DispAttr.FaceName="Tahoma"
Category.DispAttr.FontCharSet=DefaultCharSet!
Category.DispAttr.FontFamily=Swiss!
Category.DispAttr.FontPitch=Variable!
Category.DispAttr.Alignment=Center!
Category.DispAttr.BackColor=553648127
Category.DispAttr.Format="[General]"
Category.DispAttr.DisplayExpression=" categoryaxislabel "
Category.DispAttr.Escapement=900
Category.LabelDispAttr.TextSize=16
Category.LabelDispAttr.Weight=400
Category.LabelDispAttr.FaceName="Tahoma"
Category.LabelDispAttr.FontCharSet=DefaultCharSet!
Category.LabelDispAttr.FontFamily=Swiss!
Category.LabelDispAttr.FontPitch=Variable!
Category.LabelDispAttr.Alignment=Center!
Category.LabelDispAttr.BackColor=553648127
Category.LabelDispAttr.Format="[General]"
Category.LabelDispAttr.DisplayExpression="categoryaxislabel"
Values.AutoScale=true
Values.RoundTo=4
Values.MajorDivisions=10
Values.MajorGridLine=dot!
Values.MinorGridLine=dot!
Values.DropLines=transparent!
Values.MajorTic=Inside!
Values.MinorTic=Inside!
Values.DataType=adtDouble!
Values.DispAttr.TextSize=16
Values.DispAttr.Weight=400
Values.DispAttr.FaceName="Tahoma"
Values.DispAttr.FontCharSet=DefaultCharSet!
Values.DispAttr.FontFamily=Swiss!
Values.DispAttr.FontPitch=Variable!
Values.DispAttr.Alignment=Right!
Values.DispAttr.BackColor=553648127
Values.DispAttr.Format="[General]"
Values.DispAttr.DisplayExpression="value"
Values.LabelDispAttr.TextSize=16
Values.LabelDispAttr.Weight=400
Values.LabelDispAttr.FaceName="Tahoma"
Values.LabelDispAttr.FontCharSet=DefaultCharSet!
Values.LabelDispAttr.FontFamily=Swiss!
Values.LabelDispAttr.FontPitch=Variable!
Values.LabelDispAttr.Alignment=Center!
Values.LabelDispAttr.BackColor=553648127
Values.LabelDispAttr.Format="[General]"
Values.LabelDispAttr.DisplayExpression="valuesaxislabel"
Series.Label="(None)"
Series.AutoScale=true
Series.SecondaryLine=transparent!
Series.MajorGridLine=transparent!
Series.MinorGridLine=transparent!
Series.DropLines=transparent!
Series.OriginLine=transparent!
Series.MajorTic=Outside!
Series.DataType=adtText!
Series.DispAttr.TextSize=16
Series.DispAttr.Weight=400
Series.DispAttr.FaceName="Tahoma"
Series.DispAttr.FontCharSet=DefaultCharSet!
Series.DispAttr.FontFamily=Swiss!
Series.DispAttr.FontPitch=Variable!
Series.DispAttr.BackColor=553648127
Series.DispAttr.Format="[General]"
Series.DispAttr.DisplayExpression="series"
Series.LabelDispAttr.TextSize=16
Series.LabelDispAttr.Weight=400
Series.LabelDispAttr.FaceName="Tahoma"
Series.LabelDispAttr.FontCharSet=DefaultCharSet!
Series.LabelDispAttr.FontFamily=Swiss!
Series.LabelDispAttr.FontPitch=Variable!
Series.LabelDispAttr.Alignment=Center!
Series.LabelDispAttr.BackColor=553648127
Series.LabelDispAttr.Format="[General]"
Series.LabelDispAttr.DisplayExpression="seriesaxislabel"
LegendDispAttr.TextSize=16
LegendDispAttr.Weight=400
LegendDispAttr.FaceName="Tahoma"
LegendDispAttr.FontCharSet=DefaultCharSet!
LegendDispAttr.FontFamily=Swiss!
LegendDispAttr.FontPitch=Variable!
LegendDispAttr.BackColor=553648127
LegendDispAttr.Format="[General]"
LegendDispAttr.DisplayExpression="series"
PieDispAttr.Weight=400
PieDispAttr.FaceName="Tahoma"
PieDispAttr.FontCharSet=DefaultCharSet!
PieDispAttr.FontFamily=Swiss!
PieDispAttr.FontPitch=Variable!
PieDispAttr.BackColor=536870912
PieDispAttr.Format="[General]"
PieDispAttr.DisplayExpression="if(seriescount > 1, series,string(percentofseries,~"0.00%~"))"
PieDispAttr.AutoSize=true
end on

on gr_1.destroy
destroy TitleDispAttr
destroy LegendDispAttr
destroy PieDispAttr
destroy Series.DispAttr
destroy Series.LabelDispAttr
destroy Series
destroy Category.DispAttr
destroy Category.LabelDispAttr
destroy Category
destroy Values.DispAttr
destroy Values.LabelDispAttr
destroy Values
end on

