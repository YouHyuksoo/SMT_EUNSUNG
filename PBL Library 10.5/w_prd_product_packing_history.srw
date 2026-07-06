HA$PBExportHeader$w_prd_product_packing_history.srw
$PBExportComments$CELL BIZ Packing $$HEX2$$91c7c5c5$$ENDHEX$$
forward
global type w_prd_product_packing_history from w_main_root
end type
type sle_s_pack from so_singlelineedit within w_prd_product_packing_history
end type
type sle_serial_no from so_singlelineedit within w_prd_product_packing_history
end type
type st_5 from statictext within w_prd_product_packing_history
end type
type st_6 from statictext within w_prd_product_packing_history
end type
type uo_dateset from uo_ymd_calendar within w_prd_product_packing_history
end type
type uo_dateend from uo_ymd_calendar within w_prd_product_packing_history
end type
type st_7 from statictext within w_prd_product_packing_history
end type
type gb_3 from so_groupbox within w_prd_product_packing_history
end type
end forward

global type w_prd_product_packing_history from w_main_root
integer width = 5920
integer height = 2380
string title = "Product Packing Hisory"
long backcolor = 16777215
string ivs_modify_security = "N"
string ivs_dw_1_use_focusindicator = "N"
sle_s_pack sle_s_pack
sle_serial_no sle_serial_no
st_5 st_5
st_6 st_6
uo_dateset uo_dateset
uo_dateend uo_dateend
st_7 st_7
gb_3 gb_3
end type
global w_prd_product_packing_history w_prd_product_packing_history

type prototypes


end prototypes

type variables
String IVS_MODEL_PREFIX
//$$HEX3$$04d6acc72000$$ENDHEX$$Pack $$HEX9$$c4c989d5200011c978c72000a8ba78b32000$$ENDHEX$$
String IVS_CURRENT_PACK_MODEL 
string IVS_CURRNET_PACK_BARCODE
//$$HEX11$$a5c730aeacc7e0ac200055d678c72000eccefcb72000$$ENDHEX$$
string IVS_CURRENT_PACK_LONGTERM
//$$HEX3$$04d6acc72000$$ENDHEX$$Pack $$HEX5$$1cb4200018c2c9b72000$$ENDHEX$$
long IVL_PACK_QTY
//$$HEX7$$04d6acc72000a8ba78b358c72000$$ENDHEX$$Pack $$HEX3$$18c2c9b72000$$ENDHEX$$
long IVL_PACK_UNIT_QTY
//
STRING IVS_LINE_CODE, IVS_WORkstage_code
end variables

on w_prd_product_packing_history.create
int iCurrent
call super::create
this.sle_s_pack=create sle_s_pack
this.sle_serial_no=create sle_serial_no
this.st_5=create st_5
this.st_6=create st_6
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.st_7=create st_7
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_s_pack
this.Control[iCurrent+2]=this.sle_serial_no
this.Control[iCurrent+3]=this.st_5
this.Control[iCurrent+4]=this.st_6
this.Control[iCurrent+5]=this.uo_dateset
this.Control[iCurrent+6]=this.uo_dateend
this.Control[iCurrent+7]=this.st_7
this.Control[iCurrent+8]=this.gb_3
end on

on w_prd_product_packing_history.destroy
call super::destroy
destroy(this.sle_s_pack)
destroy(this.sle_serial_no)
destroy(this.st_5)
destroy(this.st_6)
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.st_7)
destroy(this.gb_3)
end on

event activate;call super::activate;/***************************************
* Window Default Property 
****************************************/
Gst_set.window_id            = this.classname() 
Gst_set.author                  = "JiSheng"
Gst_set.creation_date      = '20170310'
Gst_set.last_modify_date = '20170310'
Gst_set.Report_window    = False  // Report Window  True / Flase

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
*  Menu Property
*****************************************
* ADMIN  ( All Control )
* MANAGE ( Manager )
* GUEST  ( Only Query )
* QUERY  ( Only Query  )
* DATA_CONTROL  ( Insert Delete Update )
* REPORT ( Report )
****************************************/
F_MENU_CONTROL('RETRIEVE' , TRUE)  // All Data Control




end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
uo_dateset.settext(string(f_v_sysdate(3),'yyyy/mm/dd'))

end event

event ue_data_control;call super::ue_data_control;
CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
	
			DW_1.RETRIEVE(  uo_dateset.text(), uo_dateend.text(),  '%' + sle_s_pack.text + '%', '%' + sle_serial_no.text + '%' , gvi_organization_id  )
	
	CASE ELSE
END CHOOSE
end event

type dw_5 from w_main_root`dw_5 within w_prd_product_packing_history
integer y = 292
integer width = 919
integer height = 496
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_prd_product_packing_history
integer y = 292
integer width = 919
integer height = 496
integer taborder = 0
end type

type dw_3 from w_main_root`dw_3 within w_prd_product_packing_history
integer y = 292
integer width = 919
integer height = 496
integer taborder = 0
end type

type dw_2 from w_main_root`dw_2 within w_prd_product_packing_history
integer y = 292
integer width = 919
integer height = 496
integer taborder = 0
borderstyle borderstyle = stylebox!
end type

type dw_1 from w_main_root`dw_1 within w_prd_product_packing_history
integer y = 292
integer width = 4855
integer height = 1972
integer taborder = 0
boolean titlebar = true
string dataobject = "d_prd_cell_biz_pack_serial_hisory"
borderstyle borderstyle = stylebox!
end type

type uo_tabpages from w_main_root`uo_tabpages within w_prd_product_packing_history
integer taborder = 0
end type

type sle_s_pack from so_singlelineedit within w_prd_product_packing_history
integer x = 18
integer y = 140
integer width = 855
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer weight = 700
end type

event ue_editchange;call super::ue_editchange;long HMC, VL
HMC = ImmGetContext( handle(parent) )

VL = ImmSetConversionStatus(  HMC, 0, 0)

ImmReleaseContext( HMC, VL) 
end event

event getfocus;call super::getfocus;long HMC, VL
HMC = ImmGetContext( handle(parent) )

VL = ImmSetConversionStatus(  HMC, 0, 0)

ImmReleaseContext( HMC, VL) 
end event

type sle_serial_no from so_singlelineedit within w_prd_product_packing_history
integer x = 882
integer y = 140
integer width = 553
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer weight = 700
end type

type st_5 from statictext within w_prd_product_packing_history
integer x = 18
integer y = 60
integer width = 855
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
string text = "Pack Barcode"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_6 from statictext within w_prd_product_packing_history
integer x = 882
integer y = 64
integer width = 553
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
string text = "Serial No"
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_dateset from uo_ymd_calendar within w_prd_product_packing_history
integer x = 1449
integer y = 144
integer taborder = 50
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_prd_product_packing_history
integer x = 1874
integer y = 144
integer taborder = 60
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_7 from statictext within w_prd_product_packing_history
integer x = 1481
integer y = 68
integer width = 782
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
string text = "Packing Date"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_3 from so_groupbox within w_prd_product_packing_history
integer y = 4
integer width = 2350
integer height = 276
integer taborder = 20
integer weight = 700
long textcolor = 16711680
long backcolor = 16777215
string text = "Search Condition"
end type

