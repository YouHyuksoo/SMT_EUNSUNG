HA$PBExportHeader$w_pln_product_nsnp_history_query.srw
$PBExportComments$Line Master
forward
global type w_pln_product_nsnp_history_query from w_main_root
end type
type st_mrm_no from statictext within w_pln_product_nsnp_history_query
end type
type sle_model_name from so_singlelineedit within w_pln_product_nsnp_history_query
end type
type ddlb_line_code from uo_line_code within w_pln_product_nsnp_history_query
end type
type st_3 from statictext within w_pln_product_nsnp_history_query
end type
type st_6 from so_statictext within w_pln_product_nsnp_history_query
end type
type uo_dateset from uo_ymd_calendar within w_pln_product_nsnp_history_query
end type
type uo_dateend from uo_ymd_calendar within w_pln_product_nsnp_history_query
end type
type cb_1 from so_commandbutton within w_pln_product_nsnp_history_query
end type
type cb_2 from so_commandbutton within w_pln_product_nsnp_history_query
end type
type cb_3 from so_commandbutton within w_pln_product_nsnp_history_query
end type
type cb_4 from so_commandbutton within w_pln_product_nsnp_history_query
end type
type cb_5 from so_commandbutton within w_pln_product_nsnp_history_query
end type
type cb_6 from so_commandbutton within w_pln_product_nsnp_history_query
end type
type cb_7 from so_commandbutton within w_pln_product_nsnp_history_query
end type
type gb_1 from so_groupbox within w_pln_product_nsnp_history_query
end type
type gb_2 from so_groupbox within w_pln_product_nsnp_history_query
end type
end forward

global type w_pln_product_nsnp_history_query from w_main_root
integer width = 5294
integer height = 2748
string title = "NSNP Proess History Master"
st_mrm_no st_mrm_no
sle_model_name sle_model_name
ddlb_line_code ddlb_line_code
st_3 st_3
st_6 st_6
uo_dateset uo_dateset
uo_dateend uo_dateend
cb_1 cb_1
cb_2 cb_2
cb_3 cb_3
cb_4 cb_4
cb_5 cb_5
cb_6 cb_6
cb_7 cb_7
gb_1 gb_1
gb_2 gb_2
end type
global w_pln_product_nsnp_history_query w_pln_product_nsnp_history_query

type variables
Long Lvl_row 
String lvs_current_array_type , lvs_last_run_no
String lvs_user_line_code  , lvs_user_machine_code
end variables

on w_pln_product_nsnp_history_query.create
int iCurrent
call super::create
this.st_mrm_no=create st_mrm_no
this.sle_model_name=create sle_model_name
this.ddlb_line_code=create ddlb_line_code
this.st_3=create st_3
this.st_6=create st_6
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.cb_1=create cb_1
this.cb_2=create cb_2
this.cb_3=create cb_3
this.cb_4=create cb_4
this.cb_5=create cb_5
this.cb_6=create cb_6
this.cb_7=create cb_7
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_mrm_no
this.Control[iCurrent+2]=this.sle_model_name
this.Control[iCurrent+3]=this.ddlb_line_code
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_6
this.Control[iCurrent+6]=this.uo_dateset
this.Control[iCurrent+7]=this.uo_dateend
this.Control[iCurrent+8]=this.cb_1
this.Control[iCurrent+9]=this.cb_2
this.Control[iCurrent+10]=this.cb_3
this.Control[iCurrent+11]=this.cb_4
this.Control[iCurrent+12]=this.cb_5
this.Control[iCurrent+13]=this.cb_6
this.Control[iCurrent+14]=this.cb_7
this.Control[iCurrent+15]=this.gb_1
this.Control[iCurrent+16]=this.gb_2
end on

on w_pln_product_nsnp_history_query.destroy
call super::destroy
destroy(this.st_mrm_no)
destroy(this.sle_model_name)
destroy(this.ddlb_line_code)
destroy(this.st_3)
destroy(this.st_6)
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.cb_4)
destroy(this.cb_5)
destroy(this.cb_6)
destroy(this.cb_7)
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
Gst_set.Report_window    = False  // Report Window  True / Flase

/*****************************************
* Data Window Property
******************************************/
Ivs_resize_type                      = 'MASTER_DETAIL_12T'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


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

event ue_data_control;call super::ue_data_control;CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		
			DW_1.RETRIEVE()
		//	DW_2.RETRIEVE( ddlb_line_code.getcode()+'%' ,  SLE_model_name.text+'%' , uo_dateset.text() , uo_dateend.text() , GVI_ORGANIZATION_ID )
	CASE 'UPDATE' 
			DW_1.UPDATE()
			COMMIT ;
	CASE ELSE
	
END CHOOSE
end event

type dw_5 from w_main_root`dw_5 within w_pln_product_nsnp_history_query
integer y = 936
integer height = 1932
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_pln_product_nsnp_history_query
integer y = 936
integer height = 1932
integer taborder = 0
end type

type dw_3 from w_main_root`dw_3 within w_pln_product_nsnp_history_query
integer y = 936
integer width = 736
integer height = 1932
integer taborder = 0
end type

type dw_2 from w_main_root`dw_2 within w_pln_product_nsnp_history_query
integer x = 2597
integer y = 316
integer width = 2656
integer height = 2344
integer taborder = 0
boolean titlebar = true
string dataobject = "d_pln_product_nsnp_history_lst"
end type

type dw_1 from w_main_root`dw_1 within w_pln_product_nsnp_history_query
integer y = 316
integer width = 2587
integer height = 2344
integer taborder = 0
boolean titlebar = true
string title = "Line NSNP Status"
string dataobject = "d_pln_product_line_status_4_nsnp_lst"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 

DW_2.RETRIEVE(this.object.line_code[currentrow] +'%',  SLE_model_name.text+'%' , uo_dateset.text() , uo_dateend.text() , GVI_ORGANIZATION_ID )
end event

type uo_tabpages from w_main_root`uo_tabpages within w_pln_product_nsnp_history_query
integer taborder = 0
end type

type st_mrm_no from statictext within w_pln_product_nsnp_history_query
integer x = 594
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
string text = "Model Name"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_model_name from so_singlelineedit within w_pln_product_nsnp_history_query
integer x = 594
integer y = 172
integer width = 631
integer taborder = 10
boolean bringtotop = true
textcase textcase = upper!
end type

type ddlb_line_code from uo_line_code within w_pln_product_nsnp_history_query
integer x = 59
integer y = 172
integer width = 530
boolean bringtotop = true
long backcolor = 16777215
end type

type st_3 from statictext within w_pln_product_nsnp_history_query
integer x = 64
integer y = 88
integer width = 521
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

type st_6 from so_statictext within w_pln_product_nsnp_history_query
integer x = 1243
integer y = 84
integer width = 814
integer height = 68
boolean bringtotop = true
string text = "Enter Date"
end type

type uo_dateset from uo_ymd_calendar within w_pln_product_nsnp_history_query
integer x = 1243
integer y = 168
integer taborder = 40
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_pln_product_nsnp_history_query
integer x = 1655
integer y = 168
integer taborder = 50
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type cb_1 from so_commandbutton within w_pln_product_nsnp_history_query
integer x = 2254
integer y = 108
integer height = 116
integer taborder = 30
boolean bringtotop = true
string text = "NSNP UnLock"
end type

event clicked;call super::clicked;if dw_1.getrow() < 1 then return 

string lvs_line_code 

//=========================================
// user level $$HEX2$$55d678c7$$ENDHEX$$
//=========================================
IF ( GVI_USER_LEVEL < 8 or isnull(GVI_USER_LEVEL)) THEN
	  
	  messagebox("$$HEX2$$4cc5bcb9$$ENDHEX$$", "$$HEX11$$acc0a9c68cad5cd5200074c72000c6c5b5c2c8b2e4b2$$ENDHEX$$") 
	  return
	  
END IF

//=========================================


lvs_line_code = dw_1.object.line_code[dw_1.getrow()]
sqlca.P_INTERLOCK_SET_NSNP_TIME_MSG( lvs_line_code , '0' , 0 ,  '*', '*', 'UNLOCK', '[$$HEX4$$15ac1cc874d51cc8$$ENDHEX$$]FORCE UNLOCK '+gvs_computer_name+' : '+gvs_user_name )

if f_sql_check() < 0 then 
	return 
end if 

f_msgbox1(107 , this.text ) 

dw_1.retrieve( )
end event

type cb_2 from so_commandbutton within w_pln_product_nsnp_history_query
integer x = 2821
integer y = 108
integer height = 116
integer taborder = 40
boolean bringtotop = true
string text = "NSNP Lock"
end type

event clicked;call super::clicked;if dw_1.getrow() < 1 then return 

string lvs_line_code 


//=========================================
// user level $$HEX2$$55d678c7$$ENDHEX$$
//=========================================
IF ( GVI_USER_LEVEL < 8 or isnull(GVI_USER_LEVEL)) THEN
	  
	  messagebox("$$HEX2$$4cc5bcb9$$ENDHEX$$", "$$HEX11$$acc0a9c68cad5cd5200074c72000c6c5b5c2c8b2e4b2$$ENDHEX$$") 
	  return
	  
END IF

//=========================================


lvs_line_code = dw_1.object.line_code[dw_1.getrow()]
sqlca.P_INTERLOCK_SET_NSNP_TIME_MSG( lvs_line_code , '1' ,1, '*', '*', 'LOCK', '[$$HEX4$$15ac1cc8a0c708ae$$ENDHEX$$] $$HEX13$$15ac1cc85cb82000d9b391c7200018b4c8c5b5c2c8b2e4b22000$$ENDHEX$$=>'+gvs_user_name )
if f_sql_check() < 0 then 
	return 
end if 

f_msgbox1(107 , this.text ) 

dw_1.retrieve( )
end event

type cb_3 from so_commandbutton within w_pln_product_nsnp_history_query
integer x = 3424
integer y = 112
integer height = 116
integer taborder = 50
boolean bringtotop = true
string text = "NSNP Log Reset"
end type

event clicked;call super::clicked;string lvs_line_code


//=========================================
// user level $$HEX2$$55d678c7$$ENDHEX$$
//=========================================
IF ( GVI_USER_LEVEL < 8 or isnull(GVI_USER_LEVEL)) THEN
	  
	  messagebox("$$HEX2$$4cc5bcb9$$ENDHEX$$", "$$HEX11$$acc0a9c68cad5cd5200074c72000c6c5b5c2c8b2e4b2$$ENDHEX$$") 
	  return
	  
END IF

//=========================================

if dw_1.getrow( ) < 1 then return 

msg = f_msgbox1(1161 , this.text )

if msg  =1 then 
else
	return 
end if 


lvs_line_code = dw_1.object.line_code[dw_1.getrow()]
delete from IQ_MACHINE_INSPECT_NSNP where line_code LIKE :lvs_line_code||'%' 
   and organization_id = :gvi_organization_id ;
	
	if f_sql_check() < 0 then 
		return
	end if 
	
	commit ;
end event

type cb_4 from so_commandbutton within w_pln_product_nsnp_history_query
integer x = 4037
integer y = 56
integer height = 112
integer taborder = 80
boolean bringtotop = true
string text = "Use NSNP"
end type

event clicked;call super::clicked;string lvs_line_code

//=========================================
// user level $$HEX2$$55d678c7$$ENDHEX$$
//=========================================
IF ( GVI_USER_LEVEL < 8 or isnull(GVI_USER_LEVEL)) THEN
	  
	  messagebox("$$HEX2$$4cc5bcb9$$ENDHEX$$", "$$HEX11$$acc0a9c68cad5cd5200074c72000c6c5b5c2c8b2e4b2$$ENDHEX$$") 
	  return
	  
END IF

//=========================================

if dw_1.getrow() < 1 then 
	//Messagebox("Notify" , "$$HEX10$$7cb778c744c7200020c1ddd0200058d538c194c6$$ENDHEX$$")
	f_msg("$$HEX10$$7cb778c744c7200020c1ddd0200058d538c194c6$$ENDHEX$$","S")
	return
end if 

lvs_line_code = dw_1.object.line_code[dw_1.getrow()]

update imcn_machine set use_status = 'U'
where line_code = :lvs_line_code
    and machine_type = 'NSNP' ;

	if f_sql_check() < 0 then 
		return 
	end if 

commit ;
f_retrieve()
end event

type cb_5 from so_commandbutton within w_pln_product_nsnp_history_query
integer x = 4037
integer y = 160
integer height = 112
integer taborder = 90
boolean bringtotop = true
string text = "No Use NSNP"
end type

event clicked;call super::clicked;string lvs_line_code

//=========================================
// user level $$HEX2$$55d678c7$$ENDHEX$$
//=========================================
IF ( GVI_USER_LEVEL < 8 or isnull(GVI_USER_LEVEL)) THEN
	  
	  messagebox("$$HEX2$$4cc5bcb9$$ENDHEX$$", "$$HEX11$$acc0a9c68cad5cd5200074c72000c6c5b5c2c8b2e4b2$$ENDHEX$$") 
	  return
	  
END IF

//=========================================


if dw_1.getrow() < 1 then
	//Messagebox("Notify" , "$$HEX10$$7cb778c744c7200020c1ddd0200058d538c194c6$$ENDHEX$$")
	f_msg("$$HEX10$$7cb778c744c7200020c1ddd0200058d538c194c6$$ENDHEX$$","S")
	return
end if 

lvs_line_code = dw_1.object.line_code[dw_1.getrow()]

sqlca.P_INTERLOCK_SET_NSNP_TIME_MSG( lvs_line_code , '0' , 0 ,  '*', '*', 'UNLOCK', gvs_computer_name+'=>FORCE UNLOCK '+gvs_user_name )

update imcn_machine set use_status = 'S'
where line_code = :lvs_line_code
    and machine_type = 'NSNP' ;

	if f_sql_check() < 0 then 
		return 
	end if 

commit ;
f_retrieve()
end event

type cb_6 from so_commandbutton within w_pln_product_nsnp_history_query
integer x = 4613
integer y = 52
integer height = 112
integer taborder = 100
boolean bringtotop = true
boolean enabled = false
string text = "Reset Line"
end type

event clicked;call super::clicked;//if dw_1.getrow() < 1 then return 
//
//string lvs_line_code  , lvs_out , lvs_model_name 
//lvs_line_code      = STRING(dw_1.object.line_code[dw_1.getrow()])
//lvs_model_name = STRING(dw_1.object.model_name[dw_1.getrow()])
//
//sqlca.P_INTERLOCK_RESET_LINE( lvs_line_code  ,  lvs_model_name ,  lvs_out )
//
//if f_sql_check() < 0 then 
//	return 
//end if 
//
//f_msgbox1(107 ,lvs_out ) 
//
end event

type cb_7 from so_commandbutton within w_pln_product_nsnp_history_query
integer x = 4613
integer y = 164
integer height = 112
integer taborder = 110
boolean bringtotop = true
string text = "Reset NSNP"
end type

event clicked;call super::clicked;//=========================================
// user level $$HEX2$$55d678c7$$ENDHEX$$
//=========================================
IF ( GVI_USER_LEVEL < 8 or isnull(GVI_USER_LEVEL)) THEN
	  
	  messagebox("$$HEX2$$4cc5bcb9$$ENDHEX$$", "$$HEX11$$acc0a9c68cad5cd5200074c72000c6c5b5c2c8b2e4b2$$ENDHEX$$") 
	  return
	  
END IF

//=========================================

if dw_1.getrow() < 1 then return 

string lvs_line_code  , lvs_model_name
lvs_line_code = dw_1.object.line_code[dw_1.getrow()]
lvs_model_name = dw_1.object.model_name[dw_1.getrow()]

// p_interlock_set_nsnp_time_msg (SUBSTR (p_line_code, 1, 2),
//                                     'RESET',
//                                     1000,
//                                     P_MODEL_NAME,
//                                     '*',
//                                     'RESET',
//                                     'RESET LINE ACTUAL ');
sqlca.P_INTERLOCK_SET_NSNP_TIME_MSG( lvs_line_code , 'RESET' ,1000,lvs_model_name, '*', 'RESET', 'FORCE RESET =>'+gvs_user_name )
if f_sql_check() < 0 then 
	return 
end if 

f_msgbox1(107 , this.text ) 

dw_1.retrieve( )
end event

type gb_1 from so_groupbox within w_pln_product_nsnp_history_query
integer width = 2135
integer height = 304
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_pln_product_nsnp_history_query
integer x = 2144
integer width = 3099
integer height = 304
integer taborder = 30
string text = "NSNP Lock / Unlock"
end type

