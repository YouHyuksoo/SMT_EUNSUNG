HA$PBExportHeader$w_qc_bad_reason_popup.srw
$PBExportComments$$$HEX10$$f9b2d4c6c4ac8dd61cc888bc20c1ddd01dd3c5c5$$ENDHEX$$
forward
global type w_qc_bad_reason_popup from w_popup_root
end type
type cb_retrieve from so_commandbutton within w_qc_bad_reason_popup
end type
type cb_select from so_commandbutton within w_qc_bad_reason_popup
end type
type st_2 from so_statictext within w_qc_bad_reason_popup
end type
type sle_code_name from so_singlelineedit within w_qc_bad_reason_popup
end type
type st_1 from so_statictext within w_qc_bad_reason_popup
end type
type ddlb_code_group from uo_qc_code_group_popup within w_qc_bad_reason_popup
end type
type gb_1 from so_groupbox within w_qc_bad_reason_popup
end type
type gb_2 from so_groupbox within w_qc_bad_reason_popup
end type
end forward

global type w_qc_bad_reason_popup from w_popup_root
integer width = 3643
integer height = 2052
string title = "QC Bad Reason Master Popup"
cb_retrieve cb_retrieve
cb_select cb_select
st_2 st_2
sle_code_name sle_code_name
st_1 st_1
ddlb_code_group ddlb_code_group
gb_1 gb_1
gb_2 gb_2
end type
global w_qc_bad_reason_popup w_qc_bad_reason_popup

type prototypes

end prototypes

type variables
string lvs_code_type
end variables

on w_qc_bad_reason_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.cb_select=create cb_select
this.st_2=create st_2
this.sle_code_name=create sle_code_name
this.st_1=create st_1
this.ddlb_code_group=create ddlb_code_group
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.cb_select
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.sle_code_name
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.ddlb_code_group
this.Control[iCurrent+7]=this.gb_1
this.Control[iCurrent+8]=this.gb_2
end on

on w_qc_bad_reason_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.cb_select)
destroy(this.st_2)
destroy(this.sle_code_name)
destroy(this.st_1)
destroy(this.ddlb_code_group)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;call super::open;
dw_1.settransobject(sqlca)
lvs_code_type = MESSAGE.STRINGPARM 

cb_retrieve.triggerevent(CLICKED!)
IVS_MOUSEMOVE_YN = 'N'
end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
end if
end event

type p_title from w_popup_root`p_title within w_qc_bad_reason_popup
integer width = 3625
end type

type cb_sort from w_popup_root`cb_sort within w_qc_bad_reason_popup
boolean visible = true
integer x = 2459
integer y = 344
integer height = 128
end type

type cb_close from w_popup_root`cb_close within w_qc_bad_reason_popup
boolean visible = true
integer x = 3296
integer y = 344
integer height = 128
end type

event cb_close::clicked;gst_return.gvb_return = false
Close(parent)
end event

type st_msg from w_popup_root`st_msg within w_qc_bad_reason_popup
boolean visible = true
integer x = 5
integer y = 560
integer width = 3625
end type

type dw_1 from w_popup_root`dw_1 within w_qc_bad_reason_popup
boolean visible = true
integer x = 5
integer y = 652
integer width = 3625
integer height = 1312
boolean titlebar = true
string dataobject = "d_qc_bad_reason_popup"
end type

event dw_1::doubleclicked;call super::doubleclicked;IF ROW = 0  THEN 
	RETURN -1
END IF
cb_select.triggerevent(clicked!)
end event

type dw_2 from w_popup_root`dw_2 within w_qc_bad_reason_popup
boolean visible = true
integer y = 800
end type

type dw_3 from w_popup_root`dw_3 within w_qc_bad_reason_popup
integer y = 656
end type

type cb_retrieve from so_commandbutton within w_qc_bad_reason_popup
integer x = 2738
integer y = 344
integer width = 274
integer height = 128
integer taborder = 70
boolean bringtotop = true
string text = "Retrieve"
end type

event clicked;SETPOINTER(HOURGLASS!)

DW_1.RETRIEVE(  ddlb_code_group.TEXT()+'%' , lvs_code_type , SLE_CODE_NAME.TEXT+'%' , GVI_ORGANIZATION_ID )

end event

type cb_select from so_commandbutton within w_qc_bad_reason_popup
integer x = 3017
integer y = 344
integer width = 274
integer height = 128
integer taborder = 80
boolean bringtotop = true
string text = "Select"
boolean default = true
end type

event clicked;if dw_1.getrow() < 1 then 
	gst_return.gvb_return = false
	return -1 
end if 

gst_return.gvb_return = true 
message.stringparm = dw_1.object.code_name[dw_1.getrow()]
//Gst_return.gvf_return[1]= dw_1.object.product_sale_price[dw_1.getrow()]
//Gst_return.gvs_return[1] =  dw_1.object.sale_currency[dw_1.getrow( )]
//Gst_return.gvs_return[2] =  dw_1.object.customer_code[dw_1.getrow( )]
//Gst_return.gvs_return[3] =  dw_1.object.product_line_type[dw_1.getrow( )]
closewithreturn(parent , message.stringparm)



end event

type st_2 from so_statictext within w_qc_bad_reason_popup
integer x = 782
integer y = 312
integer width = 686
boolean bringtotop = true
integer weight = 700
string text = "Code Name"
end type

type sle_code_name from so_singlelineedit within w_qc_bad_reason_popup
integer x = 782
integer y = 392
integer width = 686
integer height = 84
integer taborder = 10
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

event getfocus;this.selecttext( 1 , len( this.text) )
this.Borderstyle = styleraised!
end event

event losefocus;this.Borderstyle = styleLowered!
end event

event ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

LVS_COLUMN = 'CODE_NAME'

IF ISNULL(LVS_COLUMN) OR LEN(LVS_COLUMN) = 0 THEN RETURN 

DW_1.SETFILTER('')
DW_1.FILTER()

IF THIS.TEXT = '' THEN 
	LVS_VALUE = '%'
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

DW_1.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
DW_1.FILTER()
F_MSG_MDI_HELP( STRING( DW_1.ROWCOUNT() ) + " Found" )

end event

type st_1 from so_statictext within w_qc_bad_reason_popup
integer x = 73
integer y = 308
integer width = 608
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Code Group"
end type

type ddlb_code_group from uo_qc_code_group_popup within w_qc_bad_reason_popup
integer x = 27
integer y = 392
integer width = 750
integer taborder = 20
boolean bringtotop = true
end type

event getfocus;call super::getfocus;STRING LVS_VALUE

DECLARE CL1 CURSOR FOR
SELECT DISTINCT CODE_GROUP
  FROM ISYS_CODE_MASTER
 WHERE  CODE_TYPE = :LVS_CODE_TYPE AND
             ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;

	
 THIS.RESET()
 THIS.ADDITEM('%') 
 OPEN CL1;
 
 DO 
 FETCH CL1 INTO :LVS_VALUE ;
 
 IF F_SQL_CHECK() < 0 THEN 
	 CLOSE CL1 ;
	 RETURN 
 END IF
 
 
 IF SQLCA.SQLCODE = 100 THEN 
	 CLOSE CL1 ;
	 EXIT
 END IF
 
      THIS.ADDITEM( LVS_VALUE ) 

LOOP UNTIL 1 = 2

end event

type gb_1 from so_groupbox within w_qc_bad_reason_popup
integer x = 2382
integer y = 220
integer width = 1239
integer height = 328
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_2 from so_groupbox within w_qc_bad_reason_popup
integer x = 9
integer y = 244
integer width = 1536
integer height = 288
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

