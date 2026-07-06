HA$PBExportHeader$w_mcn_mold_repair_request_master.srw
$PBExportComments$Material Receipt Master
forward
global type w_mcn_mold_repair_request_master from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_mcn_mold_repair_request_master
end type
type uo_dateend from uo_ymd_calendar within w_mcn_mold_repair_request_master
end type
type st_3 from so_statictext within w_mcn_mold_repair_request_master
end type
type st_4 from so_statictext within w_mcn_mold_repair_request_master
end type
type st_2 from so_statictext within w_mcn_mold_repair_request_master
end type
type sle_model_name from so_singlelineedit within w_mcn_mold_repair_request_master
end type
type sle_mold_spec from so_singlelineedit within w_mcn_mold_repair_request_master
end type
type st_5 from so_statictext within w_mcn_mold_repair_request_master
end type
type rb_mold_list from so_radiobutton within w_mcn_mold_repair_request_master
end type
type rb_mold_repair_history from so_radiobutton within w_mcn_mold_repair_request_master
end type
type st_7 from so_statictext within w_mcn_mold_repair_request_master
end type
type em_copy from so_editmask within w_mcn_mold_repair_request_master
end type
type cbx_dialog from so_checkbox within w_mcn_mold_repair_request_master
end type
type cb_preview from so_commandbutton within w_mcn_mold_repair_request_master
end type
type cb_print from so_commandbutton within w_mcn_mold_repair_request_master
end type
type cb_cancel from so_commandbutton within w_mcn_mold_repair_request_master
end type
type cb_request from so_commandbutton within w_mcn_mold_repair_request_master
end type
type ddlb_mold_group from uo_basecode within w_mcn_mold_repair_request_master
end type
type st_1 from so_statictext within w_mcn_mold_repair_request_master
end type
type ddlb_mold_code from uo_mold_code within w_mcn_mold_repair_request_master
end type
type sle_1 from so_singlelineedit within w_mcn_mold_repair_request_master
end type
type st_6 from so_statictext within w_mcn_mold_repair_request_master
end type
type sle_barcode from so_singlelineedit within w_mcn_mold_repair_request_master
end type
type st_8 from so_statictext within w_mcn_mold_repair_request_master
end type
type gb_2 from so_groupbox within w_mcn_mold_repair_request_master
end type
type gb_3 from groupbox within w_mcn_mold_repair_request_master
end type
type gb_1 from so_groupbox within w_mcn_mold_repair_request_master
end type
type gb_4 from so_groupbox within w_mcn_mold_repair_request_master
end type
end forward

global type w_mcn_mold_repair_request_master from w_main_root
integer width = 4827
integer height = 3028
string title = "Mold Repair Request Master"
uo_dateset uo_dateset
uo_dateend uo_dateend
st_3 st_3
st_4 st_4
st_2 st_2
sle_model_name sle_model_name
sle_mold_spec sle_mold_spec
st_5 st_5
rb_mold_list rb_mold_list
rb_mold_repair_history rb_mold_repair_history
st_7 st_7
em_copy em_copy
cbx_dialog cbx_dialog
cb_preview cb_preview
cb_print cb_print
cb_cancel cb_cancel
cb_request cb_request
ddlb_mold_group ddlb_mold_group
st_1 st_1
ddlb_mold_code ddlb_mold_code
sle_1 sle_1
st_6 st_6
sle_barcode sle_barcode
st_8 st_8
gb_2 gb_2
gb_3 gb_3
gb_1 gb_1
gb_4 gb_4
end type
global w_mcn_mold_repair_request_master w_mcn_mold_repair_request_master

type variables
string ivs_preview_yn
end variables

on w_mcn_mold_repair_request_master.create
int iCurrent
call super::create
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.st_3=create st_3
this.st_4=create st_4
this.st_2=create st_2
this.sle_model_name=create sle_model_name
this.sle_mold_spec=create sle_mold_spec
this.st_5=create st_5
this.rb_mold_list=create rb_mold_list
this.rb_mold_repair_history=create rb_mold_repair_history
this.st_7=create st_7
this.em_copy=create em_copy
this.cbx_dialog=create cbx_dialog
this.cb_preview=create cb_preview
this.cb_print=create cb_print
this.cb_cancel=create cb_cancel
this.cb_request=create cb_request
this.ddlb_mold_group=create ddlb_mold_group
this.st_1=create st_1
this.ddlb_mold_code=create ddlb_mold_code
this.sle_1=create sle_1
this.st_6=create st_6
this.sle_barcode=create sle_barcode
this.st_8=create st_8
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_1=create gb_1
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateset
this.Control[iCurrent+2]=this.uo_dateend
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.sle_model_name
this.Control[iCurrent+7]=this.sle_mold_spec
this.Control[iCurrent+8]=this.st_5
this.Control[iCurrent+9]=this.rb_mold_list
this.Control[iCurrent+10]=this.rb_mold_repair_history
this.Control[iCurrent+11]=this.st_7
this.Control[iCurrent+12]=this.em_copy
this.Control[iCurrent+13]=this.cbx_dialog
this.Control[iCurrent+14]=this.cb_preview
this.Control[iCurrent+15]=this.cb_print
this.Control[iCurrent+16]=this.cb_cancel
this.Control[iCurrent+17]=this.cb_request
this.Control[iCurrent+18]=this.ddlb_mold_group
this.Control[iCurrent+19]=this.st_1
this.Control[iCurrent+20]=this.ddlb_mold_code
this.Control[iCurrent+21]=this.sle_1
this.Control[iCurrent+22]=this.st_6
this.Control[iCurrent+23]=this.sle_barcode
this.Control[iCurrent+24]=this.st_8
this.Control[iCurrent+25]=this.gb_2
this.Control[iCurrent+26]=this.gb_3
this.Control[iCurrent+27]=this.gb_1
this.Control[iCurrent+28]=this.gb_4
end on

on w_mcn_mold_repair_request_master.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_2)
destroy(this.sle_model_name)
destroy(this.sle_mold_spec)
destroy(this.st_5)
destroy(this.rb_mold_list)
destroy(this.rb_mold_repair_history)
destroy(this.st_7)
destroy(this.em_copy)
destroy(this.cbx_dialog)
destroy(this.cb_preview)
destroy(this.cb_print)
destroy(this.cb_cancel)
destroy(this.cb_request)
destroy(this.ddlb_mold_group)
destroy(this.st_1)
destroy(this.ddlb_mold_code)
destroy(this.sle_1)
destroy(this.st_6)
destroy(this.sle_barcode)
destroy(this.st_8)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_1)
destroy(this.gb_4)
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
Ivs_resize_type                      = 'MASTER_DETAIL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


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

ddlb_mold_code.setfocus()



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
			dw_3.reset()
			
			if rb_mold_list.checked = true then 
				    dw_1.retrieve(ddlb_mold_code.text( )+'%' ,   ddlb_mold_group.getcode( )+'%' ,  gvi_organization_id)
			else
				    dw_3.retrieve(ddlb_mold_code.text( )+'%', uo_dateset.text() , uo_dateend.text() ,  gvi_organization_id)				
			end if 
	
				sle_barcode.setfocus( )
    case 'INSERT'

	        if dw_1.getrow() < 1 then 
				
		    else
				
						
					ROW = DW_2.INSERTROW(0)
					DW_2.SCROLLTOROW(ROW)
					F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')
					dw_2.object.repair_request_date[row] = f_t_sysdate()
					dw_2.object.repair_sequence[row] = f_get_sequence('SEQ_MOLD_REPAIR_SEQUENCE')
					dw_2.object.repair_status[row] = 'R'
					dw_2.object.repair_reason_code[row] = ''			
					dw_2.object.currency[row] = Gvs_currency
					dw_2.object.repair_vendor_code[row] = '*'
					dw_2.object.line_code[row] = '*'					
					dw_2.object.apply_machine_code[row] = '*'										
					
					DW_2.SETITEM( ROW , 'MOLD_CODE' , dw_1.object.mold_code[dw_1.getrow()] )
					DW_2.SETITEM( ROW , 'MOLD_VERSION' , dw_1.object.MOLD_VERSION[dw_1.getrow()] )
					DW_2.SETITEM( ROW , 'MOLD_SET_SERIAL' , dw_1.object.MOLD_SET_SERIAL[dw_1.getrow()] )			  
				end if 
			
				sle_barcode.setfocus( )
	case 'APPEND'		
			
			ROW = DW_2.INSERTROW(DW_2.GETROW())
			DW_2.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')
			dw_2.object.repair_request_date[row] = f_t_sysdate()
			dw_2.object.repair_sequence[row] = f_get_sequence('SEQ_MOLD_REPAIR_SEQUENCE')
			dw_2.object.repair_status[row] = 'R'
			dw_2.object.repair_reason_code[row] = ''						
			dw_2.object.currency[row] = Gvs_currency			
              if dw_1.getrow() < 1 then 
		    else
			  DW_2.SETITEM( ROW , 'MOLD_CODE' , dw_1.object.mold_code[dw_1.getrow()] )
			  DW_2.SETITEM( ROW , 'MOLD_VERSION' , dw_1.object.MOLD_VERSION[dw_1.getrow()] )
			  DW_2.SETITEM( ROW , 'MOLD_SET_SERIAL' , dw_1.object.MOLD_SET_SERIAL[dw_1.getrow()] )				  
			end if
			sle_barcode.setfocus( )
	case 'DELETE'
		
		  	if DW_2.AcceptText() = -1 then
				sle_barcode.setfocus( )
				return
			end if
			
			MSG = F_MSGBOX(1003)  //$$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?
			IF MSG = 1 THEN
				Gvl_row_deleted = DW_2.GetRow()			
				DW_2.DELETEROW(Gvl_row_deleted)		
				DW_2.SetFocus()
				ROW = DW_2.GetRow()
				DW_2.ScrollToRow(row)
				DW_2.SetColumn(1)
			END IF		 
			sle_barcode.setfocus( )			
			
   case 'UPDATE'
		
			IF DW_2.UPDATE() < 0  THEN
			  	 ROLLBACK;
			ELSE
				 COMMIT;
				 F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"			 
			END IF
			sle_barcode.setfocus( )

	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_mcn_mold_repair_request_master
integer y = 524
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_mcn_mold_repair_request_master
integer y = 524
integer width = 4544
integer height = 928
integer taborder = 0
boolean titlebar = true
string dataobject = "d_mcn_mold_repair_request_rpt"
end type

event dw_4::rowfocuschanged;call super::rowfocuschanged;string lvs_filename

if currentrow < 1 then return

lvs_filename = f_download_mold_rtn_filename( this.object.mold_code[currentrow] )

this.object.p_image.filename = lvs_filename
end event

type dw_3 from w_main_root`dw_3 within w_mcn_mold_repair_request_master
integer y = 524
integer width = 4544
integer height = 928
integer taborder = 0
boolean titlebar = true
string title = "Mold Repair History"
string dataobject = "d_mcn_mold_repair_history"
end type

event dw_3::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return

dw_2.retrieve( this.object.mold_code[currentrow] , this.object.repair_request_date[currentrow] , this.object.repair_sequence[currentrow] , gvi_organization_id )
end event

type dw_2 from w_main_root`dw_2 within w_mcn_mold_repair_request_master
integer y = 1452
integer width = 4549
integer height = 812
integer taborder = 0
boolean titlebar = true
string title = "Mold Repair List"
string dataobject = "d_mcn_mold_repair_request_lst"
boolean hscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

event dw_2::rbuttondown;call super::rbuttondown;if dwo.name = 'repair_vendor_code' then 	
	open(w_com_supplier_popup)	
	if  gst_return.gvb_return  = true then
	   this.object.repair_vendor_code[row] = message.stringparm
	   gst_return.gvs_return[1]  = ''		
	end if
elseif dwo.name = 'apply_machine_code' then 	
		OPEN( W_MCN_MASTER_POPUP )
		
		if message.stringparm = '' then 
		else
			this.object.apply_machine_code[row] = message.stringparm
		end if	
	
end if
end event

event dw_2::itemchanged;call super::itemchanged;string lvs_return

if dwo.name = 'repair_vendor_code' then 
	lvs_return = f_get_supplier_name(data , gvi_organization_id)
	if lvs_return = 'ERROR' then 
		return 1 
	end if  
	if lvs_return = 'NOTFOUND' then 
		return 1 
	end if
	
//	this.object.supplier_name[row] = lvs_return 
end if 
end event

event dw_2::uo_mousemove;call super::uo_mousemove;

//if row < 1 then return
//IF   GVS_SHOW_ITEM_IMAGE = 'Y' AND ( UPPER(DWO.TYPE) = 'COLUMN' AND  UPPER(DWO.NAME) = 'MOLD_CODE'  ) THEN
//
//	 IF ISVALID(W_MOLD_REPAIR_IMAGE_FLAT) THEN
//		RETURN
//	ELSE
//			Gst_return.gvl_return[1] = Long(THIS.OBJECT.REPAIR_SEQUENCE[ROW])
//			OPENWITHPARM(W_MOLD_REPAIR_IMAGE_FLAT , STRING(THIS.OBJECT.MOLD_CODE[ROW]))
//	END IF 
//ELSE
//
//	IF isvalid(W_MOLD_REPAIR_IMAGE_FLAT) then
//		close(W_MOLD_REPAIR_IMAGE_FLAT)
//	end if 
//END IF
end event

type dw_1 from w_main_root`dw_1 within w_mcn_mold_repair_request_master
integer y = 524
integer width = 4544
integer height = 928
integer taborder = 0
boolean titlebar = true
string title = "Mold List"
string dataobject = "d_mcn_mold_inventory_4_repair_lst"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_mcn_mold_repair_request_master
integer taborder = 0
end type

type uo_dateset from uo_ymd_calendar within w_mcn_mold_repair_request_master
event destroy ( )
integer x = 2272
integer y = 160
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mcn_mold_repair_request_master
event destroy ( )
integer x = 2688
integer y = 160
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_3 from so_statictext within w_mcn_mold_repair_request_master
integer x = 736
integer y = 80
integer width = 672
integer height = 68
boolean bringtotop = true
string text = "Mold Code"
end type

type st_4 from so_statictext within w_mcn_mold_repair_request_master
integer x = 2277
integer y = 80
integer width = 814
integer height = 68
boolean bringtotop = true
string text = "Repair Request Date"
end type

type st_2 from so_statictext within w_mcn_mold_repair_request_master
integer x = 1422
integer y = 80
integer width = 434
integer height = 68
boolean bringtotop = true
long textcolor = 16711680
string text = "Mold Name"
end type

type sle_model_name from so_singlelineedit within w_mcn_mold_repair_request_master
integer x = 1422
integer y = 160
integer width = 434
integer height = 84
boolean bringtotop = true
end type

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

dw_1.SETFILTER('')
dw_1.FILTER()

LVS_COLUMN = 'MOLD_NAME'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    dw_1.SETFILTER('')
    dw_1.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+UPPER(this.text)+'%'
END IF

dw_1.SETFILTER( "UPPER("+LVS_COLUMN+")"  +" LIKE '"+LVS_VALUE+"'")
dw_1.FILTER()
F_MSG_MDI_HELP( STRING( dw_1.ROWCOUNT() ) + " Found" )
end event

type sle_mold_spec from so_singlelineedit within w_mcn_mold_repair_request_master
integer x = 1861
integer y = 160
integer width = 411
integer height = 84
boolean bringtotop = true
end type

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

dw_1.SETFILTER('')
dw_1.FILTER()

LVS_COLUMN = 'MOLD_SPEC'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    dw_1.SETFILTER('')
    dw_1.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

dw_1.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
dw_1.FILTER()
F_MSG_MDI_HELP( STRING( dw_1.ROWCOUNT() ) + " Found" )
end event

type st_5 from so_statictext within w_mcn_mold_repair_request_master
integer x = 1856
integer y = 80
integer width = 411
integer height = 68
boolean bringtotop = true
long textcolor = 16711680
string text = "Mold Spec"
end type

type rb_mold_list from so_radiobutton within w_mcn_mold_repair_request_master
integer x = 46
integer y = 76
integer width = 635
boolean bringtotop = true
integer weight = 700
string text = "Mold List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true
selected_data_window = dw_1

cb_request.enabled = true
cb_cancel.enabled = false
end event

type rb_mold_repair_history from so_radiobutton within w_mcn_mold_repair_request_master
integer x = 46
integer y = 172
integer width = 635
boolean bringtotop = true
integer weight = 700
string text = "Mold Repair History"
end type

event clicked;call super::clicked;dw_3.bringtotop = true
selected_data_window = dw_3

cb_request.enabled = false
cb_cancel.enabled = true
end event

type st_7 from so_statictext within w_mcn_mold_repair_request_master
integer x = 1952
integer y = 356
integer width = 311
integer height = 64
boolean bringtotop = true
integer weight = 700
string text = "Print Copy"
end type

type em_copy from so_editmask within w_mcn_mold_repair_request_master
integer x = 1952
integer y = 412
integer width = 311
boolean bringtotop = true
string text = "1"
string mask = "##0"
boolean spin = true
end type

type cbx_dialog from so_checkbox within w_mcn_mold_repair_request_master
integer x = 2290
integer y = 416
integer width = 421
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Show Dialog"
end type

type cb_preview from so_commandbutton within w_mcn_mold_repair_request_master
integer x = 2798
integer y = 364
integer width = 471
integer height = 108
boolean bringtotop = true
string text = "Preview"
end type

event clicked;call super::clicked;if dw_2.getrow( ) < 1 then return 
//===================================
//
//===================================
	
	if  ivs_preview_yn = 'Y' THEN 
		ivs_preview_yn = 'N' 	
		if rb_mold_repair_history.checked = true then 
			dw_3.bringtotop = TRUE
		else
			dw_1.bringtotop = TRUE			
		end if 
	else
			ivs_preview_yn = 'Y' 	
			dw_4.bringtotop = TRUE	
			
			dw_4.retrieve( dw_2.object.mold_code[dw_2.getrow()],  dw_2.object.repair_request_date[dw_2.getrow()] , dw_2.object.repair_sequence[dw_2.getrow()] , gvi_organization_id )
			
			if dw_4.getrow( ) <  1 then 
			else
			
				if dw_4.Describe("DataWindow.Print.Preview") = '!' or dw_4.Describe("DataWindow.Print.Preview") = '?' then
				else
					dw_4.Modify("DataWindow.Print.Preview=yes")
					dw_4.Modify("DataWindow.Print.Preview.Rulers=yes")
				end if		
				
			end if 
	end if

end event

type cb_print from so_commandbutton within w_mcn_mold_repair_request_master
integer x = 3273
integer y = 364
integer width = 471
integer height = 108
boolean bringtotop = true
string text = "Print"
end type

event clicked;call super::clicked;Int		i, lvi_cnt , rows


if dw_4.getrow( ) < 1 then
   cb_preview.triggerevent( clicked!)
else
end if 

if dw_4.getrow( ) < 1 then return

lvi_cnt = Integer(em_copy.text)
If lvi_cnt > 0 Then
		For i = 1 To lvi_cnt
			
			if cbx_dialog.checked = true then 
				dw_4.print(false, True)
			else
				dw_4.print(false, False)						
			end if
		Next
End If

end event

type cb_cancel from so_commandbutton within w_mcn_mold_repair_request_master
integer x = 1504
integer y = 364
integer width = 375
integer height = 108
boolean bringtotop = true
boolean enabled = false
string text = "Cancel"
end type

event clicked;call super::clicked;int i , lvi_count 

if dw_3.rowcount( ) < 1 then return 

lvi_count = dw_3.rowcount( )


do
	i++
	
	if dw_3.object.check_yn[i] = 'Y' then 
		
		dw_3.deleterow(i)
		i = i -1 
		lvi_count = lvi_count - 1
	else
		continue
	end if 
	
	if lvi_count = 0 then 
		exit 
	end if 
	
loop until i = lvi_count 

msg = f_msgbox(1160)
if msg = 1 then 
	if dw_3.update() < 0 then 
		rollback;
	else
		commit ;
	end if 
	
else
end if 
end event

type cb_request from so_commandbutton within w_mcn_mold_repair_request_master
integer x = 1134
integer y = 364
integer width = 375
integer height = 108
boolean bringtotop = true
string text = "Request"
end type

event clicked;call super::clicked;f_insert()
sle_barcode.text = ''
end event

type ddlb_mold_group from uo_basecode within w_mcn_mold_repair_request_master
integer x = 3104
integer y = 160
integer width = 622
boolean bringtotop = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;this.redraw( 'MOLD GROUP')
end event

event selectionchanged;call super::selectionchanged;f_retrieve()
end event

type st_1 from so_statictext within w_mcn_mold_repair_request_master
integer x = 3104
integer y = 80
integer width = 549
integer height = 68
boolean bringtotop = true
string text = "Mold Group"
end type

type ddlb_mold_code from uo_mold_code within w_mcn_mold_repair_request_master
integer x = 741
integer y = 160
integer width = 672
integer height = 760
integer taborder = 20
boolean bringtotop = true
end type

event modified;call super::modified;f_retrieve()
end event

event selectionchanged;call super::selectionchanged;f_retrieve()
end event

type sle_1 from so_singlelineedit within w_mcn_mold_repair_request_master
integer x = 3735
integer y = 160
integer width = 361
integer height = 84
boolean bringtotop = true
end type

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

dw_1.SETFILTER('')
dw_1.FILTER()

LVS_COLUMN = 'REPAIR_TERM'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    dw_1.SETFILTER('')
    dw_1.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

dw_1.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
dw_1.FILTER()
F_MSG_MDI_HELP( STRING( dw_1.ROWCOUNT() ) + " Found" )
end event

type st_6 from so_statictext within w_mcn_mold_repair_request_master
integer x = 3730
integer y = 80
integer width = 361
integer height = 68
boolean bringtotop = true
long textcolor = 16711680
string text = "Repair Term"
end type

type sle_barcode from so_singlelineedit within w_mcn_mold_repair_request_master
integer x = 338
integer y = 376
integer width = 773
integer height = 84
integer taborder = 10
boolean bringtotop = true
textcase textcase = upper!
end type

event modified;call super::modified;dw_1.retrieve(this.text+'%' ,   ddlb_mold_group.getcode( )+'%' ,  gvi_organization_id)

if dw_1.rowcount( ) = 1 then 
	this.text = ''
	f_insert()
	
else
	f_msgbox(117)		
	this.text = ''
	this.setfocus( )
end if 
end event

type st_8 from so_statictext within w_mcn_mold_repair_request_master
integer x = 46
integer y = 388
integer width = 279
integer height = 68
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Barcode"
alignment alignment = right!
end type

type gb_2 from so_groupbox within w_mcn_mold_repair_request_master
integer x = 709
integer width = 3419
integer height = 300
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from groupbox within w_mcn_mold_repair_request_master
integer width = 695
integer height = 300
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Category"
end type

type gb_1 from so_groupbox within w_mcn_mold_repair_request_master
integer x = 18
integer y = 312
integer width = 1888
integer height = 192
end type

type gb_4 from so_groupbox within w_mcn_mold_repair_request_master
integer x = 1920
integer y = 312
integer width = 1911
integer height = 192
end type

