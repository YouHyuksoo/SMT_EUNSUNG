HA$PBExportHeader$w_des_mfs_bom_master.srw
$PBExportComments$BOM $$HEX4$$18c215c800adacb9$$ENDHEX$$
forward
global type w_des_mfs_bom_master from w_main_root
end type
type cbx_show_replace_item from checkbox within w_des_mfs_bom_master
end type
type cbx_show_hide from checkbox within w_des_mfs_bom_master
end type
type st_revision from so_statictext within w_des_mfs_bom_master
end type
type cb_1 from so_commandbutton within w_des_mfs_bom_master
end type
type cb_2 from so_commandbutton within w_des_mfs_bom_master
end type
type cb_3 from so_commandbutton within w_des_mfs_bom_master
end type
type cb_4 from so_commandbutton within w_des_mfs_bom_master
end type
type cb_5 from so_commandbutton within w_des_mfs_bom_master
end type
type ddlb_item_code from uo_item_code within w_des_mfs_bom_master
end type
type st_5 from so_statictext within w_des_mfs_bom_master
end type
type ddlb_model_name from uo_model_name_ddlb within w_des_mfs_bom_master
end type
type st_6 from so_statictext within w_des_mfs_bom_master
end type
type ddlb_revision from uo_mfs_bom_revision_dynamic within w_des_mfs_bom_master
end type
type sle_child_item_code from so_singlelineedit within w_des_mfs_bom_master
end type
type st_1 from so_statictext within w_des_mfs_bom_master
end type
type cb_9 from so_commandbutton within w_des_mfs_bom_master
end type
type cb_10 from so_commandbutton within w_des_mfs_bom_master
end type
type cbx_auto_retrieve from checkbox within w_des_mfs_bom_master
end type
type cb_6 from so_commandbutton within w_des_mfs_bom_master
end type
type gb_2 from so_groupbox within w_des_mfs_bom_master
end type
type gb_1 from so_groupbox within w_des_mfs_bom_master
end type
type gb_where_condition from groupbox within w_des_mfs_bom_master
end type
end forward

global type w_des_mfs_bom_master from w_main_root
integer width = 6162
integer height = 2804
string title = "MFS BOM Master"
string ivs_dw_2_selected_row_yn = "Y"
string ivs_dw_3_selected_row_yn = "Y"
cbx_show_replace_item cbx_show_replace_item
cbx_show_hide cbx_show_hide
st_revision st_revision
cb_1 cb_1
cb_2 cb_2
cb_3 cb_3
cb_4 cb_4
cb_5 cb_5
ddlb_item_code ddlb_item_code
st_5 st_5
ddlb_model_name ddlb_model_name
st_6 st_6
ddlb_revision ddlb_revision
sle_child_item_code sle_child_item_code
st_1 st_1
cb_9 cb_9
cb_10 cb_10
cbx_auto_retrieve cbx_auto_retrieve
cb_6 cb_6
gb_2 gb_2
gb_1 gb_1
gb_where_condition gb_where_condition
end type
global w_des_mfs_bom_master w_des_mfs_bom_master

type variables

end variables

on w_des_mfs_bom_master.create
int iCurrent
call super::create
this.cbx_show_replace_item=create cbx_show_replace_item
this.cbx_show_hide=create cbx_show_hide
this.st_revision=create st_revision
this.cb_1=create cb_1
this.cb_2=create cb_2
this.cb_3=create cb_3
this.cb_4=create cb_4
this.cb_5=create cb_5
this.ddlb_item_code=create ddlb_item_code
this.st_5=create st_5
this.ddlb_model_name=create ddlb_model_name
this.st_6=create st_6
this.ddlb_revision=create ddlb_revision
this.sle_child_item_code=create sle_child_item_code
this.st_1=create st_1
this.cb_9=create cb_9
this.cb_10=create cb_10
this.cbx_auto_retrieve=create cbx_auto_retrieve
this.cb_6=create cb_6
this.gb_2=create gb_2
this.gb_1=create gb_1
this.gb_where_condition=create gb_where_condition
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_show_replace_item
this.Control[iCurrent+2]=this.cbx_show_hide
this.Control[iCurrent+3]=this.st_revision
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.cb_2
this.Control[iCurrent+6]=this.cb_3
this.Control[iCurrent+7]=this.cb_4
this.Control[iCurrent+8]=this.cb_5
this.Control[iCurrent+9]=this.ddlb_item_code
this.Control[iCurrent+10]=this.st_5
this.Control[iCurrent+11]=this.ddlb_model_name
this.Control[iCurrent+12]=this.st_6
this.Control[iCurrent+13]=this.ddlb_revision
this.Control[iCurrent+14]=this.sle_child_item_code
this.Control[iCurrent+15]=this.st_1
this.Control[iCurrent+16]=this.cb_9
this.Control[iCurrent+17]=this.cb_10
this.Control[iCurrent+18]=this.cbx_auto_retrieve
this.Control[iCurrent+19]=this.cb_6
this.Control[iCurrent+20]=this.gb_2
this.Control[iCurrent+21]=this.gb_1
this.Control[iCurrent+22]=this.gb_where_condition
end on

on w_des_mfs_bom_master.destroy
call super::destroy
destroy(this.cbx_show_replace_item)
destroy(this.cbx_show_hide)
destroy(this.st_revision)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.cb_4)
destroy(this.cb_5)
destroy(this.ddlb_item_code)
destroy(this.st_5)
destroy(this.ddlb_model_name)
destroy(this.st_6)
destroy(this.ddlb_revision)
destroy(this.sle_child_item_code)
destroy(this.st_1)
destroy(this.cb_9)
destroy(this.cb_10)
destroy(this.cbx_auto_retrieve)
destroy(this.cb_6)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.gb_where_condition)
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
Ivs_resize_type    = 'MASTER_DETAIL_F4FIX_23M'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )

ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'Y' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default

ivs_dw_3_selected_row_yn = 'Y'

ivs_dw_1_retrice_cancel_popup_open = 'Y'
ivs_dw_2_retrice_cancel_popup_open = 'Y'
ivs_dw_3_retrice_cancel_popup_open = 'Y'
ivs_dw_4_retrice_cancel_popup_open = 'N'
ivs_dw_5_retrice_cancel_popup_open = 'N'

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
String lvs_mfs , lvs_parent_item_code , lvs_bom_level , lvs_item_code

CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		
				
			   dw_1.reset() 	
                dw_1.retrieve( ddlb_model_name.getcode()+'%'  , ddlb_item_code.text+'%' , Gvi_organization_id  )
				
	CASE 'INSERT'
		
			if dw_3.getrow() < 1 then 
			else
				
				lvs_mfs = dw_3.object.mfs[dw_3.getrow()] 				
				lvs_item_code = dw_3.object.item_code[dw_3.getrow()] 
				lvs_parent_item_code = dw_3.object.parent_item_code[dw_3.getrow()] 
				lvs_bom_level = dw_3.object.bom_level[dw_3.getrow()] 								
				
			end if			
			
				row = dw_3.insertrow(dw_3.getrow())
				dw_3.scrolltorow(row)
				f_set_security_row(dw_3 , row , 'ALL')
		

				dw_3.object.mfs[row]            =  lvs_mfs
				dw_3.object.item_code[row] = lvs_item_code
				dw_3.object.parent_item_code[row] = lvs_parent_item_code
				dw_3.object.bom_level[row] = lvs_bom_level

			F_MSG_MDI_HELP ( F_MSG_ST(152)	 )			
	CASE 'APPEND'
			dw_3.enabled = true
			row = dw_3.insertrow(dw_3.getrow())
			dw_3.scrolltorow(row)
			f_set_security_row(dw_3 , row , 'ALL')
			
			
			F_MSG_MDI_HELP ( F_MSG_ST(152)	 )
			
	CASE 'DELETE'
		
		  	if dw_3.getrow() < 1 then return 
		
			if dw_3.object.confirm_yn[dw_3.getrow()] = 'Y' then 
				//Mes sagebox("Notify" , "Aready Confirmed Can`t Delete")
				f_msg(  "Aready Confirmed Can`t Delete",'P')
			   return
			end if
			
			msg =f_msgbox(1003)
			if msg = 1 then
				gvl_row_deleted = dw_3.getrow()			
				dw_3.deleterow(gvl_row_deleted)		
				dw_3.setfocus()
				row = dw_3.getrow()
				dw_3.scrolltorow(row)
				dw_3.setcolumn(1)
			end if

	CASE 'UPDATE'
			
			msg = f_msgbox( 1170)
			if msg = 1 then
				
					if dw_3.update( ) < 0 then 
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

type dw_5 from w_main_root`dw_5 within w_des_mfs_bom_master
integer y = 320
integer height = 1084
string dataobject = "d_des_bom_query"
end type

type dw_4 from w_main_root`dw_4 within w_des_mfs_bom_master
integer x = 2240
integer y = 316
integer width = 2217
integer height = 1084
boolean titlebar = true
string title = "Feeder Layout"
string dataobject = "d_smt_bom_group_lst"
borderstyle borderstyle = stylebox!
end type

type dw_3 from w_main_root`dw_3 within w_des_mfs_bom_master
integer x = 2240
integer y = 1404
integer width = 2217
integer height = 1084
boolean titlebar = true
string title = "MFS Bom List"
string dataobject = "d_des_mfs_bom_lst"
borderstyle borderstyle = stylebox!
end type

type dw_2 from w_main_root`dw_2 within w_des_mfs_bom_master
integer y = 1404
integer width = 2231
integer height = 1084
boolean titlebar = true
string title = "MFS BOM List"
string dataobject = "d_des_mfs_bom_4_query_lst"
borderstyle borderstyle = stylebox!
end type

event dw_2::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return




if cbx_auto_retrieve.checked = true then 
	dw_3.RETRIEVE(   this.object.item_code[currentrow] , this.object.mfs[currentrow] ,  GVI_ORGANIZATION_ID)
	dw_3.SETFOCUS()
end if 


dw_4.retrieve( this.object.smt_model_name[this.getrow()]  , this.object.mfs[this.getrow()]  , gvi_organization_id )
end event

type dw_1 from w_main_root`dw_1 within w_des_mfs_bom_master
integer y = 316
integer width = 2231
integer height = 1084
boolean titlebar = true
string title = "Model Master List"
string dataobject = "d_pln_product_model_master_4_mfs_bom_lst"
borderstyle borderstyle = stylebox!
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;if dw_1.getrow() < 1 then return 

dw_2.reset()
dw_3.reset()
dw_2.retrieve( dw_1.object.item_code[dw_1.getrow()]  , '%'  , gvi_organization_id )

//IF CURRENTROW < 1 THEN RETURN
//
//DOUBLE LVDB_SESSION_ID
//DW_2.RESET()
//
//IF  this.object.item_code[currentrow] = '%' THEN 
//     F_MSGBOX(9050) //SET $$HEX9$$80bd88d444c7200085c725b858d538c194c6$$ENDHEX$$
//	RETURN
//END IF
//
//if cbx_show_hide.checked = true  then
//	
//	LVDB_SESSION_ID = F_BOM_QUERY_ALL_PRC( this.object.item_code[currentrow] , f_t_sysdate())
//	
//else
//	
//	LVDB_SESSION_ID = F_BOM_QUERY_PRC( this.object.item_code[currentrow] , f_t_sysdate())
//
//end if
//
//IF LVDB_SESSION_ID <= 0 THEN
//	ROLLBACK;
//	f_msgbox1(9051 ,this.object.item_code[currentrow]  )    	
//ELSE
//     dw_2.retrieve( LVDB_SESSION_ID , GVI_ORGANIZATION_ID )
//	dw_2.setfocus()
//	rollback;
//END IF
//
////$$HEX8$$00b3b4cc80bd88d420005cd4dcc22000$$ENDHEX$$
//IF CBX_SHOW_REPLACE_ITEM.CHECKED = TRUE THEN 
//	F_SET_REPLACE_ITEM_4_BOM_QUERY( dw_2 )
//	dw_2.RESETUPDATE()
//END IF

ddlb_revision.redraw( this.object.item_code[currentrow] )

end event

type uo_tabpages from w_main_root`uo_tabpages within w_des_mfs_bom_master
end type

type cbx_show_replace_item from checkbox within w_des_mfs_bom_master
integer x = 1938
integer y = 44
integer width = 635
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
string text = "Show Replace Item"
end type

type cbx_show_hide from checkbox within w_des_mfs_bom_master
integer x = 1938
integer y = 116
integer width = 635
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
string text = "Show Hide Item"
boolean checked = true
end type

type st_revision from so_statictext within w_des_mfs_bom_master
integer x = 1435
integer y = 84
integer width = 416
integer height = 52
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Revision"
end type

type cb_1 from so_commandbutton within w_des_mfs_bom_master
integer x = 2702
integer y = 52
integer width = 485
integer height = 108
integer taborder = 40
boolean bringtotop = true
string text = "MFS BOM Generate"
end type

event clicked;call super::clicked;Int i
String lvs_mfs , Lvs_item_code
Datetime lvdt_plan_date
Double    lvdb_return

if dw_1.getrow( ) < 1 then
	return
end if

lvs_mfs    =  ddlb_revision.getcode()
if lvs_mfs = '' or isnull(lvs_mfs) then 
	f_msgbox1(102 , st_revision.text )
	return 
end if 

msg = f_msgbox1( 1161, this.text)
if msg = 1 then 
else
	return
end if

//Do
//	i++
//	
//	if dw_1.object.check_yn[i] = 'Y' then
//	else
//		continue
//	end if
	
     
	lvs_item_code  = dw_1.object.item_code[dw_1.getrow()]
	lvdt_plan_date = f_t_sysdate() //dw_1.object.plan_date[i]
	
	
	
	if lvs_item_code = '' or isnull(lvs_item_code) then 
		//Messagebox( "Error" , "$$HEX13$$88d4a9ba54cfdcb47cb92000f1b45db8200074d5fcc838c194c6$$ENDHEX$$")
		f_msg(  "$$HEX13$$88d4a9ba54cfdcb47cb92000f1b45db8200074d5fcc838c194c6$$ENDHEX$$",'P')
		return 
	end if 
//===========================================
//
//===========================================
	if cbx_show_hide.checked = true then 
		lvdb_return = f_gen_mfs_bom( lvs_mfs , lvs_item_code , lvdt_plan_date , 'Y' )
	else
		lvdb_return = f_gen_mfs_bom( lvs_mfs , lvs_item_code , lvdt_plan_date , 'N' )		
	end if

	if f_sql_check() < 0 then 
		return
	end if
	
	if lvdb_return < 0 then
	   //Messagebox("Notify" , "MFS BOM Not found" )	
	   f_msg( "MFS BOM Not found",'P') 
	   Rollback;
	   Return	
	end if

//loop until i = dw_1.rowcount( )

msg = f_msgbox( 1170)
if msg = 1 then 
	commit ;
	f_retrieve()
else
	rollback;
end if
end event

type cb_2 from so_commandbutton within w_des_mfs_bom_master
integer x = 3200
integer y = 168
integer width = 485
integer height = 108
integer taborder = 50
boolean bringtotop = true
string text = "MFS BOM Drop"
end type

event clicked;call super::clicked;Int i
String lvs_mfs , Lvs_item_code

Double    lvdb_return
if dw_2.getrow( ) < 1 then
	return
end if

msg = f_msgbox1( 1161, this.text)
if msg = 1 then 
else
	return
end if


	lvs_item_code = dw_2.object.item_code[dw_2.getrow()]
	lvs_mfs = dw_2.object.mfs[dw_2.getrow()]

//===========================================
//
//===========================================

	delete from id_mfs_bom 
	where item_code = :lvs_item_code
	    and mfs = :lvs_mfs
	    and organization_id = :gvi_organization_id ;
		
	if f_sql_check() < 0 then
		return
	end if

	dw_2.deleterow( dw_2.getrow())

//loop until i = dw_1.rowcount( )

msg = f_msgbox( 1170)
if msg = 1 then 
	commit ;
else
	rollback;
end if
end event

type cb_3 from so_commandbutton within w_des_mfs_bom_master
integer x = 3200
integer y = 52
integer width = 485
integer height = 108
integer taborder = 60
boolean bringtotop = true
string text = "MFS BOM Copy"
end type

event clicked;call super::clicked;open(w_des_mfs_bom_copy_popup)
end event

type cb_4 from so_commandbutton within w_des_mfs_bom_master
integer x = 3694
integer y = 48
integer width = 485
integer height = 108
integer taborder = 70
boolean bringtotop = true
string text = "MFS BOM Confirm"
end type

event clicked;call super::clicked;string lvs_mfs , lvs_item_code

if dw_1.getrow() < 1 then return

msg = f_msgbox1(1161 , this.text )
if msg = 1 then 
	
	lvs_mfs =   ddlb_revision.getcode()//dw_1.object.mfs[dw_1.getrow()] 
	
	if lvs_mfs = '' or isnull(lvs_mfs) then 
		f_msgbox1(102 , st_revision.text )
		return 
	end if 	
	
	lvs_item_code= dw_1.object.item_code[dw_1.getrow()] 
	
	update id_mfs_bom set confirm_yn = 'Y' , confirm_date = sysdate , confirm_by = :gvs_user_id 
	where mfs = :lvs_mfs
	    and item_code = :lvs_item_code
	    and organization_id = :gvi_organization_id ;
		
	if f_sql_check() < 0 then 
		return
	end if
	
else

	return
	
end if
//=====================
//
//=====================
	commit ;
	f_msgbox(1170)
	

end event

type cb_5 from so_commandbutton within w_des_mfs_bom_master
integer x = 3694
integer y = 164
integer width = 485
integer height = 108
integer taborder = 80
boolean bringtotop = true
string text = "MFS BOM Cancel"
end type

event clicked;call super::clicked;string lvs_mfs , lvs_item_code

if dw_1.getrow() < 1 then return

msg = f_msgbox1(1161 , this.text )
if msg = 1 then 
	
	lvs_mfs = ddlb_revision.getcode() //dw_1.object.mfs[dw_1.getrow()] 
	if lvs_mfs = '' or isnull(lvs_mfs) then 
		f_msgbox1(102 , st_revision.text )
		return 
	end if 
	lvs_item_code= dw_1.object.item_code[dw_1.getrow()] 
	
	update id_mfs_bom set confirm_yn = 'N' , confirm_date = null , confirm_by = ''
	where mfs = :lvs_mfs
	    and item_code = :lvs_item_code
	    and NVL(used_yn, 'N') = 'N'
	    and organization_id = :gvi_organization_id ;
		
	if f_sql_check() < 0 then 
		return
	end if
	
else

	return
	
end if
//=====================
//
//=====================
	commit ;
	f_msgbox(1170)
	

end event

type ddlb_item_code from uo_item_code within w_des_mfs_bom_master
integer x = 718
integer y = 172
integer width = 709
integer height = 1996
integer taborder = 120
boolean bringtotop = true
end type

event selectionchanged;call super::selectionchanged;ddlb_revision.redraw( this.text )
end event

type st_5 from so_statictext within w_des_mfs_bom_master
integer x = 718
integer y = 100
integer width = 709
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type ddlb_model_name from uo_model_name_ddlb within w_des_mfs_bom_master
integer x = 41
integer y = 172
integer width = 663
integer height = 1996
integer taborder = 120
boolean bringtotop = true
end type

type st_6 from so_statictext within w_des_mfs_bom_master
integer x = 50
integer y = 104
integer width = 654
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Model Name"
end type

type ddlb_revision from uo_mfs_bom_revision_dynamic within w_des_mfs_bom_master
integer x = 1435
integer y = 172
integer width = 416
integer height = 1996
integer taborder = 20
boolean bringtotop = true
end type

type sle_child_item_code from so_singlelineedit within w_des_mfs_bom_master
integer x = 4251
integer y = 176
integer width = 507
integer height = 84
integer taborder = 140
boolean bringtotop = true
end type

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

dw_3.SETFILTER('')
dw_3.FILTER()

LVS_COLUMN = 'CHILD_ITEM_CODE'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    dw_3.SETFILTER('')
    dw_3.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

dw_3.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
dw_3.FILTER()
F_MSG_MDI_HELP( STRING( dw_3.ROWCOUNT() ) + " Found" )
end event

type st_1 from so_statictext within w_des_mfs_bom_master
integer x = 4251
integer y = 84
integer width = 507
integer height = 68
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Child  Item Code"
end type

type cb_9 from so_commandbutton within w_des_mfs_bom_master
integer x = 4791
integer y = 36
integer width = 398
integer height = 108
integer taborder = 100
boolean bringtotop = true
string text = "Use All"
end type

event clicked;call super::clicked;long i
if dw_3.getrow() < 1 then return
do
	i++
	
//	if dw_2.object.check_yn[i] = 'Y' then
//	else
//		continue
//	end if
	
	dw_3.object.used_yn[i] = 'Y' 
	
loop until i = dw_3.rowcount( )


if dw_3.update()  < 0 then 
   return 
else
	commit ;
end if 
end event

type cb_10 from so_commandbutton within w_des_mfs_bom_master
integer x = 4791
integer y = 152
integer width = 398
integer height = 108
integer taborder = 60
boolean bringtotop = true
string text = "Not Use All"
end type

event clicked;call super::clicked;long i
if dw_3.getrow() < 1 then return
do
	i++
	
//	if dw_2.object.check_yn[i] = 'Y' then
//	else
//		continue
//	end if
	
	dw_3.object.used_yn[i] = 'N' 
	
loop until i = dw_3.rowcount( )

if dw_3.update()  < 0 then 
   return 
else
	commit ;
end if 
end event

type cbx_auto_retrieve from checkbox within w_des_mfs_bom_master
integer x = 1938
integer y = 192
integer width = 690
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
string text = "MFS Bom Auto Retrieve"
end type

type cb_6 from so_commandbutton within w_des_mfs_bom_master
integer x = 2702
integer y = 164
integer width = 485
integer height = 108
integer taborder = 50
boolean bringtotop = true
string text = "Show 4M List"
end type

event clicked;call super::clicked;if dw_1.getrow() < 1 then return 
openwithparm( w_qc_4m_popup , string( dw_1.object.master_model_name[dw_1.getrow()] ))
end event

type gb_2 from so_groupbox within w_des_mfs_bom_master
integer x = 2679
integer width = 1527
integer height = 292
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_1 from so_groupbox within w_des_mfs_bom_master
integer width = 2661
integer height = 296
integer taborder = 40
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_where_condition from groupbox within w_des_mfs_bom_master
integer x = 4229
integer width = 992
integer height = 292
integer taborder = 20
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

