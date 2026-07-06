HA$PBExportHeader$w_mcn_machine_master.srw
$PBExportComments$Customer Infromation Manage
forward
global type w_mcn_machine_master from w_main_root
end type
type sle_machine_code from so_singlelineedit within w_mcn_machine_master
end type
type st_1 from so_statictext within w_mcn_machine_master
end type
type ddlb_machine_type from uo_basecode within w_mcn_machine_master
end type
type st_6 from so_statictext within w_mcn_machine_master
end type
type st_line_code from statictext within w_mcn_machine_master
end type
type uo_dateset from uo_ymd_calendar within w_mcn_machine_master
end type
type uo_dateend from uo_ymd_calendar within w_mcn_machine_master
end type
type st_4 from so_statictext within w_mcn_machine_master
end type
type gb_1 from groupbox within w_mcn_machine_master
end type
type tab_machine from tab within w_mcn_machine_master
end type
type tabpage_1 from userobject within tab_machine
end type
type dw_6 from so_datawindow within tabpage_1
end type
type tabpage_1 from userobject within tab_machine
dw_6 dw_6
end type
type tabpage_2 from userobject within tab_machine
end type
type dw_7 from so_datawindow within tabpage_2
end type
type tabpage_2 from userobject within tab_machine
dw_7 dw_7
end type
type tabpage_3 from userobject within tab_machine
end type
type dw_8 from so_datawindow within tabpage_3
end type
type tabpage_3 from userobject within tab_machine
dw_8 dw_8
end type
type tabpage_4 from userobject within tab_machine
end type
type dw_9 from so_datawindow within tabpage_4
end type
type tabpage_4 from userobject within tab_machine
dw_9 dw_9
end type
type tab_machine from tab within w_mcn_machine_master
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type
type ddlb_line_code from uo_line_code within w_mcn_machine_master
end type
type cb_7 from so_commandbutton within w_mcn_machine_master
end type
type cb_9 from so_commandbutton within w_mcn_machine_master
end type
type ddlb_acquisition_type from uo_basecode within w_mcn_machine_master
end type
type st_3 from statictext within w_mcn_machine_master
end type
type ddlb_from_line_code from uo_line_code within w_mcn_machine_master
end type
type st_2 from statictext within w_mcn_machine_master
end type
type st_5 from statictext within w_mcn_machine_master
end type
type ddlb_to_line_code from uo_line_code within w_mcn_machine_master
end type
type cb_1 from so_commandbutton within w_mcn_machine_master
end type
type cb_2 from so_commandbutton within w_mcn_machine_master
end type
type gb_2 from groupbox within w_mcn_machine_master
end type
end forward

global type w_mcn_machine_master from w_main_root
integer y = 256
integer width = 6249
integer height = 3104
string title = "Machine Master"
windowstate windowstate = maximized!
sle_machine_code sle_machine_code
st_1 st_1
ddlb_machine_type ddlb_machine_type
st_6 st_6
st_line_code st_line_code
uo_dateset uo_dateset
uo_dateend uo_dateend
st_4 st_4
gb_1 gb_1
tab_machine tab_machine
ddlb_line_code ddlb_line_code
cb_7 cb_7
cb_9 cb_9
ddlb_acquisition_type ddlb_acquisition_type
st_3 st_3
ddlb_from_line_code ddlb_from_line_code
st_2 st_2
st_5 st_5
ddlb_to_line_code ddlb_to_line_code
cb_1 cb_1
cb_2 cb_2
gb_2 gb_2
end type
global w_mcn_machine_master w_mcn_machine_master

on w_mcn_machine_master.create
int iCurrent
call super::create
this.sle_machine_code=create sle_machine_code
this.st_1=create st_1
this.ddlb_machine_type=create ddlb_machine_type
this.st_6=create st_6
this.st_line_code=create st_line_code
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.st_4=create st_4
this.gb_1=create gb_1
this.tab_machine=create tab_machine
this.ddlb_line_code=create ddlb_line_code
this.cb_7=create cb_7
this.cb_9=create cb_9
this.ddlb_acquisition_type=create ddlb_acquisition_type
this.st_3=create st_3
this.ddlb_from_line_code=create ddlb_from_line_code
this.st_2=create st_2
this.st_5=create st_5
this.ddlb_to_line_code=create ddlb_to_line_code
this.cb_1=create cb_1
this.cb_2=create cb_2
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_machine_code
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.ddlb_machine_type
this.Control[iCurrent+4]=this.st_6
this.Control[iCurrent+5]=this.st_line_code
this.Control[iCurrent+6]=this.uo_dateset
this.Control[iCurrent+7]=this.uo_dateend
this.Control[iCurrent+8]=this.st_4
this.Control[iCurrent+9]=this.gb_1
this.Control[iCurrent+10]=this.tab_machine
this.Control[iCurrent+11]=this.ddlb_line_code
this.Control[iCurrent+12]=this.cb_7
this.Control[iCurrent+13]=this.cb_9
this.Control[iCurrent+14]=this.ddlb_acquisition_type
this.Control[iCurrent+15]=this.st_3
this.Control[iCurrent+16]=this.ddlb_from_line_code
this.Control[iCurrent+17]=this.st_2
this.Control[iCurrent+18]=this.st_5
this.Control[iCurrent+19]=this.ddlb_to_line_code
this.Control[iCurrent+20]=this.cb_1
this.Control[iCurrent+21]=this.cb_2
this.Control[iCurrent+22]=this.gb_2
end on

on w_mcn_machine_master.destroy
call super::destroy
destroy(this.sle_machine_code)
destroy(this.st_1)
destroy(this.ddlb_machine_type)
destroy(this.st_6)
destroy(this.st_line_code)
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.st_4)
destroy(this.gb_1)
destroy(this.tab_machine)
destroy(this.ddlb_line_code)
destroy(this.cb_7)
destroy(this.cb_9)
destroy(this.ddlb_acquisition_type)
destroy(this.st_3)
destroy(this.ddlb_from_line_code)
destroy(this.st_2)
destroy(this.st_5)
destroy(this.ddlb_to_line_code)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.gb_2)
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

event ue_data_control;call super::ue_data_control;Long ROW
CHOOSE CASE Gvs_Ue_DATA_control
		
	CASE 'RETRIEVE'
		
			DW_1.RESET( )
			DW_1.RETRIEVE(  sle_machine_code.text+'%' , ddlb_machine_type.getcode( )+'%' , ddlb_line_code.getcode( )+'%'  , ddlb_Acquisition_Type.getcode( )+'%' ,  gvi_organization_id )
			 
	CASE 'INSERT'
		
		if tab_machine.selectedtab  = 3 then 


				ROW = tab_machine.TABPAGE_3.DW_8.INSERTROW(0)
				tab_machine.TABPAGE_3.DW_8.SCROLLTOROW(ROW)
				F_SET_SECURITY_ROW(tab_machine.TABPAGE_3.DW_8 , ROW , 'ALL')
				tab_machine.TABPAGE_3.DW_8.SETFOCUS()
				F_MSG_MDI_HELP ( F_MSG_ST(152)	 )
				if dw_1.getrow() < 1 then 
				else				
					tab_machine.TABPAGE_3.DW_8.object.machine_code[row] = dw_1.object.machine_code[dw_1.getrow()]
				end if 
					tab_machine.TABPAGE_3.DW_8.object.change_date[row] = f_sysdate()
				
				
			elseif tab_machine.selectedtab  = 4 then 

				ROW = tab_machine.TABPAGE_4.DW_9.INSERTROW(0)
				tab_machine.TABPAGE_4.DW_9.SCROLLTOROW(ROW)
				F_SET_SECURITY_ROW(tab_machine.TABPAGE_4.DW_9 , ROW , 'ALL')
				tab_machine.TABPAGE_4.DW_9.SETFOCUS()
				F_MSG_MDI_HELP ( F_MSG_ST(152)	 )
				
				
				if dw_1.getrow() < 1 then 
				else
				
					tab_machine.TABPAGE_4.DW_9.object.machine_code[row] = dw_1.object.machine_code[dw_1.getrow()]
					
				end if 
				
					tab_machine.TABPAGE_4.DW_9.object.calibration_date[row] = f_sysdate()
								
		else
		
				tab_machine.TABPAGE_1.DW_6.reset()
				ROW = tab_machine.TABPAGE_1.DW_6.INSERTROW(tab_machine.TABPAGE_1.DW_6.GETROW())
				tab_machine.TABPAGE_1.DW_6.SCROLLTOROW(ROW)
				F_SET_SECURITY_ROW(tab_machine.TABPAGE_1.DW_6 , ROW , 'ALL')
				tab_machine.TABPAGE_1.DW_6.SETFOCUS()
				F_MSG_MDI_HELP ( F_MSG_ST(152)	 )
	
		end if
		
CASE 'APPEND'

					   
						
	CASE 'DELETE'
		
			 IF DW_1.GETROW() < 1 THEN RETURN 
			 
			if tab_machine.selectedtab  = 1 then 
			 
				 IF tab_machine.TABPAGE_1.DW_6.GETROW() < 1 THEN RETURN 	
			   
			  
					MSG = F_MSGBOX(1003) 
					IF MSG = 1 THEN
		
						GVL_ROW_DELETED = tab_machine.TABPAGE_1.DW_6.GETROW()			
						tab_machine.TABPAGE_1.DW_6.DELETEROW(GVL_ROW_DELETED)		
						tab_machine.TABPAGE_1.DW_6.SETFOCUS()
						ROW = tab_machine.TABPAGE_1.DW_6.GETROW()
						tab_machine.TABPAGE_1.DW_6.SCROLLTOROW(ROW)
						tab_machine.TABPAGE_1.DW_6.SETCOLUMN(1)
						
					END IF
				elseif tab_machine.selectedtab  = 3 then 
				MSG = F_MSGBOX(1003) 
					IF MSG = 1 THEN
		
						GVL_ROW_DELETED = tab_machine.TABPAGE_3.DW_8.GETROW()			
						tab_machine.TABPAGE_3.DW_8.DELETEROW(GVL_ROW_DELETED)		
						tab_machine.TABPAGE_3.DW_8.SETFOCUS()
						ROW = tab_machine.TABPAGE_3.DW_8.GETROW()
						tab_machine.TABPAGE_3.DW_8.SCROLLTOROW(ROW)
						tab_machine.TABPAGE_3.DW_8.SETCOLUMN(1)
						
					END IF					
					
				elseif tab_machine.selectedtab  = 4 then 		
					MSG = F_MSGBOX(1003) 
					IF MSG = 1 THEN
		
						GVL_ROW_DELETED = tab_machine.TABPAGE_4.DW_9.GETROW()			
						tab_machine.TABPAGE_4.DW_9.DELETEROW(GVL_ROW_DELETED)		
						tab_machine.TABPAGE_4.DW_9.SETFOCUS()
						ROW = tab_machine.TABPAGE_4.DW_9.GETROW()
						tab_machine.TABPAGE_4.DW_9.SCROLLTOROW(ROW)
						tab_machine.TABPAGE_4.DW_9.SETCOLUMN(1)
						
					END IF	
					
				end if 
	CASE 'UPDATE'
		
		DW_1.ACCEPTTEXT()
		IF DW_1.ModifiedCount() > 0 OR DW_1.DELETEDCOUNT() > 0 THEN
			IF dw_1.UPDATE() < 0 THEN
				ROLLBACK;
			ELSE
				COMMIT;
				F_MSG_MDI_HELP ( F_MSG_ST(170)	 ) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
			END IF
		ELSE
			     F_MSG_MDI_HELP("Modified Data Not Found")
		END IF		
		
		
		 tab_machine.TABPAGE_1.DW_6.ACCEPTTEXT()
			
		IF tab_machine.TABPAGE_1.DW_6.UPDATE() < 0  or  tab_machine.TABPAGE_2.DW_7.UPDATE() < 0  or  tab_machine.TABPAGE_3.DW_8.UPDATE() < 0 or tab_machine.TABPAGE_4.DW_9.UPDATE() < 0  THEN
			ROLLBACK;
		ELSE
			COMMIT;
			F_MSG_MDI_HELP ( F_MSG_ST(170)	 ) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
		END IF
		

			COMMIT;
			F_MSG_MDI_HELP ( F_MSG_ST(170)	 ) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
 		
	CASE ELSE
END CHOOSE


end event

event ue_post_open;call super::ue_post_open;IF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL_TAB' THEN //12345_TAB
	
	dw_1.resize(width - dw_1.x -34, height - ( dw_1.y + tab_machine.height +120 ))
	dw_2.resize(width - dw_2.x -34, height - ( dw_2.y + tab_machine.height +120 ))	
	dw_3.resize(width - dw_3.x -34, height - ( dw_3.y + tab_machine.height +120))	
	dw_4.resize(width - dw_4.x -34, height - ( dw_4.y + tab_machine.height +120))		
	dw_5.resize(width - dw_5.x -34, height - ( dw_5.y + tab_machine.height +120))	
	
	tab_machine.y = dw_1.y + dw_1.HEIGHT
	tab_machine.resize(width - tab_machine.x -34, tab_machine.height )	

END IF	  
	  
	  
/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

uo_dateend.settext (string(RelativeDate( Date(uo_dateset.text()) , 30 )))
end event

event open;call super::open;//========================================
// Set Transaction
//========================================
tab_machine.tabpage_1.dw_6.settransobject( sqlca)
tab_machine.tabpage_2.dw_7.settransobject( sqlca)
tab_machine.tabpage_3.dw_8.settransobject( sqlca)
tab_machine.tabpage_4.dw_9.settransobject( sqlca)
//========================================
// dddw Init
//========================================
f_set_column_dddw( tab_machine.tabpage_1.dw_6 )
f_set_column_dddw( tab_machine.tabpage_2.dw_7 )
f_set_column_dddw( tab_machine.tabpage_3.dw_8 )
f_set_column_dddw( tab_machine.tabpage_4.dw_9 )
//========================================
// Share Data
//========================================

//tab_machine.tabpage_1.dw_6.sharedata( tab_machine.tabpage_2.dw_7 )
//tab_machine.tabpage_1.dw_6.sharedata( tab_machine.tabpage_3.dw_8 )
end event

event resize;call super::resize;IF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL_TAB' THEN //12345_TAB
	
	dw_1.resize(width - (dw_1.x +70) , height - ( dw_1.y + tab_machine.height ))
	dw_2.resize(dw_1.width , height - ( dw_2.y + tab_machine.height ))	
	dw_3.resize(dw_1.width , height - ( dw_3.y + tab_machine.height ))	
	dw_4.resize(dw_1.width , height - ( dw_4.y + tab_machine.height ))		
	dw_5.resize(dw_1.width , height - ( dw_5.y + tab_machine.height ))	
	
	tab_machine.y = dw_1.y + dw_1.HEIGHT
	tab_machine.resize(width - tab_machine.x , tab_machine.height )	

END IF	  
end event

type dw_5 from w_main_root`dw_5 within w_mcn_machine_master
integer y = 288
end type

type dw_4 from w_main_root`dw_4 within w_mcn_machine_master
integer y = 288
integer taborder = 80
end type

type dw_3 from w_main_root`dw_3 within w_mcn_machine_master
integer y = 288
integer taborder = 70
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
borderstyle borderstyle = styleraised!
end type

type dw_2 from w_main_root`dw_2 within w_mcn_machine_master
integer y = 288
integer width = 4288
integer height = 844
integer taborder = 100
end type

type dw_1 from w_main_root`dw_1 within w_mcn_machine_master
integer y = 288
integer width = 5051
integer height = 844
boolean titlebar = true
string title = "Machine List"
string dataobject = "d_mcn_machine_lst"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow = 0 then return
if tab_machine.selectedtab = 3 then 
	tab_machine.tabpage_3.dw_8.retrieve( dw_1.object.machine_code[currentrow] , gvi_organization_id )
elseif tab_machine.selectedtab = 4 then 
	tab_machine.tabpage_4.dw_9.retrieve( dw_1.object.machine_code[currentrow] , gvi_organization_id )
else
	tab_machine.tabpage_1.dw_6.retrieve( dw_1.object.rowid[currentrow])
	tab_machine.tabpage_2.dw_7.retrieve( dw_1.object.rowid[currentrow])
	dw_1.setfocus( )
end if 
end event

type uo_tabpages from w_main_root`uo_tabpages within w_mcn_machine_master
end type

type sle_machine_code from so_singlelineedit within w_mcn_machine_master
integer x = 55
integer y = 156
integer width = 471
integer taborder = 20
boolean bringtotop = true
end type

type st_1 from so_statictext within w_mcn_machine_master
integer x = 55
integer y = 80
integer width = 471
integer height = 68
boolean bringtotop = true
string text = "Machine Code"
end type

type ddlb_machine_type from uo_basecode within w_mcn_machine_master
integer x = 535
integer y = 152
integer width = 745
integer height = 1988
integer taborder = 60
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;this.redraw( 'MACHINE TYPE')
end event

type st_6 from so_statictext within w_mcn_machine_master
integer x = 535
integer y = 76
integer width = 745
integer height = 68
boolean bringtotop = true
long textcolor = 0
string text = "Machine Type"
end type

type st_line_code from statictext within w_mcn_machine_master
integer x = 1298
integer y = 72
integer width = 562
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Line Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_dateset from uo_ymd_calendar within w_mcn_machine_master
event destroy ( )
integer x = 2455
integer y = 148
integer taborder = 40
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mcn_machine_master
event destroy ( )
integer x = 2871
integer y = 148
integer taborder = 50
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_4 from so_statictext within w_mcn_machine_master
integer x = 2459
integer y = 76
integer width = 814
boolean bringtotop = true
string text = "Machine Care Plan Date"
end type

type gb_1 from groupbox within w_mcn_machine_master
integer x = 9
integer width = 3296
integer height = 272
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Where Condition"
end type

type tab_machine from tab within w_mcn_machine_master
integer y = 1148
integer width = 5051
integer height = 1004
integer taborder = 70
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
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type

on tab_machine.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4}
end on

on tab_machine.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
end on

event selectionchanged;if newindex = 3 then 
	tab_machine.tabpage_3.dw_8.width  = tab_machine.tabpage_3.width - tab_machine.tabpage_3.x
elseif  newindex = 4 then 
	tab_machine.tabpage_4.dw_9.width  = tab_machine.tabpage_4.width - tab_machine.tabpage_4.x
end if 
end event

type tabpage_1 from userobject within tab_machine
integer x = 18
integer y = 112
integer width = 5015
integer height = 876
long backcolor = 12632256
string text = "Machine Master"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "EditDataTabular!"
long picturemaskcolor = 536870912
dw_6 dw_6
end type

on tabpage_1.create
this.dw_6=create dw_6
this.Control[]={this.dw_6}
end on

on tabpage_1.destroy
destroy(this.dw_6)
end on

type dw_6 from so_datawindow within tabpage_1
integer width = 6194
integer height = 768
integer taborder = 30
string dataobject = "d_mcn_machine_mst"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;if dwo.name = 'b_new' then 
	
	open( w_des_new_item_popup)
	if Gst_return.gvb_return = true then
		this.object.item_code[row] = message.stringparm
	end if 
	
end if
end event

event itemchanged;call super::itemchanged;DATETIME 	LVD_DATESET , LVD_DATEEND
if	row <= 0 then return

if dwo.name = 'set_item_yn' then
	//$$HEX24$$5ccd85c880bd88d47cc7bdacb0c62000fcd3a9ba6cad84bd44c720001cc888d43cc75cb8200090c7d9b3200024c115c8$$ENDHEX$$
		if data = 'Y' then
			this.object.item_division[row] = 'F' 
			this.object.item_type[row] = 'T' 			
			this.object.line_type[row] = 'T' 						
		end if
end if

if dwo.name = 'dateset' or dwo.name =  'dateend' then 
	  
	DW_2.ACCEPTTEXT()
	LVD_DATESET = DW_2.GETITEMDATETIME( row , 'dateset' )
	LVD_DATEEND = DW_2.GETITEMDATETIME( row , 'dateend' )
	
	IF LVD_DATESET >  LVD_DATEEND THEN		
		DW_2.OBJECT.DATESET[ROW] = ''
		DW_2.OBJECT.DATEEND[ROW] = ''
		//MESS AGEBOX("Notify" , "Dateend Must Greate then Dateset" )
		f_msg( "Dateend Must Greate then Dateset" , 'P') 
		RETURN 1 
	END IF		
				
end if 


if dwo.name = 'line_type' then
	
	if data = 'T'  and this.object.set_item_yn[row] = 'Y'  then // $$HEX11$$90c791c7200074c7e0ac20005ccd85c874c774ba2000$$ENDHEX$$
		
		this.object.item_division[row] = 'F'
		
	elseif data = 'T'  and this.object.set_item_yn[row] = 'N'  then //$$HEX11$$90c791c774c7e0ac200018bc1cc888d474c774ba2000$$ENDHEX$$

		this.object.item_division[row] = 'W'		
		
	elseif data = 'F'  then //$$HEX5$$34bbc1c0acc009ae2000$$ENDHEX$$
		
		this.object.item_division[row] = 'R'		
	else
		this.object.item_division[row] = 'R'				
	end if
end if 
end event

type tabpage_2 from userobject within tab_machine
integer x = 18
integer y = 112
integer width = 5015
integer height = 876
long backcolor = 12632256
string text = "Inter Lock Infor"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "CreateTable5!"
long picturemaskcolor = 12632256
dw_7 dw_7
end type

on tabpage_2.create
this.dw_7=create dw_7
this.Control[]={this.dw_7}
end on

on tabpage_2.destroy
destroy(this.dw_7)
end on

type dw_7 from so_datawindow within tabpage_2
integer width = 5010
integer height = 728
integer taborder = 80
string dataobject = "d_mcn_machine_interlock_mst"
boolean border = false
borderstyle borderstyle = stylebox!
end type

type tabpage_3 from userobject within tab_machine
integer x = 18
integer y = 112
integer width = 5015
integer height = 876
long backcolor = 12632256
string text = "Soft Version"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Deploy!"
long picturemaskcolor = 12632256
dw_8 dw_8
end type

on tabpage_3.create
this.dw_8=create dw_8
this.Control[]={this.dw_8}
end on

on tabpage_3.destroy
destroy(this.dw_8)
end on

type dw_8 from so_datawindow within tabpage_3
integer y = 12
integer width = 5010
integer height = 704
integer taborder = 90
boolean titlebar = true
string title = ""
string dataobject = "d_mcn_machine_soft_version_mlst"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
borderstyle borderstyle = stylebox!
end type

event itemchanged;call super::itemchanged;string			ls_hs_name, ls_hs_name_scrap
if 	dwo.name = 'hs_code' then 
	
	SELECT	CODE_MEAN_LOCAL
	INTO		:ls_hs_name
	FROM		ISYS_BASECODE
	WHERE	CODE_TYPE				=	'HS CODE'
	AND		CODE_NAME			=	:data
	AND		ORGANIZATION_ID	=	:gvi_organization_id
	;
	
	this.object.hs_name[row]	=	ls_hs_name
	
end if

if 	dwo.name = 'hs_code_scrap' then 
	
	ls_hs_name	=	this.object.hs_name[row]
	
	SELECT	CODE_MEAN_LOCAL
	INTO		:ls_hs_name_scrap
	FROM		ISYS_BASECODE
	WHERE	CODE_TYPE				=	'HS CODE SCRAP'
	AND		CODE_NAME			=	:data
	AND		ORGANIZATION_ID	=	:gvi_organization_id
	;
	
	this.object.hs_name_scrap[row]	=	ls_hs_name + ls_hs_name_scrap
end if

end event

type tabpage_4 from userobject within tab_machine
integer x = 18
integer y = 112
integer width = 5015
integer height = 876
long backcolor = 12632256
string text = "Calibration"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "AlignVCenter!"
long picturemaskcolor = 536870912
dw_9 dw_9
end type

on tabpage_4.create
this.dw_9=create dw_9
this.Control[]={this.dw_9}
end on

on tabpage_4.destroy
destroy(this.dw_9)
end on

type dw_9 from so_datawindow within tabpage_4
integer y = 16
integer width = 5015
integer height = 844
integer taborder = 50
boolean titlebar = true
string title = ""
string dataobject = "d_mcn_machine_calibration_lst"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type ddlb_line_code from uo_line_code within w_mcn_machine_master
integer x = 1294
integer y = 148
integer width = 562
integer height = 1876
integer taborder = 70
boolean bringtotop = true
end type

type cb_7 from so_commandbutton within w_mcn_machine_master
integer x = 3351
integer y = 56
integer width = 498
integer height = 104
integer taborder = 30
boolean bringtotop = true
integer weight = 400
string text = "Image Upload"
end type

event clicked;call super::clicked;if f_object_role_check() = false then  return

int    li_filenum , loops, i , lvi_count
long   flen, bytes_read , bytes_read_sum , new_pos
blob   lib_file , b
double lvdb_version  

string is_filename, is_fullname , lvs_drawing_no , lvs_machine_code
		
		if  DW_1.getrow() < 1 then 
			 return
		end if
			
			lvs_machine_code  = DW_1.getitemstring( DW_1.getrow() , "machine_code" )
	
		if lvs_machine_code ='' or isnull(lvs_machine_code) then 
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
					
					update imcn_machine set machine_image_file_name = :is_filename 
					where machine_code = :lvs_machine_code
					  and organization_id = :gvi_organization_id ;
							  
					if f_sql_check() < 0 then 
						return 
					end if 
					
					updateblob imcn_machine set machine_image = :lib_file 
					where machine_code       = :lvs_machine_code
					  and organization_id = :gvi_organization_id ;

				  if sqlca.sqlnrows > 0 then

				  else
					  rollback ;
					  messagebox("error" , is_filename+f_msg(" file upload to database failed",'S') )
					  return
				  end if;
			  
				  commit ;
			         f_msgbox(9022)

		end if
changedirectory(gvs_default_directory)

end event

type cb_9 from so_commandbutton within w_mcn_machine_master
integer x = 3351
integer y = 152
integer width = 498
integer height = 104
integer taborder = 40
boolean bringtotop = true
integer weight = 400
string text = "Image Delete"
end type

event clicked;call super::clicked;if f_object_role_check() = false then  return
string lvs_machine_code
double lvdb_repair_sequence
blob lblob_null

setnull(lblob_null)

int lvi_count
				if  DW_2.getrow() < 1 then 
					 return
				end if
			
				lvs_machine_code  = DW_2.getitemstring( DW_2.getrow() , "machine_code" )
				
				if lvs_machine_code ='' or isnull(lvs_machine_code) then 
					return
				end if		
				
					updateblob  imcn_machine set machine_image = :lblob_null
					where machine_code  = :lvs_machine_code
					  and organization_id   = :gvi_organization_id ;

					if f_sql_check() < 0 then 
						return 
					else
						commit ;
						f_msgbox(9022)
					end if 
changedirectory(gvs_default_directory)

end event

type ddlb_acquisition_type from uo_basecode within w_mcn_machine_master
integer x = 1870
integer y = 148
integer width = 571
integer height = 1552
integer taborder = 50
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'ACQUISITION TYPE')
end event

type st_3 from statictext within w_mcn_machine_master
integer x = 1870
integer y = 76
integer width = 571
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Acquisition Type"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_from_line_code from uo_line_code within w_mcn_machine_master
integer x = 3872
integer y = 156
integer width = 457
integer height = 1876
integer taborder = 50
boolean bringtotop = true
end type

type st_2 from statictext within w_mcn_machine_master
integer x = 3877
integer y = 80
integer width = 457
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "From Line Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_5 from statictext within w_mcn_machine_master
integer x = 4352
integer y = 80
integer width = 457
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "To Line Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_to_line_code from uo_line_code within w_mcn_machine_master
integer x = 4347
integer y = 156
integer width = 457
integer height = 1876
integer taborder = 30
boolean bringtotop = true
end type

type cb_1 from so_commandbutton within w_mcn_machine_master
integer x = 4818
integer y = 144
integer width = 498
integer height = 100
integer taborder = 50
boolean bringtotop = true
integer weight = 400
string text = "Copy"
end type

event clicked;call super::clicked;STRING LVS_FROM_LINE_CODE , LVS_TO_LINE_CODE , LVS_TO_LINE_NAME

LVS_FROM_LINE_CODE = DDLB_FROM_LINE_CODE.GETCODE() 
LVS_TO_LINE_CODE     = DDLB_TO_LINE_CODE.GETCODE() 
LVS_TO_LINE_NAME     = DDLB_TO_LINE_CODE.GETNAME() 

  INSERT INTO "IMCN_MACHINE"  
         ( "MACHINE_CODE",   
           "ORGANIZATION_ID",   
           "MACHINE_NAME",   
           "MACHINE_TYPE",   
           "CAPACITY",   
           "RESERVED_CAPACITY",   
           "ACQUISITION_DATE",   
           "ACQUISITION_TYPE",   
           "MACHINE_MODEL_NAME",   
           "LINE_CODE",   
           "CUSTOMER_CODE",   
           "USE_STATUS",   
           "MANUAL_LOCATION_COMMENT",   
           "NATION_CODE",   
           "WORKSTAGE_CODE",   
           "ENTER_BY",   
           "ENTER_DATE",   
           "LAST_MODIFY_BY",   
           "LAST_MODIFY_DATE",   
           "USE_RATE",   
           "UPH_VALUE",   
           "CAPACITY_UOM",   
           "SUPPLIER_CODE",   
           "MACHINE_STATUS",   
           "MOLD_CODE",   
           "MOLD_VERSION",   
           "MOLD_SET_SERIAL",   
           "MACHINE_IMAGE_FILE_NAME",   
           "MES_DISPLAY_YN",   
           "MES_DISPLAY_SEQUENCE",   
           "MOLD_EXISTS_YN",   
           "MACHINE_STATUS_CODE",   
           "CALLING_PLC_ADDRESS",   
           "ACTION_DATE",   
           "ACTUAL_PLC_ADDRESS",   
           "USE_TPM_YN",   
           "MACHINE_SPEC",   
           "MODEL_NAME",   
           "DEPARTMENT_CODE",   
           "IP_ADDRESS",   
           "PORT_NO",   
           "DIO_PORT",   
           "SCANNER_PORT",   
           "EQUIPMENT_PORT",   
           "DIO_ADDRESS",   
           "BCR_CODE",   
           "BUFFER_TYPE",   
           "PROCESS_WAIT_TIME",   
           "JIG_TYPE",   
           "HIT_VALUE",   
           "BREAK_VALUE",   
           "MAIN_POWER",   
           "MACHINE_LENGTH",   
           "POWER_CONSUMPTION",   
           "SCANNER_ADDRESS",   
           "MIN_TEMP_VALUE",   
           "MAX_TEMP_VALUE",   
           "STD_TEMP_VALUE",   
           "MIN_HUMIDITY_VALUE",   
           "MAX_HUMIDITY_VALUE",   
           "STD_HUMIDITY_VALUE" )  
 select  REPLACE( "MACHINE_CODE",   'A' , :LVS_TO_LINE_NAME ) ,
           "ORGANIZATION_ID",   
           "MACHINE_NAME",   
           "MACHINE_TYPE",   
           "CAPACITY",   
           "RESERVED_CAPACITY",   
           "ACQUISITION_DATE",   
           "ACQUISITION_TYPE",   
           "MACHINE_MODEL_NAME",   
           :lvs_to_line_code,   
           "CUSTOMER_CODE",   
           "USE_STATUS",   
           "MANUAL_LOCATION_COMMENT",   
           "NATION_CODE",   
           "WORKSTAGE_CODE",   
           "ENTER_BY",   
           "ENTER_DATE",   
           "LAST_MODIFY_BY",   
           "LAST_MODIFY_DATE",   
           "USE_RATE",   
           "UPH_VALUE",   
           "CAPACITY_UOM",   
           "SUPPLIER_CODE",   
           "MACHINE_STATUS",   
           "MOLD_CODE",   
           "MOLD_VERSION",   
           "MOLD_SET_SERIAL",   
           "MACHINE_IMAGE_FILE_NAME",   
           "MES_DISPLAY_YN",   
           "MES_DISPLAY_SEQUENCE",   
           "MOLD_EXISTS_YN",   
           "MACHINE_STATUS_CODE",   
           "CALLING_PLC_ADDRESS",   
           "ACTION_DATE",   
           "ACTUAL_PLC_ADDRESS",   
           "USE_TPM_YN",   
           "MACHINE_SPEC",   
           "MODEL_NAME",   
           "DEPARTMENT_CODE",   
           "IP_ADDRESS",   
           "PORT_NO",   
           "DIO_PORT",   
           "SCANNER_PORT",   
           "EQUIPMENT_PORT",   
           "DIO_ADDRESS",   
           "BCR_CODE",   
           "BUFFER_TYPE",   
           "PROCESS_WAIT_TIME",   
           "JIG_TYPE",   
           "HIT_VALUE",   
           "BREAK_VALUE",   
           "MAIN_POWER",   
           "MACHINE_LENGTH",   
           "POWER_CONSUMPTION",   
           "SCANNER_ADDRESS",   
           "MIN_TEMP_VALUE",   
           "MAX_TEMP_VALUE",   
           "STD_TEMP_VALUE",   
           "MIN_HUMIDITY_VALUE",   
           "MAX_HUMIDITY_VALUE",   
           "STD_HUMIDITY_VALUE"
   from  IMCN_MACHINE
where line_code = :lvs_from_line_code 
and organization_id = :gvi_organization_id
and machine_code like 'YSS%';

IF F_SQL_CHECK() < 0 THEN 
	RETURN 
END IF 

COMMIT  ;

F_MSGBOX(170) 
end event

type cb_2 from so_commandbutton within w_mcn_machine_master
integer x = 4818
integer y = 44
integer width = 498
integer height = 100
integer taborder = 60
boolean bringtotop = true
integer weight = 400
string text = "Exchange"
end type

event clicked;call super::clicked;string  lvs_line_code1 , lvs_line_code2   , lvs_machine_code1 , lvs_machine_code2 

lvs_line_code1 = ddlb_from_line_code.getcode()
lvs_line_code2 = ddlb_to_line_code.getcode()

if lvs_machine_code1 = '%' or isnull(lvs_machine_code1) or isnull(lvs_machine_code2)  or isnull(lvs_machine_code2)  then 
	Messagebox("Notify" , f_msg("Ivalid Condition ",'S'))
	return 
end if 
//======================================
//
//======================================

update imcn_machine
     set line_code  = :lvs_line_code2||'-X'
where line_code = :lvs_line_code1
    and organization_id = :gvi_organization_id ;
if f_sql_check() < 0 then 
	return 
end if 

update id_eng_bom_smt
     set line_code  = :lvs_line_code1||'-X'
where line_code = :lvs_line_code2 
 and organization_id = :gvi_organization_id ;

if f_sql_check() < 0 then 
	return 
end if 
//===================================
//
//===================================
update imcn_machine
     set line_code  = :lvs_line_code1 ,
	      machine_code = substr( machine_code , 1,3)||'-'|| f_get_line_name(:lvs_line_code1 , organization_id ) ||'-'|| trim(substr( machine_code , 7,10))
where line_code = :lvs_line_code1||'-X'
 and machine_code like 'YSS-%'
 and organization_id = :gvi_organization_id ;

if f_sql_check() < 0 then 
	return 
end if 

update imcn_machine
     set line_code  = :lvs_line_code2 ,
	      machine_code  = substr( machine_code , 1,3)||'-'|| f_get_line_name(:lvs_line_code2, organization_id ) ||'-'|| trim(substr( machine_code , 7,10))
where line_code  =  :lvs_line_code2||'-X'
    and machine_code like 'YSS-%'
    and organization_id = :gvi_organization_id ;
	 
if f_sql_check() < 0 then 
	return 
end if 

COMMIT ;

f_msgbox(170)
end event

type gb_2 from groupbox within w_mcn_machine_master
integer x = 3305
integer width = 2043
integer height = 272
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Image"
end type

