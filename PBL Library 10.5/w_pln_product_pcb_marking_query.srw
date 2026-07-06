HA$PBExportHeader$w_pln_product_pcb_marking_query.srw
$PBExportComments$Line Master
forward
global type w_pln_product_pcb_marking_query from w_main_root
end type
type st_mrm_no from statictext within w_pln_product_pcb_marking_query
end type
type sle_run_no from so_singlelineedit within w_pln_product_pcb_marking_query
end type
type sle_pcb_serial_no from so_singlelineedit within w_pln_product_pcb_marking_query
end type
type st_2 from statictext within w_pln_product_pcb_marking_query
end type
type sle_model_name from so_singlelineedit within w_pln_product_pcb_marking_query
end type
type st_4 from statictext within w_pln_product_pcb_marking_query
end type
type cb_3 from so_commandbutton within w_pln_product_pcb_marking_query
end type
type uo_dateset from uo_ymd_calendar within w_pln_product_pcb_marking_query
end type
type st_6 from so_statictext within w_pln_product_pcb_marking_query
end type
type uo_dateend from uo_ymd_calendar within w_pln_product_pcb_marking_query
end type
type cb_1 from so_commandbutton within w_pln_product_pcb_marking_query
end type
type cb_load_data from so_commandbutton within w_pln_product_pcb_marking_query
end type
type st_5 from so_statictext within w_pln_product_pcb_marking_query
end type
type st_ng from so_statictext within w_pln_product_pcb_marking_query
end type
type rb_detail from so_radiobutton within w_pln_product_pcb_marking_query
end type
type rb_summary from so_radiobutton within w_pln_product_pcb_marking_query
end type
type gb_1 from so_groupbox within w_pln_product_pcb_marking_query
end type
type gb_2 from so_groupbox within w_pln_product_pcb_marking_query
end type
end forward

global type w_pln_product_pcb_marking_query from w_main_root
integer width = 4837
integer height = 3244
string title = "PCB Marking List Query"
st_mrm_no st_mrm_no
sle_run_no sle_run_no
sle_pcb_serial_no sle_pcb_serial_no
st_2 st_2
sle_model_name sle_model_name
st_4 st_4
cb_3 cb_3
uo_dateset uo_dateset
st_6 st_6
uo_dateend uo_dateend
cb_1 cb_1
cb_load_data cb_load_data
st_5 st_5
st_ng st_ng
rb_detail rb_detail
rb_summary rb_summary
gb_1 gb_1
gb_2 gb_2
end type
global w_pln_product_pcb_marking_query w_pln_product_pcb_marking_query

type variables
Long Lvl_row 
String lvs_current_array_type , lvs_last_run_no
String lvs_user_line_code  , lvs_user_machine_code
end variables

on w_pln_product_pcb_marking_query.create
int iCurrent
call super::create
this.st_mrm_no=create st_mrm_no
this.sle_run_no=create sle_run_no
this.sle_pcb_serial_no=create sle_pcb_serial_no
this.st_2=create st_2
this.sle_model_name=create sle_model_name
this.st_4=create st_4
this.cb_3=create cb_3
this.uo_dateset=create uo_dateset
this.st_6=create st_6
this.uo_dateend=create uo_dateend
this.cb_1=create cb_1
this.cb_load_data=create cb_load_data
this.st_5=create st_5
this.st_ng=create st_ng
this.rb_detail=create rb_detail
this.rb_summary=create rb_summary
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_mrm_no
this.Control[iCurrent+2]=this.sle_run_no
this.Control[iCurrent+3]=this.sle_pcb_serial_no
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.sle_model_name
this.Control[iCurrent+6]=this.st_4
this.Control[iCurrent+7]=this.cb_3
this.Control[iCurrent+8]=this.uo_dateset
this.Control[iCurrent+9]=this.st_6
this.Control[iCurrent+10]=this.uo_dateend
this.Control[iCurrent+11]=this.cb_1
this.Control[iCurrent+12]=this.cb_load_data
this.Control[iCurrent+13]=this.st_5
this.Control[iCurrent+14]=this.st_ng
this.Control[iCurrent+15]=this.rb_detail
this.Control[iCurrent+16]=this.rb_summary
this.Control[iCurrent+17]=this.gb_1
this.Control[iCurrent+18]=this.gb_2
end on

on w_pln_product_pcb_marking_query.destroy
call super::destroy
destroy(this.st_mrm_no)
destroy(this.sle_run_no)
destroy(this.sle_pcb_serial_no)
destroy(this.st_2)
destroy(this.sle_model_name)
destroy(this.st_4)
destroy(this.cb_3)
destroy(this.uo_dateset)
destroy(this.st_6)
destroy(this.uo_dateend)
destroy(this.cb_1)
destroy(this.cb_load_data)
destroy(this.st_5)
destroy(this.st_ng)
destroy(this.rb_detail)
destroy(this.rb_summary)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event activate;call super::activate;/***************************************
* Window Default Property 
****************************************/
Gst_set.window_id            = this.classname() 
Gst_set.author                  = "JiSheng"
Gst_set.creation_date      = '20051101'
Gst_set.last_modify_date = '20051101'
Gst_set.Report_window    = False  // Report Window  True / Flase

/*****************************************
* Data Window Property
******************************************/
Ivs_resize_type                      = 'NORMAL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default

/****************************************
*  Menu Property
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

event ue_data_control;call super::ue_data_control;LONG row
STRING lvs_pid, lvs_rowid

CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		
		IF RB_DETAIL.CHECKED  = TRUE THEN 
			DW_1.RETRIEVE( SLE_RUN_NO.TEXT+'%' , sle_pcb_serial_no.TEXT+'%' ,  uo_dateset.text() , uo_dateend.text() , GVI_ORGANIZATION_ID )
		ELSE
			DW_2.RETRIEVE( SLE_RUN_NO.TEXT+'%' , sle_pcb_serial_no.TEXT+'%' ,  uo_dateset.text() , uo_dateend.text() , GVI_ORGANIZATION_ID )

		END IF 
		
	CASE 'DELETE'
		
		IF RB_DETAIL.CHECKED  = TRUE THEN 
			
		  	if DW_1.getrow() < 1 then return 
			  
			msg =f_msgbox(1003)
			
			if msg = 1 then
				
				gvl_row_deleted = DW_1.getrow()		
				
				lvs_pid     = DW_1.object.pid[gvl_row_deleted]
			     lvs_rowid = DW_1.object.row_pos[gvl_row_deleted]
				 
				delete iq_machine_inspect_data_mk where pid = :lvs_pid and rowid = CHARTOROWID(:lvs_rowid) ;
				commit;
				
				DW_1.deleterow(gvl_row_deleted)		
				DW_1.setfocus()
				row = DW_1.getrow()
				DW_1.scrolltorow(row)
				DW_1.setcolumn(1)
				
			end if
			
	   END IF
			
	CASE 'UPDATE'
		
//		 DW_1.ACCEPTTEXT()
// 
//		IF DW_1.UPDATE() < 0 THEN
//			ROLLBACK;
//			RETURN
//		ELSE
//			     COMMIT;
//				 F_MSG_MDI_HELP ( F_MSG_ST(170)	 ) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
//		END IF
			
	CASE ELSE
		
END CHOOSE
end event

type dw_5 from w_main_root`dw_5 within w_pln_product_pcb_marking_query
integer y = 320
integer height = 1932
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_pln_product_pcb_marking_query
integer y = 320
integer height = 1932
integer taborder = 0
end type

type dw_3 from w_main_root`dw_3 within w_pln_product_pcb_marking_query
integer y = 320
integer width = 4544
integer height = 1932
integer taborder = 0
end type

type dw_2 from w_main_root`dw_2 within w_pln_product_pcb_marking_query
integer y = 320
integer width = 4567
integer height = 1932
integer taborder = 0
boolean titlebar = true
string dataobject = "d_pln_product_pcb_marking_SUMMARY_lst"
end type

type dw_1 from w_main_root`dw_1 within w_pln_product_pcb_marking_query
integer y = 320
integer width = 4567
integer height = 1932
integer taborder = 0
boolean titlebar = true
string title = "PCB Barcode List"
string dataobject = "d_pln_product_pcb_marking_lst"
end type

event dw_1::clicked;call super::clicked;SLE_RUN_NO.SETFOCUS()
end event

event dw_1::doubleclicked;call super::doubleclicked;if row < 1 then return


openwithparm(w_pln_run_card_popup , string(this.object.run_no[row]) ) 
end event

type uo_tabpages from w_main_root`uo_tabpages within w_pln_product_pcb_marking_query
integer taborder = 0
end type

type st_mrm_no from statictext within w_pln_product_pcb_marking_query
integer x = 658
integer y = 84
integer width = 631
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Run No"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_run_no from so_singlelineedit within w_pln_product_pcb_marking_query
integer x = 658
integer y = 164
integer width = 631
integer taborder = 10
boolean bringtotop = true
textcase textcase = upper!
end type

type sle_pcb_serial_no from so_singlelineedit within w_pln_product_pcb_marking_query
integer x = 1893
integer y = 164
integer width = 690
integer taborder = 30
boolean bringtotop = true
end type

type st_2 from statictext within w_pln_product_pcb_marking_query
integer x = 1893
integer y = 84
integer width = 690
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "PCB Serial No"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_model_name from so_singlelineedit within w_pln_product_pcb_marking_query
integer x = 1298
integer y = 164
integer width = 581
boolean bringtotop = true
boolean enabled = false
textcase textcase = upper!
end type

type st_4 from statictext within w_pln_product_pcb_marking_query
integer x = 1298
integer y = 84
integer width = 581
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Model Name"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_3 from so_commandbutton within w_pln_product_pcb_marking_query
integer x = 1143
integer y = 56
integer width = 151
integer height = 108
boolean bringtotop = true
string text = "?"
end type

event clicked;call super::clicked;sle_run_no.text = lvs_last_run_no
end event

type uo_dateset from uo_ymd_calendar within w_pln_product_pcb_marking_query
event destroy ( )
integer x = 2592
integer y = 156
integer taborder = 50
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type st_6 from so_statictext within w_pln_product_pcb_marking_query
integer x = 2592
integer y = 76
integer width = 814
integer height = 68
boolean bringtotop = true
string text = "Run Date"
end type

type uo_dateend from uo_ymd_calendar within w_pln_product_pcb_marking_query
event destroy ( )
integer x = 3003
integer y = 156
integer taborder = 60
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type cb_1 from so_commandbutton within w_pln_product_pcb_marking_query
integer x = 1838
integer y = 68
integer width = 151
integer height = 92
integer taborder = 70
boolean bringtotop = true
string text = "?"
end type

event clicked;call super::clicked;open( w_pln_serial_info_popup )

sle_pcb_serial_no.text = message.stringparm


end event

type cb_load_data from so_commandbutton within w_pln_product_pcb_marking_query
integer x = 3493
integer y = 100
integer height = 132
integer taborder = 20
boolean bringtotop = true
string text = "Load File"
end type

event clicked;call super::clicked;string is_fullname , is_filename[] , lvs_run_no , lvs_table_type , sql_syntax , presentation_str ,dwsyntax_str ,  ERRORS 
string lvs_serial_no , lvs_judgment , lvs_judgment_dw , lvs_old_run_no 
Long flen , i , j , k , lvi_count , lvi_error , lvl_rowcount
Int li_FileNum , lvi_exists
//======================================================
//
//======================================================		
if GetFileOpenName("Select File", is_fullname, is_filename[], "CSV", "All Files (*.*), *.*") < 1 then return

flen = FileLength(is_fullname)
						
IF FLEN < 0 THEN 
	F_MSGBOX1(9020 ,is_fullname )
	RETURN 
END IF

//=====================================================
// $$HEX5$$0cd37cc774ac18c22000$$ENDHEX$$
//=====================================================
lvi_count = Upperbound(is_filename)

if lvi_count < 1 then 
	return 
end if 

do
	j++
//======================================================
//
//======================================================			
		lvs_run_no = MID(is_filename[j] , 1, POS( is_filename[j] , '_' , 1) -1 )
		
		if lvs_run_no = '' or isnull(lvs_run_no) then
			lvs_run_no= MID(is_filename[j] , 1, POS( is_filename[j] , '.' , 1) -1 )
		end if 
		
		MSG = f_msgbox1(1151 , upper(lvs_run_no) )
		if msg = 1 then 
		else
			return 
		end if 
		
		dw_2.reset()
		dw_2.bringtotop = true 

		  SELECT F_GET_TABLE_SQL( 'IQ_MACHINE_INSPECT_DATA_MK' , 'A') 
		     INTO :sql_syntax
		    FROM DUAL  ;	  
			 
			IF F_SQL_CHECK() < 0 THEN 
				RETURN 
			END IF

//======================================================

			presentation_str = "style(type=grid)"
			dwsyntax_str = sqlca.SyntaxFromSQL(sql_syntax, presentation_str, ERRORS)
			
			IF Len(ERRORS) > 0 THEN
				MessageBox("Error" , " SyntaxFromSQL errors: " + ERRORS )
				return
			END IF
			//================================================
			// create dynamic datawindow
			//================================================
			dw_2.CREATE( DWSYNTAX_STR, ERRORS)
			dw_2.OBJECT.DATAWINDOW.TABLE.UPDATEKEYINPLACE='YES'
			dw_2.OBJECT.DATAWINDOW.TABLE.UPDATEWHERE=2
			//================================================
			//
			//================================================
			IF Len(ERRORS) > 0 THEN
				MessageBox("Error" , " Create cause these errors: " + ERRORS )
				return				
			END IF
			//================================================
			// file import to datawindow
			//================================================
			dw_2.settransobject( sqlca)
		
		    Changedirectory(Gvs_default_directory)

		//======================================================
		// $$HEX6$$99bdecc5200023b130ae2000$$ENDHEX$$
		//======================================================
		lvi_error = dw_2.importfile(is_fullname , 2 )
		if lvi_error < 0 then 
			exit
		end if 
		
		dw_2.bringtotop = true 
		Messagebox("Notify" , string(dw_2.rowcount() )+" Rows Imported")
		
		//=================================
		//
		//=================================
		
		open(w_progress_popup)
		
		w_progress_popup.f_set_range(1, dw_2.rowcount())
		w_progress_popup.f_setstep(1)
		
		lvl_rowcount = dw_2.rowcount()
		
		do
			
			k++ 
			i++
			
			f_msg_mdi_help( string(k)+"/"+string(i)+"/"+string(lvl_rowcount)+" Row Processing...")
			w_progress_popup.f_stepit()			
			
			dw_2.object.enter_date[i] 		    = f_sysdate()
			dw_2.object.enter_by[i]    		    = gvs_user_id 
			dw_2.object.last_modify_date[i] 	= f_sysdate()
			dw_2.object.last_modify_by[i]    	= gvs_user_id 			
			dw_2.object.organization_id[i]      = gvi_organization_id
			dw_2.object.file_name[i] 		    = is_filename[j]
			dw_2.object.run_no[i]          		= is_filename[j]		
			
			lvs_serial_no                           = dw_2.object.lotid[i]	
	
			if lvs_serial_no = '' or isnull(lvs_serial_no) then 
				
					 dw_2.deleterow(i)
					i = i - 1
					lvl_rowcount = lvl_rowcount -1
					
					st_ng.text = string(long(st_ng.text) + 1)
					
					continue
			end if 
	
		loop until i =lvl_rowcount
		
		//======================================================
		//Save
		//======================================================		
		
		w_progress_popup.f_set_message("Saving...")
		
		f_msg_mdi_help( string(i)+" Saving...")
		
		if dw_2.update() < 0 then 
			rollback;
			return
		else
			commit ;
		end if 		

		close(w_progress_popup)
		f_msgbox(170)
		
loop until j = lvi_count 

f_msg_mdi_help( string(i)+" OK")

//======================================================
//
//======================================================		
dw_2.groupcalc()
dw_2.bringtotop = true 

end event

type st_5 from so_statictext within w_pln_product_pcb_marking_query
integer x = 4027
integer y = 144
integer width = 119
boolean bringtotop = true
string text = "NG"
alignment alignment = right!
end type

type st_ng from so_statictext within w_pln_product_pcb_marking_query
integer x = 4178
integer y = 132
integer width = 256
boolean bringtotop = true
boolean border = true
borderstyle borderstyle = stylelowered!
end type

type rb_detail from so_radiobutton within w_pln_product_pcb_marking_query
integer x = 82
integer y = 76
integer width = 375
boolean bringtotop = true
string text = "Marking Detail"
boolean checked = true
end type

event clicked;call super::clicked;
dw_1.bringtotop = true 
selected_data_window = dw_1
end event

type rb_summary from so_radiobutton within w_pln_product_pcb_marking_query
integer x = 82
integer y = 176
integer width = 453
boolean bringtotop = true
string text = "Marking Summary"
end type

event clicked;call super::clicked;
dw_2.bringtotop = true 
selected_data_window = dw_2
end event

type gb_1 from so_groupbox within w_pln_product_pcb_marking_query
integer x = 603
integer width = 2862
integer height = 304
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_pln_product_pcb_marking_query
integer x = 5
integer width = 576
integer height = 304
integer taborder = 40
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

