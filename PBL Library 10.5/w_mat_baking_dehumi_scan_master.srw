HA$PBExportHeader$w_mat_baking_dehumi_scan_master.srw
$PBExportComments$Line Master
forward
global type w_mat_baking_dehumi_scan_master from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_mat_baking_dehumi_scan_master
end type
type uo_dateend from uo_ymd_calendar within w_mat_baking_dehumi_scan_master
end type
type st_4 from so_statictext within w_mat_baking_dehumi_scan_master
end type
type st_11 from so_statictext within w_mat_baking_dehumi_scan_master
end type
type sle_our_barcode from so_singlelineedit within w_mat_baking_dehumi_scan_master
end type
type st_1 from so_statictext within w_mat_baking_dehumi_scan_master
end type
type ddlb_item_code from uo_item_code within w_mat_baking_dehumi_scan_master
end type
type sle_material_mfs from so_singlelineedit within w_mat_baking_dehumi_scan_master
end type
type st_2 from so_statictext within w_mat_baking_dehumi_scan_master
end type
type sle_barcode from so_singlelineedit within w_mat_baking_dehumi_scan_master
end type
type st_3 from so_statictext within w_mat_baking_dehumi_scan_master
end type
type sle_chamber_code from so_singlelineedit within w_mat_baking_dehumi_scan_master
end type
type st_chamber_code from so_statictext within w_mat_baking_dehumi_scan_master
end type
type rb_receipt from so_radiobutton within w_mat_baking_dehumi_scan_master
end type
type rb_issue from so_radiobutton within w_mat_baking_dehumi_scan_master
end type
type rb_backing from so_radiobutton within w_mat_baking_dehumi_scan_master
end type
type rb_dehumi from so_radiobutton within w_mat_baking_dehumi_scan_master
end type
type st_5 from so_statictext within w_mat_baking_dehumi_scan_master
end type
type sle_location from so_singlelineedit within w_mat_baking_dehumi_scan_master
end type
type rb_vacuum from so_radiobutton within w_mat_baking_dehumi_scan_master
end type
type gb_1 from so_groupbox within w_mat_baking_dehumi_scan_master
end type
type gb_2 from so_groupbox within w_mat_baking_dehumi_scan_master
end type
type gb_3 from so_groupbox within w_mat_baking_dehumi_scan_master
end type
type gb_6 from so_groupbox within w_mat_baking_dehumi_scan_master
end type
end forward

global type w_mat_baking_dehumi_scan_master from w_main_root
integer width = 6647
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
rb_receipt rb_receipt
rb_issue rb_issue
rb_backing rb_backing
rb_dehumi rb_dehumi
st_5 st_5
sle_location sle_location
rb_vacuum rb_vacuum
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
gb_6 gb_6
end type
global w_mat_baking_dehumi_scan_master w_mat_baking_dehumi_scan_master

type variables

string ivs_chamber_type, ivs_txn_type
end variables

on w_mat_baking_dehumi_scan_master.create
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
this.rb_receipt=create rb_receipt
this.rb_issue=create rb_issue
this.rb_backing=create rb_backing
this.rb_dehumi=create rb_dehumi
this.st_5=create st_5
this.sle_location=create sle_location
this.rb_vacuum=create rb_vacuum
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_6=create gb_6
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
this.Control[iCurrent+14]=this.rb_receipt
this.Control[iCurrent+15]=this.rb_issue
this.Control[iCurrent+16]=this.rb_backing
this.Control[iCurrent+17]=this.rb_dehumi
this.Control[iCurrent+18]=this.st_5
this.Control[iCurrent+19]=this.sle_location
this.Control[iCurrent+20]=this.rb_vacuum
this.Control[iCurrent+21]=this.gb_1
this.Control[iCurrent+22]=this.gb_2
this.Control[iCurrent+23]=this.gb_3
this.Control[iCurrent+24]=this.gb_6
end on

on w_mat_baking_dehumi_scan_master.destroy
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
destroy(this.rb_receipt)
destroy(this.rb_issue)
destroy(this.rb_backing)
destroy(this.rb_dehumi)
destroy(this.st_5)
destroy(this.sle_location)
destroy(this.rb_vacuum)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_6)
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

event ue_data_control;call super::ue_data_control;long   row

choose case gvs_ue_data_control
		
	case 'RETRIEVE'
		
			dw_1.retrieve( ddlb_item_code.text( )  +'%' ,  sle_material_mfs.text+'%' , uo_dateset.text() , uo_dateend.text() ,   gvi_organization_id, ivs_chamber_type )
			dw_1.setfocus()
			
	case else
end choose


end event

type dw_5 from w_main_root`dw_5 within w_mat_baking_dehumi_scan_master
integer y = 316
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_mat_baking_dehumi_scan_master
integer y = 316
integer taborder = 0
end type

type dw_3 from w_main_root`dw_3 within w_mat_baking_dehumi_scan_master
integer y = 316
integer width = 4366
integer height = 1388
integer taborder = 0
end type

type dw_2 from w_main_root`dw_2 within w_mat_baking_dehumi_scan_master
integer y = 316
integer width = 4370
integer height = 828
integer taborder = 0
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

type dw_1 from w_main_root`dw_1 within w_mat_baking_dehumi_scan_master
integer y = 312
integer width = 4375
integer height = 2328
integer taborder = 0
boolean titlebar = true
string dataobject = "d_mat_material_baking_dehumi_scan_lst"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_mat_baking_dehumi_scan_master
integer taborder = 0
end type

type uo_dateset from uo_ymd_calendar within w_mat_baking_dehumi_scan_master
event destroy ( )
integer x = 5390
integer y = 172
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mat_baking_dehumi_scan_master
event destroy ( )
integer x = 5806
integer y = 172
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_4 from so_statictext within w_mat_baking_dehumi_scan_master
integer x = 5394
integer y = 92
integer width = 814
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Date"
end type

type st_11 from so_statictext within w_mat_baking_dehumi_scan_master
integer x = 3346
integer y = 92
integer width = 960
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Barcode"
end type

type sle_our_barcode from so_singlelineedit within w_mat_baking_dehumi_scan_master
integer x = 3346
integer y = 172
integer width = 960
integer height = 84
boolean bringtotop = true
end type

event modified;call super::modified;int lvi_pos1 , lvi_pos2
string lvs_our_barcode  , lvs_item_code , lvs_lot_no 
lvs_our_barcode = this.text 

//===================================================
//
//===================================================
SELECT  f_get_item_code_from_barcode (:lvs_our_barcode ) 
	INTO :lvs_item_code
   FROM DUAL ; 
	
if  lvs_item_code = '' then 
	
	f_msgbox1(1175 ,lvs_our_barcode )
	sle_our_barcode.text = ''
	sle_our_barcode.setfocus()
	return -1 
	
end if 

//=================================================
//
//=================================================

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
	SELECT  F_GET_LOT_NO_FROM_BARCODE (:lvs_our_barcode ) 
	INTO :lvs_lot_no
	FROM DUAL ; 
	
	IF F_SQL_CHECK() < 0 THEN 
		sle_our_barcode.text = ''
		sle_our_barcode.setfocus()
	END IF 	 

if lvs_lot_no = ''  then 
	sle_our_barcode.text = ''
	sle_our_barcode.setfocus()
	return -1
end if 

ddlb_item_code.text = lvs_item_code
sle_material_mfs.text = lvs_lot_no
this.selecttext( 1,100)
f_retrieve()


//int lvi_pos1 , lvi_pos2
//string lvs_our_barcode  , lvs_item_code , lvs_lot_no 
//lvs_our_barcode = this.text 
//
//////=======================================
////// $$HEX11$$00cf3cd554cf200090c7acc778c72000bdacb0c62000$$ENDHEX$$
//////=======================================
//// IF MID (UPPER (lvs_our_barcode), 1, 1) = '['    THEN
////         SELECT  f_get_item_code_from_barcode (:lvs_our_barcode)|| '-' || f_get_lot_no_from_barcode (:lvs_our_barcode) || '-' || f_get_lot_qty_from_barcode (:lvs_our_barcode)
////		    INTO :lvs_our_barcode
////	       FROM DUAL ; 
////		
////		IF F_SQL_CHECK() < 0 THEN 
////				this.selecttext( 1,100)	
////		END IF 	 
////ELSE
////		 SELECT  f_get_prepare_barcode (:lvs_our_barcode)
////		     INTO :lvs_our_barcode
////	       FROM DUAL ; 
////		
////		IF F_SQL_CHECK() < 0 THEN 
////				this.selecttext( 1,100)	
////		END IF 	 
////END IF 
//
//
////===================================================
////
////===================================================
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
//
////=================================================
////
////=================================================
//
//lvs_item_code = trim( mid( lvs_our_barcode , 1 ,  lvi_pos1 -1 ))
//
//if f_check_item_exists( lvs_item_code , f_t_sysdate())  <= 0 then 
//	f_play_sound("$$HEX5$$88d4a9baf8bbf1b45db8$$ENDHEX$$.wav")	
//	f_msgbox(9041) //$$HEX10$$fcd3a9bac8b9a4c230d12000f8bbf1b45db82000$$ENDHEX$$
//
//	sle_our_barcode.text = ''
//	sle_our_barcode.setfocus()
//	return -1
//end if 
//
////==================================================
//// $$HEX6$$6fb8b8d2200088bc38d62000$$ENDHEX$$
////==================================================
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
//
//ddlb_item_code.text = lvs_item_code
//sle_material_mfs.text = lvs_lot_no
//this.selecttext( 1,100)
//f_retrieve()
//
////============================================================
////
////============================================================
//
//
//
//
//
end event

type st_1 from so_statictext within w_mat_baking_dehumi_scan_master
integer x = 4315
integer y = 92
integer width = 512
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type ddlb_item_code from uo_item_code within w_mat_baking_dehumi_scan_master
integer x = 4315
integer y = 172
integer width = 512
integer taborder = 0
boolean bringtotop = true
end type

type sle_material_mfs from so_singlelineedit within w_mat_baking_dehumi_scan_master
integer x = 4837
integer y = 172
integer width = 544
integer height = 84
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

type st_2 from so_statictext within w_mat_baking_dehumi_scan_master
integer x = 4837
integer y = 92
integer width = 544
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Material MFS"
end type

type sle_barcode from so_singlelineedit within w_mat_baking_dehumi_scan_master
integer x = 2281
integer y = 172
integer width = 960
integer height = 84
integer taborder = 30
boolean bringtotop = true
end type

event modified;call super::modified;int lvi_pos1 , lvi_pos2 ,  LVI_COUNT
string lvs_our_barcode  , lvs_item_code , lvs_lot_no  , LVS_CHAMBER_CODE, LVS_CHAMBER_location
long lvl_lot_qty

lvs_our_barcode = this.text 
LVS_CHAMBER_CODE = SLE_CHAMBER_CODE.TEXT
LVS_CHAMBER_location = sle_location.text

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
SELECT  f_get_item_code_from_barcode (:lvs_our_barcode ) 
	INTO :lvs_item_code
   FROM DUAL ; 
	
if  lvs_item_code = '' then 
	
	f_msgbox1(1175 ,lvs_our_barcode )
	this.text = ''
	this.setfocus()
	return -1 
	
end if 

//=================================================
//
//=================================================

if f_check_item_exists( lvs_item_code , f_t_sysdate())  <= 0 then 
	f_play_sound("$$HEX5$$88d4a9baf8bbf1b45db8$$ENDHEX$$.wav")	
	f_msgbox(9041) //$$HEX10$$fcd3a9bac8b9a4c230d12000f8bbf1b45db82000$$ENDHEX$$

	this.text = ''
	this.setfocus()
	return -1
end if 

//==================================================
// $$HEX6$$6fb8b8d2200088bc38d62000$$ENDHEX$$
//==================================================
	SELECT  F_GET_LOT_NO_FROM_BARCODE (:lvs_our_barcode ) 
	INTO :lvs_lot_no
	FROM DUAL ; 
	
	IF F_SQL_CHECK() < 0 THEN 
		this.text = ''
		this.setfocus()
	END IF 	 

if lvs_lot_no = ''  then 
	this.text = ''
	this.setfocus()
	return -1
end if 


			 SELECT COUNT(*) 
				 INTO :LVI_COUNT 
				FROM  IM_ITEM_BAKING_MASTER 
			 WHERE ITEM_CODE = :LVS_ITEM_CODE
				  AND LOT_NO = :LVS_LOT_NO
				 AND OUTPUT_SCAN_DATE IS NULL
				 AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID
				 AND CHAMBER_TYPE       = :ivs_chamber_type;
				
			IF F_SQL_CHECK() < 0 THEN 
				RETURN 
			END IF 
			
			//==================================		
			//$$HEX17$$54cc84bc200085c7e0ac200074c725b874c7200074c7f8bb200074c8acc768d52000$$ENDHEX$$
			//==================================
			 IF ( LVI_COUNT > 0 )THEN 
				
		           f_play_sound("$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav")
			       F_MSG( '$$HEX13$$74c7f8bb200085c7e0ac1cb4200090c7acc7200085c7c8b2e4b2$$ENDHEX$$.' , 'P' )
				  RETURN
			 
	   	      END IF
				

  // ------------------------------------------------------------------------
  //   $$HEX6$$14bc54cfdcb4200055d678c7$$ENDHEX$$
  // -----------------------------------------------------------------------
  //   where receipt_compare_yn = 'Y'
  //      and issue_compare_yn    = 'Y'
  //      and reel_destroy_yn        = 'Y'
  // ------------------------------------------------------------------------
   
   LVI_COUNT = 0 
	
   SELECT count(*)
       INTO :LVI_COUNT
     FROM im_item_receipt_barcode
   WHERE item_barcode  =  :lvs_our_barcode    
       AND organization_id = 1;
		 
   IF F_SQL_CHECK() < 0 THEN 
	  RETURN 
   END IF 
			
   IF ( LVI_COUNT = 0 ) THEN 
				
        f_play_sound("$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav")
        F_MSG('Invalid barcode, check it barcode plz.', 'P' )
	   RETURN
			 
   END IF
				
  // ------------------------------------------------------------------------
  //   $$HEX7$$85c7e0acecc580bd200055d678c7$$ENDHEX$$
  // ------------------------------------------------------------------------  
  
   SELECT count(*)
       INTO :LVI_COUNT
     FROM im_item_receipt_barcode
    WHERE item_barcode       = :lvs_our_barcode    
      AND receipt_compare_yn = 'Y'  
      AND organization_id        = 1;
		
   IF F_SQL_CHECK() < 0 THEN 
	  RETURN 
   END IF 
			
   IF ( LVI_COUNT = 0 ) THEN 
				
        f_play_sound("$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav")
        F_MSG('Not receipt barcode, check it barcode plz.(1)', 'P' )
	   RETURN
			 
   END IF
	
  // ------------------------------------------------------------------------
  //   $$HEX7$$98d330aeecc580bd200055d678c7$$ENDHEX$$
  // ------------------------------------------------------------------------  
  
   SELECT count(*)
        into :LVI_COUNT
     FROM im_item_receipt_barcode
    WHERE item_barcode              = :lvs_our_barcode    
      AND NVL(reel_destroy_yn,'N') = 'Y'  
      AND organization_id              = 1;

   IF F_SQL_CHECK() < 0 THEN 
	  RETURN 
   END IF 
			
   IF ( LVI_COUNT > 0 ) THEN 
				
        f_play_sound("$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav")
        F_MSG('Aready Destroy barcode, check it barcode plz.(2)', 'P' )
	   RETURN
			 
   END IF
      
   //--------------------------------------------------------------------
   // $$HEX13$$85c7e0ac200060d52000c9b0a5c7e0ac20003dcce0ac55d678c7$$ENDHEX$$
   //--------------------------------------------------------------------
   
   select count(*)
     into :LVI_COUNT
     from imcn_machine
    where machine_type in DECODE(:ivs_chamber_type, 'B', 'BAKING', 'V', 'VACUUM', 'D', 'DEHUMIDIFY')
      and machine_code = :LVS_CHAMBER_CODE;

    IF F_SQL_CHECK() < 0 THEN 
	  RETURN 
   END IF 
			
   IF ( LVI_COUNT = 0 ) THEN 
				
        f_play_sound("$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav")
        F_MSG('nvalid chamber code, Check it Plz.', 'P' )
	   RETURN
			 
   END IF	
			
//===============================================
// $$HEX18$$74c7f8bb2000e4b4b4c500ac200088c794b22000c1c0dcd078c7c0c9200070c88cd62000$$ENDHEX$$
//  
//===============================================
if rb_receipt.checked = true then 
	
			LVI_COUNT = 0 
			
			 SELECT COUNT(*) 
				 INTO :LVI_COUNT 
				FROM  IM_ITEM_BAKING_MASTER 
			 WHERE ITEM_CODE = :LVS_ITEM_CODE
				  AND LOT_NO = :LVS_LOT_NO
				 AND OUTPUT_SCAN_DATE IS NULL
				 AND ORGANIZATION_ID   = :GVI_ORGANIZATION_ID;
				
			IF F_SQL_CHECK() < 0 THEN 
				RETURN 
			END IF 
			
			//==================================		
			//$$HEX17$$54cc84bc200085c7e0ac200074c725b874c7200074c7f8bb200074c8acc768d52000$$ENDHEX$$
			//==================================
			 IF ( LVI_COUNT > 0 ) THEN 
				
		           f_play_sound("$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav")
			      F_MSG( 'Already Receipt.(1)' , 'P' )
			      RETURN
			   
			END IF
					
			      LVI_COUNT = 0 
			
		   	      SELECT COUNT(*) 
				     INTO :LVI_COUNT 
			   	    FROM  IM_ITEM_BAKING_MASTER 
			      WHERE ITEM_CODE = :LVS_ITEM_CODE
				       AND LOT_NO = :LVS_LOT_NO
				       AND OUTPUT_SCAN_DATE IS NULL
				       AND ORGANIZATION_ID   = :GVI_ORGANIZATION_ID
				       AND CHAMBER_TYPE       = :ivs_chamber_type
					  AND  CHAMBER_CODE       = :LVS_CHAMBER_CODE;
				
			      IF F_SQL_CHECK() < 0 THEN 
				     RETURN 
			      END IF 
			
			//==================================		
			// $$HEX17$$54cc84bc200085c7e0ac200074c725b874c7200074c7f8bb200074c8acc768d52000$$ENDHEX$$
			//==================================
			      IF ( LVI_COUNT > 0 ) THEN 
				
		                 f_play_sound("$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav")
			            F_MSG( 'Already Receipt.(2)' , 'P' )
			            RETURN
					
			      END IF	
					
					
					
   //------------------------------------------------------------------------
   // $$HEX11$$85c8ccb81cb4200090c7acc778c7c0c9200055d678c7$$ENDHEX$$
   //------------------------------------------------------------------------

	              select count(*) 
                    INTO :LVI_COUNT 
                    from im_item_receipt_barcode a
                  where reel_destroy_yn = 'Y'
                      and item_barcode    = :lvs_our_barcode ;
       
			      IF ( LVI_COUNT > 0 ) THEN 
				
		                 f_play_sound("$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav")
			            F_MSG( '$$HEX12$$74c7f8bb2000d0d330ae1cb4200090c7acc785c7c8b2e4b2$$ENDHEX$$' , 'P' )
			            RETURN
					
			      END IF	     
   
  
   //------------------------------------------------------------------------
   // $$HEX17$$c8b9b4c630d130aed0c52000a5c729cc1cb4200090c7acc778c7c0c9200055d678c7$$ENDHEX$$
   //------------------------------------------------------------------------

                   select count(*)
                     INTO :LVI_COUNT
                     from ib_product_plandata 
                   where active_yn    ='Y'
                       and item_barcode = :lvs_our_barcode;
       
			      IF ( LVI_COUNT > 0 ) THEN 
				
		                 f_play_sound("$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav")
			            F_MSG( '$$HEX15$$c8b9b4c630d130aed0c52000a5c729cc1cb4200090c7acc785c7c8b2e4b2$$ENDHEX$$' , 'P' )
			            RETURN
					
			      END IF	
	 
	 
					
			//==================================		
			// $$HEX6$$70b374c7c0d02000f1b45db8$$ENDHEX$$
			//==================================					
					
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
						  "LAST_MODIFY_BY",
						  "CHAMBER_TYPE",
						 "CHAMBER_LOCATION"
						)  
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
								  :gvs_user_id,
								  :ivs_chamber_type,
								  :lvs_chamber_location
							 )  ;
			
					IF F_SQL_CHECK() < 0 THEN 
						RETURN 
					END IF 
					
						//===============================================
						// $$HEX13$$54cc84bcc0d085c774c72000a0bc74c7b9d0200074c774ba2000$$ENDHEX$$MSL $$HEX6$$bdacfcacdcc204ac44c72000$$ENDHEX$$reset
						//===============================================
						
					IF ( ivs_chamber_type = 'B' ) THEN  
							
				   		      update im_item_receipt_barcode 
							        set msl_remain_time =  msl_passed_time  , 
								//	    msl_passed_time = 0.01  ,   // $$HEX4$$9ccde0acdcc22000$$ENDHEX$$reset $$HEX8$$58d5c4b35db8200018c215c820002000$$ENDHEX$$// 0 $$HEX31$$7cc7bdacb0c6200090c7acc7a5c729cc200074c725b844c7200094cd01c858d530aed0c5200074c77cb920008cd63cd57cb9200004c774d52000c0c915c8$$ENDHEX$$
									    baking_start_date = sysdate  , 
								   	    baking_end_date = null ,
									    MSL_OPEN_DATE = null
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
									
					  ELSEIF ( ivs_chamber_type = 'V' ) THEN
							
                                 update im_item_receipt_barcode 
							        set msl_passed_time = NVL(MSL_PASSED_TIME,0) + ((SYSDATE - NVL(MSL_OPEN_DATE,SYSDATE)) * 24),
									    MSL_OPEN_DATE      = null,
									    vacuum_start_date = sysdate  , 
								   	    vacuum_end_date = sysdate  // $$HEX14$$85c7e0ac40c62000d9b3dcc2d0c520009ccde0ac200098ccacb92000$$ENDHEX$$
						       where item_code = :lvs_item_code
							      and lot_no = :lvs_lot_no
							      and organization_id = :gvi_organization_id ;
							
						        if f_sql_check() < 0 then 
							      return 
						        end if 
						
						        update im_item_inventory 
							         set vacuum_date = sysdate 
						         where item_code = :lvs_item_code
							        and material_mfs = :lvs_lot_no
							        and organization_id = :gvi_organization_id ;
							
					   	         if f_sql_check() < 0 then 
							        return 
						         end if 
									
					   ELSEIF ( ivs_chamber_type = 'D' ) THEN
							
							       update im_item_receipt_barcode 
							        set msl_passed_time = NVL(MSL_PASSED_TIME,0) + ((SYSDATE - NVL(MSL_OPEN_DATE,SYSDATE)) * 24),
									    MSL_OPEN_DATE      = null,
									    dehumidify_start_date = sysdate  , 
								   	    dehumidify_end_date = null 
						       where item_code = :lvs_item_code
							      and lot_no = :lvs_lot_no
							      and organization_id = :gvi_organization_id ;
							
						        if f_sql_check() < 0 then 
							      return 
						        end if 
						
						        update im_item_inventory 
							         set dehumidify_date = sysdate 
						         where item_code = :lvs_item_code
							        and material_mfs = :lvs_lot_no
							        and organization_id = :gvi_organization_id ;
							
					   	         if f_sql_check() < 0 then 
							        return 
						         end if 
			
					    END IF
					
else

		LVI_COUNT = 0 
		
		 SELECT COUNT(*) 
			 INTO :LVI_COUNT 
			FROM  IM_ITEM_BAKING_MASTER 
		 WHERE ITEM_CODE = :LVS_ITEM_CODE
			  AND LOT_NO = :LVS_LOT_NO
			  AND OUTPUT_SCAN_DATE IS NULL
			  AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID;
			
		IF F_SQL_CHECK() < 0 THEN 
			RETURN 
		END IF 
		
	     IF ( LVI_COUNT = 0 ) THEN 
				
                f_play_sound("$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav")
                F_MSG('Not Receipt State, check it plz.(1)', 'P' )
	           RETURN
			 
         END IF	
	
		 SELECT COUNT(*) 
			 INTO :LVI_COUNT 
			FROM  IM_ITEM_BAKING_MASTER 
		 WHERE ITEM_CODE = :LVS_ITEM_CODE
			  AND LOT_NO = :LVS_LOT_NO
			  AND OUTPUT_SCAN_DATE IS NULL
			  AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID
			  AND CHAMBER_TYPE       = :ivs_chamber_type
		      AND  CHAMBER_CODE       = :LVS_CHAMBER_CODE;
			
		IF F_SQL_CHECK() < 0 THEN 
			RETURN 
		END IF 
		
	     IF ( LVI_COUNT = 0 ) THEN 
				
                f_play_sound("$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav")
                F_MSG('Not Receipt State, check it plz.(2)', 'P' )
	           RETURN
			 
		ELSE		

//==================================		
//$$HEX17$$54cc84bc200085c7e0ac200074c725b874c7200074c7f8bb200074c8acc768d52000$$ENDHEX$$
//$$HEX6$$74c7f8bb200074c8acc768d5$$ENDHEX$$. $$HEX6$$9ccde0ac200098ccacb92000$$ENDHEX$$
//==================================
				
						UPDATE  IM_ITEM_BAKING_MASTER 
						      SET OUTPUT_SCAN_DATE = SYSDATE 
						 WHERE ITEM_CODE = :LVS_ITEM_CODE
							  AND LOT_NO = :LVS_LOT_NO
							 AND OUTPUT_SCAN_DATE IS NULL
							 AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
						     AND CHAMBER_TYPE     = :ivs_chamber_type
					         AND CHAMBER_CODE     = :LVS_CHAMBER_CODE;
							
							IF F_SQL_CHECK() < 0 THEN 
								RETURN 
							END IF 
							
				
						//===============================================
						// $$HEX13$$54cc84bcc0d085c774c72000a0bc74c7b9d0200074c774ba2000$$ENDHEX$$MSL $$HEX6$$bdacfcacdcc204ac44c72000$$ENDHEX$$reset
						//===============================================
						
						IF ( ivs_chamber_type = 'B' ) THEN		
							
						       update im_item_receipt_barcode 
							        set baking_end_date = sysdate ,
									    msl_passed_time = 0.01        // 0 $$HEX31$$7cc7bdacb0c6200090c7acc7a5c729cc200074c725b844c7200094cd01c858d530aed0c5200074c77cb920008cd63cd57cb9200004c774d52000c0c915c8$$ENDHEX$$
					  	        where item_code = :lvs_item_code
							       and lot_no = :lvs_lot_no
							       and organization_id = :gvi_organization_id ;
							
						       if f_sql_check() < 0 then 
							     return 
						       end if 	
								 
						ELSEIF ( ivs_chamber_type = 'V' ) THEN		
							
						       update im_item_receipt_barcode 
							        set vacuum_end_date = sysdate 
					  	        where item_code = :lvs_item_code
							       and lot_no = :lvs_lot_no
							       and organization_id = :gvi_organization_id ;
							
						       if f_sql_check() < 0 then 
							     return 
						       end if 	
								 
						ELSEIF ( ivs_chamber_type = 'D' ) THEN		
							
						       update im_item_receipt_barcode 
							        set  MSL_OPEN_DATE = sysdate,
                                             dehumidify_end_date = sysdate 
					  	        where item_code = :lvs_item_code
							       and lot_no = :lvs_lot_no
							       and organization_id = :gvi_organization_id ;
							
						       if f_sql_check() < 0 then 
							     return 
						       end if 									 
						
					    END IF
		
			end if 

end if 

f_play_sound("$$HEX4$$00c8a5c731c1f5ac$$ENDHEX$$.wav")
f_msgbox(197) //$$HEX12$$15c8c1c0200098ccacb9200018b4c8c5b5c2c8b2e4b22000$$ENDHEX$$

commit ;

this.text = ''
this.setfocus( )
		
end event

event getfocus;call super::getfocus;this.selecttext( 1 , len( this.text) )
this.Borderstyle = styleraised!
end event

event losefocus;call super::losefocus;this.Borderstyle = styleLowered!
end event

type st_3 from so_statictext within w_mat_baking_dehumi_scan_master
integer x = 2405
integer y = 92
integer width = 690
integer height = 72
boolean bringtotop = true
integer weight = 700
long textcolor = 255
string text = "Barcode"
end type

type sle_chamber_code from so_singlelineedit within w_mat_baking_dehumi_scan_master
integer x = 1335
integer y = 172
integer width = 411
integer height = 84
integer taborder = 10
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

type st_chamber_code from so_statictext within w_mat_baking_dehumi_scan_master
integer x = 1335
integer y = 92
integer width = 411
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 255
string text = "Chamber Code"
end type

type rb_receipt from so_radiobutton within w_mat_baking_dehumi_scan_master
integer x = 763
integer y = 92
integer width = 439
boolean bringtotop = true
string text = "Receipt (Start)"
boolean checked = true
end type

event clicked;call super::clicked;
ivs_txn_type = 'R'
end event

event constructor;call super::constructor;
ivs_txn_type = 'R'
end event

type rb_issue from so_radiobutton within w_mat_baking_dehumi_scan_master
integer x = 763
integer y = 188
integer width = 439
boolean bringtotop = true
string text = "Issue (End)"
end type

event clicked;call super::clicked;
ivs_txn_type = 'I'
end event

type rb_backing from so_radiobutton within w_mat_baking_dehumi_scan_master
integer x = 78
integer y = 64
boolean bringtotop = true
string text = "Baking"
boolean checked = true
end type

event clicked;call super::clicked;
ivs_chamber_type = 'B'
 dw_1.title = 'Baking list'
end event

event constructor;call super::constructor;
 ivs_chamber_type = 'B'
 dw_1.title = 'Baking list'
end event

type rb_dehumi from so_radiobutton within w_mat_baking_dehumi_scan_master
integer x = 78
integer y = 200
boolean bringtotop = true
string text = "Dehumidification"
end type

event clicked;call super::clicked;
ivs_chamber_type = 'D'
 dw_1.title = 'Dehumidification list'
end event

type st_5 from so_statictext within w_mat_baking_dehumi_scan_master
integer x = 1760
integer y = 92
integer width = 503
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 255
string text = "Location"
end type

type sle_location from so_singlelineedit within w_mat_baking_dehumi_scan_master
integer x = 1755
integer y = 172
integer width = 517
integer height = 84
integer taborder = 20
boolean bringtotop = true
end type

event losefocus;call super::losefocus;this.Borderstyle = styleLowered!
end event

event getfocus;call super::getfocus;this.selecttext( 1 , len( this.text) )
this.Borderstyle = styleraised!
end event

type rb_vacuum from so_radiobutton within w_mat_baking_dehumi_scan_master
integer x = 78
integer y = 128
boolean bringtotop = true
string text = "Vacuum Packing"
end type

event clicked;call super::clicked;
ivs_chamber_type = 'V'
 dw_1.title = 'Vacuum Packing list'
end event

type gb_1 from so_groupbox within w_mat_baking_dehumi_scan_master
integer x = 3305
integer width = 2958
integer height = 304
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_mat_baking_dehumi_scan_master
integer x = 690
integer width = 581
integer height = 304
string text = "Txn type"
end type

type gb_3 from so_groupbox within w_mat_baking_dehumi_scan_master
integer x = 1289
integer width = 1998
integer height = 304
string text = "Process"
end type

type gb_6 from so_groupbox within w_mat_baking_dehumi_scan_master
integer x = 5
integer width = 667
integer height = 304
string text = "Category"
end type

