HA$PBExportHeader$w_smt_plan_feeder_compare_popup.srw
$PBExportComments$$$HEX12$$3cd530d1a8bac8b230d1c1b970c88cd61dd3c5c50d000a00$$ENDHEX$$forward
global type w_smt_plan_feeder_compare_popup from w_popup_root
end type
type cb_retrieve from so_commandbutton within w_smt_plan_feeder_compare_popup
end type
type ddlb_line_code from uo_line_code within w_smt_plan_feeder_compare_popup
end type
type st_7 from so_statictext within w_smt_plan_feeder_compare_popup
end type
type ddlb_workstage_code from uo_workstage_code_all within w_smt_plan_feeder_compare_popup
end type
type st_9 from so_statictext within w_smt_plan_feeder_compare_popup
end type
type st_10 from so_statictext within w_smt_plan_feeder_compare_popup
end type
type ddlb_top_bottom from uo_basecode within w_smt_plan_feeder_compare_popup
end type
type st_12 from so_statictext within w_smt_plan_feeder_compare_popup
end type
type ddlb_model_name from uo_set_model_name_dynamic within w_smt_plan_feeder_compare_popup
end type
type sle_model_suffix from so_singlelineedit within w_smt_plan_feeder_compare_popup
end type
type ddlb_smt_model_name from uo_smt_model_name_dynamic within w_smt_plan_feeder_compare_popup
end type
type st_3 from so_statictext within w_smt_plan_feeder_compare_popup
end type
type ddlb_line_code_new from uo_line_code within w_smt_plan_feeder_compare_popup
end type
type ddlb_smt_model_name_new from uo_smt_model_name_dynamic within w_smt_plan_feeder_compare_popup
end type
type sle_1 from so_singlelineedit within w_smt_plan_feeder_compare_popup
end type
type st_4 from so_statictext within w_smt_plan_feeder_compare_popup
end type
type st_5 from so_statictext within w_smt_plan_feeder_compare_popup
end type
type ddlb_top_bottom_new from uo_basecode within w_smt_plan_feeder_compare_popup
end type
type ddlb_feeder_shaft_new from uo_feeder_shaft_dynamic within w_smt_plan_feeder_compare_popup
end type
type st_6 from so_statictext within w_smt_plan_feeder_compare_popup
end type
type ddlb_feeder_shaft from uo_feeder_shaft_dynamic within w_smt_plan_feeder_compare_popup
end type
type st_11 from so_statictext within w_smt_plan_feeder_compare_popup
end type
type ddlb_revision from uo_smt_bom_revision_dynamic within w_smt_plan_feeder_compare_popup
end type
type st_20 from so_statictext within w_smt_plan_feeder_compare_popup
end type
type ddlb_revision_new from uo_smt_bom_revision_dynamic within w_smt_plan_feeder_compare_popup
end type
type st_21 from so_statictext within w_smt_plan_feeder_compare_popup
end type
type gb_2 from so_groupbox within w_smt_plan_feeder_compare_popup
end type
type gb_4 from so_groupbox within w_smt_plan_feeder_compare_popup
end type
type gb_6 from so_groupbox within w_smt_plan_feeder_compare_popup
end type
end forward

global type w_smt_plan_feeder_compare_popup from w_popup_root
integer width = 5682
integer height = 2824
string title = "Feeder Status Popup"
boolean minbox = true
windowtype windowtype = popup!
cb_retrieve cb_retrieve
ddlb_line_code ddlb_line_code
st_7 st_7
ddlb_workstage_code ddlb_workstage_code
st_9 st_9
st_10 st_10
ddlb_top_bottom ddlb_top_bottom
st_12 st_12
ddlb_model_name ddlb_model_name
sle_model_suffix sle_model_suffix
ddlb_smt_model_name ddlb_smt_model_name
st_3 st_3
ddlb_line_code_new ddlb_line_code_new
ddlb_smt_model_name_new ddlb_smt_model_name_new
sle_1 sle_1
st_4 st_4
st_5 st_5
ddlb_top_bottom_new ddlb_top_bottom_new
ddlb_feeder_shaft_new ddlb_feeder_shaft_new
st_6 st_6
ddlb_feeder_shaft ddlb_feeder_shaft
st_11 st_11
ddlb_revision ddlb_revision
st_20 st_20
ddlb_revision_new ddlb_revision_new
st_21 st_21
gb_2 gb_2
gb_4 gb_4
gb_6 gb_6
end type
global w_smt_plan_feeder_compare_popup w_smt_plan_feeder_compare_popup

type variables
String ivs_line_code
String ivs_model_name
String ivs_active

Long  ivl_limit_time
Long  ivl_item_unit_qty
Long  ivl_limit_qty


end variables

on w_smt_plan_feeder_compare_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.ddlb_line_code=create ddlb_line_code
this.st_7=create st_7
this.ddlb_workstage_code=create ddlb_workstage_code
this.st_9=create st_9
this.st_10=create st_10
this.ddlb_top_bottom=create ddlb_top_bottom
this.st_12=create st_12
this.ddlb_model_name=create ddlb_model_name
this.sle_model_suffix=create sle_model_suffix
this.ddlb_smt_model_name=create ddlb_smt_model_name
this.st_3=create st_3
this.ddlb_line_code_new=create ddlb_line_code_new
this.ddlb_smt_model_name_new=create ddlb_smt_model_name_new
this.sle_1=create sle_1
this.st_4=create st_4
this.st_5=create st_5
this.ddlb_top_bottom_new=create ddlb_top_bottom_new
this.ddlb_feeder_shaft_new=create ddlb_feeder_shaft_new
this.st_6=create st_6
this.ddlb_feeder_shaft=create ddlb_feeder_shaft
this.st_11=create st_11
this.ddlb_revision=create ddlb_revision
this.st_20=create st_20
this.ddlb_revision_new=create ddlb_revision_new
this.st_21=create st_21
this.gb_2=create gb_2
this.gb_4=create gb_4
this.gb_6=create gb_6
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.ddlb_line_code
this.Control[iCurrent+3]=this.st_7
this.Control[iCurrent+4]=this.ddlb_workstage_code
this.Control[iCurrent+5]=this.st_9
this.Control[iCurrent+6]=this.st_10
this.Control[iCurrent+7]=this.ddlb_top_bottom
this.Control[iCurrent+8]=this.st_12
this.Control[iCurrent+9]=this.ddlb_model_name
this.Control[iCurrent+10]=this.sle_model_suffix
this.Control[iCurrent+11]=this.ddlb_smt_model_name
this.Control[iCurrent+12]=this.st_3
this.Control[iCurrent+13]=this.ddlb_line_code_new
this.Control[iCurrent+14]=this.ddlb_smt_model_name_new
this.Control[iCurrent+15]=this.sle_1
this.Control[iCurrent+16]=this.st_4
this.Control[iCurrent+17]=this.st_5
this.Control[iCurrent+18]=this.ddlb_top_bottom_new
this.Control[iCurrent+19]=this.ddlb_feeder_shaft_new
this.Control[iCurrent+20]=this.st_6
this.Control[iCurrent+21]=this.ddlb_feeder_shaft
this.Control[iCurrent+22]=this.st_11
this.Control[iCurrent+23]=this.ddlb_revision
this.Control[iCurrent+24]=this.st_20
this.Control[iCurrent+25]=this.ddlb_revision_new
this.Control[iCurrent+26]=this.st_21
this.Control[iCurrent+27]=this.gb_2
this.Control[iCurrent+28]=this.gb_4
this.Control[iCurrent+29]=this.gb_6
end on

on w_smt_plan_feeder_compare_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.ddlb_line_code)
destroy(this.st_7)
destroy(this.ddlb_workstage_code)
destroy(this.st_9)
destroy(this.st_10)
destroy(this.ddlb_top_bottom)
destroy(this.st_12)
destroy(this.ddlb_model_name)
destroy(this.sle_model_suffix)
destroy(this.ddlb_smt_model_name)
destroy(this.st_3)
destroy(this.ddlb_line_code_new)
destroy(this.ddlb_smt_model_name_new)
destroy(this.sle_1)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.ddlb_top_bottom_new)
destroy(this.ddlb_feeder_shaft_new)
destroy(this.st_6)
destroy(this.ddlb_feeder_shaft)
destroy(this.st_11)
destroy(this.ddlb_revision)
destroy(this.st_20)
destroy(this.ddlb_revision_new)
destroy(this.st_21)
destroy(this.gb_2)
destroy(this.gb_4)
destroy(this.gb_6)
end on

event key;call super::key;//if key = keyf1! then 
//   cb_retrieve.triggerevent(clicked!)	
//end if
end event

event ue_post_open;call super::ue_post_open; f_set_column_dddw( dw_1 )
//cb_retrieve.triggerevent(clicked!)	

end event

event activate;call super::activate;IVS_RESIZE_TYPE = 'DEFAULT'
end event

type p_title from w_popup_root`p_title within w_smt_plan_feeder_compare_popup
boolean visible = false
integer x = 5038
integer y = 52
integer width = 448
end type

type cb_sort from w_popup_root`cb_sort within w_smt_plan_feeder_compare_popup
integer x = 5317
integer y = 8
integer width = 288
integer height = 156
end type

type cb_close from w_popup_root`cb_close within w_smt_plan_feeder_compare_popup
boolean visible = true
integer x = 4306
integer y = 184
integer width = 366
integer height = 156
end type

type st_msg from w_popup_root`st_msg within w_smt_plan_feeder_compare_popup
boolean visible = true
integer y = 520
integer width = 5650
long textcolor = 0
end type

type dw_1 from w_popup_root`dw_1 within w_smt_plan_feeder_compare_popup
boolean visible = true
integer y = 620
integer width = 1874
integer height = 2156
boolean titlebar = true
string title = "Issue Return"
string dataobject = "d_smt_feeder_compare_issue_return_lst"
end type

event dw_1::buttonclicked;call super::buttonclicked;string docname , named 
int iret

if dwo.name = 'b_xls' then 
	

			if dw_1.getrow() < 1 then  
				Messagebox("Notify" ,"No Data Found")
				return
			end if
			
			SETPOINTER(HOURGLASS!)		
		iret = GetFileSaveName("Select Excel File ("+dw_1.classname()+")" , docname, named, "xls", "Excel Files (*.xls),*.xls")		
		
			  IF iret =1 THEN 
				uf_save_dw_as_excel( dw_1  , docname )
			end if 
END IF

end event

type dw_2 from w_popup_root`dw_2 within w_smt_plan_feeder_compare_popup
boolean visible = true
integer x = 1888
integer y = 616
integer width = 1874
integer height = 2160
boolean titlebar = true
string title = "Issue"
string dataobject = "d_smt_feeder_compare_issue_lst"
end type

event dw_2::buttonclicked;call super::buttonclicked;string docname , named 
int iret

if dwo.name = 'b_xls' then 
	

			if dw_2.getrow() < 1 then  
				Messagebox("Notify" ,"No Data Found")
				return
			end if
			
			SETPOINTER(HOURGLASS!)		
		iret = GetFileSaveName("Select Excel File ("+dw_2.classname()+")" , docname, named, "xls", "Excel Files (*.xls),*.xls")		
		
			  IF iret =1 THEN 
				uf_save_dw_as_excel( dw_2  , docname )
			end if 
END IF

end event

type dw_3 from w_popup_root`dw_3 within w_smt_plan_feeder_compare_popup
boolean visible = true
integer x = 3781
integer y = 616
integer width = 1874
integer height = 2160
boolean titlebar = true
string title = "Move"
string dataobject = "d_smt_feeder_compare_MOVE_lst"
end type

type cb_retrieve from so_commandbutton within w_smt_plan_feeder_compare_popup
integer x = 3927
integer y = 184
integer width = 366
integer height = 156
integer taborder = 60
boolean bringtotop = true
string text = "Retrieve"
end type

event clicked;if ddlb_line_code.getcode( ) = '%' or ddlb_line_code.getcode( ) = '' or ddlb_line_code.getcode( ) = '*' then
	f_msgbox1(111 , "Line")
	ddlb_line_code.setfocus()
	return 
end if 								

if ddlb_line_code_new.getcode( ) = '%' or ddlb_line_code_new.getcode( ) = '' or ddlb_line_code_new.getcode( ) = '*' then
	f_msgbox1(111 , "Line")
	ddlb_line_code_new.setfocus()
	return 
end if 

if  ddlb_smt_model_name .getcode( ) = '%' or ddlb_smt_model_name.getcode( ) = '' or ddlb_smt_model_name.getcode( ) = '*' then
	f_msgbox1(111 , "Model")
	ddlb_smt_model_name_new.setfocus()
	return 
end if 

if  ddlb_smt_model_name_new .getcode( ) = '%' or ddlb_smt_model_name_new.getcode( ) = '' or ddlb_smt_model_name_new.getcode( ) = '*' then
	f_msgbox1(111 , "Model")
	ddlb_smt_model_name_new.setfocus()
	return 
end if 
//=====================================================================
//
//=====================================================================

if ddlb_feeder_shaft.getcode( ) = '%' or ddlb_feeder_shaft.getcode( ) = '' or ddlb_feeder_shaft.getcode( ) = '*' then
	f_msgbox1(111 , "Feeder Shaft")
	return 
end if 

if ddlb_feeder_shaft_new.getcode( ) = '%' or ddlb_feeder_shaft_new.getcode( ) = '' or ddlb_feeder_shaft_new.getcode( ) = '*' then
	f_msgbox1(111 , "Feeder Shaft")
	return 
end if 
			
if ddlb_revision.getcode( ) = '%' or ddlb_revision.getcode( ) = '' or ddlb_revision.getcode( ) = '*' then
	f_msgbox1(111 , "Revision")
	return 
end if 
	
									
if ddlb_revision_new.getcode( ) = '%' or ddlb_revision_new.getcode( ) = '' or ddlb_revision_new.getcode( ) = '*' then
	f_msgbox1(111 , "Revision New")
	return 
end if 

dw_1.retrieve(   ddlb_line_code.getcode() ,   ddlb_line_code_new.getcode() ,  ddlb_smt_model_name.getcode( ) ,  ddlb_smt_model_name_new.getcode( ) ,  ddlb_top_bottom.getcode( ) ,  ddlb_top_bottom_new.getcode( ) ,   ddlb_feeder_shaft.getcode() , ddlb_feeder_shaft_new.getcode()   ,    ddlb_revision.getcode( )  ,  ddlb_revision_new.getcode( )  , gvi_organization_id  ) 
dw_2.retrieve(   ddlb_line_code.getcode() ,   ddlb_line_code_new.getcode() ,  ddlb_smt_model_name.getcode( ) ,  ddlb_smt_model_name_new.getcode( ) ,  ddlb_top_bottom.getcode( ) ,  ddlb_top_bottom_new.getcode( ) ,   ddlb_feeder_shaft.getcode() , ddlb_feeder_shaft_new.getcode()   ,    ddlb_revision.getcode( )  ,  ddlb_revision_new.getcode( )  , gvi_organization_id  )
dw_3.retrieve(   ddlb_line_code.getcode() ,   ddlb_line_code_new.getcode() ,  ddlb_smt_model_name.getcode( ) ,  ddlb_smt_model_name_new.getcode( ) ,  ddlb_top_bottom.getcode( ) ,  ddlb_top_bottom_new.getcode( ) ,   ddlb_feeder_shaft.getcode() , ddlb_feeder_shaft_new.getcode()   ,    ddlb_revision.getcode( )  ,  ddlb_revision_new.getcode( )  , gvi_organization_id  ) 
end event

type ddlb_line_code from uo_line_code within w_smt_plan_feeder_compare_popup
integer x = 416
integer y = 72
integer width = 576
integer height = 2044
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
long backcolor = 16777215
end type

event modified;call super::modified;string LVS_LINE_CODE , LVS_MODEL_NAME , LVS_PCB_ITEM , LVS_FEEDER_SHAFT
string lvs_topbot , LVS_WORKSTAGE_CODE

LVS_LINE_CODE = this.getcode( )

//========================================
// smt $$HEX13$$f5ac15c854cfdcb47cb9200000ac38c828c6e4b220000d000a00$$ENDHEX$$//========================================
SELECT WORKSTAGE_CODE INTO :LVS_WORKSTAGE_CODE 
	FROM IP_PRODUCT_WORKSTAGE 
	WHERE WORKSTAGE_TYPE = 'S' 
	AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
	
ddlb_feeder_shaft.redraw( ddlb_line_code.getcode( ) ,  '%'  , '%' )
ddlb_workstage_code.setfocus()
ddlb_workstage_code.text = LVS_WORKSTAGE_CODE 

end event

event selectionchanged;call super::selectionchanged;
  ddlb_workstage_code.setfocus()
end event

type st_7 from so_statictext within w_smt_plan_feeder_compare_popup
integer x = 46
integer y = 96
integer width = 361
integer height = 92
boolean bringtotop = true
integer textsize = -10
long textcolor = 0
string text = "Line Code"
alignment alignment = right!
end type

type ddlb_workstage_code from uo_workstage_code_all within w_smt_plan_feeder_compare_popup
integer x = 1010
integer y = 176
integer width = 439
integer height = 1448
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
long backcolor = 16777215
boolean allowedit = true
end type

type st_9 from so_statictext within w_smt_plan_feeder_compare_popup
integer x = 1019
integer y = 80
integer width = 430
integer height = 76
boolean bringtotop = true
long textcolor = 8421504
string text = "Workstage Code"
end type

type st_10 from so_statictext within w_smt_plan_feeder_compare_popup
integer x = 46
integer y = 288
integer width = 361
integer height = 76
boolean bringtotop = true
integer textsize = -10
long textcolor = 0
string text = "Model Name"
alignment alignment = right!
end type

type ddlb_top_bottom from uo_basecode within w_smt_plan_feeder_compare_popup
integer x = 416
integer y = 376
integer width = 571
integer height = 692
integer taborder = 320
boolean bringtotop = true
integer textsize = -10
integer weight = 400
long backcolor = 16777215
integer limit = 10
end type

event constructor;call super::constructor;this.redraw( 'TOP BOTTOM')
end event

event selectionchanged;call super::selectionchanged;//string lvs_topbot
//
//if rb_kitting.checked = true then 
//	ddlb_feeder_shaft.redraw( ddlb_line_code.getcode( ) ,   'N' )
//	sle_our_barcode.setfocus()
//elseif  rb_append.checked = true then 
//	ddlb_feeder_shaft.redraw( ddlb_line_code.getcode( ) ,  'A' )
//	sle_our_barcode.setfocus()
//elseif rb_compare_return.checked = true then 
//	ddlb_feeder_shaft.redraw( ddlb_line_code.getcode( ) ,   '%' )
//	sle_our_barcode.setfocus()
//else
//	ddlb_feeder_shaft.redraw( ddlb_line_code.getcode( ) ,   '%' )
//	sle_our_barcode.setfocus()
//end if
end event

type st_12 from so_statictext within w_smt_plan_feeder_compare_popup
integer x = 46
integer y = 376
integer width = 361
integer height = 92
boolean bringtotop = true
integer textsize = -10
long textcolor = 0
string text = "Top/Bottom"
alignment alignment = right!
end type

type ddlb_model_name from uo_set_model_name_dynamic within w_smt_plan_feeder_compare_popup
integer x = 1010
integer y = 276
integer width = 800
integer height = 1492
integer taborder = 210
boolean bringtotop = true
integer textsize = -10
long backcolor = 16777215
boolean autohscroll = true
end type

event selectionchanged;call super::selectionchanged;
////=============================================================================
//// 
////=============================================================================

end event

event ue_entertotab;call super::ue_entertotab;SEND(HANDLE(THIS),256,9,983041)
//RETURN 1
end event

type sle_model_suffix from so_singlelineedit within w_smt_plan_feeder_compare_popup
integer x = 416
integer y = 280
integer width = 571
integer height = 88
integer taborder = 140
boolean bringtotop = true
long backcolor = 65535
textcase textcase = upper!
end type

event getfocus;call super::getfocus;this.selecttext( 1,100)
end event

event modified;call super::modified;	ddlb_smt_model_name.redraw( this.text)
	ddlb_smt_model_name.setfocus()
end event

type ddlb_smt_model_name from uo_smt_model_name_dynamic within w_smt_plan_feeder_compare_popup
integer x = 1010
integer y = 276
integer width = 800
integer height = 1492
integer taborder = 220
boolean bringtotop = true
integer textsize = -10
long backcolor = 65280
end type

event selectionchanged;call super::selectionchanged;
ddlb_revision.redraw( ddlb_line_code.getcode( ) , this.getcode( ) , ddlb_feeder_shaft.getcode( ) ) 
end event

event ue_entertotab;call super::ue_entertotab;SEND(HANDLE(THIS),256,9,983041)
//RETURN 1
end event

type st_3 from so_statictext within w_smt_plan_feeder_compare_popup
integer x = 1865
integer y = 76
integer width = 448
integer height = 92
boolean bringtotop = true
integer textsize = -10
long textcolor = 0
string text = "Line Code"
alignment alignment = right!
end type

type ddlb_line_code_new from uo_line_code within w_smt_plan_feeder_compare_popup
integer x = 2327
integer y = 68
integer width = 558
integer height = 2044
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
long backcolor = 16777215
end type

event selectionchanged;call super::selectionchanged;//$$HEX5$$70c88cd620000d000a00$$ENDHEX$$ddlb_feeder_shaft_new.redraw( ddlb_line_code_new.getcode( ) ,   '%'  , '%' )
end event

type ddlb_smt_model_name_new from uo_smt_model_name_dynamic within w_smt_plan_feeder_compare_popup
integer x = 2894
integer y = 264
integer width = 754
integer height = 1492
integer taborder = 270
boolean bringtotop = true
integer textsize = -10
long backcolor = 65280
end type

event selectionchanged;call super::selectionchanged;

ddlb_revision_new.redraw( ddlb_line_code_new.getcode( ) , this.getcode( ) , ddlb_feeder_shaft_new.getcode( ) ) 
end event

event ue_entertotab;call super::ue_entertotab;SEND(HANDLE(THIS),256,9,983041)
//RETURN 1
end event

type sle_1 from so_singlelineedit within w_smt_plan_feeder_compare_popup
integer x = 2327
integer y = 260
integer width = 558
integer height = 88
integer taborder = 240
boolean bringtotop = true
long backcolor = 65535
textcase textcase = upper!
end type

event getfocus;call super::getfocus;this.selecttext( 1,100)
end event

event modified;call super::modified;
ddlb_smt_model_name_new.redraw( this.text)
ddlb_smt_model_name_new.setfocus()

end event

type st_4 from so_statictext within w_smt_plan_feeder_compare_popup
integer x = 1865
integer y = 360
integer width = 448
integer height = 92
boolean bringtotop = true
integer textsize = -10
long textcolor = 0
string text = "Top/Bottom"
alignment alignment = right!
end type

type st_5 from so_statictext within w_smt_plan_feeder_compare_popup
integer x = 1865
integer y = 268
integer width = 448
integer height = 76
boolean bringtotop = true
integer textsize = -10
long textcolor = 0
string text = "Model Name"
alignment alignment = right!
end type

type ddlb_top_bottom_new from uo_basecode within w_smt_plan_feeder_compare_popup
integer x = 2327
integer y = 356
integer width = 558
integer height = 692
integer taborder = 330
boolean bringtotop = true
integer textsize = -10
integer weight = 400
long backcolor = 16777215
integer limit = 10
end type

event constructor;call super::constructor;this.redraw( 'TOP BOTTOM')
end event

type ddlb_feeder_shaft_new from uo_feeder_shaft_dynamic within w_smt_plan_feeder_compare_popup
integer x = 2327
integer y = 172
integer width = 558
integer height = 904
integer taborder = 90
boolean bringtotop = true
integer textsize = -10
end type

event selectionchanged;call super::selectionchanged;string LVS_MODEL_NAME , Lvs_feeder_shaft

Lvs_feeder_shaft = this.getcode( )
LVS_MODEL_NAME = ddlb_smt_model_name_new.getcode( )

end event

type st_6 from so_statictext within w_smt_plan_feeder_compare_popup
integer x = 1865
integer y = 188
integer width = 448
integer height = 68
boolean bringtotop = true
integer textsize = -10
long textcolor = 0
string text = "Shaft"
alignment alignment = right!
end type

type ddlb_feeder_shaft from uo_feeder_shaft_dynamic within w_smt_plan_feeder_compare_popup
integer x = 416
integer y = 176
integer width = 571
integer height = 904
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
end type

event selectionchanged;call super::selectionchanged;string lvs_topbot , LVS_PCB_ITEM  , LVS_MODEL_NAME , LVS_LINE_CODE , Lvs_feeder_shaft

LVS_LINE_CODE = DDLB_LINE_CODE.getcode( )
Lvs_feeder_shaft = this.getcode( )

SELECT DISTINCT MODEL_NAME , PCB_ITEM
   INTO :LVS_MODEL_NAME , :LVS_PCB_ITEM 
  FROM IB_SMT_FEEDER_SHAFT
WHERE LINE_CODE = :LVS_LINE_CODE 
	AND FEEDER_SHAFT  = :Lvs_feeder_shaft 
	AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;

IF F_SQL_CHECK() < 0 THEN
	RETURN 
END IF 	

ddlb_revision.redraw( ddlb_line_code.getcode( ) , LVS_MODEL_NAME , Lvs_feeder_shaft ) 

sle_model_suffix.text = lvs_model_name
sle_model_suffix.triggerevent( modified! )

ddlb_top_bottom.selectitem( LVS_PCB_ITEM ,1)
ddlb_top_bottom_new.selectitem( LVS_PCB_ITEM ,1)
ddlb_top_bottom.triggerevent( selectionchanged! )

end event

type st_11 from so_statictext within w_smt_plan_feeder_compare_popup
integer x = 46
integer y = 196
integer width = 361
integer height = 68
boolean bringtotop = true
integer textsize = -10
long textcolor = 0
string text = "Shaft"
alignment alignment = right!
end type

type ddlb_revision from uo_smt_bom_revision_dynamic within w_smt_plan_feeder_compare_popup
integer x = 1454
integer y = 376
integer width = 352
integer taborder = 330
boolean bringtotop = true
integer textsize = -10
end type

type st_20 from so_statictext within w_smt_plan_feeder_compare_popup
integer x = 1024
integer y = 388
integer width = 160
integer height = 76
boolean bringtotop = true
integer textsize = -10
long textcolor = 8421504
string text = "Rev."
alignment alignment = right!
end type

type ddlb_revision_new from uo_smt_bom_revision_dynamic within w_smt_plan_feeder_compare_popup
integer x = 3186
integer y = 372
integer width = 457
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
end type

type st_21 from so_statictext within w_smt_plan_feeder_compare_popup
integer x = 2994
integer y = 380
integer width = 160
integer height = 76
boolean bringtotop = true
integer textsize = -10
long textcolor = 8421504
string text = "Rev."
alignment alignment = right!
end type

type gb_2 from so_groupbox within w_smt_plan_feeder_compare_popup
boolean visible = false
integer x = 4846
integer width = 795
integer height = 272
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_4 from so_groupbox within w_smt_plan_feeder_compare_popup
integer x = 32
integer y = 8
integer width = 1810
integer height = 484
integer taborder = 20
integer weight = 700
long textcolor = 0
string text = "Scan Issue"
end type

type gb_6 from so_groupbox within w_smt_plan_feeder_compare_popup
integer x = 1847
integer width = 1829
integer height = 488
integer taborder = 50
integer weight = 700
long textcolor = 0
string text = "New Model"
end type

