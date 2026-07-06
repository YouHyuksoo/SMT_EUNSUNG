HA$PBExportHeader$w_com_label_file_write_popup.srw
forward
global type w_com_label_file_write_popup from w_popup_root
end type
type cb_select from commandbutton within w_com_label_file_write_popup
end type
type cb_retrieve from commandbutton within w_com_label_file_write_popup
end type
type st_6 from statictext within w_com_label_file_write_popup
end type
type st_27 from so_statictext within w_com_label_file_write_popup
end type
type sle_run_no from so_singlelineedit within w_com_label_file_write_popup
end type
type sle_model_name from so_singlelineedit within w_com_label_file_write_popup
end type
type sle_file_path from so_singlelineedit within w_com_label_file_write_popup
end type
type st_1 from statictext within w_com_label_file_write_popup
end type
type cb_1 from commandbutton within w_com_label_file_write_popup
end type
type gb_1 from so_groupbox within w_com_label_file_write_popup
end type
type gb_2 from so_groupbox within w_com_label_file_write_popup
end type
end forward

global type w_com_label_file_write_popup from w_popup_root
integer width = 3785
integer height = 2156
string title = "Run No Master Popup"
cb_select cb_select
cb_retrieve cb_retrieve
st_6 st_6
st_27 st_27
sle_run_no sle_run_no
sle_model_name sle_model_name
sle_file_path sle_file_path
st_1 st_1
cb_1 cb_1
gb_1 gb_1
gb_2 gb_2
end type
global w_com_label_file_write_popup w_com_label_file_write_popup

type variables
string ivs_model_name
end variables

on w_com_label_file_write_popup.create
int iCurrent
call super::create
this.cb_select=create cb_select
this.cb_retrieve=create cb_retrieve
this.st_6=create st_6
this.st_27=create st_27
this.sle_run_no=create sle_run_no
this.sle_model_name=create sle_model_name
this.sle_file_path=create sle_file_path
this.st_1=create st_1
this.cb_1=create cb_1
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_select
this.Control[iCurrent+2]=this.cb_retrieve
this.Control[iCurrent+3]=this.st_6
this.Control[iCurrent+4]=this.st_27
this.Control[iCurrent+5]=this.sle_run_no
this.Control[iCurrent+6]=this.sle_model_name
this.Control[iCurrent+7]=this.sle_file_path
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.cb_1
this.Control[iCurrent+10]=this.gb_1
this.Control[iCurrent+11]=this.gb_2
end on

on w_com_label_file_write_popup.destroy
call super::destroy
destroy(this.cb_select)
destroy(this.cb_retrieve)
destroy(this.st_6)
destroy(this.st_27)
destroy(this.sle_run_no)
destroy(this.sle_model_name)
destroy(this.sle_file_path)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;call super::open;dw_1.settransobject(sqlca)

ivs_model_name       = gst_return.gvs_return[1] //MODEL 
sle_model_name.text = ivs_model_name
sle_run_no.text         = message.stringparm //RUN NO

cb_retrieve.TRIGGEREVENT(CLICKED!)
end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
end if
end event

type p_title from w_popup_root`p_title within w_com_label_file_write_popup
integer width = 3771
integer height = 188
long backcolor = 16777215
end type

type cb_sort from w_popup_root`cb_sort within w_com_label_file_write_popup
boolean visible = true
integer x = 41
integer y = 648
integer width = 329
integer height = 156
integer taborder = 0
end type

type cb_close from w_popup_root`cb_close within w_com_label_file_write_popup
boolean visible = true
integer x = 1051
integer y = 648
integer width = 329
integer height = 156
integer taborder = 0
end type

type st_msg from w_popup_root`st_msg within w_com_label_file_write_popup
boolean visible = true
integer y = 484
integer width = 3771
end type

type dw_1 from w_popup_root`dw_1 within w_com_label_file_write_popup
boolean visible = true
integer y = 864
integer width = 3771
integer height = 1140
integer taborder = 70
boolean titlebar = true
string title = "Barcode Form List"
string dataobject = "d_com_label_file_write_popup"
end type

event dw_1::doubleclicked;call super::doubleclicked;IF ROW = 0  THEN 
	RETURN -1
END IF
CB_SELECT.TRIGGEREVENT(CLICKED!)
end event

type dw_2 from w_popup_root`dw_2 within w_com_label_file_write_popup
boolean visible = true
integer y = 884
integer taborder = 0
end type

type dw_3 from w_popup_root`dw_3 within w_com_label_file_write_popup
integer y = 864
end type

type cb_select from commandbutton within w_com_label_file_write_popup
integer x = 713
integer y = 648
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
boolean default = true
end type

event clicked;
long lvl_ret

IF DW_1.GETROW() = 0  THEN 
	gst_return.gvb_return = false
	RETURN -1
END IF
//=============================================
//
//=============================================

string is_path , lvs_run_no
is_path = sle_file_path.text
lvs_run_no = sle_run_no.text 

IF ( LEN( is_path ) > 5 ) THEN
		
      lvl_ret = dw_1.saveas(  is_path+"\"+lvs_run_no+".JOB"  , csv! , false )

      IF ( lvl_ret = 1 ) THEN
            Messagebox("Notify" , "OK")
	 ELSE
		   Messagebox("Notify" , "$$HEX12$$14bc54cfdcb4200054d67cc7200000c8a5c72000e4c228d3$$ENDHEX$$! ")
	END IF
		
ELSE
	Messagebox("Notify" , " $$HEX14$$00c8a5c7200060d5200004c758ce7cb9200020c1ddd058d538c194c6$$ENDHEX$$! ")
END IF
		

//================================================
//
//================================================

end event

type cb_retrieve from commandbutton within w_com_label_file_write_popup
integer x = 375
integer y = 648
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

event clicked;DW_1.RETRIEVE( sle_run_no.text )
end event

type st_6 from statictext within w_com_label_file_write_popup
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

type st_27 from so_statictext within w_com_label_file_write_popup
integer x = 37
integer y = 280
integer width = 617
integer height = 72
boolean bringtotop = true
long textcolor = 16711680
string text = "Run No"
end type

type sle_run_no from so_singlelineedit within w_com_label_file_write_popup
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

type sle_model_name from so_singlelineedit within w_com_label_file_write_popup
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

type sle_file_path from so_singlelineedit within w_com_label_file_write_popup
integer x = 1298
integer y = 344
integer width = 2409
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
textcase textcase = upper!
end type

event constructor;call super::constructor;string LVS_PATH
RegistryGet( "HKEY_LOCAL_MACHINE\Software\Infinity21\Jsmes", "MARKINGFILE", RegString!, LVS_PATH)
this.text = LVS_PATH
end event

type st_1 from statictext within w_com_label_file_write_popup
integer x = 1289
integer y = 276
integer width = 2441
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
string text = "Path"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_com_label_file_write_popup
integer x = 1504
integer y = 648
integer width = 329
integer height = 156
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "File Folder"
end type

event clicked;
string is_path , lvs_run_no
is_path = sle_file_path.text
lvs_run_no = sle_run_no.text 

GetFolder ( lvs_run_no , is_path )

RegistrySet( "HKEY_LOCAL_MACHINE\Software\Infinity21\JSMES", "MARKINGFILE", RegString!,string(is_path))

sle_file_path.text = is_path
  
Messagebox("Notify" , "OK")
end event

type gb_1 from so_groupbox within w_com_label_file_write_popup
integer y = 200
integer width = 3753
integer height = 284
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_com_label_file_write_popup
integer y = 568
integer width = 1874
integer height = 284
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

