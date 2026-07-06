HA$PBExportHeader$w_mat_workstage_material_move_cancel_master.srw
$PBExportComments$Material Current Inventory Master
forward
global type w_mat_workstage_material_move_cancel_master from w_main_root
end type
type st_1 from so_statictext within w_mat_workstage_material_move_cancel_master
end type
type ddlb_item_code from uo_item_code within w_mat_workstage_material_move_cancel_master
end type
type sle_item_name from so_singlelineedit within w_mat_workstage_material_move_cancel_master
end type
type st_14 from so_statictext within w_mat_workstage_material_move_cancel_master
end type
type sle_1 from so_singlelineedit within w_mat_workstage_material_move_cancel_master
end type
type st_2 from so_statictext within w_mat_workstage_material_move_cancel_master
end type
type st_3 from so_statictext within w_mat_workstage_material_move_cancel_master
end type
type st_4 from so_statictext within w_mat_workstage_material_move_cancel_master
end type
type cb_1 from commandbutton within w_mat_workstage_material_move_cancel_master
end type
type ddlb_mfs from uo_mfs_workorder within w_mat_workstage_material_move_cancel_master
end type
type ddlb_workstage_code from uo_workstage_code_all within w_mat_workstage_material_move_cancel_master
end type
type st_6 from so_statictext within w_mat_workstage_material_move_cancel_master
end type
type sle_invoice_no from so_singlelineedit within w_mat_workstage_material_move_cancel_master
end type
type uo_dateset from uo_ymd_calendar within w_mat_workstage_material_move_cancel_master
end type
type uo_dateend from uo_ymd_calendar within w_mat_workstage_material_move_cancel_master
end type
type st_yyyymm from so_statictext within w_mat_workstage_material_move_cancel_master
end type
type gb_1 from so_groupbox within w_mat_workstage_material_move_cancel_master
end type
type gb_2 from so_groupbox within w_mat_workstage_material_move_cancel_master
end type
type gb_3 from so_groupbox within w_mat_workstage_material_move_cancel_master
end type
end forward

global type w_mat_workstage_material_move_cancel_master from w_main_root
integer width = 4754
integer height = 3056
string title = "Material Workstage Translate"
st_1 st_1
ddlb_item_code ddlb_item_code
sle_item_name sle_item_name
st_14 st_14
sle_1 sle_1
st_2 st_2
st_3 st_3
st_4 st_4
cb_1 cb_1
ddlb_mfs ddlb_mfs
ddlb_workstage_code ddlb_workstage_code
st_6 st_6
sle_invoice_no sle_invoice_no
uo_dateset uo_dateset
uo_dateend uo_dateend
st_yyyymm st_yyyymm
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_mat_workstage_material_move_cancel_master w_mat_workstage_material_move_cancel_master

type variables
string ivs_preview_yn
end variables

on w_mat_workstage_material_move_cancel_master.create
int iCurrent
call super::create
this.st_1=create st_1
this.ddlb_item_code=create ddlb_item_code
this.sle_item_name=create sle_item_name
this.st_14=create st_14
this.sle_1=create sle_1
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.cb_1=create cb_1
this.ddlb_mfs=create ddlb_mfs
this.ddlb_workstage_code=create ddlb_workstage_code
this.st_6=create st_6
this.sle_invoice_no=create sle_invoice_no
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.st_yyyymm=create st_yyyymm
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.ddlb_item_code
this.Control[iCurrent+3]=this.sle_item_name
this.Control[iCurrent+4]=this.st_14
this.Control[iCurrent+5]=this.sle_1
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.st_4
this.Control[iCurrent+9]=this.cb_1
this.Control[iCurrent+10]=this.ddlb_mfs
this.Control[iCurrent+11]=this.ddlb_workstage_code
this.Control[iCurrent+12]=this.st_6
this.Control[iCurrent+13]=this.sle_invoice_no
this.Control[iCurrent+14]=this.uo_dateset
this.Control[iCurrent+15]=this.uo_dateend
this.Control[iCurrent+16]=this.st_yyyymm
this.Control[iCurrent+17]=this.gb_1
this.Control[iCurrent+18]=this.gb_2
this.Control[iCurrent+19]=this.gb_3
end on

on w_mat_workstage_material_move_cancel_master.destroy
call super::destroy
destroy(this.st_1)
destroy(this.ddlb_item_code)
destroy(this.sle_item_name)
destroy(this.st_14)
destroy(this.sle_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.cb_1)
destroy(this.ddlb_mfs)
destroy(this.ddlb_workstage_code)
destroy(this.st_6)
destroy(this.sle_invoice_no)
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.st_yyyymm)
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

ivs_dw_1_retrice_cancel_popup_open = 'Y'
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
F_MENU_CONTROL('DATA_CONTROL_MODIFY' , TRUE)  // All Data Control
end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

event ue_data_control;call super::ue_data_control;Long row
String lvs_date
choose case gvs_ue_data_control
		
	case 'RETRIEVE'			
		     dw_1.reset()
			dw_1.retrieve(  uo_dateset.TEXT() , uo_dateend.TEXT() ,ddlb_mfs.text+'%' , ddlb_item_code.text+ '%' ,ddlb_workstage_code.getcode()+'%' ,sle_invoice_no.text+'%' , gvi_organization_id)
	case else
		
end choose

end event

type dw_5 from w_main_root`dw_5 within w_mat_workstage_material_move_cancel_master
integer y = 336
integer width = 567
integer height = 448
end type

type dw_4 from w_main_root`dw_4 within w_mat_workstage_material_move_cancel_master
integer y = 336
integer width = 567
integer height = 448
boolean titlebar = true
end type

type dw_3 from w_main_root`dw_3 within w_mat_workstage_material_move_cancel_master
integer y = 336
integer width = 567
integer height = 448
boolean titlebar = true
end type

type dw_2 from w_main_root`dw_2 within w_mat_workstage_material_move_cancel_master
integer y = 336
integer width = 567
integer height = 448
boolean titlebar = true
end type

type dw_1 from w_main_root`dw_1 within w_mat_workstage_material_move_cancel_master
integer y = 336
integer width = 4544
integer height = 1188
boolean titlebar = true
string title = "Material Receipt List"
string dataobject = "d_mat_workstage_receipt_4_move_cancel_lst"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;//if currentrow < 1 then return
//
//dw_2.retrieve( dw_1.object.mfs[currentrow] , dw_1.object.item_code[currentrow] , dw_1.object.work_order_no[currentrow] , dw_1.object.organization_id[currentrow] )
end event

type st_1 from so_statictext within w_mat_workstage_material_move_cancel_master
integer x = 1929
integer y = 108
integer width = 462
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type ddlb_item_code from uo_item_code within w_mat_workstage_material_move_cancel_master
integer x = 1929
integer y = 180
integer width = 462
integer taborder = 20
boolean bringtotop = true
end type

type sle_item_name from so_singlelineedit within w_mat_workstage_material_move_cancel_master
integer x = 2391
integer y = 180
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

type st_14 from so_statictext within w_mat_workstage_material_move_cancel_master
integer x = 2391
integer y = 112
integer width = 384
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Item Name"
end type

type sle_1 from so_singlelineedit within w_mat_workstage_material_move_cancel_master
integer x = 2775
integer y = 180
integer width = 329
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

type st_2 from so_statictext within w_mat_workstage_material_move_cancel_master
integer x = 2775
integer y = 112
integer width = 329
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Item Spec"
end type

type st_3 from so_statictext within w_mat_workstage_material_move_cancel_master
integer x = 1390
integer y = 112
integer width = 535
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Workstage Code"
end type

type st_4 from so_statictext within w_mat_workstage_material_move_cancel_master
integer x = 919
integer y = 108
integer width = 425
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "MFS"
end type

type cb_1 from commandbutton within w_mat_workstage_material_move_cancel_master
integer x = 3831
integer y = 120
integer width = 471
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Batch Cancel"
end type

event clicked;Long i , j
string lvs_rowid , lvs_mfs , lvs_item_code , lvs_invoice_no

dw_1.accepttext( )

if dw_1.getrow( ) < 1 then 
	Messagebox( "Notify" , "Receipt data not found")
	return
end if

do
	i++
	if dw_1.object.check_yn[i] = 'Y' then 
		
		lvs_mfs           = dw_1.object.mfs[i]
		lvs_item_code = dw_1.object.item_code[i] 
		lvs_invoice_no= dw_1.object.invoice_no[i]
		
	else
		continue
	end if
	
	
	
//==========================================================================
// $$HEX10$$e8cd8cc1dcc2d0c594b2200074c7d9b31cb42000$$ENDHEX$$2 $$HEX19$$74ac58c7200070b374c7c0d07cb920005cd5bcae88bcd0c52000e8cd8cc1200098ccacb92000$$ENDHEX$$
// $$HEX18$$70c874ac08c8d0c520001cc888bcfcac2000a1c1a5c788bc38d67cb92000acc0a9c668d5$$ENDHEX$$.
//==========================================================================

		  INSERT INTO "IM_ITEM_WORKSTAGE_RECEIPT"  
         ( "RECEIPT_DATE",   
           "RECEIPT_SEQUENCE",   
           "ORGANIZATION_ID",   
           "ISSUE_DATE",   
           "ISSUE_SEQUENCE",   
           "MFS",   
           "ITEM_CODE",   
           "ITEM_TYPE",   
           "RECEIPT_DEFICIT",   
           "LINE_CODE",   
           "FROM_LINE_CODE",   			  
           "RECEIPT_ACCOUNT",   
           "WORKSTAGE_CODE",   
           "RECEIPT_AMT",   
           "RECEIPT_WEIGHT",   
           "RECEIPT_TYPE",   
           "MACHINE_CODE",   
           "LINE_TYPE",   
           "ITEM_UNIT_WEIGHT",   
           "RECEIPT_STATUS",   
           "RECEIPT_PRICE",   
           "RECEIPT_QTY",   
           "TRANSFER_DATE",   
           "TRANSFER_SEQUENCE",   
           "WORK_ORDER_NO",   
           "TRANSFER_YN",   
           "ENTER_DATE",   
           "ENTER_BY",   
           "LAST_MODIFY_DATE",   
           "LAST_MODIFY_BY",   
           "MFS_CONNECT",   
           "TRANSFER_TYPE",   
           "MATERIAL_MFS",   
           "INVOICE_NO",   
           "SUB_MFS" , "FROM_WORKSTAGE_CODE" )  
     SELECT trunc(sysdate),   
             seq_workstage_receipt_seq.nextval , //"IM_ITEM_WORKSTAGE_RECEIPT"."RECEIPT_SEQUENCE",   
            "IM_ITEM_WORKSTAGE_RECEIPT"."ORGANIZATION_ID",   
            "IM_ITEM_WORKSTAGE_RECEIPT"."ISSUE_DATE",   
            "IM_ITEM_WORKSTAGE_RECEIPT"."ISSUE_SEQUENCE",   
            "IM_ITEM_WORKSTAGE_RECEIPT"."MFS",   
            "IM_ITEM_WORKSTAGE_RECEIPT"."ITEM_CODE",   
            "IM_ITEM_WORKSTAGE_RECEIPT"."ITEM_TYPE",   
            DECODE( "IM_ITEM_WORKSTAGE_RECEIPT"."RECEIPT_DEFICIT",  '1', '2' , '2' , '1' ) ,
            "IM_ITEM_WORKSTAGE_RECEIPT"."LINE_CODE",   
            "IM_ITEM_WORKSTAGE_RECEIPT"."FROM_LINE_CODE",   				
            "IM_ITEM_WORKSTAGE_RECEIPT"."RECEIPT_ACCOUNT",   
            "IM_ITEM_WORKSTAGE_RECEIPT"."WORKSTAGE_CODE",   
            "IM_ITEM_WORKSTAGE_RECEIPT"."RECEIPT_PRICE" * -1 , //"IM_ITEM_WORKSTAGE_RECEIPT"."RECEIPT_AMT",   
            "IM_ITEM_WORKSTAGE_RECEIPT"."RECEIPT_WEIGHT" * -1,   
            "IM_ITEM_WORKSTAGE_RECEIPT"."RECEIPT_TYPE",   
            "IM_ITEM_WORKSTAGE_RECEIPT"."MACHINE_CODE",   
            "IM_ITEM_WORKSTAGE_RECEIPT"."LINE_TYPE",   
            "IM_ITEM_WORKSTAGE_RECEIPT"."ITEM_UNIT_WEIGHT",   
            'C' , //"IM_ITEM_WORKSTAGE_RECEIPT"."RECEIPT_STATUS",   
            "IM_ITEM_WORKSTAGE_RECEIPT"."RECEIPT_PRICE",   
            "IM_ITEM_WORKSTAGE_RECEIPT"."RECEIPT_QTY" * -1,   
            "IM_ITEM_WORKSTAGE_RECEIPT"."TRANSFER_DATE",   
            "IM_ITEM_WORKSTAGE_RECEIPT"."TRANSFER_SEQUENCE",   
            "IM_ITEM_WORKSTAGE_RECEIPT"."WORK_ORDER_NO",   
            "IM_ITEM_WORKSTAGE_RECEIPT"."TRANSFER_YN",   
            sysdate,   
            :gvs_user_id,   
            sysdate,   
            :gvs_user_id,   
            "IM_ITEM_WORKSTAGE_RECEIPT"."MFS_CONNECT",   
            "IM_ITEM_WORKSTAGE_RECEIPT"."TRANSFER_TYPE",   
            "IM_ITEM_WORKSTAGE_RECEIPT"."MATERIAL_MFS",   
            "IM_ITEM_WORKSTAGE_RECEIPT"."INVOICE_NO",   
            "IM_ITEM_WORKSTAGE_RECEIPT"."SUB_MFS"  ,
            "IM_ITEM_WORKSTAGE_RECEIPT"."FROM_WORKSTAGE_CODE"  		
       FROM "IM_ITEM_WORKSTAGE_RECEIPT" 
    WHERE MFS = :LVS_MFS
	    AND ITEM_CODE = :LVS_ITEM_CODE
	    AND INVOICE_NO = :LVS_INVOICE_NO
	    AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
	 
	if f_sql_check() < 0 then 
		return
	end if 

	UPDATE IM_ITEM_WORKSTAGE_RECEIPT SET RECEIPT_STATUS = 'C' 
    WHERE MFS = :LVS_MFS
	    AND ITEM_CODE = :LVS_ITEM_CODE
	    AND INVOICE_NO = :LVS_INVOICE_NO
	    AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ; 
		 
	if f_sql_check() < 0 then 
		return
	end if 		 
	
 j++	
loop until  i = dw_1.rowcount( )

if j > 0  then 
		commit ;		  
		f_retrieve()
		
		f_msgbox(170) //$$HEX7$$00c8a5c718b4c8c5b5c2c8b2e4b2$$ENDHEX$$
else
	     rollback ;
		f_msg_mdi_help( f_msg_st( 9026) ) //$$HEX12$$98ccacb91cb4200074ac18c200ac2000c6c5b5c2c8b2e4b2$$ENDHEX$$.
end if
end event

type ddlb_mfs from uo_mfs_workorder within w_mat_workstage_material_move_cancel_master
integer x = 919
integer y = 176
integer width = 421
integer taborder = 20
boolean bringtotop = true
end type

type ddlb_workstage_code from uo_workstage_code_all within w_mat_workstage_material_move_cancel_master
integer x = 1394
integer y = 184
integer width = 526
integer taborder = 30
boolean bringtotop = true
end type

type st_6 from so_statictext within w_mat_workstage_material_move_cancel_master
integer x = 3109
integer y = 112
integer width = 485
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Invoice No"
end type

type sle_invoice_no from so_singlelineedit within w_mat_workstage_material_move_cancel_master
integer x = 3109
integer y = 180
integer width = 485
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

LVS_COLUMN = 'INVOICE_NO'
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

type uo_dateset from uo_ymd_calendar within w_mat_workstage_material_move_cancel_master
integer x = 105
integer y = 176
integer taborder = 80
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mat_workstage_material_move_cancel_master
integer x = 512
integer y = 176
integer taborder = 90
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_yyyymm from so_statictext within w_mat_workstage_material_move_cancel_master
integer x = 114
integer y = 104
integer width = 805
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Receipt Date"
end type

type gb_1 from so_groupbox within w_mat_workstage_material_move_cancel_master
integer x = 1367
integer y = 4
integer width = 2327
integer height = 320
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Translate Where Condition"
end type

type gb_2 from so_groupbox within w_mat_workstage_material_move_cancel_master
integer x = 3749
integer width = 635
integer height = 320
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_3 from so_groupbox within w_mat_workstage_material_move_cancel_master
integer y = 4
integer width = 1367
integer height = 320
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

