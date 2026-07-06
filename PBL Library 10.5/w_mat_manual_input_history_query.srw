HA$PBExportHeader$w_mat_manual_input_history_query.srw
$PBExportComments$Manual input MAT to production line, and inquery
forward
global type w_mat_manual_input_history_query from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_mat_manual_input_history_query
end type
type uo_dateend from uo_ymd_calendar within w_mat_manual_input_history_query
end type
type st_4 from so_statictext within w_mat_manual_input_history_query
end type
type rb_his from so_radiobutton within w_mat_manual_input_history_query
end type
type sle_model_name from so_singlelineedit within w_mat_manual_input_history_query
end type
type st_14 from so_statictext within w_mat_manual_input_history_query
end type
type cb_batch from so_commandbutton within w_mat_manual_input_history_query
end type
type st_6 from so_statictext within w_mat_manual_input_history_query
end type
type sle_run_no from so_singlelineedit within w_mat_manual_input_history_query
end type
type sle_material_lot from so_singlelineedit within w_mat_manual_input_history_query
end type
type st_1 from so_statictext within w_mat_manual_input_history_query
end type
type ddlb_line_code from uo_line_code within w_mat_manual_input_history_query
end type
type ddlb_workstage_code from uo_workstage_code_all within w_mat_manual_input_history_query
end type
type sle_comments from so_singlelineedit within w_mat_manual_input_history_query
end type
type st_2 from so_statictext within w_mat_manual_input_history_query
end type
type st_3 from so_statictext within w_mat_manual_input_history_query
end type
type st_5 from so_statictext within w_mat_manual_input_history_query
end type
type rb_txn from so_radiobutton within w_mat_manual_input_history_query
end type
type gb_1 from so_groupbox within w_mat_manual_input_history_query
end type
type gb_2 from so_groupbox within w_mat_manual_input_history_query
end type
type gb_3 from so_groupbox within w_mat_manual_input_history_query
end type
end forward

global type w_mat_manual_input_history_query from w_main_root
integer width = 4718
integer height = 2952
string title = "Manual Input Material for IMD line"
uo_dateset uo_dateset
uo_dateend uo_dateend
st_4 st_4
rb_his rb_his
sle_model_name sle_model_name
st_14 st_14
cb_batch cb_batch
st_6 st_6
sle_run_no sle_run_no
sle_material_lot sle_material_lot
st_1 st_1
ddlb_line_code ddlb_line_code
ddlb_workstage_code ddlb_workstage_code
sle_comments sle_comments
st_2 st_2
st_3 st_3
st_5 st_5
rb_txn rb_txn
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_mat_manual_input_history_query w_mat_manual_input_history_query

on w_mat_manual_input_history_query.create
int iCurrent
call super::create
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.st_4=create st_4
this.rb_his=create rb_his
this.sle_model_name=create sle_model_name
this.st_14=create st_14
this.cb_batch=create cb_batch
this.st_6=create st_6
this.sle_run_no=create sle_run_no
this.sle_material_lot=create sle_material_lot
this.st_1=create st_1
this.ddlb_line_code=create ddlb_line_code
this.ddlb_workstage_code=create ddlb_workstage_code
this.sle_comments=create sle_comments
this.st_2=create st_2
this.st_3=create st_3
this.st_5=create st_5
this.rb_txn=create rb_txn
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateset
this.Control[iCurrent+2]=this.uo_dateend
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.rb_his
this.Control[iCurrent+5]=this.sle_model_name
this.Control[iCurrent+6]=this.st_14
this.Control[iCurrent+7]=this.cb_batch
this.Control[iCurrent+8]=this.st_6
this.Control[iCurrent+9]=this.sle_run_no
this.Control[iCurrent+10]=this.sle_material_lot
this.Control[iCurrent+11]=this.st_1
this.Control[iCurrent+12]=this.ddlb_line_code
this.Control[iCurrent+13]=this.ddlb_workstage_code
this.Control[iCurrent+14]=this.sle_comments
this.Control[iCurrent+15]=this.st_2
this.Control[iCurrent+16]=this.st_3
this.Control[iCurrent+17]=this.st_5
this.Control[iCurrent+18]=this.rb_txn
this.Control[iCurrent+19]=this.gb_1
this.Control[iCurrent+20]=this.gb_2
this.Control[iCurrent+21]=this.gb_3
end on

on w_mat_manual_input_history_query.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.st_4)
destroy(this.rb_his)
destroy(this.sle_model_name)
destroy(this.st_14)
destroy(this.cb_batch)
destroy(this.st_6)
destroy(this.sle_run_no)
destroy(this.sle_material_lot)
destroy(this.st_1)
destroy(this.ddlb_line_code)
destroy(this.ddlb_workstage_code)
destroy(this.sle_comments)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_5)
destroy(this.rb_txn)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
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
//F_MENU_CONTROL('DATA_CONTROL_MODIFY' , TRUE)  // All Data Control





end event

event ue_post_open;call super::ue_post_open;

/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

event ue_data_control;call super::ue_data_control;
long row
string lvs_workstage_code 


if ( rb_txn.checked = true ) then
	 return
end if

choose case gvs_ue_data_control
		
	case 'RETRIEVE'
		
			dw_1.reset()
	
			dw_1.retrieve(uo_dateset.text(), uo_dateend.text(), ddlb_line_code.getcode()+'%', ddlb_workstage_code.getcode()+'%',  sle_run_no.text+'%' , sle_model_name.text+'%' ,  gvi_organization_id)
				
	case 'DELETE'
		
		           IF  ( dw_1.getrow() < 1 ) THEN RETURN
			  
			      msg =f_msgbox(1003)
			
			      IF ( msg = 1 ) THEN
				
				              gvl_row_deleted = dw_1.getrow()			
				              dw_1.deleterow( gvl_row_deleted )
								  
				              dw_1.setfocus()
				              row = dw_1.getrow()
				              dw_1.scrolltorow( row )
				              dw_1.setcolumn(1)
								  
		          END IF
		
	case 'UPDATE'
				 		
			      if ( dw_1.update() < 0 )  then
				       rollback;
		  	      else
				       commit;
				      f_msg_mdi_help(f_msg_st(170))
			     end if	
					
   Case else

end choose

end event

event open;call super::open;
cb_batch.enabled = false
sle_comments.enabled = false
sle_material_lot.enabled = false
end event

type dw_5 from w_main_root`dw_5 within w_mat_manual_input_history_query
integer x = 59
integer y = 1108
end type

type dw_4 from w_main_root`dw_4 within w_mat_manual_input_history_query
integer x = 165
integer y = 1180
end type

type dw_3 from w_main_root`dw_3 within w_mat_manual_input_history_query
integer x = 261
integer y = 1212
end type

type dw_2 from w_main_root`dw_2 within w_mat_manual_input_history_query
integer y = 616
integer width = 4549
integer height = 2128
boolean titlebar = true
boolean hsplitscroll = false
boolean livescroll = false
end type

type dw_1 from w_main_root`dw_1 within w_mat_manual_input_history_query
integer y = 616
integer width = 4544
integer height = 2056
boolean titlebar = true
string title = "Inupt Material list###"
string dataobject = "d_mat_manual_input_history_lst"
end type

event dw_1::retrievestart;//
end event

event dw_1::retrieverow;//
end event

event dw_1::retrieveend;//
end event

type uo_tabpages from w_main_root`uo_tabpages within w_mat_manual_input_history_query
end type

type uo_dateset from uo_ymd_calendar within w_mat_manual_input_history_query
event destroy ( )
integer x = 777
integer y = 164
integer taborder = 30
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mat_manual_input_history_query
event destroy ( )
integer x = 1193
integer y = 164
integer taborder = 40
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_4 from so_statictext within w_mat_manual_input_history_query
integer x = 782
integer y = 84
integer width = 814
boolean bringtotop = true
integer weight = 700
string text = "Input Date"
end type

type rb_his from so_radiobutton within w_mat_manual_input_history_query
integer x = 46
integer y = 180
integer width = 626
boolean bringtotop = true
integer weight = 700
string text = "Manual Input History"
boolean checked = true
end type

event clicked;call super::clicked;
dw_1.reset()

cb_batch.enabled = false
sle_comments.enabled = false
sle_material_lot.enabled = false

end event

type sle_model_name from so_singlelineedit within w_mat_manual_input_history_query
integer x = 2775
integer y = 164
integer width = 1074
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

type st_14 from so_statictext within w_mat_manual_input_history_query
integer x = 1614
integer y = 84
integer width = 562
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Line code"
end type

type cb_batch from so_commandbutton within w_mat_manual_input_history_query
integer x = 3378
integer y = 416
integer width = 475
integer height = 116
integer taborder = 40
boolean bringtotop = true
string text = "Material Input"
end type

event clicked;call super::clicked;
long       row
string      lvs_line_code, lvs_workstage_code, lvs_run_no, lvs_model_name, lvs_material_lot, lvs_comments, lvs_msg
datetime lvdt_input_date

//-------------------------------------------------------------------------
//  $$HEX20$$90c7acc72cd285c774c725b82000f1b45db844c7200004c75cd5200030ae00c912ac200055d678c7$$ENDHEX$$
//-------------------------------------------------------------------------

lvs_line_code           = ddlb_line_code.getcode( )
lvs_workstage_code = ddlb_workstage_code.getcode( )
lvs_run_no              = trim( sle_run_no.text )
lvs_material_lot        = trim( sle_material_lot.text )
lvs_comments          = trim( sle_comments.text )
lvs_model_name     = trim( sle_model_name.text )

lvdt_input_date       =  f_sysdate()

IF ( lvs_line_code = '%' ) THEN
	
	  F_MSG_MDI_HELP ( F_MSG( '$$HEX11$$7cb778c715c8f4bc7cb9200020c1ddd058d538c194c6$$ENDHEX$$' , 'S') )	
	  ddlb_line_code.setfocus( )
	  return
	  
END IF

IF ( lvs_workstage_code = '%' ) THEN
	
	  F_MSG_MDI_HELP ( F_MSG( '$$HEX10$$f5ac15c8f4bc7cb9200020c1ddd058d538c194c6$$ENDHEX$$' , 'S') )	
	  ddlb_workstage_code.setfocus( )
	  return
	  
END IF

IF ( lvs_run_no = '' OR  ISNULL( lvs_run_no ) ) THEN
	
	  F_MSG_MDI_HELP ( F_MSG( '$$HEX12$$91c7c5c5c0c9dcc27cb9200085c725b8200058d538c194c6$$ENDHEX$$' , 'S') )	
	  sle_run_no.setfocus( )
	  return
	  
END IF

IF ( lvs_model_name = '' OR  ISNULL( lvs_model_name ) ) THEN
	
	  F_MSG_MDI_HELP ( F_MSG( '$$HEX12$$a8ba78b374c784b944c7200085c725b8200058d538c194c6$$ENDHEX$$' , 'S') )	
	  sle_model_name.setfocus( )
	  return
	  
END IF

IF ( lvs_material_lot = '' OR  ISNULL( lvs_material_lot ) ) THEN
	
	  F_MSG_MDI_HELP ( F_MSG( '$$HEX12$$90c7acc76fb8b8d27cb9200085c725b8200058d538c194c6$$ENDHEX$$' , 'S') )	
	  sle_material_lot.setfocus( )
	  return
	  
END IF

//-------------------------------------------------------------------------
//  $$HEX4$$74c725b800c8a5c7$$ENDHEX$$
//-------------------------------------------------------------------------

INSERT INTO IM_ITEM_MANUAL_INPUT_HISTORY (
                                                                   input_date,
                                                                   line_code,
                                                                   workstage_code,
                                                                   run_no,
                                                                   material_lot,
                                                                   comments,
                                                                   enter_by,
                                                                   enter_date,
                                                                   last_modify_by,
                                                                   last_modify_date,
                                                                   organization_id																						 
                                                                )
                                                    VALUES (
														   :lvdt_input_date,
														   :lvs_line_code,
														   :lvs_workstage_code,
														   :lvs_run_no,
														   :lvs_material_lot,
														   :lvs_comments,
                                                                  :gvs_user_id,
														   :lvdt_input_date,
														   :gvs_user_id,
													        :lvdt_input_date,
														   :gvi_organization_id																
                                                                );
																					 
IF ( F_SQL_CHECK() < 0 ) THEN 
	
	ROLLBACK;
	f_play_sound("$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav")	
	lvs_msg = F_MSG('$$HEX19$$90c7acc72cd285c774c725b8200014b544bed0c5200000c8a5c7dcc2200024c658b91cbcddc0$$ENDHEX$$', 'P')
	
	sle_material_lot.setfocus( )	
	return -1 
	
END IF 

//====================================================
//
//====================================================

row =dw_1.insertrow(dw_1.getrow())
dw_1.scrolltorow(row)
F_SET_SECURITY_ROW(DW_1 , ROW ,'ALL')
					
dw_1.object.input_date[row]          = lvdt_input_date
dw_1.object.line_code[row]           =  lvs_line_code
dw_1.object.workstage_code[row] = lvs_workstage_code
dw_1.object.run_no[row]              = lvs_run_no
dw_1.object.model_name[row]      = lvs_model_name
dw_1.object.material_lot[row]       = lvs_material_lot
dw_1.object.comments[row]         = lvs_comments

sle_material_lot.text = ''
sle_comments.text = ''

COMMIT;
F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
f_play_sound("$$HEX4$$00c8a5c731c1f5ac$$ENDHEX$$.wav")

sle_material_lot.setfocus( )









end event

type st_6 from so_statictext within w_mat_manual_input_history_query
integer x = 2203
integer y = 84
integer width = 544
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Workstage Code"
end type

type sle_run_no from so_singlelineedit within w_mat_manual_input_history_query
integer x = 3877
integer y = 164
integer width = 544
integer height = 84
integer taborder = 110
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

event modified;call super::modified;
STRING LVS_RUN_NO, lvs_model_name, lvs_line_code
long      lvl_count

//======================================
// $$HEX16$$85c725b81cb4200091c7c5c5c0c9dcc2200030ae00c92000a8ba78b355d678c7$$ENDHEX$$
//======================================

LVS_RUN_NO   = trim(sle_run_no.text)

lvs_model_name = ''
lvl_count            = 0

SELECT MODEL_NAME, line_code, 1
    INTO :lvs_model_name, :lvs_line_code, :lvl_count
   FROM IP_PRODUCT_RUN_CARD
 WHERE RUN_NO               = :LVS_RUN_NO
     AND ORGANIZATION_ID = :gvi_organization_id;
	  
IF ( F_SQL_CHECK() < 0 ) THEN 
	
	f_play_sound( "S1.wav")
	sle_run_no.text = ''
	sle_run_no.setfocus()
	RETURN 
	
END IF 		  
	  
IF ( lvl_count = 0 ) THEN
	
	f_msg_mdi_help(  F_MSG( '$$HEX14$$85c725b85cd5200091c7c5c5c0c9dcc200ac2000c6c5b5c2c8b2e4b2$$ENDHEX$$' , 'S') )
	  
ELSE
	
     sle_model_name.text = 	lvs_model_name    
     ddlb_line_code.selectitem (lvs_line_code )	
	
END IF;


end event

type sle_material_lot from so_singlelineedit within w_mat_manual_input_history_query
integer x = 59
integer y = 472
integer width = 1623
integer height = 84
integer taborder = 110
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

event modified;call super::modified;

IF ( LEN(trim(this.text)) > 0 ) THEN
	
     cb_batch.triggerevent( clicked!)

END IF

end event

type st_1 from so_statictext within w_mat_manual_input_history_query
integer x = 3067
integer y = 84
integer width = 544
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Model name"
end type

type ddlb_line_code from uo_line_code within w_mat_manual_input_history_query
integer x = 1632
integer y = 164
integer width = 544
integer taborder = 70
boolean bringtotop = true
long backcolor = 16777215
end type

type ddlb_workstage_code from uo_workstage_code_all within w_mat_manual_input_history_query
integer x = 2203
integer y = 164
integer width = 544
integer height = 1448
integer taborder = 40
boolean bringtotop = true
long backcolor = 16777215
boolean sorted = false
end type

type sle_comments from so_singlelineedit within w_mat_manual_input_history_query
integer x = 1710
integer y = 472
integer width = 1623
integer height = 84
integer taborder = 120
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

type st_2 from so_statictext within w_mat_manual_input_history_query
integer x = 3877
integer y = 84
integer width = 544
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Run no"
end type

type st_3 from so_statictext within w_mat_manual_input_history_query
integer x = 635
integer y = 392
integer width = 544
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Material Lot"
end type

type st_5 from so_statictext within w_mat_manual_input_history_query
integer x = 2377
integer y = 396
integer width = 544
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Commets"
end type

type rb_txn from so_radiobutton within w_mat_manual_input_history_query
integer x = 46
integer y = 88
integer width = 626
boolean bringtotop = true
integer weight = 700
string text = "Transaction"
end type

event clicked;call super::clicked;
dw_1.reset()

cb_batch.enabled = true
sle_comments.enabled = true
sle_material_lot.enabled = true


end event

type gb_1 from so_groupbox within w_mat_manual_input_history_query
integer x = 9
integer width = 699
integer height = 300
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_2 from so_groupbox within w_mat_manual_input_history_query
integer x = 5
integer y = 308
integer width = 3950
integer height = 300
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_3 from so_groupbox within w_mat_manual_input_history_query
integer x = 722
integer width = 3849
integer height = 300
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

