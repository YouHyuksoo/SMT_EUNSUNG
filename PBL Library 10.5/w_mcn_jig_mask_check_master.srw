HA$PBExportHeader$w_mcn_jig_mask_check_master.srw
$PBExportComments$$$HEX8$$08ae15d680acacc074c725b800adacb9$$ENDHEX$$
forward
global type w_mcn_jig_mask_check_master from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_mcn_jig_mask_check_master
end type
type uo_dateend from uo_ymd_calendar within w_mcn_jig_mask_check_master
end type
type st_4 from so_statictext within w_mcn_jig_mask_check_master
end type
type st_2 from so_statictext within w_mcn_jig_mask_check_master
end type
type sle_jig_lot_no from so_singlelineedit within w_mcn_jig_mask_check_master
end type
type rb_jig_check_list from so_radiobutton within w_mcn_jig_mask_check_master
end type
type rb_jig_list from so_radiobutton within w_mcn_jig_mask_check_master
end type
type sle_barcode from so_singlelineedit within w_mcn_jig_mask_check_master
end type
type st_1 from so_statictext within w_mcn_jig_mask_check_master
end type
type st_5 from so_statictext within w_mcn_jig_mask_check_master
end type
type st_6 from so_statictext within w_mcn_jig_mask_check_master
end type
type em_break_value from so_editmask within w_mcn_jig_mask_check_master
end type
type em_hit_value from so_editmask within w_mcn_jig_mask_check_master
end type
type gb_2 from so_groupbox within w_mcn_jig_mask_check_master
end type
type gb_3 from groupbox within w_mcn_jig_mask_check_master
end type
type gb_1 from so_groupbox within w_mcn_jig_mask_check_master
end type
end forward

global type w_mcn_jig_mask_check_master from w_main_root
integer width = 5024
integer height = 3028
string title = "Mask Tension Manual Check Master"
uo_dateset uo_dateset
uo_dateend uo_dateend
st_4 st_4
st_2 st_2
sle_jig_lot_no sle_jig_lot_no
rb_jig_check_list rb_jig_check_list
rb_jig_list rb_jig_list
sle_barcode sle_barcode
st_1 st_1
st_5 st_5
st_6 st_6
em_break_value em_break_value
em_hit_value em_hit_value
gb_2 gb_2
gb_3 gb_3
gb_1 gb_1
end type
global w_mcn_jig_mask_check_master w_mcn_jig_mask_check_master

type variables
string lvs_jig_lot_no , lvs_jig_code
long lvl_break_value , lvl_hit_value ,lvl_row
end variables

forward prototypes
public function integer wf_insert_inspect (string arg_check_status)
end prototypes

public function integer wf_insert_inspect (string arg_check_status);
f_insert()

dw_2.object.jig_check_date[lvl_row] = f_sysdate()
dw_2.object.jig_lot_no[lvl_row] = sle_barcode.text
dw_2.object.jig_code[lvl_row] = lvs_jig_code
dw_2.object.jig_check_sequence[lvl_row] = f_get_sequence('SEQ_JIG_CHECK_SEQUENCE')
dw_2.object.jig_check_status[lvl_row] = arg_check_status //PASS

if dw_2.update() < 0 then 
	rollback ;
	return -1
else
	
	if arg_check_status = 'P' then 
				update imcn_jig set use_status = 'U' where jig_lot_no = :lvs_jig_lot_no
				and jig_type = 'M' 
				and organization_id = :gvi_organization_id ; 
				
				if f_sql_check() < 0 then 
				return  -1
				end if 
	else
				update imcn_jig set use_status = 'S' 
				where jig_lot_no = :lvs_jig_lot_no
				and jig_type = 'M' 
				and organization_id = :gvi_organization_id ; 

				if f_sql_check() < 0 then 
					return  -1
				end if 
	end if 
	

	commit ;
end if 



end function

on w_mcn_jig_mask_check_master.create
int iCurrent
call super::create
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.st_4=create st_4
this.st_2=create st_2
this.sle_jig_lot_no=create sle_jig_lot_no
this.rb_jig_check_list=create rb_jig_check_list
this.rb_jig_list=create rb_jig_list
this.sle_barcode=create sle_barcode
this.st_1=create st_1
this.st_5=create st_5
this.st_6=create st_6
this.em_break_value=create em_break_value
this.em_hit_value=create em_hit_value
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateset
this.Control[iCurrent+2]=this.uo_dateend
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.sle_jig_lot_no
this.Control[iCurrent+6]=this.rb_jig_check_list
this.Control[iCurrent+7]=this.rb_jig_list
this.Control[iCurrent+8]=this.sle_barcode
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.st_5
this.Control[iCurrent+11]=this.st_6
this.Control[iCurrent+12]=this.em_break_value
this.Control[iCurrent+13]=this.em_hit_value
this.Control[iCurrent+14]=this.gb_2
this.Control[iCurrent+15]=this.gb_3
this.Control[iCurrent+16]=this.gb_1
end on

on w_mcn_jig_mask_check_master.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.st_4)
destroy(this.st_2)
destroy(this.sle_jig_lot_no)
destroy(this.rb_jig_check_list)
destroy(this.rb_jig_list)
destroy(this.sle_barcode)
destroy(this.st_1)
destroy(this.st_5)
destroy(this.st_6)
destroy(this.em_break_value)
destroy(this.em_hit_value)
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
Gst_set.Report_window    = False  // Report Window  True / Flase

/*****************************************
* Data Window Property
******************************************/
Ivs_resize_type                      = 'MASTER_DETAIL_TOP'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


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
sle_barcode.setfocus()
end event

event ue_data_control;call super::ue_data_control;string lvs_date
choose case gvs_ue_data_control
		
	case 'RETRIEVE'
				
			if rb_jig_list.checked = true then 
					dw_1.reset()
					dw_2.reset()
				    dw_1.retrieve(sle_jig_lot_no.text + '%' , 'M' ,  gvi_organization_id)		
			else
					dw_3.reset()
				    dw_3.retrieve( sle_jig_lot_no.text+'%' ,   uo_dateset.text() , uo_dateend.text() ,  gvi_organization_id)						
			end if 
			
			sle_barcode.setfocus()

    case 'INSERT'
		
			lvl_row = DW_2.INSERTROW(0)
			DW_2.SCROLLTOROW(lvl_row)
			F_SET_SECURITY_ROW(DW_2 , lvl_row ,'ALL')
			
              if dw_1.getrow() < 1 then 
		    else
				DW_2.SETITEM( lvl_row , 'JIG_CODE' , dw_1.object.jig_code[dw_1.getrow()] )
				DW_2.SETITEM( lvl_row , 'JIG_LOT_NO' , dw_1.object.JIG_LOT_NO[dw_1.getrow()] )	
				DW_2.SETITEM( lvl_row , 'JIG_CHECK_DATE' , F_SYSDATE() )			
				DW_2.SETITEM( lvl_row , 'BREAK_VALUE' , dw_1.object.break_value[dw_1.getrow()]  )		
				DW_2.SETITEM( lvl_row , 'HIT_VALUE' ,dw_1.object.hit_value[dw_1.getrow()])		
				
			end if
			sle_barcode.setfocus()
			
			
	case 'APPEND'		
			
			lvl_row = DW_2.INSERTROW(DW_2.GETROW())
			DW_2.SCROLLTOROW(lvl_row)
			F_SET_SECURITY_ROW(DW_2 , lvl_row ,'ALL')
			
			
              if dw_1.getrow() < 1 then 
		    else
				DW_2.SETITEM( lvl_row , 'JIG_CODE' , dw_1.object.jig_code[dw_1.getrow()] )
				DW_2.SETITEM( lvl_row , 'JIG_LOT_NO' , dw_1.object.JIG_LOT_NO[dw_1.getrow()] )
				DW_2.SETITEM( lvl_row , 'JIG_CHECK_DATE' , F_SYSDATE() )		
				DW_2.SETITEM( lvl_row , 'BREAK_VALUE' , dw_1.object.break_value[dw_1.getrow()]  )		
				DW_2.SETITEM( lvl_row , 'HIT_VALUE' ,dw_1.object.hit_value[dw_1.getrow()])						
				
			end if
			sle_barcode.setfocus()
	case 'DELETE'
		
		  	if DW_2.AcceptText() = -1 then
				return
			end if
			
			MSG = F_MSGBOX(1003)  //$$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?
			IF MSG = 1 THEN
				Gvl_row_deleted = DW_2.GetRow()			
				DW_2.DELETEROW(Gvl_row_deleted)		
				DW_2.SetFocus()
				lvl_row = DW_2.GetRow()
				DW_2.ScrollToRow(lvl_row)
				DW_2.SetColumn(1)
			END IF		 
			sle_barcode.setfocus()
   case 'UPDATE'
		
			IF DW_2.UPDATE() < 0  THEN
			  	 ROLLBACK;
				 RETURN
			ELSE
				 COMMIT;
				 F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"			 
			END IF
			sle_barcode.setfocus()
	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_mcn_jig_mask_check_master
integer y = 308
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_mcn_jig_mask_check_master
integer y = 308
integer taborder = 0
end type

type dw_3 from w_main_root`dw_3 within w_mcn_jig_mask_check_master
integer y = 308
integer width = 4544
integer height = 1092
integer taborder = 0
boolean titlebar = true
string dataobject = "d_mcn_jig_mask_check_lst"
end type

type dw_2 from w_main_root`dw_2 within w_mcn_jig_mask_check_master
integer y = 1408
integer width = 4549
integer height = 1108
integer taborder = 0
boolean titlebar = true
string dataobject = "d_mcn_jig_check_mlst"
boolean hsplitscroll = false
boolean livescroll = false
end type

event dw_2::rbuttondown;call super::rbuttondown;if dwo.name = 'repair_vendor_code' then 	
	open(w_com_supplier_popup)	
	if  gst_return.gvb_return  = true then
	   this.object.repair_vendor_code[row] = message.stringparm
	   gst_return.gvs_return[1]  = ''		
	end if
end if
end event

type dw_1 from w_main_root`dw_1 within w_mcn_jig_mask_check_master
integer y = 308
integer width = 4544
integer height = 1092
integer taborder = 0
boolean titlebar = true
string title = "Metal Mask Inventory"
string dataobject = "d_mcn_jig_inventory_4_mask_check_lst"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return
dw_2.retrieve( this.object.jig_lot_no[currentrow] , gvi_organization_id  )
sle_barcode.setfocus()
end event

type uo_tabpages from w_main_root`uo_tabpages within w_mcn_jig_mask_check_master
integer taborder = 0
end type

type uo_dateset from uo_ymd_calendar within w_mcn_jig_mask_check_master
event destroy ( )
integer x = 1627
integer y = 160
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mcn_jig_mask_check_master
event destroy ( )
integer x = 2043
integer y = 160
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_4 from so_statictext within w_mcn_jig_mask_check_master
integer x = 1632
integer y = 80
integer width = 814
integer height = 68
boolean bringtotop = true
string text = "Receipt Date"
end type

type st_2 from so_statictext within w_mcn_jig_mask_check_master
integer x = 786
integer y = 80
integer width = 832
integer height = 68
boolean bringtotop = true
long textcolor = 0
string text = "JIG Lot No"
end type

type sle_jig_lot_no from so_singlelineedit within w_mcn_jig_mask_check_master
integer x = 786
integer y = 160
integer width = 832
integer height = 84
boolean bringtotop = true
end type

type rb_jig_check_list from so_radiobutton within w_mcn_jig_mask_check_master
integer x = 46
integer y = 172
integer width = 667
boolean bringtotop = true
integer weight = 700
string text = "JIG Check List"
end type

event clicked;call super::clicked;dw_3.bringtotop = true
selected_data_window = dw_3
sle_barcode.setfocus()

end event

type rb_jig_list from so_radiobutton within w_mcn_jig_mask_check_master
integer x = 46
integer y = 76
integer width = 667
boolean bringtotop = true
integer weight = 700
string text = "JIG List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true
selected_data_window = dw_1
dw_2.bringtotop = true
sle_barcode.setfocus()
end event

type sle_barcode from so_singlelineedit within w_mcn_jig_mask_check_master
integer x = 2615
integer y = 180
integer width = 891
integer taborder = 1
boolean bringtotop = true
end type

event modified;call super::modified;lvs_jig_lot_no = this.text 

select break_value , hit_value , jig_code
  into :lvl_break_value , :lvl_hit_value , :lvs_jig_code
 from imcn_jig 
where jig_lot_no = :lvs_jig_lot_no 
    and jig_type = 'M'
    and organization_id = :gvi_organization_id ;
	 
if f_sql_check() < 0 then
	return 
end if 

if lvs_jig_code = '' or isnull(lvs_jig_code) then 
	//Mes sagebox("$$HEX2$$55d678c7$$ENDHEX$$" , "$$HEX11$$f8bbf1b45db8200014bc54cfdcb4200085c7c8b2e4b2$$ENDHEX$$")
	f_msg(  "$$HEX11$$f8bbf1b45db8200014bc54cfdcb4200085c7c8b2e4b2$$ENDHEX$$",'P')
	sle_barcode.text = ''
	sle_barcode.setfocus( )
	return 
end if 

em_break_value.text = string( lvl_break_value )
em_hit_value.text = string( lvl_hit_value ) 


dw_1.retrieve( this.text+'%'  , gvi_organization_id )

if dw_1.rowcount( ) < 1 then 
	return 
end if 


if  lvl_break_value < lvl_hit_value then 
	//Mes sagebox("$$HEX2$$55d678c7$$ENDHEX$$" , "$$HEX14$$5cd5c4ac200018c285ba44c7200008cdfcac200088d5b5c2c8b2e4b2$$ENDHEX$$")
	f_msg("$$HEX14$$5cd5c4ac200018c285ba44c7200008cdfcac200088d5b5c2c8b2e4b2$$ENDHEX$$",'P')
	wf_insert_inspect( 'N')
else
	wf_insert_inspect( 'P')
end if 


end event

type st_1 from so_statictext within w_mcn_jig_mask_check_master
integer x = 2615
integer y = 76
integer width = 891
integer height = 68
boolean bringtotop = true
string text = "JIG Barcode"
end type

type st_5 from so_statictext within w_mcn_jig_mask_check_master
integer x = 3525
integer y = 76
integer width = 402
integer height = 68
boolean bringtotop = true
string text = "Break Value"
end type

type st_6 from so_statictext within w_mcn_jig_mask_check_master
integer x = 3936
integer y = 76
integer width = 402
integer height = 68
boolean bringtotop = true
string text = "Hit Value"
end type

type em_break_value from so_editmask within w_mcn_jig_mask_check_master
integer x = 3515
integer y = 180
integer taborder = 21
boolean bringtotop = true
string text = "0"
string mask = "###,##0"
end type

type em_hit_value from so_editmask within w_mcn_jig_mask_check_master
integer x = 3941
integer y = 180
integer taborder = 31
boolean bringtotop = true
string text = "0"
string mask = "###,##0"
end type

type gb_2 from so_groupbox within w_mcn_jig_mask_check_master
integer x = 750
integer width = 1746
integer height = 300
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from groupbox within w_mcn_jig_mask_check_master
integer width = 741
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

type gb_1 from so_groupbox within w_mcn_jig_mask_check_master
integer x = 2519
integer width = 1915
integer height = 296
string text = "Adjust Scan"
end type

