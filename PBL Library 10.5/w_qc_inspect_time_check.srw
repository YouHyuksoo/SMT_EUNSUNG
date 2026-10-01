HA$PBExportHeader$w_qc_inspect_time_check.srw
$PBExportComments$$$HEX7$$08cd11c985c83cbb200080acacc0$$ENDHEX$$
forward
global type w_qc_inspect_time_check from w_main_root
end type
type st_mrm_no from so_statictext within w_qc_inspect_time_check
end type
type st_1 from statictext within w_qc_inspect_time_check
end type
type st_2 from statictext within w_qc_inspect_time_check
end type
type ddlb_check_time from uo_basecode within w_qc_inspect_time_check
end type
type st_3 from so_statictext within w_qc_inspect_time_check
end type
type uo_check_date from uo_ymd_calendar within w_qc_inspect_time_check
end type
type sle_line_code from singlelineedit within w_qc_inspect_time_check
end type
type sle_model_name from singlelineedit within w_qc_inspect_time_check
end type
type sle_item_code from singlelineedit within w_qc_inspect_time_check
end type
type st_4 from so_statictext within w_qc_inspect_time_check
end type
type st_5 from so_statictext within w_qc_inspect_time_check
end type
type sle_run_no from singlelineedit within w_qc_inspect_time_check
end type
type st_6 from so_statictext within w_qc_inspect_time_check
end type
type sle_worker from singlelineedit within w_qc_inspect_time_check
end type
type gb_2 from so_groupbox within w_qc_inspect_time_check
end type
type gb_1 from so_groupbox within w_qc_inspect_time_check
end type
end forward

global type w_qc_inspect_time_check from w_main_root
integer width = 5458
integer height = 2748
string title = "Time Check Inspection Result"
string ivs_dw_1_use_focusindicator = "N"
string ivs_dw_1_selected_row_yn = "N"
st_mrm_no st_mrm_no
st_1 st_1
st_2 st_2
ddlb_check_time ddlb_check_time
st_3 st_3
uo_check_date uo_check_date
sle_line_code sle_line_code
sle_model_name sle_model_name
sle_item_code sle_item_code
st_4 st_4
st_5 st_5
sle_run_no sle_run_no
st_6 st_6
sle_worker sle_worker
gb_2 gb_2
gb_1 gb_1
end type
global w_qc_inspect_time_check w_qc_inspect_time_check

forward prototypes
public function integer wf_save_timecheck ()
end prototypes

public function integer wf_save_timecheck ();
//==========================================
// $$HEX16$$18c215c81cb4200074c725b874c7200074c8acc758d594b2c0c9200055d678c7$$ENDHEX$$
//==========================================

dw_1.accepttext()
//ddlb_check_time.triggerevent()

IF dw_1.rowcount() < 1  THEN 	return 0
IF dw_1.ModifiedCount() < 1 THEN Return 0
		
//==========================================

long lvl_row
long lvl_count
long lvl_inspection_sample_seq
string lvs_inspection_by

string lvs_line_code
string lvs_work_order_no
string lvs_item_code, lvs_model_name
datetime lvd_inspection_date
string lvs_check_time

string lvs_work_shift 

double lvd_inspection_sample_seq
string  lvs_inspect_group_desc
string  lvs_inspection_item

double lvd_inspection_value
string  lvs_inspection_result

double lvd_inspection_value_bef
string  lvs_inspection_result_bef

string  lvs_inspection_item_type
double lvd_inspection_value_lcl
double lvd_inspection_value_std
double lvd_inspection_value_ucl
string   lvs_inspection_unit
double lvd_display_seq

string lvs_set_work_order
datetime lvd_work_order_date

datetime lvd_enter_date
string lvs_enter_by
datetime lvd_last_modify_date
string lvs_last_modify_by

datetime lvd_today ; Select sysdate Into :lvd_today From dual ;

//==========================================
// $$HEX7$$85c725b8acc06dd5200055d678c7$$ENDHEX$$
//==========================================

lvs_inspection_by     = sle_worker.text
lvs_line_code           = sle_line_code.text
lvs_work_order_no   = sle_run_no.text
lvs_item_code          = sle_item_code.text
lvs_model_name      = sle_model_name.text
lvd_inspection_date  = uo_check_date.text()
lvs_check_time        = ddlb_check_time.getcode()

if isnull(lvs_inspection_by) then lvs_inspection_by = ""

if len(trim(lvs_inspection_by)) < 1 then
	F_MSGBOX1(9154 , F_GET_DUAL_LANG_TEXT(GVS_LANGUAGE , "Inspector"))
	return 0
end if

if isnull(lvs_work_order_no) then lvs_work_order_no = ""

if len(trim(lvs_work_order_no)) < 9 then
	F_MSGBOX1(9154 , F_GET_DUAL_LANG_TEXT(GVS_LANGUAGE , "Work Order"))
	sle_run_no.setfocus()
	return 0
end if

if isnull(lvs_check_time) then lvs_check_time = ""

if len(trim(lvs_check_time)) < 1 or lvs_check_time = '' or lvs_check_time = '%' then
	F_MSGBOX1(9154 , F_GET_DUAL_LANG_TEXT(GVS_LANGUAGE , "inspection by"))
	ddlb_check_time.setfocus()
	return 0
end if

For lvl_row = 1 To dw_1.Rowcount()
		
	if dw_1.getitemstring(lvl_row, "inspection_result") = "WAIT" then
		
		dw_1.scrolltorow(lvl_row)
		F_MSGBOX1(9154 , F_GET_DUAL_LANG_TEXT(GVS_LANGUAGE , "INSPECTION RESULT"))
		return 0
		
	end if
	
Next

//==========================================
// $$HEX6$$e4c21cc800c8a5c791c7c5c5$$ENDHEX$$
//==========================================

IF F_MSGBOX1(1161 ,  '$$HEX1$$08cd$$ENDHEX$$/$$HEX1$$11c9$$ENDHEX$$/$$HEX3$$85c83cbb2000$$ENDHEX$$Time Check' )  <> 1 THEN RETURN 0        // @$$HEX11$$44c72000e4c289d5200058d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?

For lvl_row = 1 To dw_1.Rowcount()
	
	lvs_inspect_group_desc      = dw_1.object.inspect_group_desc [lvl_row]
	lvs_inspection_item            = dw_1.object.inspection_item [lvl_row]
	
	lvd_inspection_value          = dw_1.object.inspection_value [lvl_row]
	lvs_inspection_result          = dw_1.object.inspection_result [lvl_row]
		
	lvd_inspection_value_bef    = dw_1.object.inspection_value.original [lvl_row]
	lvs_inspection_result_bef    = dw_1.object.inspection_result.original [lvl_row]
	
	lvs_inspection_item_type     = dw_1.object.inspection_item_type [lvl_row]
	lvd_inspection_value_lcl      = dw_1.object.inspection_value_lcl [lvl_row]
	lvd_inspection_value_std     = dw_1.object.inspection_value_std [lvl_row]
	lvd_inspection_value_ucl     =  dw_1.object.inspection_value_ucl [lvl_row]
	lvs_inspection_unit             = dw_1.object.inspection_unit [lvl_row]
	lvd_display_seq                 = dw_1.object.display_seq [lvl_row]
	
	lvd_enter_date = dw_1.object.enter_date [lvl_row]
	lvs_enter_by = dw_1.object.enter_by [lvl_row]
	lvd_last_modify_date = dw_1.object.last_modify_date [lvl_row]
	lvs_last_modify_by = dw_1.object.last_modify_by [lvl_row]
	
	if isnull(lvs_enter_by) then lvs_enter_by = ""
	
	DELETE FROM IQC_INSPECTION_TIME_CHECK
	WHERE ORGANIZATION_ID                       = :gvi_organization_id
	      AND INSPECTION_DATE                      = :LVD_INSPECTION_DATE
	     AND LINE_CODE                                  = :LVS_LINE_CODE
	     AND WORK_ORDER_NO                       = :LVS_WORK_ORDER_NO
	     AND ITEM_CODE                                 = :LVS_ITEM_CODE
	     AND CHECK_TIME                               = :LVS_CHECK_TIME
		 AND INSPECTION_ITEM_SEQ               = :LVD_DISPLAY_SEQ;
		  
	IF F_SQL_CHECK_WITH_MSG("DELETE FROM IQC_INSPECTION_TIME_CHECK (1)") < 0 THEN RETURN 0
	
		
    if len(trim(lvs_enter_by)) < 1 then
			lvd_enter_date = lvd_today
			lvs_enter_by     = lvs_inspection_by           // GVS_USER_ID
	end if
		
		if lvs_inspection_result <> lvs_inspection_result_bef then
			lvd_last_modify_date = lvd_today
			lvs_last_modify_by    = lvs_inspection_by  // GVS_USER_ID
		end if


		  INSERT INTO IQC_INSPECTION_TIME_CHECK  
					( ORGANIZATION_ID,                   LINE_CODE,                                WORK_ORDER_NO,                 ITEM_CODE,                               INSPECTION_DATE,   
					  CHECK_TIME,                            INSPECTION_ITEM_SEQ,             INSPECT_GROUP,                   INSPECT_GROUP_DESC,             INSPECTION_ITEM,                     INSPECTION_BY,   
					  INSPECTION_YN,                       INSPECTION_VALUE,                   INSPECTION_RESULT,             INSPECTION_ITEM_TYPE,            INSPECTION_VALUE_LCL,   
					  INSPECTION_VALUE_STD,          INSPECTION_VALUE_UCL,            INSPECTION_UNIT,                  SET_WORK_ORDER,   
					  WORK_ORDER_DATE,                ENTER_DATE,                             ENTER_BY,                              LAST_MODIFY_DATE,                 LAST_MODIFY_BY ,                   WORK_SHIFT)  
		  VALUES ( :gvi_organization_id,                :LVS_LINE_CODE,                       :LVS_WORK_ORDER_NO,          :LVS_ITEM_CODE,                      :LVD_INSPECTION_DATE,   
					  :LVS_CHECK_TIME,                   :LVD_DISPLAY_SEQ,                   :LVS_ITEM_CODE,                   :LVS_INSPECT_GROUP_DESC,    :LVS_INSPECTION_ITEM,            :LVS_INSPECTION_BY,   
					  'Y',                                          :LVD_INSPECTION_VALUE,           :LVS_INSPECTION_RESULT,      :LVS_INSPECTION_ITEM_TYPE,  :LVD_INSPECTION_VALUE_LCL,   
					  :LVD_INSPECTION_VALUE_STD, :LVD_INSPECTION_VALUE_UCL,   :LVS_INSPECTION_UNIT,           :LVS_SET_WORK_ORDER,   
					  NULL,                                      :LVD_ENTER_DATE,                     :LVS_ENTER_BY,                     :LVD_LAST_MODIFY_DATE,        :LVS_LAST_MODIFY_BY,            '*' )  ;
	
		IF F_SQL_CHECK_WITH_MSG("INSERT INTO IQC_INSPECTION_TIME_CHECK (1)") < 0 THEN RETURN 0
		
Next

COMMIT;

F_MSGBOX1(107 , "$$HEX1$$08cd$$ENDHEX$$/$$HEX1$$11c9$$ENDHEX$$/$$HEX3$$85c83cbb2000$$ENDHEX$$Time Check" )                              // @ $$HEX16$$00ac200031c1f5ac01c83cc75cb8200098ccacb9200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$

dw_1.reset()
sle_run_no.text = ''
sle_line_code.text = ''
sle_model_name.text = ''
sle_item_code.text = ''
sle_run_no.setfocus()

return 1
end function

on w_qc_inspect_time_check.create
int iCurrent
call super::create
this.st_mrm_no=create st_mrm_no
this.st_1=create st_1
this.st_2=create st_2
this.ddlb_check_time=create ddlb_check_time
this.st_3=create st_3
this.uo_check_date=create uo_check_date
this.sle_line_code=create sle_line_code
this.sle_model_name=create sle_model_name
this.sle_item_code=create sle_item_code
this.st_4=create st_4
this.st_5=create st_5
this.sle_run_no=create sle_run_no
this.st_6=create st_6
this.sle_worker=create sle_worker
this.gb_2=create gb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_mrm_no
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.ddlb_check_time
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.uo_check_date
this.Control[iCurrent+7]=this.sle_line_code
this.Control[iCurrent+8]=this.sle_model_name
this.Control[iCurrent+9]=this.sle_item_code
this.Control[iCurrent+10]=this.st_4
this.Control[iCurrent+11]=this.st_5
this.Control[iCurrent+12]=this.sle_run_no
this.Control[iCurrent+13]=this.st_6
this.Control[iCurrent+14]=this.sle_worker
this.Control[iCurrent+15]=this.gb_2
this.Control[iCurrent+16]=this.gb_1
end on

on w_qc_inspect_time_check.destroy
call super::destroy
destroy(this.st_mrm_no)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.ddlb_check_time)
destroy(this.st_3)
destroy(this.uo_check_date)
destroy(this.sle_line_code)
destroy(this.sle_model_name)
destroy(this.sle_item_code)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.sle_run_no)
destroy(this.st_6)
destroy(this.sle_worker)
destroy(this.gb_2)
destroy(this.gb_1)
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

event ue_data_control;call super::ue_data_control;

choose case gvs_ue_data_control
		
	case 'RETRIEVE'
		
    case 'DELETE'
		
    case 'UPDATE'		
		
		   wf_save_timecheck()
								
	case else
		
end choose

end event

type dw_5 from w_main_root`dw_5 within w_qc_inspect_time_check
integer y = 316
end type

type dw_4 from w_main_root`dw_4 within w_qc_inspect_time_check
integer y = 316
end type

type dw_3 from w_main_root`dw_3 within w_qc_inspect_time_check
integer y = 316
integer width = 4544
integer height = 1388
end type

type dw_2 from w_main_root`dw_2 within w_qc_inspect_time_check
integer y = 316
integer width = 4544
integer height = 1388
boolean titlebar = true
string title = "History"
string dataobject = "d_qc_product_reflow_data_all_lst"
end type

type dw_1 from w_main_root`dw_1 within w_qc_inspect_time_check
integer y = 316
integer width = 5239
integer height = 1920
boolean titlebar = true
string title = "Time Check Registration"
string dataobject = "d_qc_inspect_time_check2"
end type

event dw_1::clicked;call super::clicked;

if row < 1 then Return


string lvs_current
string lvs_column ; lvs_column = dwo.name



if LEFT(lvs_column, 17) = "inspection_result" then
	
	lvs_current = dw_1.getitemstring(row, lvs_column)
	
	CHOOSE CASE lvs_current
		CASE "WAIT" ;     setitem(row, lvs_column, "OK")
		CASE "OK" ;         setitem(row, lvs_column, "NG")
		CASE "NG" ;         setitem(row, lvs_column, "WAIT")
	END CHOOSE
	
end if
end event

event dw_1::itemchanged;call super::itemchanged;
double d_min, d_max

d_min = getitemnumber(row, "INSPECTION_VALUE_LCL")
d_max = getitemnumber(row, "INSPECTION_VALUE_UCL")

if dwo.name = "inspection_value" then
	
	if double(data) < d_min or double(data) > d_max then
		setitem(row, "inspection_result", "NG")
	else
		setitem(row, "inspection_result", "OK")
	end if
	
end if


end event

event dw_1::itemerror;call super::itemerror;
return 1
end event

type uo_tabpages from w_main_root`uo_tabpages within w_qc_inspect_time_check
end type

type st_mrm_no from so_statictext within w_qc_inspect_time_check
integer x = 2862
integer y = 88
integer width = 992
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "Model Name"
end type

type st_1 from statictext within w_qc_inspect_time_check
integer x = 2510
integer y = 88
integer width = 343
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Line Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_qc_inspect_time_check
integer x = 489
integer y = 92
integer width = 631
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Inspection Type"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_check_time from uo_basecode within w_qc_inspect_time_check
integer x = 489
integer y = 176
integer width = 631
integer taborder = 30
boolean bringtotop = true
end type

event modified;call super::modified;
sle_worker.setfocus()
end event

event constructor;call super::constructor;
redraw('INSPECTION TYPE') 
end event

type st_3 from so_statictext within w_qc_inspect_time_check
integer x = 59
integer y = 92
integer width = 416
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Check Date"
end type

type uo_check_date from uo_ymd_calendar within w_qc_inspect_time_check
integer x = 59
integer y = 176
integer taborder = 40
boolean bringtotop = true
end type

on uo_check_date.destroy
call uo_ymd_calendar::destroy
end on

type sle_line_code from singlelineedit within w_qc_inspect_time_check
integer x = 2510
integer y = 172
integer width = 343
integer height = 92
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12639424
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type sle_model_name from singlelineedit within w_qc_inspect_time_check
integer x = 2862
integer y = 172
integer width = 992
integer height = 92
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12639424
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type sle_item_code from singlelineedit within w_qc_inspect_time_check
integer x = 3863
integer y = 172
integer width = 613
integer height = 92
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12639424
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type st_4 from so_statictext within w_qc_inspect_time_check
integer x = 3863
integer y = 88
integer width = 613
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type st_5 from so_statictext within w_qc_inspect_time_check
integer x = 1760
integer y = 92
integer width = 613
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "Work Order No"
end type

type sle_run_no from singlelineedit within w_qc_inspect_time_check
integer x = 1760
integer y = 176
integer width = 613
integer height = 84
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event getfocus;this.selecttext(1,200)
end event

event modified;
long lvl_sql_check 
string lvs_run_no, lvs_model_name, lvs_item_code, lvs_line_code, lvs_check_time, lvs_worker
datetime lvdt_check_date

lvs_run_no                = this.text
lvdt_check_date         = uo_check_date.text()
lvs_check_time           = ddlb_check_time.getcode()
lvs_worker                = sle_worker.text

if lvs_worker = '' or lvs_worker = '%' or isnull(lvs_worker) then
	Messagebox("$$HEX2$$bdace0ac$$ENDHEX$$", "$$HEX19$$85c725b858d5e0c2200091c7c5c590c7200015c8f4bc00ac200085c725b8200058d538c194c6$$ENDHEX$$")
	sle_worker.setfocus()
	return	
end if

if len( lvs_run_no ) < 9 then
	Messagebox("$$HEX2$$bdace0ac$$ENDHEX$$", "$$HEX5$$85c725b858d5e0c22000$$ENDHEX$$Run Card$$HEX8$$7cb9200055d678c7200058d538c194c6$$ENDHEX$$")
	sle_run_no.setfocus()
	return	
end if

if lvs_check_time = '' or lvs_check_time = '%' or isnull(lvs_check_time) then
	Messagebox("$$HEX2$$bdace0ac$$ENDHEX$$", "$$HEX1$$08cd$$ENDHEX$$/$$HEX1$$11c9$$ENDHEX$$/$$HEX12$$11c920006cad84bd44c7200020c1ddd0200058d538c194c6$$ENDHEX$$")
	ddlb_check_time.setfocus()
	return	
end if

sle_line_code.text      =  ''
sle_model_name.text =  ''
sle_item_code.text    =  ''

// work order $$HEX7$$15c8f4bc7cb920006cad5cd5e4b2$$ENDHEX$$
select model_name, item_code, line_code
   into  :lvs_model_name, :lvs_item_code, :lvs_line_code
  from ip_product_run_card
 where run_no = :lvs_run_no
     and organization_id = :GVI_ORGANIZATION_ID;
	
// SQL $$HEX8$$e4c289d5b0acfcac200055d678c70900$$ENDHEX$$
lvl_sql_check = F_SQL_CHECK()	

IF  lvl_sql_check < 0 THEN 
	
	sle_run_no.setfocus()
	RETURN 
	
ELSEIF lvl_sql_check = 100 then
	
	Messagebox("$$HEX2$$bdace0ac$$ENDHEX$$", "$$HEX5$$f8bb2000f1b45db82000$$ENDHEX$$Run Card $$HEX3$$85c7c8b2e4b2$$ENDHEX$$")
	this.setfocus()
	return
	
ELSE
	
	sle_line_code.text      =   lvs_line_code
    sle_model_name.text =   lvs_model_name
    sle_item_code.text    =  lvs_item_code
	 
	dw_1.retrieve( gvi_organization_id, lvs_line_code, lvs_run_no, lvs_item_code, lvdt_check_date, lvs_check_time ) 

END IF  



end event

type st_6 from so_statictext within w_qc_inspect_time_check
integer x = 1134
integer y = 92
integer width = 613
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "Worker"
end type

type sle_worker from singlelineedit within w_qc_inspect_time_check
integer x = 1134
integer y = 176
integer width = 613
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event getfocus;this.selecttext(1,200)
end event

event modified;
sle_run_no.setfocus()


end event

type gb_2 from so_groupbox within w_qc_inspect_time_check
integer x = 2478
integer width = 2039
integer height = 304
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "WO Information"
end type

type gb_1 from so_groupbox within w_qc_inspect_time_check
integer x = 5
integer width = 2455
integer height = 304
integer taborder = 40
integer weight = 700
long textcolor = 16711680
string text = "Condition"
end type

