HA$PBExportHeader$w_system_open_close_master.srw
$PBExportComments$Dual Language Information Manage
forward
global type w_system_open_close_master from w_main_root
end type
type st_14 from so_statictext within w_system_open_close_master
end type
type st_1 from so_statictext within w_system_open_close_master
end type
type sle_window_name from so_singlelineedit within w_system_open_close_master
end type
type sle_window_description from so_singlelineedit within w_system_open_close_master
end type
type ddlb_open_close from uo_basecode within w_system_open_close_master
end type
type st_2 from so_statictext within w_system_open_close_master
end type
type sle_1 from so_singlelineedit within w_system_open_close_master
end type
type st_3 from so_statictext within w_system_open_close_master
end type
type gb_1 from so_groupbox within w_system_open_close_master
end type
end forward

global type w_system_open_close_master from w_main_root
string title = "System Environment"
st_14 st_14
st_1 st_1
sle_window_name sle_window_name
sle_window_description sle_window_description
ddlb_open_close ddlb_open_close
st_2 st_2
sle_1 sle_1
st_3 st_3
gb_1 gb_1
end type
global w_system_open_close_master w_system_open_close_master

type variables
datawindow ivd_data_window
end variables

on w_system_open_close_master.create
int iCurrent
call super::create
this.st_14=create st_14
this.st_1=create st_1
this.sle_window_name=create sle_window_name
this.sle_window_description=create sle_window_description
this.ddlb_open_close=create ddlb_open_close
this.st_2=create st_2
this.sle_1=create sle_1
this.st_3=create st_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_14
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.sle_window_name
this.Control[iCurrent+4]=this.sle_window_description
this.Control[iCurrent+5]=this.ddlb_open_close
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.sle_1
this.Control[iCurrent+8]=this.st_3
this.Control[iCurrent+9]=this.gb_1
end on

on w_system_open_close_master.destroy
call super::destroy
destroy(this.st_14)
destroy(this.st_1)
destroy(this.sle_window_name)
destroy(this.sle_window_description)
destroy(this.ddlb_open_close)
destroy(this.st_2)
destroy(this.sle_1)
destroy(this.st_3)
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
Ivs_resize_type    = 'NORMAL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
ivs_dw_1_use_focusindicator = 'N' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default

ivs_dw_1_selected_row_yn = 'N' 

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
CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		
			DW_1.RETRIEVE(SLE_WINDOW_NAME.TEXT+'%' , ddlb_open_close.getcode()+'%' , GVI_ORGANIZATION_ID)
			DW_1.SETFOCUS()
			
	CASE 'UPDATE'
		
          	IF DW_1.UPDATE() < 0 THEN
				ROLLBACK;
			ELSE
				 COMMIT;
				 F_MSG_MDI_HELP( "Update Complete" ) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
			END IF
			
	CASE ELSE
END CHOOSE


end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

type dw_5 from w_main_root`dw_5 within w_system_open_close_master
integer y = 340
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_system_open_close_master
integer y = 340
integer taborder = 50
end type

type dw_3 from w_main_root`dw_3 within w_system_open_close_master
integer y = 340
integer taborder = 60
end type

type dw_2 from w_main_root`dw_2 within w_system_open_close_master
integer y = 340
integer taborder = 70
end type

type dw_1 from w_main_root`dw_1 within w_system_open_close_master
integer y = 340
integer width = 4507
integer height = 2216
integer taborder = 0
boolean titlebar = true
string title = "System Open Close List"
string dataobject = "d_window_4_open_close_lst"
end type

type st_14 from so_statictext within w_system_open_close_master
integer x = 37
integer y = 116
integer width = 494
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Window Name"
end type

type st_1 from so_statictext within w_system_open_close_master
integer x = 535
integer y = 116
integer width = 571
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Window Description Local"
end type

type sle_window_name from so_singlelineedit within w_system_open_close_master
integer x = 37
integer y = 196
integer width = 494
integer taborder = 10
boolean bringtotop = true
end type

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN = 'WINDOW_NAME'

IF ISNULL(LVS_COLUMN) OR LEN(LVS_COLUMN) = 0 THEN RETURN 

SELECTED_DATA_WINDOW.SETFILTER('')
SELECTED_DATA_WINDOW.FILTER()

IF THIS.TEXT = '' THEN 
	SELECTED_DATA_WINDOW.SETFILTER('')
	SELECTED_DATA_WINDOW.FILTER()
	RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

SELECTED_DATA_WINDOW.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
SELECTED_DATA_WINDOW.FILTER()

end event

type sle_window_description from so_singlelineedit within w_system_open_close_master
integer x = 535
integer y = 196
integer width = 571
integer taborder = 20
boolean bringtotop = true
end type

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN = 'window_description_local'

IF ISNULL(LVS_COLUMN) OR LEN(LVS_COLUMN) = 0 THEN RETURN 

dw_1.SETFILTER('')
dw_1.FILTER()

IF THIS.TEXT = '' THEN 
	dw_1.SETFILTER('')
	dw_1.FILTER()
	RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

dw_1.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
dw_1.FILTER()

end event

type ddlb_open_close from uo_basecode within w_system_open_close_master
integer x = 1691
integer y = 192
integer width = 603
integer taborder = 20
boolean bringtotop = true
end type

event constructor;call super::constructor;THIS.REdraw( 'WINDOW OPEN YN')
end event

type st_2 from so_statictext within w_system_open_close_master
integer x = 1696
integer y = 116
integer width = 603
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Window Open Close"
end type

type sle_1 from so_singlelineedit within w_system_open_close_master
integer x = 1111
integer y = 196
integer width = 571
integer taborder = 20
boolean bringtotop = true
end type

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN = 'window_description_kor'

IF ISNULL(LVS_COLUMN) OR LEN(LVS_COLUMN) = 0 THEN RETURN 

dw_1.SETFILTER('')
dw_1.FILTER()

IF THIS.TEXT = '' THEN 
	dw_1.SETFILTER('')
	dw_1.FILTER()
	RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

dw_1.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
dw_1.FILTER()

end event

type st_3 from so_statictext within w_system_open_close_master
integer x = 1111
integer y = 116
integer width = 571
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Window Description Kor"
end type

type gb_1 from so_groupbox within w_system_open_close_master
integer x = 9
integer width = 2313
integer height = 336
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

