HA$PBExportHeader$w_mcn_sample_bcr_input_history_master.srw
$PBExportComments$SAMPLE input history
forward
global type w_mcn_sample_bcr_input_history_master from w_main_root
end type
type sle_jig_lot_no from so_singlelineedit within w_mcn_sample_bcr_input_history_master
end type
type st_1 from so_statictext within w_mcn_sample_bcr_input_history_master
end type
type ddlb_jig_type from uo_basecode within w_mcn_sample_bcr_input_history_master
end type
type st_6 from so_statictext within w_mcn_sample_bcr_input_history_master
end type
type ddlb_line_code from uo_line_code within w_mcn_sample_bcr_input_history_master
end type
type st_line_code from statictext within w_mcn_sample_bcr_input_history_master
end type
type st_4 from so_statictext within w_mcn_sample_bcr_input_history_master
end type
type uo_dateset from uo_ymd_calendar within w_mcn_sample_bcr_input_history_master
end type
type uo_dateend from uo_ymd_calendar within w_mcn_sample_bcr_input_history_master
end type
type rb_ng from so_radiobutton within w_mcn_sample_bcr_input_history_master
end type
type rb_list from so_radiobutton within w_mcn_sample_bcr_input_history_master
end type
type gb_1 from groupbox within w_mcn_sample_bcr_input_history_master
end type
type gb_4 from so_groupbox within w_mcn_sample_bcr_input_history_master
end type
end forward

global type w_mcn_sample_bcr_input_history_master from w_main_root
integer y = 256
integer width = 5367
integer height = 3104
string title = "Sample Input History Master"
string ivs_dw_2_use_focusindicator = "Y"
string ivs_dw_2_selected_row_yn = "Y"
sle_jig_lot_no sle_jig_lot_no
st_1 st_1
ddlb_jig_type ddlb_jig_type
st_6 st_6
ddlb_line_code ddlb_line_code
st_line_code st_line_code
st_4 st_4
uo_dateset uo_dateset
uo_dateend uo_dateend
rb_ng rb_ng
rb_list rb_list
gb_1 gb_1
gb_4 gb_4
end type
global w_mcn_sample_bcr_input_history_master w_mcn_sample_bcr_input_history_master

on w_mcn_sample_bcr_input_history_master.create
int iCurrent
call super::create
this.sle_jig_lot_no=create sle_jig_lot_no
this.st_1=create st_1
this.ddlb_jig_type=create ddlb_jig_type
this.st_6=create st_6
this.ddlb_line_code=create ddlb_line_code
this.st_line_code=create st_line_code
this.st_4=create st_4
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.rb_ng=create rb_ng
this.rb_list=create rb_list
this.gb_1=create gb_1
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_jig_lot_no
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.ddlb_jig_type
this.Control[iCurrent+4]=this.st_6
this.Control[iCurrent+5]=this.ddlb_line_code
this.Control[iCurrent+6]=this.st_line_code
this.Control[iCurrent+7]=this.st_4
this.Control[iCurrent+8]=this.uo_dateset
this.Control[iCurrent+9]=this.uo_dateend
this.Control[iCurrent+10]=this.rb_ng
this.Control[iCurrent+11]=this.rb_list
this.Control[iCurrent+12]=this.gb_1
this.Control[iCurrent+13]=this.gb_4
end on

on w_mcn_sample_bcr_input_history_master.destroy
call super::destroy
destroy(this.sle_jig_lot_no)
destroy(this.st_1)
destroy(this.ddlb_jig_type)
destroy(this.st_6)
destroy(this.ddlb_line_code)
destroy(this.st_line_code)
destroy(this.st_4)
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.rb_ng)
destroy(this.rb_list)
destroy(this.gb_1)
destroy(this.gb_4)
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
Ivs_resize_type    = 'NORMAL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'Y' //Default
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
STRING LVS_RCV_ISS_TYPE

CHOOSE CASE Gvs_Ue_DATA_control
		
	CASE 'RETRIEVE'
		
		      if rb_list.checked = true then
					
				DW_1.RESET( )
				DW_1.RETRIEVE(  uo_dateset.text(), uo_dateend.text(), ddlb_line_code.getcode( )+'%' ,  ddlb_jig_type.getcode( )+'%' , sle_jig_lot_no.text+'%' , Gvi_organization_id)
		
	          else
					
				DW_2.RESET( )
				DW_2.RETRIEVE(  uo_dateset.text(), uo_dateend.text(), ddlb_line_code.getcode( )+'%' ,  ddlb_jig_type.getcode( )+'%' , sle_jig_lot_no.text+'%' , Gvi_organization_id)

              end if;
	
	CASE	'INSERT'	
			
	CASE	'APPEND'			
					
	CASE	'DELETE'
		
	CASE 'UPDATE'

	CASE ELSE
		
END CHOOSE


end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
end event

type dw_5 from w_main_root`dw_5 within w_mcn_sample_bcr_input_history_master
integer y = 288
end type

type dw_4 from w_main_root`dw_4 within w_mcn_sample_bcr_input_history_master
integer y = 288
integer taborder = 80
end type

type dw_3 from w_main_root`dw_3 within w_mcn_sample_bcr_input_history_master
integer x = 2126
integer y = 1676
integer width = 2478
integer height = 992
integer taborder = 70
boolean titlebar = true
end type

event dw_3::rbuttondown;call super::rbuttondown;if dwo.name = 'item_code' then 
	
	open(w_des_model_master_popup)
	
	if Gst_return.gvb_return = true then 
		
		this.object.item_code[row] = Gst_return.gvs_return[2]  //$$HEX6$$00b35cd42000a8ba78b32000$$ENDHEX$$
		
		
	end if 
	
elseif dwo.name = 'smt_model_name' then 
	
	open(w_des_model_master_popup)
	
	if Gst_return.gvb_return = true then 
		
		this.object.item_code[row] = Gst_return.gvs_return[1]  //smt $$HEX3$$a8ba78b32000$$ENDHEX$$
	end if 
end if 
end event

type dw_2 from w_main_root`dw_2 within w_mcn_sample_bcr_input_history_master
integer y = 292
integer width = 4626
integer height = 2384
integer taborder = 100
boolean titlebar = true
string title = "Verification NG list"
string dataobject = "d_mcn_sample_bcr_input_history_query_ng"
boolean hsplitscroll = false
borderstyle borderstyle = styleraised!
end type

type dw_1 from w_main_root`dw_1 within w_mcn_sample_bcr_input_history_master
integer y = 292
integer width = 4626
integer height = 2384
boolean titlebar = true
string title = "Sample Mater Input History"
string dataobject = "d_mcn_sample_bcr_input_history_query"
end type

event dw_1::doubleclicked;call super::doubleclicked;//IF	ROW < 1	THEN	RETURN
//DW_2.RETRIEVE( DW_1.GETITEMSTRING( ROW, 'ROWID' ))
end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;//IF	CURRENTROW < 1	THEN	RETURN
//DW_2.RETRIEVE( DW_1.GETITEMSTRING( CURRENTROW, 'ROWID' ))



end event

event dw_1::uo_mousemove;call super::uo_mousemove;//if row < 1 then return
//IF   GVS_SHOW_MACHINE_IMAGE = 'Y' AND ( UPPER(DWO.TYPE) = 'COLUMN' AND  UPPER(DWO.NAME) = 'MACHINE_CODE'  ) THEN
//
//	 IF ISVALID(W_MACHINE_REPAIR_IMAGE_FLAT) THEN
//		RETURN
//	ELSE
//			OPENWITHPARM(W_MACHINE_IMAGE_FLAT , STRING(THIS.OBJECT.MACHINE_CODE[ROW]))
//	END IF 
//ELSE
//
//	IF isvalid(W_MACHINE_IMAGE_FLAT) then
//		close(W_MACHINE_IMAGE_FLAT)
//	end if 
//END IF
end event

type uo_tabpages from w_main_root`uo_tabpages within w_mcn_sample_bcr_input_history_master
end type

type sle_jig_lot_no from so_singlelineedit within w_mcn_sample_bcr_input_history_master
integer x = 3058
integer y = 152
integer width = 626
integer taborder = 20
boolean bringtotop = true
textcase textcase = upper!
end type

type st_1 from so_statictext within w_mcn_sample_bcr_input_history_master
integer x = 3141
integer y = 72
integer width = 457
integer height = 56
boolean bringtotop = true
string text = "Sample Lot No"
end type

type ddlb_jig_type from uo_basecode within w_mcn_sample_bcr_input_history_master
integer x = 2235
integer y = 152
integer width = 805
integer taborder = 60
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'SAMPLE TYPE')
end event

type st_6 from so_statictext within w_mcn_sample_bcr_input_history_master
integer x = 2235
integer y = 72
integer width = 805
integer height = 56
boolean bringtotop = true
long textcolor = 0
string text = "Sample Type"
end type

type ddlb_line_code from uo_line_code within w_mcn_sample_bcr_input_history_master
integer x = 1774
integer y = 152
integer width = 443
integer height = 836
integer taborder = 40
boolean bringtotop = true
end type

type st_line_code from statictext within w_mcn_sample_bcr_input_history_master
integer x = 1774
integer y = 72
integer width = 443
integer height = 56
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

type st_4 from so_statictext within w_mcn_sample_bcr_input_history_master
integer x = 928
integer y = 72
integer width = 814
integer height = 68
boolean bringtotop = true
string text = "Input Date"
end type

type uo_dateset from uo_ymd_calendar within w_mcn_sample_bcr_input_history_master
event destroy ( )
integer x = 923
integer y = 152
integer taborder = 70
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mcn_sample_bcr_input_history_master
event destroy ( )
integer x = 1339
integer y = 152
integer taborder = 70
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type rb_ng from so_radiobutton within w_mcn_sample_bcr_input_history_master
integer x = 37
integer y = 160
integer width = 453
boolean bringtotop = true
string text = "Verification NG"
end type

event clicked;call super::clicked;dw_2.bringtotop = true 
selected_data_window = dw_2
end event

type rb_list from so_radiobutton within w_mcn_sample_bcr_input_history_master
integer x = 37
integer y = 72
integer width = 453
boolean bringtotop = true
string text = "Input history"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1
end event

type gb_1 from groupbox within w_mcn_sample_bcr_input_history_master
integer x = 878
integer width = 2866
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

type gb_4 from so_groupbox within w_mcn_sample_bcr_input_history_master
integer width = 864
integer height = 272
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

