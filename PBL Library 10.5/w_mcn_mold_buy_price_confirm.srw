HA$PBExportHeader$w_mcn_mold_buy_price_confirm.srw
$PBExportComments$Material Buy Price Master
forward
global type w_mcn_mold_buy_price_confirm from w_main_root
end type
type st_1 from so_statictext within w_mcn_mold_buy_price_confirm
end type
type ddlb_item_code from uo_item_code within w_mcn_mold_buy_price_confirm
end type
type ddlb_supplier_code from uo_supplier_code within w_mcn_mold_buy_price_confirm
end type
type st_3 from so_statictext within w_mcn_mold_buy_price_confirm
end type
type gb_1 from so_groupbox within w_mcn_mold_buy_price_confirm
end type
type st_14 from so_statictext within w_mcn_mold_buy_price_confirm
end type
type sle_item_name from so_singlelineedit within w_mcn_mold_buy_price_confirm
end type
type sle_1 from so_singlelineedit within w_mcn_mold_buy_price_confirm
end type
type st_4 from so_statictext within w_mcn_mold_buy_price_confirm
end type
type cb_1 from so_commandbutton within w_mcn_mold_buy_price_confirm
end type
type cb_2 from so_commandbutton within w_mcn_mold_buy_price_confirm
end type
type rb_wait from so_radiobutton within w_mcn_mold_buy_price_confirm
end type
type rb_confirmed from so_radiobutton within w_mcn_mold_buy_price_confirm
end type
type gb_2 from so_groupbox within w_mcn_mold_buy_price_confirm
end type
type gb_3 from so_groupbox within w_mcn_mold_buy_price_confirm
end type
end forward

global type w_mcn_mold_buy_price_confirm from w_main_root
integer width = 4681
integer height = 2848
string title = "Mold Buy Price Confirm"
st_1 st_1
ddlb_item_code ddlb_item_code
ddlb_supplier_code ddlb_supplier_code
st_3 st_3
gb_1 gb_1
st_14 st_14
sle_item_name sle_item_name
sle_1 sle_1
st_4 st_4
cb_1 cb_1
cb_2 cb_2
rb_wait rb_wait
rb_confirmed rb_confirmed
gb_2 gb_2
gb_3 gb_3
end type
global w_mcn_mold_buy_price_confirm w_mcn_mold_buy_price_confirm

on w_mcn_mold_buy_price_confirm.create
int iCurrent
call super::create
this.st_1=create st_1
this.ddlb_item_code=create ddlb_item_code
this.ddlb_supplier_code=create ddlb_supplier_code
this.st_3=create st_3
this.gb_1=create gb_1
this.st_14=create st_14
this.sle_item_name=create sle_item_name
this.sle_1=create sle_1
this.st_4=create st_4
this.cb_1=create cb_1
this.cb_2=create cb_2
this.rb_wait=create rb_wait
this.rb_confirmed=create rb_confirmed
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.ddlb_item_code
this.Control[iCurrent+3]=this.ddlb_supplier_code
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.gb_1
this.Control[iCurrent+6]=this.st_14
this.Control[iCurrent+7]=this.sle_item_name
this.Control[iCurrent+8]=this.sle_1
this.Control[iCurrent+9]=this.st_4
this.Control[iCurrent+10]=this.cb_1
this.Control[iCurrent+11]=this.cb_2
this.Control[iCurrent+12]=this.rb_wait
this.Control[iCurrent+13]=this.rb_confirmed
this.Control[iCurrent+14]=this.gb_2
this.Control[iCurrent+15]=this.gb_3
end on

on w_mcn_mold_buy_price_confirm.destroy
call super::destroy
destroy(this.st_1)
destroy(this.ddlb_item_code)
destroy(this.ddlb_supplier_code)
destroy(this.st_3)
destroy(this.gb_1)
destroy(this.st_14)
destroy(this.sle_item_name)
destroy(this.sle_1)
destroy(this.st_4)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.rb_wait)
destroy(this.rb_confirmed)
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
F_MENU_CONTROL('DATA_CONTROL_INSERT' , TRUE)  // All Data Control





end event

event ue_post_open;call super::ue_post_open;

/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

event ue_data_control;call super::ue_data_control;long row
string lvs_confirm_status

		if rb_wait.checked = true then 
			lvs_confirm_status = 'N'
		else
			lvs_confirm_status = 'Y'			
		end if
		

choose case gvs_ue_data_control

	case 'RETRIEVE'
			
			dw_1.retrieve(ddlb_item_code.text + '%', ddlb_supplier_code.text + '%',  lvs_confirm_status , gvi_organization_id)
		

	case 'UPDATE'
		
			IF DW_1.UPDATE() < 0  THEN
			  	 ROLLBACK;
			      RETURN
			ELSE
				 COMMIT;
				 F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
	              F_RETRIEVE()
			END IF

	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_mcn_mold_buy_price_confirm
integer y = 316
end type

type dw_4 from w_main_root`dw_4 within w_mcn_mold_buy_price_confirm
integer y = 316
end type

type dw_3 from w_main_root`dw_3 within w_mcn_mold_buy_price_confirm
integer y = 316
end type

type dw_2 from w_main_root`dw_2 within w_mcn_mold_buy_price_confirm
integer y = 316
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

type dw_1 from w_main_root`dw_1 within w_mcn_mold_buy_price_confirm
integer y = 316
integer width = 4544
integer height = 2416
boolean titlebar = true
string title = "Material Buy Price List"
string dataobject = "d_mcn_mold_buy_price_4_confirm_lst"
end type

event dw_1::itemchanged;call super::itemchanged;datetime lvdt_null
setnull(lvdt_null)
if dwo.name= 'price_change_confirm_yn' then 
	
	if dw_1.object.price_change_confirm_yn[row] = 'Y' then

	dw_1.object.confirm_by[row] = Gvs_user_id
	dw_1.object.confirm_date[row] = f_sysdate()		
		
	else
		dw_1.object.confirm_by[row] = ''
		dw_1.object.confirm_date[row] = lvdt_null
	
	end if
	
end if
end event

type uo_tabpages from w_main_root`uo_tabpages within w_mcn_mold_buy_price_confirm
end type

type st_1 from so_statictext within w_mcn_mold_buy_price_confirm
integer x = 41
integer y = 100
integer width = 539
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type ddlb_item_code from uo_item_code within w_mcn_mold_buy_price_confirm
integer x = 41
integer y = 176
integer width = 539
integer taborder = 20
boolean bringtotop = true
end type

type ddlb_supplier_code from uo_supplier_code within w_mcn_mold_buy_price_confirm
integer x = 590
integer y = 176
integer width = 549
integer taborder = 20
boolean bringtotop = true
end type

type st_3 from so_statictext within w_mcn_mold_buy_price_confirm
integer x = 590
integer y = 100
integer width = 549
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Supplier Code"
end type

type gb_1 from so_groupbox within w_mcn_mold_buy_price_confirm
integer x = 2359
integer width = 677
integer height = 300
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Confirm/Cancel"
end type

type st_14 from so_statictext within w_mcn_mold_buy_price_confirm
integer x = 1147
integer y = 100
integer width = 590
integer height = 60
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Item Name"
end type

type sle_item_name from so_singlelineedit within w_mcn_mold_buy_price_confirm
integer x = 1147
integer y = 176
integer width = 590
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

type sle_1 from so_singlelineedit within w_mcn_mold_buy_price_confirm
integer x = 1742
integer y = 176
integer width = 590
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

type st_4 from so_statictext within w_mcn_mold_buy_price_confirm
integer x = 1742
integer y = 100
integer width = 590
integer height = 60
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Item Spec"
end type

type cb_1 from so_commandbutton within w_mcn_mold_buy_price_confirm
integer x = 3095
integer y = 132
integer width = 411
integer height = 104
integer taborder = 50
boolean bringtotop = true
string text = "All Confirm"
end type

event clicked;call super::clicked;long i , j
do
	i++
	if dw_1.object.check_yn[i] = 'Y' then 
	else
		continue
	end if
	
	dw_1.object.price_change_confirm_yn[i] = 'Y'
	dw_1.object.confirm_by[I] = Gvs_user_id
	dw_1.object.confirm_date[I] = f_sysdate()			
	 j++
loop until i = dw_1.rowcount()

if j > 0 then 
	
	msg = f_msgbox1( 9014 , string(j) )
	if msg = 1 then 
		f_update()
	else
		
	end if 
	
else

	f_msgbox(9026)
	
end if
end event

type cb_2 from so_commandbutton within w_mcn_mold_buy_price_confirm
integer x = 3511
integer y = 132
integer width = 411
integer height = 104
integer taborder = 60
boolean bringtotop = true
string text = "All Cancel"
end type

event clicked;call super::clicked;long i
DATETIME lvdt_null
SETNULL(lvdt_null)
do
	i++
	if dw_1.object.check_yn[i] = 'Y' then 
	else
		continue
	end if
	
	dw_1.object.price_change_confirm_yn[i] = 'N'
		dw_1.object.confirm_by[I] = ''
		dw_1.object.confirm_date[I] = lvdt_null	
	
loop until i = dw_1.rowcount()
end event

type rb_wait from so_radiobutton within w_mcn_mold_buy_price_confirm
integer x = 2459
integer y = 80
boolean bringtotop = true
integer weight = 700
string text = "Wait"
boolean checked = true
end type

type rb_confirmed from so_radiobutton within w_mcn_mold_buy_price_confirm
integer x = 2459
integer y = 184
boolean bringtotop = true
integer weight = 700
string text = "Confirmed"
end type

type gb_2 from so_groupbox within w_mcn_mold_buy_price_confirm
integer y = 4
integer width = 2359
integer height = 300
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_mcn_mold_buy_price_confirm
integer x = 3040
integer width = 951
integer height = 300
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

