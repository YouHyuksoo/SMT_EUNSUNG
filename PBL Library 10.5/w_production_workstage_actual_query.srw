HA$PBExportHeader$w_production_workstage_actual_query.srw
$PBExportComments$$$HEX6$$ddc0b0c0e4c201c870c88cd6$$ENDHEX$$
forward
global type w_production_workstage_actual_query from w_main_root
end type
type st_label from so_statictext within w_production_workstage_actual_query
end type
type st_6 from so_statictext within w_production_workstage_actual_query
end type
type rb_1 from so_radiobutton within w_production_workstage_actual_query
end type
type rb_3 from so_radiobutton within w_production_workstage_actual_query
end type
type st_1 from so_statictext within w_production_workstage_actual_query
end type
type ddlb_model_name from uo_set_model_name_ddlb within w_production_workstage_actual_query
end type
type uo_actual_date from uo_ymd_calendar within w_production_workstage_actual_query
end type
type gb_3 from so_groupbox within w_production_workstage_actual_query
end type
type gb_1 from so_groupbox within w_production_workstage_actual_query
end type
end forward

global type w_production_workstage_actual_query from w_main_root
integer width = 4325
integer height = 2840
string title = "WorkStage Actual Query"
string ivs_dw_4_use_focusindicator = "Y"
st_label st_label
st_6 st_6
rb_1 rb_1
rb_3 rb_3
st_1 st_1
ddlb_model_name ddlb_model_name
uo_actual_date uo_actual_date
gb_3 gb_3
gb_1 gb_1
end type
global w_production_workstage_actual_query w_production_workstage_actual_query

type variables
string lvs_current_array_type
long lvl_default_width , lvl_default_height , lvl_x , lvl_y

String lvs_last_gr,  ivs_hide = '1'
long  lvl_gr_width , lvl_gr_height , lvl_gr_x , lvl_gr_y
end variables

on w_production_workstage_actual_query.create
int iCurrent
call super::create
this.st_label=create st_label
this.st_6=create st_6
this.rb_1=create rb_1
this.rb_3=create rb_3
this.st_1=create st_1
this.ddlb_model_name=create ddlb_model_name
this.uo_actual_date=create uo_actual_date
this.gb_3=create gb_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_label
this.Control[iCurrent+2]=this.st_6
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.rb_3
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.ddlb_model_name
this.Control[iCurrent+7]=this.uo_actual_date
this.Control[iCurrent+8]=this.gb_3
this.Control[iCurrent+9]=this.gb_1
end on

on w_production_workstage_actual_query.destroy
call super::destroy
destroy(this.st_label)
destroy(this.st_6)
destroy(this.rb_1)
destroy(this.rb_3)
destroy(this.st_1)
destroy(this.ddlb_model_name)
destroy(this.uo_actual_date)
destroy(this.gb_3)
destroy(this.gb_1)
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
Ivs_resize_type                      = 'NORMAL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )

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
F_MENU_CONTROL('REPORT' ,TRUE)  // All Data Control

//sle_run_no.setfocus()




end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())


dw_1.setfocus()

//sle_run_no.setfocus()
end event

event ue_data_control;call super::ue_data_control;STRING lvs_qc_scan_yn
STRING Model
INT i

datetime lvd_actual_date

lvd_actual_date = uo_actual_date.uf_get_ymd_dt() 


Model = ddlb_model_name.text

i = pos(Model,'@')

if i <> 0 then
	Model = left(Model, i - 1)
end if

if Model = '' then
	Model = '%'
end if

choose case gvs_ue_data_control
		
	case 'RETRIEVE'

		if rb_3.checked = true then
			
			dw_1.retrieve(lvd_actual_date, Model)
			
			
		elseif rb_1.checked = true then
			
	
			dw_2.retrieve(Model )
			
			
		end if
			
	case else
end choose

end event

event clicked;call super::clicked;//sle_run_no.setfocus()
end event

event open;call super::open;rb_3.checked = true
end event

type dw_5 from w_main_root`dw_5 within w_production_workstage_actual_query
integer x = 5
integer y = 340
integer width = 4242
integer height = 1040
integer taborder = 0
boolean titlebar = true
boolean maxbox = false
end type

type dw_4 from w_main_root`dw_4 within w_production_workstage_actual_query
integer x = 5
integer y = 340
integer width = 4242
integer height = 1040
integer taborder = 0
boolean titlebar = true
end type

event dw_4::rbuttondown;call super::rbuttondown;if row < 1 then return

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
						
						this.Modify( dwo.name+".width='"+ string(dw_1.width - 200) +"'")
						this.Modify( dwo.name+".height='"+ string(dw_1.height - 500) +"'")
						this.Modify( dwo.name+".x='"+ "8800" +"'")
						this.Modify( dwo.name+".y='"+ "200" +"'")
		
		
		end if 
end if 		
end event

event dw_4::uo_mousemove;call super::uo_mousemove;
integer 	SeriesNbr, ItemNbr
string 	data_value,	&
			old_data

grObjectType	object_type
string 	SeriesName,			&
			ls_CategoryName,		&
			ls_SeriesName
string 	ls_name , data_name
long		ll_width

object_type 		      = 	this.ObjectAtPointer( dwo.name , SeriesNbr, ItemNbr)
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
	
	ll_width	=	len( data_value ) * 40
	st_label.text = data_value
//	st_label.x 	=   xpos - 2
//	st_label.y	=	ypos + 250
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
	
//	st_label.x 	=  xpos - 2
//	st_label.y	=	ypos + 250
	st_label.width	=	ll_width
	st_label.visible = true	
	
	f_msg_mdi_help( ls_CategoryName )
ELSE
	f_msg_mdi_help("")
	st_label.visible 	= 	false	
END IF

end event

event dw_4::buttonclicked;call super::buttonclicked;long i
if dwo.name = 'b_hide' and ivs_hide = '0' then 
	ivs_hide = '1'
	this.modify( "b_hide.text='Hide'" )
	
	do
		i++
		this.modify(  "gr_"+string(i)+".visible='1'" )
	
	loop until i = 44

elseif dwo.name = 'b_hide' and ivs_hide = '1' then 
	
	this.modify( "b_hide.text='Show'" )
	ivs_hide = '0'
	do
		i++
		this.modify(  "gr_"+string(i)+".visible='0'" )
	
	loop until i = 44
		
end if 
end event

type dw_3 from w_main_root`dw_3 within w_production_workstage_actual_query
integer x = 5
integer y = 340
integer width = 4238
integer height = 1040
integer taborder = 0
boolean titlebar = true
boolean maxbox = false
boolean border = false
end type

type dw_2 from w_main_root`dw_2 within w_production_workstage_actual_query
integer x = 5
integer y = 340
integer width = 4242
integer height = 1040
integer taborder = 0
boolean titlebar = true
string title = "Model"
string dataobject = "d_production_workstage_stock_query"
end type

event dw_2::updateend;//override
end event

event dw_2::updatestart;//override
end event

event dw_2::doubleclicked;call super::doubleclicked;if row < 1 then return 
//openwithparm( w_plan_run_no_status_popup , string(this.object.run_no[row]) )
end event

type dw_1 from w_main_root`dw_1 within w_production_workstage_actual_query
integer x = 5
integer y = 340
integer width = 4242
integer height = 1040
integer taborder = 0
boolean titlebar = true
string title = "WorkStage Actual Query"
string dataobject = "d_production_workstage_actual_query"
end type

event dw_1::clicked;call super::clicked;//if dwo.name = 'b_sum' then 
//	
//	this.dataobject = 'd_production_performance'
//	this.settransobject( sqlca)
//	f_dual_lang_change_dwtext(this)
//	f_retrieve()
//elseif 	 dwo.name = 'b_detail' then 
//	
//	this.dataobject = 'd_production_performance'
//	this.settransobject( sqlca)
//	f_dual_lang_change_dwtext(this)
//	f_retrieve()	
//end if 
end event

type uo_tabpages from w_main_root`uo_tabpages within w_production_workstage_actual_query
integer taborder = 0
end type

type st_label from so_statictext within w_production_workstage_actual_query
boolean visible = false
integer x = 9
integer y = 344
integer width = 2030
integer height = 92
boolean bringtotop = true
integer textsize = -10
long backcolor = 65535
end type

type st_6 from so_statictext within w_production_workstage_actual_query
integer x = 736
integer y = 84
integer width = 416
integer height = 68
boolean bringtotop = true
string text = "Actual Date"
end type

type rb_1 from so_radiobutton within w_production_workstage_actual_query
integer x = 73
integer y = 180
integer width = 507
integer height = 64
boolean bringtotop = true
string text = "Stock By Workstage"
end type

event clicked;call super::clicked;dw_2.bringtotop = true 
selected_data_window = dw_2
end event

type rb_3 from so_radiobutton within w_production_workstage_actual_query
integer x = 73
integer y = 96
integer width = 530
integer height = 64
boolean bringtotop = true
string text = "Actual by WorkStage"
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1
end event

type st_1 from so_statictext within w_production_workstage_actual_query
integer x = 1184
integer y = 84
integer width = 795
integer height = 68
boolean bringtotop = true
string text = "Model"
end type

type ddlb_model_name from uo_set_model_name_ddlb within w_production_workstage_actual_query
integer x = 1184
integer y = 164
integer width = 795
integer taborder = 120
boolean bringtotop = true
boolean hscrollbar = false
end type

type uo_actual_date from uo_ymd_calendar within w_production_workstage_actual_query
event destroy ( )
integer x = 736
integer y = 164
integer taborder = 130
boolean bringtotop = true
end type

on uo_actual_date.destroy
call uo_ymd_calendar::destroy
end on

type gb_3 from so_groupbox within w_production_workstage_actual_query
integer x = 645
integer width = 1435
integer height = 320
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Condition"
end type

type gb_1 from so_groupbox within w_production_workstage_actual_query
integer width = 635
integer height = 320
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Type"
end type

