HA$PBExportHeader$w_number_pad_popup.srw
forward
global type w_number_pad_popup from w_none_dw_popup_root
end type
type cb_bs from commandbutton within w_number_pad_popup
end type
type cb_return from commandbutton within w_number_pad_popup
end type
type cb_10 from commandbutton within w_number_pad_popup
end type
type st_status from statictext within w_number_pad_popup
end type
type cb_calc from commandbutton within w_number_pad_popup
end type
type cb_dot from commandbutton within w_number_pad_popup
end type
type cb_0 from commandbutton within w_number_pad_popup
end type
type cb_multiply from commandbutton within w_number_pad_popup
end type
type cb_divide from commandbutton within w_number_pad_popup
end type
type cb_plus from commandbutton within w_number_pad_popup
end type
type cb_minus from commandbutton within w_number_pad_popup
end type
type cb_00 from commandbutton within w_number_pad_popup
end type
type cb_9 from commandbutton within w_number_pad_popup
end type
type cb_8 from commandbutton within w_number_pad_popup
end type
type cb_7 from commandbutton within w_number_pad_popup
end type
type cb_6 from commandbutton within w_number_pad_popup
end type
type cb_5 from commandbutton within w_number_pad_popup
end type
type cb_4 from commandbutton within w_number_pad_popup
end type
type cb_3 from commandbutton within w_number_pad_popup
end type
type cb_2 from commandbutton within w_number_pad_popup
end type
type cb_1 from commandbutton within w_number_pad_popup
end type
type em_value from editmask within w_number_pad_popup
end type
type em_temp_value from editmask within w_number_pad_popup
end type
type cb_11 from commandbutton within w_number_pad_popup
end type
type cb_12 from commandbutton within w_number_pad_popup
end type
end forward

global type w_number_pad_popup from w_none_dw_popup_root
integer width = 914
integer height = 580
boolean titlebar = false
boolean controlmenu = false
long backcolor = 134217747
boolean contexthelp = false
cb_bs cb_bs
cb_return cb_return
cb_10 cb_10
st_status st_status
cb_calc cb_calc
cb_dot cb_dot
cb_0 cb_0
cb_multiply cb_multiply
cb_divide cb_divide
cb_plus cb_plus
cb_minus cb_minus
cb_00 cb_00
cb_9 cb_9
cb_8 cb_8
cb_7 cb_7
cb_6 cb_6
cb_5 cb_5
cb_4 cb_4
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
em_value em_value
em_temp_value em_temp_value
cb_11 cb_11
cb_12 cb_12
end type
global w_number_pad_popup w_number_pad_popup

type variables
string ivs_operator
string ivs_dot_yn
Decimal ivf_value
end variables

on w_number_pad_popup.create
int iCurrent
call super::create
this.cb_bs=create cb_bs
this.cb_return=create cb_return
this.cb_10=create cb_10
this.st_status=create st_status
this.cb_calc=create cb_calc
this.cb_dot=create cb_dot
this.cb_0=create cb_0
this.cb_multiply=create cb_multiply
this.cb_divide=create cb_divide
this.cb_plus=create cb_plus
this.cb_minus=create cb_minus
this.cb_00=create cb_00
this.cb_9=create cb_9
this.cb_8=create cb_8
this.cb_7=create cb_7
this.cb_6=create cb_6
this.cb_5=create cb_5
this.cb_4=create cb_4
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.em_value=create em_value
this.em_temp_value=create em_temp_value
this.cb_11=create cb_11
this.cb_12=create cb_12
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_bs
this.Control[iCurrent+2]=this.cb_return
this.Control[iCurrent+3]=this.cb_10
this.Control[iCurrent+4]=this.st_status
this.Control[iCurrent+5]=this.cb_calc
this.Control[iCurrent+6]=this.cb_dot
this.Control[iCurrent+7]=this.cb_0
this.Control[iCurrent+8]=this.cb_multiply
this.Control[iCurrent+9]=this.cb_divide
this.Control[iCurrent+10]=this.cb_plus
this.Control[iCurrent+11]=this.cb_minus
this.Control[iCurrent+12]=this.cb_00
this.Control[iCurrent+13]=this.cb_9
this.Control[iCurrent+14]=this.cb_8
this.Control[iCurrent+15]=this.cb_7
this.Control[iCurrent+16]=this.cb_6
this.Control[iCurrent+17]=this.cb_5
this.Control[iCurrent+18]=this.cb_4
this.Control[iCurrent+19]=this.cb_3
this.Control[iCurrent+20]=this.cb_2
this.Control[iCurrent+21]=this.cb_1
this.Control[iCurrent+22]=this.em_value
this.Control[iCurrent+23]=this.em_temp_value
this.Control[iCurrent+24]=this.cb_11
this.Control[iCurrent+25]=this.cb_12
end on

on w_number_pad_popup.destroy
call super::destroy
destroy(this.cb_bs)
destroy(this.cb_return)
destroy(this.cb_10)
destroy(this.st_status)
destroy(this.cb_calc)
destroy(this.cb_dot)
destroy(this.cb_0)
destroy(this.cb_multiply)
destroy(this.cb_divide)
destroy(this.cb_plus)
destroy(this.cb_minus)
destroy(this.cb_00)
destroy(this.cb_9)
destroy(this.cb_8)
destroy(this.cb_7)
destroy(this.cb_6)
destroy(this.cb_5)
destroy(this.cb_4)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.em_value)
destroy(this.em_temp_value)
destroy(this.cb_11)
destroy(this.cb_12)
end on

event key;call super::key;if key = Key1! then
   cb_1.triggerevent(clicked!)	
elseif key = Key2! then
   cb_2.triggerevent(clicked!)	
elseif key = Key3! then
   cb_3.triggerevent(clicked!)		
elseif key = Key4! then
   cb_4.triggerevent(clicked!)			
elseif key = Key5! then
   cb_5.triggerevent(clicked!)			
elseif key = Key6! then
   cb_6.triggerevent(clicked!)			
elseif key = Key7! then
   cb_7.triggerevent(clicked!)			
elseif key = Key8! then
   cb_8.triggerevent(clicked!)			
elseif key = Key9! then
   cb_9.triggerevent(clicked!)			
elseif key = Key0! then
   cb_0.triggerevent(clicked!)			
elseif key = KeyBack! then 
   cb_bs.triggerevent(clicked!)				
	
elseif key = KeyMultiply! then
   cb_multiply.triggerevent(clicked!)					
elseif key = KeyAdd!   then
   cb_plus.triggerevent(clicked!)					
	
elseif key = KeySubtract!    then
   cb_minus.triggerevent(clicked!)						
	
elseif key = KeyDivide! or key = KeySlash!    then
   cb_divide.triggerevent(clicked!)							
	
elseif key = KeyDecimal!  then 
   cb_dot.triggerevent(clicked!)							

elseif key = KeyEqual!  then 
	cb_calc.triggerevent(clicked!)							

elseif key = KeyEnter!  then 
	cb_return.triggerevent(clicked!)								
end if 

end event

event open;call super::open;long lvl_distanceX , lvl_distanceY , wsh , th , py


this.x = w_main_frame.Pointerx() + w_main_frame.x
this.y = w_main_frame.PointerY() +  w_main_frame.y

em_value.text = String(Message.DoubleParm)

if  Message.DoubleParm < 1 and Message.DoubleParm > 0 then 
	ivs_dot_yn = 'Y'    
end if
end event

type p_title from w_none_dw_popup_root`p_title within w_number_pad_popup
boolean visible = false
end type

type cb_close from w_none_dw_popup_root`cb_close within w_number_pad_popup
integer x = 14
integer y = 688
integer taborder = 0
end type

type st_msg from w_none_dw_popup_root`st_msg within w_number_pad_popup
end type

type cb_bs from commandbutton within w_number_pad_popup
integer x = 677
integer y = 108
integer width = 215
integer height = 92
integer taborder = 140
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "hand.ani"
string text = "< BS"
end type

event clicked;if ivs_dot_yn = 'Y' THEN 
	em_value.text =  Mid( em_value.text , 1, Len(em_value.text) - 1)
else
	em_value.text =  Mid( em_value.text , 1,  POS( 	 em_value.text , '.' , 1 ) -2 )
end if
end event

type cb_return from commandbutton within w_number_pad_popup
integer x = 677
integer y = 464
integer width = 215
integer height = 92
integer taborder = 200
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "hand.ani"
string text = "OK"
boolean default = true
end type

event clicked;IF ivs_operator <> '' THEN 
	cb_calc.triggerevent(clicked!)
END IF

Gst_return.Gvb_return = True
closewithreturn(parent , Dec(em_value.text))
end event

type cb_10 from commandbutton within w_number_pad_popup
integer x = 462
integer y = 108
integer width = 215
integer height = 92
integer taborder = 130
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "hand.ani"
string text = "C"
end type

event clicked;em_temp_value.text = ''
em_value.text = ''
st_status.text = ''
ivs_operator = ''
ivs_dot_yn = 'N'
ivf_value = 0
end event

type st_status from statictext within w_number_pad_popup
integer x = 672
integer y = 12
integer width = 201
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 134217747
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type cb_calc from commandbutton within w_number_pad_popup
integer x = 462
integer y = 372
integer width = 425
integer height = 92
integer taborder = 190
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "hand.ani"
string text = "="
end type

event clicked;if ivs_operator = '-' then 
	em_value.text = STRING(Dec(em_value.text) - Dec(em_temp_value.text))
elseif ivs_operator = '+' then 
	em_value.text = STRING(Dec(em_value.text) + Dec(em_temp_value.text))
elseif ivs_operator = '/' then 
	em_value.text = STRING(Dec(em_value.text) / Dec(em_temp_value.text))
elseif ivs_operator = '*' then 
	em_value.text = STRING(Dec(em_value.text) * Dec(em_temp_value.text))
end if 

em_temp_value.text = ''
ivs_operator = ''
st_status.text = ''
ivs_dot_yn = 'N'
em_value.bringtotop = true
end event

type cb_dot from commandbutton within w_number_pad_popup
integer x = 306
integer y = 376
integer width = 151
integer height = 92
integer taborder = 120
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "hand.ani"
string text = "."
end type

event clicked;ivs_dot_yn = 'Y'
st_status.text = 'DOT'

//if ivs_operator <> '' then 
//	em_temp_value.text = em_temp_value.text + this.text	
//else
//	em_value.text = em_value.text+this.text
//end if
end event

type cb_0 from commandbutton within w_number_pad_popup
integer y = 376
integer width = 151
integer height = 92
integer taborder = 100
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "hand.ani"
string text = "0"
end type

event clicked;IF ivs_dot_yn = 'Y' THEN

	if ivs_operator <> '' then 
		em_temp_value.text = em_temp_value.text + this.text	
	else
		em_value.text = em_value.text+this.text
	end if
	
ELSE
	
	if ivs_operator <> '' then 
		em_temp_value.text = MID( em_temp_value.text , 1 , POS( em_temp_value.text , '.' , 1 ) - 1) +this.text
	else
		em_value.text = MID( em_value.text , 1 , POS( em_value.text , '.' , 1 ) - 1) +this.text
	end if
	
END IF 



end event

type cb_multiply from commandbutton within w_number_pad_popup
integer x = 677
integer y = 284
integer width = 215
integer height = 92
integer taborder = 180
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "hand.ani"
string text = "*"
end type

event clicked;cb_calc.triggerevent(clicked!)
ivs_operator = '*'
st_status.text = '*'
ivs_dot_yn = 'N'
em_temp_value.bringtotop = true
end event

type cb_divide from commandbutton within w_number_pad_popup
integer x = 462
integer y = 284
integer width = 215
integer height = 92
integer taborder = 170
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "hand.ani"
string text = "/"
end type

event clicked;cb_calc.triggerevent(clicked!)
ivs_operator = '/'
st_status.text = '/'
ivs_dot_yn = 'N'
em_temp_value.bringtotop = true
end event

type cb_plus from commandbutton within w_number_pad_popup
integer x = 677
integer y = 196
integer width = 215
integer height = 92
integer taborder = 160
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "hand.ani"
string text = "+"
end type

event clicked;cb_calc.triggerevent(clicked!)
ivs_operator = '+'
st_status.text = '+'
ivs_dot_yn = 'N'
em_temp_value.bringtotop = true
end event

type cb_minus from commandbutton within w_number_pad_popup
integer x = 462
integer y = 196
integer width = 215
integer height = 92
integer taborder = 150
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "hand.ani"
string text = "-"
end type

event clicked;cb_calc.triggerevent(clicked!)

ivs_operator = '-'
st_status.text = '-'
ivs_dot_yn = 'N'
em_temp_value.bringtotop = true
end event

type cb_00 from commandbutton within w_number_pad_popup
integer x = 151
integer y = 376
integer width = 151
integer height = 92
integer taborder = 110
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "hand.ani"
string text = "00"
end type

event clicked;IF ivs_dot_yn = 'Y' THEN

	if ivs_operator <> '' then 
		em_temp_value.text = em_temp_value.text + this.text	
	else
		em_value.text = em_value.text+this.text
	end if
	
ELSE
	
	if ivs_operator <> '' then 
		em_temp_value.text = MID( em_temp_value.text , 1 , POS( em_temp_value.text , '.' , 1 ) - 1) +this.text
	else
		em_value.text = MID( em_value.text , 1 , POS( em_value.text , '.' , 1 ) - 1) +this.text
	end if
	
END IF 



end event

type cb_9 from commandbutton within w_number_pad_popup
integer x = 306
integer y = 284
integer width = 151
integer height = 92
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "hand.ani"
string text = "9"
end type

event clicked;IF ivs_dot_yn = 'Y' THEN

	if ivs_operator <> '' then 
		em_temp_value.text = em_temp_value.text + this.text	
	else
		em_value.text = em_value.text+this.text
	end if
	
ELSE
	
	if ivs_operator <> '' then 
		em_temp_value.text = MID( em_temp_value.text , 1 , POS( em_temp_value.text , '.' , 1 ) - 1) +this.text
	else
		em_value.text = MID( em_value.text , 1 , POS( em_value.text , '.' , 1 ) - 1) +this.text
	end if
	
END IF 



end event

type cb_8 from commandbutton within w_number_pad_popup
integer x = 151
integer y = 284
integer width = 151
integer height = 92
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "hand.ani"
string text = "8"
end type

event clicked;IF ivs_dot_yn = 'Y' THEN

	if ivs_operator <> '' then 
		em_temp_value.text = em_temp_value.text + this.text	
	else
		em_value.text = em_value.text+this.text
	end if
	
ELSE
	
	if ivs_operator <> '' then 
		em_temp_value.text = MID( em_temp_value.text , 1 , POS( em_temp_value.text , '.' , 1 ) - 1) +this.text
	else
		em_value.text = MID( em_value.text , 1 , POS( em_value.text , '.' , 1 ) - 1) +this.text
	end if
	
END IF 



end event

type cb_7 from commandbutton within w_number_pad_popup
integer y = 284
integer width = 151
integer height = 92
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "hand.ani"
string text = "7"
end type

event clicked;IF ivs_dot_yn = 'Y' THEN

	if ivs_operator <> '' then 
		em_temp_value.text = em_temp_value.text + this.text	
	else
		em_value.text = em_value.text+this.text
	end if
	
ELSE
	
	if ivs_operator <> '' then 
		em_temp_value.text = MID( em_temp_value.text , 1 , POS( em_temp_value.text , '.' , 1 ) - 1) +this.text
	else
		em_value.text = MID( em_value.text , 1 , POS( em_value.text , '.' , 1 ) - 1) +this.text
	end if
	
END IF 



end event

type cb_6 from commandbutton within w_number_pad_popup
integer x = 306
integer y = 196
integer width = 151
integer height = 92
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "hand.ani"
string text = "6"
end type

event clicked;IF ivs_dot_yn = 'Y' THEN

	if ivs_operator <> '' then 
		em_temp_value.text = em_temp_value.text + this.text	
	else
		em_value.text = em_value.text+this.text
	end if
	
ELSE
	
	if ivs_operator <> '' then 
		em_temp_value.text = MID( em_temp_value.text , 1 , POS( em_temp_value.text , '.' , 1 ) - 1) +this.text
	else
		em_value.text = MID( em_value.text , 1 , POS( em_value.text , '.' , 1 ) - 1) +this.text
	end if
	
END IF 



end event

type cb_5 from commandbutton within w_number_pad_popup
integer x = 151
integer y = 196
integer width = 151
integer height = 92
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "hand.ani"
string text = "5"
end type

event clicked;IF ivs_dot_yn = 'Y' THEN

	if ivs_operator <> '' then 
		em_temp_value.text = em_temp_value.text + this.text	
	else
		em_value.text = em_value.text+this.text
	end if
	
ELSE
	
	if ivs_operator <> '' then 
		em_temp_value.text = MID( em_temp_value.text , 1 , POS( em_temp_value.text , '.' , 1 ) - 1) +this.text
	else
		em_value.text = MID( em_value.text , 1 , POS( em_value.text , '.' , 1 ) - 1) +this.text
	end if
	
END IF 



end event

type cb_4 from commandbutton within w_number_pad_popup
integer y = 196
integer width = 151
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "hand.ani"
string text = "4"
end type

event clicked;IF ivs_dot_yn = 'Y' THEN

	if ivs_operator <> '' then 
		em_temp_value.text = em_temp_value.text + this.text	
	else
		em_value.text = em_value.text+this.text
	end if
	
ELSE
	
	if ivs_operator <> '' then 
		em_temp_value.text = MID( em_temp_value.text , 1 , POS( em_temp_value.text , '.' , 1 ) - 1) +this.text
	else
		em_value.text = MID( em_value.text , 1 , POS( em_value.text , '.' , 1 ) - 1) +this.text
	end if
	
END IF 



end event

type cb_3 from commandbutton within w_number_pad_popup
integer x = 306
integer y = 108
integer width = 151
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "hand.ani"
string text = "3"
end type

event clicked;IF ivs_dot_yn = 'Y' THEN

	if ivs_operator <> '' then 
		em_temp_value.text = em_temp_value.text + this.text	
	else
		em_value.text = em_value.text+this.text
	end if
	
ELSE
	
	if ivs_operator <> '' then 
		em_temp_value.text = MID( em_temp_value.text , 1 , POS( em_temp_value.text , '.' , 1 ) - 1) +this.text
	else
		em_value.text = MID( em_value.text , 1 , POS( em_value.text , '.' , 1 ) - 1) +this.text
	end if
	
END IF 



end event

type cb_2 from commandbutton within w_number_pad_popup
integer x = 151
integer y = 108
integer width = 151
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "hand.ani"
string text = "2"
end type

event clicked;IF ivs_dot_yn = 'Y' THEN

	if ivs_operator <> '' then 
		em_temp_value.text = em_temp_value.text + this.text	
	else
		em_value.text = em_value.text+this.text
	end if
	
ELSE
	
	if ivs_operator <> '' then 
		em_temp_value.text = MID( em_temp_value.text , 1 , POS( em_temp_value.text , '.' , 1 ) - 1) +this.text
	else
		em_value.text = MID( em_value.text , 1 , POS( em_value.text , '.' , 1 ) - 1) +this.text
	end if
	
END IF 



end event

type cb_1 from commandbutton within w_number_pad_popup
integer y = 108
integer width = 151
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "hand.ani"
string text = "1"
end type

event clicked;IF ivs_dot_yn = 'Y' THEN

	if ivs_operator <> '' then 
		em_temp_value.text = em_temp_value.text + this.text	
	else
		em_value.text = em_value.text+this.text
	end if
	
ELSE
	
	if ivs_operator <> '' then 
		em_temp_value.text = MID( em_temp_value.text , 1 , POS( em_temp_value.text , '.' , 1 ) - 1) +this.text
	else
		em_value.text = MID( em_value.text , 1 , POS( em_value.text , '.' , 1 ) - 1) +this.text
	end if
	
END IF 



end event

type em_value from editmask within w_number_pad_popup
integer x = 5
integer width = 654
integer height = 100
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 65280
long backcolor = 0
alignment alignment = right!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
string mask = "###,###,##0.####"
boolean spin = true
double increment = 1
string minmax = "1~~"
end type

event modified;
ivf_value = Dec(this.text)
end event

type em_temp_value from editmask within w_number_pad_popup
integer x = 5
integer y = 8
integer width = 654
integer height = 92
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 65280
long backcolor = 0
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "#,###,###,###.####"
boolean spin = true
end type

type cb_11 from commandbutton within w_number_pad_popup
integer x = 462
integer y = 464
integer width = 215
integer height = 92
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "hand.ani"
string text = "Cancel"
end type

event clicked;Gst_return.Gvb_return = false
closewithreturn(parent , 0)
end event

type cb_12 from commandbutton within w_number_pad_popup
integer y = 464
integer width = 302
integer height = 92
integer taborder = 110
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "hand.ani"
string text = "Minsus"
end type

event clicked;em_value.text = String( abs(Double(em_value.text )) * -1 )
end event

