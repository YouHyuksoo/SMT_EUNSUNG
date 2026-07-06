HA$PBExportHeader$w_mat_solder_receipt_issue_master.srw
$PBExportComments$$$HEX8$$08ae15d680acacc074c725b800adacb9$$ENDHEX$$
forward
global type w_mat_solder_receipt_issue_master from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_mat_solder_receipt_issue_master
end type
type uo_dateend from uo_ymd_calendar within w_mat_solder_receipt_issue_master
end type
type st_3 from so_statictext within w_mat_solder_receipt_issue_master
end type
type st_4 from so_statictext within w_mat_solder_receipt_issue_master
end type
type cb_receipt from so_commandbutton within w_mat_solder_receipt_issue_master
end type
type sle_lot_no from so_singlelineedit within w_mat_solder_receipt_issue_master
end type
type sle_barcode from so_singlelineedit within w_mat_solder_receipt_issue_master
end type
type st_1 from so_statictext within w_mat_solder_receipt_issue_master
end type
type ddlb_line_code from uo_line_code within w_mat_solder_receipt_issue_master
end type
type st_2 from so_statictext within w_mat_solder_receipt_issue_master
end type
type ddlb_solder_type from uo_basecode within w_mat_solder_receipt_issue_master
end type
type st_5 from so_statictext within w_mat_solder_receipt_issue_master
end type
type rb_running from so_radiobutton within w_mat_solder_receipt_issue_master
end type
type rb_2 from so_radiobutton within w_mat_solder_receipt_issue_master
end type
type gb_2 from so_groupbox within w_mat_solder_receipt_issue_master
end type
type gb_1 from so_groupbox within w_mat_solder_receipt_issue_master
end type
type gb_3 from so_groupbox within w_mat_solder_receipt_issue_master
end type
end forward

global type w_mat_solder_receipt_issue_master from w_main_root
integer width = 4827
integer height = 3028
string title = "Solder Receipt Issue Query"
uo_dateset uo_dateset
uo_dateend uo_dateend
st_3 st_3
st_4 st_4
cb_receipt cb_receipt
sle_lot_no sle_lot_no
sle_barcode sle_barcode
st_1 st_1
ddlb_line_code ddlb_line_code
st_2 st_2
ddlb_solder_type ddlb_solder_type
st_5 st_5
rb_running rb_running
rb_2 rb_2
gb_2 gb_2
gb_1 gb_1
gb_3 gb_3
end type
global w_mat_solder_receipt_issue_master w_mat_solder_receipt_issue_master

forward prototypes
public function integer wf_insert (string arg_solder_lot_no, string arg_type)
end prototypes

public function integer wf_insert (string arg_solder_lot_no, string arg_type);STRING LVS_ITEM_CODE
INT LVI_COUNT 

//========================================================
// $$HEX12$$7cb7a8bc20001cbc89d5200074c725b82000b4cc6cd02000$$ENDHEX$$
//========================================================

	   SELECT ITEM_CODE  
		  INTO :LVS_ITEM_CODE
		 FROM IM_ITEM_RECEIPT_BARCODE
	  WHERE LOT_NO = :arg_solder_lot_no
		  AND ORGANIZATION_ID = :GVI_ORganization_id ;
		 
	  IF F_SQL_CHECK() < 0 THEN 
		 RETURN -1 
	  END IF 
	  
	  
	  IF LVS_ITEM_CODE = '' OR ISNULL(LVS_ITEM_CODE) THEN
		
		F_MSGBOX1(815 , "$$HEX12$$85c7e0ac14bc54cfdcb420007cb7a8bc200015c8f4bc2000$$ENDHEX$$"+arg_solder_lot_no+"  " ) 
		RETURN -1 
	  END IF 
//========================================================
//
//========================================================
if arg_type = 'R' then 
	
	
			 SELECT COUNT(*) INTO :LVI_COUNT
				FROM  IM_ITEM_SOLDER_MASTER 
			  WHERE SOLDER_LOT_NO = :arg_solder_lot_no
						  AND ORGANIZATION_ID = :GVI_ORganization_id ; 
						  
				IF F_SQL_CHECK() < 0 THEN 
					RETURN -1
				END IF 
				 
				IF 	LVI_COUNT > 0 THEN 
					F_MSGBOX1(813 , arg_solder_lot_no ) 
					RETURN -1 
				ELSE
				
							  INSERT INTO IM_ITEM_SOLDER_MASTER  
										( ITEM_CODE,   
										  SOLDER_LOT_NO,   
										  RECEIPT_DATE,   
										  ISSUE_DATE,   
										  OPEN_DATE,   
										  RETURN_DATE,   
										  LINE_CODE,   
										  WORKSTAGE_CODE,   
										  MACHINE_CODE,   
										  ENTER_DATE,   
										  ENTER_BY,   
										  LAST_MODIFY_DATE,   
										  LAST_MODIFY_BY,   
										  ORGANIZATION_ID )  
							  VALUES (
										  :LVS_ITEM_CODE,   
										  :ARG_SOLDER_LOT_NO,   
										  SYSDATE ,  //RECEIPT_DATE,   
										  NULL , //ISSUE_DATE,   
										  NULL , //OPEN_DATE,   
										  NULL , //RETURN_DATE,   
										  NULL , //LINE_CODE,   
										  NULL , //WORKSTAGE_CODE,   
										  NULL , //MACHINE_CODE,   
										  SYSDATE , //ENTER_DATE,   
										  :GVS_USER_ID , //ENTER_BY,   
										  SYSDATE , //LAST_MODIFY_DATE,   
										  :GVS_USER_ID , //LAST_MODIFY_BY,   
										  :GVI_ORGANIZATION_ID)  ;
										  
							  IF F_SQL_CHECK() < 0 THEN 
								RETURN -1 
							  END IF 
				END IF 
//=========================================================
//  $$HEX3$$9ccde0ac2000$$ENDHEX$$
//=========================================================
elseif arg_type = 'I' then 
	
			 SELECT COUNT(*) INTO :LVI_COUNT
				FROM  IM_ITEM_SOLDER_MASTER 
			  WHERE SOLDER_LOT_NO = :arg_solder_lot_no
				  AND ORGANIZATION_ID = :GVI_ORganization_id ; 
						  
				IF F_SQL_CHECK() < 0 THEN 
					RETURN -1
				END IF 
			  				  
								 
				IF 	LVI_COUNT = 0 THEN 
					F_MSGBOX1(815 , arg_solder_lot_no ) 
					RETURN -1 		
				END IF 
		
			UPDATE IM_ITEM_SOLDER_MASTER SET ISSUE_DATE = SYSDATE 
			 WHERE SOLDER_LOT_NO = :ARG_SOLder_lot_no 
				  AND ORGANIZATION_ID = :GVI_ORGAnization_id ;
								  
			  IF F_SQL_CHECK() < 0 THEN 
				RETURN -1 
			  END IF 
			  				
end if 	

COMMIT ;
RETURN  1 
end function

on w_mat_solder_receipt_issue_master.create
int iCurrent
call super::create
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.st_3=create st_3
this.st_4=create st_4
this.cb_receipt=create cb_receipt
this.sle_lot_no=create sle_lot_no
this.sle_barcode=create sle_barcode
this.st_1=create st_1
this.ddlb_line_code=create ddlb_line_code
this.st_2=create st_2
this.ddlb_solder_type=create ddlb_solder_type
this.st_5=create st_5
this.rb_running=create rb_running
this.rb_2=create rb_2
this.gb_2=create gb_2
this.gb_1=create gb_1
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateset
this.Control[iCurrent+2]=this.uo_dateend
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.cb_receipt
this.Control[iCurrent+6]=this.sle_lot_no
this.Control[iCurrent+7]=this.sle_barcode
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.ddlb_line_code
this.Control[iCurrent+10]=this.st_2
this.Control[iCurrent+11]=this.ddlb_solder_type
this.Control[iCurrent+12]=this.st_5
this.Control[iCurrent+13]=this.rb_running
this.Control[iCurrent+14]=this.rb_2
this.Control[iCurrent+15]=this.gb_2
this.Control[iCurrent+16]=this.gb_1
this.Control[iCurrent+17]=this.gb_3
end on

on w_mat_solder_receipt_issue_master.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.cb_receipt)
destroy(this.sle_lot_no)
destroy(this.sle_barcode)
destroy(this.st_1)
destroy(this.ddlb_line_code)
destroy(this.st_2)
destroy(this.ddlb_solder_type)
destroy(this.st_5)
destroy(this.rb_running)
destroy(this.rb_2)
destroy(this.gb_2)
destroy(this.gb_1)
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
//Ivs_resize_type                      = 'MASTER_DETAIL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
//ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
//ivs_dw_2_use_focusindicator = 'N' //Default
//ivs_dw_3_use_focusindicator = 'N' //Default
//ivs_dw_4_use_focusindicator = 'N' //Default
//ivs_dw_5_use_focusindicator = 'N' //Default
//

Ivs_resize_type    = 'MASTER_DETAIL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'Y' //Default
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





end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
uo_dateset.settext(string(f_t_sysdate(), 'yyyy/mm')+'/01')

end event

event ue_data_control;call super::ue_data_control;long row
string lvs_date
double LVDB_RCV_ISS_SEQ
choose case gvs_ue_data_control
		
	case 'RETRIEVE'
		
			dw_1.reset()
			dw_2.reset()
			if rb_running.checked = true then 
				
			    dw_1.retrieve(sle_lot_no.text + '%' ,  sle_barcode.text + '%', uo_dateset.text() , uo_dateend.text() ,  ddlb_line_code.getcode()+'%' , ddlb_solder_type.getcode()+'%' ,  gvi_organization_id)		
			else
			    dw_3.retrieve(sle_lot_no.text + '%' ,  sle_barcode.text + '%', uo_dateset.text() , uo_dateend.text() ,  ddlb_line_code.getcode()+'%' , ddlb_solder_type.getcode()+'%' ,  gvi_organization_id)		
				
			end if 
		dw_2.retrieve()
	

//	CASE	'INSERT'
//		
//			dw_1.ENABLED = TRUE
//			ROW = dw_1.INSERTROW(dw_1.GETROW())
//			dw_1.SCROLLTOROW(ROW)
//			F_SET_SECURITY_ROW(dw_1 , ROW ,'ALL')				
//
//	CASE	'APPEND'
//		
//			dw_1.ENABLED = TRUE
//			ROW = dw_1.INSERTROW(0)
//			dw_1.SCROLLTOROW(ROW)
//			F_SET_SECURITY_ROW(dw_1 , ROW ,'ALL')				
//
//	CASE	'DELETE'
//			if dw_1.AcceptText() = -1 then
//				return
//			end if
//			
//			MSG = F_MSGBOX(1003)  //$$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?
//			IF MSG = 1 THEN
//				Gvl_row_deleted = dw_1.GetRow()			
//				dw_1.DELETEROW(Gvl_row_deleted)		
//				dw_1.SetFocus()
//				ROW = dw_1.GetRow()
//				dw_1.ScrollToRow(row)
//				dw_1.SetColumn(1)
//			END IF  
//
   case 'UPDATE'
		
		   if gvi_user_level < 8 then 
				return 
			end if 
			
			IF DW_1.UPDATE() < 0 or DW_3.UPDATE() < 0  THEN
			  	 ROLLBACK;
				 RETURN
			ELSE
				 COMMIT;
				 F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"			 
			END IF
	
	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_mat_solder_receipt_issue_master
integer y = 324
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_mat_solder_receipt_issue_master
integer y = 324
integer taborder = 0
end type

type dw_3 from w_main_root`dw_3 within w_mat_solder_receipt_issue_master
integer y = 324
integer width = 1646
integer height = 1032
integer taborder = 0
boolean titlebar = true
string title = "All"
string dataobject = "d_mat_solder_receipt_issue_lst"
end type

type dw_2 from w_main_root`dw_2 within w_mat_solder_receipt_issue_master
integer y = 1384
integer width = 4169
integer height = 544
integer taborder = 0
boolean titlebar = true
string dataobject = "d_mat_solder_receipt_cnt_lst"
boolean hsplitscroll = false
boolean livescroll = false
end type

type dw_1 from w_main_root`dw_1 within w_mat_solder_receipt_issue_master
integer y = 324
integer width = 4169
integer height = 1056
integer taborder = 0
boolean titlebar = true
string title = "Running"
string dataobject = "d_mat_solder_receipt_issue_4_running_lst"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_mat_solder_receipt_issue_master
integer taborder = 0
end type

type uo_dateset from uo_ymd_calendar within w_mat_solder_receipt_issue_master
event destroy ( )
integer x = 576
integer y = 168
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mat_solder_receipt_issue_master
event destroy ( )
integer x = 992
integer y = 168
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_3 from so_statictext within w_mat_solder_receipt_issue_master
integer x = 1957
integer y = 80
integer width = 585
integer height = 68
boolean bringtotop = true
string text = "Solder Lot No"
end type

type st_4 from so_statictext within w_mat_solder_receipt_issue_master
integer x = 581
integer y = 88
integer width = 814
integer height = 68
boolean bringtotop = true
string text = "Receipt Date"
end type

type cb_receipt from so_commandbutton within w_mat_solder_receipt_issue_master
integer x = 3877
integer y = 108
integer height = 112
integer taborder = 30
boolean bringtotop = true
string text = "Scan"
end type

event clicked;call super::clicked;OPEN(w_mat_solder_scan_barcode_popup)

end event

type sle_lot_no from so_singlelineedit within w_mat_solder_receipt_issue_master
integer x = 1957
integer y = 164
integer width = 585
integer taborder = 50
boolean bringtotop = true
end type

type sle_barcode from so_singlelineedit within w_mat_solder_receipt_issue_master
integer x = 2555
integer y = 164
integer width = 622
integer taborder = 60
boolean bringtotop = true
end type

type st_1 from so_statictext within w_mat_solder_receipt_issue_master
integer x = 2555
integer y = 76
integer width = 622
integer height = 68
boolean bringtotop = true
string text = "Solder Barcode"
end type

type ddlb_line_code from uo_line_code within w_mat_solder_receipt_issue_master
integer x = 1417
integer y = 164
integer width = 535
integer height = 1936
integer taborder = 50
boolean bringtotop = true
end type

type st_2 from so_statictext within w_mat_solder_receipt_issue_master
integer x = 1417
integer y = 84
integer width = 539
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Line Code"
end type

type ddlb_solder_type from uo_basecode within w_mat_solder_receipt_issue_master
integer x = 3191
integer y = 164
integer width = 489
integer taborder = 40
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw('SOLDER TYPE')
end event

type st_5 from so_statictext within w_mat_solder_receipt_issue_master
integer x = 3200
integer y = 84
integer width = 475
integer height = 64
boolean bringtotop = true
string text = "Solder Type"
end type

type rb_running from so_radiobutton within w_mat_solder_receipt_issue_master
integer x = 59
integer y = 84
integer width = 402
boolean bringtotop = true
string text = "Running"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true
selected_data_window = dw_1
end event

type rb_2 from so_radiobutton within w_mat_solder_receipt_issue_master
integer x = 59
integer y = 188
integer width = 402
boolean bringtotop = true
string text = "All"
end type

event clicked;call super::clicked;dw_3.bringtotop = true
selected_data_window = dw_3
end event

type gb_2 from so_groupbox within w_mat_solder_receipt_issue_master
integer x = 539
integer width = 3186
integer height = 300
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_1 from so_groupbox within w_mat_solder_receipt_issue_master
integer x = 3735
integer y = 4
integer width = 791
integer height = 296
string text = "Receipt Issue Option"
end type

type gb_3 from so_groupbox within w_mat_solder_receipt_issue_master
integer x = 9
integer y = 4
integer width = 512
integer height = 296
integer taborder = 50
string text = "Category"
end type

