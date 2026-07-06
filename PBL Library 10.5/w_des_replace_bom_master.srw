HA$PBExportHeader$w_des_replace_bom_master.srw
$PBExportComments$$$HEX3$$00b3b4cc2000$$ENDHEX$$BOM$$HEX2$$00adacb9$$ENDHEX$$
forward
global type w_des_replace_bom_master from w_main_root
end type
type uo_start from uo_ymd_calendar within w_des_replace_bom_master
end type
type st_1 from so_statictext within w_des_replace_bom_master
end type
type cbx_show_replace_item from checkbox within w_des_replace_bom_master
end type
type rb_replace_manage from so_radiobutton within w_des_replace_bom_master
end type
type rb_replace_list from so_radiobutton within w_des_replace_bom_master
end type
type uo_set_item from uo_set_item_code within w_des_replace_bom_master
end type
type st_2 from so_statictext within w_des_replace_bom_master
end type
type st_3 from so_statictext within w_des_replace_bom_master
end type
type st_4 from statictext within w_des_replace_bom_master
end type
type sle_child_item_code from singlelineedit within w_des_replace_bom_master
end type
type sle_replace_item_code from singlelineedit within w_des_replace_bom_master
end type
type st_5 from statictext within w_des_replace_bom_master
end type
type pb_1 from so_commandbutton within w_des_replace_bom_master
end type
type gb_where_condition from so_groupbox within w_des_replace_bom_master
end type
type gb_1 from so_groupbox within w_des_replace_bom_master
end type
type gb_2 from so_groupbox within w_des_replace_bom_master
end type
end forward

global type w_des_replace_bom_master from w_main_root
integer width = 4736
integer height = 2904
string title = "ENG BOM Replace Master"
uo_start uo_start
st_1 st_1
cbx_show_replace_item cbx_show_replace_item
rb_replace_manage rb_replace_manage
rb_replace_list rb_replace_list
uo_set_item uo_set_item
st_2 st_2
st_3 st_3
st_4 st_4
sle_child_item_code sle_child_item_code
sle_replace_item_code sle_replace_item_code
st_5 st_5
pb_1 pb_1
gb_where_condition gb_where_condition
gb_1 gb_1
gb_2 gb_2
end type
global w_des_replace_bom_master w_des_replace_bom_master

type variables

end variables

on w_des_replace_bom_master.create
int iCurrent
call super::create
this.uo_start=create uo_start
this.st_1=create st_1
this.cbx_show_replace_item=create cbx_show_replace_item
this.rb_replace_manage=create rb_replace_manage
this.rb_replace_list=create rb_replace_list
this.uo_set_item=create uo_set_item
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.sle_child_item_code=create sle_child_item_code
this.sle_replace_item_code=create sle_replace_item_code
this.st_5=create st_5
this.pb_1=create pb_1
this.gb_where_condition=create gb_where_condition
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_start
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cbx_show_replace_item
this.Control[iCurrent+4]=this.rb_replace_manage
this.Control[iCurrent+5]=this.rb_replace_list
this.Control[iCurrent+6]=this.uo_set_item
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.st_3
this.Control[iCurrent+9]=this.st_4
this.Control[iCurrent+10]=this.sle_child_item_code
this.Control[iCurrent+11]=this.sle_replace_item_code
this.Control[iCurrent+12]=this.st_5
this.Control[iCurrent+13]=this.pb_1
this.Control[iCurrent+14]=this.gb_where_condition
this.Control[iCurrent+15]=this.gb_1
this.Control[iCurrent+16]=this.gb_2
end on

on w_des_replace_bom_master.destroy
call super::destroy
destroy(this.uo_start)
destroy(this.st_1)
destroy(this.cbx_show_replace_item)
destroy(this.rb_replace_manage)
destroy(this.rb_replace_list)
destroy(this.uo_set_item)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.sle_child_item_code)
destroy(this.sle_replace_item_code)
destroy(this.st_5)
destroy(this.pb_1)
destroy(this.gb_where_condition)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event activate;call super::activate;
/***************************************
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


end event

event ue_data_control;call super::ue_data_control;Long ROW , LVL_ROWCOUNT
CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		
		IF RB_REPLACE_MANAGE.CHECKED = TRUE THEN 
			
				DOUBLE LVDB_SESSION_ID	
				
				IF UO_SET_ITEM.TEXT() = '%' THEN 
							  F_MSGBOX(9050) //SET $$HEX9$$80bd88d444c7200085c725b858d538c194c6$$ENDHEX$$
					RETURN
				END IF
				
				 LVDB_SESSION_ID = F_BOM_QUERY_PRC( UO_SET_ITEM.TEXT() , UO_START.TEXT())
				
				IF LVDB_SESSION_ID <= 0 THEN 
					ROLLBACK;
					f_msgbox1(9051 ,UO_SET_ITEM.TEXT())    
				ELSE
					DW_1.RETRIEVE( LVDB_SESSION_ID , GVI_ORGANIZATION_ID )
					DW_1.SETFOCUS()
					ROLLBACK;
				END IF
				//$$HEX8$$00b3b4cc80bd88d420005cd4dcc22000$$ENDHEX$$
				IF CBX_SHOW_REPLACE_ITEM.CHECKED = TRUE THEN 
					F_SET_REPLACE_ITEM_4_BOM_QUERY( DW_1 )
					DW_1.RESETUPDATE()
				END IF
			ELSE
				DW_3.RETRIEVE( uo_set_item.text+'%'   ,sle_child_item_code.text+'%' , sle_replace_item_code.text+'%' , GVI_ORGANIZATION_ID)
			END IF
	CASE 'INSERT'
		     LVL_ROWCOUNT = DW_2.ROWCOUNT()
			ROW = dw_2.INSERTROW(dw_2.GETROW())
			dw_2.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(dw_2 , ROW , 'ALL')
			
			DW_2.SETITEM( ROW , 'DATESET' , F_T_SYSDATE() )	
			DW_2.SETITEM( ROW , 'DATEEND' , DATE('9999/12/31') )	
			
			IF DW_1.GETROW() > 0 THEN 
				DW_2.SETITEM( ROW , 'PARENT_ITEM_CODE' ,DW_1.OBJECT.PARENT_ITEM_CODE[DW_1.GETROW()])
				DW_2.SETITEM( ROW , 'CHILD_ITEM_CODE' ,DW_1.OBJECT.CHILD_ITEM_CODE[DW_1.GETROW()] )
				DW_2.SETITEM( ROW , 'ITEM_UNIT_QTY' ,DW_1.OBJECT.ITEM_UNIT_QTY[DW_1.GETROW()] )						
				DW_2.SETITEM( ROW , 'WORKSTAGE_CODE' ,DW_1.OBJECT.WORKSTAGE_CODE[DW_1.GETROW()] )			
				DW_2.SETITEM( ROW , 'REPLACE_SEQUENCE' , LVL_ROWCOUNT +1 )
			END IF
   		     DW_2.SETFOCUS()
			F_MSG_MDI_HELP ( F_MSG_ST(152)	 )
	CASE 'APPEND'
    		     LVL_ROWCOUNT = DW_2.ROWCOUNT()
			ROW = dw_2.INSERTROW(0)
			dw_2.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(dw_2 , ROW , 'ALL')	

			DW_2.SETITEM( ROW , 'DATESET' , F_T_SYSDATE() )	
			DW_2.SETITEM( ROW , 'DATEEND' , DATE('9999/12/31') )	
			IF DW_1.GETROW() > 0 THEN 
				DW_2.SETITEM( ROW , 'PARENT_ITEM_CODE' ,DW_1.OBJECT.PARENT_ITEM_CODE[DW_1.GETROW()])
				DW_2.SETITEM( ROW , 'CHILD_ITEM_CODE' ,DW_1.OBJECT.CHILD_ITEM_CODE[DW_1.GETROW()] )
				DW_2.SETITEM( ROW , 'ITEM_UNIT_QTY' ,DW_1.OBJECT.ITEM_UNIT_QTY[DW_1.GETROW()] )			
				DW_2.SETITEM( ROW , 'WORKSTAGE_CODE' ,DW_1.OBJECT.WORKSTAGE_CODE[DW_1.GETROW()] )			
				DW_2.SETITEM( ROW , 'REPLACE_SEQUENCE' ,LVL_ROWCOUNT+1 )				
			END IF
			DW_2.SETFOCUS()			
			F_MSG_MDI_HELP ( F_MSG_ST(152)	 )		
			
	CASE 'UPDATE'						
		   IF F_OBJECT_ROLE_CHECK() = FALSE THEN  RETURN
		   IF DW_2.UPDATE()  < 0 THEN 
				ROLLBACK;
				RETURN
			ELSE
				COMMIT;
				F_MSG_MDI_HELP(F_MSG_ST(170))
			END IF 
		
	CASE ELSE
END CHOOSE
end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())


end event

type dw_5 from w_main_root`dw_5 within w_des_replace_bom_master
integer x = 9
integer y = 324
end type

type dw_4 from w_main_root`dw_4 within w_des_replace_bom_master
integer x = 9
integer y = 324
end type

type dw_3 from w_main_root`dw_3 within w_des_replace_bom_master
integer x = 9
integer y = 304
integer width = 4507
integer height = 1388
boolean titlebar = true
string title = "BOM Replace List"
string dataobject = "d_des_item_replace_lst"
end type

type dw_2 from w_main_root`dw_2 within w_des_replace_bom_master
integer y = 1700
integer width = 4503
integer height = 832
boolean titlebar = true
string title = "Replace Item Master"
string dataobject = "d_des_item_replace_mlst"
end type

event dw_2::rbuttondown;call super::rbuttondown;IF DWO.NAME = 'parent_item_code' THEN 
//	OPEN(w_des_product_item_popup)
//	IF message.stringparm = '' THEN 
//	ELSE
//		THIS.SETITEM( ROW , 'parent_item_code' , message.stringparm )	
//		
//		TRIGGER EVENT ITEMCHANGED( ROW , THIS.OBJECT.parent_item_code , THIS.OBJECT.parent_item_code[ROW])		
//	END IF
ELSEIF DWO.NAME = 'child_item_code' THEN 
	OPEN(w_des_material_item_popup)
	IF message.stringparm = '' THEN 
	ELSE
		THIS.SETITEM( ROW , 'child_item_code' , message.stringparm )	
		
		TRIGGER EVENT ITEMCHANGED( ROW , THIS.OBJECT.child_item_code , THIS.OBJECT.child_item_code[ROW])		
	END IF
	
ELSEIF DWO.NAME = 'replace_item_code' THEN 
	
	OPEN(w_des_material_item_popup)
	IF message.stringparm = '' THEN 
	ELSE
		THIS.SETITEM( ROW , 'replace_item_code' , message.stringparm )	
		THIS.SETITEM( ROW , 'item_name' , Gst_return.Gvs_return[3] )	
		THIS.SETITEM( ROW , 'item_spec' , Gst_return.Gvs_return[4] )	
		THIS.SETITEM( ROW , 'item_uom' , Gst_return.Gvs_return[5] )
		
		Gst_return.Gvs_return[1] = ''
		Gst_return.Gvs_return[2] = ''
		Gst_return.Gvs_return[3] = ''
		Gst_return.Gvs_return[4] = ''
		Gst_return.Gvs_return[5] = ''		
		
		TRIGGER EVENT ITEMCHANGED( ROW , THIS.OBJECT.replace_item_code , THIS.OBJECT.replace_item_code[ROW])		
	END IF
END IF
end event

event dw_2::itemchanged;call super::itemchanged;THIS.ACCEPTTEXT()
IF DWO.NAME = 'parent_item_code' OR DWO.NAME = 'child_item_code'  THEN					
	
	 IF DW_2.OBJECT.PARENT_ITEM_CODE[ROW] = DW_2.OBJECT.CHILD_ITEM_CODE[ROW] THEN
		MESSAGEBOX("Error" , string(ROW)+" Row Data Incorrect, Parent and Child Same Item Code ")
		RETURN 1
	END IF
ELSEIF DWO.NAME = 'replace_item_code'  then 
	
	     f_set_item_name_spec_uom( this , row  , this.object.replace_item_code[row] )
	
END IF
end event

type dw_1 from w_main_root`dw_1 within w_des_replace_bom_master
integer x = 9
integer y = 304
integer width = 4507
integer height = 1388
boolean titlebar = true
string title = "BOM List"
string dataobject = "d_des_bom_query"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;IF CURRENTROW = 0 THEN RETURN

DW_2.RETRIEVE( dw_1.object.parent_item_code[CURRENTROW] , dw_1.object.child_item_code[CURRENTROW] ,GVI_ORGANIZATION_ID )
end event

event dw_1::doubleclicked;call super::doubleclicked;IF ROW = 0 THEN RETURN

DW_2.RETRIEVE( dw_1.object.parent_item_code[row] , dw_1.object.child_item_code[row] ,GVI_ORGANIZATION_ID )
end event

type uo_tabpages from w_main_root`uo_tabpages within w_des_replace_bom_master
end type

type uo_start from uo_ymd_calendar within w_des_replace_bom_master
integer x = 1751
integer y = 176
integer taborder = 90
boolean bringtotop = true
end type

on uo_start.destroy
call uo_ymd_calendar::destroy
end on

type st_1 from so_statictext within w_des_replace_bom_master
integer x = 1751
integer y = 116
integer width = 398
integer height = 56
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Dateset"
end type

type cbx_show_replace_item from checkbox within w_des_replace_bom_master
integer x = 3310
integer y = 136
integer width = 581
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
string text = "Show Replace Item"
end type

type rb_replace_manage from so_radiobutton within w_des_replace_bom_master
integer x = 37
integer y = 100
integer width = 635
boolean bringtotop = true
integer weight = 700
string text = "BOM Replace Manage"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true
selected_data_window = dw_1
end event

type rb_replace_list from so_radiobutton within w_des_replace_bom_master
integer x = 37
integer y = 184
integer width = 521
boolean bringtotop = true
integer weight = 700
string text = "BOM Replace List"
end type

event clicked;call super::clicked;dw_3.bringtotop = true
selected_data_window = dw_3
end event

type uo_set_item from uo_set_item_code within w_des_replace_bom_master
integer x = 763
integer y = 176
integer width = 983
integer height = 84
integer taborder = 50
boolean bringtotop = true
end type

on uo_set_item.destroy
call uo_set_item_code::destroy
end on

type st_2 from so_statictext within w_des_replace_bom_master
integer x = 773
integer y = 112
integer width = 489
integer height = 56
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Set Item Code"
end type

type st_3 from so_statictext within w_des_replace_bom_master
integer x = 1294
integer y = 112
integer width = 448
integer height = 56
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Item Name"
end type

type st_4 from statictext within w_des_replace_bom_master
integer x = 2162
integer y = 112
integer width = 503
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "Child Item Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_child_item_code from singlelineedit within w_des_replace_bom_master
event ue_editchange pbm_enchange
integer x = 2162
integer y = 176
integer width = 503
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event ue_editchange;STRING LVS_item_name
DW_3.SETFILTER('')
DW_3.FILTER()

IF THIS.TEXT = '' THEN 
	
	DW_3.SETFILTER('')
	DW_3.FILTER()	
	RETURN 
ELSE
	LVS_item_name = '%'+this.text+'%'
END IF

DW_3.SETFILTER("child_item_code LIKE '"+LVS_item_name+"'")
DW_3.FILTER()

end event

type sle_replace_item_code from singlelineedit within w_des_replace_bom_master
event ue_editchange pbm_enchange
integer x = 2665
integer y = 176
integer width = 503
integer height = 84
integer taborder = 100
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event ue_editchange;STRING LVS_item_name
DW_3.SETFILTER('')
DW_3.FILTER()

IF THIS.TEXT = '' THEN 
	
	DW_3.SETFILTER('')
	DW_3.FILTER()	
	RETURN 
ELSE
	LVS_item_name = '%'+this.text+'%'
END IF

DW_3.SETFILTER("replace_item_code LIKE '"+LVS_item_name+"'")
DW_3.FILTER()

end event

type st_5 from statictext within w_des_replace_bom_master
integer x = 2665
integer y = 108
integer width = 503
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "Replace Item Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_1 from so_commandbutton within w_des_replace_bom_master
integer x = 3936
integer y = 96
integer taborder = 30
boolean bringtotop = true
string text = "Excel Load"
end type

event clicked;call super::clicked;open(w_des_bom_replace_item_excel_form_popup)
end event

type gb_where_condition from so_groupbox within w_des_replace_bom_master
integer x = 727
integer y = 4
integer width = 2505
integer height = 300
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_1 from so_groupbox within w_des_replace_bom_master
integer y = 4
integer width = 722
integer height = 300
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_2 from so_groupbox within w_des_replace_bom_master
integer x = 3246
integer width = 1271
integer height = 300
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

