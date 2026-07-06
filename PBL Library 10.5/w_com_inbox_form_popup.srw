HA$PBExportHeader$w_com_inbox_form_popup.srw
$PBExportComments$(Item Query)-$$HEX4$$80bd88d470c88cd6$$ENDHEX$$
forward
global type w_com_inbox_form_popup from w_popup_root
end type
type cb_select from commandbutton within w_com_inbox_form_popup
end type
type cb_retrieve from commandbutton within w_com_inbox_form_popup
end type
type st_6 from statictext within w_com_inbox_form_popup
end type
type st_27 from so_statictext within w_com_inbox_form_popup
end type
type sle_run_no from so_singlelineedit within w_com_inbox_form_popup
end type
type sle_model_name from so_singlelineedit within w_com_inbox_form_popup
end type
type sle_label_form_type from so_singlelineedit within w_com_inbox_form_popup
end type
type st_1 from statictext within w_com_inbox_form_popup
end type
type cb_1 from commandbutton within w_com_inbox_form_popup
end type
type sle_lot_no from so_singlelineedit within w_com_inbox_form_popup
end type
type gb_1 from so_groupbox within w_com_inbox_form_popup
end type
type gb_2 from so_groupbox within w_com_inbox_form_popup
end type
end forward

global type w_com_inbox_form_popup from w_popup_root
integer width = 4329
integer height = 2156
string title = "Run No Master Popup"
cb_select cb_select
cb_retrieve cb_retrieve
st_6 st_6
st_27 st_27
sle_run_no sle_run_no
sle_model_name sle_model_name
sle_label_form_type sle_label_form_type
st_1 st_1
cb_1 cb_1
sle_lot_no sle_lot_no
gb_1 gb_1
gb_2 gb_2
end type
global w_com_inbox_form_popup w_com_inbox_form_popup

type variables
string ivs_model_name , ivs_lot_no
end variables

on w_com_inbox_form_popup.create
int iCurrent
call super::create
this.cb_select=create cb_select
this.cb_retrieve=create cb_retrieve
this.st_6=create st_6
this.st_27=create st_27
this.sle_run_no=create sle_run_no
this.sle_model_name=create sle_model_name
this.sle_label_form_type=create sle_label_form_type
this.st_1=create st_1
this.cb_1=create cb_1
this.sle_lot_no=create sle_lot_no
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_select
this.Control[iCurrent+2]=this.cb_retrieve
this.Control[iCurrent+3]=this.st_6
this.Control[iCurrent+4]=this.st_27
this.Control[iCurrent+5]=this.sle_run_no
this.Control[iCurrent+6]=this.sle_model_name
this.Control[iCurrent+7]=this.sle_label_form_type
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.cb_1
this.Control[iCurrent+10]=this.sle_lot_no
this.Control[iCurrent+11]=this.gb_1
this.Control[iCurrent+12]=this.gb_2
end on

on w_com_inbox_form_popup.destroy
call super::destroy
destroy(this.cb_select)
destroy(this.cb_retrieve)
destroy(this.st_6)
destroy(this.st_27)
destroy(this.sle_run_no)
destroy(this.sle_model_name)
destroy(this.sle_label_form_type)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.sle_lot_no)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;call super::open;dw_1.settransobject(sqlca)

ivs_model_name = gst_return.gvs_return[1] //MODEL 
sle_model_name.text = ivs_model_name
sle_run_no.text = message.stringparm //RUN NO
sle_label_form_type.text = gst_return.gvs_return[2]

sle_lot_no.text = gst_return.gvs_return[3]
ivs_lot_no =  gst_return.gvs_return[3]
cb_retrieve.TRIGGEREVENT(CLICKED!)
end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
end if
end event

type p_title from w_popup_root`p_title within w_com_inbox_form_popup
integer width = 4297
integer height = 188
long backcolor = 16777215
end type

type cb_sort from w_popup_root`cb_sort within w_com_inbox_form_popup
boolean visible = true
integer x = 2519
integer y = 280
integer width = 329
integer height = 156
integer taborder = 0
end type

type cb_close from w_popup_root`cb_close within w_com_inbox_form_popup
boolean visible = true
integer x = 3931
integer y = 280
integer width = 329
integer height = 156
integer taborder = 0
end type

event cb_close::clicked;call super::clicked;gst_return.gvb_return = false
end event

type st_msg from w_popup_root`st_msg within w_com_inbox_form_popup
boolean visible = true
integer y = 484
integer width = 4306
end type

type dw_1 from w_popup_root`dw_1 within w_com_inbox_form_popup
boolean visible = true
integer y = 588
integer width = 4306
integer height = 1480
integer taborder = 70
boolean titlebar = true
string title = "Barcode Form List"
string dataobject = "d_com_label_form_popup"
end type

event dw_1::doubleclicked;call super::doubleclicked;IF ROW = 0  THEN 
	RETURN -1
END IF
CB_SELECT.TRIGGEREVENT(CLICKED!)
end event

type dw_2 from w_popup_root`dw_2 within w_com_inbox_form_popup
boolean visible = true
integer y = 772
integer taborder = 0
end type

type dw_3 from w_popup_root`dw_3 within w_com_inbox_form_popup
integer y = 864
end type

type cb_select from commandbutton within w_com_inbox_form_popup
integer x = 3186
integer y = 280
integer width = 329
integer height = 156
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Print"
end type

event clicked;IF DW_1.GETROW() = 0  THEN 
	gst_return.gvb_return = false
	RETURN -1
END IF

long  Lvl_return
string lvs_file_name , lvs_run_no , lvs_sql
lvs_run_no = sle_run_no.text
//=================================================
//
//=================================================
Lvl_return = f_download_label_form_data ( STRING(dw_1.object.model_name[dw_1.getrow()])  , LONG(dw_1.object.label_form_no[dw_1.getrow()] ) )

//messagebox( STRING(dw_1.object.model_name[dw_1.getrow()])  , STRING(dw_1.object.label_form_no[dw_1.getrow()] ) + "  " + STRING(GVI_ORGANIZATION_ID) )

if  Lvl_return > 0 then 

	lvs_file_name = Gvs_default_directory+"\Temp\"+Gst_return.gvs_return[1] 
	
	IF lvs_file_name = '' OR ISNULL(lvs_file_name) THEN 
		RETURN
	END IF
		//$$HEX8$$15bca4c27cb7a8bc20007cc74cb52000$$ENDHEX$$
	if sle_label_form_type.text = 'B' then 
		lvs_sql ="(pack_barcode='"+ivs_lot_no+"') "
		gvs_labeler_path = Profilestring( Gvs_default_directory + "\" + "WORKENV.INI","OTHER","LABELER","")
		//$$HEX7$$0cd31bb87cb7a8bc7cc74cb52000$$ENDHEX$$
	elseif sle_label_form_type.text = 'P' then   
		lvs_sql="( ship_flag='N' and pallet_no='"+ivs_lot_no+"') "
		gvs_labeler_path = Profilestring( Gvs_default_directory + "\" + "WORKENV.INI","OTHER","LABELER","")
	end if
	
	MESSAGEBOX("Notify" , gvs_labeler_path+' /F="'+lvs_file_name+'" /W="'+lvs_sql+'"'+' /PD  /X' )
	
	Run( gvs_labeler_path+' /F="'+lvs_file_name+'" /W="'+lvs_sql+'"'+' /PD  /X', Normal!)
	


else
	
	Messagebox("Error" , "Form Download Error")
	gst_return.gvb_return = false
	return 
	
end if

gst_return.gvb_return = true 

CLOSEWITHRETURN(PARENT , MESSAGE.STRINGPARM )
end event

type cb_retrieve from commandbutton within w_com_inbox_form_popup
integer x = 2853
integer y = 280
integer width = 329
integer height = 156
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Retrieve"
end type

event clicked;DW_1.RETRIEVE( sle_model_name.text , sle_label_form_type.text )
end event

type st_6 from statictext within w_com_inbox_form_popup
integer x = 658
integer y = 280
integer width = 617
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "Model Name"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_27 from so_statictext within w_com_inbox_form_popup
integer x = 37
integer y = 280
integer width = 617
integer height = 72
boolean bringtotop = true
long textcolor = 16711680
string text = "Run No"
end type

type sle_run_no from so_singlelineedit within w_com_inbox_form_popup
integer x = 37
integer y = 344
integer width = 617
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
textcase textcase = upper!
end type

type sle_model_name from so_singlelineedit within w_com_inbox_form_popup
integer x = 667
integer y = 344
integer width = 617
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
textcase textcase = upper!
end type

type sle_label_form_type from so_singlelineedit within w_com_inbox_form_popup
integer x = 1307
integer y = 344
integer width = 530
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
textcase textcase = upper!
end type

type st_1 from statictext within w_com_inbox_form_popup
integer x = 1307
integer y = 280
integer width = 530
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "Label Form Type"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_com_inbox_form_popup
integer x = 3598
integer y = 280
integer width = 329
integer height = 156
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Download"
end type

event clicked;LOng Lvl_return
String lvs_file_name

		Lvl_return = f_download_label_form_data ( STRING(dw_1.object.model_name[dw_1.getrow()])  , LONG(dw_1.object.label_form_no[dw_1.getrow()] ) )
	
		if  Lvl_return > 0 then 
		
			lvs_file_name = Gvs_default_directory+"\Temp\"+dw_1.object.label_form_name[dw_1.getrow()] 
			
			IF lvs_file_name = '' OR ISNULL(lvs_file_name) THEN 
				RETURN
			END IF
			
			f_shell_execute_by_extention ( Gst_return.gvs_return[1]   , '' ,Gvs_default_directory+'\Temp'  )
			
		else
			
		end if
end event

type sle_lot_no from so_singlelineedit within w_com_inbox_form_popup
integer x = 1856
integer y = 340
integer width = 530
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
textcase textcase = upper!
end type

type gb_1 from so_groupbox within w_com_inbox_form_popup
integer y = 200
integer width = 2455
integer height = 284
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_com_inbox_form_popup
integer x = 2491
integer y = 200
integer width = 1810
integer height = 284
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

