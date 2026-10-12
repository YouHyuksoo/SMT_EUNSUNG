HA$PBExportHeader$w_mcn_jig_master.srw
$PBExportComments$Customer Infromation Manage
forward
global type w_mcn_jig_master from w_main_root
end type
type sle_jig_code from so_singlelineedit within w_mcn_jig_master
end type
type st_1 from so_statictext within w_mcn_jig_master
end type
type sle_jig_lot_no from so_singlelineedit within w_mcn_jig_master
end type
type st_3 from so_statictext within w_mcn_jig_master
end type
type ddlb_jig_type from uo_basecode within w_mcn_jig_master
end type
type st_6 from so_statictext within w_mcn_jig_master
end type
type cb_7 from so_commandbutton within w_mcn_jig_master
end type
type cb_9 from so_commandbutton within w_mcn_jig_master
end type
type ddlb_line_code from uo_line_code within w_mcn_jig_master
end type
type st_line_code from statictext within w_mcn_jig_master
end type
type ddlb_jig_status from uo_basecode within w_mcn_jig_master
end type
type st_4 from statictext within w_mcn_jig_master
end type
type cb_1 from so_commandbutton within w_mcn_jig_master
end type
type sle_from_model from singlelineedit within w_mcn_jig_master
end type
type cb_2 from commandbutton within w_mcn_jig_master
end type
type st_5 from statictext within w_mcn_jig_master
end type
type gb_1 from groupbox within w_mcn_jig_master
end type
type gb_3 from groupbox within w_mcn_jig_master
end type
type gb_2 from groupbox within w_mcn_jig_master
end type
type gb_4 from groupbox within w_mcn_jig_master
end type
end forward

global type w_mcn_jig_master from w_main_root
integer y = 256
integer width = 6217
integer height = 3104
string title = "JIG Master"
sle_jig_code sle_jig_code
st_1 st_1
sle_jig_lot_no sle_jig_lot_no
st_3 st_3
ddlb_jig_type ddlb_jig_type
st_6 st_6
cb_7 cb_7
cb_9 cb_9
ddlb_line_code ddlb_line_code
st_line_code st_line_code
ddlb_jig_status ddlb_jig_status
st_4 st_4
cb_1 cb_1
sle_from_model sle_from_model
cb_2 cb_2
st_5 st_5
gb_1 gb_1
gb_3 gb_3
gb_2 gb_2
gb_4 gb_4
end type
global w_mcn_jig_master w_mcn_jig_master

on w_mcn_jig_master.create
int iCurrent
call super::create
this.sle_jig_code=create sle_jig_code
this.st_1=create st_1
this.sle_jig_lot_no=create sle_jig_lot_no
this.st_3=create st_3
this.ddlb_jig_type=create ddlb_jig_type
this.st_6=create st_6
this.cb_7=create cb_7
this.cb_9=create cb_9
this.ddlb_line_code=create ddlb_line_code
this.st_line_code=create st_line_code
this.ddlb_jig_status=create ddlb_jig_status
this.st_4=create st_4
this.cb_1=create cb_1
this.sle_from_model=create sle_from_model
this.cb_2=create cb_2
this.st_5=create st_5
this.gb_1=create gb_1
this.gb_3=create gb_3
this.gb_2=create gb_2
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_jig_code
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.sle_jig_lot_no
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.ddlb_jig_type
this.Control[iCurrent+6]=this.st_6
this.Control[iCurrent+7]=this.cb_7
this.Control[iCurrent+8]=this.cb_9
this.Control[iCurrent+9]=this.ddlb_line_code
this.Control[iCurrent+10]=this.st_line_code
this.Control[iCurrent+11]=this.ddlb_jig_status
this.Control[iCurrent+12]=this.st_4
this.Control[iCurrent+13]=this.cb_1
this.Control[iCurrent+14]=this.sle_from_model
this.Control[iCurrent+15]=this.cb_2
this.Control[iCurrent+16]=this.st_5
this.Control[iCurrent+17]=this.gb_1
this.Control[iCurrent+18]=this.gb_3
this.Control[iCurrent+19]=this.gb_2
this.Control[iCurrent+20]=this.gb_4
end on

on w_mcn_jig_master.destroy
call super::destroy
destroy(this.sle_jig_code)
destroy(this.st_1)
destroy(this.sle_jig_lot_no)
destroy(this.st_3)
destroy(this.ddlb_jig_type)
destroy(this.st_6)
destroy(this.cb_7)
destroy(this.cb_9)
destroy(this.ddlb_line_code)
destroy(this.st_line_code)
destroy(this.ddlb_jig_status)
destroy(this.st_4)
destroy(this.cb_1)
destroy(this.sle_from_model)
destroy(this.cb_2)
destroy(this.st_5)
destroy(this.gb_1)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.gb_4)
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
Ivs_resize_type    = 'MASTER_DETAIL_145TF_23M'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
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
STRING LVS_RCV_ISS_TYPE
CHOOSE CASE Gvs_Ue_DATA_control
	CASE 'RETRIEVE'
		
				DW_1.RESET( )
				DW_1.RETRIEVE(  sle_jig_code.text+'%' ,  sle_jig_lot_no.text+'%' ,  ddlb_jig_type.getcode( )+'%' ,   ddlb_line_code.text+'%' , ddlb_jig_status.getcode( )+'%' ,   Gvi_organization_id )
		
	CASE	'INSERT'
		
			DW_2.ENABLED = TRUE
			ROW = DW_2.INSERTROW(DW_2.GETROW())
			DW_2.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')				
			DW_2.OBject.USE_STATUS[ROW] = 'U'
			DW_2.OBject.LINE_CODE[ROW] = '*'
			DW_2.OBject.WORKSTAGE_CODE[ROW] = '*'			
			DW_2.OBject.USE_RATE[ROW] = 100
			DW_2.OBject.CUSTOMER_CODE[ROW] = '*'
			DW_2.OBject.SUPPLIER_CODE[ROW] = '*'				
			DW_2.OBject.RECEIPT_DATE[ROW] =F_SYSDATE()			
			
	CASE	'APPEND'
		
			DW_3.ENABLED = TRUE
			ROW = DW_3.INSERTROW(0)
			DW_3.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_3 , ROW ,'ALL')		
			
		
			IF DW_1.GETROW() < 1 THEN 
				RETURN 
			END IF 
		
			DW_3.OBject.JIG_CODE[ROW] = DW_1.OBject.JIG_CODE[DW_1.GETROW()]
			DW_3.OBject.JIG_LOT_NO[ROW] = DW_1.OBject.JIG_LOT_NO[DW_1.GETROW()]
			
			
	CASE	'DELETE'
		
			if DW_2.AcceptText() = -1 then
				return
			end if
			
			MSG = F_MSGBOX(1003)  //$$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?
			IF MSG = 1 THEN
				Gvl_row_deleted = DW_2.GetRow()			
				DW_2.DELETEROW(Gvl_row_deleted)		
				DW_2.SetFocus()
				ROW = DW_2.GetRow()
				DW_2.ScrollToRow(row)
				DW_2.SetColumn(1)
			END IF

	CASE 'UPDATE'

	         IF DW_1.UPDATE() < 0 or DW_2.UPDATE() < 0 or DW_3.UPDATE() < 0 THEN
			  	 ROLLBACK;
			ELSE
				 COMMIT;
	                F_RETRIEVE()
				 F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
			END IF

 		
	CASE ELSE
END CHOOSE


end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
end event

type dw_5 from w_main_root`dw_5 within w_mcn_jig_master
integer y = 288
end type

type dw_4 from w_main_root`dw_4 within w_mcn_jig_master
integer y = 288
integer taborder = 80
end type

type dw_3 from w_main_root`dw_3 within w_mcn_jig_master
integer x = 2126
integer y = 1676
integer width = 2478
integer height = 992
integer taborder = 70
boolean titlebar = true
string dataobject = "d_mcn_jig_apply_model_lst"
end type

event dw_3::rbuttondown;call super::rbuttondown;if dwo.name = 'item_code' then 
	
	open(w_des_model_master_popup)
	
	if Gst_return.gvb_return = true then 
		
		this.object.item_code[row] = Gst_return.gvs_return[2]  //$$HEX6$$00b35cd42000a8ba78b32000$$ENDHEX$$
		
		
	end if 
	
elseif dwo.name = 'smt_model_name' then 
	
	open(w_des_model_master_popup)
	
	if Gst_return.gvb_return = true then 
		
		this.object.item_code[row] = Gst_return.gvs_return[1]  //smt $$HEX3$$a8ba78b32000$$ENDHEX$$
	end if 
end if 
end event

type dw_2 from w_main_root`dw_2 within w_mcn_jig_master
integer x = 5
integer y = 1676
integer width = 2112
integer height = 992
integer taborder = 100
boolean titlebar = true
string title = "JIG Detail List"
string dataobject = "d_mcn_jig_mst"
boolean hsplitscroll = false
borderstyle borderstyle = styleraised!
end type

event dw_2::rbuttondown;call super::rbuttondown;if dwo.name = 'customer_code' THEN 
	
	open(w_com_customer_popup)
	
	if gst_return.gvb_return = true then
		this.object.customer_code[this.getrow()] = message.stringparm
	end if 
end if 		


if dwo.name = 'supplier_code' THEN 
	
	open(w_com_supplier_popup)
	
	if gst_return.gvb_return = true then
		this.object.supplier_code[this.getrow()] = message.stringparm
	end if 
end if 		


if dwo.name = 'mold_code' then 
	open(w_mcn_mold_popup)
	if 	GST_RETURN.GVB_RETURN = TRUE then 
		this.object.mold_code[row] = message.stringparm
		this.object.mold_version[row] = Gst_return.gvl_return[1]
		this.object.mold_set_serial[row] = Gst_return.gvl_return[2]
	else
	end if 		
end if 
end event

event dw_2::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return

dw_3.retrieve( dw_2.object.jig_code[currentrow] , dw_2.object.jig_lot_no[currentrow]  , gvi_organization_id )
end event

type dw_1 from w_main_root`dw_1 within w_mcn_jig_master
integer y = 292
integer width = 4599
integer height = 1372
boolean titlebar = true
string title = "JIG List"
string dataobject = "d_mcn_jig_lst"
end type

event dw_1::doubleclicked;call super::doubleclicked;IF	ROW < 1	THEN	RETURN
DW_2.RETRIEVE( DW_1.GETITEMSTRING( ROW, 'ROWID' ))
end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;IF	CURRENTROW < 1	THEN	RETURN
DW_2.RETRIEVE( DW_1.GETITEMSTRING( CURRENTROW, 'ROWID' ))



end event

event dw_1::uo_mousemove;call super::uo_mousemove;//if row < 1 then return
//IF   GVS_SHOW_MACHINE_IMAGE = 'Y' AND ( UPPER(DWO.TYPE) = 'COLUMN' AND  UPPER(DWO.NAME) = 'MACHINE_CODE'  ) THEN
//
//	 IF ISVALID(W_MACHINE_REPAIR_IMAGE_FLAT) THEN
//		RETURN
//	ELSE
//			OPENWITHPARM(W_MACHINE_IMAGE_FLAT , STRING(THIS.OBJECT.MACHINE_CODE[ROW]))
//	END IF 
//ELSE
//
//	IF isvalid(W_MACHINE_IMAGE_FLAT) then
//		close(W_MACHINE_IMAGE_FLAT)
//	end if 
//END IF
end event

type uo_tabpages from w_main_root`uo_tabpages within w_mcn_jig_master
end type

type sle_jig_code from so_singlelineedit within w_mcn_jig_master
integer x = 846
integer y = 152
integer width = 457
integer taborder = 20
boolean bringtotop = true
textcase textcase = upper!
end type

type st_1 from so_statictext within w_mcn_jig_master
integer x = 846
integer y = 80
integer width = 457
integer height = 56
boolean bringtotop = true
string text = "JIG Code"
end type

type sle_jig_lot_no from so_singlelineedit within w_mcn_jig_master
integer x = 1312
integer y = 152
integer width = 891
integer taborder = 30
boolean bringtotop = true
end type

type st_3 from so_statictext within w_mcn_jig_master
integer x = 1312
integer y = 80
integer width = 891
integer height = 56
boolean bringtotop = true
string text = "JIG Lot No"
end type

type ddlb_jig_type from uo_basecode within w_mcn_jig_master
integer x = 32
integer y = 148
integer width = 805
integer taborder = 60
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'JIG TYPE')
end event

type st_6 from so_statictext within w_mcn_jig_master
integer x = 37
integer y = 80
integer width = 805
integer height = 56
boolean bringtotop = true
long textcolor = 0
string text = "Jig Type"
end type

type cb_7 from so_commandbutton within w_mcn_jig_master
integer x = 3365
integer y = 68
integer width = 535
integer height = 92
integer taborder = 20
boolean bringtotop = true
string text = "Image Upload"
end type

event clicked;call super::clicked;if f_object_role_check() = false then  return

int    li_filenum , loops, i , lvi_count
long   flen, bytes_read , bytes_read_sum , new_pos
blob   lib_file , b
double lvdb_version   , lvdb_set_serial

string is_filename, is_fullname , lvs_drawing_no , lvs_jig_code
		
		if  dw_1.getrow() < 1 then 
			 return
		end if
			
			lvs_jig_code  = dw_1.getitemstring( dw_1.getrow() , "jig_code" )
	
		if lvs_jig_code ='' or isnull(lvs_jig_code) then 
			return
		end if		
		
		if getfileopenname("select file", is_fullname, is_filename, "jpg", &
			 + "jpg files (*.jpg),*.jpg," &	
			 + "gif files (*.gif),*.gif," &
			 + "bmp files (*.bmp),*.bmp," &			 
			 + "all files (*.*), *.*") < 1 then return
		
		flen = filelength(is_fullname)
		
		if flen < 0 then 
			rollback;			
			f_msgbox1(9020 ,is_fullname )
			return 
		end if
		
		li_filenum = fileopen(is_fullname,  streammode!, read!, lockread!)
		
		if li_filenum <> -1 then
				
					setpointer(hourglass!)
					if flen > 32765 then
					
							  if mod(flen, 32765) = 0 then
									loops = flen/32765
							  else
									loops = (flen/32765) + 1
							  end if
					else
							  loops = 1
					end if
					
					new_pos = 1
					for i = 1 to loops
							  bytes_read = fileread(li_filenum, b)
							  bytes_read_sum = bytes_read_sum + bytes_read
							  lib_file = lib_file + b
							  f_msg_mdi_help( string(bytes_read_sum)+"/"+string(flen)+" bytes read" )
					next
					
					fileclose(li_filenum)
					
					update imcn_jig set jig_image_file_name = :is_filename 
					       where jig_code       = :lvs_jig_code
					          and organization_id = :gvi_organization_id ;
								 
					if f_sql_check() < 0 then 
						return
					end if 
										  
					updateblob imcn_jig set jig_image = :lib_file 
					       where jig_code       = :lvs_jig_code
					          and organization_id = :gvi_organization_id ;

				  if sqlca.sqlnrows > 0 then

				  else
					  rollback ;
					  messagebox("error" , is_filename+" file upload to database failed "+sqlca.sqlerrtext )
					  return
				  end if;

				  commit ;
			         f_msgbox(9022)
		end if
changedirectory(gvs_default_directory)
end event

type cb_9 from so_commandbutton within w_mcn_jig_master
integer x = 3365
integer y = 160
integer width = 535
integer height = 92
integer taborder = 30
boolean bringtotop = true
string text = "Image Delete"
end type

event clicked;call super::clicked;if f_object_role_check() = false then  return
string lvs_jig_code
blob lblob_null

setnull(lblob_null)

lblob_null = blob(' ')

int lvi_count
				if  dw_1.getrow() < 1 then 
					 return
				end if
			
				lvs_jig_code  = dw_1.getitemstring( dw_1.getrow() , "jig_code" )
				if lvs_jig_code ='' or isnull(lvs_jig_code) then 
					return
				end if		
				
					updateblob  imcn_jig set jig_image = :lblob_null
					where jig_code  = :lvs_jig_code
					  and organization_id   = :gvi_organization_id ;

					if f_sql_check() < 0 then 
						return 
					else
						commit ;
						f_msgbox(9022)
					end if 
changedirectory(gvs_default_directory)

end event

type ddlb_line_code from uo_line_code within w_mcn_jig_master
integer x = 2213
integer y = 148
integer width = 443
integer height = 904
integer taborder = 40
boolean bringtotop = true
end type

type st_line_code from statictext within w_mcn_jig_master
integer x = 2213
integer y = 84
integer width = 443
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Line Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_jig_status from uo_basecode within w_mcn_jig_master
integer x = 2661
integer y = 148
integer width = 613
integer taborder = 30
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'JIG STATUS')
end event

type st_4 from statictext within w_mcn_jig_master
integer x = 2670
integer y = 80
integer width = 594
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "JIG Status"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_1 from so_commandbutton within w_mcn_jig_master
integer x = 3991
integer y = 72
integer width = 535
integer height = 92
integer taborder = 40
boolean bringtotop = true
string text = "Destroy"
end type

event clicked;call super::clicked;if dw_2.getrow() < 1 then return


msg = f_msgbox1( 1161 , this.text ) 
if msg = 1 then 
else
	return 
end if 

dw_2.object.jig_status[dw_2.getrow()] = 'B' //$$HEX3$$d0d330ae2000$$ENDHEX$$
dw_2.object.use_status[dw_2.getrow()] = 'S' //$$HEX5$$acc0a9c611c9c0c92000$$ENDHEX$$

if dw_2.update( ) < 0 then 
	rollback;
else
	commit ;
end if
end event

type sle_from_model from singlelineedit within w_mcn_jig_master
integer x = 4649
integer y = 148
integer width = 718
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_2 from commandbutton within w_mcn_jig_master
integer x = 5445
integer y = 96
integer width = 448
integer height = 128
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Copy"
end type

event clicked;
string lvs_from_jig, lvs_to_jig, lvs_jig_type
long   lvl_row, lvl_ret

lvl_row = dw_1.getrow()

IF ( lvl_row > 0 ) THEN 
	
//---------------------------------------------------------------------------
// $$HEX17$$01c8a9c6a8ba78b315c8f4bc2000f5bcacc0200004c8200000b3c1c0200055d678c7$$ENDHEX$$
//---------------------------------------------------------------------------

      lvs_from_jig = trim( sle_from_model.text )	
      lvs_to_jig = dw_1.object.jig_lot_no[lvl_row] 		
  	 lvs_jig_type = dw_1.object.jig_type[lvl_row] 
		
      select count(*)
	   into :lvl_row
       from imcn_jig
	where jig_type    = :lvs_jig_type
	    and jig_lot_no = :lvs_from_jig;
		
       if ( f_sql_check() < 0 ) then 
		
		  return;
		  
	  else
		
		  IF ( lvl_row = 0 ) THEN
			
			   lvl_ret = MessageBox("Apply Model Copy", "$$HEX23$$38cc70c8200060d52000c0c9f8ad00ac2000c6c570ac98b02000c0c9f8ad20c715d674c72000e4b285b9c8b2e4b2$$ENDHEX$$")
		       RETURN;
		  
		  END IF;
		
		
	  end if;			
		
      IF ( lvs_to_jig='' OR ISNULL( lvs_to_jig ) ) THEN
			
		   lvl_ret = MessageBox("JApply Model Copy", "$$HEX15$$38cc70c8200060d52000c0c9f8ad7cb9200085c725b8200058d538c194c6$$ENDHEX$$")
		   RETURN;
		
	  END IF;
		
      IF ( lvs_from_jig='' OR ISNULL( lvs_from_jig ) ) THEN
			
		   lvl_ret = MessageBox("Apply Model Copy", "$$HEX15$$f5bcacc0200060d52000c0c9f8ad7cb9200020c1ddd0200058d538c194c6$$ENDHEX$$")
		  RETURN;
			
	  END IF;
	  
	  IF ( lvs_to_jig = lvs_from_jig ) THEN
			
		   lvl_ret = MessageBox("Apply Model Copy", "$$HEX23$$38cc70c860d52000c0c9f8ad40c62000f5bcacc0200060d52000c0c9f8ad00ac2000d9b37cc7200069d5c8b2e4b2$$ENDHEX$$")
		  RETURN;
			
	  END IF;
	  
//---------------------------------------------------------------------------
// $$HEX10$$e4c289d5ecc580bd2000e4b2dcc2200055d678c7$$ENDHEX$$
//---------------------------------------------------------------------------	  

      lvl_ret =  MessageBox("Apply Model Copy", lvs_from_jig +  "$$HEX11$$58c7200001c8a9c6a8ba78b3200015c8f4bc7cb92000$$ENDHEX$$" + lvs_to_jig + "$$HEX8$$d0c52000f5bcacc0200060d54cae94c6$$ENDHEX$$?",  Exclamation!, OKCancel!, 2)
     
	  IF lvl_ret = 1 THEN
		 
      ELSE
          RETURN;
      END IF

//---------------------------------------------------------------------------
// $$HEX9$$01c8a9c6a8ba78b315c8f4bc2000f5bcacc0$$ENDHEX$$
//---------------------------------------------------------------------------

      delete from imcn_jig_apply_model
      where jig_lot_no = :lvs_to_jig;
		
	  if ( f_sql_check() < 0 ) then 
		
		  rollback;
		  return;
		
	  end if;
	  
	 insert into imcn_jig_apply_model (
	                                                         jig_code, 
                                                             jig_lot_no, 
                                                             item_code, 
                                                             organization_id, 
                                                             enter_by, 
                                                             enter_date, 
                                                             last_modify_by, 
                                                             last_modify_date, 
                                                             apply_smt_model_name
	                                                      )
      select  :lvs_to_jig, 
                :lvs_to_jig, 
                item_code, 
                organization_id, 
                'COPY', 
                sysdate, 
                'COPY', 
                sysdate, 
                apply_smt_model_name
	   from imcn_jig_apply_model
     where jig_lot_no = :lvs_from_jig;
	  
	lvl_row = sqlca.sqlnrows 
		  
  
  if ( f_sql_check() < 0 ) then 
	
	  rollback;
	  return;
	  
  else	 
	
	commit;
	lvl_ret = MessageBox("Apply Model Copy", string( lvl_row ) + "$$HEX10$$74ac2000f5bcacc0200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$")
	
  end if 	  
	 
	  
//---------------------------------------------------------------------------
//  $$HEX7$$f5bcacc0b0acfcac200055d678c7$$ENDHEX$$
//---------------------------------------------------------------------------		  
	 
	
END IF
end event

type st_5 from statictext within w_mcn_jig_master
integer x = 4695
integer y = 80
integer width = 594
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Target Jig - Lot No"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_mcn_jig_master
integer x = 14
integer width = 3278
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

type gb_3 from groupbox within w_mcn_jig_master
integer x = 3950
integer width = 622
integer height = 272
integer taborder = 20
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

type gb_2 from groupbox within w_mcn_jig_master
integer x = 3310
integer width = 622
integer height = 272
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Image"
end type

type gb_4 from groupbox within w_mcn_jig_master
integer x = 4599
integer width = 1362
integer height = 272
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Apply Model Copy"
end type

