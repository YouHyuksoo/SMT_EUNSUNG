HA$PBExportHeader$w_pln_barcode_check_master.srw
$PBExportComments$Material Mass Issue Return Master
forward
global type w_pln_barcode_check_master from w_main_root
end type
type st_status from so_statictext within w_pln_barcode_check_master
end type
type sle_our_barcode from so_singlelineedit within w_pln_barcode_check_master
end type
type st_2 from so_statictext within w_pln_barcode_check_master
end type
type em_yyyymm from uo_ym within w_pln_barcode_check_master
end type
type st_1 from so_statictext within w_pln_barcode_check_master
end type
type sle_our_barcode_cond from so_singlelineedit within w_pln_barcode_check_master
end type
type st_10 from so_statictext within w_pln_barcode_check_master
end type
type cbx_cancel from so_checkbox within w_pln_barcode_check_master
end type
type rb_list from so_radiobutton within w_pln_barcode_check_master
end type
type rb_2 from so_radiobutton within w_pln_barcode_check_master
end type
type pb_4 from so_commandbutton within w_pln_barcode_check_master
end type
type ddlb_line_code from uo_line_code within w_pln_barcode_check_master
end type
type ddlb_line_code_cond from uo_line_code within w_pln_barcode_check_master
end type
type st_line_code from so_statictext within w_pln_barcode_check_master
end type
type st_line_code_cond from so_statictext within w_pln_barcode_check_master
end type
type ddlb_workstage_code from uo_workstage_code_all within w_pln_barcode_check_master
end type
type st_5 from so_statictext within w_pln_barcode_check_master
end type
type ddlb_locaton_code_physical from uo_basecode within w_pln_barcode_check_master
end type
type st_6 from so_statictext within w_pln_barcode_check_master
end type
type pb_1 from so_commandbutton within w_pln_barcode_check_master
end type
type ddlb_pcb_item from uo_basecode within w_pln_barcode_check_master
end type
type st_pcb_item from so_statictext within w_pln_barcode_check_master
end type
type rb_reverse_list from so_radiobutton within w_pln_barcode_check_master
end type
type sle_model_name from so_singlelineedit within w_pln_barcode_check_master
end type
type st_3 from so_statictext within w_pln_barcode_check_master
end type
type ddlb_workstage_code_cond from uo_workstage_code_all within w_pln_barcode_check_master
end type
type st_4 from so_statictext within w_pln_barcode_check_master
end type
type gb_4 from so_groupbox within w_pln_barcode_check_master
end type
type gb_1 from so_groupbox within w_pln_barcode_check_master
end type
type gb_2 from so_groupbox within w_pln_barcode_check_master
end type
end forward

global type w_pln_barcode_check_master from w_main_root
integer height = 3228
string title = "Assembly Barcode Scan Check"
st_status st_status
sle_our_barcode sle_our_barcode
st_2 st_2
em_yyyymm em_yyyymm
st_1 st_1
sle_our_barcode_cond sle_our_barcode_cond
st_10 st_10
cbx_cancel cbx_cancel
rb_list rb_list
rb_2 rb_2
pb_4 pb_4
ddlb_line_code ddlb_line_code
ddlb_line_code_cond ddlb_line_code_cond
st_line_code st_line_code
st_line_code_cond st_line_code_cond
ddlb_workstage_code ddlb_workstage_code
st_5 st_5
ddlb_locaton_code_physical ddlb_locaton_code_physical
st_6 st_6
pb_1 pb_1
ddlb_pcb_item ddlb_pcb_item
st_pcb_item st_pcb_item
rb_reverse_list rb_reverse_list
sle_model_name sle_model_name
st_3 st_3
ddlb_workstage_code_cond ddlb_workstage_code_cond
st_4 st_4
gb_4 gb_4
gb_1 gb_1
gb_2 gb_2
end type
global w_pln_barcode_check_master w_pln_barcode_check_master

type variables
LONG lvi_count ,  lvl_row , lvi_pos1 , lvi_pos2 , lvl_barcode_qty , lvl_inventory_qty  , lvl_receipt_sequence , lvl_receipt_qty
STRING lvs_line_code ,  lvs_item_barcode , lvs_yyyymm , lvs_item_code , lvs_lot_no , lvs_label_type , lvs_workstage_code , lvs_location_code_physical , lvs_pcb_item
double  lvdb_receipt_lot_no
end variables

forward prototypes
public function integer wf_insert_barcode (string arg_type)
end prototypes

public function integer wf_insert_barcode (string arg_type);//==========================================
//
//==========================================

 select count(*) into :lvi_count 
  from IM_ASSY_INVENTORY_CHECK_BCD
where check_yyyymm = :lvs_yyyymm
	 and item_barcode      = :lvs_item_barcode ; 

if f_sql_check() < 0 then 
		f_play_sound("$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav")
		st_status.text = f_msg('$$HEX21$$acc7e0ac80acacc0200098ccacb9200011c9200024c658b900ac20001cbcddc0200088d5b5c2c8b2e4b2$$ENDHEX$$','S')
		sle_our_barcode.text = ''
		sle_our_barcode.setfocus()
		return -1
end if 
	
if lvi_count > 0 then 
	f_play_sound("$$HEX5$$74c7f8bb74c8acc768d5$$ENDHEX$$.wav")
	st_status.text = f_msg('EXISTS $$HEX11$$74c7f8bb200098ccacb9200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$','S')
	sle_our_barcode.text = ''
	sle_our_barcode.setfocus()	
	rollback; 
	return -1
else
	
			//===========================================
			//
			//===========================================
			
			
			string lvs_model_name  ,lvs_model_suffix
			
//			select model , buyer , item_code into :lvs_model_name  , :lvs_model_suffix , :lvs_item_code 
//			 from tb_vis_pid_issue_hist  
//			where product_id  = :lvs_item_barcode ;
			
			select model_name, model_suffix, item_code
			   into :lvs_model_name  , :lvs_model_suffix , :lvs_item_code 
			  from ip_product_2d_barcode 
			 where serial_no = :lvs_item_barcode ; 
			
			
			if  lvs_model_name  = '' or isnull( lvs_model_name) then 
				
				 select model_name, model_suffix, item_code
					into :lvs_model_name  , :lvs_model_suffix , :lvs_item_code 
				   from ip_product_2d_barcode 
				 where serial_no = :lvs_item_barcode ; 		
				 
			end if 
			
			
			f_insert()
			
			dw_1.object.item_barcode[lvl_row] = lvs_item_barcode
			dw_1.object.check_yyyymm[lvl_row] =lvs_yyyymm
			dw_1.object.barcode_qty[lvl_row] =1
			dw_1.object.inventory_qty[lvl_row] =1
			dw_1.object.line_code[lvl_row] =lvs_line_code
			dw_1.object.workstage_code[lvl_row] =lvs_workstage_code
			dw_1.object.location_code_physical[lvl_row] =lvs_location_code_physical
			dw_1.object.model_name[lvl_row] = lvs_model_name
			dw_1.object.model_suffix[lvl_row] =lvs_model_suffix
			dw_1.object.item_code[lvl_row] =lvs_item_code 	
			dw_1.object.pcb_item[lvl_row] =lvs_pcb_item
			
			
			if dw_1.update( ) < 0  then 
				
					rollback;
					sle_our_barcode.text = ''
					sle_our_barcode.setfocus()	
					f_play_sound("$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav")
					st_status.text = f_msg( 'ERROR $$HEX21$$acc7e0ac80acacc0200098ccacb9200011c9200024c658b900ac20001cbcddc0200088d5b5c2c8b2e4b2$$ENDHEX$$','S')
					
			else
					commit ;
					f_play_sound("$$HEX4$$00c8a5c731c1f5ac$$ENDHEX$$.wav")
					st_status.text = f_msg('OK $$HEX10$$15c8c1c098ccacb9200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$','S')
					sle_our_barcode.text = ''
					sle_our_barcode.setfocus()
			end if 
end if 


end function

on w_pln_barcode_check_master.create
int iCurrent
call super::create
this.st_status=create st_status
this.sle_our_barcode=create sle_our_barcode
this.st_2=create st_2
this.em_yyyymm=create em_yyyymm
this.st_1=create st_1
this.sle_our_barcode_cond=create sle_our_barcode_cond
this.st_10=create st_10
this.cbx_cancel=create cbx_cancel
this.rb_list=create rb_list
this.rb_2=create rb_2
this.pb_4=create pb_4
this.ddlb_line_code=create ddlb_line_code
this.ddlb_line_code_cond=create ddlb_line_code_cond
this.st_line_code=create st_line_code
this.st_line_code_cond=create st_line_code_cond
this.ddlb_workstage_code=create ddlb_workstage_code
this.st_5=create st_5
this.ddlb_locaton_code_physical=create ddlb_locaton_code_physical
this.st_6=create st_6
this.pb_1=create pb_1
this.ddlb_pcb_item=create ddlb_pcb_item
this.st_pcb_item=create st_pcb_item
this.rb_reverse_list=create rb_reverse_list
this.sle_model_name=create sle_model_name
this.st_3=create st_3
this.ddlb_workstage_code_cond=create ddlb_workstage_code_cond
this.st_4=create st_4
this.gb_4=create gb_4
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_status
this.Control[iCurrent+2]=this.sle_our_barcode
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.em_yyyymm
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.sle_our_barcode_cond
this.Control[iCurrent+7]=this.st_10
this.Control[iCurrent+8]=this.cbx_cancel
this.Control[iCurrent+9]=this.rb_list
this.Control[iCurrent+10]=this.rb_2
this.Control[iCurrent+11]=this.pb_4
this.Control[iCurrent+12]=this.ddlb_line_code
this.Control[iCurrent+13]=this.ddlb_line_code_cond
this.Control[iCurrent+14]=this.st_line_code
this.Control[iCurrent+15]=this.st_line_code_cond
this.Control[iCurrent+16]=this.ddlb_workstage_code
this.Control[iCurrent+17]=this.st_5
this.Control[iCurrent+18]=this.ddlb_locaton_code_physical
this.Control[iCurrent+19]=this.st_6
this.Control[iCurrent+20]=this.pb_1
this.Control[iCurrent+21]=this.ddlb_pcb_item
this.Control[iCurrent+22]=this.st_pcb_item
this.Control[iCurrent+23]=this.rb_reverse_list
this.Control[iCurrent+24]=this.sle_model_name
this.Control[iCurrent+25]=this.st_3
this.Control[iCurrent+26]=this.ddlb_workstage_code_cond
this.Control[iCurrent+27]=this.st_4
this.Control[iCurrent+28]=this.gb_4
this.Control[iCurrent+29]=this.gb_1
this.Control[iCurrent+30]=this.gb_2
end on

on w_pln_barcode_check_master.destroy
call super::destroy
destroy(this.st_status)
destroy(this.sle_our_barcode)
destroy(this.st_2)
destroy(this.em_yyyymm)
destroy(this.st_1)
destroy(this.sle_our_barcode_cond)
destroy(this.st_10)
destroy(this.cbx_cancel)
destroy(this.rb_list)
destroy(this.rb_2)
destroy(this.pb_4)
destroy(this.ddlb_line_code)
destroy(this.ddlb_line_code_cond)
destroy(this.st_line_code)
destroy(this.st_line_code_cond)
destroy(this.ddlb_workstage_code)
destroy(this.st_5)
destroy(this.ddlb_locaton_code_physical)
destroy(this.st_6)
destroy(this.pb_1)
destroy(this.ddlb_pcb_item)
destroy(this.st_pcb_item)
destroy(this.rb_reverse_list)
destroy(this.sle_model_name)
destroy(this.st_3)
destroy(this.ddlb_workstage_code_cond)
destroy(this.st_4)
destroy(this.gb_4)
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


 ivs_dw_2_retrice_cancel_popup_open = 'N'
 ivs_dw_3_retrice_cancel_popup_open = 'N'
 ivs_dw_4_retrice_cancel_popup_open = 'N'
 ivs_dw_5_retrice_cancel_popup_open = 'N'
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
F_MENU_CONTROL('DATA_CONTROL' , TRUE)  // All Data Control






end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
st_status.width = dw_1.width 
sle_our_barcode.setfocus()
end event

event ue_data_control;call super::ue_data_control;INT lvi_check_qty
choose case gvs_ue_data_control
		
	case 'RETRIEVE'
		

		lvi_check_qty = 1

		if rb_list.checked = true then 
			dw_1.retrieve(  em_yyyymm.text , sle_our_barcode_cond.text+'%' , lvi_check_qty ,  ddlb_line_code_cond.getcode( )+'%' , ddlb_workstage_code_cond.getcode()+'%' , gvi_organization_id)
			sle_our_barcode.setfocus()
		
		elseif rb_reverse_list.checked = true then
			dw_2.retrieve(  em_yyyymm.text ,  ddlb_line_code_cond.getcode( )+'%'  , ddlb_workstage_code_cond.getcode()+'%' ,  sle_model_name.text+'%' , sle_our_barcode_cond.text+'%'  , gvi_organization_id)

		else
				dw_4.retrieve(  em_yyyymm.text ,  sle_our_barcode_cond.text+'%'   , ddlb_line_code_cond.getcode( )+'%' ,  gvi_organization_id)
		
			sle_our_barcode.setfocus()
		end if 
			
			
		case 'INSERT' 
			
			 lvl_row= DW_1.INSERTROW(1)
			DW_1.SCROLLTOROW(lvl_row)
			F_SET_SECURITY_ROW(DW_1 , lvl_row ,'ALL')
			
	case 'DELETE'
		
		  	if dw_1.AcceptText() = -1 then
				return
			end if
			
			MSG = F_MSGBOX(1003)  //$$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?
			IF MSG = 1 THEN
				Gvl_row_deleted = dw_1.GetRow()			
				dw_1.DELETEROW(Gvl_row_deleted)		
				dw_1.SetFocus()
				lvl_row = dw_1.GetRow()
				dw_1.ScrollToRow(lvl_row)
				dw_1.SetColumn(1)
				
			END IF

	case 'UPDATE'
		
			IF dw_1.UPDATE() < 0  or dw_2.update() < 0 THEN
				 dw_1.RESET()
				 ROLLBACK;
				 RETURN				
			ELSE
				 COMMIT;
				 F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
				// F_RETRIEVE()				 
			END IF

	case else
end choose

end event

event open;call super::open;sle_our_barcode.setfocus()
end event

event clicked;call super::clicked;sle_our_barcode.setfocus()
end event

event resize;call super::resize;st_status.width = dw_1.width
end event

type dw_5 from w_main_root`dw_5 within w_pln_barcode_check_master
integer y = 744
integer width = 2267
integer height = 752
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_pln_barcode_check_master
integer y = 716
integer width = 4567
integer height = 884
integer taborder = 0
boolean titlebar = true
string title = "Summary"
string dataobject = "d_pln_inventory_barcode_check_sum_lst"
end type

event dw_4::itemchanged;//OVERRIDE
end event

type dw_3 from w_main_root`dw_3 within w_pln_barcode_check_master
integer y = 716
integer width = 4567
integer height = 884
integer taborder = 0
boolean titlebar = true
end type

type dw_2 from w_main_root`dw_2 within w_pln_barcode_check_master
integer y = 716
integer width = 4567
integer height = 884
integer taborder = 0
boolean titlebar = true
string dataobject = "d_mat_workstage_inventory_reverse_lst"
borderstyle borderstyle = styleraised!
end type

event dw_2::clicked;call super::clicked;sle_our_barcode.setfocus()
end event

type dw_1 from w_main_root`dw_1 within w_pln_barcode_check_master
integer y = 716
integer width = 4567
integer height = 884
integer taborder = 0
boolean titlebar = true
string title = "Check List"
string dataobject = "d_pln_inventory_barcode_check_lst"
end type

event dw_1::clicked;call super::clicked;sle_our_barcode.setfocus()
end event

event dw_1::updatestart;//
end event

event dw_1::updateend;//
end event

type uo_tabpages from w_main_root`uo_tabpages within w_pln_barcode_check_master
integer taborder = 0
end type

type st_status from so_statictext within w_pln_barcode_check_master
integer x = 5
integer width = 4535
integer height = 184
boolean bringtotop = true
integer textsize = -24
integer weight = 700
long textcolor = 65535
long backcolor = 16711680
string text = "Message"
end type

type sle_our_barcode from so_singlelineedit within w_pln_barcode_check_master
integer x = 4709
integer y = 356
integer width = 745
integer height = 88
integer taborder = 20
boolean bringtotop = true
textcase textcase = upper!
end type

event getfocus;call super::getfocus;this.selecttext(1,200)
end event

event modified;call super::modified;lvs_yyyymm = em_yyyymm.text
lvs_lot_no = this.text
lvs_item_barcode = this.text
lvs_line_code =  ddlb_line_code.getcode( )
lvs_workstage_code = ddlb_workstage_code.getcode()
lvs_location_code_physical =ddlb_locaton_code_physical.getcode()

lvs_pcb_item = ddlb_pcb_item.getcode()

IF lvs_line_code = '' OR ISNULL(lvs_line_code) OR lvs_line_code = '%' then 
	F_MSGBOX1(102 ,st_line_code.text )
		this.text = ''
	return 
END IF 
IF lvs_pcb_item = '' OR ISNULL(lvs_pcb_item) OR lvs_pcb_item = '%' then 
	F_MSGBOX1(102 ,st_pcb_item.text )
	this.text = ''
	return 
END IF 
//==================================================
//
//==================================================
 st_status.text = ''
 
if len(lvs_item_barcode) < 10 then 
    f_play_sound("kittingfailed.wav")
    st_status.text =f_msg( "$$HEX16$$fcd3a9ba88bc38d600ac20007cc758ce200058d5c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$",'S')
	sle_our_barcode.text = ''
	sle_our_barcode.setfocus()
   return 
end if 

if cbx_cancel.checked = true then 
	
	delete from IM_ASSY_INVENTORY_CHECK_BCD 
	where item_barcode  = :lvs_item_barcode
	   and check_yyyymm = :lvs_yyyymm ;
	
	if f_sql_check() < 0 then 
			f_play_sound("scanfailed.wav")
			st_status.text = f_msg('$$HEX19$$e4c2acc0e8cd8cc111c920002000200024c658b900ac20001cbcddc0200088d5b5c2c8b2e4b2$$ENDHEX$$','S')
			sle_our_barcode.text = ''
			sle_our_barcode.setfocus()
			return 
	end if 
	
	commit ;
	f_play_sound("Kittingok.wav")
	st_status.text = f_msg('$$HEX10$$e4c2acc0e8cd8cc12000200088d5b5c2c8b2e4b2$$ENDHEX$$','S')
	sle_our_barcode.text = ''
	sle_our_barcode.setfocus()	
	return 
	
end if 


wf_insert_barcode('N')

//===========================================
//
//===========================================

end event

type st_2 from so_statictext within w_pln_barcode_check_master
integer x = 645
integer y = 284
integer width = 343
integer height = 76
boolean bringtotop = true
long textcolor = 16711680
string text = "Check YYYYMM"
end type

type em_yyyymm from uo_ym within w_pln_barcode_check_master
integer x = 645
integer y = 360
integer width = 343
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
end type

type st_1 from so_statictext within w_pln_barcode_check_master
integer x = 4709
integer y = 268
integer width = 745
integer height = 72
boolean bringtotop = true
long textcolor = 16711680
string text = "Our Barcode"
end type

type sle_our_barcode_cond from so_singlelineedit within w_pln_barcode_check_master
integer x = 2441
integer y = 356
integer width = 562
integer height = 88
integer taborder = 30
boolean bringtotop = true
end type

type st_10 from so_statictext within w_pln_barcode_check_master
integer x = 2441
integer y = 284
integer width = 562
integer height = 76
boolean bringtotop = true
string text = "Our Barcode"
end type

type cbx_cancel from so_checkbox within w_pln_barcode_check_master
integer x = 3543
integer y = 460
integer width = 498
integer height = 80
boolean bringtotop = true
string text = "Cancel"
end type

type rb_list from so_radiobutton within w_pln_barcode_check_master
integer x = 64
integer y = 276
boolean bringtotop = true
string text = "Check List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop  = true
selected_data_window = dw_1
end event

type rb_2 from so_radiobutton within w_pln_barcode_check_master
integer x = 64
integer y = 364
boolean bringtotop = true
string text = "Check Summary"
end type

event clicked;call super::clicked;dw_4.bringtotop  = true
selected_data_window = dw_4
end event

type pb_4 from so_commandbutton within w_pln_barcode_check_master
integer x = 526
integer y = 572
integer height = 132
integer taborder = 60
boolean bringtotop = true
string text = "Paste"
end type

event clicked;call super::clicked;dw_1.importclipboard( )
end event

type ddlb_line_code from uo_line_code within w_pln_barcode_check_master
integer x = 3063
integer y = 364
integer width = 457
integer height = 1396
integer taborder = 40
boolean bringtotop = true
boolean allowedit = true
end type

type ddlb_line_code_cond from uo_line_code within w_pln_barcode_check_master
integer x = 992
integer y = 356
integer width = 471
integer height = 1840
integer taborder = 50
boolean bringtotop = true
boolean allowedit = true
end type

type st_line_code from so_statictext within w_pln_barcode_check_master
integer x = 3063
integer y = 288
integer width = 457
integer height = 72
boolean bringtotop = true
string text = "Line Code"
end type

type st_line_code_cond from so_statictext within w_pln_barcode_check_master
integer x = 992
integer y = 284
integer width = 471
integer height = 76
boolean bringtotop = true
string text = "Line Code"
end type

type ddlb_workstage_code from uo_workstage_code_all within w_pln_barcode_check_master
integer x = 3525
integer y = 356
integer width = 485
integer height = 836
integer taborder = 50
boolean bringtotop = true
end type

type st_5 from so_statictext within w_pln_barcode_check_master
integer x = 3525
integer y = 276
integer width = 485
integer height = 72
boolean bringtotop = true
string text = "Workstage Code"
end type

type ddlb_locaton_code_physical from uo_basecode within w_pln_barcode_check_master
integer x = 4018
integer y = 356
integer width = 357
integer taborder = 50
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'LOCATION CODE PHYSICAL')
end event

type st_6 from so_statictext within w_pln_barcode_check_master
integer x = 4027
integer y = 268
integer width = 338
integer height = 72
boolean bringtotop = true
string text = "Location Code "
end type

type pb_1 from so_commandbutton within w_pln_barcode_check_master
integer x = 14
integer y = 572
integer height = 132
integer taborder = 70
boolean bringtotop = true
string text = "Explosion"
end type

event clicked;call super::clicked;string    lvs_model_name , lvs_model_suffix , LVS_ERROR , LVS_SET_ITEM_CODE , lvs_master_item_code
double  LVDB_SESSION_ID 

INT i , j

msg = f_msgbox1( 1161  , this.text)
if msg = 1 then 
else
	return
end if

lvs_yyyymm = em_yyyymm.text

delete from IM_ITEM_WS_INVENTORY_REVERSE
where close_yyyymm = :lvs_yyyymm
    and organization_id = :gvi_organization_id ;

if f_sql_check() < 0 then 
	return
end if


UPDATE  IM_ASSY_INVENTORY_CHECK_BCD set reverse_yn = 'N'
where  CHECK_yyyymm = :lvs_yyyymm
    and organization_id = :gvi_organization_id ;

if f_sql_check() < 0 then 
	return
end if

//==================================================================================
//
//==================================================================================

//UPDATE IM_ASSY_INVENTORY_CHECK_BCD A
//   SET (A.ITEM_CODE, A.MODEL_NAME, A.MODEL_SUFFIX) =
//          (SELECT B.ITEM_CODE, B.MODEL, B.BUYER
//             FROM TB_VIS_PID_ISSUE_HIST B
//            WHERE A.ITEM_BARCODE = B.PRODUCT_ID
//			   AND A.CHECK_YYYYMM = :lvs_yyyymm)
//WHERE A.CHECK_YYYYMM = :lvs_yyyymm
//     AND A.ITEM_CODE IS NULL 
//     AND A.ITEM_BARCODE  IN ( SELECT B.PRODUCT_ID
//             FROM IM_ASSY_INVENTORY_CHECK_BCD A , TB_VIS_PID_ISSUE_HIST B
//            WHERE A.ITEM_BARCODE = B.PRODUCT_ID
//			   AND A.CHECK_YYYYMM = :lvs_yyyymm) ;
//	  
//IF F_SQL_CHECK() < 0 THEN 
//	RETURN  ;
//END IF 

UPDATE IM_ASSY_INVENTORY_CHECK_BCD A 
   set ITEM_CODE = ( SELECT MAX(B.ITEM_CODE) FROM IM_ASSY_INVENTORY_CHECK_BCD B
							 WHERE A.MODEL_NAME = B.MODEL_NAME
								  AND A.CHECK_YYYYMM =B.CHECK_YYYYMM
								 AND A.CHECK_YYYYMM = :lvs_yyyymm
								  AND B.ITEM_CODE IS NOT NULL )
WHERE A.CHECK_YYYYMM = :lvs_yyyymm
    AND A.ITEM_CODE IS NULL ;
	 
IF F_SQL_CHECK() < 0 THEN 
		RETURN  ;
END IF  
UPDATE IM_ASSY_INVENTORY_CHECK_BCD A
   SET A.MASTER_ITEM_CODE =
          (SELECT MAX (B.CHILD_ITEM_CODE)
             FROM ID_ENG_BOM B
            WHERE CHILD_ITEM_CODE IN
                     (SELECT C.ITEM_CODE
                        FROM IM_ASSY_INVENTORY_CHECK_BCD C
                       WHERE C.CHECK_YYYYMM = :lvs_yyyymm
                             AND A.MODEL_NAME = C.MODEL_NAME )
                  AND PARENT_ITEM_CODE = '*')
 WHERE A.CHECK_YYYYMM = :lvs_yyyymm;
 
IF F_SQL_CHECK() < 0 THEN 
		RETURN  ;
END IF  
//==================================================================================
//
//==================================================================================
do
	i++
	
	if dw_4.object.check_yn[i] = 'Y' then
	else
		continue
	end if 
	
	if dw_4.object.reverse_yn[i] = 'Y' or dw_4.object.reverse_yn[i] = 'S'  then //$$HEX16$$74c7f8bb200088d570ac98b020001cc878c620001cb470ac2000a4c2b5d02000$$ENDHEX$$.
		continue
	end if 
	
	lvs_set_item_code = dw_4.object.item_code[i]
	lvs_master_item_code = dw_4.object.master_item_code[i]
	
	lvs_model_name= dw_4.object.model_name[i]
	lvs_model_suffix = dw_4.object.model_suffix[i]
	
	lvs_line_code  = dw_4.object.line_code[i]
	lvs_workstage_code = '' // dw_4.object.workstage_code[i]	
	
	lvl_barcode_qty =  dw_4.object.barcode_qty[i]
		
//==========================================
// $$HEX17$$84c7dcc24cd174c714bed0c52000f5ac15c89ccde0ac7cb92000acc7ddc031c168d5$$ENDHEX$$
//==========================================

		LVDB_SESSION_ID       = F_BOM_QUERY_PRC( LVS_SET_ITEM_CODE , F_T_SYSDATE())
		
		IF LVDB_SESSION_ID <= 0 or SQLCA.SQLCODE  < 0  THEN		
			
			    LVDB_SESSION_ID       = F_BOM_QUERY_PRC( LVS_MASTER_ITEM_CODE , F_T_SYSDATE())
			    IF LVDB_SESSION_ID <= 0 or SQLCA.SQLCODE  < 0  THEN		
			
						LVS_ERROR = SQLCA.SQLERRTEXT
						
						 dw_4.object.reverse_yn[i] = 'E'
						 dw_4.object.reverse_error[i] ='BOM NOT FOUND : '+LVS_ERROR
						 CONTINUE 
				END IF 
		END IF		

		  INSERT INTO IM_ITEM_WS_INVENTORY_REVERSE  
         ( CLOSE_YYYYMM,   
           LINE_CODE,   
           WORKSTAGE_CODE,   
           MATERIAL_MFS,   
           MFS,   
           ITEM_CODE,   
           ORGANIZATION_ID,   
           MACHINE_CODE,   
           LINE_TYPE,   
           INVENTORY_QTY,   
           ENTER_DATE,   
           ENTER_BY,   
           LAST_MODIFY_DATE,   
           LAST_MODIFY_BY ,
		  MODEL_NAME ,
		  MODEL_SUFFIX,
		  SET_ITEM_CODE )  
 
        SELECT  :lvs_yyyymm,   
           :LVS_LINE_CODE,   
           :LVS_WORKSTAGE_CODE,   
           '*' , //MATERIAL_MFS,   
           '*', // MFS,   
           CHILD_ITEM_CODE,   
           ORGANIZATION_ID,   
           '*' , //MACHINE_CODE,   
           'F' , //LINE_TYPE,   
           SUM(ITEM_UNIT_QTY)  * :lvl_barcode_qty ,   
           SYSDATE ,   
           :GVS_USER_ID,   
           SYSDATE ,   
           :GVS_USER_ID ,
		  :LVS_MODEL_NAME ,
		  :LVS_MODEL_SUFFIX ,
		  :LVS_SET_ITEM_CODE 
		  
	 FROM ID_ENG_BOM_TEMP 
   WHERE SESSION_ID = :LVDB_SESSION_ID
    GROUP BY CHILD_ITEM_CODE,   ORGANIZATION_ID  ;
	
		 IF  SQLCA.SQLCODE < 0   THEN	
			
			 LVS_ERROR = SQLCA.SQLERRTEXT
			 dw_4.object.reverse_yn[i] = 'N'
			 dw_4.object.reverse_error[i] = sqlca.sqlerrtext 
			 
//			UPDATE IM_ASSY_INVENTORY_CHECK_BCD SET REVERSE_YN = 'E'  , REVERSE_ERROR = :LVS_ERROR
//			  WHERE  ITEM_CODE = :LVS_SET_ITEM_CODE
//			       AND  LINE_CODE = :LVS_LINE_CODE ;

			 MSG = MESSAGEBOX("ERROR" , "CONTINUE ?" , question! , yesno! )
			 IF MSG = 1 THEN 
				
			ELSE
				ROLLBACK;
				EXIT 
			END IF 
			
		END IF			
	 
	    DELETE FROM  ID_ENG_BOM_TEMP 
         WHERE SESSION_ID = :LVDB_SESSION_ID ;
			
		COMMIT ;	
j++

st_status.text = "OK="+string(j)+" / "+string(i)+" / "+string( dw_4.rowcount( )) 

loop until i = dw_4.rowcount( )

COMMIT ;


	
   



end event

type ddlb_pcb_item from uo_basecode within w_pln_barcode_check_master
integer x = 4384
integer y = 356
integer width = 315
integer taborder = 60
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'PCB ITEM')
end event

type st_pcb_item from so_statictext within w_pln_barcode_check_master
integer x = 4389
integer y = 268
integer width = 338
integer height = 72
boolean bringtotop = true
string text = "PCB Item"
end type

type rb_reverse_list from so_radiobutton within w_pln_barcode_check_master
integer x = 64
integer y = 464
boolean bringtotop = true
string text = "Reverse List"
end type

event clicked;call super::clicked;dw_2.bringtotop = true 
selected_data_window = dw_2
end event

type sle_model_name from so_singlelineedit within w_pln_barcode_check_master
integer x = 1961
integer y = 356
integer width = 480
integer height = 88
integer taborder = 40
boolean bringtotop = true
end type

type st_3 from so_statictext within w_pln_barcode_check_master
integer x = 1961
integer y = 280
integer width = 480
integer height = 76
boolean bringtotop = true
string text = "Model"
end type

type ddlb_workstage_code_cond from uo_workstage_code_all within w_pln_barcode_check_master
integer x = 1472
integer y = 360
integer width = 485
integer height = 1840
integer taborder = 30
boolean bringtotop = true
end type

type st_4 from so_statictext within w_pln_barcode_check_master
integer x = 1463
integer y = 280
integer width = 485
integer height = 72
boolean bringtotop = true
string text = "Workstage Code"
end type

type gb_4 from so_groupbox within w_pln_barcode_check_master
integer x = 3045
integer y = 196
integer width = 2450
integer height = 364
integer weight = 700
long textcolor = 16711680
string text = "Scan Receipt"
end type

type gb_1 from so_groupbox within w_pln_barcode_check_master
integer x = 599
integer y = 196
integer width = 2427
integer height = 364
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_pln_barcode_check_master
integer y = 192
integer width = 594
integer height = 364
integer taborder = 20
string text = "Category"
end type

