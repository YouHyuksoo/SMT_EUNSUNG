HA$PBExportHeader$w_product_carrier_barcode.srw
$PBExportComments$new a led project
forward
global type w_product_carrier_barcode from w_main_root
end type
type st_12 from so_statictext within w_product_carrier_barcode
end type
type em_across from so_editmask within w_product_carrier_barcode
end type
type em_height from so_editmask within w_product_carrier_barcode
end type
type st_15 from so_statictext within w_product_carrier_barcode
end type
type st_16 from so_statictext within w_product_carrier_barcode
end type
type em_width from so_editmask within w_product_carrier_barcode
end type
type em_column_space from so_editmask within w_product_carrier_barcode
end type
type st_13 from so_statictext within w_product_carrier_barcode
end type
type st_14 from so_statictext within w_product_carrier_barcode
end type
type em_row_space from so_editmask within w_product_carrier_barcode
end type
type em_font from so_editmask within w_product_carrier_barcode
end type
type st_17 from so_statictext within w_product_carrier_barcode
end type
type st_18 from so_statictext within w_product_carrier_barcode
end type
type em_zoom from so_editmask within w_product_carrier_barcode
end type
type cb_1 from so_commandbutton within w_product_carrier_barcode
end type
type em_start_serial from so_editmask within w_product_carrier_barcode
end type
type em_end_serial from so_editmask within w_product_carrier_barcode
end type
type em_topmargin from so_editmask within w_product_carrier_barcode
end type
type em_leftmargin from so_editmask within w_product_carrier_barcode
end type
type st_9 from so_statictext within w_product_carrier_barcode
end type
type st_10 from so_statictext within w_product_carrier_barcode
end type
type st_11 from so_statictext within w_product_carrier_barcode
end type
type st_20 from so_statictext within w_product_carrier_barcode
end type
type em_bottommargin from so_editmask within w_product_carrier_barcode
end type
type sle_barcode from so_singlelineedit within w_product_carrier_barcode
end type
type cb_2 from so_commandbutton within w_product_carrier_barcode
end type
type cb_3 from so_commandbutton within w_product_carrier_barcode
end type
type em_1 from so_editmask within w_product_carrier_barcode
end type
type em_2 from so_editmask within w_product_carrier_barcode
end type
type sle_tail from so_singlelineedit within w_product_carrier_barcode
end type
type cbx_auto_resize from so_checkbox within w_product_carrier_barcode
end type
type cb_4 from so_commandbutton within w_product_carrier_barcode
end type
type gb_3 from so_groupbox within w_product_carrier_barcode
end type
end forward

global type w_product_carrier_barcode from w_main_root
integer width = 6226
string title = "Carrier Barcode"
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
cb_1 cb_1
em_start_serial em_start_serial
em_end_serial em_end_serial
em_topmargin em_topmargin
em_leftmargin em_leftmargin
st_9 st_9
st_10 st_10
st_11 st_11
st_20 st_20
em_bottommargin em_bottommargin
sle_barcode sle_barcode
cb_2 cb_2
cb_3 cb_3
em_1 em_1
em_2 em_2
sle_tail sle_tail
cbx_auto_resize cbx_auto_resize
cb_4 cb_4
gb_3 gb_3
end type
global w_product_carrier_barcode w_product_carrier_barcode

type variables

end variables

on w_product_carrier_barcode.create
int iCurrent
call super::create
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
this.cb_1=create cb_1
this.em_start_serial=create em_start_serial
this.em_end_serial=create em_end_serial
this.em_topmargin=create em_topmargin
this.em_leftmargin=create em_leftmargin
this.st_9=create st_9
this.st_10=create st_10
this.st_11=create st_11
this.st_20=create st_20
this.em_bottommargin=create em_bottommargin
this.sle_barcode=create sle_barcode
this.cb_2=create cb_2
this.cb_3=create cb_3
this.em_1=create em_1
this.em_2=create em_2
this.sle_tail=create sle_tail
this.cbx_auto_resize=create cbx_auto_resize
this.cb_4=create cb_4
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_12
this.Control[iCurrent+2]=this.em_across
this.Control[iCurrent+3]=this.em_height
this.Control[iCurrent+4]=this.st_15
this.Control[iCurrent+5]=this.st_16
this.Control[iCurrent+6]=this.em_width
this.Control[iCurrent+7]=this.em_column_space
this.Control[iCurrent+8]=this.st_13
this.Control[iCurrent+9]=this.st_14
this.Control[iCurrent+10]=this.em_row_space
this.Control[iCurrent+11]=this.em_font
this.Control[iCurrent+12]=this.st_17
this.Control[iCurrent+13]=this.st_18
this.Control[iCurrent+14]=this.em_zoom
this.Control[iCurrent+15]=this.cb_1
this.Control[iCurrent+16]=this.em_start_serial
this.Control[iCurrent+17]=this.em_end_serial
this.Control[iCurrent+18]=this.em_topmargin
this.Control[iCurrent+19]=this.em_leftmargin
this.Control[iCurrent+20]=this.st_9
this.Control[iCurrent+21]=this.st_10
this.Control[iCurrent+22]=this.st_11
this.Control[iCurrent+23]=this.st_20
this.Control[iCurrent+24]=this.em_bottommargin
this.Control[iCurrent+25]=this.sle_barcode
this.Control[iCurrent+26]=this.cb_2
this.Control[iCurrent+27]=this.cb_3
this.Control[iCurrent+28]=this.em_1
this.Control[iCurrent+29]=this.em_2
this.Control[iCurrent+30]=this.sle_tail
this.Control[iCurrent+31]=this.cbx_auto_resize
this.Control[iCurrent+32]=this.cb_4
this.Control[iCurrent+33]=this.gb_3
end on

on w_product_carrier_barcode.destroy
call super::destroy
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
destroy(this.cb_1)
destroy(this.em_start_serial)
destroy(this.em_end_serial)
destroy(this.em_topmargin)
destroy(this.em_leftmargin)
destroy(this.st_9)
destroy(this.st_10)
destroy(this.st_11)
destroy(this.st_20)
destroy(this.em_bottommargin)
destroy(this.sle_barcode)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.em_1)
destroy(this.em_2)
destroy(this.sle_tail)
destroy(this.cbx_auto_resize)
destroy(this.cb_4)
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
Ivs_resize_type                      = 'MASTER_DETAIL_1L2R'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
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
F_MENU_CONTROL('DATA_CONTROL' , TRUE)  // All Data Control
end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())


end event

event ue_data_control;call super::ue_data_control;Long ROW
STRING LVS_RCV_ISS_TYPE
CHOOSE CASE Gvs_Ue_DATA_control
		
	CASE 'RETRIEVE'

			DW_1.RESET( )
			DW_1.RETRIEVE(sle_barcode.text+'%' , gvi_organization_id )
	CASE 'INSERT' 
		
			DW_1.ENABLED = TRUE
			ROW = DW_1.INSERTROW(DW_1.GETROW())
			DW_1.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_1 , ROW ,'ALL')				
			
	
						
	CASE	'DELETE'
		
			if DW_1.AcceptText() = -1 then
				return
			end if

			MSG = F_MSGBOX(1003)  //$$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?
			IF MSG = 1 THEN
				Gvl_row_deleted = DW_1.GetRow()			
				DW_1.DELETEROW(Gvl_row_deleted)		
				DW_1.SetFocus()
				ROW = DW_1.GetRow()
				DW_1.ScrollToRow(row)
				DW_1.SetColumn(1)
				DW_2.RESET()
			END IF

	CASE 'UPDATE'

	         IF DW_1.UPDATE() < 0  THEN 
			  	 ROLLBACK;
			ELSE
				 COMMIT;
				 F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
			END IF

	CASE ELSE
END CHOOSE
end event

type dw_5 from w_main_root`dw_5 within w_product_carrier_barcode
integer y = 368
end type

type dw_4 from w_main_root`dw_4 within w_product_carrier_barcode
integer y = 368
integer width = 2194
integer height = 1356
boolean titlebar = true
end type

type dw_3 from w_main_root`dw_3 within w_product_carrier_barcode
integer y = 368
integer width = 2194
integer height = 1356
boolean titlebar = true
boolean controlmenu = true
boolean minbox = true
end type

type dw_2 from w_main_root`dw_2 within w_product_carrier_barcode
integer x = 2203
integer y = 364
integer width = 2578
integer height = 1360
boolean titlebar = true
string dataobject = "d_carrier_label_qr_report_20x8"
boolean controlmenu = true
boolean minbox = true
end type

type dw_1 from w_main_root`dw_1 within w_product_carrier_barcode
integer y = 368
integer width = 2194
integer height = 1356
boolean titlebar = true
string dataobject = "d_carier_barcode_lst"
boolean controlmenu = true
boolean minbox = true
end type

type uo_tabpages from w_main_root`uo_tabpages within w_product_carrier_barcode
end type

type st_12 from so_statictext within w_product_carrier_barcode
integer x = 2331
integer y = 56
integer width = 197
integer height = 68
boolean bringtotop = true
string text = "Across"
end type

type em_across from so_editmask within w_product_carrier_barcode
integer x = 2331
integer y = 136
integer width = 197
integer height = 84
integer taborder = 50
boolean bringtotop = true
string text = "1"
string mask = "##########"
end type

event modified;call super::modified;dw_2.Modify("DataWindow.Label.Columns="+em_across.text)	

end event

type em_height from so_editmask within w_product_carrier_barcode
integer x = 2537
integer y = 136
integer width = 247
integer height = 84
integer taborder = 60
boolean bringtotop = true
string text = "800"
string mask = "######"
double increment = 1
end type

event modified;call super::modified;dw_2.Modify("DataWindow.Label.Height ='"+this.text+"'")	

end event

type st_15 from so_statictext within w_product_carrier_barcode
integer x = 2533
integer y = 56
integer width = 247
integer height = 68
boolean bringtotop = true
string text = "Height"
end type

type st_16 from so_statictext within w_product_carrier_barcode
integer x = 2789
integer y = 56
integer width = 247
integer height = 68
boolean bringtotop = true
string text = "Width"
end type

type em_width from so_editmask within w_product_carrier_barcode
integer x = 2789
integer y = 136
integer width = 247
integer height = 84
integer taborder = 70
boolean bringtotop = true
string text = "2000"
string mask = "######"
double increment = 1
end type

event modified;call super::modified;dw_2.Modify("DataWindow.Label.Width ='"+this.text+"'")	


end event

type em_column_space from so_editmask within w_product_carrier_barcode
integer x = 3045
integer y = 136
integer width = 274
integer height = 84
integer taborder = 80
boolean bringtotop = true
string text = "0"
string mask = "###,##0"
double increment = 1
end type

event constructor;call super::constructor;this.text = Gvs_label_column_spacing
end event

event modified;call super::modified;dw_2.Modify("DataWindow.Label.Columns.Spacing ='"+this.text+"'")	

end event

type st_13 from so_statictext within w_product_carrier_barcode
integer x = 3045
integer y = 56
integer width = 274
integer height = 68
boolean bringtotop = true
string text = "C.Spacing"
end type

type st_14 from so_statictext within w_product_carrier_barcode
integer x = 3323
integer y = 56
integer width = 274
integer height = 68
boolean bringtotop = true
string text = "R.Spacing"
end type

type em_row_space from so_editmask within w_product_carrier_barcode
integer x = 3323
integer y = 136
integer width = 274
integer height = 84
integer taborder = 90
boolean bringtotop = true
string text = "0"
string mask = "###,##0"
double increment = 1
end type

event constructor;call super::constructor;this.text = Gvs_label_row_spacing
end event

event modified;call super::modified;dw_2.Modify("DataWindow.Label.Rows.Spacing ='"+this.text+"'")		

end event

type em_font from so_editmask within w_product_carrier_barcode
integer x = 3607
integer y = 136
integer width = 279
integer height = 84
integer taborder = 100
boolean bringtotop = true
string text = "4"
string mask = "###"
double increment = 1
string minmax = "1~~"
end type

event constructor;call super::constructor;this.text = Gvs_label_font
end event

event modified;call super::modified;dw_2.Object.label_text.Font.Height=integer(this.text) * -1	

end event

type st_17 from so_statictext within w_product_carrier_barcode
integer x = 3607
integer y = 56
integer width = 279
integer height = 68
boolean bringtotop = true
string text = "Font"
end type

type st_18 from so_statictext within w_product_carrier_barcode
integer x = 4562
integer y = 60
integer width = 229
integer height = 68
boolean bringtotop = true
string text = "Zoom"
end type

type em_zoom from so_editmask within w_product_carrier_barcode
integer x = 4562
integer y = 136
integer width = 229
integer height = 84
integer taborder = 110
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

type cb_1 from so_commandbutton within w_product_carrier_barcode
string tag = "$$HEX5$$74c7f8bbc0c929bcddc2$$ENDHEX$$"
integer x = 1248
integer y = 80
integer width = 507
integer height = 108
integer taborder = 80
boolean bringtotop = true
integer weight = 400
string text = "2D Barcode Create"
end type

event clicked;call super::clicked;long i , j , lvl_count
string lvs_barcode  , lvs_tail

lvs_barcode = sle_barcode.text
lvl_count = long(em_end_serial.text)
lvs_tail =  sle_tail.text

if isnull(lvs_tail) then 
	lvs_tail = ''
end if 

//if lvs_barcode = '' or isnull(lvs_barcode) then 
//	Messagebox("Error" , "Barcode Data Unknown")
//	return
//end if 

i = long(em_start_serial.text) -1 

open(w_progress_popup)
w_progress_popup.f_set_range(1, lvl_count - i )
w_progress_popup.f_setstep(1)

do
	i++
			  INSERT INTO "IP_PRODUCT_CARRIER_BARCODE"  
					(
					  "SERIAL_NO",   
					  "LABEL_TEXT",   
					  "ORGANIZATION_ID",   
					  "ENTER_DATE",   
					  "ENTER_BY",   
					  "LAST_MODIFY_DATE",   
					  "LAST_MODIFY_BY" )  
		  
				 SELECT  :lvs_barcode||trim(to_char(:i,'000'))||:lvs_tail ,
						     :lvs_barcode||trim(to_char(:i,'000'))||:lvs_tail ,
							:gvi_organization_id ,
							SYSDATE ,
							:GVS_USER_ID ,
							NULL , NULL
				 FROM DUAL ;
					
				IF F_SQL_CHECK() < 0 THEN 
					RETURN 
				END IF 
		w_progress_popup.f_stepit()
		w_progress_popup.f_set_message(string(i))
		
		f_msg_mdi_help( "Create Barcode "+ string(i))
loop until i = lvl_count
close(w_progress_popup)
commit ;

end event

type em_start_serial from so_editmask within w_product_carrier_barcode
integer x = 448
integer y = 172
integer width = 261
integer taborder = 60
boolean bringtotop = true
string text = "0"
alignment alignment = center!
string mask = "000"
boolean spin = true
double increment = 1
end type

type em_end_serial from so_editmask within w_product_carrier_barcode
integer x = 713
integer y = 172
integer width = 261
integer taborder = 70
boolean bringtotop = true
string text = "0"
alignment alignment = center!
string mask = "000"
boolean spin = true
double increment = 1
end type

type em_topmargin from so_editmask within w_product_carrier_barcode
integer x = 3904
integer y = 136
integer width = 197
integer height = 84
integer taborder = 80
boolean bringtotop = true
string text = "0"
string mask = "###,##0"
end type

event modified;call super::modified;dw_4.Object.DataWindow.Print.Margin.Top = this.text
end event

type em_leftmargin from so_editmask within w_product_carrier_barcode
integer x = 4105
integer y = 136
integer width = 215
integer height = 84
integer taborder = 90
boolean bringtotop = true
string text = "0"
string mask = "###,##0"
double increment = 1
end type

event modified;call super::modified;dw_4.Object.DataWindow.Print.Margin.Left = this.text
end event

type st_9 from so_statictext within w_product_carrier_barcode
integer x = 3909
integer y = 60
integer width = 201
integer height = 68
boolean bringtotop = true
string text = "T.Margin"
end type

type st_10 from so_statictext within w_product_carrier_barcode
integer x = 4110
integer y = 60
integer width = 215
integer height = 68
boolean bringtotop = true
string text = "L.Margin"
end type

type st_11 from so_statictext within w_product_carrier_barcode
integer x = 73
integer y = 100
integer width = 1157
integer height = 68
boolean bringtotop = true
string text = "Barcode No"
end type

type st_20 from so_statictext within w_product_carrier_barcode
integer x = 4338
integer y = 60
integer width = 215
integer height = 68
boolean bringtotop = true
string text = "B.Margin"
end type

type em_bottommargin from so_editmask within w_product_carrier_barcode
integer x = 4338
integer y = 136
integer width = 215
integer height = 84
integer taborder = 120
boolean bringtotop = true
string text = "0"
string mask = "###,##0"
double increment = 1
end type

event modified;call super::modified;dw_4.Object.DataWindow.Print.Margin.Bottom = this.text
end event

type sle_barcode from so_singlelineedit within w_product_carrier_barcode
integer x = 73
integer y = 172
integer width = 370
integer taborder = 90
boolean bringtotop = true
textcase textcase = upper!
end type

type cb_2 from so_commandbutton within w_product_carrier_barcode
string tag = "$$HEX5$$74c7f8bbc0c929bcddc2$$ENDHEX$$"
integer x = 1248
integer y = 200
integer width = 507
integer height = 108
integer taborder = 90
boolean bringtotop = true
integer weight = 400
string text = "2D Barcode Preview"
end type

event clicked;call super::clicked;int i = 0,j = 0 
string lvs_file_name , lvs_barcode

lvs_barcode = sle_barcode.text

		Gvs_barcode_type = '71'
		//=======================================
		// $$HEX10$$70b374c730d17cb9200070c88cd65cd5c4d62000$$ENDHEX$$
		// $$HEX8$$f8adbcb93cc75cb820005cd4dcc22000$$ENDHEX$$
		//=======================================			
		dw_2.retrieve(  lvs_barcode+'%' , gvi_organization_id )
		//=======================================
		// $$HEX11$$14bc54cfdcb4200074c7f8bbc0c92000ddc031c12000$$ENDHEX$$
		//=======================================			
		open(w_progress_popup)
		w_progress_popup.f_set_range(1 , dw_2.rowcount( ) )
		w_progress_popup.f_setstep(1)
		//	lvs_barcode_type = ddlb_barcode_type.getcode()
		do
		i++
		Yield()
		lvs_file_name = dw_2.object.serial_no_origin[i]
		
		//$$HEX7$$14bc54cfdcb42000ddc031c12000$$ENDHEX$$
		
		run("zint -o "+lvs_file_name+'.png  -b '+Gvs_barcode_type+' -d '+lvs_file_name , Minimized! )
		
		w_progress_popup.f_stepit()
		w_progress_popup.f_set_message(string(j))
		
		f_msg_mdi_help( "Create Barcode "+ string(i))
		loop until i = dw_2.rowcount( )
		
		sleep(2)
		//======================================
		// $$HEX9$$f8adbcb92000ecd3f7b92000c0bcbdac2000$$ENDHEX$$PNG -> BMP
		//======================================
		i = 0 
		do
		Yield()
		i++
		j++				
		lvs_file_name = dw_2.object.serial_no_origin[i]
		
		//$$HEX6$$ecd3f7b92000c0bcbdac2000$$ENDHEX$$png => bmp
		run("i_view32 "+lvs_file_name+'.png /rotate_l /convert='+lvs_file_name+'.bmp' , Minimized! )  
		
		//dw_2.object.serial_no[i] = dw_2.object.serial_no[i]+".bmp"
		
		w_progress_popup.f_stepit()
		w_progress_popup.f_set_message(string(j))			
		f_msg_mdi_help( "Format Change Barcode "+ string(i))
		loop until i = dw_2.rowcount( )		
		//======================================
		//
		//======================================
		close(w_progress_popup)
		
		
		if cbx_auto_resize.checked = true then 
			
			dw_2.Modify("label_text.font.Height='"+string(integer(em_font.text) * -1)+"'")	
			dw_2.Modify("DataWindow.Label.Height='"+em_height.text+"'")
			dw_2.Modify("DataWindow.Label.Width='"+em_width.text+"'")
			
			dw_2.Modify("DataWindow.Label.Columns="+em_across.text)
			dw_2.Modify("DataWindow.Label.Columns.Spacing ='"+em_column_space.text+"'")
			dw_2.Modify("DataWindow.Label.Rows.Spacing ='"+em_row_space.text+"'")
			
		end if 
		
		dw_2.Modify("DataWindow.Print.Preview.Rulers=yes")
		

end event

type cb_3 from so_commandbutton within w_product_carrier_barcode
string tag = "$$HEX5$$74c7f8bbc0c929bcddc2$$ENDHEX$$"
integer x = 1751
integer y = 80
integer width = 498
integer height = 108
integer taborder = 90
boolean bringtotop = true
integer weight = 400
string text = "2D Barcode Delete"
end type

event clicked;call super::clicked;if f_msgbox1(1161 , this.text) = 1 then 
	
	delete from IP_PRODUCT_CARRIER_BARCODE ;
	if f_sql_check() < 0 then 
		return 
	else
		commit ;
	end if 
end if 
end event

type em_1 from so_editmask within w_product_carrier_barcode
integer x = 2533
integer y = 240
integer width = 247
integer height = 84
integer taborder = 70
boolean bringtotop = true
string text = "0"
string mask = "######"
double increment = 1
end type

event modified;call super::modified;dw_2.Object.serial_no.height=this.text
end event

type em_2 from so_editmask within w_product_carrier_barcode
integer x = 2789
integer y = 240
integer width = 247
integer height = 84
integer taborder = 80
boolean bringtotop = true
string text = "0"
string mask = "######"
double increment = 1
end type

event modified;call super::modified;dw_2.Object.serial_no.width=this.text
end event

type sle_tail from so_singlelineedit within w_product_carrier_barcode
integer x = 983
integer y = 172
integer width = 251
integer taborder = 100
boolean bringtotop = true
textcase textcase = upper!
end type

type cbx_auto_resize from so_checkbox within w_product_carrier_barcode
integer x = 3067
integer y = 236
boolean bringtotop = true
string text = "Auto Resize"
end type

type cb_4 from so_commandbutton within w_product_carrier_barcode
string tag = "$$HEX5$$74c7f8bbc0c929bcddc2$$ENDHEX$$"
integer x = 1751
integer y = 200
integer width = 498
integer height = 108
integer taborder = 100
boolean bringtotop = true
integer weight = 400
string text = "2D Barcode Print"
end type

event clicked;call super::clicked;dw_2.print( false )
end event

type gb_3 from so_groupbox within w_product_carrier_barcode
integer x = 18
integer y = 8
integer width = 2286
integer height = 324
integer taborder = 90
string text = "Label Condition"
end type

