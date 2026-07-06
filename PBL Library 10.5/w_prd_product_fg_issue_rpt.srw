HA$PBExportHeader$w_prd_product_fg_issue_rpt.srw
$PBExportComments$new a led project
forward
global type w_prd_product_fg_issue_rpt from w_main_root
end type
type rb_detail from so_radiobutton within w_prd_product_fg_issue_rpt
end type
type rb_sum from so_radiobutton within w_prd_product_fg_issue_rpt
end type
type uo_dateset from uo_ymd_calendar within w_prd_product_fg_issue_rpt
end type
type st_7 from statictext within w_prd_product_fg_issue_rpt
end type
type uo_dateend from uo_ymd_calendar within w_prd_product_fg_issue_rpt
end type
type st_6 from statictext within w_prd_product_fg_issue_rpt
end type
type sle_s_model from so_singlelineedit within w_prd_product_fg_issue_rpt
end type
type st_5 from statictext within w_prd_product_fg_issue_rpt
end type
type sle_s_pack from so_singlelineedit within w_prd_product_fg_issue_rpt
end type
type rb_cross from so_radiobutton within w_prd_product_fg_issue_rpt
end type
type gb_1 from so_groupbox within w_prd_product_fg_issue_rpt
end type
type gb_2 from so_groupbox within w_prd_product_fg_issue_rpt
end type
end forward

global type w_prd_product_fg_issue_rpt from w_main_root
string title = "Product Shipping Report"
rb_detail rb_detail
rb_sum rb_sum
uo_dateset uo_dateset
st_7 st_7
uo_dateend uo_dateend
st_6 st_6
sle_s_model sle_s_model
st_5 st_5
sle_s_pack sle_s_pack
rb_cross rb_cross
gb_1 gb_1
gb_2 gb_2
end type
global w_prd_product_fg_issue_rpt w_prd_product_fg_issue_rpt

type variables

end variables

on w_prd_product_fg_issue_rpt.create
int iCurrent
call super::create
this.rb_detail=create rb_detail
this.rb_sum=create rb_sum
this.uo_dateset=create uo_dateset
this.st_7=create st_7
this.uo_dateend=create uo_dateend
this.st_6=create st_6
this.sle_s_model=create sle_s_model
this.st_5=create st_5
this.sle_s_pack=create sle_s_pack
this.rb_cross=create rb_cross
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_detail
this.Control[iCurrent+2]=this.rb_sum
this.Control[iCurrent+3]=this.uo_dateset
this.Control[iCurrent+4]=this.st_7
this.Control[iCurrent+5]=this.uo_dateend
this.Control[iCurrent+6]=this.st_6
this.Control[iCurrent+7]=this.sle_s_model
this.Control[iCurrent+8]=this.st_5
this.Control[iCurrent+9]=this.sle_s_pack
this.Control[iCurrent+10]=this.rb_cross
this.Control[iCurrent+11]=this.gb_1
this.Control[iCurrent+12]=this.gb_2
end on

on w_prd_product_fg_issue_rpt.destroy
call super::destroy
destroy(this.rb_detail)
destroy(this.rb_sum)
destroy(this.uo_dateset)
destroy(this.st_7)
destroy(this.uo_dateend)
destroy(this.st_6)
destroy(this.sle_s_model)
destroy(this.st_5)
destroy(this.sle_s_pack)
destroy(this.rb_cross)
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

         	if rb_detail.checked = true then 

			        DW_1.RESET( )
			        DW_1.RETRIEVE( uo_dateset.text(), uo_dateend.text(),   '%' + sle_s_model.text + '%' , '%' + sle_s_pack.text + '%'  )
			
	  	    elseif rb_sum.checked = true then 
			
			        DW_2.RESET( )
			        DW_2.RETRIEVE( uo_dateset.text(), uo_dateend.text(),   '%' + sle_s_model.text + '%' , '%' + sle_s_pack.text + '%'  )
			
		   else
				  DW_3.RESET( )
			       DW_3.RETRIEVE( uo_dateset.text(), uo_dateend.text(),   '%' + sle_s_model.text + '%'  )
		   end if 
			
     CASE ELSE
		
END CHOOSE
end event

type dw_5 from w_main_root`dw_5 within w_prd_product_fg_issue_rpt
integer y = 392
end type

type dw_4 from w_main_root`dw_4 within w_prd_product_fg_issue_rpt
integer y = 392
boolean titlebar = true
end type

type dw_3 from w_main_root`dw_3 within w_prd_product_fg_issue_rpt
integer y = 392
boolean titlebar = true
string title = "by Date"
string dataobject = "d_product_fg_issue_cross_rpt"
boolean controlmenu = true
boolean minbox = true
end type

type dw_2 from w_main_root`dw_2 within w_prd_product_fg_issue_rpt
integer y = 392
integer width = 3662
integer height = 1356
boolean titlebar = true
string title = "Issue Summay"
string dataobject = "d_product_fg_issue_sum_rpt"
boolean controlmenu = true
boolean minbox = true
end type

type dw_1 from w_main_root`dw_1 within w_prd_product_fg_issue_rpt
integer y = 392
integer width = 3662
integer height = 1356
boolean titlebar = true
string title = "Issue Report"
string dataobject = "d_product_fg_issue_detail_rpt"
boolean controlmenu = true
boolean minbox = true
end type

event dw_1::rbuttondown;call super::rbuttondown;if row < 1 then return

if dwo.name = 'lv_ng_qty' then 

//	openwithparm( w_qc_lv_ng_popup , string(this.object.run_no[row] ))
	
end if 
end event

type uo_tabpages from w_main_root`uo_tabpages within w_prd_product_fg_issue_rpt
end type

type rb_detail from so_radiobutton within w_prd_product_fg_issue_rpt
integer x = 105
integer y = 100
boolean bringtotop = true
string text = "Detail"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true
selected_data_window = dw_1
end event

type rb_sum from so_radiobutton within w_prd_product_fg_issue_rpt
integer x = 105
integer y = 188
boolean bringtotop = true
string text = "Summary"
end type

event clicked;call super::clicked;dw_2.bringtotop = true
selected_data_window = dw_2
end event

type uo_dateset from uo_ymd_calendar within w_prd_product_fg_issue_rpt
integer x = 768
integer y = 232
integer taborder = 40
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type st_7 from statictext within w_prd_product_fg_issue_rpt
integer x = 800
integer y = 152
integer width = 782
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = " Issue Date"
alignment alignment = center!
long bordercolor = 8421504
boolean focusrectangle = false
end type

type uo_dateend from uo_ymd_calendar within w_prd_product_fg_issue_rpt
integer x = 1193
integer y = 232
integer taborder = 50
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_6 from statictext within w_prd_product_fg_issue_rpt
integer x = 1655
integer y = 152
integer width = 535
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Model"
long bordercolor = 8421504
boolean focusrectangle = false
end type

type sle_s_model from so_singlelineedit within w_prd_product_fg_issue_rpt
integer x = 1641
integer y = 228
integer width = 590
integer height = 92
integer taborder = 60
boolean bringtotop = true
integer weight = 700
end type

type st_5 from statictext within w_prd_product_fg_issue_rpt
integer x = 2295
integer y = 148
integer width = 672
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Barcode"
long bordercolor = 8421504
boolean focusrectangle = false
end type

type sle_s_pack from so_singlelineedit within w_prd_product_fg_issue_rpt
integer x = 2272
integer y = 228
integer width = 933
integer height = 92
integer taborder = 70
boolean bringtotop = true
integer weight = 700
end type

event getfocus;call super::getfocus;long HMC, VL
HMC = ImmGetContext( handle(parent) )

VL = ImmSetConversionStatus(  HMC, 0, 0)

ImmReleaseContext( HMC, VL) 


this.selecttext (1, 100)
end event

event modified;call super::modified;f_retrieve()
end event

event ue_editchange;call super::ue_editchange;long HMC, VL
HMC = ImmGetContext( handle(parent) )

VL = ImmSetConversionStatus(  HMC, 0, 0)

ImmReleaseContext( HMC, VL) 
end event

type rb_cross from so_radiobutton within w_prd_product_fg_issue_rpt
integer x = 105
integer y = 276
boolean bringtotop = true
string text = "by Day"
end type

event clicked;call super::clicked;dw_3.bringtotop = true
selected_data_window = dw_3
end event

type gb_1 from so_groupbox within w_prd_product_fg_issue_rpt
integer x = 18
integer y = 16
integer width = 663
integer height = 364
integer taborder = 80
string text = "Category"
end type

type gb_2 from so_groupbox within w_prd_product_fg_issue_rpt
integer x = 713
integer y = 12
integer width = 3977
integer height = 364
integer taborder = 90
string text = "Where Condition"
end type

