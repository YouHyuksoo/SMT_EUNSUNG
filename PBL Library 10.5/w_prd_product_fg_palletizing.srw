HA$PBExportHeader$w_prd_product_fg_palletizing.srw
$PBExportComments$$$HEX8$$0cd31bb8c0d074c7d5c9200091c7c5c5$$ENDHEX$$
forward
global type w_prd_product_fg_palletizing from w_main_root
end type
type sle_pcb_serial_no from so_singlelineedit within w_prd_product_fg_palletizing
end type
type st_2 from statictext within w_prd_product_fg_palletizing
end type
type st_status from so_statictext within w_prd_product_fg_palletizing
end type
type rb_pack from so_radiobutton within w_prd_product_fg_palletizing
end type
type rb_search from so_radiobutton within w_prd_product_fg_palletizing
end type
type sle_s_pack from so_singlelineedit within w_prd_product_fg_palletizing
end type
type sle_s_model from so_singlelineedit within w_prd_product_fg_palletizing
end type
type st_5 from statictext within w_prd_product_fg_palletizing
end type
type st_6 from statictext within w_prd_product_fg_palletizing
end type
type cb_manpack from so_commandbutton within w_prd_product_fg_palletizing
end type
type cb_reprint from so_commandbutton within w_prd_product_fg_palletizing
end type
type rb_normal from so_radiobutton within w_prd_product_fg_palletizing
end type
type rb_cancel from so_radiobutton within w_prd_product_fg_palletizing
end type
type uo_dateset from uo_ymd_calendar within w_prd_product_fg_palletizing
end type
type uo_dateend from uo_ymd_calendar within w_prd_product_fg_palletizing
end type
type st_7 from statictext within w_prd_product_fg_palletizing
end type
type cbx_sound_on from so_checkbox within w_prd_product_fg_palletizing
end type
type ddlb_line_code from uo_line_code_dd within w_prd_product_fg_palletizing
end type
type ddlb_workstage_code from uo_workstage_code_all within w_prd_product_fg_palletizing
end type
type sle_unpack_barcode from so_singlelineedit within w_prd_product_fg_palletizing
end type
type cbx_unpack from so_checkbox within w_prd_product_fg_palletizing
end type
type st_8 from statictext within w_prd_product_fg_palletizing
end type
type st_9 from statictext within w_prd_product_fg_palletizing
end type
type cbx_bartend from so_checkbox within w_prd_product_fg_palletizing
end type
type gb_1 from so_groupbox within w_prd_product_fg_palletizing
end type
type gb_2 from so_groupbox within w_prd_product_fg_palletizing
end type
type gb_3 from so_groupbox within w_prd_product_fg_palletizing
end type
type gb_4 from so_groupbox within w_prd_product_fg_palletizing
end type
type gb_5 from so_groupbox within w_prd_product_fg_palletizing
end type
type gb_6 from so_groupbox within w_prd_product_fg_palletizing
end type
end forward

global type w_prd_product_fg_palletizing from w_main_root
integer width = 5609
integer height = 2380
string title = "Product Palletizing Manage"
long backcolor = 16777215
string ivs_modify_security = "N"
string ivs_dw_1_use_focusindicator = "N"
sle_pcb_serial_no sle_pcb_serial_no
st_2 st_2
st_status st_status
rb_pack rb_pack
rb_search rb_search
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
cbx_bartend cbx_bartend
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
gb_5 gb_5
gb_6 gb_6
end type
global w_prd_product_fg_palletizing w_prd_product_fg_palletizing

type prototypes


end prototypes

type variables
String IVS_MODEL_PREFIX
//$$HEX3$$04d6acc72000$$ENDHEX$$Pack $$HEX9$$c4c989d5200011c978c72000a8ba78b32000$$ENDHEX$$
String IVS_CURRENT_PALLET_MODEL 
string IVS_CURRNET_PALLET_BARCODE  
//$$HEX3$$04d6acc72000$$ENDHEX$$Pack $$HEX5$$1cb4200018c2c9b72000$$ENDHEX$$
long IVL_PALLET_QTY
//$$HEX7$$04d6acc72000a8ba78b358c72000$$ENDHEX$$Pack $$HEX3$$18c2c9b72000$$ENDHEX$$
long IVL_PALLET_UNIT_QTY
//
STRING IVS_LINE_CODE, IVS_WORkstage_code
end variables

forward prototypes
public subroutine wf_init ()
public subroutine wf_print (string arg_type)
public function string wf_cancel ()
public function integer wf_close_cancel ()
public function string wf_final_inspect (string arg_barcode)
public function string wf_get_new_pallet_no ()
public function string wf_unload_pallet (string p_pallet_no)
end prototypes

public subroutine wf_init ();//=========================
// $$HEX4$$08cd30ae54d62000$$ENDHEX$$
//=========================
IVS_MODEL_PREFIX = '6871L-'
IVS_CURRENT_PALLET_MODEL = 'EMPTY'
IVS_CURRNET_PALLET_BARCODE = 'EMPTY'
IVL_PALLET_QTY = 0 
IVL_PALLET_UNIT_QTY = 0 



st_status.text = 'initial'
end subroutine

public subroutine wf_print (string arg_type);// $$HEX12$$9ccd25b8200000ad28b8200055d678c744c7200058d5e0ac$$ENDHEX$$
//messagebox('a',IVS_CURRNET_PALLET_BARCODE)


if IVS_CURRNET_PALLET_BARCODE = 'EMPTY' then 
	f_msg('$$HEX24$$04d6acc72000c4c989d511c978c720000cd31bb8200091c7c5c574c7200074c8acc758d5c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$.','P') 
	return 
end if 

//*************************************
// $$HEX3$$74d5f9b22000$$ENDHEX$$Packing $$HEX9$$91c7c5c5200044c6ccb8200098ccacb92000$$ENDHEX$$
//*************************************
Update Ip_Product_fg_pallet 
     set pallet_status= 'C', 
	      last_modify_by = :gvs_user_id, 
	      last_modify_date = sysdate 
 where pallet_no = :IVS_CURRNET_PALLET_BARCODE ; 
 
 if f_sql_check() < 0 then
	st_status.text = f_msg('Error : Complete Pallet','S') 
	return 
end if 

commit ; 
//+++++++++++++++++++++++++++++++++++++
if cbx_bartend.checked then

	GST_RETURN.GVS_RETURN[1] = '*'
	GST_RETURN.GVS_RETURN[2] = 'P' // PALETTE
	GST_RETURN.GVS_RETURN[3] = IVS_CURRNET_PALLET_BARCODE    //pack serial no $$HEX2$$84c72000$$ENDHEX$$( $$HEX6$$15bca4c2200088bc38d62000$$ENDHEX$$) 

	OPENWITHPARM(     W_COM_INBOX_FORM_POPUP , '*' )  
else 
	dw_3.retrieve(IVS_CURRNET_PALLET_BARCODE, gvs_language) 
	dw_3.print() 
end if 
//dw_1.retrieve(IVS_CURRNET_PALLET_BARCODE,'%') 

wf_init() 
	
	
	
end subroutine

public function string wf_cancel ();//$$HEX21$$04d6acc72000c4c989d5200011c978c72000ecd3a5c744c72000a8ba50b42000e8cd8cc120005cd5e4b2$$ENDHEX$$. 

if IVS_CURRNET_PALLET_BARCODE = 'EMPTY' then 
	return 'EMPTY'
end if 


//if messagebox( 'confirm' , ' $$HEX22$$c4c989d511c978c72000ecd3a5c7200015c8f4bc7cb92000e8cd8cc1200058d5dcc283acb5c2c8b24cae2000$$ENDHEX$$? ', Question!, OKCancel!,2) = 1 then 
if messagebox( f_msg('$$HEX2$$6e78a48b$$ENDHEX$$','S'),f_msg('$$HEX21$$c4c989d511c978c720000cd31bb8200091c7c5c544c72000e8cd8cc1200058d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?','S'), Question!, OKCancel!,2) = 1 then 
	
	/***********************
    $$HEX6$$0cd31bb8200074d5b4cc2000$$ENDHEX$$
    ************************/
    update ip_product_fg_inventory  x
       set x.pallet_no      = NULL
          ,x.pallet_flag     = 'N' 
          ,x.pallet_date    = NULL
          ,x.last_modify_by = sys_context('userenv','IP_ADDRESS')
     where x.pallet_no     = :IVS_CURRNET_PALLET_BARCODE ; 
	
	if f_sql_check() < 0 then 
		return 'NG'
	end if 
	
	/**************************
    * $$HEX6$$0cd31bb82000adc01cc82000$$ENDHEX$$
    ***************************/ 
    delete ip_product_fg_pallet x  
     where x.pallet_no  = :IVS_CURRNET_PALLET_BARCODE ; 
	
	if f_sql_check() < 0 then 
		return 'NG'
	end if 
	
	commit ; 
	
	wf_init()
	
	return 'OK' 
	
end if 
end function

public function integer wf_close_cancel ();//$$HEX21$$04d6acc72000c4c989d5200011c978c72000ecd3a5c744c72000a8ba50b42000e8cd8cc120005cd5e4b2$$ENDHEX$$. 

if IVS_CURRNET_PALLET_BARCODE = 'EMPTY' then 
	return 0
end if 


	//Messagebox('Notify','$$HEX12$$44c6ccb8200018b4c0c920004ac540c7200091c7c5c52000$$ENDHEX$$' + IVS_CURRNET_PALLET_BARCODE + ' $$HEX12$$ecd3a5c791c7c5c540c72000e8cd8cc1200029b4c8b2e4b2$$ENDHEX$$. ') 
	Messagebox('Notify',f_msg('$$HEX13$$f8bb44c6ccb8200091c7c5c574c7200074c8acc769d5c8b2e4b2$$ENDHEX$$. :  ','S') + IVS_CURRNET_PALLET_BARCODE + f_msg('  $$HEX19$$c4c989d5200011c978c7200091c7c5c544c72000adc01cc898ccacb9200069d5c8b2e4b22000$$ENDHEX$$','S') ) 

	/***********************
    $$HEX6$$0cd31bb8200074d5b4cc2000$$ENDHEX$$
    ************************/
    update ip_product_fg_inventory  x
       set x.pallet_no      = NULL
          ,x.pallet_flag     = 'N' 
          ,x.pallet_date    = NULL
          ,x.last_modify_by = sys_context('userenv','IP_ADDRESS')
     where x.pallet_no     = :IVS_CURRNET_PALLET_BARCODE ; 
	
	if f_sql_check() < 0 then 
		return -1
	end if 
	
	/**************************
    * $$HEX6$$0cd31bb82000adc01cc82000$$ENDHEX$$
    ***************************/ 
    delete ip_product_fg_pallet x  
     where x.pallet_no  = :IVS_CURRNET_PALLET_BARCODE ; 
	
	if f_sql_check() < 0 then 
		return -1
	end if 
	
	commit ; 
	
	
	return 0 
	
    
          
   
end function

public function string wf_final_inspect (string arg_barcode);//$$HEX17$$74d5f9b2200014bc54cfdcb458c720005ccd85c8200080acacc0200055d678c72000$$ENDHEX$$
//sqlca.p_interlock_check( 
//   p_line_code        IN     VARCHAR2,
//   p_workstage_code   IN     VARCHAR2,
//   p_machine_code     IN     VARCHAR2,
//   p_serial_no        IN     VARCHAR2,
//   p_type             IN     VARCHAR2, --CELLBIZPACKING

//   p_result              OUT VARCHAR2, --OK, NG, SKIP
//   p_message             OUT VARCHAR2, --$$HEX4$$54badcc2c0c92000$$ENDHEX$$
//   p_ng_messgae          OUT VARCHAR2, --
//   p_ok_message          OUT VARCHAR2)

String lvs_result , lvs_message, lvs_ng_message, lvs_ok_message 
lvs_result =SPACE(4000)
lvs_message=SPACE(4000)
lvs_ng_message=SPACE(4000)
lvs_ok_message =SPACE(4000)
//Cell Biz Final
SQLCA.P_INTERLOCK_CHECK( IVS_LINE_CODE, IVS_WORKSTAGE_CODE, "", ARG_BARCODE, 'CELLBIZPACKING',lvs_result, lvs_message, lvs_ng_message, lvs_ok_message) 

// lvs_result = 'OK', 'NG'
if lvs_result = 'OK' then
	st_status.text = 'Final Check ' + lvs_message + ' ' + lvs_ok_message
	return lvs_result 
else 
	st_status.text = 'Final Check ' + lvs_result + ' ' + lvs_message + ' ' + lvs_ng_message 
	return 'NG'
end if 
end function

public function string wf_get_new_pallet_no ();string lvs_out , lvs_outmsg, lvs_barcode, lvs_location, lvs_commit, lvs_model, lvs_suffix 
long lvl_txn_type, lvl_row
lvs_out = space(4000)
lvs_outmsg = space(4000)

select model_name, model_suffix 
    into :lvs_model, :lvs_suffix 
  from ip_product_fg_inventory 
where barcode = :sle_pcb_serial_no.text
    and pallet_flag = 'N' ; 

if sqlca.sqlcode = 100 then 
	f_msg('$$HEX13$$74c858d5c0c920004ac594b22000acc7e0ac200085c7c8b2e4b2$$ENDHEX$$.'	,'P') 
	return 'NG'
elseif f_sql_check() < 0 then 
	return 'NG' 
end if 

//OUT $$HEX8$$c0bc18c294b2200048c5f0c40cc92000$$ENDHEX$$fETCH $$HEX2$$d0c51cc1$$ENDHEX$$
declare proc procedure for P_CREATE_FG_PALLET_BARCODE( :lvs_model , :lvs_suffix ) 
using sqlca ; 

execute proc ; 
fetch proc into :lvs_out, :lvs_outmsg ; 
close proc ; 

if f_sql_check() < 0 then
	return 'NG'
end if 

if lvs_out = 'NG' then 
	//$$HEX22$$b4c5a4b52000d0c678c73cc75cb82000adc01cc8200058d5c0c92000bbba58d5e0ac2000acb934d128b42000$$ENDHEX$$
	//$$HEX8$$d0c678c7200054badcc2c0c994b22000$$ENDHEX$$lvs_outmsg 	
	if cbx_sound_on.checked then 
		f_play_mp3("shibai.mp3")
	end if
	Messagebox( 'NG', lvs_outmsg )
	return 'NG' 
else 

	//$$HEX3$$31c1f5ac2000$$ENDHEX$$
	//Pallet No $$HEX2$$7cb92000$$ENDHEX$$IVS $$HEX5$$d0c5e4b2200023b14cc7$$ENDHEX$$.
    IVS_CURRNET_PALLET_BARCODE = lvs_outmsg 
	 
end if 

//$$HEX5$$31c1f5ac74c774ac2000$$ENDHEX$$NG $$HEX3$$74c774ac2000$$ENDHEX$$
st_status.text = lvs_outmsg + '  ' + f_msg(' $$HEX6$$ddc031c1200044c6ccb82000$$ENDHEX$$','S')


return 'OK'




end function

public function string wf_unload_pallet (string p_pallet_no);//$$HEX6$$28d3b9d0200074d5b4cc2000$$ENDHEX$$( Un - Packing ) $$HEX2$$68d52000$$ENDHEX$$
//$$HEX3$$70c874ac2000$$ENDHEX$$
string lvs_out , lvs_outmsg
lvs_out = space(4000)
lvs_outmsg = space(4000)
/*P_PRODUCT_FG_PALLET_UNLOAD(p_pallet  varchar2,
                                                       p_commit  varchar2, 
                                                       p_out out varchar2, 
                                                       p_msg out varchar2) is
																		 */
//OUT $$HEX8$$c0bc18c294b2200048c5f0c40cc92000$$ENDHEX$$fETCH $$HEX2$$d0c51cc1$$ENDHEX$$
// p_ui_cell_biz_unpacking  $$HEX10$$94b22000c5b3bdb9200038c158c13cc75cb82000$$ENDHEX$$Commit / Rollback $$HEX7$$18b4b4c5200018b1b4c534c62000$$ENDHEX$$
declare proc procedure for P_PRODUCT_FG_PALLET_UNLOAD ( :p_pallet_no, 'Y'  ) 
using sqlca ; 

execute proc ; 
fetch proc into :lvs_out, :lvs_outmsg ; 
close proc ; 

if f_sql_check() < 0 then
	return 'NG'
end if 

if lvs_out = 'NG' then 
	//$$HEX22$$b4c5a4b52000d0c678c73cc75cb82000adc01cc8200058d5c0c92000bbba58d5e0ac2000acb934d128b42000$$ENDHEX$$
	//$$HEX8$$d0c678c7200054badcc2c0c994b22000$$ENDHEX$$lvs_outmsg 	
	f_play_mp3("shibai.mp3")//
	messagebox('Un-Load Palletize', lvs_outmsg ) 
end if 

st_status.text = lvs_outmsg 
return lvs_out
end function

on w_prd_product_fg_palletizing.create
int iCurrent
call super::create
this.sle_pcb_serial_no=create sle_pcb_serial_no
this.st_2=create st_2
this.st_status=create st_status
this.rb_pack=create rb_pack
this.rb_search=create rb_search
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
this.cbx_bartend=create cbx_bartend
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
this.gb_5=create gb_5
this.gb_6=create gb_6
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_pcb_serial_no
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_status
this.Control[iCurrent+4]=this.rb_pack
this.Control[iCurrent+5]=this.rb_search
this.Control[iCurrent+6]=this.sle_s_pack
this.Control[iCurrent+7]=this.sle_s_model
this.Control[iCurrent+8]=this.st_5
this.Control[iCurrent+9]=this.st_6
this.Control[iCurrent+10]=this.cb_manpack
this.Control[iCurrent+11]=this.cb_reprint
this.Control[iCurrent+12]=this.rb_normal
this.Control[iCurrent+13]=this.rb_cancel
this.Control[iCurrent+14]=this.uo_dateset
this.Control[iCurrent+15]=this.uo_dateend
this.Control[iCurrent+16]=this.st_7
this.Control[iCurrent+17]=this.cbx_sound_on
this.Control[iCurrent+18]=this.ddlb_line_code
this.Control[iCurrent+19]=this.ddlb_workstage_code
this.Control[iCurrent+20]=this.sle_unpack_barcode
this.Control[iCurrent+21]=this.cbx_unpack
this.Control[iCurrent+22]=this.st_8
this.Control[iCurrent+23]=this.st_9
this.Control[iCurrent+24]=this.cbx_bartend
this.Control[iCurrent+25]=this.gb_1
this.Control[iCurrent+26]=this.gb_2
this.Control[iCurrent+27]=this.gb_3
this.Control[iCurrent+28]=this.gb_4
this.Control[iCurrent+29]=this.gb_5
this.Control[iCurrent+30]=this.gb_6
end on

on w_prd_product_fg_palletizing.destroy
call super::destroy
destroy(this.sle_pcb_serial_no)
destroy(this.st_2)
destroy(this.st_status)
destroy(this.rb_pack)
destroy(this.rb_search)
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
destroy(this.cbx_bartend)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
destroy(this.gb_5)
destroy(this.gb_6)
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
//ls_syntax	=	f_get_dataobject('REPORT', upper(THIS.CLASSNAME()) ,  string( dw_4.dataobject )	)
//if	ls_syntax = '' or isnull(ls_syntax) then
//	f_msg_mdi_help("Report Not Changed")
//else
//	dw_4.create(ls_syntax)
//	dw_4.settransobject(sqlca)
//	f_set_column_dddw(dw_4)
//	f_dual_lang_change_dwtext(dw_4)
//	f_msg_mdi_help("Report Changed")
//end if	
end event

event ue_data_control;call super::ue_data_control;
CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		if rb_search.checked then 
			DW_1.RETRIEVE(  '%' + sle_s_pack.text + '%', '%' + sle_s_model.text + '%' , uo_dateset.text(), uo_dateend.text() )
		end if 
			
			
	CASE ELSE
END CHOOSE
end event

event open;call super::open;//Cell Biz Label $$HEX8$$e0ac15c82000a8ba78b3200015c8f4bc$$ENDHEX$$

//$$HEX7$$08cd30ae54d6200015c8f4bc2000$$ENDHEX$$
wf_init() 

//============================
//IVS_MODEL_PREFIX = '6871L-'
//IVS_CURRENT_PALLET_MODEL = 'EMPTY'
//IVL_PALLET_QTY = 0 
//IVL_PALLET_UNIT_QTY = 0 
//============================

end event

event closequery;call super::closequery;st_status.text = ' $$HEX12$$c4c989d5200011c978c7200091c7c5c52000adc01cc811c9$$ENDHEX$$....' 

return wf_close_cancel() 


end event

event resize;call super::resize;st_status.width = dw_1.width + dw_2.width
end event

type dw_5 from w_main_root`dw_5 within w_prd_product_fg_palletizing
integer x = 110
integer y = 1120
integer width = 219
integer height = 128
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_prd_product_fg_palletizing
integer x = 73
integer y = 1088
integer width = 206
integer height = 144
integer taborder = 0
end type

type dw_3 from w_main_root`dw_3 within w_prd_product_fg_palletizing
integer x = 18
integer y = 564
integer width = 1298
integer height = 352
integer taborder = 0
string dataobject = "d_prd_product_fg_pallet_barcode"
end type

type dw_2 from w_main_root`dw_2 within w_prd_product_fg_palletizing
integer x = 3090
integer y = 564
integer width = 1742
integer height = 1692
integer taborder = 0
string dataobject = "d_prd_prdouct_fg_pallet_dtl"
borderstyle borderstyle = stylebox!
end type

event dw_2::clicked;call super::clicked;sle_pcb_serial_no.setfocus( )
end event

event dw_2::retrieveend;call super::retrieveend;//em_count.text = string(rowcount)
end event

type dw_1 from w_main_root`dw_1 within w_prd_product_fg_palletizing
integer x = 18
integer y = 564
integer width = 3067
integer height = 1692
integer taborder = 0
string title = "PCB 2D List"
string dataobject = "d_prd_prdouct_fg_pallet_lst"
borderstyle borderstyle = stylebox!
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow <= 0 then return 

//sle_model.text = dw_1.object.model_name[currentrow]
//em_pack_unit.text = string( dw_1.object.packing_pcs_qty[currentrow])
dw_2.retrieve( dw_1.object.pallet_no[currentrow]  )
end event

event dw_1::itemchanged;call super::itemchanged;if upper(dwo.name) <> 'CHK' then return 

string lvs_complete, lvs_printed 

lvs_complete = this.object.pallet_status[row] 

//C Complete, P Processing $$HEX7$$0cd31bb82000c4c989d511c92000$$ENDHEX$$
if ( lvs_complete = 'C' ) then 
    return 0 
else
	return 2
end if 
end event

type uo_tabpages from w_main_root`uo_tabpages within w_prd_product_fg_palletizing
integer taborder = 0
end type

type sle_pcb_serial_no from so_singlelineedit within w_prd_product_fg_palletizing
integer x = 2565
integer y = 132
integer width = 1198
integer height = 104
integer taborder = 1
boolean bringtotop = true
integer textsize = -10
integer weight = 700
long textcolor = 65280
long backcolor = 0
boolean enabled = false
textcase textcase = upper!
borderstyle borderstyle = stylebox!
end type

event modified;call super::modified;/*************************************
* $$HEX12$$48be20000cd31bb87cc74cb52000e8cd8cc188bd00ac2000$$ENDHEX$$
*************************************/
if rb_cancel.checked and ( IVS_CURRNET_PALLET_BARCODE = 'EMPTY' ) then 
     f_msg('$$HEX16$$04d6acc72000c4c989d511c978c720000cd31bb874c72000c6c5b5c2c8b2e4b2$$ENDHEX$$. $$HEX8$$e8cd8cc188bd00ac200069d5c8b2e4b2$$ENDHEX$$.','P') 
	 this.text=''
	 this.setfocus()
	return 
end if 
/*************************************
* $$HEX20$$0cd31bb844c72000c8c06db88cac2000dcc291c7200060d54cb52000e0c2dcad20000cd31bb82000$$ENDHEX$$no $$HEX5$$b4cc88bc20005cd5e4b2$$ENDHEX$$. 
*************************************/
if IVS_CURRNET_PALLET_BARCODE = 'EMPTY' then 
   //$$HEX9$$c8c06db88cac2000dcc291c718b494b22000$$ENDHEX$$Pallet $$HEX2$$7cc74cb5$$ENDHEX$$
   //1. $$HEX3$$0cd31bb82000$$ENDHEX$$NO$$HEX11$$7cb92000c8c06db88cac2000ddc031c120005cd5e4b2$$ENDHEX$$. 
   if wf_get_new_pallet_no()  = 'NG' then 
   		if cbx_sound_on.checked then 
			f_play_mp3("shibai.mp3")  //$$HEX7$$14bc54cfdcb42000d0c5ecb72000$$ENDHEX$$
			this.text = ''
			this.setfocus() 
		end if
   end if 
end if   

/*******************************************************************************
create or replace procedure P_PRODUCT_FG_PALLETIZING(  p_pallet  varchar2,
																			  p_barcode varchar2, --$$HEX7$$acc7e0ac4cd174c714be58c72000$$ENDHEX$$Pack Barcode   
																			  p_txn     varchar2, --Type L $$HEX3$$15c8c1c02000$$ENDHEX$$, U $$HEX4$$e8cd8cc120002000$$ENDHEX$$
																			  p_mix     varchar2 default 'Y',  
																			  p_commit  varchar2, 
																			  
																			  p_out out varchar2, 
																			  p_msg out varchar2) is

*******************************************************************************/

/************************************
* $$HEX9$$0cd31bb820005cb829b5200098ccacb92000$$ENDHEX$$
*************************************/
string lvs_out , lvs_outmsg, lvs_barcode , lvs_txn_type, lvs_commit
long   lvl_row
lvs_out = space(4000)
lvs_outmsg = space(4000)

if rb_cancel.checked then
	//$$HEX9$$85c7e0ac2000e8cd8cc1200055d678c72000$$ENDHEX$$
	if messagebox('Question', f_msg('$$HEX20$$0cd31bb82000e8cd8cc17cb92000c4ac8dc12000c4c989d5200058d5dcc2a0acb5c2c8b24cae2000$$ENDHEX$$?','S') ,Question!,YesNo!,1) <> 1 then 
		return  
	end if 
end if

// lvs_commit ( $$HEX8$$04d55cb8dcc200c8b4b0d0c51cc12000$$ENDHEX$$Commit Rollback $$HEX9$$44c7200060d574acc0c92000b0ac15c82000$$ENDHEX$$'Y','N') 
// lvl_txn_type ( 1 $$HEX3$$85c7e0ac2000$$ENDHEX$$, 2 $$HEX5$$85c7e0ace8cd8cc12000$$ENDHEX$$, 3 $$HEX2$$9ccd58d5$$ENDHEX$$, 4 $$HEX5$$9ccd58d5e8cd8cc12000$$ENDHEX$$)  
lvs_barcode = this.text 

lvs_commit = 'Y' 

if rb_cancel.checked then    
	lvs_txn_type = 'U' //$$HEX3$$e8cd8cc12000$$ENDHEX$$Unloading 
else
	lvs_txn_type = 'L' //$$HEX3$$15c8c1c02000$$ENDHEX$$Loading 
end if 

//OUT $$HEX8$$c0bc18c294b2200048c5f0c40cc92000$$ENDHEX$$fETCH $$HEX2$$d0c51cc1$$ENDHEX$$
declare proc procedure for P_PRODUCT_FG_PALLETIZING ( :IVS_CURRNET_PALLET_BARCODE , :lvs_barcode, :lvs_txn_type,  'Y', :lvs_commit   ) 
using sqlca ; 

execute proc ; 
fetch proc into :lvs_out, :lvs_outmsg ; 
close proc ; 

if f_sql_check() < 0 then
	return
end if 

if lvs_out = 'NG' then 
	//$$HEX22$$b4c5a4b52000d0c678c73cc75cb82000adc01cc8200058d5c0c92000bbba58d5e0ac2000acb934d128b42000$$ENDHEX$$
	//$$HEX8$$d0c678c7200054badcc2c0c994b22000$$ENDHEX$$lvs_outmsg 	
	if cbx_sound_on.checked then 
		f_play_mp3("shibai.mp3")
	end if
	Messagebox( 'NG', lvs_outmsg )
else 
	//$$HEX3$$31c1f5ac2000$$ENDHEX$$
	if cbx_sound_on.checked then 
		f_play_mp3("chenggong.mp3")
	end if 
end if 

//$$HEX5$$31c1f5ac74c774ac2000$$ENDHEX$$NG $$HEX3$$74c774ac2000$$ENDHEX$$
st_status.text = lvs_outmsg 

DW_1.RETRIEVE(  IVS_CURRNET_PALLET_BARCODE, '%' , uo_dateset.text(), uo_dateend.text() )
this.text = '' 
this.setfocus()























end event

event getfocus;call super::getfocus;long HMC, VL
HMC = ImmGetContext( handle(parent) )
VL = ImmSetConversionStatus(  HMC, 0, 0)
ImmReleaseContext( HMC, VL) 
end event

type st_2 from statictext within w_prd_product_fg_palletizing
integer x = 2574
integer y = 60
integer width = 997
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
string text = "Barcode"
boolean focusrectangle = false
end type

type st_status from so_statictext within w_prd_product_fg_palletizing
integer x = 18
integer y = 464
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

type rb_pack from so_radiobutton within w_prd_product_fg_palletizing
integer x = 73
integer y = 164
integer width = 347
integer height = 96
boolean bringtotop = true
integer weight = 700
long textcolor = 255
long backcolor = 16777215
string text = "Palletizing"
end type

event clicked;call super::clicked;sle_pcb_serial_no.enabled = true 
cb_manpack.visible = true
cb_reprint.visible = false
dw_1.reset()
dw_2.reset()
//
sle_pcb_serial_no.setfocus()
rb_normal.enabled = true
rb_cancel.enabled = true


//un-Packing Option  
cbx_unpack.checked = false
cbx_unpack.enabled = false
sle_unpack_barcode.enabled = false
end event

type rb_search from so_radiobutton within w_prd_product_fg_palletizing
integer x = 73
integer y = 64
integer width = 302
integer height = 96
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
string text = "Retrieve"
boolean checked = true
end type

event clicked;call super::clicked;if IVS_CURRENT_PALLET_MODEL = 'EMPTY' and IVS_CURRNET_PALLET_BARCODE= 'EMPTY' then 
	//$$HEX16$$c4c989d5200011c978c72000ecd3a5c7200091c7c5c574c72000c6c544c74cb5$$ENDHEX$$..
	sle_pcb_serial_no.enabled = false 
	cb_manpack.visible = false
	cb_reprint.visible = true
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
	if messagebox('Question',f_msg('$$HEX15$$c4c989d511c978c7200091c7c5c574c7200074c8acc7200069d5c8b2e4b2$$ENDHEX$$. $$HEX23$$91c7c5c5e8cd8cc174c7c4d6200070c88cd62000a8badcb4200004c858d6200058d5dcc2a0acb5c2c8b24cae2000$$ENDHEX$$?','S'),Question!,Yesno!,1)  = 1 then 
		wf_cancel()
		sle_pcb_serial_no.enabled = false
		cb_manpack.visible = false
		cb_reprint.visible = true
		rb_normal.enabled = false
		rb_cancel.enabled = false
		rb_normal.checked = true
		//====================
		//un-packing option 
		//====================
		cbx_unpack.enabled = true

		f_retrieve()
	end if 
end if 

end event

type sle_s_pack from so_singlelineedit within w_prd_product_fg_palletizing
integer x = 617
integer y = 344
integer width = 1120
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


this.selecttext (1, 100)
end event

event modified;call super::modified;f_retrieve()
end event

type sle_s_model from so_singlelineedit within w_prd_product_fg_palletizing
integer x = 1486
integer y = 156
integer width = 590
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer weight = 700
end type

type st_5 from statictext within w_prd_product_fg_palletizing
integer x = 640
integer y = 264
integer width = 672
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
string text = "Pallet Barcode"
boolean focusrectangle = false
end type

type st_6 from statictext within w_prd_product_fg_palletizing
integer x = 1499
integer y = 80
integer width = 535
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
string text = "Model"
boolean focusrectangle = false
end type

type cb_manpack from so_commandbutton within w_prd_product_fg_palletizing
integer x = 4087
integer y = 120
integer width = 462
integer height = 256
integer taborder = 30
boolean bringtotop = true
string text = "Pallet Complete"
end type

event clicked;call super::clicked;wf_print('MANUAL')
end event

type cb_reprint from so_commandbutton within w_prd_product_fg_palletizing
integer x = 4087
integer y = 120
integer width = 462
integer height = 256
integer taborder = 40
boolean bringtotop = true
string text = "Reprint"
end type

event clicked;call super::clicked;long i 
string lvs_barcode 

if dw_1.rowcount()  < 1 then return 

for i = 1 to dw_1.rowcount() 
	//C $$HEX3$$44c6ccb82000$$ENDHEX$$P $$HEX4$$c4c989d511c92000$$ENDHEX$$
	if dw_1.getitemstring(i,'chk') = 'Y' then 
		lvs_barcode = dw_1.getitemstring(i,'pallet_no') 
		
		if cbx_bartend.checked then
			GST_RETURN.GVS_RETURN[1] = '*'
			GST_RETURN.GVS_RETURN[2] = 'P' // PALETTE
			GST_RETURN.GVS_RETURN[3] = lvs_barcode    //pack serial no $$HEX2$$84c72000$$ENDHEX$$( $$HEX6$$15bca4c2200088bc38d62000$$ENDHEX$$) 
		
			OPENWITHPARM(     W_COM_INBOX_FORM_POPUP , '*' )  
		else
			dw_3.retrieve(lvs_barcode, gvs_language) 
			st_status.text = 'Printing...' 
			dw_3.print()
		end if 
	end if
next

f_retrieve() 

st_status.text = 'reprint complete'
end event

type rb_normal from so_radiobutton within w_prd_product_fg_palletizing
integer x = 2203
integer y = 96
integer width = 325
integer height = 88
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
long backcolor = 16777215
string text = "Load"
boolean checked = true
end type

type rb_cancel from so_radiobutton within w_prd_product_fg_palletizing
integer x = 2203
integer y = 180
integer width = 329
integer height = 92
boolean bringtotop = true
integer weight = 700
long textcolor = 255
long backcolor = 16777215
string text = "UnLoad"
end type

type uo_dateset from uo_ymd_calendar within w_prd_product_fg_palletizing
integer x = 613
integer y = 156
integer taborder = 50
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_prd_product_fg_palletizing
integer x = 1038
integer y = 156
integer taborder = 60
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_7 from statictext within w_prd_product_fg_palletizing
integer x = 645
integer y = 80
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
string text = "Palletizing Date"
alignment alignment = center!
boolean focusrectangle = false
end type

type cbx_sound_on from so_checkbox within w_prd_product_fg_palletizing
integer x = 3781
integer y = 132
integer width = 270
boolean bringtotop = true
integer weight = 700
long backcolor = 134217742
string text = "Sound"
boolean checked = true
end type

type ddlb_line_code from uo_line_code_dd within w_prd_product_fg_palletizing
boolean visible = false
integer x = 4649
integer y = 192
integer width = 270
integer height = 244
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
end type

event constructor;call super::constructor;//RegistryGet( "HKEY_LOCAL_MACHINE\Software\Infinity21\"+GVS_APPLICATION_NAME, "IO_LINE", RegString!,  IVS_LINE_CODE)

ivs_line_code = Profilestring("WORKENV.INI","LINE","FG_PALLETIZING","")

THIS.SELECtitem(IVS_LINE_CODE )


//SetProfileString ("WORKENV.INI", "PRINT", "print_name1", THIS.TEXT )
//GVS_PRINT_NAME_1 = Profilestring("WORKENV.INI","PRINT","print_name1","")
end event

event selectionchanged;call super::selectionchanged;IVS_LINE_CODE = THIS.GETCODE()
f_jsSetProfileString ("WORKENV.INI", "LINE", "FG_PALLETIZING", THIS.GETCODE() )
if rb_pack.checked then
	sle_pcb_serial_no.setfocus()
end if 
end event

type ddlb_workstage_code from uo_workstage_code_all within w_prd_product_fg_palletizing
boolean visible = false
integer x = 4951
integer y = 192
integer width = 370
integer height = 252
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
end type

event constructor;call super::constructor;//RegistryGet( "HKEY_LOCAL_MACHINE\Software\Infinity21\"+GVS_APPLICATION_NAME, "IO_WORKSTAGE", RegString!,  IVS_WORKSTAGE_CODE)
//THIS.SELECtitem(IVS_WORKSTAGE_CODE )

IVS_WORKSTAGE_CODE = Profilestring("WORKENV.INI","WORKSTAGE","FG_PALLETIZING","")
THIS.SELECtitem(IVS_WORKSTAGE_CODE )
end event

event selectionchanged;call super::selectionchanged;IVS_WORkstage_code = THIS.GETCODE()
f_jsSetProfileString ("WORKENV.INI", "WORKSTAGE", "FG_PALLETIZING", THIS.GETCODE() )

if rb_pack.checked then
	sle_pcb_serial_no.setfocus()
end if 
end event

type sle_unpack_barcode from so_singlelineedit within w_prd_product_fg_palletizing
integer x = 2574
integer y = 340
integer width = 1445
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
long textcolor = 16777215
long backcolor = 255
boolean enabled = false
end type

event modified;call super::modified;string lvs_return 
//$$HEX9$$0cd31bb8c0d074c7d5c92000adc01cc82000$$ENDHEX$$

if messagebox('Question', this.text + f_msg(' $$HEX13$$0cd31bb844c72000adc01cc8200058d5dcc2a0acb5c2c8b24cae$$ENDHEX$$? ','S'),Question!,YesNo!,1) = 1 then  
	lvs_return = wf_unload_pallet(this.text)
	
	if cbx_sound_on.checked then 
		if lvs_return = 'OK' then  
			f_play_mp3("chenggong.mp3")  //$$HEX6$$14bc54cfdcb42000d0c5ecb7$$ENDHEX$$
		end if 
	end if
	
end if 

dw_1.reset()
dw_2.reset()
f_retrieve() 

this.text = ""
this.setfocus() 

end event

type cbx_unpack from so_checkbox within w_prd_product_fg_palletizing
integer x = 2181
integer y = 344
integer width = 370
boolean bringtotop = true
integer weight = 700
long backcolor = 134217742
string text = "Un-Load"
end type

event clicked;call super::clicked;if this.checked then 
	sle_unpack_barcode.enabled = true
	sle_unpack_barcode.setfocus() 
else 
	sle_unpack_barcode.enabled = false 
end if 
end event

type st_8 from statictext within w_prd_product_fg_palletizing
boolean visible = false
integer x = 4622
integer y = 108
integer width = 270
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421504
long backcolor = 16777215
string text = "Line"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_9 from statictext within w_prd_product_fg_palletizing
boolean visible = false
integer x = 4942
integer y = 104
integer width = 370
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421504
long backcolor = 16777215
string text = "WorkStage"
alignment alignment = center!
long bordercolor = 8421504
boolean focusrectangle = false
end type

type cbx_bartend from so_checkbox within w_prd_product_fg_palletizing
integer x = 73
integer y = 352
boolean bringtotop = true
long backcolor = 16777215
string text = "Bartend"
boolean checked = true
end type

type gb_1 from so_groupbox within w_prd_product_fg_palletizing
boolean visible = false
integer x = 4613
integer y = 28
integer width = 759
integer height = 348
integer weight = 700
long textcolor = 16711680
long backcolor = 16777215
string text = "Work Condition"
end type

type gb_2 from so_groupbox within w_prd_product_fg_palletizing
integer x = 2153
integer y = 4
integer width = 1902
integer height = 292
integer taborder = 10
integer weight = 700
long textcolor = 255
long backcolor = 16777215
string text = "Scan Condition"
end type

type gb_3 from so_groupbox within w_prd_product_fg_palletizing
integer x = 558
integer y = 4
integer width = 1586
integer height = 460
integer taborder = 20
integer weight = 700
long textcolor = 16711680
long backcolor = 16777215
string text = "Search Condition"
end type

type gb_4 from so_groupbox within w_prd_product_fg_palletizing
integer x = 4069
integer y = 4
integer width = 507
integer height = 452
integer taborder = 10
integer weight = 700
long textcolor = 16711680
long backcolor = 16777215
string text = "Process"
end type

type gb_5 from so_groupbox within w_prd_product_fg_palletizing
integer x = 9
integer y = 4
integer width = 539
integer height = 460
integer taborder = 40
integer weight = 700
long textcolor = 255
long backcolor = 16777215
string text = "Function"
end type

type gb_6 from so_groupbox within w_prd_product_fg_palletizing
integer x = 2153
integer y = 296
integer width = 1902
integer height = 164
integer taborder = 20
integer weight = 700
long textcolor = 255
long backcolor = 16777215
string text = "UnLoad Pallet"
end type

