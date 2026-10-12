HA$PBExportHeader$w_prd_product_fg_issue.srw
$PBExportComments$FG $$HEX4$$9ccd58d591c7c5c5$$ENDHEX$$
forward
global type w_prd_product_fg_issue from w_main_root
end type
type sle_pcb_serial_no from so_singlelineedit within w_prd_product_fg_issue
end type
type st_2 from statictext within w_prd_product_fg_issue
end type
type st_status from so_statictext within w_prd_product_fg_issue
end type
type rb_pack from so_radiobutton within w_prd_product_fg_issue
end type
type rb_search from so_radiobutton within w_prd_product_fg_issue
end type
type sle_s_pack from so_singlelineedit within w_prd_product_fg_issue
end type
type st_5 from statictext within w_prd_product_fg_issue
end type
type st_6 from statictext within w_prd_product_fg_issue
end type
type cb_manpack from so_commandbutton within w_prd_product_fg_issue
end type
type rb_normal from so_radiobutton within w_prd_product_fg_issue
end type
type rb_cancel from so_radiobutton within w_prd_product_fg_issue
end type
type uo_dateset from uo_ymd_calendar within w_prd_product_fg_issue
end type
type uo_dateend from uo_ymd_calendar within w_prd_product_fg_issue
end type
type st_7 from statictext within w_prd_product_fg_issue
end type
type cbx_sound_on from so_checkbox within w_prd_product_fg_issue
end type
type st_1 from statictext within w_prd_product_fg_issue
end type
type ddlb_product_location_code from uo_basecode within w_prd_product_fg_issue
end type
type cbx_multi from so_checkbox within w_prd_product_fg_issue
end type
type cbx_pallet from so_checkbox within w_prd_product_fg_issue
end type
type ddlb_customer from uo_customer_code_name within w_prd_product_fg_issue
end type
type st_3 from statictext within w_prd_product_fg_issue
end type
type ddlb_s_customer from uo_customer_code_name within w_prd_product_fg_issue
end type
type ddlb_s_model from uo_set_model_name_ddlb within w_prd_product_fg_issue
end type
type rb_summary from so_radiobutton within w_prd_product_fg_issue
end type
type ddlb_issue_model from uo_set_model_name_ddlb within w_prd_product_fg_issue
end type
type st_4 from statictext within w_prd_product_fg_issue
end type
type gb_2 from so_groupbox within w_prd_product_fg_issue
end type
type gb_3 from so_groupbox within w_prd_product_fg_issue
end type
type gb_4 from so_groupbox within w_prd_product_fg_issue
end type
type gb_5 from so_groupbox within w_prd_product_fg_issue
end type
type gb_1 from so_groupbox within w_prd_product_fg_issue
end type
type gb_6 from so_groupbox within w_prd_product_fg_issue
end type
type gb_7 from so_groupbox within w_prd_product_fg_issue
end type
end forward

global type w_prd_product_fg_issue from w_main_root
integer width = 6112
integer height = 2388
string title = "Product Shipping Master"
long backcolor = 16777215
string ivs_modify_security = "N"
string ivs_dw_1_use_focusindicator = "N"
sle_pcb_serial_no sle_pcb_serial_no
st_2 st_2
st_status st_status
rb_pack rb_pack
rb_search rb_search
sle_s_pack sle_s_pack
st_5 st_5
st_6 st_6
cb_manpack cb_manpack
rb_normal rb_normal
rb_cancel rb_cancel
uo_dateset uo_dateset
uo_dateend uo_dateend
st_7 st_7
cbx_sound_on cbx_sound_on
st_1 st_1
ddlb_product_location_code ddlb_product_location_code
cbx_multi cbx_multi
cbx_pallet cbx_pallet
ddlb_customer ddlb_customer
st_3 st_3
ddlb_s_customer ddlb_s_customer
ddlb_s_model ddlb_s_model
rb_summary rb_summary
ddlb_issue_model ddlb_issue_model
st_4 st_4
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
gb_5 gb_5
gb_1 gb_1
gb_6 gb_6
gb_7 gb_7
end type
global w_prd_product_fg_issue w_prd_product_fg_issue

type prototypes


end prototypes

type variables

end variables

forward prototypes
public subroutine wf_init ()
public function string wf_fg_issue (string p_barcode, string p_bar_type, string p_customer, string p_location, long p_txn)
end prototypes

public subroutine wf_init ();//=========================
// $$HEX4$$08cd30ae54d62000$$ENDHEX$$
//=========================
st_status.text = 'initial'
end subroutine

public function string wf_fg_issue (string p_barcode, string p_bar_type, string p_customer, string p_location, long p_txn);//create or replace procedure P_PRODUCT_FG_ISSUE( p_barcode       varchar2, 
//                                                p_bar_type      varchar2, 
//                                                p_customer_code varchar2,  --$$HEX7$$9ccd58d5dcc2200044d594c62000$$ENDHEX$$
//                                                p_location      varchar2,  --$$HEX7$$18bc88d4dcc2200044d594c62000$$ENDHEX$$
//                                                p_txn           number,    --3, 4 
//                                                p_commit        varchar2, 
//                                                p_out out       varchar2, 
//                                                p_msg out       varchar2 ) is

string lvs_out , lvs_outmsg, lvs_barcode, lvs_location, lvs_commit
long  lvl_row
lvs_out = space(4000)
lvs_outmsg = space(4000)

declare proc procedure for P_PRODUCT_FG_ISSUE ( :p_barcode , :p_bar_type, :p_customer, :p_location, :p_txn, 'Y'  ) 
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
else 
	//$$HEX3$$31c1f5ac2000$$ENDHEX$$
	if cbx_sound_on.checked then 
		f_play_mp3("chenggong.mp3")
	end if 
end if 


//Log $$HEX3$$30ae5db82000$$ENDHEX$$+++++++++++++++++++++++++++++++
lvl_row = dw_1.insertrow(0)
dw_1.setitem(lvl_row, 'result', lvs_out ) 
dw_1.setitem(lvl_row, 'messages',lvs_outmsg ) 

dw_1.scrolltorow(lvl_row)
//+++++++++++++++++++++++++++++++++++++

//$$HEX5$$31c1f5ac74c774ac2000$$ENDHEX$$NG $$HEX3$$74c774ac2000$$ENDHEX$$
st_status.text = lvs_outmsg
return lvs_out 
end function

on w_prd_product_fg_issue.create
int iCurrent
call super::create
this.sle_pcb_serial_no=create sle_pcb_serial_no
this.st_2=create st_2
this.st_status=create st_status
this.rb_pack=create rb_pack
this.rb_search=create rb_search
this.sle_s_pack=create sle_s_pack
this.st_5=create st_5
this.st_6=create st_6
this.cb_manpack=create cb_manpack
this.rb_normal=create rb_normal
this.rb_cancel=create rb_cancel
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.st_7=create st_7
this.cbx_sound_on=create cbx_sound_on
this.st_1=create st_1
this.ddlb_product_location_code=create ddlb_product_location_code
this.cbx_multi=create cbx_multi
this.cbx_pallet=create cbx_pallet
this.ddlb_customer=create ddlb_customer
this.st_3=create st_3
this.ddlb_s_customer=create ddlb_s_customer
this.ddlb_s_model=create ddlb_s_model
this.rb_summary=create rb_summary
this.ddlb_issue_model=create ddlb_issue_model
this.st_4=create st_4
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
this.gb_5=create gb_5
this.gb_1=create gb_1
this.gb_6=create gb_6
this.gb_7=create gb_7
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_pcb_serial_no
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_status
this.Control[iCurrent+4]=this.rb_pack
this.Control[iCurrent+5]=this.rb_search
this.Control[iCurrent+6]=this.sle_s_pack
this.Control[iCurrent+7]=this.st_5
this.Control[iCurrent+8]=this.st_6
this.Control[iCurrent+9]=this.cb_manpack
this.Control[iCurrent+10]=this.rb_normal
this.Control[iCurrent+11]=this.rb_cancel
this.Control[iCurrent+12]=this.uo_dateset
this.Control[iCurrent+13]=this.uo_dateend
this.Control[iCurrent+14]=this.st_7
this.Control[iCurrent+15]=this.cbx_sound_on
this.Control[iCurrent+16]=this.st_1
this.Control[iCurrent+17]=this.ddlb_product_location_code
this.Control[iCurrent+18]=this.cbx_multi
this.Control[iCurrent+19]=this.cbx_pallet
this.Control[iCurrent+20]=this.ddlb_customer
this.Control[iCurrent+21]=this.st_3
this.Control[iCurrent+22]=this.ddlb_s_customer
this.Control[iCurrent+23]=this.ddlb_s_model
this.Control[iCurrent+24]=this.rb_summary
this.Control[iCurrent+25]=this.ddlb_issue_model
this.Control[iCurrent+26]=this.st_4
this.Control[iCurrent+27]=this.gb_2
this.Control[iCurrent+28]=this.gb_3
this.Control[iCurrent+29]=this.gb_4
this.Control[iCurrent+30]=this.gb_5
this.Control[iCurrent+31]=this.gb_1
this.Control[iCurrent+32]=this.gb_6
this.Control[iCurrent+33]=this.gb_7
end on

on w_prd_product_fg_issue.destroy
call super::destroy
destroy(this.sle_pcb_serial_no)
destroy(this.st_2)
destroy(this.st_status)
destroy(this.rb_pack)
destroy(this.rb_search)
destroy(this.sle_s_pack)
destroy(this.st_5)
destroy(this.st_6)
destroy(this.cb_manpack)
destroy(this.rb_normal)
destroy(this.rb_cancel)
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.st_7)
destroy(this.cbx_sound_on)
destroy(this.st_1)
destroy(this.ddlb_product_location_code)
destroy(this.cbx_multi)
destroy(this.cbx_pallet)
destroy(this.ddlb_customer)
destroy(this.st_3)
destroy(this.ddlb_s_customer)
destroy(this.ddlb_s_model)
destroy(this.rb_summary)
destroy(this.ddlb_issue_model)
destroy(this.st_4)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
destroy(this.gb_5)
destroy(this.gb_1)
destroy(this.gb_6)
destroy(this.gb_7)
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

dw_3.resize( dw_1.width , dw_1.height  )
dw_4.resize( dw_1.width , dw_1.height  )
dw_5.resize( dw_1.width , dw_1.height  )
st_status.width = dw_1.width + dw_2.width

uo_dateset.settext(string(f_v_sysdate(7),'yyyy/mm/dd'))

sle_pcb_serial_no.setfocus( )


end event

event ue_data_control;call super::ue_data_control;string lvs_model, lvs_barcode, lvs_customer

lvs_model       = ddlb_s_model.getcode()
lvs_barcode    = sle_s_pack.text
lvs_customer  = ddlb_s_customer.getcode()


CHOOSE CASE Gvs_Ue_data_control
		
	CASE 'RETRIEVE'
		
		if rb_search.checked then 
			DW_2.RETRIEVE( uo_dateset.text(), uo_dateend.text(),   lvs_model + '%' , lvs_barcode + '%' , lvs_customer + '%' )
		elseif rb_summary.checked then 	
			DW_4.RETRIEVE( uo_dateset.text(), uo_dateend.text(),   lvs_model + '%' , lvs_barcode + '%' , lvs_customer + '%' ) 
	    elseif rb_pack.checked then 
			DW_3.RETRIEVE(  lvs_barcode + '%', lvs_model + '%' , uo_dateset.text(), uo_dateend.text() )
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

event resize;call super::resize;
dw_3.resize( dw_1.width , dw_1.height  )
dw_4.resize( dw_2.width , dw_2.height  )
dw_5.resize( dw_1.width , dw_1.height  )

st_status.width = dw_1.width + dw_2.width
end event

event closequery;call super::closequery;

SETPOINTER(HOURGLASS!)		
STRING DOC

SELECT 'SHIP_'||REPLACE(sys_context('USERENV','IP_ADDRESS'),'.','')||'_'||TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')||'.XLS'
   INTO :DOC
 FROM DUAL;

if isvalid(dw_1) then 
	if dw_1.rowcount( ) > 0 then 		
	uf_save_dw_as_excel( dw_1  , DOC)
	end if 
	
	
end if 

end event

type dw_5 from w_main_root`dw_5 within w_prd_product_fg_issue
integer x = 23
integer y = 712
integer width = 219
integer height = 128
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_prd_product_fg_issue
integer x = 2651
integer y = 712
integer width = 2181
integer height = 1540
integer taborder = 0
string dataobject = "d_product_fg_issue_summary_lst"
end type

type dw_3 from w_main_root`dw_3 within w_prd_product_fg_issue
string tag = "d_product_fg_issue_log"
integer x = 23
integer y = 712
integer width = 2624
integer height = 348
integer taborder = 0
string dataobject = "d_prd_product_fg_issue_able_lst"
borderstyle borderstyle = stylebox!
end type

type dw_2 from w_main_root`dw_2 within w_prd_product_fg_issue
integer x = 2651
integer y = 712
integer width = 2181
integer height = 1540
integer taborder = 0
string dataobject = "d_product_fg_issue_lst"
borderstyle borderstyle = stylebox!
end type

event dw_2::clicked;call super::clicked;sle_pcb_serial_no.setfocus( )
end event

event dw_2::retrieveend;call super::retrieveend;//em_count.text = string(rowcount)
end event

type dw_1 from w_main_root`dw_1 within w_prd_product_fg_issue
integer x = 23
integer y = 712
integer width = 2624
integer height = 1540
integer taborder = 0
string title = "Issueable Inventory List"
string dataobject = "d_product_fg_issue_log"
borderstyle borderstyle = stylebox!
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow <= 0 then return 

//sle_model.text = dw_1.object.model_name[currentrow]
//em_pack_unit.text = string( dw_1.object.packing_pcs_qty[currentrow])
//dw_2.retrieve( dw_1.object.pallet_no[currentrow]  )
end event

event dw_1::itemchanged;call super::itemchanged;if upper(dwo.name) <> 'CHK' then return 

string lvs_complete, lvs_printed 


if cbx_multi.checked then 
	return 0 
else 
	return 2 
end if 
//lvs_complete = this.object.pallet_status[row] 

//C Complete, P Processing $$HEX7$$0cd31bb82000c4c989d511c92000$$ENDHEX$$
//if ( lvs_complete = 'C' ) then 
//    return 0 
//else
//	return 2
//end if 
end event

type uo_tabpages from w_main_root`uo_tabpages within w_prd_product_fg_issue
integer taborder = 0
end type

type sle_pcb_serial_no from so_singlelineedit within w_prd_product_fg_issue
integer x = 3735
integer y = 456
integer width = 1129
integer height = 92
integer taborder = 1
boolean bringtotop = true
integer weight = 700
long textcolor = 65280
long backcolor = 0
boolean enabled = false
textcase textcase = upper!
borderstyle borderstyle = stylebox!
end type

event modified;call super::modified;
string lvs_location_code , lvs_issue_model, lvs_scan_model, lvs_scan_barcode, lvs_customer

lvs_customer     = ddlb_customer.getcode()
lvs_issue_model = ddlb_issue_model.getcode()
lvs_scan_barcode = this.text
  
lvs_location_code = ddlb_product_location_code.getcode() 

if rb_cancel.checked then 
	
	if lvs_location_code = '%' or lvs_location_code = '' then 
		
		f_msg('have to select Location for Return Production','P') 
		this.text = ''
		this.setfocus()
		return 
		
	end if 
	
end if 

// $$HEX12$$9ccde0ac60d52000e0ac1dac44c7200055d678c75cd5e4b2$$ENDHEX$$

if ( lvs_customer = '' or lvs_customer = '%' or isnull(lvs_customer)) then
	
	messagebox("$$HEX2$$bdace0ac$$ENDHEX$$", "$$HEX28$$9ccde0ac200060d52000e0ac1dac44c720003cba00c8200020c1ddd02000c4d6200014bc54cfdcb47cb92000a4c294ce200058d538c194c6$$ENDHEX$$")
	 this.text = ''
	ddlb_customer.setfocus()
	return
	
end if

// $$HEX12$$9ccde0ac60d52000a8ba78b344c7200055d678c75cd5e4b2$$ENDHEX$$

if ( lvs_issue_model = '' or lvs_issue_model = '%' or isnull(lvs_issue_model)) then
	
	messagebox("$$HEX2$$bdace0ac$$ENDHEX$$", "$$HEX28$$9ccde0ac200060d52000a8ba78b344c720003cba00c8200020c1ddd02000c4d6200014bc54cfdcb47cb92000a4c294ce200058d538c194c6$$ENDHEX$$")
	 this.text = ''
	ddlb_issue_model.setfocus()
	return
	
end if

// $$HEX18$$a4c294ce5cd5200014bc54cfdcb458c72000a8ba78b344c7200055d678c720005cd5e4b2$$ENDHEX$$

 select model_name
     into :lvs_scan_model
   from ip_product_fg_inventory
 where barcode = :lvs_scan_barcode;
  
if f_sql_check() < 0 then 
	return
end if 
 
if ( lvs_scan_model = '' or lvs_scan_model = '%' or isnull(lvs_scan_model)) then
	
	messagebox("$$HEX2$$bdace0ac$$ENDHEX$$", "$$HEX18$$9ccde0ac200060d5200014bc54cfdcb458c72000acc7e0ac00ac2000c6c5b5c2c8b2e4b2$$ENDHEX$$, $$HEX5$$55d678c758d538c194c6$$ENDHEX$$")
	 this.text = ''
	  this.setfocus()
	return
	
end if

// $$HEX33$$9ccde0ac200060d5200014bc54cfdcb440c62000a4c294ce5cd5200014bc54cfdcb400ac2000d9b37cc75cd52000a8ba78b378c7c0c9200055d678c720005cd5e4b2$$ENDHEX$$

if ( lvs_issue_model <> lvs_scan_model ) then
	
	messagebox("$$HEX2$$bdace0ac$$ENDHEX$$", "$$HEX22$$9ccde0ac200060d52000a8ba78b3fcac200014bc54cfdcb458c72000a8ba78b374c72000e4b285b9c8b2e4b2$$ENDHEX$$, (" +lvs_issue_model +", "+ lvs_scan_model + ")")
     this.text = ''
	this.setfocus()
	return
	
end if

cb_manpack.triggerevent(CLICKed!)



end event

event getfocus;call super::getfocus;long HMC, VL
HMC = ImmGetContext( handle(parent) )
VL = ImmSetConversionStatus(  HMC, 0, 0)
ImmReleaseContext( HMC, VL) 
end event

type st_2 from statictext within w_prd_product_fg_issue
integer x = 3739
integer y = 368
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

type st_status from so_statictext within w_prd_product_fg_issue
integer x = 18
integer y = 596
integer width = 4818
integer height = 112
boolean bringtotop = true
integer textsize = -12
integer weight = 700
long textcolor = 65280
long backcolor = 0
string text = "Message"
boolean border = true
end type

type rb_pack from so_radiobutton within w_prd_product_fg_issue
integer x = 73
integer y = 192
integer width = 347
integer height = 84
boolean bringtotop = true
integer weight = 700
long textcolor = 255
long backcolor = 16777215
string text = "Ship"
end type

event clicked;call super::clicked;sle_pcb_serial_no.enabled = true 
cb_manpack.visible  = true
cb_manpack.enabled = true

dw_1.bringtotop = true
dw_2.bringtotop = true
	
dw_1.reset()
dw_2.reset()
dw_3.reset()
dw_4.reset()

//
sle_pcb_serial_no.setfocus()
rb_normal.enabled = true
rb_normal.checked = true
rb_cancel.enabled = true

cbx_multi.enabled = true

if cbx_multi.checked then 
	dw_3.bringtoTop = true
	cbx_pallet.enabled = false
	cbx_pallet.checked = false
else
	dw_1.bringtotop = true
	cbx_pallet.enabled = true
	cbx_pallet.checked = false
end if

ddlb_product_location_code.enabled = false

end event

type rb_search from so_radiobutton within w_prd_product_fg_issue
integer x = 73
integer y = 52
integer width = 302
integer height = 84
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
string text = "Retrieve"
boolean checked = true
end type

event clicked;call super::clicked;
	sle_pcb_serial_no.enabled = false 
	
	
	rb_normal.enabled = false
	rb_cancel.enabled = false
	
	cbx_multi.enabled = false 
	cbx_multi.checked = false 
	
	dw_1.bringtotop = true
	dw_2.bringtotop = true

    cb_manpack.enabled = false
end event

type sle_s_pack from so_singlelineedit within w_prd_product_fg_issue
integer x = 2967
integer y = 156
integer width = 933
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

type st_5 from statictext within w_prd_product_fg_issue
integer x = 2967
integer y = 80
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
string text = "Barcode"
boolean focusrectangle = false
end type

type st_6 from statictext within w_prd_product_fg_issue
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

type cb_manpack from so_commandbutton within w_prd_product_fg_issue
integer x = 4965
integer y = 372
integer width = 411
integer height = 164
integer taborder = 30
boolean bringtotop = true
integer weight = 400
string text = "Issue"
end type

event clicked;call super::clicked;string lvs_multi, lvs_pallet, lvs_barcode , lvs_location, lvs_customer
long   lvl_deficit , i 

if rb_search.checked then return 

if cbx_multi.checked then 
	lvs_multi = 'M'  //$$HEX14$$e4b211c9200098ccacb9200070b374c730d1200008c7c4b3b0c62000$$ENDHEX$$3 $$HEX5$$44c7200074c7a9c62000$$ENDHEX$$
else 
	lvs_multi = 'S'  //$$HEX6$$f1c200ae200098ccacb92000$$ENDHEX$$
	lvs_barcode = sle_pcb_serial_no.text  
end if 
	
if rb_normal.checked then 
	lvl_deficit = 3 
	lvs_customer = ddlb_customer.getcode() 
	
	if lvs_customer = '' or isnull(lvs_customer) or lvs_customer = '%'  then 
		f_msg('$$HEX9$$e0ac1dac44c7200020c1ddd058d538c194c6$$ENDHEX$$!','P') 
		st_status.text = f_msg('$$HEX9$$e0ac1dac44c7200020c1ddd058d538c194c6$$ENDHEX$$!','S') 
		sle_pcb_serial_no.text = ''
		sle_pcb_serial_no.setfocus()
		return 
	end if
else
	lvl_deficit = 4 
	lvs_location = ddlb_product_location_code.getcode() 
	
	if lvs_location = '' or isnull(lvs_location) or lvs_location = '%'  then 
		f_msg('$$HEX14$$18bc88d420b420003dcce0ac7cb9200020c1ddd0200058d538c194c6$$ENDHEX$$!','P') 
		st_status.text = f_msg('$$HEX14$$18bc88d420b420003dcce0ac7cb9200020c1ddd0200058d538c194c6$$ENDHEX$$!','S') 
		sle_pcb_serial_no.text = ''
		sle_pcb_serial_no.setfocus()
		return 
	end if
	
	
	lvs_customer = ddlb_customer.getcode() 
	
	if lvs_customer  = '%' or lvs_customer = '' or isnull(lvs_customer) then 
		f_msg('$$HEX12$$e0ac1dac200054cfdcb47cb9200020c1ddd058d538c194c6$$ENDHEX$$!','P') 
		st_status.text = f_msg('$$HEX12$$e0ac1dac200054cfdcb47cb9200020c1ddd058d538c194c6$$ENDHEX$$!','S') 
		sle_pcb_serial_no.text = ''
		sle_pcb_serial_no.setfocus()
		return 
	end if 
	
end if 
	
if cbx_pallet.checked then
	lvs_pallet = 'P' 
else 
	lvs_pallet = 'I' 
end if 
	
if lvs_multi = 'M' and lvs_pallet = 'P' then 
	f_msg('$$HEX15$$0cd31bb89ccde0ac20007cc704ad98ccacb988bd00ac200069d5c8b2e4b2$$ENDHEX$$. $$HEX10$$35c658c144c7200055d678c7200058d538c194c6$$ENDHEX$$','P') 
	st_status.text = f_msg('$$HEX15$$0cd31bb89ccde0ac20007cc704ad98ccacb988bd00ac200069d5c8b2e4b2$$ENDHEX$$. $$HEX10$$35c658c144c7200055d678c7200058d538c194c6$$ENDHEX$$','S') 
	sle_pcb_serial_no.text = ''
	sle_pcb_serial_no.setfocus()
	return
elseif lvs_multi = 'M' and lvl_deficit = 4 then 
	f_msg('$$HEX15$$18bc88d440c720007cc704ad98ccacb9200088bd00ac200069d5c8b2e4b2$$ENDHEX$$. $$HEX10$$35c658c144c7200055d678c7200058d538c194c6$$ENDHEX$$','P') 
	st_status.text =f_msg('$$HEX15$$18bc88d440c720007cc704ad98ccacb9200088bd00ac200069d5c8b2e4b2$$ENDHEX$$. $$HEX10$$35c658c144c7200055d678c7200058d538c194c6$$ENDHEX$$','S') 
	sle_pcb_serial_no.text = ''
	sle_pcb_serial_no.setfocus()
	return
end if

if lvs_multi = 'M' then 
	if dw_3.rowcount() < 1 then 
		f_msg('$$HEX13$$98ccacb960d5200070b374c730d100ac2000c6c5b5c2c8b2e4b2$$ENDHEX$$.','P') 
		st_status.text =f_msg('$$HEX13$$98ccacb960d5200070b374c730d100ac2000c6c5b5c2c8b2e4b2$$ENDHEX$$','S') 
	
		sle_pcb_serial_no.text  = ''
		sle_pcb_serial_no.setfocus()
		return 
	end if 
	
	lvs_customer = ddlb_customer.getcode() 
	lvs_location = ddlb_product_location_code.getcode() 
	
	if lvs_customer  = '%' or lvs_customer = '' or isnull(lvs_customer) then 
		f_msg('$$HEX12$$e0ac1dac200054cfdcb47cb9200020c1ddd058d538c194c6$$ENDHEX$$!','P') 
		st_status.text = f_msg('$$HEX12$$e0ac1dac200054cfdcb47cb9200020c1ddd058d538c194c6$$ENDHEX$$!','S') 
		sle_pcb_serial_no.text = ''
		sle_pcb_serial_no.setfocus()
		return 
	end if 
	
	if lvs_location  = '%' or lvs_location = '' or isnull(lvs_location) then 
		f_msg('$$HEX14$$18bc88d420b420003dcce0ac7cb9200020c1ddd0200058d538c194c6$$ENDHEX$$!','P') 
		st_status.text = f_msg('$$HEX14$$18bc88d420b420003dcce0ac7cb9200020c1ddd0200058d538c194c6$$ENDHEX$$!','S') 
		sle_pcb_serial_no.text = ''
		sle_pcb_serial_no.setfocus()
		return 
	end if 
	
	for i = 1 to dw_3.rowcount() 
		dw_3.scrolltorow(i)
		//$$HEX16$$b4cc6cd01cb4200089d544c720003ecc44c51cc1200098ccacb920005cd5e4b2$$ENDHEX$$. 	
		if  dw_3.getitemstring(i,'chk') = 'Y'  then 
			lvs_barcode = dw_3.getitemstring(i,'barcode') 
			//$$HEX8$$04d55cb8dcc238c8200038d69ccd2000$$ENDHEX$$
			if wf_fg_issue(lvs_barcode , lvs_pallet , lvs_customer, lvs_location, lvl_deficit ) = 'NG' then 
				exit  
			end if
		end if
	next 
	dw_3.reset()
	rb_search.triggerevent(clicked!)
else
	lvs_barcode   = sle_pcb_serial_no.text  
	lvs_customer = ddlb_customer.getcode() 
	
	if lvs_customer  = '%' or lvs_customer = '' or isnull(lvs_customer) then 
		f_msg('$$HEX12$$e0ac1dac200054cfdcb47cb9200020c1ddd058d538c194c6$$ENDHEX$$!','P') 
		st_status.text = f_msg('$$HEX12$$e0ac1dac200054cfdcb47cb9200020c1ddd058d538c194c6$$ENDHEX$$!','S') 
		sle_pcb_serial_no.text = ''
		sle_pcb_serial_no.setfocus()
		return 
	end if 
	
	lvs_location   = ddlb_product_location_code.getcode() 
	//$$HEX8$$04d55cb8dcc238c8200038d69ccd2000$$ENDHEX$$
	wf_fg_issue(lvs_barcode , lvs_pallet , lvs_customer, lvs_location, lvl_deficit )
	
	sle_pcb_serial_no.text  = '' 
	sle_pcb_serial_no.setfocus() 
end if 



end event

type rb_normal from so_radiobutton within w_prd_product_fg_issue
integer x = 594
integer y = 372
integer width = 297
integer height = 88
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
long backcolor = 16777215
boolean enabled = false
string text = "Ship"
boolean checked = true
end type

event clicked;call super::clicked;ddlb_product_location_code.enabled = false
cbx_pallet.enabled = true

sle_pcb_serial_no.text = ''
sle_pcb_serial_no.setfocus()
end event

type rb_cancel from so_radiobutton within w_prd_product_fg_issue
integer x = 594
integer y = 452
integer width = 398
integer height = 92
boolean bringtotop = true
integer weight = 700
long textcolor = 255
long backcolor = 16777215
boolean enabled = false
string text = "Ship-Return "
end type

event clicked;call super::clicked;ddlb_product_location_code.enabled = true
cbx_pallet.enabled = false


sle_pcb_serial_no.text = ''
		sle_pcb_serial_no.setfocus()
end event

type uo_dateset from uo_ymd_calendar within w_prd_product_fg_issue
integer x = 613
integer y = 156
integer taborder = 50
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_prd_product_fg_issue
integer x = 1038
integer y = 156
integer taborder = 60
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_7 from statictext within w_prd_product_fg_issue
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
string text = " Date"
alignment alignment = center!
boolean focusrectangle = false
end type

type cbx_sound_on from so_checkbox within w_prd_product_fg_issue
integer x = 73
integer y = 460
integer width = 270
boolean bringtotop = true
integer weight = 700
long backcolor = 134217742
string text = "Sound"
boolean checked = true
end type

type st_1 from statictext within w_prd_product_fg_issue
integer x = 1586
integer y = 368
integer width = 631
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
string text = "Customer"
boolean focusrectangle = false
end type

type ddlb_product_location_code from uo_basecode within w_prd_product_fg_issue
integer x = 1065
integer y = 472
integer width = 443
integer taborder = 11
boolean bringtotop = true
boolean enabled = false
end type

event constructor;call super::constructor;this.redraw('PRODUCT LOCATION CODE')


THIS.SELECtitem('P01' )  // $$HEX13$$91c588d43dcce0acd0c51cc1ccb920009ccde0ac200000aca5b2$$ENDHEX$$
end event

event selectionchanged;call super::selectionchanged;sle_pcb_serial_no.text = ''
sle_pcb_serial_no.setfocus()
end event

type cbx_multi from so_checkbox within w_prd_product_fg_issue
integer x = 73
integer y = 364
integer width = 366
boolean bringtotop = true
integer weight = 700
long backcolor = 134217742
boolean enabled = false
string text = "Multi Issue"
end type

event clicked;call super::clicked;if checked then 
	dw_3.bringtotop =true 
	cbx_pallet.checked = false 
	cbx_pallet.enabled = false 
else 
	dw_1.bringtotop = true 
end if
end event

type cbx_pallet from so_checkbox within w_prd_product_fg_issue
integer x = 4411
integer y = 356
integer width = 453
boolean bringtotop = true
integer weight = 700
long backcolor = 134217742
boolean enabled = false
string text = "Pallet Barcode"
end type

event clicked;call super::clicked;if checked then 
	st_2.text = 'Pallet Barcode'
else
	st_2.text = 'Barcode'
end if
end event

type ddlb_customer from uo_customer_code_name within w_prd_product_fg_issue
integer x = 1568
integer y = 456
integer width = 654
integer height = 1608
integer taborder = 21
boolean bringtotop = true
end type

event selectionchanged;call super::selectionchanged;sle_pcb_serial_no.text = ''
sle_pcb_serial_no.setfocus()
end event

type st_3 from statictext within w_prd_product_fg_issue
integer x = 3927
integer y = 68
integer width = 631
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
string text = "Customer"
boolean focusrectangle = false
end type

type ddlb_s_customer from uo_customer_code_name within w_prd_product_fg_issue
integer x = 3927
integer y = 156
integer width = 654
integer height = 1608
integer taborder = 31
boolean bringtotop = true
end type

event selectionchanged;call super::selectionchanged;sle_pcb_serial_no.text = ''
sle_pcb_serial_no.setfocus()
end event

type ddlb_s_model from uo_set_model_name_ddlb within w_prd_product_fg_issue
integer x = 1486
integer y = 156
integer width = 1454
integer taborder = 30
boolean bringtotop = true
long backcolor = 16777215
boolean allowedit = false
end type

type rb_summary from so_radiobutton within w_prd_product_fg_issue
integer x = 73
integer y = 120
integer width = 462
integer height = 84
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
string text = "Summary"
end type

event clicked;call super::clicked;
    dw_4.x        = dw_2.x
    dw_4.y        = dw_2.y
    dw_4.width  = dw_2.width
    dw_4.height = dw_2.height

	sle_pcb_serial_no.enabled = false 
	
	rb_normal.enabled   = false
	rb_cancel.enabled    = false
	
	cbx_multi.enabled    = false 
	cbx_multi.checked    = false 
	
	dw_4.bringtotop       = true

    cb_manpack.enabled = false
end event

type ddlb_issue_model from uo_set_model_name_ddlb within w_prd_product_fg_issue
integer x = 2249
integer y = 456
integer width = 1454
integer taborder = 70
boolean bringtotop = true
long backcolor = 16777215
boolean allowedit = false
end type

type st_4 from statictext within w_prd_product_fg_issue
integer x = 2263
integer y = 368
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

type gb_2 from so_groupbox within w_prd_product_fg_issue
integer x = 558
integer y = 296
integer width = 480
integer height = 292
integer taborder = 10
integer weight = 700
long textcolor = 255
long backcolor = 16777215
string text = "Txn Type"
end type

type gb_3 from so_groupbox within w_prd_product_fg_issue
integer x = 558
integer y = 4
integer width = 4078
integer height = 284
integer taborder = 20
integer weight = 700
long textcolor = 8421504
long backcolor = 16777215
string text = "Search Condition"
end type

type gb_4 from so_groupbox within w_prd_product_fg_issue
integer x = 4910
integer y = 296
integer width = 507
integer height = 292
integer taborder = 10
integer weight = 700
long textcolor = 16711680
long backcolor = 16777215
string text = "Process"
end type

type gb_5 from so_groupbox within w_prd_product_fg_issue
integer x = 14
integer y = 4
integer width = 535
integer height = 284
integer taborder = 40
integer weight = 700
long textcolor = 255
long backcolor = 16777215
string text = "Function"
end type

type gb_1 from so_groupbox within w_prd_product_fg_issue
integer x = 1536
integer y = 296
integer width = 3365
integer height = 292
integer taborder = 30
integer weight = 700
long textcolor = 16711680
long backcolor = 16777215
string text = "Ship Info"
end type

type gb_6 from so_groupbox within w_prd_product_fg_issue
integer x = 1047
integer y = 296
integer width = 480
integer height = 292
integer taborder = 20
integer weight = 700
long textcolor = 8421504
long backcolor = 16777215
string text = "Location"
end type

type gb_7 from so_groupbox within w_prd_product_fg_issue
integer x = 14
integer y = 296
integer width = 535
integer height = 284
integer taborder = 30
integer weight = 700
long textcolor = 8421504
long backcolor = 16777215
string text = "Option"
end type

