HA$PBExportHeader$w_column_explanation.srw
$PBExportComments$Column Explanation Help Popup
forward
global type w_column_explanation from w_popup_root
end type
type cb_extract from so_commandbutton within w_column_explanation
end type
type st_1 from so_statictext within w_column_explanation
end type
type sle_window_name from so_singlelineedit within w_column_explanation
end type
type sle_datawindow from so_singlelineedit within w_column_explanation
end type
type st_2 from so_statictext within w_column_explanation
end type
type cb_1 from so_commandbutton within w_column_explanation
end type
type gb_1 from so_groupbox within w_column_explanation
end type
type gb_2 from so_groupbox within w_column_explanation
end type
end forward

global type w_column_explanation from w_popup_root
integer width = 3214
integer height = 2096
cb_extract cb_extract
st_1 st_1
sle_window_name sle_window_name
sle_datawindow sle_datawindow
st_2 st_2
cb_1 cb_1
gb_1 gb_1
gb_2 gb_2
end type
global w_column_explanation w_column_explanation

type variables
DATAWINDOW ARG_DW
STRING IVS_WINDOW , IVS_DATAWINDOW
end variables

on w_column_explanation.create
int iCurrent
call super::create
this.cb_extract=create cb_extract
this.st_1=create st_1
this.sle_window_name=create sle_window_name
this.sle_datawindow=create sle_datawindow
this.st_2=create st_2
this.cb_1=create cb_1
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_extract
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.sle_window_name
this.Control[iCurrent+4]=this.sle_datawindow
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.gb_1
this.Control[iCurrent+8]=this.gb_2
end on

on w_column_explanation.destroy
call super::destroy
destroy(this.cb_extract)
destroy(this.st_1)
destroy(this.sle_window_name)
destroy(this.sle_datawindow)
destroy(this.st_2)
destroy(this.cb_1)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;call super::open;ARG_DW = MESSAGE.POWEROBJECTPARM
IVS_WINDOW         =  gst_return.gvs_return[1]
IVS_DATAWINDOW = gst_return.gvs_return[2]
SLE_WINDOW_NAME.TEXT= gst_return.gvs_return[1]
SLE_DATAWINDOW.TEXT= gst_return.gvs_return[2]
CB_EXTRACT.TRIGGEREVENT(CLICKED!)

end event

type p_title from w_popup_root`p_title within w_column_explanation
integer width = 3200
end type

type cb_sort from w_popup_root`cb_sort within w_column_explanation
boolean visible = true
integer x = 2386
integer y = 332
integer width = 352
end type

type cb_close from w_popup_root`cb_close within w_column_explanation
boolean visible = true
integer x = 2734
integer y = 332
integer width = 352
end type

type st_msg from w_popup_root`st_msg within w_column_explanation
integer y = 532
end type

type dw_1 from w_popup_root`dw_1 within w_column_explanation
boolean visible = true
integer y = 628
integer width = 3200
integer height = 1380
boolean titlebar = true
string title = "Column Explanation"
string dataobject = "de_column_explanation_popup"
end type

type dw_2 from w_popup_root`dw_2 within w_column_explanation
integer y = 688
end type

type dw_3 from w_popup_root`dw_3 within w_column_explanation
integer y = 796
end type

type cb_extract from so_commandbutton within w_column_explanation
integer x = 1691
integer y = 332
integer width = 352
integer height = 100
integer taborder = 30
boolean bringtotop = true
string text = "Extract"
end type

event clicked;call super::clicked;dw_1.settransobject(sqlca)

String   	lvs_col_name, lvs_update_yn , lvs_format , lvs_editmask , lvs_visible_yn , lvs_width , lvs_sparse , lvs_col_desc
Long       lvl_column_order
Integer		lvi_count

dw_1.Reset()

Gst_dw_colinfo.i_dw_colcount = 0
Gst_dw_colinfo.i_dw_colcount=Integer(  ARG_DW.Describe("DataWindow.Column.Count"))

lvs_sparse = ARG_DW.Describe("datawindow.sparse")
For lvi_count = 1 to Gst_dw_colinfo.i_dw_colcount
	
	lvs_col_name = ''
	lvs_col_desc = ''
	
	dw_1.InsertRow(0)
//	F_SET_SECURITY_ROW(DW_1 , lvi_count , 'ALL')
		
	lvs_col_name	= ARG_DW.Describe('#'+String(lvi_count)+".Name")	
//	lvs_update_yn	= ARG_DW.Describe(lvs_col_name + ".Update")
	
	select decode( :GVS_LANGUAGE , 'K' , WORD_DESCRIPTION_KOR , 'C' , WORD_DESCRIPTION_LOCAL , WORD_DESCRIPTION_ENG ) 
	 into :lvs_col_desc
	  from ISYS_WORD_DICTIONARY
     where WORD_ENG = upper(:lvs_col_name) ;
	  
	  if f_sql_check() < 0 then 
		return
	end if
	
//	lvs_format= ARG_DW.Describe(lvs_col_name + ".format")
//	lvs_editmask= ARG_DW.Describe(lvs_col_name + ".editmask.mask")
//	lvs_visible_yn= ARG_DW.Describe(lvs_col_name + ".visible")
//	lvs_width = ARG_DW.Describe(lvs_col_name + ".width")
//	lvl_column_order = LONG(ARG_DW.Describe(lvs_col_name + ".X"))

//	dw_1.SetItem(lvi_count,'window_name' , UPPER(ivs_window) )
//	dw_1.SetItem(lvi_count,'datawindow_name' ,UPPER( ivs_datawindow) )
	dw_1.SetItem(lvi_count,'column_name',UPPER(lvs_col_name))
	dw_1.SetItem(lvi_count,'column_mean',ARG_DW.Describe(lvs_col_name+"_t.Text"))	
	dw_1.SetItem(lvi_count,'column_description',lvs_col_desc)		
	
//	dw_1.SetItem(lvi_count,'column_format',lvs_format)	
//	dw_1.SetItem(lvi_count,'editmask',lvs_editmask)		
//	dw_1.SetItem(lvi_count,'visible_yn',lvs_visible_yn)		
//	dw_1.SetItem(lvi_count,'column_width',lvs_width)		
//	dw_1.SetItem(lvi_count,'column_order',lvl_column_order)		
	
//	IF Pos(lvs_sparse,lvs_col_name ) > 0 THEN 
//		dw_1.SetItem(lvi_count,'sparse','Y')		
//	ELSE
//		dw_1.SetItem(lvi_count,'sparse','N')				
//	END IF
//	
//	IF lvs_update_yn = "yes" Then
//		dw_1.SetItem(lvi_count, 'update_yn', 'Y')	
//	Else
//		dw_1.SetItem(lvi_count, 'update_yn', 'N')
//	End IF

Next
end event

type st_1 from so_statictext within w_column_explanation
integer x = 37
integer y = 316
integer width = 517
integer height = 52
boolean bringtotop = true
integer weight = 700
string text = "Window Name:"
alignment alignment = right!
end type

type sle_window_name from so_singlelineedit within w_column_explanation
integer x = 571
integer y = 304
integer width = 1001
integer taborder = 60
boolean bringtotop = true
integer weight = 700
textcase textcase = upper!
end type

type sle_datawindow from so_singlelineedit within w_column_explanation
integer x = 576
integer y = 388
integer width = 448
integer taborder = 70
boolean bringtotop = true
integer weight = 700
textcase textcase = upper!
end type

type st_2 from so_statictext within w_column_explanation
integer x = 37
integer y = 400
integer width = 517
integer height = 52
boolean bringtotop = true
integer weight = 700
string text = "Data Window Name:"
alignment alignment = right!
end type

type cb_1 from so_commandbutton within w_column_explanation
integer x = 2039
integer y = 332
integer width = 352
integer height = 100
integer taborder = 40
boolean bringtotop = true
string text = "Select Data"
end type

event clicked;call super::clicked;string ivs_select

if isvalid(selected_data_window) then 
	
 	ivs_select = dw_1.Describe("DataWindow.Selected.Data")
//     ivs_select = selected_data_window.Describe("DataWindow.Data.HTMLTable")
     ::Clipboard(ivs_select) 
	  
end if
end event

type gb_1 from so_groupbox within w_column_explanation
integer x = 1600
integer y = 220
integer width = 1591
integer height = 296
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_2 from so_groupbox within w_column_explanation
integer y = 224
integer width = 1600
integer height = 296
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

