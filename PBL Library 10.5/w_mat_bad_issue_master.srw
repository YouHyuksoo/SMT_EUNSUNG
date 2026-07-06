HA$PBExportHeader$w_mat_bad_issue_master.srw
$PBExportComments$Material Mass Issue Master
forward
global type w_mat_bad_issue_master from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_mat_bad_issue_master
end type
type uo_dateend from uo_ymd_calendar within w_mat_bad_issue_master
end type
type ddlb_item_code from uo_item_code within w_mat_bad_issue_master
end type
type st_3 from so_statictext within w_mat_bad_issue_master
end type
type st_4 from so_statictext within w_mat_bad_issue_master
end type
type cb_set from so_commandbutton within w_mat_bad_issue_master
end type
type st_8 from so_statictext within w_mat_bad_issue_master
end type
type sle_material_mfs from so_singlelineedit within w_mat_bad_issue_master
end type
type st_1 from so_statictext within w_mat_bad_issue_master
end type
type sle_1 from so_singlelineedit within w_mat_bad_issue_master
end type
type sle_item_name from so_singlelineedit within w_mat_bad_issue_master
end type
type st_14 from so_statictext within w_mat_bad_issue_master
end type
type gb_3 from so_groupbox within w_mat_bad_issue_master
end type
type gb_4 from so_groupbox within w_mat_bad_issue_master
end type
end forward

global type w_mat_bad_issue_master from w_main_root
integer width = 4878
integer height = 3120
string title = "Material Bad Issue Master"
uo_dateset uo_dateset
uo_dateend uo_dateend
ddlb_item_code ddlb_item_code
st_3 st_3
st_4 st_4
cb_set cb_set
st_8 st_8
sle_material_mfs sle_material_mfs
st_1 st_1
sle_1 sle_1
sle_item_name sle_item_name
st_14 st_14
gb_3 gb_3
gb_4 gb_4
end type
global w_mat_bad_issue_master w_mat_bad_issue_master

on w_mat_bad_issue_master.create
int iCurrent
call super::create
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.ddlb_item_code=create ddlb_item_code
this.st_3=create st_3
this.st_4=create st_4
this.cb_set=create cb_set
this.st_8=create st_8
this.sle_material_mfs=create sle_material_mfs
this.st_1=create st_1
this.sle_1=create sle_1
this.sle_item_name=create sle_item_name
this.st_14=create st_14
this.gb_3=create gb_3
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateset
this.Control[iCurrent+2]=this.uo_dateend
this.Control[iCurrent+3]=this.ddlb_item_code
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.cb_set
this.Control[iCurrent+7]=this.st_8
this.Control[iCurrent+8]=this.sle_material_mfs
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.sle_1
this.Control[iCurrent+11]=this.sle_item_name
this.Control[iCurrent+12]=this.st_14
this.Control[iCurrent+13]=this.gb_3
this.Control[iCurrent+14]=this.gb_4
end on

on w_mat_bad_issue_master.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.ddlb_item_code)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.cb_set)
destroy(this.st_8)
destroy(this.sle_material_mfs)
destroy(this.st_1)
destroy(this.sle_1)
destroy(this.sle_item_name)
destroy(this.st_14)
destroy(this.gb_3)
destroy(this.gb_4)
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
Ivs_resize_type                      = 'MASTER_DETAIL_12T_3B'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
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
F_MENU_CONTROL('DATA_CONTROL_MODIFY' , TRUE)  // All Data Control





end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
uo_dateset.settext(string(f_t_sysdate(), 'yyyy/mm')+'/01')
end event

event ue_data_control;call super::ue_data_control;long row 
string lvs_date
double lvd_seq
choose case gvs_ue_data_control
		
	case 'RETRIEVE'
				dw_1.reset()
				dw_2.reset()
				dw_3.reset()			
				dw_1.retrieve(  sle_material_mfs.text+'%' ,    ddlb_item_code.text() + '%', gvi_organization_id)

	case 'UPDATE'
		
			IF DW_1.UPDATE() < 0 or DW_3.UPDATE() < 0   THEN
			  	 ROLLBACK;
				   
				 F_RETRIEVE()				   
			ELSE
				COMMIT;
				F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"

			END IF

	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_mat_bad_issue_master
integer y = 320
end type

type dw_4 from w_main_root`dw_4 within w_mat_bad_issue_master
integer y = 320
boolean hscrollbar = false
boolean vscrollbar = false
end type

type dw_3 from w_main_root`dw_3 within w_mat_bad_issue_master
integer y = 1516
integer width = 4558
integer height = 632
boolean titlebar = true
string title = "Bad Issue List"
string dataobject = "d_mat_bad_issue_lst"
end type

event dw_3::itemchanged;call super::itemchanged;string lvs_return
if dwo.name = 'item_code' then    
	
   lvs_return = f_set_item_name_spec_uom( this , row , this.object.item_code[row] )		

	if 	lvs_return = 'ERROR' THEN 
		return 1
	end if	
		
	if lvs_return = 'NOTFOUND' then 
		return 1  
	end if 		
		
end if
end event

type dw_2 from w_main_root`dw_2 within w_mat_bad_issue_master
integer x = 2281
integer y = 308
integer width = 2277
integer height = 1204
boolean titlebar = true
string title = "Current Inventory List"
string dataobject = "d_mat_current_inventory_4_bad_issu_lst"
boolean hsplitscroll = false
boolean livescroll = false
end type

type dw_1 from w_main_root`dw_1 within w_mat_bad_issue_master
integer y = 308
integer width = 2277
integer height = 1204
boolean titlebar = true
string title = "WQC Inspect Result List"
string dataobject = "d_qc_wqc_4_bad_issue_lst"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return

dw_2.retrieve( this.object.item_code[currentrow] , Gvi_organization_id )
end event

event dw_1::doubleclicked;call super::doubleclicked;if row < 1 then return

dw_2.retrieve( this.object.item_code[row] , Gvi_organization_id )
end event

type uo_dateset from uo_ymd_calendar within w_mat_bad_issue_master
event destroy ( )
integer x = 41
integer y = 160
integer taborder = 30
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mat_bad_issue_master
event destroy ( )
integer x = 457
integer y = 160
integer taborder = 40
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type ddlb_item_code from uo_item_code within w_mat_bad_issue_master
integer x = 873
integer y = 160
integer width = 553
integer taborder = 20
boolean bringtotop = true
end type

type st_3 from so_statictext within w_mat_bad_issue_master
integer x = 882
integer y = 88
integer width = 553
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type st_4 from so_statictext within w_mat_bad_issue_master
integer x = 46
integer y = 88
integer width = 814
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Issue Date"
end type

type cb_set from so_commandbutton within w_mat_bad_issue_master
integer x = 2985
integer y = 124
integer width = 489
integer height = 112
integer taborder = 30
boolean bringtotop = true
string text = "Batch Select"
end type

event clicked;call super::clicked;Decimal lvf_issue_qty , lvf_inventory_price , lvf_inventory_qty
long n = 1  , i = 1 

if f_object_role_check() = false then return 

if dw_1.rowcount() < 1 then return 
if dw_2.rowcount() < 1 then return 
dw_1.accepttext()

msg = f_msgbox1(1161,this.text)
if msg = 1 then 
else 
	return 
end if 
	
	
	lvf_issue_qty = dw_1.object.inspect_bad_qty[i]

	if dw_2.getrow() < 1 then 
		lvf_inventory_qty = 0
	else
		lvf_inventory_qty = dw_2.object.inventory_qty[dw_2.getrow()]
	end if

	//$$HEX16$$acc7e0ac00ac200080bd71c858d574ba200098ccacb958d5c0c920004ac54cc7$$ENDHEX$$
	if lvf_inventory_qty <= 0 then 
		Messagebox("Notify" , "Inventory Qty Not Enough" )
		return
	end if
	
	if lvf_issue_qty >  lvf_inventory_qty then 
		lvf_issue_qty = lvf_inventory_qty //$$HEX28$$acc7e0acf4bce4b220009ccde0ac18c2c9b774c720006cd074ba20009ccde0ac18c2c9b740c72000acc7e0ac18c2c9b7ccb97cd0ccb92000$$ENDHEX$$
	else
		
	end if 	

	n = dw_3.insertrow(0)
	dw_3.scrolltorow(n)
	f_set_security_row(dw_3, n, 'ALL')
	
	dw_3.object.work_order_no[n] = '*'
	dw_3.object.issue_date[n] = f_t_sysdate()	
	dw_3.object.issue_sequence[n] = double(f_get_sequence('seq_mat_issue'))
	
	dw_3.object.item_type[n] = dw_1.object.item_type[i]
	dw_3.object.item_code[n] = dw_1.object.item_code[i]
	dw_3.object.item_name[n] = dw_1.object.item_name[i]
	dw_3.object.item_spec[n] = dw_1.object.item_spec[i]
	dw_3.object.item_uom[n] = dw_1.object.item_uom[i]		
       dw_3.object.line_code[n]            = dw_1.object.line_code[i]		
	dw_3.object.workstage_code[n] = dw_1.object.workstage_code[i]		
	dw_3.object.machine_code[n] = dw_1.object.machine_code[i]			

	//==============================================
	//
	//==============================================	
	
    	dw_3.object.issue_qty[n] =lvf_issue_qty
	
	//==============================================	
	//
	//==============================================
     if 	lvf_issue_qty < 0 THEN 
		dw_3.object.issue_deficit[n] = '4'		
	else
		dw_3.object.issue_deficit[n] = '3'
	end if
	
	dw_3.object.issue_status[n] = 'N'
	
	
	dw_3.object.issue_type[n] = 'N' //$$HEX5$$15c8c1c09ccde0ac2000$$ENDHEX$$
	
	dw_3.object.issue_account[n] = 'M002'

	
	dw_3.object.line_type[n] = dw_1.object.line_type[i]
	
	dw_3.object.mfs[n] = dw_1.object.mfs[i]
	
	//=============================================
	//
	//=============================================	
	dw_3.object.material_mfs[n] = dw_2.object.material_mfs[dw_2.getrow()]

	//=================================================
	// $$HEX24$$d0c6acc7ccb820001cc888bc58c72000200004d6acc7e0ac2000c9d3e0ad2000e8b200ac7cb920006cad74d528c6e4b2$$ENDHEX$$
	//=================================================
	lvf_inventory_price =f_get_item_inventory_price(dw_1.object.item_code[i] ,  dw_1.object.line_type[i] , dw_2.object.material_mfs[dw_2.getrow()] )
	
	dw_3.object.issue_amt[n] = lvf_issue_qty * lvf_inventory_price
	dw_3.object.issue_price[n]  = lvf_inventory_price
	
	dw_3.object.supplier_code[n] = dw_1.object.supplier_code[i]
	dw_3.object.inspect_no[n] = dw_1.object.wqc_inspect_no[i]	
	
	//===================================
	// $$HEX6$$44c6ccb8200098ccacb92000$$ENDHEX$$
	//===================================	
	dw_1.object.complete_yn[i] = 'Y'
	
	//===================================
	
end event

type st_8 from so_statictext within w_mat_bad_issue_master
integer x = 1435
integer y = 88
integer width = 448
integer height = 60
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Material MFS"
end type

type sle_material_mfs from so_singlelineedit within w_mat_bad_issue_master
integer x = 1431
integer y = 160
integer width = 448
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

event getfocus;this.selecttext( 1 , len( this.text) )
this.Borderstyle = styleraised!
end event

event losefocus;this.Borderstyle = styleLowered!
end event

event ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

dw_1.SETFILTER('')
dw_1.FILTER()

LVS_COLUMN = 'ITEM_NAME'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    dw_1.SETFILTER('')
    dw_1.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

dw_1.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
dw_1.FILTER()
F_MSG_MDI_HELP( STRING( dw_1.ROWCOUNT() ) + " Found" )
end event

type st_1 from so_statictext within w_mat_bad_issue_master
integer x = 2336
integer y = 88
integer width = 453
integer height = 60
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Item Spec"
end type

type sle_1 from so_singlelineedit within w_mat_bad_issue_master
integer x = 2336
integer y = 160
integer width = 453
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

event getfocus;this.selecttext( 1 , len( this.text) )
this.Borderstyle = styleraised!
end event

event losefocus;this.Borderstyle = styleLowered!
end event

event ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

dw_1.SETFILTER('')
dw_1.FILTER()

LVS_COLUMN = 'ITEM_SPEC'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    dw_1.SETFILTER('')
    dw_1.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

dw_1.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
dw_1.FILTER()
F_MSG_MDI_HELP( STRING( dw_1.ROWCOUNT() ) + " Found" )
end event

type sle_item_name from so_singlelineedit within w_mat_bad_issue_master
integer x = 1883
integer y = 160
integer width = 448
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

event getfocus;this.selecttext( 1 , len( this.text) )
this.Borderstyle = styleraised!
end event

event losefocus;this.Borderstyle = styleLowered!
end event

event ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

dw_1.SETFILTER('')
dw_1.FILTER()

LVS_COLUMN = 'ITEM_NAME'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    dw_1.SETFILTER('')
    dw_1.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

dw_1.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
dw_1.FILTER()
F_MSG_MDI_HELP( STRING( dw_1.ROWCOUNT() ) + " Found" )
end event

type st_14 from so_statictext within w_mat_bad_issue_master
integer x = 1883
integer y = 88
integer width = 448
integer height = 60
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Item Name"
end type

type gb_3 from so_groupbox within w_mat_bad_issue_master
integer x = 2843
integer width = 777
integer height = 300
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_4 from so_groupbox within w_mat_bad_issue_master
integer width = 2830
integer height = 300
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

