HA$PBExportHeader$w_mcn_jig_feeder_adjust_master.srw
$PBExportComments$$$HEX8$$08ae15d680acacc074c725b800adacb9$$ENDHEX$$
forward
global type w_mcn_jig_feeder_adjust_master from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_mcn_jig_feeder_adjust_master
end type
type uo_dateend from uo_ymd_calendar within w_mcn_jig_feeder_adjust_master
end type
type st_4 from so_statictext within w_mcn_jig_feeder_adjust_master
end type
type st_2 from so_statictext within w_mcn_jig_feeder_adjust_master
end type
type sle_jig_lot_no from so_singlelineedit within w_mcn_jig_feeder_adjust_master
end type
type rb_jig_check_list from so_radiobutton within w_mcn_jig_feeder_adjust_master
end type
type rb_jig_list from so_radiobutton within w_mcn_jig_feeder_adjust_master
end type
type sle_barcode from so_singlelineedit within w_mcn_jig_feeder_adjust_master
end type
type st_1 from so_statictext within w_mcn_jig_feeder_adjust_master
end type
type st_5 from so_statictext within w_mcn_jig_feeder_adjust_master
end type
type gb_2 from so_groupbox within w_mcn_jig_feeder_adjust_master
end type
type gb_3 from groupbox within w_mcn_jig_feeder_adjust_master
end type
type gb_1 from so_groupbox within w_mcn_jig_feeder_adjust_master
end type
end forward

global type w_mcn_jig_feeder_adjust_master from w_main_root
integer width = 5458
integer height = 3028
string title = "JIG Feeder Adjust Master"
uo_dateset uo_dateset
uo_dateend uo_dateend
st_4 st_4
st_2 st_2
sle_jig_lot_no sle_jig_lot_no
rb_jig_check_list rb_jig_check_list
rb_jig_list rb_jig_list
sle_barcode sle_barcode
st_1 st_1
st_5 st_5
gb_2 gb_2
gb_3 gb_3
gb_1 gb_1
end type
global w_mcn_jig_feeder_adjust_master w_mcn_jig_feeder_adjust_master

on w_mcn_jig_feeder_adjust_master.create
int iCurrent
call super::create
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.st_4=create st_4
this.st_2=create st_2
this.sle_jig_lot_no=create sle_jig_lot_no
this.rb_jig_check_list=create rb_jig_check_list
this.rb_jig_list=create rb_jig_list
this.sle_barcode=create sle_barcode
this.st_1=create st_1
this.st_5=create st_5
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateset
this.Control[iCurrent+2]=this.uo_dateend
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.sle_jig_lot_no
this.Control[iCurrent+6]=this.rb_jig_check_list
this.Control[iCurrent+7]=this.rb_jig_list
this.Control[iCurrent+8]=this.sle_barcode
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.st_5
this.Control[iCurrent+11]=this.gb_2
this.Control[iCurrent+12]=this.gb_3
this.Control[iCurrent+13]=this.gb_1
end on

on w_mcn_jig_feeder_adjust_master.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.st_4)
destroy(this.st_2)
destroy(this.sle_jig_lot_no)
destroy(this.rb_jig_check_list)
destroy(this.rb_jig_list)
destroy(this.sle_barcode)
destroy(this.st_1)
destroy(this.st_5)
destroy(this.gb_2)
destroy(this.gb_3)
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
Ivs_resize_type                      = 'MASTER_DETAIL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


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





end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
uo_dateset.settext(string(f_t_sysdate(), 'yyyy/mm')+'/01')
end event

event ue_data_control;call super::ue_data_control;long row
double LVDB_SEQUENCE
choose case gvs_ue_data_control
		
	case 'RETRIEVE'
		
			dw_1.reset()
			dw_2.reset()

			if rb_jig_list.checked = true then 
				
				    dw_1.retrieve(  sle_barcode.text+'%' ,  '%' , 'F' ,  gvi_organization_id)		
			else
				    dw_3.retrieve( '%',   uo_dateset.text() , uo_dateend.text() ,  gvi_organization_id)						
			end if 


	case 'DELETE'
		
		  	if DW_2.AcceptText() = -1 then
				return
			end if
			
			MSG = F_MSGBOX(1003)  //$$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?
			IF MSG = 1 THEN
				Gvl_row_deleted = DW_2.GetRow()			
				DW_2.DELETEROW(Gvl_row_deleted)		
				DW_2.SetFocus()
				ROW = DW_2.GetRow()
				DW_2.ScrollToRow(row)
				DW_2.SetColumn(1)
			END IF		 
			
   case 'UPDATE'
		
			IF DW_1.UPDATE() < 0 OR DW_2.UPDATE() < 0  THEN
			  	 ROLLBACK;
				 RETURN
			ELSE
				 COMMIT;
				 F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"			 
			END IF

	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_mcn_jig_feeder_adjust_master
integer y = 308
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_mcn_jig_feeder_adjust_master
integer y = 308
integer taborder = 0
end type

type dw_3 from w_main_root`dw_3 within w_mcn_jig_feeder_adjust_master
integer y = 308
integer width = 4544
integer height = 1092
integer taborder = 0
boolean titlebar = true
string dataobject = "d_mcn_jig_feeder_adjust_lst"
end type

type dw_2 from w_main_root`dw_2 within w_mcn_jig_feeder_adjust_master
integer y = 1412
integer width = 4549
integer height = 712
integer taborder = 0
boolean titlebar = true
string dataobject = "d_mcn_jig_feeder_adjust_mlst"
boolean hsplitscroll = false
boolean livescroll = false
end type

event dw_2::clicked;call super::clicked;sle_barcode.setfocus( )

end event

type dw_1 from w_main_root`dw_1 within w_mcn_jig_feeder_adjust_master
integer y = 308
integer width = 4544
integer height = 1092
integer taborder = 0
boolean titlebar = true
string dataobject = "d_mcn_jig_inventory_4_feeder_adjust_lst"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return
dw_2.retrieve( this.object.jig_code[currentrow] , this.object.jig_lot_no[currentrow]  , gvi_organization_id  )
sle_barcode.setfocus()
end event

event dw_1::clicked;call super::clicked;sle_barcode.setfocus( )

end event

type uo_tabpages from w_main_root`uo_tabpages within w_mcn_jig_feeder_adjust_master
integer taborder = 0
end type

type uo_dateset from uo_ymd_calendar within w_mcn_jig_feeder_adjust_master
event destroy ( )
integer x = 2606
integer y = 160
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mcn_jig_feeder_adjust_master
event destroy ( )
integer x = 3022
integer y = 160
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_4 from so_statictext within w_mcn_jig_feeder_adjust_master
integer x = 2610
integer y = 80
integer width = 814
integer height = 68
boolean bringtotop = true
string text = "Receipt Date"
end type

type st_2 from so_statictext within w_mcn_jig_feeder_adjust_master
integer x = 2034
integer y = 76
integer width = 549
integer height = 68
boolean bringtotop = true
long textcolor = 16711680
string text = "Feeder Name"
end type

type sle_jig_lot_no from so_singlelineedit within w_mcn_jig_feeder_adjust_master
integer x = 2034
integer y = 160
integer width = 549
integer height = 84
boolean bringtotop = true
end type

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

dw_1.SETFILTER('')
dw_1.FILTER()

LVS_COLUMN = 'JIG_NAME'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    dw_1.SETFILTER('')
    dw_1.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+UPPER(this.text)+'%'
END IF

dw_1.SETFILTER( "UPPER("+LVS_COLUMN+")"  +" LIKE '"+LVS_VALUE+"'")
dw_1.FILTER()
F_MSG_MDI_HELP( STRING( dw_1.ROWCOUNT() ) + " Found" )
sle_barcode.setfocus( )

end event

type rb_jig_check_list from so_radiobutton within w_mcn_jig_feeder_adjust_master
integer x = 46
integer y = 172
integer width = 667
boolean bringtotop = true
integer weight = 700
string text = "Feeder Adjust List"
end type

event clicked;call super::clicked;dw_3.bringtotop = true
selected_data_window = dw_3
sle_barcode.setfocus( )

end event

type rb_jig_list from so_radiobutton within w_mcn_jig_feeder_adjust_master
integer x = 46
integer y = 76
integer width = 667
boolean bringtotop = true
integer weight = 700
string text = "Feeder List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true
selected_data_window = dw_1
sle_barcode.setfocus( )


end event

type sle_barcode from so_singlelineedit within w_mcn_jig_feeder_adjust_master
integer x = 823
integer y = 144
integer width = 891
integer taborder = 1
boolean bringtotop = true
end type

event modified;call super::modified;string lvs_jig_no , lvs_jig_lot_no
double lvdb_sequence
long row 

lvs_jig_lot_no = this.text

  select jig_code  , seq_feeder_adjust_sequence.nextval
     into :lvs_jig_no  , :lvdb_sequence
   from imcn_jig 
 where jig_lot_no = :lvs_jig_lot_no
    and organization_id = :gvi_organization_id ;

if f_sql_check() < 0 then 
	return 
end if 

if lvs_jig_no = '' or isnull(lvs_jig_no) then
	Messagebox("Notify" , lvs_jig_lot_no+f_msg(" $$HEX41$$f1b45db81cb420003cd554b3200015c8f4bc00ac2000c6c5b5c2c8b2e4b2200014bc54cfdcb400ac200098c7bbba18b4c8c570ac98b020003cd554b3f1b45db844c720003cba00c8200058d538c194c62000$$ENDHEX$$",'S'))
	return 
end if 

//=======================================
//
//=======================================
row = dw_2.insertrow(0)
F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')

dw_2.object.jig_code[row] = lvs_jig_no
dw_2.object.jig_lot_no[row] = lvs_jig_lot_no
dw_2.object.adjust_date[row] = f_sysdate()
dw_2.object.adjust_sequence[row] = lvdb_sequence

if dw_2.update() < 0 then 
   rollback;
else
	commit ;
end if 

sle_barcode.text = ''
sle_barcode.setfocus()

end event

type st_1 from so_statictext within w_mcn_jig_feeder_adjust_master
integer x = 827
integer y = 68
integer width = 891
integer height = 56
boolean bringtotop = true
string text = "Feeder Barcode"
end type

type st_5 from so_statictext within w_mcn_jig_feeder_adjust_master
integer x = 864
integer y = 228
integer width = 832
integer height = 56
boolean bringtotop = true
string text = "$$HEX19$$ecc530ae1cc120003cd554b3200014bc54cfdcb47cb92000a4c294ce200058d538c194c62000$$ENDHEX$$"
alignment alignment = left!
end type

type gb_2 from so_groupbox within w_mcn_jig_feeder_adjust_master
integer x = 2002
integer width = 1472
integer height = 300
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from groupbox within w_mcn_jig_feeder_adjust_master
integer width = 741
integer height = 300
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Category"
end type

type gb_1 from so_groupbox within w_mcn_jig_feeder_adjust_master
integer x = 754
integer width = 1029
integer height = 296
integer weight = 700
long textcolor = 255
string text = "Adjust Scan"
end type

