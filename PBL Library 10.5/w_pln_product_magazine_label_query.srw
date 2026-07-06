HA$PBExportHeader$w_pln_product_magazine_label_query.srw
$PBExportComments$$$HEX17$$b9c278c7d0c658c7a8ba78b3d0c5200000b35cd52000b9d231c144c7200000adacb9$$ENDHEX$$
forward
global type w_pln_product_magazine_label_query from w_main_root
end type
type st_mrm_no from so_statictext within w_pln_product_magazine_label_query
end type
type sle_model_name from so_singlelineedit within w_pln_product_magazine_label_query
end type
type sle_magazine_label_no from so_singlelineedit within w_pln_product_magazine_label_query
end type
type st_1 from so_statictext within w_pln_product_magazine_label_query
end type
type st_10 from so_statictext within w_pln_product_magazine_label_query
end type
type st_11 from so_statictext within w_pln_product_magazine_label_query
end type
type ddlb_workstage_code from uo_workstage_code_all within w_pln_product_magazine_label_query
end type
type st_2 from so_statictext within w_pln_product_magazine_label_query
end type
type em_1 from so_editmask within w_pln_product_magazine_label_query
end type
type em_2 from so_editmask within w_pln_product_magazine_label_query
end type
type ddlb_line_code from uo_line_code_dd within w_pln_product_magazine_label_query
end type
type sle_run_no from so_singlelineedit within w_pln_product_magazine_label_query
end type
type st_8 from so_statictext within w_pln_product_magazine_label_query
end type
type rb_history from so_radiobutton within w_pln_product_magazine_label_query
end type
type rb_summary from so_radiobutton within w_pln_product_magazine_label_query
end type
type rb_matrix from so_radiobutton within w_pln_product_magazine_label_query
end type
type gb_5 from so_groupbox within w_pln_product_magazine_label_query
end type
type gb_4 from so_groupbox within w_pln_product_magazine_label_query
end type
end forward

global type w_pln_product_magazine_label_query from w_main_root
integer width = 5417
integer height = 3332
string title = "Magazine Label History Query"
string icon = "Form!"
string ivs_dw_2_selected_row_yn = "Y"
st_mrm_no st_mrm_no
sle_model_name sle_model_name
sle_magazine_label_no sle_magazine_label_no
st_1 st_1
st_10 st_10
st_11 st_11
ddlb_workstage_code ddlb_workstage_code
st_2 st_2
em_1 em_1
em_2 em_2
ddlb_line_code ddlb_line_code
sle_run_no sle_run_no
st_8 st_8
rb_history rb_history
rb_summary rb_summary
rb_matrix rb_matrix
gb_5 gb_5
gb_4 gb_4
end type
global w_pln_product_magazine_label_query w_pln_product_magazine_label_query

type variables
string IVS_LINE_CODE, IVS_WORKSTAGE_CODE , IVS_RUN_NO , IVS_MASTER_MODEL_NAME  , IVS_PCB_ITEM , IVS_MAGAZINE_LABEL_NO , IVS_MAGAZINE_SET_NO
end variables

on w_pln_product_magazine_label_query.create
int iCurrent
call super::create
this.st_mrm_no=create st_mrm_no
this.sle_model_name=create sle_model_name
this.sle_magazine_label_no=create sle_magazine_label_no
this.st_1=create st_1
this.st_10=create st_10
this.st_11=create st_11
this.ddlb_workstage_code=create ddlb_workstage_code
this.st_2=create st_2
this.em_1=create em_1
this.em_2=create em_2
this.ddlb_line_code=create ddlb_line_code
this.sle_run_no=create sle_run_no
this.st_8=create st_8
this.rb_history=create rb_history
this.rb_summary=create rb_summary
this.rb_matrix=create rb_matrix
this.gb_5=create gb_5
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_mrm_no
this.Control[iCurrent+2]=this.sle_model_name
this.Control[iCurrent+3]=this.sle_magazine_label_no
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.st_10
this.Control[iCurrent+6]=this.st_11
this.Control[iCurrent+7]=this.ddlb_workstage_code
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.em_1
this.Control[iCurrent+10]=this.em_2
this.Control[iCurrent+11]=this.ddlb_line_code
this.Control[iCurrent+12]=this.sle_run_no
this.Control[iCurrent+13]=this.st_8
this.Control[iCurrent+14]=this.rb_history
this.Control[iCurrent+15]=this.rb_summary
this.Control[iCurrent+16]=this.rb_matrix
this.Control[iCurrent+17]=this.gb_5
this.Control[iCurrent+18]=this.gb_4
end on

on w_pln_product_magazine_label_query.destroy
call super::destroy
destroy(this.st_mrm_no)
destroy(this.sle_model_name)
destroy(this.sle_magazine_label_no)
destroy(this.st_1)
destroy(this.st_10)
destroy(this.st_11)
destroy(this.ddlb_workstage_code)
destroy(this.st_2)
destroy(this.em_1)
destroy(this.em_2)
destroy(this.ddlb_line_code)
destroy(this.sle_run_no)
destroy(this.st_8)
destroy(this.rb_history)
destroy(this.rb_summary)
destroy(this.rb_matrix)
destroy(this.gb_5)
destroy(this.gb_4)
end on

event activate;call super::activate;/***************************************
* Window Default Property 
****************************************/
Gst_set.window_id            = this.classname() 
Gst_set.author                  = "JiSheng"
Gst_set.creation_date      = '20051101'
Gst_set.last_modify_date = '20051101'
Gst_set.Report_window    = False  // Report Window  True / Flase

/*****************************************
* Data Window Property
******************************************/
Ivs_resize_type                      = 'NORMAL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default

/****************************************
*  Menu Property
*****************************************
* ADMIN  ( All Control )
* MANAGE ( Manager )
* GUEST  ( Only Query )
* QUERY  ( Only Query  )
* DATA_CONTROL  ( Insert Delete Update )
* REPORT ( Report )
****************************************/
F_MENU_CONTROL('DATA_CONTROL' , TRUE)  // All Data Control




end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

event ue_data_control;call super::ue_data_control;Long ROW
STRING LVS_SETYN
STRING lvsa_transfer_type[]

CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
	
				if rb_history.checked = true then 
						dw_1.reset()
						dw_1.RETRIEVE( ddlb_line_code.getcode()+'%' , ddlb_workstage_code.getcode()+'%' ,  sle_model_name.text+'%' , sle_magazine_label_no.text+'%' ,   em_1.text , em_2.text ,   sle_run_no.text+'%' ,  GVI_ORGANIZATION_ID )
						dw_1.SETFOCUS()		
				elseif rb_summary.checked = true then 
						dw_2.reset()
						dw_2.RETRIEVE( ddlb_line_code.getcode()+'%' , ddlb_workstage_code.getcode()+'%' ,  sle_model_name.text+'%' , sle_magazine_label_no.text+'%' ,   em_1.text , em_2.text ,   sle_run_no.text+'%' ,  GVI_ORGANIZATION_ID )
						dw_2.SETFOCUS()								
				else
						dw_3.reset()
						dw_3.RETRIEVE( ddlb_line_code.getcode()+'%' , ddlb_workstage_code.getcode()+'%' ,  sle_model_name.text+'%' , sle_magazine_label_no.text+'%' ,   em_1.text , em_2.text ,   sle_run_no.text+'%' ,  GVI_ORGANIZATION_ID )
						dw_3.SETFOCUS()					
				end if 
		
	CASE 'UPDATE'
	
	CASE ELSE
END CHOOSE


end event

event resize;call super::resize;DW_5.WIdth = DW_1.WIdth
end event

type dw_5 from w_main_root`dw_5 within w_pln_product_magazine_label_query
integer y = 368
integer width = 2610
integer height = 1164
integer taborder = 0
boolean titlebar = true
end type

type dw_4 from w_main_root`dw_4 within w_pln_product_magazine_label_query
integer y = 368
integer width = 2610
integer height = 1164
integer taborder = 0
boolean titlebar = true
end type

type dw_3 from w_main_root`dw_3 within w_pln_product_magazine_label_query
integer y = 368
integer width = 2610
integer height = 1164
integer taborder = 0
boolean titlebar = true
string dataobject = "d_pln_product_run_card_io_matrix"
end type

type dw_2 from w_main_root`dw_2 within w_pln_product_magazine_label_query
integer y = 368
integer width = 2610
integer height = 1164
integer taborder = 0
boolean titlebar = true
string title = "Summary"
string dataobject = "d_pln_product_run_card_io_sum_lst"
boolean border = false
borderstyle borderstyle = stylebox!
end type

type dw_1 from w_main_root`dw_1 within w_pln_product_magazine_label_query
integer y = 368
integer width = 2610
integer height = 1164
integer taborder = 0
boolean titlebar = true
string title = "List"
string dataobject = "d_pln_product_run_card_io_lst"
boolean border = false
borderstyle borderstyle = stylebox!
end type

type uo_tabpages from w_main_root`uo_tabpages within w_pln_product_magazine_label_query
integer taborder = 0
end type

type st_mrm_no from so_statictext within w_pln_product_magazine_label_query
integer x = 1989
integer y = 84
integer width = 526
integer height = 68
boolean bringtotop = true
string text = "Model Name"
end type

type sle_model_name from so_singlelineedit within w_pln_product_magazine_label_query
integer x = 1993
integer y = 176
integer width = 526
integer height = 88
boolean bringtotop = true
end type

type sle_magazine_label_no from so_singlelineedit within w_pln_product_magazine_label_query
integer x = 2523
integer y = 176
integer width = 558
integer height = 88
boolean bringtotop = true
end type

type st_1 from so_statictext within w_pln_product_magazine_label_query
integer x = 2523
integer y = 92
integer width = 558
integer height = 68
boolean bringtotop = true
string text = "Lot No"
end type

type st_10 from so_statictext within w_pln_product_magazine_label_query
integer x = 3666
integer y = 92
integer width = 1179
integer height = 68
boolean bringtotop = true
string text = "Date"
end type

type st_11 from so_statictext within w_pln_product_magazine_label_query
integer x = 768
integer y = 92
integer width = 567
integer height = 68
boolean bringtotop = true
string text = "Line Code"
end type

type ddlb_workstage_code from uo_workstage_code_all within w_pln_product_magazine_label_query
integer x = 1353
integer y = 176
integer width = 635
integer height = 1616
boolean bringtotop = true
end type

event constructor;call super::constructor;IVS_WORKSTAGE_CODE = Profilestring("WORKENV.INI","WORKSTAGE","MAGAZINE","")
THIS.SELECtitem(IVS_WORKSTAGE_CODE )
end event

event selectionchanged;call super::selectionchanged;IVS_WORkstage_code = THIS.GETCODE()
f_jsSetProfileString ("WORKENV.INI", "WORKSTAGE", "MAGAZINE", THIS.GETCODE() )
end event

type st_2 from so_statictext within w_pln_product_magazine_label_query
integer x = 1358
integer y = 92
integer width = 635
integer height = 68
boolean bringtotop = true
string text = "Workstage Code"
end type

type em_1 from so_editmask within w_pln_product_magazine_label_query
integer x = 3653
integer y = 180
integer width = 594
integer taborder = 30
boolean bringtotop = true
integer weight = 400
string text = ""
alignment alignment = left!
maskdatatype maskdatatype = datetimemask!
string mask = "yyyy/mm/dd hh:mm:ss"
boolean dropdowncalendar = true
end type

event constructor;call super::constructor;this.text =string( f_sysdate())
end event

type em_2 from so_editmask within w_pln_product_magazine_label_query
integer x = 4256
integer y = 180
integer width = 594
integer taborder = 40
boolean bringtotop = true
integer weight = 400
string text = ""
alignment alignment = left!
maskdatatype maskdatatype = datetimemask!
string mask = "yyyy/mm/dd hh:mm:ss"
boolean dropdowncalendar = true
end type

event constructor;call super::constructor;this.text =string( f_sysdate())
end event

type ddlb_line_code from uo_line_code_dd within w_pln_product_magazine_label_query
integer x = 777
integer y = 176
integer width = 571
integer height = 828
integer taborder = 20
boolean bringtotop = true
end type

event constructor;call super::constructor;ivs_line_code = Profilestring("WORKENV.INI","LINE","MAGAZINE","")

THIS.SELECtitem(IVS_LINE_CODE )


end event

event selectionchanged;call super::selectionchanged;IVS_LINE_CODE = THIS.GETCODE()

f_jsSetProfileString ("WORKENV.INI", "LINE", "MAGAZINE", THIS.GETCODE() )

end event

type sle_run_no from so_singlelineedit within w_pln_product_magazine_label_query
integer x = 3090
integer y = 176
integer width = 558
integer height = 88
integer taborder = 30
boolean bringtotop = true
end type

type st_8 from so_statictext within w_pln_product_magazine_label_query
integer x = 3090
integer y = 92
integer width = 558
integer height = 68
boolean bringtotop = true
string text = "Run No"
end type

type rb_history from so_radiobutton within w_pln_product_magazine_label_query
integer x = 46
integer y = 64
boolean bringtotop = true
string text = "Magazine History"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1

end event

type rb_summary from so_radiobutton within w_pln_product_magazine_label_query
integer x = 46
integer y = 152
boolean bringtotop = true
string text = "Magazine Summary"
end type

event clicked;call super::clicked;dw_2.bringtotop = true 
selected_data_window = dw_2
end event

type rb_matrix from so_radiobutton within w_pln_product_magazine_label_query
integer x = 46
integer y = 244
boolean bringtotop = true
string text = "Magazine Matrix"
end type

event clicked;call super::clicked;dw_3.bringtotop = true 
selected_data_window = dw_3
end event

type gb_5 from so_groupbox within w_pln_product_magazine_label_query
integer x = 704
integer width = 4178
integer height = 360
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_4 from so_groupbox within w_pln_product_magazine_label_query
integer x = 9
integer y = 8
integer width = 667
integer height = 348
integer taborder = 10
end type

