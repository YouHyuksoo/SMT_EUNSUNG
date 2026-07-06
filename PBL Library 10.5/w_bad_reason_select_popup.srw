HA$PBExportHeader$w_bad_reason_select_popup.srw
forward
global type w_bad_reason_select_popup from w_main_root
end type
type pb_select from so_picturebutton within w_bad_reason_select_popup
end type
type pb_exit from so_picturebutton within w_bad_reason_select_popup
end type
type pb_retrieve from so_picturebutton within w_bad_reason_select_popup
end type
type p_6 from so_picture within w_bad_reason_select_popup
end type
type p_7 from so_picture within w_bad_reason_select_popup
end type
type sle_value from so_singlelineedit within w_bad_reason_select_popup
end type
type sle_defect_qty from so_singlelineedit within w_bad_reason_select_popup
end type
type st_1 from so_statictext within w_bad_reason_select_popup
end type
type st_2 from so_statictext within w_bad_reason_select_popup
end type
type sle_bad_reason_barcode from so_singlelineedit within w_bad_reason_select_popup
end type
type st_3 from so_statictext within w_bad_reason_select_popup
end type
end forward

global type w_bad_reason_select_popup from w_main_root
integer width = 3936
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
pb_retrieve pb_retrieve
p_6 p_6
p_7 p_7
sle_value sle_value
sle_defect_qty sle_defect_qty
st_1 st_1
st_2 st_2
sle_bad_reason_barcode sle_bad_reason_barcode
st_3 st_3
end type
global w_bad_reason_select_popup w_bad_reason_select_popup

type variables
string  ivs_select
long ivs_selected_rownum
end variables

on w_bad_reason_select_popup.create
int iCurrent
call super::create
this.pb_select=create pb_select
this.pb_exit=create pb_exit
this.pb_retrieve=create pb_retrieve
this.p_6=create p_6
this.p_7=create p_7
this.sle_value=create sle_value
this.sle_defect_qty=create sle_defect_qty
this.st_1=create st_1
this.st_2=create st_2
this.sle_bad_reason_barcode=create sle_bad_reason_barcode
this.st_3=create st_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_select
this.Control[iCurrent+2]=this.pb_exit
this.Control[iCurrent+3]=this.pb_retrieve
this.Control[iCurrent+4]=this.p_6
this.Control[iCurrent+5]=this.p_7
this.Control[iCurrent+6]=this.sle_value
this.Control[iCurrent+7]=this.sle_defect_qty
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.st_2
this.Control[iCurrent+10]=this.sle_bad_reason_barcode
this.Control[iCurrent+11]=this.st_3
end on

on w_bad_reason_select_popup.destroy
call super::destroy
destroy(this.pb_select)
destroy(this.pb_exit)
destroy(this.pb_retrieve)
destroy(this.p_6)
destroy(this.p_7)
destroy(this.sle_value)
destroy(this.sle_defect_qty)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.sle_bad_reason_barcode)
destroy(this.st_3)
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
ivs_dw_2_use_focusindicator = 'Y' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default

ivs_dw_2_selected_row_yn = 'Y' 

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

//F_MENU_CONTROL('DATA_CONTROL' , TRUE)  // All Data Control

/****************************************
* 
****************************************/

end event

event ue_post_open;call super::ue_post_open;
/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

sle_bad_reason_barcode.setfocus()

GVI_OPENTAB_COUNT --
pb_retrieve.triggerevent(clicked!)
end event

event open;call super::open;//this.setredraw( false)
//f_set_layered_window( handle(this) , 85 )
end event

type dw_5 from w_main_root`dw_5 within w_bad_reason_select_popup
boolean visible = false
integer y = 176
integer taborder = 40
boolean titlebar = true
end type

type dw_4 from w_main_root`dw_4 within w_bad_reason_select_popup
boolean visible = false
integer y = 176
integer taborder = 50
boolean titlebar = true
end type

type dw_3 from w_main_root`dw_3 within w_bad_reason_select_popup
boolean visible = false
integer y = 176
integer taborder = 70
boolean titlebar = true
boolean maxbox = false
end type

type dw_2 from w_main_root`dw_2 within w_bad_reason_select_popup
integer y = 432
integer width = 3895
integer height = 1924
integer taborder = 60
boolean titlebar = true
string dataobject = "d_bad_reason_select_popup"
boolean maxbox = false
end type

event dw_2::retrieverow;//
end event

event dw_2::doubleclicked;call super::doubleclicked;if row < 1 then return 

ivs_selected_rownum = row 

pb_select.triggerevent( (clicked!))
end event

event dw_2::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 


ivs_selected_rownum = currentrow

sle_bad_reason_barcode.text = this.object.code_mean[currentrow]


end event

type dw_1 from w_main_root`dw_1 within w_bad_reason_select_popup
integer width = 3895
integer height = 424
integer taborder = 0
string dataobject = "d_bad_reason_group_select_popup"
boolean maxbox = false
borderstyle borderstyle = stylebox!
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 

dw_2.retrieve(   '%' , this.object.code_name[currentrow] ,  gvs_language , gvi_organization_id )
end event

event dw_1::clicked;//

if getrow() < 1 then return 
end event

type uo_tabpages from w_main_root`uo_tabpages within w_bad_reason_select_popup
integer taborder = 0
end type

type pb_select from so_picturebutton within w_bad_reason_select_popup
integer x = 3045
integer y = 2384
integer width = 448
integer height = 212
boolean bringtotop = true
integer textsize = -10
string text = "Apply"
alignment htextalign = center!
vtextalign vtextalign = vcenter!
end type

event clicked;call super::clicked;if dw_2.getrow() < 1 then return 

Gst_return.gvb_return = true
Gst_return.gvs_return[1] = dw_2.object.code_name[dw_2.getrow()]
Gst_return.gvs_return[2] = dw_2.object.code_mean[dw_2.getrow()]

if sle_value.text = '' or isnull(sle_value.text) then 
	Gst_return.gvl_return[1] = 0
	Gst_return.gvl_return[2] = 0	
	Gst_return.gvs_return[2] = ''
else
	Gst_return.gvl_return[1] = Long(sle_value.text)	
	Gst_return.gvl_return[2] = Long(sle_defect_qty.text)	//$$HEX6$$88bdc9b7200010c818c22000$$ENDHEX$$
//	Gst_return.gvs_return[2] = mle_location_infor.text
	
	
end if 

Close(parent)
end event

type pb_exit from so_picturebutton within w_bad_reason_select_popup
integer x = 3488
integer y = 2384
integer width = 379
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

type pb_retrieve from so_picturebutton within w_bad_reason_select_popup
integer x = 2656
integer y = 2388
integer width = 379
integer height = 212
boolean bringtotop = true
integer textsize = -10
string text = "Retrieve"
alignment htextalign = center!
vtextalign vtextalign = vcenter!
end type

event clicked;call super::clicked;dw_1.retrieve( gvs_language , gvi_organization_id  )

end event

type p_6 from so_picture within w_bad_reason_select_popup
integer x = 3063
integer y = 2404
integer width = 73
integer height = 64
boolean bringtotop = true
string picturename = "Query!"
boolean map3dcolors = true
end type

type p_7 from so_picture within w_bad_reason_select_popup
integer x = 3515
integer y = 2404
integer width = 73
integer height = 64
boolean bringtotop = true
string picturename = "Exit!"
boolean map3dcolors = true
end type

type sle_value from so_singlelineedit within w_bad_reason_select_popup
integer x = 2327
integer y = 2440
integer width = 279
integer height = 128
integer taborder = 20
boolean bringtotop = true
integer textsize = -16
integer weight = 700
long textcolor = 0
long backcolor = 134217750
string text = "1"
boolean displayonly = true
end type

event getfocus;call super::getfocus;ivs_select = 'LOT'
end event

type sle_defect_qty from so_singlelineedit within w_bad_reason_select_popup
integer x = 1522
integer y = 2440
integer width = 279
integer height = 128
integer taborder = 30
boolean bringtotop = true
integer textsize = -16
integer weight = 700
long textcolor = 65280
long backcolor = 0
string text = "1"
end type

event getfocus;call super::getfocus;ivs_select = 'QTY'
end event

type st_1 from so_statictext within w_bad_reason_select_popup
integer x = 1824
integer y = 2440
integer width = 462
integer height = 128
boolean bringtotop = true
integer textsize = -14
long backcolor = 31916006
string text = "Lot Bad Qty"
alignment alignment = right!
end type

type st_2 from so_statictext within w_bad_reason_select_popup
integer x = 1006
integer y = 2432
integer width = 462
integer height = 128
boolean bringtotop = true
integer textsize = -14
long backcolor = 65535
string text = "Defect Qty"
alignment alignment = right!
end type

type sle_bad_reason_barcode from so_singlelineedit within w_bad_reason_select_popup
integer x = 32
integer y = 2504
integer width = 837
integer taborder = 10
boolean bringtotop = true
long backcolor = 134217741
textcase textcase = upper!
end type

event modified;call super::modified;INT ll_row


	ll_row = dw_2.find ( "code_mean='" + this.text +"'" , 1, dw_2.rowcount() )
	
	IF ll_row = 0 THEN 
		
		this.text= ''
		this.setfocus()
	else
		dw_2.scrolltorow(ll_row)
	END IF 

sle_defect_qty.setfocus()
end event

type st_3 from so_statictext within w_bad_reason_select_popup
integer x = 32
integer y = 2416
integer width = 837
integer height = 72
boolean bringtotop = true
long backcolor = 16777215
string text = "Bad Reason Code"
end type

