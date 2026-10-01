HA$PBExportHeader$w_qc_inspect_time_check2.srw
$PBExportComments$$$HEX7$$08cd11c985c83cbb200080acacc0$$ENDHEX$$
forward
global type w_qc_inspect_time_check2 from w_main_root
end type
type st_2 from statictext within w_qc_inspect_time_check2
end type
type ddlb_check_time from uo_basecode within w_qc_inspect_time_check2
end type
type st_3 from so_statictext within w_qc_inspect_time_check2
end type
type st_5 from so_statictext within w_qc_inspect_time_check2
end type
type st_6 from so_statictext within w_qc_inspect_time_check2
end type
type sle_worker from singlelineedit within w_qc_inspect_time_check2
end type
type dp_ymd from datepicker within w_qc_inspect_time_check2
end type
type ddlb_model from uo_timecheck_model_name within w_qc_inspect_time_check2
end type
type cb_add from commandbutton within w_qc_inspect_time_check2
end type
type cb_save from commandbutton within w_qc_inspect_time_check2
end type
type cb_close from commandbutton within w_qc_inspect_time_check2
end type
end forward

global type w_qc_inspect_time_check2 from w_main_root
integer width = 5458
integer height = 2748
string title = "Inspection Time Check"
string ivs_dw_1_use_focusindicator = "N"
string ivs_dw_1_selected_row_yn = "N"
st_2 st_2
ddlb_check_time ddlb_check_time
st_3 st_3
st_5 st_5
st_6 st_6
sle_worker sle_worker
dp_ymd dp_ymd
ddlb_model ddlb_model
cb_add cb_add
cb_save cb_save
cb_close cb_close
end type
global w_qc_inspect_time_check2 w_qc_inspect_time_check2

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
long lvl_count, lvl_x
long lvl_inspection_sample_seq
string lvs_inspection_by

string lvs_line_code
string lvs_work_order_no
string lvs_item_code, lvs_model_name
date  lvd_inspection_date
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
lvs_line_code           = '*'
lvs_work_order_no   = '*'
lvd_inspection_date  = dp_ymd.datevalue
lvs_check_time        = ddlb_check_time.getcode()

lvl_x                   = pos( ddlb_model.text, ']', 2 )
lvs_item_code     = mid( ddlb_model.text, 2, lvl_x -2)

// model $$HEX7$$15c8f4bc7cb920006cad5cd5e4b2$$ENDHEX$$
select inspect_group_desc
   into  :lvs_model_name
  from IQC_INSPECTION_TEMPLATE
 where inspect_group   = :lvs_item_code
     and organization_id = :GVI_ORGANIZATION_ID
	 and rownum          = 1;
	 
if (  F_SQL_CHECK() < 0 ) then
	 return 0
end if

LVS_WORK_ORDER_NO = lvs_item_code

if isnull(lvs_inspection_by) then lvs_inspection_by = ""

if len(trim(lvs_inspection_by)) < 1 then
	F_MSGBOX1(9154 , F_GET_DUAL_LANG_TEXT(GVS_LANGUAGE , "$$HEX8$$f1b45db8200060d5200091c7c5c590c7$$ENDHEX$$"))
	return 0
end if

if isnull(lvs_model_name) then lvs_model_name = ""

if len(trim(lvs_model_name)) < 9 then
	F_MSGBOX1(9154 , F_GET_DUAL_LANG_TEXT(GVS_LANGUAGE , "$$HEX7$$f1b45db8200060d52000a8ba78b3$$ENDHEX$$"))
	ddlb_model.setfocus()
	return 0
end if

if isnull(lvs_check_time) then lvs_check_time = ""

if len(trim(lvs_check_time)) < 1 or lvs_check_time = '' or lvs_check_time = '%' then
	F_MSGBOX1(9154 , F_GET_DUAL_LANG_TEXT(GVS_LANGUAGE , "$$HEX6$$f1b45db8200060d5200008cd$$ENDHEX$$/$$HEX1$$11c9$$ENDHEX$$/$$HEX5$$85c83cbb20006cad84bd$$ENDHEX$$"))
	ddlb_check_time.setfocus()
	return 0
end if

For lvl_row = 1 To dw_1.Rowcount()
		
	if dw_1.getitemstring(lvl_row, "inspection_result") = "WAIT" then
		
		dw_1.scrolltorow(lvl_row)
		F_MSGBOX1(9154 , F_GET_DUAL_LANG_TEXT(GVS_LANGUAGE , "$$HEX9$$f1b45db8200060d5200080acacc0b0acfcac$$ENDHEX$$"))
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
	
	lvd_enter_date                  = dw_1.object.enter_date [lvl_row]
	lvs_enter_by                     = dw_1.object.enter_by [lvl_row]
	lvd_last_modify_date         = dw_1.object.last_modify_date [lvl_row]
	lvs_last_modify_by            = dw_1.object.last_modify_by [lvl_row]
	
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

F_MSGBOX1(107 , "$$HEX1$$08cd$$ENDHEX$$/$$HEX1$$11c9$$ENDHEX$$/$$HEX7$$85c83cbb2000b0acfcacf1b45db8$$ENDHEX$$" )                              // @ $$HEX16$$00ac200031c1f5ac01c83cc75cb8200098ccacb9200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$

dw_1.reset()
cb_add.setfocus()

return 1
end function

on w_qc_inspect_time_check2.create
int iCurrent
call super::create
this.st_2=create st_2
this.ddlb_check_time=create ddlb_check_time
this.st_3=create st_3
this.st_5=create st_5
this.st_6=create st_6
this.sle_worker=create sle_worker
this.dp_ymd=create dp_ymd
this.ddlb_model=create ddlb_model
this.cb_add=create cb_add
this.cb_save=create cb_save
this.cb_close=create cb_close
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.ddlb_check_time
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_5
this.Control[iCurrent+5]=this.st_6
this.Control[iCurrent+6]=this.sle_worker
this.Control[iCurrent+7]=this.dp_ymd
this.Control[iCurrent+8]=this.ddlb_model
this.Control[iCurrent+9]=this.cb_add
this.Control[iCurrent+10]=this.cb_save
this.Control[iCurrent+11]=this.cb_close
end on

on w_qc_inspect_time_check2.destroy
call super::destroy
destroy(this.st_2)
destroy(this.ddlb_check_time)
destroy(this.st_3)
destroy(this.st_5)
destroy(this.st_6)
destroy(this.sle_worker)
destroy(this.dp_ymd)
destroy(this.ddlb_model)
destroy(this.cb_add)
destroy(this.cb_save)
destroy(this.cb_close)
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
		
		  
								
	case else
		
end choose

end event

type dw_5 from w_main_root`dw_5 within w_qc_inspect_time_check2
integer y = 1320
end type

type dw_4 from w_main_root`dw_4 within w_qc_inspect_time_check2
integer y = 1320
end type

type dw_3 from w_main_root`dw_3 within w_qc_inspect_time_check2
integer y = 1320
integer width = 4544
integer height = 916
end type

type dw_2 from w_main_root`dw_2 within w_qc_inspect_time_check2
integer y = 1320
integer width = 4544
integer height = 916
boolean titlebar = true
end type

type dw_1 from w_main_root`dw_1 within w_qc_inspect_time_check2
integer y = 1116
integer width = 5239
integer height = 1120
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

type uo_tabpages from w_main_root`uo_tabpages within w_qc_inspect_time_check2
end type

type st_2 from statictext within w_qc_inspect_time_check2
integer x = 219
integer y = 420
integer width = 1161
integer height = 184
boolean bringtotop = true
integer textsize = -22
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "$$HEX1$$08cd$$ENDHEX$$/$$HEX1$$11c9$$ENDHEX$$/$$HEX5$$85c83cbb20006cad84bd$$ENDHEX$$"
alignment alignment = right!
boolean focusrectangle = false
end type

type ddlb_check_time from uo_basecode within w_qc_inspect_time_check2
integer x = 1422
integer y = 420
integer width = 1742
integer taborder = 30
boolean bringtotop = true
integer textsize = -22
end type

event modified;call super::modified;
sle_worker.setfocus()
end event

event constructor;call super::constructor;
redraw('INSPECTION TYPE') 
end event

type st_3 from so_statictext within w_qc_inspect_time_check2
integer x = 210
integer y = 236
integer width = 1161
integer height = 184
boolean bringtotop = true
integer textsize = -22
integer weight = 700
string text = "$$HEX3$$80acacc07cc7$$ENDHEX$$"
alignment alignment = right!
end type

type st_5 from so_statictext within w_qc_inspect_time_check2
integer x = 219
integer y = 804
integer width = 1161
integer height = 184
boolean bringtotop = true
integer textsize = -22
integer weight = 700
string text = "$$HEX4$$80acacc0a8ba78b3$$ENDHEX$$"
alignment alignment = right!
end type

type st_6 from so_statictext within w_qc_inspect_time_check2
integer x = 219
integer y = 604
integer width = 1161
integer height = 184
boolean bringtotop = true
integer textsize = -22
integer weight = 700
string text = "$$HEX3$$91c7c5c590c7$$ENDHEX$$"
alignment alignment = right!
end type

type sle_worker from singlelineedit within w_qc_inspect_time_check2
integer x = 1422
integer y = 604
integer width = 1742
integer height = 184
integer taborder = 40
boolean bringtotop = true
integer textsize = -20
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event getfocus;this.selecttext(1,200)
end event

type dp_ymd from datepicker within w_qc_inspect_time_check2
integer x = 1422
integer y = 220
integer width = 1742
integer height = 184
integer taborder = 60
boolean bringtotop = true
boolean border = true
borderstyle borderstyle = stylelowered!
string customformat = "yyyy-MM-dd HH:mm:ss"
date maxdate = Date("2999-12-31")
date mindate = Date("1800-01-01")
datetime value = DateTime(Date("2022-04-04"), Time("10:03:43.000000"))
integer textsize = -22
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
integer calendarfontweight = 400
boolean todaysection = true
boolean todaycircle = true
end type

type ddlb_model from uo_timecheck_model_name within w_qc_inspect_time_check2
integer x = 1422
integer y = 804
integer width = 3598
integer height = 1748
integer taborder = 20
boolean bringtotop = true
integer textsize = -22
boolean allowedit = false
boolean sorted = false
end type

type cb_add from commandbutton within w_qc_inspect_time_check2
integer x = 3451
integer y = 220
integer width = 489
integer height = 184
integer taborder = 70
boolean bringtotop = true
integer textsize = -15
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "$$HEX2$$f1b45db8$$ENDHEX$$"
end type

event clicked;
long    lvl_sql_check, lvl_x
string lvs_model_name, lvs_item_code, lvs_line_code, lvs_check_time, lvs_worker, lvs_run_no
date   lvdt_check_date

lvdt_check_date         = dp_ymd.datevalue
lvs_worker                = sle_worker.text

lvl_x               = pos( ddlb_model.text, ']', 2 )
lvs_item_code = mid( ddlb_model.text, 2, lvl_x -2)
lvs_check_time = ddlb_check_time.getcode()

if lvs_worker = '' or lvs_worker = '%' or isnull(lvs_worker) then
	Messagebox("$$HEX2$$bdace0ac$$ENDHEX$$", "$$HEX19$$f1b45db8200060d5200091c7c5c590c7200015c8f4bc7cb9200055d678c7200058d538c194c6$$ENDHEX$$")
	sle_worker.setfocus()
	return	
end if

if len( lvs_item_code ) < 9 then
	Messagebox("$$HEX2$$bdace0ac$$ENDHEX$$", "$$HEX18$$f1b45db8200060d5200088d4a9ba200015c8f4bc7cb9200055d678c7200058d538c194c6$$ENDHEX$$")
	ddlb_model.setfocus()
	return	
end if

if lvs_check_time = '' or lvs_check_time = '%' or isnull(lvs_check_time) then
	Messagebox("$$HEX2$$bdace0ac$$ENDHEX$$", "$$HEX6$$f1b45db8200060d5200008cd$$ENDHEX$$/$$HEX1$$11c9$$ENDHEX$$/$$HEX12$$11c920006cad84bd44c7200020c1ddd0200058d538c194c6$$ENDHEX$$")
	ddlb_check_time.setfocus()
	return	
end if



// model $$HEX7$$15c8f4bc7cb920006cad5cd5e4b2$$ENDHEX$$
select inspect_group_desc
   into  :lvs_model_name
  from IQC_INSPECTION_TEMPLATE
 where inspect_group   = :lvs_item_code
     and organization_id = :GVI_ORGANIZATION_ID
	 and rownum          = 1;
	
// SQL $$HEX8$$e4c289d5b0acfcac200055d678c70900$$ENDHEX$$
lvl_sql_check = F_SQL_CHECK()	

IF  lvl_sql_check < 0 THEN 
	
	ddlb_model.setfocus()
	RETURN 
	
ELSEIF lvl_sql_check = 100 then
	
	Messagebox("$$HEX2$$bdace0ac$$ENDHEX$$", "$$HEX11$$80acacc06dd5a9ba2000f8bb2000f1b45db8200008cd$$ENDHEX$$/$$HEX1$$11c9$$ENDHEX$$/$$HEX10$$85c8200088d4a9ba54cfdcb4200085c7c8b2e4b2$$ENDHEX$$")
	ddlb_model.setfocus()
	return
	
ELSE
	
	lvs_line_code = '*'
    lvs_run_no = lvs_item_code

    dw_1.retrieve( gvi_organization_id, lvs_line_code, lvs_run_no, lvs_item_code, lvdt_check_date, lvs_check_time ) 

END IF  



end event

type cb_save from commandbutton within w_qc_inspect_time_check2
integer x = 3973
integer y = 220
integer width = 489
integer height = 184
integer taborder = 70
boolean bringtotop = true
integer textsize = -15
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "$$HEX2$$00c8a5c7$$ENDHEX$$"
end type

event clicked;
 wf_save_timecheck()
end event

type cb_close from commandbutton within w_qc_inspect_time_check2
integer x = 4494
integer y = 220
integer width = 489
integer height = 184
integer taborder = 80
boolean bringtotop = true
integer textsize = -15
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "$$HEX2$$85c8ccb8$$ENDHEX$$"
end type

event clicked;
close(parent)
end event

