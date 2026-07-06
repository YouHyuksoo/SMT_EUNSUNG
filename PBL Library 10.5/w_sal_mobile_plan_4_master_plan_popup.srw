HA$PBExportHeader$w_sal_mobile_plan_4_master_plan_popup.srw
$PBExportComments$$$HEX10$$f9b2d4c6c4ac8dd61cc888bc20c1ddd01dd3c5c5$$ENDHEX$$
forward
global type w_sal_mobile_plan_4_master_plan_popup from w_popup_root
end type
type cb_retrieve from so_commandbutton within w_sal_mobile_plan_4_master_plan_popup
end type
type cb_select from so_commandbutton within w_sal_mobile_plan_4_master_plan_popup
end type
type st_3 from so_statictext within w_sal_mobile_plan_4_master_plan_popup
end type
type st_2 from statictext within w_sal_mobile_plan_4_master_plan_popup
end type
type ddlb_customer_code from uo_customer_code within w_sal_mobile_plan_4_master_plan_popup
end type
type uo_set_item from uo_set_item_code within w_sal_mobile_plan_4_master_plan_popup
end type
type cbx_auto_set_mfs from so_checkbox within w_sal_mobile_plan_4_master_plan_popup
end type
type ddlb_line_code from uo_line_code within w_sal_mobile_plan_4_master_plan_popup
end type
type st_1 from statictext within w_sal_mobile_plan_4_master_plan_popup
end type
type st_4 from so_statictext within w_sal_mobile_plan_4_master_plan_popup
end type
type uo_dateset from uo_ymd_calendar within w_sal_mobile_plan_4_master_plan_popup
end type
type uo_dateend from uo_ymd_calendar within w_sal_mobile_plan_4_master_plan_popup
end type
type rb_2 from so_radiobutton within w_sal_mobile_plan_4_master_plan_popup
end type
type rb_3 from so_radiobutton within w_sal_mobile_plan_4_master_plan_popup
end type
type rb_4 from so_radiobutton within w_sal_mobile_plan_4_master_plan_popup
end type
type rb_5 from so_radiobutton within w_sal_mobile_plan_4_master_plan_popup
end type
type rb_1 from so_radiobutton within w_sal_mobile_plan_4_master_plan_popup
end type
type rb_6 from so_radiobutton within w_sal_mobile_plan_4_master_plan_popup
end type
type rb_7 from so_radiobutton within w_sal_mobile_plan_4_master_plan_popup
end type
type rb_8 from so_radiobutton within w_sal_mobile_plan_4_master_plan_popup
end type
type rb_9 from so_radiobutton within w_sal_mobile_plan_4_master_plan_popup
end type
type gb_1 from so_groupbox within w_sal_mobile_plan_4_master_plan_popup
end type
type gb_2 from so_groupbox within w_sal_mobile_plan_4_master_plan_popup
end type
type gb_3 from so_groupbox within w_sal_mobile_plan_4_master_plan_popup
end type
type gb_4 from so_groupbox within w_sal_mobile_plan_4_master_plan_popup
end type
end forward

global type w_sal_mobile_plan_4_master_plan_popup from w_popup_root
integer width = 4210
integer height = 2508
string title = "Mobile Plan Popup"
boolean contexthelp = false
cb_retrieve cb_retrieve
cb_select cb_select
st_3 st_3
st_2 st_2
ddlb_customer_code ddlb_customer_code
uo_set_item uo_set_item
cbx_auto_set_mfs cbx_auto_set_mfs
ddlb_line_code ddlb_line_code
st_1 st_1
st_4 st_4
uo_dateset uo_dateset
uo_dateend uo_dateend
rb_2 rb_2
rb_3 rb_3
rb_4 rb_4
rb_5 rb_5
rb_1 rb_1
rb_6 rb_6
rb_7 rb_7
rb_8 rb_8
rb_9 rb_9
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
end type
global w_sal_mobile_plan_4_master_plan_popup w_sal_mobile_plan_4_master_plan_popup

on w_sal_mobile_plan_4_master_plan_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.cb_select=create cb_select
this.st_3=create st_3
this.st_2=create st_2
this.ddlb_customer_code=create ddlb_customer_code
this.uo_set_item=create uo_set_item
this.cbx_auto_set_mfs=create cbx_auto_set_mfs
this.ddlb_line_code=create ddlb_line_code
this.st_1=create st_1
this.st_4=create st_4
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.rb_2=create rb_2
this.rb_3=create rb_3
this.rb_4=create rb_4
this.rb_5=create rb_5
this.rb_1=create rb_1
this.rb_6=create rb_6
this.rb_7=create rb_7
this.rb_8=create rb_8
this.rb_9=create rb_9
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.cb_select
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.ddlb_customer_code
this.Control[iCurrent+6]=this.uo_set_item
this.Control[iCurrent+7]=this.cbx_auto_set_mfs
this.Control[iCurrent+8]=this.ddlb_line_code
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.st_4
this.Control[iCurrent+11]=this.uo_dateset
this.Control[iCurrent+12]=this.uo_dateend
this.Control[iCurrent+13]=this.rb_2
this.Control[iCurrent+14]=this.rb_3
this.Control[iCurrent+15]=this.rb_4
this.Control[iCurrent+16]=this.rb_5
this.Control[iCurrent+17]=this.rb_1
this.Control[iCurrent+18]=this.rb_6
this.Control[iCurrent+19]=this.rb_7
this.Control[iCurrent+20]=this.rb_8
this.Control[iCurrent+21]=this.rb_9
this.Control[iCurrent+22]=this.gb_1
this.Control[iCurrent+23]=this.gb_2
this.Control[iCurrent+24]=this.gb_3
this.Control[iCurrent+25]=this.gb_4
end on

on w_sal_mobile_plan_4_master_plan_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.cb_select)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.ddlb_customer_code)
destroy(this.uo_set_item)
destroy(this.cbx_auto_set_mfs)
destroy(this.ddlb_line_code)
destroy(this.st_1)
destroy(this.st_4)
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.rb_5)
destroy(this.rb_1)
destroy(this.rb_6)
destroy(this.rb_7)
destroy(this.rb_8)
destroy(this.rb_9)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
end on

event open;call super::open;dw_1.settransobject(sqlca)
ddlb_line_code.text =message.stringparm
cb_retrieve.triggerevent(CLICKED!)
IVS_MOUSEMOVE_YN = 'N'
end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
	
end if
end event

type p_title from w_popup_root`p_title within w_sal_mobile_plan_4_master_plan_popup
integer width = 4210
end type

type cb_sort from w_popup_root`cb_sort within w_sal_mobile_plan_4_master_plan_popup
boolean visible = true
integer x = 2706
integer y = 356
integer height = 164
integer taborder = 30
end type

type cb_close from w_popup_root`cb_close within w_sal_mobile_plan_4_master_plan_popup
boolean visible = true
integer x = 3543
integer y = 356
integer height = 164
end type

type st_msg from w_popup_root`st_msg within w_sal_mobile_plan_4_master_plan_popup
boolean visible = true
integer x = 5
integer y = 716
integer width = 4210
end type

type dw_1 from w_popup_root`dw_1 within w_sal_mobile_plan_4_master_plan_popup
boolean visible = true
integer y = 804
integer width = 4210
integer height = 1616
integer taborder = 100
boolean titlebar = true
string title = "Mobile Plan List"
string dataobject = "d_pln_mobilization_4_master_plan_lst_popup"
end type

type dw_2 from w_popup_root`dw_2 within w_sal_mobile_plan_4_master_plan_popup
boolean visible = true
integer y = 804
integer taborder = 110
end type

type dw_3 from w_popup_root`dw_3 within w_sal_mobile_plan_4_master_plan_popup
integer x = 5
integer y = 804
integer taborder = 120
end type

type cb_retrieve from so_commandbutton within w_sal_mobile_plan_4_master_plan_popup
integer x = 2985
integer y = 356
integer width = 274
integer height = 164
integer taborder = 80
boolean bringtotop = true
string text = "Retrieve"
end type

event clicked;SETPOINTER(HOURGLASS!)

//if ddlb_line_code.getcode() = '%' or isnull(ddlb_line_code.getcode()) or  ddlb_line_code.getcode() = '' then 
//	f_msgbox1(102 , 'Line Code')
//	return
//end if

dw_1.retrieve( uo_dateset.text() , uo_dateend.text() ,uo_set_item.text()+'%',ddlb_customer_code.text+'%' , ddlb_line_code.getcode( )+'%', gvi_organization_id)
dw_1.setfocus()
end event

type cb_select from so_commandbutton within w_sal_mobile_plan_4_master_plan_popup
integer x = 3264
integer y = 356
integer width = 274
integer height = 164
integer taborder = 90
boolean bringtotop = true
string text = "Select"
boolean default = true
end type

event clicked;if f_object_role_check() = false then return 

Long i , j
String lvs_rowid , lvs_mfs , lvs_workstage_code , lvs_machine_code , lvs_auto_mfs

MSG = F_MSGBOX1( 1161 , THIS.TEXT )
IF MSG = 1 THEN 
ELSE
	RETURN
END IF

DO
  I++
		if dw_1.object.check_yn[i] = 'Y'  then
		
		else
			continue
		end if

lvs_rowid = dw_1.object.rowid[i]

//===============================================
// $$HEX5$$1cc888bc200094cd9ccd$$ENDHEX$$
//===============================================

if cbx_auto_set_mfs.checked = true then
	lvs_auto_mfs = 'Y'
else	
	lvs_auto_mfs = 'N'	
end if 


if cbx_auto_set_mfs.checked = true then 
	
	lvs_mfs =  f_get_any_no( 'MFS' )
	
	if lvs_mfs = '' or isnull(lvs_mfs) then 
		
		Messagebox("Notify" , "MFS Extract Error" )
		Return
	end if
end if

 //===============================================
	INSERT INTO ip_product_master_plan
					( plan_yyyymm,
					  plan_date,
					  plan_date_sequence,
					  mfs,
					  plan_priority,
					  plan_time,
					  organization_id,
					  item_code,
				        product_line_type,		  
					  order_qty,
					  product_actual_qty,
					  line_code,
					  workstage_code,
					  machine_code,
					  shipping_account,
					  work_division,
					  customer_code,
					  customer_order_no,
					  delivery_date,
					  origin_mfs,
					  shift_code,
					  plan_transfer_yn,  
					  plan_status,
					  lot_divide_yn,
					  enter_date,
					  enter_by,
					  last_modify_date,
					  last_modify_by,
					  route_no , customer_order_no_origin
					)
		SELECT plan_yyyymm,
				 plan_date,
				 seq_plan_date_sequence.NEXTVAL,
				DECODE( :lvs_auto_mfs , 'Y' , :lvs_mfs , mfs )  ,
				 plan_priority, //plan_priority,
				 0,
				 :gvi_organization_id,
				 item_code,
				 product_line_type,		  			 
				 order_qty,
				 0,
				 nvl(line_code,'*') ,
				 workstage_code,
				 machine_code,
				 shipping_account,
				 work_division,
				 customer_code,
				 customer_order_no,
				 delivery_date,
				 decode( :lvs_auto_mfs , 'Y' , :lvs_mfs, mfs )  , 
				 1,
				 'N',
				 'W',
				 'N' ,
				 SYSDATE,
				 :gvs_user_id,
				 SYSDATE,
				 :gvs_user_id ,
				 f_get_plan_route_no( item_code , organization_id ) route_no , customer_order_no_origin
		  FROM ip_product_mobilization
		 WHERE rowid = :lvs_rowid ;

	    if f_sql_check() < 0 then return 
	
		update ip_product_mobilization
		 set      plan_transfer_yn = 'Y' , plan_transfer_date = trunc(sysdate)
		where  rowid = :lvs_rowid ;
		
		if f_sql_check() < 0 then return 
 j++
loop until i = dw_1.rowcount( )

msg = f_msgbox1(9014, string(j))
if msg = 1 then 
	commit  ; 
	f_msg_mdi_help(f_msg_st(170))
	close(parent)
//	f_retrieve()
else
	rollback ; 
	f_msg_mdi_help(f_msg_st(9026))
end if 
	

 
end event

type st_3 from so_statictext within w_sal_mobile_plan_4_master_plan_popup
integer x = 864
integer y = 316
integer width = 512
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type st_2 from statictext within w_sal_mobile_plan_4_master_plan_popup
integer x = 1728
integer y = 312
integer width = 457
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

type ddlb_customer_code from uo_customer_code within w_sal_mobile_plan_4_master_plan_popup
integer x = 1719
integer y = 388
integer taborder = 40
boolean bringtotop = true
end type

type uo_set_item from uo_set_item_code within w_sal_mobile_plan_4_master_plan_popup
event destroy ( )
integer x = 855
integer y = 388
integer width = 859
integer height = 84
integer taborder = 70
boolean bringtotop = true
end type

on uo_set_item.destroy
call uo_set_item_code::destroy
end on

type cbx_auto_set_mfs from so_checkbox within w_sal_mobile_plan_4_master_plan_popup
integer x = 2715
integer y = 280
integer width = 539
integer height = 64
boolean bringtotop = true
integer weight = 700
long textcolor = 255
boolean enabled = false
string text = "Auto Set MFS"
boolean checked = true
end type

event constructor;call super::constructor;if Gvs_mfs_auto_set = 'Y' then
	this.checked = true 
else
	this.checked = false
end if
end event

type ddlb_line_code from uo_line_code within w_sal_mobile_plan_4_master_plan_popup
integer x = 2181
integer y = 388
integer width = 457
boolean bringtotop = true
end type

type st_1 from statictext within w_sal_mobile_plan_4_master_plan_popup
integer x = 2181
integer y = 308
integer width = 457
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Line Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_4 from so_statictext within w_sal_mobile_plan_4_master_plan_popup
integer x = 41
integer y = 316
integer width = 795
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Delivery Date"
end type

type uo_dateset from uo_ymd_calendar within w_sal_mobile_plan_4_master_plan_popup
integer x = 27
integer y = 388
integer height = 84
integer taborder = 50
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_sal_mobile_plan_4_master_plan_popup
integer x = 439
integer y = 388
integer height = 84
integer taborder = 60
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type rb_2 from so_radiobutton within w_sal_mobile_plan_4_master_plan_popup
integer x = 562
integer y = 596
integer width = 297
boolean bringtotop = true
integer weight = 700
string text = "Today"
end type

event clicked;call super::clicked;uo_dateend.settext( string(f_t_sysdate()) )
cb_retrieve.triggerevent( clicked!)
end event

type rb_3 from so_radiobutton within w_sal_mobile_plan_4_master_plan_popup
integer x = 855
integer y = 596
integer width = 512
boolean bringtotop = true
integer weight = 700
string text = "Today + 1 Week"
end type

event clicked;call super::clicked;uo_dateset.settext( string(f_t_sysdate()) )
uo_dateend.settext( string(f_v_sysdate(-7)) )
cb_retrieve.triggerevent( clicked!)
end event

type rb_4 from so_radiobutton within w_sal_mobile_plan_4_master_plan_popup
integer x = 1417
integer y = 596
integer width = 512
boolean bringtotop = true
integer weight = 700
string text = "Today + 2 Week"
end type

event clicked;call super::clicked;uo_dateset.settext( string(f_t_sysdate()) )
uo_dateend.settext( string(f_v_sysdate(-14)) )
cb_retrieve.triggerevent( clicked!)
end event

type rb_5 from so_radiobutton within w_sal_mobile_plan_4_master_plan_popup
integer x = 1957
integer y = 596
integer width = 512
boolean bringtotop = true
integer weight = 700
string text = "Today + 4 Week"
end type

event clicked;call super::clicked;uo_dateset.settext( string(f_t_sysdate()) )
uo_dateend.settext( string(f_v_sysdate(-28)) )
cb_retrieve.triggerevent( clicked!)
end event

type rb_1 from so_radiobutton within w_sal_mobile_plan_4_master_plan_popup
integer x = 2533
integer y = 600
integer width = 274
boolean bringtotop = true
integer weight = 700
string text = "All"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.setfilter( '')
dw_1.filter( )
end event

type rb_6 from so_radiobutton within w_sal_mobile_plan_4_master_plan_popup
integer x = 2825
integer y = 600
integer width = 393
boolean bringtotop = true
integer weight = 700
string text = "Product"
end type

event clicked;call super::clicked;dw_1.setfilter("work_division = '"+"P"+"'")
dw_1.filter( )
end event

type rb_7 from so_radiobutton within w_sal_mobile_plan_4_master_plan_popup
integer x = 3223
integer y = 600
integer width = 315
boolean bringtotop = true
integer weight = 700
string text = "Work"
end type

event clicked;call super::clicked;dw_1.setfilter("work_division = '"+"W"+"'")
dw_1.filter( )
end event

type rb_8 from so_radiobutton within w_sal_mobile_plan_4_master_plan_popup
integer x = 3570
integer y = 600
integer width = 270
boolean bringtotop = true
integer weight = 700
string text = "Repair"
end type

event clicked;call super::clicked;dw_1.setfilter("work_division = '"+"R"+"'")
dw_1.filter( )
end event

type rb_9 from so_radiobutton within w_sal_mobile_plan_4_master_plan_popup
integer x = 27
integer y = 600
integer width = 512
boolean bringtotop = true
integer weight = 700
string text = "Today - 4 Week"
end type

event clicked;call super::clicked;uo_dateset.settext( string(f_v_sysdate(+28)) )
uo_dateend.settext( string(f_t_sysdate()) )
cb_retrieve.triggerevent( clicked!)
end event

type gb_1 from so_groupbox within w_sal_mobile_plan_4_master_plan_popup
integer x = 2501
integer y = 548
integer width = 1358
integer height = 152
integer taborder = 60
integer weight = 700
long textcolor = 16711680
string text = "Work Division"
end type

type gb_2 from so_groupbox within w_sal_mobile_plan_4_master_plan_popup
integer x = 5
integer y = 220
integer width = 2656
integer height = 328
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_sal_mobile_plan_4_master_plan_popup
integer x = 5
integer y = 552
integer width = 2478
integer height = 148
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Date Filter"
end type

type gb_4 from so_groupbox within w_sal_mobile_plan_4_master_plan_popup
integer x = 2674
integer y = 212
integer width = 1189
integer height = 328
integer taborder = 70
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

