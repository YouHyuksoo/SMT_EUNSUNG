HA$PBExportHeader$w_organization_master.srw
$PBExportComments$Organization  Information Manage
forward
global type w_organization_master from w_main_root
end type
type sle_organization_name from so_singlelineedit within w_organization_master
end type
type st_organization_name from so_statictext within w_organization_master
end type
type gb_1 from so_groupbox within w_organization_master
end type
end forward

global type w_organization_master from w_main_root
string title = "Organization"
toolbaralignment toolbaralignment = alignatbottom!
sle_organization_name sle_organization_name
st_organization_name st_organization_name
gb_1 gb_1
end type
global w_organization_master w_organization_master

on w_organization_master.create
int iCurrent
call super::create
this.sle_organization_name=create sle_organization_name
this.st_organization_name=create st_organization_name
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_organization_name
this.Control[iCurrent+2]=this.st_organization_name
this.Control[iCurrent+3]=this.gb_1
end on

on w_organization_master.destroy
call super::destroy
destroy(this.sle_organization_name)
destroy(this.st_organization_name)
destroy(this.gb_1)
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
CHOOSE CASE Gvs_ue_data_control
	CASE 'RETRIEVE'
		
	    DW_1.RETRIEVE(SLE_ORGANIZATION_NAME.TEXT+'%')
         DW_1.SETFOCUS()
			
	CASE 'INSERT'
		    DW_2.RESET()
			ROW = dw_2.INSERTROW(dw_2.GETROW())
			F_SET_SECURITY_ROW(dw_2 , ROW , 'NONORG')
			F_MSG_MDI_HELP( F_MSG_ST(152) )			
	CASE 'APPEND'
			DW_2.RESET()
			ROW = dw_2.INSERTROW(0)
			F_SET_SECURITY_ROW(dw_2 , ROW , 'NONORG')	
			F_MSG_MDI_HELP( F_MSG_ST(152) )			
	CASE 'DELETE'
		
		  	IF DW_2.GETROW() < 1 THEN RETURN 
			  
			MSG = F_MSGBOX(1003) 
			IF MSG = 1 THEN
				GVL_ROW_DELETED = DW_2.GETROW()			
				DW_2.DELETEROW(GVL_ROW_DELETED)		
				DW_2.SETFOCUS()
				ROW = DW_2.GETROW()
				DW_2.SCROLLTOROW(ROW)
				DW_2.SETCOLUMN(1)
			END IF
			
			MSG = F_MSGBOX1( 9030 , STRING(1) )
			IF MSG = 1 THEN 
				F_UPDATE()
			END IF
			
	CASE 'UPDATE'
		
			IF dw_2.UPDATE() < 0 THEN
				ROLLBACK;
			ELSE
				COMMIT;
				F_MSG_MDI_HELP( F_MSG_ST(170) )	 //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
			END IF
			
	CASE ELSE
END CHOOSE

end event

event ue_post_open;call super::ue_post_open;
f_child_dw3(dw_1, 'business_category', gvs_language, string(gvi_organization_id), 'BUSINESS CATEGORY')
f_child_dw3(dw_2, 'business_category', gvs_language, string(gvi_organization_id), 'BUSINESS CATEGORY')

/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

type dw_5 from w_main_root`dw_5 within w_organization_master
integer y = 356
integer width = 695
end type

type dw_4 from w_main_root`dw_4 within w_organization_master
integer y = 476
integer width = 695
end type

type dw_3 from w_main_root`dw_3 within w_organization_master
integer y = 476
integer width = 695
end type

type dw_2 from w_main_root`dw_2 within w_organization_master
integer y = 1492
integer width = 4494
integer height = 1264
string dataobject = "d_organization_mst"
boolean hscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

type dw_1 from w_main_root`dw_1 within w_organization_master
integer y = 352
integer width = 4494
integer height = 1136
boolean titlebar = true
string title = "Organization List"
string dataobject = "d_organization_lst"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;IF DW_1.GETROW() > 0 THEN
	DW_2.RETRIEVE( DW_1.GETITEMSTRING( DW_1.GETROW() , 'ROWID' ) )
ELSE
	DW_2.RESET()
END IF


end event

type uo_tabpages from w_main_root`uo_tabpages within w_organization_master
end type

type sle_organization_name from so_singlelineedit within w_organization_master
integer x = 27
integer y = 204
integer width = 553
integer taborder = 40
boolean bringtotop = true
textcase textcase = upper!
end type

type st_organization_name from so_statictext within w_organization_master
integer x = 27
integer y = 112
integer width = 553
boolean bringtotop = true
integer weight = 700
string text = "Organization Name"
end type

type gb_1 from so_groupbox within w_organization_master
integer width = 622
integer height = 336
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

