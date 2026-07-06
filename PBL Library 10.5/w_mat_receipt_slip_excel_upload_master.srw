HA$PBExportHeader$w_mat_receipt_slip_excel_upload_master.srw
$PBExportComments$Material Mass Issue Return Master
forward
global type w_mat_receipt_slip_excel_upload_master from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_mat_receipt_slip_excel_upload_master
end type
type uo_dateend from uo_ymd_calendar within w_mat_receipt_slip_excel_upload_master
end type
type ddlb_item_code from uo_item_code within w_mat_receipt_slip_excel_upload_master
end type
type st_3 from so_statictext within w_mat_receipt_slip_excel_upload_master
end type
type st_4 from so_statictext within w_mat_receipt_slip_excel_upload_master
end type
type sle_slip_no from so_singlelineedit within w_mat_receipt_slip_excel_upload_master
end type
type st_9 from so_statictext within w_mat_receipt_slip_excel_upload_master
end type
type pb_4 from so_commandbutton within w_mat_receipt_slip_excel_upload_master
end type
type sle_1 from so_singlelineedit within w_mat_receipt_slip_excel_upload_master
end type
type st_18 from so_statictext within w_mat_receipt_slip_excel_upload_master
end type
type sle_slip_group_no_cond from so_singlelineedit within w_mat_receipt_slip_excel_upload_master
end type
type sle_slip_group_no from so_singlelineedit within w_mat_receipt_slip_excel_upload_master
end type
type st_1 from so_statictext within w_mat_receipt_slip_excel_upload_master
end type
type st_2 from so_statictext within w_mat_receipt_slip_excel_upload_master
end type
type rb_excel_upload from so_radiobutton within w_mat_receipt_slip_excel_upload_master
end type
type rb_departure from so_radiobutton within w_mat_receipt_slip_excel_upload_master
end type
type gb_2 from so_groupbox within w_mat_receipt_slip_excel_upload_master
end type
type gb_3 from so_groupbox within w_mat_receipt_slip_excel_upload_master
end type
type gb_1 from so_groupbox within w_mat_receipt_slip_excel_upload_master
end type
end forward

global type w_mat_receipt_slip_excel_upload_master from w_main_root
integer width = 6359
integer height = 3712
string title = "Material Slip Excel Upload Master"
uo_dateset uo_dateset
uo_dateend uo_dateend
ddlb_item_code ddlb_item_code
st_3 st_3
st_4 st_4
sle_slip_no sle_slip_no
st_9 st_9
pb_4 pb_4
sle_1 sle_1
st_18 st_18
sle_slip_group_no_cond sle_slip_group_no_cond
sle_slip_group_no sle_slip_group_no
st_1 st_1
st_2 st_2
rb_excel_upload rb_excel_upload
rb_departure rb_departure
gb_2 gb_2
gb_3 gb_3
gb_1 gb_1
end type
global w_mat_receipt_slip_excel_upload_master w_mat_receipt_slip_excel_upload_master

type variables

end variables

on w_mat_receipt_slip_excel_upload_master.create
int iCurrent
call super::create
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.ddlb_item_code=create ddlb_item_code
this.st_3=create st_3
this.st_4=create st_4
this.sle_slip_no=create sle_slip_no
this.st_9=create st_9
this.pb_4=create pb_4
this.sle_1=create sle_1
this.st_18=create st_18
this.sle_slip_group_no_cond=create sle_slip_group_no_cond
this.sle_slip_group_no=create sle_slip_group_no
this.st_1=create st_1
this.st_2=create st_2
this.rb_excel_upload=create rb_excel_upload
this.rb_departure=create rb_departure
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateset
this.Control[iCurrent+2]=this.uo_dateend
this.Control[iCurrent+3]=this.ddlb_item_code
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.sle_slip_no
this.Control[iCurrent+7]=this.st_9
this.Control[iCurrent+8]=this.pb_4
this.Control[iCurrent+9]=this.sle_1
this.Control[iCurrent+10]=this.st_18
this.Control[iCurrent+11]=this.sle_slip_group_no_cond
this.Control[iCurrent+12]=this.sle_slip_group_no
this.Control[iCurrent+13]=this.st_1
this.Control[iCurrent+14]=this.st_2
this.Control[iCurrent+15]=this.rb_excel_upload
this.Control[iCurrent+16]=this.rb_departure
this.Control[iCurrent+17]=this.gb_2
this.Control[iCurrent+18]=this.gb_3
this.Control[iCurrent+19]=this.gb_1
end on

on w_mat_receipt_slip_excel_upload_master.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.ddlb_item_code)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.sle_slip_no)
destroy(this.st_9)
destroy(this.pb_4)
destroy(this.sle_1)
destroy(this.st_18)
destroy(this.sle_slip_group_no_cond)
destroy(this.sle_slip_group_no)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.rb_excel_upload)
destroy(this.rb_departure)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_1)
end on

event activate;call super::activate;/***************************************
* Window Default Property 
****************************************/
Gst_set.window_id            = this.classname() 
Gst_set.author                  = "JiSheng"
Gst_set.creation_date      = '20051101'
Gst_set.last_modify_date = '20051101'
Gst_set.Report_window    = True  // Report Window  True / Flase

/*****************************************
* Data Window Property
******************************************/
Ivs_resize_type                      = 'NORMAL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default


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
F_MENU_CONTROL('REPORT' , TRUE)  // All Data Control






end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())


end event

event ue_data_control;call super::ue_data_control;long i 
string lvs_date, lvs_item_code
double lvd_seq
Decimal  lvd_qty, lvd_packing_qty, lvd_request_qty, lvd_issue_qty
choose case gvs_ue_data_control
		
	case 'RETRIEVE'
		
			if rb_excel_upload.checked = true then 
		
				dw_1.reset()
			
				dw_1.retrieve( uo_dateset.text( ) , uo_dateend.text() ,   ddlb_item_code.text( )+'%' , sle_slip_no.text+'%' ,  sle_slip_group_no_cond.text+'%')
				
			else
						
				dw_2.reset()
				dw_2.retrieve( uo_dateset.text( ) , uo_dateend.text() ,   ddlb_item_code.text( )+'%' , sle_slip_no.text+'%' ,  sle_slip_group_no_cond.text+'%')
				
				
				
			end if 
	 
     case 'INSERT'
		

	
	case 'UPDATE'
		
			IF dw_1.UPDATE() < 0    THEN 
				ROLLBACK;
				RETURN					
			ELSE
				COMMIT;
				F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
			
			END IF

	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_mat_receipt_slip_excel_upload_master
integer y = 616
integer width = 2267
integer height = 1172
integer taborder = 0
boolean titlebar = true
end type

type dw_4 from w_main_root`dw_4 within w_mat_receipt_slip_excel_upload_master
integer y = 616
integer width = 2267
integer height = 1172
integer taborder = 0
boolean titlebar = true
end type

type dw_3 from w_main_root`dw_3 within w_mat_receipt_slip_excel_upload_master
integer y = 616
integer width = 2267
integer height = 1172
integer taborder = 0
boolean titlebar = true
end type

type dw_2 from w_main_root`dw_2 within w_mat_receipt_slip_excel_upload_master
integer x = 5
integer y = 616
integer width = 3927
integer height = 1172
integer taborder = 0
boolean titlebar = true
string dataobject = "d_mat_receipt_slip_excel_rpt"
borderstyle borderstyle = styleraised!
end type

type dw_1 from w_main_root`dw_1 within w_mat_receipt_slip_excel_upload_master
integer x = 5
integer y = 616
integer width = 4576
integer height = 1172
integer taborder = 0
boolean titlebar = true
string title = "Receipt Slip List"
string dataobject = "d_mat_receipt_slip_excel_lst"
end type

event dw_1::buttonclicked;call super::buttonclicked;//if dw_6.rowcount( ) < 1 then return 
//
//if dwo.name = 'b_scan' then 
//	
//	rb_normal_slip.checked = true
//	rb_normal_slip.triggerevent( clicked!)
//	
//else
//	return 
//end if 
//
//long lvl_return 
//ivl_count = row
//
//if dw_6.object.scan_yn[ivl_count] = 'Y' then 
//	
//else
//
//		 sle_lot_no.text  = dw_6.object.item[ivl_count]+'+'+ string(dw_6.object.reel_qty[ivl_count])+'+'+string(dw_6.object.transaction_qty[ivl_count])
//		 sle_lot_no.triggerevent( modified!)
//		
//		if ivi_error < 0  then 
//				return 
//		end if 
//
//		sle_slip_no.text  = dw_6.object.transaction_id[ivl_count]
//		sle_slip_no.triggerevent( modified!)
//		
//		if ivi_error < 0  then 
//			return 
//		end if 
//		dw_6.object.scan_yn[ivl_count] = 'Y'
//		if dw_6.update() < 0 then 
//			rollback;
//		else
//			commit ;
//			dw_6.sort( )
//			
//		end if 
//		
//		
//	end if 
end event

type uo_tabpages from w_main_root`uo_tabpages within w_mat_receipt_slip_excel_upload_master
integer taborder = 0
end type

type uo_dateset from uo_ymd_calendar within w_mat_receipt_slip_excel_upload_master
event destroy ( )
integer x = 905
integer y = 160
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mat_receipt_slip_excel_upload_master
event destroy ( )
integer x = 1321
integer y = 160
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type ddlb_item_code from uo_item_code within w_mat_receipt_slip_excel_upload_master
integer x = 1737
integer y = 156
integer width = 530
integer height = 676
integer taborder = 0
boolean bringtotop = true
end type

type st_3 from so_statictext within w_mat_receipt_slip_excel_upload_master
integer x = 1737
integer y = 80
integer width = 530
integer height = 72
boolean bringtotop = true
string text = "Item Code"
end type

type st_4 from so_statictext within w_mat_receipt_slip_excel_upload_master
integer x = 910
integer y = 80
integer width = 814
integer height = 72
boolean bringtotop = true
string text = "Receipt Date"
end type

type sle_slip_no from so_singlelineedit within w_mat_receipt_slip_excel_upload_master
integer x = 2277
integer y = 156
integer width = 654
integer height = 84
boolean bringtotop = true
end type

type st_9 from so_statictext within w_mat_receipt_slip_excel_upload_master
integer x = 2277
integer y = 80
integer width = 654
integer height = 72
boolean bringtotop = true
string text = "Slip No"
end type

type pb_4 from so_commandbutton within w_mat_receipt_slip_excel_upload_master
integer x = 69
integer y = 412
integer height = 124
integer taborder = 140
boolean bringtotop = true
string text = "Excel Import"
end type

event clicked;call super::clicked;//open(w_mat_receipt_slip_excel_import_popup)


long i 
string lvs_sequence
msg= f_msgbox1(1161 , this.text)

if msg = 1 then 
	
	lvs_sequence =  string( f_t_sysdate() , 'YYMMDD') +  string(f_get_sequence( 'SEQ_RECEIPT_SLIP') )
	sle_slip_group_no.text = lvs_sequence
	
//	delete from IM_ITEM_RECEIPT_SLIP_EXCEL ;
//	
//	if f_sql_check() < 0 then 
//		rollback;
//	else
//		commit ;
//	end if 
    
else
	return
end if
dw_1.reset()
dw_1.importclipboard( )

do
	i++
	dw_1.object.slip_group_no[i] = lvs_sequence
	
loop until i = dw_1.rowcount( )
//=========================================
//
//=========================================

   if dw_1.update( ) < 0 then 
     	rollback ;
   else
	    commit ;
		  f_msgbox(170)
   end if 



end event

type sle_1 from so_singlelineedit within w_mat_receipt_slip_excel_upload_master
integer x = 1216
integer y = 460
integer width = 608
integer height = 88
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
textcase textcase = upper!
end type

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

dw_1.SETFILTER('')
dw_1.FILTER()

LVS_COLUMN = 'ITEM'
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

type st_18 from so_statictext within w_mat_receipt_slip_excel_upload_master
integer x = 1216
integer y = 368
integer width = 608
integer height = 88
boolean bringtotop = true
integer textsize = -10
long textcolor = 16711680
string text = "Item Search"
end type

type sle_slip_group_no_cond from so_singlelineedit within w_mat_receipt_slip_excel_upload_master
integer x = 2935
integer y = 152
integer width = 526
integer height = 84
integer taborder = 70
boolean bringtotop = true
end type

type sle_slip_group_no from so_singlelineedit within w_mat_receipt_slip_excel_upload_master
integer x = 626
integer y = 460
integer width = 585
integer height = 88
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
textcase textcase = upper!
boolean displayonly = true
end type

type st_1 from so_statictext within w_mat_receipt_slip_excel_upload_master
integer x = 626
integer y = 376
integer width = 585
integer height = 64
boolean bringtotop = true
integer textsize = -10
long textcolor = 0
string text = "Slip Group No"
end type

type st_2 from so_statictext within w_mat_receipt_slip_excel_upload_master
integer x = 2935
integer y = 76
integer width = 526
integer height = 72
boolean bringtotop = true
long textcolor = 0
string text = "Slip Group No"
end type

type rb_excel_upload from so_radiobutton within w_mat_receipt_slip_excel_upload_master
integer x = 50
integer y = 84
integer width = 658
boolean bringtotop = true
integer weight = 700
string text = "Excel Upload"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1
end event

type rb_departure from so_radiobutton within w_mat_receipt_slip_excel_upload_master
integer x = 50
integer y = 184
integer width = 658
boolean bringtotop = true
integer weight = 700
string text = "Slip Print"
end type

event clicked;call super::clicked;dw_2.bringtotop = true 
selected_data_window = dw_2
end event

type gb_2 from so_groupbox within w_mat_receipt_slip_excel_upload_master
integer x = 873
integer width = 2638
integer height = 300
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_mat_receipt_slip_excel_upload_master
integer x = 9
integer y = 304
integer width = 1902
integer height = 296
integer weight = 700
long textcolor = 16711680
string text = "Slip Upload"
end type

type gb_1 from so_groupbox within w_mat_receipt_slip_excel_upload_master
integer width = 773
integer height = 300
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

