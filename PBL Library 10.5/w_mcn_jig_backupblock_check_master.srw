HA$PBExportHeader$w_mcn_jig_backupblock_check_master.srw
$PBExportComments$$$HEX4$$31bcc5c514beedb7$$ENDHEX$$
forward
global type w_mcn_jig_backupblock_check_master from w_main_root
end type
type sle_barcode from so_singlelineedit within w_mcn_jig_backupblock_check_master
end type
type st_1 from so_statictext within w_mcn_jig_backupblock_check_master
end type
type cb_clean_ok from so_commandbutton within w_mcn_jig_backupblock_check_master
end type
type cb_2 from so_commandbutton within w_mcn_jig_backupblock_check_master
end type
type st_status from so_statictext within w_mcn_jig_backupblock_check_master
end type
type cb_3 from so_commandbutton within w_mcn_jig_backupblock_check_master
end type
type cb_4 from so_commandbutton within w_mcn_jig_backupblock_check_master
end type
type em_break_value from so_editmask within w_mcn_jig_backupblock_check_master
end type
type em_hit_value from so_editmask within w_mcn_jig_backupblock_check_master
end type
type st_3 from so_statictext within w_mcn_jig_backupblock_check_master
end type
type st_4 from so_statictext within w_mcn_jig_backupblock_check_master
end type
type st_clean_status from so_statictext within w_mcn_jig_backupblock_check_master
end type
type st_visual_status from so_statictext within w_mcn_jig_backupblock_check_master
end type
type sle_commnets from so_singlelineedit within w_mcn_jig_backupblock_check_master
end type
type st_6 from so_statictext within w_mcn_jig_backupblock_check_master
end type
type sle_jig_code from so_singlelineedit within w_mcn_jig_backupblock_check_master
end type
type st_12 from so_statictext within w_mcn_jig_backupblock_check_master
end type
type st_13 from so_statictext within w_mcn_jig_backupblock_check_master
end type
type st_14 from so_statictext within w_mcn_jig_backupblock_check_master
end type
type st_15 from so_statictext within w_mcn_jig_backupblock_check_master
end type
type st_last_clean_date from so_statictext within w_mcn_jig_backupblock_check_master
end type
type uo_dateset from uo_ymd_calendar within w_mcn_jig_backupblock_check_master
end type
type st_16 from so_statictext within w_mcn_jig_backupblock_check_master
end type
type uo_dateend from uo_ymd_calendar within w_mcn_jig_backupblock_check_master
end type
type cb_data_clear from so_commandbutton within w_mcn_jig_backupblock_check_master
end type
type cb_save from so_commandbutton within w_mcn_jig_backupblock_check_master
end type
type gb_3 from groupbox within w_mcn_jig_backupblock_check_master
end type
type gb_5 from groupbox within w_mcn_jig_backupblock_check_master
end type
type gb_7 from so_groupbox within w_mcn_jig_backupblock_check_master
end type
type gb_9 from so_groupbox within w_mcn_jig_backupblock_check_master
end type
end forward

global type w_mcn_jig_backupblock_check_master from w_main_root
integer height = 3028
string title = "Backup Block Check Master"
sle_barcode sle_barcode
st_1 st_1
cb_clean_ok cb_clean_ok
cb_2 cb_2
st_status st_status
cb_3 cb_3
cb_4 cb_4
em_break_value em_break_value
em_hit_value em_hit_value
st_3 st_3
st_4 st_4
st_clean_status st_clean_status
st_visual_status st_visual_status
sle_commnets sle_commnets
st_6 st_6
sle_jig_code sle_jig_code
st_12 st_12
st_13 st_13
st_14 st_14
st_15 st_15
st_last_clean_date st_last_clean_date
uo_dateset uo_dateset
st_16 st_16
uo_dateend uo_dateend
cb_data_clear cb_data_clear
cb_save cb_save
gb_3 gb_3
gb_5 gb_5
gb_7 gb_7
gb_9 gb_9
end type
global w_mcn_jig_backupblock_check_master w_mcn_jig_backupblock_check_master

type variables
string lvs_jig_lot_no , lvs_line_code
STRING lvs_clean_yn , lvs_jig_code, lvs_use_status, LVS_TENSION_CHECK_YN
Long lvl_row , lvl_break_value , lvl_hit_value  , lvl_jig_check_sequence
long lvl_time_start , row
end variables

forward prototypes
public function integer wf_insert_inspect (string arg_check_status)
end prototypes

public function integer wf_insert_inspect (string arg_check_status);f_set_column_dddw(dw_1)
f_insert()

dw_1.object.jig_check_date[row] = f_sysdate()
dw_1.object.line_code[row] = lvs_line_code
dw_1.object.jig_lot_no[row] = sle_barcode.text
dw_1.object.jig_code[row] = lvs_jig_code
dw_1.object.jig_check_sequence[row] = f_get_sequence('SEQ_JIG_CHECK_SEQUENCE')
dw_1.object.jig_check_status[row] = arg_check_status //PASS
dw_1.object.hit_value[row] = long(em_hit_value.text)
dw_1.object.break_value[row] = long(em_break_value.text)

if st_clean_status.text = 'OK' then 
	dw_1.object.clean_yn[row] = 'Y'
else
	dw_1.object.clean_yn[row] = 'N'
end if 

if st_visual_status.text = 'OK' then 
	dw_1.object.pin_hole_yn[row] = 'Y'
else
	dw_1.object.pin_hole_yn[row] = 'N'
end if 

//===================================
// $$HEX7$$80acacc074c725b8200000c8a5c7$$ENDHEX$$
//===================================

if dw_1.update() < 0 then 
	rollback ;
	return -1
else
	
	commit;
	
	if arg_check_status = 'P' then 
		
				update imcn_jig 
				     set use_status                = 'U'   ,
					      TENSION_CHECK_YN = 'Y'
				where jig_lot_no    = :lvs_jig_lot_no
				and jig_type           = 'B' 
				and organization_id = :gvi_organization_id ; 
				
				if f_sql_check() < 0 then 
				  return  -1
				end if 
				
				commit;
				
   	              sle_barcode.text = ''
	              sle_barcode.setfocus()
	              f_play_sound("$$HEX2$$69d5a9ac$$ENDHEX$$.wav")				
				
	else
		
				update imcn_jig 
				     set use_status = 'S' ,
					      TENSION_CHECK_YN = 'N'
				where jig_lot_no  = :lvs_jig_lot_no
			  	    and jig_type     = 'B' 
				    and organization_id = :gvi_organization_id ; 

				if f_sql_check() < 0 then 
					return  -1
				end if 
				
				commit;
				
   	              sle_barcode.text = ''
	              sle_barcode.setfocus()
	              f_play_sound("$$HEX3$$88bd69d5a9ac$$ENDHEX$$.wav")						
				
	end if 
		
end if 



end function

on w_mcn_jig_backupblock_check_master.create
int iCurrent
call super::create
this.sle_barcode=create sle_barcode
this.st_1=create st_1
this.cb_clean_ok=create cb_clean_ok
this.cb_2=create cb_2
this.st_status=create st_status
this.cb_3=create cb_3
this.cb_4=create cb_4
this.em_break_value=create em_break_value
this.em_hit_value=create em_hit_value
this.st_3=create st_3
this.st_4=create st_4
this.st_clean_status=create st_clean_status
this.st_visual_status=create st_visual_status
this.sle_commnets=create sle_commnets
this.st_6=create st_6
this.sle_jig_code=create sle_jig_code
this.st_12=create st_12
this.st_13=create st_13
this.st_14=create st_14
this.st_15=create st_15
this.st_last_clean_date=create st_last_clean_date
this.uo_dateset=create uo_dateset
this.st_16=create st_16
this.uo_dateend=create uo_dateend
this.cb_data_clear=create cb_data_clear
this.cb_save=create cb_save
this.gb_3=create gb_3
this.gb_5=create gb_5
this.gb_7=create gb_7
this.gb_9=create gb_9
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_barcode
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cb_clean_ok
this.Control[iCurrent+4]=this.cb_2
this.Control[iCurrent+5]=this.st_status
this.Control[iCurrent+6]=this.cb_3
this.Control[iCurrent+7]=this.cb_4
this.Control[iCurrent+8]=this.em_break_value
this.Control[iCurrent+9]=this.em_hit_value
this.Control[iCurrent+10]=this.st_3
this.Control[iCurrent+11]=this.st_4
this.Control[iCurrent+12]=this.st_clean_status
this.Control[iCurrent+13]=this.st_visual_status
this.Control[iCurrent+14]=this.sle_commnets
this.Control[iCurrent+15]=this.st_6
this.Control[iCurrent+16]=this.sle_jig_code
this.Control[iCurrent+17]=this.st_12
this.Control[iCurrent+18]=this.st_13
this.Control[iCurrent+19]=this.st_14
this.Control[iCurrent+20]=this.st_15
this.Control[iCurrent+21]=this.st_last_clean_date
this.Control[iCurrent+22]=this.uo_dateset
this.Control[iCurrent+23]=this.st_16
this.Control[iCurrent+24]=this.uo_dateend
this.Control[iCurrent+25]=this.cb_data_clear
this.Control[iCurrent+26]=this.cb_save
this.Control[iCurrent+27]=this.gb_3
this.Control[iCurrent+28]=this.gb_5
this.Control[iCurrent+29]=this.gb_7
this.Control[iCurrent+30]=this.gb_9
end on

on w_mcn_jig_backupblock_check_master.destroy
call super::destroy
destroy(this.sle_barcode)
destroy(this.st_1)
destroy(this.cb_clean_ok)
destroy(this.cb_2)
destroy(this.st_status)
destroy(this.cb_3)
destroy(this.cb_4)
destroy(this.em_break_value)
destroy(this.em_hit_value)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_clean_status)
destroy(this.st_visual_status)
destroy(this.sle_commnets)
destroy(this.st_6)
destroy(this.sle_jig_code)
destroy(this.st_12)
destroy(this.st_13)
destroy(this.st_14)
destroy(this.st_15)
destroy(this.st_last_clean_date)
destroy(this.uo_dateset)
destroy(this.st_16)
destroy(this.uo_dateend)
destroy(this.cb_data_clear)
destroy(this.cb_save)
destroy(this.gb_3)
destroy(this.gb_5)
destroy(this.gb_7)
destroy(this.gb_9)
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
* Menu Property 
*****************************************
* ADMIN  ( All Control )
* MANAGE ( Manager )
* GUEST  ( Only Query )
* QUERY  ( Only Query  )
* DATA_CONTROL  ( Insert Delete Update )
* REPORT ( Report )
****************************************/
F_MENU_CONTROL('DATA_CONTROL' , TRUE)  // All Data Control
sle_barcode.setfocus()

end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
sle_barcode.setfocus()
st_status.width = width

String lvs_max, lvs_min
Long   lvs_cnt

////SPEC $$HEX2$$24c115c8$$ENDHEX$$
//SELECT count(*)
//  INTO  :lvs_cnt
//  FROM ISYS_BASECODE
//WHERE CODE_TYPE = 'METALMASK_SPEC';
//
//If lvs_cnt > 0 Then
//	SELECT max(code_name), min(code_name)
//		INTO :lvs_max, :lvs_min
//	  FROM ISYS_BASECODE
//	WHERE CODE_TYPE = 'METALMASK_SPEC';
//	
//	em_max.text = lvs_max
//	em_min.text = lvs_min
//	
//End If	
end event

event ue_data_control;
string lvs_date
double LVDB_RCV_ISS_SEQ
choose case gvs_ue_data_control
		
	case 'RETRIEVE'
		
	
			dw_1.reset()
			dw_1.retrieve(  sle_barcode.text+'%' , gvi_organization_id, uo_dateset.text() , uo_dateend.text() )

			sle_barcode.setfocus()
	
    case 'INSERT'
		
			ROW = dw_1.INSERTROW(0)
			dw_1.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(dw_1 , ROW ,'ALL')
			
    
			sle_barcode.setfocus()
			
	case 'APPEND'		
			ROW = dw_1.INSERTROW(0)
			dw_1.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(dw_1 , ROW ,'ALL')
						

			sle_barcode.setfocus()
			
	case 'DELETE'
		
		  	if dw_1.AcceptText() = -1 then
				return
			end if
			
			MSG = F_MSGBOX(1003)  //$$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?
			IF MSG = 1 THEN
				Gvl_row_deleted = dw_1.GetRow()			
				dw_1.DELETEROW(Gvl_row_deleted)		
				dw_1.SetFocus()
				lvl_ROW = dw_1.GetRow()
				dw_1.ScrollToRow(lvl_ROW)
				dw_1.SetColumn(1)
			END IF		 
			sle_barcode.setfocus()
			
   case 'UPDATE'
		
			IF dw_1.UPDATE() < 0  THEN
			  	 ROLLBACK;
				 RETURN
			ELSE
				 COMMIT;
				 F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"			 
			END IF
			sle_barcode.setfocus()
	case else
		
end choose

end event

type dw_5 from w_main_root`dw_5 within w_mcn_jig_backupblock_check_master
boolean visible = false
integer y = 308
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_mcn_jig_backupblock_check_master
boolean visible = false
integer y = 308
integer taborder = 0
end type

type dw_3 from w_main_root`dw_3 within w_mcn_jig_backupblock_check_master
boolean visible = false
integer y = 308
integer taborder = 0
string dataobject = "d_mcn_jig_mask_check_lst"
end type

type dw_2 from w_main_root`dw_2 within w_mcn_jig_backupblock_check_master
integer y = 1784
integer width = 4581
integer height = 1016
integer taborder = 0
boolean titlebar = true
boolean hsplitscroll = false
boolean livescroll = false
end type

type dw_1 from w_main_root`dw_1 within w_mcn_jig_backupblock_check_master
integer y = 1784
integer width = 5307
integer height = 1136
integer taborder = 0
boolean titlebar = true
string title = "Check List"
string dataobject = "d_mcn_jig_backupblock_check_mlst"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_mcn_jig_backupblock_check_master
integer taborder = 0
end type

type sle_barcode from so_singlelineedit within w_mcn_jig_backupblock_check_master
integer x = 59
integer y = 184
integer width = 837
integer taborder = 1
boolean bringtotop = true
end type

event modified;call super::modified;
Datetime lvdt_clean_date

lvs_jig_lot_no = this.text 

em_break_value.text = ''
em_hit_value.text = ''
sle_jig_code.text = ''

//============================================
//
//============================================
select line_code ,  break_value , hit_value , jig_code ,  use_status , TENSION_CHECK_YN
  into :lvs_line_code , :lvl_break_value , :lvl_hit_value , :lvs_jig_code, :lvs_use_status , :LVS_TENSION_CHECK_YN
 from imcn_jig 
where jig_lot_no = :lvs_jig_lot_no 
    and jig_type = 'B'
    and organization_id = :gvi_organization_id ;
	 
if f_sql_check() < 0 then
	return 
end if 

select max(jig_check_date)
  into :lvdt_clean_date
 from imcn_jig_backupblock_check
where jig_lot_no = :lvs_jig_lot_no 
    and clean_yn = 'Y'
    and organization_id = :gvi_organization_id ;
	 
if f_sql_check() < 0 then
	return 
end if 

if lvs_jig_code = '' or isnull(lvs_jig_code) then 
	f_msg("$$HEX16$$f8bbf1b45db8200031bcc5c514beedb7200014bc54cfdcb4200085c7c8b2e4b2$$ENDHEX$$",'P')
	sle_barcode.text = ''
	sle_barcode.setfocus( )
	return 
end if 

//========================================
// $$HEX17$$74c7f8bb200080acacc020001bbc40c770ac74ba2000acc780ac200088bd00ac2000$$ENDHEX$$
//========================================

if LVS_TENSION_CHECK_YN ='Y' and lvs_use_status = 'U' then 
	
	f_msg("$$HEX31$$31bcc5c514beedb7200080acacc000ac2000f1b45db81cb42000a4c234d088c9200085c7c8b2e4b22000acc780acacc0200088bd00ac200069d5c8b2e4b2$$ENDHEX$$.",'P')		
	return 
	
end if 


st_last_clean_date.text = ''
st_last_clean_date.text = string( lvdt_clean_date )

em_break_value.text = string( lvl_break_value )
em_hit_value.text = string( lvl_hit_value ) 

if  lvl_break_value < lvl_hit_value then 
	
	f_msg("$$HEX14$$5cd5c4ac200018c285ba44c7200008cdfcac200088d5b5c2c8b2e4b2$$ENDHEX$$",'P')
	st_status.text =  f_msg("$$HEX14$$5cd5c4ac200018c285ba44c7200008cdfcac200088d5b5c2c8b2e4b2$$ENDHEX$$",'S')
	
end if 

sle_jig_code.text = lvs_jig_code 
f_play_sound("cleancheck.wav")

end event

type st_1 from so_statictext within w_mcn_jig_backupblock_check_master
integer x = 59
integer y = 116
integer width = 837
integer height = 64
boolean bringtotop = true
string text = "JIG Barcode"
end type

type cb_clean_ok from so_commandbutton within w_mcn_jig_backupblock_check_master
integer x = 78
integer y = 1320
integer height = 168
integer taborder = 21
boolean bringtotop = true
string text = "OK"
end type

event clicked;call super::clicked;
if sle_barcode.text = '' or isnull(sle_barcode.text) then  
 
   //Mess agebox("$$HEX2$$55d678c7$$ENDHEX$$" , "$$HEX11$$14bc54cfdcb47cb92000a4c294ce200058d538c194c6$$ENDHEX$$")
   f_msg( "$$HEX11$$14bc54cfdcb47cb92000a4c294ce200058d538c194c6$$ENDHEX$$",'P') 
   return 

end if 

st_clean_status.text = 'OK'
st_clean_status.backcolor = RGB(0,0,255)

f_play_sound("ok.wav")


end event

type cb_2 from so_commandbutton within w_mcn_jig_backupblock_check_master
integer x = 613
integer y = 1320
integer height = 168
integer taborder = 31
boolean bringtotop = true
string text = "NG"
end type

event clicked;call super::clicked;
if sle_barcode.text = '' or isnull(sle_barcode.text) then  
 
   //Mess agebox("$$HEX2$$55d678c7$$ENDHEX$$" , "$$HEX11$$14bc54cfdcb47cb92000a4c294ce200058d538c194c6$$ENDHEX$$")
   f_msg(  "$$HEX11$$14bc54cfdcb47cb92000a4c294ce200058d538c194c6$$ENDHEX$$", 'P') 
   return 

end if 

st_clean_status.text = 'NG'
st_clean_status.backcolor =255

f_play_sound("ng.wav")

wf_insert_inspect( 'N')
end event

type st_status from so_statictext within w_mcn_jig_backupblock_check_master
integer x = 18
integer y = 324
integer width = 5262
integer height = 192
boolean bringtotop = true
integer textsize = -24
long textcolor = 65535
long backcolor = 134217741
string text = "Message"
end type

type cb_3 from so_commandbutton within w_mcn_jig_backupblock_check_master
integer x = 1819
integer y = 1320
integer height = 168
integer taborder = 41
boolean bringtotop = true
string text = "NG"
end type

event clicked;call super::clicked;
if sle_barcode.text = '' or isnull(sle_barcode.text) then  
 
   f_msg( "$$HEX11$$14bc54cfdcb47cb92000a4c294ce200058d538c194c6$$ENDHEX$$",'P') 
   return 

end if 

st_visual_status.text = 'NG'
st_visual_status.backcolor =255

f_play_sound("ng.wav")

wf_insert_inspect( 'N')

end event

type cb_4 from so_commandbutton within w_mcn_jig_backupblock_check_master
integer x = 1285
integer y = 1320
integer height = 168
integer taborder = 31
boolean bringtotop = true
string text = "OK"
end type

event clicked;call super::clicked;
if sle_barcode.text = '' or isnull(sle_barcode.text) then  
 
   //Mes sagebox("$$HEX2$$55d678c7$$ENDHEX$$" , "$$HEX11$$14bc54cfdcb47cb92000a4c294ce200058d538c194c6$$ENDHEX$$")
   f_msg( "$$HEX11$$14bc54cfdcb47cb92000a4c294ce200058d538c194c6$$ENDHEX$$",'P') 
   return 

end if 

st_visual_status.text = 'OK'
st_visual_status.backcolor = RGB(0,0,255)

f_play_sound("ok.wav")




end event

type em_break_value from so_editmask within w_mcn_jig_backupblock_check_master
integer x = 1943
integer y = 184
integer taborder = 11
boolean bringtotop = true
string text = "0"
boolean displayonly = true
string mask = "###,##0"
end type

type em_hit_value from so_editmask within w_mcn_jig_backupblock_check_master
integer x = 2368
integer y = 184
integer taborder = 21
boolean bringtotop = true
string text = "0"
boolean displayonly = true
string mask = "###,##0"
end type

type st_3 from so_statictext within w_mcn_jig_backupblock_check_master
integer x = 1952
integer y = 116
integer width = 402
integer height = 64
boolean bringtotop = true
string text = "Break Value"
end type

type st_4 from so_statictext within w_mcn_jig_backupblock_check_master
integer x = 2363
integer y = 116
integer width = 402
integer height = 64
boolean bringtotop = true
string text = "Hit Value"
end type

type st_clean_status from so_statictext within w_mcn_jig_backupblock_check_master
integer x = 78
integer y = 1088
integer width = 1074
integer height = 216
boolean bringtotop = true
integer textsize = -28
long textcolor = 16777215
long backcolor = 0
string text = "WAIT..."
end type

type st_visual_status from so_statictext within w_mcn_jig_backupblock_check_master
integer x = 1280
integer y = 1088
integer width = 1074
integer height = 216
boolean bringtotop = true
integer textsize = -28
long textcolor = 16777215
long backcolor = 0
string text = "WAIT..."
end type

type sle_commnets from so_singlelineedit within w_mcn_jig_backupblock_check_master
integer x = 18
integer y = 1652
integer width = 5285
integer height = 112
integer taborder = 31
boolean bringtotop = true
integer textsize = -12
end type

type st_6 from so_statictext within w_mcn_jig_backupblock_check_master
integer x = 27
integer y = 1556
boolean bringtotop = true
integer weight = 700
string text = "Inspect Comment"
end type

type sle_jig_code from so_singlelineedit within w_mcn_jig_backupblock_check_master
integer x = 2784
integer y = 180
integer width = 750
integer taborder = 11
boolean bringtotop = true
boolean displayonly = true
end type

type st_12 from so_statictext within w_mcn_jig_backupblock_check_master
integer x = 2784
integer y = 116
integer width = 750
integer height = 64
boolean bringtotop = true
string text = "JIG Code"
end type

type st_13 from so_statictext within w_mcn_jig_backupblock_check_master
integer x = 87
integer y = 664
integer width = 1088
integer height = 128
boolean bringtotop = true
integer textsize = -16
integer weight = 700
string text = "Clean Check Spec"
end type

type st_14 from so_statictext within w_mcn_jig_backupblock_check_master
integer x = 1285
integer y = 672
integer width = 1061
integer height = 392
boolean bringtotop = true
integer textsize = -16
integer weight = 700
string text = "Visual Check Spec"
end type

type st_15 from so_statictext within w_mcn_jig_backupblock_check_master
integer x = 37
integer y = 1000
integer width = 402
integer height = 60
boolean bringtotop = true
long textcolor = 255
string text = "Last Clean Date"
end type

type st_last_clean_date from so_statictext within w_mcn_jig_backupblock_check_master
integer x = 443
integer y = 1000
integer width = 704
integer height = 60
boolean bringtotop = true
end type

type uo_dateset from uo_ymd_calendar within w_mcn_jig_backupblock_check_master
event destroy ( )
integer x = 914
integer y = 184
integer taborder = 11
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type st_16 from so_statictext within w_mcn_jig_backupblock_check_master
integer x = 919
integer y = 104
integer width = 814
integer height = 68
boolean bringtotop = true
string text = "Check Date"
end type

type uo_dateend from uo_ymd_calendar within w_mcn_jig_backupblock_check_master
event destroy ( )
integer x = 1330
integer y = 184
integer taborder = 21
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type cb_data_clear from so_commandbutton within w_mcn_jig_backupblock_check_master
integer x = 2542
integer y = 1088
integer width = 695
integer height = 168
integer taborder = 71
boolean bringtotop = true
string text = "Clear Data"
end type

event clicked;call super::clicked;
sle_barcode.text = ''

em_break_value.text = ''
em_hit_value.text = ''
sle_jig_code.text = ''

st_status.text = ''
sle_commnets.text = ''


st_clean_status.text = '$$HEX2$$00b330ae$$ENDHEX$$...'
st_visual_status.text = '$$HEX2$$00b330ae$$ENDHEX$$...'	

st_clean_status.backcolor = rgb(0,0,0)
st_visual_status.backcolor = rgb(0,0,0)

sle_barcode.setfocus()

st_status.text = f_msg("$$HEX9$$08cd30ae54d6200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$",'S')
end event

type cb_save from so_commandbutton within w_mcn_jig_backupblock_check_master
integer x = 2542
integer y = 1320
integer width = 695
integer height = 168
integer taborder = 81
boolean bringtotop = true
string text = "Save"
end type

event clicked;call super::clicked;// $$HEX11$$80acacc0200060d52000a4c234d088c9200055d678c7$$ENDHEX$$
if sle_barcode.text = '' or isnull(sle_barcode.text) then  
 
   //Mess agebox("$$HEX2$$55d678c7$$ENDHEX$$" , "$$HEX11$$14bc54cfdcb47cb92000a4c294ce200058d538c194c6$$ENDHEX$$")
   f_msg(  "$$HEX11$$14bc54cfdcb47cb92000a4c294ce200058d538c194c6$$ENDHEX$$", 'P') 
   return 

end if 

// $$HEX7$$38c199ccc1c0dcd0200055d678c7$$ENDHEX$$
if ( st_clean_status.text <> 'OK' ) then
	
	 f_msg(  "$$HEX14$$38c199ccc1c0dcd0200080bd30d1200055d678c7200058d538c194c6$$ENDHEX$$", 'P')   
	 return
	 
end if

// $$HEX7$$78c600adc1c0dcd0200055d678c7$$ENDHEX$$
if ( st_visual_status.text <> 'OK' ) then
	
	f_msg(  "$$HEX14$$78c600adc1c0dcd0200080bd30d1200055d678c7200058d538c194c6$$ENDHEX$$", 'P')  
	return
	
end if


//==========================================================
// $$HEX4$$74c725b800c8a5c7$$ENDHEX$$
//==========================================================

if  lvl_break_value < lvl_hit_value then 

	f_msg( "$$HEX14$$5cd5c4ac200018c285ba44c7200008cdfcac200088d5b5c2c8b2e4b2$$ENDHEX$$" ,'P') 
	st_status.text =   f_msg( "$$HEX14$$5cd5c4ac200018c285ba44c7200008cdfcac200088d5b5c2c8b2e4b2$$ENDHEX$$" ,'S') 
	
else
	
   	   wf_insert_inspect( 'P')
	   st_status.text = f_msg( '$$HEX18$$a4c234d088c9200080acacc015c8f4bc00ac2000f1b45db8200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$' ,'S')   
	
end if 

cb_data_clear.triggerevent(clicked!)
end event

type gb_3 from groupbox within w_mcn_jig_backupblock_check_master
integer x = 18
integer y = 532
integer width = 1198
integer height = 1004
integer taborder = 21
integer textsize = -16
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Clean"
end type

type gb_5 from groupbox within w_mcn_jig_backupblock_check_master
integer x = 1230
integer y = 532
integer width = 1189
integer height = 1004
integer taborder = 21
integer textsize = -16
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Visual"
end type

type gb_7 from so_groupbox within w_mcn_jig_backupblock_check_master
integer x = 1906
integer y = 8
integer width = 1659
integer height = 296
integer taborder = 31
integer textsize = -16
string text = "Process"
end type

type gb_9 from so_groupbox within w_mcn_jig_backupblock_check_master
integer x = 27
integer y = 12
integer width = 1755
integer height = 296
integer taborder = 10
integer textsize = -16
string text = "Scan"
end type

