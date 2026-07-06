HA$PBExportHeader$w_smt_pickup_rate.srw
$PBExportComments$PICKUP RATE
forward
global type w_smt_pickup_rate from w_main_root
end type
type st_line_code from so_statictext within w_smt_pickup_rate
end type
type sle_program from so_singlelineedit within w_smt_pickup_rate
end type
type st_machine_code from so_statictext within w_smt_pickup_rate
end type
type ddlb_line_code from uo_line_code within w_smt_pickup_rate
end type
type uo_dateset from uo_ymd_calendar within w_smt_pickup_rate
end type
type st_1 from statictext within w_smt_pickup_rate
end type
type sle_item_code from so_singlelineedit within w_smt_pickup_rate
end type
type st_2 from so_statictext within w_smt_pickup_rate
end type
type sle_table from so_singlelineedit within w_smt_pickup_rate
end type
type sle_feeder from so_singlelineedit within w_smt_pickup_rate
end type
type sle_lr from so_singlelineedit within w_smt_pickup_rate
end type
type st_3 from so_statictext within w_smt_pickup_rate
end type
type st_4 from so_statictext within w_smt_pickup_rate
end type
type st_5 from so_statictext within w_smt_pickup_rate
end type
type sle_machine from so_singlelineedit within w_smt_pickup_rate
end type
type st_6 from so_statictext within w_smt_pickup_rate
end type
type rb_detail from so_radiobutton within w_smt_pickup_rate
end type
type rb_2 from so_radiobutton within w_smt_pickup_rate
end type
type gb_2 from so_groupbox within w_smt_pickup_rate
end type
type gb_1 from so_groupbox within w_smt_pickup_rate
end type
end forward

global type w_smt_pickup_rate from w_main_root
integer width = 4736
integer height = 2904
string title = "SMT Pickup Inquery"
st_line_code st_line_code
sle_program sle_program
st_machine_code st_machine_code
ddlb_line_code ddlb_line_code
uo_dateset uo_dateset
st_1 st_1
sle_item_code sle_item_code
st_2 st_2
sle_table sle_table
sle_feeder sle_feeder
sle_lr sle_lr
st_3 st_3
st_4 st_4
st_5 st_5
sle_machine sle_machine
st_6 st_6
rb_detail rb_detail
rb_2 rb_2
gb_2 gb_2
gb_1 gb_1
end type
global w_smt_pickup_rate w_smt_pickup_rate

on w_smt_pickup_rate.create
int iCurrent
call super::create
this.st_line_code=create st_line_code
this.sle_program=create sle_program
this.st_machine_code=create st_machine_code
this.ddlb_line_code=create ddlb_line_code
this.uo_dateset=create uo_dateset
this.st_1=create st_1
this.sle_item_code=create sle_item_code
this.st_2=create st_2
this.sle_table=create sle_table
this.sle_feeder=create sle_feeder
this.sle_lr=create sle_lr
this.st_3=create st_3
this.st_4=create st_4
this.st_5=create st_5
this.sle_machine=create sle_machine
this.st_6=create st_6
this.rb_detail=create rb_detail
this.rb_2=create rb_2
this.gb_2=create gb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_line_code
this.Control[iCurrent+2]=this.sle_program
this.Control[iCurrent+3]=this.st_machine_code
this.Control[iCurrent+4]=this.ddlb_line_code
this.Control[iCurrent+5]=this.uo_dateset
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.sle_item_code
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.sle_table
this.Control[iCurrent+10]=this.sle_feeder
this.Control[iCurrent+11]=this.sle_lr
this.Control[iCurrent+12]=this.st_3
this.Control[iCurrent+13]=this.st_4
this.Control[iCurrent+14]=this.st_5
this.Control[iCurrent+15]=this.sle_machine
this.Control[iCurrent+16]=this.st_6
this.Control[iCurrent+17]=this.rb_detail
this.Control[iCurrent+18]=this.rb_2
this.Control[iCurrent+19]=this.gb_2
this.Control[iCurrent+20]=this.gb_1
end on

on w_smt_pickup_rate.destroy
call super::destroy
destroy(this.st_line_code)
destroy(this.sle_program)
destroy(this.st_machine_code)
destroy(this.ddlb_line_code)
destroy(this.uo_dateset)
destroy(this.st_1)
destroy(this.sle_item_code)
destroy(this.st_2)
destroy(this.sle_table)
destroy(this.sle_feeder)
destroy(this.sle_lr)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.sle_machine)
destroy(this.st_6)
destroy(this.rb_detail)
destroy(this.rb_2)
destroy(this.gb_2)
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
		
		
			if rb_detail.checked = true then 
		   //MESSAGEBOX('A', string ( uo_dateset.uf_get_ymd_dt() ) ) 
			DW_1.RETRIEVE( uo_dateset.uf_get_ymd_dt(), ddlb_line_code.getcode( )+'%',sle_machine.text + '%' , sle_program.text+'%' , sle_item_code.text + '%', sle_table.text + '%', sle_feeder.text + '%', sle_lr.text + '%' )
			DW_1.SETFOCUS()
		else
				DW_2.RETRIEVE( uo_dateset.uf_get_ymd_dt(), ddlb_line_code.getcode( )+'%',sle_machine.text + '%' , sle_program.text+'%' , sle_item_code.text + '%', sle_table.text + '%', sle_feeder.text + '%', sle_lr.text + '%' )
			DW_2.SETFOCUS()
		end if 
				
	CASE 'INSERT'
//			dw_1.enabled = true
//			row = dw_1.insertrow(dw_1.getrow())
//			dw_1.scrolltorow(row)
//			f_set_security_row(dw_1 , row , 'ALL')
//			F_MSG_MDI_HELP ( F_MSG_ST(152)	 )
	CASE 'APPEND'
//			dw_1.enabled = true
//			row = dw_1.insertrow(0)
//			dw_1.scrolltorow(row)
//			f_set_security_row(dw_1 , row , 'ALL')
//			F_MSG_MDI_HELP ( F_MSG_ST(152)	 )	
	CASE 'DELETE'
		
//		  	if dw_1.getrow() < 1 then return 
//			  
//			msg =f_msgbox(1003)
//			if msg = 1 then
//				gvl_row_deleted = dw_1.getrow()			
//				dw_1.deleterow(gvl_row_deleted)		
//				dw_1.setfocus()
//				row = dw_1.getrow()
//				dw_1.scrolltorow(row)
//				dw_1.setcolumn(1)
//			end if
			
	CASE 'UPDATE'
		
//		DW_1.ACCEPTTEXT()
// 
//	      IF DW_1.UPDATE() < 0 THEN
//				ROLLBACK;
//				RETURN
//		ELSE
//				 COMMIT;
//       			 F_MSG_MDI_HELP ( F_MSG_ST(170)	 ) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
//		END IF

	CASE ELSE
END CHOOSE


end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
//f_retrieve()
end event

type dw_5 from w_main_root`dw_5 within w_smt_pickup_rate
integer y = 320
end type

type dw_4 from w_main_root`dw_4 within w_smt_pickup_rate
integer x = 5
integer y = 320
end type

type dw_3 from w_main_root`dw_3 within w_smt_pickup_rate
integer x = 5
integer y = 320
integer taborder = 50
end type

type dw_2 from w_main_root`dw_2 within w_smt_pickup_rate
integer x = 5
integer y = 320
integer width = 4507
integer height = 1208
integer taborder = 0
boolean titlebar = true
string dataobject = "d_smt_pickup_rate_by_line"
end type

type dw_1 from w_main_root`dw_1 within w_smt_pickup_rate
integer x = 5
integer y = 320
integer width = 4507
integer height = 1208
integer taborder = 40
boolean titlebar = true
string title = "Line List"
string dataobject = "d_smt_pickup_rate_by_zone"
end type

event dw_1::itemchanged;call super::itemchanged;if dwo.name = 'line_code' or dwo.name ='machine' or dwo.name ='table_id' or dwo.name ='address' or dwo.name ='position' then
	
	this.object.location_code[row] = this.object.line_code[row]+this.object.machine[row]+this.object.table_id[row]+this.object.address[row]+this.object.position[row]
	
end if 
end event

type uo_tabpages from w_main_root`uo_tabpages within w_smt_pickup_rate
end type

type st_line_code from so_statictext within w_smt_pickup_rate
integer x = 1317
integer y = 84
integer width = 590
integer height = 56
boolean bringtotop = true
string text = "Line Code"
end type

type sle_program from so_singlelineedit within w_smt_pickup_rate
integer x = 2231
integer y = 164
integer width = 590
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

type st_machine_code from so_statictext within w_smt_pickup_rate
integer x = 2254
integer y = 84
integer width = 590
integer height = 56
boolean bringtotop = true
string text = "Program Name"
end type

type ddlb_line_code from uo_line_code within w_smt_pickup_rate
integer x = 1303
integer y = 164
integer width = 567
integer height = 1964
integer taborder = 20
boolean bringtotop = true
boolean allowedit = true
end type

event selectionchanged;call super::selectionchanged;F_RETRIEVE()
end event

type uo_dateset from uo_ymd_calendar within w_smt_pickup_rate
event destroy ( )
integer x = 878
integer y = 164
integer taborder = 60
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type st_1 from statictext within w_smt_pickup_rate
integer x = 887
integer y = 84
integer width = 430
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Production Date"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_item_code from so_singlelineedit within w_smt_pickup_rate
integer x = 2825
integer y = 164
integer width = 590
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

type st_2 from so_statictext within w_smt_pickup_rate
integer x = 2848
integer y = 80
integer width = 590
integer height = 56
boolean bringtotop = true
string text = "Item Code"
end type

type sle_table from so_singlelineedit within w_smt_pickup_rate
integer x = 3419
integer y = 164
integer width = 242
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

type sle_feeder from so_singlelineedit within w_smt_pickup_rate
integer x = 3666
integer y = 164
integer width = 242
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

type sle_lr from so_singlelineedit within w_smt_pickup_rate
integer x = 3913
integer y = 164
integer width = 242
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

type st_3 from so_statictext within w_smt_pickup_rate
integer x = 3419
integer y = 84
integer width = 270
integer height = 56
boolean bringtotop = true
string text = "Table"
end type

type st_4 from so_statictext within w_smt_pickup_rate
integer x = 3666
integer y = 84
integer width = 270
integer height = 56
boolean bringtotop = true
string text = "Feeder"
end type

type st_5 from so_statictext within w_smt_pickup_rate
integer x = 3913
integer y = 84
integer width = 242
integer height = 60
boolean bringtotop = true
string text = "L/R"
end type

type sle_machine from so_singlelineedit within w_smt_pickup_rate
integer x = 1874
integer y = 164
integer width = 352
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

type st_6 from so_statictext within w_smt_pickup_rate
integer x = 1865
integer y = 80
integer width = 366
integer height = 56
boolean bringtotop = true
string text = "Machine code"
end type

type rb_detail from so_radiobutton within w_smt_pickup_rate
integer x = 133
integer y = 88
boolean bringtotop = true
string text = "Detail"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1
end event

type rb_2 from so_radiobutton within w_smt_pickup_rate
integer x = 133
integer y = 188
boolean bringtotop = true
string text = "Summary"
end type

event clicked;call super::clicked;dw_2.bringtotop = true 
selected_data_window = dw_2
end event

type gb_2 from so_groupbox within w_smt_pickup_rate
integer x = 805
integer width = 3415
integer height = 300
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_1 from so_groupbox within w_smt_pickup_rate
integer width = 800
integer height = 300
integer taborder = 20
string text = "Category"
end type

