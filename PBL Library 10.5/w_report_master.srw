HA$PBExportHeader$w_report_master.srw
$PBExportComments$$$HEX9$$70c874ac08c8ddc031c1a9c608c7c4b3b0c6$$ENDHEX$$
forward
global type w_report_master from w_main_root
end type
type pb_1 from so_picturebutton within w_report_master
end type
type pb_2 from so_picturebutton within w_report_master
end type
type sle_report_name from so_singlelineedit within w_report_master
end type
type cb_refresh from so_commandbutton within w_report_master
end type
type st_1 from so_statictext within w_report_master
end type
type pb_3 from so_picturebutton within w_report_master
end type
type cb_1 from so_commandbutton within w_report_master
end type
type cbx_preview from so_checkbox within w_report_master
end type
type gb_1 from so_groupbox within w_report_master
end type
type gb_2 from so_groupbox within w_report_master
end type
end forward

global type w_report_master from w_main_root
integer width = 4425
integer height = 2548
string title = "Report"
pb_1 pb_1
pb_2 pb_2
sle_report_name sle_report_name
cb_refresh cb_refresh
st_1 st_1
pb_3 pb_3
cb_1 cb_1
cbx_preview cbx_preview
gb_1 gb_1
gb_2 gb_2
end type
global w_report_master w_report_master

on w_report_master.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.sle_report_name=create sle_report_name
this.cb_refresh=create cb_refresh
this.st_1=create st_1
this.pb_3=create pb_3
this.cb_1=create cb_1
this.cbx_preview=create cbx_preview
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.sle_report_name
this.Control[iCurrent+4]=this.cb_refresh
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.pb_3
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.cbx_preview
this.Control[iCurrent+9]=this.gb_1
this.Control[iCurrent+10]=this.gb_2
end on

on w_report_master.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.sle_report_name)
destroy(this.cb_refresh)
destroy(this.st_1)
destroy(this.pb_3)
destroy(this.cb_1)
destroy(this.cbx_preview)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event activate;call super::activate;/***************************************
* Window Default Property 
****************************************/
Gst_set.window_id            = this.classname() 
Gst_set.author                  = "JiSheng"
Gst_set.creation_date      = '20051101'
Gst_set.last_modify_date = '20051101'
Gst_set.Report_window    = True  // Report Window  True / Flase

/*****************************************
* Data Window Property
******************************************/
Ivs_resize_type                      = 'MASTER_DETAIL_1L2R'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default

/****************************************
* Menu Property 
*****************************************
* ADMIN  ( All Control )
* MANAGE ( Manager )
* GUEST  ( Only Query )
* QUERY  ( Only Query  )
* DATA_CONTROL  ( Insert Delete Update )
* REPORT ( Report )
****************************************/
F_MENU_CONTROL('REPORT' , TRUE)  // All Data Control

SELECTED_DATA_WINDOW = DW_2




end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

cb_refresh.triggerevent( clicked!)
end event

event ue_data_control;call super::ue_data_control;long row 
string lvs_datawindow_name , lvs_sql
choose case gvs_ue_data_control
		
	case 'RETRIEVE'
		  
		  if dw_1.getrow() < 1 then return
		  
		  Gst_return.gvs_return[1] = dw_1.object.datawindow_name[dw_1.getrow()]
		  if isvalid(w_report_where_condition_popup) then 
			  w_report_where_condition_popup.show()
		  else
			  openwithparm(w_report_where_condition_popup , dw_2 )
		  end if 
	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_report_master
integer y = 340
end type

type dw_4 from w_main_root`dw_4 within w_report_master
integer y = 340
end type

type dw_3 from w_main_root`dw_3 within w_report_master
integer y = 340
integer height = 2216
end type

type dw_2 from w_main_root`dw_2 within w_report_master
integer x = 1408
integer y = 340
integer width = 2981
integer height = 2096
boolean titlebar = true
string title = "Preview"
string dataobject = "d_null_datawindow"
end type

type dw_1 from w_main_root`dw_1 within w_report_master
integer y = 340
integer width = 1408
integer height = 2096
boolean titlebar = true
string dataobject = "d_report_menu_lst_tree"
boolean maxbox = false
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;string lvs_data_window , lvs_data_window_name , lvs_comments


if currentrow = 0 then return 

	lvs_data_window_name = this.object.datawindow_name[currentrow] 
	lvs_comments = this.object.comments[currentrow] 
	//sle_comments.text = lvs_comments

	if lvs_data_window_name = '' or isnull(lvs_data_window_name) then 
	   //sle_comments.text = ''	
	   dw_2.dataobject = 'd_null_datawindow'	
	   return
	end if 
	
if cbx_preview.checked = true then 
else
	return
end if 	
//================================================
//
//================================================
lvs_data_window = f_get_data_window_source( lvs_data_window_name )

//=============================================
if lvs_data_window = '' then 
	dw_2.dataobject = 'd_null_datawindow'
	return
else
	dw_2.Create ( lvs_data_window) 
	dw_2.Modify("DataWindow.Print.Preview=yes")
	dw_2.Modify("DataWindow.Print.Preview.Rulers=yes")	
end if 
f_dual_lang_change_dwtext(dw_2)


end event

event dw_1::uo_mousemove;call super::uo_mousemove;SELECTED_DATA_WINDOW = DW_2
if row < 1 then return
IF UPPER(DWO.TYPE) = 'COLUMN' AND  UPPER(DWO.NAME) = 'REPORT_TITLE'   THEN
	
	THIS.TITLE = STRING(THIS.OBJECT.REPORT_TITLE[ROW] )
END IF 


end event

event dw_1::getfocus;call super::getfocus;SELECTED_DATA_WINDOW = DW_2
end event

event dw_1::clicked;call super::clicked;SELECTED_DATA_WINDOW = DW_2
end event

event dw_1::doubleclicked;call super::doubleclicked;SELECTED_DATA_WINDOW = DW_2
end event

type uo_tabpages from w_main_root`uo_tabpages within w_report_master
end type

type pb_1 from so_picturebutton within w_report_master
integer x = 59
integer y = 60
integer width = 101
integer height = 88
integer taborder = 20
boolean bringtotop = true
string picturename = "TreeView!"
string powertiptext = "Expand All"
end type

event clicked;call super::clicked;integer li_ret

li_ret = dw_1.ExpandAll()
end event

type pb_2 from so_picturebutton within w_report_master
integer x = 279
integer y = 60
integer width = 101
integer height = 88
integer taborder = 20
boolean bringtotop = true
boolean originalsize = false
string picturename = "OutputPrevious!"
string powertiptext = "Collepse All"
end type

event clicked;call super::clicked;integer li_ret

li_ret = dw_1.CollapseAll()
end event

type sle_report_name from so_singlelineedit within w_report_master
integer x = 421
integer y = 176
integer width = 882
integer taborder = 30
boolean bringtotop = true
end type

event modified;call super::modified;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

DW_1.SETFILTER('')
DW_1.FILTER()

LVS_COLUMN = 'REPORT_TITLE'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    DW_1.SETFILTER('')
    DW_1.FILTER()
    DW_1.GRoupcalc( )
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

DW_1.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
DW_1.FILTER()
DW_1.GRoupcalc( )
F_MSG_MDI_HELP( STRING( DW_1.ROWCOUNT() ) + " Found" )
end event

type cb_refresh from so_commandbutton within w_report_master
integer x = 41
integer y = 148
integer width = 357
integer height = 112
integer taborder = 10
boolean bringtotop = true
string text = "Refresh"
end type

event clicked;call super::clicked;dw_1.reset()
dw_1.retrieve( '%'+sle_report_name.text+'%' , gvs_language , gvs_user_id , gvi_organization_id )
end event

type st_1 from so_statictext within w_report_master
integer x = 421
integer y = 112
integer width = 882
integer height = 52
boolean bringtotop = true
integer weight = 700
string text = "Report Title"
end type

type pb_3 from so_picturebutton within w_report_master
integer x = 169
integer y = 60
integer width = 101
integer height = 88
integer taborder = 30
boolean bringtotop = true
boolean originalsize = false
string picturename = "TreeView2!"
string powertiptext = "Expand All"
end type

event clicked;call super::clicked;integer li_ret

li_ret = dw_1.ExpandLevel(2)
end event

type cb_1 from so_commandbutton within w_report_master
integer x = 1458
integer y = 152
integer width = 645
integer height = 112
integer taborder = 20
boolean bringtotop = true
string text = "Report Form Download"
end type

type cbx_preview from so_checkbox within w_report_master
integer x = 1472
integer y = 60
integer width = 622
integer height = 80
boolean bringtotop = true
string text = "Preview"
boolean checked = true
end type

type gb_1 from so_groupbox within w_report_master
integer width = 1330
integer height = 312
integer taborder = 10
string text = "Process"
end type

type gb_2 from so_groupbox within w_report_master
integer x = 1417
integer width = 713
integer height = 312
integer taborder = 20
string text = "Report Form"
end type

