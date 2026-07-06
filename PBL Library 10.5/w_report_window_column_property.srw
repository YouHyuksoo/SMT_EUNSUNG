HA$PBExportHeader$w_report_window_column_property.srw
$PBExportComments$Report DW Column Information
forward
global type w_report_window_column_property from w_popup_root
end type
type cb_1 from commandbutton within w_report_window_column_property
end type
type cb_retrieve from commandbutton within w_report_window_column_property
end type
type sle_window_name from singlelineedit within w_report_window_column_property
end type
type sle_datawindow from singlelineedit within w_report_window_column_property
end type
type cb_2 from commandbutton within w_report_window_column_property
end type
type st_1 from statictext within w_report_window_column_property
end type
type st_2 from statictext within w_report_window_column_property
end type
type gb_1 from so_groupbox within w_report_window_column_property
end type
type gb_2 from so_groupbox within w_report_window_column_property
end type
end forward

global type w_report_window_column_property from w_popup_root
integer width = 3776
integer height = 2088
string title = "Update Column Property"
cb_1 cb_1
cb_retrieve cb_retrieve
sle_window_name sle_window_name
sle_datawindow sle_datawindow
cb_2 cb_2
st_1 st_1
st_2 st_2
gb_1 gb_1
gb_2 gb_2
end type
global w_report_window_column_property w_report_window_column_property

type variables
DATAWINDOW ARG_DW
STRING IVS_WINDOW , IVS_DATAWINDOW
end variables

on w_report_window_column_property.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.cb_retrieve=create cb_retrieve
this.sle_window_name=create sle_window_name
this.sle_datawindow=create sle_datawindow
this.cb_2=create cb_2
this.st_1=create st_1
this.st_2=create st_2
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cb_retrieve
this.Control[iCurrent+3]=this.sle_window_name
this.Control[iCurrent+4]=this.sle_datawindow
this.Control[iCurrent+5]=this.cb_2
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.gb_1
this.Control[iCurrent+9]=this.gb_2
end on

on w_report_window_column_property.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.cb_retrieve)
destroy(this.sle_window_name)
destroy(this.sle_datawindow)
destroy(this.cb_2)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;call super::open;ARG_DW = MESSAGE.POWEROBJECTPARM
IVS_WINDOW         =  GST_RETURN.GVS_RETURN[1]
IVS_DATAWINDOW = GST_RETURN.GVS_RETURN[2]
SLE_WINDOW_NAME.TEXT= GST_RETURN.GVS_RETURN[1]
SLE_DATAWINDOW.TEXT= GST_RETURN.GVS_RETURN[2]

cb_retrieve.TRIGGEREVENT(CLICKED!)


end event

event close;call super::close;ROLLBACK;
end event

type p_title from w_popup_root`p_title within w_report_window_column_property
integer width = 3739
end type

type cb_sort from w_popup_root`cb_sort within w_report_window_column_property
boolean visible = true
integer x = 1979
integer y = 304
integer width = 334
end type

type cb_close from w_popup_root`cb_close within w_report_window_column_property
boolean visible = true
integer x = 3328
integer y = 304
integer width = 334
end type

event cb_close::clicked;call super::clicked;ROLLBACK ;
end event

type st_msg from w_popup_root`st_msg within w_report_window_column_property
boolean visible = true
integer x = 9
integer y = 468
integer width = 3739
end type

type dw_1 from w_popup_root`dw_1 within w_report_window_column_property
boolean visible = true
integer y = 560
integer width = 3739
integer height = 1440
string dataobject = "d_report_window_column_property"
end type

type dw_2 from w_popup_root`dw_2 within w_report_window_column_property
boolean visible = true
integer y = 572
end type

type dw_3 from w_popup_root`dw_3 within w_report_window_column_property
integer y = 560
end type

type cb_1 from commandbutton within w_report_window_column_property
integer x = 2994
integer y = 304
integer width = 334
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Apply"
end type

event clicked;MSG = F_MSGBOX1( 1161 , THIS.TEXT ) //@ $$HEX7$$7cb9200098ccacb960d54cae94c6$$ENDHEX$$?
IF MSG = 1 THEN 
	
	IF DW_1.UPDATE() < 0 THEN 
		ROLLBACK ;
		RETURN
	ELSE
		COMMIT ;
	END IF
ELSE
	RETURN 
END IF


F_MSG_MDI_HELP(F_MSG_ST(170)) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
end event

type cb_retrieve from commandbutton within w_report_window_column_property
integer x = 2318
integer y = 304
integer width = 334
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Retrieve"
end type

event clicked;dw_1.retrieve(IVS_WINDOW+'%' , IVS_DATAWINDOW+'%' , gvi_organization_id  )

end event

type sle_window_name from singlelineedit within w_report_window_column_property
integer x = 576
integer y = 272
integer width = 1312
integer height = 80
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

type sle_datawindow from singlelineedit within w_report_window_column_property
integer x = 576
integer y = 360
integer width = 448
integer height = 80
integer taborder = 60
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

type cb_2 from commandbutton within w_report_window_column_property
integer x = 2656
integer y = 308
integer width = 334
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Reset"
end type

event clicked;MSG = F_MSGBOX1( 1161 , THIS.TEXT ) //@ $$HEX7$$7cb9200098ccacb960d54cae94c6$$ENDHEX$$?
IF MSG = 1 THEN 
	
	DELETE FROM ISYS_REPORT_WINDOW_PROPERTY 
	  WHERE WINDOW_NAME         = UPPER(:IVS_WINDOW)
	      AND DATAWINDOW_NAME = UPPER(:IVS_DATAWINDOW)
		 AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
		
	 IF F_SQL_CHECK() < 0 THEN 	
		RETURN 
	END IF 
	
	COMMIT ;
	CB_RETRIEVE.TRIGGEREVENT(CLICKED!)
END IF 
end event

type st_1 from statictext within w_report_window_column_property
integer x = 37
integer y = 284
integer width = 517
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
string text = "Window Name:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_report_window_column_property
integer x = 37
integer y = 372
integer width = 517
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
string text = "Data Window Name:"
alignment alignment = right!
boolean focusrectangle = false
end type

type gb_1 from so_groupbox within w_report_window_column_property
integer x = 1929
integer y = 212
integer width = 1801
integer height = 244
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_2 from so_groupbox within w_report_window_column_property
integer y = 212
integer width = 1920
integer height = 244
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

