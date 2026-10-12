HA$PBExportHeader$w_pln_product_master_plan_master.srw
$PBExportComments$Planning Master Plan  Master
forward
global type w_pln_product_master_plan_master from w_main_root
end type
type st_1 from so_statictext within w_pln_product_master_plan_master
end type
type st_5 from so_statictext within w_pln_product_master_plan_master
end type
type st_3 from statictext within w_pln_product_master_plan_master
end type
type ddlb_customer_code from uo_customer_code within w_pln_product_master_plan_master
end type
type ddlb_line_code from uo_line_code within w_pln_product_master_plan_master
end type
type cb_8 from so_commandbutton within w_pln_product_master_plan_master
end type
type st_yyyymm from so_statictext within w_pln_product_master_plan_master
end type
type cb_9 from so_commandbutton within w_pln_product_master_plan_master
end type
type uo_dateend from uo_ymd_calendar within w_pln_product_master_plan_master
end type
type uo_dateset from uo_ymd_calendar within w_pln_product_master_plan_master
end type
type tab_1 from tab within w_pln_product_master_plan_master
end type
type tabpage_1 from userobject within tab_1
end type
type ddlb_time from so_dropdownlistbox within tabpage_1
end type
type cb_3 from so_commandbutton within tabpage_1
end type
type st_2 from so_statictext within tabpage_1
end type
type em_plan_qty from so_editmask within tabpage_1
end type
type cb_1 from so_commandbutton within tabpage_1
end type
type tabpage_1 from userobject within tab_1
ddlb_time ddlb_time
cb_3 cb_3
st_2 st_2
em_plan_qty em_plan_qty
cb_1 cb_1
end type
type tabpage_2 from userobject within tab_1
end type
type cb_17 from so_commandbutton within tabpage_2
end type
type cb_2 from so_commandbutton within tabpage_2
end type
type tabpage_2 from userobject within tab_1
cb_17 cb_17
cb_2 cb_2
end type
type tab_1 from tab within w_pln_product_master_plan_master
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type rb_1 from so_radiobutton within w_pln_product_master_plan_master
end type
type rb_3 from so_radiobutton within w_pln_product_master_plan_master
end type
type rb_4 from so_radiobutton within w_pln_product_master_plan_master
end type
type rb_5 from so_radiobutton within w_pln_product_master_plan_master
end type
type ddlb_model_name from uo_set_model_name_ddlb within w_pln_product_master_plan_master
end type
type st_4 from so_statictext within w_pln_product_master_plan_master
end type
type rb_master_plan from so_radiobutton within w_pln_product_master_plan_master
end type
type rb_month_plan from so_radiobutton within w_pln_product_master_plan_master
end type
type ddlb_workstage_code from uo_workstage_code_all within w_pln_product_master_plan_master
end type
type mle_note from multilineedit within w_pln_product_master_plan_master
end type
type st_label from statictext within w_pln_product_master_plan_master
end type
type gb_1 from so_groupbox within w_pln_product_master_plan_master
end type
type gb_2 from so_groupbox within w_pln_product_master_plan_master
end type
end forward

global type w_pln_product_master_plan_master from w_main_root
integer width = 6546
integer height = 3784
string title = "Product Master Plan"
st_1 st_1
st_5 st_5
st_3 st_3
ddlb_customer_code ddlb_customer_code
ddlb_line_code ddlb_line_code
cb_8 cb_8
st_yyyymm st_yyyymm
cb_9 cb_9
uo_dateend uo_dateend
uo_dateset uo_dateset
tab_1 tab_1
rb_1 rb_1
rb_3 rb_3
rb_4 rb_4
rb_5 rb_5
ddlb_model_name ddlb_model_name
st_4 st_4
rb_master_plan rb_master_plan
rb_month_plan rb_month_plan
ddlb_workstage_code ddlb_workstage_code
mle_note mle_note
st_label st_label
gb_1 gb_1
gb_2 gb_2
end type
global w_pln_product_master_plan_master w_pln_product_master_plan_master

type variables
long lvl_default_width , lvl_default_height , lvl_x , lvl_y

String lvs_last_gr,  ivs_hide = '1' ,   lvs_model_list[] , lvs_nullarray[]
long  lvl_gr_width , lvl_gr_height , lvl_gr_x , lvl_gr_y
end variables

on w_pln_product_master_plan_master.create
int iCurrent
call super::create
this.st_1=create st_1
this.st_5=create st_5
this.st_3=create st_3
this.ddlb_customer_code=create ddlb_customer_code
this.ddlb_line_code=create ddlb_line_code
this.cb_8=create cb_8
this.st_yyyymm=create st_yyyymm
this.cb_9=create cb_9
this.uo_dateend=create uo_dateend
this.uo_dateset=create uo_dateset
this.tab_1=create tab_1
this.rb_1=create rb_1
this.rb_3=create rb_3
this.rb_4=create rb_4
this.rb_5=create rb_5
this.ddlb_model_name=create ddlb_model_name
this.st_4=create st_4
this.rb_master_plan=create rb_master_plan
this.rb_month_plan=create rb_month_plan
this.ddlb_workstage_code=create ddlb_workstage_code
this.mle_note=create mle_note
this.st_label=create st_label
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_5
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.ddlb_customer_code
this.Control[iCurrent+5]=this.ddlb_line_code
this.Control[iCurrent+6]=this.cb_8
this.Control[iCurrent+7]=this.st_yyyymm
this.Control[iCurrent+8]=this.cb_9
this.Control[iCurrent+9]=this.uo_dateend
this.Control[iCurrent+10]=this.uo_dateset
this.Control[iCurrent+11]=this.tab_1
this.Control[iCurrent+12]=this.rb_1
this.Control[iCurrent+13]=this.rb_3
this.Control[iCurrent+14]=this.rb_4
this.Control[iCurrent+15]=this.rb_5
this.Control[iCurrent+16]=this.ddlb_model_name
this.Control[iCurrent+17]=this.st_4
this.Control[iCurrent+18]=this.rb_master_plan
this.Control[iCurrent+19]=this.rb_month_plan
this.Control[iCurrent+20]=this.ddlb_workstage_code
this.Control[iCurrent+21]=this.mle_note
this.Control[iCurrent+22]=this.st_label
this.Control[iCurrent+23]=this.gb_1
this.Control[iCurrent+24]=this.gb_2
end on

on w_pln_product_master_plan_master.destroy
call super::destroy
destroy(this.st_1)
destroy(this.st_5)
destroy(this.st_3)
destroy(this.ddlb_customer_code)
destroy(this.ddlb_line_code)
destroy(this.cb_8)
destroy(this.st_yyyymm)
destroy(this.cb_9)
destroy(this.uo_dateend)
destroy(this.uo_dateset)
destroy(this.tab_1)
destroy(this.rb_1)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.rb_5)
destroy(this.ddlb_model_name)
destroy(this.st_4)
destroy(this.rb_master_plan)
destroy(this.rb_month_plan)
destroy(this.ddlb_workstage_code)
destroy(this.mle_note)
destroy(this.st_label)
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
Ivs_resize_type                      = 'NORMAL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default

 ivs_dw_1_deleteselected_yn = 'N' 
 
ivs_dw_1_retrice_cancel_popup_open = 'Y'
ivs_dw_2_retrice_cancel_popup_open = 'N'
ivs_dw_3_retrice_cancel_popup_open = 'N'
ivs_dw_4_retrice_cancel_popup_open = 'N'
ivs_dw_5_retrice_cancel_popup_open = 'N'

ivs_dw_1_selected_row_yn = 'N'

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

end event

event ue_data_control;call super::ue_data_control;Long row , lvdb_seq
String  lvs_mfs

choose case gvs_ue_data_control
		
	case 'RETRIEVE'
		
		  if rb_master_plan.checked = true then 
		
				dw_1.reset()
				dw_1.retrieve( uo_dateset.text() , uo_dateend.text() , ddlb_line_code.getcode( )+'%' , ddlb_model_name.getcode() +'%', ddlb_workstage_code.getcode()+'%' ,  gvi_organization_id)
				dw_1.setfocus()		
			elseif rb_month_plan.checked = true then 
				dw_2.reset()
				dw_2.retrieve( string(uo_dateset.text() , 'yyyymm')  , ddlb_model_name.getcode() +'%',  gvi_organization_id)
				dw_2.setfocus()		
				
			end if 
			
	case 'INSERT'	
		
		  if rb_master_plan.checked = true then 
			
					dw_1.ENABLED = TRUE
					ROW = dw_1.INSERTROW(dw_1.GETROW())
					dw_1.SCROLLTOROW(ROW)
					F_SET_SECURITY_ROW(dw_1 , ROW ,'ALL')
					
					dw_1.object.plan_date[row] = f_t_sysdate()		
					lvdb_seq = double(f_get_sequence( 'seq_plan_date_sequence'))
					dw_1.object.plan_sequence[row] = 	lvdb_seq
					dw_1.object.mfs[row] = 	'MI'+STRING(lvdb_seq)
				
				     dw_1.object.plan_priority[row] = 	1
				     dw_1.object.work_order_no[row] = 'WO'+STRING(f_t_sysdate(),'YYMMDD')+STRING(lvdb_seq)
					  
					dw_1.object.line_code[row] = 	ddlb_line_code.getcode()			
					dw_1.object.parent_item_code[row] = '*'
					dw_1.object.item_code[row] = '*'
					dw_1.object.model_suffix[row] = '*'
					dw_1.object.actual_qty[row] = 0
					dw_1.object.plan_qty_d1[row] = 0
					dw_1.object.plan_qty_d2[row] = 0
					dw_1.object.plan_qty_d3[row] = 0
					
					dw_1.object.plan_time1[row] = 0
					dw_1.object.plan_time2[row] = 0
					dw_1.object.plan_time3[row] = 0
					dw_1.object.plan_time4[row] = 0						
					dw_1.object.plan_time5[row] = 0
					dw_1.object.plan_time6[row] = 0						
					dw_1.object.plan_time7[row] = 0
					dw_1.object.plan_time8[row] = 0
					dw_1.object.plan_time9[row] = 0
					dw_1.object.plan_time10[row] = 0			
					
				else
					
					dw_2.ENABLED = TRUE
					ROW = dw_2.INSERTROW(dw_2.GETROW())
					dw_2.SCROLLTOROW(ROW)
					F_SET_SECURITY_ROW(dw_2 , ROW ,'ALL')
					
					dw_2.object.plan_ym[row] = f_yyyymm()		
//					lvdb_seq = double(f_get_sequence( 'seq_plan_date_sequence'))
//					dw_2.object.plan_sequence[row] = 	lvdb_seq
					
					dw_2.object.model_name[row] = '*'		
					dw_2.object.model_suffix[row] = '*'
					
					dw_2.object.plan_1[row] = 0
					dw_2.object.plan_2[row] = 0
					dw_2.object.plan_3[row] = 0
					dw_2.object.plan_4[row] = 0						
					dw_2.object.plan_5[row] = 0
					dw_2.object.plan_6[row] = 0						
					dw_2.object.plan_7[row] = 0
					dw_2.object.plan_8[row] = 0
					dw_2.object.plan_9[row] = 0
					dw_2.object.plan_10[row] = 0							
					dw_2.object.plan_11[row] = 0
					dw_2.object.plan_12[row] = 0				
					
				end if 
		
	case 'APPEND'		
				 
		 if rb_master_plan.checked = true then 		 
				 
					dw_1.ENABLED = TRUE
					ROW = dw_1.INSERTROW(dw_1.GETROW())
					dw_1.SCROLLTOROW(ROW)
					F_SET_SECURITY_ROW(dw_1 , ROW ,'ALL')
					
					dw_1.object.plan_date[row] = f_t_sysdate()		
					lvdb_seq = double(f_get_sequence( 'seq_plan_date_sequence'))
					dw_1.object.plan_sequence[row] = 	lvdb_seq
					 dw_1.object.mfs[row] = 	'MI'+STRING(lvdb_seq)
					dw_1.object.line_code[row] = 	ddlb_line_code.getcode()			
					dw_1.object.actual_qty[row] = 0
					dw_1.object.plan_qty_d1[row] = 0
					dw_1.object.plan_qty_d2[row] = 0
					dw_1.object.plan_qty_d3[row] = 0
					dw_1.object.parent_item_code[row] = '*'
					dw_1.object.model_suffix[row] = '*'
					dw_1.object.item_code[row] = '*'			
					
					dw_1.object.plan_time1[row] = 0
					dw_1.object.plan_time2[row] = 0
					dw_1.object.plan_time3[row] = 0
					dw_1.object.plan_time4[row] = 0						
					dw_1.object.plan_time5[row] = 0
					dw_1.object.plan_time6[row] = 0						
					dw_1.object.plan_time7[row] = 0
					dw_1.object.plan_time8[row] = 0
					dw_1.object.plan_time9[row] = 0
					dw_1.object.plan_time10[row] = 0			
			
			else
					
					dw_2.ENABLED = TRUE
					ROW = dw_2.INSERTROW(dw_2.GETROW())
					dw_2.SCROLLTOROW(ROW)
					F_SET_SECURITY_ROW(dw_2 , ROW ,'ALL')
					
					dw_2.object.plan_ym[row] = f_yyyymm()		
					lvdb_seq = double(f_get_sequence( 'seq_plan_date_sequence'))
					dw_2.object.plan_sequence[row] = 	lvdb_seq
					
					dw_2.object.model_name[row] = '*'				
					dw_2.object.model_suffix[row] = '*'
					dw_2.object.plan_1[row] = 0
					dw_2.object.plan_2[row] = 0
					dw_2.object.plan_3[row] = 0
					dw_2.object.plan_4[row] = 0						
					dw_2.object.plan_5[row] = 0
					dw_2.object.plan_6[row] = 0						
					dw_2.object.plan_7[row] = 0
					dw_2.object.plan_8[row] = 0
					dw_2.object.plan_9[row] = 0
					dw_2.object.plan_10[row] = 0							
					dw_2.object.plan_11[row] = 0
					dw_2.object.plan_12[row] = 0					
			
			end if 
			
	case 'DELETE'
		
		  	if dw_1.AcceptText() = -1 then
				return
			end if
			
			if dw_1.getrow() < 1 then return
			
			MSG = F_MSGBOX(1003)  //$$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?
			IF MSG = 1 THEN
				Gvl_row_deleted = dw_1.GetRow()			
				dw_1.DELETEROW(Gvl_row_deleted)		
				dw_1.SetFocus()
				ROW = dw_1.GetRow()
				dw_1.ScrollToRow(row)
				dw_1.SetColumn(1)
			END IF
			
	case 'ROWCOPY'
		
			dw_1.SELECTROW(0 , FALSE)
			lvdb_seq = double(f_get_sequence( 'seq_plan_date_sequence'))
			dw_1.object.plan_sequence[GVL_ROWCOPY_ROW] = 	lvdb_seq
			dw_1.object.actual_qty[GVL_ROWCOPY_ROW] = 0
			dw_1.SCROLLTOROW(GVL_ROWCOPY_ROW)										
			dw_1.SELECTROW(GVL_ROWCOPY_ROW , TRUE)
			
	case 'UPDATE'
		
			IF dw_1.UPDATE() < 0 THEN
			  	 ROLLBACK;
				 RETURN 
			ELSE
				 COMMIT;
	                F_RETRIEVE()
				 F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
				 
			END IF

	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_pln_product_master_plan_master
integer y = 356
end type

type dw_4 from w_main_root`dw_4 within w_pln_product_master_plan_master
integer y = 356
integer width = 2304
integer height = 1396
boolean titlebar = true
boolean hscrollbar = false
end type

type dw_3 from w_main_root`dw_3 within w_pln_product_master_plan_master
integer y = 356
integer width = 2304
integer height = 1396
boolean titlebar = true
end type

type dw_2 from w_main_root`dw_2 within w_pln_product_master_plan_master
integer y = 356
integer width = 3557
integer height = 1396
boolean titlebar = true
string dataobject = "d_pln_mi_month_master_plan_lst"
end type

type dw_1 from w_main_root`dw_1 within w_pln_product_master_plan_master
integer y = 356
integer width = 6487
integer height = 1920
boolean titlebar = true
string title = "Planning Product Master Plan List"
string dataobject = "d_pln_mi_master_plan_lst_tree"
end type

event dw_1::itemchanged;call super::itemchanged;if row < 1 then return 

if mid( dwo.name , 1,9) = 'plan_time' then 	
	this.object.plan_qty_calc[row] = this.object.plan_time1[row]+this.object.plan_time2[row]+this.object.plan_time3[row]+this.object.plan_time4[row]+this.object.plan_time5[row]+this.object.plan_time6[row]+this.object.plan_time7[row]+this.object.plan_time8[row]+this.object.plan_time9[row]+this.object.plan_time10[row]
    this.object.plan_qty[row]  = this.object.plan_qty_calc[row] 
end if 

if dwo.name = 'model_name' then 
	
	   this.object.item_code[row] = f_get_item_code_by_model_suffix( data , '*') 

end if 
end event

event dw_1::rbuttondown;string lvs_str

if mid(dwo.name,1,2) = 'gr' then

		if  lvs_last_gr = dwo.name then 
			
				this.Modify( dwo.name+".width='"+ string(lvl_gr_width) +"'")
				this.Modify( dwo.name+".height='"+ string(lvl_gr_height) +"'")
				this.Modify( dwo.name+".x='"+string(lvl_gr_x) +"'")
				this.Modify( dwo.name+".y='"+ string(lvl_gr_y) +"'")
				lvs_last_gr = ''
		
		else
			
				 //$$HEX7$$d0c6f5bc2000dcc2a4d0e0ac2000$$ENDHEX$$
				if lvs_last_gr <> '' then 
						this.Modify( lvs_last_gr+".width='"+ string(lvl_gr_width) +"'")
						this.Modify( lvs_last_gr+".height='"+ string(lvl_gr_height) +"'")
						this.Modify( lvs_last_gr+".x='"+string(lvl_gr_x) +"'")
						this.Modify( lvs_last_gr+".y='"+ string(lvl_gr_y) +"'")
						lvs_last_gr = ''
							
				end if 
			
						lvl_gr_width = Long(this.Describe( dwo.name+".width"))
						lvl_gr_height =Long(this.Describe( dwo.name+".height"))
						lvl_gr_x =Long(this.Describe( dwo.name+".x"))
						lvl_gr_y=Long(this.Describe( dwo.name+".y"))
						lvs_last_gr  = dwo.name
						
						this.Modify( dwo.name+".width='"+ string(dw_1.width - 400) +"'")
						this.Modify( dwo.name+".height='"+ string(dw_1.height - 800) +"'")
						this.Modify( dwo.name+".x='"+ "10" +"'")
						this.Modify( dwo.name+".y='"+ "10" +"'")
						
						
		
		
		end if 
end if 		
if row < 1 then return 

lvs_str = dwo.name

if dwo.name = 'model_name' then 
	open( w_des_model_master_popup )
	
	if Gst_return.gvb_return = true then 
		this.object.model_name[row] = message.stringparm
		this.object.model_suffix[row] = Gst_return.Gvs_return[3] 
	end if 
end if 


if  upper( trim(mid( dwo.name , 3 , 20)))  = 'TIME_ACTUAL' then 
	
	
	Gst_return.gvdt_return[1] =this.object.plan_date[row]
	Gst_return.gvl_return[1] = this.object.plan_sequence[row]
	Gst_return.gvs_return[1] = mid( dwo.name , 1,1 )
	
     open( w_notify_product_flat) 
	  
end if 





end event

event dw_1::buttonclicked;call super::buttonclicked;if dwo.name = 'b_hide' then 
	
	if dw_1.Describe("DataWindow.Footer.Height") = '0' then 
			dw_1.Modify("DataWindow.Footer.Height='830'")
	else
		dw_1.Modify("DataWindow.Footer.Height='0'")
	end if 

end if 
end event

event dw_1::uo_mousemove;call super::uo_mousemove;integer 	SeriesNbr, ItemNbr
string 	data_value,	&
			old_data

grObjectType	object_type
string 	SeriesName,			&
			ls_CategoryName,		&
			ls_SeriesName
string 	ls_name , data_name
long		ll_width

object_type 		     =	this.ObjectAtPointer( dwo.name , SeriesNbr, ItemNbr)
ls_CategoryName	=	this.CategoryName(dwo.name ,  ItemNbr)
ls_SeriesName		=	this.SeriesName (dwo.name , SeriesNbr )

data_name = this.SeriesName(dwo.name , SeriesNbr)

setpointer(arrow!)

IF object_type = TypeData! THEN 
	
	old_data		=	data_value
	data_value 	= 	String( this.GetData( dwo.name , SeriesNbr, ItemNbr) , "###,###,##0.######")+" : "+data_name
		
	if st_label.visible and old_data = data_value then
		return
	end if
	
	ll_width	=	len( data_value ) * 50
	st_label.text = data_value
	st_label.x 	=   parent.pointerx( ) - 2
	st_label.y	=   parent.pointery( ) + 250
	
	st_label.width	=	ll_width
	st_label.visible = true	
	
	f_msg_mdi_help( ls_SeriesName + ' ** ' + ls_CategoryName + ' ** (' + data_value + ')' )
	
ELSEIF object_type = TypeCategory! THEN
		
	ll_width	=	len( ls_CategoryName ) * 40
	st_label.text = ls_CategoryName
	
	st_label.x 	=   parent.pointerx( ) - 2
	st_label.y	=   parent.pointery( ) + 250
	st_label.width	=	ll_width
	st_label.visible = true	
	
	f_msg_mdi_help( ls_CategoryName )
	

//==============================================
//
//==============================================

ELSEif  upper( trim(mid( dwo.name , 3 , 20)))  = 'TIME_ACTUAL' then 
	
	 IF  upper(mid( dwo.name , 1,1 )) = 'A' then 
		
			mle_note.text = dw_1.getitemstring( row ,  'TIME1_DESC'  )
		
	elseif upper(mid( dwo.name , 1,1 )) = 'B' then 	

			mle_note.text = dw_1.getitemstring( row ,  'TIME2_DESC'  )
	
	elseif upper(mid( dwo.name , 1,1 )) = 'C' then 	

			mle_note.text = dw_1.getitemstring( row ,  'TIME3_DESC'  )
	elseif upper(mid( dwo.name , 1,1 )) = 'D' then 	

			mle_note.text = dw_1.getitemstring( row ,  'TIME4_DESC'  )
	elseif upper(mid( dwo.name , 1,1 )) = 'E' then 	

			mle_note.text = dw_1.getitemstring( row ,  'TIME5_DESC'  )
	elseif upper(mid( dwo.name , 1,1 )) = 'F' then 	

			mle_note.text = dw_1.getitemstring( row ,  'TIME6_DESC'  )
	elseif upper(mid( dwo.name , 1,1 )) = 'G' then 	

			mle_note.text = dw_1.getitemstring( row ,  'TIME7_DESC'  )
	elseif upper(mid( dwo.name , 1,1 )) = 'H' then 	

			mle_note.text = dw_1.getitemstring( row ,  'TIME8_DESC'  )
	elseif upper(mid( dwo.name , 1,1 )) = 'I' then 	

			mle_note.text = dw_1.getitemstring( row ,  'TIME9_DESC'  )
	elseif upper(mid( dwo.name , 1,1 )) = 'J' then 	

			mle_note.text = dw_1.getitemstring( row ,  'TIME10_DESC'  )			
	end if 

    if len( mle_note.text ) > 0 then 

		if mle_note.visible and old_data = data_value then
			return
		end if
		
 		old_data		=	data_value
		data_value 	= 	mle_note.text	
	
	//		ll_width	=	     len( mle_note.text ) * 40
			mle_note.x 	=   parent.pointerx( ) - 2
			mle_note.y	=   parent.pointery( ) + 250
		//	mle_note.width	=	ll_width
			mle_note.visible = true			
			
	else
			f_msg_mdi_help("")
			mle_note.visible 	= 	false				
	end if 
	
ELSE
	f_msg_mdi_help("")
	st_label.visible 	= 	false	
	mle_note.visible 	= 	false	
END IF

end event

type uo_tabpages from w_main_root`uo_tabpages within w_pln_product_master_plan_master
end type

type st_1 from so_statictext within w_pln_product_master_plan_master
integer x = 2601
integer y = 88
integer width = 567
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Line Code"
end type

type st_5 from so_statictext within w_pln_product_master_plan_master
integer x = 3173
integer y = 84
integer width = 709
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Workstage Code"
end type

type st_3 from statictext within w_pln_product_master_plan_master
integer x = 3881
integer y = 84
integer width = 535
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

type ddlb_customer_code from uo_customer_code within w_pln_product_master_plan_master
integer x = 3886
integer y = 168
integer width = 535
integer height = 1936
integer taborder = 40
boolean bringtotop = true
boolean autohscroll = true
boolean hscrollbar = true
end type

type ddlb_line_code from uo_line_code within w_pln_product_master_plan_master
integer x = 2601
integer y = 168
integer width = 562
integer height = 1936
integer taborder = 40
boolean bringtotop = true
end type

type cb_8 from so_commandbutton within w_pln_product_master_plan_master
integer x = 864
integer y = 88
integer width = 87
integer height = 72
integer taborder = 40
boolean bringtotop = true
string text = "<"
end type

event clicked;call super::clicked;uo_dateset.settext (string(RelativeDate( Date(uo_dateset.text()) , -1 )))
uo_dateend.settext( string(RelativeDate( Date(uo_dateend.text()) , -1 )))
end event

type st_yyyymm from so_statictext within w_pln_product_master_plan_master
integer x = 974
integer y = 96
integer width = 603
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Plan Date"
end type

type cb_9 from so_commandbutton within w_pln_product_master_plan_master
integer x = 1591
integer y = 92
integer width = 87
integer height = 72
integer taborder = 50
boolean bringtotop = true
string text = ">"
end type

event clicked;call super::clicked;uo_dateset.settext (string(RelativeDate( Date(uo_dateset.text()) , 1 )))
uo_dateend.settext( string(RelativeDate( Date(uo_dateend.text()) , 1 )))
end event

type uo_dateend from uo_ymd_calendar within w_pln_product_master_plan_master
integer x = 1275
integer y = 168
integer taborder = 50
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateset from uo_ymd_calendar within w_pln_product_master_plan_master
integer x = 869
integer y = 168
integer taborder = 60
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type tab_1 from tab within w_pln_product_master_plan_master
event create ( )
event destroy ( )
integer x = 4466
integer y = 12
integer width = 2043
integer height = 320
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean fixedwidth = true
boolean raggedright = true
boolean focusonbuttondown = true
boolean powertips = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.Control[]={this.tabpage_1,&
this.tabpage_2}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
end on

type tabpage_1 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 2007
integer height = 192
long backcolor = 15780518
string text = "Process"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Regenerate5!"
long picturemaskcolor = 536870912
ddlb_time ddlb_time
cb_3 cb_3
st_2 st_2
em_plan_qty em_plan_qty
cb_1 cb_1
end type

on tabpage_1.create
this.ddlb_time=create ddlb_time
this.cb_3=create cb_3
this.st_2=create st_2
this.em_plan_qty=create em_plan_qty
this.cb_1=create cb_1
this.Control[]={this.ddlb_time,&
this.cb_3,&
this.st_2,&
this.em_plan_qty,&
this.cb_1}
end on

on tabpage_1.destroy
destroy(this.ddlb_time)
destroy(this.cb_3)
destroy(this.st_2)
destroy(this.em_plan_qty)
destroy(this.cb_1)
end on

type ddlb_time from so_dropdownlistbox within tabpage_1
integer x = 878
integer y = 108
integer width = 389
integer taborder = 60
string item[] = {"01","02","03","04","05","06","07","08","09","10","11","12",""}
end type

type cb_3 from so_commandbutton within tabpage_1
integer x = 590
integer y = 12
integer width = 681
integer height = 96
integer taborder = 180
string text = "Set Plan By ST"
end type

event clicked;call super::clicked;string lvs_model_name , lvs_topbot ,lvs_line_code , lvs_start_time , lvs_workstage_code
long lvl_plan_qty , lvl_st , i , lvl_remain_qty , k , LVL_PLAN_QTY_SUM , lvl_mc_time , m 

lvs_line_code= dw_1.object.line_code[dw_1.getrow()]
lvs_model_name = dw_1.object.model_name[dw_1.getrow()]
lvs_workstage_code =  dw_1.object.workstage_code[dw_1.getrow()]
lvl_plan_qty = dw_1.object.plan_qty[dw_1.getrow()]
lvl_remain_qty = lvl_plan_qty


i  =  long(ddlb_time.text )

if i =0 or isnull(i) then 
   //Messagebox("Notify" , "$$HEX14$$dcc291c72000dcc204ac44c7200020c1ddd0200058d538c194c62000$$ENDHEX$$") 
   f_msg( "$$HEX13$$dcc291c72000dcc204ac44c7200020c1ddd0200058d538c194c6$$ENDHEX$$","S") 
   return 
else
	 i = i -1 
end if 


do
	k++
	dw_1.setitem(dw_1.getrow() , 'PLAN_TIME'+STRING(k) ,0 )
loop until k = 10
m= 0 
do
    m++
	 
	if m = 1 then 
		lvl_mc_time = dw_1.object.mc_time[dw_1.getrow()]
	else
		lvl_mc_time = 0
	end if 
	
   	i++

	if i = 1 then 
		lvs_start_time = 'A'
	elseif i = 2 then 
		lvs_start_time = 'B'
	elseif i = 3 then 
		lvs_start_time = 'C'
	elseif i = 4 then 
		lvs_start_time = 'D'
	
	elseif i = 5 then 
		lvs_start_time = 'E'
	elseif i = 6 then 
		lvs_start_time = 'F'
	elseif i = 7 then 
		lvs_start_time = 'G'
	elseif i = 8 then 
		lvs_start_time = 'H'
	elseif i = 9 then 
		lvs_start_time = 'I'
	elseif i = 10 then 
		lvs_start_time = 'J'
	elseif i = 11 then 
		lvs_start_time = 'K'
	elseif i = 12 then 
		lvs_start_time = 'L' 
	END IF 	
	
    SELECT 	F_GET_PLAN_QTY_BY_PRODUCT_ST (:lvs_line_code ,
				:lvs_model_name,
				:lvs_topbot,
				:lvs_workstage_code,
				:lvs_start_time ,
				:lvl_mc_time ,
				:GVI_ORGANIZATION_ID )
	  INTO :LVL_PLAN_QTY 
	 FROM DUAL ;
	 
	 IF F_SQL_CHECK() < 0 THEN 
		RETURN 
	END IF 
	
	LVL_PLAN_QTY_SUM = LVL_PLAN_QTY_SUM + LVL_PLAN_QTY
		
	if i = 10 then 
		
		 dw_1.setitem(dw_1.getrow() , 'PLAN_TIME'+STRING(i) ,lvl_remain_qty )
		 lvl_remain_qty = 0 
	else
	
			if lvl_remain_qty > LVL_PLAN_QTY then 
				dw_1.setitem(dw_1.getrow() , 'PLAN_TIME'+STRING(i) ,LVL_PLAN_QTY )
				lvl_remain_qty = lvl_remain_qty - LVL_PLAN_QTY
			else
				dw_1.setitem(dw_1.getrow() , 'PLAN_TIME'+STRING(i) ,lvl_remain_qty )
					 lvl_remain_qty = 0 
			end if 
	end if 
	


	f_msg_mdi_help( string(i))
	

loop until  lvl_remain_qty = 0

dw_1.setitem(dw_1.getrow() , 'PLAN_CAPA_QTY' ,LVL_PLAN_QTY_SUM )
end event

type st_2 from so_statictext within tabpage_1
integer x = 549
integer y = 116
integer width = 334
integer height = 60
long backcolor = 15780518
string text = "Start Time"
end type

type em_plan_qty from so_editmask within tabpage_1
integer x = 23
integer y = 104
integer width = 498
integer taborder = 30
string text = "0"
string mask = "###,##0"
boolean spin = true
double increment = 1
end type

type cb_1 from so_commandbutton within tabpage_1
integer x = 23
integer y = 8
integer width = 498
integer height = 96
integer taborder = 30
string text = "Set Plan By Qty"
end type

event clicked;call super::clicked;if dw_1.getrow() < 1 then return 

dw_1.object.plan_time1[dw_1.getrow()] = Long( em_plan_qty.text ) 
dw_1.object.plan_time2[dw_1.getrow()] = Long( em_plan_qty.text ) 
dw_1.object.plan_time3[dw_1.getrow()] = Long( em_plan_qty.text ) 
dw_1.object.plan_time4[dw_1.getrow()] = Long( em_plan_qty.text ) 
dw_1.object.plan_time5[dw_1.getrow()] = Long( em_plan_qty.text ) 
dw_1.object.plan_time6[dw_1.getrow()] = Long( em_plan_qty.text ) 
dw_1.object.plan_time7[dw_1.getrow()] = Long( em_plan_qty.text ) 
dw_1.object.plan_time8[dw_1.getrow()] = Long( em_plan_qty.text ) 
dw_1.object.plan_time9[dw_1.getrow()] = Long( em_plan_qty.text ) 
dw_1.object.plan_time10[dw_1.getrow()] = Long( em_plan_qty.text) 

end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2007
integer height = 192
long backcolor = 12632256
string text = "Excel"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Custom004!"
long picturemaskcolor = 536870912
cb_17 cb_17
cb_2 cb_2
end type

on tabpage_2.create
this.cb_17=create cb_17
this.cb_2=create cb_2
this.Control[]={this.cb_17,&
this.cb_2}
end on

on tabpage_2.destroy
destroy(this.cb_17)
destroy(this.cb_2)
end on

type cb_17 from so_commandbutton within tabpage_2
integer x = 59
integer y = 20
integer width = 553
integer height = 156
integer taborder = 80
boolean bringtotop = true
string text = "Import From Excel"
end type

event clicked;call super::clicked;dw_1.reset()
dw_1.importclipboard( )

int i
do
	
	i++
	
	F_SET_SECURITY_ROW(dw_1 , i ,'ALL')

loop until i = dw_1.rowcount( )
end event

type cb_2 from so_commandbutton within tabpage_2
integer x = 617
integer y = 20
integer width = 613
integer height = 156
integer taborder = 170
boolean bringtotop = true
string text = "Form Save"
end type

event clicked;Datawindow ivdw_data_window
string     docname, named 
Long iret
ivdw_data_window = dw_1 
if isvalid(ivdw_data_window) then 
	
	if ivdw_data_window.getrow() < 1 then  
		dw_1.insertrow(0)
	end if
	
else
	return
end if

		SETPOINTER(HOURGLASS!)		
		iret = GetFileSaveName("Select Excel File ("+ivdw_data_window.classname()+")" , docname, named, "xls", "Excel Files (*.xls),*.xls")		

              IF iret =1 THEN 
		         uf_save_dw_as_excel( ivdw_data_window  , docname )
		ELSE
			RETURN
		END IF
		
//=================================================

end event

type rb_1 from so_radiobutton within w_pln_product_master_plan_master
integer x = 873
integer y = 252
integer width = 334
integer height = 64
boolean bringtotop = true
integer weight = 700
string text = "Today"
end type

event clicked;call super::clicked;uo_dateend.settext( string(f_t_sysdate()) )
end event

type rb_3 from so_radiobutton within w_pln_product_master_plan_master
integer x = 1157
integer y = 252
integer width = 315
integer height = 64
boolean bringtotop = true
integer weight = 700
string text = "1 Week"
end type

event clicked;call super::clicked;uo_dateend.settext( string(f_v_sysdate(-7)) )
end event

type rb_4 from so_radiobutton within w_pln_product_master_plan_master
integer x = 1477
integer y = 252
integer width = 315
integer height = 64
boolean bringtotop = true
integer weight = 700
string text = "2 Week"
end type

event clicked;call super::clicked;uo_dateend.settext( string(f_v_sysdate(-14)) )
end event

type rb_5 from so_radiobutton within w_pln_product_master_plan_master
integer x = 1792
integer y = 252
integer width = 315
integer height = 64
boolean bringtotop = true
integer weight = 700
string text = "4 Week"
end type

event clicked;call super::clicked;uo_dateend.settext( string(f_v_sysdate(-28)) )
end event

type ddlb_model_name from uo_set_model_name_ddlb within w_pln_product_master_plan_master
integer x = 1705
integer y = 168
integer width = 887
integer height = 1936
integer taborder = 50
boolean bringtotop = true
end type

type st_4 from so_statictext within w_pln_product_master_plan_master
integer x = 1710
integer y = 96
integer width = 887
integer height = 68
boolean bringtotop = true
string text = "Model Name"
end type

type rb_master_plan from so_radiobutton within w_pln_product_master_plan_master
integer x = 69
integer y = 88
integer width = 704
boolean bringtotop = true
string text = "Product Plan Master"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1
end event

type rb_month_plan from so_radiobutton within w_pln_product_master_plan_master
integer x = 69
integer y = 196
integer width = 704
boolean bringtotop = true
string text = "Product Plan Monthly Master"
end type

event clicked;call super::clicked;dw_2.bringtotop = true 
selected_data_window = dw_2
end event

type ddlb_workstage_code from uo_workstage_code_all within w_pln_product_master_plan_master
integer x = 3168
integer y = 168
integer width = 713
integer height = 1480
integer taborder = 50
boolean bringtotop = true
end type

type mle_note from multilineedit within w_pln_product_master_plan_master
boolean visible = false
integer x = 1353
integer y = 884
integer width = 3424
integer height = 1020
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 65280
long backcolor = 0
borderstyle borderstyle = stylelowered!
end type

type st_label from statictext within w_pln_product_master_plan_master
boolean visible = false
integer x = 9
integer y = 2304
integer width = 1467
integer height = 124
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 65535
long backcolor = 32768
boolean focusrectangle = false
end type

type gb_1 from so_groupbox within w_pln_product_master_plan_master
integer x = 841
integer y = 8
integer width = 3616
integer height = 320
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_pln_product_master_plan_master
integer y = 8
integer width = 827
integer height = 324
integer taborder = 40
string text = "Category"
end type

