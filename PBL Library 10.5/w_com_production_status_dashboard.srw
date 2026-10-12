HA$PBExportHeader$w_com_production_status_dashboard.srw
$PBExportComments$$$HEX6$$80bd88d42000c8b9a4c230d1$$ENDHEX$$
forward
global type w_com_production_status_dashboard from w_main_root
end type
type tab_item from tab within w_com_production_status_dashboard
end type
type tabpage_pickup from userobject within tab_item
end type
type dw_tab_10 from so_datawindow within tabpage_pickup
end type
type tabpage_pickup from userobject within tab_item
dw_tab_10 dw_tab_10
end type
type tabpage_solder from userobject within tab_item
end type
type dw_tab_1 from so_datawindow within tabpage_solder
end type
type tabpage_solder from userobject within tab_item
dw_tab_1 dw_tab_1
end type
type tabpage_mask from userobject within tab_item
end type
type dw_tab_2 from so_datawindow within tabpage_mask
end type
type tabpage_mask from userobject within tab_item
dw_tab_2 dw_tab_2
end type
type tabpage_squeeze from userobject within tab_item
end type
type dw_tab_3 from so_datawindow within tabpage_squeeze
end type
type tabpage_squeeze from userobject within tab_item
dw_tab_3 dw_tab_3
end type
type tabpage_tracking from userobject within tab_item
end type
type dw_tab_4 from so_datawindow within tabpage_tracking
end type
type tabpage_tracking from userobject within tab_item
dw_tab_4 dw_tab_4
end type
type tabpage_msl from userobject within tab_item
end type
type dw_tab_5 from so_datawindow within tabpage_msl
end type
type tabpage_msl from userobject within tab_item
dw_tab_5 dw_tab_5
end type
type tabpage_pcb from userobject within tab_item
end type
type dw_tab_6 from so_datawindow within tabpage_pcb
end type
type tabpage_pcb from userobject within tab_item
dw_tab_6 dw_tab_6
end type
type tabpage_sample from userobject within tab_item
end type
type dw_tab_7 from so_datawindow within tabpage_sample
end type
type tabpage_sample from userobject within tab_item
dw_tab_7 dw_tab_7
end type
type tabpage_reel from userobject within tab_item
end type
type dw_tab_8 from so_datawindow within tabpage_reel
end type
type tabpage_reel from userobject within tab_item
dw_tab_8 dw_tab_8
end type
type tabpage_nsnp from userobject within tab_item
end type
type dw_tab_9 from so_datawindow within tabpage_nsnp
end type
type tabpage_nsnp from userobject within tab_item
dw_tab_9 dw_tab_9
end type
type tab_item from tab within w_com_production_status_dashboard
tabpage_pickup tabpage_pickup
tabpage_solder tabpage_solder
tabpage_mask tabpage_mask
tabpage_squeeze tabpage_squeeze
tabpage_tracking tabpage_tracking
tabpage_msl tabpage_msl
tabpage_pcb tabpage_pcb
tabpage_sample tabpage_sample
tabpage_reel tabpage_reel
tabpage_nsnp tabpage_nsnp
end type
type st_3 from so_statictext within w_com_production_status_dashboard
end type
type em_interval from so_editmask within w_com_production_status_dashboard
end type
type cb_1 from so_commandbutton within w_com_production_status_dashboard
end type
type cb_2 from so_commandbutton within w_com_production_status_dashboard
end type
type ddlb_line_code from uo_line_code_dd within w_com_production_status_dashboard
end type
type st_11 from so_statictext within w_com_production_status_dashboard
end type
type cb_3 from so_commandbutton within w_com_production_status_dashboard
end type
type cb_4 from so_commandbutton within w_com_production_status_dashboard
end type
type cbx_auto_detail from so_checkbox within w_com_production_status_dashboard
end type
type cb_5 from so_commandbutton within w_com_production_status_dashboard
end type
end forward

global type w_com_production_status_dashboard from w_main_root
integer width = 5440
integer height = 3024
string title = "Dashboard"
string ivs_dw_1_use_focusindicator = "N"
string ivs_dw_1_selected_row_yn = "N"
tab_item tab_item
st_3 st_3
em_interval em_interval
cb_1 cb_1
cb_2 cb_2
ddlb_line_code ddlb_line_code
st_11 st_11
cb_3 cb_3
cb_4 cb_4
cbx_auto_detail cbx_auto_detail
cb_5 cb_5
end type
global w_com_production_status_dashboard w_com_production_status_dashboard

type variables
string IVS_LINE_CODE
end variables

on w_com_production_status_dashboard.create
int iCurrent
call super::create
this.tab_item=create tab_item
this.st_3=create st_3
this.em_interval=create em_interval
this.cb_1=create cb_1
this.cb_2=create cb_2
this.ddlb_line_code=create ddlb_line_code
this.st_11=create st_11
this.cb_3=create cb_3
this.cb_4=create cb_4
this.cbx_auto_detail=create cbx_auto_detail
this.cb_5=create cb_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_item
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.em_interval
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.cb_2
this.Control[iCurrent+6]=this.ddlb_line_code
this.Control[iCurrent+7]=this.st_11
this.Control[iCurrent+8]=this.cb_3
this.Control[iCurrent+9]=this.cb_4
this.Control[iCurrent+10]=this.cbx_auto_detail
this.Control[iCurrent+11]=this.cb_5
end on

on w_com_production_status_dashboard.destroy
call super::destroy
destroy(this.tab_item)
destroy(this.st_3)
destroy(this.em_interval)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.ddlb_line_code)
destroy(this.st_11)
destroy(this.cb_3)
destroy(this.cb_4)
destroy(this.cbx_auto_detail)
destroy(this.cb_5)
end on

event activate;call super::activate;/***************************************
* $$HEX17$$08c7c4b324c115c8d0c5200000ad5cd52000acc06dd544c720004bc105d35cd5e4b2$$ENDHEX$$
*
*
****************************************/
Gst_set.window_id            = this.classname() 
Gst_set.author                  = "JiSheng"
Gst_set.creation_date      = '20051101'
Gst_set.last_modify_date = '20051101'
Gst_set.Report_window    = False  // Report Window  True / Flase

/*****************************************
* Data WIndow Property
******************************************/
Ivs_resize_type    = 'MASTER_DETAIL_TAB'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default

/****************************************
* Menu Property $$HEX6$$54ba74b2200078d5e4b4c1b9$$ENDHEX$$
*****************************************
* ADMIN     : ADMIN  ( $$HEX5$$04c8b4ccacc0a9c62000$$ENDHEX$$)
* $$HEX8$$00adacb9200020002000200020002000$$ENDHEX$$: MANAGE ( $$HEX8$$04c854ba74b2acc0a9c600aca5b22000$$ENDHEX$$)
* $$HEX7$$acc0a9c690c72000200020002000$$ENDHEX$$: GUEST  ( $$HEX11$$30ae08cd2000f1b45db8200070c88cd6200000aca5b2$$ENDHEX$$)
* $$HEX8$$70c88cd6200020002000200020002000$$ENDHEX$$: QUERY  ( $$HEX10$$15c8f4bc70c88cd6ccb9200000aca5b220002000$$ENDHEX$$)
* $$HEX5$$70b374c7c0d070c891c7$$ENDHEX$$: DATA_CONTROL  ( $$HEX12$$85c725b8200018c215c82000adc01cc8200024c115c82000$$ENDHEX$$)
* $$HEX7$$08b8ecd3b8d22000200020002000$$ENDHEX$$: REPORT ( $$HEX4$$08b8ecd3b8d22000$$ENDHEX$$, $$HEX5$$9ccd25b800adacb92000$$ENDHEX$$)
****************************************/

F_MENU_CONTROL('DATA_CONTROL' , TRUE)  // All Data Control

/****************************************
* 
****************************************/

end event

event ue_data_control;call super::ue_data_control;CHOOSE CASE Gvs_Ue_data_control
		
	CASE 'RETRIEVE'
		
		         DW_1.RESET()
				DW_1.RETRIEVE( ddlb_line_code.getcode()  )
				
				tab_item.tabpage_pickup.dw_tab_10.retrieve( dw_1.object.line_code[dw_1.getrow()] )
				
				if cbx_auto_detail.checked = true then 
				
				
						if dw_1.getrow() = 0 then return
						
						if isnull(dw_1.object.running_run_no[dw_1.getrow()] ) or isnull(dw_1.object.model_name[dw_1.getrow()] ) then 
						return 
						else
						
						tab_item.tabpage_solder.dw_tab_1.retrieve( dw_1.object.solder_lot_no[dw_1.getrow()] )
						tab_item.tabpage_mask.dw_tab_2.retrieve( dw_1.object.mask_lot_no[dw_1.getrow()] )
						tab_item.tabpage_squeeze.dw_tab_3.retrieve( dw_1.object.squeeze_lot_no[dw_1.getrow()]  , dw_1.object.squeeze_lot_no2[dw_1.getrow()])
						tab_item.tabpage_tracking.dw_tab_4.retrieve( dw_1.object.running_run_no[dw_1.getrow()]  , gvi_organization_id )
						tab_item.tabpage_msl.dw_tab_5.retrieve( dw_1.object.line_code[dw_1.getrow()] ,'%' , 0 , '2' )
						tab_item.tabpage_pcb.dw_tab_6.retrieve( dw_1.object.running_run_no[dw_1.getrow()]  )
						tab_item.tabpage_sample.dw_tab_7.retrieve( dw_1.object.running_run_no[dw_1.getrow()]  )
						tab_item.tabpage_reel.dw_tab_8.retrieve( dw_1.object.running_run_no[dw_1.getrow()]  )
						tab_item.tabpage_nsnp.dw_tab_9.retrieve( dw_1.object.running_run_no[dw_1.getrow()]  )

						dw_1.setfocus( )
						
						end if 
					
				end if 
				
				DW_1.SETFOCUS()
				
				
		
	CASE ELSE
END CHOOSE


end event

event ue_post_open;call super::ue_post_open;IF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL_TAB' THEN //12345_TAB
	
	dw_1.resize(width - dw_1.x -34, height - ( dw_1.y + tab_item.height +120 ))
	dw_2.resize(width - dw_2.x -34, height - ( dw_2.y + tab_item.height +120 ))	
	dw_3.resize(width - dw_3.x -34, height - ( dw_3.y + tab_item.height +120))	
	dw_4.resize(width - dw_4.x -34, height - ( dw_4.y + tab_item.height +120))		
	dw_5.resize(width - dw_5.x -34, height - ( dw_5.y + tab_item.height +120))	

	tab_item.y = dw_1.y + dw_1.HEIGHT 
	tab_item.resize(width  - tab_item.x , tab_item.height )		
     
	tab_item.tabpage_solder.dw_tab_1.width = 	  width  - tab_item.x +300
	tab_item.tabpage_mask.dw_tab_2.width = 	  width  - tab_item.x +300
	tab_item.tabpage_squeeze.dw_tab_3.width = 	  width  - tab_item.x +300
	tab_item.tabpage_tracking.dw_tab_4.width =  width  - tab_item.x +300
	tab_item.tabpage_msl.dw_tab_5.width =  width  - tab_item.x +300
	tab_item.tabpage_pcb.dw_tab_6.width =  width  - tab_item.x +300
	tab_item.tabpage_sample.dw_tab_7.width =  width  - tab_item.x +300
	tab_item.tabpage_reel.dw_tab_8.width =  width  - tab_item.x +300
	tab_item.tabpage_nsnp.dw_tab_9.width =  width  - tab_item.x +300
	tab_item.tabpage_pickup.dw_tab_10.width =  width  - tab_item.x +300
	
END IF	  
	  

/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

F_RETRIEVE()
end event

event resize;call super::resize;IF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL_TAB' THEN //12345_TAB
	
	dw_1.resize(newwidth  - dw_1.x , newheight - ( dw_1.y + tab_item.height ))
	dw_2.resize(newwidth  - dw_2.x , newheight - ( dw_2.y + tab_item.height ))		
	dw_3.resize(newwidth  - dw_3.x , newheight - ( dw_3.y + tab_item.height ))	
	dw_4.resize(newwidth  - dw_4.x , newheight - ( dw_4.y + tab_item.height ))	
	dw_5.resize(newwidth  - dw_5.x , newheight - ( dw_5.y + tab_item.height ))	
	tab_item.y = dw_1.y + dw_1.HEIGHT 
	tab_item.resize(newwidth  - tab_item.x , tab_item.height )			
	
	
	tab_item.tabpage_solder.dw_tab_1.width = 	  newwidth  - tab_item.x +300
	tab_item.tabpage_mask.dw_tab_2.width = 	  newwidth  - tab_item.x +300
	tab_item.tabpage_squeeze.dw_tab_3.width = 	  newwidth  - tab_item.x +300
	tab_item.tabpage_tracking.dw_tab_4.width = 	  newwidth  - tab_item.x +300
	
	tab_item.tabpage_msl.dw_tab_5.width = 	  newwidth  - tab_item.x +300
	tab_item.tabpage_pcb.dw_tab_6.width= 	  newwidth  - tab_item.x +300
	tab_item.tabpage_sample.dw_tab_7.width= 	  newwidth  - tab_item.x +300
	tab_item.tabpage_reel.dw_tab_8.width= 	  newwidth  - tab_item.x +300
	tab_item.tabpage_nsnp.dw_tab_9.width= 	  newwidth  - tab_item.x +300
	
	
	END IF	  
end event

event open;call super::open;//========================================
// Set Transaction
//========================================
tab_item.tabpage_solder.dw_tab_1.settransobject( sqlca)
tab_item.tabpage_mask.dw_tab_2.settransobject( sqlca)
tab_item.tabpage_squeeze.dw_tab_3.settransobject( sqlca)
tab_item.tabpage_tracking.dw_tab_4.settransobject( sqlca)
tab_item.tabpage_msl.dw_tab_5.settransobject( sqlca)
tab_item.tabpage_pcb.dw_tab_6.settransobject( sqlca)
tab_item.tabpage_sample.dw_tab_7.settransobject( sqlca)
tab_item.tabpage_reel.dw_tab_8.settransobject( sqlca)
tab_item.tabpage_nsnp.dw_tab_9.settransobject( sqlca)
tab_item.tabpage_pickup.dw_tab_10.settransobject( sqlca)

//========================================
// dddw Init
//========================================
f_set_column_dddw(tab_item.tabpage_solder.dw_tab_1)
f_set_column_dddw( tab_item.tabpage_mask.dw_tab_2)
f_set_column_dddw( tab_item.tabpage_squeeze.dw_tab_3 )
f_set_column_dddw( tab_item.tabpage_tracking.dw_tab_4 )
f_set_column_dddw( tab_item.tabpage_msl.dw_tab_5 )
f_set_column_dddw( tab_item.tabpage_pcb.dw_tab_6 )
f_set_column_dddw( tab_item.tabpage_sample.dw_tab_7 )
f_set_column_dddw( tab_item.tabpage_reel.dw_tab_8 )
f_set_column_dddw( tab_item.tabpage_nsnp.dw_tab_9 )
f_set_column_dddw( tab_item.tabpage_pickup.dw_tab_10 )

//========================================
// Share Data
//========================================

//tab_item.tabpage_5.dw_6.sharedata( tab_item.tabpage_6.dw_7 )


end event

event timer;call super::timer;f_retrieve()
end event

type dw_5 from w_main_root`dw_5 within w_com_production_status_dashboard
integer y = 212
integer height = 396
end type

type dw_4 from w_main_root`dw_4 within w_com_production_status_dashboard
integer y = 212
integer height = 396
integer taborder = 20
end type

type dw_3 from w_main_root`dw_3 within w_com_production_status_dashboard
integer y = 212
integer height = 396
integer taborder = 120
end type

type dw_2 from w_main_root`dw_2 within w_com_production_status_dashboard
integer y = 212
integer height = 396
integer taborder = 0
end type

type dw_1 from w_main_root`dw_1 within w_com_production_status_dashboard
integer y = 120
integer width = 4146
integer height = 1532
integer taborder = 100
string dataobject = "d_display_machine_foolproof_status_check_items"
borderstyle borderstyle = styleraised!
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;//if currentrow = 0 then return
//
//if isnull(dw_1.object.running_run_no[currentrow] ) or isnull(dw_1.object.model_name[currentrow] ) then 
//	return 
//else
//
//tab_item.tabpage_solder.dw_tab_1.retrieve( dw_1.object.solder_lot_no[currentrow] )
//tab_item.tabpage_mask.dw_tab_2.retrieve( dw_1.object.mask_lot_no[currentrow] )
//tab_item.tabpage_squeeze.dw_tab_3.retrieve( dw_1.object.squeeze_lot_no[currentrow]  , dw_1.object.squeeze_lot_no2[currentrow])
//tab_item.tabpage_tracking.dw_tab_4.retrieve( dw_1.object.running_run_no[currentrow]  , gvi_organization_id )
//tab_item.tabpage_msl.dw_tab_5.retrieve( dw_1.object.line_code[currentrow] ,'%' , 0 , '2' )
//tab_item.tabpage_pcb.dw_tab_6.retrieve( dw_1.object.running_run_no[currentrow]  )
//tab_item.tabpage_sample.dw_tab_7.retrieve( dw_1.object.running_run_no[currentrow]  )
//tab_item.tabpage_reel.dw_tab_8.retrieve( dw_1.object.running_run_no[currentrow]  )
//tab_item.tabpage_nsnp.dw_tab_9.retrieve( dw_1.object.running_run_no[currentrow]  )
//dw_1.setfocus( )
//
//end if 
end event

event dw_1::doubleclicked;call super::doubleclicked;if row = 0 then return

if isnull(dw_1.object.running_run_no[row] ) or isnull(dw_1.object.model_name[row] ) then 
	return 
else

tab_item.tabpage_solder.dw_tab_1.retrieve( dw_1.object.solder_lot_no[row] )
tab_item.tabpage_mask.dw_tab_2.retrieve( dw_1.object.mask_lot_no[row] )
tab_item.tabpage_squeeze.dw_tab_3.retrieve( dw_1.object.squeeze_lot_no[row]  , dw_1.object.squeeze_lot_no2[row])
tab_item.tabpage_tracking.dw_tab_4.retrieve( dw_1.object.running_run_no[row]  , gvi_organization_id )
tab_item.tabpage_msl.dw_tab_5.retrieve( dw_1.object.line_code[row] ,'%' , 0 , '2' )
tab_item.tabpage_pcb.dw_tab_6.retrieve( dw_1.object.running_run_no[row]  )
tab_item.tabpage_sample.dw_tab_7.retrieve( dw_1.object.running_run_no[row]  )
tab_item.tabpage_reel.dw_tab_8.retrieve( dw_1.object.running_run_no[row]  )
tab_item.tabpage_nsnp.dw_tab_9.retrieve( dw_1.object.running_run_no[row]  )
dw_1.setfocus( )

end if 
end event

type uo_tabpages from w_main_root`uo_tabpages within w_com_production_status_dashboard
end type

type tab_item from tab within w_com_production_status_dashboard
integer y = 1660
integer width = 5079
integer height = 928
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean fixedwidth = true
boolean raggedright = true
boolean focusonbuttondown = true
boolean powertips = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_pickup tabpage_pickup
tabpage_solder tabpage_solder
tabpage_mask tabpage_mask
tabpage_squeeze tabpage_squeeze
tabpage_tracking tabpage_tracking
tabpage_msl tabpage_msl
tabpage_pcb tabpage_pcb
tabpage_sample tabpage_sample
tabpage_reel tabpage_reel
tabpage_nsnp tabpage_nsnp
end type

on tab_item.create
this.tabpage_pickup=create tabpage_pickup
this.tabpage_solder=create tabpage_solder
this.tabpage_mask=create tabpage_mask
this.tabpage_squeeze=create tabpage_squeeze
this.tabpage_tracking=create tabpage_tracking
this.tabpage_msl=create tabpage_msl
this.tabpage_pcb=create tabpage_pcb
this.tabpage_sample=create tabpage_sample
this.tabpage_reel=create tabpage_reel
this.tabpage_nsnp=create tabpage_nsnp
this.Control[]={this.tabpage_pickup,&
this.tabpage_solder,&
this.tabpage_mask,&
this.tabpage_squeeze,&
this.tabpage_tracking,&
this.tabpage_msl,&
this.tabpage_pcb,&
this.tabpage_sample,&
this.tabpage_reel,&
this.tabpage_nsnp}
end on

on tab_item.destroy
destroy(this.tabpage_pickup)
destroy(this.tabpage_solder)
destroy(this.tabpage_mask)
destroy(this.tabpage_squeeze)
destroy(this.tabpage_tracking)
destroy(this.tabpage_msl)
destroy(this.tabpage_pcb)
destroy(this.tabpage_sample)
destroy(this.tabpage_reel)
destroy(this.tabpage_nsnp)
end on

type tabpage_pickup from userobject within tab_item
integer x = 18
integer y = 112
integer width = 5042
integer height = 800
long backcolor = 12632256
string text = "Pickup rate (BASE)"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
long picturemaskcolor = 536870912
dw_tab_10 dw_tab_10
end type

on tabpage_pickup.create
this.dw_tab_10=create dw_tab_10
this.Control[]={this.dw_tab_10}
end on

on tabpage_pickup.destroy
destroy(this.dw_tab_10)
end on

type dw_tab_10 from so_datawindow within tabpage_pickup
integer y = 20
integer width = 5024
integer height = 776
integer taborder = 120
string dataobject = "d_display_smt_pickup_rate_lst2_base"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type tabpage_solder from userobject within tab_item
integer x = 18
integer y = 112
integer width = 5042
integer height = 800
long backcolor = 12632256
string text = "Solder"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "EditDataTabular!"
long picturemaskcolor = 536870912
dw_tab_1 dw_tab_1
end type

on tabpage_solder.create
this.dw_tab_1=create dw_tab_1
this.Control[]={this.dw_tab_1}
end on

on tabpage_solder.destroy
destroy(this.dw_tab_1)
end on

type dw_tab_1 from so_datawindow within tabpage_solder
integer y = 4
integer width = 4105
integer height = 784
integer taborder = 20
string title = ""
string dataobject = "d_mat_solder_receipt_issue_lst_4_dashboard"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

type tabpage_mask from userobject within tab_item
integer x = 18
integer y = 112
integer width = 5042
integer height = 800
long backcolor = 12632256
string text = "Mask Check"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "CreateTable5!"
long picturemaskcolor = 12632256
dw_tab_2 dw_tab_2
end type

on tabpage_mask.create
this.dw_tab_2=create dw_tab_2
this.Control[]={this.dw_tab_2}
end on

on tabpage_mask.destroy
destroy(this.dw_tab_2)
end on

type dw_tab_2 from so_datawindow within tabpage_mask
integer y = 16
integer width = 4110
integer height = 764
integer taborder = 30
string dataobject = "d_mcn_jig_mask_check_lst_4_dashboard"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

type tabpage_squeeze from userobject within tab_item
integer x = 18
integer y = 112
integer width = 5042
integer height = 800
long backcolor = 12632256
string text = "Squeeze Check"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Animation!"
long picturemaskcolor = 536870912
dw_tab_3 dw_tab_3
end type

on tabpage_squeeze.create
this.dw_tab_3=create dw_tab_3
this.Control[]={this.dw_tab_3}
end on

on tabpage_squeeze.destroy
destroy(this.dw_tab_3)
end on

type dw_tab_3 from so_datawindow within tabpage_squeeze
integer y = 16
integer width = 4110
integer height = 776
integer taborder = 40
string dataobject = "d_mcn_jig_squeeze_check_lst_4_dashboard"
end type

type tabpage_tracking from userobject within tab_item
integer x = 18
integer y = 112
integer width = 5042
integer height = 800
long backcolor = 12632256
string text = "Lot Tracking"
long tabtextcolor = 33554432
long tabbackcolor = 16777215
string picturename = "AlignRight!"
long picturemaskcolor = 536870912
dw_tab_4 dw_tab_4
end type

on tabpage_tracking.create
this.dw_tab_4=create dw_tab_4
this.Control[]={this.dw_tab_4}
end on

on tabpage_tracking.destroy
destroy(this.dw_tab_4)
end on

type dw_tab_4 from so_datawindow within tabpage_tracking
integer y = 4
integer width = 4105
integer height = 780
integer taborder = 40
string dataobject = "d_pln_product_all_barcode_tracking"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

type tabpage_msl from userobject within tab_item
integer x = 18
integer y = 112
integer width = 5042
integer height = 800
long backcolor = 12632256
string text = "MSL"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "AddWatch!"
long picturemaskcolor = 536870912
dw_tab_5 dw_tab_5
end type

on tabpage_msl.create
this.dw_tab_5=create dw_tab_5
this.Control[]={this.dw_tab_5}
end on

on tabpage_msl.destroy
destroy(this.dw_tab_5)
end on

type dw_tab_5 from so_datawindow within tabpage_msl
integer y = 8
integer width = 4096
integer height = 788
integer taborder = 60
string title = ""
string dataobject = "d_mat_msl_item_check_view_lst"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

type tabpage_pcb from userobject within tab_item
integer x = 18
integer y = 112
integer width = 5042
integer height = 800
long backcolor = 12632256
string text = "PCB Input"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Compile!"
long picturemaskcolor = 536870912
dw_tab_6 dw_tab_6
end type

on tabpage_pcb.create
this.dw_tab_6=create dw_tab_6
this.Control[]={this.dw_tab_6}
end on

on tabpage_pcb.destroy
destroy(this.dw_tab_6)
end on

type dw_tab_6 from so_datawindow within tabpage_pcb
integer y = 24
integer width = 4096
integer height = 772
integer taborder = 20
string dataobject = "d_qc_pcb_input_scan_lst_4_dashboard"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

type tabpage_sample from userobject within tab_item
integer x = 18
integer y = 112
integer width = 5042
integer height = 800
long backcolor = 12632256
string text = "Sample"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
long picturemaskcolor = 536870912
dw_tab_7 dw_tab_7
end type

on tabpage_sample.create
this.dw_tab_7=create dw_tab_7
this.Control[]={this.dw_tab_7}
end on

on tabpage_sample.destroy
destroy(this.dw_tab_7)
end on

type dw_tab_7 from so_datawindow within tabpage_sample
integer y = 16
integer width = 4114
integer height = 784
integer taborder = 110
string dataobject = "d_mcn_sample_input_history_4_dashboard"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

type tabpage_reel from userobject within tab_item
integer x = 18
integer y = 112
integer width = 5042
integer height = 800
long backcolor = 12632256
string text = "Reel Change"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
long picturemaskcolor = 536870912
dw_tab_8 dw_tab_8
end type

on tabpage_reel.create
this.dw_tab_8=create dw_tab_8
this.Control[]={this.dw_tab_8}
end on

on tabpage_reel.destroy
destroy(this.dw_tab_8)
end on

type dw_tab_8 from so_datawindow within tabpage_reel
integer y = 12
integer width = 4210
integer height = 776
integer taborder = 20
string title = ""
string dataobject = "d_smt_checklist_lst_4_dashboard"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

type tabpage_nsnp from userobject within tab_item
integer x = 18
integer y = 112
integer width = 5042
integer height = 800
long backcolor = 12632256
string text = "Interlock"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
long picturemaskcolor = 536870912
dw_tab_9 dw_tab_9
end type

on tabpage_nsnp.create
this.dw_tab_9=create dw_tab_9
this.Control[]={this.dw_tab_9}
end on

on tabpage_nsnp.destroy
destroy(this.dw_tab_9)
end on

type dw_tab_9 from so_datawindow within tabpage_nsnp
integer y = 20
integer width = 5024
integer height = 776
integer taborder = 110
string dataobject = "d_pln_product_nsnp_history_lst_4_dashboard"
end type

type st_3 from so_statictext within w_com_production_status_dashboard
integer x = 1938
integer y = 20
integer width = 389
integer height = 64
boolean bringtotop = true
integer weight = 700
string text = "Interval"
alignment alignment = right!
end type

type em_interval from so_editmask within w_com_production_status_dashboard
integer x = 2368
integer y = 12
integer width = 279
integer taborder = 50
boolean bringtotop = true
string text = "60"
alignment alignment = center!
string mask = "##0.00"
boolean spin = true
string minmax = "10~~"
end type

event modified;call super::modified;timer(dec(this.text))
end event

type cb_1 from so_commandbutton within w_com_production_status_dashboard
integer x = 3026
integer width = 393
integer height = 108
integer taborder = 40
boolean bringtotop = true
string text = "Start"
end type

event clicked;call super::clicked;timer( dec(em_interval.text))
end event

type cb_2 from so_commandbutton within w_com_production_status_dashboard
integer x = 2647
integer width = 393
integer height = 108
integer taborder = 60
boolean bringtotop = true
string text = "Stop"
end type

event clicked;call super::clicked;timer(0)	
end event

type ddlb_line_code from uo_line_code_dd within w_com_production_status_dashboard
integer x = 370
integer y = 8
integer width = 553
integer height = 1808
integer taborder = 30
boolean bringtotop = true
end type

event constructor;call super::constructor;IVS_LINE_CODE = Profilestring("WORKENV.INI","LINE","DASHBOARD","")
THIS.SELECtitem(IVS_LINE_CODE )


end event

event selectionchanged;call super::selectionchanged;//RegistrySet( "HKEY_LOCAL_MACHINE\Software\Infinity21\"+GVS_APPLICATION_NAME, "IO_LINE", RegString!,THIS.GETCODE())
f_jsSetProfileString ("WORKENV.INI", "LINE", "DASHBOARD", THIS.GETCODE() )

IVS_LINE_CODE = THIS.GETCODE()


f_retrieve()
end event

type st_11 from so_statictext within w_com_production_status_dashboard
integer x = 27
integer y = 20
integer width = 306
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Line Code"
alignment alignment = right!
end type

type cb_3 from so_commandbutton within w_com_production_status_dashboard
integer x = 3410
integer width = 393
integer height = 108
integer taborder = 40
boolean bringtotop = true
string text = "NSNP UnLock"
end type

event clicked;call super::clicked;if dw_1.getrow() < 1 then return 

//=========================================
// user level $$HEX2$$55d678c7$$ENDHEX$$
//=========================================
IF ( GVI_USER_LEVEL < 8 or isnull(GVI_USER_LEVEL)) THEN
	  
	  messagebox("$$HEX2$$4cc5bcb9$$ENDHEX$$", "$$HEX11$$acc0a9c68cad5cd5200074c72000c6c5b5c2c8b2e4b2$$ENDHEX$$") 
	  return
	  
END IF


string lvs_line_code 
lvs_line_code = dw_1.object.line_code[dw_1.getrow()]
sqlca.P_INTERLOCK_SET_NSNP_TIME_MSG( lvs_line_code , '0' , 0 ,  '*', '*', 'UNLOCK', '[$$HEX4$$15ac1cc874d51cc8$$ENDHEX$$]FORCE UNLOCK '+gvs_computer_name+' : '+gvs_user_name )

if f_sql_check() < 0 then 
	return 
end if 

f_msgbox1(107 , this.text ) 

f_retrieve()
end event

type cb_4 from so_commandbutton within w_com_production_status_dashboard
integer x = 3794
integer width = 393
integer height = 108
integer taborder = 50
boolean bringtotop = true
string text = "NSNP Lock"
end type

event clicked;call super::clicked;if dw_1.getrow() < 1 then return 


//=========================================
// user level $$HEX2$$55d678c7$$ENDHEX$$
//=========================================
IF ( GVI_USER_LEVEL < 8 or isnull(GVI_USER_LEVEL)) THEN
	  
	  messagebox("$$HEX2$$4cc5bcb9$$ENDHEX$$", "$$HEX11$$acc0a9c68cad5cd5200074c72000c6c5b5c2c8b2e4b2$$ENDHEX$$") 
	  return
	  
END IF


string lvs_line_code 
lvs_line_code = dw_1.object.line_code[dw_1.getrow()]
sqlca.P_INTERLOCK_SET_NSNP_TIME_MSG( lvs_line_code , '1' ,1, '*', '*', 'LOCK', '[$$HEX4$$15ac1cc8a0c708ae$$ENDHEX$$] $$HEX13$$15ac1cc85cb82000d9b391c7200018b4c8c5b5c2c8b2e4b22000$$ENDHEX$$=>'+gvs_user_name )
if f_sql_check() < 0 then 
	return 
end if 

f_msgbox1(107 , this.text ) 

f_retrieve()
end event

type cbx_auto_detail from so_checkbox within w_com_production_status_dashboard
integer x = 965
integer y = 4
integer width = 526
boolean bringtotop = true
string text = "Detail Auto Query"
end type

type cb_5 from so_commandbutton within w_com_production_status_dashboard
integer x = 1504
integer width = 393
integer height = 108
integer taborder = 60
boolean bringtotop = true
string text = "Detail Query"
end type

event clicked;call super::clicked;if dw_1.getrow() = 0 then return

if isnull(dw_1.object.running_run_no[dw_1.getrow()] ) or isnull(dw_1.object.model_name[dw_1.getrow()] ) then 
return 
else

tab_item.tabpage_solder.dw_tab_1.retrieve( dw_1.object.solder_lot_no[dw_1.getrow()] )
tab_item.tabpage_mask.dw_tab_2.retrieve( dw_1.object.mask_lot_no[dw_1.getrow()] )
tab_item.tabpage_squeeze.dw_tab_3.retrieve( dw_1.object.squeeze_lot_no[dw_1.getrow()]  , dw_1.object.squeeze_lot_no2[dw_1.getrow()])
tab_item.tabpage_tracking.dw_tab_4.retrieve( dw_1.object.running_run_no[dw_1.getrow()]  , gvi_organization_id )
tab_item.tabpage_msl.dw_tab_5.retrieve( dw_1.object.line_code[dw_1.getrow()] ,'%' , 0 , '2' )
tab_item.tabpage_pcb.dw_tab_6.retrieve( dw_1.object.running_run_no[dw_1.getrow()]  )
tab_item.tabpage_sample.dw_tab_7.retrieve( dw_1.object.running_run_no[dw_1.getrow()]  )
tab_item.tabpage_reel.dw_tab_8.retrieve( dw_1.object.running_run_no[dw_1.getrow()]  )
tab_item.tabpage_nsnp.dw_tab_9.retrieve( dw_1.object.running_run_no[dw_1.getrow()]  )

dw_1.setfocus( )

end if 
end event

