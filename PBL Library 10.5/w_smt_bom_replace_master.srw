HA$PBExportHeader$w_smt_bom_replace_master.srw
$PBExportComments$$$HEX6$$80bd88d42000c8b9a4c230d1$$ENDHEX$$
forward
global type w_smt_bom_replace_master from w_main_root
end type
type uo_item from uo_item_code within w_smt_bom_replace_master
end type
type st_5 from so_statictext within w_smt_bom_replace_master
end type
type ddlb_replace_item from uo_item_code within w_smt_bom_replace_master
end type
type st_1 from so_statictext within w_smt_bom_replace_master
end type
type st_2 from so_statictext within w_smt_bom_replace_master
end type
type ddlb_smt_model_name from uo_smt_layout_model_name_ddlb within w_smt_bom_replace_master
end type
type gb_2 from so_groupbox within w_smt_bom_replace_master
end type
end forward

global type w_smt_bom_replace_master from w_main_root
integer width = 4736
integer height = 2904
string title = "SMT BOM Replace Master"
uo_item uo_item
st_5 st_5
ddlb_replace_item ddlb_replace_item
st_1 st_1
st_2 st_2
ddlb_smt_model_name ddlb_smt_model_name
gb_2 gb_2
end type
global w_smt_bom_replace_master w_smt_bom_replace_master

on w_smt_bom_replace_master.create
int iCurrent
call super::create
this.uo_item=create uo_item
this.st_5=create st_5
this.ddlb_replace_item=create ddlb_replace_item
this.st_1=create st_1
this.st_2=create st_2
this.ddlb_smt_model_name=create ddlb_smt_model_name
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_item
this.Control[iCurrent+2]=this.st_5
this.Control[iCurrent+3]=this.ddlb_replace_item
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.ddlb_smt_model_name
this.Control[iCurrent+7]=this.gb_2
end on

on w_smt_bom_replace_master.destroy
call super::destroy
destroy(this.uo_item)
destroy(this.st_5)
destroy(this.ddlb_replace_item)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.ddlb_smt_model_name)
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

end event

event ue_data_control;call super::ue_data_control;Long ROW
STRING LVS_SETYN
CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		   
			DW_1.RETRIEVE(  ddlb_smt_model_name.getcode( )+'%' , uo_item.text( )+'%' ,  ddlb_replace_item.text()+'%' ,    GVI_ORGANIZATION_ID )
			DW_1.SETFOCUS()
				
	CASE 'INSERT'
			dw_1.enabled = true
			row = dw_1.insertrow(dw_1.getrow())
			dw_1.scrolltorow(row)
			f_set_security_row(dw_1 , row , 'ALL')
			F_MSG_MDI_HELP ( F_MSG_ST(152)	 )
	CASE 'APPEND'
			dw_1.enabled = true
			row = dw_1.insertrow(0)
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
		
		DW_1.ACCEPTTEXT()
 
	      IF DW_1.UPDATE() < 0 THEN
				ROLLBACK;
				RETURN
		ELSE
				 COMMIT;
       			 F_MSG_MDI_HELP ( F_MSG_ST(170)	 ) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
		END IF

	CASE ELSE
END CHOOSE


end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
f_retrieve()
end event

type dw_5 from w_main_root`dw_5 within w_smt_bom_replace_master
integer y = 320
end type

type dw_4 from w_main_root`dw_4 within w_smt_bom_replace_master
integer x = 5
integer y = 320
end type

type dw_3 from w_main_root`dw_3 within w_smt_bom_replace_master
integer x = 5
integer y = 320
integer taborder = 50
end type

type dw_2 from w_main_root`dw_2 within w_smt_bom_replace_master
integer x = 5
integer y = 320
integer taborder = 0
boolean titlebar = true
end type

type dw_1 from w_main_root`dw_1 within w_smt_bom_replace_master
integer x = 5
integer y = 320
integer width = 4507
integer height = 1208
integer taborder = 40
boolean titlebar = true
string title = "Replace List"
string dataobject = "d_des_bom_smt_replace_lst"
end type

event dw_1::itemchanged;call super::itemchanged;if dwo.name = 'line_code' or dwo.name ='machine' or dwo.name ='table_id' or dwo.name ='address' or dwo.name ='position' then
	
	this.object.location_code[row] = this.object.line_code[row]+this.object.machine[row]+this.object.table_id[row]+this.object.address[row]+this.object.position[row]
	
end if 
end event

type uo_tabpages from w_main_root`uo_tabpages within w_smt_bom_replace_master
end type

type uo_item from uo_item_code within w_smt_bom_replace_master
integer x = 914
integer y = 168
integer width = 695
integer height = 1628
integer taborder = 50
boolean bringtotop = true
end type

type st_5 from so_statictext within w_smt_bom_replace_master
integer x = 914
integer y = 84
integer width = 695
integer height = 68
boolean bringtotop = true
boolean enabled = false
string text = "Item Code"
end type

type ddlb_replace_item from uo_item_code within w_smt_bom_replace_master
integer x = 1623
integer y = 168
integer width = 695
integer height = 1628
integer taborder = 40
boolean bringtotop = true
end type

type st_1 from so_statictext within w_smt_bom_replace_master
integer x = 1623
integer y = 88
integer width = 695
integer height = 68
boolean bringtotop = true
boolean enabled = false
string text = "Replace Item Code"
end type

type st_2 from so_statictext within w_smt_bom_replace_master
integer x = 78
integer y = 84
integer width = 823
integer height = 68
boolean bringtotop = true
boolean enabled = false
string text = "SMT Model Name"
end type

type ddlb_smt_model_name from uo_smt_layout_model_name_ddlb within w_smt_bom_replace_master
integer x = 78
integer y = 168
integer width = 823
integer taborder = 20
boolean bringtotop = true
end type

type gb_2 from so_groupbox within w_smt_bom_replace_master
integer x = 14
integer width = 2345
integer height = 300
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

