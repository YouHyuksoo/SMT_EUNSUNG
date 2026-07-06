HA$PBExportHeader$w_mcn_mold_rpt.srw
forward
global type w_mcn_mold_rpt from w_main_root
end type
type rb_mold_master from so_radiobutton within w_mcn_mold_rpt
end type
type st_1 from so_statictext within w_mcn_mold_rpt
end type
type st_4 from so_statictext within w_mcn_mold_rpt
end type
type ddlb_item_code from uo_item_code within w_mcn_mold_rpt
end type
type rb_3 from so_radiobutton within w_mcn_mold_rpt
end type
type rb_1 from so_radiobutton within w_mcn_mold_rpt
end type
type rb_2 from so_radiobutton within w_mcn_mold_rpt
end type
type rb_mold_card from so_radiobutton within w_mcn_mold_rpt
end type
type rb_4 from so_radiobutton within w_mcn_mold_rpt
end type
type rb_5 from so_radiobutton within w_mcn_mold_rpt
end type
type rb_barcode from so_radiobutton within w_mcn_mold_rpt
end type
type ddlb_mold_code from uo_mold_code within w_mcn_mold_rpt
end type
type ddlb_mold_group from uo_basecode within w_mcn_mold_rpt
end type
type st_6 from so_statictext within w_mcn_mold_rpt
end type
type rb_barcode_2 from so_radiobutton within w_mcn_mold_rpt
end type
type sle_mold_name from so_singlelineedit within w_mcn_mold_rpt
end type
type st_7 from so_statictext within w_mcn_mold_rpt
end type
type gb_1 from groupbox within w_mcn_mold_rpt
end type
type gb_2 from groupbox within w_mcn_mold_rpt
end type
type gb_3 from groupbox within w_mcn_mold_rpt
end type
end forward

global type w_mcn_mold_rpt from w_main_root
integer width = 5467
integer height = 2856
string title = "Mold Master Report"
rb_mold_master rb_mold_master
st_1 st_1
st_4 st_4
ddlb_item_code ddlb_item_code
rb_3 rb_3
rb_1 rb_1
rb_2 rb_2
rb_mold_card rb_mold_card
rb_4 rb_4
rb_5 rb_5
rb_barcode rb_barcode
ddlb_mold_code ddlb_mold_code
ddlb_mold_group ddlb_mold_group
st_6 st_6
rb_barcode_2 rb_barcode_2
sle_mold_name sle_mold_name
st_7 st_7
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_mcn_mold_rpt w_mcn_mold_rpt

type variables

end variables

on w_mcn_mold_rpt.create
int iCurrent
call super::create
this.rb_mold_master=create rb_mold_master
this.st_1=create st_1
this.st_4=create st_4
this.ddlb_item_code=create ddlb_item_code
this.rb_3=create rb_3
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_mold_card=create rb_mold_card
this.rb_4=create rb_4
this.rb_5=create rb_5
this.rb_barcode=create rb_barcode
this.ddlb_mold_code=create ddlb_mold_code
this.ddlb_mold_group=create ddlb_mold_group
this.st_6=create st_6
this.rb_barcode_2=create rb_barcode_2
this.sle_mold_name=create sle_mold_name
this.st_7=create st_7
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_mold_master
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.ddlb_item_code
this.Control[iCurrent+5]=this.rb_3
this.Control[iCurrent+6]=this.rb_1
this.Control[iCurrent+7]=this.rb_2
this.Control[iCurrent+8]=this.rb_mold_card
this.Control[iCurrent+9]=this.rb_4
this.Control[iCurrent+10]=this.rb_5
this.Control[iCurrent+11]=this.rb_barcode
this.Control[iCurrent+12]=this.ddlb_mold_code
this.Control[iCurrent+13]=this.ddlb_mold_group
this.Control[iCurrent+14]=this.st_6
this.Control[iCurrent+15]=this.rb_barcode_2
this.Control[iCurrent+16]=this.sle_mold_name
this.Control[iCurrent+17]=this.st_7
this.Control[iCurrent+18]=this.gb_1
this.Control[iCurrent+19]=this.gb_2
this.Control[iCurrent+20]=this.gb_3
end on

on w_mcn_mold_rpt.destroy
call super::destroy
destroy(this.rb_mold_master)
destroy(this.st_1)
destroy(this.st_4)
destroy(this.ddlb_item_code)
destroy(this.rb_3)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_mold_card)
destroy(this.rb_4)
destroy(this.rb_5)
destroy(this.rb_barcode)
destroy(this.ddlb_mold_code)
destroy(this.ddlb_mold_group)
destroy(this.st_6)
destroy(this.rb_barcode_2)
destroy(this.sle_mold_name)
destroy(this.st_7)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event activate;call super::activate;/***************************************
* Window Default Property 
****************************************/
Gst_set.window_id            = this.classname() 
Gst_set.author                  = "JiSheng"
Gst_set.creation_date      = '20051101'
Gst_set.last_modify_date = '20051101'
Gst_set.Report_window    = True  // Report Window  True / Flase

/*****************************************
* Data Window Property
******************************************/
/*****************************************
* Data Window Property
******************************************/
Ivs_resize_type                      = 'NORMAL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


/*****************************************
* Data Window Property
******************************************/
ivs_dw_1_use_focusindicator = 'N' //Focus Indicator Show / Hide Property
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
F_MENU_CONTROL('REPORT' , True)  // All Data Control





end event

event ue_data_control;call super::ue_data_control;Long ROW
CHOOSE CASE Gvs_Ue_data_control
		
	CASE 'RETRIEVE'
		
			if rb_mold_master.checked = true then 
				DW_1.RETRIEVE(  ddlb_mold_code.text()+'%' ,  ddlb_mold_group.getcode()+'%' ,  gvi_organization_id )
				dw_1.setfocus()
			elseif rb_mold_card.checked = true then
				dw_3.retrieve( ddlb_mold_code.text()+'%'  , ddlb_mold_group.getcode()+'%' ,  gvi_organization_id  )	
				f_dual_lang_change_dwtext(dw_3)
				dw_3.setfocus()			
			elseif rb_barcode.checked = true or rb_barcode_2.checked = true then
				dw_4.retrieve(  ddlb_mold_code.text()+'%' , gvi_organization_id  )							
			end if
	CASE ELSE
END CHOOSE
end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

type dw_5 from w_main_root`dw_5 within w_mcn_mold_rpt
integer y = 500
integer width = 4507
integer height = 1832
boolean titlebar = true
end type

type dw_4 from w_main_root`dw_4 within w_mcn_mold_rpt
integer y = 500
integer width = 4507
integer height = 1832
boolean titlebar = true
string dataobject = "d_mcn_mold_barcode_rpt"
end type

type dw_3 from w_main_root`dw_3 within w_mcn_mold_rpt
integer y = 500
integer width = 4507
integer height = 1832
boolean titlebar = true
string dataobject = "d_mcn_mold_card_rpt"
end type

event dw_3::rowfocuschanged;call super::rowfocuschanged;string lvs_filename

if currentrow < 1 then return
this.object.p_image.filename = ''
lvs_filename = f_download_mold_rtn_filename( this.object.mold_code[currentrow])

this.object.p_image.filename = lvs_filename
end event

event dw_3::clicked;call super::clicked;if dwo.name = 'b_repair_show' then 		
	
		if this.getrow() < 1 then 
			return
		end if
		
		Long Lvl_return
		String  lvs_file_name
		if this.getrow() < 1 then return 
		
		lvs_file_name = f_download_mold_repair_rtn_filename ( string(this.object.mold_code[this.getrow()] ), long(this.object.repair_sequence[this.getrow()])  )
		
			
			IF lvs_file_name = '' OR ISNULL(lvs_file_name) THEN 
				RETURN
			else
			
				f_shell_execute_by_extention ( lvs_file_name   , '' ,Gvs_default_directory+'\Temp'  )

			end if
		
		Changedirectory(Gvs_default_directory)
	
	
end if 
end event

type dw_2 from w_main_root`dw_2 within w_mcn_mold_rpt
integer y = 500
integer width = 4507
integer height = 1832
integer taborder = 0
boolean titlebar = true
string title = "Mold Bill List"
end type

type dw_1 from w_main_root`dw_1 within w_mcn_mold_rpt
integer y = 500
integer width = 4901
integer height = 1832
integer taborder = 0
boolean titlebar = true
string title = "Mold List"
string dataobject = "d_mcn_mold_rpt"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_mcn_mold_rpt
end type

type rb_mold_master from so_radiobutton within w_mcn_mold_rpt
integer x = 55
integer y = 88
integer width = 489
boolean bringtotop = true
integer weight = 700
string text = "Mold Master"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true
selected_data_window = dw_1

end event

type st_1 from so_statictext within w_mcn_mold_rpt
integer x = 1253
integer y = 80
integer width = 503
integer height = 64
boolean bringtotop = true
string text = "Mold Code"
end type

type st_4 from so_statictext within w_mcn_mold_rpt
integer x = 2880
integer y = 80
integer width = 544
integer height = 64
boolean bringtotop = true
string text = "Mold Material"
end type

type ddlb_item_code from uo_item_code within w_mcn_mold_rpt
integer x = 2880
integer y = 160
integer width = 549
integer taborder = 40
boolean bringtotop = true
end type

type rb_3 from so_radiobutton within w_mcn_mold_rpt
integer x = 50
integer y = 376
integer width = 315
boolean bringtotop = true
integer weight = 700
string text = "All"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.setfilter( '')
dw_1.filter( )
end event

type rb_1 from so_radiobutton within w_mcn_mold_rpt
integer x = 1202
integer y = 376
integer width = 402
boolean bringtotop = true
integer weight = 700
string text = "Breaked"
end type

event clicked;call super::clicked;dw_1.setfilter("break_value <= actual_value")
dw_1.filter( )
end event

type rb_2 from so_radiobutton within w_mcn_mold_rpt
integer x = 462
integer y = 376
integer width = 535
boolean bringtotop = true
integer weight = 700
string text = "Remain Value > 0"
end type

event clicked;call super::clicked;dw_1.setfilter("break_value > actual_value")
dw_1.filter( )
end event

type rb_mold_card from so_radiobutton within w_mcn_mold_rpt
integer x = 64
integer y = 184
integer width = 466
boolean bringtotop = true
integer weight = 700
string text = "Mold Card"
end type

event clicked;call super::clicked;dw_3.bringtotop = true
selected_data_window = dw_3

end event

type rb_4 from so_radiobutton within w_mcn_mold_rpt
integer x = 1614
integer y = 376
integer width = 443
boolean bringtotop = true
integer weight = 700
string text = "Rent"
end type

event clicked;call super::clicked;dw_1.setfilter("rent_status = 'N'")
dw_1.filter( )
end event

type rb_5 from so_radiobutton within w_mcn_mold_rpt
integer x = 1975
integer y = 380
integer width = 315
boolean bringtotop = true
integer weight = 700
string text = "Wait"
end type

event clicked;call super::clicked;dw_1.setfilter("rent_status <> 'N'")
dw_1.filter( )
end event

type rb_barcode from so_radiobutton within w_mcn_mold_rpt
integer x = 581
integer y = 88
integer width = 475
boolean bringtotop = true
integer weight = 700
string text = "Mold Barcode 1"
end type

event clicked;call super::clicked;dw_4.bringtotop = true
dw_4.dataobject = 'd_mcn_mold_barcode_rpt'
dw_4.settransobject(sqlca)
selected_data_window = dw_4
end event

type ddlb_mold_code from uo_mold_code within w_mcn_mold_rpt
integer x = 1275
integer y = 160
integer width = 480
integer taborder = 40
boolean bringtotop = true
end type

type ddlb_mold_group from uo_basecode within w_mcn_mold_rpt
integer x = 2144
integer y = 160
integer height = 908
integer taborder = 110
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'MOLD GROUP')
end event

event selectionchanged;call super::selectionchanged;f_retrieve()
end event

type st_6 from so_statictext within w_mcn_mold_rpt
integer x = 2144
integer y = 80
integer width = 731
integer height = 76
boolean bringtotop = true
string text = "Mold Group"
end type

type rb_barcode_2 from so_radiobutton within w_mcn_mold_rpt
integer x = 585
integer y = 176
integer width = 475
boolean bringtotop = true
integer weight = 700
string text = "Mold Barcode 2"
end type

event clicked;call super::clicked;dw_4.bringtotop = true
dw_4.dataobject = 'd_mcn_mold_barcode_rpt_2'
dw_4.settransobject(sqlca)
selected_data_window = dw_4
end event

type sle_mold_name from so_singlelineedit within w_mcn_mold_rpt
integer x = 1765
integer y = 160
integer width = 366
integer height = 84
integer taborder = 50
boolean bringtotop = true
textcase textcase = upper!
end type

type st_7 from so_statictext within w_mcn_mold_rpt
integer x = 1765
integer y = 80
integer width = 366
integer height = 64
boolean bringtotop = true
string text = "Mold Name"
end type

type gb_1 from groupbox within w_mcn_mold_rpt
integer x = 9
integer width = 1207
integer height = 312
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Category"
end type

type gb_2 from groupbox within w_mcn_mold_rpt
integer x = 1234
integer y = 4
integer width = 2235
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
string text = "Where Condition"
end type

type gb_3 from groupbox within w_mcn_mold_rpt
integer x = 18
integer y = 316
integer width = 2437
integer height = 176
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Filter"
end type

