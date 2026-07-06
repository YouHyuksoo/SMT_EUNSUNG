HA$PBExportHeader$w_prd_product_packing_4_magazine_create_master.srw
$PBExportComments$$$HEX17$$b9c278c7d0c658c7a8ba78b3d0c5200000b35cd52000b9d231c144c7200000adacb9$$ENDHEX$$
forward
global type w_prd_product_packing_4_magazine_create_master from w_main_root
end type
type sle_model_name from so_singlelineedit within w_prd_product_packing_4_magazine_create_master
end type
type st_mrm_no from so_statictext within w_prd_product_packing_4_magazine_create_master
end type
type rb_2 from so_radiobutton within w_prd_product_packing_4_magazine_create_master
end type
type st_4 from so_statictext within w_prd_product_packing_4_magazine_create_master
end type
type uo_dateset from uo_ymd_calendar within w_prd_product_packing_4_magazine_create_master
end type
type uo_dateend from uo_ymd_calendar within w_prd_product_packing_4_magazine_create_master
end type
type sle_magazine_label_cond from so_singlelineedit within w_prd_product_packing_4_magazine_create_master
end type
type st_5 from so_statictext within w_prd_product_packing_4_magazine_create_master
end type
type cb_merge from so_commandbutton within w_prd_product_packing_4_magazine_create_master
end type
type sle_magazine_no_merge from so_singlelineedit within w_prd_product_packing_4_magazine_create_master
end type
type st_3 from so_statictext within w_prd_product_packing_4_magazine_create_master
end type
type rb_lot_generate from so_radiobutton within w_prd_product_packing_4_magazine_create_master
end type
type sle_week from so_singlelineedit within w_prd_product_packing_4_magazine_create_master
end type
type st_6 from so_statictext within w_prd_product_packing_4_magazine_create_master
end type
type sle_assy_week from so_singlelineedit within w_prd_product_packing_4_magazine_create_master
end type
type st_8 from so_statictext within w_prd_product_packing_4_magazine_create_master
end type
type sle_note from so_singlelineedit within w_prd_product_packing_4_magazine_create_master
end type
type st_9 from so_statictext within w_prd_product_packing_4_magazine_create_master
end type
type sle_pack_barcode from so_singlelineedit within w_prd_product_packing_4_magazine_create_master
end type
type st_10 from so_statictext within w_prd_product_packing_4_magazine_create_master
end type
type sle_model_name_merge from so_singlelineedit within w_prd_product_packing_4_magazine_create_master
end type
type st_11 from so_statictext within w_prd_product_packing_4_magazine_create_master
end type
type em_qty from so_editmask within w_prd_product_packing_4_magazine_create_master
end type
type st_12 from so_statictext within w_prd_product_packing_4_magazine_create_master
end type
type cbx_auto_print from so_checkbox within w_prd_product_packing_4_magazine_create_master
end type
type uo_delivery_date from uo_ymd_calendar within w_prd_product_packing_4_magazine_create_master
end type
type st_14 from so_statictext within w_prd_product_packing_4_magazine_create_master
end type
type ddlb_workstage_code from uo_workstage_code_all within w_prd_product_packing_4_magazine_create_master
end type
type st_13 from so_statictext within w_prd_product_packing_4_magazine_create_master
end type
type sle_fpc_revision from so_singlelineedit within w_prd_product_packing_4_magazine_create_master
end type
type st_1 from so_statictext within w_prd_product_packing_4_magazine_create_master
end type
type cbx_unpack from so_checkbox within w_prd_product_packing_4_magazine_create_master
end type
type sle_unpack_barcode from so_singlelineedit within w_prd_product_packing_4_magazine_create_master
end type
type st_status from so_statictext within w_prd_product_packing_4_magazine_create_master
end type
type cbx_sound_on from so_checkbox within w_prd_product_packing_4_magazine_create_master
end type
type cb_1 from commandbutton within w_prd_product_packing_4_magazine_create_master
end type
type em_print_count from so_editmask within w_prd_product_packing_4_magazine_create_master
end type
type st_2 from so_statictext within w_prd_product_packing_4_magazine_create_master
end type
type gb_1 from so_groupbox within w_prd_product_packing_4_magazine_create_master
end type
type gb_2 from so_groupbox within w_prd_product_packing_4_magazine_create_master
end type
type gb_4 from so_groupbox within w_prd_product_packing_4_magazine_create_master
end type
type gb_6 from so_groupbox within w_prd_product_packing_4_magazine_create_master
end type
end forward

global type w_prd_product_packing_4_magazine_create_master from w_main_root
string tag = "w_prd_product_packing_4_magazine_create_master"
integer width = 6089
integer height = 3492
string title = "Product Magazine Packing Master"
string ivs_modify_security = "N"
string ivs_dw_2_selected_row_yn = "Y"
string ivs_dw_3_selected_row_yn = "Y"
sle_model_name sle_model_name
st_mrm_no st_mrm_no
rb_2 rb_2
st_4 st_4
uo_dateset uo_dateset
uo_dateend uo_dateend
sle_magazine_label_cond sle_magazine_label_cond
st_5 st_5
cb_merge cb_merge
sle_magazine_no_merge sle_magazine_no_merge
st_3 st_3
rb_lot_generate rb_lot_generate
sle_week sle_week
st_6 st_6
sle_assy_week sle_assy_week
st_8 st_8
sle_note sle_note
st_9 st_9
sle_pack_barcode sle_pack_barcode
st_10 st_10
sle_model_name_merge sle_model_name_merge
st_11 st_11
em_qty em_qty
st_12 st_12
cbx_auto_print cbx_auto_print
uo_delivery_date uo_delivery_date
st_14 st_14
ddlb_workstage_code ddlb_workstage_code
st_13 st_13
sle_fpc_revision sle_fpc_revision
st_1 st_1
cbx_unpack cbx_unpack
sle_unpack_barcode sle_unpack_barcode
st_status st_status
cbx_sound_on cbx_sound_on
cb_1 cb_1
em_print_count em_print_count
st_2 st_2
gb_1 gb_1
gb_2 gb_2
gb_4 gb_4
gb_6 gb_6
end type
global w_prd_product_packing_4_magazine_create_master w_prd_product_packing_4_magazine_create_master

type variables
long lvi_row
string IVS_WORkstage_code
end variables

forward prototypes
public function string wf_unpacking (string arg_pack_barcode)
end prototypes

public function string wf_unpacking (string arg_pack_barcode);//$$HEX6$$28d3b9d0200074d5b4cc2000$$ENDHEX$$( Un - Packing ) $$HEX2$$68d52000$$ENDHEX$$
//$$HEX3$$70c874ac2000$$ENDHEX$$
string lvs_out , lvs_outmsg
lvs_out = space(4000)
lvs_outmsg = space(4000)

//OUT $$HEX8$$c0bc18c294b2200048c5f0c40cc92000$$ENDHEX$$fETCH $$HEX2$$d0c51cc1$$ENDHEX$$
// p_ui_cell_biz_unpacking  $$HEX10$$94b22000c5b3bdb9200038c158c13cc75cb82000$$ENDHEX$$Commit / Rollback $$HEX7$$18b4b4c5200018b1b4c534c62000$$ENDHEX$$
declare proc procedure for p_ui_cell_biz_unpacking ( :arg_pack_barcode  ) 
using sqlca ; 

execute proc ; 
fetch proc into :lvs_out, :lvs_outmsg ; 
close proc ; 

if f_sql_check() < 0 then
	return 'ERR'
end if 

if lvs_out = 'NG' then 
	//$$HEX22$$b4c5a4b52000d0c678c73cc75cb82000adc01cc8200058d5c0c92000bbba58d5e0ac2000acb934d128b42000$$ENDHEX$$
	//$$HEX8$$d0c678c7200054badcc2c0c994b22000$$ENDHEX$$lvs_outmsg 	
	f_play_mp3("shibai.mp3")//
	messagebox('Un-Packing Failed', lvs_outmsg ) 
end if 

st_status.text = lvs_outmsg 
return lvs_out
end function

on w_prd_product_packing_4_magazine_create_master.create
int iCurrent
call super::create
this.sle_model_name=create sle_model_name
this.st_mrm_no=create st_mrm_no
this.rb_2=create rb_2
this.st_4=create st_4
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.sle_magazine_label_cond=create sle_magazine_label_cond
this.st_5=create st_5
this.cb_merge=create cb_merge
this.sle_magazine_no_merge=create sle_magazine_no_merge
this.st_3=create st_3
this.rb_lot_generate=create rb_lot_generate
this.sle_week=create sle_week
this.st_6=create st_6
this.sle_assy_week=create sle_assy_week
this.st_8=create st_8
this.sle_note=create sle_note
this.st_9=create st_9
this.sle_pack_barcode=create sle_pack_barcode
this.st_10=create st_10
this.sle_model_name_merge=create sle_model_name_merge
this.st_11=create st_11
this.em_qty=create em_qty
this.st_12=create st_12
this.cbx_auto_print=create cbx_auto_print
this.uo_delivery_date=create uo_delivery_date
this.st_14=create st_14
this.ddlb_workstage_code=create ddlb_workstage_code
this.st_13=create st_13
this.sle_fpc_revision=create sle_fpc_revision
this.st_1=create st_1
this.cbx_unpack=create cbx_unpack
this.sle_unpack_barcode=create sle_unpack_barcode
this.st_status=create st_status
this.cbx_sound_on=create cbx_sound_on
this.cb_1=create cb_1
this.em_print_count=create em_print_count
this.st_2=create st_2
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_4=create gb_4
this.gb_6=create gb_6
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_model_name
this.Control[iCurrent+2]=this.st_mrm_no
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.uo_dateset
this.Control[iCurrent+6]=this.uo_dateend
this.Control[iCurrent+7]=this.sle_magazine_label_cond
this.Control[iCurrent+8]=this.st_5
this.Control[iCurrent+9]=this.cb_merge
this.Control[iCurrent+10]=this.sle_magazine_no_merge
this.Control[iCurrent+11]=this.st_3
this.Control[iCurrent+12]=this.rb_lot_generate
this.Control[iCurrent+13]=this.sle_week
this.Control[iCurrent+14]=this.st_6
this.Control[iCurrent+15]=this.sle_assy_week
this.Control[iCurrent+16]=this.st_8
this.Control[iCurrent+17]=this.sle_note
this.Control[iCurrent+18]=this.st_9
this.Control[iCurrent+19]=this.sle_pack_barcode
this.Control[iCurrent+20]=this.st_10
this.Control[iCurrent+21]=this.sle_model_name_merge
this.Control[iCurrent+22]=this.st_11
this.Control[iCurrent+23]=this.em_qty
this.Control[iCurrent+24]=this.st_12
this.Control[iCurrent+25]=this.cbx_auto_print
this.Control[iCurrent+26]=this.uo_delivery_date
this.Control[iCurrent+27]=this.st_14
this.Control[iCurrent+28]=this.ddlb_workstage_code
this.Control[iCurrent+29]=this.st_13
this.Control[iCurrent+30]=this.sle_fpc_revision
this.Control[iCurrent+31]=this.st_1
this.Control[iCurrent+32]=this.cbx_unpack
this.Control[iCurrent+33]=this.sle_unpack_barcode
this.Control[iCurrent+34]=this.st_status
this.Control[iCurrent+35]=this.cbx_sound_on
this.Control[iCurrent+36]=this.cb_1
this.Control[iCurrent+37]=this.em_print_count
this.Control[iCurrent+38]=this.st_2
this.Control[iCurrent+39]=this.gb_1
this.Control[iCurrent+40]=this.gb_2
this.Control[iCurrent+41]=this.gb_4
this.Control[iCurrent+42]=this.gb_6
end on

on w_prd_product_packing_4_magazine_create_master.destroy
call super::destroy
destroy(this.sle_model_name)
destroy(this.st_mrm_no)
destroy(this.rb_2)
destroy(this.st_4)
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.sle_magazine_label_cond)
destroy(this.st_5)
destroy(this.cb_merge)
destroy(this.sle_magazine_no_merge)
destroy(this.st_3)
destroy(this.rb_lot_generate)
destroy(this.sle_week)
destroy(this.st_6)
destroy(this.sle_assy_week)
destroy(this.st_8)
destroy(this.sle_note)
destroy(this.st_9)
destroy(this.sle_pack_barcode)
destroy(this.st_10)
destroy(this.sle_model_name_merge)
destroy(this.st_11)
destroy(this.em_qty)
destroy(this.st_12)
destroy(this.cbx_auto_print)
destroy(this.uo_delivery_date)
destroy(this.st_14)
destroy(this.ddlb_workstage_code)
destroy(this.st_13)
destroy(this.sle_fpc_revision)
destroy(this.st_1)
destroy(this.cbx_unpack)
destroy(this.sle_unpack_barcode)
destroy(this.st_status)
destroy(this.cbx_sound_on)
destroy(this.cb_1)
destroy(this.em_print_count)
destroy(this.st_2)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_4)
destroy(this.gb_6)
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
//F_MENU_CONTROL('DATA_CONTROL' , TRUE)  // All Data Control
F_MENU_CONTROL('RETRIEVE' , TRUE)  // All Data Control





end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
st_status.width = dw_1.width 



//====================================
// $$HEX22$$acb9ecd3b8d2200000adacb9d0c52000f1b45db818b4b4c5200088c73cc774ba200014bcd4af00c9e4b22000$$ENDHEX$$
//====================================

STRING ls_syntax

ls_syntax	=	f_get_dataobject('REPORT', upper(THIS.CLASSNAME()) ,  string( dw_3.dataobject )	)
if	ls_syntax = '' or isnull(ls_syntax) then
	f_msg_mdi_help("Report Not Changed")
else
	dw_3.create(ls_syntax)
	dw_3.settransobject(sqlca)
	f_set_column_dddw(dw_3)
	f_dual_lang_change_dwtext(dw_3)
	f_msg_mdi_help("Report Changed")
end if	


//====================================
// $$HEX22$$acb9ecd3b8d2200000adacb9d0c52000f1b45db818b4b4c5200088c73cc774ba200014bcd4af00c9e4b22000$$ENDHEX$$
//====================================
ls_syntax	=	f_get_dataobject('REPORT', upper(THIS.CLASSNAME()) ,  string( dw_4.dataobject )	)
if	ls_syntax = '' or isnull(ls_syntax) then
	f_msg_mdi_help("Report Not Changed")
else
	dw_4.create(ls_syntax)
	dw_4.settransobject(sqlca)
	f_set_column_dddw(dw_4)
	f_dual_lang_change_dwtext(dw_4)
	f_msg_mdi_help("Report Changed")
end if	
end event

event ue_data_control;call super::ue_data_control;choose case gvs_ue_data_control
		
	case 'RETRIEVE'
		
		
	    if rb_lot_generate.checked = true then 
			
			dw_1.retrieve( sle_magazine_label_cond.text+'%' , sle_model_name.text + '%' ,  uo_dateset.text() , uo_dateend.text() )
		else
			dw_2.retrieve( sle_magazine_label_cond.text+'%' , sle_model_name.text + '%' ,  uo_dateset.text() , uo_dateend.text() )
		end if 
//	CASE 'INSERT'
//	
//			lvi_row = dw_1.insertrow(dw_1.getrow())
//			dw_1.scrolltorow(lvi_row)
//			f_set_security_row(dw_1 , lvi_row , 'ALL')
//			F_MSG_MDI_HELP ( F_MSG_ST(152)	 )
//			
//	CASE 'APPEND'
//	
//			lvi_row = dw_1.insertrow(0)
//			dw_1.scrolltorow(lvi_row)
//			f_set_security_row(dw_1 , lvi_row , 'ALL')
//			F_MSG_MDI_HELP ( F_MSG_ST(152)	 )	
//			
//	case 'DELETE'
//		
//		  	if dw_1.getrow() < 1 then return 
//			  
//			msg =f_msgbox(1003)
//			if msg = 1 then
//				gvl_row_deleted = dw_1.getrow()			
//				dw_1.deleterow(gvl_row_deleted)		
//				dw_1.setfocus()
//				lvi_row = dw_1.getrow()
//				dw_1.scrolltorow(lvi_row)
//				dw_1.setcolumn(1)
//			end if
//			
//	case 'UPDATE'
//		
//			if dw_1.update() < 0 OR  dw_2.update() < 0 then
//				rollback;
//			else
//				commit;
//				f_msg_mdi_help(f_msg_st(170))
//			end if
			
	case else
end choose


end event

type dw_5 from w_main_root`dw_5 within w_prd_product_packing_4_magazine_create_master
integer x = 242
integer y = 1376
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_prd_product_packing_4_magazine_create_master
integer y = 1120
integer width = 5106
integer height = 1740
integer taborder = 0
boolean titlebar = true
string title = "Lot Label"
string dataobject = "d_pln_product_magazine_delivery_label_rpt"
end type

type dw_3 from w_main_root`dw_3 within w_prd_product_packing_4_magazine_create_master
integer y = 1120
integer width = 5106
integer height = 1740
integer taborder = 0
boolean titlebar = true
end type

type dw_2 from w_main_root`dw_2 within w_prd_product_packing_4_magazine_create_master
integer y = 1120
integer width = 5106
integer height = 1736
integer taborder = 0
boolean titlebar = true
string title = "Summary"
string dataobject = "d_prd_cell_biz_pack_4_oqc_sum_lst"
end type

type dw_1 from w_main_root`dw_1 within w_prd_product_packing_4_magazine_create_master
integer y = 1120
integer width = 5106
integer height = 1740
integer taborder = 0
boolean titlebar = true
string title = "Manage"
string dataobject = "d_prd_cell_biz_pack_4_oqc_master"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_prd_product_packing_4_magazine_create_master
integer taborder = 0
end type

type sle_model_name from so_singlelineedit within w_prd_product_packing_4_magazine_create_master
integer x = 2574
integer y = 188
integer width = 699
boolean bringtotop = true
textcase textcase = upper!
end type

event getfocus;call super::getfocus;this.selecttext( 1,100)
end event

type st_mrm_no from so_statictext within w_prd_product_packing_4_magazine_create_master
integer x = 2574
integer y = 112
integer width = 699
integer height = 72
boolean bringtotop = true
string text = "Model Name"
end type

type rb_2 from so_radiobutton within w_prd_product_packing_4_magazine_create_master
integer x = 46
integer y = 208
integer width = 549
boolean bringtotop = true
string text = "Lot Packing Summary"
end type

event clicked;call super::clicked;dw_2.bringtotop = true 
selected_data_window = dw_2
end event

type st_4 from so_statictext within w_prd_product_packing_4_magazine_create_master
integer x = 3291
integer y = 112
integer width = 814
integer height = 68
boolean bringtotop = true
string text = "Date"
end type

type uo_dateset from uo_ymd_calendar within w_prd_product_packing_4_magazine_create_master
event destroy ( )
integer x = 3287
integer y = 188
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_prd_product_packing_4_magazine_create_master
event destroy ( )
integer x = 3703
integer y = 188
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type sle_magazine_label_cond from so_singlelineedit within w_prd_product_packing_4_magazine_create_master
integer x = 1504
integer y = 188
integer width = 1051
boolean bringtotop = true
textcase textcase = upper!
end type

event getfocus;call super::getfocus;this.selecttext( 1,100)
end event

type st_5 from so_statictext within w_prd_product_packing_4_magazine_create_master
integer x = 1504
integer y = 112
integer width = 1051
integer height = 72
boolean bringtotop = true
long textcolor = 0
string text = "Pack Barcode"
end type

type cb_merge from so_commandbutton within w_prd_product_packing_4_magazine_create_master
integer x = 2853
integer y = 924
integer width = 521
integer height = 148
boolean bringtotop = true
string text = "Generate"
end type

event clicked;call super::clicked;string lvs_magazine_no , lvs_item_code  , lvs_fpc_revision , LVS_MODEL_NAME , lvs_model_suffix , lvs_barcode , lvs_line_code , lvs_runno , lvs_note , lvs_week , lvs_assy_week , lvs_revision , lvs_workstage_code
long lvi_exists , lvl_count , lvl_lot_qty
datetime lvdt_delivery_date

lvs_magazine_no = sle_magazine_no_merge.text
lvs_note = sle_note.text
lvs_week = sle_week.text
lvs_assy_week = sle_assy_week.text 
lvs_revision = '1' 
lvdt_delivery_date = uo_delivery_date.text()
lvl_lot_qty = Long(em_qty.text)
IVS_WORkstage_code = ddlb_workstage_code.getcode()
lvs_fpc_revision = sle_fpc_revision.text

lvs_workstage_code = ddlb_workstage_code.getcode()


if lvl_lot_qty = 0 or isnull(lvl_lot_qty) then 
	f_msg( "$$HEX11$$18c2c9b7200044c7200085c725b8200058d538c194c6$$ENDHEX$$" , "P")
	return 
end if


if lvs_week ='' or isnull(lvs_week) then 
	f_msg( "FPC $$HEX10$$fcc828cc7cb9200085c725b8200058d538c194c6$$ENDHEX$$" , "P")
	return 
end if

if lvs_assy_week ='' or isnull(lvs_assy_week) then 
	f_msg( "ASSY WORKING $$HEX10$$fcc828cc7cb9200085c725b8200058d538c194c6$$ENDHEX$$" , "P")
	return 
end if

if lvs_fpc_revision ='' or isnull(lvs_fpc_revision) then 
	f_msg( "FPC $$HEX11$$acb944be3cc844c7200085c725b8200058d538c194c6$$ENDHEX$$" , "P")
	return 
end if

if lvs_workstage_code ='' or isnull(lvs_workstage_code) then 
	f_msg( "$$HEX10$$f5ac15c844c7200020c1ddd0200058d538c194c6$$ENDHEX$$" , "P")
	return 
end if

//============================================
// $$HEX17$$e4b970acc4c920007cb7a8bc5cb8200000b35cd42000a8ba78b3200070c88cd62000$$ENDHEX$$
//============================================
select  1 , line_code ,  item_code, model_name, model_suffix  , run_no
INTO  :lvi_exists , :lvs_line_code , :lvs_item_code  , :LVS_MODEL_NAME , :lvs_model_suffix , :lvs_runno
from ip_product_run_card_io
where magazine_label_no  = :lvs_magazine_no ; 

IF F_SQL_CHECK() < 0 THEN 
	RETURN 
END IF 

IF lvi_exists = 0  THEN 
		f_play_sound("kittingfailed.wav")	
		f_msg("$$HEX16$$e4b970acc4c9200015c8f4bc7cb920003ecc44c718c22000c6c5b5c2c8b2e4b2$$ENDHEX$$",'P') 
		return 
END IF 

//============================================
// Cell Biz Barcode Create 
//++++++++++++++++++++++++++++++++++++++++++++++++++

select  f_get_new_magazine_no(:lvs_line_code , :lvs_model_name )  // F_GET_CREATE_CELLBIZ_BARCODE(:LVS_MODEL_NAME, :LVS_MODEL_NAME, :lvs_item_code, trunc(sysdate), :lvs_line_code, 'W090' ) 
   into :lvs_barcode 
 from dual ;
 
if f_sql_check() < 0 then
	return 
end if 

sle_pack_barcode.text = lvs_barcode


			/******************************************************
			* $$HEX17$$74c7f8bb200098ccacb91cb42000e4b970acc4c978c7c0c9200055d678c75cd5e4b2$$ENDHEX$$. 
			******************************************************/
			select count(*)
				into :lvl_count
			  from ip_product_pack_serial
			where barcode = :lvs_barcode 
				and  rownum = 1 ; 
			
			if f_sql_check() < 0 then 
					return 
			end if 
			
			/*$$HEX8$$74c7f8bb200074c8acc7200068d52000$$ENDHEX$$? */
			if lvl_count > 0 then
				rollback;
				f_msgbox1( 813 , lvs_barcode ) 
				return 
			end if 
			
			
			  insert into ip_product_pack_master ( 
					pack_barcode, 
					pack_type,  // C , M = MAGAZINE
					model_name, 
					model_suffix,
					part_no, 
					pack_date, 
					packing_pcs_qty, 
					pack_qty, 
					line_code, 
					workstage_code, 
					attr1,attr2,attr3,attr4,attr5, attr6 ,      
					complete_flag,       print_flag,       reprint, 
					organization_id,enter_date,enter_by,last_modify_date,last_modify_by
				 )
				 values (:lvs_barcode ,'M', :lvs_model_name, '*', :lvs_item_code ,sysdate,:lvl_lot_qty,:lvl_lot_qty, :lvs_line_code,:ivs_workstage_code,
							to_char(:lvdt_delivery_date , 'yymmdd'),
							:lvs_week,
							:lvs_assy_week,
							:lvs_note,
							:lvs_revision,
							 :lvs_fpc_revision ,
							'Y', //$$HEX26$$44c6ccb8200098ccacb9c4b32000d9b3dcc2200098ccacb920005cd5e4b22000b8d2acb970ac200001c6a5d5200088c74cc72000$$ENDHEX$$
							'N',
							0, :gvi_organization_id ,sysdate,:gvs_user_id ,sysdate, :gvs_user_id ) ; 
							
				 if f_sql_check() < 0 then 
					return 
			end if 
			
			
			//*************
			//$$HEX8$$98c72000bdc085c7200069d5c8b2e4b2$$ENDHEX$$. 
			//*************
//			insert into ip_product_pack_serial ( 
//				pack_barcode, 
//				barcode, 
//				line_code, 
//				workstage_code, 
//				
//				final_inspect_flag, 
//				final_inspect_date, 
//				
//				attr1, 
//				attr2, 
//				attr3, 
//				attr4, 
//				attr5, 
//				attr6, 
//				attr7, 
//				attr8, 
//				attr9,
//				scan_date, 
//				organization_id, 
//				enter_date, 
//				enter_by, 
//				last_modify_date, 
//				last_modify_by, 
//				run_no
//			)
//			values ( 
//						:lvs_barcode , 
//						:lvs_barcode,
//						
//						:lvs_line_code, 
//						:ivs_workstage_code, 
//						
//						'OK',                         //$$HEX11$$5ccd85c880acacc02000200020002000200020002000$$ENDHEX$$P_INTERLOCK_CHECK $$HEX7$$5cb82000a4c294cedcc2d0c52000$$ENDHEX$$Check $$HEX6$$60d5200008c615c884c72000$$ENDHEX$$
//						sysdate,                    //$$HEX7$$5ccd85c880acacc07cc790c72000$$ENDHEX$$
//						
//						to_char(:lvdt_delivery_date , 'yymmdd'),
//						:lvs_week,
//						:lvs_assy_week,
//						:lvs_note,
//						:lvs_revision,
//						'*' , 
//						'*' , 
//						'*' , 
//						'*' , 
//						sysdate, 
//						:gvi_organization_id ,  
//						sysdate,
//						:gvs_user_id, 
//						sysdate,
//						:gvs_user_id, 
//						:lvs_runno
//				) ;  
//			
//			if f_sql_check() < 0 then 
//				return 
//			end if 
st_status.text = f_msg("$$HEX11$$15c8c1c0200098ccacb9200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$" , 'S' )			
commit ;			

IF cbx_auto_print.CHECKED = TRUE THEN 
	
	st_status.text = 'Printing...' 
	
	dw_4.retrieve(lvs_barcode )
	IF DW_4.GETROW() < 1 THEN 
		F_MSG("$$HEX12$$9ccd25b860d5200090c7ccb800ac2000c6c5b5c2c8b2e4b2$$ENDHEX$$" , "P")
	END IF 
	
	dw_4.Modify("DataWindow.Print.Copies = " + em_print_count.text )
	dw_4.print(false) 
	 
END IF 
	

f_msgbox(170)
end event

type sle_magazine_no_merge from so_singlelineedit within w_prd_product_packing_4_magazine_create_master
integer x = 32
integer y = 668
integer width = 658
integer taborder = 10
boolean bringtotop = true
textcase textcase = upper!
end type

event getfocus;call super::getfocus;this.selecttext( 1,100)
end event

event modified;call super::modified;string lvs_magazine_no , LVS_MODEL_NAME

lvs_magazine_no = this.text

select  model_name
INTO  :LVS_MODEL_NAME 
from ip_product_run_card_io
where magazine_label_no  = :lvs_magazine_no ; 

IF F_SQL_CHECK() < 0 THEN 
	RETURN 
END IF 

if lvs_model_name = '' or isnull(lvs_model_name) then 
	
	f_msg( "$$HEX12$$e4b970acc4c9200074c725b874c72000c6c5b5c2c8b2e4b2$$ENDHEX$$" , "P") 
	this.text = ''
	this.setfocus()
	return 
	
end if 

sle_model_name_merge.text = LVS_MODEL_NAME

SLE_WEEK.SETFOCUS()

end event

type st_3 from so_statictext within w_prd_product_packing_4_magazine_create_master
integer x = 96
integer y = 568
integer width = 658
integer height = 72
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Magazine Label"
end type

type rb_lot_generate from so_radiobutton within w_prd_product_packing_4_magazine_create_master
integer x = 46
integer y = 96
integer width = 549
boolean bringtotop = true
string text = "Lot Packing Create"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1

end event

type sle_week from so_singlelineedit within w_prd_product_packing_4_magazine_create_master
integer x = 2053
integer y = 668
integer width = 430
integer taborder = 40
boolean bringtotop = true
textcase textcase = upper!
end type

event getfocus;call super::getfocus;THIS.SELECTTEXT( 1, 100)
end event

event modified;call super::modified;sle_ASSY_WEEK.SETFOCUS()
end event

type st_6 from so_statictext within w_prd_product_packing_4_magazine_create_master
integer x = 2053
integer y = 568
integer width = 430
integer height = 72
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Week"
end type

type sle_assy_week from so_singlelineedit within w_prd_product_packing_4_magazine_create_master
integer x = 2491
integer y = 668
integer width = 430
integer taborder = 50
boolean bringtotop = true
textcase textcase = upper!
end type

event getfocus;call super::getfocus;THIS.SELECTTEXT( 1, 100)
end event

event modified;call super::modified;em_qty.setfocus()
end event

type st_8 from so_statictext within w_prd_product_packing_4_magazine_create_master
integer x = 2491
integer y = 568
integer width = 430
integer height = 72
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Assy Week"
end type

type sle_note from so_singlelineedit within w_prd_product_packing_4_magazine_create_master
integer x = 695
integer y = 760
integer width = 3447
integer taborder = 90
boolean bringtotop = true
textcase textcase = upper!
end type

type st_9 from so_statictext within w_prd_product_packing_4_magazine_create_master
integer x = 37
integer y = 776
integer width = 658
integer height = 72
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Note"
end type

type sle_pack_barcode from so_singlelineedit within w_prd_product_packing_4_magazine_create_master
integer x = 1376
integer y = 668
integer width = 658
integer taborder = 30
boolean bringtotop = true
textcase textcase = upper!
end type

type st_10 from so_statictext within w_prd_product_packing_4_magazine_create_master
integer x = 1376
integer y = 568
integer width = 658
integer height = 72
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Pack Barcode"
end type

type sle_model_name_merge from so_singlelineedit within w_prd_product_packing_4_magazine_create_master
integer x = 699
integer y = 668
integer width = 658
integer taborder = 20
boolean bringtotop = true
boolean enabled = false
textcase textcase = upper!
end type

type st_11 from so_statictext within w_prd_product_packing_4_magazine_create_master
integer x = 699
integer y = 568
integer width = 658
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "Model Name"
end type

type em_qty from so_editmask within w_prd_product_packing_4_magazine_create_master
integer x = 3785
integer y = 668
integer width = 357
integer taborder = 80
boolean bringtotop = true
string text = ""
alignment alignment = center!
string mask = "###,###"
end type

event modified;call super::modified;sle_note.setfocus()
end event

type st_12 from so_statictext within w_prd_product_packing_4_magazine_create_master
integer x = 3785
integer y = 568
integer width = 357
integer height = 72
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "QTY"
end type

type cbx_auto_print from so_checkbox within w_prd_product_packing_4_magazine_create_master
integer x = 1947
integer y = 996
integer width = 622
boolean bringtotop = true
integer weight = 700
string text = "Auto Print"
boolean checked = true
end type

type uo_delivery_date from uo_ymd_calendar within w_prd_product_packing_4_magazine_create_master
integer x = 3360
integer y = 668
integer taborder = 70
boolean bringtotop = true
end type

on uo_delivery_date.destroy
call uo_ymd_calendar::destroy
end on

type st_14 from so_statictext within w_prd_product_packing_4_magazine_create_master
integer x = 3351
integer y = 568
integer width = 416
integer height = 72
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Delivery Date"
end type

type ddlb_workstage_code from uo_workstage_code_all within w_prd_product_packing_4_magazine_create_master
integer x = 850
integer y = 188
integer width = 645
integer height = 1912
boolean bringtotop = true
end type

event constructor;call super::constructor;//RegistryGet( "HKEY_LOCAL_MACHINE\Software\Infinity21\"+GVS_APPLICATION_NAME, "IO_WORKSTAGE", RegString!,  IVS_WORKSTAGE_CODE)

IVS_WORKSTAGE_CODE = Profilestring("WORKENV.INI","WORKSTAGE","WORKSTAGE_IO","")
THIS.SELECtitem(IVS_WORKSTAGE_CODE )




end event

event selectionchanged;call super::selectionchanged;//RegistrySet( "HKEY_LOCAL_MACHINE\Software\Infinity21\"+GVS_APPLICATION_NAME, "IO_WORKSTAGE", RegString!,THIS.GETCODE())
// 
f_jsSetProfileString ("WORKENV.INI", "WORKSTAGE", "WORKSTAGE_IO", THIS.GETCODE() )
IVS_WORkstage_code = THIS.GETCODE()


end event

type st_13 from so_statictext within w_prd_product_packing_4_magazine_create_master
integer x = 850
integer y = 112
integer width = 645
boolean bringtotop = true
integer weight = 700
long textcolor = 134217734
string text = "Workstage Code"
end type

type sle_fpc_revision from so_singlelineedit within w_prd_product_packing_4_magazine_create_master
integer x = 2926
integer y = 668
integer width = 430
integer taborder = 60
boolean bringtotop = true
textcase textcase = upper!
end type

event getfocus;call super::getfocus;THIS.SELECTTEXT( 1, 100)
end event

event modified;call super::modified;em_qty.setfocus()
end event

type st_1 from so_statictext within w_prd_product_packing_4_magazine_create_master
integer x = 2926
integer y = 568
integer width = 430
integer height = 72
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "FPC Revision"
end type

type cbx_unpack from so_checkbox within w_prd_product_packing_4_magazine_create_master
integer x = 37
integer y = 952
integer width = 370
boolean bringtotop = true
integer weight = 700
string text = "Un-Packing"
end type

event clicked;call super::clicked;if this.checked then 
	sle_unpack_barcode.enabled = true
	sle_unpack_barcode.setfocus() 
else 
	sle_unpack_barcode.enabled = false 
end if 
end event

type sle_unpack_barcode from so_singlelineedit within w_prd_product_packing_4_magazine_create_master
integer x = 425
integer y = 948
integer width = 1445
integer height = 108
integer taborder = 40
boolean bringtotop = true
integer textsize = -12
integer weight = 700
long textcolor = 16777215
long backcolor = 255
boolean enabled = false
end type

event getfocus;call super::getfocus;long HMC, VL
HMC = ImmGetContext( handle(parent) )
VL = ImmSetConversionStatus(  HMC, 0, 0)
ImmReleaseContext( HMC, VL) 
end event

event modified;call super::modified;if this.text = '' or isnull(this.text) then 
	return 
end if

string lvs_return 
//$$HEX9$$ecd3a5c774d5b4cc200091c7c5c544c72000$$ENDHEX$$
if f_msgbox1(1161,  f_get_dual_lang_text( gvs_language, 'UN-PACKING')  ) = 1 then 
	lvs_return = wf_unpacking(this.text)
	
	if cbx_sound_on.checked then 
		if lvs_return = 'OK' then  
			f_play_sound("call3.wav") 
		end if 
	end if
	
end if 

dw_1.reset()
dw_2.reset()
f_retrieve() 

this.text = ""
this.setfocus() 

end event

event ue_editchange;call super::ue_editchange;long HMC, VL
HMC = ImmGetContext( handle(parent) )
VL = ImmSetConversionStatus(  HMC, 0, 0)
ImmReleaseContext( HMC, VL) 
end event

type st_status from so_statictext within w_prd_product_packing_4_magazine_create_master
integer y = 368
integer width = 4201
integer height = 96
boolean bringtotop = true
integer textsize = -12
integer weight = 700
long textcolor = 65280
long backcolor = 0
string text = "Message"
boolean border = true
end type

type cbx_sound_on from so_checkbox within w_prd_product_packing_4_magazine_create_master
integer x = 1947
integer y = 900
integer width = 622
boolean bringtotop = true
integer weight = 700
string text = "Sound"
boolean checked = true
end type

type cb_1 from commandbutton within w_prd_product_packing_4_magazine_create_master
integer x = 3694
integer y = 924
integer width = 521
integer height = 148
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Re-Print"
end type

event clicked;long i 
string lvs_barcode ,lvs_pack_type

if dw_1.rowcount()  < 1 then return 

for i = 1 to dw_1.rowcount() 
	
	if dw_1.getitemstring(i,'chk') = 'Y' then 
		lvs_barcode = dw_1.getitemstring(i,'pack_barcode') 
		lvs_pack_type = dw_1.getitemstring(i,'pack_type')
		
		update ip_product_pack_master 
		set reprint = nvl(reprint,0) + 1
		where pack_barcode = :lvs_barcode ; 
		
		if f_sql_check() < 0 then 
			return 
		end if 
		
		commit ; 
		if lvs_pack_type = 'M' then 
			dw_4.retrieve(lvs_barcode)
			st_status.text = 'Printing...' 
			dw_4.Modify("DataWindow.Print.Copies = " + em_print_count.text ) 
			dw_4.print()
		end if
	end if
next

f_retrieve() 

st_status.text = 'reprint complete'
end event

type em_print_count from so_editmask within w_prd_product_packing_4_magazine_create_master
integer x = 3387
integer y = 984
integer width = 293
integer height = 84
integer taborder = 80
boolean bringtotop = true
integer textsize = -9
string text = "2"
alignment alignment = center!
string mask = "##"
boolean spin = true
double increment = 1
string minmax = "1~~4"
end type

type st_2 from so_statictext within w_prd_product_packing_4_magazine_create_master
integer x = 3387
integer y = 924
integer width = 293
integer height = 52
boolean bringtotop = true
string text = "Print Copy"
end type

type gb_1 from so_groupbox within w_prd_product_packing_4_magazine_create_master
integer y = 504
integer width = 4201
integer height = 376
integer weight = 700
long textcolor = 16711680
string text = "Merge Packing"
end type

type gb_2 from so_groupbox within w_prd_product_packing_4_magazine_create_master
integer width = 768
integer height = 348
string text = "Category"
end type

type gb_4 from so_groupbox within w_prd_product_packing_4_magazine_create_master
integer x = 791
integer width = 3406
integer height = 348
integer taborder = 100
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_6 from so_groupbox within w_prd_product_packing_4_magazine_create_master
integer x = 9
integer y = 892
integer width = 1906
integer height = 204
integer taborder = 30
integer weight = 700
long textcolor = 255
string text = "Un-Packing"
end type

