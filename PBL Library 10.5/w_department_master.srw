HA$PBExportHeader$w_department_master.srw
$PBExportComments$Department Information Manage
forward
global type w_department_master from w_main_root
end type
type st_3 from so_statictext within w_department_master
end type
type st_2 from so_statictext within w_department_master
end type
type ddlb_organization_id from uo_orz_id within w_department_master
end type
type st_1 from so_statictext within w_department_master
end type
type ddlb_pre_department_code from uo_department_code within w_department_master
end type
type sle_department_name from so_singlelineedit within w_department_master
end type
type cb_3 from so_commandbutton within w_department_master
end type
type ddlb_from_org from uo_orz_id within w_department_master
end type
type ddlb_to_org from uo_orz_id within w_department_master
end type
type st_8 from so_statictext within w_department_master
end type
type st_9 from so_statictext within w_department_master
end type
type gb_1 from so_groupbox within w_department_master
end type
type gb_3 from so_groupbox within w_department_master
end type
end forward

global type w_department_master from w_main_root
integer width = 4718
string title = "Department"
st_3 st_3
st_2 st_2
ddlb_organization_id ddlb_organization_id
st_1 st_1
ddlb_pre_department_code ddlb_pre_department_code
sle_department_name sle_department_name
cb_3 cb_3
ddlb_from_org ddlb_from_org
ddlb_to_org ddlb_to_org
st_8 st_8
st_9 st_9
gb_1 gb_1
gb_3 gb_3
end type
global w_department_master w_department_master

on w_department_master.create
int iCurrent
call super::create
this.st_3=create st_3
this.st_2=create st_2
this.ddlb_organization_id=create ddlb_organization_id
this.st_1=create st_1
this.ddlb_pre_department_code=create ddlb_pre_department_code
this.sle_department_name=create sle_department_name
this.cb_3=create cb_3
this.ddlb_from_org=create ddlb_from_org
this.ddlb_to_org=create ddlb_to_org
this.st_8=create st_8
this.st_9=create st_9
this.gb_1=create gb_1
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_3
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.ddlb_organization_id
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.ddlb_pre_department_code
this.Control[iCurrent+6]=this.sle_department_name
this.Control[iCurrent+7]=this.cb_3
this.Control[iCurrent+8]=this.ddlb_from_org
this.Control[iCurrent+9]=this.ddlb_to_org
this.Control[iCurrent+10]=this.st_8
this.Control[iCurrent+11]=this.st_9
this.Control[iCurrent+12]=this.gb_1
this.Control[iCurrent+13]=this.gb_3
end on

on w_department_master.destroy
call super::destroy
destroy(this.st_3)
destroy(this.st_2)
destroy(this.ddlb_organization_id)
destroy(this.st_1)
destroy(this.ddlb_pre_department_code)
destroy(this.sle_department_name)
destroy(this.cb_3)
destroy(this.ddlb_from_org)
destroy(this.ddlb_to_org)
destroy(this.st_8)
destroy(this.st_9)
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

CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		    dw_1.RETRIEVE(DDLB_PRE_DEPARTMENT_CODE.GETCODE()+'%', DDLB_ORGANIZATION_ID.GETCODE()+'%', SLE_DEPARTMENT_NAME.TEXT+'%')
             dw_1.SETFOCUS()

	CASE 'INSERT'
		    DW_2.RESET()
			ROW = dw_2.INSERTROW(dw_2.GETROW())
			F_SET_SECURITY_ROW(dw_2 , ROW , 'NONORG')
			dw_2.setitem(ROW , 'organization_id' , long(ddlb_organization_id.getcode()))
			F_MSG_MDI_HELP( F_MSG_ST(152 ) )
	CASE 'APPEND'
		
		
			DW_2.RESET()
			
			if dw_1.getrow() > 0 then 
				
				ROW = dw_2.INSERTROW(0)
				F_SET_SECURITY_ROW(dw_2 , ROW , 'NONORG')
				dw_2.setitem(ROW , 'organization_id' , long(ddlb_organization_id.getcode()))
				dw_2.setitem(ROW , 'pre_department_code' , dw_1.getitemstring( dw_1.getrow() , 'department_code' )  )
				dw_2.setitem(ROW , 'pre_department_name_local' , dw_1.getitemstring( dw_1.getrow() , 'department_name_local' )  )				
				dw_2.setitem(ROW , 'pre_department_name_kor' , dw_1.getitemstring( dw_1.getrow() , 'department_name_kor' )  )				
				dw_2.setitem(ROW , 'pre_department_name_eng' , dw_1.getitemstring( dw_1.getrow() , 'department_name_eng' )  )				
				
				F_MSG_MDI_HELP( F_MSG_ST(152 ) )
			     dw_2.setfocus()				
				
			else
				
				ROW = dw_2.INSERTROW(0)
				F_SET_SECURITY_ROW(dw_2 , ROW , 'NONORG')
				dw_2.setitem(ROW , 'organization_id' , long(ddlb_organization_id.getcode()))
				F_MSG_MDI_HELP( F_MSG_ST(152 ) )
			     dw_2.setfocus()
			end if
			
			

			
	CASE 'DELETE'
		
			IF DW_2.GETROW() < 1 THEN RETURN 
			MSG = F_MSGBOX(1003) 
			IF MSG = 1 THEN
				GVL_ROW_DELETED = DW_2.GETROW()			
				DW_2.DELETEROW(GVL_ROW_DELETED)		
				DW_2.SETFOCUS()
				ROW = DW_2.GETROW()
				DW_2.SCROLLTOROW(ROW)
				DW_2.SETCOLUMN(1)
			END IF			
			
	CASE 'UPDATE'
		
			IF DW_2.UPDATE() < 0 THEN
				ROLLBACK;
			ELSE
				COMMIT;
			F_MSG_MDI_HELP( F_MSG_ST(170 ) )
			END IF
			
	CASE ELSE
END CHOOSE

end event

event ue_post_open;call super::ue_post_open;f_child_dw(dw_1, 'pre_department_code', ddlb_organization_id.getcode()+'%')
//f_child_dw(dw_1, 'pre_department_name_', ddlb_organization_id.getcode()+'%')
f_child_dw2(dw_2, 'pre_department_code', gvs_language , ddlb_organization_id.getcode()+'%')
f_child_dw2(dw_2, 'organization_id', gvs_language, string(gvi_organization_id))

/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())


end event

type dw_5 from w_main_root`dw_5 within w_department_master
integer y = 316
end type

type dw_4 from w_main_root`dw_4 within w_department_master
integer y = 316
end type

type dw_3 from w_main_root`dw_3 within w_department_master
integer y = 316
end type

type dw_2 from w_main_root`dw_2 within w_department_master
integer y = 1812
integer width = 4544
integer height = 684
string dataobject = "d_department_mst"
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

event dw_2::rbuttondown;call super::rbuttondown;if row < 1 then return

if dwo.name = 'pre_department_code' then 
	
   open( w_department_popup)

	if Gst_return.Gvb_return = True then
		
		this.object.pre_department_name_local[row] = Gst_return.gvs_return[1]
		this.object.pre_department_name_kor[row] = Gst_return.gvs_return[2]
		this.object.pre_department_name_eng[row] = Gst_return.gvs_return[3]		
	else
	end if
	
end if

end event

type dw_1 from w_main_root`dw_1 within w_department_master
integer y = 316
integer width = 4544
integer height = 1496
boolean titlebar = true
string title = "Department List"
string dataobject = "d_department_lst_tree"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;string lvs_pre_dept_code
IF currentrow > 0 THEN
	
	lvs_pre_dept_code = dw_1.object.pre_department_code[currentrow]
	if isnull(lvs_pre_dept_code) or lvs_pre_dept_code = '' then 
		lvs_pre_dept_code = '%'
	end if
	
	dw_2.retrieve( lvs_pre_dept_code+'%' ,  dw_1.object.department_code[currentrow]+'%',   Long(dw_1.object.organization_id[currentrow]) )
	
ELSE
	DW_2.RESET()
END IF


end event

type uo_tabpages from w_main_root`uo_tabpages within w_department_master
end type

type st_3 from so_statictext within w_department_master
integer x = 1477
integer y = 84
integer width = 654
integer height = 56
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Department Name"
end type

type st_2 from so_statictext within w_department_master
integer x = 37
integer y = 84
integer width = 795
integer height = 56
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Organization ID"
end type

type ddlb_organization_id from uo_orz_id within w_department_master
integer x = 37
integer y = 152
integer width = 795
integer taborder = 20
boolean bringtotop = true
end type

event selectionchanged;call super::selectionchanged;ddlb_pre_department_code.redraw(ddlb_organization_id.getcode())
f_child_dw(dw_1, 'pre_dept_code', ddlb_organization_id.getcode()+'%')
f_child_dw(dw_2, 'pre_dept_code', ddlb_organization_id.getcode()+'%')

end event

type st_1 from so_statictext within w_department_master
integer x = 841
integer y = 84
integer width = 608
integer height = 56
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Pre Department Code"
end type

type ddlb_pre_department_code from uo_department_code within w_department_master
integer x = 841
integer y = 152
integer taborder = 20
boolean bringtotop = true
end type

event selectionchanged;call super::selectionchanged;F_MSG_MDI_HELP( THIS.TEXT())
end event

type sle_department_name from so_singlelineedit within w_department_master
integer x = 1477
integer y = 152
integer width = 654
integer taborder = 30
boolean bringtotop = true
end type

type cb_3 from so_commandbutton within w_department_master
integer x = 2194
integer y = 104
integer width = 581
integer height = 112
integer taborder = 70
boolean bringtotop = true
string text = "Sync Depratment"
end type

event clicked;call super::clicked;INT LVI_FROM_ORG , LVI_TO_ORG

LVI_FROM_ORG = INTEGER( DDLB_FROM_ORG.GETCODE( ) )
LVI_TO_ORG = INTEGER( DDLB_TO_ORG.GETCODE( ) )

  INSERT INTO "ISYS_DEPARTMENT"  
         ( "DEPARTMENT_CODE",   
           "ORGANIZATION_ID",   
           "PRE_DEPARTMENT_CODE",   
           "DEPARTMENT_NAME_LOCAL",   
           "DEPARTMENT_NAME_KOR",   
           "DEPARTMENT_NAME_ENG",   
           "COMMENTS",   
           "ENTER_DATE",   
           "PRE_DEPARTMENT_NAME_KOR",   
           "PRE_DEPARTMENT_NAME_LOCAL",   
           "ENTER_BY",   
           "LAST_MODIFY_DATE",   
           "LAST_MODIFY_BY",   
           "PRE_DEPARTMENT_NAME_ENG" )  
     SELECT "ISYS_DEPARTMENT"."DEPARTMENT_CODE",   
            :LVI_TO_ORG , //"ISYS_DEPARTMENT"."ORGANIZATION_ID",   
            "ISYS_DEPARTMENT"."PRE_DEPARTMENT_CODE",   
            "ISYS_DEPARTMENT"."DEPARTMENT_NAME_LOCAL",   
            "ISYS_DEPARTMENT"."DEPARTMENT_NAME_KOR",   
            "ISYS_DEPARTMENT"."DEPARTMENT_NAME_ENG",   
            "ISYS_DEPARTMENT"."COMMENTS",   
            "ISYS_DEPARTMENT"."ENTER_DATE",   
            "ISYS_DEPARTMENT"."PRE_DEPARTMENT_NAME_KOR",   
            "ISYS_DEPARTMENT"."PRE_DEPARTMENT_NAME_LOCAL",   
            "ISYS_DEPARTMENT"."ENTER_BY",   
            "ISYS_DEPARTMENT"."LAST_MODIFY_DATE",   
            "ISYS_DEPARTMENT"."LAST_MODIFY_BY",   
            "ISYS_DEPARTMENT"."PRE_DEPARTMENT_NAME_ENG"  
       FROM "ISYS_DEPARTMENT"  
    WHERE ORGANIZATION_ID  = 	:LVI_FROM_ORG
	  AND DEPARTMENT_CODE NOT IN ( SELECT DEPARTMENT_CODE FROM ISYS_DEPARTMENT WHERE ORGANIZATION_ID  =  :LVI_TO_ORG ) ;
	  
IF F_SQL_CHECK() < 0 THEN 
	RETURN
ELSE
	MSG = F_MSGBOX( 1170 )
	IF MSG = 1 THEN 
		COMMIT ;
	ELSE
		ROLLBACK;
	END IF
END IF 
		 
		 


end event

type ddlb_from_org from uo_orz_id within w_department_master
integer x = 2789
integer y = 124
integer width = 722
integer taborder = 40
boolean bringtotop = true
end type

type ddlb_to_org from uo_orz_id within w_department_master
integer x = 3520
integer y = 124
integer width = 722
integer taborder = 50
boolean bringtotop = true
end type

type st_8 from so_statictext within w_department_master
integer x = 2793
integer y = 44
integer width = 722
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "From"
end type

type st_9 from so_statictext within w_department_master
integer x = 3525
integer y = 48
integer width = 722
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "To"
end type

type gb_1 from so_groupbox within w_department_master
integer width = 2153
integer height = 288
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_department_master
integer x = 2167
integer width = 2107
integer height = 288
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

