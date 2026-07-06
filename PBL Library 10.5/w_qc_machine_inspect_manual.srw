HA$PBExportHeader$w_qc_machine_inspect_manual.srw
$PBExportComments$$$HEX12$$80acacc030ae5db8200018c291c7c5c52000f1b45db82000$$ENDHEX$$( PID $$HEX3$$30ae00c92000$$ENDHEX$$)
forward
global type w_qc_machine_inspect_manual from w_main_root
end type
type sle_pid_scan from so_singlelineedit within w_qc_machine_inspect_manual
end type
type st_1 from so_statictext within w_qc_machine_inspect_manual
end type
type sle_model_name from so_singlelineedit within w_qc_machine_inspect_manual
end type
type st_mrm_no from so_statictext within w_qc_machine_inspect_manual
end type
type sle_inspector from so_singlelineedit within w_qc_machine_inspect_manual
end type
type st_2 from so_statictext within w_qc_machine_inspect_manual
end type
type ddlb_inspect_type from uo_basecode within w_qc_machine_inspect_manual
end type
type st_5 from so_statictext within w_qc_machine_inspect_manual
end type
type sle_item_code from so_singlelineedit within w_qc_machine_inspect_manual
end type
type st_7 from so_statictext within w_qc_machine_inspect_manual
end type
type rb_inspect from so_radiobutton within w_qc_machine_inspect_manual
end type
type rb_2 from so_radiobutton within w_qc_machine_inspect_manual
end type
type cb_2 from so_commandbutton within w_qc_machine_inspect_manual
end type
type cbx_auto_retrieve from so_checkbox within w_qc_machine_inspect_manual
end type
type st_4 from so_statictext within w_qc_machine_inspect_manual
end type
type uo_dateset from uo_ymd_calendar within w_qc_machine_inspect_manual
end type
type uo_dateend from uo_ymd_calendar within w_qc_machine_inspect_manual
end type
type ddlb_set_line from uo_line_code_dd within w_qc_machine_inspect_manual
end type
type ddlb_set_machine from uo_machine_code_by_line_ws within w_qc_machine_inspect_manual
end type
type ddlb_set_workstage from uo_workstage_code_mcnmachine_by_line within w_qc_machine_inspect_manual
end type
type st_3 from so_statictext within w_qc_machine_inspect_manual
end type
type st_6 from so_statictext within w_qc_machine_inspect_manual
end type
type st_8 from so_statictext within w_qc_machine_inspect_manual
end type
type sle_runno from so_singlelineedit within w_qc_machine_inspect_manual
end type
type st_9 from so_statictext within w_qc_machine_inspect_manual
end type
type gb_2 from so_groupbox within w_qc_machine_inspect_manual
end type
type gb_3 from so_groupbox within w_qc_machine_inspect_manual
end type
type gb_4 from so_groupbox within w_qc_machine_inspect_manual
end type
end forward

global type w_qc_machine_inspect_manual from w_main_root
string tag = "AOI, SPI..."
integer width = 5202
integer height = 2880
string title = "Machine Inspect (Manual)"
long backcolor = 134217732
string ivs_dw_3_use_focusindicator = "Y"
string ivs_dw_1_selected_row_yn = "N"
string ivs_dw_1_deleteselected_yn = "N"
string ivs_dw_2_deleteselected_yn = "N"
string ivs_dw_3_deleteselected_yn = "N"
string ivs_dw_4_deleteselected_yn = "N"
string ivs_dw_5_deleteselected_yn = "N"
sle_pid_scan sle_pid_scan
st_1 st_1
sle_model_name sle_model_name
st_mrm_no st_mrm_no
sle_inspector sle_inspector
st_2 st_2
ddlb_inspect_type ddlb_inspect_type
st_5 st_5
sle_item_code sle_item_code
st_7 st_7
rb_inspect rb_inspect
rb_2 rb_2
cb_2 cb_2
cbx_auto_retrieve cbx_auto_retrieve
st_4 st_4
uo_dateset uo_dateset
uo_dateend uo_dateend
ddlb_set_line ddlb_set_line
ddlb_set_machine ddlb_set_machine
ddlb_set_workstage ddlb_set_workstage
st_3 st_3
st_6 st_6
st_8 st_8
sle_runno sle_runno
st_9 st_9
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
end type
global w_qc_machine_inspect_manual w_qc_machine_inspect_manual

type variables
long lvi_row
boolean is_open // 1 open 
string IVS_LINE_CODE, IVS_WORKSTAGE_CODE, IVS_MACHINE_CODE, IVS_INSPECT_TYPE
end variables

on w_qc_machine_inspect_manual.create
int iCurrent
call super::create
this.sle_pid_scan=create sle_pid_scan
this.st_1=create st_1
this.sle_model_name=create sle_model_name
this.st_mrm_no=create st_mrm_no
this.sle_inspector=create sle_inspector
this.st_2=create st_2
this.ddlb_inspect_type=create ddlb_inspect_type
this.st_5=create st_5
this.sle_item_code=create sle_item_code
this.st_7=create st_7
this.rb_inspect=create rb_inspect
this.rb_2=create rb_2
this.cb_2=create cb_2
this.cbx_auto_retrieve=create cbx_auto_retrieve
this.st_4=create st_4
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.ddlb_set_line=create ddlb_set_line
this.ddlb_set_machine=create ddlb_set_machine
this.ddlb_set_workstage=create ddlb_set_workstage
this.st_3=create st_3
this.st_6=create st_6
this.st_8=create st_8
this.sle_runno=create sle_runno
this.st_9=create st_9
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_pid_scan
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.sle_model_name
this.Control[iCurrent+4]=this.st_mrm_no
this.Control[iCurrent+5]=this.sle_inspector
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.ddlb_inspect_type
this.Control[iCurrent+8]=this.st_5
this.Control[iCurrent+9]=this.sle_item_code
this.Control[iCurrent+10]=this.st_7
this.Control[iCurrent+11]=this.rb_inspect
this.Control[iCurrent+12]=this.rb_2
this.Control[iCurrent+13]=this.cb_2
this.Control[iCurrent+14]=this.cbx_auto_retrieve
this.Control[iCurrent+15]=this.st_4
this.Control[iCurrent+16]=this.uo_dateset
this.Control[iCurrent+17]=this.uo_dateend
this.Control[iCurrent+18]=this.ddlb_set_line
this.Control[iCurrent+19]=this.ddlb_set_machine
this.Control[iCurrent+20]=this.ddlb_set_workstage
this.Control[iCurrent+21]=this.st_3
this.Control[iCurrent+22]=this.st_6
this.Control[iCurrent+23]=this.st_8
this.Control[iCurrent+24]=this.sle_runno
this.Control[iCurrent+25]=this.st_9
this.Control[iCurrent+26]=this.gb_2
this.Control[iCurrent+27]=this.gb_3
this.Control[iCurrent+28]=this.gb_4
end on

on w_qc_machine_inspect_manual.destroy
call super::destroy
destroy(this.sle_pid_scan)
destroy(this.st_1)
destroy(this.sle_model_name)
destroy(this.st_mrm_no)
destroy(this.sle_inspector)
destroy(this.st_2)
destroy(this.ddlb_inspect_type)
destroy(this.st_5)
destroy(this.sle_item_code)
destroy(this.st_7)
destroy(this.rb_inspect)
destroy(this.rb_2)
destroy(this.cb_2)
destroy(this.cbx_auto_retrieve)
destroy(this.st_4)
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.ddlb_set_line)
destroy(this.ddlb_set_machine)
destroy(this.ddlb_set_workstage)
destroy(this.st_3)
destroy(this.st_6)
destroy(this.st_8)
destroy(this.sle_runno)
destroy(this.st_9)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
end on

event activate;call super::activate;/***************************************
* Window Default Property 
****************************************/
Gst_set.window_id            = this.classname() 
Gst_set.author                  = "JiSheng"
Gst_set.creation_date      = '20051101'
Gst_set.last_modify_date = '20170301'
Gst_set.Report_window    = False  // Report Window  True / Flase

/*****************************************
* Data Window Property
******************************************/
Ivs_resize_type                      = 'MASTER_DETAIL_1LF2R'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


ivs_dw_1_use_focusindicator = 'N' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'Y' //Default
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

sle_pid_scan.setfocus( )
//
is_open = false 

end event

event ue_data_control;call super::ue_data_control;choose case gvs_ue_data_control
		
	case 'RETRIEVE'
		
		
		if rb_inspect.checked = true then 
		else
			
			dw_3.retrieve( uo_dateset.text() , uo_dateend.text() , & 
			                      sle_runno.text + '%', sle_model_name.text + '%', & 
					             ddlb_inspect_type.getcode() +'%' , sle_inspector.text + '%', & 
							    ddlb_set_line.getcode() +'%', ddlb_set_workstage.getcode()+'%', ddlb_set_machine.getcode()+'%', & 
							    gvs_language, 	 gvi_organization_id ,  sle_pid_scan.text+'%',  sle_item_code.text+'%'  )
			
		end if 
	CASE 'INSERT'
	
			lvi_row = dw_1.insertrow(dw_1.getrow())
			dw_1.scrolltorow(lvi_row)
			f_set_security_row(dw_1 , lvi_row , 'ALL')
			F_MSG_MDI_HELP ( F_MSG_ST(152)	 )
			
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
			
	case 'UPDATE'
		
			if dw_1.update() < 0 then
				rollback;
			else
				commit;
				f_msg_mdi_help(f_msg_st(170))
			end if
			
	case else
end choose


end event

event open;call super::open;//Workstge, Line, Machine Settting $$HEX2$$38bb1cc8$$ENDHEX$$
is_open = true

end event

type dw_5 from w_main_root`dw_5 within w_qc_machine_inspect_manual
integer y = 492
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_qc_machine_inspect_manual
integer y = 492
integer taborder = 0
end type

type dw_3 from w_main_root`dw_3 within w_qc_machine_inspect_manual
integer y = 484
integer width = 2601
integer height = 1136
integer taborder = 0
boolean titlebar = true
string dataobject = "d_iq_machine_inspect_manual_history"
end type

event dw_3::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 
if cbx_auto_retrieve.checked = true then 
	dw_2.retrieve(  this.object.product_id[currentrow])
end if 
end event

event dw_3::doubleclicked;call super::doubleclicked;if row < 1 then return 
//openwithparm( w_qc_inspect_4_gmes_popup , string( this.object.product_id[row] ))
end event

type dw_2 from w_main_root`dw_2 within w_qc_machine_inspect_manual
integer x = 2615
integer y = 484
integer width = 2514
integer height = 1364
integer taborder = 0
boolean titlebar = true
string title = "History"
string dataobject = "d_iq_machine_inspect_manual_hist"
end type

event dw_2::doubleclicked;call super::doubleclicked;if row < 1 then return 
//openwithparm( w_qc_inspect_4_gmes_popup , string( this.object.product_id[row] ))
end event

type dw_1 from w_main_root`dw_1 within w_qc_machine_inspect_manual
integer y = 484
integer width = 2610
integer height = 1364
integer taborder = 0
boolean titlebar = true
string title = "Manage"
string dataobject = "d_iq_machine_inspect_manual_mst"
end type

event dw_1::clicked;call super::clicked;sle_pid_scan.setfocus( )
end event

event dw_1::doubleclicked;call super::doubleclicked;if row < 1 then return 


end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 
if cbx_auto_retrieve.checked = true then 
	dw_2.retrieve(  this.object.product_id[currentrow])
end if 
end event

event dw_1::itemchanged;call super::itemchanged;if row < 1 then return 

//messa gebox('a', string(dwo.name) + '  ' + data )

if upper(dwo.name) = 'INSPECT_RESULT' and data = 'R' then
//$$HEX6$$88bdc9b7200074c774ba2000$$ENDHEX$$

	open(w_bad_reason_select_popup)
	
	
	//MESSA GEBOX(Gst_return.gvs_return[1], Gst_return.gvs_return[2]) 
	

	if Gst_return.gvb_return = true then 
	
		dw_1.object.defect_code[row]  = Gst_return.gvs_return[1]
		dw_1.object.attribute01[row] = Gst_return.gvs_return[2]
		//dw_1.object.bad_qty[Lvl_row]  = Gst_return.gvl_return[1]    //$$HEX3$$10c818c22000$$ENDHEX$$
		//dw_1.object.defect_qty[Lvl_row]  = Gst_return.gvl_return[2] //
		
		If dw_1.update() < 0 then 
			rollback ;
			//f_play_sound("$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav") 
			f_play_mp3("shibai.mp3")
			dw_1.deleterow(row)
			sle_pid_scan.text = ''
			sle_model_name.text = ''
			sle_pid_scan.setfocus( )
		
			return
		else
			commit ;
			//f_play_sound("$$HEX4$$00c8a5c731c1f5ac$$ENDHEX$$.wav") 
			f_play_mp3("chenggong.mp3")
			sle_pid_scan.text = ''
			sle_model_name.text = ''
			sle_pid_scan.setfocus( )
		end if 
		
		
		
	end if 
	
end if
	
end event

type uo_tabpages from w_main_root`uo_tabpages within w_qc_machine_inspect_manual
integer taborder = 0
end type

type sle_pid_scan from so_singlelineedit within w_qc_machine_inspect_manual
integer x = 562
integer y = 316
integer width = 910
integer height = 104
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 700
long textcolor = 65280
long backcolor = 0
textcase textcase = upper!
end type

event modified;call super::modified;string lvs_serial_no ,  lvs_line_code  , lvs_item_code , lvs_model_name , lvs_model_suffix ,  lvs_set_item_code, lvs_inspector, lvs_runno
long lvl_sequence  , lvi_count

//============================
//  
//============================
if rb_inspect.checked = true then 

else
	return 
end if 

lvs_inspector       = sle_inspector.text 
lvs_serial_no       = this.text 

if ivs_inspect_type = '' or isnull(ivs_inspect_type) or ivs_line_Code = '' or ivs_workstage_code = '' or ivs_machine_code = '' or &
  isnull(ivs_line_code) or isnull(ivs_workstage_code) or isnull(ivs_machine_code) or ivs_line_code = '%' or ivs_workstage_code = '%' or & 
  ivs_machine_code ='%' or ivs_inspect_type = '%' then 
     f_play_mp3("jianchachulitiaojian.mp3")
	//f_play_sound("$$HEX5$$6cad84bdf8bb20c1ddd0$$ENDHEX$$.wav")
	sle_pid_scan.text = ''
	sle_pid_scan.setfocus( )
	Return 	
end if


//$$HEX12$$80acacc090c72000c6c544c74cb520000900090009000900$$ENDHEX$$
if lvs_inspector = '' then 
	//f_play_sound("$$HEX7$$38c199cc80acacc0f4b2f9b290c7$$ENDHEX$$.wav")
	f_play_mp3("tianxiedandnagze.mp3")
	sle_pid_scan.text = ''
	sle_pid_scan.setfocus( )
	Return 
end if 



	//==============================================
	//$$HEX19$$30ae200080acacc0200074c725b874c7200074c8acc7200058d594b2c0c92000b4cc6cd02000$$ENDHEX$$
	//==============================================

	select count(*) 
	into :lvi_count
	from iq_machine_inspect_manual
	where product_id    = :lvs_serial_no
	and inspect_type     = :ivs_inspect_type
	and organization_id = :gvi_organization_id ;
	
	if f_sql_check() < 0 then 
		return 
	end if 

	 if lvi_count > 0 then 
		  //$$HEX9$$74c7f8bb200074c8acc7200069d5c8b2e4b2$$ENDHEX$$. 
		  f_play_mp3("yicunzai.mp3")
		  f_msgbox1(813 , this.text)
		  //$$HEX12$$f1b45db844c72000c4ac8dc12000acc0e4c298b794c62000$$ENDHEX$$? 
		  msg = f_msgbox(1150)
		  if msg = 1 then 
		  else
				sle_pid_scan.text = ''
				sle_pid_scan.setfocus( )
				return 
		  end if 
	end if 

	//==============================================
	// 2D $$HEX19$$14bc54cfdcb42000c8b9a4c230d15cb8200080bd45d1200015c8f4bc200000ac38c834c62000$$ENDHEX$$
	//==============================================
	select item_code, model_name, model_suffix , run_no
	 INTO  :lvs_set_item_code  , :LVS_MODEL_NAME , :lvs_model_suffix, :lvs_runno
	 from ip_product_2d_barcode 
	where serial_no  = :lvs_serial_no ; 



	IF F_SQL_CHECK() < 0 THEN 
		sle_pid_scan.text = ''
		sle_pid_scan.setfocus( )
		RETURN 
	END IF 
	
IF lvs_set_item_code = '' OR ISNULL(lvs_set_item_code) THEN 
		sle_pid_scan.text = ''
		sle_pid_scan.setfocus( )
		//f_play_sound("$$HEX6$$a8ba78b34cc518c2c6c54cc7$$ENDHEX$$.wav")	
		f_play_mp3("jianchaxinghao.mp3")
		//mes sagebox("Notify" , "Not Found PID Information")
		f_msg( "Not Found PID Information", 'P') 
		return 
END IF 

sle_model_name.text = LVS_MODEL_NAME

//=============================================
//
//============================================

sle_item_code.text = lvs_set_item_code

//=============================================
//
//=============================================
f_insert()

dw_1.object.line_code[lvi_row] = ivs_line_code
dw_1.object.workstage_code[lvi_row] = ivs_workstage_code
dw_1.object.machine_code[lvi_row] = ivs_machine_code
dw_1.object.inspect_type[lvi_row] = ivs_inspect_type

dw_1.object.run_no[lvi_row] = lvs_runno
dw_1.object.product_id[lvi_row] = lvs_serial_no
dw_1.object.model_name[lvi_row] = lvs_model_name
dw_1.object.model_suffix[lvi_row] = lvs_model_suffix
dw_1.object.inspect_date[lvi_row] = f_sysdate()
dw_1.object.inspector[lvi_row] = sle_inspector.text
dw_1.object.item_code[lvi_row] = lvs_set_item_code
dw_1.object.inspect_result[lvi_row] = 'P'


if dw_1.update() < 0 then 
	rollback ;
	//f_play_sound("$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav") 
	f_play_mp3("shibai.mp3")
	dw_1.deleterow(lvi_row)
	sle_pid_scan.text = ''
	sle_model_name.text = ''
	sle_pid_scan.setfocus( )

	return
else
	commit ;
	//f_play_sound("$$HEX4$$00c8a5c731c1f5ac$$ENDHEX$$.wav") 
	f_play_mp3("chenggong.mp3")
	sle_pid_scan.text = ''
	sle_model_name.text = ''
	sle_pid_scan.setfocus( )
end if 
		
end event

event getfocus;call super::getfocus;this.selecttext( 1,100)
end event

type st_1 from so_statictext within w_qc_machine_inspect_manual
integer x = 562
integer y = 244
integer width = 910
integer height = 72
boolean bringtotop = true
integer weight = 700
long textcolor = 255
long backcolor = 134217732
string text = "PID"
end type

type sle_model_name from so_singlelineedit within w_qc_machine_inspect_manual
integer x = 2455
integer y = 316
integer width = 535
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
end type

event getfocus;call super::getfocus;this.selecttext( 1,100)
end event

type st_mrm_no from so_statictext within w_qc_machine_inspect_manual
integer x = 2455
integer y = 236
integer width = 535
integer height = 72
boolean bringtotop = true
long backcolor = 134217732
string text = "Model Name"
end type

type sle_inspector from so_singlelineedit within w_qc_machine_inspect_manual
integer x = 1481
integer y = 316
integer width = 411
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
long textcolor = 65280
long backcolor = 0
end type

event getfocus;call super::getfocus;this.selecttext( 1,100)
end event

event modified;call super::modified;//sle_inspect_charger.setfocus( )
end event

type st_2 from so_statictext within w_qc_machine_inspect_manual
integer x = 1481
integer y = 236
integer width = 411
integer height = 72
boolean bringtotop = true
integer weight = 700
long textcolor = 255
long backcolor = 134217732
string text = "Inspector"
end type

type ddlb_inspect_type from uo_basecode within w_qc_machine_inspect_manual
integer x = 3008
integer y = 128
integer width = 809
integer height = 832
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
long backcolor = 134217732
end type

event constructor;call super::constructor;THIS.REdraw( 'INSPECT TYPE')

IVS_INSPECT_TYPE = Profilestring("WORKENV.INI","INSPECT_TYPE","MACHINE_INSPECT","")
THIS.SELECtitem(IVS_INSPECT_TYPE )
end event

event selectionchanged;call super::selectionchanged;//$$HEX19$$70c88cd6200070c874ac3cc75cb82000acc0a9c660d550b52000c0bcbdac200048c568d52000$$ENDHEX$$
if rb_inspect.checked then 
	f_jsSetProfileString ("WORKENV.INI", "INSPECT_TYPE", "MACHINE_INSPECT", THIS.GETCODE() )
	IVS_INSPECT_TYPE = THIS.GETCODE()
end if 

sle_pid_scan.setfocus() 
end event

type st_5 from so_statictext within w_qc_machine_inspect_manual
integer x = 3008
integer y = 52
integer width = 809
integer height = 64
boolean bringtotop = true
integer weight = 700
long textcolor = 255
long backcolor = 134217732
string text = "Inspect Type"
end type

type sle_item_code from so_singlelineedit within w_qc_machine_inspect_manual
integer x = 2994
integer y = 316
integer width = 608
integer height = 104
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
end type

type st_7 from so_statictext within w_qc_machine_inspect_manual
integer x = 2999
integer y = 236
integer width = 594
integer height = 72
boolean bringtotop = true
long backcolor = 134217732
string text = "Item Code"
end type

type rb_inspect from so_radiobutton within w_qc_machine_inspect_manual
integer x = 78
integer y = 88
integer width = 338
boolean bringtotop = true
long backcolor = 134217732
string text = " Inspection"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1

//$$HEX13$$d0c698b7200012ac3cc75cb82000ccb324b82000f4bcc4b02000$$ENDHEX$$
ddlb_set_line.selectItem(IVS_LINE_CODE) 
ddlb_set_workstage.redraw(IVS_LINE_CODE)
ddlb_set_workstage.selectItem(IVS_WORKSTAGE_CODE) 
ddlb_set_machine.redraw(IVS_LINE_CODE, IVS_WORKSTAGE_CODE)
ddlb_set_machine.selectItem(IVS_MACHINE_CODE) 

ddlb_inspect_type.selectItem(IVS_INSPECT_TYPE) 

sle_pid_scan.text = ""
sle_inspector.text = ""

//
sle_pid_scan.setfocus() 


end event

type rb_2 from so_radiobutton within w_qc_machine_inspect_manual
integer x = 78
integer y = 188
integer width = 338
boolean bringtotop = true
long backcolor = 134217732
string text = " History"
end type

event clicked;call super::clicked;dw_3.bringtotop = true 
selected_data_window = dw_3

ddlb_set_line.selectItem('%') 
ddlb_set_workstage.selectItem('%') 
ddlb_set_machine.selectItem('%') 
ddlb_inspect_type.selectItem('%') 

end event

type cb_2 from so_commandbutton within w_qc_machine_inspect_manual
integer x = 4535
integer y = 188
integer height = 160
integer taborder = 40
boolean bringtotop = true
string text = "Reset"
end type

event clicked;call super::clicked;sle_inspector.text = ''
sle_item_code.text = ''
sle_model_name.text = ''
sle_pid_scan.text = ''
ddlb_inspect_type.text = ''	
ddlb_inspect_type.setfocus( )
dw_1.reset()
end event

type cbx_auto_retrieve from so_checkbox within w_qc_machine_inspect_manual
integer x = 4581
integer y = 84
boolean bringtotop = true
long backcolor = 134217732
string text = "Auto Retrieve"
boolean checked = true
end type

type st_4 from so_statictext within w_qc_machine_inspect_manual
integer x = 3653
integer y = 236
integer width = 814
integer height = 68
boolean bringtotop = true
long backcolor = 134217732
string text = "Scan Date"
end type

type uo_dateset from uo_ymd_calendar within w_qc_machine_inspect_manual
event destroy ( )
integer x = 3621
integer y = 312
integer taborder = 50
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_qc_machine_inspect_manual
event destroy ( )
integer x = 4037
integer y = 312
integer taborder = 60
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type ddlb_set_line from uo_line_code_dd within w_qc_machine_inspect_manual
integer x = 562
integer y = 128
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
end type

event selectionchanged;call super::selectionchanged;//$$HEX19$$70c88cd6200070c874ac3cc75cb82000acc0a9c660d550b52000c0bcbdac200048c568d52000$$ENDHEX$$
if rb_inspect.checked then 
	f_jsSetProfileString ("WORKENV.INI", "LINE", "MACHINE_INSPECT", THIS.GETCODE() )
	IVS_LINE_CODE = THIS.GETCODE()
	
	 
end if 

if is_open then return 
ddlb_set_workstage.redraw(this.getcode())
end event

event constructor;call super::constructor;IVS_LINE_CODE = Profilestring("WORKENV.INI","LINE","MACHINE_INSPECT","")
THIS.SELECtitem(IVS_LINE_CODE )


end event

type ddlb_set_machine from uo_machine_code_by_line_ws within w_qc_machine_inspect_manual
integer x = 1883
integer y = 128
integer width = 1106
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 700
end type

event constructor;call super::constructor;IVS_MACHINE_CODE = Profilestring("WORKENV.INI","MACHINE","MACHINE_INSPECT","")
THIS.SELECtitem(IVS_MACHINE_CODE )
end event

event selectionchanged;call super::selectionchanged;//$$HEX19$$70c88cd6200070c874ac3cc75cb82000acc0a9c660d550b52000c0bcbdac200048c568d52000$$ENDHEX$$
if rb_inspect.checked then 
	f_jsSetProfileString ("WORKENV.INI", "MACHINE", "MACHINE_INSPECT", THIS.GETCODE() )
	IVS_MACHINE_CODE = THIS.GETCODE()
end if 

sle_pid_scan.setfocus() 
end event

type ddlb_set_workstage from uo_workstage_code_mcnmachine_by_line within w_qc_machine_inspect_manual
integer x = 1234
integer y = 128
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 700
end type

event selectionchanged;call super::selectionchanged;//$$HEX19$$70c88cd6200070c874ac3cc75cb82000acc0a9c660d550b52000c0bcbdac200048c568d52000$$ENDHEX$$
if rb_inspect.checked then 
	f_jsSetProfileString ("WORKENV.INI", "WORKSTAGE", "MACHINE_INSPECT", THIS.GETCODE() )
	IVS_WORkstage_code = THIS.GETCODE()
end if 


if is_open then return  

ddlb_set_machine.redraw( ddlb_set_line.getcode(), this.getcode() ) 

end event

event constructor;call super::constructor;IVS_WORKSTAGE_CODE = Profilestring("WORKENV.INI","WORKSTAGE","MACHINE_INSPECT","")
THIS.SELECtitem(IVS_WORKSTAGE_CODE )
end event

type st_3 from so_statictext within w_qc_machine_inspect_manual
integer x = 585
integer y = 60
integer width = 631
integer height = 64
boolean bringtotop = true
integer weight = 700
long backcolor = 134217732
string text = "Line"
end type

type st_6 from so_statictext within w_qc_machine_inspect_manual
integer x = 1234
integer y = 60
integer width = 631
integer height = 64
boolean bringtotop = true
integer weight = 700
long backcolor = 134217732
string text = "WorkStage"
end type

type st_8 from so_statictext within w_qc_machine_inspect_manual
integer x = 1883
integer y = 56
integer width = 1106
integer height = 64
boolean bringtotop = true
integer weight = 700
long backcolor = 134217732
string text = "Machine"
end type

type sle_runno from so_singlelineedit within w_qc_machine_inspect_manual
integer x = 1902
integer y = 316
integer width = 549
integer height = 104
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
end type

event getfocus;call super::getfocus;this.selecttext( 1,100)
end event

type st_9 from so_statictext within w_qc_machine_inspect_manual
integer x = 1902
integer y = 236
integer width = 549
integer height = 72
boolean bringtotop = true
long backcolor = 134217732
string text = "Run No"
end type

type gb_2 from so_groupbox within w_qc_machine_inspect_manual
integer width = 485
integer height = 456
integer taborder = 10
long backcolor = 134217732
string text = "Category"
end type

type gb_3 from so_groupbox within w_qc_machine_inspect_manual
integer x = 4494
integer width = 622
integer height = 456
integer taborder = 10
long backcolor = 134217732
string text = "Process"
end type

type gb_4 from so_groupbox within w_qc_machine_inspect_manual
integer x = 503
integer width = 3982
integer height = 456
integer taborder = 10
integer weight = 700
long textcolor = 255
long backcolor = 134217732
string text = "Work Environment"
end type

