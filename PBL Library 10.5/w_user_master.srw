HA$PBExportHeader$w_user_master.srw
$PBExportComments$User Information Manage
forward
global type w_user_master from w_main_root
end type
type st_3 from so_statictext within w_user_master
end type
type st_2 from so_statictext within w_user_master
end type
type ddlb_organization_id from uo_orz_id within w_user_master
end type
type st_1 from so_statictext within w_user_master
end type
type ddlb_department_code from uo_department_code within w_user_master
end type
type st_4 from so_statictext within w_user_master
end type
type ddlb_user_level from uo_basecode within w_user_master
end type
type st_5 from so_statictext within w_user_master
end type
type sle_user_id from so_singlelineedit within w_user_master
end type
type sle_user_name from so_singlelineedit within w_user_master
end type
type rb_1 from so_radiobutton within w_user_master
end type
type rb_2 from so_radiobutton within w_user_master
end type
type gb_1 from so_groupbox within w_user_master
end type
type gb_2 from so_groupbox within w_user_master
end type
end forward

global type w_user_master from w_main_root
integer width = 4608
integer height = 2444
string title = "User"
st_3 st_3
st_2 st_2
ddlb_organization_id ddlb_organization_id
st_1 st_1
ddlb_department_code ddlb_department_code
st_4 st_4
ddlb_user_level ddlb_user_level
st_5 st_5
sle_user_id sle_user_id
sle_user_name sle_user_name
rb_1 rb_1
rb_2 rb_2
gb_1 gb_1
gb_2 gb_2
end type
global w_user_master w_user_master

on w_user_master.create
int iCurrent
call super::create
this.st_3=create st_3
this.st_2=create st_2
this.ddlb_organization_id=create ddlb_organization_id
this.st_1=create st_1
this.ddlb_department_code=create ddlb_department_code
this.st_4=create st_4
this.ddlb_user_level=create ddlb_user_level
this.st_5=create st_5
this.sle_user_id=create sle_user_id
this.sle_user_name=create sle_user_name
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_3
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.ddlb_organization_id
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.ddlb_department_code
this.Control[iCurrent+6]=this.st_4
this.Control[iCurrent+7]=this.ddlb_user_level
this.Control[iCurrent+8]=this.st_5
this.Control[iCurrent+9]=this.sle_user_id
this.Control[iCurrent+10]=this.sle_user_name
this.Control[iCurrent+11]=this.rb_1
this.Control[iCurrent+12]=this.rb_2
this.Control[iCurrent+13]=this.gb_1
this.Control[iCurrent+14]=this.gb_2
end on

on w_user_master.destroy
call super::destroy
destroy(this.st_3)
destroy(this.st_2)
destroy(this.ddlb_organization_id)
destroy(this.st_1)
destroy(this.ddlb_department_code)
destroy(this.st_4)
destroy(this.ddlb_user_level)
destroy(this.st_5)
destroy(this.sle_user_id)
destroy(this.sle_user_name)
destroy(this.rb_1)
destroy(this.rb_2)
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

event ue_data_control;call super::ue_data_control;Long ROW

CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		   dw_1.RETRIEVE(DDLB_ORGANIZATION_ID.GETCODE()+'%', DDLB_DEPARTMENT_CODE.GETCODE()+'%', SLE_USER_ID.TEXT+'%', SLE_USER_NAME.TEXT+'%', DDLB_USER_LEVEL.GETCODE()+'%')
	        dw_1.SETFOCUS()
		   dw_1.groupcalc( )	  
			
	CASE 'INSERT'
		     DW_2.RESET()
			ROW = dw_2.INSERTROW(dw_2.GETROW())
			F_SET_SECURITY_ROW(dw_2 , ROW , 'NONORG')
			dw_2.setitem(ROW , 'organization_id' , long(ddlb_organization_id.getcode()))
			
			if dw_1.getrow() <  1 then
			
				dw_2.setitem(ROW , 'department_code' , '*')
			else
				dw_2.setitem(ROW , 'department_code' , dw_1.object.department_code[dw_1.getrow()] )
			end if 
			
			
			dw_2.setitem(ROW , 'user_level' , 3 )
			dw_2.setitem(ROW , 'position' , 'F' )			
			
			dw_2.setitem(ROW , 'show_unit_price' , 'Y' )			
			dw_2.setitem(ROW , 'show_sale_price' , 'Y' )			
			dw_2.setitem(ROW , 'show_inventory_price' , 'Y' )						
			
			F_MSG_MDI_HELP( F_MSG_ST(152) ) 
			
	CASE 'APPEND'
			DW_2.RESET()
			ROW = dw_2.INSERTROW(0)
			F_SET_SECURITY_ROW(dw_2 , ROW , 'NONORG')
			dw_2.setitem(ROW , 'organization_id' , long(ddlb_organization_id.getcode()))
			
			if dw_1.getrow() <  1 then
			
				dw_2.setitem(ROW , 'department_code' , '*')
			else
				dw_2.setitem(ROW , 'department_code' , dw_1.object.department_code[dw_1.getrow()] )
			end if 
			
			dw_2.setitem(ROW , 'user_level' , 3 )
			dw_2.setitem(ROW , 'position' , 'F' )		
			dw_2.setitem(ROW , 'show_unit_price' , 'Y' )			
			dw_2.setitem(ROW , 'show_sale_price' , 'Y' )			
			dw_2.setitem(ROW , 'show_inventory_price' , 'Y' )					

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
				
	CASE 'UPDATE'
		
			IF dw_2.UPDATE() < 0 THEN
				ROLLBACK;
			ELSE
				COMMIT;
				F_MSG_MDI_HELP( F_MSG_ST(170) ) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
			     F_RETRIEVE()
			END IF
			
	CASE ELSE
END CHOOSE

end event

event ue_post_open;call super::ue_post_open;ddlb_user_level.redraw('USER LEVEL')
/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

type dw_5 from w_main_root`dw_5 within w_user_master
integer y = 344
end type

type dw_4 from w_main_root`dw_4 within w_user_master
integer y = 344
end type

type dw_3 from w_main_root`dw_3 within w_user_master
integer y = 344
end type

type dw_2 from w_main_root`dw_2 within w_user_master
integer y = 1664
integer width = 4544
integer height = 664
string dataobject = "d_user_mst"
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

event dw_2::rbuttondown;call super::rbuttondown;if dwo.name = 'department_code' then 
	open( w_department_popup )
	
	if message.stringparm = '' then 
	else
		
		this.object.department_code[row] = message.stringparm
		
	end if
end if
end event

type dw_1 from w_main_root`dw_1 within w_user_master
integer y = 344
integer width = 4544
integer height = 1312
boolean titlebar = true
string title = "User List"
string dataobject = "d_user_lst_tree"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;IF DW_1.GETROW() > 0 THEN
	DW_2.RETRIEVE( DW_1.GETITEMSTRING( DW_1.GETROW() , "ROWID" ) )
ELSE
	DW_2.RESET()
END IF



end event

type uo_tabpages from w_main_root`uo_tabpages within w_user_master
end type

type st_3 from so_statictext within w_user_master
integer x = 2130
integer y = 108
integer height = 56
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "User ID"
end type

type st_2 from so_statictext within w_user_master
integer x = 864
integer y = 108
integer width = 645
integer height = 56
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Organization ID"
end type

type ddlb_organization_id from uo_orz_id within w_user_master
integer x = 864
integer y = 176
integer width = 645
integer taborder = 20
boolean bringtotop = true
long backcolor = 16777215
end type

event selectionchanged;call super::selectionchanged;ddlb_department_code.redraw(ddlb_organization_id.getcode())
f_child_dw(dw_1, 'dept_code', ddlb_organization_id.getcode()+'%')
f_child_dw(dw_2, 'dept_code', ddlb_organization_id.getcode()+'%')

end event

type st_1 from so_statictext within w_user_master
integer x = 1513
integer y = 108
integer width = 608
integer height = 56
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Department Code"
end type

type ddlb_department_code from uo_department_code within w_user_master
integer x = 1513
integer y = 176
integer height = 784
integer taborder = 20
boolean bringtotop = true
long backcolor = 16777215
end type

event selectionchanged;call super::selectionchanged;F_MSG_MDI_HELP( THIS.TEXT ) 
end event

type st_4 from so_statictext within w_user_master
integer x = 2633
integer y = 108
integer height = 56
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "User Name"
end type

type ddlb_user_level from uo_basecode within w_user_master
integer x = 3136
integer y = 176
integer width = 507
integer taborder = 40
boolean bringtotop = true
long backcolor = 16777215
end type

type st_5 from so_statictext within w_user_master
integer x = 3136
integer y = 108
integer width = 507
integer height = 56
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "User Level"
end type

type sle_user_id from so_singlelineedit within w_user_master
integer x = 2130
integer y = 176
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
end type

type sle_user_name from so_singlelineedit within w_user_master
integer x = 2633
integer y = 176
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
end type

type rb_1 from so_radiobutton within w_user_master
integer x = 142
integer y = 96
boolean bringtotop = true
string text = "User Master"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1
end event

type rb_2 from so_radiobutton within w_user_master
integer x = 142
integer y = 196
boolean bringtotop = true
string text = "User ID Barcode"
end type

event clicked;call super::clicked;dw_3.bringtotop = true 
selected_data_window = dw_3
end event

type gb_1 from so_groupbox within w_user_master
integer width = 805
integer height = 324
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_2 from so_groupbox within w_user_master
integer x = 827
integer width = 2839
integer height = 324
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

