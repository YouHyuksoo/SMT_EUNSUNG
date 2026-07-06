HA$PBExportHeader$w_des_model_select_from_sale_plan_pop.srw
$PBExportComments$$$HEX12$$74c7d9b33cbbd9b3d0c51cc1a8ba78b320c1ddd01dd3c5c5$$ENDHEX$$
forward
global type w_des_model_select_from_sale_plan_pop from w_popup_root
end type
type cb_retrieve from commandbutton within w_des_model_select_from_sale_plan_pop
end type
type cb_select from commandbutton within w_des_model_select_from_sale_plan_pop
end type
type st_yyyymm from so_statictext within w_des_model_select_from_sale_plan_pop
end type
type uo_dateset from uo_ymd_calendar within w_des_model_select_from_sale_plan_pop
end type
type uo_dateend from uo_ymd_calendar within w_des_model_select_from_sale_plan_pop
end type
type ddlb_model_name from uo_set_model_name_ddlb within w_des_model_select_from_sale_plan_pop
end type
type st_4 from so_statictext within w_des_model_select_from_sale_plan_pop
end type
type ddlb_line_code from uo_line_code within w_des_model_select_from_sale_plan_pop
end type
type st_2 from so_statictext within w_des_model_select_from_sale_plan_pop
end type
type gb_3 from groupbox within w_des_model_select_from_sale_plan_pop
end type
type gb_2 from groupbox within w_des_model_select_from_sale_plan_pop
end type
type gb_1 from groupbox within w_des_model_select_from_sale_plan_pop
end type
end forward

global type w_des_model_select_from_sale_plan_pop from w_popup_root
integer width = 3621
integer height = 2164
cb_retrieve cb_retrieve
cb_select cb_select
st_yyyymm st_yyyymm
uo_dateset uo_dateset
uo_dateend uo_dateend
ddlb_model_name ddlb_model_name
st_4 st_4
ddlb_line_code ddlb_line_code
st_2 st_2
gb_3 gb_3
gb_2 gb_2
gb_1 gb_1
end type
global w_des_model_select_from_sale_plan_pop w_des_model_select_from_sale_plan_pop

on w_des_model_select_from_sale_plan_pop.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.cb_select=create cb_select
this.st_yyyymm=create st_yyyymm
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.ddlb_model_name=create ddlb_model_name
this.st_4=create st_4
this.ddlb_line_code=create ddlb_line_code
this.st_2=create st_2
this.gb_3=create gb_3
this.gb_2=create gb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.cb_select
this.Control[iCurrent+3]=this.st_yyyymm
this.Control[iCurrent+4]=this.uo_dateset
this.Control[iCurrent+5]=this.uo_dateend
this.Control[iCurrent+6]=this.ddlb_model_name
this.Control[iCurrent+7]=this.st_4
this.Control[iCurrent+8]=this.ddlb_line_code
this.Control[iCurrent+9]=this.st_2
this.Control[iCurrent+10]=this.gb_3
this.Control[iCurrent+11]=this.gb_2
this.Control[iCurrent+12]=this.gb_1
end on

on w_des_model_select_from_sale_plan_pop.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.cb_select)
destroy(this.st_yyyymm)
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.ddlb_model_name)
destroy(this.st_4)
destroy(this.ddlb_line_code)
destroy(this.st_2)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.gb_1)
end on

event open;call super::open;dw_1.settransobject(sqlca)
CB_RETRIEVE.TRIGGEREVENT(CLICKED!)

end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
	
end if
end event

type p_title from w_popup_root`p_title within w_des_model_select_from_sale_plan_pop
integer width = 3611
end type

type cb_sort from w_popup_root`cb_sort within w_des_model_select_from_sale_plan_pop
boolean visible = true
integer x = 2446
integer y = 296
integer height = 156
end type

type cb_close from w_popup_root`cb_close within w_des_model_select_from_sale_plan_pop
boolean visible = true
integer x = 3282
integer y = 296
integer height = 156
end type

type st_msg from w_popup_root`st_msg within w_des_model_select_from_sale_plan_pop
boolean visible = true
integer y = 504
integer width = 3598
end type

type dw_1 from w_popup_root`dw_1 within w_des_model_select_from_sale_plan_pop
boolean visible = true
integer y = 600
integer width = 3598
integer height = 1484
boolean titlebar = true
string title = "Sale Plan List"
string dataobject = "d_pln_delivery_plan_popup"
end type

type dw_2 from w_popup_root`dw_2 within w_des_model_select_from_sale_plan_pop
boolean visible = true
integer y = 600
end type

type dw_3 from w_popup_root`dw_3 within w_des_model_select_from_sale_plan_pop
integer y = 612
end type

type cb_retrieve from commandbutton within w_des_model_select_from_sale_plan_pop
integer x = 2725
integer y = 296
integer width = 274
integer height = 156
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Retrieve"
end type

event clicked;DW_1.RETRIEVE(   uo_dateset.text() , uo_dateend.text() ,      ddlb_line_code.getcode()+'%' , ddlb_model_name.getcode()+'%' ,   GVI_ORGANIZATION_ID  )
end event

type cb_select from commandbutton within w_des_model_select_from_sale_plan_pop
integer x = 3003
integer y = 296
integer width = 274
integer height = 156
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Select"
boolean default = true
end type

event clicked;LONG    I , LVL_ROW
STRING  LVS_MODEL , LVS_SUFFIX , LVS_CHECK_YN , LVS_ITEM_CODE
DATETIME    LVD_PLAN_DATE
DATAWINDOW    PARM_DW
DECIMAL LVF_ORDER_QTY

PARM_DW = Message.PowerObjectParm

IF DW_1.GETROW() < 1 THEN RETURN 
DO
	I++
	
	LVS_CHECK_YN = DW_1.GETITEMSTRING( I , 'CHECK_YN' )
	
	IF LVS_CHECK_YN = 'Y' THEN
	
	     LVS_MODEL = '' ;LVS_SUFFIX ='' ;LVS_ITEM_CODE =''
		
		LVS_ITEM_CODE= DW_1.GETITEMSTRING( I , 'ITEM_CODE' )
		LVF_ORDER_QTY    = DW_1.GETITEMDECIMAL( I , 'PLAN_QTY' )
		LVD_PLAN_DATE    = DW_1.GETITEMDATETIME( I , 'PLAN_DATE' )
		LVL_ROW = PARM_DW.INSERTROW(0)
     	PARM_DW.SETITEM( LVL_ROW , 'ITEM_CODE' , LVS_ITEM_CODE )	
		PARM_DW.SETITEM( LVL_ROW , 'APPLY_YN' , 'N' )	
      
		PARM_DW.SETITEM( LVL_ROW, 'requirment_plan_date' , F_T_SYSDATE() )	
		PARM_DW.SETITEM( LVL_ROW, 'requirment_plan_seq' , f_get_requirment_plan_seq() )				
		PARM_DW.SETITEM( LVL_ROW, 'plan_date' , LVD_PLAN_DATE )				
		PARM_DW.SETITEM( LVL_ROW, 'order_qty' , LVF_ORDER_QTY )						
		
         F_SET_SECURITY_ROW(PARM_DW , LVL_ROW , 'ALL')		
		
	END IF
	
LOOP UNTIL I = DW_1.ROWCOUNT()

CLOSE(PARENT)


end event

type st_yyyymm from so_statictext within w_des_model_select_from_sale_plan_pop
integer x = 123
integer y = 280
integer width = 603
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Plan Date"
end type

type uo_dateset from uo_ymd_calendar within w_des_model_select_from_sale_plan_pop
event destroy ( )
integer x = 27
integer y = 364
integer taborder = 80
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_des_model_select_from_sale_plan_pop
event destroy ( )
integer x = 434
integer y = 364
integer taborder = 90
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type ddlb_model_name from uo_set_model_name_ddlb within w_des_model_select_from_sale_plan_pop
integer x = 864
integer y = 364
integer width = 887
integer height = 1936
integer taborder = 100
boolean bringtotop = true
end type

type st_4 from so_statictext within w_des_model_select_from_sale_plan_pop
integer x = 859
integer y = 280
integer width = 887
integer height = 68
boolean bringtotop = true
string text = "Model Name"
end type

type ddlb_line_code from uo_line_code within w_des_model_select_from_sale_plan_pop
integer x = 1760
integer y = 368
integer width = 462
integer taborder = 80
boolean bringtotop = true
end type

type st_2 from so_statictext within w_des_model_select_from_sale_plan_pop
integer x = 1760
integer y = 280
integer width = 462
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Line Code"
end type

type gb_3 from groupbox within w_des_model_select_from_sale_plan_pop
integer y = 524
integer width = 480
integer height = 256
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Select/Release"
end type

type gb_2 from groupbox within w_des_model_select_from_sale_plan_pop
integer x = 2418
integer y = 216
integer width = 1161
integer height = 272
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Process"
end type

type gb_1 from groupbox within w_des_model_select_from_sale_plan_pop
integer x = 5
integer y = 216
integer width = 2281
integer height = 272
integer taborder = 10
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

