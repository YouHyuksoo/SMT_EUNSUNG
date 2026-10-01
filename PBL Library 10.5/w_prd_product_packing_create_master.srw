HA$PBExportHeader$w_prd_product_packing_create_master.srw
$PBExportComments$CELL BIZ Packing $$HEX2$$91c7c5c5$$ENDHEX$$
forward
global type w_prd_product_packing_create_master from w_main_root
end type
type sle_pcb_serial_no from so_singlelineedit within w_prd_product_packing_create_master
end type
type st_2 from so_statictext within w_prd_product_packing_create_master
end type
type st_status from so_statictext within w_prd_product_packing_create_master
end type
type em_count from so_editmask within w_prd_product_packing_create_master
end type
type rb_pack from so_radiobutton within w_prd_product_packing_create_master
end type
type rb_search from so_radiobutton within w_prd_product_packing_create_master
end type
type em_pack_unit from so_editmask within w_prd_product_packing_create_master
end type
type sle_model from so_singlelineedit within w_prd_product_packing_create_master
end type
type st_1 from so_statictext within w_prd_product_packing_create_master
end type
type st_3 from so_statictext within w_prd_product_packing_create_master
end type
type st_4 from so_statictext within w_prd_product_packing_create_master
end type
type sle_s_pack from so_singlelineedit within w_prd_product_packing_create_master
end type
type sle_s_model from so_singlelineedit within w_prd_product_packing_create_master
end type
type st_5 from so_statictext within w_prd_product_packing_create_master
end type
type st_6 from so_statictext within w_prd_product_packing_create_master
end type
type cb_manpack from so_commandbutton within w_prd_product_packing_create_master
end type
type cb_reprint from so_commandbutton within w_prd_product_packing_create_master
end type
type rb_normal from so_radiobutton within w_prd_product_packing_create_master
end type
type rb_cancel from so_radiobutton within w_prd_product_packing_create_master
end type
type uo_dateset from uo_ymd_calendar within w_prd_product_packing_create_master
end type
type uo_dateend from uo_ymd_calendar within w_prd_product_packing_create_master
end type
type st_7 from so_statictext within w_prd_product_packing_create_master
end type
type cbx_sound_on from so_checkbox within w_prd_product_packing_create_master
end type
type ddlb_line_code from uo_line_code_dd within w_prd_product_packing_create_master
end type
type ddlb_workstage_code from uo_workstage_code_all within w_prd_product_packing_create_master
end type
type sle_unpack_barcode from so_singlelineedit within w_prd_product_packing_create_master
end type
type cbx_unpack from so_checkbox within w_prd_product_packing_create_master
end type
type st_8 from so_statictext within w_prd_product_packing_create_master
end type
type st_9 from so_statictext within w_prd_product_packing_create_master
end type
type mle_log from so_multilineedit within w_prd_product_packing_create_master
end type
type cbx_repair_yn from so_checkbox within w_prd_product_packing_create_master
end type
type em_print_count from so_editmask within w_prd_product_packing_create_master
end type
type st_10 from so_statictext within w_prd_product_packing_create_master
end type
type cbx_delivery_label_info_input from so_checkbox within w_prd_product_packing_create_master
end type
type ddlb_pack_type from uo_basecode within w_prd_product_packing_create_master
end type
type st_11 from so_statictext within w_prd_product_packing_create_master
end type
type em_tray_qty from so_editmask within w_prd_product_packing_create_master
end type
type st_12 from so_statictext within w_prd_product_packing_create_master
end type
type em_tray_unit_qty from so_editmask within w_prd_product_packing_create_master
end type
type cbx_use_bartender from so_checkbox within w_prd_product_packing_create_master
end type
type cbx_remian from so_checkbox within w_prd_product_packing_create_master
end type
type st_13 from so_statictext within w_prd_product_packing_create_master
end type
type st_14 from so_statictext within w_prd_product_packing_create_master
end type
type sle_pack_charger from so_singlelineedit within w_prd_product_packing_create_master
end type
type sle_qc_pack_charger from so_singlelineedit within w_prd_product_packing_create_master
end type
type st_15 from so_statictext within w_prd_product_packing_create_master
end type
type em_carrier_size from so_editmask within w_prd_product_packing_create_master
end type
type cbx_marking_condition from so_checkbox within w_prd_product_packing_create_master
end type
type sle_pcb_master_serial_no from so_singlelineedit within w_prd_product_packing_create_master
end type
type st_16 from so_statictext within w_prd_product_packing_create_master
end type
type em_carrier_count from so_editmask within w_prd_product_packing_create_master
end type
type st_17 from so_statictext within w_prd_product_packing_create_master
end type
type gb_1 from so_groupbox within w_prd_product_packing_create_master
end type
type gb_3 from so_groupbox within w_prd_product_packing_create_master
end type
type gb_4 from so_groupbox within w_prd_product_packing_create_master
end type
type gb_5 from so_groupbox within w_prd_product_packing_create_master
end type
type gb_6 from so_groupbox within w_prd_product_packing_create_master
end type
type gb_7 from so_groupbox within w_prd_product_packing_create_master
end type
type gb_8 from so_groupbox within w_prd_product_packing_create_master
end type
type gb_9 from so_groupbox within w_prd_product_packing_create_master
end type
end forward

global type w_prd_product_packing_create_master from w_main_root
string tag = "w_prd_product_packing_create_master"
integer width = 6249
integer height = 2380
string title = "Product PID Packing Master"
long backcolor = 16777215
string ivs_modify_security = "N"
string ivs_dw_1_use_focusindicator = "N"
sle_pcb_serial_no sle_pcb_serial_no
st_2 st_2
st_status st_status
em_count em_count
rb_pack rb_pack
rb_search rb_search
em_pack_unit em_pack_unit
sle_model sle_model
st_1 st_1
st_3 st_3
st_4 st_4
sle_s_pack sle_s_pack
sle_s_model sle_s_model
st_5 st_5
st_6 st_6
cb_manpack cb_manpack
cb_reprint cb_reprint
rb_normal rb_normal
rb_cancel rb_cancel
uo_dateset uo_dateset
uo_dateend uo_dateend
st_7 st_7
cbx_sound_on cbx_sound_on
ddlb_line_code ddlb_line_code
ddlb_workstage_code ddlb_workstage_code
sle_unpack_barcode sle_unpack_barcode
cbx_unpack cbx_unpack
st_8 st_8
st_9 st_9
mle_log mle_log
cbx_repair_yn cbx_repair_yn
em_print_count em_print_count
st_10 st_10
cbx_delivery_label_info_input cbx_delivery_label_info_input
ddlb_pack_type ddlb_pack_type
st_11 st_11
em_tray_qty em_tray_qty
st_12 st_12
em_tray_unit_qty em_tray_unit_qty
cbx_use_bartender cbx_use_bartender
cbx_remian cbx_remian
st_13 st_13
st_14 st_14
sle_pack_charger sle_pack_charger
sle_qc_pack_charger sle_qc_pack_charger
st_15 st_15
em_carrier_size em_carrier_size
cbx_marking_condition cbx_marking_condition
sle_pcb_master_serial_no sle_pcb_master_serial_no
st_16 st_16
em_carrier_count em_carrier_count
st_17 st_17
gb_1 gb_1
gb_3 gb_3
gb_4 gb_4
gb_5 gb_5
gb_6 gb_6
gb_7 gb_7
gb_8 gb_8
gb_9 gb_9
end type
global w_prd_product_packing_create_master w_prd_product_packing_create_master

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
//$$HEX6$$04d6acc7a8ba78b358c72000$$ENDHEX$$Tray $$HEX5$$e8b204c718c2c9b72000$$ENDHEX$$
long ivl_PACKING_TRAY_BOX_QTY
//$$HEX3$$04d6acc72000$$ENDHEX$$Tary $$HEX3$$18c2c9b72000$$ENDHEX$$
long ivl_tray_qty 

STRING IVS_LINE_CODE, IVS_WORkstage_code , ivs_pack_charger , ivs_qc_pack_charger
end variables

forward prototypes
public subroutine wf_init ()
public subroutine wf_print (string arg_type)
public function string wf_cancel ()
public function integer wf_close_cancel ()
public function string wf_final_inspect (string arg_barcode)
public function string wf_unpacking (string arg_pack_barcode)
public function string wf_get_cell_biz_barcode (string arg_model, string arg_suffix, string arg_item_code)
public function string wf_barcode_scan (string arg_pack_barcode, string arg_serial, string arg_master_barcode)
end prototypes

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


sle_model.text = ''
em_pack_unit.text = '0' 
em_count.text = '0' 
em_tray_qty.text = '0'
em_tray_unit_qty.text = '0'

st_status.text = 'Initial..'

mle_log.text = ''
rb_pack.enabled = true 
dw_1.reset()
dw_2.reset() 
end subroutine

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

if cbx_delivery_label_info_input.checked then 

	openwithparm(w_pln_fg_delivery_info_input_popup,IVS_CURRNET_PACK_BARCODE)
end if 
//*************************************
// $$HEX3$$74d5f9b22000$$ENDHEX$$Packing $$HEX9$$91c7c5c5200044c6ccb8200098ccacb92000$$ENDHEX$$
//*************************************

Update Ip_Product_Pack_Master x
     set x.complete_flag= 'Y', 
	      x.print_flag = 'Y'     , 
		  x.pack_qty = ( select count(*) 
		                        from ip_product_pack_serial y 
							where pack_barcode = x.pack_barcode  ) 
 where pack_barcode = :IVS_CURRNET_PACK_BARCODE ; 
 
 if f_sql_check() < 0 then
	st_status.text = f_msg('Error : Complete Packing','S') 
	rollback ; 
	return 
end if 

commit ; 
//=========================================
// $$HEX3$$9ccd25b82000$$ENDHEX$$
//=========================================
 f_play_sound( "apply.wav") 
if cbx_use_bartender.checked = true then 
	
	    gst_return.gvl_return[1]  = long(em_print_count.text) // $$HEX5$$9ccd25b8a5c718c22000$$ENDHEX$$
        openwithparm( w_com_bartneder_form_popup , IVS_CURRNET_PACK_BARCODE ) 
	  
else
		dw_3.retrieve(IVS_CURRNET_PACK_BARCODE) 
		For i = 1 to long(em_print_count.text)
			dw_3.print() 
		Next
end if 

st_status.text = f_msg('$$HEX7$$14bc54cfdcb4200004d5b0b9b8d2$$ENDHEX$$...','S')
wf_init() 
	
	
	
end subroutine

public function string wf_cancel ();//$$HEX21$$04d6acc72000c4c989d5200011c978c72000ecd3a5c744c72000a8ba50b42000e8cd8cc120005cd5e4b2$$ENDHEX$$. 

if IVS_CURRNET_PACK_BARCODE = 'EMPTY' then 
	return 'EMPTY'
end if 


//if messagebox( 'confirm' , ' $$HEX22$$c4c989d511c978c72000ecd3a5c7200015c8f4bc7cb92000e8cd8cc1200058d5dcc283acb5c2c8b24cae2000$$ENDHEX$$? ', Question!, OKCancel!,2) = 1 then 
if messagebox( f_msg('$$HEX2$$55d678c7$$ENDHEX$$','S'),f_msg('$$HEX22$$c4c989d511c978c72000ecd3a5c7200015c8f4bc7cb92000e8cd8cc1200058d5dcc283acb5c2c8b24cae2000$$ENDHEX$$?','S'), Question!, OKCancel!,2) = 1 then 
	
////============================================
//// $$HEX8$$ecd3a5c715bca4c2200088bc38d62000$$ENDHEX$$
////============================================
//UPDATE IP_PRODUCT_2D_BARCODE SET BOX_NO =  NULL
// WHERE  BOX_NO = :IVS_CURRNET_PACK_BARCODE ; 
//
//if f_sql_check() < 0 then 
//	return 'ERROR' 
//end if 
//	
//	
//	
//	delete from ip_product_pack_master 
//	where pack_barcode = :IVS_CURRNET_PACK_BARCODE ; 
//	
//	if f_sql_check() < 0 then 
//		return 'ERROR' 
//	end if 
//	
//	delete from ip_product_pack_serial 
//	where pack_barcode = :IVS_CURRNET_PACK_BARCODE ; 
//	
//	if f_sql_check() < 0 then 
//		return 'ERROR' 
//	end if 
//	
//	commit ; 
	
	wf_init()
	
	return 'OK' 
	
end if 
end function

public function integer wf_close_cancel ();////$$HEX21$$04d6acc72000c4c989d5200011c978c72000ecd3a5c744c72000a8ba50b42000e8cd8cc120005cd5e4b2$$ENDHEX$$. 
//
if IVS_CURRNET_PACK_BARCODE = 'EMPTY' then 
	return 0
end if 

//
//	//Messagebox('Notify','$$HEX12$$44c6ccb8200018b4c0c920004ac540c7200091c7c5c52000$$ENDHEX$$' + IVS_CURRNET_PACK_BARCODE + ' $$HEX12$$ecd3a5c791c7c5c540c72000e8cd8cc1200029b4c8b2e4b2$$ENDHEX$$. ') 
//	Messagebox('Notify',f_msg('$$HEX12$$44c6ccb8200018b4c0c920004ac540c7200091c7c5c52000$$ENDHEX$$: ','S') + IVS_CURRNET_PACK_BARCODE + f_msg('  $$HEX12$$ecd3a5c791c7c5c540c72000e8cd8cc1200029b4c8b2e4b2$$ENDHEX$$.','S') ) 
//
//	delete from ip_product_pack_master 
//	where pack_barcode = :IVS_CURRNET_PACK_BARCODE ; 
//	
//	if f_sql_check() < 0 then 
//		return -1
//	end if 
//	
//	delete from ip_product_pack_serial 
//	where pack_barcode = :IVS_CURRNET_PACK_BARCODE ; 
//	
//	if f_sql_check() < 0 then 
//		return -1
//	end if 
//		
//	//============================================
//	// $$HEX8$$ecd3a5c715bca4c2200088bc38d62000$$ENDHEX$$
//	//============================================
//	UPDATE IP_PRODUCT_2D_BARCODE SET BOX_NO =  NULL
//	 WHERE  BOX_NO = :IVS_CURRNET_PACK_BARCODE ; 
//	
//	if f_sql_check() < 0 then 
//		return -1 
//	end if 	
//	
//	commit ; 
//	
//	
	return 0 
//	
//
end function

public function string wf_final_inspect (string arg_barcode);String lvs_result , lvs_message, lvs_ng_message, lvs_ok_message  , LVS_TYPE
Long LVL_SEQUENCE

lvs_result =SPACE(4000)
lvs_message=SPACE(4000)
lvs_ng_message=SPACE(4000)
lvs_ok_message =SPACE(4000)

//===================================================
//Cell Biz Final
//===================================================
DECLARE CL1 CURSOR FOR 
      SELECT   interlock_check_type, check_sequence
            FROM   iq_interlock_check_condition
           WHERE   line_code = :ivs_line_code 
             AND workstage_code = :ivs_workstage_code  
             AND NVL (use_yn, 'Y') = 'Y'
        ORDER BY   check_sequence ASC;

OPEN CL1 ;

DO 
	
		FETCH CL1 INTO :LVS_TYPE , :LVL_SEQUENCE ;
		
		IF SQLCA.SQLCODE = 100 THEN 
			CLOSE CL1 ;
			EXIT
		END IF 
		
		SQLCA.P_INTERLOCK_CHECK( IVS_LINE_CODE, IVS_WORKSTAGE_CODE, '*', ARG_BARCODE, LVS_TYPE ,ref lvs_result, ref lvs_message, ref lvs_ng_message, ref lvs_ok_message) 
	//	sqlca.p_interlock_check( arg_line_code, arg_workstage_code, '*' , arg_pid, LVS_interlock_check_type ,ref  lvs_result , ref lvs_message , ref lvs_ng_messgae ,ref lvs_ok_message)
		
		IF F_SQL_CHECK() < 0 THEN 
			CLOSE CL1 ;
			RETURN 'NG'
		END IF 
		
		if lvs_result = 'OK' then
			
			st_status.text = 'Final Check ' + lvs_message + ' ' + lvs_ok_message
			mle_log.text = st_status.text +'~r~n'+mle_log.text
		     continue 
		else 
			st_status.text = 'Final Check ' + lvs_result + ' ' + lvs_message + ' ' + lvs_ng_message 
			mle_log.text = st_status.text +'~r~n'+mle_log.text
			CLOSE CL1 ;
			return 'NG'
		end if 
		
LOOP UNTIL 1 =2 

return 'OK'
end function

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
	f_play_sound("$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav")//
	messagebox('Un-Packing Failed', lvs_outmsg ) 
end if 

st_status.text = lvs_outmsg 
return lvs_out
end function

public function string wf_get_cell_biz_barcode (string arg_model, string arg_suffix, string arg_item_code);string lvs_barcode 

//============================================
// Cell Biz Barcode Create 
// $$HEX37$$14bc54cfdcb4200048c5d0c52000ecd3a5c7e8b204c7200018c2c9b744c7200023b1b4c51cc12000ddc031c174d57cc5200074d51cc12000e8b204c7200018c2c9b7200018b140ae2000$$ENDHEX$$
//++++++++++++++++++++++++++++++++++++++++++++++++++

select F_GET_CREATE_CELLBIZ_BARCODE(:arg_model, :arg_suffix, :arg_item_code, trunc(sysdate), :ivs_line_code, :IVS_WORkstage_code , :IVL_PACK_UNIT_QTY) 
   into :lvs_barcode 
 from dual ;
 
if f_sql_check() < 0 then
	return 'ERROR'
else 
	return lvs_barcode 
end if 


end function

public function string wf_barcode_scan (string arg_pack_barcode, string arg_serial, string arg_master_barcode);/*******************************************************
*  2966B 1AAH1 V1001
* 15 $$HEX4$$90c7acb984c72000$$ENDHEX$$
*******************************************************/
long lvl_count
string lvs_runno 
string lvs_model

/******************************************************
* 2D Barcode $$HEX3$$d0c51cc12000$$ENDHEX$$RUNO NO $$HEX6$$7cb9200000ac38c828c6e4b2$$ENDHEX$$. 
******************************************************/
lvs_runno = '*' 

select run_no
into :lvs_runno
from ip_product_2d_barcode
where serial_no = :arg_serial ;

if f_sql_check() < 0 then 
	return 'ERROR'
end if 


/******************************************************
* Pack Master $$HEX8$$ddc031c1ecc580bd200055d678c72000$$ENDHEX$$
******************************************************/
select count(*)
   into :lvl_count
  from ip_product_pack_master
where pack_barcode = :arg_pack_barcode 
   and rownum = 1 ; 

if f_sql_check() < 0 then 
	return 'ERROR'
end if 

if lvl_count = 0 then 
	//Pack Master $$HEX3$$f8bb74c8acc7$$ENDHEX$$
	return 'ERROR2' 
end if 

/******************************************************
* $$HEX17$$74c7f8bb200098ccacb91cb42000dcc2acb9bcc578c7c0c9200055d678c75cd5e4b2$$ENDHEX$$. 
******************************************************/
select count(*)
   into :lvl_count
  from ip_product_pack_serial
where barcode = :arg_serial 
   and rownum = 1 ; 

if f_sql_check() < 0 then 
	return 'ERROR'
end if 

if lvl_count > 0 then 
	//$$HEX7$$74c7f8bb200074c8acc768d52000$$ENDHEX$$
	return 'ERROR1' 
end if 

//*************
//$$HEX8$$98c72000bdc085c7200069d5c8b2e4b2$$ENDHEX$$. 
//*************


//============================================
// $$HEX8$$ecd3a5c715bca4c2200088bc38d62000$$ENDHEX$$
//============================================
UPDATE IP_PRODUCT_2D_BARCODE 
      SET BOX_NO    = :arg_pack_barcode,
	        last_modify_date = sysdate,
		   last_modify_by = 'SCAN',
		   enter_by = 'SCAN'
WHERE SERIAL_NO = :arg_serial ;

if f_sql_check() < 0 then 
	return 'ERROR' 
end if 

insert into ip_product_pack_serial ( 
	pack_barcode, 
	barcode, 
	line_code, 
	workstage_code, 
	
	final_inspect_flag, 
	final_inspect_date, 
	
	attr1, 
	attr2, 
	attr3, 
	attr4, 
	attr5, 
//	attr6, 
//	attr7, 
//	attr8, 
//	attr9,
	scan_date, 
	organization_id, 
	enter_date, 
	enter_by, 
	last_modify_date, 
	last_modify_by, 
	run_no, 
	barcode_qty ,
	master_barcode
) values ( 
	:arg_pack_barcode , 
	:arg_serial,
	
	:ivs_line_code, 
	:ivs_workstage_code, 
	
	'OK',                         //$$HEX11$$5ccd85c880acacc02000200020002000200020002000$$ENDHEX$$P_INTERLOCK_CHECK $$HEX7$$5cb82000a4c294cedcc2d0c52000$$ENDHEX$$Check $$HEX6$$60d5200008c615c884c72000$$ENDHEX$$
	sysdate,                    //$$HEX7$$5ccd85c880acacc07cc790c72000$$ENDHEX$$
	
	substr(:arg_serial,1,5), 
	substr(:arg_serial,6,1),
	substr(:arg_serial,7,1),
	substr(:arg_serial,8,2), 
	substr(:arg_serial,10,5),
	sysdate, 
	1, 
	sysdate,
	:gvs_user_id, 
	sysdate,
	:gvs_user_id, 
	:lvs_runno, 
	1 ,
	:arg_master_barcode
) ;  

if f_sql_check() < 0 then 
	return 'ERROR' 
end if 


update ip_product_pack_master
set pack_qty = pack_qty + 1 ,
	 attr7 = :ivs_pack_charger ,
	 attr8 = :ivs_qc_pack_charger	
where pack_barcode = :arg_pack_barcode ; 

if f_sql_check() < 0 then 
	return 'ERROR' 
end if 

return 'OK' 
end function

on w_prd_product_packing_create_master.create
int iCurrent
call super::create
this.sle_pcb_serial_no=create sle_pcb_serial_no
this.st_2=create st_2
this.st_status=create st_status
this.em_count=create em_count
this.rb_pack=create rb_pack
this.rb_search=create rb_search
this.em_pack_unit=create em_pack_unit
this.sle_model=create sle_model
this.st_1=create st_1
this.st_3=create st_3
this.st_4=create st_4
this.sle_s_pack=create sle_s_pack
this.sle_s_model=create sle_s_model
this.st_5=create st_5
this.st_6=create st_6
this.cb_manpack=create cb_manpack
this.cb_reprint=create cb_reprint
this.rb_normal=create rb_normal
this.rb_cancel=create rb_cancel
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.st_7=create st_7
this.cbx_sound_on=create cbx_sound_on
this.ddlb_line_code=create ddlb_line_code
this.ddlb_workstage_code=create ddlb_workstage_code
this.sle_unpack_barcode=create sle_unpack_barcode
this.cbx_unpack=create cbx_unpack
this.st_8=create st_8
this.st_9=create st_9
this.mle_log=create mle_log
this.cbx_repair_yn=create cbx_repair_yn
this.em_print_count=create em_print_count
this.st_10=create st_10
this.cbx_delivery_label_info_input=create cbx_delivery_label_info_input
this.ddlb_pack_type=create ddlb_pack_type
this.st_11=create st_11
this.em_tray_qty=create em_tray_qty
this.st_12=create st_12
this.em_tray_unit_qty=create em_tray_unit_qty
this.cbx_use_bartender=create cbx_use_bartender
this.cbx_remian=create cbx_remian
this.st_13=create st_13
this.st_14=create st_14
this.sle_pack_charger=create sle_pack_charger
this.sle_qc_pack_charger=create sle_qc_pack_charger
this.st_15=create st_15
this.em_carrier_size=create em_carrier_size
this.cbx_marking_condition=create cbx_marking_condition
this.sle_pcb_master_serial_no=create sle_pcb_master_serial_no
this.st_16=create st_16
this.em_carrier_count=create em_carrier_count
this.st_17=create st_17
this.gb_1=create gb_1
this.gb_3=create gb_3
this.gb_4=create gb_4
this.gb_5=create gb_5
this.gb_6=create gb_6
this.gb_7=create gb_7
this.gb_8=create gb_8
this.gb_9=create gb_9
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_pcb_serial_no
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_status
this.Control[iCurrent+4]=this.em_count
this.Control[iCurrent+5]=this.rb_pack
this.Control[iCurrent+6]=this.rb_search
this.Control[iCurrent+7]=this.em_pack_unit
this.Control[iCurrent+8]=this.sle_model
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.st_3
this.Control[iCurrent+11]=this.st_4
this.Control[iCurrent+12]=this.sle_s_pack
this.Control[iCurrent+13]=this.sle_s_model
this.Control[iCurrent+14]=this.st_5
this.Control[iCurrent+15]=this.st_6
this.Control[iCurrent+16]=this.cb_manpack
this.Control[iCurrent+17]=this.cb_reprint
this.Control[iCurrent+18]=this.rb_normal
this.Control[iCurrent+19]=this.rb_cancel
this.Control[iCurrent+20]=this.uo_dateset
this.Control[iCurrent+21]=this.uo_dateend
this.Control[iCurrent+22]=this.st_7
this.Control[iCurrent+23]=this.cbx_sound_on
this.Control[iCurrent+24]=this.ddlb_line_code
this.Control[iCurrent+25]=this.ddlb_workstage_code
this.Control[iCurrent+26]=this.sle_unpack_barcode
this.Control[iCurrent+27]=this.cbx_unpack
this.Control[iCurrent+28]=this.st_8
this.Control[iCurrent+29]=this.st_9
this.Control[iCurrent+30]=this.mle_log
this.Control[iCurrent+31]=this.cbx_repair_yn
this.Control[iCurrent+32]=this.em_print_count
this.Control[iCurrent+33]=this.st_10
this.Control[iCurrent+34]=this.cbx_delivery_label_info_input
this.Control[iCurrent+35]=this.ddlb_pack_type
this.Control[iCurrent+36]=this.st_11
this.Control[iCurrent+37]=this.em_tray_qty
this.Control[iCurrent+38]=this.st_12
this.Control[iCurrent+39]=this.em_tray_unit_qty
this.Control[iCurrent+40]=this.cbx_use_bartender
this.Control[iCurrent+41]=this.cbx_remian
this.Control[iCurrent+42]=this.st_13
this.Control[iCurrent+43]=this.st_14
this.Control[iCurrent+44]=this.sle_pack_charger
this.Control[iCurrent+45]=this.sle_qc_pack_charger
this.Control[iCurrent+46]=this.st_15
this.Control[iCurrent+47]=this.em_carrier_size
this.Control[iCurrent+48]=this.cbx_marking_condition
this.Control[iCurrent+49]=this.sle_pcb_master_serial_no
this.Control[iCurrent+50]=this.st_16
this.Control[iCurrent+51]=this.em_carrier_count
this.Control[iCurrent+52]=this.st_17
this.Control[iCurrent+53]=this.gb_1
this.Control[iCurrent+54]=this.gb_3
this.Control[iCurrent+55]=this.gb_4
this.Control[iCurrent+56]=this.gb_5
this.Control[iCurrent+57]=this.gb_6
this.Control[iCurrent+58]=this.gb_7
this.Control[iCurrent+59]=this.gb_8
this.Control[iCurrent+60]=this.gb_9
end on

on w_prd_product_packing_create_master.destroy
call super::destroy
destroy(this.sle_pcb_serial_no)
destroy(this.st_2)
destroy(this.st_status)
destroy(this.em_count)
destroy(this.rb_pack)
destroy(this.rb_search)
destroy(this.em_pack_unit)
destroy(this.sle_model)
destroy(this.st_1)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.sle_s_pack)
destroy(this.sle_s_model)
destroy(this.st_5)
destroy(this.st_6)
destroy(this.cb_manpack)
destroy(this.cb_reprint)
destroy(this.rb_normal)
destroy(this.rb_cancel)
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.st_7)
destroy(this.cbx_sound_on)
destroy(this.ddlb_line_code)
destroy(this.ddlb_workstage_code)
destroy(this.sle_unpack_barcode)
destroy(this.cbx_unpack)
destroy(this.st_8)
destroy(this.st_9)
destroy(this.mle_log)
destroy(this.cbx_repair_yn)
destroy(this.em_print_count)
destroy(this.st_10)
destroy(this.cbx_delivery_label_info_input)
destroy(this.ddlb_pack_type)
destroy(this.st_11)
destroy(this.em_tray_qty)
destroy(this.st_12)
destroy(this.em_tray_unit_qty)
destroy(this.cbx_use_bartender)
destroy(this.cbx_remian)
destroy(this.st_13)
destroy(this.st_14)
destroy(this.sle_pack_charger)
destroy(this.sle_qc_pack_charger)
destroy(this.st_15)
destroy(this.em_carrier_size)
destroy(this.cbx_marking_condition)
destroy(this.sle_pcb_master_serial_no)
destroy(this.st_16)
destroy(this.em_carrier_count)
destroy(this.st_17)
destroy(this.gb_1)
destroy(this.gb_3)
destroy(this.gb_4)
destroy(this.gb_5)
destroy(this.gb_6)
destroy(this.gb_7)
destroy(this.gb_8)
destroy(this.gb_9)
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
Ivs_resize_type                      = 'MASTER_DETAIL_1L2R'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


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
st_status.width = dw_1.width + dw_2.width

uo_dateset.settext(string(f_v_sysdate(3),'yyyy/mm/dd'))

sle_pcb_serial_no.setfocus( )



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

event ue_data_control;call super::ue_data_control;
CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'

			DW_1.RETRIEVE(  '%' + sle_s_pack.text + '%', '%' + sle_s_model.text + '%' , uo_dateset.text(), uo_dateend.text() , ddlb_pack_type.getcode() + '%')

		
			
	CASE ELSE
END CHOOSE
end event

event open;call super::open;//Cell Biz Label $$HEX8$$e0ac15c82000a8ba78b3200015c8f4bc$$ENDHEX$$

//$$HEX7$$08cd30ae54d6200015c8f4bc2000$$ENDHEX$$
wf_init() 

//============================
//IVS_MODEL_PREFIX = '6871L-'
//IVS_CURRENT_PACK_MODEL = 'EMPTY'
//IVL_PACK_QTY = 0 
//IVL_PACK_UNIT_QTY = 0 
//============================

end event

event closequery;call super::closequery;st_status.text = ' $$HEX12$$c4c989d5200011c978c7200091c7c5c52000adc01cc811c9$$ENDHEX$$....' 

return wf_close_cancel() 


end event

event resize;call super::resize;st_status.width = dw_1.width + dw_2.width
end event

type dw_5 from w_main_root`dw_5 within w_prd_product_packing_create_master
integer x = 14
integer y = 1072
integer width = 1504
integer height = 716
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_prd_product_packing_create_master
integer x = 5
integer y = 1000
integer width = 1504
integer height = 716
integer taborder = 0
string dataobject = "d_product_fg_magazine_label_rpt"
end type

type dw_3 from w_main_root`dw_3 within w_prd_product_packing_create_master
integer y = 1000
integer width = 2688
integer height = 1292
integer taborder = 0
string dataobject = "d_prd_cell_biz_pack_barcode"
end type

type dw_2 from w_main_root`dw_2 within w_prd_product_packing_create_master
integer x = 3090
integer y = 1000
integer width = 1742
integer height = 1496
integer taborder = 0
boolean titlebar = true
string title = "Pack Serial"
string dataobject = "d_prd_cell_biz_pack_serial"
borderstyle borderstyle = stylebox!
end type

event dw_2::clicked;call super::clicked;sle_pcb_serial_no.setfocus( )
end event

event dw_2::retrieveend;call super::retrieveend;//em_count.text = string(rowcount)
ivl_pack_qty = long(em_count.text )
end event

event dw_2::retrieverow;call super::retrieverow;em_count.text = string ( long(em_count.text) + getitemnumber(row,'barcode_qty') ) 

end event

type dw_1 from w_main_root`dw_1 within w_prd_product_packing_create_master
integer y = 1000
integer width = 3067
integer height = 1260
integer taborder = 0
boolean titlebar = true
string title = "Pack Master"
string dataobject = "d_prd_cell_biz_pack_master"
borderstyle borderstyle = stylebox!
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow <= 0 then
	return 
end if 

sle_model.text = dw_1.object.model_name[currentrow]
em_pack_unit.text = string( dw_1.object.packing_pcs_qty[currentrow])
em_count.text ='0'
dw_2.retrieve( dw_1.object.pack_barcode[currentrow]  )

if dw_1.object.packing_pcs_qty[currentrow] = dw_1.object.pack_qty[currentrow] then 

	sle_s_pack.TEXT = ''
	
else

	sle_s_pack.TEXT = dw_1.object.pack_barcode[currentrow]

end if 
end event

event dw_1::itemchanged;call super::itemchanged;if upper(dwo.name) <> 'CHK' then return 

string lvs_complete, lvs_printed 

lvs_complete = this.object.complete_flag[row] 
lvs_printed  = this.object.print_flag[row] 

if ( lvs_complete = 'Y' ) and ( lvs_printed = 'Y' ) then 
    return 0 
else
	return 2
end if 
end event

event dw_1::doubleclicked;call super::doubleclicked;

//messagebox('a',string(dwo.name))
if dwo.name = 'pack_barcode' then 
	
	openwithparm(w_pln_fg_delivery_info_input_popup,getitemstring(row,'pack_barcode'))
	
	//messagebox('a','OK')
end if 
end event

event dw_1::clicked;call super::clicked;if dwo.name = 'chk' then 
	
	if getitemstring(row,'chk') = 'Y' then 
		setitem(row,'chk','N')
	else
		setitem(row,'chk','Y')
	end if
end if 
end event

type uo_tabpages from w_main_root`uo_tabpages within w_prd_product_packing_create_master
integer taborder = 0
end type

type sle_pcb_serial_no from so_singlelineedit within w_prd_product_packing_create_master
event modified_unpack ( )
integer x = 2231
integer y = 868
integer width = 997
integer height = 96
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 700
long textcolor = 65280
long backcolor = 0
boolean enabled = false
textcase textcase = upper!
end type

event modified_unpack();//Unpack 
//Pack $$HEX3$$e8cd8cc12000$$ENDHEX$$
//$$HEX8$$04d6acc72000c4c989d511c978c72000$$ENDHEX$$Pack $$HEX16$$d0c51cc1200074d5f9b22000dcc2acb9bcc544c720001cc870ac20005cd5e4b2$$ENDHEX$$. 
if IVS_CURRNET_PACK_BARCODE = 'EMPTY' then 
	//Messagebox( 'Notify','Can not found Data for Pack Cancel.') 
	f_msg( 'Can not found Data for Pack Cancel.' , 'P' ) 
	this.text = ''
	this.setfocus()
	return 
end if

string lvs_barcode 
long lvl_count , lvl_packCnt

lvs_barcode = this.text

st_status.text = 'Start UnPack ' + lvs_barcode 
//Unpack $$HEX4$$58d524b894b22000$$ENDHEX$$Serial $$HEX5$$74c7200074d5f9b22000$$ENDHEX$$Pack $$HEX11$$d0c5200074c8acc758d594b2c0c9200055d678c72000$$ENDHEX$$
select count(*)
  into :lvl_count
  from ip_product_pack_serial 
 where pack_barcode = :IVS_CURRNET_PACK_BARCODE
    and barcode = :lvs_barcode ;
	 
if f_sql_check() < 0 then 
	return 
end if 

if lvl_count = 0 then 
	//============================================
	//Messagebox('$$HEX2$$55d678c7$$ENDHEX$$',lvs_barcode + ' $$HEX26$$94b2200004d6acc72000c4c989d511c978c72000ecd3a5c791c7c5c5d0c5200074c8acc7200058d5c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$.') 
	if cbx_sound_on.checked then 
		//f_play_sound( "$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav") //$$HEX3$$e4c228d32000$$ENDHEX$$
		f_play_mp3("shibai.mp3")  // 
	end if
	
	st_status.text = f_msg_st1(815  ,lvs_barcode )   
	f_msgbox1(815  ,lvs_barcode)
	
	this.text = ''
	this.setfocus()
	//============================================
	return 
end if 

/***********************************************
* $$HEX9$$14bc54cfdcb42000c8b9a4c2c0d0d0c52000$$ENDHEX$$BOX Barcode reset
***********************************************/
UPDATE IP_PRODUCT_2D_BARCODE 
      SET BOX_NO = NULL,
	        last_modify_date = sysdate,
		   last_modify_by     = 'PACK OUT',
		   enter_by              = 'PACK OUT'
WHERE SERIAL_NO          = :lvs_barcode ;

if f_sql_check() < 0 then 
	return
end if 

/**********************************************
* $$HEX6$$74c8acc7200058d574ba2000$$ENDHEX$$ip_product_pack_serial $$HEX9$$d0c51cc12000adc01cc820005cd5e4b22000$$ENDHEX$$.
***********************************************/
delete from ip_product_pack_serial 
where pack_barcode = :IVS_CURRNET_PACK_BARCODE
    and barcode = :lvs_barcode ;

if f_sql_check() < 0 then 
	return
end if 

/***********************************************
* PACK MASTER $$HEX7$$18c2c9b7200004c974c730ae2000$$ENDHEX$$
***********************************************/
update ip_product_pack_master
set pack_qty = pack_qty - 1 
where pack_barcode = :IVS_CURRNET_PACK_BARCODE ;

if f_sql_check() < 0 then 
	return
end if 

select count(*) 
into :lvl_packCnt 
from ip_product_pack_serial 
where pack_barcode = :IVS_CURRNET_PACK_BARCODE ; 

if lvl_packCnt = 0 then 
	//$$HEX3$$94c7ecc52000$$ENDHEX$$Pack Serial $$HEX4$$c6c53cc774ba2000$$ENDHEX$$Master $$HEX7$$7cb92000adc01cc820005cd5e4b2$$ENDHEX$$. 
	delete ip_product_pack_master 
	where pack_barcode = :IVS_CURRNET_PACK_BARCODE ; 
	
	if f_sql_check() < 0 then 
		return
	end if 
	//$$HEX11$$f8adacb9e0ac200008cd30ae54d67cb920005cd5e4b2$$ENDHEX$$. 
	wf_init() 
end if 

commit ; 

if cbx_sound_on.checked then 
	f_play_mp3("chenggong.mp3")  //$$HEX2$$31c1f5ac$$ENDHEX$$
end if
st_status.text = f_msg('Unpack Success','S')
//==================
ivl_pack_qty = ivl_pack_qty - 1 
em_count.text = string(ivl_pack_qty)

if cbx_marking_condition.checked = true then 
	em_carrier_count.text =string( long(em_carrier_count.text) -1 )
end if 

//==================
//Tray 05.12 $$HEX3$$94cd00ac2000$$ENDHEX$$
//==================
if ivl_tray_qty = 0 then 
	ivl_tray_qty = ivl_packing_tray_box_qty - 1 
else
	ivl_tray_qty = ivl_tray_qty - 1 
end if 
em_tray_qty.text = string(ivl_tray_qty) 
//===================

dw_2.reset() 
dw_1.retrieve(IVS_CURRNET_PACK_BARCODE,'%',f_v_sysdate(1), f_sysdate() , '%')


this.text = ''
this.setfocus()
//===================

end event

event modified;call super::modified;if this.text = '' or isnull(this.text) then 
	return 
end if


//Unpack $$HEX3$$7cc74cb52000$$ENDHEX$$
if rb_cancel.checked then 
	triggerevent('modified_unpack')
	return 
end if 


//$$HEX3$$7cb778c72000$$ENDHEX$$Work Stage Check 
if IVS_LINE_CODE = '' or isnull(IVS_LINE_CODE) or IVS_WORKSTAGE_CODE = '' or isnull(IVS_WORKSTAGE_CODE) or IVS_LINE_CODE = '%' or IVS_WORKSTAGE_CODE = '%' then  
	messagebox( f_msg('$$HEX13$$7cb778c7fcac2000f5ac15c844c7200020c1ddd058d538c194c6$$ENDHEX$$.','S'), f_msg('$$HEX3$$7cb778c72000$$ENDHEX$$','S') + ivs_line_code +  f_msg('$$HEX3$$f5ac15c82000$$ENDHEX$$','S') + ivs_workstage_code ) 
	this.text = ""
	this.setfocus() 
	return 
end if 

//$$HEX4$$80acacc090c72000$$ENDHEX$$
if ivs_pack_charger = '' or isnull(ivs_pack_charger) or ivs_qc_pack_charger = '' or isnull(ivs_qc_pack_charger) or ivs_pack_charger = '%' or ivs_qc_pack_charger = '%' then  
    f_play_sound( "$$HEX5$$80acacc090c785c725b8$$ENDHEX$$.wav") 
	f_msg('$$HEX3$$80acacc090c7$$ENDHEX$$/$$HEX12$$9ccd58d580acacc090c77cb9200085c725b858d538c194c6$$ENDHEX$$.','P') 
	this.text = ""
	this.setfocus() 
	return 
end if 


string LVS_MASTER_BARCODE , lvs_barcode , lvs_interlock_return   , lvs_carrier_barcode_yn
string lvs_scan_model, lvs_scan_suffix, lvs_scan_item , lvs_scan_longterm_yn
string lvs_scan_result
long   lvl_count , lvi_repair_check , lvl_carrier_size , lvi_check_carrier_size


lvs_barcode = this.text 
lvl_carrier_size = long(em_carrier_size.text)
LVS_MASTER_BARCODE = sle_pcb_master_serial_no.text


IF rb_normal.CHECKED = TRUE  then //$$HEX5$$15c8c1c0200085c7e0ac$$ENDHEX$$
		//==================================================
		// $$HEX7$$78c730d17db72000b4cc6cd02000$$ENDHEX$$
		//==================================================
		  st_status.text = "Interlock Check Processing..."
		  
		  //5.11 
		  lvs_interlock_return = f_check_interlock_condition( ivs_line_code, ivs_workstage_code, lvs_barcode ) 
		  
		  if lvs_interlock_return <> 'OK'  then 
			 st_status.text = "Interlock Check => " +lvs_interlock_return
			return 
		  else
			  st_status.text = "Interlock Check OK"
		  end if 
		  
		//========================================================
		// Interlock $$HEX22$$58d6bdac2000c0bcbdacd0c5200030b578b9200018bcdcb4dcc274d57cc5200058d594b2200083ac44c72000$$ENDHEX$$FIX $$HEX6$$7cb7e0ac200058d5e0ac2000$$ENDHEX$$SCRIPT $$HEX2$$c1c02000$$ENDHEX$$Hard coding $$HEX1$$68d5$$ENDHEX$$
		//========================================================
		
		string lvs_result, lvs_message, lvs_ng_messgae, lvs_ok_message, LVS_interlock_check_type
		
		  lvs_result= space(4000)
	      lvs_message = space(4000)
	      lvs_ng_messgae = space(4000)
           lvs_ok_message= space(4000)
	
	      LVS_interlock_check_type = 'AOI_OK_EXISTS_CHECK_TB'
			
	      sqlca.P_INTERLOCK_CHECK( ivs_line_code, ivs_workstage_code, '*' , lvs_barcode, LVS_interlock_check_type ,ref  lvs_result , ref lvs_message , ref lvs_ng_messgae ,ref lvs_ok_message)
	
          if lvs_result = 'NG'  then 
	      
			 messagebox( "Interock FIX NG" , LVS_interlock_check_type+'~r~n'+ivs_line_code +' : '+ivs_workstage_code+'  : '+ivs_workstage_code+'~r~n'+lvs_message+'~r~n'+lvs_ng_messgae ) 
	         st_status.text = "Interlock FIX Check => " + 'NG : '+ LVS_interlock_check_type+' : '+lvs_message+' : '+lvs_ng_messgae
             return
				 
		else
			 st_status.text = "Interlock FIX Check OK"
		 end if 
		  
		//==================================================
		
end if 




//=============================================
// $$HEX10$$18c2acb988d420003cd685c7200080acacc02000$$ENDHEX$$
//=============================================

select count(*) into :lvi_repair_check
 from ip_product_work_qc
where serial_no = :lvs_barcode
  and organization_id = :gvi_organization_id 
  and rownum = 1  ;
  
 if f_sql_check() < 0 then 
	return 
end if 

/******************************************************
* $$HEX17$$74c7f8bb200098ccacb91cb42000dcc2acb9bcc578c7c0c9200055d678c75cd5e4b2$$ENDHEX$$. 
******************************************************/
select count(*)
   into :lvl_count
  from ip_product_pack_serial
where barcode = :lvs_barcode 
   and rownum = 1 ; 

if f_sql_check() < 0 then 
	return
end if 

if lvl_count > 0 then 
    f_play_sound( "$$HEX5$$74c7f8bb74c8acc768d5$$ENDHEX$$.wav") 
	f_msg("$$HEX14$$74c7f8bb2000f1b45db81cb4200014bc54cfdcb4200085c7c8b2e4b2$$ENDHEX$$" , "P")
	return  
end if 



//if lvi_repair_check > 0 then 
//	cbx_repair_yn.checked = true
//end if 

if cbx_repair_yn.checked = true then 
	
	   if lvi_repair_check = 0 then 		
			f_play_sound( "$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav") 
			f_msg('$$HEX21$$18c2acb974c725b8d0c5200074c8acc758d5c0c920004ac594b2200014bc54cfdcb4200085c7c8b2e4b2$$ENDHEX$$. $$HEX6$$55d678c7200058d538c194c6$$ENDHEX$$','P')
			st_status.text = f_msg('$$HEX21$$18c2acb974c725b8d0c5200074c8acc758d5c0c920004ac594b2200014bc54cfdcb4200085c7c8b2e4b2$$ENDHEX$$. $$HEX6$$55d678c7200058d538c194c6$$ENDHEX$$','S')
			this.text = ''
			this.setfocus()
			return 			
		end if 
else

	   if lvi_repair_check > 0 then 		
			f_play_sound( "$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav") 
			f_msg('$$HEX17$$18c2acb974c725b8d0c5200074c8acc758d594b2200018c2acb988d485c7c8b2e4b2$$ENDHEX$$. $$HEX6$$55d678c7200058d538c194c6$$ENDHEX$$','P')
			st_status.text = f_msg('$$HEX17$$18c2acb974c725b8d0c5200074c8acc758d594b2200018c2acb988d485c7c8b2e4b2$$ENDHEX$$. $$HEX6$$55d678c7200058d538c194c6$$ENDHEX$$','S')
			this.text = ''
			this.setfocus()
			return 			
		end if 	

end if 

/***************************************************
* $$HEX6$$5ccd85c8200080acacc02000$$ENDHEX$$2d barcode $$HEX12$$d0c5200074c8acc7200058d594b2c0c9200080acacc02000$$ENDHEX$$
* $$HEX4$$7cc7e8b240c72000$$ENDHEX$$RUNCARD $$HEX11$$acc0a9c6200004c84caec0c92000c9b944c560b42000$$ENDHEX$$
****************************************************/
 select count(*)
    into :lvl_count
  from ip_product_2d_barcode 
where serial_no = :lvs_barcode
    and rownum = 1 ; 

if f_sql_check() < 0 then 
	this.text = ''
	this.setfocus()
	f_play_sound( "$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav") 
	return  
end if 

if lvl_count = 0 then 
	f_play_sound( "$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav") 
	f_msg('RUN CARD $$HEX17$$d0c5200074c8acc758d5c0c920004ac594b2200014bc54cfdcb4200085c7c8b2e4b2$$ENDHEX$$. $$HEX6$$55d678c7200058d538c194c6$$ENDHEX$$','P')
	st_status.text = f_msg('RUN CARD $$HEX17$$d0c5200074c8acc758d5c0c920004ac594b2200014bc54cfdcb4200085c7c8b2e4b2$$ENDHEX$$. $$HEX6$$55d678c7200058d538c194c6$$ENDHEX$$','S')
	this.text = ''
	this.setfocus()
	return 
end if


/***************************************************
* $$HEX6$$5ccd85c8200080acacc02000$$ENDHEX$$
****************************************************/
//st_status.text = f_msg('Final Inspection...','S')
//
//if wf_final_inspect( lvs_barcode ) = 'NG' then 
//	f_play_sound( "$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav") 
//	//Messagebox('$$HEX2$$55d678c7$$ENDHEX$$', '$$HEX31$$74d5f9b220001cc888d440c7200088bdc9b7200010b694b2200080acacc030ae5db8200080bdacc75cb82000ecd3a5c7200088bd00ac200069d5c8b2e4b2$$ENDHEX$$. ') 
//	f_msg('$$HEX31$$74d5f9b220001cc888d440c7200088bdc9b7200010b694b2200080acacc030ae5db8200080bdacc75cb82000ecd3a5c7200088bd00ac200069d5c8b2e4b2$$ENDHEX$$. ','P') 
//	this.text = '' 
//	this.setfocus() 
//	return 
//end if 

/****************************************************/
//2.$$HEX6$$7cb7a8bc200084bdacb92000$$ENDHEX$$
//lvs_scan_model = mid(lvs_barcode,1,5)   04.21 $$HEX2$$c9b94cc7$$ENDHEX$$
//***************************************************/

//2.1 $$HEX9$$a8ba78b385ba200000ac38c824c630ae2000$$ENDHEX$$2D RUN
select a.model_name   , nvl(a.model_suffix,'*'), nvl(a.item_code,'*') ,  nvl(a.longterm_yn,'N') , b.carrier_barcode_yn , b.carrier_size
into :lvs_scan_model , :lvs_scan_suffix, :lvs_scan_item , :lvs_scan_longterm_yn  , :lvs_carrier_barcode_yn , :lvl_carrier_size
from ip_product_2d_barcode a , ip_product_model_master b 
where a.serial_no = :lvs_barcode 
    and a.model_name = b.model_name ; 

if f_sql_check() < 0 then 
	this.text = ''
	this.setfocus()
	f_play_sound( "$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav") 
	return  
end if 


//=============================================
// $$HEX10$$f0c530bcf4c5200070c874ac200080acacc02000$$ENDHEX$$
//=============================================

if lvs_carrier_barcode_yn = 'Y' and  cbx_marking_condition.checked = false then 
	
     f_msg("$$HEX32$$f0c530bcf4c5200014bc54cfdcb4200080ac9dc900b3c1c02000a8ba78b385c7c8b2e4b2200000b35cd414bc54cfdcb47cb92000a4c294ce200058d538c194c6$$ENDHEX$$." , "P")	
	cbx_marking_condition.checked = true
	em_carrier_size.text = string(lvl_carrier_size)
	em_carrier_count.text = '0'
	this.text = ''
	sle_pcb_master_serial_no.setfocus()

	return 
end if 

if cbx_marking_condition.checked = true then
	
	SELECT F_CHECK_CARRIER_CONDITION( :LVS_MASTER_BARCODE , :Lvs_barcode , :lvl_carrier_size  )
	   INTO :lvi_check_carrier_size
	   FROM DUAL ;
		
	 if f_sql_check() < 0 then 
		return 
	end if 		
		
	if lvi_check_carrier_size > 0 then 
		
		  st_status.text = "Carrier Barcode Check OK"
		
	else
		      f_msg("$$HEX16$$f0c530bcf4c5200014bc54cfdcb400ac200088bd7cc758ce200069d5c8b2e4b2$$ENDHEX$$." , "P")
			  st_status.text = "Carrier Barcode Check NG"
			  f_play_sound( "$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav") 
			  this.text = ''
			  this.setfocus()
			  return 
	end if 
	
	
end if 



//==========================================================
//4. $$HEX15$$04d6acc72000c4c989d511c978c72000a8ba78b3fcac200044be50ad2000$$ENDHEX$$
//==========================================================
if IVS_CURRENT_PACK_MODEL= 'EMPTY' then
	//$$HEX10$$e0c2dcad5cb82000c4c989d574c7200028b42000$$ENDHEX$$
	
	st_status.text = f_msg('Check Pack Unit Quantity...','S')
	
	//$$HEX27$$94c7c9b72000ecd3a5c77cc72000bdacb0c620003cba00c82000ecd3a5c760d5200018c2c9b744c7200085c725b820001bbc4cc72000$$ENDHEX$$. $$HEX22$$14bc54cfdcb448c5d0c5200018c2c9b774c72000f8bbacb92000e4b4b4c500ac7cc5200058d5c0bb5cb82000$$ENDHEX$$...
	if cbx_remian.checked = true then 

		
	//$$HEX3$$e0c2dcad2000$$ENDHEX$$1.$$HEX14$$a8ba78b3200020c734bb2000b4cc6cd02000ecd3a5c718c2c9b72000$$ENDHEX$$
	select  nvl(PACKING_TRAY_BOX_QTY,1)
	  into  :ivl_packing_tray_box_qty
	  from ip_product_model_master 
	where model_name like :lvs_scan_model ;     //'6871L-5803A'; 
	//where model_name like :ivs_model_prefix||:lvs_scan_model ;     //'6871L-5803A'; 
	
	if sqlca.sqlcode = 100 then
			//============================================

			if cbx_sound_on.checked then 
				f_play_sound( "$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav") //$$HEX3$$e4c228d32000$$ENDHEX$$
			end if

			st_status.text = f_msg_st1(815  , lvs_scan_model )   
			f_msgbox1(815  , lvs_scan_model)
			//============================================
		this.text = '' 
		this.setfocus() 
 
		return 
	elseif f_sql_check() < 0 then
		return 
	end if
	
		if em_pack_unit.text = '0' then
			f_play_sound( "$$HEX4$$18c2c9b724c658b9$$ENDHEX$$.wav") 
			f_msg( "$$HEX17$$ecd3a5c7200060d5200030ae00c9200018c2c9b744c7200085c725b858d538c194c6$$ENDHEX$$" , "P") 
			em_pack_unit.setfocus()
			return
			
		else
		    ivl_pack_unit_qty  = long( em_pack_unit.text)
		end if 
		
	else
	
	//$$HEX3$$e0c2dcad2000$$ENDHEX$$1.$$HEX14$$a8ba78b3200020c734bb2000b4cc6cd02000ecd3a5c718c2c9b72000$$ENDHEX$$
	select nvl(packing_pcs_qty,0) , nvl(PACKING_TRAY_BOX_QTY,1)
	  into :ivl_pack_unit_qty , :ivl_packing_tray_box_qty
	  from ip_product_model_master 
	where model_name like :lvs_scan_model ;     //'6871L-5803A'; 
	//where model_name like :ivs_model_prefix||:lvs_scan_model ;     //'6871L-5803A'; 
	
	if sqlca.sqlcode = 100 then
			//============================================
			//Messagebox('Confirm',ivs_model_prefix  + lvs_scan_model + ' $$HEX17$$a8ba78b3200015c8f4bc00ac200074c8acc7200058d5c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$. ') 
			if cbx_sound_on.checked then 
				f_play_sound( "$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav") //$$HEX3$$e4c228d32000$$ENDHEX$$
				//f_play_mp3("shibai.mp3")  //$$HEX7$$14bc54cfdcb42000d0c5ecb72000$$ENDHEX$$
			end if

			st_status.text = f_msg_st1(815  , lvs_scan_model )   
			//st_status.text = f_msg_st1(815  ,ivs_model_prefix  + lvs_scan_model )   
			f_msgbox1(815  , lvs_scan_model)
			//============================================
		this.text = '' 
		this.setfocus() 
 
		return 
	elseif f_sql_check() < 0 then
		return 
	end if
	
	
	end if  // remian if 
	
	//$$HEX3$$e0c2dcad2000$$ENDHEX$$2 $$HEX7$$ecd3a5c72000e8b204c700ac2000$$ENDHEX$$1 $$HEX10$$f4bce4b2200091c73cc774ba2000d0c5ecb72000$$ENDHEX$$
	if ivl_pack_unit_qty < 1 then 
		//===============================================================
		//Messagebox('$$HEX2$$55d678c7$$ENDHEX$$','$$HEX7$$ecd3a5c72000e8b204c700ac2000$$ENDHEX$$1$$HEX7$$f4bce4b2200091c7b5c2c8b2e4b2$$ENDHEX$$.  $$HEX6$$55d678c7200058d538c194c6$$ENDHEX$$') 
		//st_status.text = 'Check Your Pack Unit Quantity'
		
		if cbx_sound_on.checked then 
			f_play_sound( "$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav") //$$HEX3$$e4c228d32000$$ENDHEX$$
			//f_play_mp3("shibai.mp3")  //$$HEX7$$14bc54cfdcb42000d0c5ecb72000$$ENDHEX$$
		end if
		
		st_status.text = f_msg_st2(134 , f_get_dual_lang_text ( gvs_language , 'PACKING PCS QTY'),'1' )   
		f_msgbox2(134,  f_get_dual_lang_text ( gvs_language , 'PACKING PCS QTY') , '1' )
		//===============================================================
		this.text = '' 
		this.setfocus() 
		return 
	end if 
	
	
	//4.1 $$HEX4$$e0c2dcad5cb82000$$ENDHEX$$Pack barcode $$HEX7$$7cb9200044cc88bc20005cd5e4b2$$ENDHEX$$.
	//      $$HEX18$$ecd3a5c7200088bc38d694b22000a8ba50b42000b4cc88bcfcac2000d9b3dcc2d0c52000$$ENDHEX$$Master $$HEX8$$d0c5200000c8a5c774c720001cb4e4b2$$ENDHEX$$. 
	IVS_CURRNET_PACK_BARCODE = wf_get_cell_biz_barcode( lvs_scan_model, lvs_scan_suffix, lvs_scan_item) 
	
	if IVS_CURRNET_PACK_BARCODE = 'ERROR' then 
		//============================================
		//Messagebox('$$HEX2$$55d678c7$$ENDHEX$$',' $$HEX27$$28d3b9d0200014bc54cfdcb42000b4cc88bc2000d0c5ecb7200030ae08cd15c8f4bc2000f1b444c7200055d678c7200058d538c194c6$$ENDHEX$$') 
		if cbx_sound_on.checked then 
			f_play_sound( "$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav") //$$HEX3$$e4c228d32000$$ENDHEX$$
			//f_play_mp3("shibai.mp3")  //$$HEX7$$14bc54cfdcb42000d0c5ecb72000$$ENDHEX$$
		end if
		
		st_status.text = f_msg_st1(199  ,f_get_dual_lang_text ( gvs_language , 'PACK BARCODE')  )   
		f_msgbox1(199  ,f_get_dual_lang_text ( gvs_language , 'PACK BARCODE') )
		//============================================
		this.text = '' 
		this.setfocus()
		rollback ; // 20180124 $$HEX3$$94cd00ac2000$$ENDHEX$$
		return 
	end if
	
	//===============================================
	//$$HEX13$$a4c294ce200015c8f4bc7cb9200085c725b8200068d520002000$$ENDHEX$$
	//===============================================
	
	lvs_scan_result = wf_barcode_scan(ivs_currnet_pack_barcode, lvs_barcode , lvs_master_barcode) 
	
	if lvs_scan_result = 'ERROR1' then 
		
		//$$HEX5$$11c9f5bc200024c658b9$$ENDHEX$$
		//messagebox('$$HEX2$$55d678c7$$ENDHEX$$',lvs_barcode + ' $$HEX9$$94b2200074c7f8bb2000acc0a9c61cb42000$$ENDHEX$$Serial $$HEX3$$85c7c8b2e4b2$$ENDHEX$$.') 
		
		if cbx_sound_on.checked then 
			f_play_sound( "$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav") //$$HEX3$$e4c228d32000$$ENDHEX$$
			//f_play_mp3("shibai.mp3")  //$$HEX7$$14bc54cfdcb42000d0c5ecb72000$$ENDHEX$$
		end if
		
		st_status.text = f_msg_st1(125  ,lvs_barcode  )   
		f_msgbox1(125  ,lvs_barcode )
		//============================================
		this.text = '' 
		this.setfocus()
		rollback ; // 20180124 $$HEX3$$94cd00ac2000$$ENDHEX$$
		return 
		
    elseif lvs_scan_result = 'ERROR2' then 
		
		//Pack Master$$HEX7$$00ac2000c6c54cc7200024c658b9$$ENDHEX$$
		if cbx_sound_on.checked then 
			f_play_sound( "$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav") //$$HEX3$$e4c228d32000$$ENDHEX$$
			//f_play_mp3("shibai.mp3")  //$$HEX7$$14bc54cfdcb42000d0c5ecb72000$$ENDHEX$$
		end if
		
		st_status.text = f_msg_st1(115 , ivs_currnet_pack_barcode  )   
		f_msgbox1(115 , ivs_currnet_pack_barcode )
		
		//============================================		
		this.text = '' 
		this.setfocus()
		rollback ; // 20180124 $$HEX3$$94cd00ac2000$$ENDHEX$$
		return
		
	elseif lvs_scan_result = 'ERROR' then 
		
		//$$HEX5$$14b544be200024c658b9$$ENDHEX$$
		if cbx_sound_on.checked then 
			f_play_sound( "$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav") //$$HEX3$$e4c228d32000$$ENDHEX$$
			//f_play_mp3("shibai.mp3")  //$$HEX7$$14bc54cfdcb42000d0c5ecb72000$$ENDHEX$$
		end if
		
		this.text = '' 
		this.setfocus()
		rollback ; // 20180124 $$HEX3$$94cd00ac2000$$ENDHEX$$
		return
		
	elseif lvs_scan_result = 'OK' then 
		
		//$$HEX5$$a5c730aeacc7e0ac2000$$ENDHEX$$Flag 
		//$$HEX11$$98cc4cc720007dc740c7200014bc54cfdcb458c72000$$ENDHEX$$LongTerm Flag 
		IVS_CURRENT_PACK_LONGTERM = lvs_scan_longterm_yn
		
		mle_log.text = f_msg('1. PACK : ','S') + ' '+IVS_CURRNET_PACK_BARCODE
		mle_log.text = mle_log.text +'~rn'+ f_msg('2. Model: ','S') +' '+ IVS_CURRENT_PACK_MODEL
		mle_log.text = mle_log.text +'~rn'+ f_msg('3. ITEM: ','S') +' '+ LVS_SCAN_ITEM
		mle_log.text = mle_log.text +'~rn'+ f_msg('4. Long Term Flag: ','S') +' '+ IVS_CURRENT_PACK_LONGTERM

		commit ; 
		
		if cbx_sound_on.checked then 
			f_play_sound( "$$HEX4$$00c8a5c731c1f5ac$$ENDHEX$$.wav")
			//f_play_mp3("chenggong.mp3")   
		end if
		
		st_status.text = f_msg('Success','S')
		
	end if
	
	
	//============================
	//$$HEX24$$a8ba50b4200015c8c1c0200098ccacb9200018b4c8c53cc774ba2000c4c989d5c1c0dcd02000c5c570b374c7b8d22000$$ENDHEX$$
	//============================
	ivs_current_pack_model = lvs_scan_model 
	ivl_pack_qty = 1
	ivl_tray_qty = 1 //2018.05.12 $$HEX3$$94cd00ac2000$$ENDHEX$$Tary $$HEX3$$18c2c9b72000$$ENDHEX$$
	//===================================
	// ui control 
	//===================================
	sle_model.text = ivs_model_prefix +  lvs_scan_model
	em_pack_unit.text = string(ivl_pack_unit_qty) 
	em_tray_unit_qty.text   = string(ivl_PACKING_TRAY_BOX_QTY) //2018.05.12 $$HEX3$$94cd00ac2000$$ENDHEX$$Tary $$HEX3$$18c2c9b72000$$ENDHEX$$
	em_count.text = string(ivl_pack_qty)

	em_tray_qty.text = string(ivl_tray_qty)//2018.05.12 $$HEX3$$94cd00ac2000$$ENDHEX$$Tary $$HEX3$$18c2c9b72000$$ENDHEX$$
	
	if cbx_marking_condition.checked = true then
		em_carrier_count.text = string( long(em_carrier_count.text) + 1 )
	end if
	
	this.text = '' 
	this.setfocus() 
	//===================================
		
elseif IVS_CURRENT_PACK_MODEL = lvs_scan_model then
	//$$HEX6$$c4ac8dc12000c4c989d52000$$ENDHEX$$
	//1.Long Term $$HEX22$$78c7c0c9200055d678c7200058d5ecc520001cc15cb82000e4b274b974ba200024c658b92000ccb9e6b42000$$ENDHEX$$
	if IVS_CURRENT_PACK_LONGTERM <> lvs_scan_longterm_yn then
		if cbx_sound_on.checked then 
			f_play_sound( "$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav") //$$HEX3$$e4c228d32000$$ENDHEX$$
			//f_play_mp3("shibai.mp3")  //$$HEX7$$14bc54cfdcb42000d0c5ecb72000$$ENDHEX$$
		end if
		
		st_status.text = lvs_barcode + '  ' + f_msg( ' $$HEX23$$74d5f9b220001cc888d440c72000a5c730aeacc7e0ac20006cad84bd74c720001cc15cb82000e4b285b9c8b2e4b2$$ENDHEX$$. $$HEX7$$55d678c7200014bc8db7c8b2e4b2$$ENDHEX$$.','S'  )   
		f_msg(  ' $$HEX23$$74d5f9b220001cc888d440c72000a5c730aeacc7e0ac20006cad84bd74c720001cc15cb82000e4b285b9c8b2e4b2$$ENDHEX$$. $$HEX7$$55d678c7200014bc8db7c8b2e4b2$$ENDHEX$$.'  , 'P' ) 
		
		this.text = '' 
		this.setfocus()
		return 
	end if
	
	//$$HEX13$$a4c294ce200015c8f4bc7cb9200085c725b8200068d520002000$$ENDHEX$$
	lvs_scan_result = wf_barcode_scan(ivs_currnet_pack_barcode, lvs_barcode , lvs_master_barcode) 
	
	if lvs_scan_result = 'ERROR1' then 
		//$$HEX5$$11c9f5bc200024c658b9$$ENDHEX$$
		//messagebox('$$HEX2$$55d678c7$$ENDHEX$$',lvs_barcode + ' $$HEX9$$94b2200074c7f8bb2000acc0a9c61cb42000$$ENDHEX$$Serial $$HEX3$$85c7c8b2e4b2$$ENDHEX$$.') 
		if cbx_sound_on.checked then 
			f_play_sound( "$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav") //$$HEX3$$e4c228d32000$$ENDHEX$$
			//f_play_mp3("shibai.mp3")  //$$HEX7$$14bc54cfdcb42000d0c5ecb72000$$ENDHEX$$
		end if
		
		st_status.text = f_msg_st1(125  ,lvs_barcode  )   
		f_msgbox1(125  ,lvs_barcode )
		//============================================
		this.text = '' 
		this.setfocus()
		rollback ; // 20180124 $$HEX3$$94cd00ac2000$$ENDHEX$$
		return 
	elseif lvs_scan_result = 'ERROR' then 
		
		
		//$$HEX5$$14b544be200024c658b9$$ENDHEX$$
		if cbx_sound_on.checked then 
			f_play_sound( "$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav") //$$HEX3$$e4c228d32000$$ENDHEX$$
			//f_play_mp3("shibai.mp3")  //$$HEX7$$14bc54cfdcb42000d0c5ecb72000$$ENDHEX$$
		end if
		
		this.text = '' 
		this.setfocus()
		rollback ; // 20180124 $$HEX3$$94cd00ac2000$$ENDHEX$$
		return 
		
		
	elseif lvs_scan_result = 'OK' then 
		
		commit ; 
		if cbx_sound_on.checked then 
			f_play_sound( "$$HEX4$$00c8a5c731c1f5ac$$ENDHEX$$.wav")
			//f_play_mp3("chenggong.mp3")  //$$HEX7$$14bc54cfdcb42000d0c5ecb72000$$ENDHEX$$
		end if
	end if
	
	//============================
	//$$HEX24$$a8ba50b4200015c8c1c0200098ccacb9200018b4c8c53cc774ba2000c4c989d5c1c0dcd02000c5c570b374c7b8d22000$$ENDHEX$$
	//============================
	ivl_pack_qty = ivl_pack_qty + 1 
	em_count.text = string(ivl_pack_qty) 
	
	if cbx_marking_condition.checked = true then
		em_carrier_count.text = string(long(em_carrier_count.text) + 1 )
	end if 
	
	//=============================
	// tray Qty Check Logic 2018.05.12 $$HEX3$$94cd00ac2000$$ENDHEX$$Tary $$HEX2$$18c2c9b7$$ENDHEX$$
	//=============================
	ivl_tray_qty = ivl_tray_qty + 1 
	em_tray_qty.text = string(ivl_tray_qty) 
	
	if ivl_tray_qty = ivl_packing_tray_box_qty then 
		ivl_tray_qty = 0 
		em_tray_qty.text = '0'
		f_play_sound( "callall.wav")
	end if 
	//=============================
	this.text = '' 
	this.setfocus() 
	//============================
	
else	
	//$$HEX20$$04d6acc72000c4c989d5200011c978c72000a8ba78b3fcac2000e4b278b92000a8ba78b384c72000$$ENDHEX$$
	//200 
	//MessageBox( '$$HEX2$$55d678c7$$ENDHEX$$','$$HEX20$$04d6acc72000c4c989d511c978c72000a8ba78b3fcac2000e4b278b92000a8ba78b385c7c8b2e4b2$$ENDHEX$$. $$HEX8$$98ccacb9200088bd00ac69d5c8b2e4b2$$ENDHEX$$. ') 
	if cbx_sound_on.checked then 
		f_play_sound( "$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav") //$$HEX3$$e4c228d32000$$ENDHEX$$
		//f_play_mp3("shibai.mp3")  //$$HEX7$$14bc54cfdcb42000d0c5ecb72000$$ENDHEX$$
	end if
	
	st_status.text = f_msg_st2(200  ,lvs_scan_model, IVS_CURRENT_PACK_MODEL  )   
	f_msgbox2(200  ,lvs_scan_model, IVS_CURRENT_PACK_MODEL )
	//============================================
	this.text = '' 
	this.setfocus() 
	return 
end if 


dw_1.retrieve( IVS_CURRNET_PACK_BARCODE,'%',f_v_sysdate(1), f_sysdate() , '%' ) 
wf_print('SCAN') 


IF cbx_remian.CHECKED = TRUE THEN 
	em_pack_unit.enabled = false
	em_pack_unit.text = '0' 	
	cbx_remian.checked = false 

END IF 

//==========================================
//
//==========================================

if cbx_marking_condition.checked = true then
	
	if em_carrier_size.text = em_carrier_count.text  then 
		
		 this.text = '' 
	      em_carrier_count.text = '0'
		 sle_pcb_master_serial_no.text = ''
		 sle_pcb_master_serial_no.setfocus()
		 
	else
		this.text = '' 
		this.setfocus() 		
	end if 
	
else

	this.text = '' 
	this.setfocus() 

end if 



end event

event getfocus;call super::getfocus;long HMC, VL
HMC = ImmGetContext( handle(parent) )
VL = ImmSetConversionStatus(  HMC, 0, 0)
ImmReleaseContext( HMC, VL) 
end event

type st_2 from so_statictext within w_prd_product_packing_create_master
integer x = 2222
integer y = 804
integer width = 997
integer height = 48
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
string text = "C-PCB Serial No"
end type

type st_status from so_statictext within w_prd_product_packing_create_master
integer x = 18
integer y = 664
integer width = 4818
integer height = 96
boolean bringtotop = true
integer textsize = -12
integer weight = 700
long textcolor = 65280
long backcolor = 0
string text = "Message"
boolean border = true
end type

type em_count from so_editmask within w_prd_product_packing_create_master
integer x = 3680
integer y = 320
integer width = 334
integer height = 112
boolean bringtotop = true
integer textsize = -14
boolean enabled = false
string text = "0"
boolean displayonly = true
string mask = "##0"
end type

type rb_pack from so_radiobutton within w_prd_product_packing_create_master
integer x = 471
integer y = 68
integer width = 311
integer height = 96
boolean bringtotop = true
integer weight = 700
long textcolor = 255
long backcolor = 16777215
string text = "Packing"
end type

event clicked;call super::clicked;sle_pcb_serial_no.enabled = true 
cb_manpack.visible = true
cb_reprint.visible = false


if IVS_CURRENT_PACK_MODEL ='EMPTY' or dw_1.getrow()  = 0  then 
	
	dw_1.reset()
	dw_2.reset()
	sle_s_pack.text = ''
	wf_init()	
else
	
		if  dw_1.object.packing_pcs_qty[dw_1.getrow()] = dw_1.object.pack_qty[dw_1.getrow()]  then 
			dw_1.reset()
			dw_2.reset()
			sle_s_pack.text = ''
			wf_init()
			
		else
			DW_1.RETRIEVE(  '%' + sle_s_pack.text + '%', '%' + sle_s_model.text + '%' , uo_dateset.text(), uo_dateend.text() , ddlb_pack_type.getcode() + '%')
			
		end if 
end if 

sle_pcb_serial_no.setfocus()
rb_normal.enabled = true
rb_cancel.enabled = true


//un-Packing Option  
cbx_unpack.checked = false
cbx_unpack.enabled = false
sle_unpack_barcode.enabled = false
end event

type rb_search from so_radiobutton within w_prd_product_packing_create_master
integer x = 73
integer y = 68
integer width = 302
integer height = 96
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
string text = "Retrieve"
boolean checked = true
end type

event clicked;call super::clicked;if IVS_CURRENT_PACK_MODEL = 'EMPTY' and IVS_CURRNET_PACK_BARCODE= 'EMPTY' then 
	//$$HEX16$$c4c989d5200011c978c72000ecd3a5c7200091c7c5c574c72000c6c544c74cb5$$ENDHEX$$..
	sle_pcb_serial_no.enabled = false 
	cb_manpack.visible = false
	cb_reprint.visible = true
	em_print_count.visible = true
	rb_normal.enabled = false
	rb_cancel.enabled = false
	//====================
	//un-packing option 
	//====================
	cbx_unpack.enabled = true
	
else 
	//$$HEX13$$c4c989d5200011c978c7200091c7c5c574c7200088c744c74cb5$$ENDHEX$$. 
	//9300 
	
	//if messagebox('$$HEX2$$55d678c7$$ENDHEX$$','$$HEX18$$c4c989d511c978c72000ecd3a5c7200091c7c5c574c7200074c8acc7200069d5c8b2e4b2$$ENDHEX$$.  $$HEX20$$e8cd8cc1c4d6200070c88cd62000a8badcb45cb8200004c858d6200058d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?', Question!, YesNo!,2) = 1 then 
	if f_msgbox(9300) = 1 then 
		wf_cancel()
		sle_pcb_serial_no.enabled = false
		cb_manpack.visible = false
		cb_reprint.visible = true
		rb_normal.enabled = false
		rb_cancel.enabled = false
		sle_s_pack.text = ''
		//====================
		//un-packing option 
		//====================
		cbx_unpack.enabled = true

		f_retrieve()
	end if 
end if 

end event

type em_pack_unit from so_editmask within w_prd_product_packing_create_master
integer x = 3323
integer y = 320
integer width = 347
integer height = 112
boolean bringtotop = true
integer textsize = -14
long textcolor = 255
string text = "0"
string mask = "##0"
end type

event modified;call super::modified;sle_pcb_serial_no.SETFOCUS()
end event

type sle_model from so_singlelineedit within w_prd_product_packing_create_master
integer x = 2761
integer y = 100
integer width = 1248
integer height = 112
boolean bringtotop = true
integer weight = 700
boolean displayonly = true
end type

type st_1 from so_statictext within w_prd_product_packing_create_master
integer x = 2761
integer y = 52
integer width = 1248
integer height = 60
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
string text = "Model"
end type

type st_3 from so_statictext within w_prd_product_packing_create_master
integer x = 3323
integer y = 252
integer width = 347
integer height = 60
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
string text = "Pack Unit Qty"
end type

type st_4 from so_statictext within w_prd_product_packing_create_master
integer x = 3680
integer y = 248
integer width = 334
integer height = 60
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
string text = "Scan Qty"
end type

type sle_s_pack from so_singlelineedit within w_prd_product_packing_create_master
integer x = 919
integer y = 132
integer width = 855
integer height = 92
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

THIS.SELECTTEXT( 1, 100)
end event

type sle_s_model from so_singlelineedit within w_prd_product_packing_create_master
integer x = 1774
integer y = 132
integer width = 553
integer height = 92
boolean bringtotop = true
integer weight = 700
end type

type st_5 from so_statictext within w_prd_product_packing_create_master
integer x = 928
integer y = 60
integer width = 791
integer height = 68
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
string text = "Pack Barcode"
end type

type st_6 from so_statictext within w_prd_product_packing_create_master
integer x = 1787
integer y = 60
integer width = 480
integer height = 68
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
string text = "Model"
end type

type cb_manpack from so_commandbutton within w_prd_product_packing_create_master
integer x = 4654
integer y = 124
integer width = 402
integer height = 256
boolean bringtotop = true
string text = "Manual Pack"
end type

event clicked;call super::clicked;wf_print('MANUAL')
end event

type cb_reprint from so_commandbutton within w_prd_product_packing_create_master
integer x = 4654
integer y = 124
integer width = 402
integer height = 256
boolean bringtotop = true
string text = "Reprint"
end type

event clicked;call super::clicked;long i , j 
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
			//dw_4.Modify("DataWindow.Print.Copies = " + em_print_count.text) 
			//dw_4.print()
			For j = 1 to long(em_print_count.text)
				dw_4.print() 
			Next

		else 
			
			if cbx_use_bartender.checked = true then 
				
				 gst_return.gvl_return[1]  = 1 // $$HEX5$$9ccd25b8a5c718c22000$$ENDHEX$$
   			     openwithparm( w_com_bartneder_form_popup , lvs_barcode ) 
					  
			else
					dw_3.retrieve(lvs_barcode) 
					st_status.text = 'Printing...' 
					//dw_3.Modify("DataWindow.Print.Copies = " + em_print_count.text) 
					//dw_3.print()
					For j = 1 to long(em_print_count.text)
						dw_3.print() 
					Next
			end if 
				
				
		end if
	end if
next

f_retrieve() 
cbx_repair_yn.checked = false
st_status.text = 'reprint complete'
end event

type rb_normal from so_radiobutton within w_prd_product_packing_create_master
integer x = 466
integer y = 812
integer width = 361
integer height = 64
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
long backcolor = 16777215
boolean enabled = false
string text = "pack-In"
boolean checked = true
end type

event clicked;call super::clicked;

	sle_pcb_serial_no.text = ''
	sle_pcb_serial_no.setfocus()

end event

type rb_cancel from so_radiobutton within w_prd_product_packing_create_master
integer x = 466
integer y = 868
integer width = 361
integer height = 92
boolean bringtotop = true
integer weight = 700
long textcolor = 255
long backcolor = 16777215
boolean enabled = false
string text = "pack-Out"
end type

event clicked;call super::clicked;	sle_pcb_serial_no.text = ''
	sle_pcb_serial_no.setfocus()

end event

type uo_dateset from uo_ymd_calendar within w_prd_product_packing_create_master
integer x = 933
integer y = 356
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_prd_product_packing_create_master
integer x = 1358
integer y = 356
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_7 from so_statictext within w_prd_product_packing_create_master
integer x = 965
integer y = 280
integer width = 782
integer height = 68
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
string text = "Packing Date"
end type

type cbx_sound_on from so_checkbox within w_prd_product_packing_create_master
integer x = 2089
integer y = 528
integer width = 242
boolean bringtotop = true
integer weight = 700
long backcolor = 134217742
string text = "Sound"
boolean checked = true
end type

type ddlb_line_code from uo_line_code_dd within w_prd_product_packing_create_master
integer x = 32
integer y = 332
integer width = 407
integer height = 800
boolean bringtotop = true
integer textsize = -9
end type

event constructor;call super::constructor;//RegistryGet( "HKEY_LOCAL_MACHINE\Software\Infinity21\"+GVS_APPLICATION_NAME, "IO_LINE", RegString!,  IVS_LINE_CODE)

ivs_line_code = Profilestring("WORKENV.INI","LINE","CELLBIZPACKING","")

THIS.SELECtitem(IVS_LINE_CODE )


//SetProfileString ("WORKENV.INI", "PRINT", "print_name1", THIS.TEXT )
//GVS_PRINT_NAME_1 = Profilestring("WORKENV.INI","PRINT","print_name1","")
end event

event selectionchanged;call super::selectionchanged;IVS_LINE_CODE = THIS.GETCODE()
f_jsSetProfileString ("WORKENV.INI", "LINE", "CELLBIZPACKING", THIS.GETCODE() )
if rb_pack.checked then
	sle_pcb_serial_no.setfocus()
end if 
end event

type ddlb_workstage_code from uo_workstage_code_all within w_prd_product_packing_create_master
integer x = 453
integer y = 332
integer width = 375
integer height = 1368
boolean bringtotop = true
integer textsize = -9
boolean enabled = false
end type

event constructor;call super::constructor;//RegistryGet( "HKEY_LOCAL_MACHINE\Software\Infinity21\"+GVS_APPLICATION_NAME, "IO_WORKSTAGE", RegString!,  IVS_WORKSTAGE_CODE)
//THIS.SELECtitem(IVS_WORKSTAGE_CODE )

IVS_WORKSTAGE_CODE = Profilestring("WORKENV.INI","WORKSTAGE","CELLBIZPACKING","")
THIS.SELECtitem(IVS_WORKSTAGE_CODE )

ddlb_workstage_code.selectitem('W220',1)

IVS_WORKSTAGE_CODE = 'W220'
end event

event selectionchanged;call super::selectionchanged;
IVS_WORkstage_code = THIS.GETCODE()

f_jsSetProfileString ("WORKENV.INI", "WORKSTAGE", "CELLBIZPACKING", THIS.GETCODE() )

if rb_pack.checked then
	sle_pcb_serial_no.setfocus()
end if 


IVS_WORkstage_code = 'W220'
end event

type sle_unpack_barcode from so_singlelineedit within w_prd_product_packing_create_master
integer x = 2757
integer y = 520
integer width = 1394
integer height = 108
boolean bringtotop = true
integer textsize = -12
integer weight = 700
long textcolor = 16777215
long backcolor = 255
boolean enabled = false
end type

event modified;call super::modified;if this.text = '' or isnull(this.text) then 
	return 
end if

string lvs_return 
//$$HEX9$$ecd3a5c774d5b4cc200091c7c5c544c72000$$ENDHEX$$
if f_msgbox1(1161,  f_get_dual_lang_text( gvs_language, 'UN-PACKING')  ) = 1 then 
	lvs_return = wf_unpacking(this.text)
	
	if cbx_sound_on.checked then 
		if lvs_return = 'OK' then  
			f_play_sound("$$HEX4$$00c8a5c731c1f5ac$$ENDHEX$$.wav")  //$$HEX6$$14bc54cfdcb42000d0c5ecb7$$ENDHEX$$
		end if 
	end if
	
end if 

dw_1.reset()
dw_2.reset()
f_retrieve() 

sle_s_pack.TEXT = ''
this.text = ""
this.setfocus() 

end event

event getfocus;call super::getfocus;long HMC, VL
HMC = ImmGetContext( handle(parent) )
VL = ImmSetConversionStatus(  HMC, 0, 0)
ImmReleaseContext( HMC, VL) 


end event

event ue_editchange;call super::ue_editchange;long HMC, VL
HMC = ImmGetContext( handle(parent) )
VL = ImmSetConversionStatus(  HMC, 0, 0)
ImmReleaseContext( HMC, VL) 
end event

type cbx_unpack from so_checkbox within w_prd_product_packing_create_master
integer x = 2377
integer y = 536
integer width = 370
boolean bringtotop = true
integer weight = 700
long backcolor = 134217742
string text = "Un-Packing"
end type

event clicked;call super::clicked;if this.checked then 
	sle_unpack_barcode.enabled = true
	sle_unpack_barcode.setfocus() 
else 
	sle_unpack_barcode.enabled = false 
end if 
end event

type st_8 from so_statictext within w_prd_product_packing_create_master
integer x = 32
integer y = 252
integer width = 407
integer height = 68
boolean bringtotop = true
integer weight = 700
long textcolor = 8421504
long backcolor = 16777215
string text = "Line"
end type

type st_9 from so_statictext within w_prd_product_packing_create_master
integer x = 462
integer y = 252
integer width = 375
integer height = 68
boolean bringtotop = true
integer weight = 700
long textcolor = 8421504
long backcolor = 16777215
string text = "WorkStage"
long bordercolor = 8421504
end type

type mle_log from so_multilineedit within w_prd_product_packing_create_master
integer x = 5120
integer y = 20
integer width = 1070
integer height = 636
boolean bringtotop = true
string text = ""
end type

type cbx_repair_yn from so_checkbox within w_prd_product_packing_create_master
integer x = 923
integer y = 532
integer width = 361
boolean bringtotop = true
long textcolor = 255
long backcolor = 16777215
string text = "Repair YN"
end type

type em_print_count from so_editmask within w_prd_product_packing_create_master
integer x = 4654
integer y = 504
integer height = 136
boolean bringtotop = true
integer textsize = -14
string text = "1"
alignment alignment = center!
string mask = "##"
boolean spin = true
double increment = 1
string minmax = "1~~4"
end type

type st_10 from so_statictext within w_prd_product_packing_create_master
integer x = 4649
integer y = 436
integer width = 402
integer height = 60
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
string text = "Print Copy"
end type

type cbx_delivery_label_info_input from so_checkbox within w_prd_product_packing_create_master
integer x = 1248
integer y = 532
integer width = 480
boolean bringtotop = true
long textcolor = 8388608
long backcolor = 16777215
string text = "Delivery Label Info"
end type

type ddlb_pack_type from uo_basecode within w_prd_product_packing_create_master
integer x = 1778
integer y = 356
integer width = 553
boolean bringtotop = true
end type

event constructor;call super::constructor;redraw('PACK TYPE')
end event

type st_11 from so_statictext within w_prd_product_packing_create_master
integer x = 1778
integer y = 284
integer width = 553
integer height = 68
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
string text = "Pack Type"
end type

type em_tray_qty from so_editmask within w_prd_product_packing_create_master
integer x = 2784
integer y = 320
integer width = 238
integer height = 112
boolean bringtotop = true
integer textsize = -14
long textcolor = 255
boolean enabled = false
string text = "0"
boolean displayonly = true
string mask = "##0"
end type

type st_12 from so_statictext within w_prd_product_packing_create_master
integer x = 2793
integer y = 256
integer width = 494
integer height = 60
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
string text = "Tray Qty"
end type

type em_tray_unit_qty from so_editmask within w_prd_product_packing_create_master
integer x = 3035
integer y = 320
integer width = 261
integer height = 112
boolean bringtotop = true
integer textsize = -14
long textcolor = 255
boolean enabled = false
string text = "0"
boolean displayonly = true
string mask = "##0"
end type

type cbx_use_bartender from so_checkbox within w_prd_product_packing_create_master
integer x = 1760
integer y = 532
integer width = 320
boolean bringtotop = true
long textcolor = 8388608
long backcolor = 16777215
string text = "Bartender"
boolean checked = true
end type

type cbx_remian from so_checkbox within w_prd_product_packing_create_master
integer x = 2395
integer y = 120
integer width = 357
boolean bringtotop = true
integer weight = 700
long backcolor = 134217742
string text = "Remain"
end type

event clicked;call super::clicked;if this.checked = true then 
	
	em_pack_unit.enabled = true 
	em_pack_unit.text = '0'
	
else
	
	em_pack_unit.enabled = false 
	em_pack_unit.text = '0'	
	
end if 
sle_pcb_serial_no.SETFOCUS()
end event

type st_13 from so_statictext within w_prd_product_packing_create_master
integer x = 27
integer y = 436
integer width = 407
integer height = 68
boolean bringtotop = true
integer weight = 700
long textcolor = 32768
long backcolor = 16777215
string text = "Pack Charger"
end type

type st_14 from so_statictext within w_prd_product_packing_create_master
integer x = 443
integer y = 436
integer width = 425
integer height = 68
boolean bringtotop = true
integer weight = 700
long textcolor = 32768
long backcolor = 16777215
string text = "QC Pack Charger"
long bordercolor = 8421504
end type

type sle_pack_charger from so_singlelineedit within w_prd_product_packing_create_master
integer x = 32
integer y = 512
integer width = 407
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer weight = 700
end type

event modified;call super::modified;ivs_pack_charger = this.text
end event

type sle_qc_pack_charger from so_singlelineedit within w_prd_product_packing_create_master
integer x = 448
integer y = 512
integer width = 407
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer weight = 700
end type

event modified;call super::modified;ivs_qc_pack_charger = this.text
sle_pcb_serial_no.SETFOCUS()
end event

type st_15 from so_statictext within w_prd_product_packing_create_master
integer x = 1879
integer y = 816
integer width = 334
integer height = 48
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
string text = "Carrier Size"
end type

type em_carrier_size from so_editmask within w_prd_product_packing_create_master
integer x = 1874
integer y = 872
integer width = 334
integer height = 96
integer taborder = 40
boolean bringtotop = true
integer textsize = -12
boolean enabled = false
string text = "0"
boolean displayonly = true
string mask = "##0"
end type

type cbx_marking_condition from so_checkbox within w_prd_product_packing_create_master
integer x = 64
integer y = 852
integer width = 338
boolean bringtotop = true
integer weight = 700
long backcolor = 134217742
string text = "M.K Cond"
end type

event clicked;call super::clicked;if this.checked = true then 
	sle_pcb_master_serial_no.enabled = true 
	sle_pcb_master_serial_no.setfocus()
else
	
	sle_pcb_master_serial_no.enabled = false 
	sle_pcb_serial_no.enabled = true 
	sle_pcb_serial_no.setfocus()	
end if 
end event

type sle_pcb_master_serial_no from so_singlelineedit within w_prd_product_packing_create_master
integer x = 882
integer y = 876
integer width = 997
integer height = 96
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
long textcolor = 65280
long backcolor = 0
boolean enabled = false
textcase textcase = upper!
end type

event modified;call super::modified;if this.text = '' or isnull(this.text) then 
	return 
end if

//$$HEX3$$7cb778c72000$$ENDHEX$$Work Stage Check 
if IVS_LINE_CODE = '' or isnull(IVS_LINE_CODE) or IVS_WORKSTAGE_CODE = '' or isnull(IVS_WORKSTAGE_CODE) or IVS_LINE_CODE = '%' or IVS_WORKSTAGE_CODE = '%' then  
	messagebox( f_msg('$$HEX13$$7cb778c7fcac2000f5ac15c844c7200020c1ddd058d538c194c6$$ENDHEX$$.','S'), f_msg('$$HEX3$$7cb778c72000$$ENDHEX$$','S') + ivs_line_code +  f_msg('$$HEX3$$f5ac15c82000$$ENDHEX$$','S') + ivs_workstage_code ) 
	this.text = ""
	this.setfocus() 
	return 
end if 

//$$HEX4$$80acacc090c72000$$ENDHEX$$
if ivs_pack_charger = '' or isnull(ivs_pack_charger) or ivs_qc_pack_charger = '' or isnull(ivs_qc_pack_charger) or ivs_pack_charger = '%' or ivs_qc_pack_charger = '%' then  
    f_play_sound( "$$HEX5$$80acacc090c785c725b8$$ENDHEX$$.wav") 
	f_msg('$$HEX3$$80acacc090c7$$ENDHEX$$/$$HEX12$$9ccd58d580acacc090c77cb9200085c725b858d538c194c6$$ENDHEX$$.','P') 
	this.text = ""
	this.setfocus() 
	return 
end if 

string lvs_barcode , lvs_carrier_barcode_yn
long   lvl_count , lvl_carrier_size


lvs_barcode = this.text 

/******************************************************
* $$HEX17$$74c7f8bb200098ccacb91cb42000dcc2acb9bcc578c7c0c9200055d678c75cd5e4b2$$ENDHEX$$. 
******************************************************/
select count(*)
   into :lvl_count
  from ip_product_pack_serial
where barcode = :lvs_barcode 
   and rownum = 1 ; 

if f_sql_check() < 0 then 
	return
end if 

if lvl_count > 0 then 
    f_play_sound( "$$HEX5$$74c7f8bb74c8acc768d5$$ENDHEX$$.wav") 
	f_msg("$$HEX14$$74c7f8bb2000f1b45db81cb4200014bc54cfdcb4200085c7c8b2e4b2$$ENDHEX$$" , "P")
	return  
end if 

/***************************************************
* $$HEX6$$5ccd85c8200080acacc02000$$ENDHEX$$2d barcode $$HEX12$$d0c5200074c8acc7200058d594b2c0c9200080acacc02000$$ENDHEX$$
* $$HEX4$$7cc7e8b240c72000$$ENDHEX$$RUNCARD $$HEX11$$acc0a9c6200004c84caec0c92000c9b944c560b42000$$ENDHEX$$
****************************************************/
 select count(*)
    into :lvl_count
  from ip_product_2d_barcode 
where serial_no = :lvs_barcode
    and rownum = 1 ; 

if f_sql_check() < 0 then 
	this.text = ''
	this.setfocus()
	f_play_sound( "$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav") 
	return  
end if 

if lvl_count = 0 then 
	f_play_sound( "$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav") 
	f_msg('RUN CARD $$HEX17$$d0c5200074c8acc758d5c0c920004ac594b2200014bc54cfdcb4200085c7c8b2e4b2$$ENDHEX$$. $$HEX6$$55d678c7200058d538c194c6$$ENDHEX$$','P')
	st_status.text = f_msg('RUN CARD $$HEX17$$d0c5200074c8acc758d5c0c920004ac594b2200014bc54cfdcb4200085c7c8b2e4b2$$ENDHEX$$. $$HEX6$$55d678c7200058d538c194c6$$ENDHEX$$','S')
	this.text = ''
	this.setfocus()
	return 
end if



/****************************************************/
//2.$$HEX6$$7cb7a8bc200084bdacb92000$$ENDHEX$$
//lvs_scan_model = mid(lvs_barcode,1,5)   04.21 $$HEX2$$c9b94cc7$$ENDHEX$$
//***************************************************/

//2.1 $$HEX9$$a8ba78b385ba200000ac38c824c630ae2000$$ENDHEX$$2D RUN
select b.carrier_barcode_yn , b.carrier_size
into   :lvs_carrier_barcode_yn , :lvl_carrier_size
from ip_product_2d_barcode a , ip_product_model_master b 
where a.serial_no = :lvs_barcode 
    and a.model_name = b.model_name ; 

if f_sql_check() < 0 then 
	this.text = ''
	this.setfocus()
	f_play_sound( "$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav") 
	return  
end if 

if lvs_carrier_barcode_yn = 'Y' THEN 
	cbx_marking_condition.checked = true 
else
	f_msg("$$HEX22$$a8ba78b3c8b9a4c230d1d0c51cc1200090ceacb9b4c514bc54cfdcb47cb9200055d678c7200058d538c194c6$$ENDHEX$$" , 'P') 
	cbx_marking_condition.checked = false 
	this.text = ''
	return 
end if

em_carrier_count.text = '0'
em_carrier_size.text = string(lvl_carrier_size) 
sle_pcb_serial_no.setfocus()

end event

type st_16 from so_statictext within w_prd_product_packing_create_master
integer x = 887
integer y = 816
integer width = 997
integer height = 48
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
string text = "Master PCB Serial No"
end type

type em_carrier_count from so_editmask within w_prd_product_packing_create_master
integer x = 3241
integer y = 868
integer width = 334
integer height = 96
integer taborder = 50
boolean bringtotop = true
integer textsize = -12
boolean enabled = false
string text = "0"
boolean displayonly = true
string mask = "##0"
end type

type st_17 from so_statictext within w_prd_product_packing_create_master
integer x = 3227
integer y = 796
integer width = 357
integer height = 48
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
string text = "Carrier Count"
end type

type gb_1 from so_groupbox within w_prd_product_packing_create_master
integer x = 14
integer y = 188
integer width = 873
integer height = 464
integer weight = 700
long textcolor = 16711680
long backcolor = 16777215
string text = "Work Condition"
end type

type gb_3 from so_groupbox within w_prd_product_packing_create_master
integer x = 891
integer y = 4
integer width = 1454
integer height = 456
integer weight = 700
long textcolor = 16711680
long backcolor = 16777215
string text = "Search Condition"
end type

type gb_4 from so_groupbox within w_prd_product_packing_create_master
integer x = 4603
integer y = 4
integer width = 507
integer height = 656
integer weight = 700
long textcolor = 16711680
long backcolor = 16777215
string text = "Process"
end type

type gb_5 from so_groupbox within w_prd_product_packing_create_master
integer x = 9
integer y = 8
integer width = 873
integer height = 184
integer weight = 700
long textcolor = 255
long backcolor = 16777215
string text = "Function"
end type

type gb_6 from so_groupbox within w_prd_product_packing_create_master
integer x = 9
integer y = 764
integer width = 3666
integer height = 224
integer weight = 700
long textcolor = 255
long backcolor = 16777215
string text = "Scan Barcode"
end type

type gb_7 from so_groupbox within w_prd_product_packing_create_master
integer x = 891
integer y = 468
integer width = 1454
integer height = 188
integer weight = 700
long textcolor = 255
long backcolor = 16777215
string text = "Packing Options"
end type

type gb_8 from so_groupbox within w_prd_product_packing_create_master
integer x = 2359
integer y = 4
integer width = 1810
integer height = 452
integer taborder = 30
integer weight = 700
long textcolor = 255
long backcolor = 16777215
string text = "Scan Condition"
end type

type gb_9 from so_groupbox within w_prd_product_packing_create_master
integer x = 2359
integer y = 468
integer width = 1810
integer height = 188
integer taborder = 50
integer weight = 700
long textcolor = 255
long backcolor = 16777215
string text = "Un-Packing"
end type

