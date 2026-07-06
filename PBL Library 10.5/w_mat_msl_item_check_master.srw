HA$PBExportHeader$w_mat_msl_item_check_master.srw
$PBExportComments$$$HEX6$$80bd88d42000c8b9a4c230d1$$ENDHEX$$
forward
global type w_mat_msl_item_check_master from w_main_root
end type
type cb_run from so_commandbutton within w_mat_msl_item_check_master
end type
type uo_item from uo_item_code within w_mat_msl_item_check_master
end type
type st_5 from so_statictext within w_mat_msl_item_check_master
end type
type em_interval from so_editmask within w_mat_msl_item_check_master
end type
type st_3 from so_statictext within w_mat_msl_item_check_master
end type
type em_check_rate from so_editmask within w_mat_msl_item_check_master
end type
type st_1 from so_statictext within w_mat_msl_item_check_master
end type
type st_4 from statictext within w_mat_msl_item_check_master
end type
type st_6 from statictext within w_mat_msl_item_check_master
end type
type st_7 from statictext within w_mat_msl_item_check_master
end type
type cb_2 from so_commandbutton within w_mat_msl_item_check_master
end type
type rb_monitoring from so_radiobutton within w_mat_msl_item_check_master
end type
type rb_2 from so_radiobutton within w_mat_msl_item_check_master
end type
type uo_dateset from uo_ymd_calendar within w_mat_msl_item_check_master
end type
type uo_dateend from uo_ymd_calendar within w_mat_msl_item_check_master
end type
type st_8 from so_statictext within w_mat_msl_item_check_master
end type
type em_msl_level from editmask within w_mat_msl_item_check_master
end type
type st_2 from so_statictext within w_mat_msl_item_check_master
end type
type rb_3 from so_radiobutton within w_mat_msl_item_check_master
end type
type rb_4 from so_radiobutton within w_mat_msl_item_check_master
end type
type ddlb_line_code from uo_line_code within w_mat_msl_item_check_master
end type
type st_9 from so_statictext within w_mat_msl_item_check_master
end type
type gb_where_condition from so_groupbox within w_mat_msl_item_check_master
end type
type gb_2 from so_groupbox within w_mat_msl_item_check_master
end type
type gb_1 from so_groupbox within w_mat_msl_item_check_master
end type
end forward

global type w_mat_msl_item_check_master from w_main_root
integer width = 5646
integer height = 2904
string title = "MSL Item Check Master"
windowstate windowstate = maximized!
string ivs_dw_1_selected_row_yn = "N"
cb_run cb_run
uo_item uo_item
st_5 st_5
em_interval em_interval
st_3 st_3
em_check_rate em_check_rate
st_1 st_1
st_4 st_4
st_6 st_6
st_7 st_7
cb_2 cb_2
rb_monitoring rb_monitoring
rb_2 rb_2
uo_dateset uo_dateset
uo_dateend uo_dateend
st_8 st_8
em_msl_level em_msl_level
st_2 st_2
rb_3 rb_3
rb_4 rb_4
ddlb_line_code ddlb_line_code
st_9 st_9
gb_where_condition gb_where_condition
gb_2 gb_2
gb_1 gb_1
end type
global w_mat_msl_item_check_master w_mat_msl_item_check_master

on w_mat_msl_item_check_master.create
int iCurrent
call super::create
this.cb_run=create cb_run
this.uo_item=create uo_item
this.st_5=create st_5
this.em_interval=create em_interval
this.st_3=create st_3
this.em_check_rate=create em_check_rate
this.st_1=create st_1
this.st_4=create st_4
this.st_6=create st_6
this.st_7=create st_7
this.cb_2=create cb_2
this.rb_monitoring=create rb_monitoring
this.rb_2=create rb_2
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.st_8=create st_8
this.em_msl_level=create em_msl_level
this.st_2=create st_2
this.rb_3=create rb_3
this.rb_4=create rb_4
this.ddlb_line_code=create ddlb_line_code
this.st_9=create st_9
this.gb_where_condition=create gb_where_condition
this.gb_2=create gb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_run
this.Control[iCurrent+2]=this.uo_item
this.Control[iCurrent+3]=this.st_5
this.Control[iCurrent+4]=this.em_interval
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.em_check_rate
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.st_4
this.Control[iCurrent+9]=this.st_6
this.Control[iCurrent+10]=this.st_7
this.Control[iCurrent+11]=this.cb_2
this.Control[iCurrent+12]=this.rb_monitoring
this.Control[iCurrent+13]=this.rb_2
this.Control[iCurrent+14]=this.uo_dateset
this.Control[iCurrent+15]=this.uo_dateend
this.Control[iCurrent+16]=this.st_8
this.Control[iCurrent+17]=this.em_msl_level
this.Control[iCurrent+18]=this.st_2
this.Control[iCurrent+19]=this.rb_3
this.Control[iCurrent+20]=this.rb_4
this.Control[iCurrent+21]=this.ddlb_line_code
this.Control[iCurrent+22]=this.st_9
this.Control[iCurrent+23]=this.gb_where_condition
this.Control[iCurrent+24]=this.gb_2
this.Control[iCurrent+25]=this.gb_1
end on

on w_mat_msl_item_check_master.destroy
call super::destroy
destroy(this.cb_run)
destroy(this.uo_item)
destroy(this.st_5)
destroy(this.em_interval)
destroy(this.st_3)
destroy(this.em_check_rate)
destroy(this.st_1)
destroy(this.st_4)
destroy(this.st_6)
destroy(this.st_7)
destroy(this.cb_2)
destroy(this.rb_monitoring)
destroy(this.rb_2)
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.st_8)
destroy(this.em_msl_level)
destroy(this.st_2)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.ddlb_line_code)
destroy(this.st_9)
destroy(this.gb_where_condition)
destroy(this.gb_2)
destroy(this.gb_1)
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
Ivs_resize_type    = 'MASTER_DETAIL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
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

timer( dec(em_interval.text))
end event

event ue_data_control;call super::ue_data_control;Long ROW
STRING LVS_SETYN

CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
	
		if rb_monitoring.checked = true then 
	
	         DW_1.RETRIEVE(  ddlb_line_code.getcode()+'%' , uo_item.text+'%' , long(em_check_rate.text) , em_msl_level.text )
			DW_1.SETFOCUS()
			
		else
			
			if rb_2.checked = true then 
		   	     DW_3.RETRIEVE(  uo_item.text+'%' , uo_dateset.text() , uo_dateend.text() ,   GVI_ORGANIZATION_ID )
			     DW_3.SETFOCUS()			
			
		     else
				
				if rb_3.checked = true then 
		   	        DW_4.RETRIEVE(  uo_item.text+'%' , em_msl_level.text , long(em_check_rate.text),   GVI_ORGANIZATION_ID  )
			        DW_4.SETFOCUS()		
				
			     else
				
				      if rb_4.checked = true then 
		   	             DW_5.RETRIEVE(  uo_item.text+'%' , em_msl_level.text , long(em_check_rate.text) ,   GVI_ORGANIZATION_ID  )
			             DW_5.SETFOCUS()		
				      end if
				
			     end if
				  
		     end if
			
		end if 
	
CASE 'INSERT' 
	
			
			IF DW_1.GETROW() < 1 THEN RETURN 
	
				DW_2.ENABLED = TRUE
				ROW = DW_2.INSERTROW(DW_2.GETROW())
				DW_2.SCROLLTOROW(ROW)
				F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')				
				
				DW_2.setitem(ROW , 'SCAN_DATE' , f_sysdate())
				DW_2.object.item_code[row] = dw_1.object.item_code[dw_1.getrow()]
				DW_2.object.item_barcode[row] = dw_1.object.item_barcode[dw_1.getrow()]
				DW_2.object.lot_no[row] = dw_1.object.lot_no[dw_1.getrow()]
				
				if  dw_1.object.new_scan_qty[dw_1.getrow()] = 0 or isnull( dw_1.object.new_scan_qty[dw_1.getrow()]) then 
					DW_2.object.lot_qty[row] = dw_1.object.scan_qty[dw_1.getrow()]
			    ELSE
					DW_2.object.lot_qty[row] = dw_1.object.new_scan_qty[dw_1.getrow()]
				END IF 
				DW_2.object.scan_by[row] = gvs_user_id 
	CASE 'UPDATE' 	
		
			IF DW_2.UPDATE() < 0 THEN 
				ROLLBACK;
			ELSE
				COMMIT ;
			END IF 
		    cb_run.triggerevent( clicked!)
		
	CASE ELSE
END CHOOSE


end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

timer( dec(em_interval.text))
end event

event timer;call super::timer;f_retrieve()
end event

event close;call super::close;timer(0)
end event

event deactivate;call super::deactivate;timer(0)
end event

type dw_5 from w_main_root`dw_5 within w_mat_msl_item_check_master
integer y = 392
integer width = 1865
integer height = 916
boolean titlebar = true
string dataobject = "d_mat_item_msl_check_returny_lst"
end type

type dw_4 from w_main_root`dw_4 within w_mat_msl_item_check_master
integer y = 392
integer width = 2048
integer height = 884
boolean titlebar = true
string dataobject = "d_mat_item_msl_check_inventory_lst"
end type

type dw_3 from w_main_root`dw_3 within w_mat_msl_item_check_master
integer y = 392
integer width = 4681
integer height = 1168
integer taborder = 50
boolean titlebar = true
string dataobject = "d_mat_item_msl_check_history_lst"
end type

type dw_2 from w_main_root`dw_2 within w_mat_msl_item_check_master
integer y = 1496
integer width = 4681
integer height = 660
integer taborder = 0
boolean titlebar = true
string title = "MSL Check Result History"
string dataobject = "d_mat_item_msl_check_lst"
end type

event dw_2::getfocus;call super::getfocus;timer(0)
end event

type dw_1 from w_main_root`dw_1 within w_mat_msl_item_check_master
integer y = 392
integer width = 4681
integer height = 1096
integer taborder = 40
boolean titlebar = true
string title = "MSL Item Check List"
string dataobject = "d_mat_msl_item_check_view_lst"
end type

event dw_1::retrieveend;call super::retrieveend;if rowcount > 0 then 
	
	f_play_sound("apply.wav")
	
end if 
end event

event dw_1::retrievestart;//OVER 
end event

event dw_1::retrieverow;//OVER
end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 
dw_2.retrieve( dw_1.object.item_barcode[currentrow] , gvi_organization_id)

dw_1.setfocus()
end event

type uo_tabpages from w_main_root`uo_tabpages within w_mat_msl_item_check_master
end type

type cb_run from so_commandbutton within w_mat_msl_item_check_master
integer x = 4018
integer y = 124
integer width = 261
integer height = 156
integer taborder = 30
boolean bringtotop = true
string text = "Run"
end type

event clicked;call super::clicked;timer(dec(em_interval.text))
end event

type uo_item from uo_item_code within w_mat_msl_item_check_master
integer x = 1353
integer y = 188
integer width = 581
integer height = 764
integer taborder = 40
boolean bringtotop = true
end type

type st_5 from so_statictext within w_mat_msl_item_check_master
integer x = 1353
integer y = 120
integer width = 581
integer height = 56
boolean bringtotop = true
boolean enabled = false
string text = "Item Code"
end type

type em_interval from so_editmask within w_mat_msl_item_check_master
integer x = 3593
integer y = 188
integer height = 84
integer taborder = 40
boolean bringtotop = true
string text = "00"
string mask = "##0.00"
boolean spin = true
string minmax = "10~~"
end type

event modified;call super::modified;timer(dec(this.text))
end event

type st_3 from so_statictext within w_mat_msl_item_check_master
integer x = 3593
integer y = 104
integer width = 402
integer height = 60
boolean bringtotop = true
string text = "Interval"
end type

type em_check_rate from so_editmask within w_mat_msl_item_check_master
integer x = 3177
integer y = 188
integer height = 84
integer taborder = 50
boolean bringtotop = true
string text = "90.0"
string mask = "##0.00"
boolean spin = true
string minmax = "10~~"
end type

event modified;call super::modified;timer(dec(this.text))
end event

type st_1 from so_statictext within w_mat_msl_item_check_master
integer x = 3177
integer y = 104
integer width = 402
integer height = 60
boolean bringtotop = true
string text = "Check Rate"
end type

type st_4 from statictext within w_mat_msl_item_check_master
integer x = 4754
integer y = 68
integer width = 878
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 65280
string text = "Green Status ( Used Rate < 70% )"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_6 from statictext within w_mat_msl_item_check_master
integer x = 4754
integer y = 156
integer width = 878
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 65535
string text = "Attention Status ( Used Rate < 90% )"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_7 from statictext within w_mat_msl_item_check_master
integer x = 4754
integer y = 244
integer width = 878
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 255
string text = "Warning Status ( Used Rate > 90%  )"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_2 from so_commandbutton within w_mat_msl_item_check_master
integer x = 4293
integer y = 124
integer width = 407
integer height = 156
integer taborder = 40
boolean bringtotop = true
string text = "Do Action"
end type

event clicked;call super::clicked;f_insert()




end event

type rb_monitoring from so_radiobutton within w_mat_msl_item_check_master
integer x = 101
integer y = 80
boolean bringtotop = true
string text = "$$HEX7$$7cb778c7a5c729cc200030ae00c9$$ENDHEX$$"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true
dw_2.bringtotop = true 
selected_data_window = dw_1
end event

type rb_2 from so_radiobutton within w_mat_msl_item_check_master
boolean visible = false
integer x = 101
integer y = 268
boolean bringtotop = true
string text = "Check History"
end type

event clicked;call super::clicked;dw_3.bringtotop = true
selected_data_window = dw_3
end event

type uo_dateset from uo_ymd_calendar within w_mat_msl_item_check_master
event destroy ( )
integer x = 1947
integer y = 188
integer taborder = 50
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mat_msl_item_check_master
event destroy ( )
integer x = 2363
integer y = 188
integer taborder = 60
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_8 from so_statictext within w_mat_msl_item_check_master
integer x = 1957
integer y = 104
integer width = 814
integer height = 72
boolean bringtotop = true
string text = "Date"
end type

type em_msl_level from editmask within w_mat_msl_item_check_master
integer x = 2802
integer y = 188
integer width = 233
integer height = 84
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "3"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type st_2 from so_statictext within w_mat_msl_item_check_master
integer x = 2802
integer y = 104
integer width = 233
integer height = 72
boolean bringtotop = true
string text = "MSL Level"
end type

type rb_3 from so_radiobutton within w_mat_msl_item_check_master
integer x = 101
integer y = 164
boolean bringtotop = true
string text = "$$HEX7$$90c7acc73dcce0ac200030ae00c9$$ENDHEX$$"
end type

event clicked;call super::clicked;dw_4.bringtotop = true
selected_data_window = dw_4
end event

type rb_4 from so_radiobutton within w_mat_msl_item_check_master
integer x = 101
integer y = 252
boolean bringtotop = true
string text = "$$HEX7$$18bca9b000b330ae200030ae00c9$$ENDHEX$$"
end type

event clicked;call super::clicked;dw_5.bringtotop = true
selected_data_window = dw_5
end event

type ddlb_line_code from uo_line_code within w_mat_msl_item_check_master
integer x = 814
integer y = 188
integer width = 535
integer height = 1936
integer taborder = 50
boolean bringtotop = true
end type

type st_9 from so_statictext within w_mat_msl_item_check_master
integer x = 814
integer y = 108
integer width = 539
integer height = 68
boolean bringtotop = true
string text = "Line Code"
end type

type gb_where_condition from so_groupbox within w_mat_msl_item_check_master
integer x = 3086
integer y = 4
integer width = 1641
integer height = 360
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_2 from so_groupbox within w_mat_msl_item_check_master
integer x = 14
integer width = 677
integer height = 360
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_1 from so_groupbox within w_mat_msl_item_check_master
integer x = 709
integer width = 2363
integer height = 360
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

