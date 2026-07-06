HA$PBExportHeader$w_mcn_jig_pm_result_popup.srw
forward
global type w_mcn_jig_pm_result_popup from w_popup_root
end type
type gb_3 from so_groupbox within w_mcn_jig_pm_result_popup
end type
type gb_2 from so_groupbox within w_mcn_jig_pm_result_popup
end type
type cb_retrieve from so_commandbutton within w_mcn_jig_pm_result_popup
end type
type st_1 from so_statictext within w_mcn_jig_pm_result_popup
end type
type sle_jig_code from so_singlelineedit within w_mcn_jig_pm_result_popup
end type
type sle_weeks from so_singlelineedit within w_mcn_jig_pm_result_popup
end type
type st_2 from so_statictext within w_mcn_jig_pm_result_popup
end type
type pb_create from so_commandbutton within w_mcn_jig_pm_result_popup
end type
type pb_save from so_commandbutton within w_mcn_jig_pm_result_popup
end type
type pb_3 from so_commandbutton within w_mcn_jig_pm_result_popup
end type
type pb_4 from so_commandbutton within w_mcn_jig_pm_result_popup
end type
type sle_jig_type from so_singlelineedit within w_mcn_jig_pm_result_popup
end type
type st_3 from so_statictext within w_mcn_jig_pm_result_popup
end type
end forward

shared variables

end variables

global type w_mcn_jig_pm_result_popup from w_popup_root
integer width = 3995
integer height = 2280
string title = "Machine Master Popup"
gb_3 gb_3
gb_2 gb_2
cb_retrieve cb_retrieve
st_1 st_1
sle_jig_code sle_jig_code
sle_weeks sle_weeks
st_2 st_2
pb_create pb_create
pb_save pb_save
pb_3 pb_3
pb_4 pb_4
sle_jig_type sle_jig_type
st_3 st_3
end type
global w_mcn_jig_pm_result_popup w_mcn_jig_pm_result_popup

on w_mcn_jig_pm_result_popup.create
int iCurrent
call super::create
this.gb_3=create gb_3
this.gb_2=create gb_2
this.cb_retrieve=create cb_retrieve
this.st_1=create st_1
this.sle_jig_code=create sle_jig_code
this.sle_weeks=create sle_weeks
this.st_2=create st_2
this.pb_create=create pb_create
this.pb_save=create pb_save
this.pb_3=create pb_3
this.pb_4=create pb_4
this.sle_jig_type=create sle_jig_type
this.st_3=create st_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_3
this.Control[iCurrent+2]=this.gb_2
this.Control[iCurrent+3]=this.cb_retrieve
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.sle_jig_code
this.Control[iCurrent+6]=this.sle_weeks
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.pb_create
this.Control[iCurrent+9]=this.pb_save
this.Control[iCurrent+10]=this.pb_3
this.Control[iCurrent+11]=this.pb_4
this.Control[iCurrent+12]=this.sle_jig_type
this.Control[iCurrent+13]=this.st_3
end on

on w_mcn_jig_pm_result_popup.destroy
call super::destroy
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.cb_retrieve)
destroy(this.st_1)
destroy(this.sle_jig_code)
destroy(this.sle_weeks)
destroy(this.st_2)
destroy(this.pb_create)
destroy(this.pb_save)
destroy(this.pb_3)
destroy(this.pb_4)
destroy(this.sle_jig_type)
destroy(this.st_3)
end on

event open;call super::open;//===============================
//
//===============================
dw_1.settransobject(sqlca)

sle_weeks.text = message.stringparm
sle_jig_code.text =  Gst_return.gvs_return[1] 
sle_jig_type.text = Gst_return.gvs_return[2] //$$HEX5$$24c144be20c715d62000$$ENDHEX$$

cb_retrieve.triggerevent(CLICKED!)


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

type p_title from w_popup_root`p_title within w_mcn_jig_pm_result_popup
integer width = 3995
end type

type cb_sort from w_popup_root`cb_sort within w_mcn_jig_pm_result_popup
boolean visible = true
integer x = 1911
integer y = 308
integer height = 160
end type

type cb_close from w_popup_root`cb_close within w_mcn_jig_pm_result_popup
boolean visible = true
integer x = 3666
integer y = 308
integer height = 160
end type

event cb_close::clicked;call super::clicked;Gst_return.gvb_return = FALSE
end event

type st_msg from w_popup_root`st_msg within w_mcn_jig_pm_result_popup
boolean visible = true
integer y = 544
integer width = 3995
end type

type dw_1 from w_popup_root`dw_1 within w_mcn_jig_pm_result_popup
boolean visible = true
integer y = 644
integer width = 3995
integer height = 1552
boolean titlebar = true
string dataobject = "d_mcn_machine_pm_result_popup"
boolean maxbox = true
end type

type dw_2 from w_popup_root`dw_2 within w_mcn_jig_pm_result_popup
boolean visible = true
integer y = 644
integer width = 503
integer height = 396
boolean titlebar = true
boolean maxbox = true
end type

type dw_3 from w_popup_root`dw_3 within w_mcn_jig_pm_result_popup
boolean visible = true
integer y = 644
integer width = 503
integer height = 396
boolean titlebar = true
boolean maxbox = true
end type

type gb_3 from so_groupbox within w_mcn_jig_pm_result_popup
integer x = 1861
integer y = 196
integer width = 2107
integer height = 328
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_2 from so_groupbox within w_mcn_jig_pm_result_popup
integer x = 5
integer y = 204
integer width = 1326
integer height = 328
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type cb_retrieve from so_commandbutton within w_mcn_jig_pm_result_popup
integer x = 2190
integer y = 308
integer width = 274
integer height = 160
integer taborder = 70
boolean bringtotop = true
string text = "Retrieve"
end type

event clicked;DW_1.RETRIEVE(   sle_jig_code.text, sle_weeks.TEXT , gvs_language ,  GVI_ORGANIZATION_ID )

if dw_1.rowcount( ) = 0 then 
	pb_create.triggerevent(clicked!)
end if 
end event

type st_1 from so_statictext within w_mcn_jig_pm_result_popup
integer x = 27
integer y = 308
integer width = 526
boolean bringtotop = true
integer weight = 700
string text = "JIG Code"
end type

type sle_jig_code from so_singlelineedit within w_mcn_jig_pm_result_popup
integer x = 27
integer y = 388
integer width = 526
integer taborder = 30
boolean bringtotop = true
end type

type sle_weeks from so_singlelineedit within w_mcn_jig_pm_result_popup
integer x = 558
integer y = 388
integer width = 347
integer taborder = 40
boolean bringtotop = true
end type

type st_2 from so_statictext within w_mcn_jig_pm_result_popup
integer x = 558
integer y = 304
integer width = 347
boolean bringtotop = true
integer weight = 700
string text = "Weeks"
end type

type pb_create from so_commandbutton within w_mcn_jig_pm_result_popup
integer x = 2469
integer y = 308
integer width = 274
integer height = 160
integer taborder = 80
boolean bringtotop = true
string text = "Create"
end type

event clicked;call super::clicked;msg = f_msgbox1(1161 , this.text ) 
if msg = 1 then 
else
	return
end if 

string lvs_plan_yyyy , lvs_plan_weeks , lvs_jig_code , lvs_jig_type
lvs_jig_code = sle_jig_code.text
lvs_plan_yyyy = mid(sle_weeks.text,1,4)
lvs_plan_weeks = mid(sle_weeks.text,5,2)
lvs_jig_type = sle_jig_type.text

  INSERT INTO IMCN_JIG_WEEKLY_PM_RESULT  
         ( PLAN_YYYY,   
           PLAN_WEEKS,   
           JIG_CODE,   
           TPM_SEQUENCE,   
           ORGANIZATION_ID,   
           CODE_TYPE,   
           CODE_GROUP,   
           CODE_GROUP_SECOND,   
           CODE_GROUP_THIRD,   
           CODE_NAME,   
           TPM_RESULT,   
           TPM_COMMENTS,   
           TPM_DATE,   
           ENTER_BY,   
           ENTER_DATE,   
           LAST_MODIFY_BY,   
           LAST_MODIFY_DATE )  
SELECT :LVS_PLAN_YYYY,   
           :LVS_PLAN_WEEKS,   
           :LVS_JIG_CODE,   
           ROWNUM , //TPM_SEQUENCE,   
           ORGANIZATION_ID,   
           CODE_TYPE,   
           CODE_GROUP,   
           CODE_GROUP_SECOND,   
           CODE_GROUP_THIRD,   
           CODE_NAME,   
           'N' TPM_RESULT,   
           '' TPM_COMMENTS,   
           TRUNC(SYSDATE),   
           ENTER_BY,   
           SYSDATE,   
           LAST_MODIFY_BY,   
           SYSDATE 
 FROM ISYS_CODE_MASTER
WHERE CODE_TYPE = 'JIG TPM CODE'
    AND CODE_GROUP IN ( 'COM' , :lvs_jig_type)
    AND ORGANIZATION_ID = :Gvi_organization_id
    AND ( 	:LVS_PLAN_YYYY,  :LVS_PLAN_WEEKS,  :LVS_JIG_CODE, CODE_TYPE ,  CODE_GROUP  , CODE_GROUP_SECOND , CODE_GROUP_THIRD , ORGANIZATION_ID )
	NOT IN ( SELECT PLAN_YYYY , TRIM(TO_CHAR(PLAN_WEEKS,'00')) , JIG_CODE , CODE_TYPE ,  CODE_GROUP  , CODE_GROUP_SECOND , CODE_GROUP_THIRD , ORGANIZATION_ID
	               FROM IMCN_JIG_WEEKLY_PM_RESULT
                  WHERE CODE_TYPE = 'JIG TPM CODE'
  					AND CODE_GROUP IN ( 'COM' , :lvs_jig_type )
				    AND ORGANIZATION_ID = :Gvi_organization_id					
	            )
	;
	
if f_sql_check() <	0 then 
	return
end if 

commit ;
cb_retrieve.TRiggerevent( CLICKED!)
end event

type pb_save from so_commandbutton within w_mcn_jig_pm_result_popup
integer x = 2752
integer y = 308
integer width = 274
integer height = 160
integer taborder = 90
boolean bringtotop = true
string text = "Save"
end type

event clicked;call super::clicked;if dw_1.update( ) < 0 then 
   rollback ;
else
	commit ;
	st_msg.text = f_msg_st(170)
end if 
end event

type pb_3 from so_commandbutton within w_mcn_jig_pm_result_popup
integer x = 3031
integer y = 308
integer width = 274
integer height = 160
integer taborder = 100
boolean bringtotop = true
string text = "Ok"
end type

event clicked;call super::clicked;pb_save.triggerevent(clicked!)
Gst_return.gvb_return = true
Close(parent)
end event

type pb_4 from so_commandbutton within w_mcn_jig_pm_result_popup
integer x = 3310
integer y = 308
integer width = 274
integer height = 160
integer taborder = 110
boolean bringtotop = true
string text = "Cancel"
end type

event clicked;call super::clicked;Gst_return.gvb_return = false
Close(parent)
end event

type sle_jig_type from so_singlelineedit within w_mcn_jig_pm_result_popup
integer x = 910
integer y = 388
integer width = 370
integer taborder = 40
boolean bringtotop = true
end type

type st_3 from so_statictext within w_mcn_jig_pm_result_popup
integer x = 910
integer y = 308
integer width = 370
boolean bringtotop = true
integer weight = 700
string text = "JIG Type"
end type

