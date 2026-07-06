HA$PBExportHeader$w_customer_complaints_master.srw
$PBExportComments$$$HEX4$$c4b374ba00adacb9$$ENDHEX$$
forward
global type w_customer_complaints_master from w_main_root
end type
type ddlb_complaints_no from uo_complaints_no within w_customer_complaints_master
end type
type st_21 from so_statictext within w_customer_complaints_master
end type
type st_5 from so_statictext within w_customer_complaints_master
end type
type uo_item from uo_item_code within w_customer_complaints_master
end type
type st_14 from so_statictext within w_customer_complaints_master
end type
type sle_item_name from so_singlelineedit within w_customer_complaints_master
end type
type sle_key_word from so_singlelineedit within w_customer_complaints_master
end type
type st_1 from so_statictext within w_customer_complaints_master
end type
type st_2 from so_statictext within w_customer_complaints_master
end type
type sle_department_code from so_singlelineedit within w_customer_complaints_master
end type
type st_3 from so_statictext within w_customer_complaints_master
end type
type sle_user_id from so_singlelineedit within w_customer_complaints_master
end type
type st_4 from so_statictext within w_customer_complaints_master
end type
type rb_all from so_radiobutton within w_customer_complaints_master
end type
type rb_check_in from so_radiobutton within w_customer_complaints_master
end type
type rb_check_out from so_radiobutton within w_customer_complaints_master
end type
type rb_locked from so_radiobutton within w_customer_complaints_master
end type
type rb_unlocked from so_radiobutton within w_customer_complaints_master
end type
type pb_upload from so_picturebutton within w_customer_complaints_master
end type
type pb_view from so_picturebutton within w_customer_complaints_master
end type
type pb_check_in from so_picturebutton within w_customer_complaints_master
end type
type pb_check_out from so_picturebutton within w_customer_complaints_master
end type
type pb_5 from so_picturebutton within w_customer_complaints_master
end type
type pb_6 from so_picturebutton within w_customer_complaints_master
end type
type pb_7 from so_picturebutton within w_customer_complaints_master
end type
type pb_8 from so_picturebutton within w_customer_complaints_master
end type
type pb_3 from so_picturebutton within w_customer_complaints_master
end type
type ddlb_complaints_division from uo_basecode within w_customer_complaints_master
end type
type st_6 from so_statictext within w_customer_complaints_master
end type
type ddlb_customer_code from uo_customer_code_name within w_customer_complaints_master
end type
type gb_where_condition from so_groupbox within w_customer_complaints_master
end type
type gb_1 from so_groupbox within w_customer_complaints_master
end type
type gb_2 from so_groupbox within w_customer_complaints_master
end type
end forward

global type w_customer_complaints_master from w_main_root
integer width = 7163
integer height = 2904
string title = "Customer Complaints Master"
windowstate windowstate = maximized!
ddlb_complaints_no ddlb_complaints_no
st_21 st_21
st_5 st_5
uo_item uo_item
st_14 st_14
sle_item_name sle_item_name
sle_key_word sle_key_word
st_1 st_1
st_2 st_2
sle_department_code sle_department_code
st_3 st_3
sle_user_id sle_user_id
st_4 st_4
rb_all rb_all
rb_check_in rb_check_in
rb_check_out rb_check_out
rb_locked rb_locked
rb_unlocked rb_unlocked
pb_upload pb_upload
pb_view pb_view
pb_check_in pb_check_in
pb_check_out pb_check_out
pb_5 pb_5
pb_6 pb_6
pb_7 pb_7
pb_8 pb_8
pb_3 pb_3
ddlb_complaints_division ddlb_complaints_division
st_6 st_6
ddlb_customer_code ddlb_customer_code
gb_where_condition gb_where_condition
gb_1 gb_1
gb_2 gb_2
end type
global w_customer_complaints_master w_customer_complaints_master

on w_customer_complaints_master.create
int iCurrent
call super::create
this.ddlb_complaints_no=create ddlb_complaints_no
this.st_21=create st_21
this.st_5=create st_5
this.uo_item=create uo_item
this.st_14=create st_14
this.sle_item_name=create sle_item_name
this.sle_key_word=create sle_key_word
this.st_1=create st_1
this.st_2=create st_2
this.sle_department_code=create sle_department_code
this.st_3=create st_3
this.sle_user_id=create sle_user_id
this.st_4=create st_4
this.rb_all=create rb_all
this.rb_check_in=create rb_check_in
this.rb_check_out=create rb_check_out
this.rb_locked=create rb_locked
this.rb_unlocked=create rb_unlocked
this.pb_upload=create pb_upload
this.pb_view=create pb_view
this.pb_check_in=create pb_check_in
this.pb_check_out=create pb_check_out
this.pb_5=create pb_5
this.pb_6=create pb_6
this.pb_7=create pb_7
this.pb_8=create pb_8
this.pb_3=create pb_3
this.ddlb_complaints_division=create ddlb_complaints_division
this.st_6=create st_6
this.ddlb_customer_code=create ddlb_customer_code
this.gb_where_condition=create gb_where_condition
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ddlb_complaints_no
this.Control[iCurrent+2]=this.st_21
this.Control[iCurrent+3]=this.st_5
this.Control[iCurrent+4]=this.uo_item
this.Control[iCurrent+5]=this.st_14
this.Control[iCurrent+6]=this.sle_item_name
this.Control[iCurrent+7]=this.sle_key_word
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.st_2
this.Control[iCurrent+10]=this.sle_department_code
this.Control[iCurrent+11]=this.st_3
this.Control[iCurrent+12]=this.sle_user_id
this.Control[iCurrent+13]=this.st_4
this.Control[iCurrent+14]=this.rb_all
this.Control[iCurrent+15]=this.rb_check_in
this.Control[iCurrent+16]=this.rb_check_out
this.Control[iCurrent+17]=this.rb_locked
this.Control[iCurrent+18]=this.rb_unlocked
this.Control[iCurrent+19]=this.pb_upload
this.Control[iCurrent+20]=this.pb_view
this.Control[iCurrent+21]=this.pb_check_in
this.Control[iCurrent+22]=this.pb_check_out
this.Control[iCurrent+23]=this.pb_5
this.Control[iCurrent+24]=this.pb_6
this.Control[iCurrent+25]=this.pb_7
this.Control[iCurrent+26]=this.pb_8
this.Control[iCurrent+27]=this.pb_3
this.Control[iCurrent+28]=this.ddlb_complaints_division
this.Control[iCurrent+29]=this.st_6
this.Control[iCurrent+30]=this.ddlb_customer_code
this.Control[iCurrent+31]=this.gb_where_condition
this.Control[iCurrent+32]=this.gb_1
this.Control[iCurrent+33]=this.gb_2
end on

on w_customer_complaints_master.destroy
call super::destroy
destroy(this.ddlb_complaints_no)
destroy(this.st_21)
destroy(this.st_5)
destroy(this.uo_item)
destroy(this.st_14)
destroy(this.sle_item_name)
destroy(this.sle_key_word)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.sle_department_code)
destroy(this.st_3)
destroy(this.sle_user_id)
destroy(this.st_4)
destroy(this.rb_all)
destroy(this.rb_check_in)
destroy(this.rb_check_out)
destroy(this.rb_locked)
destroy(this.rb_unlocked)
destroy(this.pb_upload)
destroy(this.pb_view)
destroy(this.pb_check_in)
destroy(this.pb_check_out)
destroy(this.pb_5)
destroy(this.pb_6)
destroy(this.pb_7)
destroy(this.pb_8)
destroy(this.pb_3)
destroy(this.ddlb_complaints_division)
destroy(this.st_6)
destroy(this.ddlb_customer_code)
destroy(this.gb_where_condition)
destroy(this.gb_1)
destroy(this.gb_2)
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
Ivs_resize_type    = 'MASTER_DETAIL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default

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

F_MENU_CONTROL('DATA_CONTROL' , TRUE)  // All Data Control

/****************************************
* 
****************************************/


end event

event ue_data_control;call super::ue_data_control;Long ROW
double lvdb_version
STRING LVS_complaints_NO , LVS_ITEM_CODE
CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
	
			DW_1.RESET()
			DW_2.RESET()
	   		DW_1.RETRIEVE( DDLB_complaints_NO.TEXT()+'%' , UO_ITEM.TEXT()+'%' , sle_item_name.TEXT+'%' , sle_key_word.TEXT+'%'  ,  ddlb_customer_code.getcode()+'%' , sle_department_code.text+'%' , sle_user_id.text+'%' ,  ddlb_complaints_division.getcode()+'%' ,  GVI_ORGANIZATION_ID  )
			
	CASE 'INSERT'
		
			dw_2.reset()
			ROW = dw_2.INSERTROW(dw_2.getrow())
			dw_2.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(dw_2 , ROW , 'ALL')
			
		
			dw_2.object.complaints_no[row] = F_GET_ANY_NO('FQC_INSPECT_NO')
			
			dw_2.object.check_in_out[row] = 'I'
			dw_2.object.image_format[row] = 'PPT'			
			dw_2.object.version[row] = 1
			dw_2.object.status[row] = 'N'
			dw_2.object.complete_yn[row] = 'N'
			dw_2.object.user_id[row] = Gvs_user_id
			dw_1.groupcalc( )
			pb_upload.enabled = true	

	CASE 'APPEND'
		

			if dw_1.getrow() < 1 then 
				return 
			end if 
				
				LVS_complaints_NO = DW_1.OBJECT.complaints_NO[DW_1.GETROW()]
				LVS_ITEM_CODE    = DW_1.OBJECT.ITEM_CODE[DW_1.GETROW()]				
				
				select max(version)+1 into :lvdb_version
				 from icom_customer_complaints
				 where complaints_no = :lvs_complaints_no
				     and item_code = :lvs_item_code
				     and organization_id = :gvi_organization_id ;
					 
				if f_sql_check() < 0 then 
					return
				end if 
				
				//lvdb_version = double( dw_1.object.version[dw_1.getrow()] ) + 1
//			end if 

					
			ROW = dw_2.INSERTROW(0)
			dw_2.groupcalc( )
			
			dw_2.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(dw_2 , ROW , 'ALL')
			
			dw_2.object.item_code[row] = dw_1.object.item_code[dw_1.getrow()]
			dw_2.object.item_name[row] = dw_1.object.item_name[dw_1.getrow()]
			dw_2.object.item_spec[row] = dw_1.object.item_spec[dw_1.getrow()]
			dw_2.object.item_uom[row] = dw_1.object.item_uom[dw_1.getrow()]
			dw_2.object.customer_code[row] = dw_1.object.customer_code[dw_1.getrow()]	
			dw_2.object.department_code[row] = dw_1.object.department_code[dw_1.getrow()]		
			dw_2.object.model_name[row] = dw_1.object.model_name[dw_1.getrow()]		
			dw_2.object.model_suffix[row] = dw_1.object.model_suffix[dw_1.getrow()]		
			dw_2.object.part_no[row] = dw_1.object.part_no[dw_1.getrow()]					
			dw_2.object.key_word[row] = dw_1.object.key_word[dw_1.getrow()]					
			dw_2.object.user_id[row] = dw_1.object.user_id[dw_1.getrow()]			
			
			dw_2.object.version[row] = lvdb_version
			dw_2.object.check_in_out[row] = 'I'
			dw_2.object.status[row] = 'N'
    			dw_2.object.complete_yn[row] = 'N'
			dw_2.object.user_id[row] = Gvs_user_id				 
			pb_upload.enabled = true		
			
	CASE 'DELETE'
		
		  	IF dw_2.GETROW() < 1 THEN RETURN 
			  
			IF dw_2.object.complete_yn[dw_2.getrow()] = 'Y' then
				f_msgbox(161)
				return //$$HEX17$$44c6ccb81cb42000c4b374ba40c72000adc01cc8200060d518c22000c6c54cc72000$$ENDHEX$$
			end if 
			  
			MSG = F_MSGBOX(1003) 
			IF MSG = 1 THEN
				
				LVS_complaints_NO = DW_1.OBJECT.complaints_NO[DW_1.GETROW()]
				LVS_ITEM_CODE    = DW_1.OBJECT.ITEM_CODE[DW_1.GETROW()]
				
				GVL_ROW_DELETED = dw_2.GETROW()			
				dw_2.DELETEROW(GVL_ROW_DELETED)		
				dw_2.SETFOCUS()
				ROW = dw_2.GETROW()
				dw_2.SCROLLTOROW(ROW)
				dw_2.SETCOLUMN(1)
			END IF
			dw_2.groupcalc( )			
	CASE 'UPDATE'
		
			IF  dw_2.UPDATE() < 0 THEN
				ROLLBACK;
			ELSE
				COMMIT;
				F_MSG_ST(170) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
			END IF							
	CASE ELSE
END CHOOSE
end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

dw_1.sharedata(dw_2)
end event

type dw_5 from w_main_root`dw_5 within w_customer_complaints_master
integer y = 596
end type

type dw_4 from w_main_root`dw_4 within w_customer_complaints_master
integer y = 596
end type

type dw_3 from w_main_root`dw_3 within w_customer_complaints_master
integer y = 596
end type

type dw_2 from w_main_root`dw_2 within w_customer_complaints_master
integer y = 1568
integer width = 7026
integer height = 976
string dataobject = "d_customer_complaints_mst"
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
borderstyle borderstyle = styleraised!
end type

event dw_2::rbuttondown;call super::rbuttondown;IF DWO.NAME = 'item_code' THEN
	OPEN(w_des_item_popup)
	IF message.stringparm = '' THEN 
	ELSE
		THIS.SETITEM( ROW , 'item_code' , message.stringparm )	
		THIS.OBJECT.ITEM_NAME[row] = Gst_return.Gvs_return[3] 
		THIS.OBJECT.ITEM_SPEC[row] = Gst_return.Gvs_return[4] 
		THIS.OBJECT.ITEM_UOM[row] = Gst_return.Gvs_return[5] 
		
		if  Gst_return.Gvs_return[7]  = '*' or isnull(Gst_return.Gvs_return[7] ) or Gst_return.Gvs_return[7]  = '' then
			//$$HEX15$$c4b374ba88bc38d600ac2000c6c53cc774ba200088d4a9ba3cc75cb82000$$ENDHEX$$
			if THIS.OBJECT.complaints_NO[row] = '' or isnull(THIS.OBJECT.complaints_NO[row]) then 
				THIS.OBJECT.complaints_NO[row] = message.stringparm
			end if 
		else
			THIS.OBJECT.complaints_NO[row] = Gst_return.Gvs_return[7] 
		end if 
	END IF
END IF
if dwo.name = 'customer_code' then 
	open(w_com_customer_popup)
	if message.stringparm = '' then 
	else
		this.object.customer_code[row] = message.stringparm
		 this.trigger event itemchanged( row , this.object.customer_code , this.object.customer_code[row]  )
	end if 
end if 	
end event

event dw_2::clicked;call super::clicked;if dwo.name = 'b_file' then 
else
	return 
end if 


IF F_OBJECT_ROLE_CHECK() = FALSE THEN  RETURN

int    li_FileNum , loops, i , lvi_count
long   flen, bytes_read , bytes_read_sum , new_pos
blob   LIB_FILE , b
double LVDB_VERSION
string is_filename, is_fullname , LVS_complaints_NO , LVS_ITEM_CODE , LVS_IMAGE_FORMAT
		
		IF  dw_2.GETROW() < 1 THEN 
			 RETURN
		END IF
		
		LVS_complaints_NO    = dw_2.GETITEMSTRING( dw_2.GETROW() , "complaints_NO" )
		LVS_ITEM_CODE       = dw_2.GETITEMSTRING( dw_2.GETROW() , "ITEM_CODE" )
		LVS_IMAGE_FORMAT = dw_2.GETITEMSTRING( dw_2.GETROW() , "IMAGE_FORMAT" )
		LVDB_VERSION   = dw_2.OBJECT.VERSION[dw_2.GETROW()]
		
		IF LVS_complaints_NO ='' OR ISNULL(LVS_complaints_NO) THEN 
			RETURN
		END IF		
		
		IF LVS_IMAGE_FORMAT = '' OR ISNULL(LVS_IMAGE_FORMAT) THEN 
			LVS_IMAGE_FORMAT = 'bmp'
		END IF 
		
		if GetFileOpenName("Select File", is_fullname, is_filename, LVS_IMAGE_FORMAT, &
			 + "DWG Files (*.dwg),*.DWG," &		 
			 + "GIF Files (*.pdf),*.PDF," &
			 + "BMP Files (*.xls),*.XLS," &			 
			 + "JPG Files (*.jpg),*.JPG," &
			 + "PPT Files (*.ppt),*.PPT," &			 
			 + "All Files (*.*), *.*") < 1 then return
		
		flen = FileLength(is_fullname)
		
		IF FLEN < 0 THEN 
			ROLLBACK;			
			F_MSGBOX1(9020 ,is_fullname )
			RETURN 
		END IF
		
		li_FileNum = FileOpen(is_fullname,  StreamMode!, Read!, LockRead!)
		
		IF li_FileNum <> -1 THEN
				
					SetPointer(HourGlass!)
					IF flen > 32765 THEN
					
							  IF Mod(flen, 32765) = 0 THEN
									loops = flen/32765
							  ELSE
									loops = (flen/32765) + 1
							  END IF
					ELSE
							  loops = 1
					END IF
					
					new_pos = 1
					FOR i = 1 to loops
							  bytes_read = FileRead(li_FileNum, b)
							  bytes_read_sum = bytes_read_sum + bytes_read
							  LIB_FILE = LIB_FILE + b
							  F_MSG_MDI_HELP( STRING(bytes_read_sum)+"/"+string(flen)+" Bytes Read" )
					NEXT
					
					FileClose(li_FileNum)
	//================================================
	//
	//================================================
					DW_2.object.FILE_NAME[dw_2.getrow()] = 	is_filename
					
					IF dw_2.UPDATE() < 0 THEN 
						RETURN
					END IF
	//================================================					
	
					SELECT count(*) into :lvi_count
					  FROM icom_customer_complaints
					WHERE complaints_NO   = :LVS_complaints_NO 
					AND ITEM_CODE    = :LVS_ITEM_CODE
					AND VERSION = :LVDB_VERSION
					AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
						  
					IF F_SQL_CHECK() < 0 THEN 
						RETURN
					END IF				  
					
					if lvi_count = 0 then 
						ROLLBACK;									
						F_MSGBOX1( 9021 , is_filename ) 
						return
					end if
						  
					UPDATEBLOB icom_customer_complaints SET complaints_IMAGE = :LIB_FILE 
					WHERE complaints_NO      = :LVS_complaints_NO
					  AND ITEM_CODE       = :LVS_ITEM_CODE
					  AND VERSION = :LVDB_VERSION
					  AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;

				  IF SQLCA.SQLNROWS > 0 THEN

				  ELSE
					  ROLLBACK ;
					  MESSAGEBOX("Error" , is_filename+f_msg(" File Upload To Database Failed",'S') )
					  RETURN
				  END IF;
				  
					UPDATE icom_customer_complaints SET FILE_NAME = :is_filename 
					WHERE complaints_NO      = :LVS_complaints_NO
					AND ITEM_CODE       = :LVS_ITEM_CODE
					AND VERSION = :LVDB_VERSION
					AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;				  
		
				  IF F_SQL_CHECK() < 0 THEN 
					  RETURN
				  END IF		  
				  
					COMMIT ;
					F_MSGBOX(9022)

		END IF
Changedirectory(Gvs_default_directory)
end event

event dw_2::itemchanged;call super::itemchanged;
STRING LVS_RUN_NO, LVS_MODEL_NAME, LVS_MODEL_SUFFIX, LVS_ITEM_CODE, LVS_CUSTOMER_CODE, LVS_PART_NO

IF  ROW <= 0 THEN RETURN

IF DWO.NAME = 'serial_no' THEN
  
    IF data = '' OR ISNULL(data) THEN
    
    ELSE
      
		// PID $$HEX4$$85c725b8dcc22000$$ENDHEX$$model $$HEX17$$f1b4200038cc70c815c8f4bc7cb9200055d678c758d5ecc520009ccd25b85cd5e4b2$$ENDHEX$$

       SELECT B.RUN_NO, B.ITEM_CODE, B.MODEL_NAME, B.MODEL_SUFFIX, M.CUSTOMER_CODE, M.PART_NO
           INTO :LVS_RUN_NO, :LVS_ITEM_CODE, :LVS_MODEL_NAME, :LVS_MODEL_SUFFIX,:LVS_CUSTOMER_CODE, :LVS_PART_NO
          FROM IP_PRODUCT_2D_BARCODE   B,
                    IP_PRODUCT_MODEL_MASTER M
         WHERE B.ITEM_CODE = M.ITEM_CODE(+)
             AND B.ORGANIZATION_ID = M.ORGANIZATION_ID(+)
             AND B.SERIAL_NO            =  :data
             AND B.ORGANIZATION_ID = :GVI_ORGANIZATION_ID
             AND ROWNUM                 = 1;
  
       IF F_SQL_CHECK() < 0 THEN 
           RETURN
       END IF  
          
      THIS.OBJECT.RUN_NO[ROW]               = LVS_RUN_NO
      THIS.OBJECT.MODEL_NAME[ROW]       = LVS_MODEL_NAME
      THIS.OBJECT.MODEL_SUFFIX[ROW]     = LVS_MODEL_SUFFIX      
      THIS.OBJECT.ITEM_CODE[ROW]          = LVS_ITEM_CODE             
      THIS.OBJECT.CUSTOMER_CODE[ROW] = LVS_CUSTOMER_CODE
       THIS.OBJECT.PART_NO[ROW]            = LVS_PART_NO
		 
    END IF
    
END IF


end event

type dw_1 from w_main_root`dw_1 within w_customer_complaints_master
integer y = 596
integer width = 4695
integer height = 964
boolean titlebar = true
string dataobject = "d_customer_complaints_lst"
end type

event dw_1::rbuttondown;call super::rbuttondown;IF DWO.NAME = 'item_code' THEN
	OPEN(w_des_item_popup)
	IF message.stringparm = '' THEN 
	ELSE
		THIS.SETITEM( ROW , 'item_code' , message.stringparm )	
		THIS.OBJECT.ITEM_NAME[row] = Gst_return.Gvs_return[3] 
		THIS.OBJECT.ITEM_SPEC[row] = Gst_return.Gvs_return[4] 
		THIS.OBJECT.ITEM_UOM[row] = Gst_return.Gvs_return[5] 
		
		if  Gst_return.Gvs_return[7]  = '*' or isnull(Gst_return.Gvs_return[7] ) or Gst_return.Gvs_return[7]  = '' then
			//$$HEX15$$c4b374ba88bc38d600ac2000c6c53cc774ba200088d4a9ba3cc75cb82000$$ENDHEX$$
			if THIS.OBJECT.complaints_NO[row] = '' or isnull(THIS.OBJECT.complaints_NO[row]) then 
				THIS.OBJECT.complaints_NO[row] = message.stringparm
			end if 
		else
			THIS.OBJECT.complaints_NO[row] = Gst_return.Gvs_return[7] 
		end if 
	END IF
END IF
end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow = 0 then return

if this.object.check_in_out[currentrow] = 'I' then
	pb_check_in.enabled = false
	pb_check_out.enabled = true
	pb_view.enabled = false			
	pb_upload.enabled = false
else //$$HEX9$$b4cc6cd0200044c5c3c62000c1c0dcd02000$$ENDHEX$$
	pb_check_in.enabled = true	
	pb_check_out.enabled = false
	
	if this.object.check_in_out_by[currentrow] = gvs_user_id then 
		pb_view.enabled = true
		pb_upload.enabled = true		
	else
		pb_view.enabled = false		
		pb_upload.enabled = false
	end if 
end if 

dw_2.retrieve( dw_1.object.rowid[currentrow])

//dw_2.scrolltorow(currentrow)
end event

type uo_tabpages from w_main_root`uo_tabpages within w_customer_complaints_master
integer x = 64
integer y = 412
end type

type ddlb_complaints_no from uo_complaints_no within w_customer_complaints_master
integer x = 27
integer y = 176
integer width = 567
integer taborder = 90
boolean bringtotop = true
boolean allowedit = true
end type

type st_21 from so_statictext within w_customer_complaints_master
integer x = 27
integer y = 104
integer width = 567
integer height = 56
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Complaints No"
end type

type st_5 from so_statictext within w_customer_complaints_master
integer x = 599
integer y = 104
integer width = 503
integer height = 56
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Item Code"
end type

type uo_item from uo_item_code within w_customer_complaints_master
integer x = 599
integer y = 176
integer taborder = 90
boolean bringtotop = true
end type

on uo_item.destroy
call uo_item_code::destroy
end on

type st_14 from so_statictext within w_customer_complaints_master
integer x = 1120
integer y = 104
integer width = 521
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Item Name"
end type

type sle_item_name from so_singlelineedit within w_customer_complaints_master
integer x = 1120
integer y = 176
integer width = 521
integer height = 84
integer taborder = 30
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

event modified;call super::modified;//=====================================
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

type sle_key_word from so_singlelineedit within w_customer_complaints_master
integer x = 1646
integer y = 176
integer width = 603
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

event modified;call super::modified;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

LVS_COLUMN = "KEY_WORD"

IF ISNULL(LVS_COLUMN) OR LEN(LVS_COLUMN) = 0 THEN RETURN 

DW_1.SETFILTER('')
DW_1.FILTER()

IF THIS.TEXT = '' THEN 
	DW_1.SETFILTER('')
	DW_1.FILTER()
	RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

DW_1.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
DW_1.FILTER()
F_MSG_MDI_HELP( STRING( DW_1.ROWCOUNT() ) + " Found")
end event

type st_1 from so_statictext within w_customer_complaints_master
integer x = 1646
integer y = 104
integer width = 603
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Key Word"
end type

type st_2 from so_statictext within w_customer_complaints_master
integer x = 2254
integer y = 104
integer width = 759
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Customer Code"
end type

type sle_department_code from so_singlelineedit within w_customer_complaints_master
integer x = 3026
integer y = 172
integer width = 475
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

type st_3 from so_statictext within w_customer_complaints_master
integer x = 3026
integer y = 100
integer width = 475
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Department Code"
end type

type sle_user_id from so_singlelineedit within w_customer_complaints_master
integer x = 3506
integer y = 172
integer width = 297
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

type st_4 from so_statictext within w_customer_complaints_master
integer x = 3506
integer y = 100
integer width = 297
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "User ID"
end type

type rb_all from so_radiobutton within w_customer_complaints_master
integer x = 2542
integer y = 368
integer width = 398
boolean bringtotop = true
string text = "All"
boolean checked = true
end type

event clicked;call super::clicked;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

dw_1.SETFILTER('')
dw_1.FILTER()

dw_1.SETFILTER( 'SET_ITEM_YN  LIKE '+"'"+"%"+"'")
dw_1.FILTER()
F_MSG_MDI_HELP( STRING( dw_1.ROWCOUNT() ) + " Found" )
end event

type rb_check_in from so_radiobutton within w_customer_complaints_master
integer x = 2967
integer y = 368
integer width = 398
boolean bringtotop = true
string text = "Check IN"
end type

event clicked;call super::clicked;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

dw_1.SETFILTER('')
dw_1.FILTER()

dw_1.SETFILTER( 'CHECK_IN_OUT  = '+"'"+"I"+"'")
dw_1.FILTER()
F_MSG_MDI_HELP( STRING( dw_1.ROWCOUNT() ) + " Found")
end event

type rb_check_out from so_radiobutton within w_customer_complaints_master
integer x = 2967
integer y = 464
integer width = 398
boolean bringtotop = true
string text = "Check Out"
end type

event clicked;call super::clicked;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

dw_1.SETFILTER('')
dw_1.FILTER()

dw_1.SETFILTER( 'CHECK_IN_OUT  = '+"'"+"O"+"'")
dw_1.FILTER()
F_MSG_MDI_HELP( STRING( dw_1.ROWCOUNT() ) + " Found")
end event

type rb_locked from so_radiobutton within w_customer_complaints_master
integer x = 3461
integer y = 368
integer width = 398
boolean bringtotop = true
string text = "Locked"
end type

event clicked;call super::clicked;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

dw_1.SETFILTER('')
dw_1.FILTER()

dw_1.SETFILTER( 'STATUS  = '+"'"+"L"+"'")
dw_1.FILTER()
F_MSG_MDI_HELP( STRING( dw_1.ROWCOUNT() ) + " Found")
end event

type rb_unlocked from so_radiobutton within w_customer_complaints_master
integer x = 3461
integer y = 464
integer width = 398
boolean bringtotop = true
string text = "Unlocked"
end type

event clicked;call super::clicked;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

dw_1.SETFILTER('')
dw_1.FILTER()

dw_1.SETFILTER( 'STATUS  = '+"'"+"N"+"'")
dw_1.FILTER()
F_MSG_MDI_HELP( STRING( dw_1.ROWCOUNT() ) + " Found")
end event

type pb_upload from so_picturebutton within w_customer_complaints_master
integer x = 41
integer y = 352
integer width = 256
integer height = 224
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
boolean enabled = false
string text = "Upload complaints"
boolean originalsize = false
string picturename = "drw_upload.bmp"
string disabledname = "drw_upload.bmp"
alignment htextalign = center!
string powertiptext = "Upload complaints"
end type

event clicked;call super::clicked;IF F_OBJECT_ROLE_CHECK() = FALSE THEN  RETURN

int    li_FileNum , loops, i , lvi_count
long   flen, bytes_read , bytes_read_sum , new_pos
blob   LIB_FILE , b
double LVDB_VERSION
string is_filename, is_fullname , LVS_COMPLAINTS_NO , LVS_ITEM_CODE
		
		IF  dw_2.GETROW() < 1 THEN 
			 f_msg_mdi_help("DW_2 : $$HEX14$$70b374c730d1200085c725b8c4d62000e4c289d5200058d538c194c6$$ENDHEX$$")
			 RETURN
		END IF
		
		IF dw_2.UPDATE() < 0 THEN 
			RETURN
		END IF
		
		LVS_COMPLAINTS_NO = dw_2.GETITEMSTRING( dw_2.GETROW() , "COMPLAINTS_NO" )
		LVS_ITEM_CODE  = dw_2.GETITEMSTRING( dw_2.GETROW() , "ITEM_CODE" )
		LVDB_VERSION   = dw_2.OBJECT.VERSION[dw_2.GETROW()]
		
		IF LVS_COMPLAINTS_NO ='' OR ISNULL(LVS_COMPLAINTS_NO) THEN 
			RETURN
		END IF		
		
		if GetFileOpenName("Select File", is_fullname, is_filename, "DWG", &
			 + "DWG Files (*.xls),*.XLS," &		 
			 + "GIF Files (*.pdf),*.PDF," &
			 + "BMP Files (*.bmp),*.BMP," &			 
			 + "JPG Files (*.jpg),*.JPG," &
			 + "PPT Files (*.ppt),*.PPT," &			 
			 + "All Files (*.*), *.*") < 1 then return
		
		flen = FileLength(is_fullname)
		
		IF FLEN < 0 THEN 
			ROLLBACK;			
			F_MSGBOX1(9020 ,is_fullname )
			RETURN 
		END IF
		
		li_FileNum = FileOpen(is_fullname,  StreamMode!, Read!, LockRead!)
		
		IF li_FileNum <> -1 THEN
				
					SetPointer(HourGlass!)
					IF flen > 32765 THEN
					
							  IF Mod(flen, 32765) = 0 THEN
									loops = flen/32765
							  ELSE
									loops = (flen/32765) + 1
							  END IF
					ELSE
							  loops = 1
					END IF
					
					new_pos = 1
					FOR i = 1 to loops
							  bytes_read = FileRead(li_FileNum, b)
							  bytes_read_sum = bytes_read_sum + bytes_read
							  LIB_FILE = LIB_FILE + b
							  F_MSG_MDI_HELP( STRING(bytes_read_sum)+"/"+string(flen)+" Bytes Read" )
					NEXT
					
					FileClose(li_FileNum)
					
					
					SELECT count(*) INTO :lvi_count
					  FROM ICOM_CUSTOMER_COMPLAINTS
					 WHERE COMPLAINTS_NO   = :LVS_COMPLAINTS_NO 
						AND ITEM_CODE    = :LVS_ITEM_CODE
						AND VERSION = :LVDB_VERSION
						AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
						  
					IF F_SQL_CHECK() < 0 THEN 
						RETURN
					END IF				  
					
					if lvi_count = 0 then 
						ROLLBACK;									
						F_MSGBOX1( 9021 , is_filename ) 
						return
					end if
						  
					UPDATEBLOB ICOM_CUSTOMER_COMPLAINTS
					     SET COMPLAINTS_IMAGE = :LIB_FILE 
					WHERE COMPLAINTS_NO      = :LVS_COMPLAINTS_NO
					  AND ITEM_CODE       = :LVS_ITEM_CODE
					  AND VERSION = :LVDB_VERSION
					  AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;

				  IF SQLCA.SQLNROWS > 0 THEN

				  ELSE
					  ROLLBACK ;
					  MESSAGEBOX("Error" , is_filename+f_msg(" File Upload To Database Failed",'S') )
					  RETURN
					  
				  END IF;
				  
					UPDATE ICOM_CUSTOMER_COMPLAINTS SET FILE_NAME = :is_filename 
					WHERE COMPLAINTS_NO      = :LVS_COMPLAINTS_NO
					AND ITEM_CODE       = :LVS_ITEM_CODE
					AND VERSION = :LVDB_VERSION
					AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;				  
		
				  IF F_SQL_CHECK() < 0 THEN 
					  RETURN
				  END IF		  
				  
				  COMMIT ;
			         F_MSGBOX(9022)

		END IF
Changedirectory(Gvs_default_directory)
end event

type pb_view from so_picturebutton within w_customer_complaints_master
integer x = 302
integer y = 352
integer width = 256
integer height = 224
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
boolean enabled = false
string text = "View complaints"
boolean originalsize = false
string picturename = "drw_view.bmp"
string disabledname = "drw_view.bmp"
alignment htextalign = center!
string powertiptext = "View complaints"
end type

event clicked;call super::clicked;if dw_2.getrow() < 1 then 
	return
end if

Long Lvl_return
String  lvs_file_name
if dw_2.getrow() < 1 then return 

if Gvs_download_document ='Y' then
else
	F_MSGBOX(9090) //$$HEX12$$98ccacb960d520008cad5cd574c72000c6c5b5c2c8b2e4b2$$ENDHEX$$.	
	return
end if 

if dw_2.object.status[dw_2.getrow()] = 'L' then
	f_msgbox1(9043 , this.text ) 
	return
else

	Lvl_return =  f_download_complaints ( String(dw_2.object.complaints_no[dw_2.getrow()]) , dw_2.object.item_code[dw_2.getrow()]  ,  dw_2.object.version[dw_2.getrow()])
	
	if  Lvl_return > 0 then 
	
		lvs_file_name = Gvs_default_directory+"\Temp\"+dw_2.object.file_name[dw_2.getrow()] 
		
		IF lvs_file_name = '' OR ISNULL(lvs_file_name) THEN 
			RETURN
		END IF
		
		f_shell_execute_by_extention( dw_2.object.file_name[dw_2.getrow()]  , '' ,Gvs_default_directory+'\Temp'  )
		
	else
		
	end if
	Changedirectory(Gvs_default_directory)
end if 

end event

type pb_check_in from so_picturebutton within w_customer_complaints_master
integer x = 562
integer y = 352
integer width = 256
integer height = 224
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
string text = "Check In"
boolean originalsize = false
string picturename = "drw_checkin.bmp"
string disabledname = "drw_checkin.bmp"
alignment htextalign = center!
string powertiptext = "Check In"
end type

event clicked;call super::clicked;string lvs_filename
if dw_2.getrow() < 1 then return
if dw_2.object.status[dw_2.getrow()] = 'L' then
	f_msgbox1(9043 , this.text ) 
	return
end if 

lvs_filename = string( dw_2.object.file_name[dw_2.getrow()]	 )
	
msg = f_msgbox1(1161 , this.text)	

if msg = 1 then 
	
	if dw_2.object.check_in_out_by[dw_2.getrow()]  <> Gvs_user_id then 
		f_msgbox1(507 , dw_2.object.check_in_out_by[dw_2.getrow()]  ) 
		return
	else
		dw_1.object.check_in_out_date[dw_1.getrow()] = f_sysdate()
		dw_1.object.check_in_out[dw_1.getrow()] = 'I'
		dw_1.object.check_in_out_by[dw_1.getrow()] = Gvs_user_id	
		dw_1.trigger event rowfocuschanged( dw_1.getrow() )
		dw_2.object.check_in_out_date[dw_2.getrow()] = f_sysdate()
		dw_2.object.check_in_out[dw_2.getrow()] = 'I'
		dw_2.object.check_in_out_by[dw_2.getrow()] = Gvs_user_id
		pb_view	.enabled = false
		
	end if 
	f_update()
	
	filedelete( Gvs_default_directory+"\"+lvs_filename)
	
end if 
end event

type pb_check_out from so_picturebutton within w_customer_complaints_master
integer x = 818
integer y = 352
integer width = 256
integer height = 224
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
string text = "Check Out"
boolean originalsize = false
string picturename = "drw_checkout.bmp"
string disabledname = "drw_checkout.bmp"
alignment htextalign = center!
string powertiptext = "Check Out"
end type

event clicked;call super::clicked;if dw_2.getrow() < 1 then return
if dw_2.object.status[dw_2.getrow()] = 'L' then
	f_msgbox1(9043 , this.text ) 
	return
end if 

msg = f_msgbox1(1161 , this.text)	

if msg = 1 then 
	
	if dw_2.object.check_in_out[dw_2.getrow()] = 'O' then 
		return
	else
	
		dw_1.object.check_in_out_date[dw_1.getrow()] = f_sysdate()
		dw_1.object.check_in_out[dw_1.getrow()] = 'O'
		dw_1.object.check_in_out_by[dw_1.getrow()] = Gvs_user_id		
		
		dw_1.trigger event rowfocuschanged( dw_1.getrow() )
		
		dw_2.object.check_in_out_date[dw_2.getrow()] = f_sysdate()
		dw_2.object.check_in_out[dw_2.getrow()] = 'O'
		dw_2.object.check_in_out_by[dw_2.getrow()] = Gvs_user_id
		pb_view	.enabled = true
		
	end if 
	f_update()

end if 
end event

type pb_5 from so_picturebutton within w_customer_complaints_master
integer x = 1079
integer y = 352
integer width = 256
integer height = 224
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
string text = "Lock"
boolean originalsize = false
string picturename = "drw_lock.bmp"
string disabledname = "pb_background1.bmp"
alignment htextalign = center!
string powertiptext = "Lock"
end type

event clicked;call super::clicked;
if dw_2.getrow() < 1 then return
msg = f_msgbox1(1161 , this.text ) 
if msg = 1 then 
else
	return
end if 

dw_1.object.status[dw_1.getrow()] = 'L'
dw_2.object.status[dw_2.getrow()] = 'L'
F_UPDATE()

end event

type pb_6 from so_picturebutton within w_customer_complaints_master
integer x = 1339
integer y = 352
integer width = 256
integer height = 224
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
string text = "UnLock"
boolean originalsize = false
string picturename = "drw_unlock.bmp"
string disabledname = "pb_background1.bmp"
alignment htextalign = center!
string powertiptext = "UnLock"
end type

event clicked;call super::clicked;if dw_2.getrow() < 1 then return
msg = f_msgbox1(1161 , this.text ) 
if msg = 1 then 
else
	return
end if 
dw_1.object.status[dw_1.getrow()] = 'N'
dw_2.object.status[dw_2.getrow()] = 'N'
F_UPDATE()

end event

type pb_7 from so_picturebutton within w_customer_complaints_master
integer x = 1600
integer y = 352
integer width = 256
integer height = 224
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
string text = "Lock All"
boolean originalsize = false
string picturename = "drw_lockall.bmp"
string disabledname = "pb_background1.bmp"
alignment htextalign = center!
string powertiptext = "Lock All"
end type

event clicked;call super::clicked;if Gvi_user_level < 8 then 
	return
end if 

msg = f_msgbox1(1161 , this.text ) 
if msg = 1 then 
else
	return
end if 
string lvs_complaints_division
lvs_complaints_division = ddlb_complaints_division.getcode( )+'%'

update icom_customer_complaints set status = 'L' 
where complaints_division like :lvs_complaints_division
   and organization_id = :gvi_organization_id ;

if f_sql_check() < 0 then 
	return
end if 

msg = f_msgbox(1170)
if msg = 1 then 
	commit;
	f_retrieve()
else
	rollback;
end if 

end event

event constructor;call super::constructor;if Gvi_user_level < 8 then 
	this.enabled = false
end if 
end event

type pb_8 from so_picturebutton within w_customer_complaints_master
integer x = 1856
integer y = 352
integer width = 256
integer height = 224
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
string text = "UnLock All"
boolean originalsize = false
string picturename = "drw_unlockall.bmp"
string disabledname = "pb_background1.bmp"
alignment htextalign = center!
string powertiptext = "UnLock All"
end type

event clicked;call super::clicked;if Gvi_user_level < 8 then 
	return
end if 

msg = f_msgbox1(1161 , this.text ) 
if msg = 1 then 
else
	return
end if 

string lvs_complaints_division
lvs_complaints_division = ddlb_complaints_division.getcode( )+'%'


update icom_customer_complaints set status = 'N' 
where complaints_division like :lvs_complaints_division
and organization_id = :gvi_organization_id ;

if f_sql_check() < 0 then 
	return
end if 

msg = f_msgbox(1170)
if msg = 1 then 
	commit;
	f_retrieve()
else
	rollback;
end if 

end event

event constructor;call super::constructor;if Gvi_user_level < 8 then 
	this.enabled = false
end if 
end event

type pb_3 from so_picturebutton within w_customer_complaints_master
integer x = 2176
integer y = 352
integer width = 256
integer height = 224
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
string text = "Upload"
boolean originalsize = false
string picturename = "board_refresh.bmp"
string disabledname = "pb_background1.bmp"
alignment htextalign = center!
string powertiptext = "UnLock All"
end type

event clicked;call super::clicked;//open(w_complaints_batch_popup)
end event

type ddlb_complaints_division from uo_basecode within w_customer_complaints_master
integer x = 3813
integer y = 172
integer width = 517
integer taborder = 70
boolean bringtotop = true
boolean allowedit = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;this.redraw( "COMPLAINTS DIVISION")
end event

type st_6 from so_statictext within w_customer_complaints_master
integer x = 3813
integer y = 108
integer width = 517
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Complaints Division"
end type

type ddlb_customer_code from uo_customer_code_name within w_customer_complaints_master
integer x = 2254
integer y = 176
integer width = 759
integer taborder = 50
boolean bringtotop = true
end type

type gb_where_condition from so_groupbox within w_customer_complaints_master
integer x = 2469
integer y = 300
integer width = 1582
integer height = 292
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Filter"
end type

type gb_1 from so_groupbox within w_customer_complaints_master
integer y = 300
integer width = 2459
integer height = 292
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_2 from so_groupbox within w_customer_complaints_master
integer y = 4
integer width = 4603
integer height = 292
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

