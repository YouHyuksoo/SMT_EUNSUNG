HA$PBExportHeader$w_qc_inventory_hold_master.srw
$PBExportComments$$$HEX7$$acc7e0ac200040d629b500adacb9$$ENDHEX$$
forward
global type w_qc_inventory_hold_master from w_main_root
end type
type st_27 from so_statictext within w_qc_inventory_hold_master
end type
type sle_material_mfs from so_singlelineedit within w_qc_inventory_hold_master
end type
type rb_all from so_radiobutton within w_qc_inventory_hold_master
end type
type rb_hold from so_radiobutton within w_qc_inventory_hold_master
end type
type cb_1 from so_commandbutton within w_qc_inventory_hold_master
end type
type cb_2 from so_commandbutton within w_qc_inventory_hold_master
end type
type uo_item from uo_item_code within w_qc_inventory_hold_master
end type
type st_5 from so_statictext within w_qc_inventory_hold_master
end type
type rb_all_hold from so_radiobutton within w_qc_inventory_hold_master
end type
type rb_lot_hold from so_radiobutton within w_qc_inventory_hold_master
end type
type rb_block from so_radiobutton within w_qc_inventory_hold_master
end type
type gb_1 from so_groupbox within w_qc_inventory_hold_master
end type
type gb_2 from so_groupbox within w_qc_inventory_hold_master
end type
type gb_3 from so_groupbox within w_qc_inventory_hold_master
end type
end forward

global type w_qc_inventory_hold_master from w_main_root
integer width = 5737
integer height = 2840
string title = "Inventory Hold Master"
string ivs_dw_4_use_focusindicator = "Y"
st_27 st_27
sle_material_mfs sle_material_mfs
rb_all rb_all
rb_hold rb_hold
cb_1 cb_1
cb_2 cb_2
uo_item uo_item
st_5 st_5
rb_all_hold rb_all_hold
rb_lot_hold rb_lot_hold
rb_block rb_block
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_qc_inventory_hold_master w_qc_inventory_hold_master

type variables
string lvs_current_array_type
end variables

on w_qc_inventory_hold_master.create
int iCurrent
call super::create
this.st_27=create st_27
this.sle_material_mfs=create sle_material_mfs
this.rb_all=create rb_all
this.rb_hold=create rb_hold
this.cb_1=create cb_1
this.cb_2=create cb_2
this.uo_item=create uo_item
this.st_5=create st_5
this.rb_all_hold=create rb_all_hold
this.rb_lot_hold=create rb_lot_hold
this.rb_block=create rb_block
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_27
this.Control[iCurrent+2]=this.sle_material_mfs
this.Control[iCurrent+3]=this.rb_all
this.Control[iCurrent+4]=this.rb_hold
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.cb_2
this.Control[iCurrent+7]=this.uo_item
this.Control[iCurrent+8]=this.st_5
this.Control[iCurrent+9]=this.rb_all_hold
this.Control[iCurrent+10]=this.rb_lot_hold
this.Control[iCurrent+11]=this.rb_block
this.Control[iCurrent+12]=this.gb_1
this.Control[iCurrent+13]=this.gb_2
this.Control[iCurrent+14]=this.gb_3
end on

on w_qc_inventory_hold_master.destroy
call super::destroy
destroy(this.st_27)
destroy(this.sle_material_mfs)
destroy(this.rb_all)
destroy(this.rb_hold)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.uo_item)
destroy(this.st_5)
destroy(this.rb_all_hold)
destroy(this.rb_lot_hold)
destroy(this.rb_block)
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
F_MENU_CONTROL('DATA_CONTROL' ,TRUE)  // All Data Control





end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

event ue_data_control;call super::ue_data_control;LONG row
datetime ld_date

choose case gvs_ue_data_control
		
	case 'RETRIEVE'
			if rb_all_hold.checked = true then 
				dw_1.reset()
				dw_1.retrieve( uo_item.text()+'%' , sle_material_mfs.text+'%' ,  gvi_organization_id )	
			elseif rb_lot_hold.checked = true then
				dw_2.reset()
				dw_2.retrieve( uo_item.text()+'%' , sle_material_mfs.text+'%' ,  gvi_organization_id )					
			elseif rb_block.checked = true then
				dw_3.reset()
				dw_3.retrieve(uo_item.text()+'%' , sle_material_mfs.text+'%' ,  gvi_organization_id)
			end if
			
	CASE	'INSERT'
		
		if rb_block.checked = true then
	
			DW_3.ENABLED = TRUE
			ROW = DW_3.INSERTROW(0)
			DW_3.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_3 , ROW ,'ALL')
			DW_3.OBject.HOLDING_DATE[ROW] = f_sysdate()
			
		end if			
	CASE	'APPEND'
		
		if rb_block.checked = true then
			
			DW_3.ENABLED = TRUE
			ROW = DW_3.INSERTROW(0)
			DW_3.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_3 , ROW ,'ALL')
			DW_3.OBject.HOLDING_DATE[ROW] = f_sysdate()
			
		end if
			
	CASE	'DELETE'
	
		if rb_block.checked = true then
			
			if DW_3.AcceptText() = -1 then
				return
			end if
			
			MSG = F_MSGBOX(1003)  //$$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?
			IF MSG = 1 THEN
				Gvl_row_deleted = DW_3.GetRow()			
				DW_3.DELETEROW(Gvl_row_deleted)		
				DW_3.SetFocus()
				ROW = DW_3.GetRow()
				DW_3.ScrollToRow(row)
				DW_3.SetColumn(1)
			END IF
			
		end if
			
	case 'UPDATE'

			if rb_all_hold.checked = true then

				if dw_1.update()	 < 0 then 
					rollback;
				else
					commit ;
				end if 
				f_msg_st(170)
			
			elseif rb_block.checked = true then
				
				if dw_3.update() < 0 then
					rollback;
				else 
					commit;
				end if
				f_msg_st(170)
				
			end if
	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_qc_inventory_hold_master
integer y = 344
integer width = 4242
integer height = 1504
integer taborder = 0
boolean titlebar = true
string title = "Packing Summary"
boolean maxbox = false
end type

type dw_4 from w_main_root`dw_4 within w_qc_inventory_hold_master
integer y = 344
integer width = 4242
integer height = 1504
integer taborder = 0
boolean titlebar = true
end type

type dw_3 from w_main_root`dw_3 within w_qc_inventory_hold_master
integer y = 344
integer width = 4242
integer height = 1504
integer taborder = 0
boolean titlebar = true
string dataobject = "d_mat_inventory_4_lot_blocking"
boolean maxbox = false
boolean border = false
end type

type dw_2 from w_main_root`dw_2 within w_qc_inventory_hold_master
integer y = 344
integer width = 4242
integer height = 1504
integer taborder = 0
boolean titlebar = true
string dataobject = "d_mat_inventory_barcode_4_holding_lst"
end type

event dw_2::updateend;//override
end event

event dw_2::updatestart;//override
end event

type dw_1 from w_main_root`dw_1 within w_qc_inventory_hold_master
integer y = 344
integer width = 4242
integer height = 1504
integer taborder = 0
boolean titlebar = true
string dataobject = "d_mat_item_inventory_hold_lst"
end type

event dw_1::itemchanged;//override
end event

type uo_tabpages from w_main_root`uo_tabpages within w_qc_inventory_hold_master
integer taborder = 0
end type

type st_27 from so_statictext within w_qc_inventory_hold_master
integer x = 1582
integer y = 100
integer width = 617
integer height = 56
boolean bringtotop = true
string text = "Material MFS"
end type

type sle_material_mfs from so_singlelineedit within w_qc_inventory_hold_master
integer x = 1582
integer y = 176
integer width = 617
integer height = 88
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
textcase textcase = upper!
end type

type rb_all from so_radiobutton within w_qc_inventory_hold_master
integer x = 3067
integer y = 136
integer width = 334
integer height = 72
boolean bringtotop = true
long textcolor = 0
string text = "All"
boolean checked = true
end type

event clicked;dw_1.SETFILTER('')
dw_1.FILTER()

end event

type rb_hold from so_radiobutton within w_qc_inventory_hold_master
integer x = 3410
integer y = 136
integer width = 357
integer height = 72
boolean bringtotop = true
long textcolor = 0
string text = "Hold"
end type

event clicked;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================

dw_1.SETFILTER('')
dw_1.FILTER()

dw_1.SETFILTER( 'INVENTORY_HOLD  LIKE '+"'"+"Y%"+"'")
dw_1.FILTER()
F_MSG_MDI_HELP( STRING( dw_1.ROWCOUNT() ) + " Found")
end event

type cb_1 from so_commandbutton within w_qc_inventory_hold_master
integer x = 2331
integer y = 60
integer height = 112
integer taborder = 40
boolean bringtotop = true
string text = "Hold"
end type

event clicked;call super::clicked;long i


if rb_all_hold.checked = true then 

		if dw_1.rowcount( ) < 1 then return 
		
		DO
			I++
			
			if dw_1.object.check_yn[i] = 'Y' then 
				
				dw_1.object.inventory_hold[i] = 'Y' 
				dw_1.object.comments[i] = 'QC Hold'
			else
				continue
			end if 
			
		LOOP UNTIL I = DW_1.ROWcount( )
		
		f_update()
		
else
		if dw_2.rowcount( ) < 1 then return 
		
		DO
			I++
			
			if dw_2.object.check_yn[i] = 'Y' then 
				
				dw_2.object.inventory_hold[i] = 'Y' 
				dw_2.object.comments[i] = 'QC Hold'
			else
				continue
			end if 
			
		LOOP UNTIL I = dw_2.ROWcount( )
		
		f_update()	
	
end if 
end event

type cb_2 from so_commandbutton within w_qc_inventory_hold_master
integer x = 2331
integer y = 168
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer weight = 400
string text = "Release"
end type

event clicked;call super::clicked;long i


if rb_all_hold.checked = true then 

	if dw_1.rowcount( ) < 1 then return 
	
	DO
		I++
		
		if dw_1.object.check_yn[i] = 'Y' then 
			
			dw_1.object.inventory_hold[i] = 'W' 
			dw_1.object.comments[i] = 'QC Release'
		else
			continue
		end if 
		
	LOOP UNTIL I = DW_1.ROWcount( )
	
	f_update()
	
else
	
	if dw_2.rowcount( ) < 1 then return 
	
	DO
		I++
		
		if dw_2.object.check_yn[i] = 'Y' then 
			
			dw_2.object.inventory_hold[i] = 'W' 
			dw_2.object.comments[i] = 'QC Release'
		else
			continue
		end if 
		
	LOOP UNTIL I = dw_2.ROWcount( )
	
	f_update()	
end if 
end event

type uo_item from uo_item_code within w_qc_inventory_hold_master
integer x = 997
integer y = 176
integer width = 581
integer height = 764
integer taborder = 40
boolean bringtotop = true
end type

event modified;call super::modified;f_retrieve()
end event

type st_5 from so_statictext within w_qc_inventory_hold_master
integer x = 997
integer y = 100
integer width = 581
integer height = 56
boolean bringtotop = true
boolean enabled = false
string text = "Item Code"
end type

type rb_all_hold from so_radiobutton within w_qc_inventory_hold_master
integer x = 82
integer y = 76
integer width = 375
integer height = 72
boolean bringtotop = true
long textcolor = 0
string text = "Inventory List"
boolean checked = true
end type

event clicked;dw_1.bringtotop = true
selected_data_window = dw_1

end event

type rb_lot_hold from so_radiobutton within w_qc_inventory_hold_master
integer x = 82
integer y = 184
integer width = 357
integer height = 72
boolean bringtotop = true
long textcolor = 0
string text = "Lot Hold"
end type

event clicked;dw_2.bringtotop = true
selected_data_window = dw_2

end event

type rb_block from so_radiobutton within w_qc_inventory_hold_master
integer x = 521
integer y = 76
integer width = 357
integer height = 72
boolean bringtotop = true
long textcolor = 0
string text = "Lot Blocking"
end type

event clicked;dw_3.bringtotop = true
selected_data_window = dw_3

end event

type gb_1 from so_groupbox within w_qc_inventory_hold_master
integer x = 946
integer width = 1298
integer height = 328
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_qc_inventory_hold_master
integer x = 14
integer width = 896
integer height = 324
integer taborder = 30
end type

type gb_3 from so_groupbox within w_qc_inventory_hold_master
integer x = 2985
integer width = 823
integer height = 324
integer taborder = 10
end type

