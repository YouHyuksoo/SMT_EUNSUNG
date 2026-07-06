HA$PBExportHeader$w_des_bom_modify_master.srw
$PBExportComments$BOM $$HEX4$$18c215c800adacb9$$ENDHEX$$
forward
global type w_des_bom_modify_master from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_des_bom_modify_master
end type
type st_1 from so_statictext within w_des_bom_modify_master
end type
type cbx_show_replace_item from checkbox within w_des_bom_modify_master
end type
type ddlb_item_division from uo_basecode within w_des_bom_modify_master
end type
type st_3 from so_statictext within w_des_bom_modify_master
end type
type st_4 from so_statictext within w_des_bom_modify_master
end type
type sle_1 from so_singlelineedit within w_des_bom_modify_master
end type
type cbx_show_hide from checkbox within w_des_bom_modify_master
end type
type cbx_auto_update from checkbox within w_des_bom_modify_master
end type
type st_14 from so_statictext within w_des_bom_modify_master
end type
type sle_item_name from so_singlelineedit within w_des_bom_modify_master
end type
type st_2 from so_statictext within w_des_bom_modify_master
end type
type rb_all from so_radiobutton within w_des_bom_modify_master
end type
type rb_inventory_qty from so_radiobutton within w_des_bom_modify_master
end type
type rb_1 from so_radiobutton within w_des_bom_modify_master
end type
type rb_2 from so_radiobutton within w_des_bom_modify_master
end type
type rb_3 from so_radiobutton within w_des_bom_modify_master
end type
type rb_4 from so_radiobutton within w_des_bom_modify_master
end type
type pb_1 from so_commandbutton within w_des_bom_modify_master
end type
type pb_2 from so_commandbutton within w_des_bom_modify_master
end type
type ddlb_item_code from uo_product_item_code within w_des_bom_modify_master
end type
type ddlb_workstage_code from uo_workstage_code_all within w_des_bom_modify_master
end type
type st_5 from so_statictext within w_des_bom_modify_master
end type
type pb_3 from so_commandbutton within w_des_bom_modify_master
end type
type st_6 from so_statictext within w_des_bom_modify_master
end type
type ddlb_model_name from uo_model_name_ddlb within w_des_bom_modify_master
end type
type gb_1 from so_groupbox within w_des_bom_modify_master
end type
type gb_3 from so_groupbox within w_des_bom_modify_master
end type
type gb_2 from so_groupbox within w_des_bom_modify_master
end type
type gb_4 from so_groupbox within w_des_bom_modify_master
end type
end forward

global type w_des_bom_modify_master from w_main_root
integer width = 5417
integer height = 2804
string title = "ENG BOM Master"
string ivs_dw_2_use_focusindicator = "Y"
string ivs_dw_2_selected_row_yn = "Y"
uo_dateset uo_dateset
st_1 st_1
cbx_show_replace_item cbx_show_replace_item
ddlb_item_division ddlb_item_division
st_3 st_3
st_4 st_4
sle_1 sle_1
cbx_show_hide cbx_show_hide
cbx_auto_update cbx_auto_update
st_14 st_14
sle_item_name sle_item_name
st_2 st_2
rb_all rb_all
rb_inventory_qty rb_inventory_qty
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
rb_4 rb_4
pb_1 pb_1
pb_2 pb_2
ddlb_item_code ddlb_item_code
ddlb_workstage_code ddlb_workstage_code
st_5 st_5
pb_3 pb_3
st_6 st_6
ddlb_model_name ddlb_model_name
gb_1 gb_1
gb_3 gb_3
gb_2 gb_2
gb_4 gb_4
end type
global w_des_bom_modify_master w_des_bom_modify_master

on w_des_bom_modify_master.create
int iCurrent
call super::create
this.uo_dateset=create uo_dateset
this.st_1=create st_1
this.cbx_show_replace_item=create cbx_show_replace_item
this.ddlb_item_division=create ddlb_item_division
this.st_3=create st_3
this.st_4=create st_4
this.sle_1=create sle_1
this.cbx_show_hide=create cbx_show_hide
this.cbx_auto_update=create cbx_auto_update
this.st_14=create st_14
this.sle_item_name=create sle_item_name
this.st_2=create st_2
this.rb_all=create rb_all
this.rb_inventory_qty=create rb_inventory_qty
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.rb_4=create rb_4
this.pb_1=create pb_1
this.pb_2=create pb_2
this.ddlb_item_code=create ddlb_item_code
this.ddlb_workstage_code=create ddlb_workstage_code
this.st_5=create st_5
this.pb_3=create pb_3
this.st_6=create st_6
this.ddlb_model_name=create ddlb_model_name
this.gb_1=create gb_1
this.gb_3=create gb_3
this.gb_2=create gb_2
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateset
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cbx_show_replace_item
this.Control[iCurrent+4]=this.ddlb_item_division
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.st_4
this.Control[iCurrent+7]=this.sle_1
this.Control[iCurrent+8]=this.cbx_show_hide
this.Control[iCurrent+9]=this.cbx_auto_update
this.Control[iCurrent+10]=this.st_14
this.Control[iCurrent+11]=this.sle_item_name
this.Control[iCurrent+12]=this.st_2
this.Control[iCurrent+13]=this.rb_all
this.Control[iCurrent+14]=this.rb_inventory_qty
this.Control[iCurrent+15]=this.rb_1
this.Control[iCurrent+16]=this.rb_2
this.Control[iCurrent+17]=this.rb_3
this.Control[iCurrent+18]=this.rb_4
this.Control[iCurrent+19]=this.pb_1
this.Control[iCurrent+20]=this.pb_2
this.Control[iCurrent+21]=this.ddlb_item_code
this.Control[iCurrent+22]=this.ddlb_workstage_code
this.Control[iCurrent+23]=this.st_5
this.Control[iCurrent+24]=this.pb_3
this.Control[iCurrent+25]=this.st_6
this.Control[iCurrent+26]=this.ddlb_model_name
this.Control[iCurrent+27]=this.gb_1
this.Control[iCurrent+28]=this.gb_3
this.Control[iCurrent+29]=this.gb_2
this.Control[iCurrent+30]=this.gb_4
end on

on w_des_bom_modify_master.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.st_1)
destroy(this.cbx_show_replace_item)
destroy(this.ddlb_item_division)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.sle_1)
destroy(this.cbx_show_hide)
destroy(this.cbx_auto_update)
destroy(this.st_14)
destroy(this.sle_item_name)
destroy(this.st_2)
destroy(this.rb_all)
destroy(this.rb_inventory_qty)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.ddlb_item_code)
destroy(this.ddlb_workstage_code)
destroy(this.st_5)
destroy(this.pb_3)
destroy(this.st_6)
destroy(this.ddlb_model_name)
destroy(this.gb_1)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.gb_4)
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
Ivs_resize_type    = 'MASTER_DETAIL_12T_3B'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default

ivs_dw_1_retrice_cancel_popup_open = 'Y'
ivs_dw_2_retrice_cancel_popup_open = 'N'
ivs_dw_3_retrice_cancel_popup_open = 'N'
ivs_dw_4_retrice_cancel_popup_open = 'N'
ivs_dw_5_retrice_cancel_popup_open = 'N'

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
INT I 
DOUBLE LVI_CHECK

CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
                dw_1.retrieve( ddlb_model_name.getcode()+'%'  , ddlb_item_code.text+'%' , uo_dateset.text() , ddlb_item_division.getcode()+'%' , Gvi_organization_id  )
	CASE 'UPDATE'
			
			dw_3.accepttext( )
			msg = f_msgbox( 1170)

			if msg = 1 then

//				if 	dw_1.update( ) < 0 then 
//					rollback ;
//				else
//					commit ;
//				end if 
//				
//				if dw_2.modifiedcount( ) > 0 then 
//					
//						if dw_2.update( ) < 0 then 
//							rollback ;
//							return
//						else
//							commit ;
//							F_MSG_ST(170) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"					
//						end if				
//				end if

				if dw_3.modifiedcount( ) > 0 then 
					if dw_3.update( ) < 0 then 
						rollback ;
						return
					else
						commit ;
						  F_MSG_ST(170) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"					
					end if
				end if
			else
				dw_2.resetupdate( )
			end if

	CASE ELSE
END CHOOSE
end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
//dw_1.retrieve( ddlb_item_code.text+'%' , uo_dateset.text() , ddlb_item_division.getcode()+'%' , Gvi_organization_id  )

end event

type dw_5 from w_main_root`dw_5 within w_des_bom_modify_master
integer y = 552
end type

type dw_4 from w_main_root`dw_4 within w_des_bom_modify_master
integer y = 552
integer height = 1188
end type

type dw_3 from w_main_root`dw_3 within w_des_bom_modify_master
integer y = 1748
integer width = 4466
integer height = 596
boolean titlebar = true
string title = "Raw Bom List"
string dataobject = "d_des_raw_bom_4_modify_lst"
end type

event dw_3::rbuttondown;call super::rbuttondown;IF DWO.NAME = 'parent_item_code' THEN
	OPEN(w_des_item_popup)
	IF message.stringparm = '' THEN 
	ELSE	
		THIS.SETITEM( ROW , 'parent_item_code' , message.stringparm )
	END IF		

ELSEIF DWO.NAME = 'child_item_code' THEN 
	OPEN(w_des_item_popup)
	IF message.stringparm = '' THEN 
	ELSE	
		THIS.SETITEM( ROW , 'child_item_code' , message.stringparm )	
		THIS.OBJECT.ITEM_NAME[ROW] = Gst_return.Gvs_return[3]
		THIS.OBJECT.ITEM_SPEC[ROW] = Gst_return.Gvs_return[4]		
		THIS.OBJECT.ITEM_UOM[ROW] = Gst_return.Gvs_return[5]				
		
		TRIGGER EVENT ITEMCHANGED( ROW , THIS.OBJECT.child_item_code , THIS.OBJECT.child_item_code[ROW])				
	END IF		
END IF
	
end event

event dw_3::itemchanged;call super::itemchanged;if 	dwo.name = 'child_item_code' then 
	
	    this.object.item_type[row] = f_get_item_type_from_item( this.object.child_item_code[row]) 
	    this.object.line_type[row] = f_get_line_type_from_item( this.object.child_item_code[row]) 
	
end if
end event

type dw_2 from w_main_root`dw_2 within w_des_bom_modify_master
integer x = 2235
integer y = 552
integer width = 2231
integer height = 1188
boolean titlebar = true
string title = "BOM List"
string dataobject = "d_des_bom_query"
end type

event dw_2::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return

dw_3.retrieve( this.object.parent_item_code[currentrow] , this.object.child_item_code[currentrow]  , gvi_organization_id )

if cbx_auto_update.checked = true and dw_2.modifiedcount( ) > 0 then 
	f_update()
end if
end event

event dw_2::clicked;call super::clicked;if  dwo.name = 'b_resize' then 
	
	this.bringtotop = true
	if dwo.text = '<' then
	
		dw_2.x = dw_3.x
		dw_2.width = dw_3.width
		dwo.text  = '>' 
	else
		
		dw_2.x = dw_1.x + dw_1.width
		dw_2.width = dw_1.width
		dwo.text = '<' 		
	end if

elseif dwo.name = 'b_del' then 
	
	String lvs_parent_item_code , lvs_child_item_code , lvs_item_type , lvs_line_type 
	Datetime lvdt_dateset , lvdt_dateend
	
	msg = f_msgbox(1003 ) //$$HEX7$$adc01cc8200060d54cae94c62000$$ENDHEX$$
	if msg = 1 then 
	else
		return
	end if 
	
	
	lvs_parent_item_code =  this.object.parent_item_code[row] 
	lvs_child_item_code =  this.object.child_item_code[row] 	
	lvs_line_type =  this.object.line_type[row] 	
	lvs_item_type =  this.object.item_type[row] 		
	
	lvdt_dateset = this.object.dateset[row]
	lvdt_dateend = this.object.dateend[row]
	
	delete from id_eng_bom 
    where parent_item_code = :lvs_parent_item_code 
	   and child_item_code = :lvs_child_item_code 
	   and line_type = :lvs_line_type
	   and item_type = :lvs_item_type
	   and dateset = :lvdt_dateset
	   and dateend = :lvdt_dateend
	   and organization_id = :gvi_organization_id ;
		
	if f_sql_check() < 0 then 
		return
	end if 
	
	msg = f_msgbox(1170)
	if msg = 1 then 
		this.object.status[row] = 'DELETE'
		commit;
	else
		rollback;
	end if 
	
end if
end event

type dw_1 from w_main_root`dw_1 within w_des_bom_modify_master
integer y = 552
integer width = 2231
integer height = 1188
boolean titlebar = true
string title = "Item List"
string dataobject = "d_des_item_4_bom_modify_lst"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;IF CURRENTROW < 1 THEN RETURN

DOUBLE LVDB_SESSION_ID
DW_2.RESET()


IF THIS.OBJECT.BOM_EXISTS_YN[CURRENTROW] = 'EXISTS' THEN
ELSE
	RETURN
END IF

IF  this.object.item_code[currentrow] = '%' THEN 
     F_MSGBOX(9050) //SET $$HEX9$$80bd88d444c7200085c725b858d538c194c6$$ENDHEX$$
	RETURN
END IF

if cbx_show_hide.checked = true  then
	
LVDB_SESSION_ID = F_BOM_QUERY_ALL_PRC( this.object.item_code[currentrow] , uo_dateset.text())
	
else
	
LVDB_SESSION_ID = F_BOM_QUERY_PRC( this.object.item_code[currentrow] , uo_dateset.text())

end if
IF LVDB_SESSION_ID <= 0 THEN
	ROLLBACK;
	f_msgbox1(9051 ,this.object.item_code[currentrow]  )    	
ELSE
	     dw_2.RETRIEVE( LVDB_SESSION_ID , GVI_ORGANIZATION_ID )
		dw_2.SETFOCUS()
	ROLLBACK;
END IF

//$$HEX8$$00b3b4cc80bd88d420005cd4dcc22000$$ENDHEX$$
IF CBX_SHOW_REPLACE_ITEM.CHECKED = TRUE THEN 
	F_SET_REPLACE_ITEM_4_BOM_QUERY( dw_2 )
	dw_2.RESETUPDATE()
END IF
end event

type uo_tabpages from w_main_root`uo_tabpages within w_des_bom_modify_master
end type

type uo_dateset from uo_ymd_calendar within w_des_bom_modify_master
integer x = 2158
integer y = 160
integer width = 402
integer taborder = 100
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type st_1 from so_statictext within w_des_bom_modify_master
integer x = 2158
integer y = 88
integer width = 393
integer height = 68
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Dateset"
end type

type cbx_show_replace_item from checkbox within w_des_bom_modify_master
integer x = 2318
integer y = 332
integer width = 727
integer height = 80
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

type ddlb_item_division from uo_basecode within w_des_bom_modify_master
integer x = 2574
integer y = 160
integer width = 539
integer taborder = 30
boolean bringtotop = true
end type

event constructor;call super::constructor;redraw( 'ITEM DIVISION')

end event

type st_3 from so_statictext within w_des_bom_modify_master
integer x = 2578
integer y = 80
integer width = 539
integer height = 68
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Item Division"
end type

type st_4 from so_statictext within w_des_bom_modify_master
integer x = 1710
integer y = 92
integer width = 443
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Item Class"
end type

type sle_1 from so_singlelineedit within w_des_bom_modify_master
integer x = 1710
integer y = 160
integer width = 443
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

LVS_COLUMN = 'ITEM_CLASS'
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

type cbx_show_hide from checkbox within w_des_bom_modify_master
integer x = 2318
integer y = 400
integer width = 727
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
string text = "Show Hide Item"
boolean checked = true
end type

type cbx_auto_update from checkbox within w_des_bom_modify_master
integer x = 2318
integer y = 456
integer width = 727
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
string text = "Row Chang Auto Update"
boolean checked = true
end type

type st_14 from so_statictext within w_des_bom_modify_master
integer x = 1257
integer y = 92
integer width = 448
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Item Name"
end type

type sle_item_name from so_singlelineedit within w_des_bom_modify_master
integer x = 1257
integer y = 160
integer width = 448
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

type st_2 from so_statictext within w_des_bom_modify_master
integer x = 763
integer y = 92
integer width = 489
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type rb_all from so_radiobutton within w_des_bom_modify_master
integer x = 165
integer y = 364
integer width = 494
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "All"
boolean checked = true
end type

event clicked;call super::clicked;dw_2.setfilter( '')
dw_2.filter( )
end event

type rb_inventory_qty from so_radiobutton within w_des_bom_modify_master
integer x = 160
integer y = 464
integer width = 494
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Line Type <> A"
end type

event clicked;call super::clicked;dw_2.setfilter("line_type <> 'A'")
dw_2.filter( )
end event

type rb_1 from so_radiobutton within w_des_bom_modify_master
integer x = 859
integer y = 464
integer width = 453
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Line Type =D"
end type

event clicked;call super::clicked;dw_2.setfilter("line_type = 'D'")
dw_2.filter( )
end event

type rb_2 from so_radiobutton within w_des_bom_modify_master
integer x = 1573
integer y = 364
integer width = 453
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Line Type =M"
end type

event clicked;call super::clicked;dw_2.setfilter("line_type = 'M'")
dw_2.filter( )
end event

type rb_3 from so_radiobutton within w_des_bom_modify_master
integer x = 1573
integer y = 464
integer width = 512
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Line Type <>T"
end type

event clicked;call super::clicked;dw_2.setfilter("line_type <> 'T'")
dw_2.filter( )
end event

type rb_4 from so_radiobutton within w_des_bom_modify_master
integer x = 859
integer y = 364
integer width = 453
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Line Type = A"
end type

event clicked;call super::clicked;dw_2.setfilter("line_type = 'A'")
dw_2.filter( )
end event

type pb_1 from so_commandbutton within w_des_bom_modify_master
integer x = 3205
integer y = 64
integer width = 439
integer height = 132
integer taborder = 40
boolean bringtotop = true
string text = "Delete All"
end type

event clicked;call super::clicked;if f_msgbox(1160)  = 1 then 
else
	return 
end if 

if dw_2.rowcount( ) < 1 then return 

long i
string lvs_parent_item_code , lvs_child_item_code
do
	i++
	
	lvs_parent_item_code = dw_2.object.parent_item_code[i]
	lvs_child_item_code = dw_2.object.child_item_code[i]	
	
	delete from id_eng_bom 
	where parent_item_code = :lvs_parent_item_code
  	   and child_item_code = :lvs_child_item_code
	   and organization_id = :gvi_organization_id ;
	
	if f_sql_check() < 0 then 
		return 		
	end if 	

loop until i = dw_2.rowcount( )
	
	msg =f_msgbox(170) 
	if msg = 1 then 
		commit ;
		f_retrieve()
		dw_2.reset()
	else
		rollback;
	end if 
	
end event

type pb_2 from so_commandbutton within w_des_bom_modify_master
integer x = 3205
integer y = 196
integer width = 439
integer height = 132
integer taborder = 50
boolean bringtotop = true
string text = "Excel Load"
end type

event clicked;call super::clicked;//open(w_des_bom_excel_form_lg_popup)
open(w_des_bom_excel_form_eunsung_popup)
end event

type ddlb_item_code from uo_product_item_code within w_des_bom_modify_master
integer x = 731
integer y = 160
integer taborder = 20
boolean bringtotop = true
end type

type ddlb_workstage_code from uo_workstage_code_all within w_des_bom_modify_master
integer x = 3753
integer y = 184
integer taborder = 50
boolean bringtotop = true
end type

type st_5 from so_statictext within w_des_bom_modify_master
integer x = 3758
integer y = 96
integer width = 631
integer height = 68
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Workstage Code"
end type

type pb_3 from so_commandbutton within w_des_bom_modify_master
integer x = 3758
integer y = 296
integer width = 631
integer height = 132
integer taborder = 60
boolean bringtotop = true
string text = "Change Workstage"
end type

event clicked;call super::clicked;if dw_2.getrow() < 1 then return

long i , j
string lvs_level_org , lvs_level_curr , lvs_workstage_code , lvs_parent_item_code , lvs_child_item_code

if ddlb_workstage_code.getcode() = '' or isnull(ddlb_workstage_code.getcode() ) or ddlb_workstage_code.getcode() = '%' then 
	
	//Mes sagebox("$$HEX2$$55d678c7$$ENDHEX$$" , "$$HEX17$$f5ac15c854cfdcb400ac200098c7bbba200020c1ddd0200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$")
	f_msg( "$$HEX17$$f5ac15c854cfdcb400ac200098c7bbba200020c1ddd0200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$",'P') 
	return
else
	lvs_workstage_code = ddlb_workstage_code.getcode()
end if 

i = dw_2.getrow()
lvs_level_org =  Right(string(dw_2.object.bom_level[i]) , 1)
do
	
	

	
	i++
	lvs_level_curr = Right(string(dw_2.object.bom_level[i]) ,1 )
	
	//=========================
	if lvs_level_org >= lvs_level_curr then
		exit
	else
		j++
		lvs_parent_item_code = dw_2.object.parent_item_code[i]
		lvs_child_item_code = dw_2.object.child_item_code[i]
		
		update id_eng_bom set workstage_code = :lvs_workstage_code
		 where parent_item_code = :lvs_parent_item_code
		     and child_item_code = :lvs_child_item_code 
			 and dateset <= sysdate 
			 and dateend >= sysdate 
			 and organization_id = :gvi_organization_id ;
			 
		if f_sql_check() < 0 then
			return 
		end if 

	
		f_msg_mdi_help( string(j) )
			continue
	end if 
	
loop until i = dw_2.rowcount( )
commit ;


end event

type st_6 from so_statictext within w_des_bom_modify_master
integer x = 69
integer y = 92
integer width = 654
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Model Name"
end type

type ddlb_model_name from uo_model_name_ddlb within w_des_bom_modify_master
integer x = 46
integer y = 160
integer width = 681
integer taborder = 30
boolean bringtotop = true
end type

type gb_1 from so_groupbox within w_des_bom_modify_master
integer x = 9
integer width = 3145
integer height = 296
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_des_bom_modify_master
integer x = 14
integer y = 296
integer width = 3141
integer height = 252
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Filter"
end type

type gb_2 from so_groupbox within w_des_bom_modify_master
integer x = 3698
integer width = 745
integer height = 540
integer taborder = 40
string text = "Process"
end type

type gb_4 from so_groupbox within w_des_bom_modify_master
integer x = 3163
integer width = 521
integer height = 540
integer taborder = 30
string text = "Process"
end type

