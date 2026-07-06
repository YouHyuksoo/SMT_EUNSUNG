HA$PBExportHeader$w_mat_supplier_data_master.srw
$PBExportComments$Material Receipt Cancel Master
forward
global type w_mat_supplier_data_master from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_mat_supplier_data_master
end type
type uo_dateend from uo_ymd_calendar within w_mat_supplier_data_master
end type
type ddlb_item_code from uo_item_code within w_mat_supplier_data_master
end type
type st_3 from so_statictext within w_mat_supplier_data_master
end type
type st_4 from so_statictext within w_mat_supplier_data_master
end type
type rb_cancel from so_radiobutton within w_mat_supplier_data_master
end type
type rb_hst from so_radiobutton within w_mat_supplier_data_master
end type
type ddlb_supplier_code from uo_supplier_code within w_mat_supplier_data_master
end type
type st_1 from so_statictext within w_mat_supplier_data_master
end type
type sle_item_name from so_singlelineedit within w_mat_supplier_data_master
end type
type st_14 from so_statictext within w_mat_supplier_data_master
end type
type st_2 from so_statictext within w_mat_supplier_data_master
end type
type sle_1 from so_singlelineedit within w_mat_supplier_data_master
end type
type cb_batch from so_commandbutton within w_mat_supplier_data_master
end type
type uo_generate_date from uo_ymd_calendar within w_mat_supplier_data_master
end type
type st_5 from so_statictext within w_mat_supplier_data_master
end type
type gb_1 from so_groupbox within w_mat_supplier_data_master
end type
type gb_2 from so_groupbox within w_mat_supplier_data_master
end type
type gb_3 from so_groupbox within w_mat_supplier_data_master
end type
end forward

global type w_mat_supplier_data_master from w_main_root
integer width = 4718
integer height = 2952
string title = "Supplier Data Master"
uo_dateset uo_dateset
uo_dateend uo_dateend
ddlb_item_code ddlb_item_code
st_3 st_3
st_4 st_4
rb_cancel rb_cancel
rb_hst rb_hst
ddlb_supplier_code ddlb_supplier_code
st_1 st_1
sle_item_name sle_item_name
st_14 st_14
st_2 st_2
sle_1 sle_1
cb_batch cb_batch
uo_generate_date uo_generate_date
st_5 st_5
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_mat_supplier_data_master w_mat_supplier_data_master

on w_mat_supplier_data_master.create
int iCurrent
call super::create
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.ddlb_item_code=create ddlb_item_code
this.st_3=create st_3
this.st_4=create st_4
this.rb_cancel=create rb_cancel
this.rb_hst=create rb_hst
this.ddlb_supplier_code=create ddlb_supplier_code
this.st_1=create st_1
this.sle_item_name=create sle_item_name
this.st_14=create st_14
this.st_2=create st_2
this.sle_1=create sle_1
this.cb_batch=create cb_batch
this.uo_generate_date=create uo_generate_date
this.st_5=create st_5
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateset
this.Control[iCurrent+2]=this.uo_dateend
this.Control[iCurrent+3]=this.ddlb_item_code
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.rb_cancel
this.Control[iCurrent+7]=this.rb_hst
this.Control[iCurrent+8]=this.ddlb_supplier_code
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.sle_item_name
this.Control[iCurrent+11]=this.st_14
this.Control[iCurrent+12]=this.st_2
this.Control[iCurrent+13]=this.sle_1
this.Control[iCurrent+14]=this.cb_batch
this.Control[iCurrent+15]=this.uo_generate_date
this.Control[iCurrent+16]=this.st_5
this.Control[iCurrent+17]=this.gb_1
this.Control[iCurrent+18]=this.gb_2
this.Control[iCurrent+19]=this.gb_3
end on

on w_mat_supplier_data_master.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.ddlb_item_code)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.rb_cancel)
destroy(this.rb_hst)
destroy(this.ddlb_supplier_code)
destroy(this.st_1)
destroy(this.sle_item_name)
destroy(this.st_14)
destroy(this.st_2)
destroy(this.sle_1)
destroy(this.cb_batch)
destroy(this.uo_generate_date)
destroy(this.st_5)
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
F_MENU_CONTROL('DATA_CONTROL_MODIFY' , TRUE)  // All Data Control





end event

event ue_post_open;call super::ue_post_open;

/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
if Gvi_user_level >=8 then 
else
	ddlb_supplier_code.text = Gvs_user_id
end if 
end event

event ue_data_control;call super::ue_data_control;long row
string lvs_date
double lvd_seq
choose case gvs_ue_data_control
		
	case 'RETRIEVE'
			dw_1.reset()
			dw_2.reset()
	
			if rb_cancel.checked = true  then 
			    dw_1.retrieve( ddlb_supplier_code.text+'%' , ddlb_item_code.text() + '%', uo_dateset.text(), uo_dateend.text(),  gvi_organization_id)
			else
			    dw_2.retrieve( ddlb_supplier_code.text+'%', ddlb_item_code.text() + '%', uo_dateset.text(), uo_dateend.text(),  gvi_organization_id)
			end if 
	
//    case 'INSERT'
//		
//			ROW = DW_2.INSERTROW(DW_2.GETROW())
//			DW_2.SCROLLTOROW(ROW)
//			F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')
//			lvd_seq = f_get_sequence('seq_mat_arrival')
//			lvs_date = string(f_t_sysdate(),'yyyymmdd') + string(lvd_seq)
//			dw_2.object.arrival_date[row] = f_t_sysdate()
//			dw_2.object.inspect_date[row] = f_t_sysdate()
//			dw_2.object.arrival_seq_no[row] = lvd_seq
//			dw_2.object.invoice_no[row] = lvs_date
//			dw_2.object.order_no[row] = lvs_date
//			dw_2.object.mfs[row] = lvs_date
//			dw_2.object.arrival_status[row] = 'N'
//			dw_2.object.inspect_result[row]  = 'P'
//			dw_2.object.inspect_rule[row]  = 'P'			
//			
//	case 'APPEND'		
//			
//			ROW = DW_2.INSERTROW(DW_2.GETROW())
//			DW_2.SCROLLTOROW(ROW)
//			F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')	
//			lvd_seq = f_get_sequence('seq_mat_arrival')
//			lvs_date = string(f_t_sysdate(),'yyyymmdd') + string(lvd_seq)
//			dw_2.object.arrival_date[row] = f_t_sysdate()
//			dw_2.object.inspect_date[row] = f_t_sysdate()
//			dw_2.object.arrival_seq_no[row] = lvd_seq
//			dw_2.object.invoice_no[row] = lvs_date
//			dw_2.object.order_no[row] = lvs_date
//			dw_2.object.mfs[row] = lvs_date
//			dw_2.object.arrival_status[row] = 'N'
//			dw_2.object.inspect_result[row]  = 'P'
//			dw_2.object.inspect_rule[row]  = 'P'
//			
//	case 'DELETE'
//		
//		  	if DW_2.AcceptText() = -1 then
//				return
//			end if
//			
//			MSG = F_MSGBOX(1003)  //$$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?
//			IF MSG = 1 THEN
//				Gvl_row_deleted = DW_2.GetRow()			
//				DW_2.DELETEROW(Gvl_row_deleted)		
//				DW_2.SetFocus()
//				ROW = DW_2.GetRow()
//				DW_2.ScrollToRow(row)
//				DW_2.SetColumn(1)
//			END IF		 
   case 'UPDATE'
					IF DW_1.UPDATE() < 0   THEN
					ROLLBACK;
					ELSE
					COMMIT;
					F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
					F_RETRIEVE()
					END IF
			
	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_mat_supplier_data_master
integer y = 316
end type

type dw_4 from w_main_root`dw_4 within w_mat_supplier_data_master
integer y = 316
end type

type dw_3 from w_main_root`dw_3 within w_mat_supplier_data_master
integer y = 320
end type

type dw_2 from w_main_root`dw_2 within w_mat_supplier_data_master
integer y = 316
integer width = 4549
integer height = 2536
boolean titlebar = true
string title = "Material Receipt History"
string dataobject = "d_com_supplier_data_hist"
boolean hsplitscroll = false
boolean livescroll = false
end type

type dw_1 from w_main_root`dw_1 within w_mat_supplier_data_master
integer y = 316
integer width = 4544
integer height = 2540
boolean titlebar = true
string title = "Material Receipt Return List"
string dataobject = "d_com_supplier_data_lst"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_mat_supplier_data_master
end type

type uo_dateset from uo_ymd_calendar within w_mat_supplier_data_master
event destroy ( )
integer x = 750
integer y = 176
integer taborder = 30
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mat_supplier_data_master
event destroy ( )
integer x = 1166
integer y = 176
integer taborder = 40
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type ddlb_item_code from uo_item_code within w_mat_supplier_data_master
integer x = 1591
integer y = 176
integer width = 494
integer taborder = 20
boolean bringtotop = true
end type

type st_3 from so_statictext within w_mat_supplier_data_master
integer x = 1591
integer y = 92
integer width = 494
integer height = 56
boolean bringtotop = true
string text = "Item Code"
end type

type st_4 from so_statictext within w_mat_supplier_data_master
integer x = 754
integer y = 92
integer width = 823
integer height = 56
boolean bringtotop = true
string text = "Date"
end type

type rb_cancel from so_radiobutton within w_mat_supplier_data_master
integer x = 55
integer y = 80
integer width = 613
boolean bringtotop = true
integer weight = 700
string text = "Data List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1



end event

type rb_hst from so_radiobutton within w_mat_supplier_data_master
integer x = 55
integer y = 184
integer width = 613
boolean bringtotop = true
integer weight = 700
string text = "Data History"
end type

event clicked;call super::clicked;dw_2.bringtotop = true 
selected_data_window = dw_2


end event

type ddlb_supplier_code from uo_supplier_code within w_mat_supplier_data_master
integer x = 2089
integer y = 176
integer width = 475
integer height = 724
integer taborder = 20
boolean bringtotop = true
end type

event constructor;call super::constructor;if Gvi_user_level >=3 then 
	this.enabled = true 
else
	this.enabled = false
	
end if 
end event

type st_1 from so_statictext within w_mat_supplier_data_master
integer x = 2089
integer y = 92
integer width = 475
integer height = 56
boolean bringtotop = true
string text = "Supplier Code"
end type

type sle_item_name from so_singlelineedit within w_mat_supplier_data_master
integer x = 2565
integer y = 176
integer width = 384
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

event getfocus;this.selecttext( 1 , len( this.text) )
this.Borderstyle = styleraised!
end event

event losefocus;this.Borderstyle = styleLowered!
end event

event ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

SELECTED_DATA_WINDOW.SETFILTER('')
SELECTED_DATA_WINDOW.FILTER()

LVS_COLUMN = 'ITEM_NAME'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    SELECTED_DATA_WINDOW.SETFILTER('')
    SELECTED_DATA_WINDOW.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

SELECTED_DATA_WINDOW.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
SELECTED_DATA_WINDOW.FILTER()
F_MSG_MDI_HELP( STRING( SELECTED_DATA_WINDOW.ROWCOUNT() ) + " Found" )
end event

type st_14 from so_statictext within w_mat_supplier_data_master
integer x = 2565
integer y = 92
integer width = 384
integer height = 56
boolean bringtotop = true
long textcolor = 16711680
string text = "Item Name"
end type

type st_2 from so_statictext within w_mat_supplier_data_master
integer x = 2958
integer y = 92
integer width = 443
integer height = 56
boolean bringtotop = true
long textcolor = 16711680
string text = "Item Spec"
end type

type sle_1 from so_singlelineedit within w_mat_supplier_data_master
integer x = 2958
integer y = 176
integer width = 443
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

event getfocus;this.selecttext( 1 , len( this.text) )
this.Borderstyle = styleraised!
end event

event losefocus;this.Borderstyle = styleLowered!
end event

event ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

SELECTED_DATA_WINDOW.SETFILTER('')
SELECTED_DATA_WINDOW.FILTER()

LVS_COLUMN = 'ITEM_SPEC'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    SELECTED_DATA_WINDOW.SETFILTER('')
    SELECTED_DATA_WINDOW.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

SELECTED_DATA_WINDOW.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
SELECTED_DATA_WINDOW.FILTER()
F_MSG_MDI_HELP( STRING( SELECTED_DATA_WINDOW.ROWCOUNT() ) + " Found" )
end event

type cb_batch from so_commandbutton within w_mat_supplier_data_master
integer x = 3918
integer y = 108
integer width = 503
integer height = 116
integer taborder = 40
boolean bringtotop = true
string text = "Generate"
end type

event clicked;call super::clicked;STRING LVS_SUPPLIER_CODE
Datetime Lvdt_dateset
LVS_SUPPLIER_CODE = ddlb_supplier_code.text 
Lvdt_dateset = uo_generate_date.text()

  INSERT INTO ICOM_SUPPLIER_DATA  
         ( SUPPLIER_CODE,   
           ORGANIZATION_ID,   
           DATESET,   
           ITEM_CODE,   
           LINE_TYPE,   
           PLAN_QTY,   
           PRODUCT_ACTUAL_QTY,   
           DELIVERY_QTY,   
           ARRIVAL_QTY,   
           RECEIPT_QTY,   
           RETURN_QTY,   
           INVENTORY_QTY,   
           ENTER_DATE,   
           ENTER_BY,   
           LAST_MODIFY_DATE,   
           LAST_MODIFY_BY )  
			  
SELECT SUPPLIER_CODE,   
           ORGANIZATION_ID,   
           :lvdt_dateset,   
           ITEM_CODE,   
           LINE_TYPE,   
		  0 PLAN_QTY,   
           0 PRODUCT_ACTUAL_QTY,   
           0 DELIVERY_QTY,   
           0 ARRIVAL_QTY,   
           0 RECEIPT_QTY,   
           0 RETURN_QTY,   
           0 INVENTORY_QTY,   
           ENTER_DATE,   
           ENTER_BY,   
           LAST_MODIFY_DATE,   
           LAST_MODIFY_BY
  FROM IM_ITEM_UNIT_PRICE
  WHERE SUPPLIER_CODE = :LVS_SUPPLIER_CODE
  AND ORGANIZATION_ID  = :GVI_ORGANIZation_id 
  AND DATESET <= :Lvdt_dateset
  AND DATEEND >= :Lvdt_dateset
  AND ( SUPPLIER_CODE , ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ) 
       NOT IN ( SELECT SUPPLIER_CODE , ITEM_CODE , LINE_TYPE , ORGANIZATION_ID 
		              FROM ICOM_SUPPLIER_DATA
                   WHERE  SUPPLIER_CODE     = :LVS_SUPPLIER_CODE
					  AND ORGANIZATION_ID = :GVI_ORGANIZation_id 
					  AND DATESET = :Lvdt_dateset                						  
				 ) ;	  

  IF F_SQL_CHECK() < 0 THEN 
	RETURN 
  END IF 

  
COMMIT  ;

F_RETRIEVE()

end event

type uo_generate_date from uo_ymd_calendar within w_mat_supplier_data_master
integer x = 3465
integer y = 172
integer taborder = 50
boolean bringtotop = true
end type

on uo_generate_date.destroy
call uo_ymd_calendar::destroy
end on

type st_5 from so_statictext within w_mat_supplier_data_master
integer x = 3465
integer y = 100
integer width = 421
integer height = 56
boolean bringtotop = true
string text = "Generate Date"
end type

type gb_1 from so_groupbox within w_mat_supplier_data_master
integer x = 9
integer width = 699
integer height = 300
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_2 from so_groupbox within w_mat_supplier_data_master
integer x = 3415
integer width = 1033
integer height = 300
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_3 from so_groupbox within w_mat_supplier_data_master
integer x = 713
integer width = 2702
integer height = 300
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

