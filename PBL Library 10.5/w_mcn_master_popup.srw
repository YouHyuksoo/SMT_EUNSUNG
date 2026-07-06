HA$PBExportHeader$w_mcn_master_popup.srw
forward
global type w_mcn_master_popup from w_popup_root
end type
type gb_3 from so_groupbox within w_mcn_master_popup
end type
type gb_2 from so_groupbox within w_mcn_master_popup
end type
type cb_retrieve from so_commandbutton within w_mcn_master_popup
end type
type cb_select from so_commandbutton within w_mcn_master_popup
end type
type st_1 from so_statictext within w_mcn_master_popup
end type
type sle_machine_code from so_singlelineedit within w_mcn_master_popup
end type
type sle_machine_name from so_singlelineedit within w_mcn_master_popup
end type
type st_2 from so_statictext within w_mcn_master_popup
end type
type ddlb_machine_type from uo_basecode within w_mcn_master_popup
end type
type st_3 from so_statictext within w_mcn_master_popup
end type
end forward

shared variables

end variables

global type w_mcn_master_popup from w_popup_root
integer width = 3355
integer height = 2280
string title = "Machine Master Popup"
gb_3 gb_3
gb_2 gb_2
cb_retrieve cb_retrieve
cb_select cb_select
st_1 st_1
sle_machine_code sle_machine_code
sle_machine_name sle_machine_name
st_2 st_2
ddlb_machine_type ddlb_machine_type
st_3 st_3
end type
global w_mcn_master_popup w_mcn_master_popup

on w_mcn_master_popup.create
int iCurrent
call super::create
this.gb_3=create gb_3
this.gb_2=create gb_2
this.cb_retrieve=create cb_retrieve
this.cb_select=create cb_select
this.st_1=create st_1
this.sle_machine_code=create sle_machine_code
this.sle_machine_name=create sle_machine_name
this.st_2=create st_2
this.ddlb_machine_type=create ddlb_machine_type
this.st_3=create st_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_3
this.Control[iCurrent+2]=this.gb_2
this.Control[iCurrent+3]=this.cb_retrieve
this.Control[iCurrent+4]=this.cb_select
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.sle_machine_code
this.Control[iCurrent+7]=this.sle_machine_name
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.ddlb_machine_type
this.Control[iCurrent+10]=this.st_3
end on

on w_mcn_master_popup.destroy
call super::destroy
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.cb_retrieve)
destroy(this.cb_select)
destroy(this.st_1)
destroy(this.sle_machine_code)
destroy(this.sle_machine_name)
destroy(this.st_2)
destroy(this.ddlb_machine_type)
destroy(this.st_3)
end on

event open;call super::open;//===============================
//
//===============================
dw_1.settransobject(sqlca)
cb_retrieve.triggerevent(CLICKED!)


selected_data_window = dw_2
end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
end if
end event

event activate;call super::activate;//===============================
//
//===============================
IVS_RESIZE_TYPE = 'DEFAULT'
IVS_MOUSEMOVE_YN = 'N'

end event

type p_title from w_popup_root`p_title within w_mcn_master_popup
integer width = 3337
end type

type cb_sort from w_popup_root`cb_sort within w_mcn_master_popup
boolean visible = true
integer x = 2190
integer y = 308
integer height = 160
end type

type cb_close from w_popup_root`cb_close within w_mcn_master_popup
boolean visible = true
integer x = 3035
integer y = 308
integer height = 160
end type

event cb_close::clicked;call super::clicked;Gst_return.gvb_return = FALSE
end event

type st_msg from w_popup_root`st_msg within w_mcn_master_popup
boolean visible = true
integer y = 544
integer width = 3337
end type

type dw_1 from w_popup_root`dw_1 within w_mcn_master_popup
boolean visible = true
integer y = 644
integer width = 3337
integer height = 1552
boolean titlebar = true
string title = "Machine List"
string dataobject = "d_mcn_machine_popup"
boolean maxbox = true
end type

event dw_1::doubleclicked;call super::doubleclicked;IF ROW = 0  THEN 
	RETURN -1
END IF
cb_select.triggerevent(clicked!)
end event

type dw_2 from w_popup_root`dw_2 within w_mcn_master_popup
boolean visible = true
integer y = 644
integer width = 503
integer height = 396
boolean titlebar = true
boolean maxbox = true
end type

type dw_3 from w_popup_root`dw_3 within w_mcn_master_popup
boolean visible = true
integer y = 644
integer width = 503
integer height = 396
boolean titlebar = true
boolean maxbox = true
end type

type gb_3 from so_groupbox within w_mcn_master_popup
integer x = 2149
integer y = 200
integer width = 1189
integer height = 328
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_2 from so_groupbox within w_mcn_master_popup
integer x = 5
integer y = 204
integer width = 1733
integer height = 328
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type cb_retrieve from so_commandbutton within w_mcn_master_popup
integer x = 2464
integer y = 308
integer width = 274
integer height = 160
integer taborder = 70
boolean bringtotop = true
string text = "Retrieve"
end type

event clicked;DW_1.RETRIEVE(   sle_machine_code.text+'%' ,  ddlb_machine_type.getcode()+'%' , GVI_ORGANIZATION_ID )
dw_2.retrieve( sle_machine_code.text+'%' , gvi_organization_id)
end event

type cb_select from so_commandbutton within w_mcn_master_popup
integer x = 2734
integer y = 308
integer width = 274
integer height = 160
integer taborder = 80
boolean bringtotop = true
string text = "Select"
boolean default = true
end type

event clicked;if dw_1.getrow() < 1 then 
	gst_return.gvb_return = false
	return -1 
end if 

gst_return.gvb_return = true 
message.stringparm = dw_1.object.machine_code[dw_1.getrow()]
Gst_return.gvs_return[1] = dw_1.object.machine_name[dw_1.getrow()]
//Gst_return.gvs_return[2] = dw_1.object.machine_barcode[dw_1.getrow()]
 
closewithreturn (parent , message.stringparm )



end event

type st_1 from so_statictext within w_mcn_master_popup
integer x = 27
integer y = 308
integer width = 526
boolean bringtotop = true
integer weight = 700
string text = "Machine Code"
end type

type sle_machine_code from so_singlelineedit within w_mcn_master_popup
integer x = 27
integer y = 388
integer width = 526
integer taborder = 30
boolean bringtotop = true
end type

type sle_machine_name from so_singlelineedit within w_mcn_master_popup
integer x = 558
integer y = 388
integer width = 603
integer taborder = 40
boolean bringtotop = true
end type

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

SELECTED_DATA_WINDOW.SETFILTER('')
SELECTED_DATA_WINDOW.FILTER()

LVS_COLUMN = 'MACHINE_NAME'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    SELECTED_DATA_WINDOW.SETFILTER('')
    SELECTED_DATA_WINDOW.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

SELECTED_DATA_WINDOW.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
SELECTED_DATA_WINDOW.FILTER()
F_MSG_MDI_HELP( STRING( SELECTED_DATA_WINDOW.ROWCOUNT() ) + " Found" )
end event

type st_2 from so_statictext within w_mcn_master_popup
integer x = 558
integer y = 308
integer width = 608
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Machine Name"
end type

type ddlb_machine_type from uo_basecode within w_mcn_master_popup
integer x = 1166
integer y = 388
integer width = 544
integer taborder = 50
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'MACHINE TYPE')
end event

event selectionchanged;call super::selectionchanged;cb_retrieve.triggerevent( clicked! )
end event

type st_3 from so_statictext within w_mcn_master_popup
integer x = 1166
integer y = 308
integer width = 544
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Machine Type"
end type

