HA$PBExportHeader$w_spi_query.srw
$PBExportComments$spi_time_query
forward
global type w_spi_query from w_main_root
end type
type st_label from so_statictext within w_spi_query
end type
type st_6 from so_statictext within w_spi_query
end type
type st_1 from so_statictext within w_spi_query
end type
type ddlb_line_code from uo_line_code within w_spi_query
end type
type uo_dateset from uo_ymd_calendar within w_spi_query
end type
type uo_dateend from uo_ymd_calendar within w_spi_query
end type
type gb_3 from so_groupbox within w_spi_query
end type
end forward

global type w_spi_query from w_main_root
integer width = 5737
integer height = 2840
string title = "SPI TIME QUERY"
string ivs_dw_4_use_focusindicator = "Y"
st_label st_label
st_6 st_6
st_1 st_1
ddlb_line_code ddlb_line_code
uo_dateset uo_dateset
uo_dateend uo_dateend
gb_3 gb_3
end type
global w_spi_query w_spi_query

type variables
string lvs_current_array_type
long lvl_default_width , lvl_default_height , lvl_x , lvl_y

String lvs_last_gr,  ivs_hide = '1'
long  lvl_gr_width , lvl_gr_height , lvl_gr_x , lvl_gr_y
end variables

on w_spi_query.create
int iCurrent
call super::create
this.st_label=create st_label
this.st_6=create st_6
this.st_1=create st_1
this.ddlb_line_code=create ddlb_line_code
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_label
this.Control[iCurrent+2]=this.st_6
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.ddlb_line_code
this.Control[iCurrent+5]=this.uo_dateset
this.Control[iCurrent+6]=this.uo_dateend
this.Control[iCurrent+7]=this.gb_3
end on

on w_spi_query.destroy
call super::destroy
destroy(this.st_label)
destroy(this.st_6)
destroy(this.st_1)
destroy(this.ddlb_line_code)
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.gb_3)
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

event ue_post_open;call super::ue_post_open;string ls_syntax 


//DW1, DW2 $$HEX2$$c0bcbdac$$ENDHEX$$
ls_syntax	=	f_get_dataobject('REPORT', upper(THIS.CLASSNAME()) ,  string( dw_1.dataobject )	)
if	ls_syntax = '' or isnull(ls_syntax) then
	f_msg_mdi_help("Report Not Changed")
else
	dw_1.create(ls_syntax)
	dw_1.settransobject(sqlca)
	f_set_column_dddw(dw_1)
	f_dual_lang_change_dwtext(dw_1)
	f_msg_mdi_help("Report Changed")
end if	

//ls_syntax	=	f_get_dataobject('REPORT', upper(THIS.CLASSNAME()) ,  string( dw_2.dataobject )	)
//if	ls_syntax = '' or isnull(ls_syntax) then
//	f_msg_mdi_help("Report Not Changed")
//else
//	dw_2.create(ls_syntax)
//	dw_2.settransobject(sqlca)
//	f_set_column_dddw(dw_2)
//	f_dual_lang_change_dwtext(dw_2)
//	f_msg_mdi_help("Report Changed")
//end if	



/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

string lvs_date 
select to_char(sysdate , 'yyyy/mm/dd') 
  into :lvs_date 
  from dual ; 
  
 uo_dateend.settext(lvs_date) 
 

 

dw_1.setfocus()
dw_1.bringtotop = true 
selected_data_window = dw_1

//sle_run_no.setfocus()



end event

event ue_data_control;call super::ue_data_control;STRING lvs_start, lvs_end

lvs_start = string(uo_dateset.text(),'YYYYMMDD') 
lvs_end = string(uo_dateend.text(),'YYYYMMDD')


choose case gvs_ue_data_control
		
	case 'RETRIEVE'
			
			
			
			f_dual_lang_change_text(this)			
			dw_1.retrieve( ddlb_line_code.getcode() + '%',lvs_start, lvs_end)
						
	case else
end choose

end event

event clicked;call super::clicked;//sle_run_no.setfocus()
end event

type dw_5 from w_main_root`dw_5 within w_spi_query
integer y = 340
integer width = 4242
integer height = 1040
integer taborder = 0
boolean titlebar = true
string dataobject = "d_pln_workstage_inventory_lst"
boolean maxbox = false
end type

type dw_4 from w_main_root`dw_4 within w_spi_query
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

type dw_3 from w_main_root`dw_3 within w_spi_query
integer y = 340
integer width = 4238
integer height = 1040
integer taborder = 0
boolean titlebar = true
boolean maxbox = false
boolean border = false
end type

type dw_2 from w_main_root`dw_2 within w_spi_query
integer x = 14
integer y = 332
integer width = 4242
integer height = 1040
integer taborder = 0
boolean titlebar = true
string title = "History"
end type

event dw_2::updateend;//override
end event

event dw_2::updatestart;//override
end event

event dw_2::doubleclicked;call super::doubleclicked;if row < 1 then return 
openwithparm( w_plan_run_no_status_popup , string(this.object.run_no[row]) )
end event

type dw_1 from w_main_root`dw_1 within w_spi_query
integer y = 324
integer width = 4251
integer height = 1856
integer taborder = 0
boolean titlebar = true
string title = "Current Status"
string dataobject = "d_spi_query"
end type

event dw_1::clicked;call super::clicked;if dwo.name = 'b_sum' then 
	
	this.dataobject = 'd_production_performance'
	this.settransobject( sqlca)
	f_dual_lang_change_dwtext(this)
	f_retrieve()
elseif 	 dwo.name = 'b_detail' then 
	
	this.dataobject = 'd_production_performance'
	this.settransobject( sqlca)
	f_dual_lang_change_dwtext(this)
	f_retrieve()	
end if 
end event

type uo_tabpages from w_main_root`uo_tabpages within w_spi_query
integer taborder = 0
end type

type st_label from so_statictext within w_spi_query
boolean visible = false
integer x = 9
integer y = 344
integer width = 2030
integer height = 92
boolean bringtotop = true
integer textsize = -10
long backcolor = 65535
end type

type st_6 from so_statictext within w_spi_query
integer x = 791
integer y = 80
integer width = 544
integer height = 68
boolean bringtotop = true
string text = "inspect_date"
end type

type st_1 from so_statictext within w_spi_query
integer x = 27
integer y = 92
integer width = 585
integer height = 76
boolean bringtotop = true
string text = "LINE"
end type

type ddlb_line_code from uo_line_code within w_spi_query
integer x = 59
integer y = 168
integer width = 498
integer height = 1936
integer taborder = 71
boolean bringtotop = true
long backcolor = 16777215
end type

type uo_dateset from uo_ymd_calendar within w_spi_query
event destroy ( )
integer x = 608
integer y = 164
integer taborder = 50
boolean bringtotop = true
long backcolor = 12632256
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_spi_query
event destroy ( )
integer x = 1029
integer y = 164
integer taborder = 60
boolean bringtotop = true
long backcolor = 12632256
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type gb_3 from so_groupbox within w_spi_query
integer y = 4
integer width = 1591
integer height = 320
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Condition"
end type

