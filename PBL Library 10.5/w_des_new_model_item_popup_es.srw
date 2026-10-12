HA$PBExportHeader$w_des_new_model_item_popup_es.srw
$PBExportComments$(Item Query)-$$HEX3$$a8ba78b32000$$ENDHEX$$item $$HEX2$$70c88cd6$$ENDHEX$$
forward
global type w_des_new_model_item_popup_es from w_popup_root
end type
type cbx_product_class from so_checkbox within w_des_new_model_item_popup_es
end type
type cbx_raw_material from so_checkbox within w_des_new_model_item_popup_es
end type
type cbx_3 from so_checkbox within w_des_new_model_item_popup_es
end type
type cbx_4 from so_checkbox within w_des_new_model_item_popup_es
end type
type cbx_user_define from so_checkbox within w_des_new_model_item_popup_es
end type
type em_serial from editmask within w_des_new_model_item_popup_es
end type
type sle_user_define from so_singlelineedit within w_des_new_model_item_popup_es
end type
type sle_item_code from so_singlelineedit within w_des_new_model_item_popup_es
end type
type st_1 from so_statictext within w_des_new_model_item_popup_es
end type
type cb_add from so_commandbutton within w_des_new_model_item_popup_es
end type
type cb_exit from so_commandbutton within w_des_new_model_item_popup_es
end type
type cb_save from so_commandbutton within w_des_new_model_item_popup_es
end type
type st_2 from statictext within w_des_new_model_item_popup_es
end type
type cbx_1 from so_checkbox within w_des_new_model_item_popup_es
end type
type ddlb_item_1level from uo_basecode within w_des_new_model_item_popup_es
end type
type ddlb_item_2level from uo_basecode within w_des_new_model_item_popup_es
end type
type ddlb_item_3level from uo_basecode within w_des_new_model_item_popup_es
end type
type ddlb_item_4level from uo_basecode within w_des_new_model_item_popup_es
end type
type cbx_2 from so_checkbox within w_des_new_model_item_popup_es
end type
type ddlb_item_5level from uo_basecode within w_des_new_model_item_popup_es
end type
type st_3 from statictext within w_des_new_model_item_popup_es
end type
type st_4 from statictext within w_des_new_model_item_popup_es
end type
type st_5 from statictext within w_des_new_model_item_popup_es
end type
type st_6 from statictext within w_des_new_model_item_popup_es
end type
type ddlb_item_type from dropdownlistbox within w_des_new_model_item_popup_es
end type
type sle_part_no from so_singlelineedit within w_des_new_model_item_popup_es
end type
type sle_item_spec from so_singlelineedit within w_des_new_model_item_popup_es
end type
type sle_item_name from so_singlelineedit within w_des_new_model_item_popup_es
end type
type st_7 from statictext within w_des_new_model_item_popup_es
end type
type ddlb_customer_code from uo_customer_code_name within w_des_new_model_item_popup_es
end type
type gb_1 from so_groupbox within w_des_new_model_item_popup_es
end type
type gb_2 from so_groupbox within w_des_new_model_item_popup_es
end type
type gb_3 from so_groupbox within w_des_new_model_item_popup_es
end type
type gb_4 from so_groupbox within w_des_new_model_item_popup_es
end type
type gb_5 from so_groupbox within w_des_new_model_item_popup_es
end type
type gb_6 from so_groupbox within w_des_new_model_item_popup_es
end type
type gb_7 from so_groupbox within w_des_new_model_item_popup_es
end type
type gb_8 from so_groupbox within w_des_new_model_item_popup_es
end type
type gb_11 from so_groupbox within w_des_new_model_item_popup_es
end type
end forward

global type w_des_new_model_item_popup_es from w_popup_root
integer width = 2889
integer height = 2672
string title = "$$HEX9$$a8ba78b354cfdcb4200090c7d9b344cc88bc$$ENDHEX$$"
cbx_product_class cbx_product_class
cbx_raw_material cbx_raw_material
cbx_3 cbx_3
cbx_4 cbx_4
cbx_user_define cbx_user_define
em_serial em_serial
sle_user_define sle_user_define
sle_item_code sle_item_code
st_1 st_1
cb_add cb_add
cb_exit cb_exit
cb_save cb_save
st_2 st_2
cbx_1 cbx_1
ddlb_item_1level ddlb_item_1level
ddlb_item_2level ddlb_item_2level
ddlb_item_3level ddlb_item_3level
ddlb_item_4level ddlb_item_4level
cbx_2 cbx_2
ddlb_item_5level ddlb_item_5level
st_3 st_3
st_4 st_4
st_5 st_5
st_6 st_6
ddlb_item_type ddlb_item_type
sle_part_no sle_part_no
sle_item_spec sle_item_spec
sle_item_name sle_item_name
st_7 st_7
ddlb_customer_code ddlb_customer_code
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
gb_5 gb_5
gb_6 gb_6
gb_7 gb_7
gb_8 gb_8
gb_11 gb_11
end type
global w_des_new_model_item_popup_es w_des_new_model_item_popup_es

on w_des_new_model_item_popup_es.create
int iCurrent
call super::create
this.cbx_product_class=create cbx_product_class
this.cbx_raw_material=create cbx_raw_material
this.cbx_3=create cbx_3
this.cbx_4=create cbx_4
this.cbx_user_define=create cbx_user_define
this.em_serial=create em_serial
this.sle_user_define=create sle_user_define
this.sle_item_code=create sle_item_code
this.st_1=create st_1
this.cb_add=create cb_add
this.cb_exit=create cb_exit
this.cb_save=create cb_save
this.st_2=create st_2
this.cbx_1=create cbx_1
this.ddlb_item_1level=create ddlb_item_1level
this.ddlb_item_2level=create ddlb_item_2level
this.ddlb_item_3level=create ddlb_item_3level
this.ddlb_item_4level=create ddlb_item_4level
this.cbx_2=create cbx_2
this.ddlb_item_5level=create ddlb_item_5level
this.st_3=create st_3
this.st_4=create st_4
this.st_5=create st_5
this.st_6=create st_6
this.ddlb_item_type=create ddlb_item_type
this.sle_part_no=create sle_part_no
this.sle_item_spec=create sle_item_spec
this.sle_item_name=create sle_item_name
this.st_7=create st_7
this.ddlb_customer_code=create ddlb_customer_code
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
this.gb_5=create gb_5
this.gb_6=create gb_6
this.gb_7=create gb_7
this.gb_8=create gb_8
this.gb_11=create gb_11
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_product_class
this.Control[iCurrent+2]=this.cbx_raw_material
this.Control[iCurrent+3]=this.cbx_3
this.Control[iCurrent+4]=this.cbx_4
this.Control[iCurrent+5]=this.cbx_user_define
this.Control[iCurrent+6]=this.em_serial
this.Control[iCurrent+7]=this.sle_user_define
this.Control[iCurrent+8]=this.sle_item_code
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.cb_add
this.Control[iCurrent+11]=this.cb_exit
this.Control[iCurrent+12]=this.cb_save
this.Control[iCurrent+13]=this.st_2
this.Control[iCurrent+14]=this.cbx_1
this.Control[iCurrent+15]=this.ddlb_item_1level
this.Control[iCurrent+16]=this.ddlb_item_2level
this.Control[iCurrent+17]=this.ddlb_item_3level
this.Control[iCurrent+18]=this.ddlb_item_4level
this.Control[iCurrent+19]=this.cbx_2
this.Control[iCurrent+20]=this.ddlb_item_5level
this.Control[iCurrent+21]=this.st_3
this.Control[iCurrent+22]=this.st_4
this.Control[iCurrent+23]=this.st_5
this.Control[iCurrent+24]=this.st_6
this.Control[iCurrent+25]=this.ddlb_item_type
this.Control[iCurrent+26]=this.sle_part_no
this.Control[iCurrent+27]=this.sle_item_spec
this.Control[iCurrent+28]=this.sle_item_name
this.Control[iCurrent+29]=this.st_7
this.Control[iCurrent+30]=this.ddlb_customer_code
this.Control[iCurrent+31]=this.gb_1
this.Control[iCurrent+32]=this.gb_2
this.Control[iCurrent+33]=this.gb_3
this.Control[iCurrent+34]=this.gb_4
this.Control[iCurrent+35]=this.gb_5
this.Control[iCurrent+36]=this.gb_6
this.Control[iCurrent+37]=this.gb_7
this.Control[iCurrent+38]=this.gb_8
this.Control[iCurrent+39]=this.gb_11
end on

on w_des_new_model_item_popup_es.destroy
call super::destroy
destroy(this.cbx_product_class)
destroy(this.cbx_raw_material)
destroy(this.cbx_3)
destroy(this.cbx_4)
destroy(this.cbx_user_define)
destroy(this.em_serial)
destroy(this.sle_user_define)
destroy(this.sle_item_code)
destroy(this.st_1)
destroy(this.cb_add)
destroy(this.cb_exit)
destroy(this.cb_save)
destroy(this.st_2)
destroy(this.cbx_1)
destroy(this.ddlb_item_1level)
destroy(this.ddlb_item_2level)
destroy(this.ddlb_item_3level)
destroy(this.ddlb_item_4level)
destroy(this.cbx_2)
destroy(this.ddlb_item_5level)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.st_6)
destroy(this.ddlb_item_type)
destroy(this.sle_part_no)
destroy(this.sle_item_spec)
destroy(this.sle_item_name)
destroy(this.st_7)
destroy(this.ddlb_customer_code)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
destroy(this.gb_5)
destroy(this.gb_6)
destroy(this.gb_7)
destroy(this.gb_8)
destroy(this.gb_11)
end on

event open;call super::open;
ddlb_item_1level.setfocus( )
end event

event resize;
//

	dw_1.resize(newwidth -100, newheight - dw_1.y - 50)	
end event

type p_title from w_popup_root`p_title within w_des_new_model_item_popup_es
integer width = 2880
end type

type cb_sort from w_popup_root`cb_sort within w_des_new_model_item_popup_es
integer x = 3269
integer y = 2468
integer taborder = 0
end type

type cb_close from w_popup_root`cb_close within w_des_new_model_item_popup_es
boolean visible = true
integer x = 3552
integer y = 2468
integer taborder = 0
end type

type st_msg from w_popup_root`st_msg within w_des_new_model_item_popup_es
boolean visible = true
integer y = 204
integer width = 2880
end type

type dw_1 from w_popup_root`dw_1 within w_des_new_model_item_popup_es
boolean visible = true
integer x = 55
integer y = 1724
integer width = 2779
integer height = 820
integer taborder = 0
string dataobject = "d_des_new_item_popup_es"
boolean resizable = true
end type

type dw_2 from w_popup_root`dw_2 within w_des_new_model_item_popup_es
integer x = 3291
integer y = 1936
integer taborder = 0
end type

type dw_3 from w_popup_root`dw_3 within w_des_new_model_item_popup_es
integer x = 3291
integer y = 1936
integer taborder = 0
end type

type cbx_product_class from so_checkbox within w_des_new_model_item_popup_es
integer x = 151
integer y = 544
boolean bringtotop = true
integer weight = 700
string text = "1$$HEX2$$08b8a8bc$$ENDHEX$$(1$$HEX2$$90c7acb9$$ENDHEX$$)"
boolean checked = true
end type

type cbx_raw_material from so_checkbox within w_des_new_model_item_popup_es
integer x = 1102
integer y = 544
boolean bringtotop = true
integer weight = 700
string text = "2$$HEX2$$08b8a8bc$$ENDHEX$$(2$$HEX2$$90c7acb9$$ENDHEX$$)"
boolean checked = true
end type

type cbx_3 from so_checkbox within w_des_new_model_item_popup_es
integer x = 2075
integer y = 540
boolean bringtotop = true
integer weight = 700
string text = "3$$HEX2$$08b8a8bc$$ENDHEX$$(1$$HEX2$$90c7acb9$$ENDHEX$$)"
boolean checked = true
end type

type cbx_4 from so_checkbox within w_des_new_model_item_popup_es
integer x = 146
integer y = 792
boolean bringtotop = true
integer weight = 700
string text = "4$$HEX2$$08b8a8bc$$ENDHEX$$(1$$HEX2$$90c7acb9$$ENDHEX$$)"
boolean checked = true
end type

type cbx_user_define from so_checkbox within w_des_new_model_item_popup_es
integer x = 1147
integer y = 1044
boolean bringtotop = true
integer weight = 700
string text = "$$HEX2$$24c1c0bc$$ENDHEX$$(1$$HEX2$$90c7acb9$$ENDHEX$$)"
boolean checked = true
end type

type em_serial from editmask within w_des_new_model_item_popup_es
integer x = 151
integer y = 1132
integer width = 658
integer height = 92
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "0000"
boolean spin = true
double increment = 1
string minmax = "1~~9999"
end type

type sle_user_define from so_singlelineedit within w_des_new_model_item_popup_es
integer x = 1102
integer y = 1140
integer width = 658
integer taborder = 50
boolean bringtotop = true
string text = "0"
textcase textcase = upper!
integer limit = 1
end type

type sle_item_code from so_singlelineedit within w_des_new_model_item_popup_es
integer x = 553
integer y = 380
integer width = 846
boolean bringtotop = true
textcase textcase = upper!
end type

type st_1 from so_statictext within w_des_new_model_item_popup_es
integer x = 101
integer y = 392
integer width = 439
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Model Code"
alignment alignment = right!
end type

type cb_add from so_commandbutton within w_des_new_model_item_popup_es
integer x = 1655
integer y = 372
integer width = 375
integer height = 100
integer taborder = 60
boolean bringtotop = true
string text = "$$HEX2$$44cc88bc$$ENDHEX$$"
end type

event clicked;call super::clicked;
string lvs_max_item_code, lvs_item_1level, lvs_item_2level, lvs_item_3level, lvs_item_4level,  lvs_item_5level, lvs_item_serial, lvs_user_define, lvs_item_code
long   lvl_count, lvl_item_serial

//===============================================
// $$HEX20$$88d4a9ba54cfdcb4200090c7d9b3ddc031c144c7200004c774d5200085c725b812ac200055d678c7$$ENDHEX$$
//===============================================

lvs_item_1level = ddlb_item_1level.getcode()
lvs_item_2level = ddlb_item_2level.getcode()
lvs_item_3level = ddlb_item_3level.getcode()
lvs_item_4level = ddlb_item_4level.getcode()
lvs_item_5level = ddlb_item_5level.getcode()

lvs_user_define = sle_user_define.text

IF ( lvs_item_1level = '%' or lvs_item_1level = '' or isnull(lvs_item_1level) ) THEN
	 st_msg.text = '$$HEX12$$88d4a9ba54cfdcb42000ddc031c144c7200004c774d52000$$ENDHEX$$1Level$$HEX9$$44c7200020c1ddd0200014bc8db7c8b2e4b2$$ENDHEX$$'
	 ddlb_item_1level.setfocus()
	 return
END IF

IF ( lvs_item_2level = '%' or lvs_item_2level = '' or isnull(lvs_item_2level) ) THEN
	st_msg.text = '$$HEX12$$88d4a9ba54cfdcb42000ddc031c144c7200004c774d52000$$ENDHEX$$2Level$$HEX9$$44c7200020c1ddd0200014bc8db7c8b2e4b2$$ENDHEX$$'
	 ddlb_item_2level.setfocus()
	 return
END IF

IF ( lvs_item_3level = '%' or lvs_item_3level = '' or isnull(lvs_item_3level) ) THEN
	 st_msg.text = '$$HEX12$$88d4a9ba54cfdcb42000ddc031c144c7200004c774d52000$$ENDHEX$$3Level$$HEX9$$44c7200020c1ddd0200014bc8db7c8b2e4b2$$ENDHEX$$'
	 ddlb_item_3level.setfocus()
	 return
END IF

IF ( lvs_item_4level = '%' or lvs_item_4level = '' or isnull(lvs_item_4level) ) THEN
	 st_msg.text = '$$HEX12$$88d4a9ba54cfdcb42000ddc031c144c7200004c774d52000$$ENDHEX$$4Level$$HEX9$$44c7200020c1ddd0200014bc8db7c8b2e4b2$$ENDHEX$$'
	 ddlb_item_4level.setfocus()
	 return
END IF

IF ( lvs_item_5level = '%' or lvs_item_5level = '' or isnull(lvs_item_5level) ) THEN
	 st_msg.text = '$$HEX12$$88d4a9ba54cfdcb42000ddc031c144c7200004c774d52000$$ENDHEX$$5Level$$HEX9$$44c7200020c1ddd0200014bc8db7c8b2e4b2$$ENDHEX$$'
	 ddlb_item_5level.setfocus()
	 return
END IF

//===============================================
// 1Level $$HEX3$$d0c51cc12000$$ENDHEX$$4Level $$HEX10$$4caec0c9200069d55cce200012ac3cc75cb82000$$ENDHEX$$Max $$HEX7$$58ce44c720006cad74d51cc12000$$ENDHEX$$+1 $$HEX6$$58d5ecc5200044cc88bc2000$$ENDHEX$$
//===============================================

lvl_count = 0
lvs_item_code = lvs_item_1level + lvs_item_2level + lvs_item_3level + lvs_item_4level + lvs_item_5level 

select max(substr(item_code, 1, 10)), nvl(sum(1), 0)
   into :lvs_max_item_code, :lvl_count
  from id_item_es
 where item_code like :lvs_item_code||'%'
    and organization_id = :GVI_ORGANIZATION_ID;
	 
IF F_SQL_CHECK() < 0 THEN 
	RETURN
END IF    

IF lvl_count = 0 THEN	
	lvl_item_serial = 1
ELSE
	
	lvs_item_serial = mid(lvs_max_item_code, 7, 4) // 0001 ~ 9999 $$HEX10$$1cc228cc01c83cc75cb8200044cc88bc5cd5e4b2$$ENDHEX$$
	
	IF  isnumber(lvs_item_serial)  THEN
          lvl_item_serial = long(lvs_item_serial) + 1		
	ELSE
	     st_msg.text = '$$HEX24$$dcc2acb9bcc5200012ac74c720002bc290c715d674c7200044c5ccb2200012ac74c7200074c8acc7200069d5c8b2e4b2$$ENDHEX$$'
	     return		 
	END IF
		
END IF 

em_serial.text =  string(lvl_item_serial, '0000')

//===============================================
// $$HEX8$$e0c2dcad200088d488bc200070c8bdb9$$ENDHEX$$
//===============================================

sle_item_code.text  = UPPER(lvs_item_code + em_serial.text + lvs_user_define)

DW_1.RESET()
DW_1.RETRIEVE( lvs_item_code,  GVI_ORGANIZATION_ID )

 sle_item_name.text = ''
 sle_item_spec.text   = ''
 sle_part_no.text      = ''
 st_msg.text            = ''
 
 ddlb_item_type.selectitem(0)
 ddlb_customer_code.selectitem(0)
 
sle_item_name.setfocus()				
				


end event

type cb_exit from so_commandbutton within w_des_new_model_item_popup_es
integer x = 2409
integer y = 372
integer width = 375
integer height = 100
boolean bringtotop = true
string text = "$$HEX2$$ebb230ae$$ENDHEX$$"
end type

event clicked;call super::clicked;Gst_return.gvb_return = false 
close( parent )
end event

type cb_save from so_commandbutton within w_des_new_model_item_popup_es
integer x = 2030
integer y = 372
integer width = 375
integer height = 100
integer taborder = 70
boolean bringtotop = true
string text = "$$HEX2$$00c8a5c7$$ENDHEX$$"
end type

event clicked;call super::clicked;
string lvs_item_code, lvs_item_name, lvs_item_spec, lvs_part_no, lvs_item_type, lvs_customer_code

 lvs_item_code         = sle_item_code.text
 lvs_item_name        = sle_item_name.text
 lvs_item_spec         = sle_item_spec.text
 lvs_part_no             = sle_part_no.text
 lvs_item_type          = mid(ddlb_item_type.text, 1, 1)
 lvs_customer_code  = mid(ddlb_customer_code.text, 1, 2)
 
 IF ( len(lvs_item_code) < 10 ) THEN
	 st_msg.text = '$$HEX22$$ddc031c1200060d52000a8ba78b358c7200088d4a9ba54cfdcb444c7200055d678c7200014bc8db7c8b2e4b2$$ENDHEX$$'
	 sle_item_code.setfocus()
	 return
END IF

 IF ( len(lvs_item_name) < 1 ) THEN
	 st_msg.text = '$$HEX20$$ddc031c1200060d52000a8ba78b358c7200088d485ba44c7200055d678c7200014bc8db7c8b2e4b2$$ENDHEX$$'
	 sle_item_name.setfocus()
	 return
END IF

 IF ( len(lvs_item_spec) < 1 ) THEN
	 st_msg.text = '$$HEX9$$ddc031c1200060d52000a8ba78b358c72000$$ENDHEX$$Spec$$HEX9$$44c7200055d678c7200014bc8db7c8b2e4b2$$ENDHEX$$'
	 sle_item_spec.setfocus()
	 return
END IF

// IF ( len(lvs_part_no) < 1 ) THEN
//	 st_msg.text = '$$HEX24$$ddc031c1200060d52000a8ba78b358c72000e0ac1dacacc0200088d488bc44c7200055d678c7200014bc8db7c8b2e4b2$$ENDHEX$$'
//	 sle_part_no.setfocus()
//	 return
//END IF

 IF ( len(lvs_item_type) < 1 or lvs_item_type = '%' ) THEN
	 st_msg.text = '$$HEX20$$ddc031c1200060d52000a8ba78b358c7200020c715d644c7200055d678c7200014bc8db7c8b2e4b2$$ENDHEX$$'
	 ddlb_item_type.setfocus()
	 return
END IF

 IF ( len(lvs_customer_code) < 2 ) THEN
	 st_msg.text = '$$HEX24$$ddc031c1200060d52000a8ba78b358c72000e0ac1dacacc0200054cfdcb47cb9200055d678c7200014bc8db7c8b2e4b2$$ENDHEX$$'
	 ddlb_customer_code.setfocus()
	 return
END IF

 INSERT INTO ID_ITEM_ES  
					( 
					   item_code, 
                         item_name, 
                         es_item_type, 
                         customer_code, 
                         part_no, 
                         item_spec, 
                         enter_date, 
                         enter_by, 
                         last_modify_date, 
                         last_modify_by, 
                         organization_id
                     )  
		  VALUES ( 
		                 :lvs_item_code,
					   :lvs_item_name,
					   :lvs_item_type,
					   :lvs_customer_code,
					   :lvs_part_no,
					   :lvs_item_spec,	
		                 sysdate,
					   :gvs_user_id,
                          sysdate,
					   :gvs_user_id,					
		                :gvi_organization_id
					 )  ;
	
IF F_SQL_CHECK_WITH_MSG("INSERT INTO ID_ITEM_ES ($$HEX2$$1cc888d4$$ENDHEX$$)") < 0 THEN RETURN 0
		
COMMIT;


st_msg.text = sle_item_code.text + ' $$HEX10$$74c72000f1b45db8200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$'
sle_item_code.text = '' 

end event

type st_2 from statictext within w_des_new_model_item_popup_es
integer x = 3790
integer y = 1596
integer width = 411
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
string text = "2 Digit"
alignment alignment = center!
boolean focusrectangle = false
end type

type cbx_1 from so_checkbox within w_des_new_model_item_popup_es
integer x = 155
integer y = 1044
integer width = 462
boolean bringtotop = true
integer weight = 700
string text = "$$HEX4$$f1b45db888bc38d6$$ENDHEX$$(4$$HEX2$$90c7acb9$$ENDHEX$$)"
boolean checked = true
end type

type ddlb_item_1level from uo_basecode within w_des_new_model_item_popup_es
integer x = 151
integer y = 640
integer width = 658
integer height = 1352
integer taborder = 70
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;
redraw('MODEL 1LEVEL')
end event

event selectionchanged;call super::selectionchanged;
ddlb_item_2level.setfocus( )
end event

type ddlb_item_2level from uo_basecode within w_des_new_model_item_popup_es
integer x = 1102
integer y = 640
integer width = 658
integer height = 1352
integer taborder = 30
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

event selectionchanged;call super::selectionchanged;
ddlb_item_3level.setfocus( )
end event

event constructor;call super::constructor;
redraw('MODEL 2LEVEL')
end event

type ddlb_item_3level from uo_basecode within w_des_new_model_item_popup_es
integer x = 2062
integer y = 640
integer width = 658
integer height = 1352
integer taborder = 80
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

event selectionchanged;call super::selectionchanged;
ddlb_item_4level.setfocus( )
end event

event constructor;call super::constructor;
redraw('MODEL 3LEVEL')
end event

type ddlb_item_4level from uo_basecode within w_des_new_model_item_popup_es
integer x = 151
integer y = 880
integer width = 658
integer height = 1352
integer taborder = 40
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;
redraw('MODEL 4LEVEL')
end event

event selectionchanged;call super::selectionchanged;
ddlb_item_5level.setfocus( )

end event

type cbx_2 from so_checkbox within w_des_new_model_item_popup_es
integer x = 1115
integer y = 792
boolean bringtotop = true
integer weight = 700
string text = "5$$HEX2$$08b8a8bc$$ENDHEX$$(1$$HEX2$$90c7acb9$$ENDHEX$$)"
boolean checked = true
end type

type ddlb_item_5level from uo_basecode within w_des_new_model_item_popup_es
integer x = 1102
integer y = 880
integer width = 658
integer height = 1352
integer taborder = 50
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;
redraw('MODEL 5LEVEL')
end event

event selectionchanged;call super::selectionchanged;
sle_user_define.setfocus()

end event

type st_3 from statictext within w_des_new_model_item_popup_es
integer x = 224
integer y = 1332
integer width = 343
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Item Name"
boolean focusrectangle = false
end type

type st_4 from statictext within w_des_new_model_item_popup_es
integer x = 224
integer y = 1416
integer width = 343
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Item Spec"
boolean focusrectangle = false
end type

type st_5 from statictext within w_des_new_model_item_popup_es
integer x = 224
integer y = 1508
integer width = 343
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Part no"
boolean focusrectangle = false
end type

type st_6 from statictext within w_des_new_model_item_popup_es
integer x = 224
integer y = 1600
integer width = 343
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Item Type"
boolean focusrectangle = false
end type

type ddlb_item_type from dropdownlistbox within w_des_new_model_item_popup_es
integer x = 658
integer y = 1596
integer width = 640
integer height = 768
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string item[] = {"1 : $$HEX3$$44c61cc888d4$$ENDHEX$$","2 : SUB ASSY","3 : SUB CPT","4 : $$HEX2$$e8b288d4$$ENDHEX$$($$HEX2$$04c890c7$$ENDHEX$$)","5 : $$HEX2$$e8b288d4$$ENDHEX$$($$HEX2$$7cc718bc$$ENDHEX$$)","6 : $$HEX1$$d0c6$$ENDHEX$$/$$HEX3$$80bd90c7acc7$$ENDHEX$$"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;

if ( this.text <> '' and this.text <> '%' and not isnull(this.text) ) then
     ddlb_customer_code.setfocus()			
end if
end event

type sle_part_no from so_singlelineedit within w_des_new_model_item_popup_es
integer x = 658
integer y = 1500
integer width = 640
integer taborder = 80
boolean bringtotop = true
textcase textcase = upper!
end type

event modified;call super::modified;
//if ( len(this.text) > 0 ) then
     ddlb_item_type.setfocus()			
//end if
end event

type sle_item_spec from so_singlelineedit within w_des_new_model_item_popup_es
integer x = 658
integer y = 1408
integer width = 1815
integer taborder = 70
boolean bringtotop = true
end type

event modified;call super::modified;
//if ( len(this.text) > 0 ) then
     sle_part_no.setfocus()			
//end if
end event

type sle_item_name from so_singlelineedit within w_des_new_model_item_popup_es
integer x = 658
integer y = 1312
integer width = 1815
integer taborder = 60
boolean bringtotop = true
end type

event modified;call super::modified;

if ( len(this.text) > 0 ) then
     sle_item_spec.setfocus()			
end if
end event

type st_7 from statictext within w_des_new_model_item_popup_es
integer x = 1435
integer y = 1600
integer width = 343
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Customer"
boolean focusrectangle = false
end type

type ddlb_customer_code from uo_customer_code_name within w_des_new_model_item_popup_es
integer x = 1833
integer y = 1596
integer width = 640
integer height = 1264
integer taborder = 90
boolean bringtotop = true
end type

event selectionchanged;call super::selectionchanged;
if ( this.text <> '' and this.text <> '%' and not isnull(this.text) ) then
     cb_save.setfocus()			
end if
end event

type gb_1 from so_groupbox within w_des_new_model_item_popup_es
integer x = 50
integer y = 552
integer width = 891
integer height = 220
end type

type gb_2 from so_groupbox within w_des_new_model_item_popup_es
integer x = 997
integer y = 552
integer width = 891
integer height = 220
end type

type gb_3 from so_groupbox within w_des_new_model_item_popup_es
integer x = 997
integer y = 804
integer width = 891
integer height = 220
end type

type gb_4 from so_groupbox within w_des_new_model_item_popup_es
integer x = 1934
integer y = 552
integer width = 891
integer height = 220
end type

type gb_5 from so_groupbox within w_des_new_model_item_popup_es
integer x = 997
integer y = 1056
integer width = 891
integer height = 220
end type

type gb_6 from so_groupbox within w_des_new_model_item_popup_es
integer x = 50
integer y = 1056
integer width = 891
integer height = 220
end type

type gb_7 from so_groupbox within w_des_new_model_item_popup_es
integer x = 55
integer y = 296
integer width = 1417
integer height = 220
end type

type gb_8 from so_groupbox within w_des_new_model_item_popup_es
integer x = 1614
integer y = 300
integer width = 1211
integer height = 220
end type

type gb_11 from so_groupbox within w_des_new_model_item_popup_es
integer x = 50
integer y = 804
integer width = 891
integer height = 220
integer taborder = 90
end type

