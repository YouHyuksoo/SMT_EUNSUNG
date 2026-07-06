HA$PBExportHeader$w_des_bom_confirm_master.srw
$PBExportComments$BOM$$HEX2$$00adacb9$$ENDHEX$$
forward
global type w_des_bom_confirm_master from w_main_root
end type
type st_17 from so_statictext within w_des_bom_confirm_master
end type
type ddlb_work_no from uo_bom_workno within w_des_bom_confirm_master
end type
type cb_2 from so_commandbutton within w_des_bom_confirm_master
end type
type st_16 from so_statictext within w_des_bom_confirm_master
end type
type uo_set_item from uo_set_item_code within w_des_bom_confirm_master
end type
type rb_bom from so_radiobutton within w_des_bom_confirm_master
end type
type rb_rawbom from so_radiobutton within w_des_bom_confirm_master
end type
type uo_start from uo_ymd_calendar within w_des_bom_confirm_master
end type
type st_1 from so_statictext within w_des_bom_confirm_master
end type
type st_2 from so_statictext within w_des_bom_confirm_master
end type
type pb_3 from so_commandbutton within w_des_bom_confirm_master
end type
type pb_1 from so_commandbutton within w_des_bom_confirm_master
end type
type gb_where_condition from so_groupbox within w_des_bom_confirm_master
end type
type gb_1 from so_groupbox within w_des_bom_confirm_master
end type
type gb_2 from so_groupbox within w_des_bom_confirm_master
end type
end forward

global type w_des_bom_confirm_master from w_main_root
integer width = 5403
integer height = 2980
string title = "ENG Bom Confirm"
st_17 st_17
ddlb_work_no ddlb_work_no
cb_2 cb_2
st_16 st_16
uo_set_item uo_set_item
rb_bom rb_bom
rb_rawbom rb_rawbom
uo_start uo_start
st_1 st_1
st_2 st_2
pb_3 pb_3
pb_1 pb_1
gb_where_condition gb_where_condition
gb_1 gb_1
gb_2 gb_2
end type
global w_des_bom_confirm_master w_des_bom_confirm_master

on w_des_bom_confirm_master.create
int iCurrent
call super::create
this.st_17=create st_17
this.ddlb_work_no=create ddlb_work_no
this.cb_2=create cb_2
this.st_16=create st_16
this.uo_set_item=create uo_set_item
this.rb_bom=create rb_bom
this.rb_rawbom=create rb_rawbom
this.uo_start=create uo_start
this.st_1=create st_1
this.st_2=create st_2
this.pb_3=create pb_3
this.pb_1=create pb_1
this.gb_where_condition=create gb_where_condition
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_17
this.Control[iCurrent+2]=this.ddlb_work_no
this.Control[iCurrent+3]=this.cb_2
this.Control[iCurrent+4]=this.st_16
this.Control[iCurrent+5]=this.uo_set_item
this.Control[iCurrent+6]=this.rb_bom
this.Control[iCurrent+7]=this.rb_rawbom
this.Control[iCurrent+8]=this.uo_start
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.st_2
this.Control[iCurrent+11]=this.pb_3
this.Control[iCurrent+12]=this.pb_1
this.Control[iCurrent+13]=this.gb_where_condition
this.Control[iCurrent+14]=this.gb_1
this.Control[iCurrent+15]=this.gb_2
end on

on w_des_bom_confirm_master.destroy
call super::destroy
destroy(this.st_17)
destroy(this.ddlb_work_no)
destroy(this.cb_2)
destroy(this.st_16)
destroy(this.uo_set_item)
destroy(this.rb_bom)
destroy(this.rb_rawbom)
destroy(this.uo_start)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.pb_3)
destroy(this.pb_1)
destroy(this.gb_where_condition)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event activate;call super::activate;/***************************************
* $$HEX17$$08c7c4b324c115c8d0c5200000ad5cd52000acc06dd544c720004bc105d35cd5e4b2$$ENDHEX$$
*
*
****************************************/
Gst_set.window_id            = this.classname() 
Gst_set.author                  = "JiSheng"
Gst_set.creation_date      = '20051101'
Gst_set.last_modify_date = '20051101'
Gst_set.Report_window    = False  // Report Window  True / Flase

/*****************************************
* Data WIndow Property
******************************************/
Ivs_resize_type    = 'NORMAL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default

ivs_dw_1_deleteselected_yn = 'Y'

/****************************************
* Menu Property $$HEX6$$54ba74b2200078d5e4b4c1b9$$ENDHEX$$
*****************************************
* ADMIN     : ADMIN  ( $$HEX5$$04c8b4ccacc0a9c62000$$ENDHEX$$)
* $$HEX8$$00adacb9200020002000200020002000$$ENDHEX$$: MANAGE ( $$HEX8$$04c854ba74b2acc0a9c600aca5b22000$$ENDHEX$$)
* $$HEX7$$acc0a9c690c72000200020002000$$ENDHEX$$: GUEST  ( $$HEX11$$30ae08cd2000f1b45db8200070c88cd6200000aca5b2$$ENDHEX$$)
* $$HEX8$$70c88cd6200020002000200020002000$$ENDHEX$$: QUERY  ( $$HEX10$$15c8f4bc70c88cd6ccb9200000aca5b220002000$$ENDHEX$$)
* $$HEX5$$70b374c7c0d070c891c7$$ENDHEX$$: DATA_CONTROL  ( $$HEX12$$85c725b8200018c215c82000adc01cc8200024c115c82000$$ENDHEX$$)
* $$HEX7$$08b8ecd3b8d22000200020002000$$ENDHEX$$: REPORT ( $$HEX4$$08b8ecd3b8d22000$$ENDHEX$$, $$HEX5$$9ccd25b800adacb92000$$ENDHEX$$)
****************************************/

F_MENU_CONTROL('DATA_CONTROL' , FALSE)  // All Data Control

/****************************************
* 
****************************************/

end event

event ue_data_control;call super::ue_data_control;Long ROW
INT I 
DOUBLE LVI_CHECK

CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		
		  IF RB_BOM.CHECKED = TRUE THEN 
			
			dw_1.reset()
			dw_2.reset()			
			DW_1.RETRIEVE( DOUBLE(DDLB_WORK_NO.TEXT()) , UO_SET_ITEM.TEXT() , UO_START.TEXT() , GVI_ORGANIZATION_ID )
//			dw_1.retrieve( DOUBLE(DDLB_WORK_NO.TEXT())   ,gvi_organization_id)
			ROLLBACK ;  
		ELSE
			DW_3.RETRIEVE( DOUBLE(DDLB_WORK_NO.TEXT()) , UO_SET_ITEM.TEXT()+'%' , GVI_ORGANIZATION_ID )				
		END IF
			
	CASE 'INSERT'
		
	
	CASE 'APPEND'
		
	
	CASE 'DELETE'
		
	
			
	CASE 'UPDATE'
		
			 
	CASE ELSE
END CHOOSE
end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

type dw_5 from w_main_root`dw_5 within w_des_bom_confirm_master
integer y = 320
end type

type dw_4 from w_main_root`dw_4 within w_des_bom_confirm_master
integer y = 320
end type

type dw_3 from w_main_root`dw_3 within w_des_bom_confirm_master
integer y = 296
integer width = 4498
integer height = 1600
boolean titlebar = true
string title = "Raw Bom Manage"
string dataobject = "d_des_raw_bom_workspace_query"
end type

event dw_3::doubleclicked;call super::doubleclicked;if row = 0  then return

if THIS.OBJECT.NEW_BOM_YN[row] = 'N' THEN return

DW_2.RETRIEVE( DW_3.GETITEMSTRING( DW_3.GETROW() , 'ROWID'  ))
	

end event

type dw_2 from w_main_root`dw_2 within w_des_bom_confirm_master
integer y = 296
integer width = 4498
integer height = 628
end type

type dw_1 from w_main_root`dw_1 within w_des_bom_confirm_master
integer y = 300
integer width = 4498
integer height = 2268
boolean titlebar = true
string title = "BOM Manage"
string dataobject = "d_des_bom_workspace_query"
end type

event dw_1::doubleclicked;call super::doubleclicked;if row = 0  then return

if THIS.OBJECT.NEW_BOM_YN[row] = 'N' THEN return

DW_2.RESET( )
DW_2.RETRIEVE( DW_1.GETITEMSTRING( DW_1.GETROW() , 'ROWIDS'  ))
	

end event

type uo_tabpages from w_main_root`uo_tabpages within w_des_bom_confirm_master
end type

type st_17 from so_statictext within w_des_bom_confirm_master
integer x = 690
integer y = 84
integer width = 603
integer height = 68
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Bom Work No"
end type

type ddlb_work_no from uo_bom_workno within w_des_bom_confirm_master
integer x = 681
integer y = 152
integer width = 608
integer height = 1348
integer taborder = 20
boolean bringtotop = true
boolean allowedit = true
end type

event selectionchanged;call super::selectionchanged;STRING LVS_SET_ITEM_CODE

IF THIS.TEXT = '%' THEN 
	RETURN
END IF

SELECT DISTINCT ITEM_CODE
    INTO :LVS_SET_ITEM_CODE
  FROM ID_ENG_BOM_WORKSPACE
 WHERE BOM_WORK_NO     = :THIS.TEXT
   AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
	
IF F_SQL_CHECK() < 0 THEN 
   RETURN 	
END IF

IF LVS_SET_ITEM_CODE ='' OR ISNULL(LVS_SET_ITEM_CODE) THEN 
	RETURN
END IF

UO_SET_ITEM.SETTEXT( LVS_SET_ITEM_CODE ) ;
end event

type cb_2 from so_commandbutton within w_des_bom_confirm_master
integer x = 2903
integer y = 84
integer height = 160
integer taborder = 40
boolean bringtotop = true
string text = "Translation"
end type

event clicked;IF F_OBJECT_ROLE_CHECK() = FALSE THEN  RETURN
LONG     LVL_COUNT 
DOUBLE LVL_WORK_NO
STRING LVS_ITEM_CODE

LVL_WORK_NO    =  DOUBLE(DDLB_WORK_NO.TEXT())

if  LVL_WORK_NO = 0 or isnull(LVL_WORK_NO) then 
	return
end if
//=============================================
//
//=============================================

LVS_ITEM_CODE = UO_SET_ITEM.TEXT()

   SELECT COUNT(*) 
	  INTO :LVL_COUNT 
	 FROM ID_ENG_BOM_WORKSPACE
    WHERE BOM_WORK_NO         = :LVL_WORK_NO
		AND ITEM_CODE              = :LVS_ITEM_CODE
		AND ORGANIZATION_ID    = :GVI_ORGANIZATION_ID 
		AND NEW_BOM_YN = 'Y'  ;

IF F_SQL_CHECK() < 0 THEN 
	RETURN
END IF

IF LVL_COUNT > 0 THEN 
	
ELSE
	  F_MSG_ST( 117 ) // $$HEX9$$90c7ccb800ac2000c6c5b5c2c8b2e4b22000$$ENDHEX$$
	  RETURN 
END IF

MSG = F_MSGBOX(9083) //$$HEX3$$e0c2dcad2000$$ENDHEX$$BOM $$HEX8$$44c7200055d615c860d54cae94c62000$$ENDHEX$$?
IF MSG = 1 THEN 
ELSE
	RETURN 
END IF 

//========================================
//
//========================================

LONG LVL_RETURN
LVL_RETURN = SQLCA.BOM_TRANSLATION( DOUBLE(DDLB_WORK_NO.TEXT()) , LVS_ITEM_CODE , GVI_ORGANIZATION_ID  )

IF F_SQL_CHECK() < 0 THEN 
   RETURN
END IF

//=======================================
//
//=======================================

MSG =F_MSGBOX1(9084, STRING(LVL_RETURN) )
IF MSG = 1 THEN 
	COMMIT;
	F_MSG_ST(170)	
	DW_1.RESET ()
ELSE
	ROLLBACK ;
	return
END IF

ddlb_work_no.redraw( )
end event

type st_16 from so_statictext within w_des_bom_confirm_master
integer x = 1294
integer y = 84
integer width = 526
integer height = 68
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Set Item Code"
end type

type uo_set_item from uo_set_item_code within w_des_bom_confirm_master
integer x = 1294
integer y = 152
integer width = 1102
integer height = 84
integer taborder = 100
boolean bringtotop = true
borderstyle borderstyle = styleraised!
end type

on uo_set_item.destroy
call uo_set_item_code::destroy
end on

type rb_bom from so_radiobutton within w_des_bom_confirm_master
integer x = 55
integer y = 88
integer width = 512
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "BOM"
boolean checked = true
end type

event clicked;dw_1.bringtotop = true 
selected_data_window = dw_1
end event

type rb_rawbom from so_radiobutton within w_des_bom_confirm_master
integer x = 50
integer y = 180
integer width = 526
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "Raw BOM (Temp)"
end type

event clicked;dw_3.bringtotop = true 
selected_data_window = dw_3

end event

type uo_start from uo_ymd_calendar within w_des_bom_confirm_master
integer x = 2405
integer y = 152
integer width = 402
integer taborder = 100
boolean bringtotop = true
end type

on uo_start.destroy
call uo_ymd_calendar::destroy
end on

type st_1 from so_statictext within w_des_bom_confirm_master
integer x = 2405
integer y = 84
integer width = 393
integer height = 68
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Dateset"
end type

type st_2 from so_statictext within w_des_bom_confirm_master
integer x = 1824
integer y = 84
integer width = 576
integer height = 68
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Item Name"
end type

type pb_3 from so_commandbutton within w_des_bom_confirm_master
integer x = 3406
integer y = 84
integer height = 160
integer taborder = 40
boolean bringtotop = true
string text = "Show Mold"
end type

event clicked;call super::clicked;open(w_mcn_mold_popup)	


end event

type pb_1 from so_commandbutton within w_des_bom_confirm_master
integer x = 3927
integer y = 84
integer height = 160
integer taborder = 50
boolean bringtotop = true
string text = "Delete All"
end type

event clicked;call super::clicked;IF F_OBJECT_ROLE_CHECK() = FALSE THEN  RETURN

string lvs_parent_item_code 
double lvd_bom_work_no
long lvl_row

lvd_bom_work_no = double(ddlb_work_no.text)
lvl_row = dw_1.rowcount( )

if ddlb_work_no.text = '%' OR ISNULL(lvd_bom_work_no)or ddlb_work_no.text='' then
	f_msgbox1(102 , F_GET_DUAL_LANG_TEXT( gvs_language ,  " BOM WORK NO"))
	Return
end if 

if dw_1.accepttext( ) <0 then return
		
if dw_1.rowcount() < 1 then return

    if f_msgbox(1003) = 1 then
		if dw_1.getrow() <0 then
			return
		else
			  DELETE FROM ID_ENG_BOM_WORKSPACE
			            WHERE BOM_WORK_NO = :LVD_BOM_WORK_NO
				            AND  ORGANIZATION_ID = :GVI_ORganization_id ;
		 end if
     else
		  return
	end if

 if f_sql_check() < 0 then
	return
end if


msg=f_msgbox1(1004 , string(lvl_row)) 

if msg = 1 then
	DW_1.RETRIEVE( DOUBLE(DDLB_WORK_NO.TEXT()) , UO_SET_ITEM.TEXT() , UO_START.TEXT() , GVI_ORGANIZATION_ID )
	commit;
else
	rollback;
	return
end if

 

end event

type gb_where_condition from so_groupbox within w_des_bom_confirm_master
integer x = 631
integer y = 4
integer width = 2203
integer height = 296
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_1 from so_groupbox within w_des_bom_confirm_master
integer x = 2848
integer width = 1650
integer height = 296
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_2 from so_groupbox within w_des_bom_confirm_master
integer width = 622
integer height = 296
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

