HA$PBExportHeader$w_basecode_master.srw
$PBExportComments$Base Information Manage
forward
global type w_basecode_master from w_main_root
end type
type st_2 from so_statictext within w_basecode_master
end type
type ddlb_code_group from uo_code_group within w_basecode_master
end type
type sle_code_name from so_singlelineedit within w_basecode_master
end type
type ddlb_code_type from uo_code_type within w_basecode_master
end type
type st_20 from so_statictext within w_basecode_master
end type
type st_1 from so_statictext within w_basecode_master
end type
type cb_3 from so_commandbutton within w_basecode_master
end type
type ddlb_from_org from uo_orz_id within w_basecode_master
end type
type st_8 from so_statictext within w_basecode_master
end type
type ddlb_to_org from uo_orz_id within w_basecode_master
end type
type st_9 from so_statictext within w_basecode_master
end type
type cb_1 from so_commandbutton within w_basecode_master
end type
type gb_2 from so_groupbox within w_basecode_master
end type
type gb_3 from so_groupbox within w_basecode_master
end type
end forward

global type w_basecode_master from w_main_root
integer width = 5266
integer height = 2900
string title = "Base Code Manage"
string icon = "Form!"
st_2 st_2
ddlb_code_group ddlb_code_group
sle_code_name sle_code_name
ddlb_code_type ddlb_code_type
st_20 st_20
st_1 st_1
cb_3 cb_3
ddlb_from_org ddlb_from_org
st_8 st_8
ddlb_to_org ddlb_to_org
st_9 st_9
cb_1 cb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_basecode_master w_basecode_master

type variables

end variables

on w_basecode_master.create
int iCurrent
call super::create
this.st_2=create st_2
this.ddlb_code_group=create ddlb_code_group
this.sle_code_name=create sle_code_name
this.ddlb_code_type=create ddlb_code_type
this.st_20=create st_20
this.st_1=create st_1
this.cb_3=create cb_3
this.ddlb_from_org=create ddlb_from_org
this.st_8=create st_8
this.ddlb_to_org=create ddlb_to_org
this.st_9=create st_9
this.cb_1=create cb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.ddlb_code_group
this.Control[iCurrent+3]=this.sle_code_name
this.Control[iCurrent+4]=this.ddlb_code_type
this.Control[iCurrent+5]=this.st_20
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.cb_3
this.Control[iCurrent+8]=this.ddlb_from_org
this.Control[iCurrent+9]=this.st_8
this.Control[iCurrent+10]=this.ddlb_to_org
this.Control[iCurrent+11]=this.st_9
this.Control[iCurrent+12]=this.cb_1
this.Control[iCurrent+13]=this.gb_2
this.Control[iCurrent+14]=this.gb_3
end on

on w_basecode_master.destroy
call super::destroy
destroy(this.st_2)
destroy(this.ddlb_code_group)
destroy(this.sle_code_name)
destroy(this.ddlb_code_type)
destroy(this.st_20)
destroy(this.st_1)
destroy(this.cb_3)
destroy(this.ddlb_from_org)
destroy(this.st_8)
destroy(this.ddlb_to_org)
destroy(this.st_9)
destroy(this.cb_1)
destroy(this.gb_2)
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

/*****************************************
* Multi Selected Data Delete Control Default 'Y'
******************************************/
ivs_dw_1_deleteselected_yn = 'N'

/****************************************
* Menu Property $$HEX6$$54ba74b2200078d5e4b4c1b9$$ENDHEX$$
*****************************************
* ADMIN     : ADMIN  ( $$HEX5$$04c8b4ccacc0a9c62000$$ENDHEX$$)
* $$HEX8$$00adacb9200020002000200020002000$$ENDHEX$$: MANAGE ( $$HEX8$$04c854ba74b2acc0a9c600aca5b22000$$ENDHEX$$)
* $$HEX7$$acc0a9c690c72000200020002000$$ENDHEX$$: GUEST  ( $$HEX11$$30ae08cd2000f1b45db8200070c88cd6200000aca5b2$$ENDHEX$$)
* $$HEX8$$70c88cd6200020002000200020002000$$ENDHEX$$: QUERY  ( $$HEX10$$15c8f4bc70c88cd6ccb9200000aca5b220002000$$ENDHEX$$)
* $$HEX5$$70b374c7c0d070c891c7$$ENDHEX$$: DATA_CONTROL  ( $$HEX12$$85c725b8200018c215c82000adc01cc8200024c115c82000$$ENDHEX$$)
* $$HEX7$$08b8ecd3b8d22000200020002000$$ENDHEX$$: REPORT ( $$HEX4$$08b8ecd3b8d22000$$ENDHEX$$, $$HEX5$$9ccd25b800adacb92000$$ENDHEX$$)

* RETRIEVE
* DATA_CONTROL
* DATA_CONTROL_MODIFY
* DATA_CONTROL_INSERT
* DATA_CONTROL_DELETE
* REPORT
****************************************/

F_MENU_CONTROL('DATA_CONTROL' , TRUE)     // All Data Control

/****************************************
* 
****************************************/

end event

event ue_data_control;call super::ue_data_control;Long ROW
CHOOSE CASE Gvs_Ue_DATA_control
	CASE 'RETRIEVE'
    
			SELECTED_DATA_WINDOW.RETRIEVE( upper(DDLB_CODE_GROUP.TEXT)+'%' , upper(DDLB_CODE_TYPE.TEXT())+'%' , upper(SLE_CODE_NAME.TEXT)+'%' , GVI_ORGANIZATION_ID)
			SELECTED_DATA_WINDOW.SETFOCUS()
			
	CASE 'INSERT'
			ROW = SELECTED_DATA_WINDOW.INSERTROW(SELECTED_DATA_WINDOW.GETROW())
			SELECTED_DATA_WINDOW.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(SELECTED_DATA_WINDOW , ROW , 'ALL')
			F_MSG_MDI_HELP( F_MSG_ST(152))
	CASE 'APPEND'
			ROW = SELECTED_DATA_WINDOW.INSERTROW(0)
			SELECTED_DATA_WINDOW.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(SELECTED_DATA_WINDOW , ROW , 'ALL')	
			F_MSG_MDI_HELP( F_MSG_ST(152))		
	CASE 'DELETE'
		
		  	IF SELECTED_DATA_WINDOW.GETROW() < 1 THEN RETURN 
			  
		     IF  SELECTED_DATA_WINDOW.OBJECT.CODE_GROUP[SELECTED_DATA_WINDOW.GETROW()] = 'SYSTEM' THEN 
                    F_MSGBOX( 112 )				
				RETURN
		     END IF				
			  
			MSG = F_MSGBOX(1003) 
			IF MSG = 1 THEN
				GVL_ROW_DELETED = SELECTED_DATA_WINDOW.GETROW()			
				SELECTED_DATA_WINDOW.DELETEROW(GVL_ROW_DELETED)		
				SELECTED_DATA_WINDOW.SETFOCUS()
				ROW = SELECTED_DATA_WINDOW.GETROW()
				SELECTED_DATA_WINDOW.SCROLLTOROW(ROW)
				SELECTED_DATA_WINDOW.SETCOLUMN(1)
			END IF
			  
	CASE 'UPDATE'
		
	         IF SELECTED_DATA_WINDOW.UPDATE() < 0 THEN
				ROLLBACK;
			ELSE
				 COMMIT;
	  			 F_MSG_MDI_HELP( F_MSG_ST(170))//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
			END IF
			
	CASE ELSE
END CHOOSE


end event

event ue_post_open;call super::ue_post_open;/****************************************
* Window Property Setup
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

type dw_5 from w_main_root`dw_5 within w_basecode_master
integer y = 300
end type

type dw_4 from w_main_root`dw_4 within w_basecode_master
integer y = 300
end type

type dw_3 from w_main_root`dw_3 within w_basecode_master
integer y = 300
integer taborder = 60
end type

type dw_2 from w_main_root`dw_2 within w_basecode_master
integer y = 300
integer taborder = 40
end type

type dw_1 from w_main_root`dw_1 within w_basecode_master
integer y = 300
integer width = 4544
integer height = 2200
integer taborder = 50
boolean titlebar = true
string title = "Basecode List"
string dataobject = "d_basecode_lst"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_basecode_master
end type

type st_2 from so_statictext within w_basecode_master
integer x = 1659
integer y = 68
integer width = 754
boolean bringtotop = true
integer weight = 700
string text = "Code Name"
end type

type ddlb_code_group from uo_code_group within w_basecode_master
integer x = 55
integer y = 148
integer width = 741
boolean bringtotop = true
boolean autohscroll = true
end type

type sle_code_name from so_singlelineedit within w_basecode_master
event ue_editchange pbm_enchange
integer x = 1659
integer y = 148
integer width = 754
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

event ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

LVS_COLUMN = 'CODE_NAME'

IF ISNULL(LVS_COLUMN) OR LEN(LVS_COLUMN) = 0 THEN RETURN 

SELECTED_DATA_WINDOW.SETFILTER('')
SELECTED_DATA_WINDOW.FILTER()

IF THIS.TEXT = '' THEN 
	LVS_VALUE = '%'
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

SELECTED_DATA_WINDOW.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
SELECTED_DATA_WINDOW.FILTER()
F_MSG_MDI_HELP( STRING( SELECTED_DATA_WINDOW.ROWCOUNT() ) + " Found" )
end event

event getfocus;this.selecttext( 1 , len( this.text) )
this.Borderstyle = styleraised!
end event

event losefocus;this.Borderstyle = styleLowered!
end event

type ddlb_code_type from uo_code_type within w_basecode_master
integer x = 800
integer y = 148
integer taborder = 20
boolean bringtotop = true
end type

event modified;call super::modified;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

LVS_COLUMN = 'CODE_TYPE'

IF ISNULL(LVS_COLUMN) OR LEN(LVS_COLUMN) = 0 THEN RETURN 

SELECTED_DATA_WINDOW.SETFILTER('')
SELECTED_DATA_WINDOW.FILTER()

IF THIS.TEXT = '' THEN 
	LVS_VALUE = '%'
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

SELECTED_DATA_WINDOW.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
SELECTED_DATA_WINDOW.FILTER()
F_MSG_MDI_HELP( STRING( SELECTED_DATA_WINDOW.ROWCOUNT() ) + " Found" )
end event

type st_20 from so_statictext within w_basecode_master
integer x = 800
integer y = 68
integer width = 850
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Code Type"
end type

type st_1 from so_statictext within w_basecode_master
integer x = 165
integer y = 68
boolean bringtotop = true
integer weight = 700
string text = "Code Group"
end type

type cb_3 from so_commandbutton within w_basecode_master
integer x = 2487
integer y = 60
integer width = 581
integer height = 104
integer taborder = 70
boolean bringtotop = true
string text = "Sync Basecode"
end type

event clicked;call super::clicked;INT LVI_FROM_ORG , LVI_TO_ORG

LVI_FROM_ORG = INTEGER( DDLB_FROM_ORG.GETCODE( ) )
LVI_TO_ORG = INTEGER( DDLB_TO_ORG.GETCODE( ) )

msg = f_msgbox1( 1161 , this.text)
if msg = 1 then
else
	return
end if

  INSERT INTO "ISYS_BASECODE"  
         ( "CODE_TYPE",   
           "CODE_NAME",   
           "ORGANIZATION_ID",   
           "CODE_MEAN_KOR",   
           "CODE_MEAN_ENG",   
           "CODE_MEAN_LOCAL",   
           "CODE_NAME_DESCRIPTION_KOR",   
           "CODE_NAME_DESCRIPTION_ENG",   
           "CODE_NAME_DESCRIPTION_LOCAL",   
           "CODE_TYPE_DESC_KOR",   
           "CODE_TYPE_DESC_ENG",   
           "CODE_TYPE_DESC_LOCAL",   
           "CODE_GROUP",   
           "ENTER_DATE",   
           "ENTER_BY",   
           "LAST_MODIFY_DATE",   
           "LAST_MODIFY_BY" )  
     SELECT "ISYS_BASECODE"."CODE_TYPE",   
            "ISYS_BASECODE"."CODE_NAME",   
            :LVI_TO_ORG ,
            "ISYS_BASECODE"."CODE_MEAN_KOR",   
            "ISYS_BASECODE"."CODE_MEAN_ENG",   
            "ISYS_BASECODE"."CODE_MEAN_LOCAL",   
            "ISYS_BASECODE"."CODE_NAME_DESCRIPTION_KOR",   
            "ISYS_BASECODE"."CODE_NAME_DESCRIPTION_ENG",   
            "ISYS_BASECODE"."CODE_NAME_DESCRIPTION_LOCAL",   
            "ISYS_BASECODE"."CODE_TYPE_DESC_KOR",   
            "ISYS_BASECODE"."CODE_TYPE_DESC_ENG",   
            "ISYS_BASECODE"."CODE_TYPE_DESC_LOCAL",   
            "ISYS_BASECODE"."CODE_GROUP",   
            "ISYS_BASECODE"."ENTER_DATE",   
            "ISYS_BASECODE"."ENTER_BY",   
            "ISYS_BASECODE"."LAST_MODIFY_DATE",   
            "ISYS_BASECODE"."LAST_MODIFY_BY"  
       FROM "ISYS_BASECODE"  
    WHERE ORGANIZATION_ID  = 		 :LVI_FROM_ORG
	  AND ( CODE_TYPE  , CODE_NAME ) NOT IN ( SELECT CODE_TYPE  , CODE_NAME FROM ISYS_BASECODE WHERE ORGANIZATION_ID  =  :LVI_TO_ORG ) ;
	  
IF F_SQL_CHECK() < 0 THEN 
	RETURN
ELSE
	
	
	MSG = F_MSGBOX1( 9014  , String(sqlca.sqlnrows) )
	IF MSG = 1 THEN 
		COMMIT ;
	ELSE
		ROLLBACK;
	END IF
END IF 
		 
		 


end event

type ddlb_from_org from uo_orz_id within w_basecode_master
integer x = 3077
integer y = 124
integer width = 722
integer taborder = 40
boolean bringtotop = true
end type

type st_8 from so_statictext within w_basecode_master
integer x = 3081
integer y = 44
integer width = 722
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "From"
end type

type ddlb_to_org from uo_orz_id within w_basecode_master
integer x = 3808
integer y = 124
integer width = 722
integer taborder = 50
boolean bringtotop = true
end type

type st_9 from so_statictext within w_basecode_master
integer x = 3813
integer y = 48
integer width = 722
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "To"
end type

type cb_1 from so_commandbutton within w_basecode_master
integer x = 2487
integer y = 168
integer width = 581
integer height = 100
integer taborder = 80
boolean bringtotop = true
string text = "Get From ERP"
end type

event clicked;call super::clicked;  INSERT INTO ISYS_BASECODE  
         ( CODE_TYPE,   
           CODE_NAME,   
           ORGANIZATION_ID,   
           CODE_MEAN_KOR,   
           CODE_MEAN_ENG,   
           CODE_MEAN_LOCAL,   
           CODE_NAME_DESCRIPTION_KOR,   
           CODE_NAME_DESCRIPTION_ENG,   
           CODE_NAME_DESCRIPTION_LOCAL,   
           CODE_TYPE_DESC_KOR,   
           CODE_TYPE_DESC_ENG,   
           CODE_TYPE_DESC_LOCAL,   
           CODE_GROUP,   
           ENTER_DATE,   
           ENTER_BY,   
           LAST_MODIFY_DATE,   
           LAST_MODIFY_BY )  
     SELECT A.CODE_TYPE,   
            A.CODE_NAME,   
            A.ORGANIZATION_ID,   
            A.CODE_MEAN_KOR,   
            A.CODE_MEAN_ENG,   
            A.CODE_MEAN_LOCAL,   
            A.CODE_NAME_DESCRIPTION_KOR,   
            A.CODE_NAME_DESCRIPTION_ENG,   
            A.CODE_NAME_DESCRIPTION_LOCAL,   
            A.CODE_TYPE_DESC_KOR,   
            A.CODE_TYPE_DESC_ENG,   
            A.CODE_TYPE_DESC_LOCAL,   
            A.CODE_GROUP,   
            A.ENTER_DATE,   
            A.ENTER_BY,   
            A.LAST_MODIFY_DATE,   
            A.LAST_MODIFY_BY  
       FROM ISYS_BASECODE  A
WHERE  A.CODE_TYPE NOT IN (SELECT CODE_TYPE FROM  ISYS_BASECODE ) ;

if f_sql_check() < 0 then 
	return 
end if 
COMMIT ;
end event

type gb_2 from so_groupbox within w_basecode_master
integer x = 18
integer width = 2432
integer height = 288
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_basecode_master
integer x = 2455
integer width = 2107
integer height = 288
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

