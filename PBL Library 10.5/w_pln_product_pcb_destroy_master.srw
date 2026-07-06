HA$PBExportHeader$w_pln_product_pcb_destroy_master.srw
$PBExportComments$Line Master
forward
global type w_pln_product_pcb_destroy_master from w_main_root
end type
type st_status from so_statictext within w_pln_product_pcb_destroy_master
end type
type gb_2 from so_groupbox within w_pln_product_pcb_destroy_master
end type
type gb_3 from so_groupbox within w_pln_product_pcb_destroy_master
end type
type cb_1 from so_commandbutton within w_pln_product_pcb_destroy_master
end type
type cb_4 from so_commandbutton within w_pln_product_pcb_destroy_master
end type
type cb_5 from so_commandbutton within w_pln_product_pcb_destroy_master
end type
type rb_destroy from so_radiobutton within w_pln_product_pcb_destroy_master
end type
type rb_history from so_radiobutton within w_pln_product_pcb_destroy_master
end type
type sle_bad_reason_code from so_singlelineedit within w_pln_product_pcb_destroy_master
end type
type st_1 from so_statictext within w_pln_product_pcb_destroy_master
end type
type ddlb_workstage_code from uo_workstage_code_all within w_pln_product_pcb_destroy_master
end type
type cb_3 from so_commandbutton within w_pln_product_pcb_destroy_master
end type
type cb_6 from so_commandbutton within w_pln_product_pcb_destroy_master
end type
type dw_serial_no from datawindow within w_pln_product_pcb_destroy_master
end type
type cb_2 from so_commandbutton within w_pln_product_pcb_destroy_master
end type
type cb_7 from so_commandbutton within w_pln_product_pcb_destroy_master
end type
type st_4 from statictext within w_pln_product_pcb_destroy_master
end type
type ddlb_model_name from uo_set_model_name_ddlb within w_pln_product_pcb_destroy_master
end type
type ddlb_line_code from uo_line_code within w_pln_product_pcb_destroy_master
end type
type st_3 from statictext within w_pln_product_pcb_destroy_master
end type
type st_5 from so_statictext within w_pln_product_pcb_destroy_master
end type
type sle_pcb_serial_no from so_singlelineedit within w_pln_product_pcb_destroy_master
end type
type st_9 from statictext within w_pln_product_pcb_destroy_master
end type
type uo_dateset from uo_ymd_calendar within w_pln_product_pcb_destroy_master
end type
type st_10 from so_statictext within w_pln_product_pcb_destroy_master
end type
type uo_dateend from uo_ymd_calendar within w_pln_product_pcb_destroy_master
end type
type ddlb_receipt_deficit from uo_basecode within w_pln_product_pcb_destroy_master
end type
type st_11 from so_statictext within w_pln_product_pcb_destroy_master
end type
type st_12 from so_statictext within w_pln_product_pcb_destroy_master
end type
type ddlb_repair_result_code from uo_basecode within w_pln_product_pcb_destroy_master
end type
type gb_1 from so_groupbox within w_pln_product_pcb_destroy_master
end type
end forward

global type w_pln_product_pcb_destroy_master from w_main_root
integer width = 6336
integer height = 2748
string title = "WQC Destroy Master"
st_status st_status
gb_2 gb_2
gb_3 gb_3
cb_1 cb_1
cb_4 cb_4
cb_5 cb_5
rb_destroy rb_destroy
rb_history rb_history
sle_bad_reason_code sle_bad_reason_code
st_1 st_1
ddlb_workstage_code ddlb_workstage_code
cb_3 cb_3
cb_6 cb_6
dw_serial_no dw_serial_no
cb_2 cb_2
cb_7 cb_7
st_4 st_4
ddlb_model_name ddlb_model_name
ddlb_line_code ddlb_line_code
st_3 st_3
st_5 st_5
sle_pcb_serial_no sle_pcb_serial_no
st_9 st_9
uo_dateset uo_dateset
st_10 st_10
uo_dateend uo_dateend
ddlb_receipt_deficit ddlb_receipt_deficit
st_11 st_11
st_12 st_12
ddlb_repair_result_code ddlb_repair_result_code
gb_1 gb_1
end type
global w_pln_product_pcb_destroy_master w_pln_product_pcb_destroy_master

type variables
Long Lvl_row , ivl_error = 0

end variables

on w_pln_product_pcb_destroy_master.create
int iCurrent
call super::create
this.st_status=create st_status
this.gb_2=create gb_2
this.gb_3=create gb_3
this.cb_1=create cb_1
this.cb_4=create cb_4
this.cb_5=create cb_5
this.rb_destroy=create rb_destroy
this.rb_history=create rb_history
this.sle_bad_reason_code=create sle_bad_reason_code
this.st_1=create st_1
this.ddlb_workstage_code=create ddlb_workstage_code
this.cb_3=create cb_3
this.cb_6=create cb_6
this.dw_serial_no=create dw_serial_no
this.cb_2=create cb_2
this.cb_7=create cb_7
this.st_4=create st_4
this.ddlb_model_name=create ddlb_model_name
this.ddlb_line_code=create ddlb_line_code
this.st_3=create st_3
this.st_5=create st_5
this.sle_pcb_serial_no=create sle_pcb_serial_no
this.st_9=create st_9
this.uo_dateset=create uo_dateset
this.st_10=create st_10
this.uo_dateend=create uo_dateend
this.ddlb_receipt_deficit=create ddlb_receipt_deficit
this.st_11=create st_11
this.st_12=create st_12
this.ddlb_repair_result_code=create ddlb_repair_result_code
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_status
this.Control[iCurrent+2]=this.gb_2
this.Control[iCurrent+3]=this.gb_3
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.cb_4
this.Control[iCurrent+6]=this.cb_5
this.Control[iCurrent+7]=this.rb_destroy
this.Control[iCurrent+8]=this.rb_history
this.Control[iCurrent+9]=this.sle_bad_reason_code
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.ddlb_workstage_code
this.Control[iCurrent+12]=this.cb_3
this.Control[iCurrent+13]=this.cb_6
this.Control[iCurrent+14]=this.dw_serial_no
this.Control[iCurrent+15]=this.cb_2
this.Control[iCurrent+16]=this.cb_7
this.Control[iCurrent+17]=this.st_4
this.Control[iCurrent+18]=this.ddlb_model_name
this.Control[iCurrent+19]=this.ddlb_line_code
this.Control[iCurrent+20]=this.st_3
this.Control[iCurrent+21]=this.st_5
this.Control[iCurrent+22]=this.sle_pcb_serial_no
this.Control[iCurrent+23]=this.st_9
this.Control[iCurrent+24]=this.uo_dateset
this.Control[iCurrent+25]=this.st_10
this.Control[iCurrent+26]=this.uo_dateend
this.Control[iCurrent+27]=this.ddlb_receipt_deficit
this.Control[iCurrent+28]=this.st_11
this.Control[iCurrent+29]=this.st_12
this.Control[iCurrent+30]=this.ddlb_repair_result_code
this.Control[iCurrent+31]=this.gb_1
end on

on w_pln_product_pcb_destroy_master.destroy
call super::destroy
destroy(this.st_status)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.cb_1)
destroy(this.cb_4)
destroy(this.cb_5)
destroy(this.rb_destroy)
destroy(this.rb_history)
destroy(this.sle_bad_reason_code)
destroy(this.st_1)
destroy(this.ddlb_workstage_code)
destroy(this.cb_3)
destroy(this.cb_6)
destroy(this.dw_serial_no)
destroy(this.cb_2)
destroy(this.cb_7)
destroy(this.st_4)
destroy(this.ddlb_model_name)
destroy(this.ddlb_line_code)
destroy(this.st_3)
destroy(this.st_5)
destroy(this.sle_pcb_serial_no)
destroy(this.st_9)
destroy(this.uo_dateset)
destroy(this.st_10)
destroy(this.uo_dateend)
destroy(this.ddlb_receipt_deficit)
destroy(this.st_11)
destroy(this.st_12)
destroy(this.ddlb_repair_result_code)
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
F_MENU_CONTROL('DATA_CONTROL' , TRUE)  // All Data Control




end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

sle_pcb_serial_no.setfocus()
st_status.width = dw_3.width
end event

event ue_data_control;call super::ue_data_control;CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		   
			if rb_destroy.checked = true then 
					
					dw_1.retrieve( sle_pcb_serial_no.text , gvi_organization_id )
					dw_2.retrieve( sle_pcb_serial_no.text , gvi_organization_id )				
			else	
			     	dw_3.reset()
					DW_3.RETRIEVE(  ddlb_line_code.getcode( )+'%' , ddlb_workstage_code.getcode( )+'%' ,    ddlb_model_name.getcode()+'%' , sle_pcb_serial_no.TEXT +'%' , uo_dateset.text() , uo_dateend.text() , GVI_ORGANIZATION_ID )
			end if 
				sle_pcb_serial_no.setfocus()
				
	CASE 'INSERT'
	
	
			if sle_pcb_serial_no.text = '' or isnull(sle_pcb_serial_no.text) or sle_pcb_serial_no.text = '%' then 
				return 
			end if 
			Lvl_row = dw_1.insertrow(0)
			dw_1.scrolltorow(Lvl_row)
			f_set_security_row(dw_1 , Lvl_row , 'ALL')
			F_MSG_MDI_HELP ( F_MSG_ST(152)	 )
			
	CASE 'DELETE'
		
		  	if dw_1.getrow() < 1 then return 
			  
			msg =f_msgbox(1003)
			if msg = 1 then
				gvl_row_deleted = dw_1.getrow()			
				dw_1.deleterow(gvl_row_deleted)		
				dw_1.setfocus()
				Lvl_row = dw_1.getrow()
				dw_1.scrolltorow(Lvl_row)
				dw_1.setcolumn(1)
			end if
			sle_pcb_serial_no.setfocus()
	CASE 'UPDATE'
		
		DW_1.ACCEPTTEXT()
 
	      IF DW_1.UPDATE() < 0 THEN
				ROLLBACK;	
				sle_pcb_serial_no.setfocus()
		ELSE
				 COMMIT;
       			 F_MSG_MDI_HELP ( F_MSG_ST(170)	 ) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
				sle_pcb_serial_no.setfocus()
		END IF
      
	CASE ELSE
END CHOOSE


end event

event resize;call super::resize;st_status.width = dw_3.width
end event

type dw_5 from w_main_root`dw_5 within w_pln_product_pcb_destroy_master
integer y = 948
integer height = 776
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_pln_product_pcb_destroy_master
integer y = 948
integer height = 776
integer taborder = 0
end type

type dw_3 from w_main_root`dw_3 within w_pln_product_pcb_destroy_master
integer y = 948
integer width = 4626
integer height = 976
integer taborder = 0
boolean titlebar = true
string title = "Repair History"
string dataobject = "d_pln_product_destroy_hst"
end type

type dw_2 from w_main_root`dw_2 within w_pln_product_pcb_destroy_master
integer x = 3529
integer y = 948
integer width = 1093
integer height = 976
integer taborder = 0
boolean titlebar = true
string title = "Issue List"
string dataobject = "d_pln_product_work_qc_issue_lst"
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

type dw_1 from w_main_root`dw_1 within w_pln_product_pcb_destroy_master
integer y = 948
integer width = 3529
integer height = 976
integer taborder = 0
boolean titlebar = true
string title = "Product Work QC List"
string dataobject = "d_pln_product_work_destroy_lst"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;lvl_row = currentrow
end event

type uo_tabpages from w_main_root`uo_tabpages within w_pln_product_pcb_destroy_master
integer taborder = 0
end type

type st_status from so_statictext within w_pln_product_pcb_destroy_master
integer width = 5056
integer height = 148
boolean bringtotop = true
integer textsize = -22
long textcolor = 65535
long backcolor = 134217741
string text = "Wait"
end type

type gb_2 from so_groupbox within w_pln_product_pcb_destroy_master
integer x = 617
integer y = 156
integer width = 4439
integer height = 304
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_pln_product_pcb_destroy_master
integer x = 14
integer y = 156
integer width = 599
integer height = 304
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type cb_1 from so_commandbutton within w_pln_product_pcb_destroy_master
integer x = 558
integer y = 512
integer height = 128
boolean bringtotop = true
string text = "Bad Reason"
end type

event clicked;call super::clicked;open(w_bad_reason_select_popup)

if Gst_return.gvb_return = true then 

	sle_bad_reason_code.text = Gst_return.gvs_return[1]
end if 

sle_pcb_serial_no.setfocus()
end event

type cb_4 from so_commandbutton within w_pln_product_pcb_destroy_master
integer x = 558
integer y = 644
integer height = 128
integer taborder = 31
boolean bringtotop = true
string text = "Issue"
end type

event clicked;call super::clicked;f_update()
sle_pcb_serial_no.text = ''

long lvl_sequence
string lvs_serial_no

		if dw_1.getrow() < 1 then 
			return 
		end if 
		
		lvl_sequence = dw_1.object.qc_sequence[dw_1.getrow()]
		lvs_serial_no = dw_1.object.serial_no[dw_1.getrow()]
		
		update ip_product_work_qc set receipt_deficit = '2'  , repair_date = sysdate
		 where serial_no = :lvs_serial_no
		      and qc_sequence = :lvl_sequence
			  and organization_id = :gvi_organization_id ;
			  
		if f_sql_check() < 0 then 
			return 
		end if 
		
		commit ;
		
		dw_1.retrieve(lvs_serial_no , gvi_organization_id)
		dw_2.retrieve(lvs_serial_no , gvi_organization_id)
		
end event

type cb_5 from so_commandbutton within w_pln_product_pcb_destroy_master
integer x = 558
integer y = 780
integer height = 128
integer taborder = 41
boolean bringtotop = true
string text = "Issue Cancel"
end type

event clicked;call super::clicked;f_update()
sle_pcb_serial_no.text = ''

string lvs_serial_no

		if dw_2.getrow() < 1 then 
			return 
		end if 
		
		lvs_serial_no = dw_2.object.serial_no[dw_2.getrow()]
		
		update ip_product_work_qc set receipt_deficit = '1'  , repair_date = null
		 where serial_no = :lvs_serial_no
			  and organization_id = :gvi_organization_id ;
			  
		if f_sql_check() < 0 then 
			return 
		end if 
		
		commit ;
		
		dw_1.retrieve(lvs_serial_no , gvi_organization_id)
		dw_2.retrieve(lvs_serial_no , gvi_organization_id)
		sle_pcb_serial_no.setfocus()
end event

type rb_destroy from so_radiobutton within w_pln_product_pcb_destroy_master
integer x = 73
integer y = 236
boolean bringtotop = true
string text = "Destroy"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true
dw_2.bringtotop = true
selected_data_window = dw_1
sle_pcb_serial_no.setfocus()
end event

type rb_history from so_radiobutton within w_pln_product_pcb_destroy_master
integer x = 73
integer y = 336
boolean bringtotop = true
string text = "History"
end type

event clicked;call super::clicked;dw_3.bringtotop = true
selected_data_window = dw_3
sle_pcb_serial_no.setfocus()
end event

type sle_bad_reason_code from so_singlelineedit within w_pln_product_pcb_destroy_master
integer x = 69
integer y = 708
integer width = 425
integer taborder = 41
boolean bringtotop = true
boolean displayonly = true
end type

type st_1 from so_statictext within w_pln_product_pcb_destroy_master
integer x = 69
integer y = 628
integer width = 425
integer height = 68
boolean bringtotop = true
string text = "Bad Reason Code"
end type

type ddlb_workstage_code from uo_workstage_code_all within w_pln_product_pcb_destroy_master
integer x = 1179
integer y = 320
integer width = 576
integer height = 840
integer taborder = 41
boolean bringtotop = true
end type

event selectionchanged;call super::selectionchanged;sle_pcb_serial_no.setfocus()
end event

type cb_3 from so_commandbutton within w_pln_product_pcb_destroy_master
integer x = 2962
integer y = 492
integer width = 590
integer height = 112
integer taborder = 31
boolean bringtotop = true
string text = "Paste"
end type

event clicked;call super::clicked;dw_serial_no.reset()
dw_serial_no.importclipboard( )
ivl_error = 0 //$$HEX7$$d0c5ecb7200008cd30ae54d62000$$ENDHEX$$
end event

type cb_6 from so_commandbutton within w_pln_product_pcb_destroy_master
integer x = 2962
integer y = 600
integer width = 590
integer height = 112
integer taborder = 41
boolean bringtotop = true
string text = "Reset"
end type

event clicked;call super::clicked;dw_serial_no.reset()
end event

type dw_serial_no from datawindow within w_pln_product_pcb_destroy_master
integer x = 1157
integer y = 480
integer width = 1787
integer height = 456
integer taborder = 30
boolean bringtotop = true
boolean titlebar = true
string title = "Serial No"
string dataobject = "de_serial_no_lst"
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_2 from so_commandbutton within w_pln_product_pcb_destroy_master
integer x = 2962
integer y = 708
integer width = 590
integer height = 112
integer taborder = 51
boolean bringtotop = true
string text = "Destroy"
end type

event clicked;call super::clicked;long i 
string lvs_serial_no , lvs_bad_reason_code

lvs_bad_reason_code = sle_bad_reason_code.text
if lvs_bad_reason_code = '' or isnull(lvs_bad_reason_code) or lvs_bad_reason_code = '%' then 
	f_play_sound("scanfailed.wav")	
	messagebox("Notify" , f_get_dual_lang_text( gvs_language , "BAD REASON CODE NOT FOUND" ) )
	return 
end if 

//===============================================
//
//===============================================
do
	i++
	
	lvs_serial_no = dw_serial_no.object.serial_no[i]

	if lvs_serial_no = '' or isnull(lvs_serial_no) or lvs_serial_no = '%' then 
		f_play_sound("scanfailed.wav")			
	    dw_serial_no.object.status[i] = 'FAIL'
	    continue	 
	end if 
	
	sle_pcb_serial_no.text = lvs_serial_no
	sle_pcb_serial_no.event modified( )
	
	if ivl_error < 0 then 
	   dw_serial_no.object.status[i] = 'FAIL'
	   continue
	else
	   dw_serial_no.object.status[i] = 'OK'
	end if 
	st_status.text = STRING(I) +"/"+ STRING(dw_serial_no.rowcount())
loop until i = dw_serial_no.rowcount()
end event

type cb_7 from so_commandbutton within w_pln_product_pcb_destroy_master
integer x = 2962
integer y = 812
integer width = 590
integer height = 112
integer taborder = 61
boolean bringtotop = true
string text = "Save As"
end type

event clicked;call super::clicked;dw_serial_no.saveas()
end event

type st_4 from statictext within w_pln_product_pcb_destroy_master
integer x = 1769
integer y = 232
integer width = 809
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Model Name"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_model_name from uo_set_model_name_ddlb within w_pln_product_pcb_destroy_master
integer x = 1765
integer y = 320
integer height = 1936
integer taborder = 51
boolean bringtotop = true
end type

type ddlb_line_code from uo_line_code within w_pln_product_pcb_destroy_master
integer x = 677
integer y = 320
integer width = 498
integer height = 1936
integer taborder = 61
boolean bringtotop = true
long backcolor = 16777215
end type

type st_3 from statictext within w_pln_product_pcb_destroy_master
integer x = 677
integer y = 232
integer width = 489
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Line Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_5 from so_statictext within w_pln_product_pcb_destroy_master
integer x = 1175
integer y = 232
integer width = 585
integer height = 68
boolean bringtotop = true
long textcolor = 0
string text = "Workstage Code"
end type

type sle_pcb_serial_no from so_singlelineedit within w_pln_product_pcb_destroy_master
integer x = 2578
integer y = 320
integer width = 768
integer taborder = 11
boolean bringtotop = true
textcase textcase = upper!
end type

event getfocus;call super::getfocus;this.selecttext( 1,30)
end event

event modified;call super::modified;string lvs_serial_no ,  lvs_line_code , lvs_bad_reason_code , lvs_workstage_code , lvs_item_code , lvs_model_name , lvs_model_suffix, lvs_operationname, lvs_location, lvs_shift_code
long lvl_sequence , ll_row
		
		dw_1.reset()
		dw_2.reset()

		lvs_serial_no = this.text 
	
		//=================
		//shift code 
		//=================
	    select f_get_work_shift_code(sysdate) 
		   into :lvs_shift_code
		  from dual l; 
		
		if sqlca.sqlcode = 100 or sqlca.sqlcode < 0  then 
			lvs_shift_code = '1'
		end if 
		
		//==============================================
		// 12.21 
		// IP_PRODUCT_WORKSTAGE_IO $$HEX11$$5cb8200080bd30d120005ccd85c820007cb778c72000$$ENDHEX$$, $$HEX10$$f5ac15c815c8f4bc7cb9200000ac38c834c62000$$ENDHEX$$
		//
		//==============================================
		select line_code, workstage_code 
			into :lvs_line_code, :lvs_workstage_code 
		  from ip_product_workstage_io 
		where serial_no = :lvs_serial_no 
			and wip_seq  = ( select max(wip_seq) 
											  from ip_product_workstage_io
								  where serial_no = :lvs_serial_no ) ;
				
		if sqlca.sqlcode = 100 then 
			
			/***************************
			*PID WorkStage $$HEX12$$d0c51cc120003eccc0c92000bbba60d52000bdacb0c62000$$ENDHEX$$
			* $$HEX8$$20c1ddd01cb420007cb778c7fcac2000$$ENDHEX$$WS $$HEX6$$7cb9200023b1b4c50cc92000$$ENDHEX$$
			***************************/
			
		     lvs_line_code = ddlb_line_code.getcode( )
			if lvs_line_code = '' or isnull(lvs_line_code) or lvs_line_code = '%' then 
				lvs_line_code = '*'
			end if 
			
			lvs_workstage_code = ddlb_workstage_code.getcode( )
			if lvs_workstage_code = '' or isnull(lvs_workstage_code) or lvs_workstage_code = '%' then 
				lvs_workstage_code = '*'
			end if 				
		end if
		//==================================================
		// $$HEX5$$d9b3c4b3c1c069d62000$$ENDHEX$$
		 // 1. SMT $$HEX9$$f5ac15c820000fbc2000c4d6f5ac15c82000$$ENDHEX$$Routing $$HEX14$$f5ac15c8c0c998b0c0c920004ac558c544c720002000bdacb0c62000$$ENDHEX$$workstage $$HEX9$$d0c5200070b374c730d12000c6c54cc72000$$ENDHEX$$
		//    $$HEX14$$f8adf4b72000bdacb0c6200020c1ddd01cb420007cb778c7fcac2000$$ENDHEX$$workstage $$HEX4$$15c8f4bc7cb92000$$ENDHEX$$
		//==================================================

		if rb_destroy.checked = true then 
		
						ll_row = dw_1.retrieve( sle_pcb_serial_no.text , gvi_organization_id )
						
						//==================================
						//$$HEX25$$85c7e0ac00ac200018b4b4c5200088c794b22000c1c0dcd0200074c774ba2000f8ade5b02000acb934d120005cd5e4b22000$$ENDHEX$$
						//==================================
						if ll_row > 0 then 
							sle_pcb_serial_no.text = ''
							sle_pcb_serial_no.setfocus()			
							return 
						end if 
						
						lvs_serial_no = sle_pcb_serial_no.text 
						lvl_sequence = F_GET_SEQUENCE( "SEQ_QC_REPAIR_SEQUENCE")
						
						if lvs_serial_no = '' or isnull(lvs_serial_no) or lvs_serial_no = '%' then 
							sle_pcb_serial_no.text = ''
							sle_pcb_serial_no.setfocus()			
							return 
						end if 
						
						//==============================================
						// 
						//  $$HEX18$$a4c294ce2000c8b9a4c230d15cb8200080bd45d1200015c8f4bc200000ac38c834c62000$$ENDHEX$$
						// 
						//==============================================

						select distinct  ITEM_CODE ,  MODEL_NAME  , MODEL_SUFFIX , '*','*' 
						into :lvs_item_code , :lvs_model_name  , :lvs_model_suffix,  :lvs_operationname ,:lvs_location
						from IP_PRODUCT_2D_BARCODE
						where  serial_no = :lvs_serial_no
						 and organization_id = :gvi_organization_id ;  
							 
						if f_sql_check() < 0 then 
							return 
						end if 	 							


						//===============================================

						f_insert()
				
						
						dw_1.object.repair_line_code[lvl_row] = '*'                        //$$HEX9$$18c2acb990c7e0c258c720007cb778c72000$$ENDHEX$$
						dw_1.object.repair_workstage_code[lvl_row]   = '*'  //$$HEX7$$18c2acb990c7e0c2f5ac15c82000$$ENDHEX$$
						
						dw_1.object.model_name[lvl_row] = lvs_model_name
						dw_1.object.model_suffix[lvl_row] = lvs_model_suffix
						dw_1.object.item_code[lvl_row] = lvs_item_code
						dw_1.object.serial_no[lvl_row]   = lvs_serial_no
						
						dw_1.object.bad_reason_code[lvl_row]  =  lvs_bad_reason_code
						  
						dw_1.object.qc_result[lvl_row]  =  'N'
						dw_1.object.line_code[lvl_row] = lvs_line_code
						dw_1.object.machine_code[lvl_row] = '*'		
						dw_1.object.workstage_code[lvl_row] = lvs_workstage_code
					
					    dw_1.object.location_code[lvl_row] = lvs_location + ' ' + lvs_operationname
					
						dw_1.object.receipt_deficit[lvl_row] = '1'
						dw_1.object.qc_inspect_handling[lvl_row] = 'D'	
						dw_1.object.qc_date[lvl_row] = f_sysdate()
						dw_1.object.charger[lvl_row] = gvs_user_id
						
						dw_1.object.shift_code[lvl_row] = lvs_shift_code
					
						dw_1.object.qc_sequence[lvl_row] = lvl_sequence
						dw_1.object.repair_by[lvl_row] = Gvs_user_id
						
						dw_1.object.bad_qty[lvl_row] = 1
						dw_1.object.defect_qty[lvl_row] = 1
						
						f_update()
						//====================================
						// $$HEX23$$74c704c8d0c52000d9b37cc720005cd52000dcc2acb9bcc52000200010cde0ac200074c725b8200070c88cd62000$$ENDHEX$$
						//
						//====================================
						dw_2.retrieve(sle_pcb_serial_no.text , gvi_organization_id)		
				
						sle_pcb_serial_no.text = ''
						sle_pcb_serial_no.setfocus()
						
			else
						dw_2.retrieve(sle_pcb_serial_no.text , gvi_organization_id)		
			end if 

end event

type st_9 from statictext within w_pln_product_pcb_destroy_master
integer x = 2578
integer y = 232
integer width = 768
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "PCB Serial No"
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_dateset from uo_ymd_calendar within w_pln_product_pcb_destroy_master
event destroy ( )
integer x = 3351
integer y = 312
integer taborder = 40
boolean bringtotop = true
long backcolor = 12632256
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type st_10 from so_statictext within w_pln_product_pcb_destroy_master
integer x = 3351
integer y = 232
integer width = 823
integer height = 68
boolean bringtotop = true
string text = "QC Date"
end type

type uo_dateend from uo_ymd_calendar within w_pln_product_pcb_destroy_master
event destroy ( )
integer x = 3771
integer y = 312
integer taborder = 50
boolean bringtotop = true
long backcolor = 12632256
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type ddlb_receipt_deficit from uo_basecode within w_pln_product_pcb_destroy_master
integer x = 4201
integer y = 312
integer width = 352
integer height = 508
integer taborder = 81
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw("RECEIPT DEFICIT")
end event

type st_11 from so_statictext within w_pln_product_pcb_destroy_master
integer x = 4201
integer y = 232
integer width = 352
integer height = 68
boolean bringtotop = true
string text = "Receipt Deficit"
end type

type st_12 from so_statictext within w_pln_product_pcb_destroy_master
integer x = 4558
integer y = 232
integer width = 462
integer height = 68
boolean bringtotop = true
string text = "Repair Result Code"
end type

type ddlb_repair_result_code from uo_basecode within w_pln_product_pcb_destroy_master
integer x = 4558
integer y = 312
integer width = 462
integer height = 1936
integer taborder = 91
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'REPAIR RESULT CODE')
end event

type gb_1 from so_groupbox within w_pln_product_pcb_destroy_master
integer x = 14
integer y = 464
integer width = 1125
integer height = 464
integer taborder = 11
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

