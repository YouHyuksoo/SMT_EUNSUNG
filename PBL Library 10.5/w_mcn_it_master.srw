HA$PBExportHeader$w_mcn_it_master.srw
$PBExportComments$Customer Infromation Manage
forward
global type w_mcn_it_master from w_main_root
end type
type sle_machine_code from so_singlelineedit within w_mcn_it_master
end type
type st_1 from so_statictext within w_mcn_it_master
end type
type st_2 from so_statictext within w_mcn_it_master
end type
type sle_user_name from so_singlelineedit within w_mcn_it_master
end type
type sle_model from so_singlelineedit within w_mcn_it_master
end type
type st_3 from so_statictext within w_mcn_it_master
end type
type ddlb_type from uo_basecode within w_mcn_it_master
end type
type st_6 from so_statictext within w_mcn_it_master
end type
type ddlb_use_status from uo_basecode within w_mcn_it_master
end type
type st_4 from statictext within w_mcn_it_master
end type
type cb_1 from so_commandbutton within w_mcn_it_master
end type
type gb_1 from groupbox within w_mcn_it_master
end type
type gb_3 from groupbox within w_mcn_it_master
end type
end forward

global type w_mcn_it_master from w_main_root
integer y = 256
integer width = 4695
integer height = 3104
string title = "IT Asset Management"
sle_machine_code sle_machine_code
st_1 st_1
st_2 st_2
sle_user_name sle_user_name
sle_model sle_model
st_3 st_3
ddlb_type ddlb_type
st_6 st_6
ddlb_use_status ddlb_use_status
st_4 st_4
cb_1 cb_1
gb_1 gb_1
gb_3 gb_3
end type
global w_mcn_it_master w_mcn_it_master

on w_mcn_it_master.create
int iCurrent
call super::create
this.sle_machine_code=create sle_machine_code
this.st_1=create st_1
this.st_2=create st_2
this.sle_user_name=create sle_user_name
this.sle_model=create sle_model
this.st_3=create st_3
this.ddlb_type=create ddlb_type
this.st_6=create st_6
this.ddlb_use_status=create ddlb_use_status
this.st_4=create st_4
this.cb_1=create cb_1
this.gb_1=create gb_1
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_machine_code
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.sle_user_name
this.Control[iCurrent+5]=this.sle_model
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.ddlb_type
this.Control[iCurrent+8]=this.st_6
this.Control[iCurrent+9]=this.ddlb_use_status
this.Control[iCurrent+10]=this.st_4
this.Control[iCurrent+11]=this.cb_1
this.Control[iCurrent+12]=this.gb_1
this.Control[iCurrent+13]=this.gb_3
end on

on w_mcn_it_master.destroy
call super::destroy
destroy(this.sle_machine_code)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.sle_user_name)
destroy(this.sle_model)
destroy(this.st_3)
destroy(this.ddlb_type)
destroy(this.st_6)
destroy(this.ddlb_use_status)
destroy(this.st_4)
destroy(this.cb_1)
destroy(this.gb_1)
destroy(this.gb_3)
end on

event activate;call super::activate;/***************************************
* $$HEX17$$08c7c4b324c115c8d0c5200000ad5cd52000acc06dd544c720004bc105d35cd5e4b2$$ENDHEX$$
*
*
****************************************/
Gst_set.window_id            = this.classname() 
Gst_set.author                  = "JiSheng"
Gst_set.creation_date      = '20051101'
Gst_set.last_modify_date = '20051101'
Gst_set.Report_window    = False  // Report Window  True / Flase

/*****************************************
* Data WIndow Property
******************************************/
Ivs_resize_type    = 'MASTER_DETAIL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default

/****************************************
* Menu Property $$HEX6$$54ba74b2200078d5e4b4c1b9$$ENDHEX$$
*****************************************
* ADMIN     : ADMIN  ( $$HEX5$$04c8b4ccacc0a9c62000$$ENDHEX$$)
* $$HEX8$$00adacb9200020002000200020002000$$ENDHEX$$: MANAGE ( $$HEX8$$04c854ba74b2acc0a9c600aca5b22000$$ENDHEX$$)
* $$HEX7$$acc0a9c690c72000200020002000$$ENDHEX$$: GUEST  ( $$HEX11$$30ae08cd2000f1b45db8200070c88cd6200000aca5b2$$ENDHEX$$)
* $$HEX8$$70c88cd6200020002000200020002000$$ENDHEX$$: QUERY  ( $$HEX10$$15c8f4bc70c88cd6ccb9200000aca5b220002000$$ENDHEX$$)
* $$HEX5$$70b374c7c0d070c891c7$$ENDHEX$$: DATA_CONTROL  ( $$HEX12$$85c725b8200018c215c82000adc01cc8200024c115c82000$$ENDHEX$$)
* $$HEX7$$08b8ecd3b8d22000200020002000$$ENDHEX$$: REPORT ( $$HEX4$$08b8ecd3b8d22000$$ENDHEX$$, $$HEX5$$9ccd25b800adacb92000$$ENDHEX$$)
****************************************/

F_MENU_CONTROL('DATA_CONTROL' , TRUE)  // All Data Control

/****************************************
* 
****************************************/

end event

event ue_data_control;call super::ue_data_control;Long ROW
STRING LVS_RCV_ISS_TYPE
CHOOSE CASE Gvs_Ue_DATA_control
	CASE 'RETRIEVE'
		
				DW_1.RESET( )
				DW_1.RETRIEVE( sle_machine_code.text+'%' ,  sle_model.text+'%' , sle_user_name.text+'%' , ddlb_type.getcode( )+'%' , ddlb_use_status.getcode( )+'%' , Gvi_organization_id )
		
	CASE	'INSERT'
		
			DW_2.ENABLED = TRUE
			ROW = DW_2.INSERTROW(0)
			DW_2.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')				
		    DW_2.OBject.USE_STATUS[ROW] = 'U'
			DW_2.OBject.MACHINE_CODE[ROW] =''
			DW_2.OBject.MODEL[ROW] = ''		
			DW_2.OBject.USER_NAME[ROW] = ''
			DW_2.OBject.receipt_date[ROW] =F_SYSDATE()			
			
			
	CASE	'DELETE'
		
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

	CASE 'UPDATE'

	         IF DW_2.UPDATE() < 0  THEN
			  	 ROLLBACK;
			ELSE
				 COMMIT;
	                F_RETRIEVE()
				 F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
			END IF

 		
	CASE ELSE
END CHOOSE


end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
end event

type dw_5 from w_main_root`dw_5 within w_mcn_it_master
integer y = 288
end type

type dw_4 from w_main_root`dw_4 within w_mcn_it_master
integer y = 288
integer taborder = 80
end type

type dw_3 from w_main_root`dw_3 within w_mcn_it_master
integer x = 2249
integer y = 1500
integer width = 1609
integer height = 908
integer taborder = 70
boolean titlebar = true
string title = "IT History"
end type

event dw_3::rbuttondown;call super::rbuttondown;if dwo.name = 'item_code' then 
	
	open(w_des_model_master_popup)
	
	if Gst_return.gvb_return = true then 
		
		this.object.item_code[row] = Gst_return.gvs_return[2]  //$$HEX6$$00b35cd42000a8ba78b32000$$ENDHEX$$
		
		
	end if 
	
elseif dwo.name = 'smt_model_name' then 
	
	open(w_des_model_master_popup)
	
	if Gst_return.gvb_return = true then 
		
		this.object.item_code[row] = Gst_return.gvs_return[1]  //smt $$HEX3$$a8ba78b32000$$ENDHEX$$
	end if 
end if 
end event

type dw_2 from w_main_root`dw_2 within w_mcn_it_master
integer x = 5
integer y = 1516
integer width = 4599
integer height = 1144
integer taborder = 100
boolean titlebar = true
string title = "Detail List"
string dataobject = "d_mcn_fixasset_mst"
boolean hsplitscroll = false
borderstyle borderstyle = styleraised!
end type

event dw_2::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return

//dw_3.retrieve( dw_2.object.machine_code[currentrow] , dw_2.object.user_name[currentrow]  , gvi_organization_id )
end event

type dw_1 from w_main_root`dw_1 within w_mcn_it_master
integer y = 292
integer width = 4594
integer height = 1216
boolean titlebar = true
string title = "Asset List"
string dataobject = "d_mcn_fixasset_lst"
end type

event dw_1::uo_mousemove;call super::uo_mousemove;//if row < 1 then return
//IF   GVS_SHOW_MACHINE_IMAGE = 'Y' AND ( UPPER(DWO.TYPE) = 'COLUMN' AND  UPPER(DWO.NAME) = 'MACHINE_CODE'  ) THEN
//
//	 IF ISVALID(W_MACHINE_REPAIR_IMAGE_FLAT) THEN
//		RETURN
//	ELSE
//			OPENWITHPARM(W_MACHINE_IMAGE_FLAT , STRING(THIS.OBJECT.MACHINE_CODE[ROW]))
//	END IF 
//ELSE
//
//	IF isvalid(W_MACHINE_IMAGE_FLAT) then
//		close(W_MACHINE_IMAGE_FLAT)
//	end if 
//END IF
end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;IF	CURRENTROW < 1	THEN	RETURN
DW_2.RETRIEVE( DW_1.GETITEMSTRING( CURRENTROW, 'ROWID' ))

end event

event dw_1::doubleclicked;call super::doubleclicked;IF	ROW < 1	THEN	RETURN
DW_2.RETRIEVE( DW_1.GETITEMSTRING( ROW, 'ROWID' ))
end event

type uo_tabpages from w_main_root`uo_tabpages within w_mcn_it_master
end type

type sle_machine_code from so_singlelineedit within w_mcn_it_master
integer x = 846
integer y = 148
integer width = 457
integer taborder = 20
boolean bringtotop = true
textcase textcase = upper!
end type

type st_1 from so_statictext within w_mcn_it_master
integer x = 846
integer y = 80
integer width = 457
integer height = 56
boolean bringtotop = true
string text = "Machine Code"
end type

type st_2 from so_statictext within w_mcn_it_master
integer x = 1751
integer y = 80
integer width = 443
integer height = 56
boolean bringtotop = true
long textcolor = 16711680
string text = "User Name"
end type

type sle_user_name from so_singlelineedit within w_mcn_it_master
integer x = 1751
integer y = 148
integer width = 443
integer taborder = 20
boolean bringtotop = true
end type

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

DW_1.SETFILTER('')
DW_1.FILTER()

LVS_COLUMN = 'JIG_NAME'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    DW_1.SETFILTER('')
    DW_1.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

DW_1.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
DW_1.FILTER()
F_MSG_MDI_HELP( STRING( DW_1.ROWCOUNT() ) + " Found" )
end event

type sle_model from so_singlelineedit within w_mcn_it_master
integer x = 1307
integer y = 148
integer width = 439
integer taborder = 30
boolean bringtotop = true
end type

type st_3 from so_statictext within w_mcn_it_master
integer x = 1307
integer y = 80
integer width = 439
integer height = 56
boolean bringtotop = true
string text = "Model Name"
end type

type ddlb_type from uo_basecode within w_mcn_it_master
integer x = 329
integer y = 148
integer width = 471
integer taborder = 60
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'TYPE')
end event

type st_6 from so_statictext within w_mcn_it_master
integer x = 338
integer y = 80
integer width = 471
integer height = 56
boolean bringtotop = true
long textcolor = 0
string text = "FixAsset  Type"
end type

type ddlb_use_status from uo_basecode within w_mcn_it_master
integer x = 2222
integer y = 152
integer width = 613
integer taborder = 30
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'USE STATUS')
end event

type st_4 from statictext within w_mcn_it_master
integer x = 2231
integer y = 80
integer width = 594
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Use Status"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_1 from so_commandbutton within w_mcn_it_master
integer x = 3397
integer y = 72
integer width = 535
integer height = 156
integer taborder = 40
boolean bringtotop = true
string text = "Destroy"
end type

event clicked;call super::clicked;if dw_2.getrow() < 1 then return


msg = f_msgbox1( 1161 , this.text ) 
if msg = 1 then 
else
	return 
end if 

dw_2.object.use_status[dw_2.getrow()] = 'S' //$$HEX5$$acc0a9c611c9c0c92000$$ENDHEX$$

if dw_2.update( ) < 0 then 
	rollback;
else
	commit ;
end if
end event

type gb_1 from groupbox within w_mcn_it_master
integer x = 14
integer width = 3278
integer height = 272
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Where Condition"
end type

type gb_3 from groupbox within w_mcn_it_master
integer x = 3355
integer width = 622
integer height = 272
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Process"
end type

