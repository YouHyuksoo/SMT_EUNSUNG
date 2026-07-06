HA$PBExportHeader$w_com_carrying_out_bring_in_security.srw
$PBExportComments$Material Buy Price Master
forward
global type w_com_carrying_out_bring_in_security from w_main_root
end type
type cb_confirm from so_commandbutton within w_com_carrying_out_bring_in_security
end type
type cb_cancel from so_commandbutton within w_com_carrying_out_bring_in_security
end type
type sle_group_no from so_singlelineedit within w_com_carrying_out_bring_in_security
end type
type st_2 from so_statictext within w_com_carrying_out_bring_in_security
end type
type st_status from so_statictext within w_com_carrying_out_bring_in_security
end type
type gb_2 from so_groupbox within w_com_carrying_out_bring_in_security
end type
type gb_3 from so_groupbox within w_com_carrying_out_bring_in_security
end type
end forward

global type w_com_carrying_out_bring_in_security from w_main_root
integer width = 4681
integer height = 2848
string title = "Carrying OUT Bring IN Security"
cb_confirm cb_confirm
cb_cancel cb_cancel
sle_group_no sle_group_no
st_2 st_2
st_status st_status
gb_2 gb_2
gb_3 gb_3
end type
global w_com_carrying_out_bring_in_security w_com_carrying_out_bring_in_security

on w_com_carrying_out_bring_in_security.create
int iCurrent
call super::create
this.cb_confirm=create cb_confirm
this.cb_cancel=create cb_cancel
this.sle_group_no=create sle_group_no
this.st_2=create st_2
this.st_status=create st_status
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_confirm
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.sle_group_no
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_status
this.Control[iCurrent+6]=this.gb_2
this.Control[iCurrent+7]=this.gb_3
end on

on w_com_carrying_out_bring_in_security.destroy
call super::destroy
destroy(this.cb_confirm)
destroy(this.cb_cancel)
destroy(this.sle_group_no)
destroy(this.st_2)
destroy(this.st_status)
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
Ivs_resize_type                      = 'MASTER_DETAIL_12T'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


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

sle_group_no.setfocus( )



end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
sle_group_no.setfocus( )
end event

event ue_data_control;call super::ue_data_control;long row
		
choose case gvs_ue_data_control

	case 'RETRIEVE'
		
			dw_1.retrieve( sle_group_no.text ,  gvi_organization_id)
			sle_group_no.setfocus( )

	case 'UPDATE'

				sle_group_no.setfocus( )
	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_com_carrying_out_bring_in_security
integer y = 316
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_com_carrying_out_bring_in_security
integer y = 316
integer taborder = 0
end type

type dw_3 from w_main_root`dw_3 within w_com_carrying_out_bring_in_security
integer y = 316
integer taborder = 0
end type

type dw_2 from w_main_root`dw_2 within w_com_carrying_out_bring_in_security
integer x = 2519
integer y = 316
integer width = 2107
integer height = 2404
integer taborder = 0
boolean titlebar = true
string dataobject = "d_man_carrying_out_security_lst"
end type

type dw_1 from w_main_root`dw_1 within w_com_carrying_out_bring_in_security
integer y = 312
integer width = 2510
integer height = 2408
integer taborder = 0
boolean titlebar = true
string title = "Carrying OUT Confirm List"
string dataobject = "d_man_carrying_out_invoice_rpt"
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

event dw_1::clicked;call super::clicked;if row < 1 then
	sle_group_no.setfocus( )	
	return
end if 
if dwo.name = 'b_image' then 

	IF this.object.CARRYING_OUT_DIVISION[row] <> 'J' then  //$$HEX8$$08ae15d674c7200044c5c8b274ba2000$$ENDHEX$$
				OPENWITHPARM(W_ITEM_IMAGE_FLAT , STRING(THIS.OBJECT.CARRYING_OUT_ITEM[ROW]))
	else
				OPENWITHPARM(W_MOLD_IMAGE_FLAT , STRING(THIS.OBJECT.CARRYING_OUT_ITEM[ROW]))
	end if
end if 

sle_group_no.setfocus( )
end event

event dw_1::retrieveend;call super::retrieveend;if dw_1.rowcount( ) > 0 then 
	cb_confirm.triggerevent( clicked!)
ELSE
	st_status.text = "NG"
	sle_group_no.setfocus()
end if 
end event

type uo_tabpages from w_main_root`uo_tabpages within w_com_carrying_out_bring_in_security
integer taborder = 0
end type

type cb_confirm from so_commandbutton within w_com_carrying_out_bring_in_security
integer x = 987
integer y = 96
integer width = 411
integer height = 140
boolean bringtotop = true
string text = "All Confirm"
end type

event clicked;call super::clicked;STRING lvs_group_no
if dw_1.getrow() < 1 then
	st_status.text = "NG"
	sle_group_no.setfocus( )
	return
end if 
		
		lvs_group_no = string(DW_1.OBJEct.CARRYING_OUT_GROUP_NO[DW_1.GETROW()])
		
		UPDATE  IMAN_CARRYING_OUT 
		      SET GATE_GUARD_CONFIRM_YN = 'Y' , 
				    GATE_GUARD_ID = :GVS_USER_ID ,
					GATE_GUARD_CONFIRM_DATE = SYSDATE
		  WHERE CARRYING_OUT_GROUP_NO = :lvs_group_no
		       AND ORGANIZATION_ID = :Gvi_organization_id ;
				 
		if f_sql_check() < 0 then 
			st_status.text = "ERROR"
			sle_group_no.setfocus( )		
			return 
		end if 
//===================================
//
//===================================

	commit ;
	f_message_ontime( 1, 'OK' )	
	st_status.text = "OK"
	sle_group_no.text = ''
	dw_2.retrieve( gvi_organization_id )

sle_group_no.setfocus( )
end event

type cb_cancel from so_commandbutton within w_com_carrying_out_bring_in_security
integer x = 1408
integer y = 96
integer width = 411
integer height = 140
boolean bringtotop = true
string text = "All Cancel"
end type

event clicked;call super::clicked;STRING lvs_group_no
if dw_1.getrow() < 1 then 
	sle_group_no.setfocus( )
	return
end if 
		
		lvs_group_no = string(DW_1.OBJEct.CARRYING_OUT_GROUP_NO[DW_1.GETROW()])
		
		UPDATE  IMAN_CARRYING_OUT SET GATE_GUARD_CONFIRM_YN = 'N' 
		  WHERE CARRYING_OUT_GROUP_NO = :lvs_group_no
		       AND ORGANIZATION_ID = :Gvi_organization_id ;
				 
		if f_sql_check() < 0 then 
			sle_group_no.setfocus( )
			return 
		end if 
//===================================
//
//===================================
			
msg = f_msgbox1( 9014 , string(1) )
if msg = 1 then 
	commit ;
	dw_1.reset()
	sle_group_no.text = ''
else
	rollback;	
end if 

sle_group_no.setfocus( )
end event

type sle_group_no from so_singlelineedit within w_com_carrying_out_bring_in_security
integer x = 32
integer y = 176
integer width = 841
integer height = 84
integer taborder = 1
boolean bringtotop = true
textcase textcase = upper!
boolean hideselection = false
end type

event modified;call super::modified;f_retrieve()
this.selecttext( 1,len(this.text))
end event

type st_2 from so_statictext within w_com_carrying_out_bring_in_security
integer x = 32
integer y = 100
integer width = 841
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Group No Barcode"
end type

type st_status from so_statictext within w_com_carrying_out_bring_in_security
integer x = 1902
integer y = 20
integer width = 1440
integer height = 264
boolean bringtotop = true
integer textsize = -36
string text = "WAIT"
end type

type gb_2 from so_groupbox within w_com_carrying_out_bring_in_security
integer y = 4
integer width = 910
integer height = 300
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_com_carrying_out_bring_in_security
integer x = 942
integer width = 928
integer height = 300
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

