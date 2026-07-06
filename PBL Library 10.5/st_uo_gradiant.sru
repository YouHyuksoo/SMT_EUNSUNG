HA$PBExportHeader$st_uo_gradiant.sru
forward
global type st_uo_gradiant from statictext
end type
end forward

global type st_uo_gradiant from statictext
integer width = 443
integer height = 64
integer textsize = -8
fontcharset fontcharset = ansi!
string facename = "Tahoma"
string text = "Text"
alignment alignment = center!
boolean focusrectangle = false
event ue_paint pbm_paint
end type
global st_uo_gradiant st_uo_gradiant

type variables
string #ivs_type
double #ivdb_color_1 , #ivdb_color_2
end variables

event ue_paint;if #ivs_type = '' or isnull(#ivs_type) then
	return
end if 
cn_gradient	ln_gradient
string lvs_text 
lvs_text = this.text 
CHOOSE CASE #ivs_type
	CASE 'H'
		ln_Gradient.of_HorizontalGradient (#ivdb_color_1, #ivdb_color_2, THIS)
		this.text  = lvs_text
	CASE 'V'
		ln_Gradient.of_VerticalGradient (#ivdb_color_1, #ivdb_color_2, THIS)
		this.text  = lvs_text		
	CASE 'TL'
		ln_Gradient.of_DiagonalGradient (#ivdb_color_1, #ivdb_color_2, ln_Gradient.TOPLEFT, THIS)
		this.text  = lvs_text	
	CASE 'TR'
		ln_Gradient.of_DiagonalGradient (#ivdb_color_1, #ivdb_color_2, ln_Gradient.TOPRIGHT, THIS)
		this.text  = lvs_text		
	CASE 'BR'
		ln_Gradient.of_DiagonalGradient (#ivdb_color_1, #ivdb_color_2, ln_Gradient.BOTTOMRIGHT, THIS)
		this.text  = lvs_text		
	CASE 'BL'
		ln_Gradient.of_DiagonalGradient (#ivdb_color_1, #ivdb_color_2, ln_Gradient.BOTTOMLEFT, THIS)
		this.text  = lvs_text		
	CASE ELSE
	
END CHOOSE

end event

on st_uo_gradiant.create
end on

on st_uo_gradiant.destroy
end on

