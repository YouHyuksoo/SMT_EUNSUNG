HA$PBExportHeader$w_sal_palette_popup.srw
$PBExportComments$(Item Query)-$$HEX4$$80bd88d470c88cd6$$ENDHEX$$
forward
global type w_sal_palette_popup from w_popup_root
end type
type cb_select from commandbutton within w_sal_palette_popup
end type
type cb_retrieve from commandbutton within w_sal_palette_popup
end type
type sle_palette_no from so_singlelineedit within w_sal_palette_popup
end type
type st_3 from so_statictext within w_sal_palette_popup
end type
type uo_dateset from uo_ymd_calendar within w_sal_palette_popup
end type
type st_6 from so_statictext within w_sal_palette_popup
end type
type uo_dateend from uo_ymd_calendar within w_sal_palette_popup
end type
type cb_2 from so_commandbutton within w_sal_palette_popup
end type
type sle_lot_no from so_singlelineedit within w_sal_palette_popup
end type
type st_2 from so_statictext within w_sal_palette_popup
end type
type sle_run_no from so_singlelineedit within w_sal_palette_popup
end type
type st_1 from so_statictext within w_sal_palette_popup
end type
type cb_update from commandbutton within w_sal_palette_popup
end type
type gb_1 from so_groupbox within w_sal_palette_popup
end type
type gb_2 from so_groupbox within w_sal_palette_popup
end type
end forward

global type w_sal_palette_popup from w_popup_root
integer width = 4160
integer height = 2156
string title = "Run No Master Popup"
cb_select cb_select
cb_retrieve cb_retrieve
sle_palette_no sle_palette_no
st_3 st_3
uo_dateset uo_dateset
st_6 st_6
uo_dateend uo_dateend
cb_2 cb_2
sle_lot_no sle_lot_no
st_2 st_2
sle_run_no sle_run_no
st_1 st_1
cb_update cb_update
gb_1 gb_1
gb_2 gb_2
end type
global w_sal_palette_popup w_sal_palette_popup

on w_sal_palette_popup.create
int iCurrent
call super::create
this.cb_select=create cb_select
this.cb_retrieve=create cb_retrieve
this.sle_palette_no=create sle_palette_no
this.st_3=create st_3
this.uo_dateset=create uo_dateset
this.st_6=create st_6
this.uo_dateend=create uo_dateend
this.cb_2=create cb_2
this.sle_lot_no=create sle_lot_no
this.st_2=create st_2
this.sle_run_no=create sle_run_no
this.st_1=create st_1
this.cb_update=create cb_update
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_select
this.Control[iCurrent+2]=this.cb_retrieve
this.Control[iCurrent+3]=this.sle_palette_no
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.uo_dateset
this.Control[iCurrent+6]=this.st_6
this.Control[iCurrent+7]=this.uo_dateend
this.Control[iCurrent+8]=this.cb_2
this.Control[iCurrent+9]=this.sle_lot_no
this.Control[iCurrent+10]=this.st_2
this.Control[iCurrent+11]=this.sle_run_no
this.Control[iCurrent+12]=this.st_1
this.Control[iCurrent+13]=this.cb_update
this.Control[iCurrent+14]=this.gb_1
this.Control[iCurrent+15]=this.gb_2
end on

on w_sal_palette_popup.destroy
call super::destroy
destroy(this.cb_select)
destroy(this.cb_retrieve)
destroy(this.sle_palette_no)
destroy(this.st_3)
destroy(this.uo_dateset)
destroy(this.st_6)
destroy(this.uo_dateend)
destroy(this.cb_2)
destroy(this.sle_lot_no)
destroy(this.st_2)
destroy(this.sle_run_no)
destroy(this.st_1)
destroy(this.cb_update)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;call super::open;dw_1.settransobject(sqlca)

sle_palette_no.text = message.stringparm 

CB_RETRIEVE.TRIGGEREVENT(CLICKED!)


end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
end if
end event

type p_title from w_popup_root`p_title within w_sal_palette_popup
integer width = 4160
integer height = 188
long backcolor = 16777215
end type

type cb_sort from w_popup_root`cb_sort within w_sal_palette_popup
integer x = 0
integer y = 604
integer width = 329
integer height = 156
integer taborder = 0
end type

type cb_close from w_popup_root`cb_close within w_sal_palette_popup
boolean visible = true
integer x = 3767
integer y = 268
integer width = 329
integer height = 156
integer taborder = 0
end type

event cb_close::clicked;call super::clicked;gst_return.gvb_return = false
end event

type st_msg from w_popup_root`st_msg within w_sal_palette_popup
boolean visible = true
integer y = 484
integer width = 4160
end type

type dw_1 from w_popup_root`dw_1 within w_sal_palette_popup
boolean visible = true
integer y = 588
integer width = 4160
integer height = 1480
integer taborder = 70
boolean titlebar = true
string title = "Item List"
string dataobject = "d_sal_shipping_palette_select_popup"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return
if this.object.palette_no[currentrow] = '' or isnull(this.object.palette_no[currentrow]) then 
else
	sle_palette_no.text = this.object.palette_no[currentrow]
end if 
end event

type dw_2 from w_popup_root`dw_2 within w_sal_palette_popup
boolean visible = true
integer y = 772
integer taborder = 0
end type

type dw_3 from w_popup_root`dw_3 within w_sal_palette_popup
integer y = 864
end type

type cb_select from commandbutton within w_sal_palette_popup
integer x = 3081
integer y = 264
integer width = 329
integer height = 156
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Process"
boolean default = true
end type

event clicked;long i

if dw_1.rowcount() < 1 then return


if sle_palette_no.text = ''or isnull(sle_palette_no.text) then 
	f_msgbox1(102 , "PALETTE NO")
	return
end if 

if f_msgbox1(1161 , this.text ) = 1 then 
else
	return
end if 
do
	i++
	
	if dw_1.object.check_yn[i] = 'Y' then 
	else
		continue
	end if 

	dw_1.object.palette_no[i] = sle_palette_no.text
	
loop until i = dw_1.rowcount()

if dw_1.update() < 0 then 
	rollback;
else
	commit;
end if 

cb_retrieve.triggerevent(clicked!)

sle_palette_no.text = ''
end event

type cb_retrieve from commandbutton within w_sal_palette_popup
integer x = 2747
integer y = 264
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

event clicked;DW_1.RETRIEVE( sle_run_no.text+'%' ,sle_lot_no.text + '%' ,  UO_DATESET.TEXT() , UO_DATEEND.TEXT() , GVI_ORGANIZATION_ID )
end event

type sle_palette_no from so_singlelineedit within w_sal_palette_popup
integer x = 55
integer y = 356
integer width = 521
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
textcase textcase = upper!
end type

type st_3 from so_statictext within w_sal_palette_popup
integer x = 55
integer y = 272
integer width = 521
boolean bringtotop = true
long textcolor = 16711680
string text = "Palette No"
end type

type uo_dateset from uo_ymd_calendar within w_sal_palette_popup
event destroy ( )
integer x = 1874
integer y = 352
integer taborder = 60
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type st_6 from so_statictext within w_sal_palette_popup
integer x = 1874
integer y = 272
integer width = 814
integer height = 68
boolean bringtotop = true
string text = "Lot Date"
end type

type uo_dateend from uo_ymd_calendar within w_sal_palette_popup
event destroy ( )
integer x = 2286
integer y = 352
integer taborder = 70
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type cb_2 from so_commandbutton within w_sal_palette_popup
integer x = 581
integer y = 352
integer width = 123
integer height = 92
integer taborder = 60
boolean bringtotop = true
string text = "?"
end type

event clicked;call super::clicked;sle_palette_no.text =  'P'+string(f_t_sysdate(),'yymmdd')+  trim(string(  f_get_sequence('SEQ_PALETTE_NO_SEQ') , '0000'))
end event

type sle_lot_no from so_singlelineedit within w_sal_palette_popup
integer x = 1335
integer y = 356
integer width = 521
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
textcase textcase = upper!
end type

type st_2 from so_statictext within w_sal_palette_popup
integer x = 1335
integer y = 272
integer width = 521
boolean bringtotop = true
string text = "Lot No"
end type

type sle_run_no from so_singlelineedit within w_sal_palette_popup
integer x = 718
integer y = 356
integer width = 603
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
textcase textcase = upper!
end type

type st_1 from so_statictext within w_sal_palette_popup
integer x = 718
integer y = 272
integer width = 603
boolean bringtotop = true
string text = "Run No"
end type

type cb_update from commandbutton within w_sal_palette_popup
integer x = 3415
integer y = 264
integer width = 329
integer height = 156
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Save"
end type

event clicked;if dw_1.update() < 0 then 
	rollback;
else
	commit;
end if 
end event

type gb_1 from so_groupbox within w_sal_palette_popup
integer y = 196
integer width = 2720
integer height = 276
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_sal_palette_popup
integer x = 2725
integer y = 188
integer width = 1413
integer height = 276
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

