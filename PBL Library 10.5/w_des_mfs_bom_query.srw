HA$PBExportHeader$w_des_mfs_bom_query.srw
$PBExportComments$$$HEX3$$d0c6e8b204c7$$ENDHEX$$BOM$$HEX2$$00adacb9$$ENDHEX$$
forward
global type w_des_mfs_bom_query from w_main_root
end type
type st_3 from so_statictext within w_des_mfs_bom_query
end type
type sle_mfs from so_singlelineedit within w_des_mfs_bom_query
end type
type cb_1 from so_commandbutton within w_des_mfs_bom_query
end type
type sle_child_item_code from so_singlelineedit within w_des_mfs_bom_query
end type
type st_1 from so_statictext within w_des_mfs_bom_query
end type
type cb_2 from so_commandbutton within w_des_mfs_bom_query
end type
type cb_3 from so_commandbutton within w_des_mfs_bom_query
end type
type cb_4 from so_commandbutton within w_des_mfs_bom_query
end type
type cb_5 from so_commandbutton within w_des_mfs_bom_query
end type
type cb_6 from so_commandbutton within w_des_mfs_bom_query
end type
type ddlb_model_name from uo_set_model_name_ddlb within w_des_mfs_bom_query
end type
type st_4 from so_statictext within w_des_mfs_bom_query
end type
type gb_where_condition from groupbox within w_des_mfs_bom_query
end type
type gb_1 from groupbox within w_des_mfs_bom_query
end type
end forward

global type w_des_mfs_bom_query from w_main_root
integer width = 4736
integer height = 2904
string title = "MFS Bom Query"
st_3 st_3
sle_mfs sle_mfs
cb_1 cb_1
sle_child_item_code sle_child_item_code
st_1 st_1
cb_2 cb_2
cb_3 cb_3
cb_4 cb_4
cb_5 cb_5
cb_6 cb_6
ddlb_model_name ddlb_model_name
st_4 st_4
gb_where_condition gb_where_condition
gb_1 gb_1
end type
global w_des_mfs_bom_query w_des_mfs_bom_query

type variables

end variables

on w_des_mfs_bom_query.create
int iCurrent
call super::create
this.st_3=create st_3
this.sle_mfs=create sle_mfs
this.cb_1=create cb_1
this.sle_child_item_code=create sle_child_item_code
this.st_1=create st_1
this.cb_2=create cb_2
this.cb_3=create cb_3
this.cb_4=create cb_4
this.cb_5=create cb_5
this.cb_6=create cb_6
this.ddlb_model_name=create ddlb_model_name
this.st_4=create st_4
this.gb_where_condition=create gb_where_condition
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_3
this.Control[iCurrent+2]=this.sle_mfs
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.sle_child_item_code
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.cb_2
this.Control[iCurrent+7]=this.cb_3
this.Control[iCurrent+8]=this.cb_4
this.Control[iCurrent+9]=this.cb_5
this.Control[iCurrent+10]=this.cb_6
this.Control[iCurrent+11]=this.ddlb_model_name
this.Control[iCurrent+12]=this.st_4
this.Control[iCurrent+13]=this.gb_where_condition
this.Control[iCurrent+14]=this.gb_1
end on

on w_des_mfs_bom_query.destroy
call super::destroy
destroy(this.st_3)
destroy(this.sle_mfs)
destroy(this.cb_1)
destroy(this.sle_child_item_code)
destroy(this.st_1)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.cb_4)
destroy(this.cb_5)
destroy(this.cb_6)
destroy(this.ddlb_model_name)
destroy(this.st_4)
destroy(this.gb_where_condition)
destroy(this.gb_1)
end on

event activate;call super::activate;
/***************************************
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
Ivs_resize_type    = 'MASTER_DETAIL_1L2R'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
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

F_MENU_CONTROL('DATA_CONTROL' , FALSE)  // All Data Control


end event

event ue_data_control;call super::ue_data_control;Long ROW
CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		   
		   dw_1.retrieve( sle_mfs.text+'%' , ddlb_model_name.getitem( )+'%' , gvi_organization_id )

			
	CASE 'INSERT'
			dw_1.enabled = true
			row = dw_1.insertrow(dw_1.getrow())
			dw_1.scrolltorow(row)
			f_set_security_row(dw_1 , row , 'ALL')
			F_MSG_MDI_HELP ( F_MSG_ST(152)	 )
			
	CASE 'APPEND'
			dw_1.enabled = true
			row = dw_1.insertrow(dw_1.getrow())
			dw_1.scrolltorow(row)
			f_set_security_row(dw_1 , row , 'ALL')
			F_MSG_MDI_HELP ( F_MSG_ST(152)	 )
			
	CASE 'DELETE'
		
		  	if dw_1.getrow() < 1 then return 
			  
			msg =f_msgbox(1003)
			if msg = 1 then
				gvl_row_deleted = dw_1.getrow()			
				dw_1.deleterow(gvl_row_deleted)		
				dw_1.setfocus()
				row = dw_1.getrow()
				dw_1.scrolltorow(row)
				dw_1.setcolumn(1)
			end if

	CASE 'UPDATE'
			
			msg = f_msgbox( 1170)
			if msg = 1 then
				
					if dw_1.update( ) < 0 then 
						rollback ;
						return
					else
						commit ;
						F_MSG_ST(170) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"					
					end if

			end if
	CASE ELSE
END CHOOSE
end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

type dw_5 from w_main_root`dw_5 within w_des_mfs_bom_query
integer x = 14
integer y = 328
end type

type dw_4 from w_main_root`dw_4 within w_des_mfs_bom_query
integer x = 14
integer y = 328
end type

type dw_3 from w_main_root`dw_3 within w_des_mfs_bom_query
integer x = 14
integer y = 328
end type

type dw_2 from w_main_root`dw_2 within w_des_mfs_bom_query
integer x = 2149
integer y = 324
integer width = 2546
integer height = 2464
boolean titlebar = true
string title = "MFS BOM Detail List"
string dataobject = "d_des_mfs_bom_query"
end type

event dw_2::rbuttondown;call super::rbuttondown;IF DWO.NAME = 'parent_item_code' THEN
	OPEN(W_DES_ITEM_POPUP)
	IF message.stringparm = '' THEN 
	ELSE	
		THIS.SETITEM( ROW , 'parent_item_code' , message.stringparm )
	END IF		

ELSEIF DWO.NAME = 'child_item_code' THEN 
	OPEN(W_DES_ITEM_POPUP)
	IF message.stringparm = '' THEN 
	ELSE	
		THIS.SETITEM( ROW , 'child_item_code' , message.stringparm )	
	END IF		
END IF
	
end event

type dw_1 from w_main_root`dw_1 within w_des_mfs_bom_query
integer y = 324
integer width = 2139
integer height = 2464
boolean titlebar = true
string title = "MFS BOM List"
string dataobject = "d_des_mfs_bom_4_query_lst"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return

dw_2.RETRIEVE(  this.object.mfs[currentrow] , this.object.item_code[currentrow] , '%' , GVI_ORGANIZATION_ID)
dw_2.SETFOCUS()
end event

type uo_tabpages from w_main_root`uo_tabpages within w_des_mfs_bom_query
end type

type st_3 from so_statictext within w_des_mfs_bom_query
integer x = 850
integer y = 92
integer width = 416
integer height = 68
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Revision"
end type

type sle_mfs from so_singlelineedit within w_des_mfs_bom_query
integer x = 850
integer y = 168
integer width = 416
integer height = 84
integer taborder = 120
boolean bringtotop = true
end type

type cb_1 from so_commandbutton within w_des_mfs_bom_query
integer x = 1874
integer y = 52
integer width = 398
integer height = 108
integer taborder = 20
boolean bringtotop = true
string text = "Retrieve"
end type

event clicked;call super::clicked;dw_2.RETRIEVE(  '%' , '%'  , sle_child_item_code.text+'%' , GVI_ORGANIZATION_ID)
dw_2.SETFOCUS()
end event

type sle_child_item_code from so_singlelineedit within w_des_mfs_bom_query
integer x = 1358
integer y = 180
integer width = 507
integer height = 84
integer taborder = 130
boolean bringtotop = true
end type

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

dw_2.SETFILTER('')
dw_2.FILTER()

LVS_COLUMN = 'CHILD_ITEM_CODE'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    dw_2.SETFILTER('')
    dw_2.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

dw_2.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
dw_2.FILTER()
F_MSG_MDI_HELP( STRING( dw_2.ROWCOUNT() ) + " Found" )
end event

type st_1 from so_statictext within w_des_mfs_bom_query
integer x = 1358
integer y = 88
integer width = 507
integer height = 68
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Child  Item Code"
end type

type cb_2 from so_commandbutton within w_des_mfs_bom_query
integer x = 2688
integer y = 48
integer width = 398
integer height = 108
integer taborder = 30
boolean bringtotop = true
string text = "Delete"
end type

event clicked;call super::clicked;if dw_2.getrow() < 1 then return
dw_2.deleterow(dw_2.getrow())
end event

type cb_3 from so_commandbutton within w_des_mfs_bom_query
integer x = 2688
integer y = 168
integer width = 398
integer height = 108
integer taborder = 40
boolean bringtotop = true
string text = "Update"
end type

event clicked;call super::clicked;if dw_2.update() < 0 then 
	rollback;
else
	commit;
	f_msgbox(170)
end if

end event

type cb_4 from so_commandbutton within w_des_mfs_bom_query
integer x = 2286
integer y = 52
integer width = 398
integer height = 108
integer taborder = 30
boolean bringtotop = true
string text = "Use All"
end type

event clicked;call super::clicked;long i
if dw_2.getrow() < 1 then return
do
	i++
	
//	if dw_2.object.check_yn[i] = 'Y' then
//	else
//		continue
//	end if
	
	dw_2.object.used_yn[i] = 'Y' 
	
loop until i = dw_2.rowcount( )
end event

type cb_5 from so_commandbutton within w_des_mfs_bom_query
integer x = 2286
integer y = 168
integer width = 398
integer height = 108
integer taborder = 40
boolean bringtotop = true
string text = "Not Use All"
end type

event clicked;call super::clicked;long i
if dw_2.getrow() < 1 then return
do
	i++
	
//	if dw_2.object.check_yn[i] = 'Y' then
//	else
//		continue
//	end if
	
	dw_2.object.used_yn[i] = 'N' 
	
loop until i = dw_2.rowcount( )
end event

type cb_6 from so_commandbutton within w_des_mfs_bom_query
integer x = 1874
integer y = 168
integer width = 398
integer height = 108
integer taborder = 30
boolean bringtotop = true
string text = "Show Plan"
end type

event clicked;call super::clicked;open(w_plan_master_popup)
end event

type ddlb_model_name from uo_set_model_name_ddlb within w_des_mfs_bom_query
integer x = 32
integer y = 168
integer height = 2036
integer taborder = 140
boolean bringtotop = true
end type

type st_4 from so_statictext within w_des_mfs_bom_query
integer x = 41
integer y = 92
integer width = 795
integer height = 68
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Model Name"
end type

type gb_where_condition from groupbox within w_des_mfs_bom_query
integer x = 1335
integer y = 4
integer width = 1806
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
string text = "MFS BOM Process"
end type

type gb_1 from groupbox within w_des_mfs_bom_query
integer x = 9
integer y = 4
integer width = 1312
integer height = 312
integer taborder = 30
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

