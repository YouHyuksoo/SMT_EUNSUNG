HA$PBExportHeader$w_item_search_flat.srw
forward
global type w_item_search_flat from window
end type
type st_2 from so_statictext within w_item_search_flat
end type
type sle_1 from so_singlelineedit within w_item_search_flat
end type
type st_1 from so_statictext within w_item_search_flat
end type
type sle_item_code from so_singlelineedit within w_item_search_flat
end type
type dw_1 from datawindow within w_item_search_flat
end type
end forward

global type w_item_search_flat from window
integer width = 3557
integer height = 1976
boolean titlebar = true
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "OleGenReg!"
boolean center = true
event ue_post_open ( )
st_2 st_2
sle_1 sle_1
st_1 st_1
sle_item_code sle_item_code
dw_1 dw_1
end type
global w_item_search_flat w_item_search_flat

type variables
uo_item_code uo_item
Boolean ib_getfocus = false
end variables

forward prototypes
public function integer of_search (string as_item_code)
end prototypes

event ue_post_open();f_set_column_dddw(dw_1)
f_dual_lang_change_text(this)
dw_1.reset()
dw_1.retrieve( '%' , gvi_organization_id )

//sle_item_code.setfocus( )
sle_item_code.text = UPPER(message.stringparm)
sle_item_code.selecttext( len(sle_item_code.text)+1 , 0 )

end event

public function integer of_search (string as_item_code);return 1
end function

on w_item_search_flat.create
this.st_2=create st_2
this.sle_1=create sle_1
this.st_1=create st_1
this.sle_item_code=create sle_item_code
this.dw_1=create dw_1
this.Control[]={this.st_2,&
this.sle_1,&
this.st_1,&
this.sle_item_code,&
this.dw_1}
end on

on w_item_search_flat.destroy
destroy(this.st_2)
destroy(this.sle_1)
destroy(this.st_1)
destroy(this.sle_item_code)
destroy(this.dw_1)
end on

event open;dw_1.settransobject( sqlca)
this.setredraw( false)
f_set_layered_window( handle(this) , 85 )
//uo_item = message.powerobjectparm 
//this.setredraw( TRUE)
postevent('ue_post_open')
end event

event key;if Key = KeyEscape! then 
	closewithreturn(this , sle_item_code.text)
elseif Key = KeyDownArrow! then 

	dw_1.scrollnextrow()
	
elseif Key = KeyUpArrow! then 

	dw_1.scrollpriorrow( )
	
elseif Key = KeyEnter! then 	
		
	string lvs_item_code
	
	if dw_1.getrow() < 1 then
		CLOSEwithreturn(w_item_search_flat ,sle_item_code.text )
		
	else
	
		lvs_item_code = string(dw_1.object.item_code[dw_1.getrow()])
		CLOSEwithreturn(w_item_search_flat ,lvs_item_code )
	
	end if 		
		
end if
end event

type st_2 from so_statictext within w_item_search_flat
integer x = 1024
integer y = 16
integer width = 315
integer height = 64
long backcolor = 67108864
string text = "Item Name"
end type

type sle_1 from so_singlelineedit within w_item_search_flat
integer x = 1353
integer y = 8
integer width = 672
integer taborder = 11
textcase textcase = upper!
end type

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

dw_1.SETFILTER('')
dw_1.FILTER()

LVS_COLUMN = 'ITEM_NAME'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    dw_1.SETFILTER('')
    dw_1.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

dw_1.SETFILTER( "upper("+LVS_COLUMN  +") LIKE '"+LVS_VALUE+"'")
dw_1.FILTER()

dw_1.SelectRow(0, false)
dw_1.SelectRow(1, true)
end event

type st_1 from so_statictext within w_item_search_flat
integer x = 9
integer y = 16
integer width = 315
integer height = 64
long backcolor = 67108864
string text = "Item Code"
end type

type sle_item_code from so_singlelineedit within w_item_search_flat
integer x = 334
integer y = 8
integer width = 672
integer taborder = 1
textcase textcase = upper!
end type

event modified;call super::modified;if dw_1.rowcount() < 1 then 
	CLOSEWITHRETURN(PARENT , this.text)	
elseif dw_1.rowcount() = 1 then
	CLOSEWITHRETURN(PARENT , string(dw_1.object.item_code[1]))
else
	
end if 
end event

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

dw_1.SETFILTER('')
dw_1.FILTER()

LVS_COLUMN = 'ITEM_CODE'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    dw_1.SETFILTER('')
    dw_1.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

dw_1.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
dw_1.FILTER()
dw_1.SelectRow(0, false)
dw_1.SelectRow(1, true)
end event

type dw_1 from datawindow within w_item_search_flat
integer y = 100
integer width = 3547
integer height = 1804
string title = "none"
string dataobject = "d_des_item_flat_popup"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = styleraised!
end type

event doubleclicked;string lvs_item_code

if row < 1 then
	return
else

	lvs_item_code = string(this.object.item_code[row])
	CLOSEwithreturn(w_item_search_flat ,lvs_item_code )

end if 
end event

event rowfocuschanged;This.SelectRow(0, false)
This.SelectRow(currentrow, true)
end event

