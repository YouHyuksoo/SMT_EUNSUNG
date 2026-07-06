HA$PBExportHeader$w_des_bom_merge_popup.srw
forward
global type w_des_bom_merge_popup from w_popup_root
end type
type gb_2 from so_groupbox within w_des_bom_merge_popup
end type
type cb_1 from so_commandbutton within w_des_bom_merge_popup
end type
type uo_source_parent_item_code1 from uo_set_item_code within w_des_bom_merge_popup
end type
type uo_dest_parent_item_code from uo_set_item_code within w_des_bom_merge_popup
end type
type st_source from so_statictext within w_des_bom_merge_popup
end type
type st_dest from so_statictext within w_des_bom_merge_popup
end type
type uo_dateset from uo_ymd_calendar within w_des_bom_merge_popup
end type
type st_1 from so_statictext within w_des_bom_merge_popup
end type
type ddlb_dest_line_code from uo_line_code within w_des_bom_merge_popup
end type
type st_dest_line_code from so_statictext within w_des_bom_merge_popup
end type
type ddlb_source_line_code from uo_line_code within w_des_bom_merge_popup
end type
type st_source_line_code from so_statictext within w_des_bom_merge_popup
end type
type uo_source_parent_item_code2 from uo_set_item_code within w_des_bom_merge_popup
end type
type st_2 from so_statictext within w_des_bom_merge_popup
end type
end forward

global type w_des_bom_merge_popup from w_popup_root
integer width = 1970
integer height = 1572
string title = "BOM Copy"
gb_2 gb_2
cb_1 cb_1
uo_source_parent_item_code1 uo_source_parent_item_code1
uo_dest_parent_item_code uo_dest_parent_item_code
st_source st_source
st_dest st_dest
uo_dateset uo_dateset
st_1 st_1
ddlb_dest_line_code ddlb_dest_line_code
st_dest_line_code st_dest_line_code
ddlb_source_line_code ddlb_source_line_code
st_source_line_code st_source_line_code
uo_source_parent_item_code2 uo_source_parent_item_code2
st_2 st_2
end type
global w_des_bom_merge_popup w_des_bom_merge_popup

on w_des_bom_merge_popup.create
int iCurrent
call super::create
this.gb_2=create gb_2
this.cb_1=create cb_1
this.uo_source_parent_item_code1=create uo_source_parent_item_code1
this.uo_dest_parent_item_code=create uo_dest_parent_item_code
this.st_source=create st_source
this.st_dest=create st_dest
this.uo_dateset=create uo_dateset
this.st_1=create st_1
this.ddlb_dest_line_code=create ddlb_dest_line_code
this.st_dest_line_code=create st_dest_line_code
this.ddlb_source_line_code=create ddlb_source_line_code
this.st_source_line_code=create st_source_line_code
this.uo_source_parent_item_code2=create uo_source_parent_item_code2
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_2
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.uo_source_parent_item_code1
this.Control[iCurrent+4]=this.uo_dest_parent_item_code
this.Control[iCurrent+5]=this.st_source
this.Control[iCurrent+6]=this.st_dest
this.Control[iCurrent+7]=this.uo_dateset
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.ddlb_dest_line_code
this.Control[iCurrent+10]=this.st_dest_line_code
this.Control[iCurrent+11]=this.ddlb_source_line_code
this.Control[iCurrent+12]=this.st_source_line_code
this.Control[iCurrent+13]=this.uo_source_parent_item_code2
this.Control[iCurrent+14]=this.st_2
end on

on w_des_bom_merge_popup.destroy
call super::destroy
destroy(this.gb_2)
destroy(this.cb_1)
destroy(this.uo_source_parent_item_code1)
destroy(this.uo_dest_parent_item_code)
destroy(this.st_source)
destroy(this.st_dest)
destroy(this.uo_dateset)
destroy(this.st_1)
destroy(this.ddlb_dest_line_code)
destroy(this.st_dest_line_code)
destroy(this.ddlb_source_line_code)
destroy(this.st_source_line_code)
destroy(this.uo_source_parent_item_code2)
destroy(this.st_2)
end on

type p_title from w_popup_root`p_title within w_des_bom_merge_popup
integer width = 1947
end type

type cb_sort from w_popup_root`cb_sort within w_des_bom_merge_popup
integer x = 0
integer y = 1424
integer width = 320
integer height = 140
integer taborder = 70
integer weight = 400
end type

type cb_close from w_popup_root`cb_close within w_des_bom_merge_popup
boolean visible = true
integer x = 960
integer y = 1280
integer width = 320
integer height = 140
integer taborder = 60
integer weight = 400
end type

event cb_close::clicked;call super::clicked;MESSAGE.DOUBLEPARM = -1
end event

type st_msg from w_popup_root`st_msg within w_des_bom_merge_popup
boolean visible = true
integer y = 200
integer width = 1947
end type

type dw_1 from w_popup_root`dw_1 within w_des_bom_merge_popup
boolean visible = true
integer y = 1656
integer taborder = 0
boolean titlebar = true
end type

type dw_2 from w_popup_root`dw_2 within w_des_bom_merge_popup
boolean visible = true
integer y = 1656
integer taborder = 0
end type

type dw_3 from w_popup_root`dw_3 within w_des_bom_merge_popup
integer y = 1424
integer taborder = 80
end type

type gb_2 from so_groupbox within w_des_bom_merge_popup
integer y = 328
integer width = 1947
integer height = 872
integer weight = 700
long textcolor = 16711680
string text = "Copy Condition"
end type

type cb_1 from so_commandbutton within w_des_bom_merge_popup
integer x = 635
integer y = 1280
integer width = 320
integer height = 140
integer taborder = 50
boolean bringtotop = true
integer weight = 400
string text = "Merge"
end type

event clicked;STRING lvs_dest_parent_item_code , lvs_source_parent_item_code1 , lvs_source_parent_item_code2 , lvs_source_line_code , lvs_dest_line_code , lvs_source_machine_code , lvs_dest_machine_code
datetime lvdt_dateset
//====================================================
// $$HEX9$$8cc1a4c220007cb778c7200054cfdcb42000$$ENDHEX$$
//====================================================
lvdt_dateset = uo_dateset.text()

if isnull(ddlb_source_line_code.getcode()) then 	
	f_msgbox1(102 , st_source_line_code.text )
	return
else
	lvs_source_line_code = ddlb_source_line_code.getcode()
end if 

if isnull(ddlb_source_line_code.getcode()) then 	
	f_msgbox1(102 , st_source_line_code.text )
	return
else
	lvs_source_machine_code = ddlb_source_line_code.getcode()
end if 
//==========================================
// $$HEX9$$00b3c1c020007cb778c7200054cfdcb42000$$ENDHEX$$
//==========================================
if isnull(ddlb_dest_line_code.getcode()) then 	
	f_msgbox1(102 , st_dest_line_code.text )
	return
else
	lvs_dest_line_code = ddlb_dest_line_code.getcode()
end if 

if isnull(ddlb_dest_line_code.getcode()) then 	
	f_msgbox1(102 , st_dest_line_code.text )
	return
else
	lvs_dest_machine_code = ddlb_dest_line_code.getcode()
end if 

//===========================================
// $$HEX6$$8cc1a4c2200088d4a9ba2000$$ENDHEX$$1
//===========================================
if isnull(uo_source_parent_item_code1.text()) then 	
	f_msgbox1(102 , st_source.text )
	return
else
	lvs_source_parent_item_code1 = uo_source_parent_item_code1.text()
end if 

//===========================================
// $$HEX6$$8cc1a4c2200088d4a9ba2000$$ENDHEX$$2
//===========================================
if isnull(uo_source_parent_item_code2.text()) then 	
	f_msgbox1(102 , st_source.text )
	return
else
	lvs_source_parent_item_code2 = uo_source_parent_item_code2.text()
end if 

//===========================================
// $$HEX9$$00b3c1c0200088d4a9ba200054cfdcb42000$$ENDHEX$$
//===========================================

if isnull(uo_dest_parent_item_code.text()) then 
	f_msgbox1(102 , st_dest.text )	
	return
else
	lvs_dest_parent_item_code = uo_dest_parent_item_code.text()
end if 

//============================================
// $$HEX3$$8cc1a4c22000$$ENDHEX$$1 2 $$HEX12$$00ac200019ac40c7c0c9200080acacc020005cd5e4b22000$$ENDHEX$$
//============================================
if lvs_source_parent_item_code1 = lvs_source_parent_item_code2 then 
	f_msgbox1(813 , lvs_source_parent_item_code1+'  '+lvs_source_parent_item_code2 )	
	return
end if 

//============================================
//
//============================================
if lvs_source_parent_item_code1 <> lvs_source_parent_item_code2 &
and ( lvs_source_parent_item_code1 = lvs_dest_parent_item_code or lvs_source_parent_item_code2 = lvs_dest_parent_item_code ) &
then 
	f_msgbox1(813 , lvs_dest_parent_item_code )	
	return
end if 

//=============================================
//
//=============================================

INT LVI_COUNT1 , LVI_COUNT2

SELECT COUNT(*)  INTO :LVI_COUNT1
     FROM "ID_ENG_BOM" 
     WHERE PARENT_ITEM_CODE =  :lvs_source_parent_item_code1 
		AND DATESET <= TRUNC(SYSDATE)
		AND DATEEND >= TRUNC(SYSDATE)
		AND LINE_CODE = :lvs_source_line_code
		AND MACHINE = :lvs_source_machine_code
		AND ORGANIZATION_ID = :gvi_organization_id ;
		
		IF F_SQL_CHECK() < 0 THEN 
			RETURN
		END IF 
		
SELECT COUNT(*)  INTO :LVI_COUNT2
     FROM "ID_ENG_BOM" 
     WHERE PARENT_ITEM_CODE =  :lvs_source_parent_item_code2 
		AND DATESET <= TRUNC(SYSDATE)
		AND DATEEND >= TRUNC(SYSDATE)
		AND LINE_CODE = :lvs_source_line_code
		AND MACHINE = :lvs_source_machine_code
		AND ORGANIZATION_ID = :gvi_organization_id ;
		
		IF F_SQL_CHECK() < 0 THEN 
			RETURN
		END IF 		
	
	
	
  INSERT INTO "ID_ENG_BOM"  
         ( "PARENT_ITEM_CODE",   
           "CHILD_ITEM_CODE",   
           "BOM_LEVEL",   
           "DATESET",   
           "DATEEND",   
           "LOCATION_CODE",   
           "ORGANIZATION_ID",   
           "SORT_SEQUENCE",   
           "ITEM_UNIT_QTY",   
           "WORKSTAGE_CODE",   
           "BOM_WORK_NO",   
           "ITEM_TYPE",   
           "LINE_TYPE",   
           "ENTER_BY",   
           "ENTER_DATE",   
           "LAST_MODIFY_BY",   
           "LAST_MODIFY_DATE" ,
		  LINE_CODE , MACHINE )  
     SELECT :lvs_dest_parent_item_code , //"ID_ENG_BOM"."PARENT_ITEM_CODE",   
            "ID_ENG_BOM"."CHILD_ITEM_CODE",   
            "ID_ENG_BOM"."BOM_LEVEL",   
            :lvdt_dateset , //"ID_ENG_BOM"."DATESET",   
            to_date('99991231' , 'yyyymmdd') , //"ID_ENG_BOM"."DATEEND",   
            REPLACE( "ID_ENG_BOM"."LOCATION_CODE",   :lvs_source_line_code||:lvs_source_machine_code , :lvs_dest_line_code||:lvs_dest_machine_code ) ,
            "ID_ENG_BOM"."ORGANIZATION_ID",   
            "ID_ENG_BOM"."SORT_SEQUENCE",   
            "ID_ENG_BOM"."ITEM_UNIT_QTY",   
            "ID_ENG_BOM"."WORKSTAGE_CODE",   
            "ID_ENG_BOM"."BOM_WORK_NO",   
            "ID_ENG_BOM"."ITEM_TYPE",   
            "ID_ENG_BOM"."LINE_TYPE",   
            "ID_ENG_BOM"."ENTER_BY",   
            "ID_ENG_BOM"."ENTER_DATE",   
            "ID_ENG_BOM"."LAST_MODIFY_BY",   
            "ID_ENG_BOM"."LAST_MODIFY_DATE" ,
			:lvs_dest_line_code ,
			:lvs_dest_machine_code
       FROM "ID_ENG_BOM" 
     WHERE PARENT_ITEM_CODE =  :lvs_source_parent_item_code1
		AND DATESET <= TRUNC(SYSDATE)
		AND DATEEND >= TRUNC(SYSDATE)
		AND LINE_CODE = :lvs_source_line_code
		AND MACHINE = :lvs_source_machine_code
		AND ORGANIZATION_ID = :gvi_organization_id ;
		
		IF F_SQL_CHECK() < 0 THEN 
			RETURN
		END IF
		
  INSERT INTO "ID_ENG_BOM"  
         ( "PARENT_ITEM_CODE",   
           "CHILD_ITEM_CODE",   
           "BOM_LEVEL",   
           "DATESET",   
           "DATEEND",   
           "LOCATION_CODE",   
           "ORGANIZATION_ID",   
           "SORT_SEQUENCE",   
           "ITEM_UNIT_QTY",   
           "WORKSTAGE_CODE",   
           "BOM_WORK_NO",   
           "ITEM_TYPE",   
           "LINE_TYPE",   
           "ENTER_BY",   
           "ENTER_DATE",   
           "LAST_MODIFY_BY",   
           "LAST_MODIFY_DATE" ,
		  LINE_CODE , MACHINE )  
     SELECT :lvs_dest_parent_item_code , //"ID_ENG_BOM"."PARENT_ITEM_CODE",   
            "ID_ENG_BOM"."CHILD_ITEM_CODE",   
            "ID_ENG_BOM"."BOM_LEVEL",   
            :lvdt_dateset , //"ID_ENG_BOM"."DATESET",   
            to_date('99991231' , 'yyyymmdd') , //"ID_ENG_BOM"."DATEEND",   
            REPLACE( "ID_ENG_BOM"."LOCATION_CODE",   :lvs_source_line_code||:lvs_source_machine_code , :lvs_dest_line_code||:lvs_dest_machine_code ) ,
            "ID_ENG_BOM"."ORGANIZATION_ID",   
            "ID_ENG_BOM"."SORT_SEQUENCE",   
            "ID_ENG_BOM"."ITEM_UNIT_QTY",   
            "ID_ENG_BOM"."WORKSTAGE_CODE",   
            "ID_ENG_BOM"."BOM_WORK_NO",   
            "ID_ENG_BOM"."ITEM_TYPE",   
            "ID_ENG_BOM"."LINE_TYPE",   
            "ID_ENG_BOM"."ENTER_BY",   
            "ID_ENG_BOM"."ENTER_DATE",   
            "ID_ENG_BOM"."LAST_MODIFY_BY",   
            "ID_ENG_BOM"."LAST_MODIFY_DATE" ,
			:lvs_dest_line_code ,
			:lvs_dest_machine_code
       FROM "ID_ENG_BOM" 
     WHERE PARENT_ITEM_CODE =  :lvs_source_parent_item_code2
		AND DATESET <= TRUNC(SYSDATE)
		AND DATEEND >= TRUNC(SYSDATE)
		AND LINE_CODE = :lvs_source_line_code
		AND MACHINE = :lvs_source_machine_code
		AND ORGANIZATION_ID = :gvi_organization_id ;	
		
		IF F_SQL_CHECK() < 0 THEN 
			RETURN
		END IF
		
MSG = F_MSGBOX1(9046 , STRING(LVI_COUNT1+LVI_COUNT2) )
IF MSG = 1 THEN 
	COMMIT ;
ELSE
	ROLLBACK;
	RETURN ;
END IF
end event

type uo_source_parent_item_code1 from uo_set_item_code within w_des_bom_merge_popup
event destroy ( )
integer x = 539
integer y = 564
integer taborder = 30
boolean bringtotop = true
end type

on uo_source_parent_item_code1.destroy
call uo_set_item_code::destroy
end on

type uo_dest_parent_item_code from uo_set_item_code within w_des_bom_merge_popup
event destroy ( )
integer x = 539
integer y = 820
integer taborder = 40
boolean bringtotop = true
end type

on uo_dest_parent_item_code.destroy
call uo_set_item_code::destroy
end on

type st_source from so_statictext within w_des_bom_merge_popup
integer x = 14
integer y = 568
boolean bringtotop = true
string text = "Source Item Code1"
alignment alignment = right!
end type

type st_dest from so_statictext within w_des_bom_merge_popup
integer x = 14
integer y = 832
boolean bringtotop = true
string text = "Dest Item Code"
alignment alignment = right!
end type

type uo_dateset from uo_ymd_calendar within w_des_bom_merge_popup
integer x = 544
integer y = 928
integer height = 84
integer taborder = 30
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type st_1 from so_statictext within w_des_bom_merge_popup
integer x = 14
integer y = 936
boolean bringtotop = true
string text = "Dateset"
alignment alignment = right!
end type

type ddlb_dest_line_code from uo_line_code within w_des_bom_merge_popup
integer x = 544
integer y = 1028
integer width = 786
integer taborder = 60
boolean bringtotop = true
boolean autohscroll = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

type st_dest_line_code from so_statictext within w_des_bom_merge_popup
integer x = 14
integer y = 1040
integer height = 68
boolean bringtotop = true
boolean enabled = false
string text = "Dest Line Code"
alignment alignment = right!
end type

type ddlb_source_line_code from uo_line_code within w_des_bom_merge_popup
integer x = 539
integer y = 464
integer width = 786
integer taborder = 70
boolean bringtotop = true
boolean allowedit = true
boolean autohscroll = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

type st_source_line_code from so_statictext within w_des_bom_merge_popup
integer x = 5
integer y = 468
integer height = 68
boolean bringtotop = true
boolean enabled = false
string text = "Source Line Code"
alignment alignment = right!
end type

type uo_source_parent_item_code2 from uo_set_item_code within w_des_bom_merge_popup
event destroy ( )
integer x = 539
integer y = 664
integer taborder = 40
boolean bringtotop = true
end type

on uo_source_parent_item_code2.destroy
call uo_set_item_code::destroy
end on

type st_2 from so_statictext within w_des_bom_merge_popup
integer x = 14
integer y = 668
boolean bringtotop = true
string text = "Source Item Code2"
alignment alignment = right!
end type

