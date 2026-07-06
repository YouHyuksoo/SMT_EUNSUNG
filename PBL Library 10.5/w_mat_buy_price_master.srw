HA$PBExportHeader$w_mat_buy_price_master.srw
$PBExportComments$Material Buy Price Master
forward
global type w_mat_buy_price_master from w_main_root
end type
type st_1 from so_statictext within w_mat_buy_price_master
end type
type ddlb_item_code from uo_item_code within w_mat_buy_price_master
end type
type ddlb_supplier_code from uo_supplier_code within w_mat_buy_price_master
end type
type st_3 from so_statictext within w_mat_buy_price_master
end type
type gb_1 from so_groupbox within w_mat_buy_price_master
end type
type st_14 from so_statictext within w_mat_buy_price_master
end type
type sle_item_name from so_singlelineedit within w_mat_buy_price_master
end type
type sle_1 from so_singlelineedit within w_mat_buy_price_master
end type
type st_4 from so_statictext within w_mat_buy_price_master
end type
type tab_1 from tab within w_mat_buy_price_master
end type
type tabpage_1 from userobject within tab_1
end type
type rb_4 from so_radiobutton within tabpage_1
end type
type rb_3 from so_radiobutton within tabpage_1
end type
type rb_2 from so_radiobutton within tabpage_1
end type
type rb_1 from so_radiobutton within tabpage_1
end type
type pb_2 from so_commandbutton within tabpage_1
end type
type cbx_item_buy_price_auto_confirm from so_checkbox within tabpage_1
end type
type cb_close from so_commandbutton within tabpage_1
end type
type cb_copy from so_commandbutton within tabpage_1
end type
type st_2 from so_statictext within tabpage_1
end type
type uo_close_date from uo_ymd_calendar within tabpage_1
end type
type pb_1 from so_commandbutton within tabpage_1
end type
type gb_2 from so_groupbox within tabpage_1
end type
type tabpage_1 from userobject within tab_1
rb_4 rb_4
rb_3 rb_3
rb_2 rb_2
rb_1 rb_1
pb_2 pb_2
cbx_item_buy_price_auto_confirm cbx_item_buy_price_auto_confirm
cb_close cb_close
cb_copy cb_copy
st_2 st_2
uo_close_date uo_close_date
pb_1 pb_1
gb_2 gb_2
end type
type tabpage_2 from userobject within tab_1
end type
type cb_3 from so_commandbutton within tabpage_2
end type
type ddlb_from_org from uo_orz_id within tabpage_2
end type
type ddlb_to_org from uo_orz_id within tabpage_2
end type
type st_9 from so_statictext within tabpage_2
end type
type st_8 from so_statictext within tabpage_2
end type
type tabpage_2 from userobject within tab_1
cb_3 cb_3
ddlb_from_org ddlb_from_org
ddlb_to_org ddlb_to_org
st_9 st_9
st_8 st_8
end type
type tabpage_3 from userobject within tab_1
end type
type st_17 from so_statictext within tabpage_3
end type
type cb_2 from so_commandbutton within tabpage_3
end type
type st_5 from so_statictext within tabpage_3
end type
type ddlb_after_supplier from uo_supplier_code within tabpage_3
end type
type ddlb_before_supplier from uo_supplier_code within tabpage_3
end type
type st_6 from so_statictext within tabpage_3
end type
type tabpage_3 from userobject within tab_1
st_17 st_17
cb_2 cb_2
st_5 st_5
ddlb_after_supplier ddlb_after_supplier
ddlb_before_supplier ddlb_before_supplier
st_6 st_6
end type
type tabpage_4 from userobject within tab_1
end type
type cb_1 from so_commandbutton within tabpage_4
end type
type tabpage_4 from userobject within tab_1
cb_1 cb_1
end type
type tabpage_5 from userobject within tab_1
end type
type cb_4 from so_commandbutton within tabpage_5
end type
type st_16 from so_statictext within tabpage_5
end type
type st_15 from so_statictext within tabpage_5
end type
type uo_dateend from uo_ymd_calendar within tabpage_5
end type
type uo_dateset from uo_ymd_calendar within tabpage_5
end type
type st_12 from so_statictext within tabpage_5
end type
type st_11 from so_statictext within tabpage_5
end type
type st_10 from so_statictext within tabpage_5
end type
type st_7 from so_statictext within tabpage_5
end type
type sle_line_type from so_singlelineedit within tabpage_5
end type
type ddlb_new_line_type from uo_line_type within tabpage_5
end type
type sle_item_code from so_singlelineedit within tabpage_5
end type
type sle_supplier_code from so_singlelineedit within tabpage_5
end type
type tabpage_5 from userobject within tab_1
cb_4 cb_4
st_16 st_16
st_15 st_15
uo_dateend uo_dateend
uo_dateset uo_dateset
st_12 st_12
st_11 st_11
st_10 st_10
st_7 st_7
sle_line_type sle_line_type
ddlb_new_line_type ddlb_new_line_type
sle_item_code sle_item_code
sle_supplier_code sle_supplier_code
end type
type tabpage_6 from userobject within tab_1
end type
type cbx_rate from checkbox within tabpage_6
end type
type st_19 from so_statictext within tabpage_6
end type
type uo_apply_date from uo_ymd_calendar within tabpage_6
end type
type rb_decreease from so_radiobutton within tabpage_6
end type
type rb_increase from so_radiobutton within tabpage_6
end type
type em_discount from so_editmask within tabpage_6
end type
type cb_5 from so_commandbutton within tabpage_6
end type
type tabpage_6 from userobject within tab_1
cbx_rate cbx_rate
st_19 st_19
uo_apply_date uo_apply_date
rb_decreease rb_decreease
rb_increase rb_increase
em_discount em_discount
cb_5 cb_5
end type
type tab_1 from tab within w_mat_buy_price_master
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_6 tabpage_6
end type
type ddlb_line_type from uo_line_type within w_mat_buy_price_master
end type
type st_13 from so_statictext within w_mat_buy_price_master
end type
type ddlb_item_division from uo_item_division within w_mat_buy_price_master
end type
type st_18 from so_statictext within w_mat_buy_price_master
end type
type sle_2 from so_singlelineedit within w_mat_buy_price_master
end type
type st_20 from so_statictext within w_mat_buy_price_master
end type
type ddlb_price_type from uo_basecode within w_mat_buy_price_master
end type
type st_21 from so_statictext within w_mat_buy_price_master
end type
type uo_start_date from uo_ymd_calendar within w_mat_buy_price_master
end type
type st_22 from so_statictext within w_mat_buy_price_master
end type
type mle_1 from multilineedit within w_mat_buy_price_master
end type
end forward

global type w_mat_buy_price_master from w_main_root
integer width = 4384
integer height = 2656
string title = "Material Buy Price Master"
st_1 st_1
ddlb_item_code ddlb_item_code
ddlb_supplier_code ddlb_supplier_code
st_3 st_3
gb_1 gb_1
st_14 st_14
sle_item_name sle_item_name
sle_1 sle_1
st_4 st_4
tab_1 tab_1
ddlb_line_type ddlb_line_type
st_13 st_13
ddlb_item_division ddlb_item_division
st_18 st_18
sle_2 sle_2
st_20 st_20
ddlb_price_type ddlb_price_type
st_21 st_21
uo_start_date uo_start_date
st_22 st_22
mle_1 mle_1
end type
global w_mat_buy_price_master w_mat_buy_price_master

on w_mat_buy_price_master.create
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
this.tab_1=create tab_1
this.ddlb_line_type=create ddlb_line_type
this.st_13=create st_13
this.ddlb_item_division=create ddlb_item_division
this.st_18=create st_18
this.sle_2=create sle_2
this.st_20=create st_20
this.ddlb_price_type=create ddlb_price_type
this.st_21=create st_21
this.uo_start_date=create uo_start_date
this.st_22=create st_22
this.mle_1=create mle_1
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
this.Control[iCurrent+10]=this.tab_1
this.Control[iCurrent+11]=this.ddlb_line_type
this.Control[iCurrent+12]=this.st_13
this.Control[iCurrent+13]=this.ddlb_item_division
this.Control[iCurrent+14]=this.st_18
this.Control[iCurrent+15]=this.sle_2
this.Control[iCurrent+16]=this.st_20
this.Control[iCurrent+17]=this.ddlb_price_type
this.Control[iCurrent+18]=this.st_21
this.Control[iCurrent+19]=this.uo_start_date
this.Control[iCurrent+20]=this.st_22
this.Control[iCurrent+21]=this.mle_1
end on

on w_mat_buy_price_master.destroy
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
destroy(this.tab_1)
destroy(this.ddlb_line_type)
destroy(this.st_13)
destroy(this.ddlb_item_division)
destroy(this.st_18)
destroy(this.sle_2)
destroy(this.st_20)
destroy(this.ddlb_price_type)
destroy(this.st_21)
destroy(this.uo_start_date)
destroy(this.st_22)
destroy(this.mle_1)
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

event ue_post_open;call super::ue_post_open;

/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

event ue_data_control;call super::ue_data_control;long row
choose case gvs_ue_data_control
		
	case 'RETRIEVE'
			
			dw_1.reset()
			dw_1.retrieve(ddlb_item_code.text + '%', ddlb_supplier_code.text + '%', ddlb_line_type.getcode()+'%' ,ddlb_item_division.getcode( )+'%',  ddlb_price_type.getcode()+'%' ,   gvi_organization_id)
		
	case 'INSERT'
		
		    DW_2.RESET()
			DW_2.ENABLED = TRUE
			ROW = DW_2.INSERTROW(DW_2.GETROW())
			DW_2.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')
			dw_2.object.dateset[row] = f_t_sysdate()
			dw_2.object.dateend[row] = date('2999-12-31')
			dw_2.object.price_type[row] = 'F'
			dw_2.object.price_change_reason[row] = 'N'						
			dw_2.object.delivery[row] = '2'									
			dw_2.object.currency[row] = Gvs_currency
			
			IF Gvs_item_buy_price_auto_confirm = 'Y' then
				dw_2.object.price_change_confirm_yn[row] = 'Y'									
				dw_2.object.confirm_by[row] = Gvs_user_id
				dw_2.object.confirm_date[row] = f_t_sysdate()			
			else
				dw_2.object.price_change_confirm_yn[row] = 'N'													
			end if
			
	case 'APPEND'		
		    DW_2.RESET()		
			DW_2.ENABLED = TRUE
			ROW = DW_2.INSERTROW(DW_2.GETROW())
			DW_2.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')
			dw_2.object.dateset[row] = f_t_sysdate()
			dw_2.object.dateend[row] = date('2999-12-31')
			dw_2.object.price_type[row] = 'F'
			dw_2.object.price_change_reason[row] = 'N'			
			dw_2.object.delivery[row] = '2'				
			dw_2.object.currency[row] = Gvs_currency			
			IF Gvs_item_buy_price_auto_confirm = 'Y' then
				dw_2.object.price_change_confirm_yn[row] = 'Y'									
				dw_2.object.confirm_by[row] = Gvs_user_id
				dw_2.object.confirm_date[row] = f_t_sysdate()			
			else
				dw_2.object.price_change_confirm_yn[row] = 'N'													
			end if
			
	case 'DELETE'
		
		  	if DW_2.AcceptText() = -1 then
				return
			end if
			
			if Gvs_item_buy_price_auto_confirm = 'Y' then
			else
			
				if dw_2.object.price_change_confirm_yn[dw_2.getrow()] = 'Y' then
					Messagebox("Notify" , "Aready Confirmed Can`t Delete")
					return
				end if
			end if 
			
			MSG = F_MSGBOX(1003)  //$$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?
			IF MSG = 1 THEN
				  					
                dw_2.deleterow( dw_2.getrow( ) )
					 
				IF DW_2.UPDATE() < 0  THEN
					 ROLLBACK;
					 RETURN
				ELSE				  			 
					COMMIT;
					 F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
					 F_RETRIEVE()							 
				END IF
			END IF
			
	case 'UPDATE'
		
		
			IF DW_1.UPDATE() < 0  THEN
			  	 ROLLBACK;
			      RETURN
			END IF 
		   //=======================================================
		   //	
		   //=======================================================			
			IF DW_2.UPDATE() < 0  THEN
			  	 ROLLBACK;
			      RETURN
			ELSE
				
				 IF DW_2.GETROW() < 1 THEN 
						COMMIT;
						F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
				
				 ELSE
				
					IF F_CHECK_UNIT_PRICE_DUP( dw_2.object.item_code[dw_2.getrow()] , GVI_ORGANIZATION_ID)  < 0 THEN 
						Rollback;
						Messagebox( "Notify" , string(dw_2.object.item_code[dw_2.getrow()] ) + " Unit Price Duplicate Please Check Dateset !")
						Return
					END IF
				
					COMMIT;
					F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
				END IF
				
							 
			END IF

	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_mat_buy_price_master
integer y = 608
end type

type dw_4 from w_main_root`dw_4 within w_mat_buy_price_master
integer y = 608
end type

type dw_3 from w_main_root`dw_3 within w_mat_buy_price_master
integer y = 608
end type

type dw_2 from w_main_root`dw_2 within w_mat_buy_price_master
integer y = 1724
integer width = 4334
integer height = 524
string dataobject = "d_mat_buy_price_mst"
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

event dw_2::itemchanged;call super::itemchanged;string lvs_return
if dwo.name = 'supplier_code' then 
	lvs_return = f_get_supplier_name(data , gvi_organization_id)
	if lvs_return = 'ERROR' then 
		return 1 
	end if  
	if lvs_return = 'NOTFOUND' then 
		return 1 
	end if
	
	this.object.supplier_name[row] = lvs_return 
end if 

if dwo.name = 'item_code' then 
	
     lvs_return = f_set_item_name_spec_uom( this , row , this.object.item_code[row] )		

	if 	lvs_return = 'ERROR' THEN 
		return 1
	end if	
		
	if lvs_return = 'NOTFOUND' then 
		return 1  
	end if 		
end if

if dwo.name = 'line_type' then
	
	if data = 'G' then 
		this.object.currency[row] = Gvs_currency
	end if 
	
end if 
end event

event dw_2::rbuttondown;call super::rbuttondown;if dwo.name = 'supplier_code' then 
	open(w_com_supplier_popup)
	if message.stringparm = '' then 
	else
		this.object.supplier_code[row] = message.stringparm
		IF ivs_modify_security = 'Y' THEN 
			F_SET_SECURITY_ROW( THIS , ROW , 'MODIFY' )
		END IF		
		this.trigger event itemchanged(row, this.object.supplier_code, this.object.supplier_code[row])
		
	end if
end if 
if dwo.name = 'item_code' then 
	open(w_mat_item_popup)
	if gst_return.gvb_return = false then 
	else
		this.object.item_code[row] = gst_return.gvs_return[1] 
		this.object.item_name[row] = gst_return.gvs_return[2] 
		this.object.item_spec[row] = gst_return.gvs_return[3] 
		this.object.supplier_code[row] = gst_return.gvs_return[4] 
		this.object.supplier_name[row] = gst_return.gvs_return[5] 
		this.object.line_type[row] = gst_return.gvs_return[6] 
		this.object.item_uom[row] = gst_return.gvs_return[7] 		
		IF ivs_modify_security = 'Y' THEN 
			F_SET_SECURITY_ROW( THIS , ROW , 'MODIFY' )
		END IF		
	end if 
	gst_return.gvs_return[1] = ''
	gst_return.gvs_return[2] = ''
	gst_return.gvs_return[3] = ''
	gst_return.gvs_return[4] = ''
	gst_return.gvs_return[5] = ''
	gst_return.gvs_return[6] = ''
	gst_return.gvs_return[7] = ''	
end if 
		
		
end event

type dw_1 from w_main_root`dw_1 within w_mat_buy_price_master
integer y = 600
integer width = 4329
integer height = 1112
boolean titlebar = true
string title = "Material Buy Price List"
string dataobject = "d_mat_buy_price_lst_tree"
end type

event dw_1::doubleclicked;call super::doubleclicked;IF ROW < 1  THEN RETURN
DW_2.RETRIEVE( DW_1.GETITEMSTRING( ROW , 'ROWID' ) )

if dw_1.object.price_change_confirm_yn[row] = 'Y' then
    dw_2.enabled = False
else
	dw_2.enabled = True
end if 
end event

event dw_1::rbuttondown;call super::rbuttondown;if dwo.name = 'supplier_code' then 
	open(w_com_supplier_popup)
	if message.stringparm = '' then 
	else
		this.object.supplier_code[row] = message.stringparm
		IF ivs_modify_security = 'Y' THEN 
			F_SET_SECURITY_ROW( THIS , ROW , 'MODIFY' )
		END IF		
		this.trigger event itemchanged(row, this.object.supplier_code, this.object.supplier_code[row])
		
	end if
end if 
end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;IF currentrow = 0 THEN RETURN
DW_2.RETRIEVE( DW_1.GETITEMSTRING( currentrow , 'ROWID' ) )

if dw_1.object.price_change_confirm_yn[currentrow] = 'Y' then
	DW_2.enabled = False
else
	DW_2.enabled = True
end if 

tab_1.tabpage_5.sle_supplier_code.text = this.object.supplier_code[currentrow]
tab_1.tabpage_5.sle_item_code.text = this.object.item_code[currentrow]
tab_1.tabpage_5.sle_line_type.text = this.object.line_type[currentrow]

tab_1.tabpage_5.uo_dateset.settext(STRING(this.object.dateset[currentrow]))
tab_1.tabpage_5.uo_dateend.settext(STRING(this.object.dateend[currentrow]))

end event

type uo_tabpages from w_main_root`uo_tabpages within w_mat_buy_price_master
end type

type st_1 from so_statictext within w_mat_buy_price_master
integer x = 41
integer y = 100
integer width = 539
integer height = 60
boolean bringtotop = true
string text = "Item Code"
end type

type ddlb_item_code from uo_item_code within w_mat_buy_price_master
integer x = 41
integer y = 176
integer width = 539
integer taborder = 20
boolean bringtotop = true
end type

type ddlb_supplier_code from uo_supplier_code within w_mat_buy_price_master
integer x = 590
integer y = 176
integer width = 448
integer taborder = 20
boolean bringtotop = true
end type

type st_3 from so_statictext within w_mat_buy_price_master
integer x = 590
integer y = 100
integer width = 448
integer height = 60
boolean bringtotop = true
string text = "Supplier Code"
end type

type gb_1 from so_groupbox within w_mat_buy_price_master
integer y = 4
integer width = 4334
integer height = 300
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type st_14 from so_statictext within w_mat_buy_price_master
integer x = 2939
integer y = 100
integer width = 462
integer height = 60
boolean bringtotop = true
long textcolor = 16711680
string text = "Item Name"
end type

type sle_item_name from so_singlelineedit within w_mat_buy_price_master
integer x = 2939
integer y = 176
integer width = 462
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

dw_1.SETFILTER('')
dw_1.FILTER()

LVS_COLUMN = 'ITEM_NAME'
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

type sle_1 from so_singlelineedit within w_mat_buy_price_master
integer x = 3410
integer y = 176
integer width = 375
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

dw_1.SETFILTER('')
dw_1.FILTER()

LVS_COLUMN = 'ITEM_SPEC'
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

type st_4 from so_statictext within w_mat_buy_price_master
integer x = 3410
integer y = 100
integer width = 375
integer height = 60
boolean bringtotop = true
long textcolor = 16711680
string text = "Item Spec"
end type

type tab_1 from tab within w_mat_buy_price_master
integer y = 312
integer width = 3785
integer height = 288
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean fixedwidth = true
boolean raggedright = true
boolean focusonbuttondown = true
boolean powertips = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_6 tabpage_6
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.tabpage_5=create tabpage_5
this.tabpage_6=create tabpage_6
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4,&
this.tabpage_5,&
this.tabpage_6}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
destroy(this.tabpage_5)
destroy(this.tabpage_6)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3749
integer height = 160
long backcolor = 15780518
string text = "Process"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Regenerate5!"
long picturemaskcolor = 12632256
rb_4 rb_4
rb_3 rb_3
rb_2 rb_2
rb_1 rb_1
pb_2 pb_2
cbx_item_buy_price_auto_confirm cbx_item_buy_price_auto_confirm
cb_close cb_close
cb_copy cb_copy
st_2 st_2
uo_close_date uo_close_date
pb_1 pb_1
gb_2 gb_2
end type

on tabpage_1.create
this.rb_4=create rb_4
this.rb_3=create rb_3
this.rb_2=create rb_2
this.rb_1=create rb_1
this.pb_2=create pb_2
this.cbx_item_buy_price_auto_confirm=create cbx_item_buy_price_auto_confirm
this.cb_close=create cb_close
this.cb_copy=create cb_copy
this.st_2=create st_2
this.uo_close_date=create uo_close_date
this.pb_1=create pb_1
this.gb_2=create gb_2
this.Control[]={this.rb_4,&
this.rb_3,&
this.rb_2,&
this.rb_1,&
this.pb_2,&
this.cbx_item_buy_price_auto_confirm,&
this.cb_close,&
this.cb_copy,&
this.st_2,&
this.uo_close_date,&
this.pb_1,&
this.gb_2}
end on

on tabpage_1.destroy
destroy(this.rb_4)
destroy(this.rb_3)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.pb_2)
destroy(this.cbx_item_buy_price_auto_confirm)
destroy(this.cb_close)
destroy(this.cb_copy)
destroy(this.st_2)
destroy(this.uo_close_date)
destroy(this.pb_1)
destroy(this.gb_2)
end on

type rb_4 from so_radiobutton within tabpage_1
integer x = 389
integer y = 60
integer width = 425
integer height = 64
boolean bringtotop = true
long backcolor = 15780518
string text = "Running  Only"
end type

event clicked;call super::clicked;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

LVS_COLUMN = "STATUS"

IF ISNULL(LVS_COLUMN) OR LEN(LVS_COLUMN) = 0 THEN RETURN 

DW_1.SETFILTER('')
DW_1.FILTER()

IF THIS.TEXT = '' THEN 
	DW_1.SETFILTER('')
	DW_1.FILTER()
	RETURN
END IF

DW_1.SETFILTER( LVS_COLUMN  +" = 'RUNNING'")
DW_1.FILTER()
F_MSG_MDI_HELP( STRING( DW_1.ROWCOUNT() ) + " Found")

DW_1.Sort( )
end event

type rb_3 from so_radiobutton within tabpage_1
integer x = 46
integer y = 64
integer width = 320
integer height = 64
boolean bringtotop = true
long backcolor = 15780518
string text = "All"
boolean checked = true
end type

event clicked;call super::clicked;DW_1.SETFILTER('')
DW_1.FILTER()


end event

type rb_2 from so_radiobutton within tabpage_1
integer x = 361
integer y = 364
integer width = 425
integer height = 64
boolean bringtotop = true
string text = "Running  Only"
end type

event clicked;call super::clicked;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

LVS_COLUMN = "STATUS"

IF ISNULL(LVS_COLUMN) OR LEN(LVS_COLUMN) = 0 THEN RETURN 

DW_1.SETFILTER('')
DW_1.FILTER()

IF THIS.TEXT = '' THEN 
	DW_1.SETFILTER('')
	DW_1.FILTER()
	RETURN
END IF

DW_1.SETFILTER( LVS_COLUMN  +" = 'RUNNING'")
DW_1.FILTER()
F_MSG_MDI_HELP( STRING( DW_1.ROWCOUNT() ) + " Found")

DW_1.Sort( )
end event

type rb_1 from so_radiobutton within tabpage_1
integer x = 37
integer y = 368
integer width = 425
integer height = 64
boolean bringtotop = true
string text = "All"
boolean checked = true
end type

event clicked;call super::clicked;DW_1.SETFILTER('')
DW_1.FILTER()


end event

type pb_2 from so_commandbutton within tabpage_1
integer x = 3067
integer y = 12
integer width = 562
integer taborder = 60
boolean bringtotop = true
string text = "Import From Excel"
end type

event clicked;call super::clicked;open(w_mat_material_unit_price_excel_form_popup)
end event

type cbx_item_buy_price_auto_confirm from so_checkbox within tabpage_1
integer x = 2606
integer y = 40
integer weight = 700
long backcolor = 15780518
boolean enabled = false
string text = "Auto Confirm"
end type

event constructor;call super::constructor;if Gvs_item_buy_price_auto_confirm = 'Y' then 
	this.checked = true
else
	this.checked = false
end if
end event

type cb_close from so_commandbutton within tabpage_1
integer x = 1691
integer y = 20
integer width = 379
integer taborder = 40
boolean bringtotop = true
string text = "Price Close"
end type

event clicked;call super::clicked;if f_object_role_check() = false then return 
if dw_2.rowcount() < 1  then return 
datetime lvdt_close_date ,  lvdt_dateset,  lvdt_dateend 
lvdt_close_date = uo_close_date.text()
lvdt_dateset = dw_2.object.dateset[1]
lvdt_dateend = dw_2.object.dateend[1]
if lvdt_close_date > lvdt_dateset   and  lvdt_close_date < lvdt_dateend   then 
	dw_2.object.dateend[1] = lvdt_close_date
else
	messagebox('Notify','The close date is invalid!')
	return 
end if 

end event

type cb_copy from so_commandbutton within tabpage_1
integer x = 1294
integer y = 20
integer width = 379
integer taborder = 40
boolean bringtotop = true
string text = "Price Copy"
end type

event clicked;call super::clicked;Datetime lvdt_null
setnull(lvdt_null)
if f_object_role_check() = false then return 

msg = f_msgbox1(1161 , this.text)
if msg = 1 then 
else
	return
end if

if dw_2.rowcount() < 1 then return 
dw_2.rowscopy(1, 1, Primary!, dw_2, 1, Primary!)
dw_2.object.dateset[1] = f_t_sysdate()
dw_2.object.dateend[1] = date('2999-12-31')
dw_2.object.unit_price[1] = 0 

dw_2.object.price_change_confirm_yn[1] = 'N'
dw_2.object.confirm_date[1] = lvdt_null

dw_2.enabled = true
end event

type st_2 from so_statictext within tabpage_1
integer x = 873
integer y = 16
integer width = 407
integer height = 60
boolean bringtotop = true
long backcolor = 15780518
string text = "Close Date"
end type

type uo_close_date from uo_ymd_calendar within tabpage_1
integer x = 873
integer y = 72
integer taborder = 40
boolean bringtotop = true
end type

on uo_close_date.destroy
call uo_ymd_calendar::destroy
end on

type pb_1 from so_commandbutton within tabpage_1
integer x = 2089
integer y = 20
integer width = 379
integer taborder = 50
string text = "Price Check"
end type

event clicked;call super::clicked;string lvs_item_code , lvs_item_code_inc

declare cl1 cursor for
select item_code 
 from im_item_unit_price 
where dateset <= trunc(sysdate)
    and dateend >= trunc(sysdate)
    and organization_id = :gvi_organization_id 
group by supplier_code , item_code , line_type , organization_id
having count(*) > 1  ;	 
	 
open cl1 ;

do 
	fetch cl1 into :lvs_item_code  ;
	
	if f_sql_check() < 0 then 
		close cl1;
		exit
	end if 
	
	if sqlca.sqlcode = 100 then 
		close cl1 ;
		exit
	end if 
	
	lvs_item_code_inc = lvs_item_code_inc + lvs_item_code+'~r~n'
	
loop until 1 =2

if lvs_item_code_inc = '' or isnull(lvs_item_code_inc) then 
	
	f_msgbox(117) 
	
else
	mle_1.text = lvs_item_code_inc
	messagebox("Check" , lvs_item_code_inc ) 
	
end if 
end event

type gb_2 from so_groupbox within tabpage_1
integer y = 304
integer width = 855
integer height = 156
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Filter"
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3749
integer height = 160
long backcolor = 15780518
string text = "Tranfer"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "UpdateReturn!"
long picturemaskcolor = 12632256
cb_3 cb_3
ddlb_from_org ddlb_from_org
ddlb_to_org ddlb_to_org
st_9 st_9
st_8 st_8
end type

on tabpage_2.create
this.cb_3=create cb_3
this.ddlb_from_org=create ddlb_from_org
this.ddlb_to_org=create ddlb_to_org
this.st_9=create st_9
this.st_8=create st_8
this.Control[]={this.cb_3,&
this.ddlb_from_org,&
this.ddlb_to_org,&
this.st_9,&
this.st_8}
end on

on tabpage_2.destroy
destroy(this.cb_3)
destroy(this.ddlb_from_org)
destroy(this.ddlb_to_org)
destroy(this.st_9)
destroy(this.st_8)
end on

type cb_3 from so_commandbutton within tabpage_2
integer x = 5
integer y = 76
integer width = 581
integer height = 84
integer taborder = 80
boolean bringtotop = true
string text = "Sync Price"
end type

event clicked;call super::clicked;LONG  i
INT LVI_FROM_ORG , LVI_TO_ORG , lvi_count
STRING LVS_ROWID , lvs_supplier_code , lvs_own_supplier_code , lvs_item_code , lvs_line_type , lvs_delivery , lvs_currency
STRING lvs_price_type , lvs_approval_no , lvs_confirm_by , lvs_confirm_yn
DATETIME lvdt_dateset , lvdt_dateend
DECIMAL lvf_std_price , lvf_unit_price , lvf_tax_rate


LVI_FROM_ORG = INTEGER( DDLB_FROM_ORG.GETCODE( ) )
LVI_TO_ORG = INTEGER( DDLB_TO_ORG.GETCODE( ) )

if dw_1.getrow( ) = 0 then 
	return
end if

msg = f_msgbox1( 1161 , this.text)
if msg = 1 then
else
	return
end if

do
	i++
	if dw_1.object.check_yn[i] = 'Y' then 
		
			lvs_supplier_code	= dw_1.object.supplier_code[i]
			lvs_item_code = dw_1.object.item_code[i]
			lvs_line_type   = dw_1.object.line_type[i]
			lvs_delivery = dw_1.object.delivery[i]
			lvs_currency= dw_1.object.currency[i]
			lvs_price_type = dw_1.object.price_type[i]
			lvs_approval_no= dw_1.object.approval_no[i]
			lvs_confirm_by = dw_1.object.confirm_by[i]
			lvs_confirm_yn= dw_1.object.price_change_confirm_yn[i]
			lvdt_dateset = dw_1.object.dateset[i]
			lvdt_dateend= dw_1.object.dateend[i]
			lvf_std_price = dw_1.object.standard_unit_price[i]
			lvf_unit_price = dw_1.object.unit_price[i]
			lvf_tax_rate		 = dw_1.object.tax_rate[i]
		 
	else
		continue
	end if
	
	if isnull(LVS_ROWID) then
		continue
	end if
	
	lvs_own_supplier_code = f_get_supplier_code_oneself(gvi_organization_id)
	
	if isnull(lvs_own_supplier_code) then 
		Messagebox("Notify" , "Own`s Supplier Code Not Found!")
		return
	end if
	
	select count(*) into :lvi_count 
	  from icom_supplier
    where supplier_code = :lvs_own_supplier_code
	   and organization_id = 	:LVI_TO_ORG ;
	
	if lvi_count < 1 then 
		Messagebox("Notify" ,lvs_own_supplier_code+ "  Supplier code not found from Organization ID="+string(LVI_TO_ORG))
		return
	end if
	
	//====================================
	//
	//====================================	
	select count(*) into :lvi_count 
	  from im_item_unit_price
     where supplier_code = :lvs_own_supplier_code
	    and item_code       = :lvs_item_code
	    and line_type         = 'N'
	    and dateset <= trunc(sysdate)
	    and dateend >= trunc(sysdate)
	    and organization_id = :LVI_TO_ORG ;
	
	IF F_SQL_CHECK() < 0 THEN 
		RETURN
	END IF 
	
	if lvi_count > 0 then 
		Messagebox("Notify" , lvs_own_supplier_code+"  "+lvs_item_code+" Aready Exists!")
		CONTINUE
	end if 
	
  INSERT INTO "IM_ITEM_UNIT_PRICE"  
         ( "DATESET",   
           "ITEM_CODE",   
           "SUPPLIER_CODE",   
           "LINE_TYPE",   
           "ORGANIZATION_ID",   
           "DELIVERY",   
           "CURRENCY",   
           "UNIT_PRICE",   
           "TAX_RATE",   
           "PRICE_TYPE",   
           "APPROVAL_NO",   
           "STANDARD_UNIT_PRICE",   
           "DATEEND",   
           "PRICE_CHANGE_REASON",   
           "CONFIRM_BY",   
           "PRICE_CHANGE_CONFIRM_YN",   
           "CONFIRM_DATE",   
           "ENTER_DATE",   
           "ENTER_BY",   
           "LAST_MODIFY_DATE",   
           "LAST_MODIFY_BY" ) 
values( :lvdt_dateset , //"IM_ITEM_UNIT_PRICE"."DATESET",   
            :lvs_item_code , //"IM_ITEM_UNIT_PRICE"."ITEM_CODE",   
            :lvs_own_supplier_code , //"IM_ITEM_UNIT_PRICE"."SUPPLIER_CODE",   
            'N' , //"IM_ITEM_UNIT_PRICE"."LINE_TYPE",   $$HEX5$$b4b080bd70ac98b72000$$ENDHEX$$
            :LVI_TO_ORG , //"IM_ITEM_UNIT_PRICE"."ORGANIZATION_ID",   
            :lvs_delivery , //"IM_ITEM_UNIT_PRICE"."DELIVERY",   
            :lvs_currency , //"IM_ITEM_UNIT_PRICE"."CURRENCY",   
            :lvf_unit_price , //"IM_ITEM_UNIT_PRICE"."UNIT_PRICE",   
            :lvf_tax_rate , //"IM_ITEM_UNIT_PRICE"."TAX_RATE",   
            :lvs_price_type , //"IM_ITEM_UNIT_PRICE"."PRICE_TYPE",   
            :lvs_approval_no , //"IM_ITEM_UNIT_PRICE"."APPROVAL_NO",   
            :lvf_std_price , //"IM_ITEM_UNIT_PRICE"."STANDARD_UNIT_PRICE",   
            :lvdt_dateend , //"IM_ITEM_UNIT_PRICE"."DATEEND",   
            'T' , //"IM_ITEM_UNIT_PRICE"."PRICE_CHANGE_REASON",   
            :lvs_confirm_by , //"IM_ITEM_UNIT_PRICE"."CONFIRM_BY",   
            :lvs_confirm_yn , //"IM_ITEM_UNIT_PRICE"."PRICE_CHANGE_CONFIRM_YN",   
            sysdate,   
            sysdate,   
            :Gvs_user_id,   
            sysdate,   
            :gvs_user_id  
  ) ;
	IF F_SQL_CHECK() < 0 THEN 
		RETURN
	END IF 

loop until i = dw_1.rowcount( )
	  
MSG = F_MSGBOX1( 9014  , String(sqlca.sqlnrows) )
IF MSG = 1 THEN 
	COMMIT ;
ELSE
	ROLLBACK;
END IF
end event

type ddlb_from_org from uo_orz_id within tabpage_2
integer x = 594
integer y = 76
integer width = 603
integer taborder = 50
boolean bringtotop = true
end type

type ddlb_to_org from uo_orz_id within tabpage_2
integer x = 1207
integer y = 76
integer width = 603
integer taborder = 60
boolean bringtotop = true
end type

type st_9 from so_statictext within tabpage_2
integer x = 1207
integer y = 20
integer width = 590
integer height = 60
boolean bringtotop = true
integer weight = 700
long backcolor = 15780518
string text = "To"
end type

type st_8 from so_statictext within tabpage_2
integer x = 599
integer y = 16
integer width = 603
integer height = 60
boolean bringtotop = true
integer weight = 700
long backcolor = 15780518
string text = "From"
end type

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3749
integer height = 160
long backcolor = 15780518
string text = "Supplier Change"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Custom046!"
long picturemaskcolor = 12632256
st_17 st_17
cb_2 cb_2
st_5 st_5
ddlb_after_supplier ddlb_after_supplier
ddlb_before_supplier ddlb_before_supplier
st_6 st_6
end type

on tabpage_3.create
this.st_17=create st_17
this.cb_2=create cb_2
this.st_5=create st_5
this.ddlb_after_supplier=create ddlb_after_supplier
this.ddlb_before_supplier=create ddlb_before_supplier
this.st_6=create st_6
this.Control[]={this.st_17,&
this.cb_2,&
this.st_5,&
this.ddlb_after_supplier,&
this.ddlb_before_supplier,&
this.st_6}
end on

on tabpage_3.destroy
destroy(this.st_17)
destroy(this.cb_2)
destroy(this.st_5)
destroy(this.ddlb_after_supplier)
destroy(this.ddlb_before_supplier)
destroy(this.st_6)
end on

type st_17 from so_statictext within tabpage_3
integer x = 1842
integer y = 76
integer width = 745
integer height = 60
boolean bringtotop = true
integer weight = 700
long textcolor = 65535
long backcolor = 15780518
string text = "HELP: Check item for Change"
end type

type cb_2 from so_commandbutton within tabpage_3
integer x = 1353
integer y = 52
integer width = 462
integer height = 100
integer taborder = 50
boolean bringtotop = true
string text = "Supplier Change"
end type

event clicked;call super::clicked;STRING  LVS_AFTER_SUPPLIER , LVS_BEFORE_SUPPLIER , LVS_ITEM_CODE , LVS_SUPPLIER_CODE
Long i , LVI_COUNT
LVS_AFTER_SUPPLIER  = ddlb_after_supplier.text
LVS_BEFORE_SUPPLIER= ddlb_before_supplier.text

if LVS_BEFORE_SUPPLIER  = '' or LVS_BEFORE_SUPPLIER = '%' then
   Return
end if 

if LVS_AFTER_SUPPLIER  = '' or LVS_AFTER_SUPPLIER = '%' then
   Return
end if 

if LVS_AFTER_SUPPLIER =  LVS_BEFORE_SUPPLIER then
   Return
end if 

MSG = F_MSGBOX1( 1161 ,LVS_BEFORE_SUPPLIER+'  => '+ LVS_AFTER_SUPPLIER+'   ' +THIS.TEXT )
IF MSG = 1 THEN 
ELSE
	RETURN
END IF


//==================================================
//
//==================================================
DO
i++

	if dw_1.object.check_yn[i] = 'Y' then
		LVS_ITEM_CODE = dw_1.object.item_code[i]
		LVS_SUPPLIER_CODE = dw_1.object.supplier_code[i]
	else
		continue
	end if
	
	if LVS_SUPPLIER_CODE <> LVS_BEFORE_SUPPLIER then
		continue
	end if 

	SELECT COUNT(*) INTO :LVI_COUNT
	 FROM IM_ITEM_RECEIPT 
    WHERE SUPPLIER_CODE = :LVS_BEFORE_SUPPLIER
	   AND ITEM_CODE = :LVS_ITEM_CODE
	   AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
		
	IF F_SQL_CHECK() < 0 THEN 
		RETURN
	END IF		
	
	IF LVI_COUNT > 0 THEN 
		MESSAGEBOX("Notify" , "Aready Receipted Can`t Change!")
		CONTINUE
	ELSE
		
	END IF

UPDATE IM_ITEM_UNIT_PRICE SET SUPPLIER_CODE = :LVS_AFTER_SUPPLIER
  WHERE SUPPLIER_CODE   = :LVS_BEFORE_SUPPLIER
     AND ITEM_CODE             = :LVS_ITEM_CODE
	AND SUPPLIER_CODE     = :LVS_SUPPLIER_CODE
     AND DATESET <= TRUNC(SYSDATE)
     AND DATEEND >= TRUNC(SYSDATE)	  
     AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;

IF F_SQL_CHECK() < 0 THEN 
	RETURN
END IF

LOOP UNTIL i = dw_1.rowcount( )


MSG = F_MSGBOX( 1170 )

IF MSG = 1 THEN 
	COMMIT ;
	F_MSG_MDI_HELP( F_MSG_ST( 170) )
	f_retrieve()
ELSE
	ROLLBACK ;
END IF
end event

type st_5 from so_statictext within tabpage_3
integer x = 713
integer y = 12
integer width = 617
integer height = 60
boolean bringtotop = true
long backcolor = 15780518
string text = "After Supplier"
end type

type ddlb_after_supplier from uo_supplier_code within tabpage_3
integer x = 709
integer y = 72
integer width = 617
integer taborder = 50
boolean bringtotop = true
end type

type ddlb_before_supplier from uo_supplier_code within tabpage_3
integer x = 27
integer y = 72
integer width = 681
integer taborder = 60
boolean bringtotop = true
end type

type st_6 from so_statictext within tabpage_3
integer x = 27
integer y = 12
integer width = 667
integer height = 56
boolean bringtotop = true
long backcolor = 15780518
string text = "Before Supplier"
end type

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3749
integer height = 160
long backcolor = 12632256
string text = "Get New Item"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "New!"
long picturemaskcolor = 12632256
cb_1 cb_1
end type

on tabpage_4.create
this.cb_1=create cb_1
this.Control[]={this.cb_1}
end on

on tabpage_4.destroy
destroy(this.cb_1)
end on

type cb_1 from so_commandbutton within tabpage_4
integer x = 32
integer y = 32
integer height = 96
integer taborder = 30
string text = "Get New Item"
end type

event clicked;call super::clicked;STRING LVS_SUPPLIER_CODE , LVS_ITEM_CODE , lvs_line_type
LONG J
DECIMAL LVF_UNIT_PRICE
DECLARE CL1 CURSOR FOR 
SELECT 
           ITEM_CODE,   
           SUPPLIER_CODE,
		  buy_PRICE ,
		  line_type

 FROM ID_ITEM
WHERE (  ITEM_CODE , ORGANIZATION_ID ) 
  NOT IN ( SELECT  ITEM_CODE , ORGANIZATION_ID
                  FROM IM_ITEM_UNIT_PRICE
                WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID ) 
	AND LINE_TYPE <> 'T'
	AND ITEM_DIVISION IN ('R','B')
    AND ORGANIZATION_ID =  :GVI_ORGANIZATION_ID	;
	
	
OPEN CL1 ;

  
  DO
	
	FETCH CL1 INTO   :LVS_ITEM_CODE,   
					         :LVS_SUPPLIER_CODE,
							:LVF_UNIT_PRICE	,
							:lvs_line_type ;
			IF  F_SQL_CHECK() < 0 THEN 
			   CLOSE CL1 ;
			   RETURN
			END IF
	
	IF SQLCA.SQLCODE = 100 THEN 
		CLOSE CL1 ;
		EXIT
	END IF
  
  INSERT INTO IM_ITEM_UNIT_PRICE  
         ( DATESET,   
           ITEM_CODE,   
           SUPPLIER_CODE,   
           LINE_TYPE,   
           ORGANIZATION_ID,   
           DELIVERY,   
           CURRENCY,   
           UNIT_PRICE,   
           TAX_RATE,   
           PRICE_TYPE,   
           APPROVAL_NO,   
           STANDARD_UNIT_PRICE,   
           DATEEND,   
           PRICE_CHANGE_REASON,   
           CONFIRM_BY,   
           PRICE_CHANGE_CONFIRM_YN,
           CONFIRM_DATE,   
           ENTER_DATE,   
           ENTER_BY,   
           LAST_MODIFY_DATE,   
           LAST_MODIFY_BY )

VALUES ( TRUNC(SYSDATE) ,
           :LVS_ITEM_CODE,   
           :LVS_SUPPLIER_CODE,   
           :lvs_line_type , //'G',   
           :GVI_ORGANIZATION_ID,   
           '2',   
           :GVS_CURRENCY ,
           NVL(:LVF_UNIT_PRICE,0) ,
           0 ,
           'T' ,
           '' ,
           0 , 
           TO_DATE('99991231' , 'YYYYMMDD') ,
           'N',   
           '',
           'N' ,
           NULL ,
           SYSDATE ,
           :GVS_USER_ID ,
           SYSDATE ,
           :GVS_USER_ID) ;
		   
IF F_SQL_CHECK() < 0 THEN 
	CLOSE CL1 ;
	RETURN
END IF 
J++
LOOP UNTIL 1 =2 
	
MSG = F_MSGBOX1(9014 , STRING(J))
IF MSG = 1 THEN 
	COMMIT ;
ELSE
	ROLLBACK;
END IF
end event

type tabpage_5 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3749
integer height = 160
long backcolor = 12632256
string text = "Change Line Type"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Where!"
long picturemaskcolor = 12632256
cb_4 cb_4
st_16 st_16
st_15 st_15
uo_dateend uo_dateend
uo_dateset uo_dateset
st_12 st_12
st_11 st_11
st_10 st_10
st_7 st_7
sle_line_type sle_line_type
ddlb_new_line_type ddlb_new_line_type
sle_item_code sle_item_code
sle_supplier_code sle_supplier_code
end type

on tabpage_5.create
this.cb_4=create cb_4
this.st_16=create st_16
this.st_15=create st_15
this.uo_dateend=create uo_dateend
this.uo_dateset=create uo_dateset
this.st_12=create st_12
this.st_11=create st_11
this.st_10=create st_10
this.st_7=create st_7
this.sle_line_type=create sle_line_type
this.ddlb_new_line_type=create ddlb_new_line_type
this.sle_item_code=create sle_item_code
this.sle_supplier_code=create sle_supplier_code
this.Control[]={this.cb_4,&
this.st_16,&
this.st_15,&
this.uo_dateend,&
this.uo_dateset,&
this.st_12,&
this.st_11,&
this.st_10,&
this.st_7,&
this.sle_line_type,&
this.ddlb_new_line_type,&
this.sle_item_code,&
this.sle_supplier_code}
end on

on tabpage_5.destroy
destroy(this.cb_4)
destroy(this.st_16)
destroy(this.st_15)
destroy(this.uo_dateend)
destroy(this.uo_dateset)
destroy(this.st_12)
destroy(this.st_11)
destroy(this.st_10)
destroy(this.st_7)
destroy(this.sle_line_type)
destroy(this.ddlb_new_line_type)
destroy(this.sle_item_code)
destroy(this.sle_supplier_code)
end on

type cb_4 from so_commandbutton within tabpage_5
integer x = 2610
integer y = 20
integer taborder = 40
string text = "Change Line Type"
end type

event clicked;call super::clicked;msg = f_msgbox1(1161 , this.text )
if msg = 1 then 
else
	return
end if

string lvs_supplier_code ,lvs_item_code ,  lvs_line_type , lvs_new_line_type
datetime lvdt_dateset , lvdt_dateend

lvs_supplier_code = sle_supplier_code.text
lvs_item_code = sle_item_code.text
lvs_line_type = sle_line_type.text

lvdt_dateset = uo_dateset.text()
lvdt_dateend = uo_dateend.text()

lvs_new_line_type = ddlb_new_line_type.getcode()

//=================================
//
//=================================
f_msg_mdi_help('Step 1/ 6')	
update im_item_unit_price set line_type = :lvs_new_line_type
  where supplier_code = :lvs_supplier_code
     and item_code = :lvs_item_code
     and line_type = :lvs_line_type
	 and dateset = :lvdt_dateset
	 and dateend = :lvdt_dateend
	 and organization_id = :gvi_organization_id ;
	 
	 if f_sql_check() < 0 then 
		return
	end if 
	
f_msg_mdi_help('Step 2/ 6 Arrival')	
update im_item_arrival set line_type =:lvs_new_line_type
 where supplier_code = :lvs_supplier_code
     and item_code = :lvs_item_code
     and line_type = :lvs_line_type
	 and arrival_date >= :lvdt_dateset
	 and arrival_date <= :lvdt_dateend
	 and organization_id = :gvi_organization_id ;
	 
	 if f_sql_check() < 0 then 
		return
	end if 
f_msg_mdi_help('Step 3/ 6 Free Receipt')		
update im_item_free_receipt set line_type =:lvs_new_line_type
 where item_code = :lvs_item_code
     and line_type   = :lvs_line_type
	 and receipt_date >= :lvdt_dateset
	 and receipt_date <= :lvdt_dateend
	 and organization_id = :gvi_organization_id ;
	 if f_sql_check() < 0 then 
		return
	end if 		 
	 
f_msg_mdi_help('Step 4/ 6 Receipt')		 
update im_item_receipt set line_type =:lvs_new_line_type
 where supplier_code = :lvs_supplier_code
     and item_code = :lvs_item_code
     and line_type = :lvs_line_type
	 and receipt_date >= :lvdt_dateset
	 and receipt_date <= :lvdt_dateend
	 and organization_id = :gvi_organization_id ;	 
	 
	 if f_sql_check() < 0 then 
		return
	end if 	
f_msg_mdi_help('Step 5/ 6 Issue')		
update im_item_issue set line_type =:lvs_new_line_type
 where item_code = :lvs_item_code
     and line_type = :lvs_line_type
	 and issue_date >= :lvdt_dateset
	 and issue_date <= :lvdt_dateend
	 and organization_id = :gvi_organization_id ;
	 
	 if f_sql_check() < 0 then 
		return
	end if 		
	
//f_msg_mdi_help('Step 6/ 6 Issue')		
//update im_item_inventory set line_type =:lvs_new_line_type
// where item_code = :lvs_item_code
//     and line_type = :lvs_line_type
//     and organization_id = :gvi_organization_id ;
//	 
//	 if f_sql_check() < 0 then 
//		return
//	end if 			

msg = f_msgbox(1170)	

if msg = 1 then 
	commit ;
else
	return
end if

end event

type st_16 from so_statictext within tabpage_5
integer x = 1659
integer width = 407
integer height = 64
string text = "Dateend"
end type

type st_15 from so_statictext within tabpage_5
integer x = 1257
integer width = 402
integer height = 64
string text = "Dateset"
end type

type uo_dateend from uo_ymd_calendar within tabpage_5
integer x = 1659
integer y = 68
integer taborder = 70
boolean enabled = false
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateset from uo_ymd_calendar within tabpage_5
integer x = 1253
integer y = 68
integer taborder = 70
boolean enabled = false
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type st_12 from so_statictext within tabpage_5
integer x = 2071
integer y = 4
integer width = 517
integer height = 56
string text = "New Line Type"
end type

type st_11 from so_statictext within tabpage_5
integer x = 887
integer y = 4
integer width = 357
integer height = 56
string text = "Line Type"
end type

type st_10 from so_statictext within tabpage_5
integer x = 448
integer y = 4
integer width = 434
integer height = 56
string text = "Item Code"
end type

type st_7 from so_statictext within tabpage_5
integer x = 9
integer y = 4
integer width = 434
integer height = 56
string text = "Supplier Code"
end type

type sle_line_type from so_singlelineedit within tabpage_5
integer x = 887
integer y = 72
integer width = 357
integer taborder = 30
boolean enabled = false
boolean displayonly = true
end type

type ddlb_new_line_type from uo_line_type within tabpage_5
integer x = 2066
integer y = 64
integer width = 530
integer height = 724
integer taborder = 30
end type

type sle_item_code from so_singlelineedit within tabpage_5
integer x = 448
integer y = 72
integer width = 434
integer taborder = 90
boolean enabled = false
boolean displayonly = true
end type

type sle_supplier_code from so_singlelineedit within tabpage_5
integer x = 9
integer y = 72
integer width = 434
integer taborder = 90
boolean enabled = false
boolean displayonly = true
end type

type tabpage_6 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3749
integer height = 160
long backcolor = 15780518
string text = "Price Change"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Compute5!"
long picturemaskcolor = 12632256
cbx_rate cbx_rate
st_19 st_19
uo_apply_date uo_apply_date
rb_decreease rb_decreease
rb_increase rb_increase
em_discount em_discount
cb_5 cb_5
end type

on tabpage_6.create
this.cbx_rate=create cbx_rate
this.st_19=create st_19
this.uo_apply_date=create uo_apply_date
this.rb_decreease=create rb_decreease
this.rb_increase=create rb_increase
this.em_discount=create em_discount
this.cb_5=create cb_5
this.Control[]={this.cbx_rate,&
this.st_19,&
this.uo_apply_date,&
this.rb_decreease,&
this.rb_increase,&
this.em_discount,&
this.cb_5}
end on

on tabpage_6.destroy
destroy(this.cbx_rate)
destroy(this.st_19)
destroy(this.uo_apply_date)
destroy(this.rb_decreease)
destroy(this.rb_increase)
destroy(this.em_discount)
destroy(this.cb_5)
end on

type cbx_rate from checkbox within tabpage_6
integer x = 37
integer y = 60
integer width = 306
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 15780518
string text = "Rate"
boolean checked = true
boolean lefttext = true
end type

type st_19 from so_statictext within tabpage_6
integer x = 1170
integer y = 16
integer width = 407
integer height = 76
boolean bringtotop = true
long backcolor = 15780518
string text = "Apply Date"
end type

type uo_apply_date from uo_ymd_calendar within tabpage_6
integer x = 1175
integer y = 72
integer taborder = 50
boolean bringtotop = true
end type

on uo_apply_date.destroy
call uo_ymd_calendar::destroy
end on

type rb_decreease from so_radiobutton within tabpage_6
integer x = 745
integer y = 96
integer width = 379
integer height = 44
integer weight = 700
long backcolor = 15780518
string text = "Decrease"
end type

type rb_increase from so_radiobutton within tabpage_6
integer x = 745
integer y = 32
integer width = 379
integer height = 56
integer weight = 700
long backcolor = 15780518
string text = "Increase"
boolean checked = true
end type

type em_discount from so_editmask within tabpage_6
integer x = 393
integer y = 52
integer width = 325
integer taborder = 100
string text = ""
string mask = "###,##0.00000"
end type

type cb_5 from so_commandbutton within tabpage_6
integer x = 1614
integer y = 28
integer height = 116
integer taborder = 40
string text = "Change"
end type

event clicked;call super::clicked;INT I , J 
STRING LVS_ROWID
DATETIME LVDT_DATESET , LVDT_DATEEND , LVDT_CONFIRM_DATE , LVDT_APPLY_DATE
STRING LVS_ITEM_CODE,LVS_SUPPLIER_CODE, LVS_LINE_TYPE,LVS_DELIVERY,LVS_CURRENCY,  LVS_PRICE_TYPE,LVS_APPROVAL_NO  
STRING LVS_PRICE_CHANGE_REASON,LVS_CONFIRM_BY, LVS_PRICE_CHANGE_CONFIRM_YN
DOUBLE  LVF_TAX_RATE,   LVF_STANDARD_UNIT_PRICE , LVF_NEW_UNIT_PRICE , LVF_UNIT_PRICE
						
						
 DECLARE CL1 CURSOR FOR  
      SELECT DATESET,   
			ITEM_CODE,   
			SUPPLIER_CODE,   
			LINE_TYPE,   
			DELIVERY,   
			CURRENCY,   
			UNIT_PRICE,   
			TAX_RATE,   
			PRICE_TYPE,   
			APPROVAL_NO,   
			STANDARD_UNIT_PRICE

    FROM IM_ITEM_UNIT_PRICE 
  WHERE ROWID = :LVS_ROWID
	 AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;


if  dec(em_discount.text) = 100  or dec(em_discount.text) < 0 then
	f_msgbox(9026) 
	return
end if
	

//========================================
//
//========================================

DO
	I++
	
	IF DW_1.OBJECT.CHECK_YN[I] = 'Y' THEN
		
		LVS_ROWID = DW_1.OBJECT.ROWID[I]
		
	ELSE
		CONTINUE
	END IF 
	
	OPEN CL1 ;
	FETCH CL1 INTO  :LVDT_DATESET,   
						:LVS_ITEM_CODE,   
						:LVS_SUPPLIER_CODE,   
						:LVS_LINE_TYPE,   
						:LVS_DELIVERY,   
						:LVS_CURRENCY,   
						:LVF_UNIT_PRICE,   
						:LVF_TAX_RATE,   
						:LVS_PRICE_TYPE,   
						:LVS_APPROVAL_NO,   
						:LVF_STANDARD_UNIT_PRICE;
						
			IF F_SQL_CHECK() < 0 THEN 
				CLOSE CL1;
				EXIT
			END IF 
			
			IF SQLCA.SQLCODE = 100 THEN 
				CLOSE CL1;
				EXIT
			END IF 
	if cbx_rate.checked = true then 	
		if rb_increase.checked = true then 
			LVF_NEW_UNIT_PRICE= LVF_UNIT_PRICE+ ( LVF_UNIT_PRICE* dec( em_discount.text ) / 100 )
			LVS_PRICE_CHANGE_REASON = 'I'
		else
			LVF_NEW_UNIT_PRICE = LVF_UNIT_PRICE - (LVF_UNIT_PRICE * dec( em_discount.text ) / 100 )	
			LVS_PRICE_CHANGE_REASON = 'D'
		end if 			
		   
	else
			if rb_increase.checked = true then 
			LVF_NEW_UNIT_PRICE= LVF_UNIT_PRICE  +   dec( em_discount.text ) 
			LVS_PRICE_CHANGE_REASON = 'I'
		else
			LVF_NEW_UNIT_PRICE = LVF_UNIT_PRICE  -  dec( em_discount.text ) 
			LVS_PRICE_CHANGE_REASON = 'D'
		end if 
	end  if 
		
		lvdt_apply_date = uo_apply_date.text()

		  INSERT INTO "IM_ITEM_UNIT_PRICE"  
				 ( "DATESET",   
				   "ITEM_CODE",   
				   "SUPPLIER_CODE",   
				   "LINE_TYPE",   
				   "ORGANIZATION_ID",   
				   "DELIVERY",   
				   "CURRENCY",   
				   "UNIT_PRICE",   
				   "TAX_RATE",   
				   "PRICE_TYPE",   
				   "APPROVAL_NO",   
				   "STANDARD_UNIT_PRICE",   
				   "DATEEND",   
				   "PRICE_CHANGE_REASON",   
				   "CONFIRM_BY",   
				   "PRICE_CHANGE_CONFIRM_YN",   
				   "CONFIRM_DATE",   
				   "ENTER_DATE",   
				   "ENTER_BY",   
				   "LAST_MODIFY_DATE",   
				   "LAST_MODIFY_BY" )  
		  VALUES (  :LVDT_APPLY_DATE , //LVDT_DATESET,   
					:LVS_ITEM_CODE,   
					:LVS_SUPPLIER_CODE,   
					:LVS_LINE_TYPE,   
					:GVI_ORGANIZATION_ID ,
					:LVS_DELIVERY,   
					:LVS_CURRENCY,   
					:LVF_NEW_UNIT_PRICE,   
					:LVF_TAX_RATE,   
					:LVS_PRICE_TYPE,   
					:LVS_APPROVAL_NO,   
					:LVF_STANDARD_UNIT_PRICE,   
					TO_DATE( '99991231' , 'YYYYMMDD') , //:LVDT_DATEEND,   
					:LVS_PRICE_CHANGE_REASON,   
					'' , //:LVS_CONFIRM_BY,   
					'N' , //:LVS_PRICE_CHANGE_CONFIRM_YN,   
					:LVDT_CONFIRM_DATE ,
					SYSDATE ,:GVS_USER_ID , SYSDATE , :GVS_USER_ID )  ;
					
		CLOSE CL1;
		J++
LOOP UNTIL I = DW_1.ROWCOUNT()

IF J > 0 THEN  

	MSG = F_MSGBOX(1170)
	IF MSG = 1 THEN 
			COMMIT ;
	ELSE
			ROLLBACK;
	END IF 
ELSE
	ROLLBACK;
END IF 
end event

type ddlb_line_type from uo_line_type within w_mat_buy_price_master
integer x = 1042
integer y = 176
integer width = 539
integer taborder = 20
boolean bringtotop = true
end type

type st_13 from so_statictext within w_mat_buy_price_master
integer x = 1042
integer y = 104
integer width = 539
integer height = 60
boolean bringtotop = true
string text = "Line Type"
end type

type ddlb_item_division from uo_item_division within w_mat_buy_price_master
integer x = 1586
integer y = 176
integer width = 439
integer taborder = 30
boolean bringtotop = true
end type

type st_18 from so_statictext within w_mat_buy_price_master
integer x = 1577
integer y = 112
integer width = 439
integer height = 56
boolean bringtotop = true
string text = "Item Division"
end type

type sle_2 from so_singlelineedit within w_mat_buy_price_master
integer x = 3790
integer y = 176
integer width = 443
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

event modified;call super::modified;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

dw_1.SETFILTER('')
dw_1.FILTER()

LVS_COLUMN = 'HS_NAME'
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

type st_20 from so_statictext within w_mat_buy_price_master
integer x = 3790
integer y = 100
integer width = 443
integer height = 60
boolean bringtotop = true
long textcolor = 16711680
string text = "HS Name"
end type

type ddlb_price_type from uo_basecode within w_mat_buy_price_master
integer x = 2034
integer y = 176
integer width = 475
integer taborder = 40
boolean bringtotop = true
end type

type st_21 from so_statictext within w_mat_buy_price_master
integer x = 2034
integer y = 112
integer width = 475
integer height = 56
boolean bringtotop = true
string text = "Price Type"
end type

type uo_start_date from uo_ymd_calendar within w_mat_buy_price_master
integer x = 2514
integer y = 172
integer taborder = 50
boolean bringtotop = true
end type

on uo_start_date.destroy
call uo_ymd_calendar::destroy
end on

type st_22 from so_statictext within w_mat_buy_price_master
integer x = 2514
integer y = 116
integer width = 407
integer height = 60
boolean bringtotop = true
string text = "Dateset"
end type

type mle_1 from multilineedit within w_mat_buy_price_master
integer x = 3849
integer y = 320
integer width = 411
integer height = 324
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean hscrollbar = true
boolean vscrollbar = true
boolean autohscroll = true
boolean autovscroll = true
borderstyle borderstyle = stylelowered!
end type

