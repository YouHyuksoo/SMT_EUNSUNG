HA$PBExportHeader$w_mat_workstage_inventory_check_master.srw
$PBExportComments$Material Inventory Check Master
forward
global type w_mat_workstage_inventory_check_master from w_main_root
end type
type st_1 from so_statictext within w_mat_workstage_inventory_check_master
end type
type ddlb_item_code from uo_item_code within w_mat_workstage_inventory_check_master
end type
type em_yyyymm from uo_ym within w_mat_workstage_inventory_check_master
end type
type st_2 from so_statictext within w_mat_workstage_inventory_check_master
end type
type cb_generate from so_commandbutton within w_mat_workstage_inventory_check_master
end type
type cb_check from so_commandbutton within w_mat_workstage_inventory_check_master
end type
type st_3 from so_statictext within w_mat_workstage_inventory_check_master
end type
type ddlb_workstage_code from uo_workstage_code_all within w_mat_workstage_inventory_check_master
end type
type st_6 from so_statictext within w_mat_workstage_inventory_check_master
end type
type ddlb_line_code from uo_line_code within w_mat_workstage_inventory_check_master
end type
type ddlb_item_division from uo_item_division within w_mat_workstage_inventory_check_master
end type
type st_4 from so_statictext within w_mat_workstage_inventory_check_master
end type
type cbx_check_qty_auto_set from so_checkbox within w_mat_workstage_inventory_check_master
end type
type cbx_regenerate from so_checkbox within w_mat_workstage_inventory_check_master
end type
type cb_1 from so_commandbutton within w_mat_workstage_inventory_check_master
end type
type cbx_inventory_close from so_checkbox within w_mat_workstage_inventory_check_master
end type
type cbx_check_by_mfs from so_checkbox within w_mat_workstage_inventory_check_master
end type
type cbx_check_by_line_ws from so_checkbox within w_mat_workstage_inventory_check_master
end type
type cbx_check_by_material_mfs from so_checkbox within w_mat_workstage_inventory_check_master
end type
type cb_3 from so_commandbutton within w_mat_workstage_inventory_check_master
end type
type cb_4 from so_commandbutton within w_mat_workstage_inventory_check_master
end type
type gb_1 from so_groupbox within w_mat_workstage_inventory_check_master
end type
type gb_2 from so_groupbox within w_mat_workstage_inventory_check_master
end type
end forward

global type w_mat_workstage_inventory_check_master from w_main_root
integer width = 4608
integer height = 2760
string title = "Workstage Inventory Check Master"
st_1 st_1
ddlb_item_code ddlb_item_code
em_yyyymm em_yyyymm
st_2 st_2
cb_generate cb_generate
cb_check cb_check
st_3 st_3
ddlb_workstage_code ddlb_workstage_code
st_6 st_6
ddlb_line_code ddlb_line_code
ddlb_item_division ddlb_item_division
st_4 st_4
cbx_check_qty_auto_set cbx_check_qty_auto_set
cbx_regenerate cbx_regenerate
cb_1 cb_1
cbx_inventory_close cbx_inventory_close
cbx_check_by_mfs cbx_check_by_mfs
cbx_check_by_line_ws cbx_check_by_line_ws
cbx_check_by_material_mfs cbx_check_by_material_mfs
cb_3 cb_3
cb_4 cb_4
gb_1 gb_1
gb_2 gb_2
end type
global w_mat_workstage_inventory_check_master w_mat_workstage_inventory_check_master

on w_mat_workstage_inventory_check_master.create
int iCurrent
call super::create
this.st_1=create st_1
this.ddlb_item_code=create ddlb_item_code
this.em_yyyymm=create em_yyyymm
this.st_2=create st_2
this.cb_generate=create cb_generate
this.cb_check=create cb_check
this.st_3=create st_3
this.ddlb_workstage_code=create ddlb_workstage_code
this.st_6=create st_6
this.ddlb_line_code=create ddlb_line_code
this.ddlb_item_division=create ddlb_item_division
this.st_4=create st_4
this.cbx_check_qty_auto_set=create cbx_check_qty_auto_set
this.cbx_regenerate=create cbx_regenerate
this.cb_1=create cb_1
this.cbx_inventory_close=create cbx_inventory_close
this.cbx_check_by_mfs=create cbx_check_by_mfs
this.cbx_check_by_line_ws=create cbx_check_by_line_ws
this.cbx_check_by_material_mfs=create cbx_check_by_material_mfs
this.cb_3=create cb_3
this.cb_4=create cb_4
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.ddlb_item_code
this.Control[iCurrent+3]=this.em_yyyymm
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.cb_generate
this.Control[iCurrent+6]=this.cb_check
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.ddlb_workstage_code
this.Control[iCurrent+9]=this.st_6
this.Control[iCurrent+10]=this.ddlb_line_code
this.Control[iCurrent+11]=this.ddlb_item_division
this.Control[iCurrent+12]=this.st_4
this.Control[iCurrent+13]=this.cbx_check_qty_auto_set
this.Control[iCurrent+14]=this.cbx_regenerate
this.Control[iCurrent+15]=this.cb_1
this.Control[iCurrent+16]=this.cbx_inventory_close
this.Control[iCurrent+17]=this.cbx_check_by_mfs
this.Control[iCurrent+18]=this.cbx_check_by_line_ws
this.Control[iCurrent+19]=this.cbx_check_by_material_mfs
this.Control[iCurrent+20]=this.cb_3
this.Control[iCurrent+21]=this.cb_4
this.Control[iCurrent+22]=this.gb_1
this.Control[iCurrent+23]=this.gb_2
end on

on w_mat_workstage_inventory_check_master.destroy
call super::destroy
destroy(this.st_1)
destroy(this.ddlb_item_code)
destroy(this.em_yyyymm)
destroy(this.st_2)
destroy(this.cb_generate)
destroy(this.cb_check)
destroy(this.st_3)
destroy(this.ddlb_workstage_code)
destroy(this.st_6)
destroy(this.ddlb_line_code)
destroy(this.ddlb_item_division)
destroy(this.st_4)
destroy(this.cbx_check_qty_auto_set)
destroy(this.cbx_regenerate)
destroy(this.cb_1)
destroy(this.cbx_inventory_close)
destroy(this.cbx_check_by_mfs)
destroy(this.cbx_check_by_line_ws)
destroy(this.cbx_check_by_material_mfs)
destroy(this.cb_3)
destroy(this.cb_4)
destroy(this.gb_1)
destroy(this.gb_2)
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

event ue_post_open;call super::ue_post_open;

/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

event ue_data_control;call super::ue_data_control;long row
choose case gvs_ue_data_control
		
	case 'RETRIEVE'
			
			dw_1.retrieve(em_yyyymm.text, ddlb_item_code.text() + '%', ddlb_line_code.getcode()+'%' , ddlb_workstage_code.getcode( )+'%' , ddlb_item_division.getcode( )+'%' ,  gvi_organization_id)
		  
	case 'INSERT'
		
			dw_1.ENABLED = TRUE
			ROW = dw_1.INSERTROW(dw_1.GETROW())
			dw_1.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(dw_1 , ROW ,'ALL')
			dw_1.object.inventory_hold[row] = 'W'
			dw_1.object.close_yyyymm[row] = em_yyyymm.text
			dw_1.object.inventory_qty[row] = 0
			dw_1.object.check_inventory_qty[row] = 0			
			
	case 'APPEND'		
			dw_1.ENABLED = TRUE
			ROW = dw_1.INSERTROW(0)
			dw_1.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(dw_1 , ROW ,'ALL')
			dw_1.object.inventory_hold[row] = 'W'
			dw_1.object.close_yyyymm[row] = em_yyyymm.text
			dw_1.object.inventory_qty[row] = 0
			dw_1.object.check_inventory_qty[row] = 0			
	case 'DELETE'
		
		  	if DW_1.AcceptText() = -1 then
				return
			end if
			
			MSG = F_MSGBOX(1003)  //$$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?
			IF MSG = 1 THEN
				Gvl_row_deleted = DW_1.GetRow()			
				DW_1.DELETEROW(Gvl_row_deleted)		
				DW_1.SetFocus()
				ROW = DW_1.GetRow()
				DW_1.ScrollToRow(row)
				DW_1.SetColumn(1)
			END IF

	case 'UPDATE'
		
			IF DW_1.UPDATE() < 0  THEN
			  	 ROLLBACK;
				 RETURN
			ELSE
				 COMMIT;
				 F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
		               F_RETRIEVE()				 
			END IF

	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_mat_workstage_inventory_check_master
integer y = 328
end type

type dw_4 from w_main_root`dw_4 within w_mat_workstage_inventory_check_master
integer y = 328
end type

type dw_3 from w_main_root`dw_3 within w_mat_workstage_inventory_check_master
integer y = 328
end type

type dw_2 from w_main_root`dw_2 within w_mat_workstage_inventory_check_master
integer y = 2036
integer width = 4530
integer height = 600
boolean titlebar = true
string title = "Workstage Inventory Expand List"
string dataobject = "d_mat_workstage_inventory_expand_lst"
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

event dw_2::rbuttondown;call super::rbuttondown;if dwo.name = 'supplier_code' then 
	open(w_com_supplier_popup)
	if message.stringparm = '' then 
	else
		this.object.supplier_code[row] = message.stringparm
		
	end if 
end if 
end event

type dw_1 from w_main_root`dw_1 within w_mat_workstage_inventory_check_master
integer y = 320
integer width = 4535
integer height = 1716
boolean titlebar = true
string title = "Workstage Inventory Check List"
string dataobject = "d_mat_workstage_inventory_check_lst"
end type

event dw_1::itemchanged;call super::itemchanged;THIS.ACCEPTTEXT()

if dwo.name = 'check_inventory_qty' then 
	this.object.difference_qty[row] = this.object.check_inventory_qty[row] - this.object.inventory_qty[row]
end if
end event

event dw_1::rbuttondown;call super::rbuttondown;IF DWO.NAME = 'item_code' THEN
	OPEN(w_des_item_popup)
	IF message.stringparm = '' THEN 
	ELSE
		THIS.SETITEM( ROW , 'item_code' , message.stringparm )
		THIS.SETITEM( ROW , 'line_type' , Gst_return.Gvs_return[2])
		THIS.SETITEM( ROW , 'item_name' , Gst_return.Gvs_return[3])		
		THIS.SETITEM( ROW , 'item_spec' , Gst_return.Gvs_return[4])				
		THIS.SETITEM( ROW , 'item_uom' , Gst_return.Gvs_return[5])				
		
		
	
		TRIGGER EVENT ITEMCHANGED( ROW , THIS.OBJECT.ITEM_CODE , THIS.OBJECT.ITEM_CODE[ROW])				
		
	END IF
	
END IF 



end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then 
	return
end if

dw_2.retrieve(dw_1.object.close_yyyymm[currentrow] , dw_1.object.mfs[currentrow] , dw_1.object.item_code[currentrow] , dw_1.object.line_code[currentrow] ,dw_1.object.workstage_code[currentrow] , gvi_organization_id)
end event

event dw_1::doubleclicked;call super::doubleclicked;string lvs_item_code

if dw_1.getrow() < 1 then return

lvs_item_code = dw_1.getitemstring( dw_1.getrow() , 'item_code' )
if lvs_item_code = '' or isnull(lvs_item_code) then return

openwithparm( w_des_bom_query_popup , lvs_item_code )
end event

type uo_tabpages from w_main_root`uo_tabpages within w_mat_workstage_inventory_check_master
end type

type st_1 from so_statictext within w_mat_workstage_inventory_check_master
integer x = 352
integer y = 96
integer width = 494
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type ddlb_item_code from uo_item_code within w_mat_workstage_inventory_check_master
integer x = 352
integer y = 164
integer width = 494
integer taborder = 20
boolean bringtotop = true
end type

type em_yyyymm from uo_ym within w_mat_workstage_inventory_check_master
integer x = 23
integer y = 160
integer taborder = 20
boolean bringtotop = true
end type

type st_2 from so_statictext within w_mat_workstage_inventory_check_master
integer x = 23
integer y = 96
integer width = 325
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "YYYYMM"
end type

type cb_generate from so_commandbutton within w_mat_workstage_inventory_check_master
integer x = 2459
integer y = 188
integer width = 384
integer height = 112
integer taborder = 20
boolean bringtotop = true
string text = "Generate"
end type

event clicked;call super::clicked;if f_object_role_check() = false then return 
string lvs_yyyymm, lvs_item_code , lvs_line_code , lvs_workstage_code , lvs_check_qty_auto_set
string lvs_check_by_mfs ,lvs_check_by_line_ws , lvs_check_by_material_mfs
long lvi_cnt

if cbx_check_by_mfs.checked = true then 
	lvs_check_by_mfs = 'Y'
else
	lvs_check_by_mfs = 'N'
end if

if cbx_check_by_line_ws.checked = true then 
	lvs_check_by_line_ws = 'Y'
else
	lvs_check_by_line_ws = 'N'
end if

if cbx_check_by_material_mfs.checked = true then 
	lvs_check_by_material_mfs = 'Y'
else
	lvs_check_by_material_mfs = 'N'
end if

lvs_yyyymm = em_yyyymm.text 
lvs_item_code = ddlb_item_code.text() + '%'
msg = f_msgbox1(1161,lvs_yyyymm+' : '+this.text)
if msg = 1 then 
else 
	return 
end if 


lvs_line_code  = ddlb_line_code.getcode( )+'%'
lvs_workstage_code = ddlb_workstage_code.getcode( )+'%'

if cbx_check_qty_auto_set.checked = true THEN
	lvs_check_qty_auto_set = 'Y'
else
	lvs_check_qty_auto_set = 'N'	
end if
//=============================================
//
//=============================================
 select count(*)
    into :lvi_cnt
   from im_item_workstage_inv_close
 where item_code like :lvs_item_code 
 and line_code like :lvs_line_code
 and workstage_code like :lvs_workstage_code
 and organization_id = :gvi_organization_id ; 
 
if f_sql_check() < 0 then return 
if lvi_cnt < 1 then 
	messagebox('Notify','This item is not found in the item inventory.')
	return 
end if 

if cbx_regenerate.checked = true then 

		//=============================================
		//
		//=============================================
		delete from im_item_workstage_inv_check 
				  where close_yyyymm = :lvs_yyyymm 
						and organization_id = :gvi_organization_id ; 
		if f_sql_check() < 0 then return 
		
		insert into im_item_workstage_inv_check 
				  (close_yyyymm,                            mfs ,
				  material_mfs , item_code,                                    
				  inventory_hold,                            line_type,
				  inventory_qty,                             check_inventory_qty,                       inventory_price,
				  inventory_amt,                             line_code, workstage_code , machine_code , location_code ,
					 organization_id,
				  enter_by,                                      enter_date,                                    last_modify_by,
				  last_modify_date)
		select  :lvs_yyyymm,
				decode( :lvs_check_by_mfs , 'Y' , mfs , '*' ) ,
				decode( :lvs_check_by_material_mfs , 'Y' , material_mfs ,'*' ) ,
				item_code,                                 
				'' inventory_hold,                               
				line_type,
				sum(mm_inventory_qty),                                
				decode( :lvs_check_qty_auto_set , 'Y' , sum(mm_inventory_qty) , 0 ) ,
				avg(mm_avg_price),
				sum(mm_inventory_amt),                              
				decode( :lvs_check_by_line_ws , 'Y' , line_code , '*' ) ,
				decode( :lvs_check_by_line_ws , 'Y' , workstage_code , '*' ) ,
				'*' ,
				'*' ,
				:gvi_organization_id,
				:gvs_user_id,                                 
				sysdate,                                       
				:gvs_user_id,
				sysdate
		  from im_item_workstage_inv_close
		where item_code like :lvs_item_code 
			 and decode( :lvs_check_by_line_ws , 'Y' , line_code , '*' ) like :lvs_line_code
			 and decode( :lvs_check_by_line_ws , 'Y' , workstage_code , '*' ) like :lvs_workstage_code
			 and close_yyyymm = :lvs_yyyymm
			 and organization_id = :gvi_organization_id
		group by decode( :lvs_check_by_mfs , 'Y' , mfs , '*' ) , decode( :lvs_check_by_material_mfs , 'Y' , material_mfs ,'*' ) , item_code, line_type, decode( :lvs_check_by_line_ws , 'Y' , line_code , '*' )  , decode( :lvs_check_by_line_ws , 'Y' , workstage_code , '*' ), organization_id ;
		
		if f_sql_check() < 0 then return 
		if sqlca.sqlnrows = 0 then
			f_msg_mdi_help('No data fouond')
			rollback;
		else
			msg = f_msgbox(1170)
			if msg = 1 then
				f_msg_mdi_help('Processed Complete')
				commit;
			else
				f_msg_mdi_help('Processed Cancel!')
				rollback;
			end if 
		end if 

else
	
		insert into im_item_workstage_inv_check a
				(close_yyyymm,                             mfs , material_mfs , item_code,                                    
				inventory_hold,                            line_type,
				inventory_qty,                             check_inventory_qty,                       inventory_price,
				inventory_amt,                             line_code, workstage_code , machine_code ,
				organization_id,
				enter_by,                                      enter_date,                                    last_modify_by,
				last_modify_date)
		select  :lvs_yyyymm,
				decode( :lvs_check_by_mfs , 'Y' , mfs , '*' ) ,
				decode( :lvs_check_by_material_mfs , 'Y' , material_mfs ,'*' ) ,
				item_code,                                 
				'' inventory_hold,                               
				line_type,
				sum(mm_inventory_qty),                                
				decode( :lvs_check_qty_auto_set , 'Y' , sum(mm_inventory_qty) , 0 ) ,
				avg(mm_avg_price),
				sum(mm_inventory_amt),                              
				decode( :lvs_check_by_line_ws , 'Y' , line_code , '*' ) , 
				decode( :lvs_check_by_line_ws , 'Y' , workstage_code , '*' ), 
				'*' ,
				:gvi_organization_id,
				:gvs_user_id,                                 
				sysdate,                                       
				:gvs_user_id,
				sysdate
		  from im_item_workstage_inv_close b
		where b.item_code like :lvs_item_code 
			 and  decode( :lvs_check_by_line_ws , 'Y' , b.line_code , '*' )  like :lvs_line_code
			 and  decode( :lvs_check_by_line_ws , 'Y' , b.workstage_code , '*' )  like :lvs_workstage_code
			 and b.close_yyyymm = :lvs_yyyymm
			 and b.organization_id = :gvi_organization_id
			 and ( b.close_yyyymm , b.item_code , b.line_type ,decode( :lvs_check_by_material_mfs , 'Y' , b.material_mfs ,'*' ) , decode( :lvs_check_by_mfs , 'Y' , b.mfs , '*' ) , decode( :lvs_check_by_line_ws , 'Y' , b.line_code , '*' ) ,decode( :lvs_check_by_line_ws , 'Y' , b.workstage_code , '*' ) , b.organization_id )
			 not in ( select a.close_yyyymm , a.item_code , a.line_type ,decode( :lvs_check_by_material_mfs , 'Y' , a.material_mfs ,'*' ) , decode( :lvs_check_by_mfs , 'Y' , a.mfs , '*' ) , b.line_code , a.workstage_code , a.organization_id 
			               from im_item_workstage_inv_check a
					   where a.close_yyyymm = :lvs_yyyymm
						  and a.organization_id = :gvi_organization_id ) 
			 
		group by decode( :lvs_check_by_mfs , 'Y' , mfs , '*' ) , decode( :lvs_check_by_material_mfs , 'Y' , material_mfs ,'*' ) , item_code, line_type, decode( :lvs_check_by_line_ws , 'Y' , line_code , '*' )   , decode( :lvs_check_by_line_ws , 'Y' , workstage_code , '*' )  , organization_id ;	
		
	if f_sql_check() < 0 then return 		
//====================================================
//
//====================================================
update im_item_workstage_inv_check a 
      set a.inventory_qty = ( select sum(b.mm_inventory_qty) from im_item_workstage_inv_close b 
		                                  where a.close_yyyymm =:lvs_yyyymm
									   and b.close_yyyymm = :lvs_yyyymm
									   and a.close_yyyymm = b.close_yyyymm	
						                  and a.item_code= b.item_code 
									   and a.line_type = b.line_type
									   and decode( :lvs_check_by_material_mfs , 'Y' , a.material_mfs ,'*' ) = decode( :lvs_check_by_material_mfs , 'Y' , b.material_mfs ,'*' )
									   and decode( :lvs_check_by_mfs , 'Y' , a.mfs , '*' ) = decode( :lvs_check_by_mfs , 'Y' , b.mfs , '*' )
									   and decode( :lvs_check_by_line_ws , 'Y' , a.line_code , '*' ) = decode( :lvs_check_by_line_ws , 'Y' , b.line_code , '*' )
									   and decode( :lvs_check_by_line_ws , 'Y' , a.workstage_code , '*' ) = decode( :lvs_check_by_line_ws , 'Y' , b.workstage_code , '*' )
									   and a.organization_id = b.organization_id )  
where ( a.close_yyyymm , a.item_code , a.line_type , 
             decode( :lvs_check_by_material_mfs , 'Y' , a.material_mfs ,'*' ) , 
		   decode( :lvs_check_by_mfs , 'Y' , a.mfs , '*' ) , 
		   decode( :lvs_check_by_line_ws , 'Y' , a.line_code , '*' ) , 
		   decode( :lvs_check_by_line_ws , 'Y' , a.workstage_code , '*' ) , 
		   a.organization_id )
  in ( select b.close_yyyymm , 
                  b.item_code , 
			   b.line_type , 
			   decode( :lvs_check_by_material_mfs , 'Y' , b.material_mfs ,'*' ) , 
			   decode( :lvs_check_by_mfs , 'Y' , b.mfs , '*' ) , 
			   decode( :lvs_check_by_line_ws , 'Y' , b.line_code , '*' ) , 
			   decode( :lvs_check_by_line_ws , 'Y' , b.workstage_code , '*' ) , 
			   b.organization_id 
          from  im_item_workstage_inv_close b 
		                                  where a.close_yyyymm =:lvs_yyyymm
									   and b.close_yyyymm = :lvs_yyyymm
									   and a.close_yyyymm = b.close_yyyymm	
						                  and a.item_code= b.item_code 
									   and a.line_type = b.line_type
									   and decode( :lvs_check_by_material_mfs , 'Y' , a.material_mfs ,'*' ) = decode( :lvs_check_by_material_mfs , 'Y' , b.material_mfs ,'*' )
									   and decode( :lvs_check_by_mfs , 'Y' , a.mfs , '*' ) = decode( :lvs_check_by_mfs , 'Y' , b.mfs , '*' )
									   and decode( :lvs_check_by_line_ws , 'Y' , a.line_code , '*' ) = decode( :lvs_check_by_line_ws , 'Y' , b.line_code , '*' )
									   and decode( :lvs_check_by_line_ws , 'Y' , a.workstage_code , '*' ) = decode( :lvs_check_by_line_ws , 'Y' , b.workstage_code , '*' )
									   and a.organization_id = b.organization_id ) ;
     
	if f_sql_check() < 0 then return 

	msg = f_msgbox(1170)
	if msg = 1 then
		f_msg_mdi_help('Processed Complete')
		commit;
	else
		f_msg_mdi_help('Processed Cancel!')
		rollback;
	end if 	
end if 
f_retrieve()

end event

type cb_check from so_commandbutton within w_mat_workstage_inventory_check_master
integer x = 3735
integer y = 188
integer width = 384
integer height = 112
integer taborder = 30
boolean bringtotop = true
string text = "Adjust"
end type

event clicked;call super::clicked;if f_object_role_check() = false then return 
if dw_1.rowcount() < 1 then return 
long lvl_seq, i , j 
string lvs_machine_code, lvs_item_code , lvs_deficit , lvs_material_mfs , lvs_line_code , lvs_workstage_code , lvs_line_type , lvs_mfs , lvs_yyyymm
Decimal lvf_qty , lvf_price

msg = f_msgbox1(1161,this.text)
if msg  = 1 then 
else 
	return 
end if 

dw_1.accepttext()

lvs_yyyymm  = em_yyyymm.text

open(w_progress_popup)
w_progress_popup.f_set_range( 1 , dw_1.rowcount())
w_progress_popup.f_setstep(1)

for i = 1 to dw_1.rowcount() 
	if dw_1.object.difference_qty[i] <> 0  then 
		
		lvl_seq = f_get_sequence('seq_mat_issue')
		lvs_line_code = dw_1.object.line_code[i]
		lvs_workstage_code = dw_1.object.workstage_code[i]
		lvs_machine_code = dw_1.object.workstage_code[i]
		
		lvf_qty = dw_1.object.difference_qty[i] 
		
		lvs_item_code = dw_1.object.item_code[i]
		lvs_mfs= dw_1.object.mfs[i]		
		lvs_material_mfs= dw_1.object.material_mfs[i]
		LVS_LINE_TYPE= dw_1.object.line_type[i]
		

		IF lvf_qty > 0 THEN  //$$HEX35$$e4c21cc8acc7e0ac00ac200054b3200091c740c7bdacb0c6200074c7c0bb5cb820009ccde0ac98ccacb9200074d51cc12000acc7e0ac7cb9200010ac8cc1dcc2a8d0e4b22000$$ENDHEX$$
			lvs_deficit =  '3'
		ELSE
			lvs_deficit =  '4'			
		END IF
		
		  INSERT INTO IM_ITEM_WORKSTAGE_ISSUE  
				( ISSUE_DATE,   
				  ISSUE_SEQUENCE,   
				  ORGANIZATION_ID,   
				  MFS,   
				  ITEM_CODE,   
				  ITEM_TYPE,   
				  LINE_CODE,   
				  WORKSTAGE_CODE,
				  ISSUE_DEFICIT,   
				  ISSUE_QTY,   
				  ISSUE_STATUS,   
				  ISSUE_AMT,   
				  ISSUE_ACCOUNT,   
				  LINE_TYPE,   
				  ISSUE_PRICE,   
				  ISSUE_TYPE,   
				  ENTER_DATE,   
				  ENTER_BY,   
				  LAST_MODIFY_DATE,   
				  LAST_MODIFY_BY,   
				  MACHINE_CODE,   
				  MATERIAL_MFS )  
			  
      VALUES (  F_GET_INVENTORY_CLOSE_DATE(:lvs_yyyymm , 'END' , :gvi_organization_id ),
				  :lvl_seq ,  
				  :gvi_organization_id,   
				  :lvs_mfs , //MFS,   
				  :lvs_item_code , //ITEM_CODE,   
				  'T' , //ITEM_TYPE,   
				  :lvs_line_code,   
				  :lvs_WORKSTAGE_CODE,   
				  :lvs_deficit , //ISSUE_DEFICIT,   
				  :lvf_qty ,    //ISSUE_QTY,   
				  'N' , //ISSUE_STATUS,   
				   :lvf_price * :lvf_qty ,  //ISSUE_AMT,   
				  'M009' , //ISSUE_ACCOUNT,   
				  :LVS_LINE_TYPE , //LINE_TYPE,   
				  :LVF_PRICE , //ISSUE_PRICE,   
				  'E' , //ISSUE_TYPE,   
				  SYSDATE , //ENTER_DATE,   
				  :GVS_USER_ID , //ENTER_BY,   
				  SYSDATE , //LAST_MODIFY_DATE,   
				  :GVS_USER_ID , //LAST_MODIFY_BY,   
				  :lvs_machine_code, //MACHINE_CODE,   
				  :lvs_material_mfs  //MATERIAL_MFS		
) ;				  
//===========================================================			  
		if f_sql_check() < 0 then 
			Close(w_progress_popup)
			return 
		end if
		
		dw_1.object.inventory_qty[i] = dw_1.object.check_inventory_qty[i]
		dw_1.object.difference_qty[i] = dw_1.object.check_inventory_qty[i] - 	dw_1.object.inventory_qty[i]
		dw_1.object.inventory_amt[i] = dw_1.object.check_inventory_qty[i] - 	dw_1.object.inventory_price[i]		
		
		j++
		w_progress_popup.f_stepit()
	else
		continue
	end if 
next
Close(w_progress_popup)
//===========================================================
if j > 0 then 
	msg = f_msgbox1(9014,string(j))
	if msg = 1 then 
		if dw_1.update() < 0 then 
			rollback ; 
			f_msg_mdi_help(f_msg_st(9026))
		else
			commit ; 
			f_msg_mdi_help(f_msg_st(170))
			f_retrieve()
		end if 
	else 
		rollback ; 
		f_msg_mdi_help(f_msg_st(9026))
	end if 
end if
		
//========================================
//
//========================================
int lvi_return
msg = f_msgbox1(1161,'Close')
if msg = 1 then 
else
	return 
end if 
lvs_yyyymm = em_yyyymm.text

lvi_return = f_mat_workstage_inventory_close_new(lvs_yyyymm)
if lvi_return < 0  then 	
	rollback ; 	
	messagebox('Notify','The process of inventory close is failure, please try it again.')
else 
	commit ; 
	f_msgbox( 170)	
end if 

end event

type st_3 from so_statictext within w_mat_workstage_inventory_check_master
integer x = 1349
integer y = 92
integer width = 576
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Workstage Code"
end type

type ddlb_workstage_code from uo_workstage_code_all within w_mat_workstage_inventory_check_master
integer x = 1349
integer y = 160
integer width = 576
integer height = 676
integer taborder = 30
boolean bringtotop = true
end type

type st_6 from so_statictext within w_mat_workstage_inventory_check_master
integer x = 850
integer y = 84
integer width = 489
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "Line Code"
end type

type ddlb_line_code from uo_line_code within w_mat_workstage_inventory_check_master
integer x = 850
integer y = 164
integer width = 489
integer taborder = 50
boolean bringtotop = true
end type

type ddlb_item_division from uo_item_division within w_mat_workstage_inventory_check_master
integer x = 1929
integer y = 160
integer width = 475
integer taborder = 20
boolean bringtotop = true
end type

type st_4 from so_statictext within w_mat_workstage_inventory_check_master
integer x = 1929
integer y = 92
integer width = 475
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Item Division"
end type

type cbx_check_qty_auto_set from so_checkbox within w_mat_workstage_inventory_check_master
integer x = 2505
integer y = 52
integer width = 654
integer height = 64
boolean bringtotop = true
integer weight = 700
long backcolor = 67108864
string text = "Check QTY Auto Set"
end type

type cbx_regenerate from so_checkbox within w_mat_workstage_inventory_check_master
integer x = 2505
integer y = 116
integer width = 654
integer height = 64
boolean bringtotop = true
integer weight = 700
long backcolor = 67108864
string text = "Regenerate"
end type

type cb_1 from so_commandbutton within w_mat_workstage_inventory_check_master
integer x = 4123
integer y = 188
integer width = 384
integer height = 112
integer taborder = 20
boolean bringtotop = true
string text = "Assy Expand"
end type

event clicked;call super::clicked;if dw_1.getrow() < 1 then return 
long lvl_session_id , i
string lvs_close_yyyymm , lvs_line_code , lvs_workstage_code , lvs_machine_code , lvs_set_item_code , lvs_mfs , lvs_material_mfs , lvs_item_division , lvs_rowid
decimal lvf_inventory_qty , lvf_check_inventory_qty

msg = f_msgbox1(1161 , this.text )
if msg = 1 then 
else
	return
end if

lvs_close_yyyymm = EM_YYYYMM.TEXT

OPEN(W_PROGRESS_POPUP)

W_PROGRESS_POPUP.F_SET_RANGE( 1 , DW_1.ROWcount( ) )
W_PROGRESS_POPUP.F_SETSTEP(1)

DELETE FROM	IM_ITEM_WORKSTAGE_INV_EXPAND  
WHERE CLOSE_YYYYMM = :LVS_CLOSE_YYYYMM
     AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;

IF F_SQL_CHECK() < 0 THEN 
	CLOSE(W_PROGRESS_POPUP)
	RETURN
END IF
						 
do
	i++
	
	W_PROGRESS_POPUP.F_STEPIT()
	
//	if dw_1.object.check_yn[i] = 'Y' then
//	else
//		continue
//	end if

		if dw_1.object.inventory_qty[i] = 0 and dw_1.object.check_inventory_qty[i] = 0  then
		   continue			
		else	
		
			lvs_mfs = dw_1.object.mfs[i]
			lvs_material_mfs = dw_1.object.material_mfs[i]			
			lvs_set_item_code = dw_1.object.item_code[i]
		
			lvs_line_code = dw_1.object.line_code[i]
			lvs_workstage_code= dw_1.object.workstage_code[i]
			lvs_machine_code= dw_1.object.machine_code[i]
			lvf_inventory_qty = dw_1.object.inventory_qty[i]
			lvf_check_inventory_qty = dw_1.object.check_inventory_qty[i]
			lvs_item_division = dw_1.object.item_division[i]
			lvs_rowid = dw_1.object.rowid[i]
			
			if lvs_item_division = 'R' then //$$HEX22$$d0c6acc7ccb82000c1c0dcd078c72000bdacb0c694b22000f8ade5b02000f8ad00b35cb8200085c725b82000$$ENDHEX$$
					  INSERT INTO IM_ITEM_WORKSTAGE_INV_EXPAND  
								 (SESSION_ID ,
								  CLOSE_YYYYMM,   
								  SET_ITEM_CODE , 
								  PARENT_ITEM_CODE ,
								   ITEM_CODE,   
								   LINE_TYPE,   
								   LINE_CODE,   
								   WORKSTAGE_CODE,   
								   MACHINE_CODE,   
								   MFS,   
								   MATERIAL_MFS,   
								   ORGANIZATION_ID,   
								   INVENTORY_HOLD,   
								   INVENTORY_PRICE,   
								   INVENTORY_QTY,   
								   CHECK_INVENTORY_QTY,   
								   INVENTORY_AMT,   
								   LOCATION_CODE,   
								   COMMENTS,   
								   ENTER_DATE,   
								   ENTER_BY,   
								   LAST_MODIFY_DATE,   
								   LAST_MODIFY_BY )  
                                          SELECT 0 ,
								  CLOSE_YYYYMM,   
								   ITEM_CODE , 
								   ITEM_CODE ,
								   ITEM_CODE,   
								   LINE_TYPE,   
								   LINE_CODE,   
								   WORKSTAGE_CODE,   
								   MACHINE_CODE,   
								   MFS,   
								   MATERIAL_MFS,   
								   ORGANIZATION_ID,   
								   INVENTORY_HOLD,   
								   INVENTORY_PRICE,   
								   INVENTORY_QTY,   
								   CHECK_INVENTORY_QTY,   
								   INVENTORY_AMT,   
								   LOCATION_CODE,   
								   COMMENTS,   
								   ENTER_DATE,   
								   ENTER_BY,   
								   LAST_MODIFY_DATE,   
								   LAST_MODIFY_BY 
						    FROM  IM_ITEM_WORKSTAGE_INV_CHECK
                                         WHERE ROWID = :LVS_ROWID ;
										 
						IF F_SQL_CHECK() < 0 THEN 
							CLOSE(W_PROGRESS_POPUP)
							RETURN
						END IF										 
				
			elseif  lvs_item_division = 'F' or lvs_item_division = 'W' then //$$HEX22$$18bc1cc888d420001cc888d42000c1c0dcd078c72000bdacb0c694b2200004c81cac74d51cc1200085c725b8$$ENDHEX$$
				
						lvl_session_id = f_bom_query_prc(lvs_set_item_code, f_t_sysdate())
						
						if lvl_session_id < 1 then 
							F_MSG_MDI_HELP(F_MSG_ST1( 9051 , lvs_set_item_code ))
							ROLLBACK; 
							CLOSE(W_PROGRESS_POPUP)
							RETURN
						end if 
						
						  INSERT INTO IM_ITEM_WORKSTAGE_INV_EXPAND  
								 (SESSION_ID ,
								  CLOSE_YYYYMM,   
								  SET_ITEM_CODE , 
								  PARENT_ITEM_CODE ,
								   ITEM_CODE,   
								   LINE_TYPE,   
								   LINE_CODE,   
								   WORKSTAGE_CODE,   
								   MACHINE_CODE,   
								   MFS,   
								   MATERIAL_MFS,   
								   ORGANIZATION_ID,   
								   INVENTORY_HOLD,   
								   INVENTORY_PRICE,   
								   INVENTORY_QTY,   
								   CHECK_INVENTORY_QTY,   
								   INVENTORY_AMT,   
								   LOCATION_CODE,   
								   COMMENTS,   
								   ENTER_DATE,   
								   ENTER_BY,   
								   LAST_MODIFY_DATE,   
								   LAST_MODIFY_BY )  
						 SELECT  :LVL_SESSION_ID ,
								  :LVS_CLOSE_YYYYMM , //CLOSE_YYYYMM,   
								  :LVS_SET_ITEM_CODE ,
								  PARENT_ITEM_CODE ,
								   CHILD_ITEM_CODE , //ITEM_CODE,   
								   LINE_TYPE,   
								   :LVS_LINE_CODE , //LINE_CODE,   
								   :LVS_WORKSTAGE_CODE , //WORKSTAGE_CODE,   
								   :LVS_MACHINE_CODE , //MACHINE_CODE,   
								   :LVS_MFS , //MFS,   
								   :LVS_MATERIAL_MFS , //MATERIAL_MFS,   
								   ORGANIZATION_ID,   
								   'W' , //INVENTORY_HOLD,   
								   0 , //INVENTORY_PRICE,   
								   :LVF_INVENTORY_QTY * MODEL_UNIT_QTY ,   
								   :LVF_CHECK_INVENTORY_QTY * MODEL_UNIT_QTY,   
								   '' , //INVENTORY_AMT,   
								   '' , //LOCATION_CODE,   
								   ''  , //COMMENTS,   
								   SYSDATE , //ENTER_DATE,   
								   :GVS_USER_ID , //ENTER_BY,   
								   SYSDATE , //LAST_MODIFY_DATE,   
								   :GVS_USER_ID  //LAST_MODIFY_BY 
						   FROM ID_ENG_BOM_TEMP
						 WHERE SESSION_ID = :lvl_session_id
						         AND LINE_TYPE <> 'T'
							  AND ORGANIZATION_ID = :gvi_organization_id ;
						
						IF F_SQL_CHECK() < 0 THEN 
							CLOSE(W_PROGRESS_POPUP)							
							RETURN
						END IF
			else
				
				Messagebox("Notify" , "Item Division Invalid" )
				
			end if //lvs_item_division
		end if //CHECK_YN
		
		//=====================================
		// $$HEX3$$84c7dcc22000$$ENDHEX$$bom $$HEX2$$adc01cc8$$ENDHEX$$
		//=====================================
		delete from id_eng_bom_temp where session_id = :lvl_session_id ;
		if f_sql_check() < 0 then 
			return
		end if 
		
loop until i = dw_1.rowcount( )		
CLOSE(W_PROGRESS_POPUP)
msg = f_msgbox(1170)
if msg = 1 then 
	commit;
else
	rollback;
end if 


end event

type cbx_inventory_close from so_checkbox within w_mat_workstage_inventory_check_master
integer x = 3845
integer y = 112
integer width = 567
integer height = 64
boolean bringtotop = true
integer weight = 700
long backcolor = 67108864
string text = "Inventory Close"
boolean checked = true
end type

type cbx_check_by_mfs from so_checkbox within w_mat_workstage_inventory_check_master
integer x = 3159
integer y = 116
integer width = 567
integer height = 64
boolean bringtotop = true
integer weight = 700
long backcolor = 67108864
string text = "Check By MFS"
boolean checked = true
end type

type cbx_check_by_line_ws from so_checkbox within w_mat_workstage_inventory_check_master
integer x = 3845
integer y = 44
integer width = 567
integer height = 64
boolean bringtotop = true
integer weight = 700
long backcolor = 67108864
string text = "Check By Line/WS"
boolean checked = true
end type

type cbx_check_by_material_mfs from so_checkbox within w_mat_workstage_inventory_check_master
integer x = 3163
integer y = 48
integer width = 663
integer height = 64
boolean bringtotop = true
integer weight = 700
long backcolor = 67108864
string text = "Check By Material MFS"
boolean checked = true
end type

type cb_3 from so_commandbutton within w_mat_workstage_inventory_check_master
integer x = 2848
integer y = 188
integer width = 430
integer height = 112
integer taborder = 60
boolean bringtotop = true
string text = "Excel Import"
end type

event clicked;call super::clicked;open(w_mat_ws_inventory_close_excel_import_popup)
end event

type cb_4 from so_commandbutton within w_mat_workstage_inventory_check_master
integer x = 3282
integer y = 188
integer width = 453
integer height = 112
integer taborder = 50
boolean bringtotop = true
string text = "Sync With Excel"
end type

event clicked;call super::clicked;long i
if dw_1.getrow() < 1 then return

do
	YIELD()
	i++
	if isnull(dw_1.object.excel_check_inventory_qty[i]) then
		
		//dw_1.object.check_inventory_qty[i] = 0
		
	else
		dw_1.object.check_inventory_qty[i] = dw_1.object.excel_check_inventory_qty[i]
	end if 
	
	dw_1.trigger event itemchanged( i, dw_1.object.check_inventory_qty , string(dw_1.object.check_inventory_qty[i]) )
	f_msg_mdi_help( string(i) )
loop until i = dw_1.rowcount( )

	f_msg_mdi_help( string(i)+ 'OK' )
end event

type gb_1 from so_groupbox within w_mat_workstage_inventory_check_master
integer width = 2427
integer height = 320
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_mat_workstage_inventory_check_master
integer x = 2432
integer width = 2089
integer height = 320
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

