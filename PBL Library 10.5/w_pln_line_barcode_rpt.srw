HA$PBExportHeader$w_pln_line_barcode_rpt.srw
forward
global type w_pln_line_barcode_rpt from w_main_root
end type
type cb_preview from so_commandbutton within w_pln_line_barcode_rpt
end type
type st_9 from so_statictext within w_pln_line_barcode_rpt
end type
type sle_line_code from so_singlelineedit within w_pln_line_barcode_rpt
end type
type sle_machine_code from so_singlelineedit within w_pln_line_barcode_rpt
end type
type st_1 from so_statictext within w_pln_line_barcode_rpt
end type
type st_12 from so_statictext within w_pln_line_barcode_rpt
end type
type em_across from so_editmask within w_pln_line_barcode_rpt
end type
type em_height from so_editmask within w_pln_line_barcode_rpt
end type
type st_15 from so_statictext within w_pln_line_barcode_rpt
end type
type st_16 from so_statictext within w_pln_line_barcode_rpt
end type
type em_width from so_editmask within w_pln_line_barcode_rpt
end type
type em_column_space from so_editmask within w_pln_line_barcode_rpt
end type
type st_13 from so_statictext within w_pln_line_barcode_rpt
end type
type st_14 from so_statictext within w_pln_line_barcode_rpt
end type
type em_row_space from so_editmask within w_pln_line_barcode_rpt
end type
type em_font from so_editmask within w_pln_line_barcode_rpt
end type
type st_17 from so_statictext within w_pln_line_barcode_rpt
end type
type st_18 from so_statictext within w_pln_line_barcode_rpt
end type
type em_zoom from so_editmask within w_pln_line_barcode_rpt
end type
type em_topmargin from so_editmask within w_pln_line_barcode_rpt
end type
type em_leftmargin from so_editmask within w_pln_line_barcode_rpt
end type
type st_2 from so_statictext within w_pln_line_barcode_rpt
end type
type st_10 from so_statictext within w_pln_line_barcode_rpt
end type
type st_20 from so_statictext within w_pln_line_barcode_rpt
end type
type em_bottommargin from so_editmask within w_pln_line_barcode_rpt
end type
type rb_line from so_radiobutton within w_pln_line_barcode_rpt
end type
type rb_location from so_radiobutton within w_pln_line_barcode_rpt
end type
type sle_table_id from so_singlelineedit within w_pln_line_barcode_rpt
end type
type st_3 from so_statictext within w_pln_line_barcode_rpt
end type
type sle_lr from so_singlelineedit within w_pln_line_barcode_rpt
end type
type st_4 from so_statictext within w_pln_line_barcode_rpt
end type
type st_5 from so_statictext within w_pln_line_barcode_rpt
end type
type em_start from so_singlelineedit within w_pln_line_barcode_rpt
end type
type em_end from so_singlelineedit within w_pln_line_barcode_rpt
end type
type gb_1 from so_groupbox within w_pln_line_barcode_rpt
end type
type gb_4 from so_groupbox within w_pln_line_barcode_rpt
end type
type gb_2 from so_groupbox within w_pln_line_barcode_rpt
end type
end forward

global type w_pln_line_barcode_rpt from w_main_root
integer width = 5312
integer height = 2856
string title = "Line Barcode"
windowstate windowstate = maximized!
string ivs_dw_1_use_focusindicator = "N"
string ivs_dw_1_selected_row_yn = "N"
cb_preview cb_preview
st_9 st_9
sle_line_code sle_line_code
sle_machine_code sle_machine_code
st_1 st_1
st_12 st_12
em_across em_across
em_height em_height
st_15 st_15
st_16 st_16
em_width em_width
em_column_space em_column_space
st_13 st_13
st_14 st_14
em_row_space em_row_space
em_font em_font
st_17 st_17
st_18 st_18
em_zoom em_zoom
em_topmargin em_topmargin
em_leftmargin em_leftmargin
st_2 st_2
st_10 st_10
st_20 st_20
em_bottommargin em_bottommargin
rb_line rb_line
rb_location rb_location
sle_table_id sle_table_id
st_3 st_3
sle_lr sle_lr
st_4 st_4
st_5 st_5
em_start em_start
em_end em_end
gb_1 gb_1
gb_4 gb_4
gb_2 gb_2
end type
global w_pln_line_barcode_rpt w_pln_line_barcode_rpt

type variables

end variables

on w_pln_line_barcode_rpt.create
int iCurrent
call super::create
this.cb_preview=create cb_preview
this.st_9=create st_9
this.sle_line_code=create sle_line_code
this.sle_machine_code=create sle_machine_code
this.st_1=create st_1
this.st_12=create st_12
this.em_across=create em_across
this.em_height=create em_height
this.st_15=create st_15
this.st_16=create st_16
this.em_width=create em_width
this.em_column_space=create em_column_space
this.st_13=create st_13
this.st_14=create st_14
this.em_row_space=create em_row_space
this.em_font=create em_font
this.st_17=create st_17
this.st_18=create st_18
this.em_zoom=create em_zoom
this.em_topmargin=create em_topmargin
this.em_leftmargin=create em_leftmargin
this.st_2=create st_2
this.st_10=create st_10
this.st_20=create st_20
this.em_bottommargin=create em_bottommargin
this.rb_line=create rb_line
this.rb_location=create rb_location
this.sle_table_id=create sle_table_id
this.st_3=create st_3
this.sle_lr=create sle_lr
this.st_4=create st_4
this.st_5=create st_5
this.em_start=create em_start
this.em_end=create em_end
this.gb_1=create gb_1
this.gb_4=create gb_4
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_preview
this.Control[iCurrent+2]=this.st_9
this.Control[iCurrent+3]=this.sle_line_code
this.Control[iCurrent+4]=this.sle_machine_code
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.st_12
this.Control[iCurrent+7]=this.em_across
this.Control[iCurrent+8]=this.em_height
this.Control[iCurrent+9]=this.st_15
this.Control[iCurrent+10]=this.st_16
this.Control[iCurrent+11]=this.em_width
this.Control[iCurrent+12]=this.em_column_space
this.Control[iCurrent+13]=this.st_13
this.Control[iCurrent+14]=this.st_14
this.Control[iCurrent+15]=this.em_row_space
this.Control[iCurrent+16]=this.em_font
this.Control[iCurrent+17]=this.st_17
this.Control[iCurrent+18]=this.st_18
this.Control[iCurrent+19]=this.em_zoom
this.Control[iCurrent+20]=this.em_topmargin
this.Control[iCurrent+21]=this.em_leftmargin
this.Control[iCurrent+22]=this.st_2
this.Control[iCurrent+23]=this.st_10
this.Control[iCurrent+24]=this.st_20
this.Control[iCurrent+25]=this.em_bottommargin
this.Control[iCurrent+26]=this.rb_line
this.Control[iCurrent+27]=this.rb_location
this.Control[iCurrent+28]=this.sle_table_id
this.Control[iCurrent+29]=this.st_3
this.Control[iCurrent+30]=this.sle_lr
this.Control[iCurrent+31]=this.st_4
this.Control[iCurrent+32]=this.st_5
this.Control[iCurrent+33]=this.em_start
this.Control[iCurrent+34]=this.em_end
this.Control[iCurrent+35]=this.gb_1
this.Control[iCurrent+36]=this.gb_4
this.Control[iCurrent+37]=this.gb_2
end on

on w_pln_line_barcode_rpt.destroy
call super::destroy
destroy(this.cb_preview)
destroy(this.st_9)
destroy(this.sle_line_code)
destroy(this.sle_machine_code)
destroy(this.st_1)
destroy(this.st_12)
destroy(this.em_across)
destroy(this.em_height)
destroy(this.st_15)
destroy(this.st_16)
destroy(this.em_width)
destroy(this.em_column_space)
destroy(this.st_13)
destroy(this.st_14)
destroy(this.em_row_space)
destroy(this.em_font)
destroy(this.st_17)
destroy(this.st_18)
destroy(this.em_zoom)
destroy(this.em_topmargin)
destroy(this.em_leftmargin)
destroy(this.st_2)
destroy(this.st_10)
destroy(this.st_20)
destroy(this.em_bottommargin)
destroy(this.rb_line)
destroy(this.rb_location)
destroy(this.sle_table_id)
destroy(this.st_3)
destroy(this.sle_lr)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.em_start)
destroy(this.em_end)
destroy(this.gb_1)
destroy(this.gb_4)
destroy(this.gb_2)
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
Ivs_resize_type                      = 'MASTER_DETAIL_1L2345R'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


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
F_MENU_CONTROL('DATA_CONTROL' , True)  // All Data Control



end event

event ue_data_control;call super::ue_data_control;Long ROW
STRING LVS_SETYN
CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
	
	
		//	if rb_line.checked = true then 
				DW_1.RETRIEVE(   SLE_LINE_CODE.TEXT+'%' , SLE_MACHINE_CODE.TEXT+'%' , GVI_ORGANIZATION_ID )
				DW_1.SETFOCUS()
				
//			else
//					DW_3.RETRIEVE(  SLE_LINE_CODE.TEXT+'%' , SLE_MACHINE_CODE.TEXT+'%'  ,  sle_table_id.text+'%' , sle_lr.text+'%' , em_start.text , em_end.text ,    GVI_ORGANIZATION_ID )		
//			end if 
	CASE 'INSERT'
	
			row = dw_1.insertrow(dw_1.getrow())
			dw_1.scrolltorow(row)
			f_set_security_row(dw_1 , row , 'ALL')
			F_MSG_MDI_HELP ( F_MSG_ST(152)	 )
	CASE 'APPEND'
	
			row = dw_1.insertrow(0)
			dw_1.scrolltorow(row)
			f_set_security_row(dw_1 , row , 'ALL')
			F_MSG_MDI_HELP ( F_MSG_ST(152)	 )	
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
		
		DW_1.ACCEPTTEXT()
		
 
	      IF DW_1.UPDATE() < 0 THEN
				ROLLBACK;
		ELSE
				 COMMIT;
       			 F_MSG_MDI_HELP ( F_MSG_ST(170)	 ) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
		END IF

	CASE ELSE
END CHOOSE


end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

type dw_5 from w_main_root`dw_5 within w_pln_line_barcode_rpt
integer y = 456
end type

type dw_4 from w_main_root`dw_4 within w_pln_line_barcode_rpt
integer y = 456
boolean titlebar = true
end type

type dw_3 from w_main_root`dw_3 within w_pln_line_barcode_rpt
integer x = 2149
integer y = 456
integer width = 2377
integer height = 2120
boolean titlebar = true
string dataobject = "d_smt_feeder_location_barcode"
end type

type dw_2 from w_main_root`dw_2 within w_pln_line_barcode_rpt
integer x = 2149
integer y = 456
integer width = 2377
integer height = 2120
integer taborder = 0
boolean titlebar = true
string dataobject = "d_line_barcode_rpt"
end type

type dw_1 from w_main_root`dw_1 within w_pln_line_barcode_rpt
integer y = 456
integer width = 2144
integer height = 2120
integer taborder = 0
boolean titlebar = true
string dataobject = "d_line_barcode_lst"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 
if rb_line.checked = true then 
	DW_2.RETRIEVE(   this.object.line_code[currentrow],   GVI_ORGANIZATION_ID )		
else
   DW_3.RETRIEVE(   this.object.line_code[currentrow],  SLE_MACHINE_CODE.TEXT+'%'  ,  sle_table_id.text+'%' , sle_lr.text+'%' , em_start.text , em_end.text ,    GVI_ORGANIZATION_ID )		
end if 
end event

type uo_tabpages from w_main_root`uo_tabpages within w_pln_line_barcode_rpt
end type

type cb_preview from so_commandbutton within w_pln_line_barcode_rpt
integer x = 2309
integer y = 108
integer width = 366
integer height = 132
integer taborder = 70
boolean bringtotop = true
integer weight = 400
string text = "Print"
end type

event clicked;call super::clicked;if rb_line.checked = true then
	openwithparm(w_zetprint , dw_2 )
else
		openwithparm(w_zetprint , dw_3 )
end if 
end event

type st_9 from so_statictext within w_pln_line_barcode_rpt
integer x = 622
integer y = 84
integer width = 347
integer height = 76
boolean bringtotop = true
string text = "Line Code"
end type

type sle_line_code from so_singlelineedit within w_pln_line_barcode_rpt
integer x = 622
integer y = 164
integer width = 347
integer height = 84
integer taborder = 140
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

type sle_machine_code from so_singlelineedit within w_pln_line_barcode_rpt
integer x = 974
integer y = 164
integer width = 357
integer height = 84
integer taborder = 150
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

type st_1 from so_statictext within w_pln_line_barcode_rpt
integer x = 974
integer y = 84
integer width = 357
integer height = 76
boolean bringtotop = true
string text = "Machine Code"
end type

type st_12 from so_statictext within w_pln_line_barcode_rpt
integer x = 2693
integer y = 84
integer width = 197
integer height = 68
boolean bringtotop = true
string text = "Across"
end type

type em_across from so_editmask within w_pln_line_barcode_rpt
integer x = 2693
integer y = 164
integer width = 197
integer height = 84
integer taborder = 60
boolean bringtotop = true
string text = "10"
string mask = "##########"
end type

event constructor;call super::constructor;this.text = Gvs_label_across
end event

event modified;call super::modified;selected_data_window.Modify("DataWindow.Label.Columns="+em_across.text)	

end event

type em_height from so_editmask within w_pln_line_barcode_rpt
integer x = 2894
integer y = 164
integer width = 247
integer height = 84
integer taborder = 70
boolean bringtotop = true
string text = "0"
string mask = "######"
double increment = 1
end type

event constructor;call super::constructor;this.text = Gvs_label_height
end event

event modified;call super::modified;selected_data_window.Modify("DataWindow.Label.Height ='"+this.text+"'")	


end event

type st_15 from so_statictext within w_pln_line_barcode_rpt
integer x = 2894
integer y = 84
integer width = 247
integer height = 68
boolean bringtotop = true
string text = "Height"
end type

type st_16 from so_statictext within w_pln_line_barcode_rpt
integer x = 3150
integer y = 84
integer width = 247
integer height = 68
boolean bringtotop = true
string text = "Width"
end type

type em_width from so_editmask within w_pln_line_barcode_rpt
integer x = 3150
integer y = 164
integer width = 247
integer height = 84
integer taborder = 80
boolean bringtotop = true
string text = "0"
string mask = "######"
double increment = 1
end type

event constructor;call super::constructor;this.text = Gvs_label_width
end event

event modified;call super::modified;selected_data_window.Modify("DataWindow.Label.Width ='"+this.text+"'")	

end event

type em_column_space from so_editmask within w_pln_line_barcode_rpt
integer x = 3406
integer y = 164
integer width = 274
integer height = 84
integer taborder = 90
boolean bringtotop = true
string text = "0"
string mask = "###,##0"
double increment = 1
end type

event constructor;call super::constructor;this.text = Gvs_label_column_spacing
end event

event modified;call super::modified;selected_data_window.Modify("DataWindow.Label.Columns.Spacing ='"+this.text+"'")	

end event

type st_13 from so_statictext within w_pln_line_barcode_rpt
integer x = 3406
integer y = 84
integer width = 274
integer height = 68
boolean bringtotop = true
string text = "C.Spacing"
end type

type st_14 from so_statictext within w_pln_line_barcode_rpt
integer x = 3685
integer y = 84
integer width = 274
integer height = 68
boolean bringtotop = true
string text = "R.Spacing"
end type

type em_row_space from so_editmask within w_pln_line_barcode_rpt
integer x = 3685
integer y = 164
integer width = 274
integer height = 84
integer taborder = 100
boolean bringtotop = true
string text = "0"
string mask = "###,##0"
double increment = 1
end type

event constructor;call super::constructor;this.text = Gvs_label_row_spacing
end event

event modified;call super::modified;selected_data_window.Modify("DataWindow.Label.Rows.Spacing ='"+this.text+"'")		

end event

type em_font from so_editmask within w_pln_line_barcode_rpt
integer x = 3968
integer y = 164
integer width = 279
integer height = 84
integer taborder = 110
boolean bringtotop = true
string text = "4"
string mask = "###"
double increment = 1
string minmax = "1~~"
end type

event constructor;call super::constructor;this.text = Gvs_label_font
end event

event modified;call super::modified;if rb_line.checked = true then 
	selected_data_window.Object.label_text.Font.Height=integer(this.text) * -1	
	
else
	
	selected_data_window.Object.location_code.Font.Height=integer(this.text) * -1		
end if 

end event

type st_17 from so_statictext within w_pln_line_barcode_rpt
integer x = 3968
integer y = 84
integer width = 279
integer height = 68
boolean bringtotop = true
string text = "Font"
end type

type st_18 from so_statictext within w_pln_line_barcode_rpt
integer x = 4923
integer y = 88
integer width = 229
integer height = 68
boolean bringtotop = true
string text = "Zoom"
end type

type em_zoom from so_editmask within w_pln_line_barcode_rpt
integer x = 4923
integer y = 164
integer width = 229
integer height = 84
integer taborder = 120
boolean bringtotop = true
string text = "100"
string mask = "###"
string displaydata = "100~t100/200~t200/300~t300/"
double increment = 1
string minmax = "1~~"
boolean usecodetable = true
end type

event modified;call super::modified;f_set_zoom(selected_data_window, this.text)
end event

type em_topmargin from so_editmask within w_pln_line_barcode_rpt
integer x = 4265
integer y = 164
integer width = 197
integer height = 84
integer taborder = 120
boolean bringtotop = true
string text = "0"
string mask = "###,##0"
end type

event modified;call super::modified;selected_data_window.Object.DataWindow.Print.Margin.Top = this.text
end event

type em_leftmargin from so_editmask within w_pln_line_barcode_rpt
integer x = 4466
integer y = 164
integer width = 215
integer height = 84
integer taborder = 130
boolean bringtotop = true
string text = "0"
string mask = "###,##0"
double increment = 1
end type

event modified;call super::modified;selected_data_window.Object.DataWindow.Print.Margin.Left = this.text
end event

type st_2 from so_statictext within w_pln_line_barcode_rpt
integer x = 4270
integer y = 88
integer width = 201
integer height = 68
boolean bringtotop = true
string text = "T.Margin"
end type

type st_10 from so_statictext within w_pln_line_barcode_rpt
integer x = 4471
integer y = 88
integer width = 215
integer height = 68
boolean bringtotop = true
string text = "L.Margin"
end type

type st_20 from so_statictext within w_pln_line_barcode_rpt
integer x = 4699
integer y = 88
integer width = 215
integer height = 68
boolean bringtotop = true
string text = "B.Margin"
end type

type em_bottommargin from so_editmask within w_pln_line_barcode_rpt
integer x = 4699
integer y = 164
integer width = 215
integer height = 84
integer taborder = 140
boolean bringtotop = true
string text = "0"
string mask = "###,##0"
double increment = 1
end type

event modified;call super::modified;selected_data_window.Object.DataWindow.Print.Margin.Bottom = this.text
end event

type rb_line from so_radiobutton within w_pln_line_barcode_rpt
integer x = 23
integer y = 124
boolean bringtotop = true
string text = "Line Barcode"
boolean checked = true
end type

event clicked;call super::clicked;dw_2.dataobject = 'd_line_barcode_rpt'
dw_2.settransobject( sqlca)
end event

type rb_location from so_radiobutton within w_pln_line_barcode_rpt
integer x = 23
integer y = 260
boolean bringtotop = true
string text = "Location Barcode"
end type

event clicked;call super::clicked;dw_3.bringtotop = true
dw_3.settransobject( sqlca)
end event

type sle_table_id from so_singlelineedit within w_pln_line_barcode_rpt
integer x = 1335
integer y = 160
integer width = 233
integer height = 84
integer taborder = 160
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

type st_3 from so_statictext within w_pln_line_barcode_rpt
integer x = 1344
integer y = 84
integer width = 215
integer height = 76
boolean bringtotop = true
string text = "Table ID"
end type

type sle_lr from so_singlelineedit within w_pln_line_barcode_rpt
integer x = 1577
integer y = 160
integer width = 233
integer height = 84
integer taborder = 170
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

type st_4 from so_statictext within w_pln_line_barcode_rpt
integer x = 1586
integer y = 84
integer width = 215
integer height = 76
boolean bringtotop = true
string text = "L/R"
end type

type st_5 from so_statictext within w_pln_line_barcode_rpt
integer x = 1829
integer y = 76
integer width = 347
integer height = 76
boolean bringtotop = true
string text = "Address"
end type

type em_start from so_singlelineedit within w_pln_line_barcode_rpt
integer x = 1815
integer y = 160
integer width = 192
integer height = 84
integer taborder = 180
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
string text = "01"
textcase textcase = upper!
end type

type em_end from so_singlelineedit within w_pln_line_barcode_rpt
integer x = 2011
integer y = 156
integer width = 192
integer height = 84
integer taborder = 190
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
string text = "999"
textcase textcase = upper!
end type

type gb_1 from so_groupbox within w_pln_line_barcode_rpt
integer x = 2277
integer width = 2949
integer height = 436
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_4 from so_groupbox within w_pln_line_barcode_rpt
integer width = 594
integer height = 436
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_2 from so_groupbox within w_pln_line_barcode_rpt
integer x = 603
integer width = 1641
integer height = 436
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

