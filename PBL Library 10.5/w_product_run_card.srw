HA$PBExportHeader$w_product_run_card.srw
$PBExportComments$new a led project
forward
global type w_product_run_card from w_main_root
end type
type sle_run_no from so_singlelineedit within w_product_run_card
end type
type uo_run_date from uo_ymd_calendar within w_product_run_card
end type
type sle_lot_no from so_singlelineedit within w_product_run_card
end type
type uo_dateset from uo_ymd_calendar within w_product_run_card
end type
type uo_dateend from uo_ymd_calendar within w_product_run_card
end type
type cb_2 from so_commandbutton within w_product_run_card
end type
type ddlb_model_name from uo_set_model_name_ddlb within w_product_run_card
end type
type ddlb_line_code from uo_line_code within w_product_run_card
end type
type cb_inventory from so_commandbutton within w_product_run_card
end type
type cb_4 from so_commandbutton within w_product_run_card
end type
type em_carrier_size from so_editmask within w_product_run_card
end type
type st_line_code from so_statictext within w_product_run_card
end type
type st_1 from so_statictext within w_product_run_card
end type
type st_2 from so_statictext within w_product_run_card
end type
type st_3 from so_statictext within w_product_run_card
end type
type st_4 from so_statictext within w_product_run_card
end type
type st_5 from so_statictext within w_product_run_card
end type
type st_6 from so_statictext within w_product_run_card
end type
type rb_1 from so_radiobutton within w_product_run_card
end type
type rb_2 from so_radiobutton within w_product_run_card
end type
type rb_3 from so_radiobutton within w_product_run_card
end type
type st_7 from so_statictext within w_product_run_card
end type
type sle_run_no_cond from so_singlelineedit within w_product_run_card
end type
type ddlb_product_run_type from uo_basecode within w_product_run_card
end type
type st_21 from so_statictext within w_product_run_card
end type
type ddlb_lot_divide from so_dropdownlistbox within w_product_run_card
end type
type st_11 from so_statictext within w_product_run_card
end type
type cb_1 from so_commandbutton within w_product_run_card
end type
type cb_3 from so_commandbutton within w_product_run_card
end type
type rb_bartend from so_radiobutton within w_product_run_card
end type
type rb_machine from so_radiobutton within w_product_run_card
end type
type rb_default_label from so_radiobutton within w_product_run_card
end type
type rb_no_label from so_radiobutton within w_product_run_card
end type
type cbx_create_pid from so_checkbox within w_product_run_card
end type
type st_8 from statictext within w_product_run_card
end type
type ddlb_customer_code from uo_customer_code_name within w_product_run_card
end type
type cbx_1 from so_checkbox within w_product_run_card
end type
type cbx_bom_checck from so_checkbox within w_product_run_card
end type
type rb_isssue_plan from so_radiobutton within w_product_run_card
end type
type cb_6 from so_commandbutton within w_product_run_card
end type
type cbx_force_delete from so_checkbox within w_product_run_card
end type
type em_start_serial from so_editmask within w_product_run_card
end type
type st_9 from so_statictext within w_product_run_card
end type
type ddlb_model_class from uo_basecode within w_product_run_card
end type
type st_10 from so_statictext within w_product_run_card
end type
type st_12 from so_statictext within w_product_run_card
end type
type sle_pcb_week from so_singlelineedit within w_product_run_card
end type
type cb_7 from so_commandbutton within w_product_run_card
end type
type cbx_wsio_auto_retrieve from so_checkbox within w_product_run_card
end type
type gb_2 from so_groupbox within w_product_run_card
end type
type gb_4 from so_groupbox within w_product_run_card
end type
type gb_1 from so_groupbox within w_product_run_card
end type
type gb_5 from so_groupbox within w_product_run_card
end type
type gb_6 from so_groupbox within w_product_run_card
end type
end forward

global type w_product_run_card from w_main_root
integer width = 6181
string title = "Run Card Master"
sle_run_no sle_run_no
uo_run_date uo_run_date
sle_lot_no sle_lot_no
uo_dateset uo_dateset
uo_dateend uo_dateend
cb_2 cb_2
ddlb_model_name ddlb_model_name
ddlb_line_code ddlb_line_code
cb_inventory cb_inventory
cb_4 cb_4
em_carrier_size em_carrier_size
st_line_code st_line_code
st_1 st_1
st_2 st_2
st_3 st_3
st_4 st_4
st_5 st_5
st_6 st_6
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
st_7 st_7
sle_run_no_cond sle_run_no_cond
ddlb_product_run_type ddlb_product_run_type
st_21 st_21
ddlb_lot_divide ddlb_lot_divide
st_11 st_11
cb_1 cb_1
cb_3 cb_3
rb_bartend rb_bartend
rb_machine rb_machine
rb_default_label rb_default_label
rb_no_label rb_no_label
cbx_create_pid cbx_create_pid
st_8 st_8
ddlb_customer_code ddlb_customer_code
cbx_1 cbx_1
cbx_bom_checck cbx_bom_checck
rb_isssue_plan rb_isssue_plan
cb_6 cb_6
cbx_force_delete cbx_force_delete
em_start_serial em_start_serial
st_9 st_9
ddlb_model_class ddlb_model_class
st_10 st_10
st_12 st_12
sle_pcb_week sle_pcb_week
cb_7 cb_7
cbx_wsio_auto_retrieve cbx_wsio_auto_retrieve
gb_2 gb_2
gb_4 gb_4
gb_1 gb_1
gb_5 gb_5
gb_6 gb_6
end type
global w_product_run_card w_product_run_card

type variables

end variables

forward prototypes
public subroutine wf_dw_change (datawindow arg_dw, string arg_model_name)
public subroutine wf_model_part_image ()
end prototypes

public subroutine wf_dw_change (datawindow arg_dw, string arg_model_name);STRING ls_syntax

//if dw_1.getrow() < 1 then return 
ls_syntax	=	f_get_dataobject('REPORT', upper(this.classname()) ,  f_get_dynamic_report_name(arg_model_name, 'PID'))
if	ls_syntax = '' or isnull(ls_syntax) then
//	arg_dw.dataobject  			= 'd_pcb_label_qr_report'
	f_msg_mdi_help("Report Not Changed")
else
	arg_dw.create(ls_syntax)
	arg_dw.settransobject(sqlca)
	f_msg_mdi_help("Report Changed")
end if
end subroutine

public subroutine wf_model_part_image ();/****************************************************************************************
*                                   $$HEX3$$30aef8bc2000$$ENDHEX$$script start
****************************************************************************************/
Blob			item_pic
integer 		li_fileNum,		&
				loop_i
string			ls_item_no
long			ll_length,			&
				ll_length_old,	&
				ll_item__loop
				

ll_item__loop	=	dw_1.rowcount()

if	ll_item__loop	=	0 then return

//// $$HEX17$$f4d354b300ac2000c6c53cc774ba20003cba00c82000ccb9e4b4b4c5200000c9e4b2$$ENDHEX$$.
//If not DirectoryExists ( gvs_default_directory+'\resource' ) Then
//	CreateDirectory ( gvs_default_directory+'\resource'  )
//end if
   
f_msg_mdi_help('Starting Set Picture ...')

setpointer(hourglass!)

/****************************************************
* $$HEX26$$70b374c7c0d0a0bc74c7a4c2d0c51cc1200074c7f8bbc0c9200090c7ccb87cb9200080acc9c058d5e0ac200090c7ccb800ac2000$$ENDHEX$$
  $$HEX14$$88c73cc774ba200054d67cc744c72000ccb9e4b4b4c5200000c9e4b2$$ENDHEX$$.(jpg)
****************************************************/

	
		ls_item_no	=	dw_1.object.model_name[dw_1.getrow()]
		
		SELECTBLOB 	CONTENTS
		INTO				:item_pic 
		FROM				IP_PRODUCT_SPEC_CONFIRM_DOC
		WHERE			MODEL_NAME 	= 	:ls_item_no 
		AND organization_id = :gvi_organization_id
		AND ROWNUM = 1 ;
			
		
		if sqlca.sqlcode = 100 or isnull( item_pic ) then
			return
		else
			ll_length = len(item_pic) 
		end if
			
		if	fileexists(gvs_default_directory+'\'+ls_item_no+'.jpg') then
			ll_length_old = FileLength(gvs_default_directory+'\'+ls_item_no+'.jpg')
			// $$HEX15$$6cd030ae00ac200019ac3cc774ba2000f8ade5b0200028d3a4c25cd5e4b2$$ENDHEX$$.
			if	ll_length_old = ll_length then
				return		
			else
				FileDelete(gvs_default_directory+'\'+ls_item_no+'.jpg')
				li_filenum = fileopen( gvs_default_directory+'\'+ls_item_no+'.jpg' , streamMode!, write!, lockwrite!)
				FileWriteEX(li_filenum, item_pic , ll_length )			
				fileclose( li_filenum )
			end if
		else
			li_filenum = fileopen( gvs_default_directory+'\'+ls_item_no+'.jpg' , streamMode!, write!, lockwrite!)
			FileWriteEX(li_filenum, item_pic , ll_length )			
			fileclose( li_filenum )
		end if	
		
f_msg_mdi_help('Ending Set Picture ...')






end subroutine

on w_product_run_card.create
int iCurrent
call super::create
this.sle_run_no=create sle_run_no
this.uo_run_date=create uo_run_date
this.sle_lot_no=create sle_lot_no
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.cb_2=create cb_2
this.ddlb_model_name=create ddlb_model_name
this.ddlb_line_code=create ddlb_line_code
this.cb_inventory=create cb_inventory
this.cb_4=create cb_4
this.em_carrier_size=create em_carrier_size
this.st_line_code=create st_line_code
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.st_5=create st_5
this.st_6=create st_6
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.st_7=create st_7
this.sle_run_no_cond=create sle_run_no_cond
this.ddlb_product_run_type=create ddlb_product_run_type
this.st_21=create st_21
this.ddlb_lot_divide=create ddlb_lot_divide
this.st_11=create st_11
this.cb_1=create cb_1
this.cb_3=create cb_3
this.rb_bartend=create rb_bartend
this.rb_machine=create rb_machine
this.rb_default_label=create rb_default_label
this.rb_no_label=create rb_no_label
this.cbx_create_pid=create cbx_create_pid
this.st_8=create st_8
this.ddlb_customer_code=create ddlb_customer_code
this.cbx_1=create cbx_1
this.cbx_bom_checck=create cbx_bom_checck
this.rb_isssue_plan=create rb_isssue_plan
this.cb_6=create cb_6
this.cbx_force_delete=create cbx_force_delete
this.em_start_serial=create em_start_serial
this.st_9=create st_9
this.ddlb_model_class=create ddlb_model_class
this.st_10=create st_10
this.st_12=create st_12
this.sle_pcb_week=create sle_pcb_week
this.cb_7=create cb_7
this.cbx_wsio_auto_retrieve=create cbx_wsio_auto_retrieve
this.gb_2=create gb_2
this.gb_4=create gb_4
this.gb_1=create gb_1
this.gb_5=create gb_5
this.gb_6=create gb_6
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_run_no
this.Control[iCurrent+2]=this.uo_run_date
this.Control[iCurrent+3]=this.sle_lot_no
this.Control[iCurrent+4]=this.uo_dateset
this.Control[iCurrent+5]=this.uo_dateend
this.Control[iCurrent+6]=this.cb_2
this.Control[iCurrent+7]=this.ddlb_model_name
this.Control[iCurrent+8]=this.ddlb_line_code
this.Control[iCurrent+9]=this.cb_inventory
this.Control[iCurrent+10]=this.cb_4
this.Control[iCurrent+11]=this.em_carrier_size
this.Control[iCurrent+12]=this.st_line_code
this.Control[iCurrent+13]=this.st_1
this.Control[iCurrent+14]=this.st_2
this.Control[iCurrent+15]=this.st_3
this.Control[iCurrent+16]=this.st_4
this.Control[iCurrent+17]=this.st_5
this.Control[iCurrent+18]=this.st_6
this.Control[iCurrent+19]=this.rb_1
this.Control[iCurrent+20]=this.rb_2
this.Control[iCurrent+21]=this.rb_3
this.Control[iCurrent+22]=this.st_7
this.Control[iCurrent+23]=this.sle_run_no_cond
this.Control[iCurrent+24]=this.ddlb_product_run_type
this.Control[iCurrent+25]=this.st_21
this.Control[iCurrent+26]=this.ddlb_lot_divide
this.Control[iCurrent+27]=this.st_11
this.Control[iCurrent+28]=this.cb_1
this.Control[iCurrent+29]=this.cb_3
this.Control[iCurrent+30]=this.rb_bartend
this.Control[iCurrent+31]=this.rb_machine
this.Control[iCurrent+32]=this.rb_default_label
this.Control[iCurrent+33]=this.rb_no_label
this.Control[iCurrent+34]=this.cbx_create_pid
this.Control[iCurrent+35]=this.st_8
this.Control[iCurrent+36]=this.ddlb_customer_code
this.Control[iCurrent+37]=this.cbx_1
this.Control[iCurrent+38]=this.cbx_bom_checck
this.Control[iCurrent+39]=this.rb_isssue_plan
this.Control[iCurrent+40]=this.cb_6
this.Control[iCurrent+41]=this.cbx_force_delete
this.Control[iCurrent+42]=this.em_start_serial
this.Control[iCurrent+43]=this.st_9
this.Control[iCurrent+44]=this.ddlb_model_class
this.Control[iCurrent+45]=this.st_10
this.Control[iCurrent+46]=this.st_12
this.Control[iCurrent+47]=this.sle_pcb_week
this.Control[iCurrent+48]=this.cb_7
this.Control[iCurrent+49]=this.cbx_wsio_auto_retrieve
this.Control[iCurrent+50]=this.gb_2
this.Control[iCurrent+51]=this.gb_4
this.Control[iCurrent+52]=this.gb_1
this.Control[iCurrent+53]=this.gb_5
this.Control[iCurrent+54]=this.gb_6
end on

on w_product_run_card.destroy
call super::destroy
destroy(this.sle_run_no)
destroy(this.uo_run_date)
destroy(this.sle_lot_no)
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.cb_2)
destroy(this.ddlb_model_name)
destroy(this.ddlb_line_code)
destroy(this.cb_inventory)
destroy(this.cb_4)
destroy(this.em_carrier_size)
destroy(this.st_line_code)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.st_6)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.st_7)
destroy(this.sle_run_no_cond)
destroy(this.ddlb_product_run_type)
destroy(this.st_21)
destroy(this.ddlb_lot_divide)
destroy(this.st_11)
destroy(this.cb_1)
destroy(this.cb_3)
destroy(this.rb_bartend)
destroy(this.rb_machine)
destroy(this.rb_default_label)
destroy(this.rb_no_label)
destroy(this.cbx_create_pid)
destroy(this.st_8)
destroy(this.ddlb_customer_code)
destroy(this.cbx_1)
destroy(this.cbx_bom_checck)
destroy(this.rb_isssue_plan)
destroy(this.cb_6)
destroy(this.cbx_force_delete)
destroy(this.em_start_serial)
destroy(this.st_9)
destroy(this.ddlb_model_class)
destroy(this.st_10)
destroy(this.st_12)
destroy(this.sle_pcb_week)
destroy(this.cb_7)
destroy(this.cbx_wsio_auto_retrieve)
destroy(this.gb_2)
destroy(this.gb_4)
destroy(this.gb_1)
destroy(this.gb_5)
destroy(this.gb_6)
end on

event activate;call super::activate;/***************************************
* Window Default Property 
****************************************/
Gst_set.window_id            = this.classname() 
Gst_set.author                  = "JiSheng"
Gst_set.creation_date      = '20051101'
Gst_set.last_modify_date = '20051101'
Gst_set.Report_window    = True  // Report Window  True / Flase

/*****************************************
* Data Window Property
******************************************/
Ivs_resize_type                      = 'MASTER_DETAIL_1L2R'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default

/****************************************
* Menu Property 
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

event ue_data_control;call super::ue_data_control;Long ROW , lvl_lot_qty , LVI_PID_MAPPING
STRING  lvs_lot_no , lvs_run_no
INT lvi_count
CHOOSE CASE Gvs_Ue_DATA_control
		
	CASE 'RETRIEVE'

			DW_1.RESET( )
			DW_1.RETRIEVE( ddlb_model_name.getcode()+'%' , sle_run_no_cond.text+'%' , sle_lot_no.text+'%' , uo_dateset.text() , uo_dateend.text() , '%' ,  ddlb_customer_code.getcode( )+'%' ,   gvi_organization_id )
						
	CASE	'DELETE'
		
			if DW_1.AcceptText() = -1 then
				return
			end if
			
			
//			if dw_1.object.run_status[dw_1.getrow()] > '3' then 
//				f_msgbox(161)
//				return 
//			end if
			
			lvs_lot_no  = dw_1.object.lot_no[dw_1.getrow()]
			lvs_run_no = dw_1.object.run_no[dw_1.getrow()]
			lvl_lot_qty  = dw_1.object.lot_size[dw_1.getrow()]
			
			//=======================================
			//   CHECK PID MAPPIN 
			//=======================================
			  SELECT COUNT(*) INTO :LVI_PID_MAPPING
			   FROM IP_PRODUCT_2D_BARCODE 
			  WHERE RUN_NO = :lvs_run_no
			      AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
					
				if f_sql_check() < 0 then 
					return 
				end if 				 
			   
			IF 	LVI_PID_MAPPING > 0 and cbx_force_delete.checked = false THEN 
			     F_MSG( "PID $$HEX25$$00ac200074c7f8bb2000e4b951d518b4b4c5200088c7b5c2c8b2e4b22000adc01cc8200060d518c22000c6c5b5c2c8b2e4b2$$ENDHEX$$" , "P")
				RETURN 
			END IF 
			
			//=======================================
			MSG = F_MSGBOX(1003)  //$$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?

			IF MSG = 1 THEN
				
				Gvl_row_deleted = DW_1.GetRow()			
				DW_1.DELETEROW(Gvl_row_deleted)		
				DW_1.SetFocus()
				ROW = DW_1.GetRow()
				DW_1.ScrollToRow(row)
				DW_1.SetColumn(1)
				DW_2.RESET()
				
				
				//=========================================
				// LOT NO= MFS
				//=========================================
//				
//				//$$HEX39$$ddc0b0c0c4ac8dd6d0c5200044c5c1c920006fb8b8d220006cad31c174c7200018b4b4c5200088c7c0c920004ac540c7200018c2c9b774c7200088c794b2c0c92000b4cc6cd020005cd5e4b22000$$ENDHEX$$
//				select count(*) into :lvi_count 
//				  from ip_assembly_master_plan
//				 where mfs = :lvs_lot_no // $$HEX17$$d0c61cc870c888bc38d65cb82000a8b044c5200088c794b2c0c92000b4cc6cd02000$$ENDHEX$$
//				    and organization_id = :gvi_organization_id ;	
//					 
//			     if f_sql_check() < 0 then 
//					return 
//				end if 		
//				
//				//$$HEX12$$44c5c1c92000a8b044c5200088c7e4b274ba200009002000$$ENDHEX$$
//				if 	 lvi_count > 0 then 
//					 
//						// $$HEX26$$3cba00c82000f0b7200088bc38d65cb8200084bd60d518b4b4c5200088c794b22000c4ac8dd62000adc01cc8200058d5e0ac2000$$ENDHEX$$
//						delete from ip_assembly_master_plan   
//						 where mfs  = :lvs_run_no //$$HEX8$$e0c2dcad2000f0b7200088bc38d62000$$ENDHEX$$
//							  and organization_id = :gvi_organization_id ;		
//							  
//						  if f_sql_check() < 0 then 
//							return 
//						 end if 									  
//							  
//						//$$HEX22$$d0c6c4ac8dd6d0c5e4b200ac2000adc01cc81cb4200018c2c9b72000ccb97cd02000f5bc6cad5cd5e4b22000$$ENDHEX$$
//						 update ip_assembly_master_plan set order_qty = order_qty + :lvl_lot_qty
//								where mfs  = :lvs_lot_no //$$HEX9$$d0c698b720001cc870c8200088bc38d62000$$ENDHEX$$
//							  and organization_id = :gvi_organization_id ;		   
//							  
//						  if f_sql_check() < 0 then 
//							return 
//						end if 			
//				    //$$HEX42$$04c880bd200084bd60d518b4b4c51cc1200094c7c9b774c72000c6c594b22000c1c069d6200074c774ba200074d5f9b220006fb8b8d258c720001cc870c8200088bc38d6ccb92000c0bcbdac20005cd5e4b22000$$ENDHEX$$
//					else
					//$$HEX22$$d0c6c4ac8dd6d0c5e4b200ac2000adc01cc81cb4200018c2c9b72000ccb97cd02000f5bc6cad5cd5e4b22000$$ENDHEX$$
//						 update ip_assembly_master_plan set plan_status = 'W' , mfs = :lvs_lot_no
//								where mfs  = :lvs_run_no //$$HEX17$$f0b788bc38d65cb820003ecc44c51cc12000c1c0dcd02000c0bcbdac5cd5e4b22000$$ENDHEX$$
//							  and organization_id = :gvi_organization_id ;		   
//							  
//						  if f_sql_check() < 0 then 
//							return 
//						end if 				
						
						update IP_PRODUCT_SMD_PLAN set plan_status = 'W' ,  mfs = '*'
					   	where mfs  = :lvs_run_no //$$HEX17$$f0b788bc38d65cb820003ecc44c51cc12000c1c0dcd02000c0bcbdac5cd5e4b22000$$ENDHEX$$
						    and organization_id = :gvi_organization_id ;		   
							  
						  if f_sql_check() < 0 then 
							return 
						end if 														
						
//					end if
				//======================================
				//
				//======================================
				 IF DW_1.UPDATE() < 0 or DW_2.UPDATE() < 0 THEN 
					 ROLLBACK;
				ELSE
					 COMMIT;
					 F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
				END IF
			END IF
			//$$HEX12$$15ac1cc82000adc01cc8200035c658c1200074d51cc82000$$ENDHEX$$
			cbx_force_delete.checked = false 
			
	CASE 'UPDATE'

	         IF DW_1.UPDATE() < 0 or DW_2.UPDATE() < 0 THEN 
			  	 ROLLBACK;
			ELSE
				 COMMIT;
				 F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
			END IF

	CASE ELSE
END CHOOSE
end event

type dw_5 from w_main_root`dw_5 within w_product_run_card
integer y = 676
integer width = 3671
integer height = 1504
boolean titlebar = true
string title = "Issue Plan List"
string dataobject = "d_ip_product_run_issue_plan_summary"
end type

type dw_4 from w_main_root`dw_4 within w_product_run_card
integer y = 676
integer width = 3671
integer height = 1504
boolean titlebar = true
string title = "Barcode"
string dataobject = "d_pcb_label_qr_with_item_code_report"
end type

event dw_4::updatestart;//OVER
end event

event dw_4::retrieverow;//OVER
end event

event dw_4::retrieveend;//OVER
end event

event dw_4::rowfocuschanged;//OVER
end event

event dw_4::retrievestart;//over 
end event

event dw_4::uo_mousemove;//over
end event

event dw_4::itemchanged;//over
end event

type dw_3 from w_main_root`dw_3 within w_product_run_card
integer y = 676
integer width = 3671
integer height = 1504
boolean titlebar = true
string dataobject = "d_plan_pcm_run_card_rpt"
boolean controlmenu = true
boolean minbox = true
end type

type dw_2 from w_main_root`dw_2 within w_product_run_card
integer x = 3671
integer y = 680
integer width = 1111
integer height = 1504
boolean titlebar = true
string title = "Work Stage IO List"
string dataobject = "d_pln_product_run_card_io_4_run_lst"
boolean controlmenu = true
boolean minbox = true
end type

type dw_1 from w_main_root`dw_1 within w_product_run_card
integer y = 676
integer width = 3671
integer height = 1504
boolean titlebar = true
string title = "Run Card List"
string dataobject = "d_ip_product_run_card_lst"
boolean controlmenu = true
boolean minbox = true
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 

if cbx_wsio_auto_retrieve.checked = true then 
	dw_2.reset()
	sle_run_no.text =  this.object.run_no[currentrow]
	dw_2.retrieve(sle_run_no.text, gvi_organization_id )
end if 
dw_3.retrieve(sle_run_no.text, gvi_organization_id )
f_set_column_dddw( dw_3) 
f_dual_lang_change_dwtext(dw_3)

end event

type uo_tabpages from w_main_root`uo_tabpages within w_product_run_card
end type

type sle_run_no from so_singlelineedit within w_product_run_card
integer x = 1079
integer y = 384
integer width = 571
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
boolean displayonly = true
end type

type uo_run_date from uo_ymd_calendar within w_product_run_card
event destroy ( )
integer x = 1079
integer y = 192
integer taborder = 50
boolean bringtotop = true
long backcolor = 12632256
end type

on uo_run_date.destroy
call uo_ymd_calendar::destroy
end on

type sle_lot_no from so_singlelineedit within w_product_run_card
integer x = 3296
integer y = 276
integer width = 718
integer height = 92
integer taborder = 60
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
end type

type uo_dateset from uo_ymd_calendar within w_product_run_card
event destroy ( )
integer x = 3301
integer y = 72
integer taborder = 70
boolean bringtotop = true
long backcolor = 12632256
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_product_run_card
event destroy ( )
integer x = 3721
integer y = 72
integer taborder = 80
boolean bringtotop = true
long backcolor = 12632256
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type cb_2 from so_commandbutton within w_product_run_card
integer x = 14
integer y = 520
integer width = 411
integer height = 148
integer taborder = 70
boolean bringtotop = true
integer weight = 400
string text = "New Preject"
end type

event clicked;INT I , LVI_COUNT  
STRING LVS_MODEL_NAME , LVS_LOT_NO , LVS_RUN_NO , LVS_LINE_CODE  , LVS_USE_CALENDAR , LVS_CUSTOER_ORDER_NO , LVS_PCB_ITEM , LVS_MODEL_CLASS
STRING LVS_MFS , LVS_ASEMBLY_ITEM_CODE , LVS_PARENT_ITEM_CODE
STRING LVS_PRODUCT_RUN_TYPE , LVS_MARKING_NO , LVS_PCB_ARRAY_TYPE , LVS_MASTER_MODEL_NAME , LVS_MFS_GROUP_NO , LVS_SHIFT_CODE , LVS_PCB_WEEK
DATETIME LVDT_RUN_DATE , LVDT_PLAN_DATE
LONG LVL_ROW , LVL_PCB_SUM_QTY , LVL_CARRIER_SIZE , LVL_LOT_SIZE  , LVL_PLAN_SEQUENCE

//=========================================================
//
//=========================================================
LVDT_RUN_DATE   = UO_RUN_DATE.TEXT()
//LVS_LINE_CODE      = DDLB_LINE_CODE.GETCODE()
//LVS_MODEL_NAME = DDLB_MODEL_NAME.GETCODE()


LVS_PRODUCT_RUN_TYPE = DDLB_PRODUCT_RUN_TYPE.GETCODE()
//LVI_LOT_DIVIDE_QTY = INTEGER(ddlb_lot_divide.TEXT) // $$HEX7$$84bd60d560d5200018c2c9b72000$$ENDHEX$$
//LVS_PARENT_ITEM_CODE   = ddlb_model_name.getitem( ) //$$HEX11$$5ccdc1c004c7200088d4a9ba54cfdcb4200009000900$$ENDHEX$$
LVS_MODEL_CLASS = ddlb_model_class.getcode() 
LVS_PCB_WEEK       = SLE_PCB_WEEK.TEXT

////==========================================================
////
////==========================================================
////DW_1.RESET()
//
//if lvl_carrier_size < 0 then 
//    F_MSG("$$HEX12$$a8ba78b3c8b9a4c230d12000f0c530bcf4c5200024c658b9$$ENDHEX$$" , "P") 
//    RETURN	
//end if 
//
//if LVS_MODEL_CLASS = '' or isnull(LVS_MODEL_CLASS) or LVS_MODEL_CLASS = '%' then 
//    F_MSG("$$HEX13$$a8ba78b374d098b7a4c27cb9200020c1ddd0200058d538c194c6$$ENDHEX$$" , "P") 
//    RETURN	
//	
//end if 



IF LVS_PRODUCT_RUN_TYPE = '' OR LVS_PRODUCT_RUN_TYPE = '%' OR ISNULL(LVS_PRODUCT_RUN_TYPE) THEN 
    F_MSGBOX1(102 , F_GET_DUAL_LANG_TEXT( GVS_LANGUAGE , "PRODUCT RUN TYPE" )) 
    RETURN
END IF 


////=======================================
//// $$HEX13$$a8ba78b35cb8200088d4a9ba200054cfdcb4200070c88cd62000$$ENDHEX$$
////=======================================
// SELECT ITEM_CODE 
//    INTO :LVS_ITEM_CODE
//   FROM ID_ITEM 
// WHERE MODEL_NAME = :LVS_MODEL_NAME 
//      AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID;
//     
// IF LVS_ITEM_CODE = '' OR ISNULL(LVS_ITEM_CODE)  THEN 
//    F_MSGBOX1(815 , LVS_MODEL_NAME+" ITEM MASTER" )
//    RETURN
//END IF  
//=======================================
// BOM $$HEX9$$74c8acc72000ecc580bd2000b4cc6cd02000$$ENDHEX$$
//=======================================

//if cbx_BOM_CHECCK.checked = true then 
//        SELECT COUNT (*) 
//		  INTO :LVI_COUNT
//          FROM ID_ENG_BOM
//        WHERE CHILD_ITEM_CODE   = :LVS_PARENT_ITEM_CODE
//             AND ORGANIZATION_ID   =  :GVI_ORGANIZATION_ID;
//        
//         IF LVI_COUNT <= 0 THEN 
//            F_MSGBOX1(815 , "BOM" )
//            RETURN
//        END IF
//end if 
//    //==============================
//    // $$HEX11$$d4c625b874c8acc72000ecc580bd2000b4cc6cd02000$$ENDHEX$$
//    //==============================          
//	 
//	SELECT USE_CALENDAR	  
//	INTO :LVS_USE_CALENDAR
//	FROM IP_PRODUCT_MODEL_MASTER
//	WHERE MODEL_NAME = :LVS_MODEL_NAME 
//	AND ORGANIZATION_ID   =  :GVI_ORGANIZATION_ID;
//		
//	IF F_SQL_CHECK() < 0 THEN
//		RETURN 
//	END IF 		  
//	
//	IF LVS_USE_CALENDAR = 'Y' THEN	
//		  LVI_COUNT = 0
//		SELECT COUNT(*) INTO :LVI_COUNT 
//			 FROM ip_product_year_base
//		  WHERE MODEL_NAME = :LVS_MODEL_NAME 
//			  AND ORGANIZATION_ID   =  :GVI_ORGANIZATION_ID;
//			  
//				IF LVI_COUNT <= 0 THEN 
//					F_MSGBOX1(815 , "CALENDAR" )
//					RETURN
//			  END IF
//	END IF 		

    //==============================
    // $$HEX11$$c4ac8dd6200020c1ddd020003dcc20001dd3c5c52000$$ENDHEX$$
    //==============================                
    CB_INVENTORY.TRIGGEREVENT(CLICKED!)
    
    IF GST_RETURN.GVB_RETURN = TRUE THEN 
		       
							LVS_MFS = MESSAGE.STRINGPARM                                     // $$HEX19$$ddc0b0c0c4ac8dd658c720001cc870c8200088bc38d67cb9200000ac38c8200028c6e4b22000$$ENDHEX$$
							LVL_LOT_SIZE = GST_RETURN.GVL_RETURN[1]                    //$$HEX12$$6fb8b8d2200018c2c9b744c7200000ac38c828c6e4b22000$$ENDHEX$$
							LVS_ASEMBLY_ITEM_CODE = GST_RETURN.GVS_RETURN[1] //$$HEX5$$88d4a9ba54cfdcb42000$$ENDHEX$$
							LVS_CUSTOER_ORDER_NO  = GST_RETURN.GVS_RETURN[4] //$$HEX12$$e0ac1dacfcc838bb88bc38d62000ccc66cd024c654b32000$$ENDHEX$$
							LVDT_PLAN_DATE = GST_RETURN.GVDT_RETURN[1] 
							LVL_PLAN_SEQUENCE = GST_RETURN.GVL_RETURN[2]
							LVS_PCB_ITEM =  GST_RETURN.GVS_RETURN[5]                 //PCB ITEM
							
							LVS_MASTER_MODEL_NAME =  GST_RETURN.GVS_RETURN[6]  
							LVS_MFS_GROUP_NO =  GST_RETURN.GVS_RETURN[7]  
							LVS_SHIFT_CODE =  GST_RETURN.GVS_RETURN[8]  
							LVS_LINE_CODE = Gst_return.Gvs_return[9]
							
							LVS_MODEL_NAME = Gst_return.Gvs_return[3]
							LVDT_RUN_DATE = Gst_return.Gvdt_return[1]
							
							LVS_PARENT_ITEM_CODE = Gst_return.Gvs_return[2]
							
							
							lvl_carrier_size       = f_get_carrier_size(LVS_MODEL_NAME) //LVL_CARRIER_SIZE =  INTEGER(EM_CARRIER_SIZE.TEXT)

							if lvl_carrier_size < 0 then 
								f_msg("$$HEX15$$f0c530bcf4c5200018c2c9b744c720004cc518c22000c6c5b5c2c8b2e4b2$$ENDHEX$$" , "P" )
								RETURN 
							end if 

							
							IF LVS_LINE_CODE = '' OR LVS_LINE_CODE = '%' OR ISNULL(LVS_LINE_CODE) THEN 
								 F_MSGBOX1(102 , F_GET_DUAL_LANG_TEXT( GVS_LANGUAGE , "LINE CODE" )) 
								 RETURN
							END IF 
							
							IF LVS_MODEL_NAME = '' OR LVS_MODEL_NAME = '%' OR ISNULL(LVS_MODEL_NAME) THEN 
								 F_MSGBOX1(102 , F_GET_DUAL_LANG_TEXT( GVS_LANGUAGE , "MODEL NAME" )) 
								 RETURN
							END IF 
							
							IF LVS_SHIFT_CODE = '' OR LVS_SHIFT_CODE = '%' OR ISNULL(LVS_SHIFT_CODE) THEN 
								 F_MSGBOX1(102 , F_GET_DUAL_LANG_TEXT( GVS_LANGUAGE , "SHIFT CODE" )) 
								 RETURN
							END IF 			
							
							IF LVS_MFS_GROUP_NO = '' OR LVS_MFS_GROUP_NO = '%' OR ISNULL(LVS_MFS_GROUP_NO) THEN 
								 F_MSGBOX1(102 , F_GET_DUAL_LANG_TEXT( GVS_LANGUAGE , "MFS GROUP NO" )) 
								 RETURN
							END IF 								
								 
								 IF LVL_LOT_SIZE = 0 THEN
									  ROLLBACK;
									  MESSAGEBOX("ERROR" , LVS_RUN_NO+"  "+LVS_MODEL_NAME+" LOT SIZE = " +STRING(LVL_LOT_SIZE) )
									  RETURN
								 END IF 
				


								//===============================================
								//$$HEX20$$f0b788bc38d640c62000b4c508b874c72000c0d085c7200044c7200070c88cd620005cd5e4b22000$$ENDHEX$$
								//===============================================
								SELECT  F_GET_NEW_RUN_NO(:LVDT_RUN_DATE , :LVS_MODEL_NAME , :LVS_LINE_CODE ,  :LVS_SHIFT_CODE , :GVI_ORGANIZATION_ID ) ,
											F_GET_PCB_ARRAY_TYPE( :LVS_MODEL_NAME ,:GVI_ORGANIZATION_ID)                // $$HEX12$$a8ba78b32000c8b9a4c230d1d0c52000f1b45db81cb42000$$ENDHEX$$PCB $$HEX6$$70c869d5200020c715d62000$$ENDHEX$$,L1,L2,R1,R2
								INTO :LVS_RUN_NO , 
									   :LVS_PCB_ARRAY_TYPE
								FROM DUAL ;
								
								IF F_SQL_CHECK() < 0 THEN
									RETURN 
								END IF 

								SLE_RUN_NO.TEXT = LVS_RUN_NO
//============================================================
//
//============================================================
							INSERT INTO "IP_PRODUCT_RUN_CARD_DETAIL"  
												  ( "RUN_NO",   
													 "MATERIAL_MFS",   
													 "GROUP_ID",   
													 "ORGANIZATION_ID",   
													 "ENTER_DATE",   
													 "ENTER_BY",   
													 "LAST_MODIFY_DATE",   
													 "LAST_MODIFY_BY",   
													 "LOT_SIZE",   
													 "BIN_CODE",   
													 "ITEM_CODE",   
													 "ITEM_PACKING_QTY",   
													 "BARCODE" ,
													 LOCATION_QTY ,
													 ITEM_UNIT_QTY,
													 PARENT_ITEM_CODE)  
								         SELECT   :LVS_RUN_NO,
													 '*' ,   
													 :LVS_CUSTOER_ORDER_NO,   
													 A.ORGANIZATION_ID,   
									  			     SYSDATE , //"ENTER_DATE",   
													 :GVS_USER_ID , //"ENTER_BY",   
													 SYSDATE , //"LAST_MODIFY_DATE",   
													 :GVS_USER_ID , //"LAST_MODIFY_BY",   
													 MAX(:LVL_LOT_SIZE) , //"LOT_SIZE",   
													 NULL , //"BIN_CODE",   
													 A.CHILD_ITEM_CODE , //"ITEM_CODE",   
													 MAX(B.ISSUE_PACKING_QTY) , //"ITEM_PACKING_QTY",   
													 NULL , //"BARCODE" 
													 F_GET_LOCATION_QTY(:LVS_ASEMBLY_ITEM_CODE , A.CHILD_ITEM_CODE , :LVS_LINE_CODE , A.ORGANIZATION_ID ), // SMT BOM PARENT ITEM IS SET ITEM 
													 MAX(A.ITEM_UNIT_QTY),
													 :LVS_PARENT_ITEM_CODE
										   FROM ID_ENG_BOM A , ID_ITEM  B
									     WHERE  A.CHILD_ITEM_CODE   = B.ITEM_CODE(+)
											 AND A.ORGANIZATION_ID    = B.ORGANIZATION_ID(+)
											 AND A.PARENT_ITEM_CODE = :LVS_ASEMBLY_ITEM_CODE  //SMT $$HEX26$$94b22000a8ba78b3200030ae00c93cc75cb82000ddc031c1200058d5c0bb5cb82000a8ba78b385ba3cc75cb8200070c88cd62000$$ENDHEX$$
											 AND A.DATESET <= :LVDT_RUN_DATE
											 AND A.DATEEND >= :LVDT_RUN_DATE
											 AND A.ORGANIZATION_ID    = :GVI_ORGANIZATION_ID 
										
										GROUP BY  A.ORGANIZATION_ID, A.CHILD_ITEM_CODE  ;		
	
									IF F_SQL_CHECK() < 0 THEN 
										RETURN
									END IF       
									
								//==========================
								// $$HEX9$$c8b9b9d0200054cfdcb4200070c88cd62000$$ENDHEX$$
								//==========================

//								if cbx_marking_yn.checked = true then 
//									
//										select f_get_marking_barcode(:lvs_run_no ,:lvdt_run_date ,:lvs_model_name, :gvi_organization_id ) 
//											into :lvs_marking_no
//										  from dual ;
//										
//											if f_sql_check() < 0 then 
//												return
//											end if 
//									 //===========================
//									 // $$HEX20$$24c658b900ac2000ecd368d5200018b4b4c5200088c794b2c0c92000b4cc6cd020005cd5e4b22000$$ENDHEX$$
//									 //===========================
//										 if  pos(lvs_marking_no , '*' , 1 ) > 0 then 
//											rollback;
//											dw_1.deleterow(lvl_row)
//											Messagebox("Error" , "Marking No={ "+lvs_marking_no+" }  Marking Code Invalid. Check MRM Condition Table..." )
//											return 
//										end if 
//	
//								//===============================
//								// $$HEX9$$c8b9b9d044c7200048c560d5bdacb0c62000$$ENDHEX$$
//								//===============================
//								else
									lvs_marking_no  = '*'
//								end if 									

							//=======================================
							// $$HEX6$$e0c2dcad2000ddc031c12000$$ENDHEX$$
							//=======================================
							F_SET_COLUMN_DDDW(DW_1)
							LVL_ROW = DW_1.INSERTROW(0)
							DW_1.SCROLLTOROW(LVL_ROW)
							F_SET_SECURITY_ROW(DW_1 , LVL_ROW , 'ALL')
							
							DW_1.OBJECT.RUN_DATE[LVL_ROW]       = LVDT_RUN_DATE //  UO_RUN_DATE.TEXT()
							DW_1.OBJECT.ITEM_CODE[LVL_ROW]     = LVS_ASEMBLY_ITEM_CODE
							DW_1.OBJECT.PARENT_ITEM_CODE[LVL_ROW]     = LVS_PARENT_ITEM_CODE
							
							DW_1.OBJECT.MASTER_MODEL_NAME[LVL_ROW]   = LVS_MASTER_MODEL_NAME
							DW_1.OBJECT.MFS_GROUP_NO[LVL_ROW]   = LVS_MFS_GROUP_NO
							DW_1.OBJECT.MODEL_NAME[LVL_ROW]  = LVS_MODEL_NAME
							
							DW_1.OBJECT.LINE_CODE[LVL_ROW]       =  LVS_LINE_CODE      
							DW_1.OBJECT.SHIFT_CODE[LVL_ROW]       =  LVS_SHIFT_CODE    
							DW_1.OBJECT.CARRIER_SIZE[LVL_ROW]  =  LVL_CARRIER_SIZE
							
							DW_1.OBJECT.PCB_SUPPLIER_CODE[LVL_ROW]     =''      
							DW_1.OBJECT.PRODUCT_RUN_TYPE[LVL_ROW] = LVS_PRODUCT_RUN_TYPE
							
							DW_1.OBJECT.CHARGER[LVL_ROW] = GVS_USER_ID      
							DW_1.OBJECT.RUN_STATUS[LVL_ROW] = '1' // 1=CREATE , 2 = MATERIAL ISSUE,3 = KITTING,4 =SMT SCAN,5 = QC ,6 = BOX LABEL , 7 = RECEIPT , 8 = SHIPPING 							

							DW_1.OBJECT.RUN_NO[LVL_ROW]             = LVS_RUN_NO
							DW_1.OBJECT.LOT_NO[LVL_ROW]             = LVS_MFS //  $$HEX9$$ddc0b0c0c4ac8dd620001cc870c888bc38d6$$ENDHEX$$
							DW_1.OBJECT.ARRAY_TYPE[LVL_ROW]      = LVS_PCB_ARRAY_TYPE
							DW_1.OBJECT.LOT_SIZE[LVL_ROW]           = LVL_LOT_SIZE //$$HEX14$$ddc0b0c0c4ac8dd63cc75cb8200080bd30d1200000ac38c834c62000$$ENDHEX$$
							DW_1.OBJECT.MARKING_NO[LVL_ROW]      =LVS_MARKING_NO
							DW_1.OBJECT.PCB_ITEM[LVL_ROW]           =LVS_PCB_ITEM
							DW_1.OBJECT.REVISION[LVL_ROW]           = '0' // $$HEX6$$18c2d9b3c0bcbdac20002000$$ENDHEX$$
							DW_1.OBJECT.MODEL_CLASS[LVL_ROW]    = LVS_MODEL_CLASS
							
							DW_1.OBJECT.PCB_WEEK[LVL_ROW]    = LVS_PCB_WEEK
							IF DW_1.UPDATE() < 0 THEN 
							  DW_1.DELETEROW(LVL_ROW)
							  ROLLBACK;
							  RETURN
							ELSE
	
								  //================================
								  // $$HEX25$$18bc1cc888d42000c4ac8dd6d0c520006fb8b8d22000ddc031c1200018b4c8c54cc720000cd598b7f8ad200024c115c82000$$ENDHEX$$
								  //================================
	
									IF F_SET_SMD_PLAN_LOT_DIVIDE(  LVDT_PLAN_DATE , LVL_PLAN_SEQUENCE ,  LVS_RUN_NO  )  < 0 THEN 
										DW_1.DELETEROW(LVL_ROW)
										ROLLBACK; 
										RETURN
									END IF

       					         END IF 
								
				    COMMIT;
//==================================================
//
//==================================================
    ELSE 
          ROLLBACK;
    END IF 
end event

type ddlb_model_name from uo_set_model_name_ddlb within w_product_run_card
integer x = 1079
integer y = 284
integer width = 1175
integer height = 1900
integer taborder = 50
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
boolean autohscroll = true
end type

event selectionchanged;call super::selectionchanged;int lvl_carrier_size
sle_run_no.text = ''


//IF  string(f_get_marking_yn(this.getcode())) = 'Y' THEN 
//	cbx_marking_yn.checked = TRUE
//else
//	cbx_marking_yn.checked = FALSE
//end if 
//====================================================
//
//====================================================

//lvl_carrier_size = f_get_carrier_size(this.getitem())
lvl_carrier_size = f_get_carrier_size( DDLB_MODEL_NAME.GETCODE())
  
if lvl_carrier_size < 0 then 

	if f_msgbox1(1151 , 'MODEL') = 1 then 
		Opensheet( w_pln_product_model_master  , w_main_frame , Gvi_opensheet_position , Layered!)	
	else
		this.text = ''
		return 
	end if 
	
else
	em_carrier_size.TEXT = string(lvl_carrier_size)
end if 


end event

type ddlb_line_code from uo_line_code within w_product_run_card
integer x = 1079
integer y = 104
integer width = 544
integer taborder = 60
boolean bringtotop = true
long backcolor = 16777215
end type

type cb_inventory from so_commandbutton within w_product_run_card
integer x = 864
integer y = 520
integer width = 466
integer height = 148
integer taborder = 80
boolean bringtotop = true
integer weight = 400
string text = "Show Plan"
end type

event clicked;openwithparm(w_pln_smd_plan_popup , ddlb_model_name.getcode() )

end event

type cb_4 from so_commandbutton within w_product_run_card
integer x = 425
integer y = 520
integer width = 439
integer height = 148
integer taborder = 70
boolean bringtotop = true
integer weight = 400
string text = "Run Card Print"
end type

event clicked;if dw_3.Describe("DataWindow.Print.Preview") = '!' or dw_3.Describe("DataWindow.Print.Preview") = '?' then
else
	 dw_3.Modify("DataWindow.Print.Preview=yes")
	 dw_3.Modify("DataWindow.Print.Preview.Rulers=yes")
end if	

if dw_3.rowcount( ) > 0 then 
	dw_3.print( TRUE)
end if 

//openwithparm(w_zetprint , dw_3 )
end event

type em_carrier_size from so_editmask within w_product_run_card
integer x = 2071
integer y = 104
integer width = 187
integer taborder = 60
boolean bringtotop = true
boolean enabled = false
string text = "0"
string mask = "##0"
end type

type st_line_code from so_statictext within w_product_run_card
integer x = 736
integer y = 104
integer width = 325
boolean bringtotop = true
long textcolor = 16711680
string text = "Line Code"
alignment alignment = right!
end type

type st_1 from so_statictext within w_product_run_card
integer x = 736
integer y = 200
integer width = 325
boolean bringtotop = true
long textcolor = 16711680
string text = "Run Date"
alignment alignment = right!
end type

type st_2 from so_statictext within w_product_run_card
integer x = 736
integer y = 292
integer width = 325
boolean bringtotop = true
long textcolor = 16711680
string text = "Model Name"
alignment alignment = right!
end type

type st_3 from so_statictext within w_product_run_card
integer x = 1696
integer y = 116
integer width = 325
integer height = 60
boolean bringtotop = true
string text = "Carrier Size"
alignment alignment = right!
end type

type st_4 from so_statictext within w_product_run_card
integer x = 2853
integer y = 88
integer width = 398
integer height = 64
boolean bringtotop = true
string text = "Date"
alignment alignment = right!
end type

type st_5 from so_statictext within w_product_run_card
integer x = 2853
integer y = 292
integer width = 398
integer height = 72
boolean bringtotop = true
string text = "Lot No"
alignment alignment = right!
end type

type st_6 from so_statictext within w_product_run_card
integer x = 736
integer y = 400
integer width = 325
integer height = 64
boolean bringtotop = true
string text = "Run No"
alignment alignment = right!
end type

type rb_1 from so_radiobutton within w_product_run_card
integer x = 101
integer y = 104
boolean bringtotop = true
string text = "Run Card"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true
dw_2.bringtotop = true
dw_4.bringtotop = false
selected_data_window = dw_1
end event

type rb_2 from so_radiobutton within w_product_run_card
integer x = 101
integer y = 276
boolean bringtotop = true
string text = "Barcode"
end type

event clicked;call super::clicked;dw_4.bringtotop = true
selected_data_window = dw_4
dw_4.retrieve(sle_run_no.text, gvi_organization_id )

end event

type rb_3 from so_radiobutton within w_product_run_card
integer x = 101
integer y = 188
boolean bringtotop = true
string text = "Run Card Preview"
end type

event clicked;call super::clicked;dw_3.bringtotop = true
selected_data_window =dw_3


if dw_1.getrow() < 1 then return 
wf_model_part_image()
dw_3.retrieve(dw_1.object.run_no[dw_1.getrow()], gvi_organization_id )
end event

type st_7 from so_statictext within w_product_run_card
integer x = 2853
integer y = 396
integer width = 398
integer height = 72
boolean bringtotop = true
string text = "Run No"
alignment alignment = right!
end type

type sle_run_no_cond from so_singlelineedit within w_product_run_card
integer x = 3296
integer y = 380
integer width = 718
integer height = 92
integer taborder = 70
boolean bringtotop = true
long backcolor = 16777215
textcase textcase = upper!
end type

type ddlb_product_run_type from uo_basecode within w_product_run_card
integer x = 1838
integer y = 200
integer width = 416
integer taborder = 50
boolean bringtotop = true
boolean allowedit = true
end type

event constructor;call super::constructor;this.redraw("PRODUCT RUN TYPE")
this.selectitem('P' )

end event

type st_21 from so_statictext within w_product_run_card
integer x = 1518
integer y = 212
integer width = 306
integer height = 60
boolean bringtotop = true
string text = "Run Type"
alignment alignment = right!
end type

type ddlb_lot_divide from so_dropdownlistbox within w_product_run_card
integer x = 2007
integer y = 392
integer width = 247
integer height = 1524
integer taborder = 50
boolean bringtotop = true
string text = "1"
boolean allowedit = true
boolean autohscroll = true
boolean sorted = false
boolean hscrollbar = true
boolean vscrollbar = true
string item[] = {"0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30"}
end type

type st_11 from so_statictext within w_product_run_card
integer x = 1696
integer y = 400
integer width = 297
integer height = 64
boolean bringtotop = true
string text = "Lot Divide"
alignment alignment = left!
end type

type cb_1 from so_commandbutton within w_product_run_card
integer x = 1330
integer y = 520
integer width = 466
integer height = 148
integer taborder = 90
boolean bringtotop = true
string text = "Gen Detail"
end type

event clicked;call super::clicked;STRING LVS_PARENT_ITEM_CODE , LVS_RUN_NO , LVS_LINE_CODE , LVS_MODEL_NAME , LVS_LOT_NO , LVS_ITEM_CODE
LONG LVL_LOT_SIZE , LVI_COUNT 

//================================================
//
//================================================
if dw_1.getrow( ) < 1 then return 

MSG = F_MSGBOX1( 1161 , THIS.TEXT )
IF MSG = 1 THEN 
ELSE
	RETURN 
END IF 

LVS_PARENT_ITEM_CODE = DW_1.OBject.parent_item_code[dw_1.getrow()]
LVS_RUN_NO = DW_1.OBject.RUN_NO[dw_1.getrow()]
LVL_LOT_SIZE = DW_1.OBject.LOT_SIZE[dw_1.getrow()]
LVS_LINE_CODE = DW_1.OBject.LINE_CODE[dw_1.getrow()]
LVS_MODEL_NAME =  DW_1.OBject.MODEL_NAME[dw_1.getrow()]
LVS_LOT_NO = DW_1.OBject.LOT_NO[dw_1.getrow()]
LVS_ITEM_CODE = DW_1.OBject.ITEM_CODE[dw_1.getrow()]
//=================================================
//
//=================================================


DELETE FROM IP_PRODUCT_RUN_CARD_DETAIL
WHERE  RUN_NO = :LVS_RUN_NO ;

IF F_SQL_CHECK() < 0 THEN 
	RETURN
END IF       

//=================================================
// $$HEX3$$24c1c4ac2000$$ENDHEX$$BOM $$HEX9$$30ae00c920003cc75cb82000ddc031c12000$$ENDHEX$$
//=================================================
IF cbx_bom_checck.checked = true then 

			 	 SELECT COUNT(*) 
					INTO :LVI_COUNT
					FROM ID_ENG_BOM A , ID_ITEM  B
				  WHERE  A.CHILD_ITEM_CODE   = B.ITEM_CODE(+)
					 AND A.ORGANIZATION_ID    = B.ORGANIZATION_ID(+)
					  START WITH a.parent_item_code = :LVS_ITEM_CODE    AND
									  a.dateset <= trunc(sysdate)                     AND
									  NVL(a.dateend,  trunc(sysdate)) >= trunc(sysdate) AND
									  a.organization_id = :gvi_organization_id
						CONNECT BY PRIOR child_item_code = parent_item_code AND
									  a.dateset <=  trunc(sysdate)                     AND
									  NVL(a.dateend,  trunc(sysdate)) >=  trunc(sysdate) AND
									  a.organization_id = :gvi_organization_id ;
									  
					IF F_SQL_CHECK() < 0 THEN 
						RETURN
					END IF       									  
									  
			IF LVI_COUNT = 0 THEN 
				F_MSGBOX1(815 ,LVS_MODEL_NAME )
				RETURN 
			END IF 
			
			INSERT INTO "IP_PRODUCT_RUN_CARD_DETAIL"  
							( "RUN_NO",   
							 "MATERIAL_MFS",   
							 "GROUP_ID",   
							 "ORGANIZATION_ID",   
							 "ENTER_DATE",   
							 "ENTER_BY",   
							 "LAST_MODIFY_DATE",   
							 "LAST_MODIFY_BY",   
							 "LOT_SIZE",   
							 "BIN_CODE",   
							 "ITEM_CODE",   
							 "ITEM_PACKING_QTY",   
							 "BARCODE" ,
							 LOCATION_QTY ,
							 ITEM_UNIT_QTY,
							 PARENT_ITEM_CODE)  
				SELECT   :LVS_RUN_NO,
							 '*' ,   
							 0,   
							 A.ORGANIZATION_ID,   
							  SYSDATE , //"ENTER_DATE",   
							 :GVS_USER_ID , //"ENTER_BY",   
							 SYSDATE , //"LAST_MODIFY_DATE",   
							 :GVS_USER_ID , //"LAST_MODIFY_BY",   
							 MAX(:LVL_LOT_SIZE) , //"LOT_SIZE",   
							 NULL , //"BIN_CODE",   
							 A.CHILD_ITEM_CODE , //"ITEM_CODE",   
							 MAX(B.ISSUE_PACKING_QTY) , //"ITEM_PACKING_QTY",   
							 NULL , //"BARCODE" 
							 0 ,
							 MAX(A.ITEM_UNIT_QTY) ,
							 :LVS_PARENT_ITEM_CODE
					FROM ID_ENG_BOM A , ID_ITEM  B
				  WHERE  A.CHILD_ITEM_CODE   = B.ITEM_CODE(+)
					 AND A.ORGANIZATION_ID    = B.ORGANIZATION_ID(+)
					  START WITH a.parent_item_code = :LVS_ITEM_CODE    AND
									  a.dateset <= trunc(sysdate)                     AND
									  NVL(a.dateend,  trunc(sysdate)) >= trunc(sysdate) AND
									  a.organization_id = :gvi_organization_id
						CONNECT BY PRIOR child_item_code = parent_item_code AND
									  a.dateset <=  trunc(sysdate)                     AND
									  NVL(a.dateend,  trunc(sysdate)) >=  trunc(sysdate) AND
									  a.organization_id = :gvi_organization_id
				
				GROUP BY  A.ORGANIZATION_ID, A.CHILD_ITEM_CODE  ;		
			
			IF F_SQL_CHECK() < 0 THEN 
				RETURN
			END IF       
ELSE
	
	                SELECT COUNT(*) INTO :LVI_COUNT
                      FROM IB_PRODUCT_PLANDATA A 
				  WHERE A.LINE_CODE     = :LVS_LINE_CODE
					  AND A.MODEL_NAME = :LVS_MODEL_NAME	;	
					  
				IF F_SQL_CHECK() < 0 THEN 
					RETURN
				END IF       		
			
			IF LVI_COUNT = 0 THEN 
				F_MSGBOX(117) // NO DATA FOUND 
				RETURN 
			ELSE
				
			//===============================================
			// $$HEX15$$3cd554b3200008b874c744c5c3c6d0c51cc1200000ac38c828c6e4b22000$$ENDHEX$$
			//===============================================
						INSERT INTO "IP_PRODUCT_RUN_CARD_DETAIL"  
										( "RUN_NO",   
										 "MATERIAL_MFS",   
										 "GROUP_ID",   
										 "ORGANIZATION_ID",   
										 "ENTER_DATE",   
										 "ENTER_BY",   
										 "LAST_MODIFY_DATE",   
										 "LAST_MODIFY_BY",   
										 "LOT_SIZE",   
										 "BIN_CODE",   
										 "ITEM_CODE",   
										 "ITEM_PACKING_QTY",   
										 "BARCODE" ,
										 LOCATION_QTY ,
										 ITEM_UNIT_QTY,
										 PARENT_ITEM_CODE,
										 LOCATION_CODE )  
							SELECT   :LVS_RUN_NO,
										 '*' ,   
										 :LVS_LOT_NO  ,
										 A.ORGANIZATION_ID,   
										  SYSDATE , //"ENTER_DATE",   
										 :GVS_USER_ID , //"ENTER_BY",   
										 SYSDATE , //"LAST_MODIFY_DATE",   
										 :GVS_USER_ID , //"LAST_MODIFY_BY",   
										 MAX(:LVL_LOT_SIZE) , //"LOT_SIZE",   
										 NULL , //"BIN_CODE",   
										 A.ITEM_CODE , //"ITEM_CODE",   
										 MAX(B.ISSUE_PACKING_QTY) , //"ITEM_PACKING_QTY",   
										 NULL , //"BARCODE" 
										 0 ,
										 MAX(A.ITEM_UNIT_QTY) ,
										 :LVS_PARENT_ITEM_CODE ,
										 A.LOCATION_CODE
								FROM IB_PRODUCT_PLANDATA A , ID_ITEM  B
							  WHERE A.ITEM_CODE   = B.ITEM_CODE(+)
								  AND A.ORGANIZATION_ID    = B.ORGANIZATION_ID(+)
								  AND A.LINE_CODE     = :LVS_LINE_CODE
								  AND A.MODEL_NAME = :LVS_MODEL_NAME
								 GROUP BY A.ORGANIZATION_ID, A.ITEM_CODE , A.LOCATION_CODE ;	
								 
						IF F_SQL_CHECK() < 0 THEN 
							RETURN
						END IF       					
			END IF 


END IF 
commit ;
F_MSGBOX(170)

end event

type cb_3 from so_commandbutton within w_product_run_card
string tag = "$$HEX5$$74c7f8bbc0c929bcddc2$$ENDHEX$$"
integer x = 2235
integer y = 520
integer width = 466
integer height = 148
integer taborder = 90
boolean bringtotop = true
integer weight = 400
string text = "2D Barcode Create"
end type

event clicked;call super::clicked;//=============================================================
//
//=============================================================
STRING LVS_RUN_NO , LVS_SERIAL , LVS_RUN_STATUS , LVS_MODEL_NAME  , LVS_ITEM_CODE , LVS_SERIAL_NO , LVS_LABEL_TEXT , LVS_LINE_CODE
STRING LVS_WORKSTAGE_CODE , LVS_MACHINE_CODE , LVS_BCR_CODE , LVS_ARRAY_TYPE , LVS_MARKING_NO
DATETIME LVDT_RUN_DATE
LONG I , J , K ,  m , LVL_LOT_SIZE  , lvl_start_serial
LONG LVL_EXISTS  , lvi_array_no , lvi_carrier_size
DOUBLE LVDB_GROUP_ID


MSG = F_MSGBOX1( 1161 , THIS.TEXT )

IF MSG = 1 THEN 
ELSE
	RETURN 
END IF 




IF DW_1.GETROW() < 1 THEN RETURN 
    DW_4.RESET()

                       
LVS_RUN_NO                = DW_1.OBJECT.RUN_NO[DW_1.GETROW()]
LVS_MODEL_NAME        = DW_1.OBJECT.MODEL_NAME[DW_1.GETROW()]
LVDT_RUN_DATE          = DW_1.OBJECT.RUN_DATE[DW_1.GETROW()]
LVL_LOT_SIZE              = DW_1.OBJECT.LOT_SIZE[DW_1.GETROW()]
LVS_ITEM_CODE           = DW_1.OBJECT.PARENT_ITEM_CODE[DW_1.GETROW()]
LVS_LINE_CODE            = DW_1.OBJECT.LINE_CODE[DW_1.GETROW()]
LVS_MARKING_NO         = DW_1.OBJECT.MARKING_NO[DW_1.GETROW()]
lvi_carrier_size              = DW_1.OBJECT.CARRIER_SIZE[DW_1.GETROW()]
lvl_start_serial               = LONG(EM_START_SERIAL.TEXT)
LVS_WORKSTAGE_CODE = 'W010'
LVS_MACHINE_CODE      = 'MES' 
LVS_ARRAY_TYPE           = ''

//LVS_GROUP_ID = DW_1.OBJECT.MARKING_NO[DW_1.GETROW()] // CUSTOMER ORDER NO
 
if lvi_carrier_size <= 0 or isnull(lvi_carrier_size) then  
	f_msg("$$HEX15$$f0c530bcf4c5200018c2c9b744c720004cc518c22000c6c5b5c2c8b2e4b2$$ENDHEX$$",'P')
	return 
end if 
 
//=================================
// $$HEX10$$6fb8b8d2200088c794b2c0c92000b4cc6cd02000$$ENDHEX$$
//=================================
SELECT COUNT(*)
   INTO :LVL_EXISTS
  FROM IP_PRODUCT_2D_BARCODE
WHERE RUN_NO   = :LVS_RUN_NO
    AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID
    AND ROWNUM = 1;         

IF F_SQL_CHECK() < 0 THEN 
    RETURN
END IF 
//================================================
//
//================================================

IF LVL_EXISTS > 0 THEN 
	
	MSG = MESSAGEBOX("Notify" , f_msg("$$HEX9$$74c7f8bb200074c8acc7200069d5c8b2e4b2$$ENDHEX$$. $$HEX8$$acc7ddc031c1200060d54cae94c62000$$ENDHEX$$?",'S') , QUESTION! , YESNO!)
	
	
	// $$HEX31$$90c7d9b32000ddc031c1200078c7bdacb0c694b22000b4cc6cd0200074d51cc120002cd285c720001cb470ac74ba2000acc7ddc031c1200008aec0c92000$$ENDHEX$$
	IF MSG = 1  THEN 
		
			LVL_EXISTS  = 0 
			
			SELECT COUNT(*) INTO :LVL_EXISTS
			  FROM IP_PRODUCT_2D_BARCODE
			WHERE SERIAL_NO IN ( SELECT SERIAL_NO 
			                                     FROM IP_PRODUCT_WORKSTAGE_IO
				                               WHERE RUN_NO   = :LVS_RUN_NO
					                              AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
		                                 	) ;
			
			IF LVL_EXISTS > 0 THEN 
				f_msg("$$HEX8$$f5ac15c8d0c520002cd285c71cb42000$$ENDHEX$$PID $$HEX15$$85c7c8b2e4b22000acc7ddc031c1200060d518c22000c6c5b5c2c8b2e4b2$$ENDHEX$$",'P')
				RETURN 
			END IF 
		
			//========================================
			// $$HEX16$$7cb7a8bc20009ccd25b8200074c725b844c72000adc01cc820005cd5e4b22000$$ENDHEX$$
			//========================================
			DELETE FROM IP_PRODUCT_2D_BARCODE 
			WHERE RUN_NO = :LVS_RUN_NO 
			    AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
			
			IF F_SQL_CHECK() < 0 THEN 
				RETURN 
			END IF 

    ELSE
		   RETURN 
	END IF 

END IF 

if cbx_create_pid.checked = true then 
	
	i = lvl_start_serial - 1
	m = 0 
			DO 
                      //$$HEX27$$18c2d9b3200088bc38d62000ddc031c174c7200044c5c8b274ba2000f0b788bc38d67cb9200000ac38c8e4b200ac2000ddc031c12000$$ENDHEX$$
					i++
					m++
	
						//===================================
						// $$HEX14$$7cb7a8bc200074c7f8bbc0c92000acc7ddc031c12000ecc580bd2000$$ENDHEX$$
						//===================================
		
						  INSERT INTO IP_PRODUCT_2D_BARCODE  
									( RUN_NO,   
									  RUN_DATE,   
									  ITEM_CODE,   
									  SERIAL_NO,   
									  LABEL_TEXT,   
									  LINE_CODE,   
									  WORKSTAGE_CODE,   
									  MACHINE_CODE,   
									  BCR_CODE,   
									  ARRAY_TYPE,   
									  ORGANIZATION_ID,   
									  ENTER_DATE,   
									  ENTER_BY,   
									  LAST_MODIFY_DATE,   
									  LAST_MODIFY_BY,   
									  MAGAZINE_NO,   
									  BOX_NO,   
									  PALLETE_NO,   
									  CARRIER_BARCODE,   
									  QC_SCAN_YN,   
									  LOT_NO,   
									  QC_SCAN_DATE,   
									  MODEL_NAME,   
									  LOT_QTY,   
									  BARCODE_STATUS,
									  WORK_ORDER_NO)  
						  VALUES ( 
						  
									  :LVS_RUN_NO,   
									  :LVDT_RUN_DATE,   
									  :LVS_ITEM_CODE,   
									  f_get_pcb_barcode_serial ( :lvs_run_no , :i ) ,    
									  f_get_pcb_barcode_label ( :lvs_run_no , :i ) ,  
									  :LVS_LINE_CODE,   
									  :LVS_WORKSTAGE_CODE,   
									  :LVS_MACHINE_CODE,   
									  :LVS_BCR_CODE,   
									  :LVS_ARRAY_TYPE,   
									  :GVI_ORGANIZATION_ID,   
									  SYSDATE,   
									  :GVS_USER_ID ,   
									  SYSDATE,   
									  :GVS_USER_ID ,      
									  '' , // MAGAZINE_NO,   
									  '', //BOX_NO,   
									  '', //PALLETE_NO,   
									  '', //CARRIER_BARCODE,   
									  'N' , //QC_SCAN_YN,   
									  '' , //LOT_NO,   
									  NULL , //QC_SCAN_DATE,   
									  :LVS_MODEL_NAME,   
									  :LVL_LOT_SIZE,   
									  'N' , //BARCODE_STATUS
									  :LVS_MARKING_NO
						       )  ;
						
							IF F_SQL_CHECK() < 0 THEN 
								RETURN 
							END IF 
							f_msg_mdi_help( string(i) +" / " + STRING(LVL_LOT_SIZE) )
				
			LOOP UNTIL m =  LVL_LOT_SIZE 
			
			COMMIT ;
end if 
//===================================
// $$HEX14$$7cb7a8bc200074c7f8bbc0c92000acc7ddc031c12000ecc580bd2000$$ENDHEX$$
//===================================
IF RB_DEFAULT_LABEL.CHECKED = TRUE THEN 

        //=====================================
        // $$HEX3$$74c704c82000$$ENDHEX$$PNG , BMP $$HEX3$$adc01cc82000$$ENDHEX$$
        //=====================================
        RUN( "DELPNG.BAT")
        //=====================================
        I = 0 ; J = 0 
        STRING LVS_FILE_NAME 

                     GVS_BARCODE_TYPE = '71'
                     //=======================================
                    // $$HEX10$$70b374c730d17cb9200070c88cd65cd5c4d62000$$ENDHEX$$
                    // $$HEX8$$f8adbcb93cc75cb820005cd4dcc22000$$ENDHEX$$
                    //=======================================           
                    
                    LONG LVI_TOT_COUNT
                    SELECT COUNT(*) INTO :LVI_TOT_COUNT 
			         FROM IP_PRODUCT_2D_BARCODE
                    WHERE RUN_NO = :LVS_RUN_NO
						  ;
                    
                    IF F_SQL_CHECK() < 0 THEN 
                        RETURN 
                    END IF 
                    
                    DW_4.SETREDRAW(FALSE)
                    DW_4.RETRIEVE(  LVS_RUN_NO , GVI_ORGANIZATION_ID )
                    DW_4.SETREDRAW(TRUE)
                    
                    IF LVI_TOT_COUNT = DW_4.ROWCOUNT() THEN 
                        F_MSG_MDI_HELP("MATCH OK "+STRING(LVI_TOT_COUNT))
                    ELSE
                        MESSAGEBOX("ERROR" , LVS_RUN_NO+"  QTY="+STRING(LVI_TOT_COUNT)+" / "+STRING(DW_4.ROWCOUNT())+" LABEL QTY UNMATCH")
                        RETURN
                    END IF 
                    
                    //=======================================
                    // $$HEX11$$14bc54cfdcb4200074c7f8bbc0c92000ddc031c12000$$ENDHEX$$
                    //=======================================           
                    OPEN(W_PROGRESS_POPUP)
                    W_PROGRESS_POPUP.F_SET_RANGE(1 , DW_4.ROWCOUNT( ) )
                    W_PROGRESS_POPUP.F_SETSTEP(1)

                    DO
                        i++
                         YIELD()
                        LVS_FILE_NAME = DW_4.OBJECT.SERIAL_NO_ORIGIN[I]
                
                        //$$HEX7$$14bc54cfdcb42000ddc031c12000$$ENDHEX$$
                        IF GVS_BARCODE_TYPE = '71' THEN 
                            IF  RUN("ZINT -o "+LVS_FILE_NAME+'.PNG --square -b '+GVS_BARCODE_TYPE+' -d '+LVS_FILE_NAME , MINIMIZED! ) < 0 THEN 
                                RETURN
                            END IF 
                        ELSE
                            IF  RUN("ZINT -o "+LVS_FILE_NAME+'.PNG --square -b  '+GVS_BARCODE_TYPE+' -d '+LVS_FILE_NAME , MINIMIZED! ) < 0 THEN 
                                RETURN
                            END IF                          
                        END IF 
                                
                        W_PROGRESS_POPUP.F_STEPIT()
                        W_PROGRESS_POPUP.F_SET_MESSAGE(STRING(j))
                        
                         F_MSG_MDI_HELP( "CREATE BARCODE "+ STRING(i))
                    LOOP UNTIL I = DW_4.ROWCOUNT( )
                    
                    SLEEP(2)
                    //======================================
                    // $$HEX9$$f8adbcb92000ecd3f7b92000c0bcbdac2000$$ENDHEX$$PNG -> BMP
                    //======================================
                    I = 0 
                    DO
                        YIELD()
                        i++
                        j++             
                        LVS_FILE_NAME = DW_4.OBJECT.SERIAL_NO_ORIGIN[I]
                        
                        //$$HEX6$$ecd3f7b92000c0bcbdac2000$$ENDHEX$$PNG => BMP
                        
                        IF GVS_BARCODE_TYPE = '71' THEN 
                            RUN("I_VIEW32 "+LVS_FILE_NAME+'.PNG /rotate_l /convert='+LVS_FILE_NAME+'.BMP' , MINIMIZED! )  
                        ELSE
                            RUN("I_VIEW32 "+LVS_FILE_NAME+'.PNG /convert='+LVS_FILE_NAME+'.BMP' , MINIMIZED! )  
                        END IF 
                        
                        //DW_4.OBJECT.SERIAL_NO[I] = DW_4.OBJECT.SERIAL_NO[I]+".BMP"
                        W_PROGRESS_POPUP.F_STEPIT()
                        W_PROGRESS_POPUP.F_SET_MESSAGE(STRING(J))           
                         F_MSG_MDI_HELP( "FORMAT CHANGE BARCODE "+ STRING(I))
								 
					  IF i = 1 THEN 
						 MSG =MESSAGEBOX("Notify" , f_msg("Continue ?",'S') , question! , yesno! )
						 IF MSG = 1 THEN 
						 ELSE
							ROLLBACK; 
							RETURN
						END IF 
					  END IF 
								 
                    LOOP UNTIL I = DW_4.ROWCOUNT( )     
                    //======================================
                    //
                    //======================================
                    CLOSE(W_PROGRESS_POPUP)
                     
//                    DW_4.MODIFY("LABEL_TEXT.FONT.HEIGHT='"+STRING(INTEGER(EM_FONT.TEXT) * -1)+"'")  
//                    DW_4.MODIFY("DATAWINDOW.LABEL.HEIGHT='"+EM_HEIGHT.TEXT+"'")
//                    DW_4.MODIFY("DATAWINDOW.LABEL.WIDTH='"+EM_WIDTH.TEXT+"'")
//                    
//                    DW_4.MODIFY("DATAWINDOW.LABEL.COLUMNS="+EM_ACROSS.TEXT)
//                    DW_4.MODIFY("DATAWINDOW.LABEL.COLUMNS.SPACING ='"+EM_COLUMN_SPACE.TEXT+"'")
//                    DW_4.MODIFY("DATAWINDOW.LABEL.ROWS.SPACING ='"+EM_ROW_SPACE.TEXT+"'")
                    DW_4.MODIFY("DATAWINDOW.PRINT.PREVIEW.RULERS=YES")

ELSEIF RB_BARTEND.CHECKED = TRUE THEN
    
ELSEIF  RB_MACHINE.CHECKED = TRUE THEN      

ELSE
     // $$HEX8$$7cb7a8bc20001cbc89d5200048c568d5$$ENDHEX$$
END IF 


F_MSGBOX(170)

end event

type rb_bartend from so_radiobutton within w_product_run_card
integer x = 4617
integer y = 368
integer width = 357
boolean bringtotop = true
string text = "Bartend"
end type

type rb_machine from so_radiobutton within w_product_run_card
integer x = 4983
integer y = 368
integer width = 384
boolean bringtotop = true
string text = "M.K Machine"
end type

type rb_default_label from so_radiobutton within w_product_run_card
integer x = 4265
integer y = 368
integer width = 347
boolean bringtotop = true
string text = "Default"
end type

type rb_no_label from so_radiobutton within w_product_run_card
integer x = 5390
integer y = 368
integer width = 384
boolean bringtotop = true
string text = "No Label"
boolean checked = true
end type

type cbx_create_pid from so_checkbox within w_product_run_card
integer x = 4238
integer y = 84
integer width = 530
integer height = 68
boolean bringtotop = true
string text = "Create PID"
boolean checked = true
end type

event clicked;//if this.checked = true then 
//em_leftmargin.enabled  = true
//else
//	em_leftmargin.enabled  = false
//end if 
end event

type st_8 from statictext within w_product_run_card
integer x = 2853
integer y = 180
integer width = 398
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Customer Code"
alignment alignment = right!
boolean focusrectangle = false
end type

type ddlb_customer_code from uo_customer_code_name within w_product_run_card
integer x = 3296
integer y = 172
integer width = 718
integer height = 1312
integer taborder = 70
boolean bringtotop = true
boolean autohscroll = true
boolean vscrollbar = false
end type

type cbx_1 from so_checkbox within w_product_run_card
integer x = 4238
integer y = 160
integer width = 530
integer height = 68
boolean bringtotop = true
string text = "Use Carrier Size"
boolean checked = true
end type

type cbx_bom_checck from so_checkbox within w_product_run_card
integer x = 4238
integer y = 236
integer width = 594
integer height = 68
boolean bringtotop = true
string text = "Generate Detail By BOM"
boolean checked = true
end type

type rb_isssue_plan from so_radiobutton within w_product_run_card
integer x = 101
integer y = 368
boolean bringtotop = true
string text = "Issue Plan"
end type

event clicked;call super::clicked;dw_5.bringtotop  = true 
selected_data_window = dw_5

long i , j 
string lvs_run_no []


do
	i++
	
	if dw_1.object.check_yn[i] = 'Y' then 
		
		j++
	     lvs_run_no [j] = dw_1.object.run_no[i]
		  
      end if 
	
loop until i = dw_1.rowcount()


if j > 0 then 

         dw_5.retrieve(lvs_run_no , gvi_organization_id )

end if 

end event

type cb_6 from so_commandbutton within w_product_run_card
integer x = 1797
integer y = 520
integer width = 439
integer height = 148
integer taborder = 90
boolean bringtotop = true
integer weight = 400
string text = "Print Issue Plan"
end type

event clicked;call super::clicked;long i , j 
string lvs_run_no []


do
	i++
	
	if dw_1.object.check_yn[i] = 'Y' then 
		
		j++
	     lvs_run_no [j] = dw_1.object.run_no[i]
		  
      end if 
	
loop until i = dw_1.rowcount()


if j > 0 then 

         dw_5.retrieve(lvs_run_no , gvi_organization_id )
			
		if dw_5.rowcount() < 1 then return
		
		if dw_5.rowcount( ) > 0 then 
			dw_5.print( TRUE)
		end if 


end if 


end event

type cbx_force_delete from so_checkbox within w_product_run_card
integer x = 4841
integer y = 160
integer width = 411
integer height = 68
boolean bringtotop = true
string text = "Force Delete"
end type

type em_start_serial from so_editmask within w_product_run_card
integer x = 3191
integer y = 580
integer taborder = 100
boolean bringtotop = true
string text = "1"
alignment alignment = center!
string mask = "###,##0"
boolean spin = true
double increment = 1
string minmax = "1~~9999"
end type

type st_9 from so_statictext within w_product_run_card
integer x = 3191
integer y = 508
integer width = 402
integer height = 72
boolean bringtotop = true
string text = "Start Serial"
end type

type ddlb_model_class from uo_basecode within w_product_run_card
integer x = 2258
integer y = 204
integer width = 512
integer taborder = 100
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw('MODEL CLASS')
end event

type st_10 from so_statictext within w_product_run_card
integer x = 2258
integer y = 132
integer width = 512
integer height = 72
boolean bringtotop = true
string text = "Model Class"
end type

type st_12 from so_statictext within w_product_run_card
integer x = 2254
integer y = 300
integer width = 512
integer height = 72
boolean bringtotop = true
long textcolor = 255
string text = "PCB Week"
end type

type sle_pcb_week from so_singlelineedit within w_product_run_card
integer x = 2258
integer y = 388
integer width = 512
integer height = 92
integer taborder = 50
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
boolean displayonly = true
end type

type cb_7 from so_commandbutton within w_product_run_card
string tag = "$$HEX5$$74c7f8bbc0c929bcddc2$$ENDHEX$$"
integer x = 2702
integer y = 520
integer width = 466
integer height = 148
integer taborder = 100
boolean bringtotop = true
integer weight = 400
string text = "2D Barcode Save"
end type

event clicked;call super::clicked;if dw_1.getrow() < 1 then return 

gst_return.gvs_return[1] = dw_1.object.model_name[dw_1.getrow()]
openwithparm( w_com_label_file_write_popup , string(dw_1.object.run_no[dw_1.getrow()] ))
end event

type cbx_wsio_auto_retrieve from so_checkbox within w_product_run_card
integer x = 4832
integer y = 76
integer width = 521
integer height = 68
boolean bringtotop = true
string text = "W/S IO Auto Retriee"
end type

type gb_2 from so_groupbox within w_product_run_card
integer x = 713
integer y = 16
integer width = 2089
integer taborder = 90
string text = "Create Condition"
end type

type gb_4 from so_groupbox within w_product_run_card
integer x = 4197
integer y = 8
integer width = 1600
integer height = 312
integer taborder = 100
string text = "Where Condition"
end type

type gb_1 from so_groupbox within w_product_run_card
integer x = 18
integer y = 16
integer width = 663
integer taborder = 80
string text = "Category"
end type

type gb_5 from so_groupbox within w_product_run_card
integer x = 4201
integer y = 308
integer width = 1595
integer height = 176
integer taborder = 110
end type

type gb_6 from so_groupbox within w_product_run_card
integer x = 2807
integer y = 8
integer width = 1376
integer taborder = 110
string text = "Where Condition"
end type

