HA$PBExportHeader$w_department_popup.srw
$PBExportComments$$$HEX7$$80bd1cc1c8b9a4c230d11dd3c5c5$$ENDHEX$$
forward
global type w_department_popup from w_popup_root
end type
type cb_retrieve from so_commandbutton within w_department_popup
end type
type cb_select from so_commandbutton within w_department_popup
end type
type ddlb_dept_code from uo_department_code within w_department_popup
end type
type st_11 from so_statictext within w_department_popup
end type
type sle_code_mean_eng from so_singlelineedit within w_department_popup
end type
type st_3 from so_statictext within w_department_popup
end type
type gb_2 from so_groupbox within w_department_popup
end type
type gb_1 from so_groupbox within w_department_popup
end type
end forward

global type w_department_popup from w_popup_root
integer width = 4087
integer height = 2460
string title = "Department Popup"
cb_retrieve cb_retrieve
cb_select cb_select
ddlb_dept_code ddlb_dept_code
st_11 st_11
sle_code_mean_eng sle_code_mean_eng
st_3 st_3
gb_2 gb_2
gb_1 gb_1
end type
global w_department_popup w_department_popup

on w_department_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.cb_select=create cb_select
this.ddlb_dept_code=create ddlb_dept_code
this.st_11=create st_11
this.sle_code_mean_eng=create sle_code_mean_eng
this.st_3=create st_3
this.gb_2=create gb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.cb_select
this.Control[iCurrent+3]=this.ddlb_dept_code
this.Control[iCurrent+4]=this.st_11
this.Control[iCurrent+5]=this.sle_code_mean_eng
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.gb_2
this.Control[iCurrent+8]=this.gb_1
end on

on w_department_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.cb_select)
destroy(this.ddlb_dept_code)
destroy(this.st_11)
destroy(this.sle_code_mean_eng)
destroy(this.st_3)
destroy(this.gb_2)
destroy(this.gb_1)
end on

event open;call super::open;dw_1.settransobject(sqlca)
CB_RETRIEVE.TRIGGEREVENT(CLICKED!)


end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
	
end if
end event

type p_title from w_popup_root`p_title within w_department_popup
integer width = 4069
end type

type cb_sort from w_popup_root`cb_sort within w_department_popup
boolean visible = true
integer x = 2848
integer y = 356
end type

type cb_close from w_popup_root`cb_close within w_department_popup
boolean visible = true
integer x = 3685
integer y = 356
end type

event cb_close::clicked;call super::clicked;Gst_return.gvb_return = false
end event

type st_msg from w_popup_root`st_msg within w_department_popup
boolean visible = true
integer y = 572
integer width = 4069
end type

type dw_1 from w_popup_root`dw_1 within w_department_popup
boolean visible = true
integer y = 676
integer width = 4069
integer height = 1700
string dataobject = "d_dept_popup"
end type

event dw_1::doubleclicked;call super::doubleclicked;CB_SELECT.TRIGGEREVENT(CLICKED!)
end event

type dw_2 from w_popup_root`dw_2 within w_department_popup
boolean visible = true
integer y = 676
end type

type dw_3 from w_popup_root`dw_3 within w_department_popup
integer y = 684
end type

type cb_retrieve from so_commandbutton within w_department_popup
integer x = 3127
integer y = 356
integer width = 274
integer height = 100
integer taborder = 70
boolean bringtotop = true
string text = "Retrieve"
end type

event clicked;DW_1.RETRIEVE(ddlb_dept_code.GETCODE()+'%' , GVS_LANGUAGE , GVI_ORGANIZATION_ID)
end event

type cb_select from so_commandbutton within w_department_popup
integer x = 3406
integer y = 356
integer width = 274
integer height = 100
integer taborder = 80
boolean bringtotop = true
string text = "Select"
boolean default = true
end type

event clicked;IF DW_1.GETROW() < 1 THEN RETURN 
Gst_return.gvb_return = true
MESSAGE.STRINGPARM = DW_1.GETITEMSTRING( DW_1.GETROW() , 'department_code')

Gst_return.gvs_return[1] = DW_1.GETITEMSTRING( DW_1.GETROW() , 'department_name')

CLOSEWITHRETURN(PARENT , MESSAGE.STRINGPARM )

end event

type ddlb_dept_code from uo_department_code within w_department_popup
integer x = 64
integer y = 388
integer taborder = 90
boolean bringtotop = true
end type

type st_11 from so_statictext within w_department_popup
integer x = 64
integer y = 324
integer width = 608
integer height = 56
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Department Code"
end type

type sle_code_mean_eng from so_singlelineedit within w_department_popup
integer x = 681
integer y = 392
integer width = 581
integer taborder = 20
boolean bringtotop = true
textcase textcase = upper!
end type

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

LVS_COLUMN = "DEPARTMENT_NAME"

IF ISNULL(LVS_COLUMN) OR LEN(LVS_COLUMN) = 0 THEN RETURN 

IVD_SELECTED_DATA_WINDOW.SETFILTER('')
IVD_SELECTED_DATA_WINDOW.FILTER()

IF THIS.TEXT = '' THEN 
	IVD_SELECTED_DATA_WINDOW.SETFILTER('')
	IVD_SELECTED_DATA_WINDOW.FILTER()
	RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

IVD_SELECTED_DATA_WINDOW.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
IVD_SELECTED_DATA_WINDOW.FILTER()
F_MSG_MDI_HELP( STRING( IVD_SELECTED_DATA_WINDOW.ROWCOUNT() ) + " Found")
end event

type st_3 from so_statictext within w_department_popup
integer x = 681
integer y = 320
integer width = 581
integer height = 52
boolean bringtotop = true
integer weight = 700
string text = "Dept Name"
end type

type gb_2 from so_groupbox within w_department_popup
integer x = 18
integer y = 228
integer width = 1312
integer height = 336
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_1 from so_groupbox within w_department_popup
integer x = 2702
integer y = 220
integer width = 1367
integer height = 336
integer taborder = 40
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

