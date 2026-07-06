HA$PBExportHeader$w_qc_4m_history_rpt.srw
$PBExportComments$new a led project
forward
global type w_qc_4m_history_rpt from w_main_root
end type
type st_4 from statictext within w_qc_4m_history_rpt
end type
type sle_pcb_serial_no from so_singlelineedit within w_qc_4m_history_rpt
end type
type st_2 from statictext within w_qc_4m_history_rpt
end type
type ddlb_model_name from so_singlelineedit within w_qc_4m_history_rpt
end type
type st_1 from statictext within w_qc_4m_history_rpt
end type
type sle_suffix from so_singlelineedit within w_qc_4m_history_rpt
end type
type gb_1 from so_groupbox within w_qc_4m_history_rpt
end type
end forward

global type w_qc_4m_history_rpt from w_main_root
string title = "4M Change History"
st_4 st_4
sle_pcb_serial_no sle_pcb_serial_no
st_2 st_2
ddlb_model_name ddlb_model_name
st_1 st_1
sle_suffix sle_suffix
gb_1 gb_1
end type
global w_qc_4m_history_rpt w_qc_4m_history_rpt

type variables

end variables

on w_qc_4m_history_rpt.create
int iCurrent
call super::create
this.st_4=create st_4
this.sle_pcb_serial_no=create sle_pcb_serial_no
this.st_2=create st_2
this.ddlb_model_name=create ddlb_model_name
this.st_1=create st_1
this.sle_suffix=create sle_suffix
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_4
this.Control[iCurrent+2]=this.sle_pcb_serial_no
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.ddlb_model_name
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.sle_suffix
this.Control[iCurrent+7]=this.gb_1
end on

on w_qc_4m_history_rpt.destroy
call super::destroy
destroy(this.st_4)
destroy(this.sle_pcb_serial_no)
destroy(this.st_2)
destroy(this.ddlb_model_name)
destroy(this.st_1)
destroy(this.sle_suffix)
destroy(this.gb_1)
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
Ivs_resize_type                      = 'NORMAL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
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
end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())


end event

event ue_data_control;call super::ue_data_control;STRING LS_Suffix

LS_Suffix = sle_Suffix.text

if LS_Suffix = '' then
	LS_Suffix = '%'
end if

timer(3)

CHOOSE CASE Gvs_Ue_DATA_control
		
	CASE 'RETRIEVE'
		
		   f_set_column_dddw( dw_1 )
		   f_dual_lang_change_dwtext( dw_1 )
			
			sle_pcb_serial_no.triggerevent(modified!)
	
			DW_1.RETRIEVE( ddlb_model_name.text , GVI_ORGANIZATION_ID , LS_Suffix)
				
			if DW_1.Describe("DataWindow.Print.Preview") = '!' or &
				DW_1.Describe("DataWindow.Print.Preview") = '?' then
			else
				DW_1.Modify("DataWindow.Print.Preview=yes")
				DW_1.Modify("DataWindow.Print.Preview.Rulers=yes")
			end if

		  

	CASE ELSE
END CHOOSE
end event

type dw_5 from w_main_root`dw_5 within w_qc_4m_history_rpt
integer y = 420
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_qc_4m_history_rpt
integer y = 420
integer taborder = 0
boolean titlebar = true
end type

type dw_3 from w_main_root`dw_3 within w_qc_4m_history_rpt
integer y = 420
integer taborder = 0
boolean titlebar = true
boolean controlmenu = true
boolean minbox = true
end type

type dw_2 from w_main_root`dw_2 within w_qc_4m_history_rpt
integer y = 404
integer width = 2478
integer height = 1356
integer taborder = 0
boolean titlebar = true
string title = "Item"
boolean controlmenu = true
boolean minbox = true
end type

type dw_1 from w_main_root`dw_1 within w_qc_4m_history_rpt
integer y = 404
integer width = 4466
integer height = 1356
integer taborder = 0
boolean titlebar = true
string title = "4M History"
string dataobject = "d_qc_4m_history_rpt"
boolean controlmenu = true
boolean minbox = true
end type

type uo_tabpages from w_main_root`uo_tabpages within w_qc_4m_history_rpt
integer taborder = 0
end type

type st_4 from statictext within w_qc_4m_history_rpt
integer x = 786
integer y = 124
integer width = 681
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Model Name"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_pcb_serial_no from so_singlelineedit within w_qc_4m_history_rpt
integer x = 101
integer y = 204
integer width = 681
integer taborder = 50
boolean bringtotop = true
textcase textcase = upper!
end type

event getfocus;call super::getfocus;this.selecttext( 1,30)
end event

event modified;call super::modified;string lvs_serial_no ,  lvs_line_code , lvs_bad_reason_code , lvs_workstage_code , lvs_item_code , lvs_model_name, lvs_suffix
long lvl_sequence , ll_row
		
lvs_serial_no = this.text 
//==============================================
// $$HEX18$$a4c294ce2000c8b9a4c230d15cb8200080bd45d1200015c8f4bc200000ac38c834c62000$$ENDHEX$$
//==============================================
//SELECT  DISTINCT  MODEL ,  ITEM_CODE  , LOCATION , BUYER
//   INTO :lvs_model_name , :lvs_item_code ,   :lvs_workstage_code , :lvs_suffix
//FROM TB_VIS_PID_ISSUE_HIST
//WHERE PRODUCT_ID = :lvs_serial_no ;

select model_name, item_code, workstage_code, model_suffix 
  INTO :lvs_model_name , :lvs_item_code ,   :lvs_workstage_code , :lvs_suffix
  from ip_product_2d_barcode 
 where serial_no = :lvs_serial_no ; 

	IF F_SQL_CHECK() < 0 THEN 
		RETURN 
	END IF 
	
IF lvs_model_name = '' OR ISNULL(lvs_model_name) THEN 
		//mess agebox("Notify" , "Not Found PID Information")
		f_msg(  "Not Found PID Information" , 'P' ) 
		return 
//ELSE
//
//	SELECT MODEL_NAME
//	    INTO :LVS_MODEL_NAME 
//	   FROM ID_ITEM 
//	WHERE ITEM_CODE = :lvs_item_code
//	     AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
//		  
//	IF F_SQL_CHECK() < 0 THEN 
//		RETURN 
//	END IF 
	
END IF 




ddlb_model_name.text = LVS_MODEL_NAME
sle_suffix.text = lvs_suffix

//
//
//			f_set_column_dddw( dw_1 )
//		   f_dual_lang_change_dwtext( dw_1 )
//	
//			DW_1.RETRIEVE( ddlb_model_name.text , GVI_ORGANIZATION_ID , lvs_suffix)
//				
//			if DW_1.Describe("DataWindow.Print.Preview") = '!' or &
//				DW_1.Describe("DataWindow.Print.Preview") = '?' then
//			else
//				DW_1.Modify("DataWindow.Print.Preview=yes")
//				DW_1.Modify("DataWindow.Print.Preview.Rulers=yes")
//			end if
//


		
end event

type st_2 from statictext within w_qc_4m_history_rpt
integer x = 101
integer y = 124
integer width = 681
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "PCB Serial No"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_model_name from so_singlelineedit within w_qc_4m_history_rpt
integer x = 791
integer y = 204
integer width = 681
integer taborder = 60
boolean bringtotop = true
textcase textcase = upper!
end type

type st_1 from statictext within w_qc_4m_history_rpt
integer x = 1481
integer y = 124
integer width = 681
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Suffix"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_suffix from so_singlelineedit within w_qc_4m_history_rpt
integer x = 1481
integer y = 204
integer width = 681
integer taborder = 50
boolean bringtotop = true
textcase textcase = upper!
end type

event getfocus;call super::getfocus;this.selecttext( 1,30)
end event

type gb_1 from so_groupbox within w_qc_4m_history_rpt
integer width = 2231
integer height = 384
integer taborder = 40
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

