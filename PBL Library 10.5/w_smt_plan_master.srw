HA$PBExportHeader$w_smt_plan_master.srw
$PBExportComments$$$HEX4$$ddc0b0c0c4ac8dd6$$ENDHEX$$
forward
global type w_smt_plan_master from w_main_root
end type
type st_item_code from so_statictext within w_smt_plan_master
end type
type st_3 from so_statictext within w_smt_plan_master
end type
type rb_plan_master from so_radiobutton within w_smt_plan_master
end type
type cb_6 from so_commandbutton within w_smt_plan_master
end type
type cb_1 from so_commandbutton within w_smt_plan_master
end type
type rb_all from so_radiobutton within w_smt_plan_master
end type
type rb_top from so_radiobutton within w_smt_plan_master
end type
type rb_bottom from so_radiobutton within w_smt_plan_master
end type
type cb_2 from so_commandbutton within w_smt_plan_master
end type
type rb_feeder_layout from so_radiobutton within w_smt_plan_master
end type
type cb_3 from so_commandbutton within w_smt_plan_master
end type
type cb_print_issue from so_commandbutton within w_smt_plan_master
end type
type rb_1 from so_radiobutton within w_smt_plan_master
end type
type cbx_print_issue from so_checkbox within w_smt_plan_master
end type
type rb_2 from so_radiobutton within w_smt_plan_master
end type
type ddlb_line_code from uo_line_code within w_smt_plan_master
end type
type dw_6 from datawindow within w_smt_plan_master
end type
type cb_4 from so_commandbutton within w_smt_plan_master
end type
type cbx_auo_retrieve from so_checkbox within w_smt_plan_master
end type
type cb_out from so_commandbutton within w_smt_plan_master
end type
type cb_5 from so_commandbutton within w_smt_plan_master
end type
type st_4 from so_statictext within w_smt_plan_master
end type
type sle_revision from so_singlelineedit within w_smt_plan_master
end type
type ddlb_model_name from uo_smt_layout_model_name_ddlb within w_smt_plan_master
end type
type rb_product from so_radiobutton within w_smt_plan_master
end type
type rb_sample from so_radiobutton within w_smt_plan_master
end type
type gb_2 from so_groupbox within w_smt_plan_master
end type
type gb_1 from so_groupbox within w_smt_plan_master
end type
type gb_3 from so_groupbox within w_smt_plan_master
end type
end forward

global type w_smt_plan_master from w_main_root
integer width = 5824
integer height = 3180
string title = "SMT Plan Master"
windowstate windowstate = maximized!
st_item_code st_item_code
st_3 st_3
rb_plan_master rb_plan_master
cb_6 cb_6
cb_1 cb_1
rb_all rb_all
rb_top rb_top
rb_bottom rb_bottom
cb_2 cb_2
rb_feeder_layout rb_feeder_layout
cb_3 cb_3
cb_print_issue cb_print_issue
rb_1 rb_1
cbx_print_issue cbx_print_issue
rb_2 rb_2
ddlb_line_code ddlb_line_code
dw_6 dw_6
cb_4 cb_4
cbx_auo_retrieve cbx_auo_retrieve
cb_out cb_out
cb_5 cb_5
st_4 st_4
sle_revision sle_revision
ddlb_model_name ddlb_model_name
rb_product rb_product
rb_sample rb_sample
gb_2 gb_2
gb_1 gb_1
gb_3 gb_3
end type
global w_smt_plan_master w_smt_plan_master

forward prototypes
public subroutine wf_model_image ()
end prototypes

public subroutine wf_model_image ();/****************************************************************************************
*                                   $$HEX3$$30aef8bc2000$$ENDHEX$$script start
****************************************************************************************/
Blob			item_pic
integer 		li_fileNum,		&
				loop_i
string			ls_model_name
long			ll_length,			&
				ll_length_old,	&
				ll_item__loop
				

ll_item__loop	=	dw_2.rowcount()

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

	
		ls_model_name	=	dw_2.object.model_name[dw_2.getrow()]
		
		SELECTBLOB 	MODEL_IMAGE
		INTO				:item_pic 
		FROM				IB_SMT_BOM_IMAGE
		WHERE			model_name 	= 	:ls_model_name 
		AND organization_id = :gvi_organization_id
		AND ROWNUM = 1 ;
			
		
		if sqlca.sqlcode = 100 or isnull( item_pic ) then
			return
		else
			ll_length = len(item_pic) 
		end if
			
		if	fileexists(gvs_default_directory+'\'+ls_model_name+'.jpg') then
			ll_length_old = FileLength(gvs_default_directory+'\'+ls_model_name+'.jpg')
			// $$HEX15$$6cd030ae00ac200019ac3cc774ba2000f8ade5b0200028d3a4c25cd5e4b2$$ENDHEX$$.
			if	ll_length_old = ll_length then
				return		
			else
				FileDelete(gvs_default_directory+'\'+ls_model_name+'.jpg')
				li_filenum = fileopen( gvs_default_directory+'\'+ls_model_name+'.jpg' , streamMode!, write!, lockwrite!)
				FileWriteEX(li_filenum, item_pic , ll_length )			
				fileclose( li_filenum )
			end if
		else
			li_filenum = fileopen( gvs_default_directory+'\'+ls_model_name+'.jpg' , streamMode!, write!, lockwrite!)
			FileWriteEX(li_filenum, item_pic , ll_length )			
			fileclose( li_filenum )
		end if	
		
f_msg_mdi_help('Ending Set Picture ...')






end subroutine

on w_smt_plan_master.create
int iCurrent
call super::create
this.st_item_code=create st_item_code
this.st_3=create st_3
this.rb_plan_master=create rb_plan_master
this.cb_6=create cb_6
this.cb_1=create cb_1
this.rb_all=create rb_all
this.rb_top=create rb_top
this.rb_bottom=create rb_bottom
this.cb_2=create cb_2
this.rb_feeder_layout=create rb_feeder_layout
this.cb_3=create cb_3
this.cb_print_issue=create cb_print_issue
this.rb_1=create rb_1
this.cbx_print_issue=create cbx_print_issue
this.rb_2=create rb_2
this.ddlb_line_code=create ddlb_line_code
this.dw_6=create dw_6
this.cb_4=create cb_4
this.cbx_auo_retrieve=create cbx_auo_retrieve
this.cb_out=create cb_out
this.cb_5=create cb_5
this.st_4=create st_4
this.sle_revision=create sle_revision
this.ddlb_model_name=create ddlb_model_name
this.rb_product=create rb_product
this.rb_sample=create rb_sample
this.gb_2=create gb_2
this.gb_1=create gb_1
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_item_code
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.rb_plan_master
this.Control[iCurrent+4]=this.cb_6
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.rb_all
this.Control[iCurrent+7]=this.rb_top
this.Control[iCurrent+8]=this.rb_bottom
this.Control[iCurrent+9]=this.cb_2
this.Control[iCurrent+10]=this.rb_feeder_layout
this.Control[iCurrent+11]=this.cb_3
this.Control[iCurrent+12]=this.cb_print_issue
this.Control[iCurrent+13]=this.rb_1
this.Control[iCurrent+14]=this.cbx_print_issue
this.Control[iCurrent+15]=this.rb_2
this.Control[iCurrent+16]=this.ddlb_line_code
this.Control[iCurrent+17]=this.dw_6
this.Control[iCurrent+18]=this.cb_4
this.Control[iCurrent+19]=this.cbx_auo_retrieve
this.Control[iCurrent+20]=this.cb_out
this.Control[iCurrent+21]=this.cb_5
this.Control[iCurrent+22]=this.st_4
this.Control[iCurrent+23]=this.sle_revision
this.Control[iCurrent+24]=this.ddlb_model_name
this.Control[iCurrent+25]=this.rb_product
this.Control[iCurrent+26]=this.rb_sample
this.Control[iCurrent+27]=this.gb_2
this.Control[iCurrent+28]=this.gb_1
this.Control[iCurrent+29]=this.gb_3
end on

on w_smt_plan_master.destroy
call super::destroy
destroy(this.st_item_code)
destroy(this.st_3)
destroy(this.rb_plan_master)
destroy(this.cb_6)
destroy(this.cb_1)
destroy(this.rb_all)
destroy(this.rb_top)
destroy(this.rb_bottom)
destroy(this.cb_2)
destroy(this.rb_feeder_layout)
destroy(this.cb_3)
destroy(this.cb_print_issue)
destroy(this.rb_1)
destroy(this.cbx_print_issue)
destroy(this.rb_2)
destroy(this.ddlb_line_code)
destroy(this.dw_6)
destroy(this.cb_4)
destroy(this.cbx_auo_retrieve)
destroy(this.cb_out)
destroy(this.cb_5)
destroy(this.st_4)
destroy(this.sle_revision)
destroy(this.ddlb_model_name)
destroy(this.rb_product)
destroy(this.rb_sample)
destroy(this.gb_2)
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
Ivs_resize_type    = 'MASTER_DETAIL_12T_3B'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
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

F_MENU_CONTROL('DATA_CONTROL' , TRUE)  // All Data Control

/****************************************
* 
****************************************/

end event

event ue_data_control;call super::ue_data_control;Long ROW
Double lvdb_seq
string lvs_top_bot
CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		
				dw_1.reset()
				dw_2.reset()
				dw_3.reset()
				
				if rb_plan_master.checked = true then
					
					dw_1.retrieve(ddlb_line_code.getcode()+'%' ,  Gvi_organization_id  )	

				else
	
			    end if

	CASE 'INSERT'		//$$HEX5$$c4ac8dd694cd00ac2000$$ENDHEX$$
	
				
	CASE 'APPEND' 

	CASE 'DELETE' 
		    
		  	if dw_3.getrow() < 1 then return 
			  
			msg =f_msgbox(1003)
			if msg = 1 then
				gvl_row_deleted = dw_3.getrow()			
				dw_3.deleterow(gvl_row_deleted)		
				dw_3.setfocus()
				row = dw_3.getrow()
				dw_3.scrolltorow(row)
				dw_3.setcolumn(1)
			end if		 

	CASE 'UPDATE'
	
			   if dw_3.update() < 0 then 
					rollback;
				else
					commit ;
					
				end if 

	CASE ELSE
END CHOOSE
end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

dw_6.settransobject( sqlca)

//====================================
// $$HEX22$$acb9ecd3b8d2200000adacb9d0c52000f1b45db818b4b4c5200088c73cc774ba200014bcd4af00c9e4b22000$$ENDHEX$$
//====================================

STRING ls_syntax

ls_syntax	=	f_get_dataobject('REPORT', upper(THIS.CLASSNAME()) ,  string( dw_5.dataobject )	)
if	ls_syntax = '' or isnull(ls_syntax) then
	f_msg_mdi_help("Report Not Changed")
else
	dw_5.create(ls_syntax)
	dw_5.settransobject(sqlca)
	f_set_column_dddw(dw_5)
	f_dual_lang_change_dwtext(dw_5)
	f_msg_mdi_help("Report Changed")
end if	

f_retrieve()


end event

type dw_5 from w_main_root`dw_5 within w_smt_plan_master
integer x = 9
integer y = 412
integer width = 2208
integer height = 716
boolean titlebar = true
string title = "Feeder Layout(Plan)"
string dataobject = "d_smt_plandata_list_rpt"
end type

event dw_5::printend;call super::printend;if cbx_print_issue.checked = true then 
	cb_print_issue.triggerevent( clicked! )
end if 
end event

type dw_4 from w_main_root`dw_4 within w_smt_plan_master
integer x = 9
integer y = 412
integer width = 2208
integer height = 716
boolean titlebar = true
string dataobject = "d_smt_workflow_rpt"
end type

type dw_3 from w_main_root`dw_3 within w_smt_plan_master
integer y = 1140
integer width = 4448
integer height = 1496
boolean titlebar = true
string title = "Feeder Layout"
string dataobject = "d_smt_plandata_simple_4_plan"
end type

type dw_2 from w_main_root`dw_2 within w_smt_plan_master
integer x = 2217
integer y = 412
integer width = 2231
integer height = 716
boolean titlebar = true
string title = "Summary"
string dataobject = "d_smt_plandata_lst"
end type

event dw_2::rowfocuschanged;call super::rowfocuschanged;if currentrow = 0 then return 
string lvs_top_bot, lvs_feeder_shaft


lvs_feeder_shaft = trim(this.object.feeder_shaft[currentrow])
if lvs_feeder_shaft = ''  or isnull(lvs_feeder_shaft) then
   lvs_feeder_shaft = '%'	
end if
dw_3.retrieve( this.object.line_code[currentrow] , '%' ,  this.object.model_name[currentrow] ,    this.object.pcb_item[currentrow]+'%' ,    lvs_feeder_shaft , gvi_organization_id )

if rb_top.checked = true then 
	lvs_top_bot = 'T'
elseif rb_bottom.checked = true then 
	lvs_top_bot = 'B'
else
	lvs_top_bot = '%' 
end if 
if cbx_auo_retrieve.checked = true then 
	
WF_MODEL_IMAGE()
DW_4.RETRIEVE(  dw_2.object.model_name[currentrow] ,  dw_2.object.line_code[currentrow]+'%' ,   lvs_top_bot+'%' ,  GVI_ORGANIZATION_ID )	
DW_5.RETRIEVE(  dw_2.object.model_name[currentrow] ,  dw_2.object.line_code[currentrow]+'%' ,   lvs_top_bot+'%' ,  GVI_ORGANIZATION_ID , SLE_REVISION.TEXT+'%'  )	
end if 
end event

event dw_2::buttonclicked;call super::buttonclicked;if row < 1 then return 
openwithparm (w_smt_bom_comments_window , string( this.object.model_name[row]) )
end event

type dw_1 from w_main_root`dw_1 within w_smt_plan_master
event ue_lbuttondown pbm_lbuttondown
integer x = 9
integer y = 412
integer width = 2208
integer height = 716
boolean titlebar = true
string title = "Line"
string dataobject = "d_ib_line_master_distinct_4_plan_lst"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 

dw_2.reset()
dw_3.reset()
dw_2.retrieve( this.object.line_code[currentrow],  ddlb_model_name.getcode( ) )
end event

event dw_1::doubleclicked;call super::doubleclicked;if row < 1 then return 
dw_2.reset()
dw_3.reset()
dw_2.retrieve( this.object.line_code[row], ddlb_model_name.getcode( ) ,  sle_revision.text+'%' , '%'  )
end event

type uo_tabpages from w_main_root`uo_tabpages within w_smt_plan_master
end type

type st_item_code from so_statictext within w_smt_plan_master
integer x = 1221
integer y = 128
integer width = 649
integer height = 56
boolean bringtotop = true
string text = "Feeder Layout Name"
end type

type st_3 from so_statictext within w_smt_plan_master
integer x = 608
integer y = 128
integer width = 594
integer height = 56
boolean bringtotop = true
string text = "Line Code"
end type

type rb_plan_master from so_radiobutton within w_smt_plan_master
integer x = 27
integer y = 80
integer width = 466
boolean bringtotop = true
string text = "Plan Master"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
dw_2.bringtotop = true
dw_3.bringtotop = true
selected_data_window = dw_1
end event

type cb_6 from so_commandbutton within w_smt_plan_master
integer x = 2615
integer y = 244
integer width = 617
integer height = 120
integer taborder = 70
boolean bringtotop = true
string text = "Delete Feeder Layout"
end type

event clicked;call super::clicked;string lvs_model_name , lvs_line_code , lvs_machine , lvs_topbot , lvs_feeder_shaft

if dw_2.getrow() < 1 then return

	lvs_line_code     =  ddlb_line_code.getcode()
	lvs_model_name = ddlb_model_name.getcode() 
	lvs_feeder_shaft = '%'
	
	
	if lvs_line_code = '%' or isnull(lvs_line_code) or lvs_line_code = '' then 
		
		f_msg("$$HEX22$$3cd554b308b874c744c5c3c644c72000adc01cc860d520007cb778c744c7200020c1ddd0200058d538c194c6$$ENDHEX$$" , "P")
		return 
	end if 
//=========================================
//
//=========================================
   if rb_all.checked = true then 
		lvs_topbot = '%'
	elseif rb_top.checked = true then 
		lvs_topbot ='T'
		
	elseif  rb_bottom.checked = true then 
		lvs_topbot= 'B'
	end if 

msg = MessageBox ( 'Warning', f_msg( 'Are you sure delete Line=','S') +lvs_line_code +" Model="+lvs_model_name+" Top.Bot"+lvs_topbot , Information! ,YesNo!  )
if msg = 1 then 
	
	
	 INSERT INTO ib_product_plandata_BACKUP
      SELECT *
        FROM ib_product_plandata
       WHERE     line_code = :lvs_line_code
	    and model_name = :lvs_model_name
	    and organization_id = :gvi_organization_id
		and pcb_item like :lvs_topbot 
         AND active_yn = 'N' ;

	 if f_sql_check() < 0 then 
		return 
	end if 	
//===========================================
//
//===========================================
	delete from IB_PRODUCT_PLANDATA
	where  line_code = :lvs_line_code
	    and model_name = :lvs_model_name
	    and organization_id = :gvi_organization_id
		and pcb_item like :lvs_topbot
		and nvl(feeder_shaft , '*') like NVL(:lvs_feeder_shaft , '*')
         and  active_yn = 'N' ;
	 
	 if f_sql_check() < 0 then 
		return 
	end if 
	
	commit ;
	f_msgbox(170)
	
end if 
end event

type cb_1 from so_commandbutton within w_smt_plan_master
integer x = 2615
integer y = 124
integer width = 617
integer height = 120
integer taborder = 80
boolean bringtotop = true
string text = "Upload Feeder Layout"
end type

event clicked;call super::clicked;string lvs_model_name , lvs_line_code  , lvs_topbot , lvs_feeder_shaft
int LVI_BOM_EXISTS, lvi_row_count

lvs_line_code      = ddlb_line_code.getcode()
lvs_model_name = ddlb_model_name.getcode()
lvs_feeder_shaft = '%'

if lvs_feeder_shaft = '' or isnull(lvs_feeder_shaft) then 
	lvs_feeder_shaft = '%' 
end if 

if rb_top.checked = true then 
   lvs_topbot  = 'T'
elseif rb_bottom.checked = true then 
    lvs_topbot  = 'B'
else
	 //messa gebox("Notify" , "TOP / BOTTOM $$HEX9$$44c7200020c1ddd0200058d538c194c62000$$ENDHEX$$")
	 f_msg( "TOP / BOTTOM $$HEX9$$44c7200020c1ddd0200058d538c194c62000$$ENDHEX$$", 'P') 
	 return 
end if 
//=========================================
//
//=========================================
//LVI_BOM_EXISTS = 0 
//SELECT COUNT(*) INTO :LVI_BOM_EXISTS
//    FROM ID_ENG_BOM_SMT B
//	   WHERE  B.LINE_CODE  LIKE :lvs_line_code
//		    AND B.PARENT_ITEM_CODE = :LVS_MODEL_NAME 
//		    AND B.PCB_ITEM = :lvs_topbot
//		    AND NVL(B.FEEDER_SHAFT , '*') LIKE :LVS_FEEDER_shaft
//	     	AND ( B.LINE_CODE ,  B.PARENT_ITEM_CODE , B.CHILD_ITEM_CODE , B.LOCATION_CODE , B.PCB_ITEM  , NVL(B.FEEDER_SHAFT,'*')  ) 	
//			  NOT IN (  SELECT A.LINE_CODE ,  A.MODEL_NAME , A.ITEM_CODE , A.LOCATION_CODE , A.PCB_ITEM , NVL( A.FEEDER_SHAFT , '*') 
//			                  FROM IB_PRODUCT_PLANDATA A 
//							 WHERE A.LINE_CODE  = :lvs_line_code
//		                           AND A.MODEL_NAME = :LVS_MODEL_NAME 	
//								AND A.PCB_ITEM = :lvs_topbot
//								AND NVL( FEEDER_SHAFT , '*') LIKE :LVS_FEEDER_SHAFT
//					  	) ;
//
//	if f_sql_check() < 0 then 
//		return 
//	end if 	
	
//	if LVI_BOM_EXISTS = 0 then 
//		
//		f_msgbox(120) 
//		return 
//		
//	end if 

//=========================================
msg = MessageBox ( 'Warning',f_msg('Create Feeder Layout Line=','S') +lvs_line_code + ' Model= '+lvs_model_name , Information! ,YesNo!  )
if msg = 1 then 

  STRING LVS_ACTIVE_YN

  LVS_ACTIVE_YN = 'N'
  lvi_row_count    = 0
 
   SELECT NVL(MAX(NVL(ACTIVE_YN ,'N')),'N'), count(*)  INTO :LVS_ACTIVE_YN, :lvi_row_count
   FROM IB_PRODUCT_PLANDATA
   WHERE LINE_CODE  = :lvs_line_code
       AND MODEL_NAME = :LVS_MODEL_NAME 
	  AND PCB_ITEM = :lvs_topbot
//	  AND NVL(FEEDER_SHAFT, '*')  LIKE  :LVS_FEEDER_SHAFT 
       ;
	  
	if f_sql_check() < 0 then 
		return 
	end if 	
	
	
  IF ( LVS_ACTIVE_YN = 'Y' ) THEN
	    MessageBox ( 'Warning', '$$HEX20$$f1b45db8200060d52000a8ba78b374c720005cd631c154d6200018b4b4c5200088c7b5c2c8b2e4b2$$ENDHEX$$, $$HEX10$$8cd618c2c4d6200030bcecd358d538c194c62000$$ENDHEX$$! ' , StopSign! ,OK!  )
		return
  END IF
  
  IF ( lvi_row_count > 0 ) THEN
	   MessageBox ( 'Warning', '$$HEX14$$3cd554b308b874c744c5c3c674c7200074c8acc7200069d5c8b2e4b2$$ENDHEX$$, $$HEX10$$adc01cc8c4d6200030bcecd358d538c194c62000$$ENDHEX$$!', StopSign! ,OK!  )
	   return
  END IF
  	

  INSERT INTO IB_PRODUCT_PLANDATA  
         ( PLAN_DATE,   
           MODEL_NAME,   
           ITEM_CODE,   
           CHIPNAME,   
           CHECK_YN,   
           SELECTED_DATE,   
           MACHINE,   
           LINE_CODE,   
           CHECK_STATUS,   
           ENTER_DATE,   
           ENTER_BY,   
           LAST_MODIFY_DATE,   
           LAST_MODIFY_BY,   
           ORGANIZATION_ID,   
           PLAN_DATE_SEQUENCE,   
           ITEM_BARCODE,   
           LOCATION_CODE,   
           TABLE_ID,
		  PCB_ITEM,
		  ACTIVE_YN ,
		  REPLACE_YN,
		  ITEM_UNIT_QTY,
		  FEEDER_SHAFT ,
		  REVISION ,
		  LOCATION_INFO,
		  FULL_CHECK_YN,
		  SMT_MODEL_NAME )  

    SELECT  SYSDATE PLAN_DATE,   
           PARENT_ITEM_CODE LOT_NAME,   
           CHILD_ITEM_CODE    PARTNAME,   
           '' CHIPNAME,   
           'N' CHECK_YN,   
           NULL SELECTED_DATE,   
           MACHINE,   
           LINE_CODE,   
           'W'  CHECK_STATUS,   
           SYSDATE ,   
           :GVS_USER_ID,  
          SYSDATE ,   
           :GVS_USER_ID,   
           ORGANIZATION_ID,   
           1 PLAN_DATE_SEQUENCE,    
           NULL ITEM_BARCODE, 
           LOCATION_CODE,   
           TABLE_ID,
		  PCB_ITEM ,
		  NVL(:LVS_ACTIVE_YN ,'N') , 
		  'N' ,
		  ITEM_UNIT_QTY ,
		  nvl(FEEDER_SHAFT , '*') ,
		  REVISION ,
		  LOCATION_INFO ,
		  'N' ,
		  SMT_MODEL_NAME
        FROM ID_ENG_BOM_SMT B
	   WHERE  B.LINE_CODE  LIKE :lvs_line_code
		    AND B.PARENT_ITEM_CODE = :LVS_MODEL_NAME 
		    AND B.PCB_ITEM = :lvs_topbot
		    AND NVL(B.FEEDER_SHAFT , '*') LIKE :LVS_FEEDER_shaft
	     	AND ( B.LINE_CODE ,  B.PARENT_ITEM_CODE , B.CHILD_ITEM_CODE , B.LOCATION_CODE , B.PCB_ITEM  , NVL(B.FEEDER_SHAFT,'*')  ) 	
			  NOT IN (  SELECT A.LINE_CODE ,  A.MODEL_NAME , A.ITEM_CODE , A.LOCATION_CODE , A.PCB_ITEM , NVL( A.FEEDER_SHAFT , '*') 
			                  FROM IB_PRODUCT_PLANDATA A 
							 WHERE A.LINE_CODE  = :lvs_line_code
		                           AND A.MODEL_NAME = :LVS_MODEL_NAME 	
								AND A.PCB_ITEM = :lvs_topbot
							//	AND NVL( FEEDER_SHAFT , '*') LIKE :LVS_FEEDER_SHAFT
					  	) ;
	
	if f_sql_check() < 0 then 
		return 
	end if 
	
//	IF sqlca.sqlnrows > 0 THEN
//		messagebox('test',  ' $$HEX8$$98ccacb920001cb4200074ac18c22000$$ENDHEX$$: ' + string(sqlca.sqlnrows) )
//	ELSE
//		messagebox( 'test', ' $$HEX13$$98ccacb920001cb42000b4b0a9c6c6c5b5c2c8b2e4b220002000$$ENDHEX$$: ' + string(sqlca.sqlnrows) )
//	END IF;	
				
	
//================================================================
//
//=================================================================

  INSERT INTO IB_PRODUCT_PLANDATA  
         ( PLAN_DATE,   
           MODEL_NAME,   
           ITEM_CODE,   
           CHIPNAME,   
           CHECK_YN,   
           SELECTED_DATE,   
           MACHINE,   
           LINE_CODE,   
           CHECK_STATUS,   
           ENTER_DATE,   
           ENTER_BY,   
           LAST_MODIFY_DATE,   
           LAST_MODIFY_BY,   
           ORGANIZATION_ID,   
           PLAN_DATE_SEQUENCE,   
           ITEM_BARCODE,   
        
           LOCATION_CODE,   
           TABLE_ID,
		  PCB_ITEM ,
		  ACTIVE_YN,
		  REPLACE_YN,
		  ITEM_UNIT_QTY,
		   FEEDER_SHAFT ,
		  REVISION ,
		  LOCATION_INFO,
		  FULL_CHECK_YN,
		  SMT_MODEL_NAME)  

    SELECT  TO_CHAR(SYSDATE, 'YYYYMMDD')  PLAN_DATE,   
           PARENT_ITEM_CODE LOT_NAME,   
           REPLACE_ITEM_CODE    PARTNAME,   
           '' CHIPNAME,   
           'N' CHECK_YN,   
           NULL SELECTED_DATE,   
           MACHINE,   
           LINE_CODE,   
           'W'  CHECK_STATUS,   
           SYSDATE ,   
           :GVS_USER_ID,   
           SYSDATE ,   
           :GVS_USER_ID,  
           ORGANIZATION_ID,   
           1 PLAN_DATE_SEQUENCE,    
           NULL ITEM_BARCODE, 
           LOCATION_CODE,   
           TABLE_ID ,
		  PCB_ITEM ,
		  NVL(:LVS_ACTIVE_YN,'N')  ,
		  'Y' ,
		  ITEM_UNIT_QTY,
		  nvl(FEEDER_SHAFT ,'*') ,
		  REVISION ,
		  LOCATION_INFO ,
		  'N',
		  SMT_MODEL_NAME 
        FROM ID_ENG_BOM_SMT_REPLACE B
	   WHERE  B.LINE_CODE  LIKE :lvs_line_code
		    AND B.PARENT_ITEM_CODE = :LVS_MODEL_NAME
		    AND B.PCB_ITEM = :lvs_topbot
		    	AND ( B.LINE_CODE ,B.PARENT_ITEM_CODE , B.REPLACE_ITEM_CODE , B.LOCATION_CODE , B.PCB_ITEM ,  NVL(B.FEEDER_SHAFT,'*')  ) 	
			  NOT IN (  SELECT A.LINE_CODE ,  A.MODEL_NAME , A.ITEM_CODE , A.LOCATION_CODE  , A.PCB_ITEM ,  NVL(A.FEEDER_SHAFT,'*') 
			                  FROM IB_PRODUCT_PLANDATA A 
							 WHERE A.LINE_CODE  = :lvs_line_code
		                            AND A.MODEL_NAME = :LVS_MODEL_NAME 	
								 AND A.PCB_ITEM = :lvs_topbot	
						//		 AND NVL(A.FEEDER_SHAFT,'*') LIKE :LVS_FEEDER_SHAFT
					  	) ;	 

		if f_sql_check() < 0 then 
			return 
		end if 
		   commit ;
		   f_msgbox(170)
end if 
end event

type rb_all from so_radiobutton within w_smt_plan_master
integer x = 2171
integer y = 64
integer width = 343
boolean bringtotop = true
string text = "All"
boolean checked = true
end type

event clicked;call super::clicked;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
dw_3.SETFILTER('')
dw_3.FILTER()

dw_3.SETFILTER( 'PCB_ITEM  LIKE '+"'"+"%"+"'")
dw_3.FILTER()
F_MSG_MDI_HELP( STRING( dw_1.ROWCOUNT() ) + " Found")
end event

type rb_top from so_radiobutton within w_smt_plan_master
integer x = 2171
integer y = 168
integer width = 343
boolean bringtotop = true
string text = "Top"
end type

event clicked;call super::clicked;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
dw_3.SETFILTER('')
dw_3.FILTER()

dw_3.SETFILTER( 'PCB_ITEM  LIKE '+"'"+"T"+"'")
dw_3.FILTER()
F_MSG_MDI_HELP( STRING( dw_1.ROWCOUNT() ) + " Found")
end event

type rb_bottom from so_radiobutton within w_smt_plan_master
integer x = 2171
integer y = 264
integer width = 343
boolean bringtotop = true
string text = "Bottom"
end type

event clicked;call super::clicked;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
dw_3.SETFILTER('')
dw_3.FILTER()

dw_3.SETFILTER( 'PCB_ITEM  LIKE '+"'"+"B"+"'")
dw_3.FILTER()
F_MSG_MDI_HELP( STRING( dw_1.ROWCOUNT() ) + " Found")
end event

type cb_2 from so_commandbutton within w_smt_plan_master
integer x = 3232
integer y = 244
integer width = 539
integer height = 120
integer taborder = 80
boolean bringtotop = true
string text = "Print Layout"
end type

event clicked;call super::clicked;IF cbx_print_issue.CHECKED = TRUE THEN 
	dw_4.print( false )
END IF 
openwithparm(w_zetprint , dw_5)


end event

type rb_feeder_layout from so_radiobutton within w_smt_plan_master
integer x = 27
integer y = 148
integer width = 466
boolean bringtotop = true
string text = "Feeder Layout"
end type

event clicked;call super::clicked;dw_5.bringtotop = true
selected_data_window = dw_5



end event

type cb_3 from so_commandbutton within w_smt_plan_master
integer x = 3232
integer y = 124
integer width = 539
integer height = 120
integer taborder = 90
boolean bringtotop = true
string text = "Image Upload"
end type

event clicked;call super::clicked;if f_object_role_check() = false then  return

int    li_filenum , loops, i , lvi_count
long   flen, bytes_read , bytes_read_sum , new_pos
blob   lib_file , b
double lvdb_version
string is_filename, is_fullname , lvs_drawing_no , lvs_model_name
		
		if  dw_2.getrow() < 1 then 
			 return
		end if
			
		lvs_model_name  = dw_2.getitemstring( dw_2.getrow() , "MODEL_NAME" )
	
		if lvs_model_name ='' or isnull(lvs_model_name) then 
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
					
					select count(*) into :lvi_count
					  from ib_smt_bom_image
					 where model_name    = :lvs_model_name
						and organization_id = :gvi_organization_id ;
						  
					if f_sql_check() < 0 then 
						return
					end if				  
					
					if lvi_count = 0 then 
						
						insert into ib_smt_bom_image ( model_name , organization_id ) 
						   values ( :lvs_model_name , :gvi_organization_id ) ;
								  
						if f_sql_check() < 0 then 
							return
						end if				  
										
					end if
						  
					updateblob ib_smt_bom_image set model_image = :lib_file 
					where model_name  = :lvs_model_name
					  and organization_id = :gvi_organization_id ;

				  if sqlca.sqlnrows > 0 then

				  else
					  messagebox("error" , is_filename+f_msg(" file upload to database failed ",'S') +sqlca.sqlerrtext)
					  rollback ;
					
					  return
				  end if;
			  
				  commit ;
			         f_msgbox(9022)

		end if
changedirectory(gvs_default_directory)

end event

type cb_print_issue from so_commandbutton within w_smt_plan_master
integer x = 3776
integer y = 124
integer width = 434
integer height = 120
integer taborder = 90
boolean bringtotop = true
string text = "Print Issue"
end type

event clicked;call super::clicked;openwithparm(w_zetprint , dw_4)


end event

type rb_1 from so_radiobutton within w_smt_plan_master
integer x = 27
integer y = 220
integer width = 466
boolean bringtotop = true
string text = "Show Issue"
end type

event clicked;call super::clicked;dw_4.bringtotop = true
selected_data_window = dw_4

end event

type cbx_print_issue from so_checkbox within w_smt_plan_master
integer x = 3790
integer y = 64
integer width = 539
integer height = 52
boolean bringtotop = true
string text = "Print Issue"
boolean checked = true
end type

type rb_2 from so_radiobutton within w_smt_plan_master
integer x = 27
integer y = 288
integer width = 466
boolean bringtotop = true
string text = "Show Issue List"
end type

type ddlb_line_code from uo_line_code within w_smt_plan_master
integer x = 608
integer y = 204
integer width = 594
integer height = 1856
integer taborder = 30
boolean bringtotop = true
end type

type dw_6 from datawindow within w_smt_plan_master
integer x = 4887
integer y = 8
integer width = 1509
integer height = 388
integer taborder = 80
boolean bringtotop = true
boolean titlebar = true
string dataobject = "d_des_item_4_plan_smt_modify_lst"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

type cb_4 from so_commandbutton within w_smt_plan_master
integer x = 3776
integer y = 244
integer width = 434
integer height = 120
integer taborder = 100
boolean bringtotop = true
string text = "Restore"
end type

event clicked;call super::clicked;STRING lvs_model_name , lvs_line_code , lvs_pcb_item

msg = f_msgbox1(1161 , this.text ) 
if msg = 1 then 
else
	return 
end if 
if rb_top.checked = true then 
	lvs_pcb_item = 'T' 
elseif rb_bottom.checked = true then 
	lvs_pcb_item = 'B'
end if 
	
lvs_line_code = ddlb_line_code.getcode()
lvs_model_name = ddlb_model_name.getcode() 

          UPDATE   ib_product_plandata
               SET   check_status = 'P',
					check_yn = 'Y',
					check_msg = 'OK',
					change_date = SYSDATE,     
					CCS_YN = 'Y'        ,     
					ACTIVE_YN = 'Y' ,
					feeding_count = 1
		WHERE model_name = :lvs_model_name
		AND line_code = :lvs_line_code
		AND pcb_item = :lvs_pcb_item
		AND active_yn = 'Y'
		AND ccs_yn = 'N' 
		;
					  
		 if f_sql_check() < 0 then 
			return 
		end if 
		
		UPDATE   ib_product_plandata A
		SET  ( A.selected_date, A.item_barcode ,    A.chipname , A.supplier_barcode , A.lot_no , A.feeding_end_date   ) 
		= ( SELECT DISTINCT  MIN(b.CHECK_DATE ), b.SCAN_PARTNAME , b.CHIPNAME , b.SCAN_SUPPLIER_PARTNAME  , B.LOT_NO , MAX(B.CCS_END_DATE) 
					FROM IB_SMT_CHECKHIST b 
					where a.model_name = b.lot_name
					and  a.line_code = b.line_code
					and a.location_code = b.location_code
					and a.pcb_item = b.pcb_item 
					and B.lot_name =:lvs_model_name
					and B.line_code = :lvs_line_code
					AND B.CHECK_STATUS = 'P'
					AND B.CHECK_TYPE = 1
					AND B.pcb_item = :lvs_pcb_item
					GROUP BY b.SCAN_PARTNAME , b.CHIPNAME , b.SCAN_SUPPLIER_PARTNAME  , B.LOT_NO 
		)
		WHERE model_name =:lvs_model_name
		AND line_code =:lvs_line_code
		AND active_yn = 'Y'
//	 	AND ccs_yn = 'N' 
	    AND pcb_item = :lvs_pcb_item
	;         
					  
		 if f_sql_check() < 0 then 
			return 
		end if 
		commit ;
		f_retrieve()
end event

type cbx_auo_retrieve from so_checkbox within w_smt_plan_master
integer x = 3232
integer y = 64
integer width = 539
integer height = 52
boolean bringtotop = true
string text = "Layout Auto Retrieve"
boolean checked = true
end type

type cb_out from so_commandbutton within w_smt_plan_master
integer x = 4210
integer y = 244
integer width = 320
integer height = 120
integer taborder = 110
boolean bringtotop = true
string text = "Line OFF"
end type

event clicked;call super::clicked;string p_err = space( 2000) , lvs_ps_type

if dw_2.getrow() < 1 then return 

msg = f_msgbox1( 1161 , this.text ) 

if msg = 1 then 
else
	return 
end if 


IF rb_product.checked = true  THEN 
	lvs_ps_type = 'P'
ELSE
	lvs_ps_type = 'S' 
END IF 
//sqlca.P_CHECK_PDA_TB_INOUT( dw_2.object.line_code[dw_2.getrow()], dw_2.object.model_name[dw_2.getrow()], dw_2.object.pcb_item[dw_2.getrow()], '2',  p_err ) ;
sqlca.P_CHECK_PDA_TB_INOUT_PS(dw_2.object.line_code[dw_2.getrow()], dw_2.object.model_name[dw_2.getrow()], dw_2.object.pcb_item[dw_2.getrow()], '2',  lvs_ps_type ,  p_err ) ;

if isnull(p_err) then 
	Messagebox("Notify" , f_msg('OK','S') ) 
ELSE
	Messagebox("Notify" , p_err ) 
END IF 
IF SQLCA.SQLCODE < 0 THEN 
	ROLLBACK;
ELSE
	commit ;
END IF 
end event

type cb_5 from so_commandbutton within w_smt_plan_master
integer x = 4210
integer y = 124
integer width = 320
integer height = 120
integer taborder = 120
boolean bringtotop = true
string text = "Line On"
end type

event clicked;call super::clicked;string p_err  = space(2000) , lvs_ps_type

IF rb_product.checked = true  THEN 
	lvs_ps_type = 'P'
ELSE
	lvs_ps_type = 'S' 
END IF 
if dw_2.getrow() < 1 then return 

//sqlca.P_CHECK_PDA_TB_INOUT( dw_2.object.line_code[dw_2.getrow()], dw_2.object.model_name[dw_2.getrow()], dw_2.object.pcb_item[dw_2.getrow()], '1',  p_err ) ;
sqlca.P_CHECK_PDA_TB_INOUT_PS(dw_2.object.line_code[dw_2.getrow()], dw_2.object.model_name[dw_2.getrow()], dw_2.object.pcb_item[dw_2.getrow()], '1',  lvs_ps_type ,  p_err ) ;

Messagebox("Notify" , p_err ) 
IF SQLCA.SQLCODE < 0 THEN 
	ROLLBACK;
ELSE
	commit ;
END IF 
end event

type st_4 from so_statictext within w_smt_plan_master
integer x = 1879
integer y = 124
integer width = 270
integer height = 56
boolean bringtotop = true
integer textsize = -9
boolean enabled = false
string text = "Revision"
end type

type sle_revision from so_singlelineedit within w_smt_plan_master
integer x = 1879
integer y = 204
integer width = 270
integer height = 84
integer taborder = 50
boolean bringtotop = true
end type

type ddlb_model_name from uo_smt_layout_model_name_ddlb within w_smt_plan_master
integer x = 1216
integer y = 204
integer width = 658
integer taborder = 40
boolean bringtotop = true
end type

event selectionchanged;call super::selectionchanged;dw_6.retrieve( this.getcode()  , gvi_organization_id )

end event

type rb_product from so_radiobutton within w_smt_plan_master
integer x = 4553
integer y = 128
integer width = 288
boolean bringtotop = true
string text = "Product"
boolean checked = true
end type

event clicked;call super::clicked;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
dw_3.SETFILTER('')
dw_3.FILTER()

dw_3.SETFILTER( 'PCB_ITEM  LIKE '+"'"+"%"+"'")
dw_3.FILTER()
F_MSG_MDI_HELP( STRING( dw_1.ROWCOUNT() ) + " Found")
end event

type rb_sample from so_radiobutton within w_smt_plan_master
integer x = 4553
integer y = 244
integer width = 288
boolean bringtotop = true
string text = "Sample"
end type

event clicked;call super::clicked;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
dw_3.SETFILTER('')
dw_3.FILTER()

dw_3.SETFILTER( 'PCB_ITEM  LIKE '+"'"+"%"+"'")
dw_3.FILTER()
F_MSG_MDI_HELP( STRING( dw_1.ROWCOUNT() ) + " Found")
end event

type gb_2 from so_groupbox within w_smt_plan_master
integer y = 12
integer width = 553
integer height = 376
integer taborder = 20
long textcolor = 16711680
string text = "Category"
end type

type gb_1 from so_groupbox within w_smt_plan_master
integer x = 571
integer y = 8
integer width = 1975
integer height = 376
integer taborder = 30
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_smt_plan_master
integer x = 2560
integer y = 12
integer width = 2309
integer height = 376
integer taborder = 40
long textcolor = 16711680
string text = "Process"
end type

