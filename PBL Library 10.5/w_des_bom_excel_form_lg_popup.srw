HA$PBExportHeader$w_des_bom_excel_form_lg_popup.srw
$PBExportComments$$$HEX4$$d1c540c191c5ddc2$$ENDHEX$$
forward
global type w_des_bom_excel_form_lg_popup from w_popup_root
end type
type cb_confirm from so_commandbutton within w_des_bom_excel_form_lg_popup
end type
type cb_2 from so_commandbutton within w_des_bom_excel_form_lg_popup
end type
type pb_1 from so_commandbutton within w_des_bom_excel_form_lg_popup
end type
type cbx_assy_yn from checkbox within w_des_bom_excel_form_lg_popup
end type
type cbx_bom_create from checkbox within w_des_bom_excel_form_lg_popup
end type
type mle_confirm_comment from so_multilineedit within w_des_bom_excel_form_lg_popup
end type
type st_request_comment from so_statictext within w_des_bom_excel_form_lg_popup
end type
type cbx_mfs_bom from checkbox within w_des_bom_excel_form_lg_popup
end type
type sle_revision from so_singlelineedit within w_des_bom_excel_form_lg_popup
end type
type st_revision from so_statictext within w_des_bom_excel_form_lg_popup
end type
type st_17 from so_statictext within w_des_bom_excel_form_lg_popup
end type
type ddlb_work_no from uo_bom_workno within w_des_bom_excel_form_lg_popup
end type
type st_set_item_code from so_statictext within w_des_bom_excel_form_lg_popup
end type
type sle_set_item_code from so_singlelineedit within w_des_bom_excel_form_lg_popup
end type
type sle_model_name from so_singlelineedit within w_des_bom_excel_form_lg_popup
end type
type st_model_name from so_statictext within w_des_bom_excel_form_lg_popup
end type
type sle_smt_model_name from so_singlelineedit within w_des_bom_excel_form_lg_popup
end type
type st_2 from so_statictext within w_des_bom_excel_form_lg_popup
end type
type sle_master_model_name from so_singlelineedit within w_des_bom_excel_form_lg_popup
end type
type st_3 from so_statictext within w_des_bom_excel_form_lg_popup
end type
type em_caarier_size from so_editmask within w_des_bom_excel_form_lg_popup
end type
type st_4 from so_statictext within w_des_bom_excel_form_lg_popup
end type
type cbx_use_default_model from checkbox within w_des_bom_excel_form_lg_popup
end type
type rb_default_form from so_radiobutton within w_des_bom_excel_form_lg_popup
end type
type rb_dongdu_from from so_radiobutton within w_des_bom_excel_form_lg_popup
end type
type gb_1 from so_groupbox within w_des_bom_excel_form_lg_popup
end type
type gb_2 from so_groupbox within w_des_bom_excel_form_lg_popup
end type
type gb_3 from so_groupbox within w_des_bom_excel_form_lg_popup
end type
type gb_4 from so_groupbox within w_des_bom_excel_form_lg_popup
end type
end forward

global type w_des_bom_excel_form_lg_popup from w_popup_root
integer width = 4727
integer height = 2664
string title = "BOM Create"
cb_confirm cb_confirm
cb_2 cb_2
pb_1 pb_1
cbx_assy_yn cbx_assy_yn
cbx_bom_create cbx_bom_create
mle_confirm_comment mle_confirm_comment
st_request_comment st_request_comment
cbx_mfs_bom cbx_mfs_bom
sle_revision sle_revision
st_revision st_revision
st_17 st_17
ddlb_work_no ddlb_work_no
st_set_item_code st_set_item_code
sle_set_item_code sle_set_item_code
sle_model_name sle_model_name
st_model_name st_model_name
sle_smt_model_name sle_smt_model_name
st_2 st_2
sle_master_model_name sle_master_model_name
st_3 st_3
em_caarier_size em_caarier_size
st_4 st_4
cbx_use_default_model cbx_use_default_model
rb_default_form rb_default_form
rb_dongdu_from rb_dongdu_from
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
end type
global w_des_bom_excel_form_lg_popup w_des_bom_excel_form_lg_popup

type variables
datawindow idw_datawindow

LONG     LVL_COUNT  , LVL_CARRIER_SIZE
DOUBLE LVL_WORK_NO , lvdb_return
STRING  LVS_REVISION , LVS_MODEL_NAME , LVS_MASTER_MODEL_NAME , LVS_SMT_MODEL_NAME , LVS_SET_ITEM_CODE , LVS_PART_NO , LVS_MODEL_SPEC , LVS_CUSTOMER_MODEL_NAME , LVS_MODEL_SUFFIX

end variables

forward prototypes
public function integer wf_save_lg ()
public function integer wf_save_vietnam ()
end prototypes

public function integer wf_save_lg ();string  lvs_parent_item_code ,  lvs_child_item_code ,  lvs_work_no , lvs_bom_create_yn
long i , lvi_count , j  

DELETE FROM ID_ENG_BOM_EXCEL_LG ;

if f_sql_check() < 0 then 
	return -1
end if 

//==========================================
// $$HEX5$$99bdecc5200023b130ae$$ENDHEX$$
//==========================================
dw_1.reset()
dw_1.importclipboard( )


LVS_REVISION = SLE_REvision.TEXT 
LVL_CARRIER_SIZE = LONG(EM_caarier_size.TEXT)

if cbx_use_default_model.checked = true then 
		LVS_SET_ITEM_CODE = dw_1.object.parent_part_no[1] ;
		LVS_CUSTOMER_MODEL_NAME = dw_1.object.parent_part_no[1]
		LVS_MODEL_NAME = dw_1.object.parent_part_no[1]
		LVS_SMT_MODEL_NAME = dw_1.object.parent_part_no[1]
		LVS_MASTER_MODEL_NAME =dw_1.object.parent_part_no[1]
		LVS_PART_NO = dw_1.object.parent_part_no[1]
		LVS_MODEL_SPEC  =dw_1.object.parent_part_no[1]
		
		sle_set_item_code.text = LVS_SET_ITEM_CODE
		SLE_MODEL_NAME.TEXT =LVS_CUSTOMER_MODEL_NAME
		SLE_MODEL_NAME.TEXT = LVS_MODEL_NAME
		SLE_SMT_MODEL_NAME.TEXT = LVS_SMT_MODEL_NAME
		SLE_MASTER_MODEL_NAME.TEXT = LVS_MASTER_MODEL_NAME
		SLE_SET_ITEM_code.TEXT = LVS_PART_NO
		SLE_MODEL_NAME.TEXT = LVS_MODEL_SPEC
		
else
		LVS_SET_ITEM_CODE = sle_set_item_code.text ;
		LVS_CUSTOMER_MODEL_NAME= SLE_MODEL_NAME.TEXT
		LVS_MODEL_NAME = SLE_MODEL_NAME.TEXT
		LVS_SMT_MODEL_NAME = SLE_SMT_MODEL_NAME.TEXT
		LVS_MASTER_MODEL_NAME = SLE_MASTER_MODEL_NAME.TEXT
		LVS_PART_NO = SLE_SET_ITEM_code.TEXT
		LVS_MODEL_SPEC  = SLE_MODEL_NAME.TEXT
end if 
if LVS_MODEL_NAME = '' or isnull(LVS_MODEL_NAME) then 
		f_msgbox1(126 ,st_model_name.text )	
		return -1
end if 


//=========================================
//
//=========================================

if dw_1.rowcount( ) < 1 then return  -1

open(w_progress_popup)
w_progress_popup.f_set_range( 1,  dw_1.rowcount( ) )
w_progress_popup.f_setstep(1)
			
lvs_set_item_code  = dw_1.object.parent_part_no[1]			
lvs_work_no = string(f_sysdate() , 'yymmddhh24mmss')			

sle_set_item_code.text = lvs_set_item_code

if cbx_bom_create.checked = true then 
	lvs_bom_create_yn = 'Y'
else
	lvs_bom_create_yn = 'N'	
end if 


dw_1.object.confirm_comment[1] = mle_confirm_comment.text

do
	i++
		
	lvs_parent_item_code  = dw_1.object.parent_part_no[i]
	lvs_child_item_code = dw_1.object.part_no[i]
	
		select count(*) into :lvi_count 
		from id_eng_bom_workspace 
		where parent_item_code = :lvs_parent_item_code
		    and child_item_code = :lvs_child_item_code
		    and organization_id = :gvi_organization_id ;
		  
		if f_sql_check() < 0 then 
			close(w_progress_popup)
			return -1
		end if 
		  
		if lvi_count > 1 then 
				dw_1.selectrow(i , true)
			j++
		end if 
		
	dw_1.object.set_item_code[i]  = lvs_set_item_code	
	dw_1.object.bom_create_yn[i] = lvs_bom_create_yn
	w_progress_popup.f_stepit()
	//========================================
	//
	//========================================
	dw_1.object.comments[i] =lvs_work_no
	
loop until i = dw_1.rowcount( )

close(w_progress_popup)

//==================================================
//
//==================================================
delete from id_eng_bom_workspace 
 where item_code = :lvs_set_item_code ;
 
 if f_sql_check() < 0 then 
	return -1
end if 

if j> 0 then
	rollback;
	f_msgbox(813 )
	return -1
end if

msg = f_msgbox(1170)
if msg = 1 then 
	if dw_1.update() < 0 then 
		rollback;
	else
		commit ;
	end if 
end if 

commit ;
ddlb_work_no.redraw( )
ddlb_work_no.selectitem( 2	)

end function

public function integer wf_save_vietnam ();string  lvs_parent_item_code ,  lvs_child_item_code ,  lvs_work_no , lvs_bom_create_yn
long i , lvi_count , j  

DELETE FROM ID_ENG_BOM_EXCEL_LG ;

if f_sql_check() < 0 then 
	return -1
end if 

//==========================================
// $$HEX5$$99bdecc5200023b130ae$$ENDHEX$$
//==========================================
dw_1.reset()
dw_1.importclipboard( )

LVS_REVISION = SLE_REvision.TEXT 
LVL_CARRIER_SIZE = LONG(EM_caarier_size.TEXT)

//$$HEX31$$d1c540c158c720005ccd85c82000fcd3a9ba44c72000f8ad00b35cb82000a8ba78b35cb82000acc0a9c6200058d58cac200058d594b22000bdacb0c62000$$ENDHEX$$
if cbx_use_default_model.checked = true then 
	
		LVS_SET_ITEM_CODE = dw_1.object.part_no[1] ;
		LVS_CUSTOMER_MODEL_NAME = dw_1.object.part_no[1]
		LVS_MODEL_NAME = dw_1.object.part_no[1]
		LVS_SMT_MODEL_NAME = dw_1.object.part_no[1]
		LVS_MASTER_MODEL_NAME =dw_1.object.part_no[1]
		LVS_PART_NO = dw_1.object.part_no[1]
		LVS_MODEL_SPEC  =dw_1.object.part_no[1]
		
		sle_set_item_code.text = LVS_SET_ITEM_CODE
		SLE_MODEL_NAME.TEXT =LVS_CUSTOMER_MODEL_NAME
		SLE_MODEL_NAME.TEXT = LVS_MODEL_NAME
		SLE_SMT_MODEL_NAME.TEXT = LVS_SMT_MODEL_NAME
		SLE_MASTER_MODEL_NAME.TEXT = LVS_MASTER_MODEL_NAME
		SLE_SET_ITEM_code.TEXT = LVS_PART_NO
		SLE_MODEL_NAME.TEXT = LVS_MODEL_SPEC
//=========================================
// $$HEX22$$85c725b81bbc40c72000a8ba78b35cb82000a8ba78b385ba44c72000acc0a9c658d594b22000bdacb0c62000$$ENDHEX$$
//=========================================
else
		LVS_SET_ITEM_CODE = sle_set_item_code.text ;
		LVS_CUSTOMER_MODEL_NAME= SLE_MODEL_NAME.TEXT
		LVS_MODEL_NAME = SLE_MODEL_NAME.TEXT
		LVS_SMT_MODEL_NAME = SLE_SMT_MODEL_NAME.TEXT
		LVS_MASTER_MODEL_NAME = SLE_MASTER_MODEL_NAME.TEXT
		LVS_PART_NO = SLE_SET_ITEM_code.TEXT
		LVS_MODEL_SPEC  = SLE_MODEL_NAME.TEXT
end if 

if LVS_MODEL_NAME = '' or isnull(LVS_MODEL_NAME) then 
		f_msgbox1(126 ,st_model_name.text )	
		return -1
end if 

//=========================================
//
//=========================================

if dw_1.rowcount( ) < 1 then return  -1

open(w_progress_popup)
w_progress_popup.f_set_range( 1,  dw_1.rowcount( ) )
w_progress_popup.f_setstep(1)

lvs_work_no = string(f_sysdate() , 'yymmddhh24mmss')			

//$$HEX12$$abcc04c974c7200038c1b8d220000cd3b8d218b184bc2000$$ENDHEX$$
lvs_parent_item_code  = dw_1.object.parent_part_no[1]


if cbx_bom_create.checked = true then 
	lvs_bom_create_yn = 'Y'
else
	lvs_bom_create_yn = 'N'	
end if 

dw_1.object.confirm_comment[1] = mle_confirm_comment.text

do
	i++
		
	//lvs_parent_item_code  = dw_1.object.parent_part_no[i]
	lvs_child_item_code = dw_1.object.part_no[i]
	
		select count(*) into :lvi_count 
		from id_eng_bom_workspace 
		where parent_item_code = :lvs_parent_item_code
		    and child_item_code = :lvs_child_item_code
		    and organization_id = :gvi_organization_id ;
		  
		if f_sql_check() < 0 then 
			close(w_progress_popup)
			return -1
		end if 
		  
		if lvi_count > 1 then 
				dw_1.selectrow(i , true)
			j++
		end if 
	
	//==================================
	// $$HEX11$$94cd00ac01c878c72000acc06dd5200085c725b82000$$ENDHEX$$
	//==================================
	
	dw_1.object.expiry_date[i] =  STRING( f_t_sysdate() , 'YYYYMMDD')
	dw_1.object.extended_qty[i] = dw_1.object.component_qty[i] 
	
	if i = 1 then 
			dw_1.object.item_type[i] = 'P'
	else
		dw_1.object.item_type[i] = 'G'
	end if 

	dw_1.object.set_item_code[i]  = lvs_set_item_code	
	dw_1.object.parent_part_no[i]  = lvs_set_item_code	
	dw_1.object.bom_create_yn[i] = lvs_bom_create_yn
	w_progress_popup.f_stepit()
	//========================================
	//
	//========================================
	dw_1.object.comments[i] =lvs_work_no
	
loop until i = dw_1.rowcount( )

close(w_progress_popup)

//==================================================
//
//==================================================
delete from id_eng_bom_workspace 
 where item_code = :lvs_set_item_code ;
 
 if f_sql_check() < 0 then 
	return -1
end if 

if j> 0 then
	rollback;
	f_msgbox(813 )
	return -1
end if

msg = f_msgbox(1170)
if msg = 1 then 
	if dw_1.update() < 0 then 
		rollback;
	else
		commit ;
	end if 
end if 

commit ;
ddlb_work_no.redraw( )
ddlb_work_no.selectitem( 2	)

end function

on w_des_bom_excel_form_lg_popup.create
int iCurrent
call super::create
this.cb_confirm=create cb_confirm
this.cb_2=create cb_2
this.pb_1=create pb_1
this.cbx_assy_yn=create cbx_assy_yn
this.cbx_bom_create=create cbx_bom_create
this.mle_confirm_comment=create mle_confirm_comment
this.st_request_comment=create st_request_comment
this.cbx_mfs_bom=create cbx_mfs_bom
this.sle_revision=create sle_revision
this.st_revision=create st_revision
this.st_17=create st_17
this.ddlb_work_no=create ddlb_work_no
this.st_set_item_code=create st_set_item_code
this.sle_set_item_code=create sle_set_item_code
this.sle_model_name=create sle_model_name
this.st_model_name=create st_model_name
this.sle_smt_model_name=create sle_smt_model_name
this.st_2=create st_2
this.sle_master_model_name=create sle_master_model_name
this.st_3=create st_3
this.em_caarier_size=create em_caarier_size
this.st_4=create st_4
this.cbx_use_default_model=create cbx_use_default_model
this.rb_default_form=create rb_default_form
this.rb_dongdu_from=create rb_dongdu_from
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_confirm
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.cbx_assy_yn
this.Control[iCurrent+5]=this.cbx_bom_create
this.Control[iCurrent+6]=this.mle_confirm_comment
this.Control[iCurrent+7]=this.st_request_comment
this.Control[iCurrent+8]=this.cbx_mfs_bom
this.Control[iCurrent+9]=this.sle_revision
this.Control[iCurrent+10]=this.st_revision
this.Control[iCurrent+11]=this.st_17
this.Control[iCurrent+12]=this.ddlb_work_no
this.Control[iCurrent+13]=this.st_set_item_code
this.Control[iCurrent+14]=this.sle_set_item_code
this.Control[iCurrent+15]=this.sle_model_name
this.Control[iCurrent+16]=this.st_model_name
this.Control[iCurrent+17]=this.sle_smt_model_name
this.Control[iCurrent+18]=this.st_2
this.Control[iCurrent+19]=this.sle_master_model_name
this.Control[iCurrent+20]=this.st_3
this.Control[iCurrent+21]=this.em_caarier_size
this.Control[iCurrent+22]=this.st_4
this.Control[iCurrent+23]=this.cbx_use_default_model
this.Control[iCurrent+24]=this.rb_default_form
this.Control[iCurrent+25]=this.rb_dongdu_from
this.Control[iCurrent+26]=this.gb_1
this.Control[iCurrent+27]=this.gb_2
this.Control[iCurrent+28]=this.gb_3
this.Control[iCurrent+29]=this.gb_4
end on

on w_des_bom_excel_form_lg_popup.destroy
call super::destroy
destroy(this.cb_confirm)
destroy(this.cb_2)
destroy(this.pb_1)
destroy(this.cbx_assy_yn)
destroy(this.cbx_bom_create)
destroy(this.mle_confirm_comment)
destroy(this.st_request_comment)
destroy(this.cbx_mfs_bom)
destroy(this.sle_revision)
destroy(this.st_revision)
destroy(this.st_17)
destroy(this.ddlb_work_no)
destroy(this.st_set_item_code)
destroy(this.sle_set_item_code)
destroy(this.sle_model_name)
destroy(this.st_model_name)
destroy(this.sle_smt_model_name)
destroy(this.st_2)
destroy(this.sle_master_model_name)
destroy(this.st_3)
destroy(this.em_caarier_size)
destroy(this.st_4)
destroy(this.cbx_use_default_model)
destroy(this.rb_default_form)
destroy(this.rb_dongdu_from)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
end on

event open;call super::open;dw_1.settransobject(sqlca)

end event

event activate;call super::activate;ivs_resize_type = 'DEFAULT'
end event

event ue_post_open;call super::ue_post_open;dw_2.SETTRANSOBJECT(SQLCA)


end event

event close;call super::close;rollback;
end event

event closequery;call super::closequery;rollback;
end event

type p_title from w_popup_root`p_title within w_des_bom_excel_form_lg_popup
integer width = 4704
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
end type

type cb_sort from w_popup_root`cb_sort within w_des_bom_excel_form_lg_popup
integer x = 1024
integer y = 0
integer taborder = 40
end type

type cb_close from w_popup_root`cb_close within w_des_bom_excel_form_lg_popup
boolean visible = true
integer x = 4142
integer y = 648
integer width = 489
integer height = 128
integer taborder = 0
end type

event cb_close::clicked;rollback;
close(parent)
end event

type st_msg from w_popup_root`st_msg within w_des_bom_excel_form_lg_popup
boolean visible = true
integer y = 800
integer width = 4704
integer weight = 400
end type

type dw_1 from w_popup_root`dw_1 within w_des_bom_excel_form_lg_popup
boolean visible = true
integer x = 9
integer y = 1052
integer width = 2702
integer height = 1512
integer taborder = 20
boolean titlebar = true
string title = "BOM Upload"
string dataobject = "d_des_bom_import_excel_lcd"
boolean controlmenu = true
end type

type dw_2 from w_popup_root`dw_2 within w_des_bom_excel_form_lg_popup
boolean visible = true
integer x = 2711
integer y = 900
integer width = 2007
integer height = 1692
integer taborder = 0
boolean titlebar = true
string title = "MFS Bom"
string dataobject = "d_des_mfs_bom_lst"
boolean controlmenu = true
end type

event dw_2::constructor;//override
end event

type dw_3 from w_popup_root`dw_3 within w_des_bom_excel_form_lg_popup
integer y = 916
integer taborder = 50
end type

type cb_confirm from so_commandbutton within w_des_bom_excel_form_lg_popup
integer x = 4142
integer y = 408
integer width = 489
integer height = 128
integer taborder = 10
boolean bringtotop = true
string text = "BOM Confirm"
end type

event clicked;call super::clicked;LVS_REVISION = SLE_REvision.TEXT 
LVS_SET_ITEM_CODE = sle_set_item_code.text ;
LVS_CUSTOMER_MODEL_NAME= SLE_MODEL_NAME.TEXT
LVS_MODEL_NAME = SLE_MODEL_NAME.TEXT
LVS_SMT_MODEL_NAME = SLE_SMT_MODEL_NAME.TEXT
LVS_MASTER_MODEL_NAME = SLE_MASTER_MODEL_NAME.TEXT
LVS_PART_NO = SLE_SET_ITEM_code.TEXT
LVL_CARRIER_SIZE = LONG(EM_caarier_size.TEXT)
LVS_MODEL_SPEC  = SLE_MODEL_NAME.TEXT

if mle_confirm_comment.text = '' then 

	f_msgbox1(126 ,st_request_comment.text )
	return 
end if 

if sle_revision.text = '' or isnull(sle_revision.text) then 
		f_msgbox1(126 ,st_revision.text )	
		return 
elseif LVS_MODEL_NAME = '' or isnull(LVS_MODEL_NAME) then 
		f_msgbox1(126 ,st_model_name.text )	
		return 
elseif lvs_set_item_code = '' or isnull( lvs_set_item_code) then 
		f_msgbox1(126 ,st_set_item_code.text )	
		return 
end if 


//IF F_OBJECT_ROLE_CHECK() = FALSE THEN  RETURN

LVL_WORK_NO    =  DOUBLE(DDLB_WORK_NO.TEXT())

if  LVL_WORK_NO = 0 or isnull(LVL_WORK_NO) then 
	return
end if


//=============================================
// $$HEX13$$a8ba78b32000c8b9a4c230d1200090c7d9b32000f1b45db82000$$ENDHEX$$
//=============================================

	 SELECT COUNT(*) INTO :LVL_COUNT FROM IP_PRODUCT_MODEL_MASTER
	  WHERE MODEL_NAME = :LVS_MODEL_NAME 
		  AND ITEM_CODE = :LVS_SET_ITEM_CODE 
		 AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
			 
		IF F_SQL_CHECK() < 0 THEN 
			RETURN 
		END IF 
		
		IF LVL_COUNT > 0 THEN 
		ELSE
		
				  INSERT INTO IP_PRODUCT_MODEL_MASTER  
							( MODEL_NAME,   
							  MODEL_SPEC,   
							  MODEL_TYPE,   
							  PART_NO,   
							  VERSION,   
							  SITE_CODE,   
							  COMPANY_NO,   
							  COMPANY_CODE,   
							  CARRIER_SIZE,   
							  PCB_TOTAL_QTY,   
							  CUSTOMER_CODE,   
							  CUSTOMER_NAME,   
							  MARKING_CONDITION,   
							  MARKING_YN,   
							  MODEL_DIVISION,   
							  BARCODE_TYPE,   
							  PACKING_PCS_QTY,   
							  PACKING_TRAY_BOX_QTY,   
							  ARRAY_TYPE,   
							  DATESET,   
							  DATEEND,   
							  CONFIRM_DATE,   
							  SERIAL_NO_LENGTH,   
							  PACKING_BOX_MAX_PSC_QTY,   
							  PACKING_BOX_MIN_PSC_QTY,   
							  ORGANIZATION_ID,   
							  ENTER_BY,   
							  ENTER_DATE,   
							  LAST_MODIFY_BY,   
							  LAST_MODIFY_DATE,   
							  SPI_CHECK_YN,   
							  MARKING_CHECK_YN,   
							  AOI_CHECK_YN,   
							  REFLOW_CHECK_YN,   
							  FUNCTION_CHECK_YN,   
							  ICT_CHECK_YN,   
							  POWER_CHECK_YN,   
							  CARRIER_BARCODE_YN,   
							  SORDER_CREAM_CHECK_YN,   
							  NG_PROCESS,   
							  SERIAL_ARRAY_LENGTH,   
							  CARRIER_BARCODE_POSITION,   
							  REVISION,   
							  ITEM_CODE,   
							  MAGAZINE_PRINT_X,   
							  MAGAZINE_PRINT_Y,   
							  MAGAZINE_NO_LENGTH,   
							  USE_CALENDAR,   
							  CUSTOMER_MODEL_NAME,   
							  EC_NO,   
							  HW_VERSION,   
							  SW_VERSION,   
							  SW_FILENAME,   
							  MODEL_SUFFIX,   
							  INSPECT_CHANNEL1,   
							  LOWER_CONTROL_VALUE,   
							  INSPECT_CHANNEL2,   
							  INSPECT_CHANNEL3,   
							  PID_PRINT_X,   
							  PID_PRINT_Y,   
							  SOLDER_TYPE,   
							  TOP_ITEM_CODE,   
							  BOTTOM_ITEM_CODE,   
							  INSERT_ITEM_CODE,   
							  PCB_ITEM_CODE,   
							  SOLDER_ITEM_CODE,   
							  UNDERFILL_ITEM_CODE,   
							  SMT_MODEL_NAME,   
							  MASTER_MODEL_NAME )  
							  
				  VALUES ( :LVS_MODEL_NAME,   
							  :LVS_MODEL_SPEC,   
						  	 '*' , //MODEL_TYPE,   
							  :LVS_PART_NO,   
							  0 ,//VERSION,   
							  '*' , //SITE_CODE,   
							  1 , //COMPANY_NO,   
							  '*' , //COMPANY_CODE,   
							  :LVL_CARRIER_SIZE,   
							  1 , //PCB_TOTAL_QTY,   
							  'LGE' , //CUSTOMER_CODE,   
							  'LGE' , //CUSTOMER_NAME,   
							  '*' , //MARKING_CONDITION,   
							  'Y' , //MARKING_YN,   
							  '*' , //MODEL_DIVISION,   
							  '*' , //BARCODE_TYPE,   
							  1 , //PACKING_PCS_QTY,   
							  1 , //PACKING_TRAY_BOX_QTY,   
							  0 , //ARRAY_TYPE,   
							  TRUNC(SYSDATE -1) , // DATESET,   
							  TO_DATE('99991231' , 'YYYYMMDD') , //DATEEND,   
							  SYSDATE , //CONFIRM_DATE,   
							  0 , //SERIAL_NO_LENGTH,   
							  0 , //PACKING_BOX_MAX_PSC_QTY,   
							  0 , //PACKING_BOX_MIN_PSC_QTY,   
							  :GVI_ORGANIZATION_ID,   
							  :GVS_USER_ID , //ENTER_BY,   
							  SYSDATE , //ENTER_DATE,   
							  :GVS_USER_ID , //LAST_MODIFY_BY,   
							  SYSDATE , //LAST_MODIFY_DATE,   
							  'N' , //SPI_CHECK_YN,   
							  'N' , //MARKING_CHECK_YN,   
							  'N' , //AOI_CHECK_YN,   
							  'N' , //REFLOW_CHECK_YN,   
							  'N' , //FUNCTION_CHECK_YN,   
							  'N' , //ICT_CHECK_YN,   
							  'N' , //POWER_CHECK_YN,   
							  'N' , //CARRIER_BARCODE_YN,   
							  'N' , //SORDER_CREAM_CHECK_YN,   
							  '*' , //NG_PROCESS,   
							  0 , //SERIAL_ARRAY_LENGTH,   
							  0 , //CARRIER_BARCODE_POSITION,   
							  :LVS_REVISION,   
							  :LVS_SET_ITEM_CODE,   
							  0 , //MAGAZINE_PRINT_X,   
							  0 , //MAGAZINE_PRINT_Y,   
							  0 , //MAGAZINE_NO_LENGTH,   
							  'N' , //USE_CALENDAR,   
							  :LVS_CUSTOMER_MODEL_NAME,   
							  '*' , //EC_NO,   
							  NULL , //HW_VERSION,   
							  NULL , //SW_VERSION,   
							  '*' , //SW_FILENAME,   
							  :LVS_MODEL_SUFFIX,   
							  NULL , //INSPECT_CHANNEL1,   
							  NULL  , //LOWER_CONTROL_VALUE,   
							  NULL , //INSPECT_CHANNEL2,   
							  NULL , //INSPECT_CHANNEL3,   
							  0 , //PID_PRINT_X,   
							  0 , //PID_PRINT_Y,   
							  '*' , //SOLDER_TYPE,   
							  '*' , //TOP_ITEM_CODE,   
							  '*' , //BOTTOM_ITEM_CODE,   
							  '*' , //INSERT_ITEM_CODE,   
							  '*' , //PCB_ITEM_CODE,   
							  '*' , //SOLDER_ITEM_CODE,   
							  '*' , //UNDERFILL_ITEM_CODE,   
							  :LVS_SMT_MODEL_NAME,   
							  :LVS_MASTER_MODEL_NAME )  ;
				
				IF F_SQL_CHECK_WITH_MSG('MODEL INSERT') < 0 THEN
					 RETURN 
				END IF 

	END IF 

//=============================================
//
//=============================================


LVL_COUNT = 0 

   SELECT COUNT(*) 
	  INTO :LVL_COUNT 
	 FROM ID_ENG_BOM_WORKSPACE
    WHERE BOM_WORK_NO         = :LVL_WORK_NO
		AND ITEM_CODE              = :LVS_SET_ITEM_CODE
		AND ORGANIZATION_ID    = :GVI_ORGANIZATION_ID 
		AND NEW_BOM_YN = 'Y'  ;

IF F_SQL_CHECK() < 0 THEN 
	RETURN
END IF

IF LVL_COUNT > 0 THEN 
	
ELSE
	  F_MSGBOX(117)  //F_MSG_ST( 117 ) // $$HEX9$$90c7ccb800ac2000c6c5b5c2c8b2e4b22000$$ENDHEX$$
	  RETURN 
END IF

MSG = F_MSGBOX(9083) //$$HEX3$$e0c2dcad2000$$ENDHEX$$BOM $$HEX8$$44c7200055d615c860d54cae94c62000$$ENDHEX$$?
IF MSG = 1 THEN 
ELSE
	RETURN 
END IF 

//========================================
//
//========================================

LONG LVL_RETURN
LVL_RETURN = SQLCA.BOM_TRANSLATION( DOUBLE(DDLB_WORK_NO.TEXT()) , LVS_SET_ITEM_CODE , GVI_ORGANIZATION_ID  )

IF F_SQL_CHECK() < 0 THEN 
   RETURN
END IF

//=======================================
//
//=======================================

MSG =F_MSGBOX1(9084, STRING(LVL_RETURN) )
IF MSG = 1 THEN 
	COMMIT;
	F_MSG_ST(170)	
//	DW_1.RESET ()
ELSE
	ROLLBACK ;
	return
END IF

	if cbx_mfs_bom.checked = true then 
		lvs_revision = sle_revision.text 
		if lvs_revision = '' or isnull(lvs_revision) then 
			lvs_revision = '0000'
		end if 
		
		lvdb_return = f_gen_mfs_bom( lvs_revision , lvs_set_item_code , f_t_sysdate() , 'Y' )
		if lvdb_return < 0 then 
			//Mess agebox("$$HEX2$$55d678c7$$ENDHEX$$" , "$$HEX3$$1cc870c82000$$ENDHEX$$BOM $$HEX5$$ddc031c1200024c658b9$$ENDHEX$$")
			f_msg( "$$HEX3$$1cc870c82000$$ENDHEX$$BOM $$HEX5$$ddc031c1200024c658b9$$ENDHEX$$", 'P') 
			RETURN -1
		end if 
		
		if f_sql_check() < 0 then 
			return -1
		end if 
		
	end if 

ddlb_work_no.redraw( )
dw_2.RETRIEVE(   sle_set_item_code.text ,LVS_REVISION , GVI_ORGANIZATION_ID)
end event

type cb_2 from so_commandbutton within w_des_bom_excel_form_lg_popup
integer x = 4142
integer y = 284
integer width = 489
integer height = 128
integer taborder = 50
boolean bringtotop = true
string text = "Excel Paste"
end type

event clicked;call super::clicked;if mle_confirm_comment.text = '' then 
	f_msgbox1(126 ,st_request_comment.text )
	return 
end if 

if sle_revision.text = '' or isnull(sle_revision.text) then 
		f_msgbox1(126 ,st_revision.text )	
		return 
end if 


if rb_default_form.checked = true then 
	wf_save_lg() 
else
	wf_save_vietnam() 	
	
end if 
//=================================
if f_msgbox1(1161 , cb_confirm.text )  = 1 then 
	
	cb_confirm.triggerevent( clicked!) 
	
end if 
	
	
end event

type pb_1 from so_commandbutton within w_des_bom_excel_form_lg_popup
integer x = 59
integer y = 620
integer width = 489
integer height = 128
integer taborder = 40
boolean bringtotop = true
string text = "Save Form"
end type

event clicked;call super::clicked;string     docname, named 
Long iret

SETPOINTER(HOURGLASS!)		
iret = GetFileSaveName("Select Excel File ("+dw_1.classname()+")" , docname, named, "xls", "Excel Files (*.xls),*.xls")		

IF iret =1 THEN 
	
	     dw_1.insertrow( 0)
		uf_save_dw_as_excel( dw_1  , docname )
ELSE
	RETURN
END IF
		

end event

type cbx_assy_yn from checkbox within w_des_bom_excel_form_lg_popup
integer x = 69
integer y = 264
integer width = 439
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Assy Exists YN"
end type

type cbx_bom_create from checkbox within w_des_bom_excel_form_lg_popup
integer x = 69
integer y = 440
integer width = 439
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "BOM Create"
boolean checked = true
end type

type mle_confirm_comment from so_multilineedit within w_des_bom_excel_form_lg_popup
integer x = 594
integer y = 512
integer width = 3461
integer height = 272
integer taborder = 40
boolean bringtotop = true
string text = ""
end type

type st_request_comment from so_statictext within w_des_bom_excel_form_lg_popup
integer x = 594
integer y = 428
integer width = 485
boolean bringtotop = true
string text = "Request Comment"
end type

type cbx_mfs_bom from checkbox within w_des_bom_excel_form_lg_popup
integer x = 69
integer y = 536
integer width = 439
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "MFS BOM Create"
boolean checked = true
end type

type sle_revision from so_singlelineedit within w_des_bom_excel_form_lg_popup
integer x = 613
integer y = 312
integer width = 274
integer height = 84
integer taborder = 50
boolean bringtotop = true
string text = "1"
end type

type st_revision from so_statictext within w_des_bom_excel_form_lg_popup
integer x = 613
integer y = 240
integer width = 274
integer height = 64
boolean bringtotop = true
long backcolor = 25430527
string text = "Revision"
end type

type st_17 from so_statictext within w_des_bom_excel_form_lg_popup
integer x = 891
integer y = 240
integer width = 549
integer height = 64
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Bom Work No"
end type

type ddlb_work_no from uo_bom_workno within w_des_bom_excel_form_lg_popup
integer x = 891
integer y = 312
integer width = 549
integer height = 1348
integer taborder = 30
boolean bringtotop = true
boolean allowedit = true
end type

event selectionchanged;call super::selectionchanged;IF THIS.TEXT = '%' THEN 
	RETURN
END IF

SELECT DISTINCT ITEM_CODE
    INTO :LVS_SET_ITEM_CODE
  FROM ID_ENG_BOM_WORKSPACE
 WHERE BOM_WORK_NO     = :THIS.TEXT
   AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
	
IF F_SQL_CHECK() < 0 THEN 
   RETURN 	
END IF

IF LVS_SET_ITEM_CODE ='' OR ISNULL(LVS_SET_ITEM_CODE) THEN 
	RETURN
END IF

sle_set_item_code.text =  LVS_SET_ITEM_CODE ;
end event

type st_set_item_code from so_statictext within w_des_bom_excel_form_lg_popup
integer x = 1445
integer y = 240
integer width = 466
integer height = 64
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Set Item Code"
end type

type sle_set_item_code from so_singlelineedit within w_des_bom_excel_form_lg_popup
integer x = 1445
integer y = 312
integer width = 466
integer height = 84
integer taborder = 60
boolean bringtotop = true
end type

event modified;call super::modified;sle_master_model_name.text = this.text
sle_smt_model_name.text = this.text
sle_model_name.text = this.text
end event

type sle_model_name from so_singlelineedit within w_des_bom_excel_form_lg_popup
integer x = 1915
integer y = 312
integer width = 558
integer height = 84
integer taborder = 70
boolean bringtotop = true
end type

event modified;call super::modified;sle_master_model_name.text = this.text
sle_smt_model_name.text = this.text

end event

type st_model_name from so_statictext within w_des_bom_excel_form_lg_popup
integer x = 1915
integer y = 240
integer width = 558
integer height = 64
boolean bringtotop = true
integer weight = 700
long backcolor = 25430527
boolean enabled = false
string text = "Model Name"
end type

type sle_smt_model_name from so_singlelineedit within w_des_bom_excel_form_lg_popup
integer x = 2478
integer y = 312
integer width = 558
integer height = 84
integer taborder = 80
boolean bringtotop = true
end type

type st_2 from so_statictext within w_des_bom_excel_form_lg_popup
integer x = 2478
integer y = 240
integer width = 558
integer height = 64
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "SMT Model Name"
end type

type sle_master_model_name from so_singlelineedit within w_des_bom_excel_form_lg_popup
integer x = 3040
integer y = 312
integer width = 558
integer height = 84
integer taborder = 90
boolean bringtotop = true
end type

type st_3 from so_statictext within w_des_bom_excel_form_lg_popup
integer x = 3040
integer y = 240
integer width = 558
integer height = 64
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Master Model Name"
end type

type em_caarier_size from so_editmask within w_des_bom_excel_form_lg_popup
integer x = 3607
integer y = 312
integer width = 261
integer taborder = 100
boolean bringtotop = true
string text = "2"
alignment alignment = center!
string mask = "##0"
boolean spin = true
double increment = 1
string minmax = "1~~20"
end type

type st_4 from so_statictext within w_des_bom_excel_form_lg_popup
integer x = 3607
integer y = 240
integer width = 261
integer height = 64
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "C.Size"
end type

type cbx_use_default_model from checkbox within w_des_bom_excel_form_lg_popup
integer x = 69
integer y = 348
integer width = 466
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Use Default Model"
boolean checked = true
end type

type rb_default_form from so_radiobutton within w_des_bom_excel_form_lg_popup
integer x = 91
integer y = 936
boolean bringtotop = true
string text = "LG(LCD)"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.dataobject = 'd_des_bom_import_excel_lcd'
dw_1.settransobject(sqlca)
end event

type rb_dongdu_from from so_radiobutton within w_des_bom_excel_form_lg_popup
integer x = 631
integer y = 936
boolean bringtotop = true
string text = "LG (Vietnam)"
end type

event clicked;call super::clicked;dw_1.dataobject = 'd_des_bom_import_excel_lcd2'
dw_1.settransobject(sqlca)
end event

type gb_1 from so_groupbox within w_des_bom_excel_form_lg_popup
integer x = 4073
integer y = 188
integer width = 631
integer height = 612
integer taborder = 50
long textcolor = 16711680
string text = "Process"
end type

type gb_2 from so_groupbox within w_des_bom_excel_form_lg_popup
integer x = 590
integer y = 172
integer width = 3314
integer height = 240
integer taborder = 60
long textcolor = 16711680
string text = "Revision"
end type

type gb_3 from so_groupbox within w_des_bom_excel_form_lg_popup
integer x = 5
integer y = 168
integer width = 571
integer height = 620
integer taborder = 60
long textcolor = 16711680
string text = "Option"
end type

type gb_4 from so_groupbox within w_des_bom_excel_form_lg_popup
integer x = 23
integer y = 888
integer width = 1147
integer height = 160
integer taborder = 50
end type

