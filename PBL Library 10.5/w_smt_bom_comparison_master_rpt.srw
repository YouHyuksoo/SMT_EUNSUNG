HA$PBExportHeader$w_smt_bom_comparison_master_rpt.srw
$PBExportComments$BOM$$HEX3$$acb9ecd3b8d2$$ENDHEX$$
forward
global type w_smt_bom_comparison_master_rpt from w_main_root
end type
type rb_count from so_radiobutton within w_smt_bom_comparison_master_rpt
end type
type cb_1 from so_commandbutton within w_smt_bom_comparison_master_rpt
end type
type ddlb_line_code from uo_line_code within w_smt_bom_comparison_master_rpt
end type
type st_2 from so_statictext within w_smt_bom_comparison_master_rpt
end type
type dw_6 from datawindow within w_smt_bom_comparison_master_rpt
end type
type rb_1 from so_radiobutton within w_smt_bom_comparison_master_rpt
end type
type rb_all from so_radiobutton within w_smt_bom_comparison_master_rpt
end type
type rb_diff from so_radiobutton within w_smt_bom_comparison_master_rpt
end type
type rb_same from so_radiobutton within w_smt_bom_comparison_master_rpt
end type
type rb_bom_location from so_radiobutton within w_smt_bom_comparison_master_rpt
end type
type ddlb_top_bottom from uo_basecode within w_smt_bom_comparison_master_rpt
end type
type st_3 from so_statictext within w_smt_bom_comparison_master_rpt
end type
type ddlb_model_name from uo_set_model_name_ddlb within w_smt_bom_comparison_master_rpt
end type
type st_7 from so_statictext within w_smt_bom_comparison_master_rpt
end type
type cbx_check_all_type from so_checkbox within w_smt_bom_comparison_master_rpt
end type
type rb_lg_bom_comparision from so_radiobutton within w_smt_bom_comparison_master_rpt
end type
type cb_bom_upload from so_commandbutton within w_smt_bom_comparison_master_rpt
end type
type ddlb_customer_code from uo_customer_code_name within w_smt_bom_comparison_master_rpt
end type
type st_1 from so_statictext within w_smt_bom_comparison_master_rpt
end type
type st_4 from so_statictext within w_smt_bom_comparison_master_rpt
end type
type uo_dateend from uo_ymd_calendar within w_smt_bom_comparison_master_rpt
end type
type gb_1 from groupbox within w_smt_bom_comparison_master_rpt
end type
type gb_2 from groupbox within w_smt_bom_comparison_master_rpt
end type
type gb_3 from groupbox within w_smt_bom_comparison_master_rpt
end type
end forward

global type w_smt_bom_comparison_master_rpt from w_main_root
integer width = 6199
integer height = 2648
string title = "SMT BOM Comparision Report"
windowstate windowstate = maximized!
rb_count rb_count
cb_1 cb_1
ddlb_line_code ddlb_line_code
st_2 st_2
dw_6 dw_6
rb_1 rb_1
rb_all rb_all
rb_diff rb_diff
rb_same rb_same
rb_bom_location rb_bom_location
ddlb_top_bottom ddlb_top_bottom
st_3 st_3
ddlb_model_name ddlb_model_name
st_7 st_7
cbx_check_all_type cbx_check_all_type
rb_lg_bom_comparision rb_lg_bom_comparision
cb_bom_upload cb_bom_upload
ddlb_customer_code ddlb_customer_code
st_1 st_1
st_4 st_4
uo_dateend uo_dateend
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_smt_bom_comparison_master_rpt w_smt_bom_comparison_master_rpt

type variables
string lvsa_model_name[]

end variables

on w_smt_bom_comparison_master_rpt.create
int iCurrent
call super::create
this.rb_count=create rb_count
this.cb_1=create cb_1
this.ddlb_line_code=create ddlb_line_code
this.st_2=create st_2
this.dw_6=create dw_6
this.rb_1=create rb_1
this.rb_all=create rb_all
this.rb_diff=create rb_diff
this.rb_same=create rb_same
this.rb_bom_location=create rb_bom_location
this.ddlb_top_bottom=create ddlb_top_bottom
this.st_3=create st_3
this.ddlb_model_name=create ddlb_model_name
this.st_7=create st_7
this.cbx_check_all_type=create cbx_check_all_type
this.rb_lg_bom_comparision=create rb_lg_bom_comparision
this.cb_bom_upload=create cb_bom_upload
this.ddlb_customer_code=create ddlb_customer_code
this.st_1=create st_1
this.st_4=create st_4
this.uo_dateend=create uo_dateend
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_count
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.ddlb_line_code
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.dw_6
this.Control[iCurrent+6]=this.rb_1
this.Control[iCurrent+7]=this.rb_all
this.Control[iCurrent+8]=this.rb_diff
this.Control[iCurrent+9]=this.rb_same
this.Control[iCurrent+10]=this.rb_bom_location
this.Control[iCurrent+11]=this.ddlb_top_bottom
this.Control[iCurrent+12]=this.st_3
this.Control[iCurrent+13]=this.ddlb_model_name
this.Control[iCurrent+14]=this.st_7
this.Control[iCurrent+15]=this.cbx_check_all_type
this.Control[iCurrent+16]=this.rb_lg_bom_comparision
this.Control[iCurrent+17]=this.cb_bom_upload
this.Control[iCurrent+18]=this.ddlb_customer_code
this.Control[iCurrent+19]=this.st_1
this.Control[iCurrent+20]=this.st_4
this.Control[iCurrent+21]=this.uo_dateend
this.Control[iCurrent+22]=this.gb_1
this.Control[iCurrent+23]=this.gb_2
this.Control[iCurrent+24]=this.gb_3
end on

on w_smt_bom_comparison_master_rpt.destroy
call super::destroy
destroy(this.rb_count)
destroy(this.cb_1)
destroy(this.ddlb_line_code)
destroy(this.st_2)
destroy(this.dw_6)
destroy(this.rb_1)
destroy(this.rb_all)
destroy(this.rb_diff)
destroy(this.rb_same)
destroy(this.rb_bom_location)
destroy(this.ddlb_top_bottom)
destroy(this.st_3)
destroy(this.ddlb_model_name)
destroy(this.st_7)
destroy(this.cbx_check_all_type)
destroy(this.rb_lg_bom_comparision)
destroy(this.cb_bom_upload)
destroy(this.ddlb_customer_code)
destroy(this.st_1)
destroy(this.st_4)
destroy(this.uo_dateend)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event activate;call super::activate;/***************************************
* Window Default Property 
****************************************/
Gst_set.window_id            = this.classname() 
Gst_set.author                  = "JiSheng"
Gst_set.creation_date      = '20051101'
Gst_set.last_modify_date = '20051101'
Gst_set.Report_window    = True  // Report Window  True / Flase

/*****************************************
* Data Window Property
******************************************/
/*****************************************
* Data Window Property
******************************************/
Ivs_resize_type                      = 'MASTER_DETAIL_1L2345R'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


/*****************************************
* Data Window Property
******************************************/
ivs_dw_1_use_focusindicator = 'N' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default

/****************************************
* Menu Property 
*****************************************
* ADMIN  ( All Control )
* MANAGE ( Manager )
* GUEST  ( Only Query )
* QUERY  ( Only Query  )
* DATA_CONTROL  ( Insert Delete Update )
* REPORT ( Report )
****************************************/
F_MENU_CONTROL('REPORT' , True)  // All Data Control





end event

event ue_data_control;call super::ue_data_control;
CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
	
				dw_1.reset() 
				dw_1.retrieve( ddlb_line_code.getcode()+'%' ,  ddlb_model_name.getcode()+'%' , ddlb_top_bottom.getcode( )+'%' ,  ddlb_customer_code.getcode()+'%' , gvi_organization_id, uo_dateend.text() )  
				
	
	CASE ELSE
END CHOOSE
end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

dw_6.settransobject( sqlca)


end event

type dw_5 from w_main_root`dw_5 within w_smt_bom_comparison_master_rpt
integer x = 1170
integer y = 456
integer width = 4507
integer height = 1764
boolean titlebar = true
string dataobject = "d_lg_bom_comparision_rpt2"
end type

type dw_4 from w_main_root`dw_4 within w_smt_bom_comparison_master_rpt
integer x = 1170
integer y = 456
integer width = 4507
integer height = 1764
boolean titlebar = true
string title = "ERP/SMT Comparision"
string dataobject = "d_des_bom_query_4_comparision"
boolean controlmenu = true
end type

type dw_3 from w_main_root`dw_3 within w_smt_bom_comparison_master_rpt
integer x = 1170
integer y = 456
integer width = 4507
integer height = 1764
boolean titlebar = true
string title = "Location"
string dataobject = "d_smt_bom_location_comparision_4_location_rpt"
end type

event dw_3::itemchanged;//OVER
end event

type dw_2 from w_main_root`dw_2 within w_smt_bom_comparison_master_rpt
integer x = 1170
integer y = 456
integer width = 4974
integer height = 1764
integer taborder = 0
boolean titlebar = true
string title = "Count"
string dataobject = "d_smt_bom_location_comparision_4_group_rpt"
end type

type dw_1 from w_main_root`dw_1 within w_smt_bom_comparison_master_rpt
integer y = 456
integer width = 1157
integer height = 1764
integer taborder = 0
boolean titlebar = true
string title = "SMT BOM LIST"
string dataobject = "d_smt_bom_model_list"
end type

event dw_1::itemchanged;// OVER
end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 
dw_6.retrieve( this.object.parent_item_code[currentrow] , gvi_organization_id ) 
end event

type uo_tabpages from w_main_root`uo_tabpages within w_smt_bom_comparison_master_rpt
end type

type rb_count from so_radiobutton within w_smt_bom_comparison_master_rpt
integer x = 96
integer y = 76
integer width = 786
boolean bringtotop = true
string text = "STM Models Comparision (Count)"
boolean checked = true
end type

event clicked;call super::clicked;dw_2.bringtotop = true 
selected_data_window = dw_2

cb_bom_upload.enabled = false
end event

type cb_1 from so_commandbutton within w_smt_bom_comparison_master_rpt
integer x = 1225
integer y = 292
integer height = 128
integer taborder = 20
boolean bringtotop = true
string text = "Comparision"
end type

event clicked;call super::clicked;LONG I  , J  , k , l , m , n
DOUBLE LVDB_SESSION_ID
STRING LVS_SET_ITEM_CODE , lvs_item_code  , LVS_MODEL_NAME , LVS_LINE_CODE
Long ROW 

//==========================================================================
dw_2.reset()
dw_3.reset()
dw_3.setfilter( '')
dw_3.filter( )
rb_all.checked =true 

if rb_lg_bom_comparision.checked = true then 
	    dw_5.retrieve( )
elseIF RB_bom_location.CHecked = TRUE THEN 
	
		IF DW_1.GETROW() < 1 THEN RETURN 

				if rb_bom_location.checked = true then 

						LVS_LINE_CODE           = ddlb_line_code.getcode( )
						LVS_SET_ITEM_CODE   = ddlb_model_name.GETITEM( )
						LVS_MODEL_NAME       =  ddlb_model_name.getcode() 
					    
						LVDB_SESSION_ID       = F_BOM_QUERY_PRC( LVS_SET_ITEM_CODE , F_T_SYSDATE())
				
					IF LVDB_SESSION_ID <= 0 THEN
						ROLLBACK;
						F_MSGBOX1(9051 ,LVS_SET_ITEM_CODE  )        
					ELSE
						DW_4.RETRIEVE( LVDB_SESSION_ID , LVS_LINE_CODE , LVS_MODEL_NAME ,  ddlb_top_bottom.getcode() ,   GVI_ORGANIZATION_ID )
						DW_4.SETFOCUS()
						ROLLBACK ;
					END IF		
				
				end if 
ELSE				
				
	IF DW_1.GETROW() < 1 THEN RETURN 
 	  LVSA_MODEL_NAME[]  = {''}

        DO
            i++
            
            IF DW_1.OBJECT.CHECK_YN[I] = 'Y' THEN 
                j++                
                LVSA_MODEL_NAME[j] =  DW_1.OBJECT.PARENT_ITEM_CODE[i]+DW_1.OBJECT.PCB_ITEM[i]               
            ELSE
                CONTINUE 
            END IF 
            
            
        LOOP UNTIL i= DW_1.ROWCOUNT( )
     
			m = upperbound(LVSA_MODEL_NAME[])
			if m < 2 then 
				f_msg("$$HEX16$$a8ba78b344c7200050b41cac200074c7c1c0200020c1ddd0200058d538c194c6$$ENDHEX$$" , "P" ) 
				return 
			end if 
			
			if rb_count.checked = true then 
				
				DW_2.RETRIEVE( DDLB_LINE_CODE.GETCODE()+'%'  ,LVSA_MODEL_NAME ,   GVI_ORGANIZATION_ID )
								
								setpointer( hourglass!)
								DO
										k++
										
										n = 0
										DO
											n++
											
											if n = 1 then 
												lvs_item_code = string(dw_2.getitemnumber( k ,'location_code'  ))
												if isnull(lvs_item_code) then 
													
													if cbx_check_all_type.checked = true then 
														dw_2.object.check_diff_yn[k] = 'Y' 											 
													end if 		
													continue
													
												else
													exit
												end if 
												
											else
												
													lvs_item_code = string(dw_2.getitemnumber( k , 'location_code_'+string(n -1)))
													if isnull(lvs_item_code) then 
														
														if cbx_check_all_type.checked = true then 
															dw_2.object.check_diff_yn[k] = 'Y' 
														
														end if 		
													
														continue
													else
														exit
													end if 
												
											end if 
											
										LOOP UNTIL 1= 2
									
									
										L = 0
										do
											L++
											
											if lvs_item_code =  string(dw_2.getitemnumber( k , 'location_code_'+string(L))) then 
												continue
											elseif  isnull(string(dw_2.getitemnumber( k , 'location_code_'+string(L))) )  then 
												
													if cbx_check_all_type.checked = true then 
														dw_2.object.check_diff_yn[k] = 'Y' 
													else
														continue 
													end if 
										elseif  isnull(lvs_item_code)  then 
												
													if cbx_check_all_type.checked = true then 
														dw_2.object.check_diff_yn[k] = 'Y' 
													else
														continue 
													end if 		
												
											else
												dw_2.object.check_diff_yn[k] = 'Y' 
											end if 
											
											
										loop until  L= m -1
										
								
								LOOP UNTIL k= dw_2.ROWcount( )
							
								setpointer( arrow!)				
				
			else
							
								DW_3.RETRIEVE( DDLB_LINE_CODE.GETCODE()+'%'  ,LVSA_MODEL_NAME , GVI_ORGANIZATION_ID )		
								
								setpointer( hourglass!)
								DO
										k++
										
										n = 0
										DO
											n++
											
											if n = 1 then 
												lvs_item_code = dw_3.getitemstring( k ,'child_item_code'  )
												if isnull(lvs_item_code) then 
													
													if cbx_check_all_type.checked = true then 
														dw_3.object.check_diff[k] = 'Y' 
																										 
													end if 		
													continue
													
												else
													exit
												end if 
												
											else
												
													lvs_item_code = dw_3.getitemstring( k , 'child_item_code_'+string(n -1))
													if isnull(lvs_item_code) then 
														
														if cbx_check_all_type.checked = true then 
															dw_3.object.check_diff[k] = 'Y' 
														
														end if 		
													
														continue
													else
														exit
													end if 
												
											end if 
											
										LOOP UNTIL 1= 2
									
										
										L = 0
										do
											L++
											
											if lvs_item_code =  dw_3.getitemstring( k , 'child_item_code_'+string(L)) then 
												continue
											elseif  isnull(dw_3.getitemstring( k , 'child_item_code_'+string(L)) )  then 
												
													if cbx_check_all_type.checked = true then 
														dw_3.object.check_diff[k] = 'Y' 
													else
														continue 
													end if 
										elseif  isnull(lvs_item_code)  then 
												
													if cbx_check_all_type.checked = true then 
														dw_3.object.check_diff[k] = 'Y' 
													else
														continue 
													end if 		
												
											else
												dw_3.object.check_diff[k] = 'Y' 
											end if 
											
											
										loop until  L= m -1
										
								
								LOOP UNTIL k= DW_3.ROWcount( )
							
								setpointer( arrow!)
			end if 
	
END IF 	
	
	
end event

type ddlb_line_code from uo_line_code within w_smt_bom_comparison_master_rpt
integer x = 1979
integer y = 140
integer width = 471
integer height = 1664
integer taborder = 30
boolean bringtotop = true
end type

type st_2 from so_statictext within w_smt_bom_comparison_master_rpt
integer x = 1984
integer y = 64
integer width = 471
integer height = 72
boolean bringtotop = true
boolean enabled = false
string text = "Line Code"
end type

type dw_6 from datawindow within w_smt_bom_comparison_master_rpt
integer x = 4558
integer width = 1591
integer height = 440
integer taborder = 100
boolean bringtotop = true
boolean titlebar = true
string title = "Model"
string dataobject = "d_des_item_4_plan_smt_modify_lst"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

type rb_1 from so_radiobutton within w_smt_bom_comparison_master_rpt
integer x = 96
integer y = 156
integer width = 837
boolean bringtotop = true
string text = "STM Models Comparision (Location)"
end type

event clicked;call super::clicked;dw_3.bringtotop = true 
selected_data_window = dw_3

cb_bom_upload.enabled = false
end event

type rb_all from so_radiobutton within w_smt_bom_comparison_master_rpt
integer x = 4023
integer y = 92
boolean bringtotop = true
string text = "All"
boolean checked = true
end type

event clicked;call super::clicked;if rb_count.checked = true then 
	dw_2.setfilter( '')
dw_2.filter( )
else
dw_3.setfilter( '')
dw_3.filter( )
end if 
end event

type rb_diff from so_radiobutton within w_smt_bom_comparison_master_rpt
integer x = 4023
integer y = 212
boolean bringtotop = true
string text = "Diffent"
end type

event clicked;call super::clicked;if rb_count.checked = true then 
	dw_2.setfilter( "check_diff_yn= 'Y'")
	dw_2.filter( )
else
	dw_3.setfilter( "check_diff = 'Y'")
	dw_3.filter( )
end if 
end event

type rb_same from so_radiobutton within w_smt_bom_comparison_master_rpt
integer x = 4023
integer y = 336
boolean bringtotop = true
string text = "Same"
end type

event clicked;call super::clicked;if rb_count.checked = true then 
dw_2.setfilter( "check_diff_yn = 'N'")
dw_2.filter( )
else
dw_3.setfilter( "check_diff = 'N'")
dw_3.filter( )
end if 


end event

type rb_bom_location from so_radiobutton within w_smt_bom_comparison_master_rpt
integer x = 96
integer y = 236
integer width = 878
boolean bringtotop = true
string text = "BOM/SMT Location Comparision"
end type

event clicked;call super::clicked;dw_4.bringtotop = true
selected_data_window = dw_4

cb_bom_upload.enabled = false


end event

type ddlb_top_bottom from uo_basecode within w_smt_bom_comparison_master_rpt
integer x = 3141
integer y = 140
integer width = 329
integer height = 1664
integer taborder = 100
boolean bringtotop = true
integer weight = 400
boolean allowedit = true
integer limit = 10
end type

event constructor;call super::constructor;this.redraw( 'TOP BOTTOM')
end event

type st_3 from so_statictext within w_smt_bom_comparison_master_rpt
integer x = 3159
integer y = 64
integer width = 274
integer height = 72
boolean bringtotop = true
boolean enabled = false
string text = "Top/Bottom"
end type

type ddlb_model_name from uo_set_model_name_ddlb within w_smt_bom_comparison_master_rpt
integer x = 2459
integer y = 140
integer width = 677
integer height = 1664
integer taborder = 80
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
boolean autohscroll = true
end type

event selectionchanged;call super::selectionchanged;dw_6.retrieve( this.getcode() , gvi_organization_id )
end event

type st_7 from so_statictext within w_smt_bom_comparison_master_rpt
integer x = 2459
integer y = 64
integer width = 677
integer height = 72
boolean bringtotop = true
boolean enabled = false
string text = "Model Name"
end type

type cbx_check_all_type from so_checkbox within w_smt_bom_comparison_master_rpt
integer x = 1774
integer y = 312
boolean bringtotop = true
string text = "Check All Type"
boolean checked = true
end type

type rb_lg_bom_comparision from so_radiobutton within w_smt_bom_comparison_master_rpt
integer x = 96
integer y = 316
integer width = 878
boolean bringtotop = true
string text = "LG BOM Comparision"
end type

event clicked;call super::clicked;dw_5.bringtotop  = true 
cb_bom_upload.enabled = true 
end event

type cb_bom_upload from so_commandbutton within w_smt_bom_comparison_master_rpt
integer x = 2222
integer y = 296
integer height = 128
integer taborder = 30
boolean bringtotop = true
boolean enabled = false
string text = "BOM Upload"
end type

event clicked;call super::clicked;open( w_des_bom_excel_form_lg_4_compare_popup) 
end event

type ddlb_customer_code from uo_customer_code_name within w_smt_bom_comparison_master_rpt
integer x = 1216
integer y = 140
integer width = 754
integer height = 1664
integer taborder = 110
boolean bringtotop = true
end type

type st_1 from so_statictext within w_smt_bom_comparison_master_rpt
integer x = 1216
integer y = 68
integer width = 754
integer height = 72
boolean bringtotop = true
boolean enabled = false
string text = "Cutomer Code"
end type

type st_4 from so_statictext within w_smt_bom_comparison_master_rpt
integer x = 3525
integer y = 64
integer width = 338
integer height = 72
boolean bringtotop = true
boolean enabled = false
string text = "Model DateEnd"
end type

type uo_dateend from uo_ymd_calendar within w_smt_bom_comparison_master_rpt
event destroy ( )
integer x = 3479
integer y = 140
integer height = 88
integer taborder = 40
boolean bringtotop = true
long backcolor = 12632256
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type gb_1 from groupbox within w_smt_bom_comparison_master_rpt
integer width = 1157
integer height = 436
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Category"
end type

type gb_2 from groupbox within w_smt_bom_comparison_master_rpt
integer x = 3968
integer width = 581
integer height = 448
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Show Filter"
end type

type gb_3 from groupbox within w_smt_bom_comparison_master_rpt
integer x = 1170
integer width = 2770
integer height = 276
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Where Condition"
end type

