HA$PBExportHeader$w_des_item_master_es.srw
$PBExportComments$$$HEX14$$40c731c104c8a5c72000acc0b4b0200080bd88d42000c8b9a4c230d1$$ENDHEX$$
forward
global type w_des_item_master_es from w_main_root
end type
type st_2 from so_statictext within w_des_item_master_es
end type
type sle_item_code from so_singlelineedit within w_des_item_master_es
end type
type cb_2 from so_commandbutton within w_des_item_master_es
end type
type cb_1 from so_commandbutton within w_des_item_master_es
end type
type ddlb_item_type from dropdownlistbox within w_des_item_master_es
end type
type ddlb_customer_code from uo_customer_code_name within w_des_item_master_es
end type
type st_1 from so_statictext within w_des_item_master_es
end type
type st_3 from so_statictext within w_des_item_master_es
end type
type st_4 from so_statictext within w_des_item_master_es
end type
type sle_item_spec from so_singlelineedit within w_des_item_master_es
end type
type gb_where_condition from so_groupbox within w_des_item_master_es
end type
type gb_1 from so_groupbox within w_des_item_master_es
end type
end forward

global type w_des_item_master_es from w_main_root
integer width = 4736
integer height = 2904
string title = "Item Master (Internal)"
st_2 st_2
sle_item_code sle_item_code
cb_2 cb_2
cb_1 cb_1
ddlb_item_type ddlb_item_type
ddlb_customer_code ddlb_customer_code
st_1 st_1
st_3 st_3
st_4 st_4
sle_item_spec sle_item_spec
gb_where_condition gb_where_condition
gb_1 gb_1
end type
global w_des_item_master_es w_des_item_master_es

on w_des_item_master_es.create
int iCurrent
call super::create
this.st_2=create st_2
this.sle_item_code=create sle_item_code
this.cb_2=create cb_2
this.cb_1=create cb_1
this.ddlb_item_type=create ddlb_item_type
this.ddlb_customer_code=create ddlb_customer_code
this.st_1=create st_1
this.st_3=create st_3
this.st_4=create st_4
this.sle_item_spec=create sle_item_spec
this.gb_where_condition=create gb_where_condition
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.sle_item_code
this.Control[iCurrent+3]=this.cb_2
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.ddlb_item_type
this.Control[iCurrent+6]=this.ddlb_customer_code
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.st_3
this.Control[iCurrent+9]=this.st_4
this.Control[iCurrent+10]=this.sle_item_spec
this.Control[iCurrent+11]=this.gb_where_condition
this.Control[iCurrent+12]=this.gb_1
end on

on w_des_item_master_es.destroy
call super::destroy
destroy(this.st_2)
destroy(this.sle_item_code)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.ddlb_item_type)
destroy(this.ddlb_customer_code)
destroy(this.st_1)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.sle_item_spec)
destroy(this.gb_where_condition)
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
STRING LVS_SETYN
CHOOSE CASE Gvs_Ue_data_control
		
	CASE 'RETRIEVE'
		   
			DW_1.RETRIEVE(sle_item_code.text+'%' , mid(ddlb_item_type.text,1,1)+'%',  mid(ddlb_customer_code.text,1,2)+'%', gvi_organization_id, '%'+sle_item_spec.text+'%' )
			DW_1.SETFOCUS()
			
	CASE 'INSERT'
		
//			dw_1.enabled = true
//			row = dw_1.insertrow(dw_1.getrow())
//			dw_1.scrolltorow(row)
//			f_set_security_row(dw_1 , row , 'ALL')
//			F_MSG_MDI_HELP ( F_MSG_ST(152)	 )
			
	CASE 'APPEND'
		
//			dw_1.enabled = true
//			row = dw_1.insertrow(dw_1.getrow())
//			dw_1.scrolltorow(row)
//			f_set_security_row(dw_1 , row , 'ALL')
//			F_MSG_MDI_HELP ( F_MSG_ST(152)	 )
			
	CASE 'DELETE'
		
		  	if dw_1.getrow() < 1 then return 
			  
			msg =f_msgbox(1003)
			
			if msg = 1 then
				gvl_row_deleted = dw_1.getrow()			
				dw_1.deleterow(gvl_row_deleted)		
				dw_1.setfocus()
				row = dw_1.getrow()
				dw_1.scrolltorow(row)
				dw_1.setcolumn(1)
			end if

	CASE 'UPDATE'
 
	       IF dw_1.UPDATE() < 0 THEN
			  ROLLBACK;
			  RETURN
			ELSE
				 COMMIT;
   			      F_MSG_MDI_HELP ( F_MSG_ST(170)	 ) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
				 F_RETRIEVE()
			END IF
	
	CASE ELSE
		
END CHOOSE


end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

event open;call super::open;
ddlb_item_type.selectitem(1)
end event

type dw_5 from w_main_root`dw_5 within w_des_item_master_es
integer y = 320
end type

type dw_4 from w_main_root`dw_4 within w_des_item_master_es
integer x = 5
integer y = 320
end type

type dw_3 from w_main_root`dw_3 within w_des_item_master_es
integer x = 5
integer y = 320
integer taborder = 50
end type

type dw_2 from w_main_root`dw_2 within w_des_item_master_es
integer x = 5
integer y = 296
integer width = 4517
integer height = 408
integer taborder = 0
end type

type dw_1 from w_main_root`dw_1 within w_des_item_master_es
integer x = 5
integer y = 296
integer width = 4507
integer height = 1816
integer taborder = 40
boolean titlebar = true
string title = "$$HEX11$$acc0b4b0200088d4a9ba54cfdcb42000acb9a4c2b8d2$$ENDHEX$$"
string dataobject = "d_des_item_master_es_lst"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_des_item_master_es
end type

type st_2 from so_statictext within w_des_item_master_es
integer x = 91
integer y = 80
integer width = 581
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Item code"
end type

type sle_item_code from so_singlelineedit within w_des_item_master_es
event ue_editchange pbm_enchange
integer x = 91
integer y = 152
integer width = 581
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

event ue_editchange;////=====================================
////LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
////=====================================
//STRING LVS_VALUE , LVS_COLUMN
//
//SELECTED_DATA_WINDOW.SETFILTER('')
//SELECTED_DATA_WINDOW.FILTER()
//
//LVS_COLUMN = 'ITEM_NAME'
//IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
//	RETURN 
//END IF
//
//IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
//    SELECTED_DATA_WINDOW.SETFILTER('')
//    SELECTED_DATA_WINDOW.FILTER()	
//    RETURN
//ELSE
//	LVS_VALUE = '%'+this.text+'%'
//END IF
//
//SELECTED_DATA_WINDOW.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
//SELECTED_DATA_WINDOW.FILTER()
//F_MSG_MDI_HELP( STRING( SELECTED_DATA_WINDOW.ROWCOUNT() ) + " Found" )
end event

event getfocus;this.selecttext( 1 , len( this.text) )
this.Borderstyle = styleraised!
end event

event losefocus;this.Borderstyle = styleLowered!
end event

type cb_2 from so_commandbutton within w_des_item_master_es
integer x = 2880
integer y = 88
integer width = 489
integer height = 128
integer taborder = 20
boolean bringtotop = true
string text = "$$HEX7$$1cc888d454cfdcb42000f1b45db8$$ENDHEX$$"
end type

event clicked;call super::clicked;
	open( w_des_new_model_item_popup_es)
	
	//if Gst_return.gvb_return = true then
	//	this.object.item_code[row] = message.stringparm
	//end if 
end event

type cb_1 from so_commandbutton within w_des_item_master_es
integer x = 3387
integer y = 88
integer width = 489
integer height = 128
integer taborder = 20
boolean bringtotop = true
string text = "$$HEX7$$80bd88d454cfdcb42000f1b45db8$$ENDHEX$$"
end type

event clicked;call super::clicked;
	open( w_des_new_item_popup_es)
	
	//if Gst_return.gvb_return = true then
	//	this.object.item_code[row] = message.stringparm
	//end if 


end event

type ddlb_item_type from dropdownlistbox within w_des_item_master_es
integer x = 695
integer y = 152
integer width = 640
integer height = 980
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string item[] = {"%","1 : $$HEX3$$44c61cc888d4$$ENDHEX$$","2 : SUB ASSY","3 : SUB CPT","4 : $$HEX2$$e8b288d4$$ENDHEX$$($$HEX2$$04c890c7$$ENDHEX$$)","5 : $$HEX2$$e8b288d4$$ENDHEX$$($$HEX2$$7cc718bc$$ENDHEX$$)","6 : $$HEX1$$d0c6$$ENDHEX$$/$$HEX3$$80bd90c7acc7$$ENDHEX$$"}
borderstyle borderstyle = stylelowered!
end type

type ddlb_customer_code from uo_customer_code_name within w_des_item_master_es
integer x = 1358
integer y = 152
integer width = 640
integer height = 1256
integer taborder = 100
boolean bringtotop = true
end type

type st_1 from so_statictext within w_des_item_master_es
integer x = 695
integer y = 80
integer width = 640
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Item Type"
end type

type st_3 from so_statictext within w_des_item_master_es
integer x = 1358
integer y = 80
integer width = 640
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Customer Code"
end type

type st_4 from so_statictext within w_des_item_master_es
integer x = 2021
integer y = 80
integer width = 640
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Item Spec"
end type

type sle_item_spec from so_singlelineedit within w_des_item_master_es
integer x = 2021
integer y = 152
integer width = 640
integer height = 84
integer taborder = 100
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

event ue_editchange;////=====================================
////LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
////=====================================
//STRING LVS_VALUE , LVS_COLUMN
//
//SELECTED_DATA_WINDOW.SETFILTER('')
//SELECTED_DATA_WINDOW.FILTER()
//
//LVS_COLUMN = 'ITEM_NAME'
//IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
//	RETURN 
//END IF
//
//IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
//    SELECTED_DATA_WINDOW.SETFILTER('')
//    SELECTED_DATA_WINDOW.FILTER()	
//    RETURN
//ELSE
//	LVS_VALUE = '%'+this.text+'%'
//END IF
//
//SELECTED_DATA_WINDOW.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
//SELECTED_DATA_WINDOW.FILTER()
//F_MSG_MDI_HELP( STRING( SELECTED_DATA_WINDOW.ROWCOUNT() ) + " Found" )
end event

type gb_where_condition from so_groupbox within w_des_item_master_es
integer x = 2747
integer width = 1271
integer height = 280
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_1 from so_groupbox within w_des_item_master_es
integer x = 14
integer width = 2725
integer height = 280
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

