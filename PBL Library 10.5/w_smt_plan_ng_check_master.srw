HA$PBExportHeader$w_smt_plan_ng_check_master.srw
$PBExportComments$$$HEX4$$ddc0b0c0c4ac8dd6$$ENDHEX$$
forward
global type w_smt_plan_ng_check_master from w_main_root
end type
type st_3 from so_statictext within w_smt_plan_ng_check_master
end type
type ddlb_line_code from uo_line_code within w_smt_plan_ng_check_master
end type
type gb_1 from so_groupbox within w_smt_plan_ng_check_master
end type
end forward

global type w_smt_plan_ng_check_master from w_main_root
integer width = 5824
integer height = 3180
string title = "PDA Scan NG List Query"
windowstate windowstate = maximized!
st_3 st_3
ddlb_line_code ddlb_line_code
gb_1 gb_1
end type
global w_smt_plan_ng_check_master w_smt_plan_ng_check_master

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

on w_smt_plan_ng_check_master.create
int iCurrent
call super::create
this.st_3=create st_3
this.ddlb_line_code=create ddlb_line_code
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_3
this.Control[iCurrent+2]=this.ddlb_line_code
this.Control[iCurrent+3]=this.gb_1
end on

on w_smt_plan_ng_check_master.destroy
call super::destroy
destroy(this.st_3)
destroy(this.ddlb_line_code)
destroy(this.gb_1)
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
				dw_1.retrieve(ddlb_line_code.getcode()+'%' ,  Gvi_organization_id  )	


	CASE 'INSERT'		//$$HEX5$$c4ac8dd694cd00ac2000$$ENDHEX$$
	
				
	CASE 'APPEND' 

	CASE 'DELETE' 


	CASE 'UPDATE'
	
			   if dw_1.update() < 0 then 
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

f_retrieve()


end event

type dw_5 from w_main_root`dw_5 within w_smt_plan_ng_check_master
integer x = 9
integer y = 412
integer width = 2208
integer height = 716
boolean titlebar = true
string title = "Feeder Layout(Plan)"
string dataobject = "d_smt_plandata_list_rpt"
end type

type dw_4 from w_main_root`dw_4 within w_smt_plan_ng_check_master
integer x = 9
integer y = 412
integer width = 2208
integer height = 716
boolean titlebar = true
string dataobject = "d_smt_workflow_rpt"
end type

type dw_3 from w_main_root`dw_3 within w_smt_plan_ng_check_master
integer x = 9
integer y = 412
integer width = 2208
integer height = 716
boolean titlebar = true
string title = "Feeder Layout"
end type

type dw_2 from w_main_root`dw_2 within w_smt_plan_ng_check_master
integer y = 1680
integer width = 5193
integer height = 1264
boolean titlebar = true
string title = "Check List"
string dataobject = "d_smt_checklist_4_ng_check_lst"
end type

type dw_1 from w_main_root`dw_1 within w_smt_plan_ng_check_master
event ue_lbuttondown pbm_lbuttondown
integer y = 408
integer width = 5193
integer height = 1264
boolean titlebar = true
string title = "Line"
string dataobject = "d_smt_plandata_ng_check_4_plan"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 


dw_2.retrieve( dw_1.object.line_code[currentrow] , dw_1.object.model_name[currentrow] , dw_1.object.location_code[currentrow] , GVI_ORGANIZATION_ID) 
end event

type uo_tabpages from w_main_root`uo_tabpages within w_smt_plan_ng_check_master
end type

type st_3 from so_statictext within w_smt_plan_ng_check_master
integer x = 78
integer y = 140
integer width = 594
integer height = 56
boolean bringtotop = true
string text = "Line Code"
end type

type ddlb_line_code from uo_line_code within w_smt_plan_ng_check_master
integer x = 78
integer y = 216
integer width = 594
integer height = 1856
integer taborder = 30
boolean bringtotop = true
end type

type gb_1 from so_groupbox within w_smt_plan_ng_check_master
integer x = 37
integer y = 20
integer width = 718
integer height = 376
integer taborder = 30
long textcolor = 16711680
string text = "Where Condition"
end type

