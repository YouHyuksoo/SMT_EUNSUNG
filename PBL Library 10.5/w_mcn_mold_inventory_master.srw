HA$PBExportHeader$w_mcn_mold_inventory_master.srw
$PBExportComments$Customer Infromation Manage
forward
global type w_mcn_mold_inventory_master from w_main_root
end type
type st_1 from so_statictext within w_mcn_mold_inventory_master
end type
type st_2 from so_statictext within w_mcn_mold_inventory_master
end type
type sle_model_name from so_singlelineedit within w_mcn_mold_inventory_master
end type
type ddlb_mold_use_status from uo_basecode within w_mcn_mold_inventory_master
end type
type st_8 from so_statictext within w_mcn_mold_inventory_master
end type
type ddlb_mold_group from uo_basecode within w_mcn_mold_inventory_master
end type
type st_4 from so_statictext within w_mcn_mold_inventory_master
end type
type ddlb_mold_code from uo_mold_code within w_mcn_mold_inventory_master
end type
type cb_request from so_commandbutton within w_mcn_mold_inventory_master
end type
type cb_2 from so_commandbutton within w_mcn_mold_inventory_master
end type
type gb_1 from so_groupbox within w_mcn_mold_inventory_master
end type
type gb_2 from so_groupbox within w_mcn_mold_inventory_master
end type
end forward

global type w_mcn_mold_inventory_master from w_main_root
integer width = 5787
integer height = 2668
string title = "Mold Inventory Master"
st_1 st_1
st_2 st_2
sle_model_name sle_model_name
ddlb_mold_use_status ddlb_mold_use_status
st_8 st_8
ddlb_mold_group ddlb_mold_group
st_4 st_4
ddlb_mold_code ddlb_mold_code
cb_request cb_request
cb_2 cb_2
gb_1 gb_1
gb_2 gb_2
end type
global w_mcn_mold_inventory_master w_mcn_mold_inventory_master

type variables
//
end variables

on w_mcn_mold_inventory_master.create
int iCurrent
call super::create
this.st_1=create st_1
this.st_2=create st_2
this.sle_model_name=create sle_model_name
this.ddlb_mold_use_status=create ddlb_mold_use_status
this.st_8=create st_8
this.ddlb_mold_group=create ddlb_mold_group
this.st_4=create st_4
this.ddlb_mold_code=create ddlb_mold_code
this.cb_request=create cb_request
this.cb_2=create cb_2
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.sle_model_name
this.Control[iCurrent+4]=this.ddlb_mold_use_status
this.Control[iCurrent+5]=this.st_8
this.Control[iCurrent+6]=this.ddlb_mold_group
this.Control[iCurrent+7]=this.st_4
this.Control[iCurrent+8]=this.ddlb_mold_code
this.Control[iCurrent+9]=this.cb_request
this.Control[iCurrent+10]=this.cb_2
this.Control[iCurrent+11]=this.gb_1
this.Control[iCurrent+12]=this.gb_2
end on

on w_mcn_mold_inventory_master.destroy
call super::destroy
destroy(this.st_1)
destroy(this.st_2)
destroy(this.sle_model_name)
destroy(this.ddlb_mold_use_status)
destroy(this.st_8)
destroy(this.ddlb_mold_group)
destroy(this.st_4)
destroy(this.ddlb_mold_code)
destroy(this.cb_request)
destroy(this.cb_2)
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
Ivs_resize_type                      = 'MASTER_DETAIL_12T_3B'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


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
F_MENU_CONTROL('DATA_CONTROL_MODIFY' , TRUE)  // All Data Control





end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

event ue_data_control;call super::ue_data_control;Long row , lvi_sign , LVDB_RCV_ISS_SEQ
String lvs_date
choose case gvs_ue_data_control
		
	case 'RETRIEVE'		
				
				dw_1.reset()
				dw_1.retrieve(ddlb_mold_code.text() + '%', ddlb_mold_use_status.getcode( )+'%' , ddlb_mold_group.getcode( )+'%' ,   gvi_organization_id)
 
 
    case 'INSERT' 
	
			ROW = DW_3.INSERTROW(0)
			DW_3.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_3 , ROW ,'ALL')
              
			LVDB_RCV_ISS_SEQ  = F_GET_SEQUENCE('SEQ_MOLD_REPAIR_SEQUENCE')
			
			
			DW_3.SETITEM( ROW , 'MOLD_CODE' , STRING(DW_1.OBJECT.MOLD_CODE[DW_1.GETROW()] ) )
			DW_3.SETITEM( ROW , 'MOLD_VERSION' , DW_1.OBJECT.MOLD_VERSION[DW_1.GETROW()]  )
			DW_3.SETITEM( ROW , 'MOLD_SET_SERIAL' , DW_1.OBJECT.MOLD_SET_SERIAL[DW_1.GETROW()]  )
			
			DW_3.SETITEM( ROW , 'REQUEST_DATE' , F_SYSDATE() )
			DW_3.SETITEM( ROW , 'REQUEST_SEQUENCE' , LVDB_RCV_ISS_SEQ )
			DW_3.SETITEM( ROW , 'REQUEST_STATUS' , 'R' )
			DW_3.SETITEM( ROW , 'REQUEST_QTY' , 1 )
	 

	case 'UPDATE'
		
			IF  DW_3.UPDATE() < 0 THEN
			  	 ROLLBACK;
			ELSE
				COMMIT;
				F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
					 
			END IF

	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_mcn_mold_inventory_master
integer x = 9
integer y = 348
integer width = 2464
integer height = 1056
integer taborder = 0
boolean titlebar = true
string title = "Mold Product List"
string dataobject = "d_mcn_mold_inventory_4_product_status_lst"
end type

type dw_4 from w_main_root`dw_4 within w_mcn_mold_inventory_master
integer x = 9
integer y = 348
integer width = 2464
integer height = 1056
integer taborder = 0
boolean titlebar = true
string title = "Mold Repair List"
end type

type dw_3 from w_main_root`dw_3 within w_mcn_mold_inventory_master
integer y = 1416
integer width = 4626
integer height = 832
integer taborder = 0
boolean titlebar = true
string dataobject = "d_mcn_mold_request_lst"
end type

type dw_2 from w_main_root`dw_2 within w_mcn_mold_inventory_master
integer x = 2491
integer y = 348
integer width = 2139
integer height = 1056
integer taborder = 0
boolean titlebar = true
string title = "Issue List"
string dataobject = "d_mcn_mold_issue_4_inventory_lst"
end type

type dw_1 from w_main_root`dw_1 within w_mcn_mold_inventory_master
integer x = 9
integer y = 348
integer width = 2464
integer height = 1056
integer taborder = 0
boolean titlebar = true
string title = "Mold Inventory List"
string dataobject = "d_mcn_mold_inventory_lst"
end type

event dw_1::uo_mousemove;call super::uo_mousemove;

end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 
   dw_2.retrieve( dw_1.object.mold_code[currentrow]  ,   gvi_organization_id )
   dw_3.retrieve( dw_1.object.mold_code[currentrow]  ,   gvi_organization_id )	
end event

type uo_tabpages from w_main_root`uo_tabpages within w_mcn_mold_inventory_master
integer taborder = 0
end type

type st_1 from so_statictext within w_mcn_mold_inventory_master
integer x = 805
integer y = 104
integer width = 608
integer height = 76
boolean bringtotop = true
string text = "Mold Code"
end type

type st_2 from so_statictext within w_mcn_mold_inventory_master
integer x = 1417
integer y = 104
integer width = 443
integer height = 76
boolean bringtotop = true
long textcolor = 16711680
string text = "Mold Name"
end type

type sle_model_name from so_singlelineedit within w_mcn_mold_inventory_master
integer x = 1417
integer y = 192
integer width = 443
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

type ddlb_mold_use_status from uo_basecode within w_mcn_mold_inventory_master
integer x = 1865
integer y = 188
integer width = 489
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'MOLD USE STATUS')
end event

event selectionchanged;call super::selectionchanged;f_retrieve()
end event

type st_8 from so_statictext within w_mcn_mold_inventory_master
integer x = 1865
integer y = 100
integer width = 489
integer height = 76
boolean bringtotop = true
string text = "Mold Use Status"
end type

type ddlb_mold_group from uo_basecode within w_mcn_mold_inventory_master
integer x = 2363
integer y = 188
integer width = 599
boolean bringtotop = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;this.redraw( 'MOLD GROUP')
end event

event selectionchanged;call super::selectionchanged;dw_1.setfilter('')
dw_1.filter( )
f_retrieve()
end event

type st_4 from so_statictext within w_mcn_mold_inventory_master
integer x = 2363
integer y = 100
integer width = 526
integer height = 76
boolean bringtotop = true
string text = "Mold Group"
end type

type ddlb_mold_code from uo_mold_code within w_mcn_mold_inventory_master
integer x = 805
integer y = 192
integer width = 608
integer taborder = 1
boolean bringtotop = true
end type

event modified;call super::modified;f_retrieve()
end event

type cb_request from so_commandbutton within w_mcn_mold_inventory_master
integer x = 3099
integer y = 120
integer height = 124
integer taborder = 21
boolean bringtotop = true
string text = "Request"
end type

event clicked;call super::clicked;f_insert()

end event

type cb_2 from so_commandbutton within w_mcn_mold_inventory_master
integer x = 3643
integer y = 120
integer height = 124
integer taborder = 31
boolean bringtotop = true
string text = "Cancel"
end type

event clicked;call super::clicked;dw_3.deleterow(dw_3.getrow())
end event

type gb_1 from so_groupbox within w_mcn_mold_inventory_master
integer x = 777
integer y = 4
integer width = 2245
integer height = 320
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_mcn_mold_inventory_master
integer x = 3031
integer width = 1189
integer height = 328
integer taborder = 11
integer weight = 700
long textcolor = 16711680
string text = "Request Process"
end type

