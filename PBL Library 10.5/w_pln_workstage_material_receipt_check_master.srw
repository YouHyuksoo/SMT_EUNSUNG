HA$PBExportHeader$w_pln_workstage_material_receipt_check_master.srw
$PBExportComments$$$HEX6$$80bd88d42000c8b9a4c230d1$$ENDHEX$$
forward
global type w_pln_workstage_material_receipt_check_master from w_main_root
end type
type st_2 from so_statictext within w_pln_workstage_material_receipt_check_master
end type
type sle_line_code from so_singlelineedit within w_pln_workstage_material_receipt_check_master
end type
type uo_item from uo_item_code within w_pln_workstage_material_receipt_check_master
end type
type st_5 from so_statictext within w_pln_workstage_material_receipt_check_master
end type
type rb_request_list from so_radiobutton within w_pln_workstage_material_receipt_check_master
end type
type rb_request_history from so_radiobutton within w_pln_workstage_material_receipt_check_master
end type
type st_4 from so_statictext within w_pln_workstage_material_receipt_check_master
end type
type uo_dateset from uo_ymdh_calendar within w_pln_workstage_material_receipt_check_master
end type
type uo_dateend from uo_ymdh_calendar within w_pln_workstage_material_receipt_check_master
end type
type sle_our_barcode from so_singlelineedit within w_pln_workstage_material_receipt_check_master
end type
type st_status from so_statictext within w_pln_workstage_material_receipt_check_master
end type
type st_3 from so_statictext within w_pln_workstage_material_receipt_check_master
end type
type gb_1 from so_groupbox within w_pln_workstage_material_receipt_check_master
end type
type gb_2 from so_groupbox within w_pln_workstage_material_receipt_check_master
end type
end forward

global type w_pln_workstage_material_receipt_check_master from w_main_root
integer width = 5170
integer height = 2904
string title = "Workstage Material Receipt Check Master "
windowstate windowstate = maximized!
st_2 st_2
sle_line_code sle_line_code
uo_item uo_item
st_5 st_5
rb_request_list rb_request_list
rb_request_history rb_request_history
st_4 st_4
uo_dateset uo_dateset
uo_dateend uo_dateend
sle_our_barcode sle_our_barcode
st_status st_status
st_3 st_3
gb_1 gb_1
gb_2 gb_2
end type
global w_pln_workstage_material_receipt_check_master w_pln_workstage_material_receipt_check_master

on w_pln_workstage_material_receipt_check_master.create
int iCurrent
call super::create
this.st_2=create st_2
this.sle_line_code=create sle_line_code
this.uo_item=create uo_item
this.st_5=create st_5
this.rb_request_list=create rb_request_list
this.rb_request_history=create rb_request_history
this.st_4=create st_4
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.sle_our_barcode=create sle_our_barcode
this.st_status=create st_status
this.st_3=create st_3
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.sle_line_code
this.Control[iCurrent+3]=this.uo_item
this.Control[iCurrent+4]=this.st_5
this.Control[iCurrent+5]=this.rb_request_list
this.Control[iCurrent+6]=this.rb_request_history
this.Control[iCurrent+7]=this.st_4
this.Control[iCurrent+8]=this.uo_dateset
this.Control[iCurrent+9]=this.uo_dateend
this.Control[iCurrent+10]=this.sle_our_barcode
this.Control[iCurrent+11]=this.st_status
this.Control[iCurrent+12]=this.st_3
this.Control[iCurrent+13]=this.gb_1
this.Control[iCurrent+14]=this.gb_2
end on

on w_pln_workstage_material_receipt_check_master.destroy
call super::destroy
destroy(this.st_2)
destroy(this.sle_line_code)
destroy(this.uo_item)
destroy(this.st_5)
destroy(this.rb_request_list)
destroy(this.rb_request_history)
destroy(this.st_4)
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.sle_our_barcode)
destroy(this.st_status)
destroy(this.st_3)
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
sle_our_barcode.setfocus( )
end event

event ue_data_control;call super::ue_data_control;Long ROW
STRING LVS_SETYN

CHOOSE CASE Gvs_Ue_data_control
		
		
	CASE 'RETRIEVE'
	    if rb_request_list.checked = true then 
			DW_1.RETRIEVE(   sle_our_barcode.text+'%'  ,  GVI_ORGANIZATION_ID )
			DW_1.SETFOCUS()
		elseif rb_request_history.checked = true then 
			DW_2.RETRIEVE(  sle_line_code.text+'%' , uo_item.text+'%' ,uo_dateset.TEXT() , uo_dateend.text() ,  GVI_ORGANIZATION_ID )
			DW_2.SETFOCUS()	
		end if 
		sle_our_barcode.setfocus( )
	CASE ELSE
END CHOOSE


end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
st_status.width = dw_1.width

end event

event resize;call super::resize;st_status.width = dw_1.width
end event

type dw_5 from w_main_root`dw_5 within w_pln_workstage_material_receipt_check_master
integer y = 540
end type

type dw_4 from w_main_root`dw_4 within w_pln_workstage_material_receipt_check_master
integer y = 540
integer width = 2674
integer height = 1208
boolean titlebar = true
string title = "Report"
end type

type dw_3 from w_main_root`dw_3 within w_pln_workstage_material_receipt_check_master
integer y = 540
integer width = 2674
integer height = 1208
integer taborder = 50
boolean titlebar = true
end type

type dw_2 from w_main_root`dw_2 within w_pln_workstage_material_receipt_check_master
integer y = 540
integer width = 4078
integer height = 1208
integer taborder = 0
boolean titlebar = true
string dataobject = "d_mat_request_master_hist"
end type

type dw_1 from w_main_root`dw_1 within w_pln_workstage_material_receipt_check_master
integer y = 540
integer width = 4087
integer height = 1208
integer taborder = 40
boolean titlebar = true
string title = "Material Request List"
string dataobject = "d_mat_request_master_lst"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_pln_workstage_material_receipt_check_master
end type

type st_2 from so_statictext within w_pln_workstage_material_receipt_check_master
integer x = 1673
integer y = 96
integer width = 334
integer height = 56
boolean bringtotop = true
string text = "Line Code"
end type

type sle_line_code from so_singlelineedit within w_pln_workstage_material_receipt_check_master
event ue_editchange pbm_enchange
integer x = 1673
integer y = 172
integer width = 334
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

event ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

SELECTED_DATA_WINDOW.SETFILTER('')
SELECTED_DATA_WINDOW.FILTER()

LVS_COLUMN = 'LINE_CODE'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    SELECTED_DATA_WINDOW.SETFILTER('')
    SELECTED_DATA_WINDOW.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

SELECTED_DATA_WINDOW.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
SELECTED_DATA_WINDOW.FILTER()
F_MSG_MDI_HELP( STRING( SELECTED_DATA_WINDOW.ROWCOUNT() ) + " Found" )
end event

event getfocus;this.selecttext( 1 , len( this.text) )
this.Borderstyle = styleraised!
end event

event losefocus;this.Borderstyle = styleLowered!
end event

type uo_item from uo_item_code within w_pln_workstage_material_receipt_check_master
integer x = 2016
integer y = 172
integer width = 581
integer height = 764
integer taborder = 40
boolean bringtotop = true
end type

type st_5 from so_statictext within w_pln_workstage_material_receipt_check_master
integer x = 2011
integer y = 104
integer width = 581
integer height = 56
boolean bringtotop = true
boolean enabled = false
string text = "Item Code"
end type

type rb_request_list from so_radiobutton within w_pln_workstage_material_receipt_check_master
integer x = 59
integer y = 100
boolean bringtotop = true
string text = "Request Issue List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true
selected_data_window = dw_1
sle_our_barcode.setfocus( )
end event

type rb_request_history from so_radiobutton within w_pln_workstage_material_receipt_check_master
integer x = 59
integer y = 204
boolean bringtotop = true
string text = "Request History"
end type

event clicked;call super::clicked;dw_2.bringtotop = true
selected_data_window = dw_2
sle_our_barcode.setfocus( )
end event

type st_4 from so_statictext within w_pln_workstage_material_receipt_check_master
integer x = 2615
integer y = 88
integer width = 1083
integer height = 68
boolean bringtotop = true
string text = "Request Date"
end type

type uo_dateset from uo_ymdh_calendar within w_pln_workstage_material_receipt_check_master
event destroy ( )
integer x = 2606
integer y = 168
integer width = 549
integer taborder = 70
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymdh_calendar::destroy
end on

type uo_dateend from uo_ymdh_calendar within w_pln_workstage_material_receipt_check_master
event destroy ( )
integer x = 3154
integer y = 168
integer width = 544
integer taborder = 70
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymdh_calendar::destroy
end on

type sle_our_barcode from so_singlelineedit within w_pln_workstage_material_receipt_check_master
integer x = 718
integer y = 180
integer width = 869
integer taborder = 30
boolean bringtotop = true
end type

event modified;call super::modified;string lvs_serial_no , lvs_item_code
long LVI_COUNT

st_status.backcolor = rgb( 0 ,0 ,255) 

	lvs_serial_no = this.text 

//	SELECT COUNT(*) 
//	    INTO :LVI_COUNT 
//	   FROM IM_ITEM_ISSUE 
//      WHERE BARCODE = :lvs_serial_no
//		  AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID  ;
//
//		if sqlca.sqlcode < 0 then 
//		
//			Messagebox("Error" , sqlca.sqlerrtext ) 
//			st_status.text ='NG'
//			st_status.backcolor = 255
//			this.text = ''
//			this.setfocus( )
//			f_play_sound("Kittingfailedk.wav")
//			ROLLBACK;
//			return 
//	end if   		  
		  
//	if LVI_COUNT < 1 then 
//		st_status.text ='NG :'+"ISSUE BARCODE NOT FOUND"
//		st_status.backcolor = 255
//		this.text = ''
//		this.setfocus( )
//		f_play_sound("Kittingfailed.wav")
//		RETURN 		
//	end if 


      SELECT item_code
         INTO :lvs_item_code
        FROM im_item_request
       WHERE  item_barcode = :lvs_serial_no
             AND REQUEST_STATUS = 'C'
             AND confirm_date IS NULL
             AND ROWNUM = 1;

   IF    ISNULL(lvs_item_code) OR  lvs_item_code = ''    THEN
		st_status.text ='NG :'+"BARCODE NOT FOUND"
		st_status.backcolor = 255
		this.text = ''
		this.setfocus( )
		f_play_sound("Kittingfailed.wav")
		RETURN 
   ELSE

      UPDATE IM_ITEM_REQUEST
         SET CONFIRM_DATE = SYSDATE, CONFIRM_BY = NVL (:GVS_USER_ID, '*')
       WHERE  ITEM_BARCODE = :lvs_serial_no
             AND REQUEST_STATUS = 'C'
             AND CONFIRM_DATE IS NULL;
				 
		if sqlca.sqlcode < 0 then 
		
			Messagebox("Error" , sqlca.sqlerrtext ) 
			st_status.text ='NG'
			st_status.backcolor = 255
			this.text = ''
			this.setfocus( )
			f_play_sound("Kittingfailedk.wav")
			ROLLBACK;
			return 
	end if   
	st_status.text = "OK : "+lvs_serial_no
	st_status.backcolor = rgb( 0 ,0 ,255) 
	f_play_sound("Kittingok.wav")
	commit ;
	
  END IF 
this.text = ''
this.setfocus( )

end event

type st_status from so_statictext within w_pln_workstage_material_receipt_check_master
integer y = 336
integer width = 4082
integer height = 196
boolean bringtotop = true
integer textsize = -28
long textcolor = 65535
long backcolor = 16711680
string text = "Message"
end type

type st_3 from so_statictext within w_pln_workstage_material_receipt_check_master
integer x = 718
integer y = 88
integer width = 864
integer height = 76
boolean bringtotop = true
string text = "MES Barcode"
end type

type gb_1 from so_groupbox within w_pln_workstage_material_receipt_check_master
integer width = 672
integer height = 324
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_2 from so_groupbox within w_pln_workstage_material_receipt_check_master
integer x = 1605
integer y = 8
integer width = 2117
integer height = 324
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

