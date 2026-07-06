HA$PBExportHeader$w_privilege_warning_popup.srw
forward
global type w_privilege_warning_popup from w_popup_root
end type
type p_1 from picture within w_privilege_warning_popup
end type
type mle_message from multilineedit within w_privilege_warning_popup
end type
type gb_1 from so_groupbox within w_privilege_warning_popup
end type
end forward

global type w_privilege_warning_popup from w_popup_root
integer width = 2619
integer height = 1688
string title = "Privilege Information"
boolean clientedge = true
p_1 p_1
mle_message mle_message
gb_1 gb_1
end type
global w_privilege_warning_popup w_privilege_warning_popup

type variables

end variables

on w_privilege_warning_popup.create
int iCurrent
call super::create
this.p_1=create p_1
this.mle_message=create mle_message
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_1
this.Control[iCurrent+2]=this.mle_message
this.Control[iCurrent+3]=this.gb_1
end on

on w_privilege_warning_popup.destroy
call super::destroy
destroy(this.p_1)
destroy(this.mle_message)
destroy(this.gb_1)
end on

event ue_post_open;call super::ue_post_open;MLE_MESSAGE.TEXT = F_MSG_ST1( 9043 , 'User ID='+gvs_user_id+'~r~n'+&
                                                                      'User Level='+string(GVI_USER_LEVEL)+'~r~n'+&
                                                                      'Window Name='+MESSAGE.STRINGPARM+'~r~n'+&
											               'Organiation ID='+string(gvi_organization_id)+'~r~n')
f_child_dw2(dw_1, 'window_name', gvs_language, string(gvi_organization_id))
f_child_dw2(dw_1, 'window_description', gvs_language, string(gvi_organization_id))
dw_1.retrieve(Gvs_user_id , Gvi_organization_id )
end event

type p_title from w_popup_root`p_title within w_privilege_warning_popup
integer width = 2587
end type

type cb_sort from w_popup_root`cb_sort within w_privilege_warning_popup
integer x = 0
integer y = 1616
end type

type cb_close from w_popup_root`cb_close within w_privilege_warning_popup
boolean visible = true
integer x = 32
integer y = 44
integer width = 329
integer taborder = 30
boolean default = true
end type

type st_msg from w_popup_root`st_msg within w_privilege_warning_popup
boolean visible = true
integer x = 9
integer y = 1876
integer width = 2181
boolean enabled = true
end type

type dw_1 from w_popup_root`dw_1 within w_privilege_warning_popup
boolean visible = true
integer y = 672
integer width = 2587
integer height = 908
boolean titlebar = true
string title = "My Privilege List"
string dataobject = "d_privilege_lst_popup_by_user"
end type

type dw_2 from w_popup_root`dw_2 within w_privilege_warning_popup
integer y = 680
end type

type dw_3 from w_popup_root`dw_3 within w_privilege_warning_popup
integer y = 676
end type

type p_1 from picture within w_privilege_warning_popup
integer x = 9
integer y = 248
integer width = 457
integer height = 404
boolean bringtotop = true
string picturename = "plivilige_left.gif"
boolean border = true
boolean focusrectangle = false
end type

type mle_message from multilineedit within w_privilege_warning_popup
integer x = 517
integer y = 268
integer width = 2025
integer height = 364
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 255
boolean hscrollbar = true
boolean vscrollbar = true
boolean autohscroll = true
boolean autovscroll = true
borderstyle borderstyle = stylelowered!
end type

type gb_1 from so_groupbox within w_privilege_warning_popup
integer x = 475
integer y = 220
integer width = 2103
integer height = 432
integer weight = 700
string text = "Message"
end type

