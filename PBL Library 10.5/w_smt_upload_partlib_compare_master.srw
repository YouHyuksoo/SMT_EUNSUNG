HA$PBExportHeader$w_smt_upload_partlib_compare_master.srw
$PBExportComments$$$HEX4$$ddc0b0c0c4ac8dd6$$ENDHEX$$
forward
global type w_smt_upload_partlib_compare_master from w_main_root
end type
type st_3 from so_statictext within w_smt_upload_partlib_compare_master
end type
type cb_1 from commandbutton within w_smt_upload_partlib_compare_master
end type
type sle_lot_name from so_singlelineedit within w_smt_upload_partlib_compare_master
end type
type mle_2 from so_multilineedit within w_smt_upload_partlib_compare_master
end type
type ddlb_line_code from uo_line_code within w_smt_upload_partlib_compare_master
end type
type cb_2 from commandbutton within w_smt_upload_partlib_compare_master
end type
type st_status from so_statictext within w_smt_upload_partlib_compare_master
end type
type cb_4 from commandbutton within w_smt_upload_partlib_compare_master
end type
type sle_filename from so_singlelineedit within w_smt_upload_partlib_compare_master
end type
type cb_3 from so_commandbutton within w_smt_upload_partlib_compare_master
end type
type rb_cm from so_radiobutton within w_smt_upload_partlib_compare_master
end type
type rb_npm from so_radiobutton within w_smt_upload_partlib_compare_master
end type
type rb_bm from so_radiobutton within w_smt_upload_partlib_compare_master
end type
type uo_item from uo_item_code within w_smt_upload_partlib_compare_master
end type
type st_5 from so_statictext within w_smt_upload_partlib_compare_master
end type
type ddlb_part_type from uo_basecode within w_smt_upload_partlib_compare_master
end type
type st_1 from so_statictext within w_smt_upload_partlib_compare_master
end type
type sle_work_no from so_singlelineedit within w_smt_upload_partlib_compare_master
end type
type cb_5 from commandbutton within w_smt_upload_partlib_compare_master
end type
type st_2 from so_statictext within w_smt_upload_partlib_compare_master
end type
type dw_6 from so_datawindow within w_smt_upload_partlib_compare_master
end type
type dw_7 from so_datawindow within w_smt_upload_partlib_compare_master
end type
type cb_6 from commandbutton within w_smt_upload_partlib_compare_master
end type
type dw_8 from so_datawindow within w_smt_upload_partlib_compare_master
end type
type dw_9 from so_datawindow within w_smt_upload_partlib_compare_master
end type
type pb_debug from picturebutton within w_smt_upload_partlib_compare_master
end type
type ddlb_is_new_yn from so_dropdownlistbox within w_smt_upload_partlib_compare_master
end type
type st_4 from so_statictext within w_smt_upload_partlib_compare_master
end type
type ddlb_mounter_model_type from uo_basecode within w_smt_upload_partlib_compare_master
end type
type st_6 from so_statictext within w_smt_upload_partlib_compare_master
end type
type st_7 from so_statictext within w_smt_upload_partlib_compare_master
end type
type cbx_masteryn from so_checkbox within w_smt_upload_partlib_compare_master
end type
type uo_dateset from uo_ymdh_calendar within w_smt_upload_partlib_compare_master
end type
type uo_dateend from uo_ymdh_calendar within w_smt_upload_partlib_compare_master
end type
type gb_1 from so_groupbox within w_smt_upload_partlib_compare_master
end type
type gb_3 from so_groupbox within w_smt_upload_partlib_compare_master
end type
end forward

global type w_smt_upload_partlib_compare_master from w_main_root
integer width = 6185
integer height = 2804
string title = "Plan Master"
windowstate windowstate = maximized!
st_3 st_3
cb_1 cb_1
sle_lot_name sle_lot_name
mle_2 mle_2
ddlb_line_code ddlb_line_code
cb_2 cb_2
st_status st_status
cb_4 cb_4
sle_filename sle_filename
cb_3 cb_3
rb_cm rb_cm
rb_npm rb_npm
rb_bm rb_bm
uo_item uo_item
st_5 st_5
ddlb_part_type ddlb_part_type
st_1 st_1
sle_work_no sle_work_no
cb_5 cb_5
st_2 st_2
dw_6 dw_6
dw_7 dw_7
cb_6 cb_6
dw_8 dw_8
dw_9 dw_9
pb_debug pb_debug
ddlb_is_new_yn ddlb_is_new_yn
st_4 st_4
ddlb_mounter_model_type ddlb_mounter_model_type
st_6 st_6
st_7 st_7
cbx_masteryn cbx_masteryn
uo_dateset uo_dateset
uo_dateend uo_dateend
gb_1 gb_1
gb_3 gb_3
end type
global w_smt_upload_partlib_compare_master w_smt_upload_partlib_compare_master

type variables
string LVS_LINE_CODE , LVS_MACHINE_TYPE, LVS_QUERY = 'Y'
end variables

forward prototypes
public function integer wf_panasonic ()
public function integer wf_panasonic_npm ()
public function integer wf_panasonic_bm ()
end prototypes

public function integer wf_panasonic ();integer li_FileNum , li_eof , li_eof2 , lvi_loop
string is_filename , is_fullname , ls_text

string lvs_n ,lvs_item_id , lvs_plan_date , lvs_lot_name , lvs_pa , lvs_pb
string lvs_partname1 ,  lvs_chipname , lvs_chipname1 , lvs_partname2 , lvs_chipname2 , lvs_table  , lvs_address
int i , row , lvi_item_unit_qty

//=============================================
//
//=============================================

	is_fullname =sle_filename.text 
	if is_fullname  = '' or isnull(is_fullname) then 
		return  -1 
	end if 
	
		li_FileNum = FileOpen (is_fullname, LineMode!)
		
		//=========================================
		//
		//=========================================
		delete from ib_mnt_partslib ;
		if sqlca.sqlcode < 0 then 
			
			MESSAGEBOX("ERROR" , SQLCA.SQLerrtext )
			rollback;
			return -1
		end if 

		
		delete from ib_mnt_chipdata ;
		if sqlca.sqlcode < 0 then 
			MESSAGEBOX("ERROR" , SQLCA.SQLerrtext )
			rollback;
			return -1
		end if 
		
		
		//=========================================
		//
		//=========================================
		
		do
			li_eof = FileReadEx (li_FileNum, ls_text ) 
		
		//===========================================================================
		// [LotNames]
		//===========================================================================
			if ls_text = '[LotNames]' then
				
				li_eof = FileReadEx (li_FileNum, ls_text )  //$$HEX6$$c0d074c7c0d2200009000900$$ENDHEX$$
				li_eof2 = FileReadEx (li_FileNum, ls_text )  //$$HEX6$$6fb8b8d270b374c7c0d02000$$ENDHEX$$
				
				lvs_lot_name = f_replace_string ( mid( ls_text , 1 , pos( ls_text , ' ') -1 ) , '"' , '')
				sle_lot_name.text =lvs_lot_name 
				
			end if 

		//===========================================================================
		// [ChipData]
		//===========================================================================
			if ls_text = '[ChipData]' then
				
				li_eof = FileReadEx (li_FileNum, ls_text )  //$$HEX4$$c0d074c7c0d22000$$ENDHEX$$
				
				li_eof2 = FileReadEx (li_FileNum, ls_text )
				
				do while ( mid(ls_text , 1 ,1) <> '[' and li_eof2 <> 0 )
		
					mle_2.text = mle_2.text + ls_text+"~r~n"
					
					dw_6.importstring( f_replace_string( ls_text ,' ' , '~t' ) +"~t"+string(today() ,'yyyymmdd')+"~t"+lvs_lot_name )
					li_eof2 = FileReadEx (li_FileNum, ls_text )	
				loop  ;
				
			end if 		
		
		
		//===========================================================================
		// [ib_mnt_positiondata]
		//===========================================================================
			
			if ls_text = '[PartsLIB]' then
				
				li_eof = FileReadEx (li_FileNum, ls_text )  //$$HEX4$$c0d074c7c0d22000$$ENDHEX$$
				
				li_eof2 = FileReadEx (li_FileNum, ls_text )
				
				do while ( mid(ls_text , 1 ,1) <> '[' and li_eof2 <> 0 )
		
					mle_2.text = mle_2.text + ls_text+"~r~n"
					
					dw_7.importstring( f_replace_string( ls_text ,' ' , '~t' ) +"~t"+string(today() ,'yyyymmdd')+"~t"+lvs_lot_name )
					li_eof2 = FileReadEx (li_FileNum, ls_text )	
				loop  ;
				
			end if 
			
		loop until li_eof = -100
		
		
		//===========================================================================
		//
		//===========================================================================
		FileClose (li_FileNum)  
		
		//===========================================================================
		//
		//===========================================================================
		if dw_6.update()  < 0 then 
			return -1 
		end if 
		if dw_7.update() < 0 then 
			return -1 
		end if 

		commit ;

		dw_6.sort( )
		

FileClose (li_FileNum)  
return 1
end function

public function integer wf_panasonic_npm ();integer li_FileNum , li_eof , li_eof2 , lvi_loop
string is_filename , is_fullname , ls_text

string lvs_n ,lvs_item_id , lvs_plan_date , lvs_lot_name , lvs_pa , lvs_pb
string lvs_partname1 ,  lvs_chipname , lvs_chipname1 , lvs_partname2 , lvs_chipname2 , lvs_table  , lvs_address
int i , row , lvi_item_unit_qty

//=============================================
//
//=============================================

	is_fullname =sle_filename.text 
	if is_fullname  = '' or isnull(is_fullname) then 
		return  -1 
	end if 
	
		li_FileNum = FileOpen (is_fullname, LineMode!)
		
		//=========================================
		//
		//=========================================
		delete from ib_mnt_partslib_nmp ;
		if sqlca.sqlcode < 0 then 
			
			MESSAGEBOX("ERROR" , SQLCA.SQLerrtext )
			rollback;
			return -1
		end if 

		
		delete from ib_mnt_chipdata_nmp ;
		if sqlca.sqlcode < 0 then 
			MESSAGEBOX("ERROR" , SQLCA.SQLerrtext )
			rollback;
			return -1
		end if 
		
		
		//=========================================
		//
		//=========================================
		
		do
			li_eof = FileReadEx (li_FileNum, ls_text ) 
		
		//===========================================================================
		// [LotNames]
		//===========================================================================
			if ls_text = '[LotNames]' then
				
				li_eof = FileReadEx (li_FileNum, ls_text )  //$$HEX6$$c0d074c7c0d2200009000900$$ENDHEX$$
				li_eof2 = FileReadEx (li_FileNum, ls_text )  //$$HEX6$$6fb8b8d270b374c7c0d02000$$ENDHEX$$
				
				lvs_lot_name = f_replace_string ( mid( ls_text , 1 , pos( ls_text , ' ') -1 ) , '"' , '')
				sle_lot_name.text =lvs_lot_name 
				
			end if 

		//===========================================================================
		// [ChipData]
		//===========================================================================
			if ls_text = '[ChipData]' then
				
				li_eof = FileReadEx (li_FileNum, ls_text )  //$$HEX4$$c0d074c7c0d22000$$ENDHEX$$
				
				li_eof2 = FileReadEx (li_FileNum, ls_text )
				
				do while ( mid(ls_text , 1 ,1) <> '[' and li_eof2 <> 0 )
		
					mle_2.text = mle_2.text + ls_text+"~r~n"
					
					dw_8.importstring( f_replace_string( ls_text ,' ' , '~t' ) +"~t"+string(today() ,'yyyymmdd')+"~t"+lvs_lot_name )
					li_eof2 = FileReadEx (li_FileNum, ls_text )	
				loop  ;
				
			end if 		
		
		
		//===========================================================================
		// [ib_mnt_positiondata]
		//===========================================================================
			
			if ls_text = '[PartsData]' then
				
				li_eof = FileReadEx (li_FileNum, ls_text )  //$$HEX4$$c0d074c7c0d22000$$ENDHEX$$
				
				li_eof2 = FileReadEx (li_FileNum, ls_text )
				
				do while ( mid(ls_text , 1 ,1) <> '[' and li_eof2 <> 0 )
		
					mle_2.text = mle_2.text + ls_text+"~r~n"
					
					dw_9.importstring( f_replace_string( ls_text ,' ' , '~t' ) +"~t"+string(today() ,'yyyymmdd')+"~t"+lvs_lot_name )
					li_eof2 = FileReadEx (li_FileNum, ls_text )	
				loop  ;
				
			end if 
			
		loop until li_eof = -100
		
		
		//===========================================================================
		//
		//===========================================================================
		FileClose (li_FileNum)  
		
		//===========================================================================
		//
		//===========================================================================
		if dw_8.update()  < 0 then 
			return -1 
		end if 
		if dw_9.update() < 0 then 
			return -1 
		end if 

		commit ;

		dw_6.sort( )
		

FileClose (li_FileNum)  
return 1
end function

public function integer wf_panasonic_bm ();integer li_FileNum , li_eof , li_eof2 , lvi_loop
string is_filename , is_fullname , ls_text

string lvs_n ,lvs_item_id , lvs_plan_date , lvs_lot_name , lvs_pa , lvs_pb
string lvs_partname1 ,  lvs_chipname , lvs_chipname1 , lvs_partname2 , lvs_chipname2 , lvs_table  , lvs_address
int i , row , lvi_item_unit_qty, i_count

string lvs_partname, lvs_vision_code , lvs_l1w1, lvs_speed_detact, lvs_speed_pickup_mount, lvs_feedpitch, lvs_reelsize
//=============================================
//
//=============================================
 i_count = 0 
 
 
	is_fullname =sle_filename.text 
	if is_fullname  = '' or isnull(is_fullname) then 
		return  -1 
	end if 
	
		li_FileNum = FileOpen (is_fullname, LineMode!)
		
		//=========================================
		// $$HEX3$$30ae74c82000$$ENDHEX$$BM $$HEX13$$84c7dcc2200000c8a5c720000cd37cc72000adc01cc8200068d5$$ENDHEX$$
		//=========================================
		delete from ib_mnt_partslib_bm ;
		if sqlca.sqlcode < 0 then
			MESSAGEBOX("ERROR" , SQLCA.SQLerrtext )
			rollback;
			return -1
		end if 
		
		//=========================================
		//
		//=========================================
		
		do
			li_eof = FileReadEx (li_FileNum, ls_text ) 
		
		//===========================================================================
		// [LotNames]
		//===========================================================================
			if ls_text = '%PARTS' then
				
				//$$HEX5$$e4b24cc720005cd504c9$$ENDHEX$$
				li_eof = FileReadEx (li_FileNum, ls_text )  //$$HEX8$$0cd3b8d224b184c72000200009000900$$ENDHEX$$
			    
				lvs_partname = ls_text //f_replace_string ( mid( ls_text , 1 , pos( ls_text , ' ') -1 ) , '"' , '')
				
			elseif ls_text = '&SIZE' then 
				
				//$$HEX5$$e4b24cc720005cd504c9$$ENDHEX$$
				li_eof = FileReadEx (li_FileNum, ls_text )  //VISION CODE 
				lvs_vision_code =  ls_text  //f_replace_string ( mid( ls_text , 1 , pos( ls_text , ' ') -1 ) , '"' , '')
				
				li_eof = FileReadEx (li_FileNum, ls_text )  //L1 W1 
				lvs_l1w1          =  ls_text //f_replace_string ( mid( ls_text , 1 , pos( ls_text , ' ') -1 ) , '"' , '')
				 
				//messagebox(lvs_vision_code, lvs_l1w1) 
				
		    	elseif ls_text = '&MCMOVE' then 
			    //$$HEX5$$e4b24cc720005cd504c9$$ENDHEX$$
				li_eof = FileReadEx (li_FileNum, ls_text )  //SPEED Detact  	
				lvs_speed_detact           = 	 ls_text //f_replace_string ( mid( ls_text , 1 , pos( ls_text , ' ') -1 ) , '"' , '')
				//$$HEX6$$e4b24cc720005cd504c92000$$ENDHEX$$
				li_eof = FileReadEx (li_FileNum, ls_text )  //SPEED Mount 
				lvs_speed_pickup_mount	=   ls_text //f_replace_string ( mid( ls_text , 1 , pos( ls_text , ' ') -1 ) , '"' , '')
	
		     elseif ls_text = '&SUPPLY' then 
				 //$$HEX5$$e4b24cc720005cd504c9$$ENDHEX$$
		
				
				li_eof = FileReadEx (li_FileNum, ls_text )  //
				lvs_feedpitch                 = 	 ls_text //f_replace_string ( mid( ls_text , 1 , pos( ls_text , ' ') -1 ) , '"' , '')
				//lvs_reelsize                   = 	 f_replace_string ( mid( ls_text , 1 , pos( ls_text , ' ') -1 ) , '"' , '')
				
				
			elseif ls_text = '#PATTERN02' then //$$HEX4$$c8b9c0c9c9b92000$$ENDHEX$$
		        // $$HEX12$$5cd504c920007dc7e0ac2000200000c8a5c7200058d538c1$$ENDHEX$$.. 
				INSERT INTO IB_MNT_PARTSLIB_BM (  
						partname, 
						vision_code, 
						size_l, 
						size_w, 
						speed_detact, 
						speed_mount, 
						speed_pickup, 
						material_feeder_pitch, 
						material_reel_size
								
				 )  values ( 
				         :lvs_partname, 
					    :lvs_vision_code, 
						:lvs_l1w1, 
						:lvs_l1w1, 
						:lvs_speed_detact, 
						:lvs_speed_pickup_mount, 
						:lvs_speed_pickup_mount, 
						:lvs_feedpitch, 
						:lvs_feedpitch
							
				 ) ; 
				 
				 
				 
				 
				 if sqlca.sqlcode < 0 then
					MESSAGEBOX("ERROR" , SQLCA.SQLerrtext )
					rollback;
					return -1
				end if 
				 
				 commit ; 
				 
				 i_count ++ 
			end if 

		loop until li_eof = -100
		
	ST_STATUS.TEXT =string(i_count) + f_msg(' $$HEX4$$74ac2000bdc085c7$$ENDHEX$$','S')
FileClose (li_FileNum)  
return 1
end function

on w_smt_upload_partlib_compare_master.create
int iCurrent
call super::create
this.st_3=create st_3
this.cb_1=create cb_1
this.sle_lot_name=create sle_lot_name
this.mle_2=create mle_2
this.ddlb_line_code=create ddlb_line_code
this.cb_2=create cb_2
this.st_status=create st_status
this.cb_4=create cb_4
this.sle_filename=create sle_filename
this.cb_3=create cb_3
this.rb_cm=create rb_cm
this.rb_npm=create rb_npm
this.rb_bm=create rb_bm
this.uo_item=create uo_item
this.st_5=create st_5
this.ddlb_part_type=create ddlb_part_type
this.st_1=create st_1
this.sle_work_no=create sle_work_no
this.cb_5=create cb_5
this.st_2=create st_2
this.dw_6=create dw_6
this.dw_7=create dw_7
this.cb_6=create cb_6
this.dw_8=create dw_8
this.dw_9=create dw_9
this.pb_debug=create pb_debug
this.ddlb_is_new_yn=create ddlb_is_new_yn
this.st_4=create st_4
this.ddlb_mounter_model_type=create ddlb_mounter_model_type
this.st_6=create st_6
this.st_7=create st_7
this.cbx_masteryn=create cbx_masteryn
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.gb_1=create gb_1
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_3
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.sle_lot_name
this.Control[iCurrent+4]=this.mle_2
this.Control[iCurrent+5]=this.ddlb_line_code
this.Control[iCurrent+6]=this.cb_2
this.Control[iCurrent+7]=this.st_status
this.Control[iCurrent+8]=this.cb_4
this.Control[iCurrent+9]=this.sle_filename
this.Control[iCurrent+10]=this.cb_3
this.Control[iCurrent+11]=this.rb_cm
this.Control[iCurrent+12]=this.rb_npm
this.Control[iCurrent+13]=this.rb_bm
this.Control[iCurrent+14]=this.uo_item
this.Control[iCurrent+15]=this.st_5
this.Control[iCurrent+16]=this.ddlb_part_type
this.Control[iCurrent+17]=this.st_1
this.Control[iCurrent+18]=this.sle_work_no
this.Control[iCurrent+19]=this.cb_5
this.Control[iCurrent+20]=this.st_2
this.Control[iCurrent+21]=this.dw_6
this.Control[iCurrent+22]=this.dw_7
this.Control[iCurrent+23]=this.cb_6
this.Control[iCurrent+24]=this.dw_8
this.Control[iCurrent+25]=this.dw_9
this.Control[iCurrent+26]=this.pb_debug
this.Control[iCurrent+27]=this.ddlb_is_new_yn
this.Control[iCurrent+28]=this.st_4
this.Control[iCurrent+29]=this.ddlb_mounter_model_type
this.Control[iCurrent+30]=this.st_6
this.Control[iCurrent+31]=this.st_7
this.Control[iCurrent+32]=this.cbx_masteryn
this.Control[iCurrent+33]=this.uo_dateset
this.Control[iCurrent+34]=this.uo_dateend
this.Control[iCurrent+35]=this.gb_1
this.Control[iCurrent+36]=this.gb_3
end on

on w_smt_upload_partlib_compare_master.destroy
call super::destroy
destroy(this.st_3)
destroy(this.cb_1)
destroy(this.sle_lot_name)
destroy(this.mle_2)
destroy(this.ddlb_line_code)
destroy(this.cb_2)
destroy(this.st_status)
destroy(this.cb_4)
destroy(this.sle_filename)
destroy(this.cb_3)
destroy(this.rb_cm)
destroy(this.rb_npm)
destroy(this.rb_bm)
destroy(this.uo_item)
destroy(this.st_5)
destroy(this.ddlb_part_type)
destroy(this.st_1)
destroy(this.sle_work_no)
destroy(this.cb_5)
destroy(this.st_2)
destroy(this.dw_6)
destroy(this.dw_7)
destroy(this.cb_6)
destroy(this.dw_8)
destroy(this.dw_9)
destroy(this.pb_debug)
destroy(this.ddlb_is_new_yn)
destroy(this.st_4)
destroy(this.ddlb_mounter_model_type)
destroy(this.st_6)
destroy(this.st_7)
destroy(this.cbx_masteryn)
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.gb_1)
destroy(this.gb_3)
end on

event activate;call super::activate;/***************************************
* $$HEX17$$08c7c4b324c115c8d0c5200000ad5cd52000acc06dd544c720004bc105d35cd5e4b2$$ENDHEX$$
*
*
****************************************/
Gst_set.window_id            = this.classname() 
Gst_set.author                  = "JiSheng"
Gst_set.creation_date      = '20051101'
Gst_set.last_modify_date = '20051101'
Gst_set.Report_window    = False  // Report Window  True / Flase

/*****************************************
* Data WIndow Property
******************************************/
Ivs_resize_type    = 'NORMAL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default

ivs_dw_1_retrice_cancel_popup_open = 'Y'
ivs_dw_2_retrice_cancel_popup_open = 'N'
ivs_dw_3_retrice_cancel_popup_open = 'N'
ivs_dw_4_retrice_cancel_popup_open = 'N'
ivs_dw_5_retrice_cancel_popup_open = 'N'

/****************************************
* Menu Property $$HEX6$$54ba74b2200078d5e4b4c1b9$$ENDHEX$$
*****************************************
* ADMIN     : ADMIN  ( $$HEX5$$04c8b4ccacc0a9c62000$$ENDHEX$$)
* $$HEX8$$00adacb9200020002000200020002000$$ENDHEX$$: MANAGE ( $$HEX8$$04c854ba74b2acc0a9c600aca5b22000$$ENDHEX$$)
* $$HEX7$$acc0a9c690c72000200020002000$$ENDHEX$$: GUEST  ( $$HEX11$$30ae08cd2000f1b45db8200070c88cd6200000aca5b2$$ENDHEX$$)
* $$HEX8$$70c88cd6200020002000200020002000$$ENDHEX$$: QUERY  ( $$HEX10$$15c8f4bc70c88cd6ccb9200000aca5b220002000$$ENDHEX$$)
* $$HEX5$$70b374c7c0d070c891c7$$ENDHEX$$: DATA_CONTROL  ( $$HEX12$$85c725b8200018c215c82000adc01cc8200024c115c82000$$ENDHEX$$)
* $$HEX7$$08b8ecd3b8d22000200020002000$$ENDHEX$$: REPORT ( $$HEX4$$08b8ecd3b8d22000$$ENDHEX$$, $$HEX5$$9ccd25b800adacb92000$$ENDHEX$$)
****************************************/

F_MENU_CONTROL('QUERY' , TRUE)  // All Data Control

/****************************************
* 
****************************************/

end event

event ue_data_control;call super::ue_data_control;String LVS_MASTER_CHK
long row

CHOOSE CASE Gvs_Ue_data_control
		
		
	CASE 'RETRIEVE'
		    IF cbx_masteryn.Checked = TRUE THEN 
	             LVS_MASTER_CHK = 'Y'
			ELSE
				LVS_MASTER_CHK= '%'
			END IF
			dw_1.retrieve( ddlb_line_code.getcode( )+'%' ,  uo_item.text( )+'%'  ,  ddlb_part_type.getcode()+'%' ,  ddlb_is_new_yn.text+'%' , ddlb_mounter_model_type.getcode( )+'%' ,  uo_dateset.text() , uo_dateend.text(),  gvi_organization_id, LVS_QUERY, LVS_MASTER_CHK  ) 
			LVS_QUERY = 'Y'	
			    
//	CASE 'INSERT'		
//		
//			ROW = dw_1.insertrow(0)
//			dw_1.scrolltorow(ROW)
//			f_set_security_row(dw_1 , ROW , 'ALL')
//			F_MSG_MDI_HELP ( F_MSG_ST(152)	 )	
//			
//			dw_1.object.master_yn[row] = 'Y'
//				
//	CASE 'APPEND' 
//		
//			ROW = dw_1.insertrow(0)
//			dw_1.scrolltorow(ROW)
//			f_set_security_row(dw_1 , ROW , 'ALL')
//			F_MSG_MDI_HELP ( F_MSG_ST(152)	 )	
//			
//			dw_1.object.master_yn[row] = 'N'
//	CASE 'DELETE' 
//		
//		 	if dw_1.getrow() < 1 then return 
//			  
//			msg =f_msgbox(1003)
//			if msg = 1 then
//				gvl_row_deleted = dw_1.getrow()			
//				dw_1.deleterow(gvl_row_deleted)		
//				dw_1.setfocus()
//				row = dw_1.getrow()
//				dw_1.scrolltorow(row)
//				dw_1.setcolumn(1)
//			end if		
//			
//	CASE 'UPDATE'
//				
//				if dw_1.update() < 0 then 
//					rollback;
//				else
//					commit ;
//				end if 
//				f_msgbox(170)
			 
	CASE ELSE
END CHOOSE
end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
st_status.width = dw_1.width 
dw_6.settransobject(sqlca)
dw_7.settransobject(sqlca)
dw_8.settransobject(sqlca)
dw_9.settransobject(sqlca)

/***********************
 debug 
***********************/
sle_lot_name.visible = false 
dw_6.visible = false 
dw_7.visible = false 
dw_8.visible = false 
dw_9.visible = false 
mle_2.visible=false 
end event

event resize;st_status.width = dw_1.width 
end event

type dw_5 from w_main_root`dw_5 within w_smt_upload_partlib_compare_master
integer y = 712
integer width = 2729
integer height = 816
boolean titlebar = true
end type

type dw_4 from w_main_root`dw_4 within w_smt_upload_partlib_compare_master
integer y = 708
integer width = 2729
integer height = 816
integer taborder = 20
boolean titlebar = true
end type

type dw_3 from w_main_root`dw_3 within w_smt_upload_partlib_compare_master
integer y = 744
integer width = 2336
integer height = 1052
integer taborder = 30
boolean titlebar = true
end type

type dw_2 from w_main_root`dw_2 within w_smt_upload_partlib_compare_master
boolean visible = false
integer y = 1636
integer width = 4978
integer height = 1052
integer taborder = 40
boolean titlebar = true
string title = "QC Issue"
end type

event dw_2::buttonclicked;call super::buttonclicked;IF dwo.name = 'b_show' then 
			
		if this.getrow() < 1 then 
			return
		end if
		
		Long Lvl_return
		String  lvs_file_name
		if this.getrow() < 1 then return 
		
		Lvl_return = f_download_qc_inspect_data ( this.object.action_date[this.getrow()] , long(this.object.notify_sequence[this.getrow()] ) )
		
		if  Lvl_return > 0 then 
		
			lvs_file_name = Gvs_default_directory+"\Temp\"+ Gst_return.gvs_return[1]
			
			IF lvs_file_name = '' OR ISNULL(lvs_file_name) THEN 
				RETURN
			END IF
			
			f_shell_execute_by_extention ( Gst_return.gvs_return[1]   , '' ,Gvs_default_directory+'\Temp'  )
		else
			
		end if
		
		Changedirectory(Gvs_default_directory)
	
	
end if 
end event

type dw_1 from w_main_root`dw_1 within w_smt_upload_partlib_compare_master
event ue_lbuttondown pbm_lbuttondown
integer y = 684
integer width = 4978
integer height = 2000
integer taborder = 50
boolean titlebar = true
string title = "ChipData"
string dataobject = "d_mnt_partlib_compare_master"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;//if currentrow < 1 then return 
//st_status.text = this.object.item_name[currentrow]+" "+this.object.item_spec[currentrow]
//
//dw_2.retrieve( this.object.partname[currentrow] , gvi_organization_id  )
end event

type uo_tabpages from w_main_root`uo_tabpages within w_smt_upload_partlib_compare_master
integer taborder = 70
end type

type st_3 from so_statictext within w_smt_upload_partlib_compare_master
integer x = 32
integer y = 72
integer width = 443
integer height = 56
boolean bringtotop = true
string text = "Line Code"
alignment alignment = right!
end type

type cb_1 from commandbutton within w_smt_upload_partlib_compare_master
integer x = 3397
integer y = 68
integer width = 375
integer height = 112
integer taborder = 110
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Generate"
end type

event clicked;LVS_LINE_CODE    = DDLB_LINE_CODE.GETCODE()

if lvs_line_code = '' or lvs_line_code = '%'  then 
     //Mes sagebox("$$HEX2$$55d678c7$$ENDHEX$$" , "$$HEX14$$7cb778c720006cad84bd44c7200020c1ddd0200058d538c194c62000$$ENDHEX$$")
	 f_msg("$$HEX14$$7cb778c720006cad84bd44c7200020c1ddd0200058d538c194c62000$$ENDHEX$$",'P') 
	return -1
end if 

if  sle_filename.text = ''  then
	 //Mes sagebox("Notify" , "$$HEX20$$98ccacb960d5200004d55cb8f8ada8b720000cd37cc744c7200020c1ddd0200058d538c194c62000$$ENDHEX$$")
	 f_msg("$$HEX20$$98ccacb960d5200004d55cb8f8ada8b720000cd37cc744c7200020c1ddd0200058d538c194c62000$$ENDHEX$$",'P') 
	 return 
end if 

msg = f_msgbox1(1161 , this.text )
if msg = 1 then 
else
	return 
end if 

	
if (rb_cm.checked ) then 
   wf_panasonic( )
elseif (rb_npm.checked) then 
   wf_panasonic_npm() 
elseif (rb_bm.checked) then 
  wf_panasonic_bm() 
end if 
	

F_MSGBOX(170)
end event

type sle_lot_name from so_singlelineedit within w_smt_upload_partlib_compare_master
integer x = 4032
integer width = 955
integer taborder = 120
boolean bringtotop = true
end type

type mle_2 from so_multilineedit within w_smt_upload_partlib_compare_master
integer x = 4032
integer y = 96
integer width = 960
integer height = 344
integer taborder = 80
boolean bringtotop = true
long textcolor = 65280
long backcolor = 0
string text = ""
boolean hscrollbar = true
boolean vscrollbar = true
boolean autohscroll = true
end type

type ddlb_line_code from uo_line_code within w_smt_upload_partlib_compare_master
integer x = 480
integer y = 56
integer width = 306
integer height = 2116
integer taborder = 150
boolean bringtotop = true
end type

type cb_2 from commandbutton within w_smt_upload_partlib_compare_master
integer x = 3397
integer y = 180
integer width = 375
integer height = 112
integer taborder = 160
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Compare"
end type

event clicked;STRING LVS_APPLY_LOCATION, LVS_PARTNAME, LVS_WORKNO, LVS_MASTER_YN, LVS_LINE_CODE2, LVS_LINE_CODE3, LVS_MACHINE_TYPE3
INT      LVI_COUNT, LVI_ROW, LVI_ROW2, LVI_ROW3

LVI_ROW   = 0
LVI_ROW2 = 0
LVI_ROW3 = 0

MSG = F_MSGBOX1(1161 , THIS.Text ) 
IF MSG = 1 THEN 
ELSE
	RETURN 
END IF

 st_status.text = "Create Data..."

 IF RB_cm.CHecked = TRUE THEN 
	LVS_MACHINE_TYPE = 'CM'
	/*********************/
	DECLARE CUR_1 CURSOR FOR
 
      SELECT '*', 	 A.PARTSNAME
        FROM IB_MNT_PARTSLIB  A, IB_MNT_CHIPDATA B	 
      WHERE A.IDNUM = B.IDNUM;
	 
	 IF F_SQL_CHECK() < 0 THEN 
		  RETURN 
	 END IF
	 
	 OPEN CUR_1 ;
	 DO
		
		
	     FETCH CUR_1  INTO :LVS_APPLY_LOCATION,        :LVS_PARTNAME;
		
		IF F_SQL_CHECK() < 0 THEN 
			CLOSE CUR_1 ;
			EXIT
		END IF
		
		IF SQLCA.SQLCODE = 100 THEN 
			CLOSE CUR_1 ;
			EXIT
		END IF
	
	     //$$HEX8$$c8b9a4c230d1200020c734bb55d678c7$$ENDHEX$$($$HEX6$$7cb778c7c4bc200080acc9c0$$ENDHEX$$)/MACHINE_CODE, LINE_CODE$$HEX5$$3cc75cb8200070c88cd6$$ENDHEX$$
	     SELECT Count(*)
	        INTO :LVI_ROW
          FROM IB_MNT_PARTLIB_MASTER  
        WHERE MACHINE_CODE    = :LVS_MACHINE_TYPE
            AND LINE_CODE           = :LVS_LINE_CODE
            AND APPLY_LOCATION  = :LVS_APPLY_LOCATION
            AND PARTNAME           = :LVS_PARTNAME
		   AND MASTER_YN         = 'Y' ;
	    
		IF LVI_ROW > 0 THEN
	        LVS_MASTER_YN = 'Y'
	     ELSE
			//MACHINE_CODE,  MIN(LINE_CODE) $$HEX5$$3cc75cb8200070c88cd6$$ENDHEX$$
		    LVI_ROW2 = 0		    
		   SELECT Count(*)
	           INTO :LVI_ROW2
              FROM IB_MNT_PARTLIB_MASTER  
            WHERE MACHINE_CODE   = :LVS_MACHINE_TYPE
                 AND LINE_CODE         IN ( SELECT MIN(LINE_CODE) 
                                                         FROM IB_MNT_PARTLIB_MASTER
                                                       WHERE MACHINE_CODE   = :LVS_MACHINE_TYPE
											          AND APPLY_LOCATION = :LVS_APPLY_LOCATION
                                                           AND PARTNAME           = :LVS_PARTNAME
                                                           AND MASTER_YN         = 'Y' )
                AND APPLY_LOCATION = :LVS_APPLY_LOCATION
                AND PARTNAME       = :LVS_PARTNAME
		       AND MASTER_YN      = 'Y' ;
		
		     IF LVI_ROW2 = 1 THEN
			    SELECT  LINE_CODE
			        INTO :LVS_LINE_CODE2
			       FROM IB_MNT_PARTLIB_MASTER  
			     WHERE MACHINE_CODE   = :LVS_MACHINE_TYPE
				     AND LINE_CODE          IN ( SELECT MIN(LINE_CODE) 
													      FROM IB_MNT_PARTLIB_MASTER
													    WHERE MACHINE_CODE   = :LVS_MACHINE_TYPE
													        AND APPLY_LOCATION = :LVS_APPLY_LOCATION
										  				   AND PARTNAME           = :LVS_PARTNAME
														   AND MASTER_YN         = 'Y' )
				     AND APPLY_LOCATION = :LVS_APPLY_LOCATION
				     AND PARTNAME          = :LVS_PARTNAME
			         AND MASTER_YN         = 'Y' ;
				 
				     LVS_MASTER_YN = 'Y'
		     ELSE
				     //MIN(MACHINE_CODE),  MIN(LINE_CODE) $$HEX5$$3cc75cb8200070c88cd6$$ENDHEX$$
				     LVI_ROW3 = 0		    
				    SELECT Count(*)
					   INTO :LVI_ROW3
					  FROM IB_MNT_PARTLIB_MASTER  
					WHERE MACHINE_CODE  = 'NPM'															  
					     AND LINE_CODE        IN ( SELECT MIN(LINE_CODE) 
													        FROM IB_MNT_PARTLIB_MASTER
													      WHERE MACHINE_CODE    = 'NPM'	
													          AND APPLY_LOCATION = :LVS_APPLY_LOCATION
										  				     AND PARTNAME           = :LVS_PARTNAME
														     AND MASTER_YN         = 'Y' )
						 AND APPLY_LOCATION = :LVS_APPLY_LOCATION
						 AND PARTNAME          = :LVS_PARTNAME
					      AND MASTER_YN        = 'Y' ;
					 IF LVI_ROW3 = 0 THEN 
						 SELECT Count(*)
							INTO :LVI_ROW3
						  FROM IB_MNT_PARTLIB_MASTER  
						WHERE MACHINE_CODE  = 'BM'															  
							  AND LINE_CODE        IN ( SELECT MIN(LINE_CODE) 
																  FROM IB_MNT_PARTLIB_MASTER
																WHERE MACHINE_CODE    = 'BM'	
																  AND APPLY_LOCATION = :LVS_APPLY_LOCATION
																  AND PARTNAME           = :LVS_PARTNAME
																  AND MASTER_YN         = 'Y' )
							 AND APPLY_LOCATION = :LVS_APPLY_LOCATION
							 AND PARTNAME          = :LVS_PARTNAME
							 AND MASTER_YN        = 'Y' ;
					      IF LVI_ROW3 = 0 THEN							 
							 LVS_MACHINE_TYPE3 =  ''							
						 ELSE
						      LVS_MACHINE_TYPE3 =  'BM'		
						 END IF	
					 ELSE
						LVS_MACHINE_TYPE3 =  'NPM'
					 END IF
					 
					 IF LVI_ROW3 = 1 THEN
						SELECT LINE_CODE
					       INTO  :LVS_LINE_CODE3
					      FROM IB_MNT_PARTLIB_MASTER  
				   	    WHERE MACHINE_CODE = :LVS_MACHINE_TYPE3
					       AND LINE_CODE        IN ( SELECT MIN(LINE_CODE) 
													        FROM IB_MNT_PARTLIB_MASTER
													      WHERE MACHINE_CODE   = :LVS_MACHINE_TYPE3
													          AND APPLY_LOCATION = :LVS_APPLY_LOCATION
										  				     AND PARTNAME           = :LVS_PARTNAME
														     AND MASTER_YN         = 'Y' )
						 AND APPLY_LOCATION = :LVS_APPLY_LOCATION
						 AND PARTNAME          = :LVS_PARTNAME
					      AND MASTER_YN        = 'Y' ;
							
				         LVS_MASTER_YN = 'Y'
					ELSE		
					    LVS_MASTER_YN = 'N'	
					END IF	 
     	     END IF
		
	 END IF
	
	 LVI_COUNT = 0
	 SELECT COUNT(*)
	    INTO  :LVI_COUNT
	   FROM (     
				  SELECT '*'  APPLY_LOCATION, 	         A.PARTSNAME  PARTNAME,                      '*'  PART_TYPE,  
							A.L                   SIZE_L,           A.W            SIZE_W,                                A.T  SIZE_T,   
							A.REF1  VISION_CODE,            B.NOZZLEA,                                              B.NOZZLEB,   
							B.NOZZLEC,                             B.NOZZLED,  		                                     B.RCGSP SPEED_DETACT, 
							B.TSPD SPEED_MOUNT,   	     B.MSPD SPEED_PICKUP,                             B.TGAP GAP_PICKUP,
							B.MGAP GAP_MOUNT,   		     '' DETACT_ANGLE,                                     A.PACK STYLE_VALUE,
							A.RETRY RECOVERY_COUNT,     B.TUPX FIX_PICKUP_OFFSET_X,                B.TUPY FIX_PICKUP_OFFSET_Y,  
							B.TUPX FIX_PICKUP_OFFSET_Z, A.SENDPITCH MATERIAL_FEEDER_PITCH,   A.REELWIDTH MATERIAL_REEL_SIZE,   
							'' MATERIAL_PART_PER_REEL
				   FROM IB_MNT_PARTSLIB  A, IB_MNT_CHIPDATA B	 
				 WHERE A.IDNUM = B.IDNUM
					 AND A.PARTSNAME      = :LVS_PARTNAME
				 MINUS
				 SELECT APPLY_LOCATION,         PARTNAME,                     PART_TYPE,  
				 		    SIZE_L,                         SIZE_W,                          SIZE_T,   
							VISION_CODE,               NOZZLE_A,                      NOZZLE_B,   
							NOZZLE_C,                    NOZZLE_D,                      SPEED_DETACT, 
							SPEED_MOUNT,             SPEED_PICKUP,                GAP_PICKUP,
							GAP_MOUNT,                 DETACT_ANGLE,              STYLE_VALUE,
							RECOVERY_COUNT,        FIX_PICKUP_OFFSET_X,   FIX_PICKUP_OFFSET_Y,  
							FIX_PICKUP_OFFSET_Z,  MATERIAL_FEEDER_PITCH, MATERIAL_REEL_SIZE,   
							MATERIAL_PART_PER_REEL
				    FROM IB_MNT_PARTLIB_MASTER  
			      WHERE MACHINE_CODE    = DECODE(:LVI_ROW3, 0, :LVS_MACHINE_TYPE, :LVS_MACHINE_TYPE3)
					  AND LINE_CODE          = DECODE(:LVI_ROW3, 0,  DECODE(:LVI_ROW2, 0, :LVS_LINE_CODE, :LVS_LINE_CODE2), :LVS_LINE_CODE3)
					  AND APPLY_LOCATION = :LVS_APPLY_LOCATION
					  AND PARTNAME          = :LVS_PARTNAME
					  AND MASTER_YN        = 'Y' 
						 )
					WHERE ROWNUM = 1;
      	  
		     IF LVI_COUNT  = 1 THEN
			    SELECT TRIM(TO_CHAR(SEQ_COMPARE_SEQ.NEXTVAL,'0000000000')) 
			      INTO :LVS_WORKNO
			     FROM DUAL;
			 
		        //FILE DATA INSERT
				 INSERT INTO IB_MNT_PARTLIB_COMPARE_MASTER   
						 (  MACHINE_CODE,   
						LINE_CODE,   
						APPLY_LOCATION,   
						PARTNAME,   
						PART_TYPE,   
						
						SIZE_L,   
						SIZE_W,   
						SIZE_T,   
						VISION_CODE,   
						
						NOZZLE_A,   
						NOZZLE_B,   
						NOZZLE_C,  
						NOZZLE_D,  
						
						SPEED_DETACT,   
						SPEED_MOUNT,   
						SPEED_PICKUP,   
						
						GAP_PICKUP,   
						GAP_MOUNT,   
						
						DETACT_ANGLE,   
						
						STYLE_VALUE,   
						RECOVERY_COUNT,   
						
						FIX_PICKUP_OFFSET_X,   
						FIX_PICKUP_OFFSET_Y,   
						FIX_PICKUP_OFFSET_Z,   
						LAST_UPDATE_DATE,   
						
						MATERIAL_FEEDER_PITCH,   
						MATERIAL_REEL_SIZE,   
						MATERIAL_PART_PER_REEL,   
						
						ENTER_DATE,   
						ENTER_BY,   
						LAST_MODIFY_DATE,   
						LAST_MODIFY_BY,   
						ORGANIZATION_ID,   
						MASTER_YN ,
						WORK_NO,
						COMPARE_DATE,
					    MASTER_GB,
					    QUERY,
					    MASTER_CHK) 
					  
						SELECT :LVS_MACHINE_TYPE ,   
								 :LVS_LINE_CODE ,   
								 '*' APPLY_LOCATION,   
								 A.PARTSNAME      PARTNAME,   
								 '*'  PART_TYPE,   
								 
								 A.L       SIZE_L,   
								 A.W      SIZE_W,   
								 A.T       SIZE_T,   
								 
								 A.REF1  VISION_CODE,   
								 
								 B.NOZZLEA,   
								 B.NOZZLEB,   
								 B.NOZZLEC,  
								 B.NOZZLED,  		  
								 
								 B.RCGSP SPEED_DETACT,   
								 B.TSPD SPEED_MOUNT,   
								 B.MSPD SPEED_PICKUP,   
								 
								 B.TGAP GAP_PICKUP,   
								 B.MGAP GAP_MOUNT,   
								 
								 '' DETACT_ANGLE,   
								 
								 A.PACK STYLE_VALUE,   
								 A.RETRY RECOVERY_COUNT,   
								 
								 B.TUPX FIX_PICKUP_OFFSET_X,   
								 B.TUPY FIX_PICKUP_OFFSET_Y,   
								 B.TUPX FIX_PICKUP_OFFSET_Z,   
								 TO_CHAR(SYSDATE ,'YYYY-MM-DD HH24:MI:SS')  LAST_UPDATE_DATE,   
								 
								 A.SENDPITCH MATERIAL_FEEDER_PITCH,   
								 A.REELWIDTH MATERIAL_REEL_SIZE,   
								 '' MATERIAL_PART_PER_REEL,   
								 
								 SYSDATE ,   
								 :GVS_USER_ID ,   
								 SYSDATE ,   
								 :GVS_USER_ID ,   
								 :GVI_ORGANIZATION_ID,   
								 'N' ,
								 :LVS_WORKNO,
								 SYSDATE,
								 'C',
							'N'	,
							:LVS_MASTER_YN
				    FROM  IB_MNT_PARTSLIB  A, IB_MNT_CHIPDATA B
				  WHERE  A.IDNUM              = B.IDNUM 
					  AND  A.PARTSNAME      = :LVS_PARTNAME;
			  
			  //MASTER INSERT   
			  INSERT INTO IB_MNT_PARTLIB_COMPARE_MASTER   
				      (  MACHINE_CODE,   
						LINE_CODE,   
						APPLY_LOCATION,   
						PARTNAME,   
						PART_TYPE,   
						
						SIZE_L,   
						SIZE_W,   
						SIZE_T,   
						VISION_CODE,   
						
						NOZZLE_A,   
						NOZZLE_B,   
						NOZZLE_C,  
						NOZZLE_D,  
						
						SPEED_DETACT,   
						SPEED_MOUNT,   
						SPEED_PICKUP,   
						
						GAP_PICKUP,   
						GAP_MOUNT,   
						
						DETACT_ANGLE,   
						
						STYLE_VALUE,   
						RECOVERY_COUNT,   
						
						FIX_PICKUP_OFFSET_X,   
						FIX_PICKUP_OFFSET_Y,   
						FIX_PICKUP_OFFSET_Z,   
						LAST_UPDATE_DATE,   
						
						MATERIAL_FEEDER_PITCH,   
						MATERIAL_REEL_SIZE,   
						MATERIAL_PART_PER_REEL,   
						
						ENTER_DATE,   
						ENTER_BY,   
						LAST_MODIFY_DATE,   
						LAST_MODIFY_BY,   
						ORGANIZATION_ID,   
						MASTER_YN ,
						WORK_NO,
						COMPARE_DATE,
					    MASTER_GB,
					    QUERY,
					    MASTER_CHK) 
					  
					  SELECT MACHINE_CODE ,   
								 LINE_CODE ,   
								 APPLY_LOCATION,   
								 PARTNAME,   
								 PART_TYPE,   
								 
								 SIZE_L,   
								 SIZE_W,   
								 SIZE_T,   
								 
								 VISION_CODE,   
								 
								 NOZZLE_A,   
								 NOZZLE_B,   
								 NOZZLE_C,  
								 NOZZLE_D,  		  
								 
								 SPEED_DETACT,   
								 SPEED_MOUNT,   
								 SPEED_PICKUP,   
								 
								 GAP_PICKUP,   
								 GAP_MOUNT,   
								 
								 DETACT_ANGLE,   
								 
								 STYLE_VALUE,   
								 RECOVERY_COUNT,   
								 
								 FIX_PICKUP_OFFSET_X,   
								 FIX_PICKUP_OFFSET_Y,   
								 FIX_PICKUP_OFFSET_Z,   
								 LAST_UPDATE_DATE,   
								 
								 MATERIAL_FEEDER_PITCH,   
								 MATERIAL_REEL_SIZE,   
								 MATERIAL_PART_PER_REEL,   
								 
								 ENTER_DATE ,   
								 ENTER_BY ,   
								 LAST_MODIFY_DATE ,   
								 LAST_MODIFY_BY ,   
								 ORGANIZATION_ID,   
								 MASTER_YN,
								 :LVS_WORKNO,
								 SYSDATE,
								 'M',
							     'N'	,
							   :LVS_MASTER_YN	 
					  FROM  IB_MNT_PARTLIB_MASTER
					WHERE  MACHINE_CODE    = DECODE(:LVI_ROW3, 0, :LVS_MACHINE_TYPE, :LVS_MACHINE_TYPE3)
					     AND LINE_CODE          = DECODE(:LVI_ROW3, 0,  DECODE(:LVI_ROW2, 0, :LVS_LINE_CODE, :LVS_LINE_CODE2), :LVS_LINE_CODE3)
						AND  APPLY_LOCATION = :LVS_APPLY_LOCATION
					    AND  PARTNAME          = :LVS_PARTNAME
					    AND  MASTER_YN        = 'Y' ;   
			 END IF
		 
LOOP UNTIL 1 = 2 
	   

	/********************/
ELSEIF RB_bm.CHecked = TRUE THEN 
	LVS_MACHINE_TYPE = 'BM'
	/*********************/
	DECLARE CUR_2 CURSOR FOR
     
	  SELECT '*', 	 PARTNAME
        FROM IB_MNT_PARTSLIB_BM_V	;
	 
	 IF F_SQL_CHECK() < 0 THEN 
		  RETURN 
	 END IF
	 
	 OPEN CUR_2 ;
	 DO
		
		
		FETCH CUR_2  INTO :LVS_APPLY_LOCATION,        :LVS_PARTNAME;
		
		IF F_SQL_CHECK() < 0 THEN 
			CLOSE CUR_2 ;
			EXIT
		END IF
		
		IF SQLCA.SQLCODE = 100 THEN 
			CLOSE CUR_2 ;
			EXIT
		END IF
		
		//$$HEX8$$c8b9a4c230d1200020c734bb55d678c7$$ENDHEX$$($$HEX6$$7cb778c7c4bc200080acc9c0$$ENDHEX$$)/MACHINE_CODE, LINE_CODE$$HEX5$$3cc75cb8200070c88cd6$$ENDHEX$$
	    SELECT Count(*)
	       INTO :LVI_ROW
         FROM IB_MNT_PARTLIB_MASTER  
        WHERE MACHINE_CODE   = :LVS_MACHINE_TYPE
            AND LINE_CODE          = :LVS_LINE_CODE
            AND APPLY_LOCATION = :LVS_APPLY_LOCATION
            AND PARTNAME          = :LVS_PARTNAME
		   AND MASTER_YN        = 'Y' ;
		IF LVI_ROW > 0 THEN
			 LVS_MASTER_YN = 'Y'
		ELSE
			 //MACHINE_CODE,  MIN(LINE_CODE) $$HEX5$$3cc75cb8200070c88cd6$$ENDHEX$$
		    LVI_ROW2 = 0		    
		   SELECT Count(*)
	           INTO :LVI_ROW2
              FROM IB_MNT_PARTLIB_MASTER  
            WHERE MACHINE_CODE   = :LVS_MACHINE_TYPE
                 AND LINE_CODE         IN ( SELECT MIN(LINE_CODE) 
                                                         FROM IB_MNT_PARTLIB_MASTER
                                                       WHERE MACHINE_CODE   = :LVS_MACHINE_TYPE
											          AND APPLY_LOCATION = :LVS_APPLY_LOCATION
                                                           AND PARTNAME           = :LVS_PARTNAME
                                                           AND MASTER_YN         = 'Y' )
                AND APPLY_LOCATION = :LVS_APPLY_LOCATION
                AND PARTNAME       = :LVS_PARTNAME
		       AND MASTER_YN      = 'Y' ;
		
		     IF LVI_ROW2 = 1 THEN
			    SELECT  LINE_CODE
			        INTO :LVS_LINE_CODE2
			       FROM IB_MNT_PARTLIB_MASTER  
			     WHERE MACHINE_CODE   = :LVS_MACHINE_TYPE
				     AND LINE_CODE          IN ( SELECT MIN(LINE_CODE) 
													      FROM IB_MNT_PARTLIB_MASTER
													    WHERE MACHINE_CODE   = :LVS_MACHINE_TYPE
													        AND APPLY_LOCATION = :LVS_APPLY_LOCATION
										  				   AND PARTNAME           = :LVS_PARTNAME
														   AND MASTER_YN         = 'Y' )
				     AND APPLY_LOCATION = :LVS_APPLY_LOCATION
				     AND PARTNAME          = :LVS_PARTNAME
			         AND MASTER_YN         = 'Y' ;
				 
				     LVS_MASTER_YN = 'Y'
		     ELSE
				     //MIN(MACHINE_CODE),  MIN(LINE_CODE) $$HEX5$$3cc75cb8200070c88cd6$$ENDHEX$$
				     LVI_ROW3 = 0		    
				    SELECT Count(*)
					   INTO :LVI_ROW3
					  FROM IB_MNT_PARTLIB_MASTER  
					WHERE MACHINE_CODE  = 'CM'															  
					     AND LINE_CODE        IN ( SELECT MIN(LINE_CODE) 
													        FROM IB_MNT_PARTLIB_MASTER
													      WHERE MACHINE_CODE    = 'CM'	
													          AND APPLY_LOCATION = :LVS_APPLY_LOCATION
										  				     AND PARTNAME           = :LVS_PARTNAME
														     AND MASTER_YN         = 'Y' )
						 AND APPLY_LOCATION = :LVS_APPLY_LOCATION
						 AND PARTNAME          = :LVS_PARTNAME
					      AND MASTER_YN        = 'Y' ;
					 IF LVI_ROW3 = 0 THEN 
						 SELECT Count(*)
							INTO :LVI_ROW3
						  FROM IB_MNT_PARTLIB_MASTER  
						WHERE MACHINE_CODE  = 'NPM'															  
							  AND LINE_CODE        IN ( SELECT MIN(LINE_CODE) 
																  FROM IB_MNT_PARTLIB_MASTER
																WHERE MACHINE_CODE    = 'NPM'	
																  AND APPLY_LOCATION = :LVS_APPLY_LOCATION
																  AND PARTNAME           = :LVS_PARTNAME
																  AND MASTER_YN         = 'Y' )
							 AND APPLY_LOCATION = :LVS_APPLY_LOCATION
							 AND PARTNAME          = :LVS_PARTNAME
							 AND MASTER_YN        = 'Y' ;
					      IF LVI_ROW3 = 0 THEN							 
							 LVS_MACHINE_TYPE3 =  ''							
						 ELSE
						      LVS_MACHINE_TYPE3 =  'NPM'		
						 END IF	
					 ELSE
						LVS_MACHINE_TYPE3 =  'CM'
					 END IF
					 
					 IF LVI_ROW3 = 1 THEN
						SELECT LINE_CODE
					       INTO  :LVS_LINE_CODE3
					      FROM IB_MNT_PARTLIB_MASTER  
				   	    WHERE MACHINE_CODE = :LVS_MACHINE_TYPE3
					       AND LINE_CODE        IN ( SELECT MIN(LINE_CODE) 
													        FROM IB_MNT_PARTLIB_MASTER
													      WHERE MACHINE_CODE   = :LVS_MACHINE_TYPE3
													          AND APPLY_LOCATION = :LVS_APPLY_LOCATION
										  				     AND PARTNAME           = :LVS_PARTNAME
														     AND MASTER_YN         = 'Y' )
						 AND APPLY_LOCATION = :LVS_APPLY_LOCATION
						 AND PARTNAME          = :LVS_PARTNAME
					      AND MASTER_YN        = 'Y' ;
							
				         LVS_MASTER_YN = 'Y'
					ELSE		
					    LVS_MASTER_YN = 'N'	
					END IF	 
     	     END IF
		END IF
		
		LVI_COUNT = 0
		SELECT COUNT(*)
		   INTO  :LVI_COUNT
		 FROM (
		              SELECT   '*'  APPLY_LOCATION, 	       PARTNAME,              VISION_CODE,  
								 TO_CHAR(TO_NUMBER(SIZE_L1) / 1000)   SIZE_L, 
							     TO_CHAR(TO_NUMBER(SIZE_W1) / 1000)   SIZE_W,  
								 NOZZLE_A, 
								 SPEED_DETACT,   SPEED_MOUNT,  SPEED_PICKUP, 
								 MATERIAL_FEEDER_PITCH, MATERIAL_REEL_SIZE
					    FROM  IB_MNT_PARTSLIB_BM_V	 
					  WHERE PARTNAME   = :LVS_PARTNAME
					 MINUS
					 SELECT APPLY_LOCATION,       PARTNAME,              VISION_CODE,  
							    SIZE_L,                SIZE_W,                NOZZLE_A, 
							    SPEED_DETACT,   SPEED_MOUNT,  SPEED_PICKUP, 
								MATERIAL_FEEDER_PITCH, MATERIAL_REEL_SIZE
						FROM IB_MNT_PARTLIB_MASTER  
					  WHERE MACHINE_CODE    = DECODE(:LVI_ROW3, 0, :LVS_MACHINE_TYPE, :LVS_MACHINE_TYPE3)
					      AND LINE_CODE          = DECODE(:LVI_ROW3, 0,  DECODE(:LVI_ROW2, 0, :LVS_LINE_CODE, :LVS_LINE_CODE2), :LVS_LINE_CODE3)
						  AND APPLY_LOCATION = :LVS_APPLY_LOCATION
						  AND PARTNAME           = :LVS_PARTNAME
					      AND  MASTER_YN         = 'Y' 
						 )
					WHERE ROWNUM = 1;
      	  
		 IF LVI_COUNT  = 1 THEN
		     SELECT TRIM(TO_CHAR(SEQ_COMPARE_SEQ.NEXTVAL,'0000000000')) 
			   INTO :LVS_WORKNO
			  FROM DUAL;
			   
		    //FILE DATA INSERT
		    INSERT INTO IB_MNT_PARTLIB_COMPARE_MASTER   
              (  MACHINE_CODE,
		        LINE_CODE, 
		        
		        PARTNAME, 
		        VISION_CODE, 
		        SIZE_L,   
	            SIZE_W,   
		        NOZZLE_A, 
		        
		        SPEED_DETACT,   
	             SPEED_MOUNT,   
	             SPEED_PICKUP,
		        MATERIAL_FEEDER_PITCH,   
		        MATERIAL_REEL_SIZE , 
		        
		        PART_TYPE, 
		        ORGANIZATION_ID, 
		        ENTER_DATE,   
		        ENTER_BY,   
		        LAST_MODIFY_DATE,   
		        LAST_MODIFY_BY,
		        WORK_NO,
		        COMPARE_DATE,
		        MASTER_GB,
				QUERY,
				MASTER_CHK) 
			     
			   SELECT :LVS_MACHINE_TYPE ,   
                            :LVS_LINE_CODE ,   
	                       PARTNAME, 
			             VISION_CODE, 
			             TO_NUMBER(SIZE_L1) / 1000 , 
			             TO_NUMBER(SIZE_W1) / 1000, 
			             NOZZLE_A,
			             
			             SPEED_DETACT, 
			             SPEED_MOUNT, 
			             SPEED_PICKUP, 
			             
			             MATERIAL_FEEDER_PITCH, 
                           MATERIAL_REEL_SIZE, 
				           	
		            	   '*', 
		            	   :GVI_ORGANIZATION_ID,   
		            	   SYSDATE ,   
		            	   :GVS_USER_ID ,   
		            	   SYSDATE ,   
		            	   :GVS_USER_ID,
		            	   :LVS_WORKNO,
		            	   SYSDATE,
		            	   'C',
					   'N'	,
					 :LVS_MASTER_YN
               FROM IB_MNT_PARTSLIB_BM_V
			WHERE PARTNAME       = :LVS_PARTNAME ;
        
        //MASTER INSERT   
         INSERT INTO IB_MNT_PARTLIB_COMPARE_MASTER   
              (  MACHINE_CODE,
		        LINE_CODE, 
		        
		        PARTNAME, 
		        VISION_CODE, 
		        SIZE_L,   
	            SIZE_W,   
		        NOZZLE_A, 
		        
		        SPEED_DETACT,   
	             SPEED_MOUNT,   
	             SPEED_PICKUP,
		        MATERIAL_FEEDER_PITCH,   
		        MATERIAL_REEL_SIZE , 
		        
		        PART_TYPE, 
		        ORGANIZATION_ID, 
		        ENTER_DATE,   
		        ENTER_BY,   
		        LAST_MODIFY_DATE,   
		        LAST_MODIFY_BY,
		        WORK_NO,
		        COMPARE_DATE,
		        MASTER_GB,
			   QUERY,
			   MASTER_CHK) 
			     
			   SELECT MACHINE_CODE ,   
			               LINE_CODE ,  			                
			              PARTNAME,   
			              VISION_CODE,
			              SIZE_L,   
			              SIZE_W, 
			              NOZZLE_A, 	  
			             
			              SPEED_DETACT,   
			              SPEED_MOUNT,   
			              SPEED_PICKUP,   
			             
			              MATERIAL_FEEDER_PITCH, 
                           MATERIAL_REEL_SIZE,   
			             
			             PART_TYPE, 
		                 ORGANIZATION_ID, 
		                 ENTER_DATE,   
		                 ENTER_BY,   
		                 LAST_MODIFY_DATE,   
		                 LAST_MODIFY_BY,
			             :LVS_WORKNO,
			             SYSDATE,
			             'M',
						'N'	,
						:LVS_MASTER_YN	 
	           FROM  IB_MNT_PARTLIB_MASTER
             WHERE  MACHINE_CODE    = DECODE(:LVI_ROW3, 0, :LVS_MACHINE_TYPE, :LVS_MACHINE_TYPE3)
			    AND LINE_CODE          = DECODE(:LVI_ROW3, 0,  DECODE(:LVI_ROW2, 0, :LVS_LINE_CODE, :LVS_LINE_CODE2), :LVS_LINE_CODE3)
                 AND  APPLY_LOCATION = :LVS_APPLY_LOCATION
                 AND  PARTNAME          = :LVS_PARTNAME
		       AND  MASTER_YN          = 'Y' ;   
		 END IF
		 
LOOP UNTIL 1 = 2 
	/********************/
ELSE
	LVS_MACHINE_TYPE = 'NPM' 
	
	/*********************/
	DECLARE CUR_3 CURSOR FOR
    
	 SELECT  '*',  a.NAME
       FROM IB_MNT_PARTSLIB_NMP  A, IB_MNT_CHIPDATA_NMP B
     WHERE A.CHIP = B.IDNUM;
	 
	 IF F_SQL_CHECK() < 0 THEN 
		  RETURN 
	 END IF
	 
	 OPEN CUR_3 ;
	 DO
		
		
		FETCH CUR_3  INTO :LVS_APPLY_LOCATION,        :LVS_PARTNAME;
		
		IF F_SQL_CHECK() < 0 THEN 
			CLOSE CUR_3 ;
			EXIT
		END IF
		
		IF SQLCA.SQLCODE = 100 THEN 
			CLOSE CUR_3 ;
			EXIT
		END IF
		
	   //$$HEX8$$c8b9a4c230d1200020c734bb55d678c7$$ENDHEX$$($$HEX6$$7cb778c7c4bc200080acc9c0$$ENDHEX$$)/MACHINE_CODE, LINE_CODE$$HEX5$$3cc75cb8200070c88cd6$$ENDHEX$$
   	   SELECT  Count(*)
	      INTO :LVI_ROW
         FROM IB_MNT_PARTLIB_MASTER  
        WHERE MACHINE_CODE   = :LVS_MACHINE_TYPE
            AND LINE_CODE          = :LVS_LINE_CODE
            AND APPLY_LOCATION = :LVS_APPLY_LOCATION
            AND PARTNAME          = :LVS_PARTNAME
		   AND MASTER_YN        = 'Y' ;
			
		IF LVI_ROW > 0 THEN
			 LVS_MASTER_YN = 'Y'
		ELSE
			//MACHINE_CODE,  MIN(LINE_CODE) $$HEX5$$3cc75cb8200070c88cd6$$ENDHEX$$
		    LVI_ROW2 = 0		    
		   SELECT Count(*)
	           INTO :LVI_ROW2
              FROM IB_MNT_PARTLIB_MASTER  
            WHERE MACHINE_CODE   = :LVS_MACHINE_TYPE
                 AND LINE_CODE         IN ( SELECT MIN(LINE_CODE) 
                                                         FROM IB_MNT_PARTLIB_MASTER
                                                       WHERE MACHINE_CODE   = :LVS_MACHINE_TYPE
											          AND APPLY_LOCATION = :LVS_APPLY_LOCATION
                                                           AND PARTNAME           = :LVS_PARTNAME
                                                           AND MASTER_YN         = 'Y' )
                AND APPLY_LOCATION = :LVS_APPLY_LOCATION
                AND PARTNAME       = :LVS_PARTNAME
		       AND MASTER_YN      = 'Y' ;
		
		     IF LVI_ROW2 = 1 THEN
			    SELECT  LINE_CODE
			        INTO :LVS_LINE_CODE2
			       FROM IB_MNT_PARTLIB_MASTER  
			     WHERE MACHINE_CODE   = :LVS_MACHINE_TYPE
				     AND LINE_CODE          IN ( SELECT MIN(LINE_CODE) 
													      FROM IB_MNT_PARTLIB_MASTER
													    WHERE MACHINE_CODE   = :LVS_MACHINE_TYPE
													        AND APPLY_LOCATION = :LVS_APPLY_LOCATION
										  				   AND PARTNAME           = :LVS_PARTNAME
														   AND MASTER_YN         = 'Y' )
				     AND APPLY_LOCATION = :LVS_APPLY_LOCATION
				     AND PARTNAME          = :LVS_PARTNAME
			         AND MASTER_YN         = 'Y' ;
				 
				     LVS_MASTER_YN = 'Y'
		     ELSE
				     //MIN(MACHINE_CODE),  MIN(LINE_CODE) $$HEX5$$3cc75cb8200070c88cd6$$ENDHEX$$
				     LVI_ROW3 = 0		    
				    SELECT Count(*)
					   INTO :LVI_ROW3
					  FROM IB_MNT_PARTLIB_MASTER  
					WHERE MACHINE_CODE  = 'CM'															  
					     AND LINE_CODE        IN ( SELECT MIN(LINE_CODE) 
													        FROM IB_MNT_PARTLIB_MASTER
													      WHERE MACHINE_CODE    = 'CM'	
													          AND APPLY_LOCATION = :LVS_APPLY_LOCATION
										  				     AND PARTNAME           = :LVS_PARTNAME
														     AND MASTER_YN         = 'Y' )
						 AND APPLY_LOCATION = :LVS_APPLY_LOCATION
						 AND PARTNAME          = :LVS_PARTNAME
					      AND MASTER_YN        = 'Y' ;
					 IF LVI_ROW3 = 0 THEN 
						 SELECT Count(*)
							INTO :LVI_ROW3
						  FROM IB_MNT_PARTLIB_MASTER  
						WHERE MACHINE_CODE  = 'BM'															  
							  AND LINE_CODE        IN ( SELECT MIN(LINE_CODE) 
																  FROM IB_MNT_PARTLIB_MASTER
																WHERE MACHINE_CODE    = 'BM'	
																  AND APPLY_LOCATION = :LVS_APPLY_LOCATION
																  AND PARTNAME           = :LVS_PARTNAME
																  AND MASTER_YN         = 'Y' )
							 AND APPLY_LOCATION = :LVS_APPLY_LOCATION
							 AND PARTNAME          = :LVS_PARTNAME
							 AND MASTER_YN        = 'Y' ;
					      IF LVI_ROW3 = 0 THEN							 
							 LVS_MACHINE_TYPE3 =  ''							
						 ELSE
						      LVS_MACHINE_TYPE3 =  'BM'		
						 END IF	
					 ELSE
						LVS_MACHINE_TYPE3 =  'CM'
					 END IF
					 
					 IF LVI_ROW3 = 1 THEN
						SELECT LINE_CODE
					       INTO  :LVS_LINE_CODE3
					      FROM IB_MNT_PARTLIB_MASTER  
				   	    WHERE MACHINE_CODE = :LVS_MACHINE_TYPE3
					       AND LINE_CODE        IN ( SELECT MIN(LINE_CODE) 
													        FROM IB_MNT_PARTLIB_MASTER
													      WHERE MACHINE_CODE   = :LVS_MACHINE_TYPE3
													          AND APPLY_LOCATION = :LVS_APPLY_LOCATION
										  				     AND PARTNAME           = :LVS_PARTNAME
														     AND MASTER_YN         = 'Y' )
						 AND APPLY_LOCATION = :LVS_APPLY_LOCATION
						 AND PARTNAME          = :LVS_PARTNAME
					      AND MASTER_YN        = 'Y' ;
							
				         LVS_MASTER_YN = 'Y'
					ELSE		
					    LVS_MASTER_YN = 'N'	
					END IF	 
     	     END IF
		  END IF
		  
		 LVI_COUNT = 0
		 SELECT COUNT(*)
		    INTO  :LVI_COUNT
		   FROM (     
					 SELECT  '*'  APPLY_LOCATION, 	     A.NAME    PARTNAME,      '*'  PART_TYPE,   
								B.L  SIZE_L,       			     B.W      SIZE_W,   			B.T       SIZE_T,   
								B.REF  VISION_CODE,          B.NOZZLEA,         			B.NOZZLEB,   
							    B.NOZZLEC,             	          B.NOZZLED,          			B.RCGSP SPEED_DETACT,   
							    B.TSPD SPEED_MOUNT,    	 B.MSPD SPEED_PICKUP,   		B.TGAP GAP_PICKUP,   
							    B.MGAP GAP_MOUNT,   		 '' DETACT_ANGLE,   				A.PACK STYLE_VALUE,   
							    A.RETRY RECOVERY_COUNT,   B.TUPX FIX_PICKUP_OFFSET_X,   B.TUPY FIX_PICKUP_OFFSET_Y,   
							    B.TUPX FIX_PICKUP_OFFSET_Z,  '' MATERIAL_FEEDER_PITCH, '' MATERIAL_REEL_SIZE,  
							   '' MATERIAL_PART_PER_REEL
				        FROM IB_MNT_PARTSLIB_NMP  A, IB_MNT_CHIPDATA_NMP B
				      WHERE A.CHIP      = B.IDNUM  
					      AND  A.NAME   = :LVS_PARTNAME
				   MINUS
				   SELECT APPLY_LOCATION, 	 PARTNAME,             PART_TYPE,   
							 SIZE_L,       			 SIZE_W,   		          SIZE_T,   
							 VISION_CODE,         NOZZLE_A,              NOZZLE_B,   
							 NOZZLE_C,            NOZZLE_D,          		SPEED_DETACT,   
							 SPEED_MOUNT,    	   SPEED_PICKUP,   		    GAP_PICKUP,   
							 GAP_MOUNT,   		     DETACT_ANGLE,   				STYLE_VALUE,   
							 RECOVERY_COUNT,      FIX_PICKUP_OFFSET_X,   FIX_PICKUP_OFFSET_Y,   
							 FIX_PICKUP_OFFSET_Z, MATERIAL_FEEDER_PITCH, MATERIAL_REEL_SIZE,  
							 MATERIAL_PART_PER_REEL
					FROM IB_MNT_PARTLIB_MASTER  
				  WHERE MACHINE_CODE    = DECODE(:LVI_ROW3, 0, :LVS_MACHINE_TYPE, :LVS_MACHINE_TYPE3)
					  AND LINE_CODE          = DECODE(:LVI_ROW3, 0,  DECODE(:LVI_ROW2, 0, :LVS_LINE_CODE, :LVS_LINE_CODE2), :LVS_LINE_CODE3)
					 AND APPLY_LOCATION = :LVS_APPLY_LOCATION
					 AND PARTNAME           = :LVS_PARTNAME 
				  AND  MASTER_YN            = 'Y' 
					 )
				WHERE ROWNUM = 1;
      	  
		 IF LVI_COUNT  = 1 THEN
		     SELECT TRIM(TO_CHAR(SEQ_COMPARE_SEQ.NEXTVAL,'0000000000')) 
			  INTO :LVS_WORKNO
			 FROM DUAL;
			   
		    //FILE DATA INSERT
		    INSERT INTO IB_MNT_PARTLIB_COMPARE_MASTER   
                (  MACHINE_CODE,   
			      LINE_CODE,   
			      APPLY_LOCATION,   
			      PARTNAME,   
			      PART_TYPE,   
			      
			      SIZE_L,   
			      SIZE_W,   
			      SIZE_T,   
			      VISION_CODE,   
			      
			      NOZZLE_A,   
			      NOZZLE_B,   
			      NOZZLE_C,  
			      NOZZLE_D,  
			      
			      SPEED_DETACT,   
			      SPEED_MOUNT,   
			      SPEED_PICKUP,   
			      
			      GAP_PICKUP,   
			      GAP_MOUNT,   
			      
			      DETACT_ANGLE,   
			      
			      STYLE_VALUE,   
			      RECOVERY_COUNT,   
			      
			      FIX_PICKUP_OFFSET_X,   
			      FIX_PICKUP_OFFSET_Y,   
			      FIX_PICKUP_OFFSET_Z,   
			      LAST_UPDATE_DATE,   
			      
			      MATERIAL_FEEDER_PITCH,   
			      MATERIAL_REEL_SIZE,   
			      MATERIAL_PART_PER_REEL,   
			      
			      ENTER_DATE,   
			      ENTER_BY,   
			      LAST_MODIFY_DATE,   
			      LAST_MODIFY_BY,   
			      ORGANIZATION_ID,   
			      MASTER_YN ,
			      WORK_NO,
			      COMPARE_DATE,
		          MASTER_GB,
			     QUERY,
				MASTER_CHK) 
			     
			 SELECT  :LVS_MACHINE_TYPE ,   
             				:LVS_LINE_CODE ,   
             				'*' APPLY_LOCATION,   
             				A.NAME      PARTNAME,   
             				'*'  PART_TYPE,   
             				
             				B.L       SIZE_L,   
             				B.W      SIZE_W,   
             				B.T       SIZE_T,   
             				
             				B.REF  VISION_CODE,   
             				
             				B.NOZZLEA,   
             				B.NOZZLEB,   
             				B.NOZZLEC,  
             				B.NOZZLED,        
             				
             				B.RCGSP SPEED_DETACT,   
             				B.TSPD SPEED_MOUNT,   
             				B.MSPD SPEED_PICKUP,   
             				
             				B.TGAP GAP_PICKUP,   
             				B.MGAP GAP_MOUNT,   
             				
             				'' DETACT_ANGLE,   
             				
             				A.PACK STYLE_VALUE,   
             				A.RETRY RECOVERY_COUNT,   
             				
             				B.TUPX FIX_PICKUP_OFFSET_X,   
             				B.TUPY FIX_PICKUP_OFFSET_Y,   
             				B.TUPX FIX_PICKUP_OFFSET_Z,   
             				TO_CHAR(SYSDATE ,'YYYY-MM-DD HH24:MI:SS')  LAST_UPDATE_DATE,   
             				'',
             				'',  
             				'' MATERIAL_PART_PER_REEL,   
             				
             				SYSDATE ,   
             				:GVS_USER_ID ,   
             				SYSDATE ,   
             				:GVS_USER_ID ,   
             				:GVI_ORGANIZATION_ID,   
             				'N' ,
             				:LVS_WORKNO,
             			    SYSDATE,
                           'C',
				         'N'	,
						:LVS_MASTER_YN
                 FROM  IB_MNT_PARTSLIB_NMP  A, IB_MNT_CHIPDATA_NMP B
                WHERE A.CHIP = B.IDNUM
				  AND  A.NAME  = :LVS_PARTNAME;
        
        //MASTER INSERT   
         INSERT INTO IB_MNT_PARTLIB_COMPARE_MASTER   
                (  MACHINE_CODE,   
			      LINE_CODE,   
			      APPLY_LOCATION,   
			      PARTNAME,   
			      PART_TYPE,   
			      
			      SIZE_L,   
			      SIZE_W,   
			      SIZE_T,   
			      VISION_CODE,   
			      
			      NOZZLE_A,   
			      NOZZLE_B,   
			      NOZZLE_C,  
			      NOZZLE_D,  
			      
			      SPEED_DETACT,   
			      SPEED_MOUNT,   
			      SPEED_PICKUP,   
			      
			      GAP_PICKUP,   
			      GAP_MOUNT,   
			      
			      DETACT_ANGLE,   
			      
			      STYLE_VALUE,   
			      RECOVERY_COUNT,   
			      
			      FIX_PICKUP_OFFSET_X,   
			      FIX_PICKUP_OFFSET_Y,   
			      FIX_PICKUP_OFFSET_Z,   
			      LAST_UPDATE_DATE,   
			      
			      MATERIAL_FEEDER_PITCH,   
			      MATERIAL_REEL_SIZE,   
			      MATERIAL_PART_PER_REEL,   
			      
			      ENTER_DATE,   
			      ENTER_BY,   
			      LAST_MODIFY_DATE,   
			      LAST_MODIFY_BY,   
			      ORGANIZATION_ID,   
			      MASTER_YN ,
			      WORK_NO,
			      COMPARE_DATE,
		          MASTER_GB,
			 	QUERY,
				MASTER_CHK) 
			     
			    SELECT MACHINE_CODE ,   
			                LINE_CODE ,  			                
			                APPLY_LOCATION,   
             			       PARTNAME,   
             			       PART_TYPE,   
             				
             			       SIZE_L,   
             				  SIZE_W,   
             				  SIZE_T,   
             				
             				  VISION_CODE,   
             				
             				  NOZZLE_A,   
             				  NOZZLE_B,   
             				  NOZZLE_C,  
             				  NOZZLE_D,        
             				
             				  SPEED_DETACT,   
             				  SPEED_MOUNT,   
             				  SPEED_PICKUP,   
             				
             				  GAP_PICKUP,   
             				  GAP_MOUNT,   
             				
             				  DETACT_ANGLE,   
             				
             				  STYLE_VALUE,   
             				  RECOVERY_COUNT,   
             				
             				  FIX_PICKUP_OFFSET_X,   
             				  FIX_PICKUP_OFFSET_Y,   
             				  FIX_PICKUP_OFFSET_Z,   
             				
             				  LAST_UPDATE_DATE,   
             				  MATERIAL_FEEDER_PITCH,   
			                MATERIAL_REEL_SIZE,   
			                MATERIAL_PART_PER_REEL,   
             				
             				  ENTER_DATE,   
			               ENTER_BY,   
			               LAST_MODIFY_DATE,   
			               LAST_MODIFY_BY,   
			               ORGANIZATION_ID,   
			               MASTER_YN ,
			               :LVS_WORKNO,
			               SYSDATE,
			               'M',
						  'N'	,
						:LVS_MASTER_YN	 
	           FROM  IB_MNT_PARTLIB_MASTER
             WHERE MACHINE_CODE    = DECODE(:LVI_ROW3, 0, :LVS_MACHINE_TYPE, :LVS_MACHINE_TYPE3)
			    AND LINE_CODE          = DECODE(:LVI_ROW3, 0,  DECODE(:LVI_ROW2, 0, :LVS_LINE_CODE, :LVS_LINE_CODE2), :LVS_LINE_CODE3)
                  AND  APPLY_LOCATION = :LVS_APPLY_LOCATION
                  AND  PARTNAME           = :LVS_PARTNAME  
		         AND  MASTER_YN          = 'Y' ;
		 END IF
		 
LOOP UNTIL 1 = 2 
	    
/*********************/
	
	
END IF 

 
 
IF F_SQL_CHECK() < 0 THEN 
	RETURN 
END IF 


//=============================================
//
//=============================================

COMMIT ;

//$$HEX3$$acc770c88cd6$$ENDHEX$$
dw_1.Reset()
LVS_QUERY = 'N'
Gvs_Ue_DATA_control = 'RETRIEVE'
Parent.Triggerevent("UE_DATA_CONTROL")

//$$HEX9$$70c88cd6ecc580bd2000c5c570b374c7b8d2$$ENDHEX$$
UPDATE IB_MNT_PARTLIB_COMPARE_MASTER
SET       QUERY = 'Y'
WHERE  MACHINE_CODE = :LVS_MACHINE_TYPE
AND       QUERY              = 'N'
AND       COMPARE_DATE >= SYSDATE - 1
AND       COMPARE_DATE <   SYSDATE + 1  ;

IF F_SQL_CHECK() < 0 THEN 
	RETURN 
END IF 
COMMIT ;
				
st_status.text = "Completed.."	
F_MSGBOX(170)



  
end event

type st_status from so_statictext within w_smt_upload_partlib_compare_master
integer x = 18
integer y = 540
integer width = 4955
integer height = 132
boolean bringtotop = true
integer textsize = -10
long textcolor = 0
long backcolor = 30474192
string text = "Message"
end type

type cb_4 from commandbutton within w_smt_upload_partlib_compare_master
integer x = 1266
integer y = 276
integer width = 379
integer height = 96
integer taborder = 170
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Reset"
end type

event clicked;dw_1.reset()
dw_2.reset()
dw_3.reset()
dw_4.reset()
dw_5.reset()
dw_6.reset()
dw_7.reset()

end event

type sle_filename from so_singlelineedit within w_smt_upload_partlib_compare_master
integer x = 1664
integer y = 180
integer width = 1609
integer height = 88
integer taborder = 220
boolean bringtotop = true
end type

type cb_3 from so_commandbutton within w_smt_upload_partlib_compare_master
integer x = 1262
integer y = 176
integer width = 389
integer height = 96
integer taborder = 270
boolean bringtotop = true
string text = "File"
end type

event clicked;call super::clicked;//
string is_fullname , is_filename
long flen

		IF getfileopenname("Select File", &
			 is_fullname, is_filename, "txt", &
			 + "Text files (*.txt),*.txt," &
			 + "Log files (*.log),*.log," &
			 + "all files (*.*), *.*") < 1 THEN RETURN


//if GetFileOpenName ("Open", is_fullname, is_filename,   "*", "All Files (*.*),*.txt,INI Files " + "(*.ini), *.ini,Log Files (*.log),*.log" ) < 1 then return

sle_FILENAME.text =  is_fullname

//
//if GetFileOpenName("Select File", is_fullname, is_filename[], "CSV", "All Files (*.*), *.*") < 1 then return
//
//flen = FileLength(is_fullname)
//						
//IF FLEN < 0 THEN 
//	F_MSGBOX1(9020 ,is_fullname )
//	RETURN 
//END IF
end event

type rb_cm from so_radiobutton within w_smt_upload_partlib_compare_master
integer x = 1728
integer y = 80
boolean bringtotop = true
string text = "CM"
boolean checked = true
end type

type rb_npm from so_radiobutton within w_smt_upload_partlib_compare_master
integer x = 2249
integer y = 80
boolean bringtotop = true
string text = "NPM"
end type

type rb_bm from so_radiobutton within w_smt_upload_partlib_compare_master
integer x = 2770
integer y = 80
boolean bringtotop = true
string text = "BM"
end type

type uo_item from uo_item_code within w_smt_upload_partlib_compare_master
integer x = 480
integer y = 152
integer width = 768
integer height = 1928
integer taborder = 230
boolean bringtotop = true
end type

type st_5 from so_statictext within w_smt_upload_partlib_compare_master
integer x = 32
integer y = 164
integer width = 443
integer height = 68
boolean bringtotop = true
boolean enabled = false
string text = "Item Code"
alignment alignment = right!
end type

type ddlb_part_type from uo_basecode within w_smt_upload_partlib_compare_master
integer x = 480
integer y = 240
integer width = 768
integer height = 1844
integer taborder = 240
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'PART TYPE')
end event

type st_1 from so_statictext within w_smt_upload_partlib_compare_master
integer x = 32
integer y = 244
integer width = 443
integer height = 68
boolean bringtotop = true
boolean enabled = false
string text = "Part Type"
alignment alignment = right!
end type

type sle_work_no from so_singlelineedit within w_smt_upload_partlib_compare_master
integer x = 2158
integer y = 280
integer width = 736
integer height = 88
integer taborder = 280
boolean bringtotop = true
end type

type cb_5 from commandbutton within w_smt_upload_partlib_compare_master
integer x = 2903
integer y = 272
integer width = 375
integer height = 112
integer taborder = 250
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Delete All"
end type

event clicked;string lvs_work_no

lvs_work_no = sle_work_no.text 

if lvs_work_no = '' or isnull(lvs_work_no) then 
	return 
end if 

msg = f_msgbox1(1161 , this.text ) 

if msg = 1 then 
else
	return 
end if 

delete from ib_mnt_partlib_compare_master where work_no = :lvs_work_no and organization_id = :gvi_organization_id ;
if f_sql_check() < 0 then 
	return 
end if 

commit ;

f_retrieve()
end event

type st_2 from so_statictext within w_smt_upload_partlib_compare_master
integer x = 1659
integer y = 300
integer width = 475
integer height = 56
boolean bringtotop = true
string text = "Work No"
alignment alignment = right!
end type

type dw_6 from so_datawindow within w_smt_upload_partlib_compare_master
integer x = 5001
integer width = 379
integer height = 196
integer taborder = 130
boolean bringtotop = true
boolean titlebar = true
string title = "Chipdata"
string dataobject = "d_chipdata_compare"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean hsplitscroll = true
boolean righttoleft = true
end type

type dw_7 from so_datawindow within w_smt_upload_partlib_compare_master
integer x = 5385
integer width = 379
integer height = 196
integer taborder = 180
boolean bringtotop = true
boolean titlebar = true
string title = "PartLib"
string dataobject = "d_partlist_compare"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean hsplitscroll = true
boolean righttoleft = true
end type

type cb_6 from commandbutton within w_smt_upload_partlib_compare_master
integer x = 3397
integer y = 296
integer width = 375
integer height = 112
integer taborder = 260
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Check"
end type

event clicked;string lvs_std_value , lvs_real_value
Long i = 1

lvs_std_value = dw_1.object.speed_mount[1]

do
	
 	i++
    lvs_real_value = dw_1.object.speed_mount[i] 
	if lvs_std_value = lvs_real_value then 
		continue
	else
		
		 dw_1.object.speed_mount.Background.Color=255
		
	end if 
	
	
loop until i = dw_1.rowcount( )
end event

type dw_8 from so_datawindow within w_smt_upload_partlib_compare_master
integer x = 4997
integer y = 212
integer width = 379
integer height = 196
integer taborder = 190
boolean bringtotop = true
boolean titlebar = true
string title = "Chipdata_Nmp"
string dataobject = "d_chipdata_compare_nmp"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean hsplitscroll = true
boolean righttoleft = true
end type

type dw_9 from so_datawindow within w_smt_upload_partlib_compare_master
integer x = 5385
integer y = 212
integer width = 379
integer height = 196
integer taborder = 200
boolean bringtotop = true
boolean titlebar = true
string title = "PartLib_nmp"
string dataobject = "d_partslib_compare_nmp"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean hsplitscroll = true
boolean righttoleft = true
end type

type pb_debug from picturebutton within w_smt_upload_partlib_compare_master
integer x = 3831
integer y = 40
integer width = 101
integer height = 88
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "debug"
boolean originalsize = true
string picturename = "Debug!"
alignment htextalign = left!
end type

event clicked;

if (sle_lot_name.visible) then 
	/***********************
	 debug 
	***********************/
	sle_lot_name.visible = false 
	dw_6.visible = false 
	dw_7.visible = false 
	dw_8.visible = false 
	dw_9.visible = false 
	mle_2.visible=false 
else 
	sle_lot_name.visible = true 
	dw_6.visible = true
	dw_7.visible = true 
	dw_8.visible = true 
	dw_9.visible = true 
	mle_2.visible=true 
	
end if
end event

type ddlb_is_new_yn from so_dropdownlistbox within w_smt_upload_partlib_compare_master
integer x = 1042
integer y = 60
integer width = 210
integer taborder = 290
boolean bringtotop = true
integer weight = 700
string item[] = {"%","Y","N"}
end type

type st_4 from so_statictext within w_smt_upload_partlib_compare_master
integer x = 795
integer y = 64
integer width = 242
integer height = 68
boolean bringtotop = true
boolean enabled = false
string text = "Is New YN"
alignment alignment = right!
end type

type ddlb_mounter_model_type from uo_basecode within w_smt_upload_partlib_compare_master
integer x = 480
integer y = 332
integer width = 768
integer height = 1844
integer taborder = 310
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'MOUNTER MODEL TYPE')
end event

type st_6 from so_statictext within w_smt_upload_partlib_compare_master
integer x = 32
integer y = 332
integer width = 443
integer height = 68
boolean bringtotop = true
boolean enabled = false
string text = "Mounter Model Type"
alignment alignment = right!
end type

type st_7 from so_statictext within w_smt_upload_partlib_compare_master
integer x = 32
integer y = 428
integer width = 443
integer height = 68
boolean bringtotop = true
string text = "Date"
alignment alignment = right!
end type

type cbx_masteryn from so_checkbox within w_smt_upload_partlib_compare_master
integer x = 1929
integer y = 424
integer height = 84
integer taborder = 300
boolean bringtotop = true
string text = "Master Yn"
end type

type uo_dateset from uo_ymdh_calendar within w_smt_upload_partlib_compare_master
integer x = 475
integer y = 420
integer taborder = 320
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymdh_calendar::destroy
end on

event constructor;call super::constructor;em_2.text = '1'
end event

type uo_dateend from uo_ymdh_calendar within w_smt_upload_partlib_compare_master
integer x = 1138
integer y = 420
integer taborder = 330
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymdh_calendar::destroy
end on

event constructor;call super::constructor;em_2.text = '23'
end event

type gb_1 from so_groupbox within w_smt_upload_partlib_compare_master
integer x = 14
integer y = 16
integer width = 3328
integer height = 504
integer taborder = 100
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_smt_upload_partlib_compare_master
integer x = 3360
integer y = 12
integer width = 448
integer height = 412
integer taborder = 60
string text = "Process"
end type

