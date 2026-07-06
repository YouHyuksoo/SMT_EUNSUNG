HA$PBExportHeader$w_pln_2d_baarcode_excel_popup.srw
$PBExportComments$(Item Query)-$$HEX4$$80bd88d470c88cd6$$ENDHEX$$
forward
global type w_pln_2d_baarcode_excel_popup from w_popup_root
end type
type cb_retrieve from commandbutton within w_pln_2d_baarcode_excel_popup
end type
type cb_1 from commandbutton within w_pln_2d_baarcode_excel_popup
end type
type mle_msg from so_multilineedit within w_pln_2d_baarcode_excel_popup
end type
type gb_2 from so_groupbox within w_pln_2d_baarcode_excel_popup
end type
end forward

global type w_pln_2d_baarcode_excel_popup from w_popup_root
integer width = 4283
integer height = 2632
string title = "BOM Popup"
cb_retrieve cb_retrieve
cb_1 cb_1
mle_msg mle_msg
gb_2 gb_2
end type
global w_pln_2d_baarcode_excel_popup w_pln_2d_baarcode_excel_popup

on w_pln_2d_baarcode_excel_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.cb_1=create cb_1
this.mle_msg=create mle_msg
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.mle_msg
this.Control[iCurrent+4]=this.gb_2
end on

on w_pln_2d_baarcode_excel_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.cb_1)
destroy(this.mle_msg)
destroy(this.gb_2)
end on

event open;call super::open;dw_1.settransobject(sqlca)



end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
end if
end event

type p_title from w_popup_root`p_title within w_pln_2d_baarcode_excel_popup
integer width = 4293
end type

type cb_sort from w_popup_root`cb_sort within w_pln_2d_baarcode_excel_popup
integer x = 2665
integer y = 28
integer height = 140
integer taborder = 0
end type

type cb_close from w_popup_root`cb_close within w_pln_2d_baarcode_excel_popup
boolean visible = true
integer x = 1435
integer y = 464
integer width = 421
integer height = 140
integer taborder = 0
end type

event cb_close::clicked;call super::clicked;gst_return.gvb_return = false
end event

type st_msg from w_popup_root`st_msg within w_pln_2d_baarcode_excel_popup
boolean visible = true
integer y = 904
integer width = 4293
end type

type dw_1 from w_popup_root`dw_1 within w_pln_2d_baarcode_excel_popup
boolean visible = true
integer y = 1008
integer width = 4293
integer height = 1564
integer taborder = 70
boolean titlebar = true
string title = "Set Item List"
string dataobject = "d_pln_product_2d_barcode_excel_lst"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;this.selectrow( 0 , false )
this.selectrow( currentrow , true )
end event

type dw_2 from w_popup_root`dw_2 within w_pln_2d_baarcode_excel_popup
boolean visible = true
integer y = 1020
integer taborder = 0
end type

type dw_3 from w_popup_root`dw_3 within w_pln_2d_baarcode_excel_popup
integer y = 784
end type

type cb_retrieve from commandbutton within w_pln_2d_baarcode_excel_popup
integer x = 101
integer y = 464
integer width = 859
integer height = 140
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Paste"
end type

event clicked;dw_1.reset()
dw_1.importclipboard()

long i , lvi_check
string lvs_serial_no
do
	i++
	st_msg.text = 'Checking Serial No...'+string(i)
	lvs_serial_no = dw_1.object.a[i]
	
	
	select count(*) into  :lvi_check
	 from IP_PRODUCT_2D_BARCODE
	where serial_no = :lvs_serial_no ;
	
	if f_sql_check() < 0 then 
		return 
	end if 

	if lvi_check > 0 then 
		
		dw_1.scrolltorow(i)
		st_msg.text = lvs_serial_no+" NG"
		mle_msg.text = mle_msg.text+'~r~n'+f_msg(lvs_serial_no+" $$HEX15$$74c7f8bb200074c8acc7200069d5c8b2e4b2200055d678c758d538c194c6$$ENDHEX$$" , 'S') 
	     continue
	
	end if 
	
loop until  i = dw_1.rowcount( )

//=========================================
//
//=========================================

msg = f_msgbox1(1161 , this.text) 

if msg = 1 then 
else
	return 
end if 

delete from IP_PRODUCT_2D_BARCODE_EXCEL ;
if f_sql_check() < 0 then 
	return 
end if 

if dw_1.update( ) < 0 then 
	rollback;
end if

ST_MSG.TEXT = "Data Inserting..."
//===================================================
//
//===================================================

  INSERT INTO IP_PRODUCT_2D_BARCODE  
         ( RUN_NO,   
           RUN_DATE,   
           ITEM_CODE,   
           SERIAL_NO,   
           LABEL_TEXT,   
           LINE_CODE,   
           WORKSTAGE_CODE,   
           MACHINE_CODE,   
           ARRAY_TYPE,   
           ORGANIZATION_ID,   
           ENTER_DATE,   
           ENTER_BY,   
           LAST_MODIFY_DATE,   
           LAST_MODIFY_BY,   
           MAGAZINE_NO,   
           BOX_NO,   
           PALLETE_NO,   
           CARRIER_BARCODE,   
           QC_SCAN_YN,   
           LOT_NO,   
           QC_SCAN_DATE,   
           MODEL_NAME,   
           LOT_QTY,   
           BARCODE_STATUS,   
           MAPPING_LABEL,   
           WORK_ORDER_NO,   
           CARRIER_SIZE,   
           CUSTOMER_MODEL_NAME,   
           EC_NO,   
           PART_NO,   
           MODEL_SUFFIX,   
           MAGAZINE_DATE,   
           COMMENTS,   
           ACTUAL_DATE,   
           SHIFT_CODE,   
           C_WORKSTAGE_CODE,   
           IS_LAST,   
           WORKTIME_ZONE,   
           ACTUAL_LINE_CODE,   
           MASK_LOT_NO,   
           SQUEEZE_LOT_NO,   
           SOLDER_LOT_NO,   
           MAPPING_MODEL_NAME,   
           SHIPPING_DEFICIT,   
           RECEIPT_DATE,   
           SHIPPING_DATE,   
           POWER_CHECK_YN,   
           IS_PROGRESS,   
           BCR_CODE,   
           LONGTERM_YN )  
 SELECT  '*' RUN_NO,   
           TRUNC(SYSDATE) RUN_DATE,   
           C ITEM_CODE,   
           A SERIAL_NO,   
           A LABEL_TEXT,   
           '00' LINE_CODE,   
           '*' WORKSTAGE_CODE,   
           '*' MACHINE_CODE,   
           1 ARRAY_TYPE,   
           :GVI_ORGANIZATION_ID ORGANIZATION_ID,   
           SYSDATE ENTER_DATE,   
           :GVS_USER_ID ENTER_BY,   
           SYSDATE LAST_MODIFY_DATE,   
           :GVS_USER_ID LAST_MODIFY_BY,   
           '*' MAGAZINE_NO,   
           '*' BOX_NO,   
           '*' PALLETE_NO,   
           '*' CARRIER_BARCODE,   
           'N' QC_SCAN_YN,   
           NULL LOT_NO,   
           NULL QC_SCAN_DATE,   
           C MODEL_NAME,   
           TO_NUMBER(E)  LOT_QTY,   
           'N' BARCODE_STATUS,   
           NULL MAPPING_LABEL,   
           NULL WORK_ORDER_NO,   
           NULL CARRIER_SIZE,   
           NULL CUSTOMER_MODEL_NAME,   
           NULL EC_NO,   
           NULL PART_NO,   
           '*' MODEL_SUFFIX,   
           NULL MAGAZINE_DATE,   
           'EXCEL UPLOAD' COMMENTS,   
           NULL ACTUAL_DATE,   
           '1' SHIFT_CODE,   
           NULL C_WORKSTAGE_CODE,   
           NULL IS_LAST,   
           NULL  WORKTIME_ZONE,   
           NULL ACTUAL_LINE_CODE,   
           NULL MASK_LOT_NO,   
           NULL SQUEEZE_LOT_NO,   
           NULL SOLDER_LOT_NO,   
           NULL MAPPING_MODEL_NAME,   
           NULL SHIPPING_DEFICIT,   
           NULL RECEIPT_DATE,   
           NULL SHIPPING_DATE,   
           NULL POWER_CHECK_YN,   
           NULL IS_PROGRESS,   
           NULL BCR_CODE,   
           'N' LONGTERM_YN
 FROM IP_PRODUCT_2D_BARCODE_EXCEL ;
 
 IF F_SQL_CHECK()  < 0 THEN 
	ST_MSG.TEXT = "Fail"
	 RETURN 
END IF 

COMMIT ;
ST_MSG.TEXT = "OK"
F_MSGBOX(170)

end event

type cb_1 from commandbutton within w_pln_2d_baarcode_excel_popup
integer x = 951
integer y = 464
integer width = 485
integer height = 140
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Delete"
end type

event clicked;if dw_1.getrow() < 1 then return 
dw_1.deleterow(dw_1.getrow())
end event

type mle_msg from so_multilineedit within w_pln_2d_baarcode_excel_popup
integer x = 2231
integer y = 200
integer width = 2007
integer height = 676
integer taborder = 10
boolean bringtotop = true
string text = ""
boolean hscrollbar = true
boolean vscrollbar = true
boolean autohscroll = true
boolean autovscroll = true
end type

type gb_2 from so_groupbox within w_pln_2d_baarcode_excel_popup
integer x = 64
integer y = 384
integer width = 1824
integer height = 284
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

