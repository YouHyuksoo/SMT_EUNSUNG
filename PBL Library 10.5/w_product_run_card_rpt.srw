HA$PBExportHeader$w_product_run_card_rpt.srw
$PBExportComments$new a led project
forward
global type w_product_run_card_rpt from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_product_run_card_rpt
end type
type uo_dateend from uo_ymd_calendar within w_product_run_card_rpt
end type
type ddlb_model_name from uo_set_model_name_ddlb within w_product_run_card_rpt
end type
type ddlb_line_code from uo_line_code within w_product_run_card_rpt
end type
type em_carrier_size from so_editmask within w_product_run_card_rpt
end type
type st_line_code from so_statictext within w_product_run_card_rpt
end type
type st_2 from so_statictext within w_product_run_card_rpt
end type
type st_3 from so_statictext within w_product_run_card_rpt
end type
type st_4 from so_statictext within w_product_run_card_rpt
end type
type rb_list from so_radiobutton within w_product_run_card_rpt
end type
type st_7 from so_statictext within w_product_run_card_rpt
end type
type sle_run_no_cond from so_singlelineedit within w_product_run_card_rpt
end type
type ddlb_run_status from uo_basecode within w_product_run_card_rpt
end type
type st_8 from so_statictext within w_product_run_card_rpt
end type
type rb_sum from so_radiobutton within w_product_run_card_rpt
end type
type sle_marking_no from so_singlelineedit within w_product_run_card_rpt
end type
type st_1 from so_statictext within w_product_run_card_rpt
end type
type gb_1 from so_groupbox within w_product_run_card_rpt
end type
type gb_2 from so_groupbox within w_product_run_card_rpt
end type
end forward

global type w_product_run_card_rpt from w_main_root
string title = "Product Run Card Report"
uo_dateset uo_dateset
uo_dateend uo_dateend
ddlb_model_name ddlb_model_name
ddlb_line_code ddlb_line_code
em_carrier_size em_carrier_size
st_line_code st_line_code
st_2 st_2
st_3 st_3
st_4 st_4
rb_list rb_list
st_7 st_7
sle_run_no_cond sle_run_no_cond
ddlb_run_status ddlb_run_status
st_8 st_8
rb_sum rb_sum
sle_marking_no sle_marking_no
st_1 st_1
gb_1 gb_1
gb_2 gb_2
end type
global w_product_run_card_rpt w_product_run_card_rpt

type variables

end variables

on w_product_run_card_rpt.create
int iCurrent
call super::create
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.ddlb_model_name=create ddlb_model_name
this.ddlb_line_code=create ddlb_line_code
this.em_carrier_size=create em_carrier_size
this.st_line_code=create st_line_code
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.rb_list=create rb_list
this.st_7=create st_7
this.sle_run_no_cond=create sle_run_no_cond
this.ddlb_run_status=create ddlb_run_status
this.st_8=create st_8
this.rb_sum=create rb_sum
this.sle_marking_no=create sle_marking_no
this.st_1=create st_1
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateset
this.Control[iCurrent+2]=this.uo_dateend
this.Control[iCurrent+3]=this.ddlb_model_name
this.Control[iCurrent+4]=this.ddlb_line_code
this.Control[iCurrent+5]=this.em_carrier_size
this.Control[iCurrent+6]=this.st_line_code
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.st_3
this.Control[iCurrent+9]=this.st_4
this.Control[iCurrent+10]=this.rb_list
this.Control[iCurrent+11]=this.st_7
this.Control[iCurrent+12]=this.sle_run_no_cond
this.Control[iCurrent+13]=this.ddlb_run_status
this.Control[iCurrent+14]=this.st_8
this.Control[iCurrent+15]=this.rb_sum
this.Control[iCurrent+16]=this.sle_marking_no
this.Control[iCurrent+17]=this.st_1
this.Control[iCurrent+18]=this.gb_1
this.Control[iCurrent+19]=this.gb_2
end on

on w_product_run_card_rpt.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.ddlb_model_name)
destroy(this.ddlb_line_code)
destroy(this.em_carrier_size)
destroy(this.st_line_code)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.rb_list)
destroy(this.st_7)
destroy(this.sle_run_no_cond)
destroy(this.ddlb_run_status)
destroy(this.st_8)
destroy(this.rb_sum)
destroy(this.sle_marking_no)
destroy(this.st_1)
destroy(this.gb_1)
destroy(this.gb_2)
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
Ivs_resize_type                      = 'NORMAL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
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
F_MENU_CONTROL('REPORT' , TRUE)  // All Data Control
end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())


end event

event ue_data_control;call super::ue_data_control;Long ROW
STRING LVS_RCV_ISS_TYPE
CHOOSE CASE Gvs_Ue_DATA_control
		
	CASE 'RETRIEVE'

	if rb_list.checked = true then 

			DW_1.RESET( )
			DW_1.RETRIEVE(  ddlb_line_code.getcode()+'%' , ddlb_model_name.getcode()+'%' , sle_run_no_cond.text+'%' , '%' , uo_dateset.text() , uo_dateend.text() , ddlb_run_status.getcode()+'%' ,  sle_marking_no.text+'%' , gvi_organization_id )
		elseif rb_sum.checked = true then 
			DW_2.RESET( )
			DW_2.RETRIEVE(  ddlb_line_code.getcode()+'%' , ddlb_model_name.getcode()+'%' , sle_run_no_cond.text+'%' , '%' , uo_dateset.text() , uo_dateend.text() , ddlb_run_status.getcode()+'%' , sle_marking_no.text+'%' , gvi_organization_id )			
		else
			
		end if 
			
	CASE ELSE
END CHOOSE
end event

type dw_5 from w_main_root`dw_5 within w_product_run_card_rpt
integer y = 392
end type

type dw_4 from w_main_root`dw_4 within w_product_run_card_rpt
integer y = 392
boolean titlebar = true
end type

type dw_3 from w_main_root`dw_3 within w_product_run_card_rpt
integer y = 392
boolean titlebar = true
boolean controlmenu = true
boolean minbox = true
end type

type dw_2 from w_main_root`dw_2 within w_product_run_card_rpt
integer y = 392
integer width = 3662
integer height = 1356
boolean titlebar = true
string title = "Run Card"
string dataobject = "d_ip_product_run_card_sum_rpt"
boolean controlmenu = true
boolean minbox = true
end type

type dw_1 from w_main_root`dw_1 within w_product_run_card_rpt
integer y = 392
integer width = 3662
integer height = 1356
boolean titlebar = true
string title = "Data List"
string dataobject = "d_ip_product_run_card_rpt"
boolean controlmenu = true
boolean minbox = true
end type

event dw_1::rbuttondown;call super::rbuttondown;if row < 1 then return

if dwo.name = 'lv_ng_qty' then 

//	openwithparm( w_qc_lv_ng_popup , string(this.object.run_no[row] ))
	
end if 
end event

type uo_tabpages from w_main_root`uo_tabpages within w_product_run_card_rpt
end type

type uo_dateset from uo_ymd_calendar within w_product_run_card_rpt
event destroy ( )
integer x = 1129
integer y = 272
integer taborder = 70
boolean bringtotop = true
long backcolor = 12632256
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_product_run_card_rpt
event destroy ( )
integer x = 1550
integer y = 272
integer taborder = 80
boolean bringtotop = true
long backcolor = 12632256
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type ddlb_model_name from uo_set_model_name_ddlb within w_product_run_card_rpt
integer x = 1134
integer y = 172
integer width = 1129
integer height = 1244
integer taborder = 50
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
boolean hscrollbar = false
end type

event selectionchanged;call super::selectionchanged;sle_run_no_cond.text = ''
em_carrier_size.TEXT = string(f_get_carrier_size(this.getcode()))

end event

type ddlb_line_code from uo_line_code within w_product_run_card_rpt
integer x = 1134
integer y = 84
integer width = 544
integer taborder = 60
boolean bringtotop = true
long backcolor = 16777215
end type

type em_carrier_size from so_editmask within w_product_run_card_rpt
integer x = 2071
integer y = 84
integer width = 187
integer taborder = 60
boolean bringtotop = true
boolean enabled = false
string text = "0"
string mask = "##0"
end type

type st_line_code from so_statictext within w_product_run_card_rpt
integer x = 759
integer y = 84
integer width = 325
boolean bringtotop = true
long textcolor = 16711680
string text = "Line Code"
alignment alignment = right!
end type

type st_2 from so_statictext within w_product_run_card_rpt
integer x = 759
integer y = 176
integer width = 325
boolean bringtotop = true
long textcolor = 16711680
string text = "Model Name"
alignment alignment = right!
end type

type st_3 from so_statictext within w_product_run_card_rpt
integer x = 1696
integer y = 96
integer width = 325
integer height = 60
boolean bringtotop = true
string text = "Carrier Size"
alignment alignment = right!
end type

type st_4 from so_statictext within w_product_run_card_rpt
integer x = 759
integer y = 288
integer width = 325
integer height = 64
boolean bringtotop = true
string text = "Date"
alignment alignment = right!
end type

type rb_list from so_radiobutton within w_product_run_card_rpt
integer x = 105
integer y = 132
boolean bringtotop = true
string text = "Run Card"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true
selected_data_window = dw_1
end event

type st_7 from so_statictext within w_product_run_card_rpt
integer x = 2313
integer y = 84
integer width = 325
integer height = 72
boolean bringtotop = true
string text = "Run No"
alignment alignment = right!
end type

type sle_run_no_cond from so_singlelineedit within w_product_run_card_rpt
integer x = 2706
integer y = 68
integer width = 809
integer height = 92
integer taborder = 70
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
textcase textcase = upper!
end type

type ddlb_run_status from uo_basecode within w_product_run_card_rpt
integer x = 2706
integer y = 172
integer width = 809
integer taborder = 50
boolean bringtotop = true
boolean allowedit = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;this.redraw("RUN STATUS")
end event

type st_8 from so_statictext within w_product_run_card_rpt
integer x = 2295
integer y = 184
integer width = 325
integer height = 72
boolean bringtotop = true
string text = "Run Status"
alignment alignment = right!
end type

type rb_sum from so_radiobutton within w_product_run_card_rpt
integer x = 105
integer y = 252
boolean bringtotop = true
string text = "Run Card Summary"
end type

event clicked;call super::clicked;dw_2.bringtotop = true
selected_data_window = dw_2
end event

type sle_marking_no from so_singlelineedit within w_product_run_card_rpt
integer x = 2706
integer y = 268
integer width = 809
integer height = 92
integer taborder = 80
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
textcase textcase = upper!
end type

type st_1 from so_statictext within w_product_run_card_rpt
integer x = 2313
integer y = 284
integer width = 325
integer height = 72
boolean bringtotop = true
string text = "Marking No"
alignment alignment = right!
end type

type gb_1 from so_groupbox within w_product_run_card_rpt
integer x = 18
integer y = 16
integer width = 663
integer height = 364
integer taborder = 80
string text = "Category"
end type

type gb_2 from so_groupbox within w_product_run_card_rpt
integer x = 713
integer y = 12
integer width = 3977
integer height = 364
integer taborder = 90
string text = "Where Condition"
end type

