HA$PBExportHeader$w_mcn_sample_master.srw
$PBExportComments$Sample Master Infromation Manage
forward
global type w_mcn_sample_master from w_main_root
end type
type sle_sample_code from so_singlelineedit within w_mcn_sample_master
end type
type st_1 from so_statictext within w_mcn_sample_master
end type
type ddlb_sample_type from uo_basecode within w_mcn_sample_master
end type
type st_6 from so_statictext within w_mcn_sample_master
end type
type ddlb_sample_status from uo_basecode within w_mcn_sample_master
end type
type st_4 from statictext within w_mcn_sample_master
end type
type sle_from_model from singlelineedit within w_mcn_sample_master
end type
type cb_1 from commandbutton within w_mcn_sample_master
end type
type st_3 from statictext within w_mcn_sample_master
end type
type st_5 from so_statictext within w_mcn_sample_master
end type
type st_7 from so_statictext within w_mcn_sample_master
end type
type gb_1 from groupbox within w_mcn_sample_master
end type
type gb_2 from groupbox within w_mcn_sample_master
end type
type sle_remian_days from so_singlelineedit within w_mcn_sample_master
end type
type st_8 from so_statictext within w_mcn_sample_master
end type
type sle_sample_name from so_singlelineedit within w_mcn_sample_master
end type
type st_9 from so_statictext within w_mcn_sample_master
end type
type sle_location_address from so_singlelineedit within w_mcn_sample_master
end type
type st_2 from statictext within w_mcn_sample_master
end type
type ddlb_use_status from uo_basecode within w_mcn_sample_master
end type
end forward

global type w_mcn_sample_master from w_main_root
integer y = 256
integer width = 5883
integer height = 3104
string title = "Sample Master"
sle_sample_code sle_sample_code
st_1 st_1
ddlb_sample_type ddlb_sample_type
st_6 st_6
ddlb_sample_status ddlb_sample_status
st_4 st_4
sle_from_model sle_from_model
cb_1 cb_1
st_3 st_3
st_5 st_5
st_7 st_7
gb_1 gb_1
gb_2 gb_2
sle_remian_days sle_remian_days
st_8 st_8
sle_sample_name sle_sample_name
st_9 st_9
sle_location_address sle_location_address
st_2 st_2
ddlb_use_status ddlb_use_status
end type
global w_mcn_sample_master w_mcn_sample_master

on w_mcn_sample_master.create
int iCurrent
call super::create
this.sle_sample_code=create sle_sample_code
this.st_1=create st_1
this.ddlb_sample_type=create ddlb_sample_type
this.st_6=create st_6
this.ddlb_sample_status=create ddlb_sample_status
this.st_4=create st_4
this.sle_from_model=create sle_from_model
this.cb_1=create cb_1
this.st_3=create st_3
this.st_5=create st_5
this.st_7=create st_7
this.gb_1=create gb_1
this.gb_2=create gb_2
this.sle_remian_days=create sle_remian_days
this.st_8=create st_8
this.sle_sample_name=create sle_sample_name
this.st_9=create st_9
this.sle_location_address=create sle_location_address
this.st_2=create st_2
this.ddlb_use_status=create ddlb_use_status
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_sample_code
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.ddlb_sample_type
this.Control[iCurrent+4]=this.st_6
this.Control[iCurrent+5]=this.ddlb_sample_status
this.Control[iCurrent+6]=this.st_4
this.Control[iCurrent+7]=this.sle_from_model
this.Control[iCurrent+8]=this.cb_1
this.Control[iCurrent+9]=this.st_3
this.Control[iCurrent+10]=this.st_5
this.Control[iCurrent+11]=this.st_7
this.Control[iCurrent+12]=this.gb_1
this.Control[iCurrent+13]=this.gb_2
this.Control[iCurrent+14]=this.sle_remian_days
this.Control[iCurrent+15]=this.st_8
this.Control[iCurrent+16]=this.sle_sample_name
this.Control[iCurrent+17]=this.st_9
this.Control[iCurrent+18]=this.sle_location_address
this.Control[iCurrent+19]=this.st_2
this.Control[iCurrent+20]=this.ddlb_use_status
end on

on w_mcn_sample_master.destroy
call super::destroy
destroy(this.sle_sample_code)
destroy(this.st_1)
destroy(this.ddlb_sample_type)
destroy(this.st_6)
destroy(this.ddlb_sample_status)
destroy(this.st_4)
destroy(this.sle_from_model)
destroy(this.cb_1)
destroy(this.st_3)
destroy(this.st_5)
destroy(this.st_7)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.sle_remian_days)
destroy(this.st_8)
destroy(this.sle_sample_name)
destroy(this.st_9)
destroy(this.sle_location_address)
destroy(this.st_2)
destroy(this.ddlb_use_status)
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
				DW_1.RETRIEVE(  sle_sample_code.text+'%' ,  ddlb_sample_type.getcode( )+'%' ,  ddlb_sample_status.getcode( )+'%' ,  ddlb_use_status.getcode( )+'%' , sle_remian_days.text,  Gvi_organization_id, sle_sample_name.text+'%', sle_location_address.text+'%' )
		
	CASE	'INSERT'
		
			DW_2.ENABLED = TRUE
			ROW = DW_2.INSERTROW(DW_2.GETROW())
			DW_2.SCROLLTOROW(ROW)
			
			F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')	
			
			DW_2.OBject.USE_STATUS[ROW] = 'U'
			DW_2.OBject.LINE_CODE[ROW] = '*'
			DW_2.OBject.WORKSTAGE_CODE[ROW] = '*'			
			DW_2.OBject.SAMPLE_APPLY_DATE[ROW] =F_SYSDATE()			
			DW_2.OBject.VALID_MONTHS[ROW] =12	
			
	CASE	'APPEND'
		
			DW_3.ENABLED = TRUE
			ROW = DW_3.INSERTROW(0)
			DW_3.SCROLLTOROW(ROW)
			
			F_SET_SECURITY_ROW(DW_3 , ROW ,'ALL')		
			
		
			IF DW_2.GETROW() < 1 THEN 
				RETURN 
			END IF 
		
			DW_3.OBject.SAMPLE_CODE[ROW] = DW_2.OBject.SAMPLE_CODE[DW_2.GETROW()]
			DW_3.OBject.SAMPLE_LOT_NO[ROW] = DW_2.OBject.SAMPLE_LOT_NO[DW_2.GETROW()]
			
			
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

	         IF DW_2.UPDATE() < 0 or DW_3.UPDATE() < 0 THEN
			  	 ROLLBACK;
			ELSE
				 COMMIT;
				
				ROW = dw_1.getrow()				 
	              F_RETRIEVE()					  
				DW_1.ScrollToRow(row)
				
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

type dw_5 from w_main_root`dw_5 within w_mcn_sample_master
integer y = 288
end type

type dw_4 from w_main_root`dw_4 within w_mcn_sample_master
integer y = 288
integer taborder = 80
end type

type dw_3 from w_main_root`dw_3 within w_mcn_sample_master
integer x = 2126
integer y = 1676
integer width = 2478
integer height = 992
integer taborder = 70
boolean titlebar = true
string title = "Apply Model List"
string dataobject = "d_mcn_sample_apply_model_lst"
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

type dw_2 from w_main_root`dw_2 within w_mcn_sample_master
integer x = 5
integer y = 1676
integer width = 2112
integer height = 992
integer taborder = 100
boolean titlebar = true
string title = "Detail List"
string dataobject = "d_mcn_sample_mst"
boolean hsplitscroll = false
borderstyle borderstyle = styleraised!
end type

event dw_2::rowfocuschanged;if currentrow < 1 then return

dw_3.retrieve( dw_2.object.sample_code[currentrow] , dw_2.object.sample_lot_no[currentrow]  , gvi_organization_id )
end event

type dw_1 from w_main_root`dw_1 within w_mcn_sample_master
integer y = 292
integer width = 4599
integer height = 1372
boolean titlebar = true
string title = "Sample Master List"
string dataobject = "d_mcn_sample_lst"
end type

event dw_1::doubleclicked;call super::doubleclicked;//IF	ROW < 1	THEN	RETURN
//DW_2.RETRIEVE( DW_1.GETITEMSTRING( ROW, 'ROWID' ))
end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;IF	CURRENTROW < 1	THEN	RETURN
DW_2.RETRIEVE( DW_1.GETITEMSTRING( CURRENTROW, 'ROWID' ))

DW_2.setfocus( )
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

type uo_tabpages from w_main_root`uo_tabpages within w_mcn_sample_master
end type

type sle_sample_code from so_singlelineedit within w_mcn_sample_master
integer x = 859
integer y = 148
integer width = 457
integer taborder = 20
boolean bringtotop = true
textcase textcase = upper!
end type

type st_1 from so_statictext within w_mcn_sample_master
integer x = 859
integer y = 80
integer width = 457
integer height = 56
boolean bringtotop = true
string text = "Sample Code"
end type

type ddlb_sample_type from uo_basecode within w_mcn_sample_master
integer x = 41
integer y = 148
integer width = 805
integer taborder = 60
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'SAMPLE TYPE')
end event

type st_6 from so_statictext within w_mcn_sample_master
integer x = 46
integer y = 80
integer width = 805
integer height = 56
boolean bringtotop = true
long textcolor = 0
string text = "Sample Type"
end type

type ddlb_sample_status from uo_basecode within w_mcn_sample_master
integer x = 1330
integer y = 148
integer width = 521
integer taborder = 30
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'SAMPLE STATUS')
end event

type st_4 from statictext within w_mcn_sample_master
integer x = 1330
integer y = 80
integer width = 521
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Sample Status"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_from_model from singlelineedit within w_mcn_sample_master
integer x = 4137
integer y = 148
integer width = 718
integer height = 80
integer taborder = 40
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

type cb_1 from commandbutton within w_mcn_sample_master
integer x = 4933
integer y = 96
integer width = 448
integer height = 128
integer taborder = 20
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
string lvs_from_jig, lvs_jig_type, lvs_to_jig
long   lvl_row, lvl_ret

lvl_row = dw_1.getrow()

IF ( lvl_row > 0 ) THEN 
	
//---------------------------------------------------------------------------
// $$HEX17$$01c8a9c6a8ba78b315c8f4bc2000f5bcacc0200004c8200000b3c1c0200055d678c7$$ENDHEX$$
//---------------------------------------------------------------------------

      lvs_from_jig = trim( sle_from_model.text )	
		
      lvs_to_jig = dw_1.object.sample_lot_no[lvl_row] 
  	 lvs_jig_type = dw_1.object.sample_type[lvl_row] 
		
      select count(*)
	   into :lvl_row
       from imcn_sample
	where sample_type   = :lvs_jig_type
	   and sample_lot_no = :lvs_from_jig;
		
       if ( f_sql_check() < 0 ) then 
		
		  return;
		  
	  else
		
		  IF ( lvl_row = 0 ) THEN
			
			   lvl_ret = MessageBox("Apply Model Copy", "$$HEX23$$38cc70c8200060d52000c0c9f8ad00ac2000c6c570ac98b02000d8c00cd520c715d674c72000e4b285b9c8b2e4b2$$ENDHEX$$")
		       RETURN;
		  
		  END IF;
		
		
	  end if;	
	  		
		
      IF ( lvs_to_jig='' OR ISNULL( lvs_to_jig ) ) THEN
			
		   lvl_ret = MessageBox("Apply Model Copy", "$$HEX15$$38cc70c8200060d52000d8c00cd57cb9200085c725b8200058d538c194c6$$ENDHEX$$")
		   RETURN;
		
	  END IF;
		
      IF ( lvs_from_jig='' OR ISNULL( lvs_from_jig ) ) THEN
			
		   lvl_ret = MessageBox("Apply Model Copy", "$$HEX15$$f5bcacc0200060d52000d8c00cd57cb9200020c1ddd0200058d538c194c6$$ENDHEX$$")
		  RETURN;
			
	  END IF;
	  
	  IF ( lvs_to_jig = lvs_from_jig ) THEN
			
		   lvl_ret = MessageBox("Apply Model Copy", "$$HEX23$$38cc70c860d52000d8c00cd5fcac2000f5bcacc0200060d52000d8c00cd574c72000d9b37cc7200069d5c8b2e4b2$$ENDHEX$$")
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

      delete from imcn_sample_apply_model
      where sample_lot_no = :lvs_to_jig;
		
	  if ( f_sql_check() < 0 ) then 
		
		  return;
		
	  end if;
	  
	 insert into imcn_sample_apply_model (
	                                                         sample_code, 
                                                             sample_lot_no, 
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
	   from imcn_sample_apply_model
     where sample_lot_no = :lvs_from_jig;
	  
     lvl_row = sqlca.sqlnrows 
		  
  if ( f_sql_check() < 0 ) then 
	
	  rollback;
	  RETURN;
	  
  else
	
  	 lvl_ret = MessageBox("Apply Model Copy", string( lvl_row ) + "$$HEX10$$74ac2000f5bcacc0200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$")
	
	commit;
	
  end if 	  
	 
	  
//---------------------------------------------------------------------------
//  $$HEX7$$f5bcacc0b0acfcac200055d678c7$$ENDHEX$$
//---------------------------------------------------------------------------		  
	
END IF
end event

type st_3 from statictext within w_mcn_sample_master
integer x = 4183
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
string text = "Target Sample - Lot No"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_5 from so_statictext within w_mcn_sample_master
integer x = 3525
integer y = 80
integer width = 457
integer height = 56
boolean bringtotop = true
string text = "Remain Days"
end type

type st_7 from so_statictext within w_mcn_sample_master
integer x = 3566
integer y = 160
integer width = 151
integer height = 52
boolean bringtotop = true
string text = ">="
end type

type gb_1 from groupbox within w_mcn_sample_master
integer x = 4087
integer width = 1362
integer height = 272
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Apply Model Copy"
end type

type gb_2 from groupbox within w_mcn_sample_master
integer x = 14
integer width = 4041
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

type sle_remian_days from so_singlelineedit within w_mcn_sample_master
integer x = 3689
integer y = 148
integer width = 219
integer taborder = 70
boolean bringtotop = true
textcase textcase = upper!
boolean righttoleft = true
end type

type st_8 from so_statictext within w_mcn_sample_master
integer x = 2546
integer y = 80
integer width = 457
integer height = 56
boolean bringtotop = true
string text = "Sample Name"
end type

type sle_sample_name from so_singlelineedit within w_mcn_sample_master
integer x = 2418
integer y = 148
integer width = 640
integer taborder = 70
boolean bringtotop = true
textcase textcase = upper!
end type

type st_9 from so_statictext within w_mcn_sample_master
integer x = 3077
integer y = 80
integer width = 457
integer height = 56
boolean bringtotop = true
string text = "Location Address"
end type

type sle_location_address from so_singlelineedit within w_mcn_sample_master
integer x = 3077
integer y = 148
integer width = 457
integer taborder = 40
boolean bringtotop = true
textcase textcase = upper!
end type

type st_2 from statictext within w_mcn_sample_master
integer x = 1874
integer y = 72
integer width = 521
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Use Status"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_use_status from uo_basecode within w_mcn_sample_master
integer x = 1874
integer y = 148
integer width = 521
integer taborder = 30
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'USE STATUS')
end event

