HA$PBExportHeader$w_des_apply_item_master.srw
$PBExportComments$$$HEX9$$01c8a9c6a8ba78b370c88cd6c8b9a4c230d1$$ENDHEX$$
forward
global type w_des_apply_item_master from w_main_root
end type
type cb_1 from so_commandbutton within w_des_apply_item_master
end type
type st_5 from so_statictext within w_des_apply_item_master
end type
type uo_item from uo_item_code within w_des_apply_item_master
end type
type gb_where_condition from so_groupbox within w_des_apply_item_master
end type
type gb_2 from so_groupbox within w_des_apply_item_master
end type
end forward

global type w_des_apply_item_master from w_main_root
integer height = 2640
string title = "Apply Model Master"
cb_1 cb_1
st_5 st_5
uo_item uo_item
gb_where_condition gb_where_condition
gb_2 gb_2
end type
global w_des_apply_item_master w_des_apply_item_master

on w_des_apply_item_master.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.st_5=create st_5
this.uo_item=create uo_item
this.gb_where_condition=create gb_where_condition
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.st_5
this.Control[iCurrent+3]=this.uo_item
this.Control[iCurrent+4]=this.gb_where_condition
this.Control[iCurrent+5]=this.gb_2
end on

on w_des_apply_item_master.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.st_5)
destroy(this.uo_item)
destroy(this.gb_where_condition)
destroy(this.gb_2)
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

F_MENU_CONTROL('DATA_CONTROL' , FALSE)  // All Data Control

/****************************************
* 
****************************************/

end event

event ue_data_control;call super::ue_data_control;Long ROW
CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		    
			DW_1.RESET()
			DW_2.RESET()
			
			dw_1.RETRIEVE( UO_ITEM.TEXT() , GVI_ORGANIZATION_ID)
			dw_1.SETFOCUS()
		
	CASE ELSE
END CHOOSE


end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

type dw_5 from w_main_root`dw_5 within w_des_apply_item_master
integer y = 316
end type

type dw_4 from w_main_root`dw_4 within w_des_apply_item_master
integer y = 316
end type

type dw_3 from w_main_root`dw_3 within w_des_apply_item_master
integer y = 324
integer width = 425
integer height = 368
end type

type dw_2 from w_main_root`dw_2 within w_des_apply_item_master
integer y = 1528
integer width = 4512
integer height = 1004
boolean enabled = false
string dataobject = "d_pln_product_model_master_simple_4_apply_mst"
end type

event dw_2::rbuttondown;call super::rbuttondown;IF DWO.NAME = 'item_code' THEN
	OPEN(W_DES_SET_ITEM_POPUP)
	IF message.stringparm = '' THEN 
	ELSE
		THIS.SETITEM( ROW , 'item_code' , message.stringparm )
	END IF
	
ELSEIF DWO.NAME = 'customer_code' THEN
	OPEN(W_COM_CUSTOMER_POPUP)
	IF message.stringparm = '' THEN 
	ELSE
		THIS.SETITEM( ROW , 'customer_code' , message.stringparm )
	END IF	
END IF 
end event

event dw_2::itemchanged;call super::itemchanged;IF DWO.NAME = 'product_class_code' then 
//	ST_MSG.TEXT = THIS.OBJECT.PRODUCT_CLASS_CODE[ROW]
END IF 
end event

type dw_1 from w_main_root`dw_1 within w_des_apply_item_master
integer y = 308
integer width = 4507
integer height = 1212
boolean titlebar = true
string title = "Apply Item Master List"
string dataobject = "d_des_apply_item_lst"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;IF currentrow  < 1  THEN RETURN
DW_2.RETRIEVE( dw_1.object.item_code[currentrow], gvi_organization_id )

end event

type uo_tabpages from w_main_root`uo_tabpages within w_des_apply_item_master
end type

type cb_1 from so_commandbutton within w_des_apply_item_master
integer x = 1143
integer y = 128
integer width = 453
integer height = 108
boolean bringtotop = true
string text = "Show BOM"
end type

event clicked;string lvs_set_item_code

if dw_1.getrow() < 1 then return

lvs_set_item_code = dw_1.getitemstring( dw_1.getrow() , 'item_code' )
if lvs_set_item_code = '' or isnull(lvs_set_item_code) then return

openwithparm( w_des_bom_query_popup , lvs_set_item_code )
end event

type st_5 from so_statictext within w_des_apply_item_master
integer x = 82
integer y = 100
integer width = 873
integer height = 56
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Item Code"
end type

type uo_item from uo_item_code within w_des_apply_item_master
integer x = 82
integer y = 168
integer width = 873
integer height = 92
integer taborder = 20
boolean bringtotop = true
end type

on uo_item.destroy
call uo_item_code::destroy
end on

type gb_where_condition from so_groupbox within w_des_apply_item_master
integer x = 5
integer width = 1047
integer height = 304
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_des_apply_item_master
integer x = 1088
integer width = 576
integer height = 304
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

