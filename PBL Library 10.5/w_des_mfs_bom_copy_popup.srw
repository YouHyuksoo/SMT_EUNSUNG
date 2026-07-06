HA$PBExportHeader$w_des_mfs_bom_copy_popup.srw
forward
global type w_des_mfs_bom_copy_popup from w_popup_root
end type
type st_16 from so_statictext within w_des_mfs_bom_copy_popup
end type
type st_1 from so_statictext within w_des_mfs_bom_copy_popup
end type
type gb_2 from so_groupbox within w_des_mfs_bom_copy_popup
end type
type cb_1 from so_commandbutton within w_des_mfs_bom_copy_popup
end type
type cb_2 from so_commandbutton within w_des_mfs_bom_copy_popup
end type
type st_2 from so_statictext within w_des_mfs_bom_copy_popup
end type
type sle_source_mfs from so_singlelineedit within w_des_mfs_bom_copy_popup
end type
type sle_dest_mfs from so_singlelineedit within w_des_mfs_bom_copy_popup
end type
type sle_source_item_code from so_singlelineedit within w_des_mfs_bom_copy_popup
end type
type cb_3 from so_commandbutton within w_des_mfs_bom_copy_popup
end type
end forward

global type w_des_mfs_bom_copy_popup from w_popup_root
integer width = 3141
integer height = 2256
st_16 st_16
st_1 st_1
gb_2 gb_2
cb_1 cb_1
cb_2 cb_2
st_2 st_2
sle_source_mfs sle_source_mfs
sle_dest_mfs sle_dest_mfs
sle_source_item_code sle_source_item_code
cb_3 cb_3
end type
global w_des_mfs_bom_copy_popup w_des_mfs_bom_copy_popup

on w_des_mfs_bom_copy_popup.create
int iCurrent
call super::create
this.st_16=create st_16
this.st_1=create st_1
this.gb_2=create gb_2
this.cb_1=create cb_1
this.cb_2=create cb_2
this.st_2=create st_2
this.sle_source_mfs=create sle_source_mfs
this.sle_dest_mfs=create sle_dest_mfs
this.sle_source_item_code=create sle_source_item_code
this.cb_3=create cb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_16
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.gb_2
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.cb_2
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.sle_source_mfs
this.Control[iCurrent+8]=this.sle_dest_mfs
this.Control[iCurrent+9]=this.sle_source_item_code
this.Control[iCurrent+10]=this.cb_3
end on

on w_des_mfs_bom_copy_popup.destroy
call super::destroy
destroy(this.st_16)
destroy(this.st_1)
destroy(this.gb_2)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.st_2)
destroy(this.sle_source_mfs)
destroy(this.sle_dest_mfs)
destroy(this.sle_source_item_code)
destroy(this.cb_3)
end on

type p_title from w_popup_root`p_title within w_des_mfs_bom_copy_popup
integer width = 3127
end type

type cb_sort from w_popup_root`cb_sort within w_des_mfs_bom_copy_popup
boolean visible = true
integer x = 914
integer y = 812
integer width = 320
integer taborder = 70
integer weight = 400
end type

type cb_close from w_popup_root`cb_close within w_des_mfs_bom_copy_popup
boolean visible = true
integer x = 1888
integer y = 812
integer width = 320
integer taborder = 60
end type

event cb_close::clicked;call super::clicked;MESSAGE.DOUBLEPARM = -1
end event

type st_msg from w_popup_root`st_msg within w_des_mfs_bom_copy_popup
boolean visible = true
integer y = 200
integer width = 3127
end type

type dw_1 from w_popup_root`dw_1 within w_des_mfs_bom_copy_popup
boolean visible = true
integer x = 5
integer y = 932
integer width = 3118
integer height = 1236
integer taborder = 0
boolean titlebar = true
string title = "MFS BOM List"
string dataobject = "d_des_mfs_bom_popup"
end type

type dw_2 from w_popup_root`dw_2 within w_des_mfs_bom_copy_popup
boolean visible = true
integer y = 1292
integer taborder = 0
end type

type dw_3 from w_popup_root`dw_3 within w_des_mfs_bom_copy_popup
integer y = 1288
integer taborder = 80
end type

type st_16 from so_statictext within w_des_mfs_bom_copy_popup
integer x = 274
integer y = 432
integer width = 713
integer height = 72
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
boolean enabled = false
string text = "Source MFS"
alignment alignment = right!
end type

type st_1 from so_statictext within w_des_mfs_bom_copy_popup
integer x = 270
integer y = 528
integer width = 713
integer height = 68
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
boolean enabled = false
string text = "Source Item Code"
alignment alignment = right!
end type

type gb_2 from so_groupbox within w_des_mfs_bom_copy_popup
integer x = 32
integer y = 328
integer width = 3063
integer height = 456
integer weight = 700
long textcolor = 16711680
string text = "Copy Condition"
end type

type cb_1 from so_commandbutton within w_des_mfs_bom_copy_popup
integer x = 1563
integer y = 812
integer width = 320
integer height = 100
integer taborder = 50
boolean bringtotop = true
integer weight = 400
string text = "Copy"
end type

event clicked;DOUBLE LVL_RETURN
string lvs_source_item , lvs_source_mfs , lvs_dest_mfs
//====================================================
//
//====================================================
lvs_source_item = sle_source_item_code.text
lvs_source_mfs  =  sle_source_mfs.text 
lvs_dest_mfs      =  sle_dest_mfs.text 


if isnull(lvs_source_item) or lvs_source_item = '' or  isnull( lvs_dest_mfs) or lvs_dest_mfs ='' or isnull(lvs_source_mfs) or lvs_source_mfs = '' then 
   //Mess agebox("Notify" , "Copy Condition Invalid ")
   f_msg( "Copy Condition Invalid ", 'P') 
   Return
end if 

LVL_RETURN = f_mfs_bom_copy( lvs_source_item  ,lvs_source_mfs, lvs_dest_mfs , gvi_organization_id )

IF F_SQL_CHECK() < 0 THEN 
	RETURN
END IF

IF LVL_RETURN < 1 THEN 
     //MESSAGEBOX("Error" , "MFS  BOM Copy Failed! No Data Found")
	f_msg(  "MFS  BOM Copy Failed! No Data Found", 'P') 
	RETURN 
END IF
MSG = F_MSGBOX1( 9046 , sle_source_item_code.text+'  '+STRING(LVL_RETURN) )
		
//MSG = MESSAGEBOX("Notify", string(LVL_RETURN)+" "+UO_DEST_SET_ITEM.TEXT()+"	Rows Copied! Do You Wish To Save ?" , question! , yesno! )
IF MSG = 1 THEN 
	COMMIT ;
ELSE
	ROLLBACK;
	RETURN ;
END IF

MESSAGE.STRINGPARM = sle_source_item_code.text

CLOSE(PARENT)
end event

type cb_2 from so_commandbutton within w_des_mfs_bom_copy_popup
integer x = 1239
integer y = 812
integer width = 320
integer height = 100
integer taborder = 40
boolean bringtotop = true
integer weight = 400
string text = "Retrieve"
end type

event clicked;call super::clicked;dw_1.retrieve( sle_source_mfs.text  , gvi_organization_id )
end event

type st_2 from so_statictext within w_des_mfs_bom_copy_popup
integer x = 270
integer y = 628
integer width = 713
integer height = 68
boolean bringtotop = true
integer weight = 700
long textcolor = 255
boolean enabled = false
string text = "Dest MFS"
alignment alignment = right!
end type

type sle_source_mfs from so_singlelineedit within w_des_mfs_bom_copy_popup
integer x = 1088
integer y = 416
integer width = 521
integer height = 84
integer taborder = 120
boolean bringtotop = true
textcase textcase = upper!
end type

event modified;call super::modified;string lvs_item_code , lvs_source_mfs

lvs_source_mfs =this.text

select distinct item_code 
   into :lvs_item_code
  from id_mfs_bom
where mfs = :lvs_source_mfs
    and organization_id = :gvi_organization_id ;
	
if f_sql_check() < 0 then 
	return
end if

sle_source_item_code.text = lvs_item_code
end event

type sle_dest_mfs from so_singlelineedit within w_des_mfs_bom_copy_popup
integer x = 1088
integer y = 616
integer width = 521
integer height = 84
integer taborder = 10
boolean bringtotop = true
textcase textcase = upper!
end type

type sle_source_item_code from so_singlelineedit within w_des_mfs_bom_copy_popup
integer x = 1088
integer y = 516
integer width = 521
integer height = 84
integer taborder = 20
boolean bringtotop = true
textcase textcase = upper!
end type

type cb_3 from so_commandbutton within w_des_mfs_bom_copy_popup
integer x = 1614
integer y = 620
integer taborder = 20
boolean bringtotop = true
string text = "Show Plan"
end type

event clicked;call super::clicked;open(w_plan_master_popup)

if gst_return.gvb_return = false then 
else
	sle_dest_mfs.text = gst_return.gvs_return[1] 

end if 
end event

