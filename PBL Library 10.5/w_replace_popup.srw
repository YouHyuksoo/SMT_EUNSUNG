HA$PBExportHeader$w_replace_popup.srw
$PBExportComments$$$HEX6$$14bcb8af30ae08c7c4b3b0c6$$ENDHEX$$
forward
global type w_replace_popup from w_none_dw_popup_root
end type
type cb_replace_all from so_commandbutton within w_replace_popup
end type
type cb_replace from so_commandbutton within w_replace_popup
end type
type sle_replace from so_singlelineedit within w_replace_popup
end type
type st_2 from so_statictext within w_replace_popup
end type
type rb_2 from so_radiobutton within w_replace_popup
end type
type rb_1 from so_radiobutton within w_replace_popup
end type
type st_1 from so_statictext within w_replace_popup
end type
type sle_find from so_singlelineedit within w_replace_popup
end type
type cb_search from so_commandbutton within w_replace_popup
end type
type st_3 from so_statictext within w_replace_popup
end type
type rb_regular from so_radiobutton within w_replace_popup
end type
type rb_like from so_radiobutton within w_replace_popup
end type
type ddlb_col_name from so_dropdownlistbox within w_replace_popup
end type
type hpb_progress from hprogressbar within w_replace_popup
end type
type rb_string from so_radiobutton within w_replace_popup
end type
type rb_number from so_radiobutton within w_replace_popup
end type
type rb_date from so_radiobutton within w_replace_popup
end type
type rb_fill from so_radiobutton within w_replace_popup
end type
type cb_1 from so_commandbutton within w_replace_popup
end type
type gb_1 from so_groupbox within w_replace_popup
end type
type gb_2 from so_groupbox within w_replace_popup
end type
type gb_3 from so_groupbox within w_replace_popup
end type
end forward

global type w_replace_popup from w_none_dw_popup_root
integer x = 800
integer y = 876
integer width = 2798
integer height = 1092
string title = "Search Tool"
windowtype windowtype = popup!
cb_replace_all cb_replace_all
cb_replace cb_replace
sle_replace sle_replace
st_2 st_2
rb_2 rb_2
rb_1 rb_1
st_1 st_1
sle_find sle_find
cb_search cb_search
st_3 st_3
rb_regular rb_regular
rb_like rb_like
ddlb_col_name ddlb_col_name
hpb_progress hpb_progress
rb_string rb_string
rb_number rb_number
rb_date rb_date
rb_fill rb_fill
cb_1 cb_1
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_replace_popup w_replace_popup

type variables
string ivs_cancel_yn ='N'
end variables

on w_replace_popup.create
int iCurrent
call super::create
this.cb_replace_all=create cb_replace_all
this.cb_replace=create cb_replace
this.sle_replace=create sle_replace
this.st_2=create st_2
this.rb_2=create rb_2
this.rb_1=create rb_1
this.st_1=create st_1
this.sle_find=create sle_find
this.cb_search=create cb_search
this.st_3=create st_3
this.rb_regular=create rb_regular
this.rb_like=create rb_like
this.ddlb_col_name=create ddlb_col_name
this.hpb_progress=create hpb_progress
this.rb_string=create rb_string
this.rb_number=create rb_number
this.rb_date=create rb_date
this.rb_fill=create rb_fill
this.cb_1=create cb_1
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_replace_all
this.Control[iCurrent+2]=this.cb_replace
this.Control[iCurrent+3]=this.sle_replace
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.rb_2
this.Control[iCurrent+6]=this.rb_1
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.sle_find
this.Control[iCurrent+9]=this.cb_search
this.Control[iCurrent+10]=this.st_3
this.Control[iCurrent+11]=this.rb_regular
this.Control[iCurrent+12]=this.rb_like
this.Control[iCurrent+13]=this.ddlb_col_name
this.Control[iCurrent+14]=this.hpb_progress
this.Control[iCurrent+15]=this.rb_string
this.Control[iCurrent+16]=this.rb_number
this.Control[iCurrent+17]=this.rb_date
this.Control[iCurrent+18]=this.rb_fill
this.Control[iCurrent+19]=this.cb_1
this.Control[iCurrent+20]=this.gb_1
this.Control[iCurrent+21]=this.gb_2
this.Control[iCurrent+22]=this.gb_3
end on

on w_replace_popup.destroy
call super::destroy
destroy(this.cb_replace_all)
destroy(this.cb_replace)
destroy(this.sle_replace)
destroy(this.st_2)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.st_1)
destroy(this.sle_find)
destroy(this.cb_search)
destroy(this.st_3)
destroy(this.rb_regular)
destroy(this.rb_like)
destroy(this.ddlb_col_name)
destroy(this.hpb_progress)
destroy(this.rb_string)
destroy(this.rb_number)
destroy(this.rb_date)
destroy(this.rb_fill)
destroy(this.cb_1)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event key;IF key = keyescape! THEN 
	CB_CLOSE.TRIGGEREVENT('CLICKED')
END IF
end event

event open;call super::open;IF isvalid(selected_data_window) then 
	if selected_data_window.getrow() > 0 then 
		ddlb_col_name.text = selected_data_window.getcolumnname()
//		sle_column_name.text = selected_data_window.getcolumnname()
		sle_find.SETFOCUS()
	end if
end if


end event

type p_title from w_none_dw_popup_root`p_title within w_replace_popup
integer width = 2789
end type

type cb_close from w_none_dw_popup_root`cb_close within w_replace_popup
boolean visible = true
integer x = 2437
integer y = 780
integer width = 338
integer height = 108
integer taborder = 90
end type

type st_msg from w_none_dw_popup_root`st_msg within w_replace_popup
boolean visible = true
integer y = 912
integer width = 2789
boolean enabled = true
end type

type cb_replace_all from so_commandbutton within w_replace_popup
integer x = 2094
integer y = 780
integer width = 338
integer height = 108
integer taborder = 80
string text = "Replace All"
end type

event clicked;call super::clicked;if selected_data_window.getrow() < 1 then return
//if SLE_FIND.TEXT = '' then Return

datawindow ivd_data_window
String searchstr , lvs_col_name
lvs_col_name = UPPER(ddlb_col_name.text)
ivd_data_window = selected_data_window
if rb_regular.checked = true then

		 if rb_string.checked = true then
			
				if SLE_FIND.TEXT = '' or isnull(SLE_FIND.TEXT) then 
					searchstr = lvs_col_name+" = ''  or "+"isnull("+lvs_col_name+")"
				else
					searchstr = lvs_col_name+" = "+"'"+SLE_FIND.TEXT+"'"
				end if
				
		elseif rb_number.checked = true then 
			
				if SLE_FIND.TEXT = '' or isnull(SLE_FIND.TEXT) then 
					searchstr = "isnull("+lvs_col_name+")"
				else
					searchstr = lvs_col_name+" = "+SLE_FIND.TEXT
				end if			
		else
				if SLE_FIND.TEXT = '' or isnull(SLE_FIND.TEXT) then 
					searchstr = "isnull("+lvs_col_name+")"
				else
					searchstr = "String("+lvs_col_name+",'yyyymmdd') = "+"'"+SLE_FIND.TEXT+"'"
				end if			
		end if
	
elseif rb_like.checked = true then 
	
	searchstr = lvs_col_name+" LIKE "+"'%"+SLE_FIND.TEXT+"%'"	
	
else
	
	searchstr = "STRING("+lvs_col_name+")"+" <> '' "
	
end if

ST_MSG.TEXT = searchstr
long ll_find = 1, ll_end

ll_end = ivd_data_window.RowCount()
ll_find = ivd_data_window.Find(searchstr, ll_find, ll_end)

if ll_find < 0 then 
	return
end if

hpb_progress.setrange( 0 , ll_end )
hpb_progress.setstep = 1 

IF ll_find = 0 THEN 
	ST_MSG.TEXT = "No data Found =>"+searchstr
	RETURN
ELSE
		ivd_data_window.SCROLLTOROW(ll_find)  
		
		if rb_string.checked = true then 
			ivd_data_window.setitem( ll_find , lvs_col_name , sle_replace.text) 
		elseif rb_number.checked = true then 
			ivd_data_window.setitem( ll_find , lvs_col_name , Dec(sle_replace.text)) 			
		else
			ivd_data_window.setitem( ll_find , lvs_col_name , Date(sle_replace.text)) 						
		end if
		ST_MSG.TEXT = "Replaced"		
hpb_progress.stepit()
END IF

//========================================================
//
//========================================================

DO WHILE ll_find > 0
	
     Yield()
	if ivs_cancel_yn = 'Y' then 
		ivs_cancel_yn = 'N'
		return
	end if
        
        ll_find++
        IF ll_find > ll_end THEN EXIT
		  
        ll_find = ivd_data_window.Find(searchstr, ll_find, ll_end)
		  
	  IF  ll_find > 0 THEN 
		     ivd_data_window.SCROLLTOROW(ll_find)
			  
			if rb_string.checked = true then 
				
				ivd_data_window.setitem( ll_find , lvs_col_name , sle_replace.text) 
				
			elseif rb_number.checked = true then 
				
				ivd_data_window.setitem( ll_find , lvs_col_name , Dec(sle_replace.text)) 	
				
			else
				
				ivd_data_window.setitem( ll_find , lvs_col_name , Date(sle_replace.text)) 		
				
			end if
 			  ST_MSG.TEXT = "Replaced"		
hpb_progress.stepit()				
	
	 END IF
	 
LOOP
end event

type cb_replace from so_commandbutton within w_replace_popup
integer x = 1760
integer y = 780
integer width = 338
integer height = 108
integer taborder = 70
string text = "Replace"
end type

event clicked;call super::clicked;if selected_data_window.getrow() < 1 then return
//if SLE_FIND.TEXT = '' then Return

Datawindow ivd_data_window
String searchstr 

ivd_data_window = selected_data_window
if rb_regular.checked = true then 

		 if rb_string.checked = true then 	
			
				if SLE_FIND.TEXT = '' or isnull(SLE_FIND.TEXT) then 
					searchstr = ddlb_col_name.text+" = ''  or "+"isnull("+ddlb_col_name.text+")"
				else
					searchstr = ddlb_col_name.text+" = "+"'"+SLE_FIND.TEXT+"'"
				end if
		elseif rb_number.checked = true then 
			
				if SLE_FIND.TEXT = '' or isnull(SLE_FIND.TEXT) then 
					searchstr = "isnull("+ddlb_col_name.text+")"
				else
					searchstr = ddlb_col_name.text+" = "+SLE_FIND.TEXT
				end if			
		else
				if SLE_FIND.TEXT = '' or isnull(SLE_FIND.TEXT) then 
					searchstr = "isnull("+ddlb_col_name.text+")"
				else
					searchstr = ddlb_col_name.text+" = "+"'"+SLE_FIND.TEXT+"'"
				end if			
		end if
	
else
	searchstr = ddlb_col_name.text+" LIKE "+"'%"+SLE_FIND.TEXT+"%'"	
	
end if

ST_MSG.TEXT = searchstr
long ll_find = 1, ll_end

ll_end = ivd_data_window.RowCount()
ll_find = ivd_data_window.Find(searchstr, ll_find, ll_end)

IF ll_find = 0 THEN 
	ST_MSG.TEXT = "No data Found"
	RETURN
	
ELSE
	  ivd_data_window.SCROLLTOROW(ll_find)
	  msg = f_msgbox(142) //("Notify" , "Replace Text ?" , question! , yesno! )
	  IF MSG = 1 THEN 
		
		if rb_string.checked = true then 
			ivd_data_window.setitem( ll_find , ddlb_col_name.text , sle_replace.text) 
		elseif rb_number.checked = true then 
			ivd_data_window.setitem( ll_find , ddlb_col_name.text , Dec(sle_replace.text)) 			
		else
			ivd_data_window.setitem( ll_find , ddlb_col_name.text , Date(sle_replace.text)) 						
		end if
		
		ST_MSG.TEXT = "Replaced"		
	 ELSEIF MSG = 2 THEN 
		ST_MSG.TEXT = "Skip"				
	 ELSE
		ST_MSG.TEXT = "No Data Change"				
		RETURN
	  END IF
END IF

end event

type sle_replace from so_singlelineedit within w_replace_popup
integer x = 485
integer y = 508
integer width = 709
integer height = 92
integer taborder = 30
integer weight = 700
long backcolor = 16777215
end type

type st_2 from so_statictext within w_replace_popup
integer x = 55
integer y = 516
integer width = 407
integer height = 68
integer weight = 700
boolean enabled = false
string text = "Replace Text"
alignment alignment = right!
end type

type rb_2 from so_radiobutton within w_replace_popup
integer x = 2336
integer y = 412
integer width = 338
integer height = 76
integer weight = 700
string text = "Under"
end type

type rb_1 from so_radiobutton within w_replace_popup
integer x = 2336
integer y = 308
integer width = 338
integer height = 76
integer weight = 700
string text = "All"
boolean checked = true
end type

type st_1 from so_statictext within w_replace_popup
integer x = 55
integer y = 416
integer width = 407
integer height = 68
integer weight = 700
boolean enabled = false
string text = "Search Text"
alignment alignment = right!
end type

type sle_find from so_singlelineedit within w_replace_popup
integer x = 485
integer y = 408
integer width = 1157
integer height = 92
integer taborder = 20
integer weight = 700
long backcolor = 16777215
boolean autohscroll = false
end type

type cb_search from so_commandbutton within w_replace_popup
integer x = 1426
integer y = 780
integer width = 338
integer height = 108
integer taborder = 40
string text = "Search"
end type

event clicked;if selected_data_window.getrow() < 1 then return



//if SLE_FIND.TEXT = '' then Return
Datawindow ivd_data_window
String searchstr

ivd_data_window = selected_data_window
if rb_regular.checked = true then 
	
	if SLE_FIND.TEXT = '' or isnull(SLE_FIND.TEXT) then 
		searchstr = ddlb_col_name.text+" = ''  or "+"isnull("+ddlb_col_name.text+")"
	else
		searchstr = ddlb_col_name.text+" = "+"'"+SLE_FIND.TEXT+"'"
	end if
	
	
else
	searchstr = ddlb_col_name.text+" LIKE "+"'%"+SLE_FIND.TEXT+"%'"	
end if

ST_MSG.TEXT = searchstr
long ll_find = 1, ll_end

ll_end = ivd_data_window.RowCount()

ll_find = ivd_data_window.Find(searchstr, ll_find, ll_end)

IF ll_find = 0 THEN 
	ST_MSG.TEXT = "No data Found"
	RETURN
	
ELSE
	  ivd_data_window.SCROLLTOROW(ll_find)
	  msg = f_msgbox( 141 )//("Notify" , "Find Next ?" , question! , yesno! )
	  IF MSG = 1 THEN 
	  ELSE
		RETURN
	  END IF
END IF



DO WHILE ll_find > 0
        
        ll_find++
        IF ll_find > ll_end THEN EXIT
        ll_find = ivd_data_window.Find(searchstr, ll_find, ll_end)
		  
	  IF  ll_find > 0 THEN 
		ivd_data_window.SCROLLTOROW(ll_find)
	     msg = f_msgbox( 141 )	//("Notify" , "Find Next ?" , question! , yesno! )
		  IF MSG = 1 THEN 
		  ELSE
			RETURN
		  END IF
	
	 END IF
	 
LOOP
end event

type st_3 from so_statictext within w_replace_popup
integer x = 59
integer y = 316
integer width = 407
integer height = 68
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Column name"
alignment alignment = right!
end type

type rb_regular from so_radiobutton within w_replace_popup
integer x = 91
integer y = 772
integer width = 338
integer height = 76
boolean bringtotop = true
integer weight = 700
string text = "Regular"
boolean checked = true
end type

event clicked;call super::clicked;sle_find.enabled = true
cb_search.enabled = true
cb_replace.enabled = true
end event

type rb_like from so_radiobutton within w_replace_popup
integer x = 517
integer y = 768
integer width = 338
integer height = 76
boolean bringtotop = true
integer weight = 700
string text = "Like"
end type

event clicked;call super::clicked;sle_find.enabled = true
cb_search.enabled = true
cb_replace.enabled = true
end event

type ddlb_col_name from so_dropdownlistbox within w_replace_popup
integer x = 489
integer y = 312
integer width = 1152
integer taborder = 10
boolean bringtotop = true
boolean allowedit = true
boolean autohscroll = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;STRING ls_dwobject  ,lvs_col_name , lvs_col_type
Int lvi_count , li_objcount

Gst_dw_colinfo.i_dw_colcount = 0
Gst_dw_colinfo.i_dw_colcount=Integer(  selected_data_window.Describe("DataWindow.Column.Count"))

			ls_dwobject = selected_data_window.Object.DataWindow.Objects     // dw object list
			if len(trim(ls_dwobject)) = 0 then 
				return
			end if

			li_objcount = f_dual_lang_object_count(ls_dwobject)  // get object count

			//======================================================================
			// Column Object $$HEX2$$7cb92000$$ENDHEX$$Scan $$HEX2$$5cd5e4b2$$ENDHEX$$
			//======================================================================
			For lvi_count = 1 to Gst_dw_colinfo.i_dw_colcount
				lvs_col_name	= selected_data_window.Describe('#'+String(lvi_count)+".Name")
				lvs_col_type	= selected_data_window.Describe('#'+String(lvi_count)+".ColType")
				ddlb_col_name.additem(lvs_col_name)			
			Next
end event

type hpb_progress from hprogressbar within w_replace_popup
integer x = 1431
integer y = 692
integer width = 1339
integer height = 76
boolean bringtotop = true
unsignedinteger maxposition = 100
integer setstep = 1
end type

type rb_string from so_radiobutton within w_replace_popup
integer x = 1207
integer y = 516
integer width = 320
integer height = 72
boolean bringtotop = true
string text = "String"
boolean checked = true
end type

type rb_number from so_radiobutton within w_replace_popup
integer x = 1527
integer y = 516
integer width = 320
integer height = 72
boolean bringtotop = true
string text = "Number"
end type

type rb_date from so_radiobutton within w_replace_popup
integer x = 1865
integer y = 516
integer width = 320
integer height = 72
boolean bringtotop = true
string text = "Date"
end type

type rb_fill from so_radiobutton within w_replace_popup
integer x = 901
integer y = 768
integer width = 338
integer height = 76
boolean bringtotop = true
integer weight = 700
string text = "Fill"
end type

event clicked;call super::clicked;sle_find.enabled = false
cb_search.enabled = false
cb_replace.enabled = false
end event

type cb_1 from so_commandbutton within w_replace_popup
integer x = 2354
integer y = 548
integer width = 338
integer height = 108
integer taborder = 90
boolean bringtotop = true
string text = "Cancel"
end type

event clicked;call super::clicked;ivs_cancel_yn = 'Y'
end event

type gb_1 from so_groupbox within w_replace_popup
integer x = 2208
integer y = 224
integer width = 576
integer height = 304
integer weight = 700
long textcolor = 16711680
string text = "Execute Condition"
end type

type gb_2 from so_groupbox within w_replace_popup
integer x = 14
integer y = 676
integer width = 1353
integer height = 220
integer taborder = 50
integer weight = 700
string text = "Option"
end type

type gb_3 from so_groupbox within w_replace_popup
integer x = 18
integer y = 220
integer width = 2190
integer height = 432
integer taborder = 60
integer weight = 700
long textcolor = 16711680
string text = "Search  Condition"
end type

