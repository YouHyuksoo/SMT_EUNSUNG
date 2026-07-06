HA$PBExportHeader$w_mat_baking_scan_master.srw
$PBExportComments$Line Master
forward
global type w_mat_baking_scan_master from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_mat_baking_scan_master
end type
type uo_dateend from uo_ymd_calendar within w_mat_baking_scan_master
end type
type st_4 from so_statictext within w_mat_baking_scan_master
end type
type st_11 from so_statictext within w_mat_baking_scan_master
end type
type sle_our_barcode from so_singlelineedit within w_mat_baking_scan_master
end type
type st_1 from so_statictext within w_mat_baking_scan_master
end type
type ddlb_item_code from uo_item_code within w_mat_baking_scan_master
end type
type sle_material_mfs from so_singlelineedit within w_mat_baking_scan_master
end type
type st_2 from so_statictext within w_mat_baking_scan_master
end type
type sle_barcode from so_singlelineedit within w_mat_baking_scan_master
end type
type st_3 from so_statictext within w_mat_baking_scan_master
end type
type sle_chamber_code from so_singlelineedit within w_mat_baking_scan_master
end type
type st_chamber_code from so_statictext within w_mat_baking_scan_master
end type
type rb_input from so_radiobutton within w_mat_baking_scan_master
end type
type rb_output from so_radiobutton within w_mat_baking_scan_master
end type
type gb_1 from so_groupbox within w_mat_baking_scan_master
end type
type gb_2 from so_groupbox within w_mat_baking_scan_master
end type
type gb_3 from so_groupbox within w_mat_baking_scan_master
end type
end forward

global type w_mat_baking_scan_master from w_main_root
integer width = 5038
integer height = 2748
string title = "Baking History Master"
uo_dateset uo_dateset
uo_dateend uo_dateend
st_4 st_4
st_11 st_11
sle_our_barcode sle_our_barcode
st_1 st_1
ddlb_item_code ddlb_item_code
sle_material_mfs sle_material_mfs
st_2 st_2
sle_barcode sle_barcode
st_3 st_3
sle_chamber_code sle_chamber_code
st_chamber_code st_chamber_code
rb_input rb_input
rb_output rb_output
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_mat_baking_scan_master w_mat_baking_scan_master

on w_mat_baking_scan_master.create
int iCurrent
call super::create
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.st_4=create st_4
this.st_11=create st_11
this.sle_our_barcode=create sle_our_barcode
this.st_1=create st_1
this.ddlb_item_code=create ddlb_item_code
this.sle_material_mfs=create sle_material_mfs
this.st_2=create st_2
this.sle_barcode=create sle_barcode
this.st_3=create st_3
this.sle_chamber_code=create sle_chamber_code
this.st_chamber_code=create st_chamber_code
this.rb_input=create rb_input
this.rb_output=create rb_output
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateset
this.Control[iCurrent+2]=this.uo_dateend
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.st_11
this.Control[iCurrent+5]=this.sle_our_barcode
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.ddlb_item_code
this.Control[iCurrent+8]=this.sle_material_mfs
this.Control[iCurrent+9]=this.st_2
this.Control[iCurrent+10]=this.sle_barcode
this.Control[iCurrent+11]=this.st_3
this.Control[iCurrent+12]=this.sle_chamber_code
this.Control[iCurrent+13]=this.st_chamber_code
this.Control[iCurrent+14]=this.rb_input
this.Control[iCurrent+15]=this.rb_output
this.Control[iCurrent+16]=this.gb_1
this.Control[iCurrent+17]=this.gb_2
this.Control[iCurrent+18]=this.gb_3
end on

on w_mat_baking_scan_master.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.st_4)
destroy(this.st_11)
destroy(this.sle_our_barcode)
destroy(this.st_1)
destroy(this.ddlb_item_code)
destroy(this.sle_material_mfs)
destroy(this.st_2)
destroy(this.sle_barcode)
destroy(this.st_3)
destroy(this.sle_chamber_code)
destroy(this.st_chamber_code)
destroy(this.rb_input)
destroy(this.rb_output)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
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

/****************************************
*  Menu Property
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

event ue_data_control;call super::ue_data_control;long row
choose case gvs_ue_data_control
		
	case 'RETRIEVE'
		
			dw_1.retrieve( ddlb_item_code.text( )  +'%' ,  sle_material_mfs.text+'%' , uo_dateset.text() , uo_dateend.text() ,   gvi_organization_id)
			dw_1.setfocus()
			
	case else
end choose


end event

type dw_5 from w_main_root`dw_5 within w_mat_baking_scan_master
integer y = 316
end type

type dw_4 from w_main_root`dw_4 within w_mat_baking_scan_master
integer y = 316
end type

type dw_3 from w_main_root`dw_3 within w_mat_baking_scan_master
integer y = 316
integer width = 4366
integer height = 1388
end type

type dw_2 from w_main_root`dw_2 within w_mat_baking_scan_master
integer y = 316
integer width = 4370
integer height = 828
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

type dw_1 from w_main_root`dw_1 within w_mat_baking_scan_master
integer y = 312
integer width = 4375
integer height = 2328
boolean titlebar = true
string dataobject = "d_mat_material_baking_scan_lst"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_mat_baking_scan_master
end type

type uo_dateset from uo_ymd_calendar within w_mat_baking_scan_master
event destroy ( )
integer x = 3918
integer y = 164
integer taborder = 40
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mat_baking_scan_master
event destroy ( )
integer x = 4334
integer y = 164
integer taborder = 50
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_4 from so_statictext within w_mat_baking_scan_master
integer x = 3922
integer y = 84
integer width = 814
integer height = 68
boolean bringtotop = true
string text = "Date"
end type

type st_11 from so_statictext within w_mat_baking_scan_master
integer x = 1874
integer y = 100
integer width = 960
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Barcode"
end type

type sle_our_barcode from so_singlelineedit within w_mat_baking_scan_master
integer x = 1874
integer y = 168
integer width = 960
integer height = 84
integer taborder = 70
boolean bringtotop = true
end type

event modified;call super::modified;int lvi_pos1 , lvi_pos2
string lvs_our_barcode  , lvs_item_code , lvs_lot_no 
lvs_our_barcode = this.text 

////=======================================
//// $$HEX11$$00cf3cd554cf200090c7acc778c72000bdacb0c62000$$ENDHEX$$
////=======================================
// IF MID (UPPER (lvs_our_barcode), 1, 1) = '['    THEN
//         SELECT  f_get_item_code_from_barcode (:lvs_our_barcode)|| '-' || f_get_lot_no_from_barcode (:lvs_our_barcode) || '-' || f_get_lot_qty_from_barcode (:lvs_our_barcode)
//		    INTO :lvs_our_barcode
//	       FROM DUAL ; 
//		
//		IF F_SQL_CHECK() < 0 THEN 
//				this.selecttext( 1,100)	
//		END IF 	 
//ELSE
//		 SELECT  f_get_prepare_barcode (:lvs_our_barcode)
//		     INTO :lvs_our_barcode
//	       FROM DUAL ; 
//		
//		IF F_SQL_CHECK() < 0 THEN 
//				this.selecttext( 1,100)	
//		END IF 	 
//END IF 


//===================================================
//
//===================================================
//lvi_pos1 =  pos(lvs_our_barcode , '-' , 7 ) 
//
//if  lvi_pos1 <= 0 then 
//	
//	f_msgbox1(1175 ,lvs_our_barcode )
//	sle_our_barcode.text = ''
//	sle_our_barcode.setfocus()
//	return -1 
//	
//end if 
//=================================================
//
//=================================================

//lvs_item_code = trim( mid( lvs_our_barcode , 1 ,  lvi_pos1 -1 ))
SELECT  f_get_item_code_from_barcode (:lvs_our_barcode) 
	INTO :lvs_item_code
	FROM DUAL ; 
	
	IF F_SQL_CHECK() < 0 THEN 
		sle_our_barcode.selecttext( 1,100)	
	END IF 	 
	
	if  lvs_item_code = '' then 
		
		f_play_sound("$$HEX5$$88d4a9baf8bbf1b45db8$$ENDHEX$$.wav")
		f_msgbox1(1175 ,lvs_our_barcode )
		sle_our_barcode.setfocus()
		sle_our_barcode.selecttext( 1,100)
		return 
	end if 

if f_check_item_exists( lvs_item_code , f_t_sysdate())  <= 0 then 
	f_play_sound("$$HEX5$$88d4a9baf8bbf1b45db8$$ENDHEX$$.wav")	
	f_msgbox(9041) //$$HEX10$$fcd3a9bac8b9a4c230d12000f8bbf1b45db82000$$ENDHEX$$

	sle_our_barcode.text = ''
	sle_our_barcode.setfocus()
	return -1
end if 

//==================================================
// $$HEX6$$6fb8b8d2200088bc38d62000$$ENDHEX$$
//==================================================
//lvi_pos2 =  pos(lvs_our_barcode , '-' , lvi_pos1+1 ) 
//
//if  lvi_pos2 <= 0 then 
//
//	lvs_lot_no = trim( mid( lvs_our_barcode , lvi_pos1+1 ,  100 ))	
//else
//	lvs_lot_no = trim( mid( lvs_our_barcode , lvi_pos1+1 ,   lvi_pos2 - lvi_pos1 -1 ))
//end if 
//
//if lvs_lot_no = ''  then 
//	sle_our_barcode.text = ''
//	sle_our_barcode.setfocus()
//	return -1
//end if 
SELECT  F_GET_LOT_NO_FROM_BARCODE (:lvs_our_barcode ) 
	INTO :lvs_lot_no
	FROM DUAL ; 
	
	IF F_SQL_CHECK() < 0 THEN 
		sle_our_barcode.selecttext( 1,100)	
	END IF 	 

	if lvs_lot_no = ''  then 
         f_msg( "$$HEX15$$6fb8b8d288bc38d600ac20002cc614bc74b9c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$",'S')
		sle_our_barcode.setfocus()
		sle_our_barcode.selecttext( 1,100)	
		return
	end if 
	
ddlb_item_code.text = lvs_item_code
sle_material_mfs.text = lvs_lot_no
this.selecttext( 1,100)
f_retrieve()

//============================================================
//
//============================================================





end event

type st_1 from so_statictext within w_mat_baking_scan_master
integer x = 2843
integer y = 100
integer width = 512
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type ddlb_item_code from uo_item_code within w_mat_baking_scan_master
integer x = 2843
integer y = 168
integer width = 512
integer taborder = 80
boolean bringtotop = true
end type

type sle_material_mfs from so_singlelineedit within w_mat_baking_scan_master
integer x = 3365
integer y = 168
integer width = 544
integer height = 84
integer taborder = 90
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

type st_2 from so_statictext within w_mat_baking_scan_master
integer x = 3365
integer y = 100
integer width = 544
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Material MFS"
end type

type sle_barcode from so_singlelineedit within w_mat_baking_scan_master
integer x = 1120
integer y = 172
integer width = 690
integer height = 84
integer taborder = 80
boolean bringtotop = true
end type

event modified;call super::modified;int lvi_pos1 , lvi_pos2 ,  LVI_COUNT
string lvs_our_barcode  , lvs_item_code , lvs_lot_no  , LVS_CHAMBER_CODE
long lvl_lot_qty

lvs_our_barcode = this.text 
LVS_CHAMBER_CODE = SLE_CHAMBER_CODE.TEXT

if lvs_our_barcode  = '' then 
	return 
end if 
if LVS_CHAMBER_CODE  = '' OR ISNULL(LVS_CHAMBER_CODE) then 
	F_MSGBOX1(102 , st_chamber_code.text ) 
	return 
end if 

//===================================================
//
//===================================================
//lvi_pos1 =  pos(lvs_our_barcode , '-' , 7 ) 
//
//if  lvi_pos1 <= 0 then 
//	
//	f_msgbox1(1175 ,lvs_our_barcode )
//	sle_our_barcode.text = ''
//	sle_our_barcode.setfocus()
//	return -1 
//end if 
//
////=================================================
////
////=================================================
//
//lvs_item_code = trim( mid( lvs_our_barcode , 1 ,  lvi_pos1 -1 ))
SELECT  f_get_item_code_from_barcode (:lvs_our_barcode) 
	INTO :lvs_item_code
	FROM DUAL ; 
	
	IF F_SQL_CHECK() < 0 THEN 
		sle_our_barcode.selecttext( 1,100)	
	END IF 	 
	
	if  lvs_item_code = '' then 
		
		f_play_sound("$$HEX5$$88d4a9baf8bbf1b45db8$$ENDHEX$$.wav")
		f_msgbox1(1175 ,lvs_our_barcode )
		sle_our_barcode.setfocus()
		sle_our_barcode.selecttext( 1,100)
		return 
	end if 
if f_check_item_exists( lvs_item_code , f_t_sysdate())  <= 0 then 
	f_play_sound("$$HEX5$$88d4a9baf8bbf1b45db8$$ENDHEX$$.wav")	
	f_msgbox(9041) //$$HEX10$$fcd3a9bac8b9a4c230d12000f8bbf1b45db82000$$ENDHEX$$

	sle_our_barcode.text = ''
	sle_our_barcode.setfocus()
	return -1
end if 

//==================================================
// $$HEX6$$6fb8b8d2200088bc38d62000$$ENDHEX$$
//================================================== 
//lvi_pos2 =  pos(lvs_our_barcode , '-' , lvi_pos1+1 ) 
//
//if  lvi_pos2 <= 0 then 
//
//	lvs_lot_no = trim( mid( lvs_our_barcode , lvi_pos1+1 ,  100 ))	
//else
//	lvs_lot_no = trim( mid( lvs_our_barcode , lvi_pos1+1 ,   lvi_pos2 - lvi_pos1 -1 ))
//end if 
//
//if lvs_lot_no = ''  then 
//	sle_our_barcode.text = ''
//	sle_our_barcode.setfocus()
//	return -1
//end if 

SELECT  F_GET_LOT_NO_FROM_BARCODE (:lvs_our_barcode ) 
	INTO :lvs_lot_no
	FROM DUAL ; 
	
	IF F_SQL_CHECK() < 0 THEN 
		sle_our_barcode.selecttext( 1,100)	
	END IF 	 

	if lvs_lot_no = ''  then 
		f_msg( "$$HEX15$$6fb8b8d288bc38d600ac20002cc614bc74b9c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$",'P')
		sle_our_barcode.setfocus()
		sle_our_barcode.selecttext( 1,100)	
		return
	end if 
//===============================================
// $$HEX18$$74c7f8bb2000e4b4b4c500ac200088c794b22000c1c0dcd078c7c0c9200070c88cd62000$$ENDHEX$$
//  
//===============================================
if rb_input.checked = true then 
	

			LVI_COUNT = 0 
			
			 SELECT COUNT(*) 
				 INTO :LVI_COUNT 
				FROM  IM_ITEM_BAKING_MASTER 
			 WHERE ITEM_CODE = :LVS_ITEM_CODE
				  AND LOT_NO = :LVS_LOT_NO
				 AND OUTPUT_SCAN_DATE IS NULL
				 AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
				
			IF F_SQL_CHECK() < 0 THEN 
				RETURN 
			END IF 
			
			//==================================		
			//$$HEX17$$54cc84bc200085c7e0ac200074c725b874c7200074c7f8bb200074c8acc768d52000$$ENDHEX$$
			//==================================
			 IF LVI_COUNT > 0 THEN 
				
			
				
			 ELSE
				
					 INSERT INTO "IM_ITEM_BAKING_MASTER"  
						( "CHAMBER_CODE",   
						  "INPUT_SCAN_DATE",   
						  "OUTPUT_SCAN_DATE",   
						  "SCAN_BY",   
						  "ITEM_CODE",   
						  "ITEM_BARCODE",   
						  "LOT_NO",   
						  "LOT_QTY",   
						  "ORGANIZATION_ID",   
						  "ENTER_DATE",   
						  "ENTER_BY",   
						  "LAST_MODIFY_DATE",   
						  "LAST_MODIFY_BY" )  
					  VALUES ( :LVS_CHAMBER_CODE,   
								  SYSDATE,   
								  NULL,   
								  :GVS_USER_ID,   
								  :LVS_ITEM_CODE,   
								  :lvs_our_barcode,   
								  :LVS_LOT_NO ,   
								  :lvl_lot_qty,   
								  :gvi_organization_id,   
								  sysdate,   
								  :gvs_user_id,   
								  sysdate,   
								  :gvs_user_id
							 )  ;
			
					IF F_SQL_CHECK() < 0 THEN 
						RETURN 
					END IF 
				END IF 
						//===============================================
						//
						//===============================================
						
						update im_item_receipt_barcode 
							  set msl_remain_time =  msl_passed_time  , 
									msl_passed_time = 0.01  ,     // 0 $$HEX31$$7cc7bdacb0c6200090c7acc7a5c729cc200074c725b844c7200094cd01c858d530aed0c5200074c77cb920008cd63cd57cb9200004c774d52000c0c915c8$$ENDHEX$$
									baking_start_date = sysdate  , 
									baking_end_date = null 
						where item_code = :lvs_item_code
							and lot_no = :lvs_lot_no
							and organization_id = :gvi_organization_id ;
							
						 if f_sql_check() < 0 then 
							return 
						end if 
						
						update im_item_inventory 
							  set baking_date = sysdate 
						where item_code = :lvs_item_code
							and material_mfs = :lvs_lot_no
							and organization_id = :gvi_organization_id ;
							
						 if f_sql_check() < 0 then 
							return 
						end if 		
					
		
 
//===============================================
// $$HEX18$$74c7f8bb2000e4b4b4c500ac200088c794b22000c1c0dcd078c7c0c9200070c88cd62000$$ENDHEX$$
// $$HEX24$$74d51cc1200074c7f8bb2000e4b4b4c500ac200088c7c8c53cc774ba20009ccde0ac200098ccacb920005cd5e4b22000$$ENDHEX$$
//=============================================== 
else

		LVI_COUNT = 0 
		
		 SELECT COUNT(*) 
			 INTO :LVI_COUNT 
			FROM  IM_ITEM_BAKING_MASTER 
		 WHERE ITEM_CODE = :LVS_ITEM_CODE
			  AND LOT_NO = :LVS_LOT_NO
			 AND OUTPUT_SCAN_DATE IS NULL
			 AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
			
		IF F_SQL_CHECK() < 0 THEN 
			RETURN 
		END IF 

//==================================		
//$$HEX17$$54cc84bc200085c7e0ac200074c725b874c7200074c7f8bb200074c8acc768d52000$$ENDHEX$$
//$$HEX6$$74c7f8bb200074c8acc768d5$$ENDHEX$$. $$HEX6$$9ccde0ac200098ccacb92000$$ENDHEX$$
//==================================
			 IF LVI_COUNT > 0 THEN 
				
						UPDATE  IM_ITEM_BAKING_MASTER 
								SET OUTPUT_SCAN_DATE = SYSDATE 
						 WHERE ITEM_CODE = :LVS_ITEM_CODE
							  AND LOT_NO = :LVS_LOT_NO
							 AND OUTPUT_SCAN_DATE IS NULL
							 AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
							
							IF F_SQL_CHECK() < 0 THEN 
								RETURN 
							END IF 
							
						update im_item_receipt_barcode 
							  set baking_end_date = sysdate 
						where item_code = :lvs_item_code
							and lot_no = :lvs_lot_no
							and organization_id = :gvi_organization_id ;
							
						 if f_sql_check() < 0 then 
							return 
						end if 	
				
			else
				
				
				
			end if 

end if 

f_play_sound("$$HEX4$$00c8a5c731c1f5ac$$ENDHEX$$.wav")
f_msgbox(197) //$$HEX12$$15c8c1c0200098ccacb9200018b4c8c5b5c2c8b2e4b22000$$ENDHEX$$

commit ;

this.text = ''
this.setfocus( )
		
end event

type st_3 from so_statictext within w_mat_baking_scan_master
integer x = 1120
integer y = 104
integer width = 690
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 255
string text = "Barcode"
end type

type sle_chamber_code from so_singlelineedit within w_mat_baking_scan_master
integer x = 704
integer y = 172
integer width = 411
integer height = 84
integer taborder = 90
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

type st_chamber_code from so_statictext within w_mat_baking_scan_master
integer x = 704
integer y = 104
integer width = 411
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 255
string text = "Chamber Code"
end type

type rb_input from so_radiobutton within w_mat_baking_scan_master
integer x = 96
integer y = 96
boolean bringtotop = true
string text = "Start Baking"
boolean checked = true
end type

type rb_output from so_radiobutton within w_mat_baking_scan_master
integer x = 96
integer y = 192
boolean bringtotop = true
string text = "End Baking"
end type

type gb_1 from so_groupbox within w_mat_baking_scan_master
integer x = 1833
integer width = 2958
integer height = 304
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_mat_baking_scan_master
integer width = 667
integer height = 304
integer taborder = 30
string text = "Category"
end type

type gb_3 from so_groupbox within w_mat_baking_scan_master
integer x = 686
integer width = 1143
integer height = 304
integer taborder = 30
string text = "Process"
end type

