HA$PBExportHeader$w_main_root.srw
$PBExportComments$Main Root Window
forward
global type w_main_root from window
end type
type dw_5 from datawindow within w_main_root
end type
type dw_4 from datawindow within w_main_root
end type
type dw_3 from datawindow within w_main_root
end type
type dw_2 from datawindow within w_main_root
end type
type dw_1 from datawindow within w_main_root
end type
type uo_tabpages from uo_tabpage within w_main_root
end type
end forward

global type w_main_root from window
integer width = 5477
integer height = 3456
boolean titlebar = true
string title = "Workspace"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 12632256
string icon = "AppIcon!"
event ue_data_control ( )
event ue_post_open ( )
event ue_unmoved pbm_syscommand
event ue_help_comment ( )
dw_5 dw_5
dw_4 dw_4
dw_3 dw_3
dw_2 dw_2
dw_1 dw_1
uo_tabpages uo_tabpages
end type
global w_main_root w_main_root

type variables
DWObject ls_anydata
Double setrow

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



end variables

forward prototypes
public function integer wf_set_window_property (string arg_window_name)
public function integer wf_size_it ()
public function integer wf_resize_it (double size_factor)
public function integer wf_resize_it_width_fit (double size_factor)
public function integer wf_set_column_dddw ()
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
		
		if isvalid(w_item_search_flat) then 
			close(w_item_search_flat)
		end if 
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

event ue_post_open();double ratiow, ratio, ratioh
int rc

open(w_please_wait_popup)

F_SYSTEM_ACCESS( THIS.CLASSNAME() , 'WINDOW' , 'OPEN')
/***********************************************************
* DATA WINDOW DDDW  "vd_basecode" Auto Set
************************************************************/
//f_set_column_dddw( dw_1 )
//f_set_column_dddw( dw_2 )
//f_set_column_dddw( dw_3 )
//f_set_column_dddw( dw_4 )
//f_set_column_dddw( dw_5 )

/***********************************************************
* DATA WINDOW SIZE $$HEX2$$c0bcbdac$$ENDHEX$$
************************************************************/
if UPPER(IVS_RESIZE_TYPE) = 'NORMAL' THEN

dw_1.resize(width - dw_1.x  -34 , height - dw_1.y -120)	
dw_2.resize(width - dw_2.x - 34, height - dw_2.y -120)		
dw_3.resize(width - dw_3.x - 34, height - dw_3.y -120)
dw_4.resize(width - dw_4.x - 34, height - dw_1.y -120)	
dw_5.resize(width - dw_5.x - 34, height - dw_2.y -120)		

ELSEIF  UPPER(IVS_RESIZE_TYPE) = 'NORMAL_WIDE' THEN

dw_1.resize(width - dw_1.x  -34, dw_1.height)	
dw_2.resize(width - dw_2.x - 34, dw_2.height)		
dw_3.resize(width - dw_3.x - 34, dw_3.height)
dw_4.resize(width - dw_4.x - 34, dw_4.height)	
dw_5.resize(width - dw_5.x - 34, dw_5.height)		


ELSEIF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL' THEN //1345_2
	
	dw_1.resize(width - dw_1.x -34, height - ( dw_1.y + dw_2.height +120 ))
	dw_3.resize(width - dw_3.x -34, height - ( dw_3.y + dw_2.height +120))	
	dw_4.resize(width - dw_4.x -34, height - ( dw_4.y + dw_2.height +120))		
	dw_5.resize(width - dw_5.x -34, height - ( dw_5.y + dw_2.height +120))	
	
	dw_2.y = dw_1.y + dw_1.HEIGHT
     dw_2.resize(width - dw_5.x -34, dw_2.height )	
ELSEIF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL_TOP' THEN
	
	dw_1.resize(width - dw_1.x -34, height - ( dw_1.y + dw_2.height +120 ))
	dw_3.resize(width - dw_3.x -34, height +120)	
	dw_4.resize(width - dw_4.x -34, height +120)		
	dw_5.resize(width - dw_5.x -34, height +120)	
	
	 dw_2.y = dw_1.y + dw_1.HEIGHT
     dw_2.resize(width - dw_5.x -34, dw_2.height )		  
ELSEIF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL_R5' THEN //1345_2
	
	dw_1.resize(width  - (dw_1.x + dw_5.width +34), height -120  - dw_1.y)
	dw_2.resize(width  - (dw_3.x + dw_5.width +34), height -120  - dw_1.y)	
	dw_3.resize(width  - (dw_3.x + dw_5.width +34), height -120  - dw_1.y)	
	dw_4.resize(width  - (dw_4.x + dw_5.width +34), height -120  - dw_1.y)	

     dw_5.y = dw_1.y
	dw_5.x = dw_1.x + dw_1.width
     dw_5.height = dw_1.height	  
	  
ELSEIF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL_F5' THEN //1345_2
	
	dw_1.resize(width - dw_1.x -34, height - ( dw_1.y + dw_2.height +120 ))
	dw_3.resize(width - dw_3.x -34, height - ( dw_3.y + dw_2.height +120))	
	dw_4.resize(width - dw_4.x -34, height - ( dw_4.y + dw_2.height +120))		
	
	dw_2.y = dw_1.y + dw_1.HEIGHT
     dw_2.resize(width - dw_1.x -34, dw_2.height )		  	  
ELSEIF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL_F4FIX_23M' THEN //1345_2
	
	dw_1.resize(width  - ( dw_1.x  + dw_4.width ) , height - ( dw_1.y + dw_2.height)  )
	dw_5.resize(dw_1.width , dw_1.height)
	
	dw_4.resize( dw_4.width , dw_1.height)	// $$HEX11$$00ac5cb8200038c15cb82000edd32000e0ac15c82000$$ENDHEX$$
	dw_4.x = width - dw_4.width

	dw_2.y = dw_1.y + dw_1.HEIGHT
	dw_2.resize(width / 2 -34, dw_2.height - 120 )	
	
	dw_3.x =  dw_2.x + dw_2.width 
	dw_3.y = dw_2.y
	dw_3.resize(width - dw_2.width , dw_2.height )		 
ELSEIF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL_135_24' THEN
	
	dw_1.resize(width -34, height - ( dw_1.y + dw_2.height +120 ))
	dw_3.resize(width -34, height - ( dw_3.y + dw_2.height +120))	
	dw_5.resize(width -34, height - ( dw_5.y + dw_2.height +120))	
	
	dw_2.y = dw_1.y + dw_1.HEIGHT
     dw_2.resize(width -34, dw_2.height )	
	dw_4.y = dw_1.y + dw_1.HEIGHT
     dw_4.resize(width -34, dw_4.height )		  	  
	  
ELSEIF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL_145_23' THEN
	
	dw_1.resize(width -34, height - ( dw_1.y + dw_2.height +120 ))
	dw_4.resize(width -34, height - ( dw_4.y + dw_2.height +120))	
	dw_5.resize(width -34, height - ( dw_5.y + dw_2.height +120))	
	
	dw_2.y = dw_1.y + dw_1.HEIGHT
     dw_2.resize(width -34, dw_2.height )	
	dw_3.y = dw_1.y + dw_1.HEIGHT
     dw_3.resize(width -34, dw_3.height )		  	  	  
	  
ELSEIF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL_145_23M' THEN
	
	dw_1.resize(width -34, height - ( dw_1.y + dw_2.height +120 ))
	dw_4.resize(width -34, height - ( dw_4.y + dw_2.height +120))	
	dw_5.resize(width -34, height - ( dw_5.y + dw_2.height +120))	

	dw_2.y = dw_1.y + dw_1.HEIGHT
     dw_2.resize(width / 2 -34, dw_2.height )	
	  
	dw_3.x =  dw_2.x + dw_2.width 
	dw_3.y = dw_1.y + dw_1.HEIGHT
      dw_3.resize(width / 2 -34, dw_3.height )		
	  
ELSEIF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL_145_2F3M' THEN
	
	dw_1.resize(width -34, height - ( dw_1.y + dw_2.height +120 ))
	dw_4.resize(width -34, height - ( dw_4.y + dw_2.height +120))	
	dw_5.resize(width -34, height - ( dw_5.y + dw_2.height +120))	

	dw_2.y = dw_1.y + dw_1.HEIGHT
      //dw_2.resize(width / 2 -34, dw_2.height )	
	  
	dw_3.x =  dw_2.x + dw_2.width 
	dw_3.y = dw_1.y + dw_1.HEIGHT
      dw_3.resize(width -dw_2.width -34, dw_3.height )			  
ELSEIF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL_145F_23' THEN
	
	dw_1.resize(width -34  - ( dw_1.x  + dw_5.width ) , height  - ( dw_1.y + dw_2.height + 120 ))	
	dw_4.resize(width -34  - ( dw_1.x  + dw_5.width ) , height  - ( dw_1.y + dw_2.height + 120))		

	dw_5.resize( dw_5.width -34 , dw_1.height)	// $$HEX8$$00ac5cb82000edd32000e0ac15c82000$$ENDHEX$$
	dw_5.x =dw_1.x + dw_1.width
	

	dw_2.y = dw_1.y + dw_1.HEIGHT
	dw_2.resize(width -34, dw_2.height )	
	
	dw_3.y = dw_1.y + dw_1.HEIGHT
	dw_3.resize(width -34, dw_3.height )		
ELSEIF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL_145TF_23M' THEN //145 TOP FIX 
	
	dw_1.resize(width -34 , dw_1.height)
	dw_4.resize(width -34 , dw_4.height)	
	dw_5.resize(width -34 , dw_5.height)	

	dw_2.y = dw_1.y + dw_1.HEIGHT 
      dw_2.resize(width  / 2 - 34 , height -34 - ( dw_1.y + dw_1.height+120 ))
	  
	dw_3.x = dw_2.x + dw_2.width  
	dw_3.y = dw_1.y + dw_1.HEIGHT 
      dw_3.resize(width / 2 - 34 , height -34 - ( dw_1.y + dw_1.height +120))
	  
ELSEIF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL_14_235M' THEN
	
	dw_1.resize(width -34, height - ( dw_1.y + dw_2.height +120 ))
	dw_4.resize(width -34, height - ( dw_4.y + dw_2.height +120))	


	dw_2.y = dw_1.y + dw_1.HEIGHT
      dw_2.resize(width / 2 -34, dw_2.height )	
	  
	dw_3.x =  dw_2.x + dw_2.width 
	dw_3.y = dw_1.y + dw_1.HEIGHT
     dw_3.resize(width / 2 -34, dw_3.height )		
	  
	dw_5.y = dw_1.y + dw_1.HEIGHT	  
	dw_5.resize(width -34,dw_5.height  )
	  
ELSEIF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL_12T_3B' THEN
	
		
	dw_1.resize( ((width - dw_1.x) -34) / 2 , height - ( dw_1.y + dw_3.height )  )
	
	dw_2.x = dw_1.x + dw_1.width 
	dw_2.resize( ((width - dw_1.x ) -34)  - dw_1.width, dw_1.height)	
	
	dw_3.y = dw_1.y + dw_1.HEIGHT 
	dw_3.resize(( width - dw_1.x ) -34 , dw_3.height - 100) 
	
	dw_4.resize( ((width - dw_1.x) -34)  , height - ( dw_1.y  +100)  )
	dw_5.resize( ((width - dw_1.x) -34)  , height - ( dw_1.y  + 100)  )
	
ELSEIF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL_12T_34B' THEN
	
		
	dw_1.resize( (width -34) / 2 , height - ( dw_1.y + dw_3.height )  )
	
	dw_2.x = dw_1.x + dw_1.width 
	dw_2.resize( (width -34)  - dw_1.width, dw_1.height)	
	
	dw_3.y = dw_1.y + dw_1.HEIGHT 
	dw_3.resize(dw_1.width -34 , dw_3.height - 100) 
	
	
	dw_4.x = dw_2.x
	dw_4.y = dw_2.y + dw_2.HEIGHT 
	dw_4.resize(dw_2.width -34 , dw_4.height - 100) 
	
	
	dw_5.resize( (width -34)  , height - ( dw_1.y  + 100)  )	  
	
ELSEIF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL_12T_345B' THEN
	
		
	dw_1.resize( (width -34) / 2 , height - ( dw_1.y + dw_3.height )  )
	
	dw_2.x = dw_1.x + dw_1.width 
	dw_2.resize( (width -34)  - dw_1.width, dw_1.height)	
	
	dw_3.y = dw_1.y + dw_1.HEIGHT 
	dw_3.resize(dw_1.width  , dw_3.height - 100) 
	
	
	dw_4.x = dw_2.x
	dw_4.y = dw_2.y + dw_2.HEIGHT 
	dw_4.resize(dw_2.width , dw_4.height - 100) 
	
	dw_5.y = dw_3.y
	dw_5.resize( (width -34)  , dw_3.height )	  	
	
ELSEIF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL_12T' THEN
	
		
	dw_1.resize( (width -34) / 2 , height - ( dw_1.y +120)  )
	
	dw_2.x = dw_1.x + dw_1.width 
	dw_2.resize( (width -34)  - dw_1.width, dw_1.height)	
	dw_3.resize(width - dw_3.x - 34, height - dw_3.y -120)
	dw_4.resize(width - dw_4.x - 34, height - dw_1.y -120)	
	dw_5.resize(width - dw_5.x - 34, height - dw_2.y -120)		

	  
ELSEIF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL_1L2R' THEN
	
		
	dw_1.resize( dw_1.width -34 , height - ( dw_1.y +120)  )
	
	dw_2.x = dw_1.x + dw_1.width 
	dw_2.resize( (width -34)  - dw_1.width, dw_1.height)		  
	
dw_3.resize(width - dw_3.x - 34, height - dw_3.y -120)
dw_4.resize(width - dw_4.x - 34, height - dw_1.y -120)	
dw_5.resize(width - dw_5.x - 34, height - dw_2.y -120)		


ELSEIF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL_1L2345R' THEN
	
	dw_1.resize( dw_1.width -34 , height - (dw_1.y +120 ) )
	
	dw_2.x = dw_1.x + dw_1.width 
	dw_2.resize(  width  - dw_1.width - 34 , dw_1.height)	
	
		dw_3.x = dw_2.x
	dw_4.x = dw_2.x
	dw_5.x = dw_2.x
	
	dw_3.resize(dw_2.width , dw_1.height )
	dw_4.resize(dw_2.width  , dw_1.height )	
	dw_5.resize(dw_2.width  , dw_1.height )	

ELSEIF  UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL_1L2R4B' THEN
	
	dw_1.resize(width - (dw_1.x + dw_2.width + 34  ), height - dw_1.y - 120 )
	dw_2.x = dw_1.x +dw_1.width
	dw_2.y = dw_1.y
	dw_2.resize(dw_2.width ,  height  -  ( dw_2.y+dw_4.height) )
	dw_3.resize(width  - dw_3.x , height -  dw_3.y )
	dw_4.bringtotop = true
	dw_4.y = dw_2.y+ dw_2.height
	dw_4.x = dw_2.x
	dw_4.resize(dw_2.width -34  , dw_4.height  - 120)
	dw_5.resize(dw_1.width , dw_1.height )
	
ELSEIF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL_1L2FR' THEN
	
		
	dw_1.resize( width - ( dw_2.width -34 ) , height - ( dw_1.y +120)  )
	
	dw_2.x = dw_1.x + dw_1.width 
	dw_2.resize( (width -34)  - dw_1.width, dw_1.height)		
	
	dw_3.y = dw_1.y 
	dw_3.x = dw_1.x  
	dw_3.resize(width -dw_3.x -34 , dw_1.height )
	
	dw_4.y = dw_1.y 
	dw_4.x = dw_1.x  
	dw_4.resize(width -dw_4.x -34, dw_1.height )
	
	dw_5.y = dw_1.y 
	dw_5.x = dw_1.x  
	dw_5.resize(width -dw_5.x -34, dw_1.height )			

ELSEIF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL_1LF2R' THEN

	dw_1.resize( width - ( dw_2.width -34 ) , height - ( dw_1.y +120)  )
	
	dw_2.x = dw_1.x + dw_1.width 
	dw_2.resize( (width -34)  - dw_1.width, dw_1.height)		
	
	dw_3.y = dw_1.y 
	dw_3.x = dw_1.x  
	dw_3.resize(dw_1.width , dw_1.height )
	
	dw_4.y = dw_1.y 
	dw_4.x = dw_1.x  
	dw_4.resize(dw_1.width, dw_1.height )
	
	dw_5.y = dw_1.y 
	dw_5.x = dw_1.x  
	dw_5.resize(dw_1.width, dw_1.height )		 	  
	
ELSEIF UPPER(IVS_RESIZE_TYPE) = 'FREEFORM' THEN
	
////////////////////////////////////////////////////////////////////////////////////////////////////
// resize script for w_scale
////////////////////////////////////////////////////////////////////////////////////////////////////
	
		// recalculate the new ratios and then use the minimum
		if ib_exec then  // Check to see if wf_resize_it is already running.
			ratioh  = this.height /ii_win_height
			ratiow = this.width / ii_win_width
			ratio = min (ratioh, ratiow)
			rc = wf_resize_it(ratio)  //RATIO = SIZE FACTOR
		end if	  
ELSEIF UPPER(IVS_RESIZE_TYPE) = 'FREEFORM_WIDTH_FIT' THEN
	
////////////////////////////////////////////////////////////////////////////////////////////////////
// resize script for w_scale
////////////////////////////////////////////////////////////////////////////////////////////////////
		
		// recalculate the new ratios and then use the minimum
		if ib_exec then  // Check to see if wf_resize_it is already running.
			ratioh  = this.height /ii_win_height
			ratiow = this.width / ii_win_width
			ratio = min (ratioh, ratiow)
			rc = wf_resize_it_width_fit(ratio)  //RATIO = SIZE FACTOR
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
if isvalid(w_collapsemenu) then 
	if  w_collapsemenu.ib_locked = false then
	   w_collapsemenu.pb_close.triggerevent(clicked!)
	end if 
end if 
//=================================
// $$HEX15$$68d518c2d0c51cc12000edd000ad28b82000acc06dd5200098ccacb92000$$ENDHEX$$
//=================================

GVI_OPENTAB_COUNT ++
end event

event ue_unmoved;CHOOSE CASE commandtype
	CASE 61456, 61458
		message.processed = true
		message.returnvalue = 0
END CHOOSE

return

end event

public function integer wf_set_window_property (string arg_window_name);F_MSG_MDI_HELP('Function :wf_window_property-> select  from isys_window')  		

  SELECT UPPER(:ARG_WINDOW_NAME) , 
               UPPER(DECODE( :GVS_LANGUAGE , 'K' ,  WINDOW_DESCRIPTION_KOR,  'E' ,  WINDOW_DESCRIPTION_ENG , WINDOW_DESCRIPTION_LOCAL )) WINDOW_TITLE,
               UPPER(DECODE( :GVS_LANGUAGE , 'K' ,  WINDOW_DESCRIPTION_KOR,  'E' ,  WINDOW_DESCRIPTION_ENG , WINDOW_DESCRIPTION_LOCAL )) WINDOW_DESCRIPTION ,
               UPPER(WINDOW_TYPE),
		VERSION
INTO   :Gst_set.window_id,   
		:Gst_set.window_title,   
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
	Gst_set.window_comment   =W_MAIN_FRAME.GETACTIVESHEET().title
	Gst_set.window_type      = 'None'
	Gst_set.version	       = 0
	
END IF

// isys_window $$HEX13$$04d689d554d600ac200048c51cb42000c1c0dcd0d0c51cc12000$$ENDHEX$$window name $$HEX10$$c0bcbdac3cc75cb8200084c7dcc22000c0bcbdac$$ENDHEX$$
 THIS.TITLE = Gst_set.window_title

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


this.setredraw( false)

F_MSG_MDI_HELP('Function :wf_window_property-> SELECT FROM ISYS_WINDOW_PROPERTY CURSOR OPEN')  		
//==========================================================================
//
//==========================================================================
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
			
	
	F_MSG_MDI_HELP('Function :wf_window_property-> SELECT FROM ISYS_WINDOW_PROPERTY CURSOR FETCH')  		
	
	IF  UPPER(LVS_DATAWINDOW_NAME) = 'DW_1' THEN

			IF  UPPER(LVS_OBJECT_TYPE) = 'COLUMN' THEN

						DW_1.Modify(LVS_COLUMN_NAME + ".Format='"+LVS_FORMAT+"'")	
						DW_1.Modify(LVS_COLUMN_NAME + ".Alignment='"+LVS_OBJECT_ALIGNMENT+"'")							
						
						if lvs_visible_yn = '0' THEN 
							DW_1.Modify(LVS_COLUMN_NAME + ".Visible='"+lvs_visible_yn+"'")		
						end if
						

						
						IF LONG(LVS_COLUMN_ORDER) < 0  OR LVS_COLUMN_ORDER = '?' OR ISNULL(LVS_COLUMN_ORDER) THEN 
							DW_1.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")									
							DW_1.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")															
						ELSE
							DW_1.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")									
							DW_1.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																
						END IF
						
						DW_1.Modify(LVS_COLUMN_NAME + ".width='"+lvs_width+"'")			
						DW_1.Modify(LVS_COLUMN_NAME + ".height='"+lvs_height+"'")									
								
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
						

						
						IF LONG(LVS_COLUMN_ORDER) < 0  OR LVS_COLUMN_ORDER = '?' OR ISNULL(LVS_COLUMN_ORDER) THEN 
							DW_1.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")		
							DW_1.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")		
						ELSE
							DW_1.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")		
							DW_1.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																							
						END IF
						DW_1.Modify(LVS_COLUMN_NAME + ".width='"+lvs_width+"'")			
						DW_1.Modify(LVS_COLUMN_NAME + ".height='"+lvs_height+"'")		
				
			ELSEIF LVS_OBJECT_TYPE = 'COMPUTE' THEN 	
				
						DW_1.Modify(LVS_COLUMN_NAME + ".Format='"+LVS_FORMAT+"'")	
						DW_1.Modify(LVS_COLUMN_NAME + ".Alignment='"+LVS_OBJECT_ALIGNMENT+"'")						
						
						if lvs_visible_yn = '0' THEN 
							DW_1.Modify(LVS_COLUMN_NAME + ".Visible='"+lvs_visible_yn+"'")		
						end if
						

						
						IF LONG(LVS_COLUMN_ORDER) < 0  OR LVS_COLUMN_ORDER = '?' OR ISNULL(LVS_COLUMN_ORDER) THEN 
							DW_1.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")		
							DW_1.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																							
						ELSE
							DW_1.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")		
							DW_1.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																							
						END IF
						DW_1.Modify(LVS_COLUMN_NAME + ".width='"+lvs_width+"'")		
						DW_1.Modify(LVS_COLUMN_NAME + ".height='"+lvs_height+"'")								
								
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
		
			IF  UPPER(LVS_OBJECT_TYPE) = 'COLUMN' THEN

						DW_2.Modify(LVS_COLUMN_NAME + ".Format='"+LVS_FORMAT+"'")	
						DW_2.Modify(LVS_COLUMN_NAME + ".Alignment='"+LVS_OBJECT_ALIGNMENT+"'")							
						
						if lvs_visible_yn = '0' THEN 
							DW_2.Modify(LVS_COLUMN_NAME + ".Visible='"+lvs_visible_yn+"'")		
						end if
						
						DW_2.Modify(LVS_COLUMN_NAME + ".width='1000'")			
						
						IF LONG(LVS_COLUMN_ORDER) < 0  OR LVS_COLUMN_ORDER = '?' OR ISNULL(LVS_COLUMN_ORDER) THEN 
							DW_2.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")									
							DW_2.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")									
						ELSE
							DW_2.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")									
							DW_2.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																
						END IF
								
						DW_2.Modify(LVS_COLUMN_NAME + ".width='"+lvs_width+"'")			
						DW_2.Modify(LVS_COLUMN_NAME + ".height='"+lvs_height+"'")									
						
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
						
			ELSEIF LVS_OBJECT_TYPE = 'TEXT' THEN 

						DW_2.Modify(LVS_COLUMN_NAME + ".Format='"+LVS_FORMAT+"'")	
						DW_2.Modify(LVS_COLUMN_NAME + ".Alignment='"+LVS_OBJECT_ALIGNMENT+"'")							
						
						if lvs_visible_yn = '0' THEN 
							DW_2.Modify(LVS_COLUMN_NAME + ".Visible='"+lvs_visible_yn+"'")		
						end if
						
						DW_2.Modify(LVS_COLUMN_NAME + ".width='1000'")		
						
						IF LONG(LVS_COLUMN_ORDER) < 0  OR LVS_COLUMN_ORDER = '?' OR ISNULL(LVS_COLUMN_ORDER) THEN 
							DW_2.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")		
							DW_2.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")								
						ELSE
							DW_2.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")		
							DW_2.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																							
						END IF
						DW_2.Modify(LVS_COLUMN_NAME + ".width='"+lvs_width+"'")			
						DW_2.Modify(LVS_COLUMN_NAME + ".height='"+lvs_height+"'")		
				
			ELSEIF LVS_OBJECT_TYPE = 'COMPUTE' THEN 	
				
						DW_2.Modify(LVS_COLUMN_NAME + ".Format='"+LVS_FORMAT+"'")	
						DW_2.Modify(LVS_COLUMN_NAME + ".Alignment='"+LVS_OBJECT_ALIGNMENT+"'")						
						
						if lvs_visible_yn = '0' THEN 
							DW_2.Modify(LVS_COLUMN_NAME + ".Visible='"+lvs_visible_yn+"'")		
						end if
						
						DW_2.Modify(LVS_COLUMN_NAME + ".width='1000'")		
						
						IF LONG(LVS_COLUMN_ORDER) < 0  OR LVS_COLUMN_ORDER = '?' OR ISNULL(LVS_COLUMN_ORDER) THEN 
							DW_2.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")		
							DW_2.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")									
						ELSE
							DW_2.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")		
							DW_2.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																							
						END IF
						DW_2.Modify(LVS_COLUMN_NAME + ".width='"+lvs_width+"'")		
						DW_2.Modify(LVS_COLUMN_NAME + ".height='"+lvs_height+"'")								
								
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
				
			ELSEIF LVS_OBJECT_TYPE = 'LINE' THEN 
						
						if lvs_visible_yn = '0' THEN 
							DW_2.Modify(LVS_COLUMN_NAME + ".Visible='"+lvs_visible_yn+"'")		
						end if

						DW_2.Modify(LVS_COLUMN_NAME + ".x1='"+LVS_OBJECT_X1+"'")									
						DW_2.Modify(LVS_COLUMN_NAME + ".x2='"+LVS_OBJECT_X2+"'")									
						DW_2.Modify(LVS_COLUMN_NAME + ".y1='"+LVS_OBJECT_Y1+"'")									
						DW_2.Modify(LVS_COLUMN_NAME + ".y2='"+LVS_OBJECT_Y2+"'")	
				
			ELSEIF LVS_OBJECT_TYPE = 'RECTANGLE' THEN
				
			END IF
			
	ELSEIF UPPER(LVS_DATAWINDOW_NAME) = 'DW_3' THEN 		
		
			IF  UPPER(LVS_OBJECT_TYPE) = 'COLUMN' THEN

						DW_3.Modify(LVS_COLUMN_NAME + ".Format='"+LVS_FORMAT+"'")	
						DW_3.Modify(LVS_COLUMN_NAME + ".Alignment='"+LVS_OBJECT_ALIGNMENT+"'")							
						
						if lvs_visible_yn = '0' THEN 
							DW_3.Modify(LVS_COLUMN_NAME + ".Visible='"+lvs_visible_yn+"'")		
						end if
						

						
						IF LONG(LVS_COLUMN_ORDER) < 0  OR LVS_COLUMN_ORDER = '?' OR ISNULL(LVS_COLUMN_ORDER) THEN 

							DW_3.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")									
							DW_3.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")								
						ELSE
							DW_3.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")									
							DW_3.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																
						END IF
								
						DW_3.Modify(LVS_COLUMN_NAME + ".width='"+lvs_width+"'")			
						DW_3.Modify(LVS_COLUMN_NAME + ".height='"+lvs_height+"'")		
						
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
						
			ELSEIF LVS_OBJECT_TYPE = 'TEXT' THEN 

						DW_3.Modify(LVS_COLUMN_NAME + ".Format='"+LVS_FORMAT+"'")	
						DW_3.Modify(LVS_COLUMN_NAME + ".Alignment='"+LVS_OBJECT_ALIGNMENT+"'")							
						
						if lvs_visible_yn = '0' THEN 
							DW_3.Modify(LVS_COLUMN_NAME + ".Visible='"+lvs_visible_yn+"'")		
						end if
						

						
						IF LONG(LVS_COLUMN_ORDER) < 0  OR LVS_COLUMN_ORDER = '?' OR ISNULL(LVS_COLUMN_ORDER) THEN 
							DW_3.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")		
							DW_3.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																														
						ELSE
							DW_3.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")		
							DW_3.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																							
						END IF
						DW_3.Modify(LVS_COLUMN_NAME + ".width='"+lvs_width+"'")			
						DW_3.Modify(LVS_COLUMN_NAME + ".height='"+lvs_height+"'")		
				
			ELSEIF LVS_OBJECT_TYPE = 'COMPUTE' THEN 	
				
						DW_3.Modify(LVS_COLUMN_NAME + ".Format='"+LVS_FORMAT+"'")	
						DW_3.Modify(LVS_COLUMN_NAME + ".Alignment='"+LVS_OBJECT_ALIGNMENT+"'")						
						
						if lvs_visible_yn = '0' THEN 
							DW_3.Modify(LVS_COLUMN_NAME + ".Visible='"+lvs_visible_yn+"'")		
						end if
						

						
						IF LONG(LVS_COLUMN_ORDER) < 0  OR LVS_COLUMN_ORDER = '?' OR ISNULL(LVS_COLUMN_ORDER) THEN 
							DW_3.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")		
							DW_3.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																														
						ELSE
							DW_3.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")		
							DW_3.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																							

						END IF
						DW_3.Modify(LVS_COLUMN_NAME + ".width='"+lvs_width+"'")		
						DW_3.Modify(LVS_COLUMN_NAME + ".height='"+lvs_height+"'")														
								
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
				
			ELSEIF LVS_OBJECT_TYPE = 'LINE' THEN 	
				
						
						if lvs_visible_yn = '0' THEN 
							DW_3.Modify(LVS_COLUMN_NAME + ".Visible='"+lvs_visible_yn+"'")		
						end if

						DW_3.Modify(LVS_COLUMN_NAME + ".x1='"+LVS_OBJECT_X1+"'")									
						DW_3.Modify(LVS_COLUMN_NAME + ".x2='"+LVS_OBJECT_X2+"'")									
						DW_3.Modify(LVS_COLUMN_NAME + ".y1='"+LVS_OBJECT_Y1+"'")									
						DW_3.Modify(LVS_COLUMN_NAME + ".y2='"+LVS_OBJECT_Y2+"'")															
 				
				
			ELSEIF LVS_OBJECT_TYPE = 'RECTANGLE' THEN
				
			END IF



	ELSEIF UPPER(LVS_DATAWINDOW_NAME) = 'DW_4' THEN 		
		
			IF  UPPER(LVS_OBJECT_TYPE) = 'COLUMN' THEN

						DW_4.Modify(LVS_COLUMN_NAME + ".Format='"+LVS_FORMAT+"'")	
						DW_4.Modify(LVS_COLUMN_NAME + ".Alignment='"+LVS_OBJECT_ALIGNMENT+"'")							
						
						if lvs_visible_yn = '0' THEN 
							DW_4.Modify(LVS_COLUMN_NAME + ".Visible='"+lvs_visible_yn+"'")		
						end if
						

						
						IF LONG(LVS_COLUMN_ORDER) < 0  OR LVS_COLUMN_ORDER = '?' OR ISNULL(LVS_COLUMN_ORDER) THEN 
							DW_4.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")									
							DW_4.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																							
						ELSE
							DW_4.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")									
							DW_4.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																
						END IF
								
						DW_4.Modify(LVS_COLUMN_NAME + ".width='"+lvs_width+"'")			
						DW_4.Modify(LVS_COLUMN_NAME + ".height='"+lvs_height+"'")									
						
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
						
			ELSEIF LVS_OBJECT_TYPE = 'TEXT' THEN 

						DW_4.Modify(LVS_COLUMN_NAME + ".Format='"+LVS_FORMAT+"'")	
						DW_4.Modify(LVS_COLUMN_NAME + ".Alignment='"+LVS_OBJECT_ALIGNMENT+"'")							
						
						if lvs_visible_yn = '0' THEN 
							DW_4.Modify(LVS_COLUMN_NAME + ".Visible='"+lvs_visible_yn+"'")		
						end if
						

						
						IF LONG(LVS_COLUMN_ORDER) < 0  OR LVS_COLUMN_ORDER = '?' OR ISNULL(LVS_COLUMN_ORDER) THEN 
							DW_4.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")		
							DW_4.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																														
						ELSE
							DW_4.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")		
							DW_4.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																							
						END IF
						DW_4.Modify(LVS_COLUMN_NAME + ".width='"+lvs_width+"'")			
						DW_4.Modify(LVS_COLUMN_NAME + ".height='"+lvs_height+"'")			

			ELSEIF LVS_OBJECT_TYPE = 'COMPUTE' THEN 	
				
						DW_4.Modify(LVS_COLUMN_NAME + ".Format='"+LVS_FORMAT+"'")	
						DW_4.Modify(LVS_COLUMN_NAME + ".Alignment='"+LVS_OBJECT_ALIGNMENT+"'")						
						
						if lvs_visible_yn = '0' THEN 
							DW_4.Modify(LVS_COLUMN_NAME + ".Visible='"+lvs_visible_yn+"'")		
						end if
						
							
						
						IF LONG(LVS_COLUMN_ORDER) < 0  OR LVS_COLUMN_ORDER = '?' OR ISNULL(LVS_COLUMN_ORDER) THEN 
							DW_4.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")		
							DW_4.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																														
						ELSE
							DW_4.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")		
							DW_4.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																							
						END IF
						DW_4.Modify(LVS_COLUMN_NAME + ".width='"+lvs_width+"'")		
						DW_4.Modify(LVS_COLUMN_NAME + ".height='"+lvs_height+"'")	
								
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
				
			ELSEIF LVS_OBJECT_TYPE = 'LINE' THEN 	
				
						
						if lvs_visible_yn = '0' THEN 
							DW_4.Modify(LVS_COLUMN_NAME + ".Visible='"+lvs_visible_yn+"'")		
						end if

						DW_4.Modify(LVS_COLUMN_NAME + ".x1='"+LVS_OBJECT_X1+"'")									
						DW_4.Modify(LVS_COLUMN_NAME + ".x2='"+LVS_OBJECT_X2+"'")									
						DW_4.Modify(LVS_COLUMN_NAME + ".y1='"+LVS_OBJECT_Y1+"'")									
						DW_4.Modify(LVS_COLUMN_NAME + ".y2='"+LVS_OBJECT_Y2+"'")															
 				
				
			ELSEIF LVS_OBJECT_TYPE = 'RECTANGLE' THEN
				
			END IF

	ELSEIF UPPER(LVS_DATAWINDOW_NAME) = 'DW_5' THEN 		
		
			IF  UPPER(LVS_OBJECT_TYPE) = 'COLUMN' THEN

						DW_5.Modify(LVS_COLUMN_NAME + ".Format='"+LVS_FORMAT+"'")	
						DW_5.Modify(LVS_COLUMN_NAME + ".Alignment='"+LVS_OBJECT_ALIGNMENT+"'")							
						
						if lvs_visible_yn = '0' THEN 
							DW_5.Modify(LVS_COLUMN_NAME + ".Visible='"+lvs_visible_yn+"'")		
						end if
						
							
						
						IF LONG(LVS_COLUMN_ORDER) < 0  OR LVS_COLUMN_ORDER = '?' OR ISNULL(LVS_COLUMN_ORDER) THEN 
							DW_5.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")									
							DW_5.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																							
						ELSE
							DW_5.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")									
							DW_5.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																
						END IF
								
						DW_5.Modify(LVS_COLUMN_NAME + ".width='"+lvs_width+"'")			
						DW_5.Modify(LVS_COLUMN_NAME + ".height='"+lvs_height+"'")		
						
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
						
			ELSEIF LVS_OBJECT_TYPE = 'TEXT' THEN 

						DW_5.Modify(LVS_COLUMN_NAME + ".Format='"+LVS_FORMAT+"'")	
						DW_5.Modify(LVS_COLUMN_NAME + ".Alignment='"+LVS_OBJECT_ALIGNMENT+"'")							
						
						if lvs_visible_yn = '0' THEN 
							DW_5.Modify(LVS_COLUMN_NAME + ".Visible='"+lvs_visible_yn+"'")		
						end if
						

						
						IF LONG(LVS_COLUMN_ORDER) < 0  OR LVS_COLUMN_ORDER = '?' OR ISNULL(LVS_COLUMN_ORDER) THEN 
							DW_5.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")		
							DW_5.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																														
						ELSE
							DW_5.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")		
							DW_5.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																							
						END IF
						DW_5.Modify(LVS_COLUMN_NAME + ".width='"+lvs_width+"'")			
						DW_5.Modify(LVS_COLUMN_NAME + ".height='"+lvs_height+"'")		
				
			ELSEIF LVS_OBJECT_TYPE = 'COMPUTE' THEN 	
				
						DW_5.Modify(LVS_COLUMN_NAME + ".Format='"+LVS_FORMAT+"'")	
						DW_5.Modify(LVS_COLUMN_NAME + ".Alignment='"+LVS_OBJECT_ALIGNMENT+"'")						
						
						if lvs_visible_yn = '0' THEN 
							DW_5.Modify(LVS_COLUMN_NAME + ".Visible='"+lvs_visible_yn+"'")		
						end if
						

						
						IF LONG(LVS_COLUMN_ORDER) < 0  OR LVS_COLUMN_ORDER = '?' OR ISNULL(LVS_COLUMN_ORDER) THEN 
							DW_5.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")		
							DW_5.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																														
						ELSE
							DW_5.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")		
							DW_5.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																							
						END IF
						DW_5.Modify(LVS_COLUMN_NAME + ".width='"+lvs_width+"'")		
						DW_5.Modify(LVS_COLUMN_NAME + ".height='"+lvs_height+"'")																
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
				
			ELSEIF LVS_OBJECT_TYPE = 'LINE' THEN 	
				
						
						if lvs_visible_yn = '0' THEN 
							DW_5.Modify(LVS_COLUMN_NAME + ".Visible='"+lvs_visible_yn+"'")		
						end if

						DW_5.Modify(LVS_COLUMN_NAME + ".x1='"+LVS_OBJECT_X1+"'")									
						DW_5.Modify(LVS_COLUMN_NAME + ".x2='"+LVS_OBJECT_X2+"'")									
						DW_5.Modify(LVS_COLUMN_NAME + ".y1='"+LVS_OBJECT_Y1+"'")									
						DW_5.Modify(LVS_COLUMN_NAME + ".y2='"+LVS_OBJECT_Y2+"'")															
 				
				
			ELSEIF LVS_OBJECT_TYPE = 'RECTANGLE' THEN
				
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

//==================================================================
//
//==================================================================

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
	
	
	F_MSG_MDI_HELP('Function :wf_window_property-> SELECT FROM ISYS_WINDOW_PROPERTY CURSOR FETCH')  		
	
	IF  UPPER(LVS_DATAWINDOW_NAME) = 'DW_1' THEN

			IF  UPPER(LVS_OBJECT_TYPE) = 'COLUMN' THEN

						DW_1.Modify(LVS_COLUMN_NAME + ".Format='"+LVS_FORMAT+"'")	
						DW_1.Modify(LVS_COLUMN_NAME + ".Alignment='"+LVS_OBJECT_ALIGNMENT+"'")							
						
						if lvs_visible_yn = '0' THEN 
							DW_1.Modify(LVS_COLUMN_NAME + ".Visible='"+lvs_visible_yn+"'")		
						end if
						
						
						IF LONG(LVS_COLUMN_ORDER) < 0  OR LVS_COLUMN_ORDER = '?' OR ISNULL(LVS_COLUMN_ORDER) THEN 
							DW_1.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")									
							DW_1.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")															
						ELSE
							DW_1.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")									
							DW_1.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																
						END IF
						
						DW_1.Modify(LVS_COLUMN_NAME + ".width='"+lvs_width+"'")			
						DW_1.Modify(LVS_COLUMN_NAME + ".height='"+lvs_height+"'")									
								
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
						

						
						IF LONG(LVS_COLUMN_ORDER) < 0  OR LVS_COLUMN_ORDER = '?' OR ISNULL(LVS_COLUMN_ORDER) THEN 
							DW_1.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")		
							DW_1.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")		
						ELSE
							DW_1.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")		
							DW_1.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																							
						END IF
						DW_1.Modify(LVS_COLUMN_NAME + ".width='"+lvs_width+"'")			
						DW_1.Modify(LVS_COLUMN_NAME + ".height='"+lvs_height+"'")		
				
			ELSEIF LVS_OBJECT_TYPE = 'COMPUTE' THEN 	
				
						DW_1.Modify(LVS_COLUMN_NAME + ".Format='"+LVS_FORMAT+"'")	
						DW_1.Modify(LVS_COLUMN_NAME + ".Alignment='"+LVS_OBJECT_ALIGNMENT+"'")						
						
						if lvs_visible_yn = '0' THEN 
							DW_1.Modify(LVS_COLUMN_NAME + ".Visible='"+lvs_visible_yn+"'")		
						end if
						

						
						IF LONG(LVS_COLUMN_ORDER) < 0  OR LVS_COLUMN_ORDER = '?' OR ISNULL(LVS_COLUMN_ORDER) THEN 
							DW_1.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")		
							DW_1.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																							
						ELSE
							DW_1.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")		
							DW_1.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																							
						END IF
						DW_1.Modify(LVS_COLUMN_NAME + ".width='"+lvs_width+"'")		
						DW_1.Modify(LVS_COLUMN_NAME + ".height='"+lvs_height+"'")								
								
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
		
			IF  UPPER(LVS_OBJECT_TYPE) = 'COLUMN' THEN

						DW_2.Modify(LVS_COLUMN_NAME + ".Format='"+LVS_FORMAT+"'")	
						DW_2.Modify(LVS_COLUMN_NAME + ".Alignment='"+LVS_OBJECT_ALIGNMENT+"'")							
						
						if lvs_visible_yn = '0' THEN 
							DW_2.Modify(LVS_COLUMN_NAME + ".Visible='"+lvs_visible_yn+"'")		
						end if
								
						
						IF LONG(LVS_COLUMN_ORDER) < 0  OR LVS_COLUMN_ORDER = '?' OR ISNULL(LVS_COLUMN_ORDER) THEN 
							DW_2.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")									
							DW_2.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")									
						ELSE
							DW_2.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")									
							DW_2.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																
						END IF
								
						DW_2.Modify(LVS_COLUMN_NAME + ".width='"+lvs_width+"'")			
						DW_2.Modify(LVS_COLUMN_NAME + ".height='"+lvs_height+"'")									
						
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
						
			ELSEIF LVS_OBJECT_TYPE = 'TEXT' THEN 

						DW_2.Modify(LVS_COLUMN_NAME + ".Format='"+LVS_FORMAT+"'")	
						DW_2.Modify(LVS_COLUMN_NAME + ".Alignment='"+LVS_OBJECT_ALIGNMENT+"'")							
						
						if lvs_visible_yn = '0' THEN 
							DW_2.Modify(LVS_COLUMN_NAME + ".Visible='"+lvs_visible_yn+"'")		
						end if
						
						IF LONG(LVS_COLUMN_ORDER) < 0  OR LVS_COLUMN_ORDER = '?' OR ISNULL(LVS_COLUMN_ORDER) THEN 
							DW_2.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")		
							DW_2.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")								
						ELSE
							DW_2.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")		
							DW_2.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																							
						END IF
						DW_2.Modify(LVS_COLUMN_NAME + ".width='"+lvs_width+"'")			
						DW_2.Modify(LVS_COLUMN_NAME + ".height='"+lvs_height+"'")		
				
			ELSEIF LVS_OBJECT_TYPE = 'COMPUTE' THEN 	
				
						DW_2.Modify(LVS_COLUMN_NAME + ".Format='"+LVS_FORMAT+"'")	
						DW_2.Modify(LVS_COLUMN_NAME + ".Alignment='"+LVS_OBJECT_ALIGNMENT+"'")						
						
						if lvs_visible_yn = '0' THEN 
							DW_2.Modify(LVS_COLUMN_NAME + ".Visible='"+lvs_visible_yn+"'")		
						end if	
						
						IF LONG(LVS_COLUMN_ORDER) < 0  OR LVS_COLUMN_ORDER = '?' OR ISNULL(LVS_COLUMN_ORDER) THEN 
							DW_2.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")		
							DW_2.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")									
						ELSE
							DW_2.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")		
							DW_2.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																							
						END IF
						DW_2.Modify(LVS_COLUMN_NAME + ".width='"+lvs_width+"'")		
						DW_2.Modify(LVS_COLUMN_NAME + ".height='"+lvs_height+"'")								
								
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
				
			ELSEIF LVS_OBJECT_TYPE = 'LINE' THEN 
						
						if lvs_visible_yn = '0' THEN 
							DW_2.Modify(LVS_COLUMN_NAME + ".Visible='"+lvs_visible_yn+"'")		
						end if

						DW_2.Modify(LVS_COLUMN_NAME + ".x1='"+LVS_OBJECT_X1+"'")									
						DW_2.Modify(LVS_COLUMN_NAME + ".x2='"+LVS_OBJECT_X2+"'")									
						DW_2.Modify(LVS_COLUMN_NAME + ".y1='"+LVS_OBJECT_Y1+"'")									
						DW_2.Modify(LVS_COLUMN_NAME + ".y2='"+LVS_OBJECT_Y2+"'")	
				
			ELSEIF LVS_OBJECT_TYPE = 'RECTANGLE' THEN
				
			END IF
			
	ELSEIF UPPER(LVS_DATAWINDOW_NAME) = 'DW_3' THEN 		
		
			IF  UPPER(LVS_OBJECT_TYPE) = 'COLUMN' THEN

						DW_3.Modify(LVS_COLUMN_NAME + ".Format='"+LVS_FORMAT+"'")	
						DW_3.Modify(LVS_COLUMN_NAME + ".Alignment='"+LVS_OBJECT_ALIGNMENT+"'")							
						
						if lvs_visible_yn = '0' THEN 
							DW_3.Modify(LVS_COLUMN_NAME + ".Visible='"+lvs_visible_yn+"'")		
						end if
						

						
						IF LONG(LVS_COLUMN_ORDER) < 0  OR LVS_COLUMN_ORDER = '?' OR ISNULL(LVS_COLUMN_ORDER) THEN 

							DW_3.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")									
							DW_3.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")								
						ELSE
							DW_3.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")									
							DW_3.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																
						END IF
								
						DW_3.Modify(LVS_COLUMN_NAME + ".width='"+lvs_width+"'")			
						DW_3.Modify(LVS_COLUMN_NAME + ".height='"+lvs_height+"'")		
						
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
						
			ELSEIF LVS_OBJECT_TYPE = 'TEXT' THEN 

						DW_3.Modify(LVS_COLUMN_NAME + ".Format='"+LVS_FORMAT+"'")	
						DW_3.Modify(LVS_COLUMN_NAME + ".Alignment='"+LVS_OBJECT_ALIGNMENT+"'")							
						
						if lvs_visible_yn = '0' THEN 
							DW_3.Modify(LVS_COLUMN_NAME + ".Visible='"+lvs_visible_yn+"'")		
						end if
						

						
						IF LONG(LVS_COLUMN_ORDER) < 0  OR LVS_COLUMN_ORDER = '?' OR ISNULL(LVS_COLUMN_ORDER) THEN 
							DW_3.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")		
							DW_3.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																														
						ELSE
							DW_3.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")		
							DW_3.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																							
						END IF
						DW_3.Modify(LVS_COLUMN_NAME + ".width='"+lvs_width+"'")			
						DW_3.Modify(LVS_COLUMN_NAME + ".height='"+lvs_height+"'")		
				
			ELSEIF LVS_OBJECT_TYPE = 'COMPUTE' THEN 	
				
						DW_3.Modify(LVS_COLUMN_NAME + ".Format='"+LVS_FORMAT+"'")	
						DW_3.Modify(LVS_COLUMN_NAME + ".Alignment='"+LVS_OBJECT_ALIGNMENT+"'")						
						
						if lvs_visible_yn = '0' THEN 
							DW_3.Modify(LVS_COLUMN_NAME + ".Visible='"+lvs_visible_yn+"'")		
						end if
						

						
						IF LONG(LVS_COLUMN_ORDER) < 0  OR LVS_COLUMN_ORDER = '?' OR ISNULL(LVS_COLUMN_ORDER) THEN 
							DW_3.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")		
							DW_3.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																														
						ELSE
							DW_3.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")		
							DW_3.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																							

						END IF
						DW_3.Modify(LVS_COLUMN_NAME + ".width='"+lvs_width+"'")		
						DW_3.Modify(LVS_COLUMN_NAME + ".height='"+lvs_height+"'")														
								
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
				
			ELSEIF LVS_OBJECT_TYPE = 'LINE' THEN 	
				
						
						if lvs_visible_yn = '0' THEN 
							DW_3.Modify(LVS_COLUMN_NAME + ".Visible='"+lvs_visible_yn+"'")		
						end if

						DW_3.Modify(LVS_COLUMN_NAME + ".x1='"+LVS_OBJECT_X1+"'")									
						DW_3.Modify(LVS_COLUMN_NAME + ".x2='"+LVS_OBJECT_X2+"'")									
						DW_3.Modify(LVS_COLUMN_NAME + ".y1='"+LVS_OBJECT_Y1+"'")									
						DW_3.Modify(LVS_COLUMN_NAME + ".y2='"+LVS_OBJECT_Y2+"'")															
 				
				
			ELSEIF LVS_OBJECT_TYPE = 'RECTANGLE' THEN
				
			END IF



	ELSEIF UPPER(LVS_DATAWINDOW_NAME) = 'DW_4' THEN 		
		
			IF  UPPER(LVS_OBJECT_TYPE) = 'COLUMN' THEN

						DW_4.Modify(LVS_COLUMN_NAME + ".Format='"+LVS_FORMAT+"'")	
						DW_4.Modify(LVS_COLUMN_NAME + ".Alignment='"+LVS_OBJECT_ALIGNMENT+"'")							
						
						if lvs_visible_yn = '0' THEN 
							DW_4.Modify(LVS_COLUMN_NAME + ".Visible='"+lvs_visible_yn+"'")		
						end if
						

						
						IF LONG(LVS_COLUMN_ORDER) < 0  OR LVS_COLUMN_ORDER = '?' OR ISNULL(LVS_COLUMN_ORDER) THEN 
							DW_4.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")									
							DW_4.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																							
						ELSE
							DW_4.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")									
							DW_4.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																
						END IF
								
						DW_4.Modify(LVS_COLUMN_NAME + ".width='"+lvs_width+"'")			
						DW_4.Modify(LVS_COLUMN_NAME + ".height='"+lvs_height+"'")									
						
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
						
			ELSEIF LVS_OBJECT_TYPE = 'TEXT' THEN 

						DW_4.Modify(LVS_COLUMN_NAME + ".Format='"+LVS_FORMAT+"'")	
						DW_4.Modify(LVS_COLUMN_NAME + ".Alignment='"+LVS_OBJECT_ALIGNMENT+"'")							
						
						if lvs_visible_yn = '0' THEN 
							DW_4.Modify(LVS_COLUMN_NAME + ".Visible='"+lvs_visible_yn+"'")		
						end if
						

						
						IF LONG(LVS_COLUMN_ORDER) < 0  OR LVS_COLUMN_ORDER = '?' OR ISNULL(LVS_COLUMN_ORDER) THEN 
							DW_4.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")		
							DW_4.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																														
						ELSE
							DW_4.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")		
							DW_4.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																							
						END IF
						DW_4.Modify(LVS_COLUMN_NAME + ".width='"+lvs_width+"'")			
						DW_4.Modify(LVS_COLUMN_NAME + ".height='"+lvs_height+"'")			

			ELSEIF LVS_OBJECT_TYPE = 'COMPUTE' THEN 	
				
						DW_4.Modify(LVS_COLUMN_NAME + ".Format='"+LVS_FORMAT+"'")	
						DW_4.Modify(LVS_COLUMN_NAME + ".Alignment='"+LVS_OBJECT_ALIGNMENT+"'")						
						
						if lvs_visible_yn = '0' THEN 
							DW_4.Modify(LVS_COLUMN_NAME + ".Visible='"+lvs_visible_yn+"'")		
						end if
						
							
						
						IF LONG(LVS_COLUMN_ORDER) < 0  OR LVS_COLUMN_ORDER = '?' OR ISNULL(LVS_COLUMN_ORDER) THEN 
							DW_4.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")		
							DW_4.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																														
						ELSE
							DW_4.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")		
							DW_4.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																							
						END IF
						DW_4.Modify(LVS_COLUMN_NAME + ".width='"+lvs_width+"'")		
						DW_4.Modify(LVS_COLUMN_NAME + ".height='"+lvs_height+"'")	
								
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
				
			ELSEIF LVS_OBJECT_TYPE = 'LINE' THEN 	
				
						
						if lvs_visible_yn = '0' THEN 
							DW_4.Modify(LVS_COLUMN_NAME + ".Visible='"+lvs_visible_yn+"'")		
						end if

						DW_4.Modify(LVS_COLUMN_NAME + ".x1='"+LVS_OBJECT_X1+"'")									
						DW_4.Modify(LVS_COLUMN_NAME + ".x2='"+LVS_OBJECT_X2+"'")									
						DW_4.Modify(LVS_COLUMN_NAME + ".y1='"+LVS_OBJECT_Y1+"'")									
						DW_4.Modify(LVS_COLUMN_NAME + ".y2='"+LVS_OBJECT_Y2+"'")															
 				
				
			ELSEIF LVS_OBJECT_TYPE = 'RECTANGLE' THEN
				
			END IF

	ELSEIF UPPER(LVS_DATAWINDOW_NAME) = 'DW_5' THEN 		
		
			IF  UPPER(LVS_OBJECT_TYPE) = 'COLUMN' THEN

						DW_5.Modify(LVS_COLUMN_NAME + ".Format='"+LVS_FORMAT+"'")	
						DW_5.Modify(LVS_COLUMN_NAME + ".Alignment='"+LVS_OBJECT_ALIGNMENT+"'")							
						
						if lvs_visible_yn = '0' THEN 
							DW_5.Modify(LVS_COLUMN_NAME + ".Visible='"+lvs_visible_yn+"'")		
						end if

						IF LONG(LVS_COLUMN_ORDER) < 0  OR LVS_COLUMN_ORDER = '?' OR ISNULL(LVS_COLUMN_ORDER) THEN 
							DW_5.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")									
							DW_5.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																							
						ELSE
							DW_5.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")									
							DW_5.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																
						END IF
								
						DW_5.Modify(LVS_COLUMN_NAME + ".width='"+lvs_width+"'")			
						DW_5.Modify(LVS_COLUMN_NAME + ".height='"+lvs_height+"'")		
						
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
						
			ELSEIF LVS_OBJECT_TYPE = 'TEXT' THEN 

						DW_5.Modify(LVS_COLUMN_NAME + ".Format='"+LVS_FORMAT+"'")	
						DW_5.Modify(LVS_COLUMN_NAME + ".Alignment='"+LVS_OBJECT_ALIGNMENT+"'")							
						
						if lvs_visible_yn = '0' THEN 
							DW_5.Modify(LVS_COLUMN_NAME + ".Visible='"+lvs_visible_yn+"'")		
						end if
						

						
						IF LONG(LVS_COLUMN_ORDER) < 0  OR LVS_COLUMN_ORDER = '?' OR ISNULL(LVS_COLUMN_ORDER) THEN 
							DW_5.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")		
							DW_5.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																														
						ELSE
							DW_5.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")		
							DW_5.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																							
						END IF
						DW_5.Modify(LVS_COLUMN_NAME + ".width='"+lvs_width+"'")			
						DW_5.Modify(LVS_COLUMN_NAME + ".height='"+lvs_height+"'")		
				
			ELSEIF LVS_OBJECT_TYPE = 'COMPUTE' THEN 	
				
						DW_5.Modify(LVS_COLUMN_NAME + ".Format='"+LVS_FORMAT+"'")	
						DW_5.Modify(LVS_COLUMN_NAME + ".Alignment='"+LVS_OBJECT_ALIGNMENT+"'")						
						
						if lvs_visible_yn = '0' THEN 
							DW_5.Modify(LVS_COLUMN_NAME + ".Visible='"+lvs_visible_yn+"'")		
						end if
						

						
						IF LONG(LVS_COLUMN_ORDER) < 0  OR LVS_COLUMN_ORDER = '?' OR ISNULL(LVS_COLUMN_ORDER) THEN 
							DW_5.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")		
							DW_5.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																														
						ELSE
							DW_5.Modify(LVS_COLUMN_NAME + ".x='"+LVS_OBJECT_X1+"'")		
							DW_5.Modify(LVS_COLUMN_NAME + ".y='"+LVS_OBJECT_Y1+"'")																							
						END IF
						DW_5.Modify(LVS_COLUMN_NAME + ".width='"+lvs_width+"'")		
						DW_5.Modify(LVS_COLUMN_NAME + ".height='"+lvs_height+"'")																
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
				
			ELSEIF LVS_OBJECT_TYPE = 'LINE' THEN 	
				
						
						if lvs_visible_yn = '0' THEN 
							DW_5.Modify(LVS_COLUMN_NAME + ".Visible='"+lvs_visible_yn+"'")		
						end if

						DW_5.Modify(LVS_COLUMN_NAME + ".x1='"+LVS_OBJECT_X1+"'")									
						DW_5.Modify(LVS_COLUMN_NAME + ".x2='"+LVS_OBJECT_X2+"'")									
						DW_5.Modify(LVS_COLUMN_NAME + ".y1='"+LVS_OBJECT_Y1+"'")									
						DW_5.Modify(LVS_COLUMN_NAME + ".y2='"+LVS_OBJECT_Y2+"'")															
 				
				
			ELSEIF LVS_OBJECT_TYPE = 'RECTANGLE' THEN
				
			END IF

END IF 	
	
LOOP UNTIL 1 = 2


F_MSG_MDI_HELP('Function :wf_window_property-> Completed') 

//=================================
// $$HEX5$$edd0200098ccacb92000$$ENDHEX$$
//=================================
//if isvalid(w_tab_sheet) then 
//	w_tab_sheet.bringtotop = true
//else
//	Opensheet( w_tab_sheet  , w_main_frame , Gvi_opensheet_position , Layered!)
//	w_tab_sheet.height = 110
//end if

int index
w_tab_sheet.tab_1.opentab( uo_tabpages , 0 ) //$$HEX9$$e0c2dcad2000edd044c7200094cd00ac2000$$ENDHEX$$

index = Upperbound(w_tab_sheet.tab_1.Control[])
uo_tabpages.ivw_openedwindow = this
uo_tabpages.text =this.title
uo_tabpages.height = 100
w_tab_sheet.tab_1.selecttab(index)
this.setfocus()

this.setredraw( true)
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
			checkbox cbx
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
			checkbox cbx
			cbx = temp
//			cbx.textsize =  size_ctrl[i].fontsize * size_factor 

		case dropdownlistbox!
			dropdownlistbox ddlb
			ddlb = temp
//			ddlb.textsize =  size_ctrl[i].fontsize * size_factor 

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

public function integer wf_resize_it_width_fit (double size_factor);////////////////////////////////////////////////////////////////////////////////////////////////////
// function: wf_resize_it
////////////////////////////////////////////////////////////////////////////////////////////////////


// loop through off of the objects captured in the wf_size_it function and resize them
// Note !! radio buttons and checkboxes do not size properly as they are of fixed size.

dragobject temp
int cnt,i

ib_exec = false // keep the function from being called recursively
cnt = upperbound(this.control)
for i = cnt to 1 step -1
	
	temp = this.control[i]

	choose case typeof(temp)

		case datawindow! // datawindows get zoomed
			datawindow dw
			dw = temp
			
			dw.x		 = size_ctrl[i].x * size_factor
			dw.width   = this.width - 30
			dw.y		 = size_ctrl[i].y * size_factor			
          	dw.height  = size_ctrl[i].height * size_factor 			

	end choose
next
ib_exec = true
return 1
end function

public function integer wf_set_column_dddw ();if ivs_set_column_dddw1 = 'Y' then 
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


return 0
end function

on w_main_root.create
this.dw_5=create dw_5
this.dw_4=create dw_4
this.dw_3=create dw_3
this.dw_2=create dw_2
this.dw_1=create dw_1
this.uo_tabpages=create uo_tabpages
this.Control[]={this.dw_5,&
this.dw_4,&
this.dw_3,&
this.dw_2,&
this.dw_1,&
this.uo_tabpages}
end on

on w_main_root.destroy
destroy(this.dw_5)
destroy(this.dw_4)
destroy(this.dw_3)
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.uo_tabpages)
end on

event resize;double ratiow, ratio, ratioh
int rc
		
IF UPPER(IVS_RESIZE_TYPE) = 'NORMAL' THEN

	dw_1.resize(newwidth  - dw_1.x , newheight - dw_1.y )	
	dw_2.resize(newwidth  - dw_2.x , newheight - dw_2.y )		
	dw_3.resize(newwidth  - dw_3.x , newheight - dw_3.y )
	dw_4.resize(newwidth  - dw_4.x , newheight - dw_4.y )	
	dw_5.resize(newwidth  - dw_5.x , newheight - dw_5.y )		
	
ELSEIF  UPPER(IVS_RESIZE_TYPE) = 'NORMAL_WIDE' THEN

	dw_1.resize(newwidth - dw_1.x  -34, dw_1.height)	
	dw_2.resize(newwidth - dw_2.x - 34, dw_2.height)		
	dw_3.resize(newwidth - dw_3.x - 34, dw_3.height)
	dw_4.resize(newwidth - dw_4.x - 34, dw_4.height)	
	dw_5.resize(newwidth - dw_5.x - 34, dw_5.height)	


ELSEIF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL' THEN //1345_2
	
	dw_1.resize(newwidth  - dw_1.x , newheight - ( dw_1.y + dw_2.height ))
	dw_3.resize(newwidth  - dw_3.x , newheight - ( dw_3.y + dw_2.height ))	
	dw_4.resize(newwidth  - dw_4.x , newheight - ( dw_4.y + dw_2.height ))	
	dw_5.resize(newwidth  - dw_5.x , newheight - ( dw_5.y + dw_2.height ))	
	

	dw_2.y = dw_1.y + dw_1.HEIGHT 
     dw_2.resize(newwidth  - dw_2.x , dw_2.height )		
	  
ELSEIF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL_TOP' THEN //1345_2
	
	dw_1.resize(newwidth  - dw_1.x , newheight - ( dw_1.y + dw_2.height ))
	dw_3.resize(newwidth  - dw_3.x , newheight )	
	dw_4.resize(newwidth  - dw_4.x , newheight )	
	dw_5.resize(newwidth  - dw_5.x , newheight )	
	
	
	dw_2.y = dw_1.y + dw_1.HEIGHT 
	dw_2.resize(newwidth  - dw_2.x , dw_2.height )			  

ELSEIF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL_R5' THEN //1345_2
	
	dw_1.resize(newwidth  -( dw_1.x + dw_5.width ), newheight - dw_1.y )
	dw_2.resize(newwidth  -( dw_3.x + dw_5.width ), newheight - dw_1.y )	
	dw_3.resize(newwidth  -( dw_3.x + dw_5.width ), newheight - dw_1.y )	
	dw_4.resize(newwidth  - (dw_4.x + dw_5.width ), newheight - dw_1.y )	

     dw_5.y = dw_1.y
	dw_5.x = dw_1.x + dw_1.width 
     dw_5.height = dw_1.height


ELSEIF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL_F5' THEN //1345_2
	
	dw_1.resize(newwidth  - dw_1.x , newheight - ( dw_1.y + dw_2.height ))
	dw_3.resize(newwidth  - dw_3.x , newheight - ( dw_3.y + dw_2.height ))	
	dw_4.resize(newwidth  - dw_4.x , newheight - ( dw_4.y + dw_2.height ))	

	 dw_2.y = dw_1.y + dw_1.HEIGHT 
     dw_2.resize(newwidth  - dw_2.x , dw_2.height )			  	  
ELSEIF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL_F4FIX_23M' THEN //1345_2
	
	dw_1.resize(newwidth  - ( dw_1.x  + dw_4.width ) , newheight - ( dw_1.y + dw_2.height) )
	dw_5.resize( dw_1.width , dw_1.height )
	
	dw_4.resize( dw_4.width ,dw_1.height )	// $$HEX11$$00ac5cb8200038c15cb82000edd32000e0ac15c82000$$ENDHEX$$
	dw_4.x = newwidth - dw_4.width

	dw_2.y = dw_1.y + dw_1.HEIGHT 
     dw_2.resize(newwidth / 2, dw_2.height )		
	  
	dw_3.x = dw_2.x + dw_2.width  
	dw_3.y = dw_2.y
     dw_3.resize(newwidth / 2 , dw_2.height )	  		  
ELSEIF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL_135_24' THEN
	
	dw_1.resize(newwidth , newheight - ( dw_1.y + dw_2.height ))
	dw_3.resize(newwidth , newheight - ( dw_3.y + dw_2.height ))	
	dw_4.resize(newwidth , newheight - ( dw_4.y + dw_2.height ))	
	dw_5.resize(newwidth , newheight - ( dw_5.y + dw_2.height ))	
	
	dw_2.y = dw_1.y + dw_1.HEIGHT 
     dw_2.resize(newwidth , dw_2.height )		
	dw_4.y = dw_1.y + dw_1.HEIGHT 
     dw_4.resize(newwidth , dw_4.height )		  
	  
	  
ELSEIF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL_145_23' THEN
	
	dw_1.resize(newwidth , newheight - ( dw_1.y + dw_2.height ))
	dw_4.resize(newwidth , newheight - ( dw_4.y + dw_2.height ))	
	dw_5.resize(newwidth , newheight - ( dw_5.y + dw_2.height ))	
	

	dw_2.y = dw_1.y + dw_1.HEIGHT 
	dw_2.resize(newwidth , dw_2.height )		
	dw_3.y = dw_1.y + dw_1.HEIGHT 
	dw_3.resize(newwidth , dw_3.height )	  
	  
ELSEIF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL_145_23M' THEN
	
	dw_1.resize(newwidth , newheight - ( dw_1.y + dw_2.height ))
	dw_4.resize(newwidth , newheight - ( dw_4.y + dw_2.height ))	
	dw_5.resize(newwidth , newheight - ( dw_5.y + dw_2.height ))	
	

	dw_2.y = dw_1.y + dw_1.HEIGHT 
     dw_2.resize(newwidth / 2, dw_2.height )		
	  
	dw_3.x = dw_2.x + dw_2.width  
	dw_3.y = dw_1.y + dw_1.HEIGHT 
     dw_3.resize(newwidth / 2 , dw_3.height )	  	
ELSEIF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL_145_2F3M' THEN
	
	dw_1.resize(newwidth , newheight - ( dw_1.y + dw_2.height ))
	dw_4.resize(newwidth , newheight - ( dw_4.y + dw_2.height ))	
	dw_5.resize(newwidth , newheight - ( dw_5.y + dw_2.height ))	
	

	dw_2.y = dw_1.y + dw_1.HEIGHT 
     //dw_2.resize(newwidth / 2, dw_2.height )		
	  
	dw_3.x = dw_2.x + dw_2.width  
	dw_3.y = dw_1.y + dw_1.HEIGHT 
      dw_3.resize(newwidth -dw_2.width , dw_3.height )	  		 
ELSEIF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL_145F_23' THEN
	
	dw_1.resize(newwidth  - ( dw_1.x  + dw_5.width ) , newheight - ( dw_1.y + dw_2.height ))	
	dw_4.resize(newwidth  - ( dw_1.x  + dw_5.width ) , newheight - ( dw_1.y + dw_2.height ))		

	dw_5.resize( dw_5.width , dw_1.height)	// $$HEX8$$00ac5cb82000edd32000e0ac15c82000$$ENDHEX$$
	dw_5.x = dw_1.x + dw_1.width
	

	dw_2.y = dw_1.y + dw_1.HEIGHT 
     dw_2.resize(newwidth , dw_2.height )		
	  
	 dw_3.y = dw_1.y + dw_1.HEIGHT 
     dw_3.resize(newwidth  , dw_3.height )	  		 
ELSEIF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL_145TF_23M' THEN //145 TOP FIX 
	
	dw_1.resize(newwidth , dw_1.height)
	dw_4.resize(newwidth , dw_4.height)	
	dw_5.resize(newwidth , dw_5.height)	

	dw_2.y = dw_1.y + dw_1.HEIGHT 
      dw_2.resize(newwidth / 2, newheight - ( dw_1.y + dw_1.height ))
	  
	dw_3.x = dw_2.x + dw_2.width  
	dw_3.y = dw_1.y + dw_1.HEIGHT 
      dw_3.resize(newwidth / 2 , newheight - ( dw_1.y + dw_1.height ))
	  
ELSEIF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL_14_235M' THEN
	
	dw_1.resize(newwidth , newheight - ( dw_1.y + dw_2.height ))
	dw_4.resize(newwidth , newheight - ( dw_4.y + dw_2.height ))	

	dw_2.y = dw_1.y + dw_1.HEIGHT 
     dw_2.resize(newwidth / 2, dw_2.height )		
	  
	dw_3.x = dw_2.x + dw_2.width  
	dw_3.y = dw_1.y + dw_1.HEIGHT 
     dw_3.resize(newwidth / 2 , dw_3.height )	  	  	  
	  
	dw_5.y = dw_1.y + dw_1.HEIGHT 	  
	dw_5.resize(newwidth ,  dw_5.height )

ELSEIF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL_12T_3B' THEN
	
	dw_1.resize((newwidth - dw_1.x)  / 2 , newheight - ( dw_1.y + dw_3.height )  )
	
	dw_2.x = dw_1.x + dw_1.width 
	dw_2.resize(( newwidth -dw_1.x ) - dw_1.width, dw_1.height)	
	
	dw_3.y = dw_1.y + dw_1.HEIGHT 
     dw_3.resize(newwidth -dw_1.x , dw_3.height ) 
	   
	dw_4.resize(newwidth -dw_1.x   , newheight - ( dw_1.y  )  )
	dw_5.resize(newwidth -dw_1.x   , newheight - ( dw_1.y  )  )   	
	
ELSEIF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL_12T_34B' THEN
	
	
	dw_1.resize(newwidth / 2 , newheight - ( dw_1.y + dw_3.height )  )
	
	dw_2.x = dw_1.x + dw_1.width 
	dw_2.resize(newwidth - dw_1.width, dw_1.height)	
	
	dw_3.y = dw_1.y + dw_1.HEIGHT 
    dw_3.resize(dw_1.width , dw_3.height ) 
	
   	dw_4.x = dw_2.x 
	dw_4.y = dw_2.y + dw_2.HEIGHT 
    dw_4.resize(dw_2.width , dw_4.height ) 
	
	dw_5.resize(newwidth  , newheight - ( dw_1.y  )  )   		  
ELSEIF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL_12T_345B' THEN
	
	
	dw_1.resize(newwidth / 2 , newheight - ( dw_1.y + dw_3.height )  )
	
	dw_2.x = dw_1.x + dw_1.width 
	dw_2.resize(newwidth - dw_1.width, dw_1.height)	
	
	dw_3.y = dw_1.y + dw_1.HEIGHT 
    dw_3.resize(dw_1.width , dw_3.height ) 
	
   	dw_4.x = dw_2.x 
	dw_4.y = dw_2.y + dw_2.HEIGHT 
    dw_4.resize(dw_2.width , dw_4.height ) 
	
	dw_5.y = dw_3.y 
	dw_5.resize(newwidth  , dw_3.height  )   			
ELSEIF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL_12T' THEN
	
	dw_1.resize( newwidth / 2 , newheight - dw_1.y  )
	
	dw_2.x = dw_1.x + dw_1.width 
	dw_2.resize( newwidth  - dw_1.width, dw_1.height)	
	
	dw_3.resize(newwidth  - dw_3.x , newheight - dw_3.y )
	dw_4.resize(newwidth  - dw_4.x , newheight - dw_4.y )	
	dw_5.resize(newwidth  - dw_5.x , newheight - dw_5.y )		

ELSEIF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL_1L2R' THEN
	
	dw_1.resize( dw_1.width , newheight - dw_1.y  )
	
	dw_2.x = dw_1.x + dw_1.width 
	dw_2.resize( newwidth  - dw_1.width, dw_1.height)	
	
	dw_3.resize(newwidth  - dw_3.x , newheight - dw_3.y )
	dw_4.resize(newwidth  - dw_4.x , newheight - dw_4.y )	
	dw_5.resize(newwidth  - dw_5.x , newheight - dw_5.y )		
	
ELSEIF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL_1L2345R' THEN
	
	dw_1.resize( dw_1.width , newheight - dw_1.y  )
	
	dw_2.x = dw_1.x + dw_1.width 
	dw_2.resize( newwidth  - dw_1.width, dw_1.height)	
	
	dw_3.x = dw_2.x
	dw_4.x = dw_2.x
	dw_5.x = dw_2.x
	dw_3.resize(dw_2.width , dw_1.height )
	dw_4.resize(dw_2.width  , dw_1.height )	
	dw_5.resize(dw_2.width  , dw_1.height )		
	
	
ELSEIF  UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL_1L2R4B' THEN
	
			dw_1.resize(newwidth - (dw_1.x + dw_2.width ), newheight -  dw_1.y)
			dw_2.x = dw_1.x +dw_1.width
			dw_2.y = dw_1.y
			dw_2.resize(dw_2.width ,  newheight  -  ( dw_2.y+dw_4.height) )
			dw_3.resize(newwidth  - dw_3.x , newheight -  dw_3.y )
			dw_4.bringtotop = true
			dw_4.y = dw_2.y+ dw_2.height
			dw_4.x = dw_2.x
			dw_4.resize(dw_2.width , dw_4.height )
			dw_5.resize(dw_1.width , DW_1.height )	
			
ELSEIF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL_1L2FR' THEN		
	
	dw_1.resize( newwidth - dw_2.width , newheight - dw_1.y  )
	
	dw_2.x = dw_1.x + dw_1.width 
	dw_2.resize( newwidth  - dw_1.width, dw_1.height)	
	
	dw_3.y = dw_1.y 
	dw_3.x = dw_1.x  
	dw_3.resize( newwidth - dw_3.x  , dw_1.height )
	
	dw_4.y = dw_1.y 
	dw_4.x = dw_1.x  
	dw_4.resize( newwidth - dw_4.x , dw_1.height )
	
	dw_5.y = dw_1.y 
	dw_5.x = dw_1.x  
	dw_5.resize( newwidth - dw_5.x, dw_1.height )				

ELSEIF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL_1LF2R' THEN
	
	dw_1.resize( newwidth - dw_2.width , newheight - dw_1.y  )
	
	dw_2.x = dw_1.x + dw_1.width 
	dw_2.resize( newwidth  - dw_1.width, dw_1.height)	
	
	dw_3.y = dw_1.y 
	dw_3.x = dw_1.x  
	dw_3.resize(dw_1.width , dw_1.height )
	
	dw_4.y = dw_1.y 
	dw_4.x = dw_1.x  
	dw_4.resize(dw_1.width , dw_1.height )
	
	dw_5.y = dw_1.y 
	dw_5.x = dw_1.x  
	dw_5.resize(dw_1.width , dw_1.height )			  
ELSEIF UPPER(IVS_RESIZE_TYPE) = 'FREEFORM' THEN
	
////////////////////////////////////////////////////////////////////////////////////////////////////
// resize script for w_scale
////////////////////////////////////////////////////////////////////////////////////////////////////
		
		// recalculate the new ratios and then use the minimum
		if ib_exec then  // Check to see if wf_resize_it is already running.
			ratioh  = this.height /ii_win_height
			ratiow = this.width / ii_win_width
			ratio = MIN (ratioh, ratiow)
			rc = wf_resize_it(ratio)  //RATIO = SIZE FACTOR
		end if

ELSEIF UPPER(IVS_RESIZE_TYPE) = 'FREEFORM_WIDTH_FIT' THEN
	
////////////////////////////////////////////////////////////////////////////////////////////////////
// resize script for w_scale
////////////////////////////////////////////////////////////////////////////////////////////////////

		// recalculate the new ratios and then use the minimum
		if ib_exec then  // Check to see if wf_resize_it is already running.
			ratioh  = this.height /ii_win_height
			ratiow = this.width / ii_win_width
			ratio = MIN (ratioh, ratiow)
			rc = wf_resize_it_width_fit(ratio)  //RATIO = SIZE FACTOR
		end if

END IF
end event

event open;////===============================
//// CENTER POSITION
////===============================
//long llX, llY, llXRes, llYRes
//
//IF GetEnvironment ( lEnv ) = 1 THEN
//	// Get current screen settings
//	llXRes = lEnv.ScreenWidth
//	llYRes = lEnv.ScreenHeight
//ELSE
//	//Default to 1024/768
//	llXRes = 1024
//	llYRes = 768
//END IF
//
//// Convert pixels to PB units
//llXRes = PixelsToUnits ( llXRes, XPixelsToUnits! )
//llYRes = PixelsToUnits ( llYRes, YPixelsToUnits! )
//// Is this window too wide for the current resolution ???
//IF llXRes <= this.Width THEN
//// Move window to leftmost position
//llX = 0
//ELSE
//// Center window horizontally
//llX = (llXRes - this.Width) / 2
//END IF
//// Is this window too high for the current resolution ???
//IF llYRes <= this.Height THEN
//// Move window to topmost position
//llY = 0 
//ELSE
//// Center window vertically
//llY = (llYRes - this.Height) / 2
//END IF
//
//this.visible = false
//
//this.x = llX 
//this.y = llY -120
//
//animatewindow(handle(this),500, 524288 )  //fade 
////animatewindow(handle(this),500, 262148 )  //$$HEX8$$04c7d0c51cc1200044c598b75cb82000$$ENDHEX$$
////262145 $$HEX5$$7cc6bdcad0c51cc12000$$ENDHEX$$-> $$HEX5$$24c678b9bdca3cc75cb8$$ENDHEX$$
////262146 $$HEX6$$24c678b9bdcad0c51cc12000$$ENDHEX$$-> $$HEX4$$7cc6bdca3cc75cb8$$ENDHEX$$
//
////================================================
////
////================================================
//[instance variable]  
//CONSTANT LONG AW_HOR_POSITIVE = 1
//CONSTANT LONG AW_HOR_NEGATIVE = 2
//CONSTANT LONG AW_VER_POSITIVE = 4
//CONSTANT LONG AW_VER_NEGATIVE = 8
//CONSTANT LONG AW_CENTER = 16
//CONSTANT LONG AW_HIDE = 65536
//CONSTANT LONG AW_ACTIVATE = 131072
//CONSTANT LONG AW_SLIDE = 262144
//CONSTANT LONG AW_BLEND = 524288  
////
////[powerscript, open event]
////// slide right to left
////AnimateWindow ( Handle( this ),500,AW_HOR_NEGATIVE) 
////
////// slide left to right
////AnimateWindow ( Handle( this ),500,AW_HOR_POSITIVE)
////
////// slide top to bottom
////AnimateWindow ( Handle( this ),500,AW_VER_POSITIVE)
////
////// slide bottom to top
////AnimateWindow ( Handle( this ),500,AW_VER_NEGATIVE)
////
////// from center expand
//AnimateWindow ( Handle( this ),500,AW_CENTER)
////
////// reveal diagonnally
//AnimateWindow ( Handle( this ),2000,AW_HOR_NEGATIVE)
//this.visible = TRUE
//this.setredraw( true)


//this.setredraw( false)
dw_1.settransobject(sqlca)
dw_2.settransobject(sqlca)
dw_3.settransobject(sqlca)
dw_4.settransobject(sqlca)
dw_5.settransobject(sqlca)

SELECTED_DATA_WINDOW = DW_1
PostEvent("ue_post_open")


end event

event activate;SELECTED_WINDOW = THIS


//============================
// tab sheet
//============================
uo_tabpage tabpage
int selectedtab , i
	if not isvalid( w_tab_sheet)  then return 
      if Upperbound(w_tab_sheet.tab_1.Control[]) < 1 then return
	  
	selectedtab = w_tab_sheet.tab_1.selectedtab //$$HEX18$$04d6acc720c1ddd018b4b4c5200088c794b22000edd098d374c7c0c9200088bc38d62000$$ENDHEX$$
	if selectedtab <= 0 or isnull(selectedtab) then return
	
	tabpage = w_tab_sheet.tab_1.Control[selectedtab] //$$HEX16$$88bc38d67cb9200000acc0c9e0ac200024c60cbe1dc8b8d2200038cc70c82000$$ENDHEX$$

	if not isvalid(tabpage) then return
	
	if tabpage.ivw_openedwindow = this then return
	
 do
	i++
	tabpage = w_tab_sheet.tab_1.Control[i]
	if tabpage.ivw_openedwindow = this then 
		w_tab_sheet.tab_1.Selecttab(i) //$$HEX9$$edd098d374c7c0c9200020c1ddd020002000$$ENDHEX$$
		exit
	end if 
	
loop until i = Upperbound(w_tab_sheet.tab_1.Control[])

this.bringtotop = true
end event

event close;// $$HEX18$$70b374c7c0d008c7c4b3b0c6200018c215c8a8badcb47cb9200074d51cc85cd5e4b22000$$ENDHEX$$
Gvi_dw_edit_mode = 0
GVI_OPENTAB_COUNT = GVI_OPENTAB_COUNT -1
//============================
// tab sheet
//============================
uo_tabpage tabpage
int selectedtab

if isvalid(w_tab_sheet)  then
	
		selectedtab = w_tab_sheet.tab_1.selectedtab //$$HEX18$$04d6acc720c1ddd018b4b4c5200088c794b22000edd098d374c7c0c9200088bc38d62000$$ENDHEX$$
		
		tabpage = w_tab_sheet.tab_1.Control[selectedtab] //$$HEX16$$88bc38d67cb9200000acc0c9e0ac200024c60cbe1dc8b8d2200038cc70c82000$$ENDHEX$$
		
		w_tab_sheet.tab_1.Closetab(tabpage ) //$$HEX8$$edd098d374c7c0c92000ebb230ae2000$$ENDHEX$$
		
		//===============================================
		// $$HEX17$$edd044c72000e4b22000ebb244c5c4b32000e8ceb8d25cb820002fac18c200ac2000$$ENDHEX$$1 $$HEX11$$5cb82000acb934d1200028b4200074c7c1c058d58cac$$ENDHEX$$...
		//===============================================
		if selectedtab = 1 and  upperbound( w_tab_sheet.tab_1.Control[] ) = 1 then 
                   w_tab_sheet.tab_1.Selecttab(selectedtab)
		//$$HEX45$$04c7d0c51cc12000edd044c720003cba00c82000ebb258c530ae20004cb538bbd0c52000e8ceb8d264b820002fac18c294b2200074c7f8bb200004c9c8c5c0c9ccb9200020c1ddd01cb42000ecd0200088bc38d694b220004731$$ENDHEX$$
		//$$HEX18$$74c704c8d0c5200020c1ddd020001cb4200088bc38d674c730ae20004cb538bbd0c52000$$ENDHEX$$
		//$$HEX23$$04c8b4cc2000edd02fac18c22000f4bce4b2200020c1ddd01cb42000edd074c720006cd074ba2000090009000900$$ENDHEX$$
		elseif selectedtab > upperbound( w_tab_sheet.tab_1.Control[] ) then 
			w_tab_sheet.tab_1.Selecttab(upperbound( w_tab_sheet.tab_1.Control[] )) // $$HEX13$$5ccd85c82000edd044c7200020c145cc58d58cacccb9ecb42000$$ENDHEX$$
		else //$$HEX33$$e8ceb8d264b820002fac18c200ac200004c9c8c530ae20004cb538bbd0c5200074c704c8200020c1ddd01cb42000edd0200088bc38d65cb82000edd020c1ddd02000$$ENDHEX$$
			w_tab_sheet.tab_1.Selecttab(selectedtab)
		end if 
		
		IF GVI_OPENTAB_COUNT  = 0 THEN 
			w_tab_sheet.height = 0
		END IF 
		
		destroy tabpage
end if 

end event

event key;window activesheet
string lvs_origin_language , lvs_origin_previous_language
activesheet = w_main_frame.GetActiveSheet( )

IF keyflags = 3 THEN

   IF key = KeyK! THEN
	
	lvs_origin_language = Gvs_language
	lvs_origin_previous_language = Gvs_previous_language
	

	Gvs_language = 'K'
	
	Gvs_previous_language ='E'	
	f_dual_lang_change_text(activesheet )
	Gvs_previous_language ='C'	
	f_dual_lang_change_text(activesheet )	
	Gvs_previous_language ='K'	
	f_dual_lang_change_text(activesheet )	
	
	
	
	Gvs_language = lvs_origin_language
	Gvs_previous_language = lvs_origin_previous_language
	
   ELSEIF key = KeyC! THEN
	
	lvs_origin_language = Gvs_language
	lvs_origin_previous_language = Gvs_previous_language
	

	Gvs_language = 'C'
	Gvs_previous_language ='E'	
	f_dual_lang_change_text(activesheet )
	Gvs_previous_language ='C'	
	f_dual_lang_change_text(activesheet )	
	Gvs_previous_language ='K'	
	f_dual_lang_change_text(activesheet )	
	
	Gvs_language = lvs_origin_language
	Gvs_previous_language = lvs_origin_previous_language
	
   ELSEIF  key = KeyE! THEN
	
	lvs_origin_language = Gvs_language
	lvs_origin_previous_language = Gvs_previous_language
	

	Gvs_language = 'E'
	
	Gvs_previous_language ='E'	
	f_dual_lang_change_text(activesheet )
	Gvs_previous_language ='C'	
	f_dual_lang_change_text(activesheet )	
	Gvs_previous_language ='K'	
	f_dual_lang_change_text(activesheet )	
	
	Gvs_language = lvs_origin_language
	Gvs_previous_language = lvs_origin_previous_language
	
   END IF

END IF


end event

type dw_5 from datawindow within w_main_root
event ue_accepttext ( )
event ue_entertotab pbm_dwnprocessenter
event ue_dwkey pbm_dwnkey
event uo_mousemove pbm_dwnmousemove
event ue_unmoved pbm_syscommand
integer width = 494
integer height = 380
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
										f_set_zoom(selected_data_window, string( long(Gvs_zoom_size) - 1) )
										
									elseif  key = keyrightarrow! then 
										Gvs_zoom_size = selected_data_window.Describe("Datawindow.Zoom")		
										f_set_zoom(selected_data_window, string(long(Gvs_zoom_size) + 1) )
										
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

event uo_mousemove;if row < 1 then return
IF   GVS_SHOW_ITEM_IMAGE = 'Y' AND ( UPPER(DWO.TYPE) = 'COLUMN' AND  UPPER(DWO.NAME) = 'ITEM_CODE'  ) THEN

 IF ISVALID(W_ITEM_IMAGE_FLAT) THEN
	RETURN
ELSE
	   OPENWITHPARM(W_ITEM_IMAGE_FLAT , STRING(THIS.OBJECT.ITEM_CODE[ROW]))
END IF 
ELSE

IF isvalid(W_ITEM_IMAGE_FLAT) then
	close(W_ITEM_IMAGE_FLAT)
end if 
END IF
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
//			if UPPER(DWO.TYPE) = 'TEXT' then	
				IF row = 0 THEN 

					if Right(dwo.text , 1) = '^' then
					   dwo.text = mid( dwo.text , 1 , len(string(dwo.text)) - 1 )+'v'
					elseif Right(dwo.text , 1) = 'v' then
					   dwo.text = mid( dwo.text , 1 , len(string(dwo.text)) - 1 )+'^'						
					else
						dwo.text = dwo.text+'v'
					end if
					
					F_QUICK_SORT(THIS , MID(STRING(DWO.NAME),1,LEN(STRING(DWO.NAME)) - 2) )
					this.groupcalc( )
					
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
							
							 F_MSG_MDI_HELP( upper(dwo.name)+' '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".Edit.Style")+' '+LVS_VALUE+' Visible= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".Visible") )		
								
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

f_screen_capture()		

IF   sqldbcode = 1 THEN // UNIQUE CHECK

        F_MSGBOX1( 125 , "Row Number="+STRING(Gvl_error_row) )
	 return  1

ELSEIF sqldbcode = 2291 THEN // CONSTRAINTS CHECK PARENT NOT FOUND
	
	LVS_CONSTRAINTS_NAME = MID( sqlerrtext , POS( sqlerrtext , '.' ,1 ) + 1 ,   POS(sqlerrtext , ')' ) - ( POS( sqlerrtext , '.' ,1 )  +1 )  )
	LVS_TABLE_NAME = F_GET_CONSTRAINTS_TABLE_NAME(LVS_CONSTRAINTS_NAME) 
	
	IF ISNULL(LVS_TABLE_NAME) OR LVS_TABLE_NAME = '' THEN 
		LVS_TABLE_NAME = '*'
	END IF
	
	F_MSGBOX2(196, 'SQLCODE='+STRING(SQLCA.SQLCODE)+'  '+LVS_CONSTRAINTS_NAME , LVS_TABLE_NAME )		
	return 1

ELSEIF sqldbcode = 2292 THEN // CONSTRAINTS CHECK CHILD  FOUND CAN`T DELETE
     
    //ORA-02292: integrity constraint
	 
	LVS_CONSTRAINTS_NAME = MID( sqlerrtext , POS( sqlerrtext , '.' ,1 ) + 1 ,   POS(sqlerrtext , ')' ) - ( POS( sqlerrtext , '.' ,1 )  +1 )  )
	LVS_TABLE_NAME = F_GET_CONSTRAINTS_TABLE_NAME(LVS_CONSTRAINTS_NAME) 
	F_MSGBOX2(162, STRING(SQLCA.SQLCODE)+'  '+LVS_CONSTRAINTS_NAME , LVS_TABLE_NAME )		
	return 1
ELSEIF sqldbcode = 1400 THEN // NULL CHECK
	
	//ORA-01400: CANNOT INSERT NULL INTO ()

	LVS_COLUMN_NAME = MID( sqlerrtext , POS( sqlerrtext , '.' ,1 ) + 2 ,   POS(sqlerrtext , ')' ) - POS( sqlerrtext , '.' ,1 ) + 2     )
	LVS_COLUMN_NAME = MID( LVS_COLUMN_NAME , POS( LVS_COLUMN_NAME , '.' ,1 ) + 2 , LEN(LVS_COLUMN_NAME)  -  POS( LVS_COLUMN_NAME , '.' ,1 )  - 6 ) 
	//======================================================================
	// $$HEX8$$eccefcb785ba44c7200000ac38c834c6$$ENDHEX$$
	//======================================================================	
	SELECT NVL(DECODE( :GVS_LANGUAGE , 'K' , WORD_KOR , 'E' , WORD_ENG , WORD_LOCAL ) , :LVS_COLUMN_NAME ) ,
             	      NVL(DECODE( :GVS_LANGUAGE , 'K' , WORD_DESCRIPTION_KOR , 'E' , WORD_DESCRIPTION_ENG , WORD_DESCRIPTION_LOCAL ) , :LVS_COLUMN_NAME )
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
		 F_MSGBOX1(111, LVS_COLUMN_NAME+'~r~n'+SQLERRTEXT)
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


//=========================================================
// Error Log Trace
//=========================================================
if Gvs_error_log_trace_yn = 'Y' then
	f_set_error_log_trace( w_main_frame.Getactivesheet() , 'DW_5' , 0 , ''  , Gvl_DberrorCode , Gvs_DberrorMessage , Gvs_error_syntax ) 
end if 
//=========================================================

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
Long i
string lvs_ret , lvs_vis , lvs_eval 
 IF  UPPER(DWO.TYPE) = 'TEXT' AND  UPPER(DWO.NAME) = 'CHECK_YN_T' THEN

		
	if this.object.check_yn_t.tag  = 'Y' then 	

		open(w_progress_popup)
		w_progress_popup.f_set_range(1 , this.rowcount( ) )
		w_progress_popup.f_setstep(1)
		do
			
			i++
		
				this.object.check_yn[i] = 'N' 
				this.trigger event itemchanged( i , this.object.check_yn , this.object.check_yn[i])
				w_progress_popup.f_stepit()
		loop until i = this.rowcount()
		this.object.check_yn_t.tag  = 'N' 		
		close(w_progress_popup)

		
	else
		
		lvs_eval = string(this.object.check_yn.visible)
		f_get_token(lvs_eval , '~t')
		lvs_eval = Mid( lvs_eval , 1 , Len(lvs_eval) -1 )
		
		open(w_progress_popup)
		w_progress_popup.f_set_range(1 , this.rowcount( ) )
		w_progress_popup.f_setstep(1)		
		do
			i++
				if lvs_eval = '' then
						this.object.check_yn[i] = 'Y' 
						this.trigger event itemchanged( i , this.object.check_yn , this.object.check_yn[i])								
				else
					lvs_ret = this.describe("evaluate(~' "+lvs_eval+"~',"+string(i)+")")
					if lvs_ret = '1' then 
						this.object.check_yn[i] = 'Y' 
						this.trigger event itemchanged( i , this.object.check_yn , this.object.check_yn[i])		
					elseif lvs_ret = '!' then 
						
						Msg = Messagebox("Notify" ,lvs_ret+'  '+ lvs_eval  +" Continue ?", Stopsign! , Yesno!)
						if Msg = 1 then 
						else
							Return
						end if
					end if 
					
				end if
		     	w_progress_popup.f_stepit()
				  
		loop until i = this.rowcount()
		this.object.check_yn_t.tag  = 'Y' 		
		close(w_progress_popup)		
	
	end if
		
END IF

//=======================================================
//
//=======================================================

 IF  UPPER(DWO.TYPE) = 'TEXT' AND  UPPER(DWO.NAME) = 'CONFIRM_STATUS_T' THEN

		
	if this.object.CONFIRM_STATUS_T.tag  = 'Y' then 	
		
		do
			
			i++
			this.object.CONFIRM_STATUS[i] = 'N' 
			this.trigger event itemchanged( i , this.object.CONFIRM_STATUS , this.object.CONFIRM_STATUS[i])
			
		loop until i = this.rowcount()
		
		this.object.CONFIRM_STATUS_T.tag  = 'N' 
		
		
		
	else
		
		do
			i++
			this.object.CONFIRM_STATUS[i] = 'Y' 
			this.trigger event itemchanged( i , this.object.CONFIRM_STATUS , this.object.CONFIRM_STATUS[i])			
		loop until i = this.rowcount()
		
		this.object.CONFIRM_STATUS_T.tag  = 'Y' 
		
	end if
		
END IF
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

//("Data Input Error" , 'Data Invalid Check Data Length or Data Type ( String , Number , Date ...)  =>' + data ) 
RETURN 1
end event

event itemfocuschanged; ls_anydata = dwo
if Gvs_popup_auto_active = 'Y' THEN
	TRIGGER EVENT RBUTTONDOWN( 0 , 0 , ROW , DWO )
end if
end event

event retrieveend;GVS_DB_CANCEL = 'N'
IF ISVALID(W_CANCEL_RETRIEVE_POP) THEN
	CLOSE(W_CANCEL_RETRIEVE_POP)
ELSE
	
END IF

//if Gst_set.window_type = 'REPORT' then 
//	String modstring
//	modstring = 'create bitmap(band=footer x="14" y="20" height="76" width="87" filename="company_logo.bmp" border="0" name=comlogo )'
//	this.Modify( modstring)
//end if
//
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
	
	IF GVS_DB_CANCEL = 'Y' THEN 
		
		THIS.DBCANCEL()	 
		RETURN 1
	ELSE
		
	END IF


END IF

end event

event retrievestart;if ivs_set_column_dddw5 = 'Y' then 
else
   f_set_column_dddw( dw_5 )
   ivs_set_column_dddw5 = 'Y'		
end if
	
	
IF ivs_modify_security = 'Y' THEN
		
		IF THIS.MODIFIEDCOUNT() > 0 OR DELETEDCOUNT() > 0 THEN 
			
			Msg = F_MSGBOX1( 9014 , String(THIS.MODIFIEDCOUNT()+THIS.DELETEDCOUNT()))
			
			if Msg = 1 then 	
				
				Gvs_Ue_DATA_control = 'UPDATE'
				Parent.Triggerevent("UE_DATA_CONTROL")
				
			ELSEIF Msg = 2 then 	//NO 
				
				ROLLBACK ;
				RETURN
				
			ELSE // CANCEL
				 RETURN 2
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

IF currentrow = 0  or gvs_deleteselecte_mod = 'Y' THEN RETURN

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

event error;//if f_msgbox1( 144 , STRING(ERRORNUMBER)+" "+ERRORTEXT+" "+errorwindowmenu+" "+errorobject+" "+errorscript+" "+STRING(errorline)+" ") = 1 then 
//   Rollback;
//   Disconnect ;
//   Halt Close
//else
//	action  = EXCEPTIONiGNORE!
//end if
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

event rbuttondown;String lvs_date , LVS_VALUE

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
			OPENWITHPARM(W_QUICK_FILTER , THIS)
elseif UPPER(dwo.type) = 'BUTTON' then
		LVS_VALUE = DWO.TEXT
		IF ISNULL(LVS_VALUE) THEN 
		     LVS_VALUE = ' '	
		END IF
			
elseif UPPER(dwo.type) = 'GROUPBOX' then
		LVS_VALUE = DWO.TEXT
		IF ISNULL(LVS_VALUE) THEN 
		     LVS_VALUE = ' '	
		END IF
						
elseif 	UPPER(dwo.type) = 'DATAWINDOW' then
		LVS_VALUE = THIS.CLASSNAME()
		if Gvi_language_direct_change = 1 then 
			 OPENWITHPARM( W_DUAL_LANGUAGE_POPUP ,  this.title )
		end if 		
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
		

	    if   Gst_set.Report_window = True  then
			
			m_main_frame_menu.m_file.m_print.popmenu( w_main_frame.pointerx() , w_main_frame.pointery() ) 					
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
	 string lvs_eval , lvs_ret
			lvs_eval = this.Describe(dwo.name+".Protect")
			lvs_eval = f_replace_string(lvs_eval , "~'" , "~"")
			f_get_token(lvs_eval , '~t')
			lvs_eval = Mid( lvs_eval , 1 , Len(lvs_eval) -1 )
	
			if lvs_eval = '' then
			else
					lvs_ret = this.describe("evaluate(~' "+lvs_eval+"~',"+string(row)+")")
					if lvs_ret = '1' then 
						return
					elseif lvs_ret = '!' then 
						return
					end if
			end if

			  if  this.Describe(dwo.name+".TabSequence") ='0' then
			      if  w_main_frame.menuname = 'm_main_frame_menu' then 
					m_main_frame_menu.m_control.m_rbuttonmenu.popmenu( w_main_frame.pointerx() , w_main_frame.pointery() ) 
				end if 					
				return
			end if
		
			IF  Upper(this.describe( dwo.name+".ColType")) = 'DATE'  OR Upper(this.describe( dwo.name+".ColType")) = 'DATETIME' THEN 
				
				if dwo.name = 'delivery_date' then 
					OPEN(W_COMPANY_CALENDAR_POPUP )
					if  Message.Stringparm = '' or isnull( Message.Stringparm) then 
					else
						lvs_date = message.stringparm
						dwo.Primary[row] = datetime( date(lvs_date))
						post event itemchanged( row , dwo , lvs_date )					
					end if					
				else
					OPEN(W_CALENDAR_POPUP )
					if  Message.Stringparm = '' or isnull( Message.Stringparm) then 
					else
						lvs_date = message.stringparm
						dwo.Primary[row] = datetime( date(lvs_date))
						post event itemchanged( row , dwo , lvs_date )					
					end if
					
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

event getfocus;SELECTED_DATA_WINDOW = THIS
end event

type dw_4 from datawindow within w_main_root
event ue_accepttext ( )
event ue_entertotab pbm_dwnprocessenter
event ue_dwkey pbm_dwnkey
event uo_mousemove pbm_dwnmousemove
event ue_unmoved pbm_syscommand
integer width = 494
integer height = 380
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
										f_set_zoom(selected_data_window, string( long(Gvs_zoom_size) - 1) )
										
									elseif  key = keyrightarrow! then 
										Gvs_zoom_size = selected_data_window.Describe("Datawindow.Zoom")		
										f_set_zoom(selected_data_window, string(long(Gvs_zoom_size) + 1) )
										
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

event uo_mousemove;if row < 1 then return
IF   GVS_SHOW_ITEM_IMAGE = 'Y' AND ( UPPER(DWO.TYPE) = 'COLUMN' AND  UPPER(DWO.NAME) = 'ITEM_CODE'  ) THEN

 IF ISVALID(W_ITEM_IMAGE_FLAT) THEN
	RETURN
ELSE
	   OPENWITHPARM(W_ITEM_IMAGE_FLAT , STRING(THIS.OBJECT.ITEM_CODE[ROW]))
END IF 
ELSE

IF isvalid(W_ITEM_IMAGE_FLAT) then
	close(W_ITEM_IMAGE_FLAT)
end if 
END IF
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
//			if UPPER(DWO.TYPE) = 'TEXT' then	
				IF row = 0 THEN 

					if Right(dwo.text , 1) = '^' then
					   dwo.text = mid( dwo.text , 1 , len(string(dwo.text)) - 1 )+'v'
					elseif Right(dwo.text , 1) = 'v' then
					   dwo.text = mid( dwo.text , 1 , len(string(dwo.text)) - 1 )+'^'						
					else
						dwo.text = dwo.text+'v'
					end if
					
					F_QUICK_SORT(THIS , MID(STRING(DWO.NAME),1,LEN(STRING(DWO.NAME)) - 2) )
					this.groupcalc( )
					
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
							
							 F_MSG_MDI_HELP( upper(dwo.name)+' '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".Edit.Style")+' '+LVS_VALUE+' Visible= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".Visible") )		
								
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

f_screen_capture()		

IF   sqldbcode = 1 THEN // UNIQUE CHECK

        F_MSGBOX1( 125 , "Row Number="+STRING(Gvl_error_row) )
	 return  1

ELSEIF sqldbcode = 2291 THEN // CONSTRAINTS CHECK PARENT NOT FOUND
	
	LVS_CONSTRAINTS_NAME = MID( sqlerrtext , POS( sqlerrtext , '.' ,1 ) + 1 ,   POS(sqlerrtext , ')' ) - ( POS( sqlerrtext , '.' ,1 )  +1 )  )
	LVS_TABLE_NAME = F_GET_CONSTRAINTS_TABLE_NAME(LVS_CONSTRAINTS_NAME) 
	
	IF ISNULL(LVS_TABLE_NAME) OR LVS_TABLE_NAME = '' THEN 
		LVS_TABLE_NAME = '*'
	END IF
	
	F_MSGBOX2(196, 'SQLCODE='+STRING(SQLCA.SQLCODE)+'  '+LVS_CONSTRAINTS_NAME , LVS_TABLE_NAME )		
	return 1

ELSEIF sqldbcode = 2292 THEN // CONSTRAINTS CHECK CHILD  FOUND CAN`T DELETE
     
    //ORA-02292: integrity constraint
	 
	LVS_CONSTRAINTS_NAME = MID( sqlerrtext , POS( sqlerrtext , '.' ,1 ) + 1 ,   POS(sqlerrtext , ')' ) - ( POS( sqlerrtext , '.' ,1 )  +1 )  )
	LVS_TABLE_NAME = F_GET_CONSTRAINTS_TABLE_NAME(LVS_CONSTRAINTS_NAME) 
	F_MSGBOX2(162, STRING(SQLCA.SQLCODE)+'  '+LVS_CONSTRAINTS_NAME , LVS_TABLE_NAME )		
	return 1
ELSEIF sqldbcode = 1400 THEN // NULL CHECK
	
	//ORA-01400: CANNOT INSERT NULL INTO ()

	LVS_COLUMN_NAME = MID( sqlerrtext , POS( sqlerrtext , '.' ,1 ) + 2 ,   POS(sqlerrtext , ')' ) - POS( sqlerrtext , '.' ,1 ) + 2     )
	LVS_COLUMN_NAME = MID( LVS_COLUMN_NAME , POS( LVS_COLUMN_NAME , '.' ,1 ) + 2 , LEN(LVS_COLUMN_NAME)  -  POS( LVS_COLUMN_NAME , '.' ,1 )  - 6 ) 
	//======================================================================
	// $$HEX8$$eccefcb785ba44c7200000ac38c834c6$$ENDHEX$$
	//======================================================================	
	SELECT NVL(DECODE( :GVS_LANGUAGE , 'K' , WORD_KOR , 'E' , WORD_ENG , WORD_LOCAL ) , :LVS_COLUMN_NAME ) ,
             	      NVL(DECODE( :GVS_LANGUAGE , 'K' , WORD_DESCRIPTION_KOR , 'E' , WORD_DESCRIPTION_ENG , WORD_DESCRIPTION_LOCAL ) , :LVS_COLUMN_NAME )
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
		 F_MSGBOX1(111, LVS_COLUMN_NAME+'~r~n'+SQLERRTEXT)
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


//=========================================================
// Error Log Trace
//=========================================================
if Gvs_error_log_trace_yn = 'Y' then
	f_set_error_log_trace( w_main_frame.Getactivesheet() , 'DW_4' , 0 , ''  , Gvl_DberrorCode , Gvs_DberrorMessage , Gvs_error_syntax ) 
end if 
//=========================================================

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
Long i
string lvs_ret , lvs_vis , lvs_eval 
 IF  UPPER(DWO.TYPE) = 'TEXT' AND  UPPER(DWO.NAME) = 'CHECK_YN_T' THEN

		
	if this.object.check_yn_t.tag  = 'Y' then 	

		open(w_progress_popup)
		w_progress_popup.f_set_range(1 , this.rowcount( ) )
		w_progress_popup.f_setstep(1)
		do
			
			i++
		
				this.object.check_yn[i] = 'N' 
				this.trigger event itemchanged( i , this.object.check_yn , this.object.check_yn[i])
				w_progress_popup.f_stepit()
		loop until i = this.rowcount()
		this.object.check_yn_t.tag  = 'N' 		
		close(w_progress_popup)

		
	else
		
		lvs_eval = string(this.object.check_yn.visible)
		f_get_token(lvs_eval , '~t')
		lvs_eval = Mid( lvs_eval , 1 , Len(lvs_eval) -1 )
		
		open(w_progress_popup)
		w_progress_popup.f_set_range(1 , this.rowcount( ) )
		w_progress_popup.f_setstep(1)		
		do
			i++
				if lvs_eval = '' then
						this.object.check_yn[i] = 'Y' 
						this.trigger event itemchanged( i , this.object.check_yn , this.object.check_yn[i])								
				else
					lvs_ret = this.describe("evaluate(~' "+lvs_eval+"~',"+string(i)+")")
					if lvs_ret = '1' then 
						this.object.check_yn[i] = 'Y' 
						this.trigger event itemchanged( i , this.object.check_yn , this.object.check_yn[i])		
					elseif lvs_ret = '!' then 
						
						Msg = Messagebox("Notify" ,lvs_ret+'  '+ lvs_eval  +" Continue ?", Stopsign! , Yesno!)
						if Msg = 1 then 
						else
							Return
						end if
					end if 
					
				end if
		     	w_progress_popup.f_stepit()
				  
		loop until i = this.rowcount()
		this.object.check_yn_t.tag  = 'Y' 		
		close(w_progress_popup)		
	
	end if
		
END IF

//=======================================================
//
//=======================================================

 IF  UPPER(DWO.TYPE) = 'TEXT' AND  UPPER(DWO.NAME) = 'CONFIRM_STATUS_T' THEN

		
	if this.object.CONFIRM_STATUS_T.tag  = 'Y' then 	
		
		do
			
			i++
			this.object.CONFIRM_STATUS[i] = 'N' 
			this.trigger event itemchanged( i , this.object.CONFIRM_STATUS , this.object.CONFIRM_STATUS[i])
			
		loop until i = this.rowcount()
		
		this.object.CONFIRM_STATUS_T.tag  = 'N' 
		
		
		
	else
		
		do
			i++
			this.object.CONFIRM_STATUS[i] = 'Y' 
			this.trigger event itemchanged( i , this.object.CONFIRM_STATUS , this.object.CONFIRM_STATUS[i])			
		loop until i = this.rowcount()
		
		this.object.CONFIRM_STATUS_T.tag  = 'Y' 
		
	end if
		
END IF
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

//("Data Input Error" , 'Data Invalid Check Data Length or Data Type ( String , Number , Date ...)  =>' + data ) 
RETURN 1
end event

event itemfocuschanged; ls_anydata = dwo
if Gvs_popup_auto_active = 'Y' THEN
	TRIGGER EVENT RBUTTONDOWN( 0 , 0 , ROW , DWO )
end if
end event

event retrieveend;GVS_DB_CANCEL = 'N'
IF ISVALID(W_CANCEL_RETRIEVE_POP) THEN
	CLOSE(W_CANCEL_RETRIEVE_POP)
ELSE
	
END IF

//if Gst_set.window_type = 'REPORT' then 
//	String modstring
//	modstring = 'create bitmap(band=footer x="14" y="20" height="76" width="87" filename="company_logo.bmp" border="0" name=comlogo )'
//	this.Modify( modstring)
//end if

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
	
	IF GVS_DB_CANCEL = 'Y' THEN 
		
		THIS.DBCANCEL()	 
		RETURN 1
	ELSE
		
	END IF


END IF

end event

event retrievestart;if ivs_set_column_dddw4 = 'Y' then 
else
   f_set_column_dddw( dw_4 )
   ivs_set_column_dddw4 = 'Y'		
end if
	
	
IF ivs_modify_security = 'Y' THEN
		
		IF THIS.MODIFIEDCOUNT() > 0 OR DELETEDCOUNT() > 0 THEN 
			
			Msg = F_MSGBOX1( 9014 , String(THIS.MODIFIEDCOUNT()+THIS.DELETEDCOUNT()))
			
			if Msg = 1 then 	
				
				Gvs_Ue_DATA_control = 'UPDATE'
				Parent.Triggerevent("UE_DATA_CONTROL")
				
			ELSEIF Msg = 2 then 	//NO 
				
				ROLLBACK ;
				RETURN
				
			ELSE // CANCEL
				 RETURN 2
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

IF currentrow = 0  or gvs_deleteselecte_mod = 'Y' THEN RETURN

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

event rbuttondown;String lvs_date , LVS_VALUE

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
		OPENWITHPARM(W_QUICK_FILTER , THIS)	
elseif UPPER(dwo.type) = 'BUTTON' then
		LVS_VALUE = DWO.TEXT
		IF ISNULL(LVS_VALUE) THEN 
		     LVS_VALUE = ' '	
		END IF
			
elseif UPPER(dwo.type) = 'GROUPBOX' then
		LVS_VALUE = DWO.TEXT
		IF ISNULL(LVS_VALUE) THEN 
		     LVS_VALUE = ' '	
		END IF
		
elseif 	UPPER(dwo.type) = 'DATAWINDOW' then
		LVS_VALUE = THIS.CLASSNAME()
		if Gvi_language_direct_change = 1 then 
			 OPENWITHPARM( W_DUAL_LANGUAGE_POPUP ,  this.title )
		end if 		
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
		

	    if   Gst_set.Report_window = True  then
			
			m_main_frame_menu.m_file.m_print.popmenu( w_main_frame.pointerx() , w_main_frame.pointery() ) 					
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
	 string lvs_eval , lvs_ret
			lvs_eval = this.Describe(dwo.name+".Protect")
			lvs_eval = f_replace_string(lvs_eval , "~'" , "~"")
			f_get_token(lvs_eval , '~t')
			lvs_eval = Mid( lvs_eval , 1 , Len(lvs_eval) -1 )
	
			if lvs_eval = '' then
			else
					lvs_ret = this.describe("evaluate(~' "+lvs_eval+"~',"+string(row)+")")
					if lvs_ret = '1' then 
						return
					elseif lvs_ret = '!' then 
						return
					end if
			end if

			  if  this.Describe(dwo.name+".TabSequence") ='0' then
			      if  w_main_frame.menuname = 'm_main_frame_menu' then 
					m_main_frame_menu.m_control.m_rbuttonmenu.popmenu( w_main_frame.pointerx() , w_main_frame.pointery() ) 
				end if 					
				return
			end if
		
			IF  Upper(this.describe( dwo.name+".ColType")) = 'DATE'  OR Upper(this.describe( dwo.name+".ColType")) = 'DATETIME' THEN 
				
					if dwo.name = 'delivery_date' then 
					OPEN(W_COMPANY_CALENDAR_POPUP )
					if  Message.Stringparm = '' or isnull( Message.Stringparm) then 
					else
						lvs_date = message.stringparm
						dwo.Primary[row] = datetime( date(lvs_date))
						post event itemchanged( row , dwo , lvs_date )					
					end if					
				else
					OPEN(W_CALENDAR_POPUP )
					if  Message.Stringparm = '' or isnull( Message.Stringparm) then 
					else
						lvs_date = message.stringparm
						dwo.Primary[row] = datetime( date(lvs_date))
						post event itemchanged( row , dwo , lvs_date )					
					end if
					
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

event getfocus;SELECTED_DATA_WINDOW = THIS
end event

type dw_3 from datawindow within w_main_root
event ue_accepttext ( )
event ue_entertotab pbm_dwnprocessenter
event ue_dwkey pbm_dwnkey
event uo_mousemove pbm_dwnmousemove
event ue_unmoved pbm_syscommand
integer width = 494
integer height = 380
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
										f_set_zoom(selected_data_window, string( long(Gvs_zoom_size) - 1) )
										
									elseif  key = keyrightarrow! then 
										Gvs_zoom_size = selected_data_window.Describe("Datawindow.Zoom")		
										f_set_zoom(selected_data_window, string(long(Gvs_zoom_size) + 1) )
										
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
						lvs_object_type  = Gst_edit_object.object_type[i]
						
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

event uo_mousemove;if row < 1 then return
IF   GVS_SHOW_ITEM_IMAGE = 'Y' AND ( UPPER(DWO.TYPE) = 'COLUMN' AND  UPPER(DWO.NAME) = 'ITEM_CODE'  ) THEN

 IF ISVALID(W_ITEM_IMAGE_FLAT) THEN
	RETURN
ELSE
	   OPENWITHPARM(W_ITEM_IMAGE_FLAT , STRING(THIS.OBJECT.ITEM_CODE[ROW]))
END IF 
ELSE

IF isvalid(W_ITEM_IMAGE_FLAT) then
	close(W_ITEM_IMAGE_FLAT)
end if 
END IF
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
//			if UPPER(DWO.TYPE) = 'TEXT' then	
				IF row = 0 THEN 

					if Right(dwo.text , 1) = '^' then
					   dwo.text = mid( dwo.text , 1 , len(string(dwo.text)) - 1 )+'v'
					elseif Right(dwo.text , 1) = 'v' then
					   dwo.text = mid( dwo.text , 1 , len(string(dwo.text)) - 1 )+'^'						
					else
						dwo.text = dwo.text+'v'
					end if
					
					F_QUICK_SORT(THIS , MID(STRING(DWO.NAME),1,LEN(STRING(DWO.NAME)) - 2) )
					this.groupcalc( )
					
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
							
							 F_MSG_MDI_HELP( upper(dwo.name)+' '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".Edit.Style")+' '+LVS_VALUE+' Visible= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".Visible") )		
								
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

f_screen_capture()		

IF   sqldbcode = 1 THEN // UNIQUE CHECK

        F_MSGBOX1( 125 , "Row Number="+STRING(Gvl_error_row) )
	 return  1

ELSEIF sqldbcode = 2291 THEN // CONSTRAINTS CHECK PARENT NOT FOUND
	
	LVS_CONSTRAINTS_NAME = MID( sqlerrtext , POS( sqlerrtext , '.' ,1 ) + 1 ,   POS(sqlerrtext , ')' ) - ( POS( sqlerrtext , '.' ,1 )  +1 )  )
	LVS_TABLE_NAME = F_GET_CONSTRAINTS_TABLE_NAME(LVS_CONSTRAINTS_NAME) 
	
	IF ISNULL(LVS_TABLE_NAME) OR LVS_TABLE_NAME = '' THEN 
		LVS_TABLE_NAME = '*'
	END IF
	
	F_MSGBOX2(196, 'SQLCODE='+STRING(SQLCA.SQLCODE)+'  '+LVS_CONSTRAINTS_NAME , LVS_TABLE_NAME )		
	return 1

ELSEIF sqldbcode = 2292 THEN // CONSTRAINTS CHECK CHILD  FOUND CAN`T DELETE
     
    //ORA-02292: integrity constraint
	 
	LVS_CONSTRAINTS_NAME = MID( sqlerrtext , POS( sqlerrtext , '.' ,1 ) + 1 ,   POS(sqlerrtext , ')' ) - ( POS( sqlerrtext , '.' ,1 )  +1 )  )
	LVS_TABLE_NAME = F_GET_CONSTRAINTS_TABLE_NAME(LVS_CONSTRAINTS_NAME) 
	F_MSGBOX2(162, STRING(SQLCA.SQLCODE)+'  '+LVS_CONSTRAINTS_NAME , LVS_TABLE_NAME )		
	return 1
ELSEIF sqldbcode = 1400 THEN // NULL CHECK
	
	//ORA-01400: CANNOT INSERT NULL INTO ()

	LVS_COLUMN_NAME = MID( sqlerrtext , POS( sqlerrtext , '.' ,1 ) + 2 ,   POS(sqlerrtext , ')' ) - POS( sqlerrtext , '.' ,1 ) + 2     )
	LVS_COLUMN_NAME = MID( LVS_COLUMN_NAME , POS( LVS_COLUMN_NAME , '.' ,1 ) + 2 , LEN(LVS_COLUMN_NAME)  -  POS( LVS_COLUMN_NAME , '.' ,1 )  - 6 ) 
	//======================================================================
	// $$HEX8$$eccefcb785ba44c7200000ac38c834c6$$ENDHEX$$
	//======================================================================	
	SELECT NVL(DECODE( :GVS_LANGUAGE , 'K' , WORD_KOR , 'E' , WORD_ENG , WORD_LOCAL ) , :LVS_COLUMN_NAME ) ,
             	      NVL(DECODE( :GVS_LANGUAGE , 'K' , WORD_DESCRIPTION_KOR , 'E' , WORD_DESCRIPTION_ENG , WORD_DESCRIPTION_LOCAL ) , :LVS_COLUMN_NAME )
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
		 F_MSGBOX1(111, LVS_COLUMN_NAME+'~r~n'+SQLERRTEXT)
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

//=========================================================
// Error Log Trace
//=========================================================
if Gvs_error_log_trace_yn = 'Y' then
	f_set_error_log_trace( w_main_frame.Getactivesheet() , 'DW_3' , 0 , ''  , Gvl_DberrorCode , Gvs_DberrorMessage , Gvs_error_syntax ) 
end if 
//=========================================================

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
Long i
string lvs_ret , lvs_vis , lvs_eval 
 IF  UPPER(DWO.TYPE) = 'TEXT' AND  UPPER(DWO.NAME) = 'CHECK_YN_T' THEN

		
	if this.object.check_yn_t.tag  = 'Y' then 	

		open(w_progress_popup)
		w_progress_popup.f_set_range(1 , this.rowcount( ) )
		w_progress_popup.f_setstep(1)
		do
			
			i++
		
				this.object.check_yn[i] = 'N' 
				this.trigger event itemchanged( i , this.object.check_yn , this.object.check_yn[i])
				w_progress_popup.f_stepit()
		loop until i = this.rowcount()
		this.object.check_yn_t.tag  = 'N' 		
		close(w_progress_popup)

		
	else
		
		lvs_eval = string(this.object.check_yn.visible)
		f_get_token(lvs_eval , '~t')
		lvs_eval = Mid( lvs_eval , 1 , Len(lvs_eval) -1 )
		
		open(w_progress_popup)
		w_progress_popup.f_set_range(1 , this.rowcount( ) )
		w_progress_popup.f_setstep(1)		
		do
			i++
				if lvs_eval = '' then
						this.object.check_yn[i] = 'Y' 
						this.trigger event itemchanged( i , this.object.check_yn , this.object.check_yn[i])								
				else
					lvs_ret = this.describe("evaluate(~' "+lvs_eval+"~',"+string(i)+")")
					if lvs_ret = '1' then 
						this.object.check_yn[i] = 'Y' 
						this.trigger event itemchanged( i , this.object.check_yn , this.object.check_yn[i])		
					elseif lvs_ret = '!' then 
						
						Msg = Messagebox("Notify" ,lvs_ret+'  '+ lvs_eval  +" Continue ?", Stopsign! , Yesno!)
						if Msg = 1 then 
						else
							Return
						end if
					end if 
					
				end if
		     	w_progress_popup.f_stepit()
				  
		loop until i = this.rowcount()
		this.object.check_yn_t.tag  = 'Y' 		
		close(w_progress_popup)		
	
	end if
		
END IF

//=======================================================
//
//=======================================================

 IF  UPPER(DWO.TYPE) = 'TEXT' AND  UPPER(DWO.NAME) = 'CONFIRM_STATUS_T' THEN

		
	if this.object.CONFIRM_STATUS_T.tag  = 'Y' then 	
		
		do
			
			i++
			this.object.CONFIRM_STATUS[i] = 'N' 
			this.trigger event itemchanged( i , this.object.CONFIRM_STATUS , this.object.CONFIRM_STATUS[i])
			
		loop until i = this.rowcount()
		
		this.object.CONFIRM_STATUS_T.tag  = 'N' 
		
		
		
	else
		
		do
			i++
			this.object.CONFIRM_STATUS[i] = 'Y' 
			this.trigger event itemchanged( i , this.object.CONFIRM_STATUS , this.object.CONFIRM_STATUS[i])			
		loop until i = this.rowcount()
		
		this.object.CONFIRM_STATUS_T.tag  = 'Y' 
		
	end if
		
END IF
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

//("Data Input Error" , 'Data Invalid Check Data Length or Data Type ( String , Number , Date ...)  =>' + data ) 
RETURN 1
end event

event itemfocuschanged; ls_anydata = dwo
if Gvs_popup_auto_active = 'Y' THEN
	TRIGGER EVENT RBUTTONDOWN( 0 , 0 , ROW , DWO )
end if
end event

event retrieveend;GVS_DB_CANCEL = 'N'
IF ISVALID(W_CANCEL_RETRIEVE_POP) THEN
	CLOSE(W_CANCEL_RETRIEVE_POP)
ELSE
	
END IF

//if Gst_set.window_type = 'REPORT' then 
//	String modstring
//	modstring = 'create bitmap(band=footer x="14" y="20" height="76" width="87" filename="company_logo.bmp" border="0" name=comlogo )'
//	this.Modify( modstring)
//end if

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
	
	IF GVS_DB_CANCEL = 'Y' THEN 
		
		THIS.DBCANCEL()	 
		RETURN 1
	ELSE
		
	END IF


END IF

end event

event retrievestart;if ivs_set_column_dddw3 = 'Y' then 
else
   f_set_column_dddw( dw_3 )
   ivs_set_column_dddw4 = 'Y'		
end if
	
	
IF ivs_modify_security = 'Y' THEN
		
		IF THIS.MODIFIEDCOUNT() > 0 OR DELETEDCOUNT() > 0 THEN 
			
			Msg = F_MSGBOX1( 9014 , String(THIS.MODIFIEDCOUNT()+THIS.DELETEDCOUNT()))
			
			if Msg = 1 then 	
				
				Gvs_Ue_DATA_control = 'UPDATE'
				Parent.Triggerevent("UE_DATA_CONTROL")
				
			ELSEIF Msg = 2 then 	//NO 
				
				ROLLBACK ;
				RETURN
				
			ELSE // CANCEL
				 RETURN 2
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

IF currentrow = 0  or gvs_deleteselecte_mod = 'Y' THEN RETURN

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

event rbuttondown;String lvs_date , LVS_VALUE

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
		OPENWITHPARM(W_QUICK_FILTER , THIS)	
elseif UPPER(dwo.type) = 'BUTTON' then
		LVS_VALUE = DWO.TEXT
		IF ISNULL(LVS_VALUE) THEN 
		     LVS_VALUE = ' '	
		END IF
		
elseif UPPER(dwo.type) = 'GROUPBOX' then
		LVS_VALUE = DWO.TEXT
		IF ISNULL(LVS_VALUE) THEN 
		     LVS_VALUE = ' '	
		END IF
					
elseif 	UPPER(dwo.type) = 'DATAWINDOW' then
		LVS_VALUE = THIS.CLASSNAME()
		if Gvi_language_direct_change = 1 then 
			 OPENWITHPARM( W_DUAL_LANGUAGE_POPUP ,  this.title )
		end if 		
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
		

	    if   Gst_set.Report_window = True  then
			
			m_main_frame_menu.m_file.m_print.popmenu( w_main_frame.pointerx() , w_main_frame.pointery() ) 					
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
	 string lvs_eval , lvs_ret
			lvs_eval = this.Describe(dwo.name+".Protect")
			lvs_eval = f_replace_string(lvs_eval , "~'" , "~"")
			f_get_token(lvs_eval , '~t')
			lvs_eval = Mid( lvs_eval , 1 , Len(lvs_eval) -1 )
	
			if lvs_eval = '' then
			else
					lvs_ret = this.describe("evaluate(~' "+lvs_eval+"~',"+string(row)+")")
					if lvs_ret = '1' then 
						return
					elseif lvs_ret = '!' then 
						return
					end if
			end if

			  if  this.Describe(dwo.name+".TabSequence") ='0' then
			      if  w_main_frame.menuname = 'm_main_frame_menu' then 
					m_main_frame_menu.m_control.m_rbuttonmenu.popmenu( w_main_frame.pointerx() , w_main_frame.pointery() ) 
				end if 					
				return
			end if
		
			IF  Upper(this.describe( dwo.name+".ColType")) = 'DATE'  OR Upper(this.describe( dwo.name+".ColType")) = 'DATETIME' THEN 
				
				if dwo.name = 'delivery_date' then 
					OPEN(W_COMPANY_CALENDAR_POPUP )
					if  Message.Stringparm = '' or isnull( Message.Stringparm) then 
					else
						lvs_date = message.stringparm
						dwo.Primary[row] = datetime( date(lvs_date))
						post event itemchanged( row , dwo , lvs_date )					
					end if					
				else
					OPEN(W_CALENDAR_POPUP )
					if  Message.Stringparm = '' or isnull( Message.Stringparm) then 
					else
						lvs_date = message.stringparm
						dwo.Primary[row] = datetime( date(lvs_date))
						post event itemchanged( row , dwo , lvs_date )					
					end if
					
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

event getfocus;SELECTED_DATA_WINDOW = THIS
end event

type dw_2 from datawindow within w_main_root
event ue_accepttext ( )
event ue_entertotab pbm_dwnprocessenter
event ue_dwkey pbm_dwnkey
event uo_mousemove pbm_dwnmousemove
event ue_unmoved pbm_syscommand
integer width = 494
integer height = 380
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
										f_set_zoom(selected_data_window, string( long(Gvs_zoom_size) - 1) )
										
									elseif  key = keyrightarrow! then 
										Gvs_zoom_size = selected_data_window.Describe("Datawindow.Zoom")		
										f_set_zoom(selected_data_window, string(long(Gvs_zoom_size) + 1) )
										
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

event uo_mousemove;if row < 1 then return
IF   GVS_SHOW_ITEM_IMAGE = 'Y' AND ( UPPER(DWO.TYPE) = 'COLUMN' AND  UPPER(DWO.NAME) = 'ITEM_CODE'  ) THEN

 IF ISVALID(W_ITEM_IMAGE_FLAT) THEN
	RETURN
ELSE
	   OPENWITHPARM(W_ITEM_IMAGE_FLAT , STRING(THIS.OBJECT.ITEM_CODE[ROW]))
END IF 
ELSE

IF isvalid(W_ITEM_IMAGE_FLAT) then
	close(W_ITEM_IMAGE_FLAT)
end if 
END IF
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
//			if UPPER(DWO.TYPE) = 'TEXT' then	
				IF row = 0 THEN 

					if Right(dwo.text , 1) = '^' then
					   dwo.text = mid( dwo.text , 1 , len(string(dwo.text)) - 1 )+'v'
					elseif Right(dwo.text , 1) = 'v' then
					   dwo.text = mid( dwo.text , 1 , len(string(dwo.text)) - 1 )+'^'						
					else
						dwo.text = dwo.text+'v'
					end if
					
					F_QUICK_SORT(THIS , MID(STRING(DWO.NAME),1,LEN(STRING(DWO.NAME)) - 2) )
					this.groupcalc( )
					
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
							
							 F_MSG_MDI_HELP( upper(dwo.name)+' '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".Edit.Style")+' '+LVS_VALUE+' Visible= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".Visible") )		
								
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

selected_data_window = this

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

f_screen_capture()		

IF   sqldbcode = 1 THEN // UNIQUE CHECK

        F_MSGBOX1( 125 , "Row Number="+STRING(Gvl_error_row) )
	 return  1

ELSEIF sqldbcode = 2291 THEN // CONSTRAINTS CHECK PARENT NOT FOUND
	
	LVS_CONSTRAINTS_NAME = MID( sqlerrtext , POS( sqlerrtext , '.' ,1 ) + 1 ,   POS(sqlerrtext , ')' ) - ( POS( sqlerrtext , '.' ,1 )  +1 )  )
	LVS_TABLE_NAME = F_GET_CONSTRAINTS_TABLE_NAME(LVS_CONSTRAINTS_NAME) 
	
	IF ISNULL(LVS_TABLE_NAME) OR LVS_TABLE_NAME = '' THEN 
		LVS_TABLE_NAME = '*'
	END IF
	
	F_MSGBOX2(196, 'SQLCODE='+STRING(SQLCA.SQLCODE)+'  '+LVS_CONSTRAINTS_NAME , LVS_TABLE_NAME )		
	return 1

ELSEIF sqldbcode = 2292 THEN // CONSTRAINTS CHECK CHILD  FOUND CAN`T DELETE
     
    //ORA-02292: integrity constraint
	 
	LVS_CONSTRAINTS_NAME = MID( sqlerrtext , POS( sqlerrtext , '.' ,1 ) + 1 ,   POS(sqlerrtext , ')' ) - ( POS( sqlerrtext , '.' ,1 )  +1 )  )
	LVS_TABLE_NAME = F_GET_CONSTRAINTS_TABLE_NAME(LVS_CONSTRAINTS_NAME) 
	F_MSGBOX2(162, STRING(SQLCA.SQLCODE)+'  '+LVS_CONSTRAINTS_NAME , LVS_TABLE_NAME )		
	return 1
ELSEIF sqldbcode = 1400 THEN // NULL CHECK
	
	//ORA-01400: CANNOT INSERT NULL INTO ()

	LVS_COLUMN_NAME = MID( sqlerrtext , POS( sqlerrtext , '.' ,1 ) + 2 ,   POS(sqlerrtext , ')' ) - POS( sqlerrtext , '.' ,1 ) + 2     )
	LVS_COLUMN_NAME = MID( LVS_COLUMN_NAME , POS( LVS_COLUMN_NAME , '.' ,1 ) + 2 , LEN(LVS_COLUMN_NAME)  -  POS( LVS_COLUMN_NAME , '.' ,1 )  - 6 ) 
	//======================================================================
	// $$HEX8$$eccefcb785ba44c7200000ac38c834c6$$ENDHEX$$
	//======================================================================	
	SELECT NVL(DECODE( :GVS_LANGUAGE , 'K' , WORD_KOR , 'E' , WORD_ENG , WORD_LOCAL ) , :LVS_COLUMN_NAME ) ,
             	      NVL(DECODE( :GVS_LANGUAGE , 'K' , WORD_DESCRIPTION_KOR , 'E' , WORD_DESCRIPTION_ENG , WORD_DESCRIPTION_LOCAL ) , :LVS_COLUMN_NAME )
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
		 F_MSGBOX1(111, LVS_COLUMN_NAME+'~r~n'+SQLERRTEXT)
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


//=========================================================
// Error Log Trace
//=========================================================
if Gvs_error_log_trace_yn = 'Y' then
	f_set_error_log_trace( w_main_frame.Getactivesheet() , 'DW_2' , 0 , ''  , Gvl_DberrorCode , Gvs_DberrorMessage , Gvs_error_syntax ) 
end if 
//=========================================================

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
Long i
string lvs_ret , lvs_vis , lvs_eval 
 IF  UPPER(DWO.TYPE) = 'TEXT' AND  UPPER(DWO.NAME) = 'CHECK_YN_T' THEN

		
	if this.object.check_yn_t.tag  = 'Y' then 	

		open(w_progress_popup)
		w_progress_popup.f_set_range(1 , this.rowcount( ) )
		w_progress_popup.f_setstep(1)
		do
			
			i++
		
				this.object.check_yn[i] = 'N' 
				this.trigger event itemchanged( i , this.object.check_yn , this.object.check_yn[i])
				w_progress_popup.f_stepit()
		loop until i = this.rowcount()
		this.object.check_yn_t.tag  = 'N' 		
		close(w_progress_popup)

		
	else
		
		lvs_eval = string(this.object.check_yn.visible)
		f_get_token(lvs_eval , '~t')
		lvs_eval = Mid( lvs_eval , 1 , Len(lvs_eval) -1 )
		
		open(w_progress_popup)
		w_progress_popup.f_set_range(1 , this.rowcount( ) )
		w_progress_popup.f_setstep(1)		
		do
			i++
				if lvs_eval = '' then
						this.object.check_yn[i] = 'Y' 
						this.trigger event itemchanged( i , this.object.check_yn , this.object.check_yn[i])								
				else
					lvs_ret = this.describe("evaluate(~' "+lvs_eval+"~',"+string(i)+")")
					if lvs_ret = '1' then 
						this.object.check_yn[i] = 'Y' 
						this.trigger event itemchanged( i , this.object.check_yn , this.object.check_yn[i])		
					elseif lvs_ret = '!' then 
						
						Msg = Messagebox("Notify" ,lvs_ret+'  '+ lvs_eval  +" Continue ?", Stopsign! , Yesno!)
						if Msg = 1 then 
						else
							Return
						end if
					end if 
					
				end if
		     	w_progress_popup.f_stepit()
				  
		loop until i = this.rowcount()
		this.object.check_yn_t.tag  = 'Y' 		
		close(w_progress_popup)		
	
	end if
		
END IF

//=======================================================
//
//=======================================================

 IF  UPPER(DWO.TYPE) = 'TEXT' AND  UPPER(DWO.NAME) = 'CONFIRM_STATUS_T' THEN

		
	if this.object.CONFIRM_STATUS_T.tag  = 'Y' then 	
		
		do
			
			i++
			this.object.CONFIRM_STATUS[i] = 'N' 
			this.trigger event itemchanged( i , this.object.CONFIRM_STATUS , this.object.CONFIRM_STATUS[i])
			
		loop until i = this.rowcount()
		
		this.object.CONFIRM_STATUS_T.tag  = 'N' 
		
		
		
	else
		
		do
			i++
			this.object.CONFIRM_STATUS[i] = 'Y' 
			this.trigger event itemchanged( i , this.object.CONFIRM_STATUS , this.object.CONFIRM_STATUS[i])			
		loop until i = this.rowcount()
		
		this.object.CONFIRM_STATUS_T.tag  = 'Y' 
		
	end if
		
END IF
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

//("Data Input Error" , 'Data Invalid Check Data Length or Data Type ( String , Number , Date ...)  =>' + data ) 
RETURN 1
end event

event itemfocuschanged; ls_anydata = dwo
if Gvs_popup_auto_active = 'Y' THEN
	TRIGGER EVENT RBUTTONDOWN( 0 , 0 , ROW , DWO )
end if
end event

event retrieveend;GVS_DB_CANCEL = 'N'
IF ISVALID(W_CANCEL_RETRIEVE_POP) THEN
	CLOSE(W_CANCEL_RETRIEVE_POP)
ELSE
	
END IF

//if Gst_set.window_type = 'REPORT' then 
//	String modstring
//	modstring = 'create bitmap(band=footer x="14" y="20" height="76" width="87" filename="company_logo.bmp" border="0" name=comlogo )'
//	this.Modify( modstring)
//end if

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
	
	IF GVS_DB_CANCEL = 'Y' THEN 
		
		THIS.DBCANCEL()	 
		RETURN 1
	ELSE
		
	END IF


END IF

end event

event retrievestart;if ivs_set_column_dddw2 = 'Y' then 
else
   f_set_column_dddw( dw_2 )
   ivs_set_column_dddw2 = 'Y'	
end if
	
	
	IF ivs_modify_security = 'Y' THEN
		
		IF THIS.MODIFIEDCOUNT() > 0 OR DELETEDCOUNT() > 0 THEN 
			
			Msg = F_MSGBOX1( 9014 , String(THIS.MODIFIEDCOUNT()+THIS.DELETEDCOUNT()))
			
			if Msg = 1 then 	
				
				Gvs_Ue_DATA_control = 'UPDATE'
				Parent.Triggerevent("UE_DATA_CONTROL")
				
			ELSEIF Msg = 2 then 	//NO 
				
				ROLLBACK ;
				RETURN
				
			ELSE // CANCEL
				 RETURN 2
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

IF currentrow = 0  or gvs_deleteselecte_mod = 'Y' THEN RETURN

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

event rbuttondown;String lvs_date , LVS_VALUE

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
		OPENWITHPARM(W_QUICK_FILTER , THIS)	
elseif UPPER(dwo.type) = 'BUTTON' then
		LVS_VALUE = DWO.TEXT
		IF ISNULL(LVS_VALUE) THEN 
		     LVS_VALUE = ' '	
		END IF	
		
elseif UPPER(dwo.type) = 'GROUPBOX' then
		LVS_VALUE = DWO.TEXT
		IF ISNULL(LVS_VALUE) THEN 
		     LVS_VALUE = ' '	
		END IF
		
elseif 	UPPER(dwo.type) = 'DATAWINDOW' then
		LVS_VALUE = THIS.CLASSNAME()
		if Gvi_language_direct_change = 1 then 
			 OPENWITHPARM( W_DUAL_LANGUAGE_POPUP ,  this.title )
		end if 		
		
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
		

	    if   Gst_set.Report_window = True  then
			
			m_main_frame_menu.m_file.m_print.popmenu( w_main_frame.pointerx() , w_main_frame.pointery() ) 					
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
	 string lvs_eval , lvs_ret
			lvs_eval = this.Describe(dwo.name+".Protect")
			lvs_eval = f_replace_string(lvs_eval , "~'" , "~"")
			f_get_token(lvs_eval , '~t')
			lvs_eval = Mid( lvs_eval , 1 , Len(lvs_eval) -1 )
	
			if lvs_eval = '' then
			else
					lvs_ret = this.describe("evaluate(~' "+lvs_eval+"~',"+string(row)+")")
					if lvs_ret = '1' then 
						return
					elseif lvs_ret = '!' then 
						return
					end if
			end if

			  if  this.Describe(dwo.name+".TabSequence") ='0' then
			      if  w_main_frame.menuname = 'm_main_frame_menu' then 
					m_main_frame_menu.m_control.m_rbuttonmenu.popmenu( w_main_frame.pointerx() , w_main_frame.pointery() ) 
				end if 					
				return
			end if
		
			IF  Upper(this.describe( dwo.name+".ColType")) = 'DATE'  OR Upper(this.describe( dwo.name+".ColType")) = 'DATETIME' THEN 

				if dwo.name = 'delivery_date' then 
					OPEN(W_COMPANY_CALENDAR_POPUP )
					if  Message.Stringparm = '' or isnull( Message.Stringparm) then 
					else
						lvs_date = message.stringparm
						dwo.Primary[row] = datetime( date(lvs_date))
						post event itemchanged( row , dwo , lvs_date )					
					end if					
				else
					OPEN(W_CALENDAR_POPUP )
					if  Message.Stringparm = '' or isnull( Message.Stringparm) then 
					else
						lvs_date = message.stringparm
						dwo.Primary[row] = datetime( date(lvs_date))
						post event itemchanged( row , dwo , lvs_date )					
					end if
					
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

event getfocus;SELECTED_DATA_WINDOW = THIS
end event

type dw_1 from datawindow within w_main_root
event ue_accepttext ( )
event ue_entertotab pbm_dwnprocessenter
event ue_dwkey pbm_dwnkey
event uo_mousemove pbm_dwnmousemove
event ue_unmoved pbm_syscommand
event ue_rowfocuschanged ( long currentrow )
integer width = 494
integer height = 380
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
										f_set_zoom(selected_data_window, string( long(Gvs_zoom_size) - 1) )
										
									elseif  key = keyrightarrow! then 
										Gvs_zoom_size = selected_data_window.Describe("Datawindow.Zoom")		
										f_set_zoom(selected_data_window, string(long(Gvs_zoom_size) + 1) )
										
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
						lvs_object_type  = Gst_edit_object.object_type[i]
						
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

event uo_mousemove;// IF  ( UPPER(DWO.TYPE) = 'TEXT' AND  UPPER(DWO.NAME) = 'CHECK_YN_T'  ) THEN
//       THIS.Modify("CHECK_YN_T.Pointer='HAND.ANI'")	 
//END IF
//
// IF   ( UPPER(DWO.TYPE) = 'TEXT' AND  UPPER(DWO.NAME) = 'CONFIRM_STATUS_T'  ) THEN
//       THIS.Modify("CONFIRM_STATUS_T.Pointer='HAND.ANI'")	 
//END IF

if row < 1 then return
IF   ( GVS_SHOW_ITEM_IMAGE = 'Y' OR GVS_SHOW_ITEM_IMAGE = 'A' ) AND ( UPPER(DWO.TYPE) = 'COLUMN' AND  UPPER(DWO.NAME) = 'ITEM_CODE'  ) THEN

		IF ISVALID(W_ITEM_IMAGE_FLAT) THEN
			RETURN
		ELSE
			OPENWITHPARM(W_ITEM_IMAGE_FLAT , STRING(THIS.OBJECT.ITEM_CODE[ROW]))
		END IF 
ELSEIF   ( GVS_SHOW_ITEM_IMAGE = 'P' OR GVS_SHOW_ITEM_IMAGE = 'A' ) AND ( UPPER(DWO.TYPE) = 'COLUMN' AND  UPPER(DWO.NAME) = 'PARTNAME'  ) THEN

		IF ISVALID(W_ITEM_IMAGE_FLAT) THEN
			RETURN
		ELSE
			OPENWITHPARM(W_ITEM_IMAGE_FLAT , STRING(THIS.OBJECT.PARTNAME[ROW]))
		END IF 
		
ELSEIF   ( GVS_SHOW_MOLD_IMAGE = 'Y'  ) AND ( UPPER(DWO.TYPE) = 'COLUMN' AND  UPPER(DWO.NAME) = 'MOLD_CODE'  ) THEN

		IF ISVALID(W_MOLD_IMAGE_FLAT) THEN
			RETURN
		ELSE
			OPENWITHPARM(W_MOLD_IMAGE_FLAT , STRING(THIS.OBJECT.MOLD_CODE[ROW]))
		END IF 		
ELSE

		IF isvalid(W_ITEM_IMAGE_FLAT) then
			close(W_ITEM_IMAGE_FLAT)
		end if 
		
				IF isvalid(W_MOLD_IMAGE_FLAT) then
			close(W_MOLD_IMAGE_FLAT)
		end if 
END IF
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
//			if UPPER(DWO.TYPE) = 'TEXT' then	
				IF row = 0 THEN 

					if Right(dwo.text , 1) = '^' then
					   dwo.text = mid( dwo.text , 1 , len(string(dwo.text)) - 1 )+'v'
					elseif Right(dwo.text , 1) = 'v' then
					   dwo.text = mid( dwo.text , 1 , len(string(dwo.text)) - 1 )+'^'						
					else
						dwo.text = dwo.text+'v'
					end if
					
					F_QUICK_SORT(THIS , MID(STRING(DWO.NAME),1,LEN(STRING(DWO.NAME)) - 2) )
					this.groupcalc( )
					
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
							
							 F_MSG_MDI_HELP( upper(dwo.name)+' '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".Edit.Style")+' '+LVS_VALUE+' Visible= '+SELECTED_DATA_WINDOW.DESCRIBE( upper(dwo.name)+".Visible") )		
								
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

selected_data_window = this

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

f_screen_capture()		

IF   sqldbcode = 1 THEN // UNIQUE CHECK

        F_MSGBOX1( 125 , "Row Number="+STRING(Gvl_error_row) )
	 return  1

ELSEIF sqldbcode = 2291 THEN // CONSTRAINTS CHECK PARENT NOT FOUND
	
	LVS_CONSTRAINTS_NAME = MID( sqlerrtext , POS( sqlerrtext , '.' ,1 ) + 1 ,   POS(sqlerrtext , ')' ) - ( POS( sqlerrtext , '.' ,1 )  +1 )  )
	LVS_TABLE_NAME = F_GET_CONSTRAINTS_TABLE_NAME(LVS_CONSTRAINTS_NAME) 
	
	IF ISNULL(LVS_TABLE_NAME) OR LVS_TABLE_NAME = '' THEN 
		LVS_TABLE_NAME = '*'
	END IF
	
	F_MSGBOX2(196, 'SQLCODE='+STRING(SQLCA.SQLCODE)+'  '+LVS_CONSTRAINTS_NAME , LVS_TABLE_NAME )		
	return 1

ELSEIF sqldbcode = 2292 THEN // CONSTRAINTS CHECK CHILD  FOUND CAN`T DELETE
     
    //ORA-02292: integrity constraint
	 
	LVS_CONSTRAINTS_NAME = MID( sqlerrtext , POS( sqlerrtext , '.' ,1 ) + 1 ,   POS(sqlerrtext , ')' ) - ( POS( sqlerrtext , '.' ,1 )  +1 )  )
	LVS_TABLE_NAME = F_GET_CONSTRAINTS_TABLE_NAME(LVS_CONSTRAINTS_NAME) 
	F_MSGBOX2(162, STRING(SQLCA.SQLCODE)+'  '+LVS_CONSTRAINTS_NAME , LVS_TABLE_NAME )		
	return 1
ELSEIF sqldbcode = 1400 THEN // NULL CHECK
	
	//ORA-01400: CANNOT INSERT NULL INTO ()

	LVS_COLUMN_NAME = MID( sqlerrtext , POS( sqlerrtext , '.' ,1 ) + 2 ,   POS(sqlerrtext , ')' ) - POS( sqlerrtext , '.' ,1 ) + 2     )
	LVS_COLUMN_NAME = MID( LVS_COLUMN_NAME , POS( LVS_COLUMN_NAME , '.' ,1 ) + 2 , LEN(LVS_COLUMN_NAME)  -  POS( LVS_COLUMN_NAME , '.' ,1 )  - 6 ) 
	//======================================================================
	// $$HEX8$$eccefcb785ba44c7200000ac38c834c6$$ENDHEX$$
	//======================================================================	
	SELECT NVL(DECODE( :GVS_LANGUAGE , 'K' , WORD_KOR , 'E' , WORD_ENG , WORD_LOCAL ) , :LVS_COLUMN_NAME ) ,
             	      NVL(DECODE( :GVS_LANGUAGE , 'K' , WORD_DESCRIPTION_KOR , 'E' , WORD_DESCRIPTION_ENG , WORD_DESCRIPTION_LOCAL ) , :LVS_COLUMN_NAME )
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
		 F_MSGBOX1(111, LVS_COLUMN_NAME+'~r~n'+SQLERRTEXT)
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


//=========================================================
// Error Log Trace
//=========================================================
if Gvs_error_log_trace_yn = 'Y' then
	f_set_error_log_trace( w_main_frame.Getactivesheet() , 'DW_1' , 0 , ''  , Gvl_DberrorCode , Gvs_DberrorMessage , Gvs_error_syntax ) 
end if 
//=========================================================

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
Long i
string lvs_ret , lvs_vis , lvs_eval 
 IF  UPPER(DWO.TYPE) = 'TEXT' AND  UPPER(DWO.NAME) = 'CHECK_YN_T' THEN

		
	if this.object.check_yn_t.tag  = 'Y' then 	

		open(w_progress_popup)
		w_progress_popup.f_set_range(1 , this.rowcount( ) )
		w_progress_popup.f_setstep(1)
		do
			
			i++
		
				this.object.check_yn[i] = 'N' 
				this.trigger event itemchanged( i , this.object.check_yn , this.object.check_yn[i])
				w_progress_popup.f_stepit()
		loop until i = this.rowcount()
		this.object.check_yn_t.tag  = 'N' 		
		close(w_progress_popup)

		
	else
		
		lvs_eval = string(this.object.check_yn.visible)
		f_get_token(lvs_eval , '~t')
		lvs_eval = Mid( lvs_eval , 1 , Len(lvs_eval) -1 )
		
		open(w_progress_popup)
		w_progress_popup.f_set_range(1 , this.rowcount( ) )
		w_progress_popup.f_setstep(1)		
		do
			i++
				if lvs_eval = '' then
						this.object.check_yn[i] = 'Y' 
						this.trigger event itemchanged( i , this.object.check_yn , this.object.check_yn[i])								
				else
					lvs_ret = this.describe("evaluate(~' "+lvs_eval+"~',"+string(i)+")")
					if lvs_ret = '1' then 
						this.object.check_yn[i] = 'Y' 
						this.trigger event itemchanged( i , this.object.check_yn , this.object.check_yn[i])		
					elseif lvs_ret = '!' then 
						
						Msg = Messagebox("Notify" ,lvs_ret+'  '+ lvs_eval  +" Continue ?", Stopsign! , Yesno!)
						if Msg = 1 then 
						else
							Return
						end if
					end if 
					
				end if
		     	w_progress_popup.f_stepit()
				  
		loop until i = this.rowcount()
		this.object.check_yn_t.tag  = 'Y' 		
		close(w_progress_popup)		
	
	end if
		
END IF

//=======================================================
//
//=======================================================

 IF  UPPER(DWO.TYPE) = 'TEXT' AND  UPPER(DWO.NAME) = 'CONFIRM_STATUS_T' THEN

		
	if this.object.CONFIRM_STATUS_T.tag  = 'Y' then 	
		
		do
			
			i++
			this.object.CONFIRM_STATUS[i] = 'N' 
			this.trigger event itemchanged( i , this.object.CONFIRM_STATUS , this.object.CONFIRM_STATUS[i])
			
		loop until i = this.rowcount()
		
		this.object.CONFIRM_STATUS_T.tag  = 'N' 
		
		
		
	else
		
		do
			i++
			this.object.CONFIRM_STATUS[i] = 'Y' 
			this.trigger event itemchanged( i , this.object.CONFIRM_STATUS , this.object.CONFIRM_STATUS[i])			
		loop until i = this.rowcount()
		
		this.object.CONFIRM_STATUS_T.tag  = 'Y' 
		
	end if
		
END IF
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

//("Data Input Error" , 'Data Invalid Check Data Length or Data Type ( String , Number , Date ...)  =>' + data ) 
RETURN 1
end event

event itemfocuschanged; ls_anydata = dwo
if Gvs_popup_auto_active = 'Y' THEN
	TRIGGER EVENT RBUTTONDOWN( 0 , 0 , ROW , DWO )
end if
end event

event retrieveend;GVS_DB_CANCEL = 'N'
IF ISVALID(W_CANCEL_RETRIEVE_POP) THEN
	CLOSE(W_CANCEL_RETRIEVE_POP)
ELSE
	
END IF


//if Gst_set.window_type = 'REPORT' then 
//	String modstring
//	modstring = 'create bitmap(band=footer x="14" y="20" height="76" width="87" filename="company_logo.bmp" border="0" name=comlogo )'
//	this.Modify( modstring)
//end if

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
	
	IF GVS_DB_CANCEL = 'Y' THEN 
		
		THIS.DBCANCEL()	 
		RETURN 1
	ELSE
		
	END IF


END IF

end event

event retrievestart;if ivs_set_column_dddw1 = 'Y' then 
else
   f_set_column_dddw( dw_1 )
   ivs_set_column_dddw1 = 'Y'		
end if
	
	
	IF ivs_modify_security = 'Y' THEN
		
		IF THIS.MODIFIEDCOUNT() > 0 OR DELETEDCOUNT() > 0 THEN 
			
			Msg = F_MSGBOX1( 9014 , String(THIS.MODIFIEDCOUNT()+THIS.DELETEDCOUNT()))
			
			if Msg = 1 then 	
				
				Gvs_Ue_DATA_control = 'UPDATE'
				Parent.Triggerevent("UE_DATA_CONTROL")
				
			ELSEIF Msg = 2 then 	//NO 
				
				ROLLBACK ;
				RETURN
				
			ELSE // CANCEL
				 RETURN 2
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
			
		OPENWITHPARM(W_QUICK_FILTER , THIS)
		
elseif UPPER(dwo.type) = 'BUTTON' then
		LVS_VALUE = DWO.TEXT
		IF ISNULL(LVS_VALUE) THEN 
		     LVS_VALUE = ' '	
		END IF
		
		
elseif UPPER(dwo.type) = 'GROUPBOX' then
		LVS_VALUE = DWO.TEXT
		IF ISNULL(LVS_VALUE) THEN 
		     LVS_VALUE = ' '	
		END IF
						
		
elseif 	UPPER(dwo.type) = 'DATAWINDOW' then
		LVS_VALUE = THIS.CLASSNAME()
		
		if Gvi_language_direct_change = 1 then 
			 OPENWITHPARM( W_DUAL_LANGUAGE_POPUP ,  this.title )
		end if 

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
		

	    if   Gst_set.Report_window = True  then
			
			m_main_frame_menu.m_file.m_print.popmenu( w_main_frame.pointerx() , w_main_frame.pointery() ) 					
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
	string  lvs_eval	, lvs_ret


			lvs_eval = this.Describe(dwo.name+".Protect")
			lvs_eval = f_replace_string(lvs_eval , "~'" , "~"")
			f_get_token(lvs_eval , '~t')
			lvs_eval = Mid( lvs_eval , 1 , Len(lvs_eval) -1 )
	
			if lvs_eval = '' then
			else
					lvs_ret = this.describe("evaluate(~' "+lvs_eval+"~',"+string(row)+")")
					if lvs_ret = '1' then 
						return
					elseif lvs_ret = '!' then 
						return
					end if
			end if

			  if  this.Describe(dwo.name+".TabSequence") ='0' then
			      if  w_main_frame.menuname = 'm_main_frame_menu' then 
					m_main_frame_menu.m_control.m_rbuttonmenu.popmenu( w_main_frame.pointerx() , w_main_frame.pointery() ) 
				end if 		
				return
			end if
		
			IF  Upper(this.describe( dwo.name+".ColType")) = 'DATE'  OR Upper(this.describe( dwo.name+".ColType")) = 'DATETIME' THEN 
				
					if dwo.name = 'delivery_date' then 
					OPEN(W_COMPANY_CALENDAR_POPUP )
					if  Message.Stringparm = '' or isnull( Message.Stringparm) then 
					else
						lvs_date = message.stringparm
						dwo.Primary[row] = datetime( date(lvs_date))
						post event itemchanged( row , dwo , lvs_date )					
					end if					
				else
					OPEN(W_CALENDAR_POPUP )
					if  Message.Stringparm = '' or isnull( Message.Stringparm) then 
					else
						lvs_date = message.stringparm
						dwo.Primary[row] = datetime( date(lvs_date))
						post event itemchanged( row , dwo , lvs_date )					
					end if
					
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

event getfocus;SELECTED_DATA_WINDOW = THIS
end event

type uo_tabpages from uo_tabpage within w_main_root
integer y = 3260
integer width = 119
integer height = 88
integer taborder = 20
long backcolor = 12632256
end type

on uo_tabpages.destroy
call uo_tabpage::destroy
end on

