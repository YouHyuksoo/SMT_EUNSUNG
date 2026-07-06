HA$PBExportHeader$w_smt_bom_comments_window.srw
$PBExportComments$$$HEX7$$38bb90c7b8d3d1c908c7c4b3b0c6$$ENDHEX$$
forward
global type w_smt_bom_comments_window from window
end type
type sle_model_name from so_singlelineedit within w_smt_bom_comments_window
end type
type cb_2 from commandbutton within w_smt_bom_comments_window
end type
type cb_1 from commandbutton within w_smt_bom_comments_window
end type
type mle_1 from multilineedit within w_smt_bom_comments_window
end type
end forward

global type w_smt_bom_comments_window from window
integer x = 827
integer y = 576
integer width = 2990
integer height = 1980
boolean titlebar = true
string title = "Edit Control"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 79741120
boolean center = true
event ue_postopen ( )
sle_model_name sle_model_name
cb_2 cb_2
cb_1 cb_1
mle_1 mle_1
end type
global w_smt_bom_comments_window w_smt_bom_comments_window

type variables
string lvs_comments , lvs_model_name 
int lvi_count
end variables

event ue_postopen();lvs_model_name = message.stringparm
sle_model_name.text = lvs_model_name

SELECT  model_comments into :lvs_comments

  FROM ib_smt_bom_image
  WHERE model_name = :lvs_model_name
     AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
	  
	  
IF F_SQL_CHECK() < 0 THEN 
	RETURN 
END IF 


mle_1.text = lvs_comments
end event

on w_smt_bom_comments_window.create
this.sle_model_name=create sle_model_name
this.cb_2=create cb_2
this.cb_1=create cb_1
this.mle_1=create mle_1
this.Control[]={this.sle_model_name,&
this.cb_2,&
this.cb_1,&
this.mle_1}
end on

on w_smt_bom_comments_window.destroy
destroy(this.sle_model_name)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.mle_1)
end on

event key;IF key = keyescape! THEN 
	CB_2.TRIGGEREVENT('CLICKED')
END IF

end event

event open;postevent( 'UE_POSTOPEN')
end event

type sle_model_name from so_singlelineedit within w_smt_bom_comments_window
integer x = 59
integer y = 28
integer taborder = 10
end type

type cb_2 from commandbutton within w_smt_bom_comments_window
integer x = 1522
integer y = 1784
integer width = 640
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Cancel[Esc]"
end type

event clicked;Gst_return.gvb_return = false
closewithreturn(parent, '')
end event

type cb_1 from commandbutton within w_smt_bom_comments_window
integer x = 878
integer y = 1784
integer width = 640
integer height = 92
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Confirm[Ctrl+Enter]"
end type

event clicked;Gst_return.gvb_return = true

lvs_comments = mle_1.text

//==========================================
//
//==========================================
IF lvs_model_name = '' or ISNULL(lvs_model_name) THEN 
	//MESS AGEBOX("Notify" , "$$HEX9$$a8ba78b385ba74c72000c6c5b5c2c8b2e4b2$$ENDHEX$$")
	f_msg( "$$HEX9$$a8ba78b385ba74c72000c6c5b5c2c8b2e4b2$$ENDHEX$$", 'P')
end if 

select count(*) into :lvi_count 
 from ib_smt_bom_image
where model_name = :lvs_model_name
   and organization_id = :gvi_organization_id ;
	
	if f_sql_check() < 0 then 
		return 
	end if 	
	
if lvi_count > 0 then 	
	
	update ib_smt_bom_image set model_comments = :lvs_comments 
	where model_name = :lvs_model_name
		and organization_id = :gvi_organization_id ;
		
		if f_sql_check() < 0 then 
			return 
		end if 
else
	   insert into ib_smt_bom_image ( model_name,  model_comments, organization_id )
		  values ( :lvs_model_name , :lvs_comments  , :gvi_organization_id ) ;
		  
		if f_sql_check() < 0 then 
			return 
		end if 	  
	   
end if 

commit ;

closewithreturn(parent ,string(mle_1.text))
end event

type mle_1 from multilineedit within w_smt_bom_comments_window
integer x = 23
integer y = 164
integer width = 2953
integer height = 1596
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean hscrollbar = true
boolean vscrollbar = true
boolean autohscroll = true
boolean autovscroll = true
borderstyle borderstyle = stylelowered!
end type

