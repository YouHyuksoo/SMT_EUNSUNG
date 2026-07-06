HA$PBExportHeader$w_notify_flat.srw
forward
global type w_notify_flat from window
end type
type cb_close from so_commandbutton within w_notify_flat
end type
type cb_save from so_commandbutton within w_notify_flat
end type
type mle_note from multilineedit within w_notify_flat
end type
end forward

global type w_notify_flat from window
integer width = 2551
integer height = 1144
boolean titlebar = true
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "OleGenReg!"
boolean center = true
event ue_post_open ( )
cb_close cb_close
cb_save cb_save
mle_note mle_note
end type
global w_notify_flat w_notify_flat

event ue_post_open();datetime lvdt_plan_date
long  lvl_sequence
string lvs_timezone , lvs_note

lvdt_plan_date  = Gst_return.Gvdt_return[1]
lvl_sequence     =  Gst_return.Gvl_return[1]
lvs_timezone    = upper(Gst_return.Gvs_return[1])

if lvl_sequence = 0 or isnull(lvl_sequence) then
	return
else
	
	
	select decode ( :lvs_timezone , 'A'  , time1_desc , 'B' ,  time2_desc , 'C' ,  time3_desc , 'D' ,  time4_desc , 'E' ,  time5_desc , 'F'  , time6_desc , 'G',   time7_desc , 'H' , time8_desc , 'I'  ,time9_desc , 'J'  ,time10_desc , '' )
      into :lvs_note
	  from ip_product_smd_plan 
	 where plan_date = :lvdt_plan_date
	    and plan_sequence = :lvl_sequence 
		and organization_id = :gvi_organization_id ; 
		
		if f_sql_check() < 0 then 
			return 
		end if 
	
	
	mle_note.text = lvs_note
	
end if 
this.setredraw( true)

end event

on w_notify_flat.create
this.cb_close=create cb_close
this.cb_save=create cb_save
this.mle_note=create mle_note
this.Control[]={this.cb_close,&
this.cb_save,&
this.mle_note}
end on

on w_notify_flat.destroy
destroy(this.cb_close)
destroy(this.cb_save)
destroy(this.mle_note)
end on

event open;postevent('ue_post_open')
end event

type cb_close from so_commandbutton within w_notify_flat
integer x = 1243
integer y = 916
integer height = 116
integer taborder = 20
string text = "Close"
end type

event clicked;call super::clicked;close( w_notify_flat)
end event

type cb_save from so_commandbutton within w_notify_flat
integer x = 690
integer y = 920
integer height = 116
integer taborder = 20
string text = "Save"
end type

event clicked;call super::clicked;datetime lvdt_plan_date
long  lvl_sequence
string lvs_timezone , lvs_note

lvdt_plan_date  = Gst_return.Gvdt_return[1]
lvl_sequence     =  Gst_return.Gvl_return[1]
lvs_timezone    = upper(Gst_return.Gvs_return[1])

if lvl_sequence = 0 or isnull(lvl_sequence) then
	return
else

	lvs_note = mle_note.text
	
	if lvs_timezone = 'A' then 
	
		update ip_product_smd_plan set   time1_desc =  :lvs_note
		where plan_date = :lvdt_plan_date
		and plan_sequence = :lvl_sequence 
		and organization_id = :gvi_organization_id ; 
	
	elseif lvs_timezone = 'B' then 			
	
		update ip_product_smd_plan set   time2_desc =  :lvs_note
		where plan_date = :lvdt_plan_date
		and plan_sequence = :lvl_sequence 
		and organization_id = :gvi_organization_id ; 
	
	elseif lvs_timezone = 'C' then 			
	
		update ip_product_smd_plan set   time3_desc =  :lvs_note		
		where plan_date = :lvdt_plan_date
		and plan_sequence = :lvl_sequence 
		and organization_id = :gvi_organization_id ; 
	
	elseif lvs_timezone = 'D' then 					
		update ip_product_smd_plan set   time4_desc =  :lvs_note			
		where plan_date = :lvdt_plan_date
		and plan_sequence = :lvl_sequence 
		and organization_id = :gvi_organization_id ; 
	
	elseif lvs_timezone = 'E' then 		
	
		update ip_product_smd_plan set   time5_desc =  :lvs_note		
		where plan_date = :lvdt_plan_date
		and plan_sequence = :lvl_sequence 
		and organization_id = :gvi_organization_id ; 
	
	elseif lvs_timezone = 'F' then 		
	
	
		update ip_product_smd_plan set   time6_desc =  :lvs_note				
		where plan_date = :lvdt_plan_date
		and plan_sequence = :lvl_sequence 
		and organization_id = :gvi_organization_id ; 
		
	elseif lvs_timezone = 'G' then
		update ip_product_smd_plan set   time7_desc =  :lvs_note				
		where plan_date = :lvdt_plan_date
		and plan_sequence = :lvl_sequence 
		and organization_id = :gvi_organization_id ; 
	
	elseif lvs_timezone = 'H' then 					
		update ip_product_smd_plan set   time8_desc =  :lvs_note		
		where plan_date = :lvdt_plan_date
		and plan_sequence = :lvl_sequence 
		and organization_id = :gvi_organization_id ; 
	
	elseif lvs_timezone = 'I' then 					
	update ip_product_smd_plan set   time9_desc =  :lvs_note				
		where plan_date = :lvdt_plan_date
		and plan_sequence = :lvl_sequence 
		and organization_id = :gvi_organization_id ; 
	
	elseif lvs_timezone = 'J'  then 					
		update ip_product_smd_plan set   time10_desc =  :lvs_note				
		where plan_date = :lvdt_plan_date
		and plan_sequence = :lvl_sequence 
		and organization_id = :gvi_organization_id ; 
	
	end if 
	
	if f_sql_check() < 0 then 
		return 
	end if 

COMMIT ;
	
end if 
	

end event

type mle_note from multilineedit within w_notify_flat
integer width = 2523
integer height = 892
integer taborder = 10
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

