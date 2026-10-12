HA$PBExportHeader$w_product_infac_interface.srw
$PBExportComments$INFAC $$HEX6$$e0ac1dacacc0200090c7acc7$$ENDHEX$$,$$HEX5$$1cc888d4acc7e0ac2000$$ENDHEX$$interface upload $$HEX2$$54d674ba$$ENDHEX$$
forward
global type w_product_infac_interface from w_main_root
end type
type sle_sl from so_singlelineedit within w_product_infac_interface
end type
type st_2 from statictext within w_product_infac_interface
end type
type st_1 from so_statictext within w_product_infac_interface
end type
type st_item from statictext within w_product_infac_interface
end type
type sle_item from so_singlelineedit within w_product_infac_interface
end type
type uo_dateset from uo_ymd_calendar within w_product_infac_interface
end type
type cb_excel from commandbutton within w_product_infac_interface
end type
type cb_delete from commandbutton within w_product_infac_interface
end type
type ddlb_trans_flag from dropdownlistbox within w_product_infac_interface
end type
type st_3 from statictext within w_product_infac_interface
end type
type gb_1 from so_groupbox within w_product_infac_interface
end type
end forward

global type w_product_infac_interface from w_main_root
integer width = 6354
integer height = 2748
string title = "INFAC $$HEX2$$90c7acc7$$ENDHEX$$/$$HEX6$$1cc888d42000acc7e0ac2000$$ENDHEX$$Upload"
string ivs_dw_2_use_focusindicator = "Y"
string ivs_dw_2_selected_row_yn = "Y"
sle_sl sle_sl
st_2 st_2
st_1 st_1
st_item st_item
sle_item sle_item
uo_dateset uo_dateset
cb_excel cb_excel
cb_delete cb_delete
ddlb_trans_flag ddlb_trans_flag
st_3 st_3
gb_1 gb_1
end type
global w_product_infac_interface w_product_infac_interface

type variables
Long Lvl_row 
String lvs_current_array_type , lvs_last_run_no
String lvs_user_line_code  , lvs_user_machine_code
end variables

on w_product_infac_interface.create
int iCurrent
call super::create
this.sle_sl=create sle_sl
this.st_2=create st_2
this.st_1=create st_1
this.st_item=create st_item
this.sle_item=create sle_item
this.uo_dateset=create uo_dateset
this.cb_excel=create cb_excel
this.cb_delete=create cb_delete
this.ddlb_trans_flag=create ddlb_trans_flag
this.st_3=create st_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_sl
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.st_item
this.Control[iCurrent+5]=this.sle_item
this.Control[iCurrent+6]=this.uo_dateset
this.Control[iCurrent+7]=this.cb_excel
this.Control[iCurrent+8]=this.cb_delete
this.Control[iCurrent+9]=this.ddlb_trans_flag
this.Control[iCurrent+10]=this.st_3
this.Control[iCurrent+11]=this.gb_1
end on

on w_product_infac_interface.destroy
call super::destroy
destroy(this.sle_sl)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.st_item)
destroy(this.sle_item)
destroy(this.uo_dateset)
destroy(this.cb_excel)
destroy(this.cb_delete)
destroy(this.ddlb_trans_flag)
destroy(this.st_3)
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
Ivs_resize_type                      = 'NORMAL'  // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


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
CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		
			DW_1.RETRIEVE( uo_dateset.text() , sle_sl.TEXT+'%', sle_item.TEXT+'%', ddlb_trans_flag.TEXT )
			dw_1.setfocus()	
	
    CASE "DELETE"
		
			MSG = F_MSGBOX(1003)  //$$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?
			
			IF MSG = 1 THEN
                      DW_1.deleterow( DW_1.getrow( ) )
			END IF
			
	CASE 'UPDATE'
		
	         if ( dw_1.update() < 0 ) then 
			   rollback;
			else
			   commit ;		
			end if 			

CASE ELSE
	
END CHOOSE
end event

type dw_5 from w_main_root`dw_5 within w_product_infac_interface
integer x = 18
integer y = 548
integer height = 1040
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_product_infac_interface
integer x = 18
integer y = 548
integer height = 1044
integer taborder = 0
end type

type dw_3 from w_main_root`dw_3 within w_product_infac_interface
integer x = 599
integer y = 612
integer width = 1001
integer height = 1072
integer taborder = 0
boolean titlebar = true
end type

type dw_2 from w_main_root`dw_2 within w_product_infac_interface
integer x = 485
integer y = 452
integer width = 1001
integer height = 712
integer taborder = 0
boolean titlebar = true
end type

type dw_1 from w_main_root`dw_1 within w_product_infac_interface
integer x = 9
integer y = 332
integer width = 4357
integer height = 1792
integer taborder = 0
boolean titlebar = true
string title = "Upload List"
string dataobject = "d_product_infac_upload_list"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_product_infac_interface
integer taborder = 0
end type

type sle_sl from so_singlelineedit within w_product_infac_interface
integer x = 581
integer y = 168
integer width = 411
integer height = 84
integer taborder = 30
boolean bringtotop = true
textcase textcase = upper!
end type

type st_2 from statictext within w_product_infac_interface
integer x = 581
integer y = 96
integer width = 411
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "CD SL"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from so_statictext within w_product_infac_interface
integer x = 137
integer y = 96
integer width = 411
integer height = 68
boolean bringtotop = true
fontfamily fontfamily = modern!
string facename = "$$HEX5$$d1b940c72000e0ac15b5$$ENDHEX$$"
boolean enabled = false
string text = "DT IF"
end type

type st_item from statictext within w_product_infac_interface
integer x = 1029
integer y = 96
integer width = 709
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "CD ITEM"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_item from so_singlelineedit within w_product_infac_interface
integer x = 1029
integer y = 168
integer width = 709
integer height = 84
integer taborder = 60
boolean bringtotop = true
textcase textcase = upper!
end type

type uo_dateset from uo_ymd_calendar within w_product_infac_interface
event destroy ( )
integer x = 137
integer y = 168
integer taborder = 80
boolean bringtotop = true
long backcolor = 12632256
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type cb_excel from commandbutton within w_product_infac_interface
integer x = 2359
integer y = 108
integer width = 507
integer height = 148
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "$$HEX5$$d1b940c72000e0ac15b5$$ENDHEX$$"
string text = "$$HEX6$$d1c540c12000c5c55cb8dcb4$$ENDHEX$$"
end type

event clicked;
dw_1.reset()
dw_1.importclipboard( )	

//do
//	
//	i++
//	
//loop until i = dw_1.rowcount( )
end event

type cb_delete from commandbutton within w_product_infac_interface
integer x = 2912
integer y = 108
integer width = 507
integer height = 148
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "$$HEX5$$d1b940c72000e0ac15b5$$ENDHEX$$"
string text = "$$HEX6$$7cc7e8b204c72000adc01cc8$$ENDHEX$$"
end type

event clicked;
String ls_ret, ls_yyymmdd
Long ll_ret, ll_rows
 
 ls_yyymmdd = string( uo_dateset.text(), 'YYYYMMDD' )
 
ll_ret = MessageBox('$$HEX2$$bdace0ac$$ENDHEX$$', ls_yyymmdd + ' $$HEX21$$7cc790c72000f8bb04c8a1c1200070b374c7c0d07cb92000adc01cc8200058d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?', Question!,  YesNo!)

if ( ll_ret = 1  ) then   
	  
     DELETE FROM ESEAI_M107_TEMP
     WHERE DT_IF             = :ls_yyymmdd
         AND TRANSFER_YN = 'N';
	
	// SQL $$HEX4$$24c658b955d678c7$$ENDHEX$$
     if ( f_sql_check() < 0 ) then 
	   return 
	end if  
			
    ll_rows = sqlca.sqlnrows

    COMMIT ;		
	 	 
    MessageBox('$$HEX2$$4cc5bcb9$$ENDHEX$$', '$$HEX8$$f8bb04c8a1c1200070b374c7c0d02000$$ENDHEX$$' + string(ll_rows) +  '$$HEX12$$74ac200044c72000adc01cc8200058d500c6b5c2c8b2e4b2$$ENDHEX$$!', Information! ,  OK!) 	
	 
	// $$HEX13$$adc01cc82000c4d6200070b374c7c0d02000acc770c88cd62000$$ENDHEX$$
    Gvs_Ue_DATA_control = 'RETRIEVE'
    Parent.Triggerevent("UE_DATA_CONTROL")
 
end if
end event

type ddlb_trans_flag from dropdownlistbox within w_product_infac_interface
integer x = 1769
integer y = 168
integer width = 338
integer height = 324
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean sorted = false
string item[] = {"%","Y","N"}
borderstyle borderstyle = stylelowered!
end type

event constructor;
ddlb_trans_flag.selectitem(1)
end event

type st_3 from statictext within w_product_infac_interface
integer x = 1769
integer y = 96
integer width = 338
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Transfer Flag"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_1 from so_groupbox within w_product_infac_interface
integer x = 9
integer width = 2258
integer height = 304
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

