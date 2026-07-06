HA$PBExportHeader$w_qc_repair_receipt_excel_form_popup.srw
$PBExportComments$$$HEX8$$01c6c5c585c7e0acd1c540c191c5ddc2$$ENDHEX$$
forward
global type w_qc_repair_receipt_excel_form_popup from w_popup_root
end type
type cb_delete from so_commandbutton within w_qc_repair_receipt_excel_form_popup
end type
type cb_insert from so_commandbutton within w_qc_repair_receipt_excel_form_popup
end type
type cb_2 from so_commandbutton within w_qc_repair_receipt_excel_form_popup
end type
type pb_1 from so_commandbutton within w_qc_repair_receipt_excel_form_popup
end type
type gb_3 from so_groupbox within w_qc_repair_receipt_excel_form_popup
end type
end forward

global type w_qc_repair_receipt_excel_form_popup from w_popup_root
integer width = 3141
integer height = 1956
string title = "Repair List Insert Form Popup"
cb_delete cb_delete
cb_insert cb_insert
cb_2 cb_2
pb_1 pb_1
gb_3 gb_3
end type
global w_qc_repair_receipt_excel_form_popup w_qc_repair_receipt_excel_form_popup

type variables
datawindow idw_datawindow
end variables

on w_qc_repair_receipt_excel_form_popup.create
int iCurrent
call super::create
this.cb_delete=create cb_delete
this.cb_insert=create cb_insert
this.cb_2=create cb_2
this.pb_1=create pb_1
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_delete
this.Control[iCurrent+2]=this.cb_insert
this.Control[iCurrent+3]=this.cb_2
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.gb_3
end on

on w_qc_repair_receipt_excel_form_popup.destroy
call super::destroy
destroy(this.cb_delete)
destroy(this.cb_insert)
destroy(this.cb_2)
destroy(this.pb_1)
destroy(this.gb_3)
end on

event open;call super::open;dw_1.settransobject(sqlca)

end event

event key;call super::key;if key = keyf2! then 
   cb_insert.triggerevent(clicked!)
elseif key = keyf3! then 
   cb_delete.triggerevent(clicked!)   
end if
end event

event activate;call super::activate;ivs_resize_type = 'DEFAULT'
end event

event ue_post_open;call super::ue_post_open;dw_2.SETTRANSOBJECT(SQLCA)


end event

type p_title from w_popup_root`p_title within w_qc_repair_receipt_excel_form_popup
integer width = 3118
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
end type

type cb_sort from w_popup_root`cb_sort within w_qc_repair_receipt_excel_form_popup
integer x = 1024
integer y = 0
integer taborder = 40
integer weight = 400
end type

type cb_close from w_popup_root`cb_close within w_qc_repair_receipt_excel_form_popup
boolean visible = true
integer x = 2729
integer y = 252
integer width = 352
integer height = 128
integer taborder = 0
integer weight = 400
end type

event cb_close::clicked;close(parent)
end event

type st_msg from w_popup_root`st_msg within w_qc_repair_receipt_excel_form_popup
boolean visible = true
integer y = 420
integer width = 3118
integer weight = 400
end type

type dw_1 from w_popup_root`dw_1 within w_qc_repair_receipt_excel_form_popup
boolean visible = true
integer y = 516
integer width = 3118
integer height = 1324
integer taborder = 20
boolean titlebar = true
string title = "Repair Receipt"
string dataobject = "d_qc_repair_receipt_excel_popup_lst"
boolean controlmenu = true
end type

type dw_2 from w_popup_root`dw_2 within w_qc_repair_receipt_excel_form_popup
boolean visible = true
integer y = 516
integer width = 2217
integer height = 1324
integer taborder = 0
boolean controlmenu = true
end type

event dw_2::constructor;//override
end event

type dw_3 from w_popup_root`dw_3 within w_qc_repair_receipt_excel_form_popup
integer y = 856
integer taborder = 50
end type

type cb_delete from so_commandbutton within w_qc_repair_receipt_excel_form_popup
integer x = 741
integer y = 256
integer width = 352
integer height = 128
boolean bringtotop = true
integer weight = 400
string text = "Delete [F3]"
end type

event clicked;call super::clicked;if dw_1.getrow() < 1 then return 
dw_1.deleterow( dw_1.getrow())
end event

type cb_insert from so_commandbutton within w_qc_repair_receipt_excel_form_popup
integer x = 384
integer y = 256
integer width = 352
integer height = 128
integer taborder = 10
boolean bringtotop = true
integer weight = 400
string text = "Insert [F2]"
end type

event clicked;call super::clicked;string lvs_serial_no , LVS_SHIFT_CODE , LVS_WORKSTAGE_CODE , LVS_BAD_REASON_CODE
DATETIME LVDT_QC_DATE
long i , ll_row , lvi_count

if dw_1.getrow() < 1 then 
	return 
end if 

do
	i++
	
	if dw_1.object.check_yn[i] = 'X' then 
		continue
	end if 
	
	lvs_serial_no = dw_1.object.serial_no[i]
	LVS_SHIFT_CODE =  dw_1.object.shift_code[i]
	LVS_WORKSTAGE_CODE = dw_1.object.workstage_code[i]
	LVS_BAD_REASON_CODE =  dw_1.object.bad_reason_code[i]
	LVDT_QC_DATE =  dw_1.object.qc_date[i]
	
   //$$HEX16$$18c2acb9e4c2200085c7e0ac200000b330ae200078c72000bdacb0c620000900$$ENDHEX$$
   SELECT count(*) INTO :lvi_count
	 FROM IP_PRODUCT_WORK_QC
    WHERE SERIAL_NO = :LVS_SERIAL_NO
	    AND RECEIPT_DEFICIT = '1' ;
	 
	if f_sql_check() < 0 then 
		return 
	end if 	
	
	// $$HEX19$$18c2acb9e4c2d0c5200074c7f8bb200085c7e0ac18b4b4c5200088c744c72000bdacb0c62000$$ENDHEX$$
	IF lvi_count > 0 THEN 
	    dw_1.object.check_yn[i] = 'E'
		CONTINUE
	ELSE

	END IF 
	
	  INSERT INTO IP_PRODUCT_WORK_QC  
         ( RUN_NO,   
           QC_SEQUENCE,   
           MODEL_NAME,   
           RUN_DATE,   
           LINE_CODE,   
           WORKSTAGE_CODE,   
           SERIAL_NO,   
           QC_RESULT,   
           BAD_REASON_CODE,   
           BAD_QTY,   
           CHARGER,   
           REPAIR_BY,   
           QC_DATE,   
           REPAIR_DATE,   
           QC_INSPECT_HANDLING,   
           COMMENTS,   
           ORGANIZATION_ID,   
           ENTER_DATE,   
           ENTER_BY,   
           LAST_MODIFY_DATE,   
           LAST_MODIFY_BY,   
           SHIFT_CODE,   
           CARRIER_BARCODE,   
           DEFECT_QTY,   
           COMBINATION_YN,   
           MACHINE_CODE,   
           RECEIPT_DEFICIT,   
           NEW_RUN_NO )  

	SELECT  RUN_NO,   
           SEQ_QC_REPAIR_SEQUENCE.NEXTVAL,   
           MODEL_NAME,   
           RUN_DATE,   
           LINE_CODE,   
           :LVS_WORKSTAGE_CODE,   
           SERIAL_NO,   
           'N' QC_RESULT,   
           :LVS_BAD_REASON_CODE,   
           1 BAD_QTY,   
           '' CHARGER,   
           '' REPAIR_BY,   
           :LVDT_QC_DATE,   
           NULL REPAIR_DATE,   
           'W' QC_INSPECT_HANDLING,   
           'EXCEL' COMMENTS,   
           :GVI_ORGANIZATION_ID,   
           SYSDATE,
           :GVS_USER_ID,   
           SYSDATE,
           :GVS_USER_ID,   
           :LVS_SHIFT_CODE,   
           '*' CARRIER_BARCODE,   
           1 DEFECT_QTY,   
           'N' COMBINATION_YN,   
           '*' MACHINE_CODE,   
           '1' RECEIPT_DEFICIT,   
           '' NEW_RUN_NO
 FROM IP_PRODUCT_PCB_SCAN_MASTER
WHERE SERIAL_NO = :LVS_SERIAL_NO  ;
	
if f_sql_check() < 0 then 
	return 
end if 

dw_1.object.check_yn[i] = 'Y'

st_msg.text = string(i)+"/"+string(dw_1.rowcount())
loop until i = dw_1.rowcount( )

commit ;
end event

type cb_2 from so_commandbutton within w_qc_repair_receipt_excel_form_popup
integer x = 27
integer y = 256
integer width = 352
integer height = 128
integer taborder = 50
boolean bringtotop = true
integer weight = 400
string text = "Excel Paste"
end type

event clicked;call super::clicked;string lvs_serial_no , lvs_run_no
Long i
dw_1.reset()
dw_1.importclipboard( )
//=========================================
//
//=========================================

if dw_1.rowcount( ) < 1 then return 

open(w_progress_popup)
w_progress_popup.f_set_range( 1,  dw_1.rowcount( ) )
w_progress_popup.f_setstep(1)
										
do
	i++

	lvs_serial_no = dw_1.object.serial_no[i]
//=======================================	
	
	select run_no into :lvs_run_no
	 from ip_product_pcb_barcode
	where serial_no = :lvs_serial_no
	     and organization_id = :gvi_organization_id ;
		  
		  if f_sql_check() < 0 then 
			close(w_progress_popup)
			return
		  end if 
		  
	if lvs_run_no = '' then 
		dw_1.object.check_yn[i] = 'X'
		f_msgbox1(815 , string(i)+"  "+lvs_serial_no )
		continue
	else
		dw_1.object.run_no[i] = lvs_run_no
	end if 

	w_progress_popup.f_stepit()	
loop until i = dw_1.rowcount( )
close(w_progress_popup)

end event

type pb_1 from so_commandbutton within w_qc_repair_receipt_excel_form_popup
integer x = 1097
integer y = 256
integer width = 352
integer height = 128
integer taborder = 40
boolean bringtotop = true
integer weight = 400
string text = "Save Form"
end type

event clicked;call super::clicked;	
string     docname, named 
Long iret

SETPOINTER(HOURGLASS!)		
iret = GetFileSaveName("Select Excel File ("+dw_1.classname()+")" , docname, named, "xls", "Excel Files (*.xls),*.xls")		

IF iret =1 THEN 
	
	     dw_1.insertrow( 0)
		uf_save_dw_as_excel( dw_1  , docname )
ELSE
	RETURN
END IF
		
end event

type gb_3 from so_groupbox within w_qc_repair_receipt_excel_form_popup
integer y = 176
integer width = 3118
integer height = 240
long textcolor = 16711680
string text = "Process"
end type

