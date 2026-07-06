HA$PBExportHeader$w_mat_requirment_plan_master.srw
$PBExportComments$$$HEX6$$1dcd8cc194c6c9b700adacb9$$ENDHEX$$
forward
global type w_mat_requirment_plan_master from w_main_root
end type
type uo_item from uo_item_code within w_mat_requirment_plan_master
end type
type st_5 from so_statictext within w_mat_requirment_plan_master
end type
type cb_1 from so_commandbutton within w_mat_requirment_plan_master
end type
type rb_master_plan from so_radiobutton within w_mat_requirment_plan_master
end type
type rb_requirment_plan from so_radiobutton within w_mat_requirment_plan_master
end type
type uo_dateset from uo_ymd_calendar within w_mat_requirment_plan_master
end type
type st_1 from so_statictext within w_mat_requirment_plan_master
end type
type rb_1 from so_radiobutton within w_mat_requirment_plan_master
end type
type rb_2 from so_radiobutton within w_mat_requirment_plan_master
end type
type rb_3 from so_radiobutton within w_mat_requirment_plan_master
end type
type rb_requirment_plan_matrix from so_radiobutton within w_mat_requirment_plan_master
end type
type ddlb_supplier_code from uo_supplier_code within w_mat_requirment_plan_master
end type
type st_2 from so_statictext within w_mat_requirment_plan_master
end type
type cb_2 from so_commandbutton within w_mat_requirment_plan_master
end type
type uo_plan_start from uo_ymd_calendar within w_mat_requirment_plan_master
end type
type uo_plan_end from uo_ymd_calendar within w_mat_requirment_plan_master
end type
type st_3 from so_statictext within w_mat_requirment_plan_master
end type
type cb_inventory_set from so_commandbutton within w_mat_requirment_plan_master
end type
type cb_3 from so_commandbutton within w_mat_requirment_plan_master
end type
type rb_5 from so_radiobutton within w_mat_requirment_plan_master
end type
type gb_where_condition from so_groupbox within w_mat_requirment_plan_master
end type
type gb_1 from so_groupbox within w_mat_requirment_plan_master
end type
type gb_2 from so_groupbox within w_mat_requirment_plan_master
end type
type gb_3 from so_groupbox within w_mat_requirment_plan_master
end type
end forward

global type w_mat_requirment_plan_master from w_main_root
integer width = 5550
integer height = 2860
string title = "Material Requirement Plan Master"
uo_item uo_item
st_5 st_5
cb_1 cb_1
rb_master_plan rb_master_plan
rb_requirment_plan rb_requirment_plan
uo_dateset uo_dateset
st_1 st_1
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
rb_requirment_plan_matrix rb_requirment_plan_matrix
ddlb_supplier_code ddlb_supplier_code
st_2 st_2
cb_2 cb_2
uo_plan_start uo_plan_start
uo_plan_end uo_plan_end
st_3 st_3
cb_inventory_set cb_inventory_set
cb_3 cb_3
rb_5 rb_5
gb_where_condition gb_where_condition
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_mat_requirment_plan_master w_mat_requirment_plan_master

on w_mat_requirment_plan_master.create
int iCurrent
call super::create
this.uo_item=create uo_item
this.st_5=create st_5
this.cb_1=create cb_1
this.rb_master_plan=create rb_master_plan
this.rb_requirment_plan=create rb_requirment_plan
this.uo_dateset=create uo_dateset
this.st_1=create st_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.rb_requirment_plan_matrix=create rb_requirment_plan_matrix
this.ddlb_supplier_code=create ddlb_supplier_code
this.st_2=create st_2
this.cb_2=create cb_2
this.uo_plan_start=create uo_plan_start
this.uo_plan_end=create uo_plan_end
this.st_3=create st_3
this.cb_inventory_set=create cb_inventory_set
this.cb_3=create cb_3
this.rb_5=create rb_5
this.gb_where_condition=create gb_where_condition
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_item
this.Control[iCurrent+2]=this.st_5
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.rb_master_plan
this.Control[iCurrent+5]=this.rb_requirment_plan
this.Control[iCurrent+6]=this.uo_dateset
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.rb_1
this.Control[iCurrent+9]=this.rb_2
this.Control[iCurrent+10]=this.rb_3
this.Control[iCurrent+11]=this.rb_requirment_plan_matrix
this.Control[iCurrent+12]=this.ddlb_supplier_code
this.Control[iCurrent+13]=this.st_2
this.Control[iCurrent+14]=this.cb_2
this.Control[iCurrent+15]=this.uo_plan_start
this.Control[iCurrent+16]=this.uo_plan_end
this.Control[iCurrent+17]=this.st_3
this.Control[iCurrent+18]=this.cb_inventory_set
this.Control[iCurrent+19]=this.cb_3
this.Control[iCurrent+20]=this.rb_5
this.Control[iCurrent+21]=this.gb_where_condition
this.Control[iCurrent+22]=this.gb_1
this.Control[iCurrent+23]=this.gb_2
this.Control[iCurrent+24]=this.gb_3
end on

on w_mat_requirment_plan_master.destroy
call super::destroy
destroy(this.uo_item)
destroy(this.st_5)
destroy(this.cb_1)
destroy(this.rb_master_plan)
destroy(this.rb_requirment_plan)
destroy(this.uo_dateset)
destroy(this.st_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.rb_requirment_plan_matrix)
destroy(this.ddlb_supplier_code)
destroy(this.st_2)
destroy(this.cb_2)
destroy(this.uo_plan_start)
destroy(this.uo_plan_end)
destroy(this.st_3)
destroy(this.cb_inventory_set)
destroy(this.cb_3)
destroy(this.rb_5)
destroy(this.gb_where_condition)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event activate;call super::activate;/***************************************
* Window Default Property 
****************************************/
Gst_set.window_id            = this.classname() 
Gst_set.author                  = "JiSheng"
Gst_set.creation_date      = '20051101'
Gst_set.last_modify_date = '20051101'
Gst_set.Report_window    = False  // Report Window  True / Flase

/*****************************************
* Data Window Property
******************************************/
Ivs_resize_type                      = 'NORMAL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
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

IF RB_MASTER_PLAN.CHECKED = TRUE THEN
	f_menu_control('DATA_CONTROL' , TRUE)  // $$HEX9$$70b374c7c0d0200070c891c788bd00ac0900$$ENDHEX$$
ELSE
	f_menu_control('DATA_CONTROL' , FALSE)  // $$HEX8$$70b374c7c0d0200070c891c788bd00ac$$ENDHEX$$
END IF
/****************************************
* $$HEX11$$70b374c7c0d0200008c7c4b3b0c6200078d5e4b4c1b9$$ENDHEX$$
****************************************/

end event

event ue_data_control;call super::ue_data_control;Long ROW
CHOOSE CASE Gvs_Ue_DATA_control
	CASE 'RETRIEVE'
		 
		   IF RB_MASTER_PLAN.CHECKED = TRUE THEN 
				
				cb_inventory_set.TRIGGEREVENT(CLICKED!)	
				
				DW_1.BRINGTOTOP = TRUE
				DW_1.RETRIEVE( UO_DATESET.TEXT() , uo_item.TEXT+'%'  , GVI_ORGANIZATION_ID  )

		    ELSEIF rb_requirment_plan.CHECKED = TRUE THEN
				
				DW_2.BRINGTOTOP = TRUE
				DW_2.RETRIEVE( UO_DATESET.TEXT() , DDLB_SUPPLIER_CODE.TEXT+'%', UO_ITEM.TEXT()+'%' , GVI_ORGANIZATION_ID  )
				
             ELSE
					
				DW_3.BRINGTOTOP = TRUE
				DW_3.RETRIEVE( UO_DATESET.TEXT() , DDLB_SUPPLIER_CODE.TEXT+'%', UO_ITEM.TEXT()+'%' , UO_PLAN_START.TEXT() ,UO_PLAN_END.TEXT() ,  GVI_ORGANIZATION_ID  )
				f_child_dw3(dw_3, 'line_type', gvs_language, string(gvi_organization_id), 'LINE TYPE')	
					
			END IF

	CASE 'INSERT'
			ROW = DW_1.INSERTROW(DW_1.GETROW())
			DW_1.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_1 , ROW , 'ALL')
			
			DW_1.SETITEM( ROW, 'requirment_plan_date' , UO_DATESET.TEXT() )
			DW_1.SETITEM( ROW, 'requirment_plan_seq' ,  f_get_requirment_plan_seq() )	
			F_MSG_ST(152)
	CASE 'APPEND'
			ROW = DW_1.INSERTROW(0)
			DW_1.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_1 , ROW , 'ALL')	
			DW_1.SETITEM( ROW, 'requirment_plan_date' , UO_DATESET.TEXT() )		
    			DW_1.SETITEM( ROW, 'requirment_plan_seq' , f_get_requirment_plan_seq() )	
			F_MSG_ST(152)			
	CASE 'DELETE'
		  	IF DW_1.GETROW() < 1 THEN RETURN 
			  
			MSG = F_MSGBOX(1003) 
			IF MSG = 1 THEN
				GVL_ROW_DELETED = DW_1.GETROW()			
				DW_1.DELETEROW(GVL_ROW_DELETED)		
				DW_1.SETFOCUS()
				ROW = DW_1.GETROW()
				DW_1.SCROLLTOROW(ROW)
				DW_1.SETCOLUMN(1)
			END IF
			
	CASE 'UPDATE'
		    
			IF rb_requirment_plan.CHECKED = TRUE THEN 
					IF DW_2.UPDATE() < 0 THEN
					ROLLBACK;
				ELSE
					 COMMIT;
					 F_MSG_ST(170) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
				END IF											
			ELSE
			 
					IF DW_1.UPDATE() < 0 THEN
					ROLLBACK;
				ELSE
					 COMMIT;
					 F_MSG_ST(170) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
				END IF							
				
			END IF
			
			
	CASE ELSE
END CHOOSE
end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
uo_plan_start.settext(string(f_t_sysdate(), 'yyyy/mm')+'/01')
end event

type dw_5 from w_main_root`dw_5 within w_mat_requirment_plan_master
integer y = 576
end type

type dw_4 from w_main_root`dw_4 within w_mat_requirment_plan_master
integer y = 576
end type

type dw_3 from w_main_root`dw_3 within w_mat_requirment_plan_master
integer y = 576
integer width = 4507
integer height = 1976
boolean titlebar = true
string title = "Requirment Plan Matrix Master"
string dataobject = "d_mat_requirment_plan_matrix_lst"
end type

type dw_2 from w_main_root`dw_2 within w_mat_requirment_plan_master
integer y = 576
integer width = 4507
integer height = 1976
boolean titlebar = true
string title = "Requirment Plan Master"
string dataobject = "d_mat_requirment_plan_lst"
end type

event dw_2::rbuttondown;call super::rbuttondown;STRING LVS_ITEM_CODE
IF ROW < 1 THEN RETURN

IF DWO.NAME = 'item_code' or DWO.NAME = 'supplier_code'  THEN 

	LVS_ITEM_CODE = THIS.OBJECT.ITEM_CODE[ROW]
	
	OPENWITHPARM( W_MAT_SUPPLIER_BY_ITEM_CODE_POPUP , LVS_ITEM_CODE )
	IF message.stringparm = '' THEN 
	ELSE	
		THIS.SETITEM( ROW , 'supplier_code' ,  message.stringparm )	
		POST EVENT ITEMCHANGED( ROW , THIS.OBJECT.supplier_code , THIS.OBJECT.supplier_code[ROW])			
	END IF		
	
END IF
end event

type dw_1 from w_main_root`dw_1 within w_mat_requirment_plan_master
integer y = 576
integer width = 4507
integer height = 1976
boolean titlebar = true
string title = "Master Plan For Requirment"
string dataobject = "d_mat_master_plan_4_requirment_lst"
end type

event dw_1::rbuttondown;call super::rbuttondown;IF DWO.NAME = 'item_code' THEN
	OPEN(W_DES_SET_ITEM_POPUP)
	
	IF message.stringparm = '' THEN 
		RETURN
	END IF
	THIS.SETITEM( ROW , 'item_code' , MESSAGE.STRINGPARM )			
	THIS.SETITEM( ROW , 'item_name' , Gst_return.Gvs_return[3] )			
	THIS.SETITEM( ROW , 'item_spec' , Gst_return.Gvs_return[4] )			
	THIS.SETITEM( ROW , 'item_uom' , Gst_return.Gvs_return[5] )			
	Gst_return.Gvs_return[3]  = ''
	Gst_return.Gvs_return[4]  = ''
	Gst_return.Gvs_return[5]  = ''	
END IF
end event

event dw_1::itemchanged;call super::itemchanged;String lvs_return
if dwo.name = 'item_code' then 
   lvs_return = f_set_item_name_spec_uom( this , row , this.object.item_code[row] )		
   if 	lvs_return = 'ERROR' THEN 
		return 1
   end if	
	if lvs_return = 'NOTFOUND' then 
		return 1  
	end if 		
end if
end event

type uo_tabpages from w_main_root`uo_tabpages within w_mat_requirment_plan_master
end type

type uo_item from uo_item_code within w_mat_requirment_plan_master
integer x = 937
integer y = 176
integer width = 539
integer height = 92
integer taborder = 90
boolean bringtotop = true
end type

on uo_item.destroy
call uo_item_code::destroy
end on

type st_5 from so_statictext within w_mat_requirment_plan_master
integer x = 937
integer y = 108
integer width = 539
integer height = 56
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Item Code"
end type

type cb_1 from so_commandbutton within w_mat_requirment_plan_master
integer x = 2363
integer y = 80
integer width = 457
integer height = 168
integer taborder = 30
boolean bringtotop = true
string text = "Generate"
end type

event clicked;IF F_OBJECT_ROLE_CHECK() = FALSE THEN  RETURN
LONG     I , LVL_COUNT
DOUBLE   LVDB_SESSION_ID , LVDB_REQ_SESSION_ID
STRING   LVS_ITEM_CODE 
DECIMAL  LVF_ORDER_QTY
DATETIME LVD_REQUIRMENT_PLAN_DATE , LVS_PLAN_DATE

  LVD_REQUIRMENT_PLAN_DATE = uo_dateset.text() ;	
  
	 SELECT COUNT(*) INTO :LVL_COUNT
		 FROM IM_ITEM_MASTER_PLAN_4_REQUIR
		WHERE REQUIRMENT_PLAN_DATE = :LVD_REQUIRMENT_PLAN_DATE
		  AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;	  
		  
	 IF F_SQL_CHECK() < 0 THEN 
		 RETURN
	 END IF
	 
	 IF LVL_COUNT = 0 THEN 
		 F_MSGbox1(9011 , string(LVD_REQUIRMENT_PLAN_DATE,'yyyymmdd')+' '+rb_master_plan.text ) //@ $$HEX8$$90c7ccb800ac2000c6c5b5c2c8b2e4b2$$ENDHEX$$
		 RETURN
	 END IF
	 
LVDB_REQ_SESSION_ID = f_get_sequence	( 'SEQ_REQUIRMENT_PLAN')
F_MSG_MDI_HELP("Session ID = "+STRING(LVDB_REQ_SESSION_ID))
//===================================================================================	
//  $$HEX10$$7cc790c7c4bc5cb82000c4ac8dd6200069d5c4ac$$ENDHEX$$
//===================================================================================	

  INSERT INTO "IM_ITEM_MASTER_PLAN_4_REQUIR_S"  
         ( "REQUIRMENT_PLAN_DATE",   
           "PLAN_DATE",   
           "ORGANIZATION_ID",   
           "ORDER_QTY",   
           "TOTAL_INVENTORY_QTY",   
           "INVENTORY_QTY",   
           "SAFETY_INVENTORY_QTY",   
           "ITEM_CODE",   
           "APPLY_YN",   
           "ENTER_BY",   
           "ENTER_DATE",   
           "LAST_MODIFY_BY",   
           "LAST_MODIFY_DATE",   
           "SESSION_ID" )  
     SELECT "IM_ITEM_MASTER_PLAN_4_REQUIR"."REQUIRMENT_PLAN_DATE",   
            "IM_ITEM_MASTER_PLAN_4_REQUIR"."PLAN_DATE",   
            "IM_ITEM_MASTER_PLAN_4_REQUIR"."ORGANIZATION_ID",   
            SUM("IM_ITEM_MASTER_PLAN_4_REQUIR"."ORDER_QTY"),   
            AVG("IM_ITEM_MASTER_PLAN_4_REQUIR"."TOTAL_INVENTORY_QTY"),   
            AVG("IM_ITEM_MASTER_PLAN_4_REQUIR"."INVENTORY_QTY"),   
            AVG("IM_ITEM_MASTER_PLAN_4_REQUIR"."SAFETY_INVENTORY_QTY"),   
            "IM_ITEM_MASTER_PLAN_4_REQUIR"."ITEM_CODE",   
            MAX("IM_ITEM_MASTER_PLAN_4_REQUIR"."APPLY_YN"),   
            MAX("IM_ITEM_MASTER_PLAN_4_REQUIR"."ENTER_BY"),   
            MAX("IM_ITEM_MASTER_PLAN_4_REQUIR"."ENTER_DATE"),   
            MAX("IM_ITEM_MASTER_PLAN_4_REQUIR"."LAST_MODIFY_BY"),   
            MAX("IM_ITEM_MASTER_PLAN_4_REQUIR"."LAST_MODIFY_DATE"),   
            :LVDB_REQ_SESSION_ID 
       FROM "IM_ITEM_MASTER_PLAN_4_REQUIR" 
     WHERE  REQUIRMENT_PLAN_DATE = :LVD_REQUIRMENT_PLAN_DATE
	     AND ORGANIZATION_ID      = :GVI_ORGANIZATION_ID 
	GROUP BY 	"IM_ITEM_MASTER_PLAN_4_REQUIR"."REQUIRMENT_PLAN_DATE",   
      	  "IM_ITEM_MASTER_PLAN_4_REQUIR"."ITEM_CODE", 
            "IM_ITEM_MASTER_PLAN_4_REQUIR"."PLAN_DATE",   
            "IM_ITEM_MASTER_PLAN_4_REQUIR"."ORGANIZATION_ID" ;

		 IF F_SQL_CHECK() < 0 THEN
               RETURN 
		 END IF

     DELETE FROM IM_ITEM_MASTER_PLAN_4_REQUIR 
     WHERE  REQUIRMENT_PLAN_DATE <= :LVD_REQUIRMENT_PLAN_DATE
	     AND ORGANIZATION_ID      = :GVI_ORGANIZATION_ID  ;

		 IF F_SQL_CHECK() < 0 THEN
               RETURN 
		 END IF
		 
      INSERT INTO "IM_ITEM_MASTER_PLAN_4_REQUIR"  
         ( "REQUIRMENT_PLAN_DATE",   
		 "REQUIRMENT_PLAN_SEQ",   
           "PLAN_DATE",   
           "ORGANIZATION_ID",   
           "ORDER_QTY",   
           "TOTAL_INVENTORY_QTY",   
           "INVENTORY_QTY",   
           "SAFETY_INVENTORY_QTY",   
           "ITEM_CODE",   
           "APPLY_YN",   
           "ENTER_BY",   
           "ENTER_DATE",   
           "LAST_MODIFY_BY",   
           "LAST_MODIFY_DATE" )  
     SELECT "IM_ITEM_MASTER_PLAN_4_REQUIR_S"."REQUIRMENT_PLAN_DATE",
	       SEQ_REQUIRMENT_PLAN_SEQ.NEXTVAL ,
            "IM_ITEM_MASTER_PLAN_4_REQUIR_S"."PLAN_DATE",   
            "IM_ITEM_MASTER_PLAN_4_REQUIR_S"."ORGANIZATION_ID",   
            "IM_ITEM_MASTER_PLAN_4_REQUIR_S"."ORDER_QTY",   
            "IM_ITEM_MASTER_PLAN_4_REQUIR_S"."TOTAL_INVENTORY_QTY",   
            "IM_ITEM_MASTER_PLAN_4_REQUIR_S"."INVENTORY_QTY",   
            "IM_ITEM_MASTER_PLAN_4_REQUIR_S"."SAFETY_INVENTORY_QTY",   
            "IM_ITEM_MASTER_PLAN_4_REQUIR_S"."ITEM_CODE",   
            "IM_ITEM_MASTER_PLAN_4_REQUIR_S"."APPLY_YN",   
            "IM_ITEM_MASTER_PLAN_4_REQUIR_S"."ENTER_BY",   
            "IM_ITEM_MASTER_PLAN_4_REQUIR_S"."ENTER_DATE",   
            "IM_ITEM_MASTER_PLAN_4_REQUIR_S"."LAST_MODIFY_BY",   
            "IM_ITEM_MASTER_PLAN_4_REQUIR_S"."LAST_MODIFY_DATE"  
       FROM "IM_ITEM_MASTER_PLAN_4_REQUIR_S"
     WHERE SESSION_ID = 	:LVDB_REQ_SESSION_ID	
	   AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
		 
		 IF F_SQL_CHECK() < 0 THEN
               RETURN 
		 END IF		 

       DELETE FROM IM_ITEM_MASTER_PLAN_4_REQUIR_S 
	  WHERE SESSION_ID = 	:LVDB_REQ_SESSION_ID	
	        AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
		 IF F_SQL_CHECK() < 0 THEN
               RETURN 
		 END IF
  
  DECLARE CL_PLAN CURSOR FOR
    SELECT ITEM_CODE , PLAN_DATE , ORDER_QTY
      FROM IM_ITEM_MASTER_PLAN_4_REQUIR
	WHERE REQUIRMENT_PLAN_DATE = :LVD_REQUIRMENT_PLAN_DATE
	     AND ORGANIZATION_ID      = :GVI_ORGANIZATION_ID ;
		  
	 SELECT COUNT(*) INTO :LVL_COUNT
		 FROM IM_ITEM_MASTER_PLAN_4_REQUIR
		WHERE REQUIRMENT_PLAN_DATE = :LVD_REQUIRMENT_PLAN_DATE
		  AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;	  
		  
	 IF F_SQL_CHECK() < 0 THEN 
		 RETURN
	 END IF
OPEN(w_progress_popup)
w_progress_popup.F_SET_RANGE( 0 , LVL_COUNT  + 3 )
w_progress_popup.f_setstep( 1)
			  
	 IF LVL_COUNT = 0 THEN 
		 F_MSGbox1(9011 , string(LVD_REQUIRMENT_PLAN_DATE,'yyyymmdd')+' '+rb_master_plan.text ) //@ $$HEX8$$90c7ccb800ac2000c6c5b5c2c8b2e4b2$$ENDHEX$$
		 RETURN
	 END IF
	 
      LVDB_REQ_SESSION_ID = f_get_sequence	( 'SEQ_REQUIRMENT_PLAN')
	 F_MSG_MDI_HELP("Session ID = "+STRING(LVDB_REQ_SESSION_ID))

	OPEN CL_PLAN ;  
	IF F_SQL_CHECK() < 0 THEN
		CLOSE CL_PLAN ;
		RETURN
	END IF
//===================================================================================	
  DO 
		 FETCH CL_PLAN INTO :LVS_ITEM_CODE , :LVS_PLAN_DATE  , :LVF_ORDER_QTY ;
		 
		 IF F_SQL_CHECK() < 0 THEN
			 CLOSE CL_PLAN ;
			 EXIT
		 END IF
		  
		 IF SQLCA.SQLCODE = 100 THEN 
			  CLOSE CL_PLAN;
			  EXIT
		 END IF
		 
 		 I++
		  
	    LVDB_SESSION_ID = SQLCA.BOM_EXPLOSION( LVS_ITEM_CODE , LVS_PLAN_DATE , DOUBLE(GVI_ORGANIZATION_ID) ) ;  
         IF F_SQL_CHECK() < 0 THEN
			 CLOSE CL_PLAN ;
			 EXIT 
		 END IF
		 
		   INSERT INTO "IM_ITEM_REQUIRMENT_PLAN_TEMP"  
				( "SESSION_ID",
				  "REQUIRMENT_PLAN_DATE",   
				  "ITEM_CODE",   "LINE_TYPE" ,
				  "SUPPLIER_CODE",   
				  "ORGANIZATION_ID",   
				  "PLAN_DATE",   
				  "REQUIRMENT_QTY",   
				  "ENTER_BY",   
				  "ENTER_DATE",   
				  "LAST_MODIFY_BY",   
				  "LAST_MODIFY_DATE" 
				 )  
			SELECT :LVDB_REQ_SESSION_ID ,
					:LVD_REQUIRMENT_PLAN_DATE ,
					CHILD_ITEM_CODE, LINE_TYPE , 
					'*' ,
					ORGANIZATION_ID ,
					:LVS_PLAN_DATE ,
					MODEL_UNIT_QTY * :LVF_ORDER_QTY,
					:GVS_USER_ID ,SYSDATE,:GVS_USER_ID ,SYSDATE
				FROM ID_ENG_BOM_TEMP 
		WHERE SESSION_ID = :LVDB_SESSION_ID 
		     AND LINE_TYPE IN ( 'G' , 'D' , 'N' , 'S' , 'M' ,'F' , 'B' ) ;
				
		 IF F_SQL_CHECK() < 0 THEN 
			 RETURN 
		 END IF
		 
		 DELETE FROM ID_ENG_BOM_TEMP WHERE SESSION_ID = :LVDB_SESSION_ID ;
		 
		 IF F_SQL_CHECK() < 0 THEN 
			 RETURN 
		 END IF
w_progress_popup.f_STEPIT()				 

  LOOP UNTIL I = LVL_COUNT

 IF I = 0 THEN 
	 
	 F_MSG_ST( 117  ) // $$HEX9$$90c7ccb800ac2000c6c5b5c2c8b2e4b22000$$ENDHEX$$
	
 ELSE
	
	    DELETE FROM IM_ITEM_REQUIRMENT_PLAN
		  WHERE REQUIRMENT_PLAN_DATE = :LVD_REQUIRMENT_PLAN_DATE
		    AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
w_progress_popup.f_STEPIT()					 
		 IF F_SQL_CHECK() < 0 THEN 
			 RETURN 
		 END IF	 
	
	    INSERT INTO "IM_ITEM_REQUIRMENT_PLAN"  
				( "REQUIRMENT_PLAN_DATE",   
				  "ITEM_CODE",   "LINE_TYPE" , 
				  "SUPPLIER_CODE",   
				  "ORGANIZATION_ID",   
				  "PLAN_DATE",   
				  "REQUIRMENT_QTY",   
				  "ENTER_BY",   
				  "ENTER_DATE",   
				  "LAST_MODIFY_BY",   
				  "LAST_MODIFY_DATE")
        SELECT "REQUIRMENT_PLAN_DATE",   
				  "ITEM_CODE",   "LINE_TYPE" , 
				  F_GET_MAX_SUPPLIER_BY_ITEM( ITEM_CODE , ORGANIZATION_ID ) SUPPLIER_CODE,   
				  "ORGANIZATION_ID",   
				  "PLAN_DATE",   
				  SUM("REQUIRMENT_QTY"),   
				  MAX("ENTER_BY"),   
				  MAX("ENTER_DATE"),   
				  MAX("LAST_MODIFY_BY"),   
				  MAX("LAST_MODIFY_DATE")
		 FROM IM_ITEM_REQUIRMENT_PLAN_TEMP
         WHERE SESSION_ID = :LVDB_REQ_SESSION_ID			 
	     GROUP BY REQUIRMENT_PLAN_DATE , ITEM_CODE ,LINE_TYPE , SUPPLIER_CODE ,  ORGANIZATION_ID , PLAN_DATE ;
w_progress_popup.f_STEPIT()			
		 IF F_SQL_CHECK() < 0 THEN 
			 RETURN 
		 END IF
		 
		 DELETE FROM IM_ITEM_REQUIRMENT_PLAN_TEMP
          WHERE SESSION_ID = :LVDB_REQ_SESSION_ID ;
w_progress_popup.f_STEPIT()						 
		 IF F_SQL_CHECK() < 0 THEN 
			 RETURN 
		 END IF	
//==========================
// Progress Close
//==========================
Close(w_progress_popup)
//==========================

	    Msg= F_MSGbox1( 9014 , STRING(SQLCA.SQLNROWS)) ;
		 IF MSG = 1 THEN 
			 COMMIT ;
          F_MSGBOX(170) // $$HEX25$$74d5f9b2200090c7ccb800ac200031c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b20900090009002000$$ENDHEX$$
		ELSE
			 ROLLBACK;
          F_MSGBOX(173) // $$HEX19$$90c7ccb800ac200000c8a5c7d0c52000e4c228d3200088d5b5c2c8b2e4b20900090009002000$$ENDHEX$$
		END IF
		
 END IF

end event

type rb_master_plan from so_radiobutton within w_mat_requirment_plan_master
integer x = 50
integer y = 440
integer width = 645
integer height = 52
boolean bringtotop = true
integer weight = 700
string text = "Master Plan"
boolean checked = true
end type

event clicked;DW_1.BRINGTOTOP = TRUE
SELECTED_DATA_WINDOW = PARENT.DW_1
IF RB_MASTER_PLAN.CHECKED = TRUE THEN
	f_menu_control('DATA_CONTROL' , TRUE)  // $$HEX9$$70b374c7c0d0200070c891c788bd00ac0900$$ENDHEX$$
ELSE
	f_menu_control('DATA_CONTROL' , FALSE)  // $$HEX8$$70b374c7c0d0200070c891c788bd00ac$$ENDHEX$$
END IF
end event

type rb_requirment_plan from so_radiobutton within w_mat_requirment_plan_master
integer x = 512
integer y = 440
integer width = 645
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Required Qty"
end type

event clicked;DW_2.BRINGTOTOP = TRUE
SELECTED_DATA_WINDOW = PARENT.DW_2
IF RB_MASTER_PLAN.CHECKED = TRUE THEN
	f_menu_control('DATA_CONTROL' , TRUE)  // $$HEX9$$70b374c7c0d0200070c891c788bd00ac0900$$ENDHEX$$
ELSE
	f_menu_control('DATA_CONTROL' , FALSE)  // $$HEX8$$70b374c7c0d0200070c891c788bd00ac$$ENDHEX$$
END IF
end event

type uo_dateset from uo_ymd_calendar within w_mat_requirment_plan_master
integer x = 37
integer y = 176
integer width = 402
integer taborder = 80
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type st_1 from so_statictext within w_mat_requirment_plan_master
integer x = 41
integer y = 112
integer width = 407
integer height = 56
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Req Plan Date"
end type

type rb_1 from so_radiobutton within w_mat_requirment_plan_master
integer x = 1733
integer y = 484
integer width = 722
integer height = 52
boolean bringtotop = true
integer weight = 700
string text = "From Model Master"
end type

event clicked;OPENWITHPARM(W_DES_SET_ITEM_SELECT_POPUP , DW_1 )
end event

type rb_2 from so_radiobutton within w_mat_requirment_plan_master
integer x = 2523
integer y = 468
integer width = 750
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "From Master Plan"
end type

event clicked;OPENWITHPARM(W_DES_MODEL_SELECT_FROM_MASTER_PLAN_POP , DW_1 )
end event

type rb_3 from so_radiobutton within w_mat_requirment_plan_master
integer x = 1733
integer y = 408
integer width = 722
integer height = 52
boolean bringtotop = true
integer weight = 700
string text = "Manual Input"
boolean checked = true
end type

type rb_requirment_plan_matrix from so_radiobutton within w_mat_requirment_plan_master
integer x = 992
integer y = 440
integer width = 649
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Required Qty(Matrix)"
end type

event clicked;DW_3.BRINGTOTOP = TRUE
SELECTED_DATA_WINDOW = PARENT.DW_3
IF RB_MASTER_PLAN.CHECKED = TRUE THEN
	f_menu_control('DATA_CONTROL' , TRUE)  // $$HEX9$$70b374c7c0d0200070c891c788bd00ac0900$$ENDHEX$$
ELSE
	f_menu_control('DATA_CONTROL' , FALSE)  // $$HEX8$$70b374c7c0d0200070c891c788bd00ac$$ENDHEX$$
END IF
end event

type ddlb_supplier_code from uo_supplier_code within w_mat_requirment_plan_master
integer x = 453
integer y = 176
integer width = 480
integer taborder = 100
boolean bringtotop = true
end type

event rbuttondown;call super::rbuttondown;THIS.TRIGGEREVENT(SELECTIONCHANGED!)
end event

type st_2 from so_statictext within w_mat_requirment_plan_master
integer x = 448
integer y = 108
integer width = 466
integer height = 56
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Supplier Code"
end type

type cb_2 from so_commandbutton within w_mat_requirment_plan_master
integer x = 2825
integer y = 80
integer width = 457
integer height = 168
integer taborder = 40
boolean bringtotop = true
string text = "Show BOM"
end type

event clicked;string lvs_item_code

if dw_1.getrow() < 1 then return

lvs_item_code = dw_1.getitemstring( dw_1.getrow() , 'item_code' )
if lvs_item_code = '' or isnull(lvs_item_code) then return

openwithparm( w_des_bom_query_popup , lvs_item_code )
end event

type uo_plan_start from uo_ymd_calendar within w_mat_requirment_plan_master
integer x = 1481
integer y = 172
integer width = 402
integer taborder = 90
boolean bringtotop = true
end type

on uo_plan_start.destroy
call uo_ymd_calendar::destroy
end on

type uo_plan_end from uo_ymd_calendar within w_mat_requirment_plan_master
integer x = 1893
integer y = 172
integer width = 402
integer taborder = 100
boolean bringtotop = true
end type

on uo_plan_end.destroy
call uo_ymd_calendar::destroy
end on

type st_3 from so_statictext within w_mat_requirment_plan_master
integer x = 1495
integer y = 112
integer width = 786
integer height = 56
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Plan Date"
end type

type cb_inventory_set from so_commandbutton within w_mat_requirment_plan_master
integer x = 3287
integer y = 80
integer width = 457
integer height = 168
integer taborder = 50
boolean bringtotop = true
string text = "Product Inv Set"
end type

event clicked;DATETIME LVD_REQUIRMENT_PLAN_DATE
STRING LVS_ITEM_CODE , LVS_ROWID  , LVS_INV_ROWID
LONG    LVL_ORDER_QTY , LVL_INVENTORY_QTY , LVL_SAFETY_INVENTORY_QTY , I


LVD_REQUIRMENT_PLAN_DATE = uo_dateset.text() 

DECLARE CL1 CURSOR FOR 
	SELECT ITEM_CODE , ORDER_QTY ,  ROWID 
	  FROM IM_ITEM_MASTER_PLAN_4_REQUIR
	WHERE   REQUIRMENT_PLAN_DATE = :LVD_REQUIRMENT_PLAN_DATE 
		AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID  
	ORDER BY PLAN_DATE , ITEM_CODE  ;
	
//=====================================================
// $$HEX4$$acc7e0acddc031c1$$ENDHEX$$
//=====================================================

UPDATE IM_ITEM_MASTER_PLAN_4_REQUIR 
       SET TOTAL_INVENTORY_QTY = 0 , 
		    INVENTORY_QTY  = 0 ,
		    SAFETY_INVENTORY_QTY = 0
 WHERE  REQUIRMENT_PLAN_DATE = TRUNC(:LVD_REQUIRMENT_PLAN_DATE )
      AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID  ;
		
 IF F_SQL_CHECK() < 0 THEN 
	RETURN
END IF		

IF SQLCA.SQLNROWS < 1 THEN 
	f_msg_mdi_help( f_msg_st(9026) )
//	F_MSGBOX(9026)
	RETURN
END IF

DELETE FROM IP_PRODUCT_INV_4_REQUIREMENT 
 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
 IF F_SQL_CHECK() < 0 THEN 
	RETURN
END IF

  INSERT INTO "IP_PRODUCT_INV_4_REQUIREMENT"  
         ( "ORGANIZATION_ID",   
           "ITEM_CODE",   
           "INVENTORY_QTY",   
           "SAFETY_INVENTORY_QTY" )  
		
SELECT 
           "ORGANIZATION_ID",   
           "ITEM_CODE",   
		  0 ,
		  0
 FROM IM_ITEM_MASTER_PLAN_4_REQUIR
 WHERE   REQUIRMENT_PLAN_DATE = TRUNC(:LVD_REQUIRMENT_PLAN_DATE )
      AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID  
 GROUP  BY 	 ITEM_CODE,    ORGANIZATION_ID	;
 
  IF F_SQL_CHECK() < 0 THEN 
	RETURN
END IF
//
//UPDATE IP_PRODUCT_INV_4_REQUIREMENT A SET A.INVENTORY_QTY =
//    ( SELECT sum(NVL(B.INVENTORY_QTY ,0)) 
//	  FROM IS_PRODUCT_INVENTORY B
//	   WHERE  A.ITEM_CODE    =  B.ITEM_CODE		  
//		   AND A.ORGANIZATION_ID = B.ORGANIZATION_ID )
//  WHERE EXISTS ( SELECT 'X'  FROM 	IS_PRODUCT_INVENTORY B
//                      	    WHERE A.ITEM_CODE    =  B.ITEM_CODE
//		                        AND A.ORGANIZATION_ID = B.ORGANIZATION_ID )		;
//
//  IF F_SQL_CHECK() < 0 THEN 
//	RETURN
//END IF

UPDATE IP_PRODUCT_INV_4_REQUIREMENT A SET A.SAFETY_INVENTORY_QTY =
    ( SELECT NVL(B.SAFETY_INVENTORY ,0) FROM ID_ITEM B
	   WHERE A.ITEM_CODE =  B.ITEM_CODE
		   AND A.ORGANIZATION_ID = B.ORGANIZATION_ID )
  WHERE EXISTS ( SELECT 'X'  FROM 	ID_ITEM B
                      	    WHERE A.ITEM_CODE    =  B.ITEM_CODE
		                        AND A.ORGANIZATION_ID = B.ORGANIZATION_ID )		;

  IF F_SQL_CHECK() < 0 THEN 
	RETURN
END IF

UPDATE IM_ITEM_MASTER_PLAN_4_REQUIR A
       SET ( A.TOTAL_INVENTORY_QTY  ) 
		 =( SELECT  NVL(B.INVENTORY_QTY ,0) + NVL(B.SAFETY_INVENTORY_QTY,0)
		        FROM IP_PRODUCT_INV_4_REQUIREMENT B
			  WHERE A.ITEM_CODE = B.ITEM_CODE
				AND A.ORGANIZATION_ID = B.ORGANIZATION_ID )
 WHERE EXISTS ( SELECT 'X' FROM IP_PRODUCT_INV_4_REQUIREMENT B
			  WHERE A.ITEM_CODE = B.ITEM_CODE
				AND A.ORGANIZATION_ID = B.ORGANIZATION_ID ) ;
				
  IF F_SQL_CHECK() < 0 THEN 
	RETURN
END IF 				


COMMIT ;

//================================================
//
//================================================
	OPEN CL1 ;
	DO
		
		FETCH CL1 INTO :LVS_ITEM_CODE, :LVL_ORDER_QTY , :LVS_ROWID  ;
		
		IF F_SQL_CHECK() < 0 THEN 
	         CLOSE CL1 ;
			RETURN
		END IF
		
		IF SQLCA.SQLCODE = 100 THEN 
			CLOSE CL1 ;
			EXIT
		END IF

		//========================================================
		//
		//========================================================
		
			SELECT INVENTORY_QTY ,  ROWID 
				 INTO :LVL_INVENTORY_QTY , :LVS_INV_ROWID
				 FROM IP_PRODUCT_INV_4_REQUIREMENT
			WHERE  ITEM_CODE= :LVS_ITEM_CODE
				 AND INVENTORY_QTY <> 0
				AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
			IF F_SQL_CHECK() < 0 THEN 
				CLOSE CL1 ;
				RETURN
			END IF			
			
			IF SQLCA.SQLCODE = 100 THEN 
				
						 UPDATE IM_ITEM_MASTER_PLAN_4_REQUIR SET INVENTORY_QTY = 0
						  WHERE ROWID  = :LVS_ROWID ;
							  
							IF F_SQL_CHECK() < 0 THEN 
								CLOSE CL1 ;
								RETURN
							END IF						
			ELSE
			
							   //$$HEX16$$fcc838bb18c2c9b774c72000acc7e0ac40c62000200019ac3cc774ba20000900$$ENDHEX$$
								IF 	LVL_ORDER_QTY =  LVL_INVENTORY_QTY THEN 
								
									 UPDATE IM_ITEM_MASTER_PLAN_4_REQUIR SET INVENTORY_QTY = NVL(:LVL_INVENTORY_QTY,0)
									  WHERE ROWID  = :LVS_ROWID ;
										  
										IF F_SQL_CHECK() < 0 THEN 
											CLOSE CL1 ;
											RETURN
										END IF						
								
									  UPDATE IP_PRODUCT_INV_4_REQUIREMENT SET INVENTORY_QTY = 0 
										WHERE ROWID = :LVS_INV_ROWID ;
										
										IF F_SQL_CHECK() < 0 THEN 
											CLOSE CL1 ;
											RETURN
										END IF		
										
										LVL_ORDER_QTY = 0 
							   //$$HEX17$$fcc838bb18c2c9b774c72000acc7e0acf4bce4b220006cd074ba2000090009000900$$ENDHEX$$
								ELSEIF 	LVL_ORDER_QTY >  LVL_INVENTORY_QTY THEN 	
									
									//=========================================================
									//$$HEX16$$b4b080bd2000acc7e0ac200028cc10ac3cba00c8200028cc10ac58d5e0ac2000$$ENDHEX$$
									//=========================================================				
									 UPDATE IM_ITEM_MASTER_PLAN_4_REQUIR SET INVENTORY_QTY = NVL(:LVL_INVENTORY_QTY,0)
									  WHERE ROWID  = :LVS_ROWID ;
									  
										IF F_SQL_CHECK() < 0 THEN 
											CLOSE CL1 ;
											RETURN
										END IF						
								
									  UPDATE IP_PRODUCT_INV_4_REQUIREMENT SET INVENTORY_QTY = 0 
										WHERE ROWID = :LVS_INV_ROWID ;
										
										IF F_SQL_CHECK() < 0 THEN 
											CLOSE CL1 ;
											RETURN
										END IF							
										
										LVL_ORDER_QTY = LVL_ORDER_QTY - LVL_INVENTORY_QTY
																			
 							    ELSEIF LVL_ORDER_QTY <  LVL_INVENTORY_QTY THEN 	 //$$HEX15$$acc7e0ac18c2c9b774c720006cd074ba2000090009000900090009000900$$ENDHEX$$
									
									 UPDATE IM_ITEM_MASTER_PLAN_4_REQUIR SET INVENTORY_QTY = ORDER_QTY
									  WHERE ROWID  = :LVS_ROWID ;
									  
										IF F_SQL_CHECK() < 0 THEN 
											CLOSE CL1 ;
											RETURN
										END IF						
								
									  UPDATE IP_PRODUCT_INV_4_REQUIREMENT SET INVENTORY_QTY = NVL(INVENTORY_QTY,0) -NVL( :LVL_ORDER_QTY,0)
										WHERE ROWID = :LVS_INV_ROWID ;
										
										IF F_SQL_CHECK() < 0 THEN 
											CLOSE CL1 ;
											RETURN
										END IF		
										
									    LVL_ORDER_QTY = 0 	
								END IF 
				END IF
				
				
				//$$HEX22$$b4b080bd2000acc7e0ac7cb9200010ac48c558d5e0acc4b32000fcc838bbc9b774c72000a8b03cc774ba2000$$ENDHEX$$
				//$$HEX12$$48c504c8acc7e0ac7cb9200028cc10ac20005cd5e4b22000$$ENDHEX$$.
				IF  LVL_ORDER_QTY >  0 THEN 
				ELSE
					  I++
					  CONTINUE 
				END IF
				
				
					SELECT  SAFETY_INVENTORY_QTY  , ROWID 
						 INTO  :LVL_SAFETY_INVENTORY_QTY , :LVS_INV_ROWID
						 FROM IP_PRODUCT_INV_4_REQUIREMENT
					WHERE  ITEM_CODE = :LVS_ITEM_CODE
						 AND SAFETY_INVENTORY_QTY <> 0
						AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
					IF F_SQL_CHECK() < 0 THEN 
						CLOSE CL1 ;
						RETURN
					END IF										
				
				IF SQLCA.SQLCODE = 100 THEN 
				
						 UPDATE IM_ITEM_MASTER_PLAN_4_REQUIR SET SAFETY_INVENTORY_QTY = 0
						  WHERE ROWID  = :LVS_ROWID ;
							  
							IF F_SQL_CHECK() < 0 THEN 
								CLOSE CL1 ;
								RETURN
							END IF						
				
              
			ELSE
			
							  //$$HEX20$$fcc838bb18c2c9b774c72000acc7e0acf4bce4b220006cd070ac98b0200019ac3cc774ba20000900$$ENDHEX$$
								IF 	LVL_ORDER_QTY =  LVL_SAFETY_INVENTORY_QTY THEN 
								
									 UPDATE IM_ITEM_MASTER_PLAN_4_REQUIR SET SAFETY_INVENTORY_QTY = NVL(:LVL_SAFETY_INVENTORY_QTY,0)
									  WHERE ROWID  = :LVS_ROWID ;
										  
										IF F_SQL_CHECK() < 0 THEN 
											CLOSE CL1 ;
											RETURN
										END IF						
								
									  UPDATE IP_PRODUCT_INV_4_REQUIREMENT SET SAFETY_INVENTORY_QTY = 0 
										WHERE ROWID = :LVS_INV_ROWID ;
										
										IF F_SQL_CHECK() < 0 THEN 
											CLOSE CL1 ;
											RETURN
										END IF		
										
										LVL_ORDER_QTY = 0 
									
								ELSEIF 	LVL_ORDER_QTY >  LVL_SAFETY_INVENTORY_QTY THEN 	
									
									//=========================================================
									//$$HEX16$$b4b080bd2000acc7e0ac200028cc10ac3cba00c8200028cc10ac58d5e0ac2000$$ENDHEX$$
									//=========================================================				
									 UPDATE IM_ITEM_MASTER_PLAN_4_REQUIR SET SAFETY_INVENTORY_QTY = NVL(:LVL_SAFETY_INVENTORY_QTY,0)
									  WHERE ROWID  = :LVS_ROWID ;
									  
										IF F_SQL_CHECK() < 0 THEN 
											CLOSE CL1 ;
											RETURN
										END IF						
								
									  UPDATE IP_PRODUCT_INV_4_REQUIREMENT SET SAFETY_INVENTORY_QTY = 0 
										WHERE ROWID = :LVS_INV_ROWID ;
										
										IF F_SQL_CHECK() < 0 THEN 
											CLOSE CL1 ;
											RETURN
										END IF							
										
										LVL_ORDER_QTY = LVL_ORDER_QTY - LVL_SAFETY_INVENTORY_QTY
																			
						             ELSEIF LVL_ORDER_QTY <  LVL_SAFETY_INVENTORY_QTY THEN 	 //$$HEX15$$acc7e0ac18c2c9b774c720006cd074ba2000090009000900090009000900$$ENDHEX$$
									
									 UPDATE IM_ITEM_MASTER_PLAN_4_REQUIR SET SAFETY_INVENTORY_QTY = :LVL_ORDER_QTY
									  WHERE ROWID  = :LVS_ROWID ;
									  
										IF F_SQL_CHECK() < 0 THEN 
											CLOSE CL1 ;
											RETURN
										END IF						
								
									  UPDATE IP_PRODUCT_INV_4_REQUIREMENT SET  SAFETY_INVENTORY_QTY = NVL(SAFETY_INVENTORY_QTY,0) - :LVL_ORDER_QTY
										WHERE ROWID = :LVS_INV_ROWID ;
										
										IF F_SQL_CHECK() < 0 THEN 
											CLOSE CL1 ;
											RETURN
										END IF		
										
									    LVL_ORDER_QTY = 0 	
								END IF 
				END IF			
	I++
	f_msg_mdi_help( STRING(I) +"Rows Prcessed!" )
	LOOP UNTIL 1 =2
	
    COMMIT ;

end event

type cb_3 from so_commandbutton within w_mat_requirment_plan_master
integer x = 3749
integer y = 80
integer width = 457
integer height = 168
integer taborder = 40
boolean bringtotop = true
string text = "Batch Delete"
end type

event clicked;IF F_OBJECT_ROLE_CHECK() = FALSE THEN  RETURN
LONG I , J , K , LVL_COUNT
STRING LVS_CHECK_YN
IF DW_1.GETROW() < 1 THEN RETURN
	

MSG = F_MSGBOX(1003) //$$HEX7$$adc01cc8200060d54cae94c62000$$ENDHEX$$? DO YOU WISH TO DELETE ?
IF MSG = 1 THEN 
ELSE
	RETURN
END IF

DW_1.ACCEPTTEXT()

LVL_COUNT =  DW_1.ROWCOUNT()
I = 1
DO
	K++
	LVS_CHECK_YN = DW_1.GETITEMSTRING( I , 'check_yn' )
	
	IF LVS_CHECK_YN = 'Y' THEN 
		J++
		DW_1.DELETEROW( I )
	ELSE
		 I++
	END IF
	
LOOP UNTIL K = LVL_COUNT

IF J > 0 THEN 
	Msg= F_MSGbox1( 9030 , STRING(J)) //@ $$HEX18$$74ac74c72000adc01cc8200018b4c8c5b5c2c8b2e4b2200000c8a5c7200060d54cae94c6$$ENDHEX$$
ELSE
	RETURN
END IF

IF MSG = 1 THEN 
	
	IF DW_1.UPDATE() < 0 THEN 
		ROLLBACK;
	ELSE
		COMMIT;
//		F_MSG_ST(170 , ST_MSG)
	END IF
	
ELSE
	
	 F_UNDELETE()
	
END IF



end event

type rb_5 from so_radiobutton within w_mat_requirment_plan_master
integer x = 2523
integer y = 400
integer width = 750
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "From Sale Plan"
end type

event clicked;OPENWITHPARM(W_DES_MODEL_SELECT_FROM_SALE_PLAN_POP , DW_1 )
end event

type gb_where_condition from so_groupbox within w_mat_requirment_plan_master
integer x = 14
integer width = 2299
integer height = 328
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_1 from so_groupbox within w_mat_requirment_plan_master
integer x = 9
integer y = 340
integer width = 1664
integer height = 220
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_2 from so_groupbox within w_mat_requirment_plan_master
integer x = 1691
integer y = 340
integer width = 1627
integer height = 220
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Plan Input Method"
end type

type gb_3 from so_groupbox within w_mat_requirment_plan_master
integer x = 2318
integer width = 1906
integer height = 324
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

