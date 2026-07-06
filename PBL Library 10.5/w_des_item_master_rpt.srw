HA$PBExportHeader$w_des_item_master_rpt.srw
$PBExportComments$BOM$$HEX3$$acb9ecd3b8d2$$ENDHEX$$
forward
global type w_des_item_master_rpt from w_main_root
end type
type rb_all from so_radiobutton within w_des_item_master_rpt
end type
type rb_2 from so_radiobutton within w_des_item_master_rpt
end type
type rb_goods from so_radiobutton within w_des_item_master_rpt
end type
type rb_1 from so_radiobutton within w_des_item_master_rpt
end type
type rb_3 from so_radiobutton within w_des_item_master_rpt
end type
type uo_item from uo_item_code within w_des_item_master_rpt
end type
type st_5 from so_statictext within w_des_item_master_rpt
end type
type st_14 from so_statictext within w_des_item_master_rpt
end type
type sle_item_name from so_singlelineedit within w_des_item_master_rpt
end type
type st_1 from so_statictext within w_des_item_master_rpt
end type
type sle_item_spec from so_singlelineedit within w_des_item_master_rpt
end type
type gb_where_condition from groupbox within w_des_item_master_rpt
end type
type gb_3 from so_groupbox within w_des_item_master_rpt
end type
end forward

global type w_des_item_master_rpt from w_main_root
integer width = 4549
integer height = 2648
string title = "Item Master Report"
windowstate windowstate = maximized!
rb_all rb_all
rb_2 rb_2
rb_goods rb_goods
rb_1 rb_1
rb_3 rb_3
uo_item uo_item
st_5 st_5
st_14 st_14
sle_item_name sle_item_name
st_1 st_1
sle_item_spec sle_item_spec
gb_where_condition gb_where_condition
gb_3 gb_3
end type
global w_des_item_master_rpt w_des_item_master_rpt

type variables

end variables

on w_des_item_master_rpt.create
int iCurrent
call super::create
this.rb_all=create rb_all
this.rb_2=create rb_2
this.rb_goods=create rb_goods
this.rb_1=create rb_1
this.rb_3=create rb_3
this.uo_item=create uo_item
this.st_5=create st_5
this.st_14=create st_14
this.sle_item_name=create sle_item_name
this.st_1=create st_1
this.sle_item_spec=create sle_item_spec
this.gb_where_condition=create gb_where_condition
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_all
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_goods
this.Control[iCurrent+4]=this.rb_1
this.Control[iCurrent+5]=this.rb_3
this.Control[iCurrent+6]=this.uo_item
this.Control[iCurrent+7]=this.st_5
this.Control[iCurrent+8]=this.st_14
this.Control[iCurrent+9]=this.sle_item_name
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.sle_item_spec
this.Control[iCurrent+12]=this.gb_where_condition
this.Control[iCurrent+13]=this.gb_3
end on

on w_des_item_master_rpt.destroy
call super::destroy
destroy(this.rb_all)
destroy(this.rb_2)
destroy(this.rb_goods)
destroy(this.rb_1)
destroy(this.rb_3)
destroy(this.uo_item)
destroy(this.st_5)
destroy(this.st_14)
destroy(this.sle_item_name)
destroy(this.st_1)
destroy(this.sle_item_spec)
destroy(this.gb_where_condition)
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
/*****************************************
* Data Window Property
******************************************/
Ivs_resize_type                      = 'NORMAL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


/*****************************************
* Data Window Property
******************************************/
ivs_dw_1_use_focusindicator = 'N' //Focus Indicator Show / Hide Property
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
F_MENU_CONTROL('REPORT' , True)  // All Data Control





end event

event ue_data_control;call super::ue_data_control;Long ROW
CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'

				DW_1.RETRIEVE( uo_item.text+'%' , GVI_ORGANIZATION_ID )
		          DW_1.SETFOCUS()
						
	CASE ELSE
END CHOOSE
end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

type dw_5 from w_main_root`dw_5 within w_des_item_master_rpt
integer y = 316
end type

type dw_4 from w_main_root`dw_4 within w_des_item_master_rpt
integer y = 316
end type

type dw_3 from w_main_root`dw_3 within w_des_item_master_rpt
integer y = 316
end type

type dw_2 from w_main_root`dw_2 within w_des_item_master_rpt
integer y = 316
integer taborder = 0
end type

type dw_1 from w_main_root`dw_1 within w_des_item_master_rpt
integer y = 316
integer width = 4507
integer height = 2120
integer taborder = 0
boolean titlebar = true
string title = "Item Master List"
string dataobject = "d_des_item_master_rpt"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_des_item_master_rpt
end type

type rb_all from so_radiobutton within w_des_item_master_rpt
integer x = 1797
integer y = 136
integer width = 357
boolean bringtotop = true
integer weight = 700
string text = "All"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.setfilter('')
dw_1.filter()
end event

type rb_2 from so_radiobutton within w_des_item_master_rpt
integer x = 2171
integer y = 136
boolean bringtotop = true
integer weight = 700
string text = "Material"
end type

event clicked;call super::clicked;dw_1.setfilter("item_division = 'R' ")
dw_1.filter()
end event

type rb_goods from so_radiobutton within w_des_item_master_rpt
integer x = 2665
integer y = 136
boolean bringtotop = true
integer weight = 700
string text = "Goods"
end type

event clicked;call super::clicked;dw_1.setfilter("item_division = 'G' ")
dw_1.filter()
end event

type rb_1 from so_radiobutton within w_des_item_master_rpt
integer x = 3159
integer y = 140
integer width = 430
boolean bringtotop = true
integer weight = 700
string text = "Product"
end type

event clicked;call super::clicked;dw_1.setfilter("item_division = 'F' ")
dw_1.filter()
end event

type rb_3 from so_radiobutton within w_des_item_master_rpt
integer x = 3621
integer y = 136
integer width = 430
boolean bringtotop = true
integer weight = 700
string text = "Model"
end type

event clicked;call super::clicked;dw_1.setfilter("item_division = 'M' ")
dw_1.filter()
end event

type uo_item from uo_item_code within w_des_item_master_rpt
integer x = 37
integer y = 164
integer width = 581
integer height = 764
integer taborder = 40
boolean bringtotop = true
end type

type st_5 from so_statictext within w_des_item_master_rpt
integer x = 37
integer y = 96
integer width = 581
integer height = 56
boolean bringtotop = true
boolean enabled = false
string text = "Item Code"
end type

type st_14 from so_statictext within w_des_item_master_rpt
integer x = 622
integer y = 96
integer width = 535
integer height = 56
boolean bringtotop = true
long textcolor = 16711680
string text = "Item Name"
end type

type sle_item_name from so_singlelineedit within w_des_item_master_rpt
integer x = 622
integer y = 164
integer width = 535
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

SELECTED_DATA_WINDOW.SETFILTER('')
SELECTED_DATA_WINDOW.FILTER()

LVS_COLUMN = 'ITEM_NAME'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    SELECTED_DATA_WINDOW.SETFILTER('')
    SELECTED_DATA_WINDOW.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

SELECTED_DATA_WINDOW.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
SELECTED_DATA_WINDOW.FILTER()
F_MSG_MDI_HELP( STRING( SELECTED_DATA_WINDOW.ROWCOUNT() ) + " Found" )
end event

type st_1 from so_statictext within w_des_item_master_rpt
integer x = 1161
integer y = 96
integer width = 539
integer height = 56
boolean bringtotop = true
long textcolor = 16711680
string text = "Item Spec"
end type

type sle_item_spec from so_singlelineedit within w_des_item_master_rpt
integer x = 1161
integer y = 164
integer width = 539
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

SELECTED_DATA_WINDOW.SETFILTER('')
SELECTED_DATA_WINDOW.FILTER()

LVS_COLUMN = 'ITEM_SPEC'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    SELECTED_DATA_WINDOW.SETFILTER('')
    SELECTED_DATA_WINDOW.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

SELECTED_DATA_WINDOW.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
SELECTED_DATA_WINDOW.FILTER()
F_MSG_MDI_HELP( STRING( SELECTED_DATA_WINDOW.ROWCOUNT() ) + " Found" )
end event

type gb_where_condition from groupbox within w_des_item_master_rpt
integer y = 4
integer width = 1728
integer height = 304
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

type gb_3 from so_groupbox within w_des_item_master_rpt
integer x = 1737
integer width = 2350
integer height = 308
integer taborder = 50
integer weight = 700
long textcolor = 16711680
string text = "Filter"
end type

