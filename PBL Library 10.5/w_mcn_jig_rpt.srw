HA$PBExportHeader$w_mcn_jig_rpt.srw
forward
global type w_mcn_jig_rpt from w_main_root
end type
type rb_jig_master from so_radiobutton within w_mcn_jig_rpt
end type
type st_1 from so_statictext within w_mcn_jig_rpt
end type
type sle_jig_code from so_singlelineedit within w_mcn_jig_rpt
end type
type rb_jig_card from so_radiobutton within w_mcn_jig_rpt
end type
type rb_issue_list from so_radiobutton within w_mcn_jig_rpt
end type
type st_7 from so_statictext within w_mcn_jig_rpt
end type
type ddlb_issue_status from uo_basecode within w_mcn_jig_rpt
end type
type ddlb_jig_type from uo_basecode within w_mcn_jig_rpt
end type
type st_5 from so_statictext within w_mcn_jig_rpt
end type
type uo_dateend from uo_ymd_calendar within w_mcn_jig_rpt
end type
type uo_dateset from uo_ymd_calendar within w_mcn_jig_rpt
end type
type st_4 from so_statictext within w_mcn_jig_rpt
end type
type rb_1 from so_radiobutton within w_mcn_jig_rpt
end type
type sle_lot_no from so_singlelineedit within w_mcn_jig_rpt
end type
type st_2 from so_statictext within w_mcn_jig_rpt
end type
type rb_type1 from so_radiobutton within w_mcn_jig_rpt
end type
type rb_3 from so_radiobutton within w_mcn_jig_rpt
end type
type ole_com from olecustomcontrol within w_mcn_jig_rpt
end type
type em_port from editmask within w_mcn_jig_rpt
end type
type cb_com from commandbutton within w_mcn_jig_rpt
end type
type sle_jig_name from so_singlelineedit within w_mcn_jig_rpt
end type
type st_3 from so_statictext within w_mcn_jig_rpt
end type
type gb_1 from groupbox within w_mcn_jig_rpt
end type
type gb_2 from groupbox within w_mcn_jig_rpt
end type
type gb_3 from so_groupbox within w_mcn_jig_rpt
end type
end forward

global type w_mcn_jig_rpt from w_main_root
integer width = 6231
integer height = 2856
string title = "JIG Master Report"
rb_jig_master rb_jig_master
st_1 st_1
sle_jig_code sle_jig_code
rb_jig_card rb_jig_card
rb_issue_list rb_issue_list
st_7 st_7
ddlb_issue_status ddlb_issue_status
ddlb_jig_type ddlb_jig_type
st_5 st_5
uo_dateend uo_dateend
uo_dateset uo_dateset
st_4 st_4
rb_1 rb_1
sle_lot_no sle_lot_no
st_2 st_2
rb_type1 rb_type1
rb_3 rb_3
ole_com ole_com
em_port em_port
cb_com cb_com
sle_jig_name sle_jig_name
st_3 st_3
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_mcn_jig_rpt w_mcn_jig_rpt

type variables

end variables

forward prototypes
public subroutine wf_print_comport (string arg_jig_code, string arg_jig_type, string arg_jig_lot_no, integer arg_org)
end prototypes

public subroutine wf_print_comport (string arg_jig_code, string arg_jig_type, string arg_jig_lot_no, integer arg_org);//st_status.text = 'COM Print ' 

string lvs_barcode
long i

DECLARE C01 CURSOR FOR 
			 SELECT ZEBRA_CODE 
  			   FROM IMCN_JIG_ZEBRA_V 
			 WHERE JIG_CODE       like :arg_jig_code 
			     AND JIG_TYPE       like :arg_jig_type
			     AND JIG_LOT_NO     like :arg_jig_lot_no 
			     AND ORGANIZATION_ID = :arg_org ;
		
OPEN C01 ; 


ole_com.object.CommPort    = integer(em_port.text)
//ole_com.object.Settings       = '9600'+','+'none'+','+'8'+','+'1' // "9600,N,8,1" // 9600 $$HEX5$$04c8a1c120008dc1c4b3$$ENDHEX$$, $$HEX6$$28d3acb9f0d22000c6c54cc7$$ENDHEX$$, 8 $$HEX3$$70b374c730d1$$ENDHEX$$, 1 $$HEX12$$11c9c0c9200044beb8d27cb92000c0c915c869d5c8b2e4b2$$ENDHEX$$.


if (ole_com.object.Portopen = false ) then 
	ole_com.object.Portopen = true
end if 

do
	    
	    lvs_barcode = ""
		
		
		fetch c01 into :lvs_barcode ; 
		
		//messagebox('$$HEX2$$55d678c7$$ENDHEX$$',string(sqlca.sqlcode))
		
		if sqlca.sqlcode = 100 then exit ; 
		i++
		//messagebox(string(i),lvs_item_barcode) 

		
		//messagebox("$$HEX2$$55d678c7$$ENDHEX$$",lvs_barcode) 
		
	ole_com.object.Output = lvs_barcode 

  		
loop  until ( 1 = 2 ) 

close C01; 

//st_status.text = 'Print $$HEX2$$44c6ccb8$$ENDHEX$$' 

if (ole_com.object.Portopen ) then 
	ole_com.object.Portopen = false
end if 

end subroutine

on w_mcn_jig_rpt.create
int iCurrent
call super::create
this.rb_jig_master=create rb_jig_master
this.st_1=create st_1
this.sle_jig_code=create sle_jig_code
this.rb_jig_card=create rb_jig_card
this.rb_issue_list=create rb_issue_list
this.st_7=create st_7
this.ddlb_issue_status=create ddlb_issue_status
this.ddlb_jig_type=create ddlb_jig_type
this.st_5=create st_5
this.uo_dateend=create uo_dateend
this.uo_dateset=create uo_dateset
this.st_4=create st_4
this.rb_1=create rb_1
this.sle_lot_no=create sle_lot_no
this.st_2=create st_2
this.rb_type1=create rb_type1
this.rb_3=create rb_3
this.ole_com=create ole_com
this.em_port=create em_port
this.cb_com=create cb_com
this.sle_jig_name=create sle_jig_name
this.st_3=create st_3
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_jig_master
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.sle_jig_code
this.Control[iCurrent+4]=this.rb_jig_card
this.Control[iCurrent+5]=this.rb_issue_list
this.Control[iCurrent+6]=this.st_7
this.Control[iCurrent+7]=this.ddlb_issue_status
this.Control[iCurrent+8]=this.ddlb_jig_type
this.Control[iCurrent+9]=this.st_5
this.Control[iCurrent+10]=this.uo_dateend
this.Control[iCurrent+11]=this.uo_dateset
this.Control[iCurrent+12]=this.st_4
this.Control[iCurrent+13]=this.rb_1
this.Control[iCurrent+14]=this.sle_lot_no
this.Control[iCurrent+15]=this.st_2
this.Control[iCurrent+16]=this.rb_type1
this.Control[iCurrent+17]=this.rb_3
this.Control[iCurrent+18]=this.ole_com
this.Control[iCurrent+19]=this.em_port
this.Control[iCurrent+20]=this.cb_com
this.Control[iCurrent+21]=this.sle_jig_name
this.Control[iCurrent+22]=this.st_3
this.Control[iCurrent+23]=this.gb_1
this.Control[iCurrent+24]=this.gb_2
this.Control[iCurrent+25]=this.gb_3
end on

on w_mcn_jig_rpt.destroy
call super::destroy
destroy(this.rb_jig_master)
destroy(this.st_1)
destroy(this.sle_jig_code)
destroy(this.rb_jig_card)
destroy(this.rb_issue_list)
destroy(this.st_7)
destroy(this.ddlb_issue_status)
destroy(this.ddlb_jig_type)
destroy(this.st_5)
destroy(this.uo_dateend)
destroy(this.uo_dateset)
destroy(this.st_4)
destroy(this.rb_1)
destroy(this.sle_lot_no)
destroy(this.st_2)
destroy(this.rb_type1)
destroy(this.rb_3)
destroy(this.ole_com)
destroy(this.em_port)
destroy(this.cb_com)
destroy(this.sle_jig_name)
destroy(this.st_3)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
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
/*****************************************
* Data Window Property
******************************************/
Ivs_resize_type                      = 'NORMAL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


/*****************************************
* Data Window Property
******************************************/
ivs_dw_1_use_focusindicator = 'N' //Focus Indicator Show / Hide Property
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
F_MENU_CONTROL('REPORT' , True)  // All Data Control





end event

event ue_data_control;call super::ue_data_control;Long ROW
CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		if rb_jig_master.checked = true then 
			DW_1.RETRIEVE(  sle_jig_code.text+'%', gvi_organization_id )
			dw_1.setfocus()
		elseif rb_jig_card.checked = true then 
			dw_2.retrieve( sle_jig_code.text+'%'  , gvi_organization_id  )	
			f_dual_lang_change_dwtext(dw_2)
			dw_2.setfocus()			
		elseif rb_issue_list.checked = true then
			dw_3.retrieve(uo_dateset.text() , uo_dateend.text() , sle_jig_code.text + '%',ddlb_jig_type.GETCODE()+'%' , ddlb_issue_status.getcode()+'%' ,  gvi_organization_id)
			dw_3.setfocus()
		else
		
			dw_4.retrieve( sle_jig_code.text + '%',ddlb_jig_type.GETCODE()+'%' ,  sle_lot_no.text+'%' ,  sle_jig_name.text+'%' , gvi_organization_id)
			dw_4.setfocus()
		end if
	CASE ELSE
END CHOOSE
end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

type dw_5 from w_main_root`dw_5 within w_mcn_jig_rpt
integer x = 9
integer y = 328
end type

type dw_4 from w_main_root`dw_4 within w_mcn_jig_rpt
integer x = 9
integer y = 328
integer width = 4507
integer height = 2120
boolean titlebar = true
string dataobject = "d_mcn_jig_barcode_rpt"
end type

type dw_3 from w_main_root`dw_3 within w_mcn_jig_rpt
integer x = 9
integer y = 328
integer width = 4507
integer height = 2120
boolean titlebar = true
string dataobject = "d_mcn_jig_issue_rpt"
end type

type dw_2 from w_main_root`dw_2 within w_mcn_jig_rpt
integer x = 9
integer y = 328
integer width = 4507
integer height = 2120
integer taborder = 0
boolean titlebar = true
string title = "Jig Bill List"
string dataobject = "d_mcn_jig_card_rpt"
end type

event dw_2::clicked;call super::clicked;if dwo.name = 'b_repair_show' then 		
	
		if this.getrow() < 1 then 
			return
		end if
		
		Long Lvl_return
		String  lvs_file_name
		if this.getrow() < 1 then return 
		
		lvs_file_name = f_download_jig_repair_rtn_filename ( string(this.object.jig_code[this.getrow()] ), long(this.object.repair_sequence[this.getrow()])  )
		
			
			IF lvs_file_name = '' OR ISNULL(lvs_file_name) THEN 
				RETURN
			else
			
				f_shell_execute_by_extention ( lvs_file_name   , '' ,Gvs_default_directory+'\Temp'  )

			end if
		
		Changedirectory(Gvs_default_directory)
	
	
end if 
end event

type dw_1 from w_main_root`dw_1 within w_mcn_jig_rpt
integer x = 9
integer y = 328
integer width = 4507
integer height = 2120
integer taborder = 0
boolean titlebar = true
string title = "Jig List"
string dataobject = "d_mcn_jig_rpt"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_mcn_jig_rpt
end type

type rb_jig_master from so_radiobutton within w_mcn_jig_rpt
integer x = 73
integer y = 68
integer width = 489
boolean bringtotop = true
integer weight = 700
string text = "Jig Master"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true
selected_data_window = dw_1

end event

type st_1 from so_statictext within w_mcn_jig_rpt
integer x = 1582
integer y = 72
integer width = 489
integer height = 64
boolean bringtotop = true
string text = "Jig Code"
end type

type sle_jig_code from so_singlelineedit within w_mcn_jig_rpt
integer x = 1582
integer y = 160
integer width = 489
integer height = 84
integer taborder = 30
boolean bringtotop = true
textcase textcase = upper!
end type

type rb_jig_card from so_radiobutton within w_mcn_jig_rpt
integer x = 73
integer y = 196
integer width = 466
boolean bringtotop = true
integer weight = 700
string text = "Jig Card"
end type

event clicked;call super::clicked;dw_2.bringtotop = true
selected_data_window = dw_2

end event

type rb_issue_list from so_radiobutton within w_mcn_jig_rpt
integer x = 503
integer y = 68
integer width = 466
boolean bringtotop = true
integer weight = 700
string text = "Jig Issue List"
end type

event clicked;call super::clicked;dw_3.bringtotop = true
selected_data_window = dw_3
end event

type st_7 from so_statictext within w_mcn_jig_rpt
integer x = 4791
integer y = 92
integer height = 68
boolean bringtotop = true
long textcolor = 0
string text = "Issue Status"
end type

type ddlb_issue_status from uo_basecode within w_mcn_jig_rpt
integer x = 4791
integer y = 168
integer width = 498
integer taborder = 30
boolean bringtotop = true
boolean autohscroll = true
end type

event constructor;call super::constructor;THIS.REdraw( 'ISSUE STATUS')

end event

type ddlb_jig_type from uo_basecode within w_mcn_jig_rpt
integer x = 4215
integer y = 168
integer width = 571
integer taborder = 30
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'JIG TYPE')
end event

type st_5 from so_statictext within w_mcn_jig_rpt
integer x = 4219
integer y = 88
integer width = 571
integer height = 68
boolean bringtotop = true
long textcolor = 0
string text = "Jig Type"
end type

type uo_dateend from uo_ymd_calendar within w_mcn_jig_rpt
event destroy ( )
integer x = 3794
integer y = 164
integer taborder = 40
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateset from uo_ymd_calendar within w_mcn_jig_rpt
event destroy ( )
integer x = 3378
integer y = 164
integer taborder = 40
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type st_4 from so_statictext within w_mcn_jig_rpt
integer x = 3383
integer y = 84
integer width = 814
integer height = 68
boolean bringtotop = true
string text = "Date"
end type

type rb_1 from so_radiobutton within w_mcn_jig_rpt
integer x = 498
integer y = 196
integer width = 466
boolean bringtotop = true
integer weight = 700
string text = "Jig Barcode"
end type

event clicked;call super::clicked;dw_4.bringtotop = true
selected_data_window = dw_4
end event

type sle_lot_no from so_singlelineedit within w_mcn_jig_rpt
integer x = 2080
integer y = 160
integer width = 608
integer height = 84
integer taborder = 40
boolean bringtotop = true
textcase textcase = upper!
end type

type st_2 from so_statictext within w_mcn_jig_rpt
integer x = 2080
integer y = 72
integer width = 608
integer height = 64
boolean bringtotop = true
string text = "Jig Lot No"
end type

type rb_type1 from so_radiobutton within w_mcn_jig_rpt
integer x = 1152
integer y = 84
integer width = 361
boolean bringtotop = true
string text = "Big"
boolean checked = true
end type

event clicked;call super::clicked;dw_4.dataobject = 'd_mcn_jig_barcode_rpt'
dw_4.settransobject( sqlca)
end event

type rb_3 from so_radiobutton within w_mcn_jig_rpt
integer x = 1147
integer y = 180
integer width = 361
boolean bringtotop = true
string text = "Small"
end type

event clicked;call super::clicked;dw_4.dataobject = 'd_mcn_jig_barcode_width_rpt'
dw_4.settransobject( sqlca)
end event

type ole_com from olecustomcontrol within w_mcn_jig_rpt
event oncomm ( )
boolean visible = false
integer x = 4864
integer y = 48
integer width = 1317
integer height = 768
integer taborder = 20
boolean bringtotop = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
string binarykey = "w_mcn_jig_rpt.win"
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
end type

type em_port from editmask within w_mcn_jig_rpt
boolean visible = false
integer x = 4686
integer y = 68
integer width = 160
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "1"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###"
end type

type cb_com from commandbutton within w_mcn_jig_rpt
boolean visible = false
integer x = 4681
integer y = 168
integer width = 178
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Print"
end type

event clicked;dw_4.retrieve( sle_jig_code.text + '%',ddlb_jig_type.GETCODE()+'%' ,  sle_lot_no.text+'%' ,  gvi_organization_id)
wf_print_comport(sle_jig_code.text + '%',ddlb_jig_type.GETCODE()+'%' ,  sle_lot_no.text+'%' ,  gvi_organization_id)
end event

type sle_jig_name from so_singlelineedit within w_mcn_jig_rpt
integer x = 2693
integer y = 160
integer width = 608
integer height = 84
integer taborder = 50
boolean bringtotop = true
textcase textcase = upper!
end type

type st_3 from so_statictext within w_mcn_jig_rpt
integer x = 2693
integer y = 68
integer width = 608
integer height = 64
boolean bringtotop = true
string text = "Jig Name"
end type

type gb_1 from groupbox within w_mcn_jig_rpt
integer x = 9
integer width = 1079
integer height = 312
integer taborder = 10
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

type gb_2 from groupbox within w_mcn_jig_rpt
integer x = 1559
integer width = 3936
integer height = 312
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_mcn_jig_rpt
integer x = 1097
integer width = 443
integer height = 312
integer taborder = 30
string text = "Barcode Type"
end type


Start of PowerBuilder Binary Data Section : Do NOT Edit
09w_mcn_jig_rpt.bin 
2300000c00e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd00000004fffffffefffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff0000000300000000000000000000000000000000000000000000000000000000e3b86f3001d3cd7100000003000000c00000000000500003004c004200430049004e0045004500530045004b000000590000000000000000000000000000000000000000000000000000000000000000000000000002001cffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000260000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000002001affffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000010000003c00000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000101001a000000020000000100000004648a5600101b2c6e0000b6821400000000000000e3b8211001d3cd71e3b8211001d3cd71000000000000000000000000fffffffefffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
23ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00430079007000690072006800670020007400630028002000290039003100340039000000200000000000000000000000000000000000000000000000001234432100000008000003ed000003ed648a560100060000000100000000040000002800000025800008000000000000000000000000003f00000001000000001234432100000008000003ed000003ed648a560100060000000100000000040000002800000025800008000000000000000000000000003f00000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006f00430074006e006e00650073007400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000020000003c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
19w_mcn_jig_rpt.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
