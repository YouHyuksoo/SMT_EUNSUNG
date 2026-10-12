HA$PBExportHeader$w_product_assy_label_print.srw
$PBExportComments$2$$HEX2$$35ce2000$$ENDHEX$$assy $$HEX5$$7cb7a8bc20001cbc89d5$$ENDHEX$$
forward
global type w_product_assy_label_print from w_main_root
end type
type cb_2 from so_commandbutton within w_product_assy_label_print
end type
type cb_3 from so_commandbutton within w_product_assy_label_print
end type
type sle_run_no from so_singlelineedit within w_product_assy_label_print
end type
type st_6 from so_statictext within w_product_assy_label_print
end type
type ddlb_model_name from uo_set_model_name_ddlb within w_product_assy_label_print
end type
type st_2 from so_statictext within w_product_assy_label_print
end type
type ddlb_line_code from uo_line_code within w_product_assy_label_print
end type
type st_line_code from so_statictext within w_product_assy_label_print
end type
type uo_dateset from uo_ymd_calendar within w_product_assy_label_print
end type
type uo_dateend from uo_ymd_calendar within w_product_assy_label_print
end type
type st_1 from so_statictext within w_product_assy_label_print
end type
type sle_pack_charger from so_singlelineedit within w_product_assy_label_print
end type
type sle_qc_charger from so_singlelineedit within w_product_assy_label_print
end type
type sle_cart_in_qty from so_singlelineedit within w_product_assy_label_print
end type
type sle_print_page_qty from so_singlelineedit within w_product_assy_label_print
end type
type st_3 from statictext within w_product_assy_label_print
end type
type st_4 from statictext within w_product_assy_label_print
end type
type st_5 from statictext within w_product_assy_label_print
end type
type st_7 from statictext within w_product_assy_label_print
end type
type st_8 from statictext within w_product_assy_label_print
end type
type sle_pint_lot_size from so_singlelineedit within w_product_assy_label_print
end type
type st_9 from statictext within w_product_assy_label_print
end type
type sle_print_model from so_singlelineedit within w_product_assy_label_print
end type
type gb_5 from so_groupbox within w_product_assy_label_print
end type
type sle_print_run_no from so_singlelineedit within w_product_assy_label_print
end type
type st_status from so_statictext within w_product_assy_label_print
end type
type st_10 from so_statictext within w_product_assy_label_print
end type
type sle_label_cancel from so_singlelineedit within w_product_assy_label_print
end type
type gb_1 from so_groupbox within w_product_assy_label_print
end type
end forward

global type w_product_assy_label_print from w_main_root
string tag = "Label Master"
integer width = 6368
integer height = 2928
string title = "2nd Assy Packing Label Print"
string ivs_dw_2_selected_row_yn = "Y"
cb_2 cb_2
cb_3 cb_3
sle_run_no sle_run_no
st_6 st_6
ddlb_model_name ddlb_model_name
st_2 st_2
ddlb_line_code ddlb_line_code
st_line_code st_line_code
uo_dateset uo_dateset
uo_dateend uo_dateend
st_1 st_1
sle_pack_charger sle_pack_charger
sle_qc_charger sle_qc_charger
sle_cart_in_qty sle_cart_in_qty
sle_print_page_qty sle_print_page_qty
st_3 st_3
st_4 st_4
st_5 st_5
st_7 st_7
st_8 st_8
sle_pint_lot_size sle_pint_lot_size
st_9 st_9
sle_print_model sle_print_model
gb_5 gb_5
sle_print_run_no sle_print_run_no
st_status st_status
st_10 st_10
sle_label_cancel sle_label_cancel
gb_1 gb_1
end type
global w_product_assy_label_print w_product_assy_label_print

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
//$$HEX6$$04d6acc7a8ba78b358c72000$$ENDHEX$$Tray $$HEX5$$e8b204c718c2c9b72000$$ENDHEX$$
long ivl_PACKING_TRAY_BOX_QTY
//$$HEX3$$04d6acc72000$$ENDHEX$$Tary $$HEX3$$18c2c9b72000$$ENDHEX$$
long ivl_tray_qty 

STRING IVS_LINE_CODE, IVS_WORkstage_code , ivs_pack_charger , ivs_qc_pack_charger, ivs_run_no
end variables

forward prototypes
public subroutine wf_print (string arg_type)
public function string wf_get_cell_biz_barcode (string arg_model, string arg_suffix, string arg_item_code)
public subroutine wf_init ()
end prototypes

public subroutine wf_print (string arg_type);// $$HEX12$$9ccd25b8200000ad28b8200055d678c744c7200058d5e0ac$$ENDHEX$$
//
// arg_type  'SCAN'  -- $$HEX22$$28d3b9d0200018c2c9b744c7200044cce0c644c74cb520009ccd25b8200068d52000a4c294cedcc2d0c52000$$ENDHEX$$, 
//               'MANUAL'  $$HEX35$$ecd3a5c7200098ccacb92000c4b311c9200028d3b9d0200018c2c9b744c7200044ccb0c6c0c92000bbba58d5e0ac20009ccd25b844c7200060d52000bdacb0c6200020002000$$ENDHEX$$
// ivl_pack_unit_qty $$HEX6$$ecd3a5c72000e8b204c72000$$ENDHEX$$
// ivl_pack_qty $$HEX9$$04d6acc72000ecd3a5c7200018c2c9b72000$$ENDHEX$$
long i 

//if ivs_current_pack_model = 'EMPTY' then 
//	f_msg('$$HEX20$$04d6acc72000ecd3a5c791c7c5c574c72000c4c989d5200011c974c7c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$','P') 
//	return 
//end if 

if arg_type = 'SCAN' then 

	if ivl_pack_unit_qty  >  ivl_pack_qty then 
		return
	end if
	
else
	
	
	if ivl_pack_unit_qty  <>  ivl_pack_qty then 
		f_Play_sound("$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav")
		f_msg('$$HEX27$$ecd3a5c71cb42000e8b204c7200018c2c9b7fcac2000a4c294ce200018c2c9b774c77cc758ce200058d5c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$.','P')
		return
	end if

	
	if ivl_pack_qty = 0 then 
		f_msg('$$HEX18$$ecd3a5c71cb4200018c2c9b774c7200074c8acc7200058d5c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$.','P')
		return 
	end if
	
	//if messagebox('$$HEX2$$55d678c7$$ENDHEX$$',' $$HEX14$$ecd3a5c72000e8b204c700ac2000deb9c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$. $$HEX20$$ecd3a5c720007cb7a8bc20009ccd25b844c72000c4c989d5200058d5dcc2a0acb5c2c8b24cae2000$$ENDHEX$$? ' ,Question!, OKCancel!, 1 ) <> 1 then
//	if f_msgbox(9301) <> 1 then 
//		return 
//	end if 
	
end if 
//*************************************************
// $$HEX11$$ecd3a5c77cb7a8bc200015c8f4bc200085c725b82000$$ENDHEX$$
//*************************************************

if IVS_CURRNET_PACK_BARCODE = '' or IVS_CURRNET_PACK_BARCODE='EMPTY' then 
	
	f_msg("$$HEX16$$9ccd25b860d5200014bc54cfdcb47cb920004cc518c22000c6c5b5c2c8b2e4b2$$ENDHEX$$" , "P")
	return
	
end if 

//*************************************
// $$HEX3$$74d5f9b22000$$ENDHEX$$Packing $$HEX9$$91c7c5c5200044c6ccb8200098ccacb92000$$ENDHEX$$
//*************************************

Update Ip_Product_Pack_Master x
      set x.complete_flag = 'C', 
	      x.print_flag        = 'Y' , 
		  x.pack_qty        =  :IVL_PACK_QTY,
		 x.attr7               = :ivs_pack_charger,
		 x.attr8               = :ivs_qc_pack_charger,
		 x.run_no           = :ivs_run_no
 where pack_barcode   = :IVS_CURRNET_PACK_BARCODE ; 
 
 if f_sql_check() < 0 then
	st_status.text = f_msg('Error : Complete Packing', 'S') 
	rollback ; 
	return 
end if 

commit ; 

//=========================================
// $$HEX3$$9ccd25b82000$$ENDHEX$$
//=========================================
 f_play_sound( "apply.wav") 
 
 gst_return.gvl_return[1]  = 1 // $$HEX4$$9ccd25b8a5c718c2$$ENDHEX$$
 openwithparm( w_com_bartneder_form_popup_auto , IVS_CURRNET_PACK_BARCODE ) 

 wf_init() 
	
	
end subroutine

public function string wf_get_cell_biz_barcode (string arg_model, string arg_suffix, string arg_item_code);string lvs_barcode,  lvs_marking_condition

//============================================
// Cell Biz Barcode Create 
// $$HEX37$$14bc54cfdcb4200048c5d0c52000ecd3a5c7e8b204c7200018c2c9b744c7200023b1b4c51cc12000ddc031c174d57cc5200074d51cc12000e8b204c7200018c2c9b7200018b140ae2000$$ENDHEX$$
//++++++++++++++++++++++++++++++++++++++++++++++++++


select marking_condition
  into :lvs_marking_condition
  from ip_product_model_master
 where model_name = :arg_model
    and rownum = 1;
 
if f_sql_check() < 0 then
	return 'ERROR'
end if 

if ( lvs_marking_condition = 'T' ) then
 
      select F_GET_CREATE_CELLBIZ_BARCODE_N(:arg_model, :arg_suffix, :arg_item_code, trunc(sysdate), :ivs_line_code, :IVS_WORkstage_code , :IVL_PACK_UNIT_QTY, :ivs_run_no) 
        into :lvs_barcode 
      from dual ;
		
else
		
     select F_GET_CREATE_CELLBIZ_BARCODE(:arg_model, :arg_suffix, :arg_item_code, trunc(sysdate), :ivs_line_code, :IVS_WORkstage_code , :IVL_PACK_UNIT_QTY) 
        into :lvs_barcode 
      from dual ;
 
end if

 
if f_sql_check() < 0 then
	return 'ERROR'
else 
	return lvs_barcode 
end if 

end function

public subroutine wf_init ();//=========================
// $$HEX4$$08cd30ae54d62000$$ENDHEX$$
//=========================
IVS_MODEL_PREFIX = ''
IVS_CURRENT_PACK_MODEL = 'EMPTY'
IVS_CURRNET_PACK_BARCODE = 'EMPTY'
IVS_CURRENT_PACK_LONGTERM = 'N'
IVL_PACK_QTY = 0 
IVL_PACK_UNIT_QTY = 0 
//2018.05.12 $$HEX3$$94cd00ac2000$$ENDHEX$$
IVL_PACKING_TRAY_BOX_QTY = 0 
IVL_TRAY_QTY = 0 


//sle_model.text = ''
//em_pack_unit.text = '0' 
//em_count.text = '0' 
//em_tray_qty.text = '0'
//em_tray_unit_qty.text = '0'

st_status.text = ''

//mle_log.text = ''
//rb_pack.enabled = true 
//dw_1.reset()
//dw_2.reset() 
end subroutine

on w_product_assy_label_print.create
int iCurrent
call super::create
this.cb_2=create cb_2
this.cb_3=create cb_3
this.sle_run_no=create sle_run_no
this.st_6=create st_6
this.ddlb_model_name=create ddlb_model_name
this.st_2=create st_2
this.ddlb_line_code=create ddlb_line_code
this.st_line_code=create st_line_code
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.st_1=create st_1
this.sle_pack_charger=create sle_pack_charger
this.sle_qc_charger=create sle_qc_charger
this.sle_cart_in_qty=create sle_cart_in_qty
this.sle_print_page_qty=create sle_print_page_qty
this.st_3=create st_3
this.st_4=create st_4
this.st_5=create st_5
this.st_7=create st_7
this.st_8=create st_8
this.sle_pint_lot_size=create sle_pint_lot_size
this.st_9=create st_9
this.sle_print_model=create sle_print_model
this.gb_5=create gb_5
this.sle_print_run_no=create sle_print_run_no
this.st_status=create st_status
this.st_10=create st_10
this.sle_label_cancel=create sle_label_cancel
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.cb_3
this.Control[iCurrent+3]=this.sle_run_no
this.Control[iCurrent+4]=this.st_6
this.Control[iCurrent+5]=this.ddlb_model_name
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.ddlb_line_code
this.Control[iCurrent+8]=this.st_line_code
this.Control[iCurrent+9]=this.uo_dateset
this.Control[iCurrent+10]=this.uo_dateend
this.Control[iCurrent+11]=this.st_1
this.Control[iCurrent+12]=this.sle_pack_charger
this.Control[iCurrent+13]=this.sle_qc_charger
this.Control[iCurrent+14]=this.sle_cart_in_qty
this.Control[iCurrent+15]=this.sle_print_page_qty
this.Control[iCurrent+16]=this.st_3
this.Control[iCurrent+17]=this.st_4
this.Control[iCurrent+18]=this.st_5
this.Control[iCurrent+19]=this.st_7
this.Control[iCurrent+20]=this.st_8
this.Control[iCurrent+21]=this.sle_pint_lot_size
this.Control[iCurrent+22]=this.st_9
this.Control[iCurrent+23]=this.sle_print_model
this.Control[iCurrent+24]=this.gb_5
this.Control[iCurrent+25]=this.sle_print_run_no
this.Control[iCurrent+26]=this.st_status
this.Control[iCurrent+27]=this.st_10
this.Control[iCurrent+28]=this.sle_label_cancel
this.Control[iCurrent+29]=this.gb_1
end on

on w_product_assy_label_print.destroy
call super::destroy
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.sle_run_no)
destroy(this.st_6)
destroy(this.ddlb_model_name)
destroy(this.st_2)
destroy(this.ddlb_line_code)
destroy(this.st_line_code)
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.st_1)
destroy(this.sle_pack_charger)
destroy(this.sle_qc_charger)
destroy(this.sle_cart_in_qty)
destroy(this.sle_print_page_qty)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.st_7)
destroy(this.st_8)
destroy(this.sle_pint_lot_size)
destroy(this.st_9)
destroy(this.sle_print_model)
destroy(this.gb_5)
destroy(this.sle_print_run_no)
destroy(this.st_status)
destroy(this.st_10)
destroy(this.sle_label_cancel)
destroy(this.gb_1)
end on

event activate;call super::activate;/***************************************
* Window Default Property 
****************************************/
Gst_set.window_id            = this.classname() 
Gst_set.author                  = "JiSheng"
Gst_set.creation_date      = '20051101'
Gst_set.last_modify_date = '20051101'
Gst_set.Report_window    = False  // Report Window  True / Flase

/*****************************************
* Data Window Property
******************************************/
Ivs_resize_type                      = 'MASTER_DETAIL_12T'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


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

    F_MENU_CONTROL('QUERY' , TRUE)  // All Data Control

//=============================================




end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

event ue_data_control;call super::ue_data_control;long row
choose case gvs_ue_data_control
		
		case 'RETRIEVE'
			    dw_1.reset()
			    dw_1.retrieve(uo_dateset.text(), uo_dateend.text(), ddlb_line_code.getcode()+'%', ddlb_model_name.getcode() , sle_run_no.text + '%', gvi_organization_id)		
	case else
		
end choose


end event

event resize;call super::resize;
st_status.width = newwidth //dw_1.width + dw_2.width
end event

type dw_5 from w_main_root`dw_5 within w_product_assy_label_print
integer y = 1120
integer height = 1160
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_product_assy_label_print
integer y = 1120
integer height = 1160
integer taborder = 0
end type

type dw_3 from w_main_root`dw_3 within w_product_assy_label_print
integer x = 9
integer y = 1120
integer width = 2482
integer height = 1160
integer taborder = 0
end type

type dw_2 from w_main_root`dw_2 within w_product_assy_label_print
integer x = 2784
integer y = 1120
integer width = 2775
integer height = 1160
integer taborder = 0
boolean titlebar = true
string title = "Print history"
string dataobject = "d_product_assy_label_print_history_list2"
end type

type dw_1 from w_main_root`dw_1 within w_product_assy_label_print
integer y = 1120
integer width = 2779
integer height = 1160
integer taborder = 0
boolean titlebar = true
string title = "Run Card list"
string dataobject = "d_product_assy_label_print_runcard_list"
end type

event dw_1::clicked;call super::clicked;if row < 1 then 
	return
end if
end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 

sle_print_run_no.text = dw_1.object.run_no[currentrow]
sle_print_model.text  = dw_1.object.model_name[currentrow]
sle_pint_lot_size.text = string(dw_1.object.lot_size[currentrow] - dw_1.object.print_qty[currentrow])
sle_cart_in_qty.text   = string(dw_1.object.cart_in_qty[currentrow])

if ( dw_1.object.cart_in_qty[currentrow] > 0 and (dw_1.object.lot_size[currentrow] - dw_1.object.print_qty[currentrow] > 0) ) then
     //sle_print_page_qty.text = string( ceiling((dw_1.object.lot_size[currentrow] - dw_1.object.print_qty[currentrow] ) / dw_1.object.cart_in_qty[currentrow]) )
	sle_print_page_qty.text = '1'  
else
	sle_print_page_qty.text = '0'
end if

dw_2.reset()
dw_2.retrieve(dw_1.object.run_no[currentrow], gvi_organization_id)		
end event

type uo_tabpages from w_main_root`uo_tabpages within w_product_assy_label_print
integer taborder = 0
end type

type cb_2 from so_commandbutton within w_product_assy_label_print
integer x = 3698
integer y = 440
integer width = 690
integer height = 392
integer taborder = 50
boolean bringtotop = true
integer textsize = -20
string text = "$$HEX4$$7cb7a8bc9ccd25b8$$ENDHEX$$"
end type

event clicked;call super::clicked;
string      lvs_line_code, lvs_workstage_code, lvs_run_no, lvs_model_name, lvs_model_suffix, lvs_pack_barcode, lvs_item_code
string      lvs_v1,  lvs_v2, lvs_v3, lvs_v4, lvs_v5, lvs_v6, lvs_v7, lvs_v8, lvs_v9
string      lvs_pack_charger, lvs_qc_charger
long        lvl_row, lvl_lot_size,  lvl_cart_in_qty, lvl_page_qty, lvl_pack_qty, lvl_remain_qty, lvl_remain_page

datetime lvdt_pack_date; 

lvl_row = dw_1.getrow()

if lvl_row < 1 then return

//========================================
// $$HEX3$$9ccd25b82000$$ENDHEX$$lot $$HEX5$$15c8f4bc200055d678c7$$ENDHEX$$
//========================================

IVS_LINE_CODE           = dw_1.object.line_code[lvl_row]
IVS_WORkstage_code  = '*'

ivs_run_no                  = dw_1.object.run_no[lvl_row]
lvs_model_name         = dw_1.object.model_name[lvl_row]
lvs_model_suffix          = '*'
lvs_item_code             = dw_1.object.item_code[lvl_row]
lvs_pack_barcode        = '*'

ivs_pack_charger        = sle_pack_charger.text

if len(ivs_pack_charger) < 1 then
	st_status.text = f_msg('$$HEX14$$ecd3a5c7200080acacc090c77cb9200085c725b8200058d538c194c6$$ENDHEX$$', 'S')
	sle_pack_charger.setfocus()
	return
end if

ivs_qc_pack_charger   = sle_qc_charger.text

if len(ivs_qc_pack_charger) < 1 then
	st_status.text = f_msg('$$HEX14$$9ccd58d5200080acacc090c77cb9200085c725b8200058d538c194c6$$ENDHEX$$', 'S')
	sle_qc_charger.setfocus()
	return	
end if

lvl_lot_size   = long(sle_pint_lot_size.text)

if lvl_lot_size < 1 then
	st_status.text = f_msg('$$HEX5$$9ccd25b8200060d52000$$ENDHEX$$lot $$HEX11$$58c7200018c2c9b744c7200055d678c758d538c194c6$$ENDHEX$$', 'S')
	sle_pint_lot_size.setfocus()
	return	
end if

lvl_cart_in_qty = long(sle_cart_in_qty.text)

if lvl_cart_in_qty < 1 then
	st_status.text = f_msg('$$HEX5$$9ccd25b8200060d52000$$ENDHEX$$lot $$HEX13$$58c72000a5c785c718c2c9b744c7200055d678c758d538c194c6$$ENDHEX$$', 'S')
	sle_cart_in_qty.setfocus()
	return	
end if

lvl_page_qty = long(sle_print_page_qty.text)

if lvl_page_qty < 1 then
	st_status.text = f_msg('$$HEX5$$9ccd25b8200060d52000$$ENDHEX$$lot $$HEX13$$58c720009ccd25b8a5c718c244c7200055d678c758d538c194c6$$ENDHEX$$', 'S')
	sle_print_page_qty.setfocus()
	return	
end if

//========================================
// $$HEX8$$74c725b844c7200000c8a5c75cd5e4b2$$ENDHEX$$
//========================================

lvl_remain_qty   = lvl_lot_size
lvl_remain_page = lvl_page_qty

do
	    
		 st_status.text =  f_msg('$$HEX7$$7cb7a8bc9ccd25b8200044be11c9$$ENDHEX$$..', 'S')
	 
	    IF ( lvl_remain_qty < lvl_cart_in_qty ) THEN
			 lvl_pack_qty = lvl_remain_qty
		ELSE
			 lvl_pack_qty = lvl_cart_in_qty
		END IF
		
		IVL_PACK_UNIT_QTY = lvl_pack_qty
		IVL_PACK_QTY          = lvl_pack_qty
	
//		INSERT INTO IP_PRODUCT_PACK_ASSY_MASTER ( 
//									                                           pack_date,
//                                                                                    line_code,
//                                                                                    workstage_code,
//                                                                                    run_no,
//                                                                                    model_name,
//                                                                                    pack_qty,
//                                                                                    pack_barcode,
//																            pack_charger,
//																		   qc_charger,
//                                                                                    V1,  V2,  V3, V4 , V5, V6, V7, V8, V9,
//                                                                                    enter_date,
//                                                                                    enter_by,
//                                                                                    last_modify_date,
//                                                                                    last_modify_by,
//                                                                                    organization_id
//									                                         )  
//						                                          VALUES (  
//																		  sysdate,
//																		  :IVS_LINE_CODE,
//																		  :IVS_WORkstage_code,
//																		  :ivs_run_no,
//																		  :lvs_model_name,
//																		  :lvl_pack_qty,
//																		  :lvs_pack_barcode,
//																		  :ivs_pack_charger,
//																		  :ivs_qc_pack_charger,
//																		  :lvs_v1, :lvs_v2, :lvs_v3, :lvs_v4, :lvs_v5, :lvs_v6, :lvs_v7, :lvs_v8,  :lvs_v9,
//								                                               sysdate,       
//									                                          :gvs_user_id,
//									                                           sysdate ,       
//								                                               :gvs_user_id,
//											                                 :gvi_organization_id
//									                                        ) ;
//							
//		IF F_SQL_CHECK() < 0 THEN 
//			RETURN 
//		END IF  	
//
//      COMMIT;

	//4.1 $$HEX4$$e0c2dcad5cb82000$$ENDHEX$$Pack barcode $$HEX7$$7cb9200044cc88bc20005cd5e4b2$$ENDHEX$$.
	//      $$HEX18$$ecd3a5c7200088bc38d694b22000a8ba50b42000b4cc88bcfcac2000d9b3dcc2d0c52000$$ENDHEX$$Master $$HEX8$$d0c5200000c8a5c774c720001cb4e4b2$$ENDHEX$$. 
	IVS_CURRNET_PACK_BARCODE = wf_get_cell_biz_barcode( lvs_model_name, lvs_model_suffix, lvs_item_code) 	
	
	if IVS_CURRNET_PACK_BARCODE = 'ERROR' then 
		
		//============================================
		//Messagebox('$$HEX2$$55d678c7$$ENDHEX$$',' $$HEX27$$28d3b9d0200014bc54cfdcb42000b4cc88bc2000d0c5ecb7200030ae08cd15c8f4bc2000f1b444c7200055d678c7200058d538c194c6$$ENDHEX$$') 
		//============================================	
		f_play_sound( "$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav") //$$HEX3$$e4c228d32000$$ENDHEX$$
		
	//	st_status.text = f_msg_st1(199  ,f_get_dual_lang_text ( gvs_language , 'PACK BARCODE')  )   
	//	f_msgbox1(199  ,f_get_dual_lang_text ( gvs_language , 'PACK BARCODE') )
		
		f_msg('$$HEX12$$28d3b9d0200014bc54cfdcb42000b4cc88bc2000d0c5ecb7$$ENDHEX$$, $$HEX14$$30ae08cd15c8f4bc2000f1b444c7200055d678c7200058d538c194c6$$ENDHEX$$', 'P')
		 
		rollback ; // 20180124 $$HEX3$$94cd00ac2000$$ENDHEX$$
		return 
		
	end if
	
		
	//=====================================
	// $$HEX8$$7cb7a8bc44c720009ccd25b85cd5e4b2$$ENDHEX$$
	//=====================================
	
	  st_status.text = IVS_CURRNET_PACK_BARCODE + ' : ' + f_msg('$$HEX7$$7cb7a8bc20001cbc89d5200011c9$$ENDHEX$$..', 'S')
	  
	  wf_print('SCAN')    
		 
	  lvl_remain_qty    = lvl_remain_qty - lvl_pack_qty
       lvl_remain_page = lvl_remain_page -1

loop WHILE ( lvl_remain_qty > 0 and lvl_remain_page > 0 )

COMMIT;

//========================================

st_status.text = "$$HEX5$$1cbc89d5200044c6ccb8$$ENDHEX$$"

//dw_1.reset()
//dw_1.retrieve(uo_dateset.text(), uo_dateend.text(), ddlb_line_code.getcode()+'%', ddlb_model_name.getcode() , sle_run_no.text + '%', gvi_organization_id)		
				 
end event

type cb_3 from so_commandbutton within w_product_assy_label_print
integer x = 4475
integer y = 440
integer width = 690
integer height = 392
integer taborder = 60
boolean bringtotop = true
integer textsize = -20
string text = "$$HEX3$$acc79ccd25b8$$ENDHEX$$"
end type

event clicked;call super::clicked;
string lvs_pack_barcode

if dw_2.getrow() < 1 then return

lvs_pack_barcode = dw_2.object.pack_barcode[dw_2.getrow()] 

st_status.text = lvs_pack_barcode + ' : ' + f_msg('$$HEX7$$7cb7a8bc20001cbc89d5200011c9$$ENDHEX$$..', 'S')

 gst_return.gvl_return[1]  = 1 // $$HEX4$$9ccd25b8a5c718c2$$ENDHEX$$
 openwithparm( w_com_bartneder_form_popup_auto , lvs_pack_barcode ) 
 
 st_status.text = "$$HEX6$$acc71cbc89d5200044c6ccb8$$ENDHEX$$"

end event

type sle_run_no from so_singlelineedit within w_product_assy_label_print
integer x = 2779
integer y = 172
integer width = 571
integer height = 92
integer taborder = 50
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
end type

type st_6 from so_statictext within w_product_assy_label_print
integer x = 2779
integer y = 88
integer width = 571
integer height = 64
boolean bringtotop = true
long textcolor = 0
string text = "Run No"
end type

type ddlb_model_name from uo_set_model_name_ddlb within w_product_assy_label_print
integer x = 1573
integer y = 176
integer width = 1175
integer height = 1900
integer taborder = 60
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
boolean autohscroll = true
end type

type st_2 from so_statictext within w_product_assy_label_print
integer x = 1573
integer y = 84
integer width = 1175
boolean bringtotop = true
long textcolor = 0
string text = "Model Name"
end type

type ddlb_line_code from uo_line_code within w_product_assy_label_print
integer x = 1001
integer y = 176
integer width = 544
integer taborder = 70
boolean bringtotop = true
long backcolor = 16777215
end type

type st_line_code from so_statictext within w_product_assy_label_print
integer x = 1001
integer y = 88
integer width = 544
boolean bringtotop = true
long textcolor = 0
string text = "Line Code"
end type

type uo_dateset from uo_ymd_calendar within w_product_assy_label_print
event destroy ( )
integer x = 119
integer y = 176
integer taborder = 80
boolean bringtotop = true
long backcolor = 12632256
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_product_assy_label_print
event destroy ( )
integer x = 539
integer y = 176
integer taborder = 90
boolean bringtotop = true
long backcolor = 12632256
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_1 from so_statictext within w_product_assy_label_print
integer x = 133
integer y = 92
integer width = 818
boolean bringtotop = true
long textcolor = 0
string text = "Plan Date"
end type

type sle_pack_charger from so_singlelineedit within w_product_assy_label_print
integer x = 741
integer y = 548
integer width = 626
integer height = 156
integer taborder = 60
boolean bringtotop = true
integer textsize = -20
integer weight = 700
long backcolor = 16777215
end type

event modified;call super::modified;
sle_qc_charger.setfocus()
end event

type sle_qc_charger from so_singlelineedit within w_product_assy_label_print
integer x = 741
integer y = 720
integer width = 626
integer height = 156
integer taborder = 70
boolean bringtotop = true
integer textsize = -20
integer weight = 700
long backcolor = 16777215
end type

type sle_cart_in_qty from so_singlelineedit within w_product_assy_label_print
integer x = 3026
integer y = 548
integer width = 489
integer height = 156
integer taborder = 70
boolean bringtotop = true
integer textsize = -20
integer weight = 700
long backcolor = 12639424
end type

event modified;call super::modified;//
//if ( long(sle_cart_in_qty.text) > 0 and long(sle_pint_lot_size.text) > 0 ) then
//    sle_print_page_qty.text = string( ceiling(long(sle_pint_lot_size.text) / long(sle_cart_in_qty.text))  )
//else
//    sle_print_page_qty.text = '0'
//end if
end event

type sle_print_page_qty from so_singlelineedit within w_product_assy_label_print
integer x = 3026
integer y = 720
integer width = 489
integer height = 156
integer taborder = 80
boolean bringtotop = true
integer textsize = -20
integer weight = 700
long backcolor = 12639424
end type

type st_3 from statictext within w_product_assy_label_print
integer x = 137
integer y = 556
integer width = 571
integer height = 156
boolean bringtotop = true
integer textsize = -20
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
string text = "$$HEX6$$ecd3a5c7200080acacc090c7$$ENDHEX$$"
boolean focusrectangle = false
end type

type st_4 from statictext within w_product_assy_label_print
integer x = 137
integer y = 728
integer width = 571
integer height = 156
boolean bringtotop = true
integer textsize = -20
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
string text = "$$HEX6$$9ccd58d5200080acacc090c7$$ENDHEX$$"
boolean focusrectangle = false
end type

type st_5 from statictext within w_product_assy_label_print
integer x = 2555
integer y = 728
integer width = 434
integer height = 156
boolean bringtotop = true
integer textsize = -20
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
string text = "$$HEX4$$9ccd25b8a5c718c2$$ENDHEX$$"
boolean focusrectangle = false
end type

type st_7 from statictext within w_product_assy_label_print
integer x = 2555
integer y = 556
integer width = 434
integer height = 156
boolean bringtotop = true
integer textsize = -20
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
string text = "$$HEX4$$a5c785c718c2c9b7$$ENDHEX$$"
boolean focusrectangle = false
end type

type st_8 from statictext within w_product_assy_label_print
integer x = 1463
integer y = 556
integer width = 434
integer height = 156
boolean bringtotop = true
integer textsize = -20
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
string text = "$$HEX4$$ecd3a5c718c2c9b7$$ENDHEX$$"
boolean focusrectangle = false
end type

type sle_pint_lot_size from so_singlelineedit within w_product_assy_label_print
integer x = 1934
integer y = 544
integer width = 489
integer height = 156
integer taborder = 80
boolean bringtotop = true
integer textsize = -20
integer weight = 700
long backcolor = 12632256
boolean displayonly = true
end type

type st_9 from statictext within w_product_assy_label_print
integer x = 137
integer y = 372
integer width = 549
integer height = 156
boolean bringtotop = true
integer textsize = -20
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
string text = "$$HEX2$$a8ba78b3$$ENDHEX$$"
boolean focusrectangle = false
end type

type sle_print_model from so_singlelineedit within w_product_assy_label_print
integer x = 741
integer y = 368
integer width = 2779
integer height = 156
integer taborder = 70
boolean bringtotop = true
integer textsize = -20
integer weight = 700
long backcolor = 65535
boolean displayonly = true
end type

type gb_5 from so_groupbox within w_product_assy_label_print
integer x = 3502
integer y = 4
integer width = 2057
integer height = 304
integer taborder = 20
integer weight = 700
long textcolor = 255
end type

type sle_print_run_no from so_singlelineedit within w_product_assy_label_print
boolean visible = false
integer x = 695
integer y = 1464
integer width = 1166
integer height = 156
integer taborder = 80
integer textsize = -20
integer weight = 700
long backcolor = 65535
boolean displayonly = true
end type

type st_status from so_statictext within w_product_assy_label_print
integer x = 5
integer y = 924
integer width = 5403
integer height = 176
boolean bringtotop = true
integer textsize = -20
integer weight = 700
long textcolor = 65280
long backcolor = 0
string text = "Message"
boolean border = true
end type

type st_10 from so_statictext within w_product_assy_label_print
integer x = 3547
integer y = 136
integer width = 329
integer height = 64
boolean bringtotop = true
integer textsize = -12
integer weight = 700
long textcolor = 255
string text = "$$HEX4$$7cb7a8bce8cd8cc1$$ENDHEX$$"
end type

type sle_label_cancel from so_singlelineedit within w_product_assy_label_print
integer x = 3881
integer y = 120
integer width = 1595
integer height = 108
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 700
long backcolor = 16777215
end type

event getfocus;call super::getfocus;
//this.selecttext(1, 100)
end event

event modified;call super::modified;
string lvs_barcode, lvs_condition
long   lvl_return

lvs_barcode = this.text


//********************************************************
// $$HEX10$$7cb7a8bc1cbc89d52000ecc580bd200055d678c7$$ENDHEX$$
//********************************************************

   select count(*), max(F_GET_MODEL_MARKING_CONDITION(model_name, organization_id))
     into :lvl_return, :lvs_condition
    from IP_PRODUCT_PACK_MASTER
 where  pack_barcode   = :lvs_barcode
	 and organization_id = :GVI_ORGANIZATION_ID;
	 
if ( lvl_return = 0 ) then
	
	// $$HEX4$$1cbc89d5c1c0dcd0$$ENDHEX$$
     st_status.text = f_msg('$$HEX22$$a4c294ce20001cb420007cb7a8bc40c720009ccd25b820001cb4200074c725b874c72000c6c5b5c2c8b2e4b2$$ENDHEX$$', 'S')
	  
	 this.text = ''
	this.setfocus()
	return
	
end if	 

if ( lvs_condition <> 'Y' ) then
	
	// $$HEX4$$1cbc89d5c1c0dcd0$$ENDHEX$$
     st_status.text = f_msg('$$HEX24$$7cb7a8bc1cbc89d52000e8cd8cc194b22000a8ba78b32000c8b9a4c2c0d0d0c5200000b35cd414bc54cfdcb400ac2000$$ENDHEX$$Y $$HEX8$$ccb9200000aca5b2200069d5c8b2e4b2$$ENDHEX$$', 'S')
	  
	 this.text = ''
	this.setfocus()
	return
	
end if	 

//********************************************************
// $$HEX8$$85c7e0ac2000ecc580bd200055d678c7$$ENDHEX$$
//********************************************************

select count(*)
   into :lvl_return
 from ip_product_fg_receipt
where barcode      = :lvs_barcode
   and txn_deficit    = '1'
   and receipt_date = (
                                select max(receipt_date)
                                 from ip_product_fg_receipt
                               where barcode           = :lvs_barcode
				        	        and organization_id = :GVI_ORGANIZATION_ID
                             ) 
   and organization_id = :GVI_ORGANIZATION_ID;
	
	
if ( lvl_return > 0 ) then
	
	// $$HEX4$$85c7e0acc1c0dcd0$$ENDHEX$$
	st_status.text = f_msg('$$HEX21$$a4c294ce20001cb420007cb7a8bc40c720003dcce0acd0c5200085c7e0acc1c0dcd0200085c7c8b2e4b2$$ENDHEX$$', 'S')
	
     this.text = ''
	this.setfocus()
	
	return
	
end if

//********************************************************
// $$HEX8$$9ccde0ac2000ecc580bd200055d678c7$$ENDHEX$$
//********************************************************

select count(*)
   into :lvl_return
 from ip_product_fg_issue
where barcode    = :lvs_barcode
   and txn_deficit  = '3'
   and issue_date = (
                                select max(issue_date)
                                 from ip_product_fg_issue
                               where barcode           = :lvs_barcode
				        	        and organization_id = :GVI_ORGANIZATION_ID
                             ) 
   and organization_id = :GVI_ORGANIZATION_ID;
	
	
if ( lvl_return > 0 ) then
	
	// $$HEX4$$85c7e0acc1c0dcd0$$ENDHEX$$
	st_status.text = f_msg('$$HEX24$$a4c294ce20001cb420007cb7a8bc40c720003dcce0acd0c51cc120009ccde0ac1cb42000c1c0dcd0200085c7c8b2e4b2$$ENDHEX$$', 'S')
   
	this.text = ''
	this.setfocus()
	
	return
	
end if

//********************************************************
// $$HEX5$$7cb7a8bcadc01cc82000$$ENDHEX$$
//********************************************************

 delete IP_PRODUCT_PACK_MASTER
 where pack_barcode   = :lvs_barcode
     and organization_id = :GVI_ORGANIZATION_ID;
	 
 delete ip_product_fg_receipt
 where barcode           = :lvs_barcode
    and organization_id = :GVI_ORGANIZATION_ID;
	 
 delete ip_product_fg_issue
 where barcode           = :lvs_barcode
    and organization_id = :GVI_ORGANIZATION_ID;	 
	 
commit;

// $$HEX7$$7cb7a8bc15c8f4bc2000adc01cc8$$ENDHEX$$
st_status.text = f_msg('$$HEX17$$a4c294ce20001cb420007cb7a8bc74c72000e8cd8cc1200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$', 'S')

this.text = ''
this.setfocus()
	

end event

type gb_1 from so_groupbox within w_product_assy_label_print
integer x = 5
integer y = 4
integer width = 3465
integer height = 304
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

