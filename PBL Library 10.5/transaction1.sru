HA$PBExportHeader$transaction1.sru
$PBExportComments$SQL TRANSACTION
forward
global type transaction1 from transaction
end type
end forward

global type transaction1 from transaction
end type
global transaction1 transaction1

type prototypes
//===============================
// BOM
//===============================
function double BOM_MODEL_QTY(string P_ORG,double P_SESSION_ID) RPCFUNC ALIAS FOR "PKG_DESIGN.~"BOM_MODEL_QTY~""
function double BOM_QUERY(string P_PARENT_ITEM_CODE,datetime P_DATESET,double P_ORG) RPCFUNC ALIAS FOR "PKG_DESIGN.~"BOM_QUERY~""
function double BOM_QUERY_ALL(string P_PARENT_ITEM_CODE,datetime P_DATESET,double P_ORG) RPCFUNC ALIAS FOR "PKG_DESIGN.~"BOM_QUERY_ALL~""
function double BOM_TRANSLATION(double P_WORK_NO,string P_SET_ITEM_CODE,double P_ORG) RPCFUNC ALIAS FOR "PKG_DESIGN.~"BOM_TRANSLATION~""
function double BOM_NEWINS_CHECK(double P_WORK_NO,string P_SET_ITEM_CODE,string P_PARENT_ITEM_CODE,string P_CHILD_ITEM_CODE,datetime P_DATESET,double P_ORG) RPCFUNC ALIAS FOR "PKG_DESIGN.~"BOM_NEWINS_CHECK~""
function double BOM_COPY(double P_BOM_WORK_NO,string P_SOURCE_ITEM_CODE,string P_DEST_PARENT_ITEM_CODE,string P_DEST_ITEM_CODE, datetime P_DATESET,double P_ORG) RPCFUNC ALIAS FOR "PKG_DESIGN.~"BOM_COPY~""
function double BOM_ECO_CONFIRM(double P_ECO_WORK_NO,double P_ORG) RPCFUNC ALIAS FOR "PKG_DESIGN.~"BOM_ECO_CONFIRM~""
function double BOM_EXPLOSION(string P_PARENT_ITEM_CODE,datetime P_DATESET,double P_ORG) RPCFUNC ALIAS FOR "PKG_DESIGN.~"BOM_EXPLOSION~""
function double BOM_EXPLOSION_ALL(string P_PARENT_ITEM_CODE,datetime P_DATESET,double P_ORG) RPCFUNC ALIAS FOR "PKG_DESIGN.~"BOM_EXPLOSION_ALL~""
function double BOM_LOOP_CHECK_ECO(string P_PARENT_ITEM_CODE,string P_CHILD_ITEM_CODE,datetime P_DATESET,double P_ORG) RPCFUNC ALIAS FOR "PKG_DESIGN.~"BOM_LOOP_CHECK_ECO~""
function double BOM_LOOP_CHECK(string P_PARENT_ITEM_CODE,string P_CHILD_ITEM_CODE,datetime P_DATESET,double P_ORG) RPCFUNC ALIAS FOR "PKG_DESIGN.~"BOM_LOOP_CHECK~""

function string   F_GET_ANY_NO(string P_NAME,double P_ORG) RPCFUNC ALIAS FOR "F_GET_ANY_NO"
function double  F_SET_DATA_MONITOR(double P_ORG) RPCFUNC ALIAS FOR "F_SET_DATA_MONITOR"
function string   F_CHECK_BOM_EXISTS(string P_ITEM_CODE,double P_ORG) RPCFUNC ALIAS FOR "F_CHECK_BOM_EXISTS"
//================================
// PDA SCAN
//================================
function string F_SET_DATA_MONITOR(datetime P_DATE,string P_TYPE,double P_QTY) RPCFUNC ALIAS FOR  "~"F_SET_DATA_MONITOR~""
subroutine P_CHECK_PDA_SCAN(string P_PLAN_DATE,string P_MODEL_NAME,string P_LINE_CODE,string P_ADDRESS,string P_BARCODE,string P_DEFICIT,ref string P_RETURN) RPCFUNC ALIAS FOR  "~"P_CHECK_PDA_SCAN~""
subroutine P_CHECK_SOLDER_SCAN( string P_line , string P_MODEL ,  string  P_BARCODE,  string p_TYPE ,  string   P_DEFICIT,ref string P_RETURN) RPCFUNC ALIAS FOR  "~"P_CHECK_SOLDER_SCAN~""
subroutine P_INTERLOCK_SET_NSNP(string P_HOST,string P_MESSAGE) RPCFUNC ALIAS FOR  "~"P_INTERLOCK_SET_NSNP~""
subroutine P_SET_PRODUCT_SCAN(string P_PID,ref string P_OUT) RPCFUNC ALIAS FOR "~"P_SET_PRODUCT_SCAN~""
subroutine P_INTERLOCK_SET_NSNP_MSG(string P_LINE_CODE,string P_MESSAGE,string P_MODEL_NAME,string P_MODEL_SUFFIX,string P_NSNP_REASON,string P_NSNP_ERROR_MESSAGE) RPCFUNC ALIAS FOR  "~"P_INTERLOCK_SET_NSNP_MSG~""
subroutine P_INTERLOCK_SET_NSNP_TIME_MSG(string P_LINE_CODE,string P_MESSAGE,double P_TIME,string P_MODEL_NAME,string P_MODEL_SUFFIX,string P_NSNP_REASON,string P_NSNP_ERROR_MESSAGE) RPCFUNC ALIAS FOR  "~"P_INTERLOCK_SET_NSNP_TIME_MSG~""

subroutine P_INTERLOCK_RESET_LINE(string P_LINE_CODE,string P_MODEL_NAME,ref string P_OUT) RPCFUNC ALIAS FOR  "~"P_INTERLOCK_RESET_LINE~""
subroutine P_CHECK_WS_RECEIPT_SCAN(string P_USER_ID ,string P_NEW_PID,ref string P_OUT,ref string P_MSG) RPCFUNC ALIAS FOR  "~"P_CHECK_WS_RECEIPT_SCAN~""
subroutine P_INTERLOCK_SENSOR_ACTUAL_NEO(string P_LINE_CODE,string P_WORKSTAGE_CODE,string P_MACHINE_CODE,double P_COUNT,double P_ACC_COUNT,ref string P_OUT) RPCFUNC ALIAS FOR  "~"P_INTERLOCK_SENSOR_ACTUAL_NEO~""
subroutine P_INTERLOCK_SENSOR_ACTUAL_MAN(string P_LINE_CODE,string P_WORKSTAGE_CODE,string P_MACHINE_CODE,double P_COUNT,double P_ACC_COUNT) RPCFUNC ALIAS FOR  "~"P_INTERLOCK_SENSOR_ACTUAL_MAN~""

subroutine P_INTERLOCK_SET_CHECK_DATA(string P_LINE_CODE,string P_WORKSTAGE_CODE,string P_MACHINE_CODE,string P_ITEM_CODE,string P_SERIAL_NO,string P_RESULT,string P_MAGAZINE_NO,string P_MAPPING_LABEL,string P_ATTRIBUTE1,string P_ATTRIBUTE2,string P_ATTRIBUTE3,ref string P_OUT) RPCFUNC ALIAS FOR  "~"P_INTERLOCK_SET_CHECK_DATA~""
subroutine P_CREATE_LINE_RESULT_INS(double P_ORGANIZATION_ID, datetime P_WORK_DATE) RPCFUNC ALIAS FOR  "~"P_CREATE_LINE_RESULT_INS~""
//$$HEX5$$5ccd85c880acacc02000$$ENDHEX$$
subroutine P_INTERLOCK_CHECK(string P_LINE_CODE,string P_WORKSTAGE_CODE,string P_MACHINE_CODE,string P_SERIAL_NO,string P_TYPE,ref string P_RESULT,ref string P_MESSAGE,ref string P_NG_MESSGAE,ref string P_OK_MESSAGE) RPCFUNC ALIAS FOR "~"P_INTERLOCK_CHECK~""
//FG ( Finish Goods ) $$HEX3$$85c7e0ac2000$$ENDHEX$$
subroutine P_PRODUCT_FG_RECEIPT(string p_barcode,string p_location, long p_txn, string p_commit,ref string p_out,ref string p_msg ) RPCFUNC ALIAS FOR "~"P_PRODUCT_FG_RECEIPT~""
subroutine P_PRODUCT_FG_MAGAZINE_RECEIPT(string p_barcode,string p_location, long p_txn, string p_commit,ref string p_out,ref string p_msg ) RPCFUNC ALIAS FOR "~"P_PRODUCT_FG_MAGAZINE_RECEIPT~""
//
subroutine P_CHECK_PDA_TB_SHAFT_INOUT(string P_LINE_CODE,string P_MODEL_NAME,string P_TOPBOT,string P_INOUT,string P_SHAFT,ref string P_ERR) RPCFUNC ALIAS FOR  "~"P_CHECK_PDA_TB_SHAFT_INOUT~""
subroutine P_CHECK_PDA_TB_INOUT(string P_LINE_CODE,string P_MODEL_NAME,string P_TOPBOT,string P_INOUT,ref string P_ERR) RPCFUNC ALIAS FOR  "~"P_CHECK_PDA_TB_INOUT~""
subroutine P_CHECK_PDA_TB_INOUT_PS(string P_LINE_CODE,string P_FEEDER_LAYOUT_NAME,string P_TOPBOT,string P_INOUT,string P_PS,ref string P_ERR) RPCFUNC ALIAS FOR "~"INFINITY21_JSLCD~".~"P_CHECK_PDA_TB_INOUT_PS~""


//========================================
//
//========================================
function double PLAN_ROUTING_EXPLOSION(string P_PRE_WORKSTAGE_CODE,datetime P_DATESET,double P_ORG) RPCFUNC ALIAS FOR "PKG_PLANNING.~"PLAN_ROUTING_EXPLOSION~""
function double PLAN_ROUTING_LOOP_CHECK(string P_PRE_WORKSTAGE_CODE,string P_WORKSTAGE_CODE,datetime P_DATESET,double P_ORG) RPCFUNC ALIAS FOR "PKG_PLANNING.~"PLAN_ROUTING_LOOP_CHECK~""

function double PLAN_ASSY_EXPLOSION(datetime P_PLAN_DATE,double P_PLAN_SEQUENCE,double P_ORG) RPCFUNC ALIAS FOR "PKG_PLANNING.~"PLAN_ASSY_EXPLOSION~""
function double PLAN_ASSY_EXPLOSION_ONESELF(datetime P_PLAN_DATE,double P_PLAN_SEQUENCE,double P_ORG) RPCFUNC ALIAS FOR " PKG_PLANNING.~"PLAN_ASSY_EXPLOSION_ONESELF~""

function double PLAN_PROD_EXPLOSION(datetime P_PLAN_DATE,double P_PLAN_SEQUENCE,double P_ORG) RPCFUNC ALIAS FOR "PKG_PLANNING.~"PLAN_PROD_EXPLOSION~""

function double PLAN_ASSY_PLAN_GEN(datetime P_PLAN_DATE,double P_PLAN_SEQUENCE,double P_ORG) RPCFUNC ALIAS FOR "PKG_PLANNING.~"PLAN_ASSY_PLAN_GEN~""
function double PLAN_ASSY_PLAN_GEN_ONESELF(datetime P_PLAN_DATE,double P_PLAN_SEQUENCE, string P_LINE_CODE , double P_ORG) RPCFUNC ALIAS FOR "PKG_PLANNING.~"PLAN_ASSY_PLAN_GEN_ONESELF~""

function double PLAN_WS_CHILD_ITEM_ISSUE_GEN(datetime P_PRODUCT_DATE,double P_PRODUCT_SEQUENCE,string P_MFS,string P_SUB_MFS,string P_ITEM_CODE,string P_LINE_CODE,string P_WORKSTAGE_CODE,string P_MACHINE_CODE,double P_PRODUCT_RESULT_QTY,double P_PRODUCT_RESULT_WEIGHT,string P_RESULT_STATUS,double P_ORG) RPCFUNC ALIAS FOR "PKG_PLANNING.~"PLAN_WS_CHILD_ITEM_ISSUE_GEN~""

end prototypes

on transaction1.create
call super::create
TriggerEvent( this, "constructor" )
end on

on transaction1.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

