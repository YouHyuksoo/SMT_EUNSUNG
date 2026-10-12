HA$PBExportHeader$w_mcn_machine_repair_request_master.srw
$PBExportComments$Material Receipt Master
forward
global type w_mcn_machine_repair_request_master from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_mcn_machine_repair_request_master
end type
type uo_dateend from uo_ymd_calendar within w_mcn_machine_repair_request_master
end type
type st_3 from so_statictext within w_mcn_machine_repair_request_master
end type
type st_4 from so_statictext within w_mcn_machine_repair_request_master
end type
type st_2 from so_statictext within w_mcn_machine_repair_request_master
end type
type sle_model_name from so_singlelineedit within w_mcn_machine_repair_request_master
end type
type rb_machine_list from so_radiobutton within w_mcn_machine_repair_request_master
end type
type rb_machine_repair_history from so_radiobutton within w_mcn_machine_repair_request_master
end type
type st_7 from so_statictext within w_mcn_machine_repair_request_master
end type
type em_copy from so_editmask within w_mcn_machine_repair_request_master
end type
type cbx_dialog from so_checkbox within w_mcn_machine_repair_request_master
end type
type cb_preview from so_commandbutton within w_mcn_machine_repair_request_master
end type
type cb_print from so_commandbutton within w_mcn_machine_repair_request_master
end type
type ddlb_machine_code from uo_machine_code within w_mcn_machine_repair_request_master
end type
type ddlb_machine_type from uo_basecode within w_mcn_machine_repair_request_master
end type
type st_6 from so_statictext within w_mcn_machine_repair_request_master
end type
type ddlb_line_code from uo_line_code within w_mcn_machine_repair_request_master
end type
type st_1 from so_statictext within w_mcn_machine_repair_request_master
end type
type cb_7 from so_commandbutton within w_mcn_machine_repair_request_master
end type
type cb_9 from so_commandbutton within w_mcn_machine_repair_request_master
end type
type cb_1 from so_commandbutton within w_mcn_machine_repair_request_master
end type
type rb_1 from so_radiobutton within w_mcn_machine_repair_request_master
end type
type rb_2 from so_radiobutton within w_mcn_machine_repair_request_master
end type
type rb_3 from so_radiobutton within w_mcn_machine_repair_request_master
end type
type ddlb_repiar_status from uo_basecode within w_mcn_machine_repair_request_master
end type
type st_5 from so_statictext within w_mcn_machine_repair_request_master
end type
type gb_2 from so_groupbox within w_mcn_machine_repair_request_master
end type
type gb_3 from groupbox within w_mcn_machine_repair_request_master
end type
type gb_4 from so_groupbox within w_mcn_machine_repair_request_master
end type
type gb_1 from groupbox within w_mcn_machine_repair_request_master
end type
end forward

global type w_mcn_machine_repair_request_master from w_main_root
integer width = 5426
integer height = 3028
string title = "Machine Repair History Master"
uo_dateset uo_dateset
uo_dateend uo_dateend
st_3 st_3
st_4 st_4
st_2 st_2
sle_model_name sle_model_name
rb_machine_list rb_machine_list
rb_machine_repair_history rb_machine_repair_history
st_7 st_7
em_copy em_copy
cbx_dialog cbx_dialog
cb_preview cb_preview
cb_print cb_print
ddlb_machine_code ddlb_machine_code
ddlb_machine_type ddlb_machine_type
st_6 st_6
ddlb_line_code ddlb_line_code
st_1 st_1
cb_7 cb_7
cb_9 cb_9
cb_1 cb_1
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
ddlb_repiar_status ddlb_repiar_status
st_5 st_5
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
gb_1 gb_1
end type
global w_mcn_machine_repair_request_master w_mcn_machine_repair_request_master

type variables
string ivs_preview_yn
end variables

on w_mcn_machine_repair_request_master.create
int iCurrent
call super::create
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.st_3=create st_3
this.st_4=create st_4
this.st_2=create st_2
this.sle_model_name=create sle_model_name
this.rb_machine_list=create rb_machine_list
this.rb_machine_repair_history=create rb_machine_repair_history
this.st_7=create st_7
this.em_copy=create em_copy
this.cbx_dialog=create cbx_dialog
this.cb_preview=create cb_preview
this.cb_print=create cb_print
this.ddlb_machine_code=create ddlb_machine_code
this.ddlb_machine_type=create ddlb_machine_type
this.st_6=create st_6
this.ddlb_line_code=create ddlb_line_code
this.st_1=create st_1
this.cb_7=create cb_7
this.cb_9=create cb_9
this.cb_1=create cb_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.ddlb_repiar_status=create ddlb_repiar_status
this.st_5=create st_5
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateset
this.Control[iCurrent+2]=this.uo_dateend
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.sle_model_name
this.Control[iCurrent+7]=this.rb_machine_list
this.Control[iCurrent+8]=this.rb_machine_repair_history
this.Control[iCurrent+9]=this.st_7
this.Control[iCurrent+10]=this.em_copy
this.Control[iCurrent+11]=this.cbx_dialog
this.Control[iCurrent+12]=this.cb_preview
this.Control[iCurrent+13]=this.cb_print
this.Control[iCurrent+14]=this.ddlb_machine_code
this.Control[iCurrent+15]=this.ddlb_machine_type
this.Control[iCurrent+16]=this.st_6
this.Control[iCurrent+17]=this.ddlb_line_code
this.Control[iCurrent+18]=this.st_1
this.Control[iCurrent+19]=this.cb_7
this.Control[iCurrent+20]=this.cb_9
this.Control[iCurrent+21]=this.cb_1
this.Control[iCurrent+22]=this.rb_1
this.Control[iCurrent+23]=this.rb_2
this.Control[iCurrent+24]=this.rb_3
this.Control[iCurrent+25]=this.ddlb_repiar_status
this.Control[iCurrent+26]=this.st_5
this.Control[iCurrent+27]=this.gb_2
this.Control[iCurrent+28]=this.gb_3
this.Control[iCurrent+29]=this.gb_4
this.Control[iCurrent+30]=this.gb_1
end on

on w_mcn_machine_repair_request_master.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_2)
destroy(this.sle_model_name)
destroy(this.rb_machine_list)
destroy(this.rb_machine_repair_history)
destroy(this.st_7)
destroy(this.em_copy)
destroy(this.cbx_dialog)
destroy(this.cb_preview)
destroy(this.cb_print)
destroy(this.ddlb_machine_code)
destroy(this.ddlb_machine_type)
destroy(this.st_6)
destroy(this.ddlb_line_code)
destroy(this.st_1)
destroy(this.cb_7)
destroy(this.cb_9)
destroy(this.cb_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.ddlb_repiar_status)
destroy(this.st_5)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
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
			
			if rb_machine_list.checked = true then 
				    dw_1.retrieve(ddlb_machine_code.text( )+'%' ,   ddlb_machine_type.getcode( )+'%' ,  ddlb_line_code.getcode( )+'%' ,  gvi_organization_id)
			else
				    dw_3.retrieve(ddlb_machine_code.text( )+'%',  ddlb_machine_type.getcode( )+'%' ,  uo_dateset.text() , uo_dateend.text() ,  ddlb_line_code.getcode( )+'%' ,  ddlb_repiar_status.getcode( )+'%'  , gvi_organization_id)				
			end if 
	
	
    case 'INSERT'

	        if dw_1.getrow() < 1 then 
				
		    else
				
						
					ROW = DW_2.INSERTROW(0)
					DW_2.SCROLLTOROW(ROW)
					F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')
					dw_2.object.repair_request_date[row] = f_t_sysdate()
					dw_2.object.repair_sequence[row] = f_get_sequence('SEQ_MACHINE_REPAIR_SEQUENCE')
					dw_2.object.repair_status[row] = 'C'  //'R'
					dw_2.object.repair_reason_code[row] = ''			
					dw_2.object.currency[row] = Gvs_currency
					
					DW_2.SETITEM( ROW , 'MACHINE_CODE' , dw_1.object.machine_code[dw_1.getrow()] )
				end if 
			
			
	case 'APPEND'		
			
			ROW = DW_2.INSERTROW(DW_2.GETROW())
			DW_2.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')
			dw_2.object.repair_request_date[row] = f_t_sysdate()
			dw_2.object.repair_sequence[row] = f_get_sequence('SEQ_MACHINE_REPAIR_SEQUENCE')
			dw_2.object.repair_status[row] = 'C' //'R'
			dw_2.object.repair_reason_code[row] = ''						
			dw_2.object.currency[row] = Gvs_currency			
              if dw_1.getrow() < 1 then 
		    else
			  DW_2.SETITEM( ROW , 'MACHINE_CODE' , dw_1.object.machine_code[dw_1.getrow()] )
			end if
			
	case 'DELETE'
		
		  	if DW_2.AcceptText() = -1 then
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
			
   case 'UPDATE'
		
			IF DW_2.UPDATE() < 0  THEN
			  	 ROLLBACK;
				 RETURN
			ELSE
				 COMMIT;
				 F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"			 
			END IF

	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_mcn_machine_repair_request_master
integer y = 524
end type

type dw_4 from w_main_root`dw_4 within w_mcn_machine_repair_request_master
integer y = 516
integer width = 4544
integer height = 928
boolean titlebar = true
string dataobject = "d_mcn_machine_repair_request_rpt"
end type

event dw_4::rowfocuschanged;call super::rowfocuschanged;string lvs_filename , lvs_filename1 , lvs_filename2 , lvs_filename3

if currentrow < 1 then return

lvs_filename = f_download_machine_rtn_filename( this.object.machine_code[currentrow] )

this.object.p_image.filename = lvs_filename


lvs_filename1 = f_download_machine_repair_rtn_multi_filename(this.object.machine_code[currentrow]  , this.object.repair_sequence[currentrow]  , 1 )
lvs_filename2 = f_download_machine_repair_rtn_multi_filename(this.object.machine_code[currentrow]  , this.object.repair_sequence[currentrow]  ,2  )
lvs_filename3 = f_download_machine_repair_rtn_multi_filename(this.object.machine_code[currentrow]  , this.object.repair_sequence[currentrow]  , 3 )

this.object.p_repair_image1.filename = lvs_filename1
this.object.p_repair_image2.filename = lvs_filename2
this.object.p_repair_image3.filename = lvs_filename3
end event

type dw_3 from w_main_root`dw_3 within w_mcn_machine_repair_request_master
integer y = 516
integer width = 4544
integer height = 928
boolean titlebar = true
string title = "Machine Repair History"
string dataobject = "d_mcn_machine_repair_4_request_history"
end type

event dw_3::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return

dw_2.retrieve( this.object.machine_code[currentrow] , this.object.repair_request_date[currentrow] , this.object.repair_sequence[currentrow] , gvi_organization_id )
end event

type dw_2 from w_main_root`dw_2 within w_mcn_machine_repair_request_master
integer y = 1456
integer width = 4549
integer height = 812
boolean titlebar = true
string title = "Machine Repair List"
string dataobject = "d_mcn_machine_repair_request_lst"
boolean hscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

event dw_2::rbuttondown;call super::rbuttondown;//if dwo.name = 'repair_vendor_code' then 	
//	open(w_com_supplier_popup)	
//	if  gst_return.gvb_return  = true then
//	   this.object.repair_vendor_code[row] = message.stringparm
//	   gst_return.gvs_return[1]  = ''		
//	end if
//elseif dwo.name = 'apply_machine_code' then 	
//		OPEN( W_MCN_MASTER_POPUP )
//		
//		if message.stringparm = '' then 
//		else
//			this.object.apply_machine_code[row] = message.stringparm
//		end if	
//	
//end if
end event

event dw_2::itemchanged;call super::itemchanged;//string lvs_return
//
//if dwo.name = 'repair_vendor_code' then 
//	
//	lvs_return = f_get_supplier_name(data , gvi_organization_id)
//	
//	if lvs_return = 'ERROR' then 
//		return 1 
//	end if  
//	if lvs_return = 'NOTFOUND' then 
//		return 1 
//	end if
//	
////	this.object.supplier_name[row] = lvs_return 
//end if 
end event

event dw_2::uo_mousemove;call super::uo_mousemove;

//if row < 1 then return
//IF   GVS_SHOW_ITEM_IMAGE = 'Y' AND ( UPPER(DWO.TYPE) = 'COLUMN' AND  UPPER(DWO.NAME) = 'MACHINE_CODE'  ) THEN
//
//	 IF ISVALID(W_MACHINE_REPAIR_IMAGE_FLAT) THEN
//		RETURN
//	ELSE
//			Gst_return.gvl_return[1] = Long(THIS.OBJECT.REPAIR_SEQUENCE[ROW])
//			OPENWITHPARM(W_MACHINE_REPAIR_IMAGE_FLAT , STRING(THIS.OBJECT.MACHINE_CODE[ROW]))
//	END IF 
//ELSE
//
//	IF isvalid(W_MACHINE_REPAIR_IMAGE_FLAT) then
//		close(W_MACHINE_REPAIR_IMAGE_FLAT)
//	end if 
//END IF

end event

event dw_2::doubleclicked;call super::doubleclicked;string lvs_column_name

   if this.Getcolumnname() = '' or isnull(this.Getcolumnname()) then 
		return
	end if
	
	message.stringparm=''
	
	lvs_column_name = lower(this.Getcolumnname())
	
	openwithparm(w_edit_window , this.gettext())

	if message.stringparm = '' then 
	else
  	 this.setitem( this.getrow() , lvs_column_name , message.stringparm)
	end if	

end event

type dw_1 from w_main_root`dw_1 within w_mcn_machine_repair_request_master
integer y = 516
integer width = 4544
integer height = 928
boolean titlebar = true
string title = "Machine List"
string dataobject = "d_mcn_machine_4_repair_request_lst"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_mcn_machine_repair_request_master
end type

type uo_dateset from uo_ymd_calendar within w_mcn_machine_repair_request_master
event destroy ( )
integer x = 2798
integer y = 164
integer taborder = 30
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mcn_machine_repair_request_master
event destroy ( )
integer x = 3214
integer y = 164
integer taborder = 40
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_3 from so_statictext within w_mcn_machine_repair_request_master
integer x = 1431
integer y = 80
integer width = 896
integer height = 68
boolean bringtotop = true
string text = "Machine Code"
end type

type st_4 from so_statictext within w_mcn_machine_repair_request_master
integer x = 2802
integer y = 84
integer width = 814
integer height = 68
boolean bringtotop = true
string text = "Repair Request Date"
end type

type st_2 from so_statictext within w_mcn_machine_repair_request_master
integer x = 2350
integer y = 84
integer width = 434
integer height = 68
boolean bringtotop = true
long textcolor = 16711680
string text = "Machine Name"
end type

type sle_model_name from so_singlelineedit within w_mcn_machine_repair_request_master
integer x = 2350
integer y = 164
integer width = 434
integer height = 84
integer taborder = 40
boolean bringtotop = true
end type

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

dw_1.SETFILTER('')
dw_1.FILTER()

LVS_COLUMN = 'MACHINE_NAME'
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

type rb_machine_list from so_radiobutton within w_mcn_machine_repair_request_master
integer x = 46
integer y = 76
integer width = 727
boolean bringtotop = true
integer weight = 700
string text = "Machine List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true
selected_data_window = dw_1


end event

type rb_machine_repair_history from so_radiobutton within w_mcn_machine_repair_request_master
integer x = 46
integer y = 172
integer width = 727
boolean bringtotop = true
integer weight = 700
string text = "Machine Repair History"
end type

event clicked;call super::clicked;dw_3.bringtotop = true
selected_data_window = dw_3

end event

type st_7 from so_statictext within w_mcn_machine_repair_request_master
integer x = 41
integer y = 356
integer width = 311
integer height = 64
boolean bringtotop = true
integer weight = 700
string text = "Print Copy"
end type

type em_copy from so_editmask within w_mcn_machine_repair_request_master
integer x = 41
integer y = 412
integer width = 311
integer taborder = 70
boolean bringtotop = true
string text = "1"
string mask = "##0"
boolean spin = true
end type

type cbx_dialog from so_checkbox within w_mcn_machine_repair_request_master
integer x = 379
integer y = 416
integer width = 421
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Show Dialog"
end type

type cb_preview from so_commandbutton within w_mcn_machine_repair_request_master
integer x = 891
integer y = 384
integer width = 471
integer height = 108
integer taborder = 100
boolean bringtotop = true
string text = "Preview"
end type

event clicked;call super::clicked;if dw_2.getrow( ) < 1 then return 
//===================================
//
//===================================
	
	if  ivs_preview_yn = 'Y' THEN 
		ivs_preview_yn = 'N' 	
		if rb_machine_repair_history.checked = true then 
			dw_3.bringtotop = TRUE
		else
			dw_1.bringtotop = TRUE			
		end if 
	else
			ivs_preview_yn = 'Y' 	
			dw_4.bringtotop = TRUE	
			
			dw_4.retrieve( dw_2.object.machine_code[dw_2.getrow()],  dw_2.object.repair_request_date[dw_2.getrow()] , dw_2.object.repair_sequence[dw_2.getrow()] , gvi_organization_id )
			
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

type cb_print from so_commandbutton within w_mcn_machine_repair_request_master
integer x = 1362
integer y = 380
integer width = 471
integer height = 108
integer taborder = 110
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

type ddlb_machine_code from uo_machine_code within w_mcn_machine_repair_request_master
integer x = 1435
integer y = 160
integer width = 896
integer height = 2120
integer taborder = 70
boolean bringtotop = true
end type

type ddlb_machine_type from uo_basecode within w_mcn_machine_repair_request_master
integer x = 3643
integer y = 164
integer width = 814
integer height = 2120
integer taborder = 60
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'MACHINE TYPE')
end event

type st_6 from so_statictext within w_mcn_machine_repair_request_master
integer x = 3648
integer y = 88
integer width = 814
integer height = 68
boolean bringtotop = true
long textcolor = 0
string text = "Machine Type"
end type

type ddlb_line_code from uo_line_code within w_mcn_machine_repair_request_master
integer x = 850
integer y = 156
integer width = 567
integer height = 1980
integer taborder = 50
boolean bringtotop = true
end type

type st_1 from so_statictext within w_mcn_machine_repair_request_master
integer x = 850
integer y = 96
integer width = 567
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Line Code"
end type

type cb_7 from so_commandbutton within w_mcn_machine_repair_request_master
integer x = 2871
integer y = 372
integer height = 108
integer taborder = 30
boolean bringtotop = true
string text = "Image Upload"
end type

event clicked;call super::clicked;if f_object_role_check() = false then  return

int    li_filenum , loops, i , lvi_count
long   flen, bytes_read , bytes_read_sum , new_pos
blob   lib_file , b
double lvdb_version , lvdb_repair_sequence 
string is_filename, is_fullname , lvs_drawing_no , lvs_machine_code
		
		if  dw_2.getrow() < 1 then 
			 return
		end if
			
			lvs_machine_code  = dw_2.getitemstring( dw_2.getrow() , "machine_code" )
			lvdb_repair_sequence  = dw_2.getitemNumber( dw_2.getrow() , "repair_sequence" )	
	
		if lvs_machine_code ='' or isnull(lvs_machine_code) then 
			return
		end if		
		
		if getfileopenname("select file", is_fullname, is_filename, "jpg", &
			 + "jpg files (*.jpg),*.jpg," &	
			 + "gif files (*.gif),*.gif," &
			 + "bmp files (*.bmp),*.bmp," &			 
			 + "all files (*.*), *.*") < 1 then return
		
		flen = filelength(is_fullname)
		
		if flen < 0 then 
			rollback;			
			f_msgbox1(9020 ,is_fullname )
			return 
		end if
		
		li_filenum = fileopen(is_fullname,  streammode!, read!, lockread!)
		
		if li_filenum <> -1 then
				
					setpointer(hourglass!)
					if flen > 32765 then
					
							  if mod(flen, 32765) = 0 then
									loops = flen/32765
							  else
									loops = (flen/32765) + 1
							  end if
					else
							  loops = 1
					end if
					
					new_pos = 1
					for i = 1 to loops
							  bytes_read = fileread(li_filenum, b)
							  bytes_read_sum = bytes_read_sum + bytes_read
							  lib_file = lib_file + b
							  f_msg_mdi_help( string(bytes_read_sum)+"/"+string(flen)+" bytes read" )
					next
					
					fileclose(li_filenum)
					
					     select count(*) into :lvi_count
						  from imcn_machine_repair_image
						where machine_code    = :lvs_machine_code
						    and repair_sequence = :lvdb_repair_sequence
						    and organization_id = :gvi_organization_id ;
						  
					if f_sql_check() < 0 then 
						return
					end if				  
					
					if lvi_count = 0 then 
						
						insert into imcn_machine_repair_image ( machine_code , repair_sequence , file_name ,  organization_id ) 
						   values ( :lvs_machine_code , :lvdb_repair_sequence , :is_filename , :gvi_organization_id ) ;
								  
						if f_sql_check() < 0 then 
							return
						end if				  
										
					end if
					
					if rb_1.checked = true then 
					
							updateblob imcn_machine_repair_image set repair_image = :lib_file 
							where machine_code       = :lvs_machine_code
							  and repair_sequence = :lvdb_repair_sequence
							  and organization_id = :gvi_organization_id ;

					elseif rb_2.checked = true then 
							updateblob imcn_machine_repair_image set repair_image2 = :lib_file 
							where machine_code       = :lvs_machine_code
							  and repair_sequence = :lvdb_repair_sequence
							  and organization_id = :gvi_organization_id ;
					elseif rb_3.checked = true then 
							updateblob imcn_machine_repair_image set repair_image3 = :lib_file 
							where machine_code       = :lvs_machine_code
							  and repair_sequence = :lvdb_repair_sequence
							  and organization_id = :gvi_organization_id ;					end if 
				  if sqlca.sqlnrows > 0 then

				  else
					  rollback ;
					  messagebox("error" , is_filename+" file upload to database failed" )
					  return
				  end if;
			  
				  commit ;
			         f_msgbox(9022)

		end if
changedirectory(gvs_default_directory)

end event

type cb_9 from so_commandbutton within w_mcn_machine_repair_request_master
integer x = 3945
integer y = 372
integer height = 108
integer taborder = 70
boolean bringtotop = true
string text = "Image Delete"
end type

event clicked;call super::clicked;if f_object_role_check() = false then  return
string lvs_machine_code
double lvdb_repair_sequence
int lvi_count
				if  dw_2.getrow() < 1 then 
					 return
				end if
			
				lvs_machine_code  = dw_2.getitemstring( dw_2.getrow() , "machine_code" )
				lvdb_repair_sequence  = dw_2.getitemNumber( dw_2.getrow() , "repair_sequence" )	
				
				if lvs_machine_code ='' or isnull(lvs_machine_code) then 
					return
				end if		

							  
					delete  imcn_machine_repair_image 
					where machine_code  = :lvs_machine_code
					  and repair_sequence = :lvdb_repair_sequence
					  and organization_id   = :gvi_organization_id ;

					if f_sql_check() < 0 then 
						return 
					else
						commit ;
						f_msgbox(9022)
					end if 
changedirectory(gvs_default_directory)

end event

type cb_1 from so_commandbutton within w_mcn_machine_repair_request_master
integer x = 3406
integer y = 372
integer height = 108
integer taborder = 40
boolean bringtotop = true
string text = "Image Show"
end type

event clicked;call super::clicked;Long Lvl_return , lvi_index
String  lvs_file_name
//=====================================================
//
//=====================================================
if rb_1.checked = true then 
	lvi_index = 1 
elseif rb_2.checked = true then 
	lvi_index = 2 
elseif rb_3.checked = true then 
	lvi_index = 3 		
end if 
//=====================================================
//
//=====================================================
		if dw_2.getrow() < 1 then return 
		
		lvs_file_name = f_download_machine_repair_rtn_multi_filename ( string(dw_2.object.machine_code[dw_2.getrow()] ), long(dw_2.object.repair_sequence[dw_2.getrow()])  ,  lvi_index  )
		
			
			IF lvs_file_name = '' OR ISNULL(lvs_file_name) THEN 
				RETURN
			else
			
				f_shell_execute_by_extention ( lvs_file_name   , '' ,Gvs_default_directory+'\Temp'  )

			end if
		
		Changedirectory(Gvs_default_directory)

end event

type rb_1 from so_radiobutton within w_mcn_machine_repair_request_master
integer x = 2011
integer y = 388
integer width = 229
boolean bringtotop = true
string text = "1"
boolean checked = true
end type

type rb_2 from so_radiobutton within w_mcn_machine_repair_request_master
integer x = 2304
integer y = 388
integer width = 229
boolean bringtotop = true
string text = "2"
end type

type rb_3 from so_radiobutton within w_mcn_machine_repair_request_master
integer x = 2610
integer y = 388
integer width = 229
boolean bringtotop = true
string text = "3"
end type

type ddlb_repiar_status from uo_basecode within w_mcn_machine_repair_request_master
integer x = 4462
integer y = 164
integer width = 571
integer taborder = 30
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'REPAIR STATUS')
end event

type st_5 from so_statictext within w_mcn_machine_repair_request_master
integer x = 4462
integer y = 88
integer width = 571
integer height = 68
boolean bringtotop = true
long textcolor = 0
string text = "Repair Status"
end type

type gb_2 from so_groupbox within w_mcn_machine_repair_request_master
integer x = 827
integer width = 4261
integer height = 300
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from groupbox within w_mcn_machine_repair_request_master
integer width = 814
integer height = 300
integer taborder = 20
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

type gb_4 from so_groupbox within w_mcn_machine_repair_request_master
integer x = 23
integer y = 320
integer width = 1911
integer height = 192
integer taborder = 30
end type

type gb_1 from groupbox within w_mcn_machine_repair_request_master
integer x = 1934
integer y = 320
integer width = 2569
integer height = 192
integer taborder = 120
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Repair Image"
end type

