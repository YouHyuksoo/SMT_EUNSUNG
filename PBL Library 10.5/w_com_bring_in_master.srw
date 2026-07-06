HA$PBExportHeader$w_com_bring_in_master.srw
$PBExportComments$Material Receipt Master
forward
global type w_com_bring_in_master from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_com_bring_in_master
end type
type uo_dateend from uo_ymd_calendar within w_com_bring_in_master
end type
type ddlb_item_code from uo_item_code within w_com_bring_in_master
end type
type st_3 from so_statictext within w_com_bring_in_master
end type
type st_4 from so_statictext within w_com_bring_in_master
end type
type rb_list from so_radiobutton within w_com_bring_in_master
end type
type rb_receipt from so_radiobutton within w_com_bring_in_master
end type
type ddlb_supplier_code from uo_supplier_code within w_com_bring_in_master
end type
type st_1 from so_statictext within w_com_bring_in_master
end type
type st_5 from so_statictext within w_com_bring_in_master
end type
type sle_1 from so_singlelineedit within w_com_bring_in_master
end type
type tab_1 from tab within w_com_bring_in_master
end type
type tabpage_1 from userobject within tab_1
end type
type cb_1 from so_commandbutton within tabpage_1
end type
type tabpage_1 from userobject within tab_1
cb_1 cb_1
end type
type tabpage_2 from userobject within tab_1
end type
type rb_3 from so_radiobutton within tabpage_2
end type
type rb_2 from so_radiobutton within tabpage_2
end type
type rb_1 from so_radiobutton within tabpage_2
end type
type cb_print from so_commandbutton within tabpage_2
end type
type cb_preview from so_commandbutton within tabpage_2
end type
type cbx_dialog from so_checkbox within tabpage_2
end type
type em_copy from so_editmask within tabpage_2
end type
type st_2 from so_statictext within tabpage_2
end type
type tabpage_2 from userobject within tab_1
rb_3 rb_3
rb_2 rb_2
rb_1 rb_1
cb_print cb_print
cb_preview cb_preview
cbx_dialog cbx_dialog
em_copy em_copy
st_2 st_2
end type
type tab_1 from tab within w_com_bring_in_master
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type ddlb_carrying_out_type from uo_basecode within w_com_bring_in_master
end type
type st_6 from so_statictext within w_com_bring_in_master
end type
type st_7 from so_statictext within w_com_bring_in_master
end type
type sle_gen_new_group from so_singlelineedit within w_com_bring_in_master
end type
type gb_1 from so_groupbox within w_com_bring_in_master
end type
type gb_2 from so_groupbox within w_com_bring_in_master
end type
end forward

global type w_com_bring_in_master from w_main_root
integer width = 4613
integer height = 2952
string title = "Bring IN Invoice"
uo_dateset uo_dateset
uo_dateend uo_dateend
ddlb_item_code ddlb_item_code
st_3 st_3
st_4 st_4
rb_list rb_list
rb_receipt rb_receipt
ddlb_supplier_code ddlb_supplier_code
st_1 st_1
st_5 st_5
sle_1 sle_1
tab_1 tab_1
ddlb_carrying_out_type ddlb_carrying_out_type
st_6 st_6
st_7 st_7
sle_gen_new_group sle_gen_new_group
gb_1 gb_1
gb_2 gb_2
end type
global w_com_bring_in_master w_com_bring_in_master

type variables
string ivs_preview_yn
end variables

on w_com_bring_in_master.create
int iCurrent
call super::create
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.ddlb_item_code=create ddlb_item_code
this.st_3=create st_3
this.st_4=create st_4
this.rb_list=create rb_list
this.rb_receipt=create rb_receipt
this.ddlb_supplier_code=create ddlb_supplier_code
this.st_1=create st_1
this.st_5=create st_5
this.sle_1=create sle_1
this.tab_1=create tab_1
this.ddlb_carrying_out_type=create ddlb_carrying_out_type
this.st_6=create st_6
this.st_7=create st_7
this.sle_gen_new_group=create sle_gen_new_group
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateset
this.Control[iCurrent+2]=this.uo_dateend
this.Control[iCurrent+3]=this.ddlb_item_code
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.rb_list
this.Control[iCurrent+7]=this.rb_receipt
this.Control[iCurrent+8]=this.ddlb_supplier_code
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.st_5
this.Control[iCurrent+11]=this.sle_1
this.Control[iCurrent+12]=this.tab_1
this.Control[iCurrent+13]=this.ddlb_carrying_out_type
this.Control[iCurrent+14]=this.st_6
this.Control[iCurrent+15]=this.st_7
this.Control[iCurrent+16]=this.sle_gen_new_group
this.Control[iCurrent+17]=this.gb_1
this.Control[iCurrent+18]=this.gb_2
end on

on w_com_bring_in_master.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.ddlb_item_code)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.rb_list)
destroy(this.rb_receipt)
destroy(this.ddlb_supplier_code)
destroy(this.st_1)
destroy(this.st_5)
destroy(this.sle_1)
destroy(this.tab_1)
destroy(this.ddlb_carrying_out_type)
destroy(this.st_6)
destroy(this.st_7)
destroy(this.sle_gen_new_group)
destroy(this.gb_1)
destroy(this.gb_2)
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
F_MENU_CONTROL('DATA_CONTROL' ,TRUE)  // All Data Control





end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
uo_dateset.settext(string(f_t_sysdate(), 'yyyy/mm')+'/01')
end event

event ue_data_control;call super::ue_data_control;long row
string lvs_date
double lvd_seq
choose case gvs_ue_data_control
		
	case 'RETRIEVE'
			dw_1.reset()
			dw_2.reset()
			dw_3.reset()
			if rb_list.checked = true  then 
			    dw_1.retrieve(ddlb_item_code.text() + '%', ddlb_supplier_code.text +'%', uo_dateset.text(), uo_dateend.text(),  ddlb_carrying_out_type.getcode( )+'%'  , sle_gen_new_group.text+'%' , gvi_organization_id)
			else
		//		dw_3.retrieve(ddlb_item_code.text() + '%', ddlb_supplier_code.text +'%',uo_dateset.text() , uo_dateend.text(),   ddlb_carrying_out_type.getcode( )+'%' , gvi_organization_id)
		     	dw_3.retrieve( ddlb_item_code.text+ '%' , ddlb_supplier_code.text + '%' ,uo_dateset.text () , uo_dateend.text() ,  ddlb_carrying_out_type.getcode( )+'%' ,  gvi_organization_id )
		    end if 
	
    case 'INSERT'
		
//			ROW = DW_2.INSERTROW(DW_2.GETROW())
//			DW_2.SCROLLTOROW(ROW)
//			F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')
//			lvd_seq = f_get_sequence('seq_carrying_out')
//			lvs_date = string(f_t_sysdate(),'yyyymmdd') + string(lvd_seq)
//			dw_2.object.carrying_out_date[row] = f_t_sysdate()
//			dw_2.object.carrying_out_seq[row] = lvd_seq
//			dw_2.object.invoice_no[row] = lvs_date+string(lvd_seq)		
//			
//			dw_2.object.bring_in_date[row] = f_t_sysdate()
//         	dw_2.object.bring_in_seq[row] = f_get_sequence( 'seq_bring_in')
//
//              dw_2.object.confirm_yn[row] = 'N'			
//			

		
			
	case 'APPEND'		
			
//			ROW = DW_2.INSERTROW(DW_2.GETROW())
//			DW_2.SCROLLTOROW(ROW)
//			F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')	
//			lvd_seq = f_get_sequence('seq_carrying_out')
//			lvs_date = string(f_t_sysdate(),'yyyymmdd') + string(lvd_seq)
//			dw_2.object.carrying_out_date[row] = f_t_sysdate()
//			dw_2.object.carrying_out_seq[row] = lvd_seq
//			dw_2.object.invoice_no[row] = lvs_date+string(lvd_seq)		
//			
//			dw_2.object.bring_in_yn[row] = 'Y' //$$HEX8$$18bc85c774d57cc5200058d594b2c0c9$$ENDHEX$$
//			dw_2.object.confirm_yn[row] = 'N'			
//			dw_2.object.complete_yn[row] = 'N'						
//			dw_2.object.gate_guard_confirm_yn[row] = 'N'									
//			dw_2.object.car_no[row] = '*'												
			
	case 'DELETE'
		
		  	if DW_2.AcceptText() = -1 then
				return
			end if
			
			if dw_2.object.confirm_yn[dw_2.getrow()] = 'Y'  then
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
		
		
				dw_2.accepttext()
				msg = f_msgbox(1170)
				if msg = 1 then 
				else
					return 
				end if 
				
				if  dw_1.update() < 0 or dw_2.update() < 0 then 
					rollback; 
					f_msg_mdi_help(f_msg_st(9026))
				else
					commit; 
					f_retrieve()
					f_msg_mdi_help(f_msg_st(170))
				end if 
				
	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_com_bring_in_master
integer y = 584
end type

type dw_4 from w_main_root`dw_4 within w_com_bring_in_master
integer y = 584
integer width = 4544
integer height = 1124
boolean titlebar = true
string title = "Material Receipt Invoice Report"
string dataobject = "d_man_carrying_out_invoice_rpt"
end type

type dw_3 from w_main_root`dw_3 within w_com_bring_in_master
integer y = 584
integer width = 4544
integer height = 1120
boolean titlebar = true
string title = "Bring In History"
string dataobject = "d_com_bring_in_mst"
end type

type dw_2 from w_main_root`dw_2 within w_com_bring_in_master
integer y = 1720
integer width = 4549
integer height = 856
boolean titlebar = true
string title = "Bring IN Master"
string dataobject = "d_man_bring_in_mlst"
boolean hsplitscroll = false
boolean livescroll = false
borderstyle borderstyle = styleraised!
end type

event dw_2::itemchanged;call super::itemchanged;string lvs_return
if dwo.name = 'carrying_out_receiptor' then 
	lvs_return = f_get_supplier_name(data , gvi_organization_id)
	if lvs_return = 'ERROR' then 
		return 1 
	end if  
	if lvs_return = 'NOTFOUND' then 
		return 1 
	end if
	
	this.object.supplier_name[row] = lvs_return 
end if 

if dwo.name = 'carrying_out_item' then 
	
     lvs_return = f_set_item_name_spec_uom( this , row , this.object.item_code[row] )		

	if 	lvs_return = 'ERROR' THEN 
		return 1
	end if	
		
	if lvs_return = 'NOTFOUND' then 
		return 1  
	end if 		
end if
end event

event dw_2::rbuttondown;call super::rbuttondown;if dwo.name = 'carrying_out_receiptor' then 
	open(w_com_supplier_popup)
	if message.stringparm = '' then 
	else
		this.object.carrying_out_receiptor[row] = message.stringparm
//		IF ivs_modify_security = 'Y' THEN 
//			F_SET_SECURITY_ROW( THIS , ROW , 'MODIFY' )
//		END IF		
//		this.trigger event itemchanged(row, this.object.carrying_out_receiptor, this.object.carrying_out_receiptor[row])
		
	end if
end if 
if dwo.name = 'carrying_out_item' then 
	open(w_mat_item_popup)
	if gst_return.gvb_return = false then 
	else
		this.object.carrying_out_item[row] = gst_return.gvs_return[1] 
		this.object.carrying_out_item_spec[row] = gst_return.gvs_return[3] 
		this.object.carrying_out_division[row] = 'I' //$$HEX4$$d0c690c7acc72000$$ENDHEX$$
	end if 
	gst_return.gvs_return[1] = ''
	gst_return.gvs_return[3] = ''

end if 
		
if dwo.name = 'carrying_out_by' then 
	
	open(w_user_popup )
	
	if message.stringparm = '' then 
	else
		this.object.carrying_out_by[row] = message.stringparm
	end if
end if

if dwo.name = 'confirm_by' then 
	
	open(w_user_4_bring_in_out_confirm_popup )
	
	if message.stringparm = '' then 
	else
		this.object.confirm_by[row] = message.stringparm
	end if
	
end if		
end event

type dw_1 from w_main_root`dw_1 within w_com_bring_in_master
integer y = 584
integer width = 4544
integer height = 1128
boolean titlebar = true
string title = "Carrying OUT List"
string dataobject = "d_man_carrying_out_4_bring_in_lst"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return

dw_2.retrieve( this.object.carrying_out_date[currentrow] , this.object.carrying_out_seq[currentrow] , gvi_organization_id )
end event

type uo_tabpages from w_main_root`uo_tabpages within w_com_bring_in_master
end type

type uo_dateset from uo_ymd_calendar within w_com_bring_in_master
event destroy ( )
integer x = 1710
integer y = 160
integer taborder = 30
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_com_bring_in_master
event destroy ( )
integer x = 2126
integer y = 160
integer taborder = 40
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type ddlb_item_code from uo_item_code within w_com_bring_in_master
integer x = 750
integer y = 160
integer width = 517
integer taborder = 20
boolean bringtotop = true
end type

type st_3 from so_statictext within w_com_bring_in_master
integer x = 750
integer y = 80
integer width = 517
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type st_4 from so_statictext within w_com_bring_in_master
integer x = 1714
integer y = 80
integer width = 814
boolean bringtotop = true
integer weight = 700
string text = "Date"
end type

type rb_list from so_radiobutton within w_com_bring_in_master
integer x = 55
integer y = 80
integer width = 617
boolean bringtotop = true
integer weight = 700
string text = "Carrying OUT List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1




end event

type rb_receipt from so_radiobutton within w_com_bring_in_master
integer x = 55
integer y = 184
integer width = 622
boolean bringtotop = true
integer weight = 700
string text = "Bring In History"
end type

event clicked;call super::clicked;dw_3.bringtotop = true 
selected_data_window = dw_3



end event

type ddlb_supplier_code from uo_supplier_code within w_com_bring_in_master
integer x = 1271
integer y = 160
integer width = 439
integer taborder = 20
boolean bringtotop = true
end type

type st_1 from so_statictext within w_com_bring_in_master
integer x = 1271
integer y = 80
integer width = 439
boolean bringtotop = true
integer weight = 700
string text = "Supplier Code"
end type

type st_5 from so_statictext within w_com_bring_in_master
integer x = 2537
integer y = 84
integer width = 425
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Item Spec"
end type

type sle_1 from so_singlelineedit within w_com_bring_in_master
integer x = 2537
integer y = 160
integer width = 425
integer height = 84
integer taborder = 60
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

LVS_COLUMN = 'CARRYING_OUT_ITEM_SPEC'
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

type tab_1 from tab within w_com_bring_in_master
event create ( )
event destroy ( )
integer y = 300
integer width = 3287
integer height = 284
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean fixedwidth = true
boolean raggedright = true
boolean focusonbuttondown = true
boolean powertips = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.Control[]={this.tabpage_1,&
this.tabpage_2}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3250
integer height = 156
long backcolor = 12632256
string text = "Process"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Regenerate5!"
long picturemaskcolor = 536870912
cb_1 cb_1
end type

on tabpage_1.create
this.cb_1=create cb_1
this.Control[]={this.cb_1}
end on

on tabpage_1.destroy
destroy(this.cb_1)
end on

type cb_1 from so_commandbutton within tabpage_1
integer x = 23
integer y = 24
integer height = 108
integer taborder = 70
string text = "Batch Bring IN"
end type

event clicked;call super::clicked;int i , rows
decimal lvf_bring_in_qty 
dw_1.accepttext()
do
	i++
	
	if dw_1.object.check_yn[i] = 'Y' then
	else
		continue
	end if

	lvf_bring_in_qty = dw_1.object.new_bring_in_qty[i]
	if lvf_bring_in_qty  <  0 then
		Messagebox("Notify" , "Bring IN Qty Invalid")
		return
	end if
	
	rows = dw_2.insertrow( 0)
	f_set_security_row(dw_2, rows , 'ALL')
	
	dw_2.object.carrying_out_date[rows] = dw_1.object.carrying_out_date[i] 	
	dw_2.object.carrying_out_seq[rows] = dw_1.object.carrying_out_seq[i] 	
	
	dw_2.object.bring_in_date[rows] = f_t_sysdate()
	dw_2.object.bring_in_seq[rows] = f_get_sequence( 'seq_bring_in')
	dw_2.object.bring_in_qty[rows] = lvf_bring_in_qty
	
loop until i = dw_1.rowcount( )
end event

type tabpage_2 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 3250
integer height = 156
long backcolor = 15780518
string text = "Print"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Print!"
long picturemaskcolor = 536870912
rb_3 rb_3
rb_2 rb_2
rb_1 rb_1
cb_print cb_print
cb_preview cb_preview
cbx_dialog cbx_dialog
em_copy em_copy
st_2 st_2
end type

on tabpage_2.create
this.rb_3=create rb_3
this.rb_2=create rb_2
this.rb_1=create rb_1
this.cb_print=create cb_print
this.cb_preview=create cb_preview
this.cbx_dialog=create cbx_dialog
this.em_copy=create em_copy
this.st_2=create st_2
this.Control[]={this.rb_3,&
this.rb_2,&
this.rb_1,&
this.cb_print,&
this.cb_preview,&
this.cbx_dialog,&
this.em_copy,&
this.st_2}
end on

on tabpage_2.destroy
destroy(this.rb_3)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.cb_print)
destroy(this.cb_preview)
destroy(this.cbx_dialog)
destroy(this.em_copy)
destroy(this.st_2)
end on

type rb_3 from so_radiobutton within tabpage_2
integer x = 2194
integer y = 48
integer width = 315
integer weight = 700
long backcolor = 15780518
string text = "All"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.setfilter( '')
dw_1.filter( )
end event

type rb_2 from so_radiobutton within tabpage_2
integer x = 2962
integer y = 48
integer width = 288
integer weight = 700
long backcolor = 15780518
string text = "Wait"
end type

event clicked;call super::clicked;dw_1.setfilter("confirm_yn <>'"+'Y'+"'")
dw_1.filter( )
end event

type rb_1 from so_radiobutton within tabpage_2
integer x = 2560
integer y = 48
integer width = 402
integer weight = 700
long backcolor = 15780518
string text = "Confirmed"
end type

event clicked;call super::clicked;dw_1.setfilter("confirm_yn = '"+'Y'+"'")
dw_1.filter( )
end event

type cb_print from so_commandbutton within tabpage_2
integer x = 1061
integer y = 24
integer width = 361
integer height = 108
integer taborder = 100
boolean bringtotop = true
string text = "Print"
end type

event clicked;call super::clicked;Int		i, lvi_cnt , rows

If dw_4.rowcount() < 1 Then Return

	if dw_4.object.confirm_yn[dw_4.getrow()] = 'Y' then
		Messagebox("Notify" , "Not Confirmed Can`t Print Invoice")
		return
	else
		return
	end if 

		lvi_cnt = Integer(em_copy.text)
		If lvi_cnt > 0 Then
			If rb_list.checked = True Then
				For i = 1 To lvi_cnt
					
					if cbx_dialog.checked = true then 
						dw_4.print(false, True)
					else
						dw_4.print(false, False)						
					end if
				Next
			End If
		End If

end event

type cb_preview from so_commandbutton within tabpage_2
integer x = 695
integer y = 24
integer width = 361
integer height = 108
integer taborder = 60
boolean bringtotop = true
string text = "Preview"
end type

event clicked;call super::clicked;if rb_list.checked = true then 
	if  ivs_preview_yn = 'Y' THEN 
		ivs_preview_yn = 'N' 	
		dw_1.bringtotop = TRUE
	else
		
		if dw_1.getrow() < 1 then return
		ivs_preview_yn = 'Y' 	
		dw_4.bringtotop = TRUE	
		dw_4.retrieve( dw_1.object.invoice_no[dw_1.getrow()] , gvi_organization_id )
		  
		if dw_4.Describe("DataWindow.Print.Preview") = '!' or dw_4.Describe("DataWindow.Print.Preview") = '?' then
		else
			 dw_4.Modify("DataWindow.Print.Preview=yes")
			dw_4.Modify("DataWindow.Print.Preview.Rulers=yes")
		end if		
	end if
end if
	
end event

type cbx_dialog from so_checkbox within tabpage_2
integer x = 1440
integer y = 32
integer width = 393
boolean bringtotop = true
integer weight = 700
long backcolor = 15780518
string text = "Show Dialog"
end type

type em_copy from so_editmask within tabpage_2
integer x = 375
integer y = 36
integer width = 311
integer taborder = 60
boolean bringtotop = true
string text = "1"
string mask = "##0"
boolean spin = true
end type

type st_2 from so_statictext within tabpage_2
integer x = 50
integer y = 48
integer width = 311
integer height = 56
boolean bringtotop = true
integer weight = 700
long backcolor = 15780518
string text = "Print Copy"
end type

type ddlb_carrying_out_type from uo_basecode within w_com_bring_in_master
integer x = 2971
integer y = 160
integer width = 539
integer taborder = 50
boolean bringtotop = true
end type

event constructor;call super::constructor;THIS.REdraw( 'CARRYING OUT TYPE')
end event

type st_6 from so_statictext within w_com_bring_in_master
integer x = 2971
integer y = 84
integer width = 539
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Carrying Out Type"
end type

type st_7 from so_statictext within w_com_bring_in_master
integer x = 3502
integer y = 88
integer width = 425
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Gen New Group"
end type

type sle_gen_new_group from so_singlelineedit within w_com_bring_in_master
integer x = 3520
integer y = 160
integer width = 425
integer height = 84
integer taborder = 70
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

type gb_1 from so_groupbox within w_com_bring_in_master
integer width = 709
integer height = 300
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_2 from so_groupbox within w_com_bring_in_master
integer x = 718
integer width = 3337
integer height = 300
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

