HA$PBExportHeader$w_pln_product_model_simple_master.srw
$PBExportComments$$$HEX17$$b9c278c7d0c658c7a8ba78b3d0c5200000b35cd52000b9d231c144c7200000adacb9$$ENDHEX$$
forward
global type w_pln_product_model_simple_master from w_main_root
end type
type st_mrm_no from statictext within w_pln_product_model_simple_master
end type
type sle_model_name from so_singlelineedit within w_pln_product_model_simple_master
end type
type cb_2 from so_commandbutton within w_pln_product_model_simple_master
end type
type st_2 from statictext within w_pln_product_model_simple_master
end type
type ddlb_customer_code from uo_customer_code_name within w_pln_product_model_simple_master
end type
type sle_item_code from so_singlelineedit within w_pln_product_model_simple_master
end type
type st_3 from statictext within w_pln_product_model_simple_master
end type
type sle_master_model_name from so_singlelineedit within w_pln_product_model_simple_master
end type
type st_4 from statictext within w_pln_product_model_simple_master
end type
type cb_1 from so_commandbutton within w_pln_product_model_simple_master
end type
type uo_dateend from uo_ymd_calendar within w_pln_product_model_simple_master
end type
type st_1 from statictext within w_pln_product_model_simple_master
end type
type ddlb_model_type from uo_basecode within w_pln_product_model_simple_master
end type
type st_5 from statictext within w_pln_product_model_simple_master
end type
type gb_1 from so_groupbox within w_pln_product_model_simple_master
end type
end forward

global type w_pln_product_model_simple_master from w_main_root
integer width = 6053
integer height = 2952
string title = "Product Model Master"
st_mrm_no st_mrm_no
sle_model_name sle_model_name
cb_2 cb_2
st_2 st_2
ddlb_customer_code ddlb_customer_code
sle_item_code sle_item_code
st_3 st_3
sle_master_model_name sle_master_model_name
st_4 st_4
cb_1 cb_1
uo_dateend uo_dateend
st_1 st_1
ddlb_model_type ddlb_model_type
st_5 st_5
gb_1 gb_1
end type
global w_pln_product_model_simple_master w_pln_product_model_simple_master

on w_pln_product_model_simple_master.create
int iCurrent
call super::create
this.st_mrm_no=create st_mrm_no
this.sle_model_name=create sle_model_name
this.cb_2=create cb_2
this.st_2=create st_2
this.ddlb_customer_code=create ddlb_customer_code
this.sle_item_code=create sle_item_code
this.st_3=create st_3
this.sle_master_model_name=create sle_master_model_name
this.st_4=create st_4
this.cb_1=create cb_1
this.uo_dateend=create uo_dateend
this.st_1=create st_1
this.ddlb_model_type=create ddlb_model_type
this.st_5=create st_5
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_mrm_no
this.Control[iCurrent+2]=this.sle_model_name
this.Control[iCurrent+3]=this.cb_2
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.ddlb_customer_code
this.Control[iCurrent+6]=this.sle_item_code
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.sle_master_model_name
this.Control[iCurrent+9]=this.st_4
this.Control[iCurrent+10]=this.cb_1
this.Control[iCurrent+11]=this.uo_dateend
this.Control[iCurrent+12]=this.st_1
this.Control[iCurrent+13]=this.ddlb_model_type
this.Control[iCurrent+14]=this.st_5
this.Control[iCurrent+15]=this.gb_1
end on

on w_pln_product_model_simple_master.destroy
call super::destroy
destroy(this.st_mrm_no)
destroy(this.sle_model_name)
destroy(this.cb_2)
destroy(this.st_2)
destroy(this.ddlb_customer_code)
destroy(this.sle_item_code)
destroy(this.st_3)
destroy(this.sle_master_model_name)
destroy(this.st_4)
destroy(this.cb_1)
destroy(this.uo_dateend)
destroy(this.st_1)
destroy(this.ddlb_model_type)
destroy(this.st_5)
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
Ivs_resize_type                      = 'MASTER_DETAIL_145_23M'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


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

event ue_data_control;call super::ue_data_control;Long ROW
STRING LVS_SETYN
CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		

		     dw_1.reset()
		     dw_2.reset()
			dw_3.reset()
			
			dw_1.RETRIEVE(  sle_model_name.text+'%' ,  ddlb_customer_code.getcode( )+'%' ,  sle_item_code.text +'%' ,   sle_master_model_name.text+'%' , GVI_ORGANIZATION_ID, uo_dateend.text() , ddlb_model_type.getcode( )+'%' )
			dw_1.SETFOCUS()
	
		
	CASE 'INSERT'
		
		             if ( GVI_USER_LEVEL <> 9 ) then
						messagebox("$$HEX2$$bdace0ac$$ENDHEX$$", "$$HEX14$$a8ba78b32000f1b45db88cad5cd574c72000c6c5b5c2c8b2e4b22000$$ENDHEX$$( USER LEVEL : 9 ) => " + string( GVI_USER_LEVEL ) )
						return
					end if
	
					row =dw_2.insertrow(dw_2.getrow())
					dw_2.scrolltorow(row)
					f_set_security_row(dw_2 , row , 'ALL')
					F_MSG_MDI_HELP ( F_MSG_ST(152)	 )
					
					dw_2.object.model_suffix[row] = '*'

			
	CASE 'APPEND'
		
		                 if ( GVI_USER_LEVEL <> 9 ) then
						    messagebox("$$HEX2$$bdace0ac$$ENDHEX$$", "$$HEX14$$a8ba78b3200094cd00ac8cad5cd574c72000c6c5b5c2c8b2e4b22000$$ENDHEX$$( USER LEVEL : 9 ) => " + string( GVI_USER_LEVEL ) )
					   	    return
					   end if
				
						row =dw_2.insertrow(0)
						dw_2.scrolltorow(row)
						f_set_security_row(dw_2 , row , 'ALL')
						F_MSG_MDI_HELP ( F_MSG_ST(152)	 )	
						dw_2.object.model_suffix[row] = '*'

	CASE 'DELETE'
		
			
		        if ( GVI_USER_LEVEL <> 9 ) then
				    messagebox("$$HEX2$$bdace0ac$$ENDHEX$$", "$$HEX14$$a8ba78b32000adc01cc88cad5cd574c72000c6c5b5c2c8b2e4b22000$$ENDHEX$$( USER LEVEL : 9 ) => " + string( GVI_USER_LEVEL ) )
				    return
			   end if
						
				if dw_2.getrow() < 1 then return 
						  
						msg =f_msgbox(1003)
						if msg = 1 then
							gvl_row_deleted =dw_2.getrow()			
							dw_2.deleterow(gvl_row_deleted)		
							dw_2.setfocus()
							row =dw_2.getrow()
							dw_2.scrolltorow(row)
							dw_2.setcolumn(1)
						end if
		
	CASE 'UPDATE'
		
		if ( GVI_USER_LEVEL <> 9 ) then
			 messagebox("$$HEX2$$bdace0ac$$ENDHEX$$", "$$HEX14$$a8ba78b3200000c8a5c78cad5cd574c72000c6c5b5c2c8b2e4b22000$$ENDHEX$$( USER LEVEL : 9 ) => " + string( GVI_USER_LEVEL ) )
		     return
		end if		
		
		dw_2.ACCEPTTEXT()
 
	      IF   dw_2.UPDATE() < 0  THEN
				F_MSG('$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$' , 'P' ) 
				ROLLBACK;
				RETURN
		ELSE
				 COMMIT;
       			 F_MSG_MDI_HELP ( F_MSG_ST(170)	 ) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
		END IF

	CASE ELSE
END CHOOSE


end event

type dw_5 from w_main_root`dw_5 within w_pln_product_model_simple_master
integer y = 316
end type

type dw_4 from w_main_root`dw_4 within w_pln_product_model_simple_master
integer x = 2345
integer y = 1400
integer width = 2341
integer height = 1156
end type

type dw_3 from w_main_root`dw_3 within w_pln_product_model_simple_master
integer x = 2341
integer y = 1400
integer width = 2341
integer height = 1156
boolean titlebar = true
string dataobject = "d_smt_plandata_4_model_master_lst"
end type

type dw_2 from w_main_root`dw_2 within w_pln_product_model_simple_master
integer y = 1400
integer width = 2341
integer height = 1156
boolean titlebar = true
string dataobject = "d_pln_product_model_master_SIMPLE_mst"
borderstyle borderstyle = styleraised!
end type

event dw_2::itemchanged;call super::itemchanged;if dwo.name = 'model_name' then
	this.accepttext( )
	this.object.smt_model_name[row] = data
	this.object.master_model_name[row] = data
//	this.object.customer_master_model_name[row] = data
//	this.object.master_spec[row] = data
elseif dwo.name = 'item_code' then
	this.accepttext( )	
	this.object.part_no[row] = data
end if 

end event

event dw_2::clicked;call super::clicked;
if dwo.name = 'b_new' then 
	
	open( w_des_new_model_item_popup_es)
	
	if Gst_return.gvb_return = true then
		this.object.item_code[row] = message.stringparm
	end if 
	
end if
end event

type dw_1 from w_main_root`dw_1 within w_pln_product_model_simple_master
integer y = 308
integer width = 4681
integer height = 1088
boolean titlebar = true
string title = "Product Model List"
string dataobject = "d_pln_product_model_master_lst"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 
dw_2.retrieve( this.object.model_name[currentrow])
dw_3.retrieve( '%' , this.object.smt_model_name[currentrow])

end event

type uo_tabpages from w_main_root`uo_tabpages within w_pln_product_model_simple_master
end type

type st_mrm_no from statictext within w_pln_product_model_simple_master
integer x = 750
integer y = 92
integer width = 603
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

type sle_model_name from so_singlelineedit within w_pln_product_model_simple_master
integer x = 750
integer y = 188
integer width = 603
integer taborder = 30
boolean bringtotop = true
end type

type cb_2 from so_commandbutton within w_pln_product_model_simple_master
integer x = 3771
integer y = 116
integer width = 576
integer height = 112
integer taborder = 50
boolean bringtotop = true
string text = "Show BOM"
end type

event clicked;call super::clicked;string lvs_item_code

if dw_1.getrow() < 1 then return

lvs_item_code = dw_1.getitemstring( dw_1.getrow() , 'item_code' )
if lvs_item_code = '' or isnull(lvs_item_code) then return

openwithparm( w_des_bom_query_popup , lvs_item_code )
end event

type st_2 from statictext within w_pln_product_model_simple_master
integer x = 105
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
string text = "Customer Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_customer_code from uo_customer_code_name within w_pln_product_model_simple_master
integer x = 105
integer y = 184
integer width = 631
integer height = 1808
integer taborder = 40
boolean bringtotop = true
end type

type sle_item_code from so_singlelineedit within w_pln_product_model_simple_master
integer x = 1367
integer y = 188
integer width = 603
integer taborder = 40
boolean bringtotop = true
end type

type st_3 from statictext within w_pln_product_model_simple_master
integer x = 1367
integer y = 92
integer width = 603
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Item Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_master_model_name from so_singlelineedit within w_pln_product_model_simple_master
integer x = 1984
integer y = 188
integer width = 603
integer taborder = 60
boolean bringtotop = true
end type

type st_4 from statictext within w_pln_product_model_simple_master
integer x = 1984
integer y = 92
integer width = 603
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Master Model Name"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_1 from so_commandbutton within w_pln_product_model_simple_master
integer x = 4361
integer y = 116
integer width = 576
integer height = 112
integer taborder = 20
boolean bringtotop = true
string text = "Show JIG / Sample"
end type

event clicked;call super::clicked;string lvs_item_code

if dw_1.getrow() < 1 then return

lvs_item_code = dw_1.getitemstring( dw_1.getrow() , 'model_name' )
if lvs_item_code = '' or isnull(lvs_item_code) then return

openwithparm( w_mcn_jig_sample_query_popup , lvs_item_code )
end event

type uo_dateend from uo_ymd_calendar within w_pln_product_model_simple_master
event destroy ( )
integer x = 3186
integer y = 184
integer taborder = 70
boolean bringtotop = true
long backcolor = 12632256
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_1 from statictext within w_pln_product_model_simple_master
integer x = 3186
integer y = 92
integer width = 425
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Date END"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_model_type from uo_basecode within w_pln_product_model_simple_master
integer x = 2597
integer y = 184
integer width = 475
integer taborder = 70
boolean bringtotop = true
end type

event constructor;call super::constructor;redraw('MODEL TYPE')
end event

type st_5 from statictext within w_pln_product_model_simple_master
integer x = 2601
integer y = 92
integer width = 475
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Model type"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_1 from so_groupbox within w_pln_product_model_simple_master
integer x = 9
integer y = 4
integer width = 3694
integer height = 304
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

