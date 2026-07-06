HA$PBExportHeader$w_bad_reason_select_4_iqc_popup.srw
forward
global type w_bad_reason_select_4_iqc_popup from w_main_root
end type
type pb_select from so_picturebutton within w_bad_reason_select_4_iqc_popup
end type
type pb_exit from so_picturebutton within w_bad_reason_select_4_iqc_popup
end type
type pb_1 from so_picturebutton within w_bad_reason_select_4_iqc_popup
end type
type p_1 from so_picture within w_bad_reason_select_4_iqc_popup
end type
type p_6 from so_picture within w_bad_reason_select_4_iqc_popup
end type
type p_7 from so_picture within w_bad_reason_select_4_iqc_popup
end type
type mle_comments from so_multilineedit within w_bad_reason_select_4_iqc_popup
end type
type st_1 from so_statictext within w_bad_reason_select_4_iqc_popup
end type
end forward

global type w_bad_reason_select_4_iqc_popup from w_main_root
integer width = 5184
integer height = 2704
string title = "Bad Reason Code"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
long backcolor = 16777215
boolean clientedge = true
boolean center = true
string ivs_dw_1_use_focusindicator = "N"
pb_select pb_select
pb_exit pb_exit
pb_1 pb_1
p_1 p_1
p_6 p_6
p_7 p_7
mle_comments mle_comments
st_1 st_1
end type
global w_bad_reason_select_4_iqc_popup w_bad_reason_select_4_iqc_popup

type variables
string  ivs_select
end variables

on w_bad_reason_select_4_iqc_popup.create
int iCurrent
call super::create
this.pb_select=create pb_select
this.pb_exit=create pb_exit
this.pb_1=create pb_1
this.p_1=create p_1
this.p_6=create p_6
this.p_7=create p_7
this.mle_comments=create mle_comments
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_select
this.Control[iCurrent+2]=this.pb_exit
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.p_1
this.Control[iCurrent+5]=this.p_6
this.Control[iCurrent+6]=this.p_7
this.Control[iCurrent+7]=this.mle_comments
this.Control[iCurrent+8]=this.st_1
end on

on w_bad_reason_select_4_iqc_popup.destroy
call super::destroy
destroy(this.pb_select)
destroy(this.pb_exit)
destroy(this.pb_1)
destroy(this.p_1)
destroy(this.p_6)
destroy(this.p_7)
destroy(this.mle_comments)
destroy(this.st_1)
end on

event ue_data_control;call super::ue_data_control;CHOOSE CASE Gvs_Ue_DATA_control
	CASE 'RETRIEVE'
				dw_1.retrieve( gvs_language , gvi_organization_id )
	CASE ELSE
END CHOOSE


end event

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
Ivs_resize_type    = 'DEFAULT'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
ivs_dw_1_use_focusindicator = 'N' //Focus Indicator Show / Hide Property
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

end event

event ue_post_open;call super::ue_post_open;dw_1.retrieve( gvs_language , gvi_organization_id )


end event

type dw_5 from w_main_root`dw_5 within w_bad_reason_select_4_iqc_popup
boolean visible = false
integer taborder = 40
boolean titlebar = true
end type

type dw_4 from w_main_root`dw_4 within w_bad_reason_select_4_iqc_popup
boolean visible = false
integer taborder = 50
boolean titlebar = true
end type

type dw_3 from w_main_root`dw_3 within w_bad_reason_select_4_iqc_popup
boolean visible = false
integer taborder = 70
boolean titlebar = true
boolean maxbox = false
end type

type dw_2 from w_main_root`dw_2 within w_bad_reason_select_4_iqc_popup
boolean visible = false
integer taborder = 60
boolean titlebar = true
boolean maxbox = false
end type

event dw_2::retrieverow;//
end event

event dw_2::retrievestart;//
end event

event dw_2::rowfocuschanged;//
end event

type dw_1 from w_main_root`dw_1 within w_bad_reason_select_4_iqc_popup
integer width = 3895
integer height = 2608
integer taborder = 0
boolean titlebar = true
string dataobject = "d_bad_reason_select_4_iqc_popup"
boolean maxbox = false
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_1::doubleclicked;call super::doubleclicked;if row < 1 then return 

pb_select.triggerevent( (clicked!))
end event

type uo_tabpages from w_main_root`uo_tabpages within w_bad_reason_select_4_iqc_popup
integer taborder = 0
end type

type pb_select from so_picturebutton within w_bad_reason_select_4_iqc_popup
integer x = 4247
integer y = 984
integer width = 704
integer height = 212
boolean bringtotop = true
integer textsize = -10
integer weight = 700
string text = "Apply"
alignment htextalign = center!
vtextalign vtextalign = vcenter!
end type

event clicked;call super::clicked;if dw_1.getrow() < 1 then return 

	Gst_return.gvb_return = true
	Gst_return.gvs_return[1] = dw_1.object.code_name[dw_1.getrow()]
     Gst_return.gvs_return[2] = mle_comments.text
Close(parent)
end event

type pb_exit from so_picturebutton within w_bad_reason_select_4_iqc_popup
integer x = 4233
integer y = 2356
integer width = 704
integer height = 212
boolean bringtotop = true
integer textsize = -10
string text = "Exit"
alignment htextalign = center!
vtextalign vtextalign = vcenter!
end type

event clicked;call super::clicked;Gst_return.gvb_return = false
close(parent)
end event

type pb_1 from so_picturebutton within w_bad_reason_select_4_iqc_popup
integer x = 4247
integer y = 756
integer width = 704
integer height = 212
boolean bringtotop = true
integer textsize = -10
string text = "Retrieve"
alignment htextalign = center!
vtextalign vtextalign = vcenter!
end type

event clicked;call super::clicked;dw_1.retrieve( gvs_language , gvi_organization_id )
end event

type p_1 from so_picture within w_bad_reason_select_4_iqc_popup
integer x = 4283
integer y = 828
integer width = 73
integer height = 64
boolean bringtotop = true
string picturename = "Retrieve!"
boolean map3dcolors = true
end type

type p_6 from so_picture within w_bad_reason_select_4_iqc_popup
integer x = 4279
integer y = 1060
integer width = 73
integer height = 64
boolean bringtotop = true
string picturename = "Query!"
boolean map3dcolors = true
end type

type p_7 from so_picture within w_bad_reason_select_4_iqc_popup
integer x = 4306
integer y = 2428
integer width = 73
integer height = 64
boolean bringtotop = true
string picturename = "Exit!"
boolean map3dcolors = true
end type

type mle_comments from so_multilineedit within w_bad_reason_select_4_iqc_popup
integer x = 3909
integer y = 160
integer width = 1234
integer taborder = 50
boolean bringtotop = true
string text = ""
end type

type st_1 from so_statictext within w_bad_reason_select_4_iqc_popup
integer x = 3918
integer y = 20
integer width = 1221
integer height = 104
boolean bringtotop = true
string text = "comment"
end type

