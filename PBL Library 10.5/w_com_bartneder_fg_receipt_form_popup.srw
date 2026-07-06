HA$PBExportHeader$w_com_bartneder_fg_receipt_form_popup.srw
$PBExportComments$(Item Query)-$$HEX4$$80bd88d470c88cd6$$ENDHEX$$
forward
global type w_com_bartneder_fg_receipt_form_popup from w_popup_root
end type
type cb_select from commandbutton within w_com_bartneder_fg_receipt_form_popup
end type
type cb_retrieve from commandbutton within w_com_bartneder_fg_receipt_form_popup
end type
type sle_box_no from so_singlelineedit within w_com_bartneder_fg_receipt_form_popup
end type
type st_5 from statictext within w_com_bartneder_fg_receipt_form_popup
end type
type em_copy from so_editmask within w_com_bartneder_fg_receipt_form_popup
end type
type st_6 from so_statictext within w_com_bartneder_fg_receipt_form_popup
end type
type gb_2 from so_groupbox within w_com_bartneder_fg_receipt_form_popup
end type
type gb_3 from so_groupbox within w_com_bartneder_fg_receipt_form_popup
end type
end forward

global type w_com_bartneder_fg_receipt_form_popup from w_popup_root
integer width = 2277
integer height = 2100
string title = "Bartender Form for Tray / Tray Pack / Carton"
long backcolor = 16777215
cb_select cb_select
cb_retrieve cb_retrieve
sle_box_no sle_box_no
st_5 st_5
em_copy em_copy
st_6 st_6
gb_2 gb_2
gb_3 gb_3
end type
global w_com_bartneder_fg_receipt_form_popup w_com_bartneder_fg_receipt_form_popup

type variables
string ivs_model_name , ivs_value = '' , ivs_pack_barcode , ivs_qty  , ivs_data
datetime ivdt_pack_date
end variables

on w_com_bartneder_fg_receipt_form_popup.create
int iCurrent
call super::create
this.cb_select=create cb_select
this.cb_retrieve=create cb_retrieve
this.sle_box_no=create sle_box_no
this.st_5=create st_5
this.em_copy=create em_copy
this.st_6=create st_6
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_select
this.Control[iCurrent+2]=this.cb_retrieve
this.Control[iCurrent+3]=this.sle_box_no
this.Control[iCurrent+4]=this.st_5
this.Control[iCurrent+5]=this.em_copy
this.Control[iCurrent+6]=this.st_6
this.Control[iCurrent+7]=this.gb_2
this.Control[iCurrent+8]=this.gb_3
end on

on w_com_bartneder_fg_receipt_form_popup.destroy
call super::destroy
destroy(this.cb_select)
destroy(this.cb_retrieve)
destroy(this.sle_box_no)
destroy(this.st_5)
destroy(this.em_copy)
destroy(this.st_6)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event open;call super::open;dw_1.settransobject(sqlca)

IVS_PACK_BARCODE =  message.stringparm // $$HEX5$$15bca4c288bc38d62000$$ENDHEX$$
sle_box_no.text = IVS_PACK_BARCODE
em_copy.text = string(gst_return.gvl_return[1])

cb_retrieve.TRIGGEREVENT(CLICKED!)
end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
end if
end event

event activate;call super::activate;IVS_RESIZE_TYPE = 'DEFAULT' 
end event

type p_title from w_popup_root`p_title within w_com_bartneder_fg_receipt_form_popup
integer width = 2213
integer height = 188
long backcolor = 16777215
end type

type cb_sort from w_popup_root`cb_sort within w_com_bartneder_fg_receipt_form_popup
integer x = 3529
integer y = 276
integer width = 329
integer height = 156
integer taborder = 0
end type

type cb_close from w_popup_root`cb_close within w_com_bartneder_fg_receipt_form_popup
boolean visible = true
integer x = 1883
integer y = 280
integer width = 329
integer height = 156
integer taborder = 0
end type

event cb_close::clicked;call super::clicked;gst_return.gvb_return = false
end event

type st_msg from w_popup_root`st_msg within w_com_bartneder_fg_receipt_form_popup
boolean visible = true
integer y = 544
integer width = 2258
end type

type dw_1 from w_popup_root`dw_1 within w_com_bartneder_fg_receipt_form_popup
boolean visible = true
integer y = 644
integer width = 2258
integer height = 748
integer taborder = 0
boolean titlebar = true
boolean border = false
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 
DW_3.RETRIEVE( THIS.OBJECT.MODEL_NAME[currentrow] , gvi_organization_id)
end event

type dw_2 from w_popup_root`dw_2 within w_com_bartneder_fg_receipt_form_popup
boolean visible = true
integer y = 644
integer width = 2213
integer height = 392
integer taborder = 0
boolean titlebar = true
string title = "Lot Detail"
end type

type dw_3 from w_popup_root`dw_3 within w_com_bartneder_fg_receipt_form_popup
boolean visible = true
integer y = 644
integer width = 2213
integer height = 392
integer taborder = 0
boolean titlebar = true
string title = "Model Master"
end type

type cb_select from commandbutton within w_com_bartneder_fg_receipt_form_popup
integer y = 1720
integer width = 2245
integer height = 244
integer taborder = 1
boolean bringtotop = true
integer textsize = -20
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Print"
boolean default = true
end type

event clicked;//IF DW_1.GETROW() = 0  THEN 
//	gst_return.gvb_return = false
//	RETURN -1
//END IF

//=================================================
//
//=================================================
string ls_path , lvs_file_name  
long   ll_s_cnt  , ll_row , Lvl_return  , lvl_copy
int i = 0 , LVI_ERROR = 0
					 
lvl_copy = long(em_copy.text) //$$HEX5$$9ccd25b8a5c718c22000$$ENDHEX$$
//=================================================
//
//=================================================

st_msg.text = "'Step 1 : Bartender Invoke"

OleObject barcode_object,barcode_format
barcode_object = Create OleObject
barcode_format = Create OleObject

//================================================
//
//================================================

st_msg.text = "'Step 2 : Bartender Connect"
iF barcode_object.ConnectToNewObject("BarTender.Application") <> 0 then
	Destroy barcode_object;
	Destroy barcode_format;
	MessageBox('Error', '$$HEX16$$14bc34d130d1200004d55cb8f8ada8b7200024c60cbe1dc8b8d2200024c658b9$$ENDHEX$$',StopSign!)
	return 0
End if 

//================================================
//
//================================================

 SELECT MODEL_NAME  , PACK_QTY , PACK_DATE 
    INTO :ivs_model_name  , :ivs_qty , :ivdt_pack_date 
   FROM IP_PRODUCT_PACK_MASTER
 WHERE PACK_BARCODE = :IVS_PACK_BARCODE ;
 
//=================================================
// $$HEX7$$0cd37cc7e4b2b4c65cb8dcb42000$$ENDHEX$$
//=================================================
st_msg.text = "'Step 3 : Label Download..."

Lvl_return = f_download_label_form_data_by_type ( ivs_model_name  ,'R')

if  Lvl_return > 0 then 

					lvs_file_name = Gvs_default_directory+"\Temp\"+Gst_return.gvs_return[1] 
					
					IF lvs_file_name = '' OR ISNULL(lvs_file_name) THEN 
						Destroy barcode_object;
						Destroy barcode_format;
						RETURN
					END IF
     
					ls_path = lvs_file_name 					
					st_msg.text = "'Step 4 : Label Open..."
					barcode_format = barcode_object.Formats.Open(ls_path,false,'')
					
					//====================================
					// $$HEX5$$12ac200038c105d32000$$ENDHEX$$
					//f_gen_label_data_4_bartender (
					//   p_run_no         IN  VARCHAR2,
//					  p_model_name     IN  VARCHAR2,  --$$HEX5$$a8ba78b3200085ba2000$$ENDHEX$$
//					  p_label_form_type  IN  VARCHAR2,   --$$HEX9$$7cb7a8bc20006cad84bd2000c0d085c72000$$ENDHEX$$
//					  p_value          IN  VARCHAR2,  --V1 - V20 $$HEX4$$eccefcb712ac2000$$ENDHEX$$
//					  p_date           IN  DATE,      --$$HEX5$$01c8a9c67cc790c72000$$ENDHEX$$
//					  p_qty            IN  VARCHAR2, --$$HEX2$$18c2c9b7$$ENDHEX$$
//					  p_param          IN  VARCHAR2,  --$$HEX5$$0cd37cb754ba30d12000$$ENDHEX$$( $$HEX13$$6fb8b8d288bc38d600ac200020b418c2c4b3200088c7e0ac2000$$ENDHEX$$, $$HEX12$$15bca4c288bc38d600ac200020b418c2c4b3200088c7e0ac$$ENDHEX$$...)
//					  p_serial_no      IN  VARCHAR2
					//====================================
					                      
					 ivs_value = '' 
					 i = 0 
					 LVI_ERROR = 0 
					 
					do			
							i++		
							ivs_value = 'V'+STRING(i)
							st_msg.text = "'Step 5 : Get Data Value : "+string(i)
									
							SELECT f_gen_label_data_4_bartender( '' , :ivs_model_name , 'B' , :ivs_value , :ivdt_pack_date , :ivs_qty , :IVS_PACK_BARCODE , '' ) 
							  INTO :ivs_data
							  FROM DUAL ;
							
							IF F_SQL_CHECK() < 0 THEN 
								LVI_ERROR = -1 
								EXIT 
							END IF 
							
							//========================================
							// do not set null data
							//========================================
							if ivs_data = 'NOTFOUND' or ivs_data = '' or isnull(ivs_data) then 
							else
								st_msg.text = "'Step 6 : Set Data Value : "+string(i)
								barcode_format.SetNamedSubStringValue(ivs_value, ivs_data )
							end if ; 
					loop until i = 20
					
					if LVI_ERROR < 0 then 
							Destroy barcode_object;
							Destroy barcode_format;
							 Messagebox("Error" , "Label Data set error")
					else
							st_msg.text = "'Step 7 : Printing..."
						
//									//$$HEX22$$90c72cd2acb9200018c2c9b774c7200088c73cc774ba200090c72cd2acb9200018c2c9b7200098ccacb92000$$ENDHEX$$
//									if  long(LVS_REMIAN_QTY) > 0 then 
//
//										 if lvl_copy > 1 then 
//										       lvl_copy = lvl_copy -1 
//										elseif lvl_copy = 1 then 
//											   lvl_copy = 1 
//										end if 
//										
//									end if 
									
									// $$HEX12$$9ccd25b82000a5c718c22000ccb97cd02000e8b804d52000$$ENDHEX$$
									long j = 0 
									do 
											j++
											barcode_format.PrintOut(0,0)
											st_msg.text = "'Step 7 : Copy Printing..."+string(j)
									loop until j = lvl_copy //$$HEX16$$94c7c9b720005cd5a5c72000ccb97cd020005cb3200098ccacb9200009000900$$ENDHEX$$
					
					end if 
					
					
//					//==============================================================
//					// $$HEX22$$94c7c9b7d0c5200000b374d52000c8b9c0c9c9b920005cd5a5c72000ccb92000e4b2dcc2200098ccacb92000$$ENDHEX$$
//					//==============================================================
//					if  long(LVS_REMIAN_QTY) > 0 then 
//						
//								 ivs_value = '' 
//								 i = 0 
//								 LVI_ERROR = 0 
//								 
//								do			
//										i++		
//										ivs_value = 'V'+STRING(i)
//										st_msg.text = "'Step 8 : Get Data Value : "+string(i)
//												
//										SELECT f_gen_label_data_4_bartender( :LVS_RUN_NO , :LVS_MODEL_NAME , :IVS_LABEL_FORM_TYPE , :ivs_value , SYSDATE , :LVS_REMIAN_QTY , :LVS_PARAM  , '') 
//										  INTO :ivs_data
//										  FROM DUAL ;
//										
//										IF F_SQL_CHECK() < 0 THEN 
//											LVI_ERROR = -1 
//											EXIT 
//										END IF 
//										
//										//========================================
//										// do not set null data
//										//========================================
//										if ivs_data = 'NOTFOUND' or ivs_data = '' or isnull(ivs_data) then 
//										else
//											st_msg.text = "'Step 9 : Set Data Value : "+string(i)
//											barcode_format.SetNamedSubStringValue(ivs_value, ivs_data )
//										end if ; 
//								loop until i = 20
//								
//								if LVI_ERROR < 0 then 
//										Destroy barcode_object;
//										Destroy barcode_format;
//									    Messagebox("Error" , "Label Data set error")
//								else
//										st_msg.text = "'Step 10 : Printing..."
//										barcode_format.PrintOut(0,0)
//								end if 				
//								
//					end if //  $$HEX10$$94c7c9b7d0c5200000b374d5200098ccacb92000$$ENDHEX$$
//
else
	
	Messagebox("Error" , "Form Download Error "+ivs_model_name)
	Destroy barcode_object;
	Destroy barcode_format;
	gst_return.gvb_return = false
	return 
	
end if
//======================================
//
//======================================
gst_return.gvb_return = true 

st_msg.text = "'Step 7 : Close Bartender"
barcode_format.Close(1)
barcode_object.Quit(1)
st_msg.text = "'Step 7 : Object Release..."
Destroy barcode_object;
Destroy barcode_format;

Gst_return.gvs_return[1]  = ''
CLOSEWITHRETURN(PARENT , MESSAGE.STRINGPARM )
end event

type cb_retrieve from commandbutton within w_com_bartneder_fg_receipt_form_popup
integer x = 1550
integer y = 280
integer width = 329
integer height = 156
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Retrieve"
end type

type sle_box_no from so_singlelineedit within w_com_bartneder_fg_receipt_form_popup
integer x = 78
integer y = 360
integer width = 955
integer height = 84
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
textcase textcase = upper!
end type

type st_5 from statictext within w_com_bartneder_fg_receipt_form_popup
integer x = 73
integer y = 296
integer width = 955
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
boolean enabled = false
string text = "Box No"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_copy from so_editmask within w_com_bartneder_fg_receipt_form_popup
integer x = 1257
integer y = 1432
integer width = 818
integer height = 232
boolean bringtotop = true
integer textsize = -28
string text = "1"
alignment alignment = center!
string mask = "###"
boolean spin = true
double increment = 1
string minmax = "1~~"
end type

type st_6 from so_statictext within w_com_bartneder_fg_receipt_form_popup
integer x = 46
integer y = 1424
integer width = 1042
integer height = 232
boolean bringtotop = true
integer textsize = -28
integer weight = 700
long backcolor = 16777215
string text = "Copy"
alignment alignment = right!
end type

type gb_2 from so_groupbox within w_com_bartneder_fg_receipt_form_popup
integer x = 1486
integer y = 192
integer width = 777
integer height = 328
integer weight = 700
long textcolor = 16711680
long backcolor = 16777215
string text = "Process"
end type

type gb_3 from so_groupbox within w_com_bartneder_fg_receipt_form_popup
integer y = 192
integer width = 1115
integer height = 328
integer weight = 700
long textcolor = 16711680
long backcolor = 16777215
string text = "Where Condition"
end type

