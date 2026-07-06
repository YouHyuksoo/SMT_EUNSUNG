HA$PBExportHeader$w_mcn_jig_sample_query_popup.srw
$PBExportComments$$$HEX7$$a8ba78b3d0c5200000b35cd52000$$ENDHEX$$JIG$$HEX2$$40c62000$$ENDHEX$$SAMPLE $$HEX4$$70c88cd61dd3c5c5$$ENDHEX$$
forward
global type w_mcn_jig_sample_query_popup from w_popup_root
end type
type cb_retrieve from so_commandbutton within w_mcn_jig_sample_query_popup
end type
type sle_item_code from so_singlelineedit within w_mcn_jig_sample_query_popup
end type
type st_2 from so_statictext within w_mcn_jig_sample_query_popup
end type
type gb_where_condition from so_groupbox within w_mcn_jig_sample_query_popup
end type
type gb_2 from so_groupbox within w_mcn_jig_sample_query_popup
end type
end forward

global type w_mcn_jig_sample_query_popup from w_popup_root
integer width = 4155
integer height = 2824
string title = "JIG / Sample List Query  Popup"
boolean minbox = true
windowtype windowtype = popup!
cb_retrieve cb_retrieve
sle_item_code sle_item_code
st_2 st_2
gb_where_condition gb_where_condition
gb_2 gb_2
end type
global w_mcn_jig_sample_query_popup w_mcn_jig_sample_query_popup

on w_mcn_jig_sample_query_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.sle_item_code=create sle_item_code
this.st_2=create st_2
this.gb_where_condition=create gb_where_condition
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.sle_item_code
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.gb_where_condition
this.Control[iCurrent+5]=this.gb_2
end on

on w_mcn_jig_sample_query_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.sle_item_code)
destroy(this.st_2)
destroy(this.gb_where_condition)
destroy(this.gb_2)
end on

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
	
end if
end event

event ue_post_open;call super::ue_post_open;
dw_1.settransobject(sqlca)
dw_2.settransobject(sqlca)

sle_item_code.TEXT =MESSAGE.STRINGPARM

CB_RETRIEVE.TRIGGEREVENT(CLICKED!)

SLE_ITEM_CODE.SETFOCUS()
end event

event activate;call super::activate;
IVS_RESIZE_TYPE = 'DEFAULT'
end event

type p_title from w_popup_root`p_title within w_mcn_jig_sample_query_popup
integer x = 14
integer width = 4142
end type

type cb_sort from w_popup_root`cb_sort within w_mcn_jig_sample_query_popup
boolean visible = true
integer x = 3086
integer y = 292
integer width = 288
integer height = 156
integer weight = 400
end type

type cb_close from w_popup_root`cb_close within w_mcn_jig_sample_query_popup
boolean visible = true
integer x = 3753
integer y = 292
integer width = 288
integer height = 156
integer weight = 400
end type

type st_msg from w_popup_root`st_msg within w_mcn_jig_sample_query_popup
boolean visible = true
integer y = 516
integer width = 4142
end type

type dw_1 from w_popup_root`dw_1 within w_mcn_jig_sample_query_popup
boolean visible = true
integer y = 608
integer width = 4142
integer height = 1068
boolean titlebar = true
string title = "Jig List"
string dataobject = "d_mcn_jig_lst_query_popup"
end type

type dw_2 from w_popup_root`dw_2 within w_mcn_jig_sample_query_popup
boolean visible = true
integer y = 1672
integer width = 4133
integer height = 1068
boolean titlebar = true
string title = "Sample List"
string dataobject = "d_mcn_sample_lst_query_popup"
end type

type dw_3 from w_popup_root`dw_3 within w_mcn_jig_sample_query_popup
integer y = 620
end type

type cb_retrieve from so_commandbutton within w_mcn_jig_sample_query_popup
integer x = 3378
integer y = 292
integer width = 366
integer height = 156
integer taborder = 60
boolean bringtotop = true
integer weight = 400
string text = "Retrieve"
end type

event clicked;
DW_1.RETRIEVE(  sle_item_code.TEXT, GVI_ORGANIZATION_ID )
DW_2.RETRIEVE(  sle_item_code.TEXT , GVI_ORGANIZATION_ID )
end event

type sle_item_code from so_singlelineedit within w_mcn_jig_sample_query_popup
integer x = 55
integer y = 360
integer width = 681
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer weight = 700
boolean autohscroll = false
end type

type st_2 from so_statictext within w_mcn_jig_sample_query_popup
integer x = 55
integer y = 288
integer width = 681
integer height = 56
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Item Code"
end type

type gb_where_condition from so_groupbox within w_mcn_jig_sample_query_popup
integer y = 224
integer width = 805
integer height = 272
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_mcn_jig_sample_query_popup
integer x = 3040
integer y = 220
integer width = 1083
integer height = 272
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

