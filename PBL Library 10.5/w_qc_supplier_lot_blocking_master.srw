HA$PBExportHeader$w_qc_supplier_lot_blocking_master.srw
$PBExportComments$$$HEX9$$acc7e0ac200040d629b500adacb90d000a00$$ENDHEX$$forward
global type w_qc_supplier_lot_blocking_master from w_main_root
end type
type st_27 from so_statictext within w_qc_supplier_lot_blocking_master
end type
type sle_vendor_lotno from so_singlelineedit within w_qc_supplier_lot_blocking_master
end type
type uo_item from uo_item_code within w_qc_supplier_lot_blocking_master
end type
type st_5 from so_statictext within w_qc_supplier_lot_blocking_master
end type
type ddlb_model_name from uo_smt_model_name_ddlb within w_qc_supplier_lot_blocking_master
end type
type st_1 from so_statictext within w_qc_supplier_lot_blocking_master
end type
type st_2 from statictext within w_qc_supplier_lot_blocking_master
end type
type gb_1 from so_groupbox within w_qc_supplier_lot_blocking_master
end type
type gb_2 from so_groupbox within w_qc_supplier_lot_blocking_master
end type
end forward

global type w_qc_supplier_lot_blocking_master from w_main_root
integer width = 5737
integer height = 2840
string title = "OQC Inspect Query"
string ivs_dw_4_use_focusindicator = "Y"
st_27 st_27
sle_vendor_lotno sle_vendor_lotno
uo_item uo_item
st_5 st_5
ddlb_model_name ddlb_model_name
st_1 st_1
st_2 st_2
gb_1 gb_1
gb_2 gb_2
end type
global w_qc_supplier_lot_blocking_master w_qc_supplier_lot_blocking_master

type variables
string lvs_current_array_type
end variables

on w_qc_supplier_lot_blocking_master.create
int iCurrent
call super::create
this.st_27=create st_27
this.sle_vendor_lotno=create sle_vendor_lotno
this.uo_item=create uo_item
this.st_5=create st_5
this.ddlb_model_name=create ddlb_model_name
this.st_1=create st_1
this.st_2=create st_2
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_27
this.Control[iCurrent+2]=this.sle_vendor_lotno
this.Control[iCurrent+3]=this.uo_item
this.Control[iCurrent+4]=this.st_5
this.Control[iCurrent+5]=this.ddlb_model_name
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.gb_1
this.Control[iCurrent+9]=this.gb_2
end on

on w_qc_supplier_lot_blocking_master.destroy
call super::destroy
destroy(this.st_27)
destroy(this.sle_vendor_lotno)
destroy(this.uo_item)
destroy(this.st_5)
destroy(this.ddlb_model_name)
destroy(this.st_1)
destroy(this.st_2)
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
F_MENU_CONTROL('DATA_CONTROL' ,TRUE)  // All Data Control





end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX17$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c80d000a00$$ENDHEX$$*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

event ue_data_control;call super::ue_data_control;LONG row
datetime ld_date

choose case gvs_ue_data_control
		
	case 'RETRIEVE'
		
				dw_1.reset()
				dw_1.retrieve(  ddlb_model_name.getcode( )+'%' ,   uo_item.text()+'%' , sle_vendor_lotno.text+'%' ,  gvi_organization_id )	
		
	CASE	'INSERT'

			DW_1.ENABLED = TRUE
			ROW = DW_1.INSERTROW(0)
			DW_1.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_1 , ROW ,'ALL')

	CASE	'APPEND'

			DW_1.ENABLED = TRUE
			ROW = DW_1.INSERTROW(0)
			DW_1.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_1 , ROW ,'ALL')
			
	CASE	'DELETE'
	
			if DW_1.AcceptText() = -1 then
				return
			end if
			
			MSG = F_MSGBOX(1003)  //$$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?
			IF MSG = 1 THEN
				Gvl_row_deleted = DW_1.GetRow()			
				DW_1.DELETEROW(Gvl_row_deleted)		
				DW_1.SetFocus()
				ROW = DW_1.GetRow()
				DW_1.ScrollToRow(row)
				DW_1.SetColumn(1)
			END IF
			
			
	case 'UPDATE'

				if dw_1.update()	 < 0 then 
					rollback;
				else
					commit ;
				end if 
				f_msg_st(170)

	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_qc_supplier_lot_blocking_master
integer y = 344
integer width = 4242
integer height = 1504
integer taborder = 0
boolean titlebar = true
string title = "Packing Summary"
boolean maxbox = false
end type

type dw_4 from w_main_root`dw_4 within w_qc_supplier_lot_blocking_master
integer y = 344
integer width = 4242
integer height = 1504
integer taborder = 0
boolean titlebar = true
end type

type dw_3 from w_main_root`dw_3 within w_qc_supplier_lot_blocking_master
integer y = 344
integer width = 4242
integer height = 1504
integer taborder = 0
boolean titlebar = true
boolean maxbox = false
boolean border = false
end type

type dw_2 from w_main_root`dw_2 within w_qc_supplier_lot_blocking_master
integer y = 344
integer width = 4242
integer height = 1504
integer taborder = 0
boolean titlebar = true
end type

event dw_2::updateend;//override
end event

event dw_2::updatestart;//override
end event

type dw_1 from w_main_root`dw_1 within w_qc_supplier_lot_blocking_master
integer y = 344
integer width = 4242
integer height = 1504
integer taborder = 0
boolean titlebar = true
string dataobject = "d_qc_supplier_lot_blocking_lst"
end type

event dw_1::rbuttondown;call super::rbuttondown;if dwo.name = 'item_code' then 
	
	open( w_des_item_popup ) 
	
	if Gst_return.Gvb_return = true then 
		
		this.object.item_code[row] = message.stringparm
		
	else
		return 
	end if 
	
end if 
end event

type uo_tabpages from w_main_root`uo_tabpages within w_qc_supplier_lot_blocking_master
integer taborder = 0
end type

type st_27 from so_statictext within w_qc_supplier_lot_blocking_master
integer x = 2103
integer y = 108
integer width = 617
integer height = 56
boolean bringtotop = true
string text = "Vondor LotNo"
end type

type sle_vendor_lotno from so_singlelineedit within w_qc_supplier_lot_blocking_master
integer x = 2103
integer y = 184
integer width = 617
integer height = 88
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
textcase textcase = upper!
end type

type uo_item from uo_item_code within w_qc_supplier_lot_blocking_master
integer x = 1518
integer y = 184
integer width = 581
integer height = 764
integer taborder = 40
boolean bringtotop = true
end type

event modified;call super::modified;f_retrieve()
end event

type st_5 from so_statictext within w_qc_supplier_lot_blocking_master
integer x = 1518
integer y = 108
integer width = 581
integer height = 56
boolean bringtotop = true
boolean enabled = false
string text = "Item Code"
end type

type ddlb_model_name from uo_smt_model_name_ddlb within w_qc_supplier_lot_blocking_master
integer x = 745
integer y = 184
integer width = 763
integer height = 1492
integer taborder = 50
boolean bringtotop = true
end type

type st_1 from so_statictext within w_qc_supplier_lot_blocking_master
integer x = 750
integer y = 108
integer width = 763
integer height = 56
boolean bringtotop = true
boolean enabled = false
string text = "Model Name"
end type

type st_2 from statictext within w_qc_supplier_lot_blocking_master
integer x = 2802
integer y = 48
integer width = 1737
integer height = 268
boolean bringtotop = true
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 255
long backcolor = 12632256
string text = "$$HEX3$$fcc858c72000$$ENDHEX$$: $$HEX42$$74d5f9b2a8ba78b3d0c5ccb9200001c8a9c618b494b220002000a4bc54b320006fb8b8d2200088bc38d67cb9200014bc54cfdcb47cb92000a4c294ce74d51cc1200055d678c7c4d62000f1b45db858d538c194c6$$ENDHEX$$"
boolean focusrectangle = false
end type

type gb_1 from so_groupbox within w_qc_supplier_lot_blocking_master
integer x = 713
integer y = 4
integer width = 2057
integer height = 328
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_qc_supplier_lot_blocking_master
integer width = 699
integer height = 328
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

