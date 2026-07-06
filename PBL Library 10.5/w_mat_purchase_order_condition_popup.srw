HA$PBExportHeader$w_mat_purchase_order_condition_popup.srw
$PBExportComments$$$HEX8$$fcc838bb1cbcfcc870c874ac1dd3c5c5$$ENDHEX$$
forward
global type w_mat_purchase_order_condition_popup from w_popup_root
end type
type cb_purchase_order from commandbutton within w_mat_purchase_order_condition_popup
end type
type uo_dateset from uo_ymd_calendar within w_mat_purchase_order_condition_popup
end type
type st_4 from statictext within w_mat_purchase_order_condition_popup
end type
type hpb_1 from hprogressbar within w_mat_purchase_order_condition_popup
end type
type cbx_abc_grade from checkbox within w_mat_purchase_order_condition_popup
end type
type cbx_delivery_reset from checkbox within w_mat_purchase_order_condition_popup
end type
type uo_dateend from uo_ymd_calendar within w_mat_purchase_order_condition_popup
end type
type st_3 from statictext within w_mat_purchase_order_condition_popup
end type
type ddlb_supplier_code from uo_supplier_code within w_mat_purchase_order_condition_popup
end type
type st_5 from statictext within w_mat_purchase_order_condition_popup
end type
type uo_item from uo_item_code within w_mat_purchase_order_condition_popup
end type
type gb_3 from groupbox within w_mat_purchase_order_condition_popup
end type
type gb_2 from groupbox within w_mat_purchase_order_condition_popup
end type
type gb_1 from groupbox within w_mat_purchase_order_condition_popup
end type
end forward

global type w_mat_purchase_order_condition_popup from w_popup_root
integer width = 2254
integer height = 1108
boolean minbox = true
windowtype windowtype = popup!
cb_purchase_order cb_purchase_order
uo_dateset uo_dateset
st_4 st_4
hpb_1 hpb_1
cbx_abc_grade cbx_abc_grade
cbx_delivery_reset cbx_delivery_reset
uo_dateend uo_dateend
st_3 st_3
ddlb_supplier_code ddlb_supplier_code
st_5 st_5
uo_item uo_item
gb_3 gb_3
gb_2 gb_2
gb_1 gb_1
end type
global w_mat_purchase_order_condition_popup w_mat_purchase_order_condition_popup

type variables
DATAWINDOW IVD_PARM_DATA_WINDOW
end variables

on w_mat_purchase_order_condition_popup.create
int iCurrent
call super::create
this.cb_purchase_order=create cb_purchase_order
this.uo_dateset=create uo_dateset
this.st_4=create st_4
this.hpb_1=create hpb_1
this.cbx_abc_grade=create cbx_abc_grade
this.cbx_delivery_reset=create cbx_delivery_reset
this.uo_dateend=create uo_dateend
this.st_3=create st_3
this.ddlb_supplier_code=create ddlb_supplier_code
this.st_5=create st_5
this.uo_item=create uo_item
this.gb_3=create gb_3
this.gb_2=create gb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_purchase_order
this.Control[iCurrent+2]=this.uo_dateset
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.hpb_1
this.Control[iCurrent+5]=this.cbx_abc_grade
this.Control[iCurrent+6]=this.cbx_delivery_reset
this.Control[iCurrent+7]=this.uo_dateend
this.Control[iCurrent+8]=this.st_3
this.Control[iCurrent+9]=this.ddlb_supplier_code
this.Control[iCurrent+10]=this.st_5
this.Control[iCurrent+11]=this.uo_item
this.Control[iCurrent+12]=this.gb_3
this.Control[iCurrent+13]=this.gb_2
this.Control[iCurrent+14]=this.gb_1
end on

on w_mat_purchase_order_condition_popup.destroy
call super::destroy
destroy(this.cb_purchase_order)
destroy(this.uo_dateset)
destroy(this.st_4)
destroy(this.hpb_1)
destroy(this.cbx_abc_grade)
destroy(this.cbx_delivery_reset)
destroy(this.uo_dateend)
destroy(this.st_3)
destroy(this.ddlb_supplier_code)
destroy(this.st_5)
destroy(this.uo_item)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.gb_1)
end on

type p_title from w_popup_root`p_title within w_mat_purchase_order_condition_popup
integer width = 2240
end type

type cb_sort from w_popup_root`cb_sort within w_mat_purchase_order_condition_popup
boolean visible = true
integer x = 41
integer y = 1460
end type

type cb_close from w_popup_root`cb_close within w_mat_purchase_order_condition_popup
boolean visible = true
integer x = 1737
integer y = 720
integer width = 443
end type

type st_msg from w_popup_root`st_msg within w_mat_purchase_order_condition_popup
boolean visible = true
integer y = 496
integer width = 2240
end type

type dw_1 from w_popup_root`dw_1 within w_mat_purchase_order_condition_popup
boolean visible = true
integer y = 1112
end type

type dw_2 from w_popup_root`dw_2 within w_mat_purchase_order_condition_popup
boolean visible = true
integer y = 1116
end type

type dw_3 from w_popup_root`dw_3 within w_mat_purchase_order_condition_popup
integer y = 1116
end type

type cb_purchase_order from commandbutton within w_mat_purchase_order_condition_popup
integer x = 1289
integer y = 720
integer width = 443
integer height = 100
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Purchase Order"
end type

event clicked;DATETIME LVD_DATESET , LVD_DATEEND 
LONG LVL_COUNT  , LVL_ORDER_COUNT
STRING LVS_SUPPLIER_CODE , LVS_ITEM_CODE , LVS_ORDER_GROUP_NO

LVD_DATESET =UO_DATESET.TEXT()
LVD_DATEEND = UO_DATEEND.TEXT()

//==========================================
// $$HEX11$$98ccacb960d5200074ac18c2200074ceb4c6b8d22000$$ENDHEX$$
//==========================================
LVS_SUPPLIER_CODE = ddlb_supplier_code.text+'%'
LVS_ITEM_CODE = uo_item.text()+'%'

IF cbx_abc_grade.checked = true THEN 
		SELECT COUNT(*) INTO :LVL_COUNT 
		  FROM IM_ITEM_PURCHASE_ORDER_PLAN 
		WHERE SUPPLIER_CODE LIKE :LVS_SUPPLIER_CODE
		     AND ITEM_CODE LIKE :LVS_ITEM_CODE
		     AND DELIVERY_DATE >=   :LVD_DATESET
			AND DELIVERY_DATE <=   :LVD_DATEEND
			AND NVL(PURCHASE_ORDER_STATUS,'N')  = 'N'
			AND NVL(PURCHASE_ORDER_QTY,0)  > 0 
               AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM WHERE ABC_GRADE IN(  'A' , 'B' , 'C' )  AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID )			
			AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ; 
			
		IF F_SQL_CHECK() < 0 THEN 
			RETURN
		END IF
		
ELSE
		SELECT COUNT(*) INTO :LVL_COUNT 
		  FROM  IM_ITEM_PURCHASE_ORDER_PLAN 
		WHERE  SUPPLIER_CODE LIKE :LVS_SUPPLIER_CODE
		     AND ITEM_CODE LIKE :LVS_ITEM_CODE
		     AND DELIVERY_DATE >=   :LVD_DATESET
			AND DELIVERY_DATE <=   :LVD_DATEEND
			AND NVL(PURCHASE_ORDER_STATUS,'N')  = 'N'
			AND NVL(PURCHASE_ORDER_QTY,0)  > 0 
//              AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM WHERE ABC_GRADE IN(  'A' , 'B' , 'C' )  AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID )			
			AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ; 
			
		IF F_SQL_CHECK() < 0 THEN 
			RETURN
		END IF
END IF
		

  IF LVL_COUNT = 0 THEN 
	F_MSGBOX( 117 ) // $$HEX9$$90c7ccb800ac2000c6c5b5c2c8b2e4b22000$$ENDHEX$$
	RETURN 
  END IF
  
MSG = F_MSGBOX1( 1161 , THIS.TEXT ) //@ $$HEX7$$7cb9200098ccacb960d54cae94c6$$ENDHEX$$?
IF MSG = 1 THEN 
ELSE
	RETURN 
END IF

if cbx_delivery_reset.checked = true then 

//==================================================
// $$HEX16$$24c698b2f4bce4b2200074c704c8a9b030ae20007cc704ad200018c215c82000$$ENDHEX$$
//==================================================	
	ST_MSG.TEXT = "Delivery Date Reset..."
	UPDATE IM_ITEM_PURCHASE_ORDER_PLAN
	      SET DELIVERY_DATE = TRUNC(SYSDATE)
    WHERE   SUPPLIER_CODE LIKE :LVS_SUPPLIER_CODE
        AND ITEM_CODE LIKE :LVS_ITEM_CODE
	   AND PURCHASE_ORDER_STATUS = 'N' 
        AND DELIVERY_DATE < TRUNC(SYSDATE)
        AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;		

   IF F_SQL_CHECK() < 0 THEN 
	  RETURN 
   END IF	
end if

LVS_ORDER_GROUP_NO =  string(f_t_sysdate(),'yyyymmdd') + string( f_get_sequence( 'SEQ_PURCHASE_ORDER_NO'),'000')

//==========================================
// ABC $$HEX16$$f1b409ae200001c8a9c620001cbcfcc8200098ccacb978c72000bdacb0c62000$$ENDHEX$$
//==========================================
IF cbx_abc_grade.checked = true THEN 

//==========================================
// ABC $$HEX4$$f1b409ae11c92000$$ENDHEX$$A $$HEX4$$09ae20001cbcfcc8$$ENDHEX$$.
//==========================================
  INSERT INTO "IM_ITEM_PURCHASE_ORDER"  
         ( "ORDER_NO",   "ORDER_GROUP_NO" ,
           "ORGANIZATION_ID",   
           "PURCHASE_ORDER_DATE",   
           "SUPPLIER_CODE",   
           "ITEM_CODE",   
           "DELIVERY_DATE",   
           "DELIVERY",   
           "LINE_TYPE",   
           "ORDER_TYPE",   
           "ORDER_QTY",   
           "UNIT_PRICE",   
           "CURRENCY",   
           "ARRIVAL_QTY",   
           "MFS",   
           "ENTER_BY",   
           "ENTER_DATE",   
           "LAST_MODIFY_BY",   
           "LAST_MODIFY_DATE" )  
SELECT "ORDER_NO",   :LVS_ORDER_GROUP_NO ,
           "ORGANIZATION_ID",   
           TRUNC(SYSDATE) PURCHASE_ORDER_DATE,   
           "SUPPLIER_CODE",   
           "ITEM_CODE",   
           "DELIVERY_DATE",   
           "DELIVERY",   
           "LINE_TYPE",   
           "ORDER_TYPE",   
           "ORDER_QTY",   
           "UNIT_PRICE",   
           "CURRENCY",   
           "ARRIVAL_QTY",   
           "MFS",   
           :GVS_USER_ID ,   
           SYSDATE,   
           :GVS_USER_ID,   
           SYSDATE 
 FROM  IM_ITEM_PURCHASE_ORDER_PLAN 
WHERE SUPPLIER_CODE LIKE :LVS_SUPPLIER_CODE
	AND ITEM_CODE LIKE :LVS_ITEM_CODE
	AND DELIVERY_DATE >=   :LVD_DATESET
	AND DELIVERY_DATE <=   :LVD_DATEEND
	AND NVL(PURCHASE_ORDER_STATUS,'N')  = 'N'
	AND NVL(PURCHASE_ORDER_QTY,0)  > 0 
	AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM WHERE ABC_GRADE = 'A' AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID )
	AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;

IF F_SQL_CHECK() < 0 THEN 
    RETURN
END IF

UPDATE IM_ITEM_PURCHASE_ORDER_PLAN SET PURCHASE_ORDER_STATUS = 'Y'
WHERE SUPPLIER_CODE LIKE :LVS_SUPPLIER_CODE
	AND ITEM_CODE LIKE :LVS_ITEM_CODE
	AND DELIVERY_DATE >=   :LVD_DATESET
	AND DELIVERY_DATE <=   :LVD_DATEEND
	AND NVL(PURCHASE_ORDER_STATUS,'N')  = 'N'
	AND NVL(PURCHASE_ORDER_QTY,0)  > 0 	 
	AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM 
	                                    WHERE ITEM_CODE LIKE :LVS_ITEM_CODE
									 AND ABC_GRADE = 'A' 
					                     AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID )	 
	AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ; 
	  
IF F_SQL_CHECK() < 0 THEN 
    RETURN
END IF
LVL_ORDER_COUNT = LVL_ORDER_COUNT + SQLCA.SQLNROWS
//==========================================
// ABC $$HEX4$$f1b409ae11c92000$$ENDHEX$$B $$HEX4$$09ae20001cbcfcc8$$ENDHEX$$.
//==========================================
  INSERT INTO "IM_ITEM_PURCHASE_ORDER"  
         ( "ORDER_NO",  "ORDER_GROUP_NO",
           "ORGANIZATION_ID",   
           "PURCHASE_ORDER_DATE",   
           "SUPPLIER_CODE",   
           "ITEM_CODE",   
           "DELIVERY_DATE",   
           "DELIVERY",   
           "LINE_TYPE",   
           "ORDER_TYPE",   
           "ORDER_QTY",   
           "UNIT_PRICE",   
           "CURRENCY",   
           "ARRIVAL_QTY",   
           "MFS",   
           "ENTER_BY",   
           "ENTER_DATE",   
           "LAST_MODIFY_BY",   
           "LAST_MODIFY_DATE" )  
SELECT MAX("ORDER_NO"),   :LVS_ORDER_GROUP_NO ,
           "ORGANIZATION_ID",   
           TRUNC(SYSDATE) PURCHASE_ORDER_DATE,      
           "SUPPLIER_CODE",   
           "ITEM_CODE",   
          MIN( "DELIVERY_DATE") , 
           "DELIVERY",   
           "LINE_TYPE",   
           "ORDER_TYPE",   
           SUM("ORDER_QTY"),   
           "UNIT_PRICE",   
           "CURRENCY",   
           SUM("ARRIVAL_QTY"),   
           MIN("MFS"),   
           :GVS_USER_ID ,   
           SYSDATE,   
           :GVS_USER_ID,   
           SYSDATE 
 FROM  IM_ITEM_PURCHASE_ORDER_PLAN 
WHERE SUPPLIER_CODE LIKE :LVS_SUPPLIER_CODE
	AND ITEM_CODE LIKE :LVS_ITEM_CODE
	AND DELIVERY_DATE >=   :LVD_DATESET
     AND DELIVERY_DATE <=   :LVD_DATEEND
	 AND NVL(PURCHASE_ORDER_STATUS,'N')  = 'N'
	 AND NVL(PURCHASE_ORDER_QTY,0)  > 0 
	 AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM WHERE ITEM_CODE LIKE :LVS_ITEM_CODE AND ABC_GRADE = 'B' AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID )
     AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID
 GROUP BY  "ORGANIZATION_ID",   
           "SUPPLIER_CODE",   
           "ITEM_CODE",   
           "DELIVERY",   
           "LINE_TYPE",   
           "ORDER_TYPE",   
		  "PAYMENT_TYPE",
           "UNIT_PRICE",   
           "CURRENCY" ,
           TO_CHAR(DELIVERY_DATE,'W')  ;
			  
IF F_SQL_CHECK() < 0 THEN 
    RETURN
END IF

UPDATE IM_ITEM_PURCHASE_ORDER_PLAN SET PURCHASE_ORDER_STATUS = 'Y'
 WHERE SUPPLIER_CODE LIKE :LVS_SUPPLIER_CODE
	AND ITEM_CODE LIKE :LVS_ITEM_CODE
	AND DELIVERY_DATE >=   :LVD_DATESET
     AND DELIVERY_DATE <=   :LVD_DATEEND
	 AND NVL(PURCHASE_ORDER_STATUS,'N')  = 'N'
	 AND NVL(PURCHASE_ORDER_QTY,0)  > 0 	 
	 AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM WHERE ITEM_CODE LIKE :LVS_ITEM_CODE AND ABC_GRADE = 'B' AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID )	 
     AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ; 
	  
IF F_SQL_CHECK() < 0 THEN 
    RETURN
END IF
LVL_ORDER_COUNT = LVL_ORDER_COUNT + SQLCA.SQLNROWS
//==========================================
// ABC $$HEX4$$f1b409ae11c92000$$ENDHEX$$C $$HEX4$$09ae20001cbcfcc8$$ENDHEX$$.
//==========================================
  INSERT INTO "IM_ITEM_PURCHASE_ORDER"  
         ( "ORDER_NO",  "ORDER_GROUP_NO",
           "ORGANIZATION_ID",   
           "PURCHASE_ORDER_DATE",   
           "SUPPLIER_CODE",   
           "ITEM_CODE",   
           "DELIVERY_DATE",   
           "DELIVERY",   
           "LINE_TYPE",   
           "ORDER_TYPE",   
           "ORDER_QTY",   
           "UNIT_PRICE",   
           "CURRENCY",   
           "ARRIVAL_QTY",   
           "MFS",   
           "ENTER_BY",   
           "ENTER_DATE",   
           "LAST_MODIFY_BY",   
           "LAST_MODIFY_DATE" )  
SELECT MAX("ORDER_NO"),   :LVS_ORDER_GROUP_NO ,
           "ORGANIZATION_ID",   
            TRUNC(SYSDATE) PURCHASE_ORDER_DATE,   
           "SUPPLIER_CODE",   
           "ITEM_CODE",   
           MIN("DELIVERY_DATE"),   
           "DELIVERY",   
           "LINE_TYPE",   
           "ORDER_TYPE",   
           SUM("ORDER_QTY"),   
           "UNIT_PRICE",   
           "CURRENCY",   
           SUM("ARRIVAL_QTY"),   
           MIN("MFS"),   
           :GVS_USER_ID ,   
           SYSDATE,   
           :GVS_USER_ID,   
           SYSDATE 
 FROM  IM_ITEM_PURCHASE_ORDER_PLAN 
WHERE SUPPLIER_CODE LIKE :LVS_SUPPLIER_CODE
	AND ITEM_CODE LIKE :LVS_ITEM_CODE
     AND DELIVERY_DATE >=   :LVD_DATESET
     AND DELIVERY_DATE <=   :LVD_DATEEND
	 AND NVL(PURCHASE_ORDER_STATUS,'N')  = 'N'
	 AND NVL(PURCHASE_ORDER_QTY,0)  > 0 
	 AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM WHERE ITEM_CODE LIKE :LVS_ITEM_CODE AND ABC_GRADE = 'C' AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID )
     AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID
 GROUP BY  "ORGANIZATION_ID",   
				"SUPPLIER_CODE",   
				"ITEM_CODE",   
				"DELIVERY",   
				"LINE_TYPE",   
				"ORDER_TYPE",   
				"PAYMENT_TYPE",
				"UNIT_PRICE",   
				"CURRENCY" ;	  
			  
IF F_SQL_CHECK() < 0 THEN 
    RETURN
END IF

UPDATE IM_ITEM_PURCHASE_ORDER_PLAN SET PURCHASE_ORDER_STATUS = 'Y'
	WHERE SUPPLIER_CODE LIKE :LVS_SUPPLIER_CODE
	AND ITEM_CODE LIKE :LVS_ITEM_CODE
	AND DELIVERY_DATE >=   :LVD_DATESET
	AND DELIVERY_DATE <=   :LVD_DATEEND
	AND NVL(PURCHASE_ORDER_STATUS,'N')  = 'N'
	AND NVL(PURCHASE_ORDER_QTY,0)  > 0 	 
	AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM WHERE ITEM_CODE LIKE :LVS_ITEM_CODE AND ABC_GRADE = 'C' AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID )	 
	AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ; 
	  
IF F_SQL_CHECK() < 0 THEN 
    RETURN
END IF
LVL_ORDER_COUNT = LVL_ORDER_COUNT + SQLCA.SQLNROWS

//==========================================
// ABC $$HEX18$$f1b409ae200001c8a9c620001cbcfcc8200098ccacb900ac200044c5ccb2bdacb0c62000$$ENDHEX$$
//==========================================
else

//==========================================
// $$HEX11$$f1b409ae2000c6c574c7200004c8b4cc20001cbcfcc8$$ENDHEX$$
//==========================================
  INSERT INTO "IM_ITEM_PURCHASE_ORDER"  
         ( "ORDER_NO",  "ORDER_GROUP_NO",
           "ORGANIZATION_ID",   
           "PURCHASE_ORDER_DATE",   
           "SUPPLIER_CODE",   
           "ITEM_CODE",   
           "DELIVERY_DATE",   
           "DELIVERY",   
           "LINE_TYPE",   
           "ORDER_TYPE",   
           "ORDER_QTY",   
           "UNIT_PRICE",   
           "CURRENCY",   
           "ARRIVAL_QTY",   
           "MFS",   
           "ENTER_BY",   
           "ENTER_DATE",   
           "LAST_MODIFY_BY",   
           "LAST_MODIFY_DATE" )  
SELECT "ORDER_NO",   :LVS_ORDER_GROUP_NO ,
           "ORGANIZATION_ID",   
            TRUNC(SYSDATE) PURCHASE_ORDER_DATE,   
           "SUPPLIER_CODE",   
           "ITEM_CODE",   
           "DELIVERY_DATE",   
           "DELIVERY",   
           "LINE_TYPE",   
           "ORDER_TYPE",   
           "ORDER_QTY",   
           "UNIT_PRICE",   
           "CURRENCY",   
           "ARRIVAL_QTY",   
           "MFS",   
           :GVS_USER_ID ,   
           SYSDATE,   
           :GVS_USER_ID,   
           SYSDATE 
 FROM  IM_ITEM_PURCHASE_ORDER_PLAN 
WHERE SUPPLIER_CODE LIKE :LVS_SUPPLIER_CODE
	AND ITEM_CODE LIKE :LVS_ITEM_CODE
	AND DELIVERY_DATE >=   :LVD_DATESET
     AND DELIVERY_DATE <=   :LVD_DATEEND
	 AND NVL(PURCHASE_ORDER_STATUS,'N')  = 'N'
	 AND NVL(PURCHASE_ORDER_QTY,0)  > 0 
//	 AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM WHERE ABC_GRADE = 'A' AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID )
     AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;

IF F_SQL_CHECK() < 0 THEN 
    RETURN
END IF

UPDATE IM_ITEM_PURCHASE_ORDER_PLAN SET PURCHASE_ORDER_STATUS = 'Y'
 WHERE SUPPLIER_CODE LIKE :LVS_SUPPLIER_CODE
	AND ITEM_CODE LIKE :LVS_ITEM_CODE
	AND DELIVERY_DATE >=   :LVD_DATESET
     AND DELIVERY_DATE <=   :LVD_DATEEND
	 AND NVL(PURCHASE_ORDER_STATUS,'N')  = 'N'
	 AND NVL(PURCHASE_ORDER_QTY,0)  > 0 	 
//	 AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM WHERE ABC_GRADE = 'A' AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID )	 
     AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ; 
	  
IF F_SQL_CHECK() < 0 THEN 
    RETURN
END IF
LVL_ORDER_COUNT = LVL_ORDER_COUNT + SQLCA.SQLNROWS

end if

//=============================================

IF LVL_ORDER_COUNT > 0 THEN 

	F_MSG_ST1(129 ,STRING(LVL_ORDER_COUNT)) //@$$HEX14$$89d558c7200098ccacb900ac200031c1f5ac58d500c6b5c2c8b2e4b2$$ENDHEX$$.
	F_MSGBOX(9088) //$$HEX14$$fcc838bb98ccacb900ac200044c6ccb8200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$
	COMMIT ;
	
ELSE
	  F_MSGBOX(9026) //$$HEX12$$c0bcbdac1cb4200090c7ccb800ac2000c6c5b5c2c8b2e4b2$$ENDHEX$$
	  COMMIT ;
END IF
end event

type uo_dateset from uo_ymd_calendar within w_mat_purchase_order_condition_popup
integer x = 69
integer y = 340
integer taborder = 110
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type st_4 from statictext within w_mat_purchase_order_condition_popup
integer x = 91
integer y = 268
integer width = 795
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Delivery Date"
alignment alignment = center!
boolean focusrectangle = false
end type

type hpb_1 from hprogressbar within w_mat_purchase_order_condition_popup
integer y = 948
integer width = 2235
integer height = 68
boolean bringtotop = true
unsignedinteger maxposition = 100
integer setstep = 10
end type

type cbx_abc_grade from checkbox within w_mat_purchase_order_condition_popup
integer x = 101
integer y = 696
integer width = 951
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
string text = "Apply ABC Grade"
boolean checked = true
end type

type cbx_delivery_reset from checkbox within w_mat_purchase_order_condition_popup
integer x = 101
integer y = 788
integer width = 951
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
string text = "Delivery Date Reset (Today)"
boolean checked = true
end type

type uo_dateend from uo_ymd_calendar within w_mat_purchase_order_condition_popup
integer x = 480
integer y = 340
integer taborder = 120
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_3 from statictext within w_mat_purchase_order_condition_popup
integer x = 901
integer y = 272
integer width = 489
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "Supplier Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_supplier_code from uo_supplier_code within w_mat_purchase_order_condition_popup
integer x = 891
integer y = 340
integer width = 489
integer taborder = 100
boolean bringtotop = true
end type

event rbuttondown;call super::rbuttondown;THIS.TRIGGEREVENT(SELECTIONCHANGED!)
end event

type st_5 from statictext within w_mat_purchase_order_condition_popup
integer x = 1390
integer y = 264
integer width = 521
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "Item Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_item from uo_item_code within w_mat_purchase_order_condition_popup
integer x = 1390
integer y = 340
integer width = 521
integer height = 676
integer taborder = 110
boolean bringtotop = true
end type

type gb_3 from groupbox within w_mat_purchase_order_condition_popup
integer x = 1257
integer y = 596
integer width = 960
integer height = 316
integer taborder = 40
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

type gb_2 from groupbox within w_mat_purchase_order_condition_popup
integer x = 23
integer y = 596
integer width = 1225
integer height = 316
integer taborder = 100
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
string text = "Purchase Order Option"
end type

type gb_1 from groupbox within w_mat_purchase_order_condition_popup
integer x = 14
integer y = 200
integer width = 1929
integer height = 288
integer taborder = 20
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

