HA$PBExportHeader$w_choose_organization_other.srw
$PBExportComments$$$HEX5$$70c8c1c9c0bcbdac3dcc$$ENDHEX$$
forward
global type w_choose_organization_other from w_none_dw_popup_root
end type
type st_current_org from so_statictext within w_choose_organization_other
end type
type st_1 from so_statictext within w_choose_organization_other
end type
type cb_1 from so_commandbutton within w_choose_organization_other
end type
type dw_org from datawindow within w_choose_organization_other
end type
end forward

global type w_choose_organization_other from w_none_dw_popup_root
integer x = 1202
integer y = 928
integer width = 1742
integer height = 1036
string title = "Selection Organization"
boolean minbox = true
windowtype windowtype = popup!
st_current_org st_current_org
st_1 st_1
cb_1 cb_1
dw_org dw_org
end type
global w_choose_organization_other w_choose_organization_other

type variables
datawindowchild idw_orz
end variables

on w_choose_organization_other.create
int iCurrent
call super::create
this.st_current_org=create st_current_org
this.st_1=create st_1
this.cb_1=create cb_1
this.dw_org=create dw_org
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_current_org
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.dw_org
end on

on w_choose_organization_other.destroy
call super::destroy
destroy(this.st_current_org)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.dw_org)
end on

event open;st_current_org.text = "Organization ID : "+string(Gvi_organization_id)+'~r~n'
st_current_org.text = st_current_org.text+ +'Organiztion Name : '+Gvs_organization_name 

THIS.TITLE = Gvs_User_name+" ,Please Select Organization..."
DW_ORG.SETTRANSOBJECT(SQLCA)
dw_org.getchild('organization_id',idw_orz)
idw_orz.settransobject(sqlca)
idw_orz.insertrow(0)
DW_ORG.INSERTROW(0)





end event

type p_title from w_none_dw_popup_root`p_title within w_choose_organization_other
integer x = 14
integer width = 1714
end type

type cb_close from w_none_dw_popup_root`cb_close within w_choose_organization_other
boolean visible = true
integer x = 841
integer y = 844
end type

type st_msg from w_none_dw_popup_root`st_msg within w_choose_organization_other
integer x = 14
integer y = 464
integer width = 1714
end type

type st_current_org from so_statictext within w_choose_organization_other
integer x = 14
integer y = 320
integer width = 1664
integer height = 136
integer weight = 700
long textcolor = 65535
long backcolor = 16711680
end type

type st_1 from so_statictext within w_choose_organization_other
integer x = 457
integer y = 240
integer width = 818
integer height = 56
integer weight = 700
string text = "Current Organization Infomation"
end type

type cb_1 from so_commandbutton within w_choose_organization_other
integer x = 539
integer y = 844
integer width = 274
integer height = 100
integer taborder = 20
string text = "OK"
end type

event clicked;Gvi_organization_id = dw_org.getitemNumber(1 , 'organization_id')


if isNUll(Gvi_organization_id) then 
	f_msgbox(168)
	//("Confirm", "Please Select Organization")
	
	Return
else
	
	   select count(*) into :Rowcnt
	    from isys_users
	   where user_id = :Gvs_user_id
		  and password = :Gvs_password
		  and organization_id = :Gvi_organization_id;

		if f_sql_check() < 0 then
			Return
		end if
		
	   if Rowcnt < 1 then 
			f_msgbox( 167)
//			("Warning" , "You Are Unregisterd Current Organization. Please Contact Your System Manager!")
		else
			 W_MAIN_FRAME.TITLE = "Organization : "+Gvs_organization_name+"-["+W_MAIN_FRAME.TAG+"] User ID : "+Gvs_user_name
			 close(Parent)	
		end if
end if
	


end event

type dw_org from datawindow within w_choose_organization_other
integer x = 443
integer y = 620
integer width = 846
integer height = 168
integer taborder = 10
string dataobject = "de_choose_org_extern"
boolean border = false
boolean livescroll = true
end type

event itemchanged;Int iVs_org_id

Dw_org.setrow(1)
iVs_org_id = Dw_org.getitemNumber(1 , 'organization_id')

Select organization_name into :GVs_organization_name
  from ISYS_organization
 where organization_id = :iVs_org_id ;
 
if  f_sql_check() < 1 then Return
end event

event itemfocuschanged;if dwo.name = 'organization_id' then 
	idw_orz.retrieve(gvs_user_id)
end if
end event

