HA$PBExportHeader$w_smt_bom_create_master.srw
$PBExportComments$BOM $$HEX4$$18c215c800adacb9$$ENDHEX$$
forward
global type w_smt_bom_create_master from w_main_root
end type
type st_2 from so_statictext within w_smt_bom_create_master
end type
type st_4 from so_statictext within w_smt_bom_create_master
end type
type tab_1 from tab within w_smt_bom_create_master
end type
type tabpage_1 from userobject within tab_1
end type
type cb_7 from so_commandbutton within tabpage_1
end type
type cb_4 from so_commandbutton within tabpage_1
end type
type cb_6 from so_commandbutton within tabpage_1
end type
type cb_1 from so_commandbutton within tabpage_1
end type
type tabpage_1 from userobject within tab_1
cb_7 cb_7
cb_4 cb_4
cb_6 cb_6
cb_1 cb_1
end type
type tabpage_2 from userobject within tab_1
end type
type st_11 from so_statictext within tabpage_2
end type
type ddlb_supplier_code from uo_supplier_name_code within tabpage_2
end type
type cb_11 from commandbutton within tabpage_2
end type
type cb_9 from so_commandbutton within tabpage_2
end type
type cb_3 from so_commandbutton within tabpage_2
end type
type cb_2 from so_commandbutton within tabpage_2
end type
type tabpage_2 from userobject within tab_1
st_11 st_11
ddlb_supplier_code ddlb_supplier_code
cb_11 cb_11
cb_9 cb_9
cb_3 cb_3
cb_2 cb_2
end type
type tabpage_3 from userobject within tab_1
end type
type cb_8 from so_commandbutton within tabpage_3
end type
type cb_5 from so_commandbutton within tabpage_3
end type
type tabpage_3 from userobject within tab_1
cb_8 cb_8
cb_5 cb_5
end type
type tabpage_4 from userobject within tab_1
end type
type cb_10 from so_commandbutton within tabpage_4
end type
type st_3 from so_statictext within tabpage_4
end type
type st_1 from so_statictext within tabpage_4
end type
type ddlb_new_model_name from uo_model_name_ddlb within tabpage_4
end type
type ddlb_old_model_name from uo_model_name_ddlb within tabpage_4
end type
type tabpage_4 from userobject within tab_1
cb_10 cb_10
st_3 st_3
st_1 st_1
ddlb_new_model_name ddlb_new_model_name
ddlb_old_model_name ddlb_old_model_name
end type
type tabpage_5 from userobject within tab_1
end type
type ddlb_line_code_change2 from uo_line_code within tabpage_5
end type
type st_9 from so_statictext within tabpage_5
end type
type st_8 from so_statictext within tabpage_5
end type
type cb_12 from so_commandbutton within tabpage_5
end type
type ddlb_line_code_change1 from uo_line_code within tabpage_5
end type
type tabpage_5 from userobject within tab_1
ddlb_line_code_change2 ddlb_line_code_change2
st_9 st_9
st_8 st_8
cb_12 cb_12
ddlb_line_code_change1 ddlb_line_code_change1
end type
type tab_1 from tab within w_smt_bom_create_master
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
end type
type cb_doit from so_commandbutton within w_smt_bom_create_master
end type
type em_number from so_editmask within w_smt_bom_create_master
end type
type rb_all from so_radiobutton within w_smt_bom_create_master
end type
type rb_top from so_radiobutton within w_smt_bom_create_master
end type
type rb_bottom from so_radiobutton within w_smt_bom_create_master
end type
type sle_table_id from so_singlelineedit within w_smt_bom_create_master
end type
type st_7 from so_statictext within w_smt_bom_create_master
end type
type dw_6 from datawindow within w_smt_bom_create_master
end type
type ddlb_line_code from uo_line_code within w_smt_bom_create_master
end type
type uo_dateset from uo_ymd_calendar within w_smt_bom_create_master
end type
type st_5 from so_statictext within w_smt_bom_create_master
end type
type sle_revision from so_singlelineedit within w_smt_bom_create_master
end type
type st_6 from so_statictext within w_smt_bom_create_master
end type
type ddlb_feeder_shaft from uo_feeder_shaft_dynamic within w_smt_bom_create_master
end type
type st_12 from so_statictext within w_smt_bom_create_master
end type
type ddlb_customer_code from uo_customer_code_name within w_smt_bom_create_master
end type
type st_10 from statictext within w_smt_bom_create_master
end type
type ddlb_model_name from uo_smt_layout_model_name_ddlb within w_smt_bom_create_master
end type
type gb_1 from so_groupbox within w_smt_bom_create_master
end type
type gb_3 from so_groupbox within w_smt_bom_create_master
end type
end forward

global type w_smt_bom_create_master from w_main_root
integer width = 5106
integer height = 3368
string title = "SMT BOM Master"
windowstate windowstate = maximized!
st_2 st_2
st_4 st_4
tab_1 tab_1
cb_doit cb_doit
em_number em_number
rb_all rb_all
rb_top rb_top
rb_bottom rb_bottom
sle_table_id sle_table_id
st_7 st_7
dw_6 dw_6
ddlb_line_code ddlb_line_code
uo_dateset uo_dateset
st_5 st_5
sle_revision sle_revision
st_6 st_6
ddlb_feeder_shaft ddlb_feeder_shaft
st_12 st_12
ddlb_customer_code ddlb_customer_code
st_10 st_10
ddlb_model_name ddlb_model_name
gb_1 gb_1
gb_3 gb_3
end type
global w_smt_bom_create_master w_smt_bom_create_master

on w_smt_bom_create_master.create
int iCurrent
call super::create
this.st_2=create st_2
this.st_4=create st_4
this.tab_1=create tab_1
this.cb_doit=create cb_doit
this.em_number=create em_number
this.rb_all=create rb_all
this.rb_top=create rb_top
this.rb_bottom=create rb_bottom
this.sle_table_id=create sle_table_id
this.st_7=create st_7
this.dw_6=create dw_6
this.ddlb_line_code=create ddlb_line_code
this.uo_dateset=create uo_dateset
this.st_5=create st_5
this.sle_revision=create sle_revision
this.st_6=create st_6
this.ddlb_feeder_shaft=create ddlb_feeder_shaft
this.st_12=create st_12
this.ddlb_customer_code=create ddlb_customer_code
this.st_10=create st_10
this.ddlb_model_name=create ddlb_model_name
this.gb_1=create gb_1
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.st_4
this.Control[iCurrent+3]=this.tab_1
this.Control[iCurrent+4]=this.cb_doit
this.Control[iCurrent+5]=this.em_number
this.Control[iCurrent+6]=this.rb_all
this.Control[iCurrent+7]=this.rb_top
this.Control[iCurrent+8]=this.rb_bottom
this.Control[iCurrent+9]=this.sle_table_id
this.Control[iCurrent+10]=this.st_7
this.Control[iCurrent+11]=this.dw_6
this.Control[iCurrent+12]=this.ddlb_line_code
this.Control[iCurrent+13]=this.uo_dateset
this.Control[iCurrent+14]=this.st_5
this.Control[iCurrent+15]=this.sle_revision
this.Control[iCurrent+16]=this.st_6
this.Control[iCurrent+17]=this.ddlb_feeder_shaft
this.Control[iCurrent+18]=this.st_12
this.Control[iCurrent+19]=this.ddlb_customer_code
this.Control[iCurrent+20]=this.st_10
this.Control[iCurrent+21]=this.ddlb_model_name
this.Control[iCurrent+22]=this.gb_1
this.Control[iCurrent+23]=this.gb_3
end on

on w_smt_bom_create_master.destroy
call super::destroy
destroy(this.st_2)
destroy(this.st_4)
destroy(this.tab_1)
destroy(this.cb_doit)
destroy(this.em_number)
destroy(this.rb_all)
destroy(this.rb_top)
destroy(this.rb_bottom)
destroy(this.sle_table_id)
destroy(this.st_7)
destroy(this.dw_6)
destroy(this.ddlb_line_code)
destroy(this.uo_dateset)
destroy(this.st_5)
destroy(this.sle_revision)
destroy(this.st_6)
destroy(this.ddlb_feeder_shaft)
destroy(this.st_12)
destroy(this.ddlb_customer_code)
destroy(this.st_10)
destroy(this.ddlb_model_name)
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
Ivs_resize_type    = 'MASTER_DETAIL_145_23M'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL ) 
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
STRING  lvs_set_item_yn
DOUBLE LVI_CHECK

CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		
				dw_1.reset()
				dw_2.reset()
				dw_3.reset()
				rollback;
				lvs_set_item_yn = 'Y'

				dw_6.retrieve( ddlb_model_name.getcode()  , gvi_organization_id )
				dw_1.retrieve( ddlb_model_name.getcode()  , uo_dateset.text( ) ,  ddlb_line_code.getcode()+'%' , '%' ,sle_revision.text+'%' ,  ddlb_feeder_shaft.getcode()+'%' ,   gvi_organization_id )
				dw_3.retrieve (ddlb_model_name.getcode()  , gvi_organization_id )

	CASE 'INSERT'
			ROW = dw_1.INSERTROW(dw_1.GETROW())
			dw_1.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(dw_1 , ROW , 'ALL')
			F_MSG_MDI_HELP( F_MSG_ST(152))		
	CASE 'APPEND'
			ROW = dw_1.INSERTROW(0)
			dw_1.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(dw_1 , ROW , 'ALL')
			F_MSG_MDI_HELP( F_MSG_ST(152))				
	CASE 'DELETE'			
			msg = f_msgbox(1003)
			if msg = 1 then 
				dw_1.deleterow(dw_1.getrow())
			end if 
	CASE 'UPDATE'

			dw_2.accepttext( )
			msg = f_msgbox( 1170)
			if msg = 1 then
				
				if dw_1.update( ) < 0 then 
					rollback ;
					return
				else
					commit ;
					  F_MSG_ST(170) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"					
				end if				
				
				if dw_2.update( ) < 0 then 
					rollback ;
					return
				else
					commit ;
					F_MSG_ST(170) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"					
				end if
				
			end if
	CASE ELSE
END CHOOSE
end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())


dw_6.settransobject( sqlca)
f_set_column_dddw(dw_1)
end event

event close;call super::close;ROLLBACK;
end event

type dw_5 from w_main_root`dw_5 within w_smt_bom_create_master
integer y = 672
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_smt_bom_create_master
integer y = 676
integer width = 2231
integer height = 764
integer taborder = 0
boolean titlebar = true
end type

type dw_3 from w_main_root`dw_3 within w_smt_bom_create_master
integer x = 2240
integer y = 2648
integer width = 2231
integer height = 564
integer taborder = 60
boolean titlebar = true
string title = "No Replace List"
string dataobject = "d_des_bom_smt_no_replace_4_modify_lst"
end type

event dw_3::itemchanged;call super::itemchanged;if dwo.name = 'model_name' then 
	datawindowchild IDW_CHILD
	
	THIS.GETCHILD( 'MODEL_SUFFIX' , IDW_CHILD)
	IDW_CHILD.settransobject( SQLCA) 
	IDW_CHILD.RETrieve(  data , GVI_ORGANIZATION_ID ) 
	IDW_CHILD.insertrow(1)	
end if 
end event

event dw_3::rbuttondown;call super::rbuttondown;if dwo.name = 'replace_item_code' THEN 
	OPEN(w_des_item_popup)
	IF message.stringparm = '' THEN 
	ELSE	
		THIS.SETITEM( ROW , 'replace_item_code' , message.stringparm )
	END IF		
end if 
end event

type dw_2 from w_main_root`dw_2 within w_smt_bom_create_master
integer x = 5
integer y = 2648
integer width = 2231
integer height = 564
integer taborder = 50
boolean titlebar = true
string title = "Replace Item"
string dataobject = "d_des_bom_smt_replace_4_modify_lst"
end type

event dw_2::rbuttondown;call super::rbuttondown;IF DWO.NAME = 'parent_item_code' THEN
	OPEN(w_des_item_popup)
	IF message.stringparm = '' THEN 
	ELSE	
		THIS.SETITEM( ROW , 'parent_item_code' , message.stringparm )
	END IF		
ELSEIF DWO.NAME = 'replace_item_code' THEN
	OPEN(w_des_item_popup)
	IF message.stringparm = '' THEN 
	ELSE	
		THIS.SETITEM( ROW , 'replace_item_code' , message.stringparm )
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
	
if dwo.name = 'location_code' then
	
	open( w_location_barcode_popup)
	
	if Gst_return.gvb_return = true then
		
		this.object.location_code[row] = message.stringparm
		
	else
	end if 
	
	
end if 	
end event

event dw_2::itemchanged;call super::itemchanged;if 	dwo.name = 'child_item_code' then 
	
	    this.object.item_type[row] = f_get_item_type_from_item( this.object.child_item_code[row]) 
	    this.object.line_type[row] = f_get_line_type_from_item( this.object.child_item_code[row]) 
	
end if
end event

type dw_1 from w_main_root`dw_1 within w_smt_bom_create_master
event ue_lbuttondown pbm_lbuttondown
integer y = 668
integer width = 4663
integer height = 1976
integer taborder = 40
boolean titlebar = true
string title = "BOM List"
string dataobject = "d_des_bom_smt_create_lst"
end type

event dw_1::rbuttondown;call super::rbuttondown;if dwo.name = 'location_code' then
	

	openwithparm( w_location_barcode_popup , ddlb_line_code.getcode() )
	
	if Gst_return.gvb_return = true then
		
		this.object.location_code[row] = message.stringparm
		
		
	else
	end if 
	
end if 
end event

event dw_1::doubleclicked;call super::doubleclicked;if row < 1 then return

if dwo.name = 'child_item_code' then 
	Gst_return.gvs_return[1] = string(this.object.child_item_code[row]) 
	Gst_return.gvs_return[3] = this.object.line_code[row] 
	Gst_return.gvs_return[4] = this.object.machine[row] 
	
	Gst_return.gvs_return[2] = string(this.object.dateset[row] , 'YYYY/MM/DD')
	
	openwithparm( w_des_bom_form_popup , string(this.object.parent_item_code[row]) )
end if 
end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return
dw_2.retrieve( this.object.parent_item_code[currentrow] , '%'  , this.object.line_code[currentrow] ,'%', gvi_organization_id )
dw_1.setfocus( )


end event

type uo_tabpages from w_main_root`uo_tabpages within w_smt_bom_create_master
integer taborder = 0
end type

type st_2 from so_statictext within w_smt_bom_create_master
integer x = 750
integer y = 92
integer width = 841
integer height = 68
boolean bringtotop = true
string text = "SMT Model Name"
end type

type st_4 from so_statictext within w_smt_bom_create_master
integer x = 1618
integer y = 92
integer width = 658
integer height = 68
boolean bringtotop = true
boolean enabled = false
string text = "Line Code"
end type

type tab_1 from tab within w_smt_bom_create_master
integer y = 308
integer width = 2501
integer height = 352
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.tabpage_5=create tabpage_5
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4,&
this.tabpage_5}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
destroy(this.tabpage_5)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2464
integer height = 224
long backcolor = 12632256
string text = "Process"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Regenerate5!"
long picturemaskcolor = 12632256
cb_7 cb_7
cb_4 cb_4
cb_6 cb_6
cb_1 cb_1
end type

on tabpage_1.create
this.cb_7=create cb_7
this.cb_4=create cb_4
this.cb_6=create cb_6
this.cb_1=create cb_1
this.Control[]={this.cb_7,&
this.cb_4,&
this.cb_6,&
this.cb_1}
end on

on tabpage_1.destroy
destroy(this.cb_7)
destroy(this.cb_4)
destroy(this.cb_6)
destroy(this.cb_1)
end on

type cb_7 from so_commandbutton within tabpage_1
integer x = 1239
integer y = 52
integer width = 379
integer height = 128
integer taborder = 70
boolean bringtotop = true
string text = "Copy Line"
end type

event clicked;call super::clicked;open(w_des_bom_line_copy_popup)
end event

type cb_4 from so_commandbutton within tabpage_1
integer x = 448
integer y = 52
integer width = 379
integer height = 128
integer taborder = 50
boolean bringtotop = true
string text = "Excel Load"
end type

event clicked;call super::clicked;open(w_smt_bom_excel_load_popup)
end event

type cb_6 from so_commandbutton within tabpage_1
integer x = 841
integer y = 52
integer width = 379
integer height = 128
integer taborder = 60
boolean bringtotop = true
string text = "Delete All"
end type

event clicked;call super::clicked;string lvs_parent_item_code , lvs_line_code , lvs_machine , lvs_top_bottom

if dw_1.getrow() < 1 then
	//Mess agebox("Notify" , "$$HEX14$$adc01cc860d52000a8ba78b344c7200070c88cd6200058d538c194c6$$ENDHEX$$")
	f_msg("$$HEX14$$adc01cc860d52000a8ba78b344c7200070c88cd6200058d538c194c6$$ENDHEX$$", 'P')
	return
end if 
if dw_1.getrow() < 1 then
	//Messa gebox("Notify" , "$$HEX14$$adc01cc860d52000a8ba78b344c7200070c88cd6200058d538c194c6$$ENDHEX$$")
	f_msg("$$HEX14$$adc01cc860d52000a8ba78b344c7200070c88cd6200058d538c194c6$$ENDHEX$$", 'P')
	return
end if 
//=========================================
//
//=========================================

lvs_line_code = dw_1.object.line_code[dw_1.getrow()]
lvs_machine    = dw_1.object.machine[dw_1.getrow()]
lvs_parent_item_code = dw_1.object.parent_item_code[dw_1.getrow()]


if rb_top.checked = true then 
	lvs_top_bottom = 'T'
elseif rb_bottom.checked = true then 
	lvs_top_bottom = 'B'
else
	lvs_top_bottom = '%'
end if 
	
msg = f_msgbox1(1161 ,lvs_line_code+'  '+lvs_machine+'  '+ lvs_parent_item_code+'  '+this.text )
if msg = 1 then 
	
	delete from id_eng_bom_smt 
	where parent_item_code = :lvs_parent_item_code
	 and line_code = :lvs_line_code
	 and pcb_item like :lvs_top_bottom
	 and organization_id = :gvi_organization_id ;
	 
	 if f_sql_check() < 0 then 
		return 
	end if 
	
	delete from id_eng_bom_smt_replace
	where parent_item_code = :lvs_parent_item_code
	    and line_code = :lvs_line_code
	    and pcb_item like :lvs_top_bottom
	    and organization_id = :gvi_organization_id ;
	 	
	 if f_sql_check() < 0 then 
		return 
	end if 	
	
	commit ;
	f_msgbox(170)
end if 
end event

type cb_1 from so_commandbutton within tabpage_1
integer x = 55
integer y = 52
integer width = 379
integer height = 128
integer taborder = 40
boolean bringtotop = true
string text = "BOM Copy"
end type

event clicked;call super::clicked;open(w_des_bom_copy_popup)
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2464
integer height = 224
long backcolor = 12632256
string text = "Replace"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Replace!"
long picturemaskcolor = 12632256
st_11 st_11
ddlb_supplier_code ddlb_supplier_code
cb_11 cb_11
cb_9 cb_9
cb_3 cb_3
cb_2 cb_2
end type

on tabpage_2.create
this.st_11=create st_11
this.ddlb_supplier_code=create ddlb_supplier_code
this.cb_11=create cb_11
this.cb_9=create cb_9
this.cb_3=create cb_3
this.cb_2=create cb_2
this.Control[]={this.st_11,&
this.ddlb_supplier_code,&
this.cb_11,&
this.cb_9,&
this.cb_3,&
this.cb_2}
end on

on tabpage_2.destroy
destroy(this.st_11)
destroy(this.ddlb_supplier_code)
destroy(this.cb_11)
destroy(this.cb_9)
destroy(this.cb_3)
destroy(this.cb_2)
end on

type st_11 from so_statictext within tabpage_2
integer x = 1627
integer y = 28
integer width = 183
integer height = 56
boolean bringtotop = true
string text = "Supplier"
alignment alignment = right!
end type

type ddlb_supplier_code from uo_supplier_name_code within tabpage_2
integer x = 1463
integer y = 112
integer width = 498
integer taborder = 30
boolean bringtotop = true
end type

type cb_11 from commandbutton within tabpage_2
integer x = 1970
integer y = 56
integer width = 466
integer height = 124
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Replace PartNo"
end type

event clicked;if dw_1.getrow() < 0 then return 


long i
string lvs_part_no , lvs_item_code , lvs_supplier_code
lvs_supplier_code = tab_1.tabpage_2.ddlb_supplier_code.getcode()

do
	i++
	
	lvs_part_no = dw_1.object.child_item_code[i]
	
	select item_code into :lvs_item_code 
	 from id_item 
	where supplier_code = :lvs_supplier_code
	     and (item_code = :lvs_part_no or part_no = :lvs_part_no or instr( part_no , :lvs_part_no) > 0 or item_spec = :lvs_part_no  or instr( item_spec , :lvs_part_no) > 0   );
			
		if f_sql_check() < 0 then 
			
			MESSAGEBOX("ERRROR" , lvs_part_no ) 
			continue
		end if 
	
	if lvs_item_code = '' or isnull(lvs_item_code) then 
	else
		dw_1.object.child_item_code[i] = lvs_item_code
		
	end if 
	dw_1.accepttext() 
	
loop until i = dw_1.rowcount()

dw_1.accepttext()
if dw_1.update() < 0 then 
	rollback;
else
	commit ;
end if 
end event

type cb_9 from so_commandbutton within tabpage_2
integer x = 951
integer y = 60
integer width = 453
integer height = 112
integer taborder = 70
boolean bringtotop = true
string text = "Apply Model"
end type

event clicked;call super::clicked;string lvs_model_name  , lvs_child_item_code , lvs_line_code , lvs_replace_item_code , lvs_pcb_item



msg = f_msgbox1(1160 , this.text ) 

if msg = 1 then 
else
	return 
end if 

if dw_2.getrow() < 0 then 
   return 
end if 

 lvs_model_name   = dw_2.object.model_name[dw_2.getrow()]
 lvs_child_item_code = dw_2.object.child_item_code[dw_2.getrow()]
 lvs_replace_item_code = dw_2.object.replace_item_code[dw_2.getrow()]
 lvs_line_code = dw_2.object.line_code[dw_2.getrow()]
 lvs_pcb_item = dw_2.object.pcb_item[dw_2.getrow()]

INSERT INTO id_eng_bom_smt_replace (parent_item_code,
                                    child_item_code,
                                    replace_item_code,
                                    bom_level,
                                    dateset,
                                    dateend,
                                    location_code,
                                    organization_id,
                                    sort_sequence,
                                    item_unit_qty,
                                    workstage_code,
                                    bom_work_no,
                                    item_type,
                                    line_type,
                                    enter_by,
                                    enter_date,
                                    last_modify_by,
                                    last_modify_date,
                                    line_code,
                                    machine,
                                    version,
                                    pcb_item,
                                    marking_no,
                                    comments,
                                    table_id,
                                    feeder_type)
    SELECT   b.parent_item_code,
             b.child_item_code,
             :lvs_replace_item_code ,
             b.bom_level,
             b.dateset,
             b.dateend,
             b.location_code,
             b.organization_id,
             b.sort_sequence,
             b.item_unit_qty,
             b.workstage_code,
             b.bom_work_no,
             b.item_type,
             b.line_type,
             :gvs_user_id,
             sysdate ,
             :gvs_user_id,
             sysdate,
             b.line_code,
             b.machine,
             b.version,
             b.pcb_item,
             b.marking_no,
             b.comments,
             b.table_id,
             b.feeder_type
      FROM   id_eng_bom_smt b
     WHERE b.parent_item_code = :lvs_model_name
		AND b.child_item_code    = :lvs_child_item_code
		AND b.pcb_item              = :lvs_pcb_item 
	     
		AND ( b.parent_item_code , b.child_item_code , :lvs_replace_item_code , b.pcb_item , b.line_code  , b.location_code ) 
			NOT IN ( select c.parent_item_code , c.child_item_code , c.replace_item_code , c.pcb_item , c.line_code  , c.location_code 
						from id_eng_bom_smt_replace c
						where 	c.parent_item_code = :lvs_model_name
						AND c.child_item_code = :lvs_child_item_code
						AND c.replace_item_code = :lvs_replace_item_code
						AND c.pcb_item = :lvs_pcb_item
		) 
		;
     
if f_sql_check() < 0 then 
	return 
end if 

COMMIT ; 




















end event

type cb_3 from so_commandbutton within tabpage_2
integer x = 489
integer y = 60
integer width = 453
integer height = 112
integer taborder = 60
boolean bringtotop = true
string text = "Delete"
end type

event clicked;call super::clicked;if dw_2.getrow( ) < 1 then return
dw_2.deleterow( dw_2.getrow())
end event

type cb_2 from so_commandbutton within tabpage_2
integer x = 27
integer y = 60
integer width = 453
integer height = 112
integer taborder = 50
boolean bringtotop = true
string text = "Add"
end type

event clicked;call super::clicked;long lvl_row
if dw_1.getrow() < 1 then return 

Lvl_row = dw_2.insertrow(0)
f_set_security_row( dw_2 , lvl_row , 'ALL')

dw_2.object.bom_level[lvl_row] = 1
dw_2.object.model_name[lvl_row] =dw_1.object.parent_item_code[dw_1.getrow()]
dw_2.object.smt_model_name[lvl_row] =dw_1.object.smt_model_name[dw_1.getrow()]
dw_2.object.parent_item_code[lvl_row] =dw_1.object.parent_item_code[dw_1.getrow()]
dw_2.object.child_item_code[lvl_row] = dw_1.object.child_item_code[dw_1.getrow()]
dw_2.object.item_name[lvl_row] = dw_1.object.item_name[dw_1.getrow()]
dw_2.object.item_spec[lvl_row] = dw_1.object.item_spec[dw_1.getrow()]			
dw_2.object.item_uom[lvl_row] = dw_1.object.item_uom[dw_1.getrow()]			

dw_2.object.item_type[lvl_row] = dw_1.object.item_type[dw_1.getrow()]
dw_2.object.line_type[lvl_row] = dw_1.object.line_type[dw_1.getrow()]

dw_2.object.location_code[lvl_row] = dw_1.object.location_code[dw_1.getrow()]
dw_2.object.line_code[lvl_row] = dw_1.object.line_code[dw_1.getrow()]
dw_2.object.machine[lvl_row] = dw_1.object.machine[dw_1.getrow()]
dw_2.object.table_id[lvl_row] = dw_1.object.table_id[dw_1.getrow()]
dw_2.object.pcb_item[lvl_row] = dw_1.object.pcb_item[dw_1.getrow()]

dw_2.object.dateset[Lvl_row] = f_t_sysdate()
dw_2.object.dateend[Lvl_row] = f_t_maxdate()						

dw_2.object.item_unit_qty[Lvl_row] = 1
dw_2.object.sort_sequence[Lvl_row] = 0
dw_2.object.workstage_code[Lvl_row] = '*'

end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2464
integer height = 224
long backcolor = 12632256
string text = "No Replace"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "EditStops5!"
long picturemaskcolor = 536870912
cb_8 cb_8
cb_5 cb_5
end type

on tabpage_3.create
this.cb_8=create cb_8
this.cb_5=create cb_5
this.Control[]={this.cb_8,&
this.cb_5}
end on

on tabpage_3.destroy
destroy(this.cb_8)
destroy(this.cb_5)
end on

type cb_8 from so_commandbutton within tabpage_3
integer x = 558
integer y = 60
integer width = 453
integer height = 112
integer taborder = 70
boolean bringtotop = true
string text = "Delete"
end type

event clicked;call super::clicked;if dw_3.getrow( ) < 1 then return
dw_3.deleterow( dw_3.getrow())
end event

type cb_5 from so_commandbutton within tabpage_3
integer x = 96
integer y = 60
integer width = 453
integer height = 112
integer taborder = 60
boolean bringtotop = true
string text = "Add"
end type

event clicked;call super::clicked;long lvl_row

if dw_1.getrow() < 1 then return 

lvl_row = dw_3.insertrow(0)
f_set_security_row( dw_3 , lvl_row , 'ALL')

dw_3.object.model_name[lvl_row]        = dw_1.object.parent_item_code[dw_1.getrow()]
dw_3.event itemchanged(  lvl_row , dw_3.object.model_name, string(dw_3.object.model_name[lvl_row] ))

dw_3.object.parent_item_code[lvl_row] = dw_1.object.parent_item_code[dw_1.getrow()]
dw_3.object.child_item_code[lvl_row]    = dw_1.object.child_item_code[dw_1.getrow()]

dw_3.object.location_code[lvl_row] = dw_1.object.location_code[dw_1.getrow()]
dw_3.object.line_code[lvl_row]       = dw_1.object.line_code[dw_1.getrow()]

dw_3.object.dateset[Lvl_row]  = f_t_sysdate()
dw_3.object.dateend[Lvl_row] = f_t_maxdate()


end event

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2464
integer height = 224
long backcolor = 12632256
string text = "Model Change"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "CrossTab!"
long picturemaskcolor = 536870912
cb_10 cb_10
st_3 st_3
st_1 st_1
ddlb_new_model_name ddlb_new_model_name
ddlb_old_model_name ddlb_old_model_name
end type

on tabpage_4.create
this.cb_10=create cb_10
this.st_3=create st_3
this.st_1=create st_1
this.ddlb_new_model_name=create ddlb_new_model_name
this.ddlb_old_model_name=create ddlb_old_model_name
this.Control[]={this.cb_10,&
this.st_3,&
this.st_1,&
this.ddlb_new_model_name,&
this.ddlb_old_model_name}
end on

on tabpage_4.destroy
destroy(this.cb_10)
destroy(this.st_3)
destroy(this.st_1)
destroy(this.ddlb_new_model_name)
destroy(this.ddlb_old_model_name)
end on

type cb_10 from so_commandbutton within tabpage_4
integer x = 1193
integer y = 48
integer width = 398
integer height = 144
integer taborder = 80
string text = "Change"
end type

event clicked;call super::clicked;string lvs_new_model_name , lvs_old_model_name

lvs_new_model_name = tab_1.tabpage_4.ddlb_new_model_name.getcode()
lvs_old_model_name   =  tab_1.tabpage_4.ddlb_old_model_name.getcode()


if lvs_new_model_name = lvs_old_model_name then 
	return 
end if 

msg = f_msgbox1(1161 , this.text )

if msg = 1 then 
else
	return 
end if 

//==============================================
//
//==============================================

update id_eng_bom_smt set parent_item_code = :lvs_new_model_name
 where parent_item_code = :lvs_old_model_name 
    and organization_id = :gvi_organization_id  ;
	 
if f_sql_check() < 0 then 
	return 
end if 
//==============================================
//
//==============================================
update IB_PRODUCT_PLANDATA set model_name = :lvs_new_model_name
 where model_name = :lvs_old_model_name 
    and organization_id = :gvi_organization_id  ;
	 
if f_sql_check() < 0 then 
	return 
end if 

commit ;
end event

type st_3 from so_statictext within tabpage_4
integer x = 14
integer y = 124
integer width = 251
boolean bringtotop = true
string text = "New"
end type

type st_1 from so_statictext within tabpage_4
integer x = 14
integer y = 36
integer width = 251
string text = "Old"
end type

type ddlb_new_model_name from uo_model_name_ddlb within tabpage_4
integer x = 302
integer y = 124
integer width = 841
integer height = 1920
integer taborder = 20
boolean bringtotop = true
end type

event selectionchanged;call super::selectionchanged;//string lvs_line_code 
////=======================================
////
////=======================================
//lvs_line_code        = ddlb_line_code.getcode( )
//rollback ;
//
dw_6.retrieve( this.getcode()  , gvi_organization_id )
//dw_1.retrieve( this.getcode()  , f_t_sysdate() ,  lvs_line_code+'%' , '%' , gvi_organization_id )
//dw_3.retrieve (this.getcode()  , gvi_organization_id )
end event

type ddlb_old_model_name from uo_model_name_ddlb within tabpage_4
integer x = 302
integer y = 32
integer width = 841
integer height = 1920
integer taborder = 20
boolean bringtotop = true
end type

event selectionchanged;call super::selectionchanged;//string lvs_line_code 
////=======================================
////
////=======================================
//lvs_line_code        = ddlb_line_code.getcode( )
//rollback ;
//
dw_6.retrieve( this.getcode()  , gvi_organization_id )
//dw_1.retrieve( this.getcode()  , f_t_sysdate() ,  lvs_line_code+'%' , '%' , gvi_organization_id )
//dw_3.retrieve (this.getcode()  , gvi_organization_id )
end event

type tabpage_5 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2464
integer height = 224
long backcolor = 12632256
string text = "Line Exchange"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "CreateForeignKey!"
long picturemaskcolor = 536870912
ddlb_line_code_change2 ddlb_line_code_change2
st_9 st_9
st_8 st_8
cb_12 cb_12
ddlb_line_code_change1 ddlb_line_code_change1
end type

on tabpage_5.create
this.ddlb_line_code_change2=create ddlb_line_code_change2
this.st_9=create st_9
this.st_8=create st_8
this.cb_12=create cb_12
this.ddlb_line_code_change1=create ddlb_line_code_change1
this.Control[]={this.ddlb_line_code_change2,&
this.st_9,&
this.st_8,&
this.cb_12,&
this.ddlb_line_code_change1}
end on

on tabpage_5.destroy
destroy(this.ddlb_line_code_change2)
destroy(this.st_9)
destroy(this.st_8)
destroy(this.cb_12)
destroy(this.ddlb_line_code_change1)
end on

type ddlb_line_code_change2 from uo_line_code within tabpage_5
integer x = 585
integer y = 112
integer width = 521
integer height = 1856
integer taborder = 40
boolean bringtotop = true
end type

type st_9 from so_statictext within tabpage_5
integer x = 585
integer y = 44
integer width = 521
integer height = 56
string text = "Line Code"
end type

type st_8 from so_statictext within tabpage_5
integer x = 50
integer y = 36
integer width = 507
integer height = 56
string text = "Line Code"
end type

type cb_12 from so_commandbutton within tabpage_5
integer x = 1513
integer y = 76
integer height = 112
integer taborder = 80
string text = "Exchange"
end type

event clicked;call super::clicked;string lvs_line_code1 , lvs_line_code2 

lvs_line_code1 = ddlb_line_code_change1.getcode()
lvs_line_code2 = ddlb_line_code_change2.getcode()

if lvs_line_code1 = '%' or isnull(lvs_line_code1) or isnull(lvs_line_code2)  or isnull(lvs_line_code2)  then 
	//Mes sagebox("Notify" , "Ivalid Condition ")
	f_msg("Ivalid Condition", 'P')
	return 
end if 
//======================================
//
//======================================

update id_eng_bom_smt
     set line_code  = :lvs_line_code2||'-X'
where line_code = :lvs_line_code1
    and organization_id = :gvi_organization_id ;
if f_sql_check() < 0 then 
	return 
end if 

update id_eng_bom_smt
     set line_code  = :lvs_line_code1||'-X'
where line_code = :lvs_line_code2 
 and organization_id = :gvi_organization_id ;

if f_sql_check() < 0 then 
	return 
end if 
//===================================
//
//===================================
update id_eng_bom_smt
     set line_code  = :lvs_line_code1 ,
	      machine = :lvs_line_code1||substr( machine , 3, 2 ) 
where line_code = :lvs_line_code1||'-X'
 and organization_id = :gvi_organization_id ;

if f_sql_check() < 0 then 
	return 
end if 

update id_eng_bom_smt
     set line_code  = :lvs_line_code2 ,
	      machine   = :lvs_line_code2||substr( machine , 3, 2 ) 
where line_code  =  :lvs_line_code2||'-X'
    and organization_id = :gvi_organization_id ;
if f_sql_check() < 0 then 
	return 
end if 


////======================================
////
////======================================
//
//update ib_product_plandata
//     set line_code  = :lvs_line_code2||'-X'
//where line_code  = :lvs_line_code1
//    and organization_id = :gvi_organization_id ;
//if f_sql_check() < 0 then 
//	return 
//end if 
//
//update ib_product_plandata
//     set line_code  = :lvs_line_code1||'-X'
//where line_code = :lvs_line_code2 
// and organization_id = :gvi_organization_id ;
//
//if f_sql_check() < 0 then 
//	return 
//end if 
//
//update ib_product_plandata
//     set line_code  = :lvs_line_code1 ,
//	      machine = :lvs_line_code1||substr( machine , 3, 2 ) 
//where line_code = :lvs_line_code1||'-X'
// and organization_id = :gvi_organization_id ;
//
//if f_sql_check() < 0 then 
//	return 
//end if 
//
//update ib_product_plandata
//     set line_code  = :lvs_line_code2 ,
//	      machine = :lvs_line_code2||substr( machine , 3, 2 ) 
//where line_code =  :lvs_line_code2||'-X'
//    and organization_id = :gvi_organization_id ;
//if f_sql_check() < 0 then 
//	return 
//end if 

COMMIT ;

f_msgbox(170)
end event

type ddlb_line_code_change1 from uo_line_code within tabpage_5
integer x = 37
integer y = 112
integer width = 521
integer height = 1856
integer taborder = 30
boolean bringtotop = true
end type

type cb_doit from so_commandbutton within w_smt_bom_create_master
integer x = 2642
integer y = 488
integer width = 430
integer height = 104
boolean bringtotop = true
string text = "Change"
end type

event clicked;call super::clicked;int lvi_num
string lvs_line_code , lvs_model_name , lvs_topbot , lvs_table_id

lvi_num = Long(em_number.text)
lvs_table_id = sle_table_id.text 
lvs_line_code = ddlb_line_code.getcode() 
lvs_model_name = ddlb_model_name.getcode() 
//=====================================================
//
//=====================================================
if rb_all.checked = true then 
	//MESS AGEBOX("$$HEX2$$55d678c7$$ENDHEX$$" , "$$HEX2$$d1d02000$$ENDHEX$$/ $$HEX10$$14bc41d144c7200020c1ddd058d538c194c62000$$ENDHEX$$")
	f_msg( "$$HEX2$$d1d02000$$ENDHEX$$/ $$HEX10$$14bc41d144c7200020c1ddd058d538c194c62000$$ENDHEX$$", 'P') 
	return 
elseif rb_top.checked = true then 
	lvs_topbot ='T'
	
elseif  rb_bottom.checked = true then 
	lvs_topbot= 'B'
end if 
	
msg = MessageBox ( 'Confirm',f_msg('$$HEX5$$c0bcbdac200000b3c1c0$$ENDHEX$$= ','S') +lvs_line_code +" Model="+lvs_model_name+" TopBot="+lvs_topbot+ "  Table="+lvs_table_id, Information! ,YesNo!  )
if msg = 1 then 
			
	update ID_ENG_BOM_SMT
		  set  location_code_last = location_code ,
		  	    location_code = substr( location_code , 1,1) ||   TRIM(to_char( to_number(substr(location_code , 2,2)) +:lvi_num  , '00')) ||substr( location_code , 4,1)
	 where line_code  = :lvs_line_code
		and parent_item_code = :lvs_model_name
		and pcb_item 	= :lvs_topbot
		and location_code  not like 'TRAY%'
		and length(location_code) = 4
		and table_id LIKE  NVL(:lvs_table_id , '%')
		;
	
	if f_sql_check() < 0 then 
		rollback;
	else
		dw_1.retrieve( lvs_model_name ,  f_t_sysdate() ,  lvs_line_code+'%' , '%' , sle_revision.text+'%' ,  ddlb_feeder_shaft.getcode()+'%' ,   gvi_organization_id )
		//dw_1.retrieve( lvs_model_name , f_t_sysdate() ,  lvs_line_code+'%' , '%' , gvi_organization_id )
	end if 
	
end if 
end event

type em_number from so_editmask within w_smt_bom_create_master
integer x = 3072
integer y = 492
integer width = 261
integer height = 92
boolean bringtotop = true
string text = "0"
string mask = "###0"
boolean autoskip = true
boolean spin = true
double increment = 1
string minmax = "-100~~100"
end type

type rb_all from so_radiobutton within w_smt_bom_create_master
integer x = 3319
integer y = 68
integer width = 297
boolean bringtotop = true
string text = "All"
boolean checked = true
end type

event clicked;call super::clicked;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
dw_1.SETFILTER('')
dw_1.FILTER()

dw_1.SETFILTER( 'PCB_ITEM  LIKE '+"'"+"%"+"'")
dw_1.FILTER()
F_MSG_MDI_HELP( STRING( dw_1.ROWCOUNT() ) + " Found")
end event

type rb_top from so_radiobutton within w_smt_bom_create_master
integer x = 3319
integer y = 140
integer width = 297
boolean bringtotop = true
string text = "Top"
end type

event clicked;call super::clicked;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
dw_1.SETFILTER('')
dw_1.FILTER()

dw_1.SETFILTER( 'PCB_ITEM  LIKE '+"'"+"T"+"'")
dw_1.FILTER()
F_MSG_MDI_HELP( STRING( dw_1.ROWCOUNT() ) + " Found")
end event

type rb_bottom from so_radiobutton within w_smt_bom_create_master
integer x = 3319
integer y = 212
integer width = 297
boolean bringtotop = true
string text = "Bottom"
end type

event clicked;call super::clicked;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
dw_1.SETFILTER('')
dw_1.FILTER()

dw_1.SETFILTER( 'PCB_ITEM  LIKE '+"'"+"B"+"'")
dw_1.FILTER()
F_MSG_MDI_HELP( STRING( dw_1.ROWCOUNT() ) + " Found")
end event

type sle_table_id from so_singlelineedit within w_smt_bom_create_master
integer x = 3355
integer y = 496
integer width = 297
integer height = 88
boolean bringtotop = true
end type

type st_7 from so_statictext within w_smt_bom_create_master
integer x = 3355
integer y = 412
integer width = 297
integer height = 68
boolean bringtotop = true
boolean enabled = false
string text = "Table ID"
end type

type dw_6 from datawindow within w_smt_bom_create_master
integer x = 3707
integer width = 1339
integer height = 660
integer taborder = 70
boolean bringtotop = true
boolean titlebar = true
string dataobject = "d_des_item_4_bom_smt_modify_lst"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

type ddlb_line_code from uo_line_code within w_smt_bom_create_master
integer x = 1618
integer y = 180
integer height = 1856
integer taborder = 20
boolean bringtotop = true
end type

event selectionchanged;call super::selectionchanged;ddlb_feeder_shaft.REdraw( this.getcode(), ddlb_model_name.getcode() )
end event

type uo_dateset from uo_ymd_calendar within w_smt_bom_create_master
integer x = 2258
integer y = 180
integer taborder = 30
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type st_5 from so_statictext within w_smt_bom_create_master
integer x = 2267
integer y = 92
integer width = 407
integer height = 68
boolean bringtotop = true
boolean enabled = false
string text = "Dateset"
end type

type sle_revision from so_singlelineedit within w_smt_bom_create_master
integer x = 2994
integer y = 176
integer width = 297
integer height = 88
integer taborder = 40
boolean bringtotop = true
end type

type st_6 from so_statictext within w_smt_bom_create_master
integer x = 2994
integer y = 92
integer width = 297
integer height = 68
boolean bringtotop = true
boolean enabled = false
string text = "Revision"
end type

type ddlb_feeder_shaft from uo_feeder_shaft_dynamic within w_smt_bom_create_master
integer x = 2679
integer y = 180
integer width = 306
integer taborder = 20
boolean bringtotop = true
end type

type st_12 from so_statictext within w_smt_bom_create_master
integer x = 2683
integer y = 92
integer width = 297
integer height = 68
boolean bringtotop = true
boolean enabled = false
string text = "Shaft"
end type

type ddlb_customer_code from uo_customer_code_name within w_smt_bom_create_master
integer x = 119
integer y = 180
integer width = 663
integer height = 1324
integer taborder = 180
boolean bringtotop = true
boolean autohscroll = true
boolean vscrollbar = false
end type

event selectionchanged;call super::selectionchanged;//ddlb_model_name.REdraw_customer( this.getcode() )
end event

type st_10 from statictext within w_smt_bom_create_master
integer x = 119
integer y = 92
integer width = 663
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Customer Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_model_name from uo_smt_layout_model_name_ddlb within w_smt_bom_create_master
integer x = 795
integer y = 180
integer taborder = 30
boolean bringtotop = true
end type

event selectionchanged;call super::selectionchanged;ddlb_feeder_shaft.REdraw( this.getcode(), ddlb_model_name.getcode() )
dw_6.retrieve( ddlb_model_name.getcode()  , gvi_organization_id )
end event

type gb_1 from so_groupbox within w_smt_bom_create_master
integer x = 14
integer y = 12
integer width = 3675
integer height = 296
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_smt_bom_create_master
integer x = 2528
integer y = 356
integer width = 1157
integer height = 296
string text = "Change Location"
end type

