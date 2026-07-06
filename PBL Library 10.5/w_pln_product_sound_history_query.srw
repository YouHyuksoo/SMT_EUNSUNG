HA$PBExportHeader$w_pln_product_sound_history_query.srw
$PBExportComments$ng sound history management
forward
global type w_pln_product_sound_history_query from w_main_root
end type
type st_5 from so_statictext within w_pln_product_sound_history_query
end type
type st_1 from so_statictext within w_pln_product_sound_history_query
end type
type ddlb_line_code from uo_line_code within w_pln_product_sound_history_query
end type
type st_2 from so_statictext within w_pln_product_sound_history_query
end type
type st_3 from so_statictext within w_pln_product_sound_history_query
end type
type st_4 from so_statictext within w_pln_product_sound_history_query
end type
type ddlb_machine_code from uo_machine_code within w_pln_product_sound_history_query
end type
type ddlb_sound_group from dropdownlistbox within w_pln_product_sound_history_query
end type
type ddlb_sound_status from dropdownlistbox within w_pln_product_sound_history_query
end type
type em_1 from so_editmask within w_pln_product_sound_history_query
end type
type em_2 from so_editmask within w_pln_product_sound_history_query
end type
type cb_5 from so_commandbutton within w_pln_product_sound_history_query
end type
type gb_1 from so_groupbox within w_pln_product_sound_history_query
end type
type gb_2 from so_groupbox within w_pln_product_sound_history_query
end type
end forward

global type w_pln_product_sound_history_query from w_main_root
string title = "Action history for NG Sound"
toolbaralignment toolbaralignment = alignatbottom!
st_5 st_5
st_1 st_1
ddlb_line_code ddlb_line_code
st_2 st_2
st_3 st_3
st_4 st_4
ddlb_machine_code ddlb_machine_code
ddlb_sound_group ddlb_sound_group
ddlb_sound_status ddlb_sound_status
em_1 em_1
em_2 em_2
cb_5 cb_5
gb_1 gb_1
gb_2 gb_2
end type
global w_pln_product_sound_history_query w_pln_product_sound_history_query

on w_pln_product_sound_history_query.create
int iCurrent
call super::create
this.st_5=create st_5
this.st_1=create st_1
this.ddlb_line_code=create ddlb_line_code
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.ddlb_machine_code=create ddlb_machine_code
this.ddlb_sound_group=create ddlb_sound_group
this.ddlb_sound_status=create ddlb_sound_status
this.em_1=create em_1
this.em_2=create em_2
this.cb_5=create cb_5
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_5
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.ddlb_line_code
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.st_4
this.Control[iCurrent+7]=this.ddlb_machine_code
this.Control[iCurrent+8]=this.ddlb_sound_group
this.Control[iCurrent+9]=this.ddlb_sound_status
this.Control[iCurrent+10]=this.em_1
this.Control[iCurrent+11]=this.em_2
this.Control[iCurrent+12]=this.cb_5
this.Control[iCurrent+13]=this.gb_1
this.Control[iCurrent+14]=this.gb_2
end on

on w_pln_product_sound_history_query.destroy
call super::destroy
destroy(this.st_5)
destroy(this.st_1)
destroy(this.ddlb_line_code)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.ddlb_machine_code)
destroy(this.ddlb_sound_group)
destroy(this.ddlb_sound_status)
destroy(this.em_1)
destroy(this.em_2)
destroy(this.cb_5)
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
Ivs_resize_type    = 'MASTER_DETAIL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default

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

F_MENU_CONTROL('DATA_CONTROL' , TRUE)  // All Data Control

/****************************************
* 
****************************************/

end event

event ue_data_control;call super::ue_data_control;Long ROW, lvl_pos
string lvs_str, lvs_sound_group, lvs_sound_status, lvs_machine_code, lvs_line_code


lvs_str = ddlb_sound_group.text
lvl_pos = pos(lvs_str,':')
lvs_sound_group =  left(lvs_str, lvl_pos -2)+'%'

lvs_str = ddlb_sound_status.text
lvl_pos = pos(lvs_str,':')
lvs_sound_status =  left(lvs_str, lvl_pos -2)+'%'

lvs_line_code = ddlb_line_code.getcode()
lvs_machine_code = ddlb_machine_code.getcode()

CHOOSE CASE Gvs_ue_data_control
	CASE 'RETRIEVE'
		
	    DW_1.RETRIEVE(em_1.text , em_2.text, lvs_line_code, lvs_machine_code+'%', lvs_sound_group, lvs_sound_status, GVI_ORGANIZATION_ID)
         DW_1.SETFOCUS()
			
	CASE 'INSERT'
		    DW_2.RESET()
			ROW = dw_2.INSERTROW(dw_2.GETROW())
			F_SET_SECURITY_ROW(dw_2 , ROW , 'NONORG')
			F_MSG_MDI_HELP( F_MSG_ST(152) )			
	CASE 'APPEND'
			DW_2.RESET()
			ROW = dw_2.INSERTROW(0)
			F_SET_SECURITY_ROW(dw_2 , ROW , 'NONORG')	
			F_MSG_MDI_HELP( F_MSG_ST(152) )			
	CASE 'DELETE'
		
		  	IF DW_2.GETROW() < 1 THEN RETURN 
			  
			MSG = F_MSGBOX(1003) 
			IF MSG = 1 THEN
				GVL_ROW_DELETED = DW_2.GETROW()			
				DW_2.DELETEROW(GVL_ROW_DELETED)		
				DW_2.SETFOCUS()
				ROW = DW_2.GETROW()
				DW_2.SCROLLTOROW(ROW)
				DW_2.SETCOLUMN(1)
			END IF
			
			MSG = F_MSGBOX1( 9030 , STRING(1) )
			IF MSG = 1 THEN 
				F_UPDATE()
			END IF
			
	CASE 'UPDATE'
		
			IF dw_2.UPDATE() < 0 THEN
				ROLLBACK;
			ELSE
				COMMIT;
				F_MSG_MDI_HELP( F_MSG_ST(170) )	 //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
			END IF
			
	CASE ELSE
END CHOOSE

end event

event ue_post_open;call super::ue_post_open;
f_child_dw3(dw_1, 'business_category', gvs_language, string(gvi_organization_id), 'BUSINESS CATEGORY')
f_child_dw3(dw_2, 'business_category', gvs_language, string(gvi_organization_id), 'BUSINESS CATEGORY')

/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

type dw_5 from w_main_root`dw_5 within w_pln_product_sound_history_query
integer y = 356
integer width = 695
end type

type dw_4 from w_main_root`dw_4 within w_pln_product_sound_history_query
integer y = 476
integer width = 695
end type

type dw_3 from w_main_root`dw_3 within w_pln_product_sound_history_query
integer y = 476
integer width = 695
end type

type dw_2 from w_main_root`dw_2 within w_pln_product_sound_history_query
integer y = 1652
integer width = 4494
integer height = 1104
string dataobject = "d_pln_product_sound_history_detail"
boolean hscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

type dw_1 from w_main_root`dw_1 within w_pln_product_sound_history_query
integer y = 352
integer width = 4494
integer height = 1288
boolean titlebar = true
string title = "Action history"
string dataobject = "d_pln_product_sound_history_lst"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;IF DW_1.GETROW() > 0 THEN
	DW_2.RETRIEVE( DW_1.GETITEMSTRING( DW_1.GETROW() , 'ROWID' ) )
ELSE
	DW_2.RESET()
END IF


end event

type uo_tabpages from w_main_root`uo_tabpages within w_pln_product_sound_history_query
end type

type st_5 from so_statictext within w_pln_product_sound_history_query
integer x = 443
integer y = 108
integer width = 841
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Production Date"
end type

type st_1 from so_statictext within w_pln_product_sound_history_query
integer x = 1655
integer y = 108
integer width = 631
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Line Code"
end type

type ddlb_line_code from uo_line_code within w_pln_product_sound_history_query
integer x = 1664
integer y = 184
integer width = 599
integer height = 1328
integer taborder = 70
boolean bringtotop = true
long backcolor = 16777215
end type

type st_2 from so_statictext within w_pln_product_sound_history_query
integer x = 2999
integer y = 104
integer width = 809
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Sound Group"
end type

type st_3 from so_statictext within w_pln_product_sound_history_query
integer x = 3739
integer y = 112
integer width = 539
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Sound Status"
boolean disabledlook = true
end type

type st_4 from so_statictext within w_pln_product_sound_history_query
integer x = 2281
integer y = 104
integer width = 837
boolean bringtotop = true
integer weight = 700
string text = "Machine Code"
end type

type ddlb_machine_code from uo_machine_code within w_pln_product_sound_history_query
integer x = 2281
integer y = 184
integer width = 800
integer height = 1324
integer taborder = 30
boolean bringtotop = true
end type

type ddlb_sound_group from dropdownlistbox within w_pln_product_sound_history_query
integer x = 3099
integer y = 184
integer width = 608
integer height = 780
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

event constructor;STRING LVS_code_name , LVS_code_mean_eng

DECLARE CUR_01 CURSOR FOR 
	select code_name, code_mean_eng
	 from ISYS_BASECODE 
   where code_type='SOUND GROUP'
      AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
		 
OPEN CUR_01 ;

	IF F_SQL_CHECK_WITH_MSG('OPEN FROM ISYS_BASECODE') < 0 THEN 
		CLOSE CUR_01 ;
		RETURN
	END IF	

DO 
	FETCH CUR_01 INTO :LVS_code_name , :LVS_code_mean_eng ;
	
	IF F_SQL_CHECK_WITH_MSG('SELECT FROM ISYS_BASECODE') < 0 THEN 
		CLOSE CUR_01 ;
		RETURN
	END IF	
	
	IF SQLCA.SQLCODE = 100 THEN 
		CLOSE CUR_01 ;
		EXIT
	END IF 
	
	LVS_code_name = LVS_code_name + ' : ' + LVS_code_mean_eng
	THIS.ADDITEM(LVS_code_name)
LOOP UNTIL 1 = 2
CLOSE CUR_01;
THIS.ADDITEM('%')
THIS.SELECTITEM(1)

end event

type ddlb_sound_status from dropdownlistbox within w_pln_product_sound_history_query
integer x = 3726
integer y = 184
integer width = 608
integer height = 780
integer taborder = 50
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

event constructor;STRING LVS_code_name , LVS_code_mean_eng

DECLARE CUR_01 CURSOR FOR 
	select code_name, code_mean_eng
	 from ISYS_BASECODE 
   where code_type='SOUND STATUS'
      AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
		 
OPEN CUR_01 ;

	IF F_SQL_CHECK_WITH_MSG('OPEN FROM ISYS_BASECODE') < 0 THEN 
		CLOSE CUR_01 ;
		RETURN
	END IF	

DO 
	FETCH CUR_01 INTO :LVS_code_name , :LVS_code_mean_eng ;
	
	IF F_SQL_CHECK_WITH_MSG('SELECT FROM ISYS_BASECODE') < 0 THEN 
		CLOSE CUR_01 ;
		RETURN
	END IF	
	
	IF SQLCA.SQLCODE = 100 THEN 
		CLOSE CUR_01 ;
		EXIT
	END IF 
	
	LVS_code_name = LVS_code_name + ' : ' + LVS_code_mean_eng
	THIS.ADDITEM(LVS_code_name)
LOOP UNTIL 1 = 2

CLOSE CUR_01;

THIS.ADDITEM('%')
THIS.SELECTITEM(1)

end event

type em_1 from so_editmask within w_pln_product_sound_history_query
integer x = 64
integer y = 184
integer width = 791
integer height = 84
integer taborder = 50
boolean bringtotop = true
string text = ""
alignment alignment = left!
maskdatatype maskdatatype = datetimemask!
string mask = "YYYY-MM-DD HH:MM:SS"
boolean dropdowncalendar = true
end type

event constructor;call super::constructor;this.text =string( f_sysdate())
end event

type em_2 from so_editmask within w_pln_product_sound_history_query
integer x = 859
integer y = 184
integer width = 791
integer height = 84
integer taborder = 60
boolean bringtotop = true
string text = ""
alignment alignment = left!
maskdatatype maskdatatype = datetimemask!
string mask = "YYYY-MM-DD HH:MM:SS"
boolean dropdowncalendar = true
end type

event constructor;call super::constructor;this.text =string( f_sysdate())
end event

type cb_5 from so_commandbutton within w_pln_product_sound_history_query
integer x = 4462
integer y = 168
integer width = 430
integer height = 112
integer taborder = 20
boolean bringtotop = true
string text = "NSNP UnLock"
end type

event clicked;call super::clicked;string lvs_line_code 

lvs_line_code = ddlb_line_code.getcode()

if lvs_line_code <> '%' then

   sqlca.P_INTERLOCK_SET_NSNP_TIME_MSG( lvs_line_code , '0' , 0 ,  '*', '*', 'UNLOCK', gvs_computer_name+'=>FORCE UNLOCK '+gvs_user_name )

   if f_sql_check() < 0 then 
      return 
   end if 
	
   f_msgbox1(107 , this.text ) 

end if
end event

type gb_1 from so_groupbox within w_pln_product_sound_history_query
integer x = 4430
integer width = 503
integer height = 336
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "NSNP"
end type

type gb_2 from so_groupbox within w_pln_product_sound_history_query
integer width = 4407
integer height = 336
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

