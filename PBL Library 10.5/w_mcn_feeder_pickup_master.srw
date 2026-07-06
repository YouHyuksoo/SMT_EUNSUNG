HA$PBExportHeader$w_mcn_feeder_pickup_master.srw
$PBExportComments$Manual input MAT to production line, and inquery
forward
global type w_mcn_feeder_pickup_master from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_mcn_feeder_pickup_master
end type
type uo_dateend from uo_ymd_calendar within w_mcn_feeder_pickup_master
end type
type st_4 from so_statictext within w_mcn_feeder_pickup_master
end type
type rb_his from so_radiobutton within w_mcn_feeder_pickup_master
end type
type st_14 from so_statictext within w_mcn_feeder_pickup_master
end type
type cb_batch from so_commandbutton within w_mcn_feeder_pickup_master
end type
type st_1 from so_statictext within w_mcn_feeder_pickup_master
end type
type ddlb_line_code from uo_line_code within w_mcn_feeder_pickup_master
end type
type st_3 from so_statictext within w_mcn_feeder_pickup_master
end type
type rb_txn from so_radiobutton within w_mcn_feeder_pickup_master
end type
type ddlb_model_name from uo_set_model_name_ddlb within w_mcn_feeder_pickup_master
end type
type uo_input_date from uo_ymd_calendar within w_mcn_feeder_pickup_master
end type
type st_2 from so_statictext within w_mcn_feeder_pickup_master
end type
type sle_item_code from so_singlelineedit within w_mcn_feeder_pickup_master
end type
type cb_save from so_commandbutton within w_mcn_feeder_pickup_master
end type
type cb_reset from so_commandbutton within w_mcn_feeder_pickup_master
end type
type gb_1 from so_groupbox within w_mcn_feeder_pickup_master
end type
type gb_2 from so_groupbox within w_mcn_feeder_pickup_master
end type
type gb_3 from so_groupbox within w_mcn_feeder_pickup_master
end type
end forward

global type w_mcn_feeder_pickup_master from w_main_root
integer width = 5074
integer height = 2952
string title = "Mount Pickup rate"
uo_dateset uo_dateset
uo_dateend uo_dateend
st_4 st_4
rb_his rb_his
st_14 st_14
cb_batch cb_batch
st_1 st_1
ddlb_line_code ddlb_line_code
st_3 st_3
rb_txn rb_txn
ddlb_model_name ddlb_model_name
uo_input_date uo_input_date
st_2 st_2
sle_item_code sle_item_code
cb_save cb_save
cb_reset cb_reset
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_mcn_feeder_pickup_master w_mcn_feeder_pickup_master

on w_mcn_feeder_pickup_master.create
int iCurrent
call super::create
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.st_4=create st_4
this.rb_his=create rb_his
this.st_14=create st_14
this.cb_batch=create cb_batch
this.st_1=create st_1
this.ddlb_line_code=create ddlb_line_code
this.st_3=create st_3
this.rb_txn=create rb_txn
this.ddlb_model_name=create ddlb_model_name
this.uo_input_date=create uo_input_date
this.st_2=create st_2
this.sle_item_code=create sle_item_code
this.cb_save=create cb_save
this.cb_reset=create cb_reset
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateset
this.Control[iCurrent+2]=this.uo_dateend
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.rb_his
this.Control[iCurrent+5]=this.st_14
this.Control[iCurrent+6]=this.cb_batch
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.ddlb_line_code
this.Control[iCurrent+9]=this.st_3
this.Control[iCurrent+10]=this.rb_txn
this.Control[iCurrent+11]=this.ddlb_model_name
this.Control[iCurrent+12]=this.uo_input_date
this.Control[iCurrent+13]=this.st_2
this.Control[iCurrent+14]=this.sle_item_code
this.Control[iCurrent+15]=this.cb_save
this.Control[iCurrent+16]=this.cb_reset
this.Control[iCurrent+17]=this.gb_1
this.Control[iCurrent+18]=this.gb_2
this.Control[iCurrent+19]=this.gb_3
end on

on w_mcn_feeder_pickup_master.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.st_4)
destroy(this.rb_his)
destroy(this.st_14)
destroy(this.cb_batch)
destroy(this.st_1)
destroy(this.ddlb_line_code)
destroy(this.st_3)
destroy(this.rb_txn)
destroy(this.ddlb_model_name)
destroy(this.uo_input_date)
destroy(this.st_2)
destroy(this.sle_item_code)
destroy(this.cb_save)
destroy(this.cb_reset)
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

choose case gvs_ue_data_control
		
	case 'RETRIEVE'
		
			dw_1.reset()
	
			if rb_his.checked = true  then 
			     dw_1.retrieve(uo_dateset.text(), uo_dateend.text(), ddlb_line_code.getcode()+'%', ddlb_model_name.getcode()+'%', sle_item_code.text+'%', gvi_organization_id)
			end if 	
	
	case 'DELETE'
		
		    IF  ( rb_his.checked = TRUE ) THEN 
				
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
			
		END IF
		
	case 'UPDATE'
		
		    dw_1.accepttext( )
		
		    IF  ( rb_his.checked = TRUE ) THEN 
				
			      if ( dw_1.update() < 0 )  then
				       rollback;
		  	      else
				       commit;
				      f_msg_mdi_help(f_msg_st(170))
			     end if	
			
		    END IF
		
   Case else

end choose

end event

event open;call super::open;

f_set_column_dddw(dw_1)
end event

type dw_5 from w_main_root`dw_5 within w_mcn_feeder_pickup_master
integer x = 59
integer y = 1108
end type

type dw_4 from w_main_root`dw_4 within w_mcn_feeder_pickup_master
integer x = 165
integer y = 1180
end type

type dw_3 from w_main_root`dw_3 within w_mcn_feeder_pickup_master
integer x = 261
integer y = 1212
end type

type dw_2 from w_main_root`dw_2 within w_mcn_feeder_pickup_master
integer y = 616
integer width = 4549
integer height = 2176
boolean titlebar = true
string dataobject = "d_com_excel_upload"
boolean livescroll = false
end type

type dw_1 from w_main_root`dw_1 within w_mcn_feeder_pickup_master
integer y = 616
integer width = 4544
integer height = 2056
boolean titlebar = true
string title = "Pickup Data list"
string dataobject = "d_mcn_feeder_pickup_lst"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_mcn_feeder_pickup_master
end type

type uo_dateset from uo_ymd_calendar within w_mcn_feeder_pickup_master
event destroy ( )
integer x = 777
integer y = 164
integer taborder = 30
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mcn_feeder_pickup_master
event destroy ( )
integer x = 1193
integer y = 164
integer taborder = 40
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_4 from so_statictext within w_mcn_feeder_pickup_master
integer x = 782
integer y = 84
integer width = 814
boolean bringtotop = true
integer weight = 700
string text = "Product date"
end type

type rb_his from so_radiobutton within w_mcn_feeder_pickup_master
integer x = 46
integer y = 180
integer width = 631
boolean bringtotop = true
integer weight = 700
string text = "Pickup History"
boolean checked = true
end type

event clicked;call super::clicked;
cb_reset.enabled = false
cb_save.enabled = false
cb_batch.enabled = false
uo_input_date.enabled = false

dw_1.bringtotop = true 
selected_data_window = dw_1
end event

type st_14 from so_statictext within w_mcn_feeder_pickup_master
integer x = 1614
integer y = 84
integer width = 562
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Line code"
end type

type cb_batch from so_commandbutton within w_mcn_feeder_pickup_master
integer x = 1257
integer y = 424
integer width = 475
integer height = 116
integer taborder = 40
boolean bringtotop = true
boolean enabled = false
string text = "Excel upload"
end type

event clicked;call super::clicked;

//-------------------------------------------------------------------------
//  Excel Buffer $$HEX2$$00c8a5c7$$ENDHEX$$
//-------------------------------------------------------------------------

dw_1.reset()
dw_2.reset()

dw_2.importclipboard( )


end event

type st_1 from so_statictext within w_mcn_feeder_pickup_master
integer x = 2729
integer y = 84
integer width = 544
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Model name"
end type

type ddlb_line_code from uo_line_code within w_mcn_feeder_pickup_master
integer x = 1632
integer y = 164
integer width = 544
integer taborder = 70
boolean bringtotop = true
long backcolor = 16777215
end type

type st_3 from so_statictext within w_mcn_feeder_pickup_master
integer x = 91
integer y = 392
integer width = 544
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Input Date"
end type

type rb_txn from so_radiobutton within w_mcn_feeder_pickup_master
integer x = 46
integer y = 88
integer width = 626
boolean bringtotop = true
integer weight = 700
string text = "Transaction"
end type

event clicked;call super::clicked;
cb_reset.enabled = true
cb_batch.enabled = true
cb_save.enabled = true
uo_input_date.enabled = true

dw_1.reset()
dw_2.reset()

dw_2.bringtotop = true 
selected_data_window = dw_2

end event

type ddlb_model_name from uo_set_model_name_ddlb within w_mcn_feeder_pickup_master
integer x = 2208
integer y = 164
integer width = 1669
integer height = 832
integer taborder = 210
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
boolean hscrollbar = false
end type

type uo_input_date from uo_ymd_calendar within w_mcn_feeder_pickup_master
event destroy ( )
integer x = 160
integer y = 472
integer taborder = 40
boolean bringtotop = true
boolean enabled = false
end type

on uo_input_date.destroy
call uo_ymd_calendar::destroy
end on

type st_2 from so_statictext within w_mcn_feeder_pickup_master
integer x = 3909
integer y = 84
integer width = 544
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Item code"
end type

type sle_item_code from so_singlelineedit within w_mcn_feeder_pickup_master
integer x = 3909
integer y = 164
integer width = 544
integer height = 84
integer taborder = 220
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

type cb_save from so_commandbutton within w_mcn_feeder_pickup_master
integer x = 1765
integer y = 424
integer width = 475
integer height = 116
integer taborder = 50
boolean bringtotop = true
boolean enabled = false
string text = "Save"
end type

event clicked;call super::clicked;
long       row
string      lvs_line_code,  lvs_model_name,lvs_item_code, feeder_id,  lvs_msg
datetime lvdt_input_date

//-------------------------------------------------------------------------
//  $$HEX20$$90c7acc72cd285c774c725b82000f1b45db844c7200004c75cd5200030ae00c912ac200055d678c7$$ENDHEX$$
//-------------------------------------------------------------------------

lvs_line_code           = ddlb_line_code.getcode( )
lvs_model_name     = ddlb_model_name.getcode( )

lvdt_input_date       = uo_input_date.text( )

IF ( lvs_line_code = '%' ) THEN
	
	  F_MSG_MDI_HELP ( F_MSG( '$$HEX11$$7cb778c715c8f4bc7cb9200020c1ddd058d538c194c6$$ENDHEX$$' , 'P') )	
	  ddlb_line_code.setfocus( )
	  return
	  
END IF

IF ( dw_2.rowcount( ) = 0 ) THEN 
       F_MSG_MDI_HELP ( F_MSG( '$$HEX14$$00c8a5c7200060d5200070b374c7c0d000ac2000c6c5b5c2c8b2e4b2$$ENDHEX$$' , 'P') )	
	  RETURN
END IF

//IF ( lvs_model_name = '%' ) THEN
//	
//	 F_MSG_MDI_HELP ( F_MSG( '$$HEX12$$a8ba78b374c784b944c7200085c725b8200058d538c194c6$$ENDHEX$$' , 'S') )	
//	  ddlb_model_name.setfocus( )
//	  return
//	  
//END IF

//-------------------------------------------------------------------------
//  Excel Buffer $$HEX2$$00c8a5c7$$ENDHEX$$
//-------------------------------------------------------------------------

setpointer(hourglass!) 

double lvdb_seq

int i
do
	
	i++
	
	lvs_item_code = dw_2.object.C05[i] 
	
	IF ( lvs_item_code = '' OR ISNULL( lvs_item_code ) ) THEN
		  CONTINUE
	END IF
	
	
     ROW = DW_1.INSERTROW(0)
	 DW_1.SCROLLTOROW(ROW)
	 F_SET_SECURITY_ROW(DW_1 , ROW ,'ALL')
	
	dw_1.object.product_date[row] = lvdt_input_date
	dw_1.object.line_code[row]      = lvs_line_code
	dw_1.object.model_name[row] = lvs_model_name
		
	feeder_id        = dw_2.object.C02[i]
	
	//======================================
	// $$HEX29$$70b374c7c0d000ac200011c9f5bc20007cc7200018c2200088c730aed0c520007cc7e8b22000adc01cc880bd30d120003cba00c820005cd5e4b2$$ENDHEX$$
	//======================================
	
	DELETE FROM IQ_MACHINE_INSPECT_DATA_PICKUP
	WHERE product_date               = :lvdt_input_date
	    AND line_code                     = :lvs_line_code
	//	AND NVL(model_name, '*')  = NVL(:lvs_model_name, '*')
	//	AND NVL(item_code,'*')       = NVL(:lvs_item_code, '*')
	//	AND feeder_id                     = :feeder_id
		AND organization_id             = :gvi_organization_id;
		
						
	dw_1.object.feeder_id[row]                     = feeder_id
	dw_1.object.feeder_type[row]                 = dw_2.object.C03[i]
	dw_1.object.item_code[row]                    = lvs_item_code
	dw_1.object.transfer_count[row]              = long( dw_2.object.C32[i] )				
	dw_1.object.adsorption_error_count[row] = long( dw_2.object.C34[i] )
	
	
	IF ( dw_1.object.transfer_count[row] = 0 OR ISNULL( dw_1.object.transfer_count[row] )) THEN
	      dw_1.object.pickup_rate[row]  = 0
	ELSE
		
	      IF ( dw_1.object.adsorption_error_count[row] = 0 OR ISNULL( dw_1.object.adsorption_error_count[row] )) THEN
	            dw_1.object.pickup_rate[row]  = 0
	      ELSE
		        dw_1.object.pickup_rate[row]  = ( dw_1.object.adsorption_error_count[row] / dw_1.object.transfer_count[row] ) *100
	      END IF		
		
	END IF
		
	dw_1.object.pickup_status[row]               = 'OK'
						
loop until i = dw_2.rowcount( )

setpointer(Arrow!) 

COMMIT;

F_MSG_MDI_HELP( "Excel uploading Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"

rb_txn.checked = false
rb_his.checked = true

rb_his.triggerevent( Clicked! )



end event

type cb_reset from so_commandbutton within w_mcn_feeder_pickup_master
integer x = 750
integer y = 424
integer width = 475
integer height = 116
integer taborder = 50
boolean bringtotop = true
boolean enabled = false
string text = "Reset"
end type

event clicked;call super::clicked;

//-------------------------------------------------------------------------
//  Excel Buffer $$HEX2$$00c8a5c7$$ENDHEX$$
//-------------------------------------------------------------------------


dw_1.reset()
dw_2.reset()


end event

type gb_1 from so_groupbox within w_mcn_feeder_pickup_master
integer x = 9
integer width = 699
integer height = 300
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_2 from so_groupbox within w_mcn_feeder_pickup_master
integer x = 9
integer y = 308
integer width = 2382
integer height = 300
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_3 from so_groupbox within w_mcn_feeder_pickup_master
integer x = 722
integer width = 3945
integer height = 300
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

