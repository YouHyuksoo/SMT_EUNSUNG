HA$PBExportHeader$w_drawing_batch_popup.srw
$PBExportComments$$$HEX7$$80bd1cc1c8b9a4c230d11dd3c5c5$$ENDHEX$$
forward
global type w_drawing_batch_popup from w_popup_root
end type
type lb_image from so_listbox within w_drawing_batch_popup
end type
type pb_1 from so_picturebutton within w_drawing_batch_popup
end type
type st_dir from so_statictext within w_drawing_batch_popup
end type
type pb_2 from so_picturebutton within w_drawing_batch_popup
end type
type lv_image from listview within w_drawing_batch_popup
end type
type vpb_upload from hprogressbar within w_drawing_batch_popup
end type
type pb_3 from so_picturebutton within w_drawing_batch_popup
end type
type ddlb_format from uo_basecode within w_drawing_batch_popup
end type
type cb_1 from so_commandbutton within w_drawing_batch_popup
end type
type cb_2 from so_commandbutton within w_drawing_batch_popup
end type
type st_1 from so_statictext within w_drawing_batch_popup
end type
type gb_2 from so_groupbox within w_drawing_batch_popup
end type
type gb_1 from so_groupbox within w_drawing_batch_popup
end type
end forward

global type w_drawing_batch_popup from w_popup_root
integer width = 4087
integer height = 2460
string title = "Department Popup"
lb_image lb_image
pb_1 pb_1
st_dir st_dir
pb_2 pb_2
lv_image lv_image
vpb_upload vpb_upload
pb_3 pb_3
ddlb_format ddlb_format
cb_1 cb_1
cb_2 cb_2
st_1 st_1
gb_2 gb_2
gb_1 gb_1
end type
global w_drawing_batch_popup w_drawing_batch_popup

on w_drawing_batch_popup.create
int iCurrent
call super::create
this.lb_image=create lb_image
this.pb_1=create pb_1
this.st_dir=create st_dir
this.pb_2=create pb_2
this.lv_image=create lv_image
this.vpb_upload=create vpb_upload
this.pb_3=create pb_3
this.ddlb_format=create ddlb_format
this.cb_1=create cb_1
this.cb_2=create cb_2
this.st_1=create st_1
this.gb_2=create gb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.lb_image
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.st_dir
this.Control[iCurrent+4]=this.pb_2
this.Control[iCurrent+5]=this.lv_image
this.Control[iCurrent+6]=this.vpb_upload
this.Control[iCurrent+7]=this.pb_3
this.Control[iCurrent+8]=this.ddlb_format
this.Control[iCurrent+9]=this.cb_1
this.Control[iCurrent+10]=this.cb_2
this.Control[iCurrent+11]=this.st_1
this.Control[iCurrent+12]=this.gb_2
this.Control[iCurrent+13]=this.gb_1
end on

on w_drawing_batch_popup.destroy
call super::destroy
destroy(this.lb_image)
destroy(this.pb_1)
destroy(this.st_dir)
destroy(this.pb_2)
destroy(this.lv_image)
destroy(this.vpb_upload)
destroy(this.pb_3)
destroy(this.ddlb_format)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.st_1)
destroy(this.gb_2)
destroy(this.gb_1)
end on

event open;call super::open;dw_1.settransobject(sqlca)


end event

type p_title from w_popup_root`p_title within w_drawing_batch_popup
integer width = 4069
end type

type cb_sort from w_popup_root`cb_sort within w_drawing_batch_popup
integer x = 3767
integer y = 36
end type

type cb_close from w_popup_root`cb_close within w_drawing_batch_popup
boolean visible = true
integer x = 3744
integer y = 288
integer width = 283
integer height = 224
end type

event cb_close::clicked;call super::clicked;Gst_return.gvb_return = false
end event

type st_msg from w_popup_root`st_msg within w_drawing_batch_popup
boolean visible = true
integer y = 572
integer width = 4069
end type

type dw_1 from w_popup_root`dw_1 within w_drawing_batch_popup
integer y = 0
end type

type dw_2 from w_popup_root`dw_2 within w_drawing_batch_popup
integer y = 0
end type

type dw_3 from w_popup_root`dw_3 within w_drawing_batch_popup
integer y = 8
end type

type lb_image from so_listbox within w_drawing_batch_popup
integer x = 14
integer y = 792
integer width = 1678
integer height = 1572
integer taborder = 20
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean multiselect = true
end type

type pb_1 from so_picturebutton within w_drawing_batch_popup
integer x = 713
integer y = 300
integer width = 256
integer height = 224
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
string text = "Dir"
string picturename = "drw_upload.bmp"
alignment htextalign = center!
end type

event clicked;call super::clicked;string		ls_title,			&
			ls_directory , lvs_format

ls_directory	=	st_dir.text
ls_title		=	this.powertiptext
if GetFolder ( ls_title, ls_directory ) <> 1 then return

lvs_format = ddlb_format.getname( )

lb_image.DirList(ls_directory+'\*.'+lvs_format, 0, st_dir)
end event

type st_dir from so_statictext within w_drawing_batch_popup
integer x = 997
integer y = 324
integer width = 1595
boolean bringtotop = true
boolean border = true
borderstyle borderstyle = stylelowered!
end type

type pb_2 from so_picturebutton within w_drawing_batch_popup
integer x = 3456
integer y = 288
integer width = 283
integer height = 224
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
string text = "Upload"
boolean originalsize = false
string picturename = "board_refresh.bmp"
alignment htextalign = center!
end type

event clicked;call super::clicked;/*****************************************************************************************
* select$$HEX2$$5cd52000$$ENDHEX$$bitmap image$$HEX10$$7cb9200070b374c7c0d0a0bc74c7a4c2d0c52000$$ENDHEX$$upload$$HEX5$$58d594b2200091c7c5c5$$ENDHEX$$.
*****************************************************************************************/
Integer		li_count,		&
				ii_index
long			ll_filelen,		&
				ll_TotalItems
listviewitem	l_lvi
string			ls_filename,	&
				ls_drawing_no , ls_dir
Blob			lb_filecontents,		&
				lb_pic
UINT			lui_file
int				li_loops,		i

	
ls_dir = st_dir.text	
ll_TotalItems	=	lv_image.TotalItems()

if	ll_TotalItems < 1 then
	f_msg1(102, f_get_dual_lang_text(gvs_language , 'Image'))
	return
end if

vpb_upload.maxposition	=	ll_TotalItems
vpb_upload.position		=	0

for	ii_index = 1 to 	ll_TotalItems
	lv_image.GetItem(ii_index, l_lvi)
//	ls_filename	=	st_dir.text+'\'+l_lvi.Label
	ls_filename	=	l_lvi.Label	
	ls_drawing_no	=	left(l_lvi.Label, len(l_lvi.Label) - 4 )
	ll_filelen		=	filelength(ls_filename)
	
	SELECT	count(*)
	INTO		:li_Count
	FROM		ID_ENG_BOM_DRAWING
	WHERE	organization_id	=	:gvi_organization_id
	     AND	drawing_no 	      = 	:ls_drawing_no ;
	
	if sqlca.sqlcode <> 0 then
		rollback;
		vpb_upload.position		=	ii_index
		continue
	end if
	/********************************************
	* $$HEX16$$70b374c7c0d0a0bc74c7a4c2d0c52000c6c594b2200090c7ccb874c774ba2000$$ENDHEX$$empno,
	  img file name, size$$HEX6$$7cb9200023b1b4c500c9e4b2$$ENDHEX$$.
	  $$HEX8$$f8ad07b8c0c920004ac53cc774ba2000$$ENDHEX$$name$$HEX2$$fcac2000$$ENDHEX$$size$$HEX2$$ccb92000$$ENDHEX$$update$$HEX4$$74d5200000c9e4b2$$ENDHEX$$.
	*********************************************/
	if li_count = 0 then
		
 INSERT INTO ID_ENG_BOM_DRAWING  
         ( DRAWING_NO,   
           ITEM_CODE,   
           ORGANIZATION_ID,   
     //      DRAWING_IMAGE,   
           FILE_NAME,   
           IMAGE_FORMAT,   
           DRAWING_COMMENT,   
           ENTER_BY,   
           ENTER_DATE,   
           LAST_MODIFY_BY,   
           LAST_MODIFY_DATE,   
           KEY_WORD,   
           VERSION,   
           CUSTOMER_CODE,   
           USER_ID,   
           DEPARTMENT_CODE,   
           MODEL_NAME,   
           MODEL_SUFFIX,   
           PART_NO,   
           DRAWING_DATE,   
//           MODEL_IMAGE,   
           COMPLETE_YN,   
           STATUS,   
           CHECK_IN_OUT,   
           CHECK_IN_OUT_DATE,   
           CHECK_IN_OUT_BY,   
           DRAWING_GRADE )  
  VALUES ( :ls_drawing_no,   
           :ls_drawing_no,   
           :GVI_ORGANIZATION_ID,   
           //DRAWING_IMAGE,   
           :ls_filename,   
           'DWG' , //IMAGE_FORMAT,   
           :ls_drawing_no , //DRAWING_COMMENT,   
           :gvs_user_id , //ENTER_BY,   
           sysdate , //ENTER_DATE,   
           :gvs_user_id , //LAST_MODIFY_BY,   
           sysdate , //LAST_MODIFY_DATE,   
           :ls_dir , //KEY_WORD,   
           1 , //VERSION,   
           '*' , //CUSTOMER_CODE,   
           :GVS_USER_ID,   
           :GVS_DEPARTMENT_CODE,   
           '*' , //MODEL_NAME,   
           '*' , //MODEL_SUFFIX,   
           '*' , //PART_NO,   
           SYSDATE , //DRAWING_DATE,   
//           MODEL_IMAGE,   
           'N' , //COMPLETE_YN,   
           'N' , //STATUS,   
           'I' , //CHECK_IN_OUT,   
           NULL , //CHECK_IN_OUT_DATE,   
           NULL , //CHECK_IN_OUT_BY,   
           'A' //DRAWING_GRADE 
		   )  ;

	
	else
		
		UPDATE	ID_ENG_BOM_DRAWING
		SET		FILE_NAME	= :ls_filename ,
		            KEY_WORD  = :ls_dir
		WHERE organization_id	=	:gvi_organization_id
                AND drawing_no 	= 	:ls_drawing_no ;		
	end if
	
	if sqlca.sqlcode <> 0 then
		f_msg_st( 103)	
		rollback;
		vpb_upload.position		=	ii_index
		continue
	else
		commit;
	end if
	
	/********************************************
	* $$HEX8$$74c7f8bbc0c9200070b374c7c0d02000$$ENDHEX$$update
	*********************************************/
	lb_pic = Blob( space(0) )
	lui_file = fileopen( ls_filename, StreamMode! )
	
	if	ll_filelen > 32765 then
		if mod(ll_filelen, 32765) = 0 then
			li_loops = ll_filelen/32765
		else
			li_loops = (ll_filelen/32765) + 1
		end if
	else
		li_loops = 1
	end if
	
	/***********************************************
	* file$$HEX6$$44c720007dc7b4c51cc12000$$ENDHEX$$picture control$$HEX2$$d0c52000$$ENDHEX$$display.
	***********************************************/
	for i = 1 to li_loops
		fileread( lui_file, lb_filecontents )
		lb_pic = lb_pic + lb_filecontents 
	next

	fileclose( lui_file )	

	UPDATEBLOB ID_ENG_BOM_DRAWING
	SET		drawing_image	=	:lb_pic
	WHERE	organization_id		=	:gvi_organization_id
	AND		drawing_no		=	:ls_drawing_no
	;
	
	if sqlca.sqlcode <> 0 then
		f_msgbox1( 102, f_get_dual_lang_text(gvs_language , "Image"))
		rollback;
		vpb_upload.position		=	ii_index
		continue
	else
		commit;
		vpb_upload.position		=	ii_index
	end if
next

lv_image.DeleteLargePictures ( )
lv_image.DeleteItems ( )
//cb_upload.enabled	=	false
f_msgbox(170)
end event

type lv_image from listview within w_drawing_batch_popup
integer x = 1705
integer y = 676
integer width = 2359
integer height = 1688
integer taborder = 30
boolean bringtotop = true
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
long largepicturemaskcolor = 536870912
long smallpicturemaskcolor = 536870912
long statepicturemaskcolor = 536870912
end type

type vpb_upload from hprogressbar within w_drawing_batch_popup
integer x = 997
integer y = 416
integer width = 1595
integer height = 68
boolean bringtotop = true
unsignedinteger maxposition = 100
unsignedinteger position = 100
integer setstep = 1
end type

type pb_3 from so_picturebutton within w_drawing_batch_popup
integer x = 3168
integer y = 288
integer width = 283
integer height = 224
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
string text = "Preview"
boolean originalsize = false
string picturename = "drw_view.bmp"
alignment htextalign = center!
end type

event clicked;call super::clicked;string		ls_directory , lvs_file_format
long		ll_TotalItems,	&
			ll_i,				&
			ll_pic
			
lvs_file_format = upper(ddlb_format.getname())
// $$HEX9$$f8adbcb92000f8bbacb9f4bcecc5fcc830ae$$ENDHEX$$
if lb_image.TotalSelected ( ) < 1 then 
	f_msgbox1(102, f_get_dual_lang_text(gvs_language , 'Image'))
	return
end if

lv_image.DeleteLargePictures ( )
lv_image.DeleteItems ( )

lv_image.LargePictureWidth		=	96	
lv_image.LargePictureHeight	=	128	

ls_directory		=	st_dir.text
ll_TotalItems	=	lb_image.TotalItems ( )

for ll_i = 1 to ll_TotalItems
	if	lb_image.State( ll_i ) = 1 then
		
		if lvs_file_format = 'BMP' or lvs_file_format = 'JPG' or lvs_file_format = 'GIF' or lvs_file_format = 'PNG'  then
			ll_pic	=	lv_image.AddLargePicture( ls_directory+'\'+upper(lb_image.text(ll_i)))
			ll_pic	=	lv_image.AddItem( lb_image.text(ll_i), ll_pic)
		else
			ll_pic	=	lv_image.AddItem( lb_image.text(ll_i), 0)
		end if 
	end if
next


end event

type ddlb_format from uo_basecode within w_drawing_batch_popup
integer x = 78
integer y = 416
integer width = 622
integer taborder = 50
boolean bringtotop = true
boolean allowedit = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;this.redraw( 'IMAGE FORMAT')
end event

type cb_1 from so_commandbutton within w_drawing_batch_popup
integer x = 544
integer y = 668
integer height = 112
integer taborder = 40
boolean bringtotop = true
string text = "Deselect All"
end type

event clicked;call super::clicked;lb_image.SetState(0, FALSE)
end event

type cb_2 from so_commandbutton within w_drawing_batch_popup
integer x = 9
integer y = 668
integer height = 112
integer taborder = 50
boolean bringtotop = true
string text = "Select All"
end type

event clicked;call super::clicked;int i
do
	i++
	
	lb_image.setstate( i, True)
	
loop until i = lb_image.totalitems( )
end event

type st_1 from so_statictext within w_drawing_batch_popup
integer x = 78
integer y = 312
integer width = 622
boolean bringtotop = true
string text = "File Format"
end type

type gb_2 from so_groupbox within w_drawing_batch_popup
integer x = 18
integer y = 228
integer width = 2619
integer height = 336
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_1 from so_groupbox within w_drawing_batch_popup
integer x = 3136
integer y = 220
integer width = 933
integer height = 336
integer taborder = 40
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

