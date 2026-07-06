HA$PBExportHeader$w_prd_product_fg_receipt.srw
$PBExportComments$finish goods $$HEX3$$85c7e0ac2000$$ENDHEX$$/ $$HEX6$$85c7e0ac2000e8cd8cc12000$$ENDHEX$$2017.03.29
forward
global type w_prd_product_fg_receipt from w_main_root
end type
type sle_pcb_serial_no from so_singlelineedit within w_prd_product_fg_receipt
end type
type st_2 from statictext within w_prd_product_fg_receipt
end type
type st_status from so_statictext within w_prd_product_fg_receipt
end type
type rb_receipt from so_radiobutton within w_prd_product_fg_receipt
end type
type rb_search from so_radiobutton within w_prd_product_fg_receipt
end type
type sle_s_pack from so_singlelineedit within w_prd_product_fg_receipt
end type
type sle_s_model from so_singlelineedit within w_prd_product_fg_receipt
end type
type st_5 from statictext within w_prd_product_fg_receipt
end type
type st_6 from statictext within w_prd_product_fg_receipt
end type
type rb_normal from so_radiobutton within w_prd_product_fg_receipt
end type
type rb_cancel from so_radiobutton within w_prd_product_fg_receipt
end type
type uo_dateset from uo_ymd_calendar within w_prd_product_fg_receipt
end type
type uo_dateend from uo_ymd_calendar within w_prd_product_fg_receipt
end type
type st_7 from statictext within w_prd_product_fg_receipt
end type
type cbx_sound_on from so_checkbox within w_prd_product_fg_receipt
end type
type ddlb_line_code from uo_line_code_dd within w_prd_product_fg_receipt
end type
type ddlb_workstage_code from uo_workstage_code_all within w_prd_product_fg_receipt
end type
type st_8 from statictext within w_prd_product_fg_receipt
end type
type st_9 from statictext within w_prd_product_fg_receipt
end type
type ddlb_product_location from uo_basecode within w_prd_product_fg_receipt
end type
type st_10 from statictext within w_prd_product_fg_receipt
end type
type ddlb_txn_deficit from uo_basecode within w_prd_product_fg_receipt
end type
type st_1 from statictext within w_prd_product_fg_receipt
end type
type cbx_use_bartend from so_checkbox within w_prd_product_fg_receipt
end type
type rb_reprint from so_radiobutton within w_prd_product_fg_receipt
end type
type st_3 from statictext within w_prd_product_fg_receipt
end type
type gb_reprint from so_groupbox within w_prd_product_fg_receipt
end type
type gb_2 from so_groupbox within w_prd_product_fg_receipt
end type
type gb_3 from so_groupbox within w_prd_product_fg_receipt
end type
type gb_5 from so_groupbox within w_prd_product_fg_receipt
end type
type gb_4 from so_groupbox within w_prd_product_fg_receipt
end type
type sle_re_packcode from so_singlelineedit within w_prd_product_fg_receipt
end type
end forward

global type w_prd_product_fg_receipt from w_main_root
integer width = 4928
integer height = 2380
string title = "Product Receipt Master"
long backcolor = 16777215
string ivs_modify_security = "N"
string ivs_dw_1_use_focusindicator = "N"
string ivs_dw_1_selected_row_yn = "N"
sle_pcb_serial_no sle_pcb_serial_no
st_2 st_2
st_status st_status
rb_receipt rb_receipt
rb_search rb_search
sle_s_pack sle_s_pack
sle_s_model sle_s_model
st_5 st_5
st_6 st_6
rb_normal rb_normal
rb_cancel rb_cancel
uo_dateset uo_dateset
uo_dateend uo_dateend
st_7 st_7
cbx_sound_on cbx_sound_on
ddlb_line_code ddlb_line_code
ddlb_workstage_code ddlb_workstage_code
st_8 st_8
st_9 st_9
ddlb_product_location ddlb_product_location
st_10 st_10
ddlb_txn_deficit ddlb_txn_deficit
st_1 st_1
cbx_use_bartend cbx_use_bartend
rb_reprint rb_reprint
st_3 st_3
gb_reprint gb_reprint
gb_2 gb_2
gb_3 gb_3
gb_5 gb_5
gb_4 gb_4
sle_re_packcode sle_re_packcode
end type
global w_prd_product_fg_receipt w_prd_product_fg_receipt

type prototypes


end prototypes

type variables
//
STRING IVS_LINE_CODE, IVS_WORkstage_code, IVS_PRODUCT_LOCATION
end variables

forward prototypes
public subroutine wf_init ()
public function string wf_final_inspect (string arg_barcode)
end prototypes

public subroutine wf_init ();//=========================
// $$HEX4$$08cd30ae54d62000$$ENDHEX$$
//=========================
sle_pcb_serial_no.text = '' 
sle_pcb_serial_no.setfocus()
st_status.text = f_msg('Wating..','S')

end subroutine

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

on w_prd_product_fg_receipt.create
int iCurrent
call super::create
this.sle_pcb_serial_no=create sle_pcb_serial_no
this.st_2=create st_2
this.st_status=create st_status
this.rb_receipt=create rb_receipt
this.rb_search=create rb_search
this.sle_s_pack=create sle_s_pack
this.sle_s_model=create sle_s_model
this.st_5=create st_5
this.st_6=create st_6
this.rb_normal=create rb_normal
this.rb_cancel=create rb_cancel
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.st_7=create st_7
this.cbx_sound_on=create cbx_sound_on
this.ddlb_line_code=create ddlb_line_code
this.ddlb_workstage_code=create ddlb_workstage_code
this.st_8=create st_8
this.st_9=create st_9
this.ddlb_product_location=create ddlb_product_location
this.st_10=create st_10
this.ddlb_txn_deficit=create ddlb_txn_deficit
this.st_1=create st_1
this.cbx_use_bartend=create cbx_use_bartend
this.rb_reprint=create rb_reprint
this.st_3=create st_3
this.gb_reprint=create gb_reprint
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_5=create gb_5
this.gb_4=create gb_4
this.sle_re_packcode=create sle_re_packcode
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_pcb_serial_no
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_status
this.Control[iCurrent+4]=this.rb_receipt
this.Control[iCurrent+5]=this.rb_search
this.Control[iCurrent+6]=this.sle_s_pack
this.Control[iCurrent+7]=this.sle_s_model
this.Control[iCurrent+8]=this.st_5
this.Control[iCurrent+9]=this.st_6
this.Control[iCurrent+10]=this.rb_normal
this.Control[iCurrent+11]=this.rb_cancel
this.Control[iCurrent+12]=this.uo_dateset
this.Control[iCurrent+13]=this.uo_dateend
this.Control[iCurrent+14]=this.st_7
this.Control[iCurrent+15]=this.cbx_sound_on
this.Control[iCurrent+16]=this.ddlb_line_code
this.Control[iCurrent+17]=this.ddlb_workstage_code
this.Control[iCurrent+18]=this.st_8
this.Control[iCurrent+19]=this.st_9
this.Control[iCurrent+20]=this.ddlb_product_location
this.Control[iCurrent+21]=this.st_10
this.Control[iCurrent+22]=this.ddlb_txn_deficit
this.Control[iCurrent+23]=this.st_1
this.Control[iCurrent+24]=this.cbx_use_bartend
this.Control[iCurrent+25]=this.rb_reprint
this.Control[iCurrent+26]=this.st_3
this.Control[iCurrent+27]=this.gb_reprint
this.Control[iCurrent+28]=this.gb_2
this.Control[iCurrent+29]=this.gb_3
this.Control[iCurrent+30]=this.gb_5
this.Control[iCurrent+31]=this.gb_4
this.Control[iCurrent+32]=this.sle_re_packcode
end on

on w_prd_product_fg_receipt.destroy
call super::destroy
destroy(this.sle_pcb_serial_no)
destroy(this.st_2)
destroy(this.st_status)
destroy(this.rb_receipt)
destroy(this.rb_search)
destroy(this.sle_s_pack)
destroy(this.sle_s_model)
destroy(this.st_5)
destroy(this.st_6)
destroy(this.rb_normal)
destroy(this.rb_cancel)
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.st_7)
destroy(this.cbx_sound_on)
destroy(this.ddlb_line_code)
destroy(this.ddlb_workstage_code)
destroy(this.st_8)
destroy(this.st_9)
destroy(this.ddlb_product_location)
destroy(this.st_10)
destroy(this.ddlb_txn_deficit)
destroy(this.st_1)
destroy(this.cbx_use_bartend)
destroy(this.rb_reprint)
destroy(this.st_3)
destroy(this.gb_reprint)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_5)
destroy(this.gb_4)
destroy(this.sle_re_packcode)
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


end event

event ue_data_control;call super::ue_data_control;
CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		if rb_search.checked then 
			DW_2.RETRIEVE(  gvs_language , uo_dateset.text(), uo_dateend.text() , sle_s_model.text + '%', sle_s_pack.text + '%', ddlb_txn_deficit.getcode() + '%' )
		end if 
		
			
			
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

//return wf_close_cancel() 


end event

event resize;call super::resize;st_status.width = dw_1.width + dw_2.width
end event

type dw_5 from w_main_root`dw_5 within w_prd_product_fg_receipt
integer x = 110
integer y = 1120
integer width = 219
integer height = 128
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_prd_product_fg_receipt
integer x = 73
integer y = 1088
integer width = 206
integer height = 144
integer taborder = 0
end type

type dw_3 from w_main_root`dw_3 within w_prd_product_fg_receipt
integer x = 73
integer y = 1120
integer width = 1298
integer height = 348
integer taborder = 0
end type

type dw_2 from w_main_root`dw_2 within w_prd_product_fg_receipt
integer x = 2798
integer y = 700
integer width = 2034
integer height = 1572
integer taborder = 0
string dataobject = "d_product_fg_receipt_lst"
borderstyle borderstyle = stylebox!
end type

event dw_2::clicked;call super::clicked;sle_pcb_serial_no.setfocus( )
end event

type dw_1 from w_main_root`dw_1 within w_prd_product_fg_receipt
integer x = 9
integer y = 700
integer width = 2775
integer height = 1572
integer taborder = 0
string title = "PCB 2D List"
string dataobject = "d_product_fg_receipt_log"
borderstyle borderstyle = stylebox!
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow <= 0 then return 

//dw_2.retrieve( dw_1.object.pack_barcode[currentrow]  )
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

type uo_tabpages from w_main_root`uo_tabpages within w_prd_product_fg_receipt
integer taborder = 0
end type

type sle_pcb_serial_no from so_singlelineedit within w_prd_product_fg_receipt
integer x = 1513
integer y = 424
integer width = 1513
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

event modified;call super::modified;//Unpack $$HEX3$$7cc74cb52000$$ENDHEX$$

//=================================================
string lvs_out , lvs_outmsg, lvs_barcode, lvs_location, lvs_commit , lvs_interlock_return, lvs_model_name
long lvl_txn_type, lvl_row
lvs_out = space(4000)
lvs_outmsg = space(4000)

if rb_cancel.checked then
	//$$HEX9$$85c7e0ac2000e8cd8cc1200055d678c72000$$ENDHEX$$
	if messagebox('Question', f_msg('$$HEX20$$85c7e0ac2000e8cd8cc17cb92000c4ac8dc12000c4c989d5200058d5dcc2a0acb5c2c8b24cae2000$$ENDHEX$$?','S') ,Question!,YesNo!,1) <> 1 then 
		return  
	end if 
end if

// lvs_commit ( $$HEX8$$04d55cb8dcc200c8b4b0d0c51cc12000$$ENDHEX$$Commit Rollback $$HEX9$$44c7200060d574acc0c92000b0ac15c82000$$ENDHEX$$'Y','N') 
// lvl_txn_type ( 1 $$HEX3$$85c7e0ac2000$$ENDHEX$$, 2 $$HEX5$$85c7e0ace8cd8cc12000$$ENDHEX$$, 3 $$HEX2$$9ccd58d5$$ENDHEX$$, 4 $$HEX5$$9ccd58d5e8cd8cc12000$$ENDHEX$$)  
lvs_barcode = this.text 
lvs_location = IVS_PRODUCT_LOCATION //ddlb_product_location.getcode() 
lvs_commit = 'Y' 

if rb_cancel.checked then    
	lvl_txn_type = 2 //$$HEX6$$85c7e0ac2000e8cd8cc12000$$ENDHEX$$
else
	lvl_txn_type = 1 //$$HEX5$$15c8c1c0200085c7e0ac$$ENDHEX$$
end if 

//$$HEX13$$85c7e0ac7cc74cb5200055d678c7200074d57cc5200068d52000$$ENDHEX$$
if rb_normal.checked then 
	if lvs_location = '' or isnull(lvs_location) or lvs_location = '%' then 
		f_play_sound( "$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav") //$$HEX3$$e4c228d32000$$ENDHEX$$
		f_msg('$$HEX19$$85c7e0ac20001cc888d420005cb800cf74c758c144c7200020c1ddd0200058d538c194c62000$$ENDHEX$$!', 'P')
		st_status.text = f_msg('$$HEX19$$85c7e0ac20001cc888d420005cb800cf74c758c144c7200020c1ddd0200058d538c194c62000$$ENDHEX$$!', 'S')
		return 
	end if
end if


IF lvl_txn_type = 1  then //$$HEX5$$15c8c1c0200085c7e0ac$$ENDHEX$$
		//==================================================
		// $$HEX7$$78c730d17db72000b4cc6cd02000$$ENDHEX$$
		//==================================================
		  st_status.text = "Interlock Check Processing..."
		  
		  lvs_interlock_return = f_check_interlock_condition( '*' , '*' , lvs_barcode ) 
		  if lvs_interlock_return <> 'OK'  then 
			 st_status.text = "Interlock Check => " +lvs_interlock_return
			return 
		  else
			  st_status.text = "Interlock Check OK"
		  end if 
end if 

//OUT $$HEX8$$c0bc18c294b2200048c5f0c40cc92000$$ENDHEX$$fETCH $$HEX2$$d0c51cc1$$ENDHEX$$
declare proc procedure for P_PRODUCT_FG_RECEIPT ( :lvs_barcode , :lvs_location, :lvl_txn_type, :lvs_commit   ) 
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
		f_play_sound( "$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav") //$$HEX3$$e4c228d32000$$ENDHEX$$
	end if
	Messagebox( 'NG', lvs_outmsg )
else 
	//$$HEX3$$31c1f5ac2000$$ENDHEX$$
	if cbx_sound_on.checked then 
		f_play_sound( "$$HEX4$$00c8a5c731c1f5ac$$ENDHEX$$.wav") //$$HEX3$$e4c228d32000$$ENDHEX$$
	end if 
	
	if lvl_txn_type = 1 then
		/********************************************************/
		/*$$HEX90$$14bc50d154b320007cb7a8bc44c720009ccd25b820005cd5e4b220002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000$$ENDHEX$$*/ 
		/********************************************************/
		if cbx_use_bartend.checked then 
			
			gst_return.gvl_return[1]  =1 // $$HEX5$$9ccd25b8a5c718c22000$$ENDHEX$$
			  openwithparm( w_com_bartneder_fg_receipt_form_popup , lvs_barcode ) 
			  
		  
//			SELECT model_name
//			into :lvs_model_name 
//			FROM ip_product_pack_master
//			where organization_id = :gvi_organization_id 
//			    and pack_barcode    = :lvs_barcode ; 
//			GST_RETURN.GVS_RETURN[1] = LVS_MODEL_NAME
//			GST_RETURN.GVS_RETURN[2] = 'B' // INBOX
//			GST_RETURN.GVS_RETURN[3] = lvs_barcode    //pack serial no $$HEX2$$84c72000$$ENDHEX$$( $$HEX6$$15bca4c2200088bc38d62000$$ENDHEX$$) 
//			//OPENWITHPARM(     W_COM_INBOX_FORM_POPUP , lvs_runno )  
//			OPENWITHPARM(     W_COM_INBOX_FORM_POPUP , '*' )  

		end if 
	end if
	
end if 

//$$HEX5$$31c1f5ac74c774ac2000$$ENDHEX$$NG $$HEX3$$74c774ac2000$$ENDHEX$$
st_status.text = lvs_outmsg 

lvl_row = dw_1.insertrow(0)
dw_1.setitem(lvl_row, 'result', lvs_out ) 
dw_1.setitem(lvl_row, 'messages',lvs_outmsg ) 

dw_1.scrolltorow(lvl_row)

this.text = '' 
this.setfocus()


end event

event getfocus;call super::getfocus;long HMC, VL
HMC = ImmGetContext( handle(parent) )
VL = ImmSetConversionStatus(  HMC, 0, 0)
ImmReleaseContext( HMC, VL) 
end event

type st_2 from statictext within w_prd_product_fg_receipt
integer x = 1522
integer y = 348
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

type st_status from so_statictext within w_prd_product_fg_receipt
integer x = 14
integer y = 588
integer width = 4823
integer height = 104
boolean bringtotop = true
integer textsize = -12
integer weight = 700
long textcolor = 65280
long backcolor = 0
string text = "Message"
boolean border = true
end type

type rb_receipt from so_radiobutton within w_prd_product_fg_receipt
integer x = 78
integer y = 180
integer width = 357
integer height = 72
boolean bringtotop = true
integer weight = 700
long textcolor = 255
long backcolor = 16777215
string text = "FG Receipt"
end type

event clicked;call super::clicked;
rb_normal.enabled = true
rb_cancel.enabled = true
rb_normal.checked = true
sle_pcb_serial_no.enabled = true 

//reprint 
//sle_re_packcode.enabled =false 
sle_re_packcode.visible =false
gb_reprint.visible = false
st_3.visible = false 

dw_1.reset()
dw_2.reset()

//$$HEX8$$91c588d420003dcce0ac200020c1ddd0$$ENDHEX$$
ddlb_product_location.SELECtitem('P01')

st_status.text = f_msg('$$HEX15$$85c7e0ac60d5200014bc54cfdcb47cb92000a4c294ce200058d538c194c6$$ENDHEX$$','S')
sle_pcb_serial_no.text = '' 
sle_pcb_serial_no.setfocus()


end event

type rb_search from so_radiobutton within w_prd_product_fg_receipt
integer x = 78
integer y = 92
integer width = 302
integer height = 72
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
string text = "Retrieve"
boolean checked = true
end type

event clicked;call super::clicked;	//$$HEX16$$c4c989d5200011c978c72000ecd3a5c7200091c7c5c574c72000c6c544c74cb5$$ENDHEX$$..
	sle_pcb_serial_no.enabled = false 
	rb_normal.enabled = false
	rb_cancel.enabled = false
	
	//reprint 
	sle_re_packcode.visible =false
	gb_reprint.visible = false
	st_3.visible = false
	
    st_status.text = f_msg('$$HEX15$$70c874ac44c7200085c725b858d5e0ac200070c88cd6200058d538c194c6$$ENDHEX$$','S')
	 
	 
	 
	//f_retrieve()

end event

type sle_s_pack from so_singlelineedit within w_prd_product_fg_receipt
integer x = 1504
integer y = 132
integer width = 855
integer height = 84
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

type sle_s_model from so_singlelineedit within w_prd_product_fg_receipt
integer x = 2368
integer y = 132
integer width = 553
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer weight = 700
end type

type st_5 from statictext within w_prd_product_fg_receipt
integer x = 1522
integer y = 56
integer width = 791
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
string text = " Barcode"
boolean focusrectangle = false
end type

type st_6 from statictext within w_prd_product_fg_receipt
integer x = 2382
integer y = 56
integer width = 480
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

type rb_normal from so_radiobutton within w_prd_product_fg_receipt
integer x = 617
integer y = 376
integer width = 361
integer height = 88
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
long backcolor = 16777215
boolean enabled = false
string text = "Receipt"
boolean checked = true
end type

event clicked;call super::clicked;sle_pcb_serial_no.textColor  = RGB(0,255,0)
sle_pcb_serial_no.backColor = RGB(0,0,0)

st_status.text = f_msg('$$HEX16$$85c7e0ac98ccacb9200014bc54cfdcb47cb92000a4c294ce200058d538c194c6$$ENDHEX$$','S')

sle_pcb_serial_no.text = ''
sle_pcb_serial_no.setfocus()
end event

type rb_cancel from so_radiobutton within w_prd_product_fg_receipt
integer x = 617
integer y = 452
integer width = 361
integer height = 92
boolean bringtotop = true
integer weight = 700
long textcolor = 255
long backcolor = 16777215
boolean enabled = false
string text = "Cancel"
end type

event clicked;call super::clicked;sle_pcb_serial_no.textColor = RGB(255,255,255)
sle_pcb_serial_no.backColor = RGB(255,0,0)

st_status.text = f_msg('$$HEX18$$85c7e0ac2000e8cd8cc160d5200014bc54cfdcb47cb92000a4c294ce200058d538c194c6$$ENDHEX$$','S')

sle_pcb_serial_no.text = ''
sle_pcb_serial_no.setfocus()
end event

type uo_dateset from uo_ymd_calendar within w_prd_product_fg_receipt
integer x = 645
integer y = 132
integer taborder = 50
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_prd_product_fg_receipt
integer x = 1070
integer y = 132
integer taborder = 60
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_7 from statictext within w_prd_product_fg_receipt
integer x = 677
integer y = 56
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
string text = "Receipt Date"
alignment alignment = center!
boolean focusrectangle = false
end type

type cbx_sound_on from so_checkbox within w_prd_product_fg_receipt
integer x = 78
integer y = 468
integer width = 311
boolean bringtotop = true
integer weight = 700
long backcolor = 134217742
string text = "Sound"
boolean checked = true
end type

type ddlb_line_code from uo_line_code_dd within w_prd_product_fg_receipt
boolean visible = false
integer x = 3598
integer y = 136
integer width = 466
integer height = 800
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
end type

event constructor;call super::constructor;//RegistryGet( "HKEY_LOCAL_MACHINE\Software\Infinity21\"+GVS_APPLICATION_NAME, "IO_LINE", RegString!,  IVS_LINE_CODE)

ivs_line_code = Profilestring("WORKENV.INI","LINE","FG_RECEIPT","")

THIS.SELECtitem(IVS_LINE_CODE )


//SetProfileString ("WORKENV.INI", "PRINT", "print_name1", THIS.TEXT )
//GVS_PRINT_NAME_1 = Profilestring("WORKENV.INI","PRINT","print_name1","")
end event

event selectionchanged;call super::selectionchanged;IVS_LINE_CODE = THIS.GETCODE()
f_jsSetProfileString ("WORKENV.INI", "LINE", "FG_RECEIPT", THIS.GETCODE() )
if rb_receipt.checked then
	sle_pcb_serial_no.setfocus()
end if 
end event

type ddlb_workstage_code from uo_workstage_code_all within w_prd_product_fg_receipt
boolean visible = false
integer x = 4073
integer y = 136
integer height = 1368
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
end type

event constructor;call super::constructor;//RegistryGet( "HKEY_LOCAL_MACHINE\Software\Infinity21\"+GVS_APPLICATION_NAME, "IO_WORKSTAGE", RegString!,  IVS_WORKSTAGE_CODE)
//THIS.SELECtitem(IVS_WORKSTAGE_CODE )

IVS_WORKSTAGE_CODE = Profilestring("WORKENV.INI","WORKSTAGE","FG_RECEIPT","")
THIS.SELECtitem(IVS_WORKSTAGE_CODE )
end event

event selectionchanged;call super::selectionchanged;IVS_WORkstage_code = THIS.GETCODE()
f_jsSetProfileString ("WORKENV.INI", "WORKSTAGE", "FG_RECEIPT", THIS.GETCODE() )

if rb_receipt.checked then
	sle_pcb_serial_no.setfocus()
end if 
end event

type st_8 from statictext within w_prd_product_fg_receipt
boolean visible = false
integer x = 3579
integer y = 60
integer width = 466
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

type st_9 from statictext within w_prd_product_fg_receipt
boolean visible = false
integer x = 4046
integer y = 60
integer width = 631
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

type ddlb_product_location from uo_basecode within w_prd_product_fg_receipt
integer x = 1001
integer y = 428
integer width = 503
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
end type

event constructor;call super::constructor;this.redraw('PRODUCT LOCATION CODE')

IVS_PRODUCT_LOCATION = Profilestring("WORKENV.INI","PRODUCT_LOCATION","FG_RECEIPT","")

THIS.SELECtitem(IVS_PRODUCT_LOCATION )

end event

event selectionchanged;call super::selectionchanged;IVS_PRODUCT_LOCATION = THIS.GETCODE()
f_jsSetProfileString ("WORKENV.INI", "PRODUCT_LOCATION", "FG_RECEIPT", THIS.GETCODE() )

if rb_receipt.checked then
	sle_pcb_serial_no.text = ''
	sle_pcb_serial_no.setfocus()
	
end if 
end event

type st_10 from statictext within w_prd_product_fg_receipt
integer x = 1006
integer y = 348
integer width = 453
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
string text = "Location"
boolean focusrectangle = false
end type

type ddlb_txn_deficit from uo_basecode within w_prd_product_fg_receipt
integer x = 2939
integer y = 132
integer width = 503
integer taborder = 50
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw('TXN DEFICIT')


end event

type st_1 from statictext within w_prd_product_fg_receipt
integer x = 2939
integer y = 56
integer width = 480
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
string text = "Txn Deficit"
boolean focusrectangle = false
end type

type cbx_use_bartend from so_checkbox within w_prd_product_fg_receipt
integer x = 78
integer y = 388
integer width = 311
integer height = 80
boolean bringtotop = true
integer weight = 700
long backcolor = 134217742
string text = "Bartend"
end type

type rb_reprint from so_radiobutton within w_prd_product_fg_receipt
integer x = 78
integer y = 264
integer width = 357
integer height = 72
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
long backcolor = 16777215
string text = "Reprint"
end type

event clicked;call super::clicked;//sle_re_packcode.enabled =true 
gb_reprint.visible = true
sle_re_packcode.visible =true 

st_3.visible = true 

rb_normal.enabled = false
rb_cancel.enabled = false
rb_normal.checked = false
sle_pcb_serial_no.enabled = false 
dw_1.reset()
dw_2.reset()
//==================================
st_status.text = f_msg('$$HEX15$$9ccd25b860d5200014bc54cfdcb47cb92000a4c294ce200058d538c194c6$$ENDHEX$$','S')
sle_re_packcode.text = '' 
sle_re_packcode.setfocus()


end event

type st_3 from statictext within w_prd_product_fg_receipt
boolean visible = false
integer x = 3127
integer y = 352
integer width = 1111
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
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_reprint from so_groupbox within w_prd_product_fg_receipt
boolean visible = false
integer x = 3090
integer y = 292
integer width = 1184
integer height = 288
integer weight = 700
long textcolor = 16711680
long backcolor = 16777215
string text = "RePrint"
end type

type gb_2 from so_groupbox within w_prd_product_fg_receipt
integer x = 567
integer y = 292
integer width = 2514
integer height = 288
integer taborder = 10
integer weight = 700
long textcolor = 255
long backcolor = 16777215
string text = "Scan Condition"
end type

type gb_3 from so_groupbox within w_prd_product_fg_receipt
integer x = 567
integer y = 4
integer width = 2976
integer height = 284
integer taborder = 20
integer weight = 700
long textcolor = 16711680
long backcolor = 16777215
string text = "Search Condition"
end type

type gb_5 from so_groupbox within w_prd_product_fg_receipt
integer x = 14
integer y = 4
integer width = 539
integer height = 576
integer taborder = 40
integer weight = 700
long textcolor = 255
long backcolor = 16777215
string text = "Function"
end type

type gb_4 from so_groupbox within w_prd_product_fg_receipt
boolean visible = false
integer x = 3552
integer y = 4
integer width = 1184
integer height = 284
integer taborder = 30
integer weight = 700
long textcolor = 16711680
long backcolor = 16777215
string text = "Work Condition"
end type

type sle_re_packcode from so_singlelineedit within w_prd_product_fg_receipt
boolean visible = false
integer x = 3122
integer y = 420
integer width = 1111
integer height = 104
integer taborder = 11
boolean bringtotop = true
integer textsize = -10
integer weight = 700
long textcolor = 65280
long backcolor = 0
textcase textcase = upper!
borderstyle borderstyle = stylebox!
end type

event getfocus;call super::getfocus;long HMC, VL
HMC = ImmGetContext( handle(parent) )
VL = ImmSetConversionStatus(  HMC, 0, 0)
ImmReleaseContext( HMC, VL) 
end event

event modified;call super::modified;//REPRINT  
string lvs_barcode , lvs_model_name
long lvl_count 

lvs_barcode = this.text 

/********************************************************/
/*$$HEX90$$14bc50d154b320007cb7a8bc44c720009ccd25b820005cd5e4b220002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000$$ENDHEX$$*/ 
/********************************************************/
if cbx_use_bartend.checked then 
	select count(*) 
	  into :lvl_count
	  from ip_product_pack_master 
	where  organization_id = :gvi_organization_id 
	    and pack_barcode    = :lvs_barcode  
		and receipt_flag = 'Y' ; 
	
	if lvl_count < 1 then
		f_msg(lvs_barcode + ' $$HEX15$$85c7e0ac18b4c0c920004ac540c7200014bc54cfdcb4200085c7c8b2e4b2$$ENDHEX$$. $$HEX7$$55d678c7200058d538c194c62000$$ENDHEX$$!','P') 
		this.text = '' 
		this.setfocus()
		return 
	end if 
		
	
	SELECT model_name
	into :lvs_model_name 
	FROM ip_product_pack_master
	where organization_id = :gvi_organization_id 
		 and pack_barcode    = :lvs_barcode ; 
	
	
		 
	GST_RETURN.GVS_RETURN[1] = LVS_MODEL_NAME
	GST_RETURN.GVS_RETURN[2] = 'B' // INBOX
	GST_RETURN.GVS_RETURN[3] = lvs_barcode    //pack serial no $$HEX2$$84c72000$$ENDHEX$$( $$HEX6$$15bca4c2200088bc38d62000$$ENDHEX$$) 
	//OPENWITHPARM(     W_COM_INBOX_FORM_POPUP , lvs_runno )  
	OPENWITHPARM(     W_COM_INBOX_FORM_POPUP , '*' )  

end if 

this.text = '' 
this.setfocus()


end event

