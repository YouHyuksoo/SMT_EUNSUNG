HA$PBExportHeader$cn_gradient.sru
forward
global type cn_gradient from nonvisualobject
end type
type gradient_rect from structure within cn_gradient
end type
type gradient_triangle from structure within cn_gradient
end type
type rect from structure within cn_gradient
end type
type trivertex from structure within cn_gradient
end type
end forward

type gradient_rect from structure
	unsignedlong		upperleft
	unsignedlong		lowerright
end type

type gradient_triangle from structure
	unsignedlong		vertex1
	unsignedlong		vertex2
	unsignedlong		vertex3
end type

type rect from structure
	long		left
	long		top
	long		right
	long		bottom
end type

type trivertex from structure
	long		x
	long		y
	integer		red
	integer		green
	integer		blue
	integer		alpha
end type

global type cn_gradient from nonvisualobject autoinstantiate
end type

type prototypes
Function Long GetDC (Long hwnd) Library 'user32'
Function Long GetClientRect (Long hwnd, REF RECT lpRect) Library 'user32' alias for "GetClientRect;Ansi"
Function Long ReleaseDC (Long hwnd, Long hdc) Library 'user32'
Function Boolean GradientRectangle (Long hdc, TRIVERTEX pVert[], ULong numVert, GRADIENT_RECT pMesh [], ULong numMesh, ULong dMode) Library 'msimg32' Alias For 'GradientFill;Ansi'
Function Boolean GradientTriangle (Long hdc, TRIVERTEX pVert[], ULong numVert, GRADIENT_TRIANGLE pMesh [], ULong numMesh, ULong dMode) Library 'msimg32' Alias For 'GradientFill;Ansi'
end prototypes

type variables
// MS Windows enumerations
CONSTANT ULong GRADIENT_FILL_RECT_H = 0
CONSTANT ULong GRADIENT_FILL_RECT_V = 1
CONSTANT ULong GRADIENT_FILL_TRIANGLE = 2
CONSTANT ULong GRADIENT_FILL_OP_FLAG = 255

// User object enumerations
CONSTANT String TOPLEFT = "TOPLEFT"
CONSTANT String TOPRIGHT = "TOPRIGHT"
CONSTANT String BOTTOMRIGHT = "BOTTOMRIGHT"
CONSTANT String BOTTOMLEFT = "BOTTOMLEFT"

PRIVATE:
// Object Handle
Long	HDC

// Dimensions
RECT DC_Rect

// Vertices
TRIVERTEX Corner[4]

// st_text paint event $$HEX11$$d0c5200044c598b72000b4b0a9c6200094cd00ac2000$$ENDHEX$$
//cn_gradient	ln_gradient
//
//CHOOSE CASE ddlb_1.Text
//	CASE 'Horizontal'
//		ln_Gradient.of_HorizontalGradient (r_1.FillColor, r_2.FillColor, THIS)
//	CASE 'Vertical'
//		ln_Gradient.of_VerticalGradient (r_1.FillColor, r_2.FillColor, THIS)
//	CASE 'Top Left'
//		ln_Gradient.of_DiagonalGradient (r_1.FillColor, r_2.FillColor, ln_Gradient.TOPLEFT, THIS)
//	CASE 'Top Right'
//		ln_Gradient.of_DiagonalGradient (r_1.FillColor, r_2.FillColor, ln_Gradient.TOPRIGHT, THIS)
//	CASE 'Bottom Right'
//		ln_Gradient.of_DiagonalGradient (r_1.FillColor, r_2.FillColor, ln_Gradient.BOTTOMRIGHT, THIS)
//	CASE 'Bottom Left'
//		ln_Gradient.of_DiagonalGradient (r_1.FillColor, r_2.FillColor, ln_Gradient.BOTTOMLEFT, THIS)
//END CHOOSE
//
end variables

forward prototypes
public subroutine of_horizontalgradient (long al_color1, long al_color2, dragobject ado_palette)
public subroutine of_horizontalgradient (long al_color1, long al_color2)
public subroutine of_verticalgradient (long al_color1, long al_color2, dragobject ado_palette)
public subroutine of_verticalgradient (long al_color1, long al_color2)
public subroutine of_diagonalgradient (long al_color1, long al_color2, string as_startingcorner, dragobject ado_palette)
public subroutine of_diagonalgradient (long al_color1, long al_color2, string as_startingcorner)
public function boolean of_setdevicecontext (dragobject ado_palette)
public subroutine of_splitrgb (long al_color, ref long red, ref long green, ref long blue)
end prototypes

public subroutine of_horizontalgradient (long al_color1, long al_color2, dragobject ado_palette);IF NOT of_SetDeviceContext (ado_Palette) THEN RETURN
of_HorizontalGradient (al_Color1, al_Color2)
end subroutine

public subroutine of_horizontalgradient (long al_color1, long al_color2);Long	ll_Red, &
		ll_Green, &
		ll_Blue, &
		ll_DC
GRADIENT_RECT l_Gradient[1]

// Set the colors in the first corner (top left)
of_SplitRGB (al_Color1, ll_Red, ll_Green, ll_Blue)
Corner[1].Red = ll_Red * 256
Corner[1].Green = ll_Green * 256
Corner[1].Blue = ll_Blue * 256

// Set the colors in the third corner (bottom right)
of_SplitRGB (al_Color2, ll_Red, ll_Green, ll_Blue)
Corner[3].Red = ll_Red * 256
Corner[3].Green = ll_Green * 256
Corner[3].Blue = ll_Blue * 256

l_Gradient[1].UpperLeft = 0 // First corner, top lefts
l_Gradient[1].LowerRight = 2 // Third corner, bottom right

ll_DC = GetDC (HDC)
GradientRectangle (ll_DC, Corner, 4, l_Gradient, 1, GRADIENT_FILL_RECT_H)
ReleaseDC (HDC, ll_DC)
end subroutine

public subroutine of_verticalgradient (long al_color1, long al_color2, dragobject ado_palette);IF NOT of_SetDeviceContext (ado_Palette) THEN RETURN

of_VerticalGradient (al_Color1, al_Color2)
end subroutine

public subroutine of_verticalgradient (long al_color1, long al_color2);Long	ll_Red, &
		ll_Green, &
		ll_Blue, &
		ll_DC
GRADIENT_RECT l_Gradient[1]

// Set the colors in the first corner (top left)
of_SplitRGB (al_Color1, ll_Red, ll_Green, ll_Blue)
Corner[1].Red = ll_Red * 256
Corner[1].Green = ll_Green * 256
Corner[1].Blue = ll_Blue * 256

// Set the colors in the third corner (bottom right)
of_SplitRGB (al_Color2, ll_Red, ll_Green, ll_Blue)
Corner[3].Red = ll_Red * 256
Corner[3].Green = ll_Green * 256
Corner[3].Blue = ll_Blue * 256

l_Gradient[1].UpperLeft = 0 // First corner, top left
l_Gradient[1].LowerRight = 2 // Third corner, bottom right

ll_DC = GetDC (HDC)
GradientRectangle (ll_DC, Corner, 4, l_Gradient, 1, GRADIENT_FILL_RECT_V)
ReleaseDC (HDC, ll_DC)
end subroutine

public subroutine of_diagonalgradient (long al_color1, long al_color2, string as_startingcorner, dragobject ado_palette);IF NOT THIS.of_SetDeviceContext (ado_Palette) THEN RETURN

of_DiagonalGradient (al_Color1, al_Color2, as_StartingCorner)
end subroutine

public subroutine of_diagonalgradient (long al_color1, long al_color2, string as_startingcorner);Long	ll_Red, &
		ll_Green, &
		ll_Blue, &
		ll_DC
GRADIENT_TRIANGLE l_Gradient[2]

// Set the colors for all corners
of_SplitRGB (al_Color2, ll_Red, ll_Green, ll_Blue)
Corner[1].Red = ll_Red * 256
Corner[1].Green = ll_Green * 256
Corner[1].Blue = ll_Blue * 256

Corner[2].Red = ll_Red * 256
Corner[2].Green = ll_Green * 256
Corner[2].Blue = ll_Blue * 256

Corner[3].Red = ll_Red * 256
Corner[3].Green = ll_Green * 256
Corner[3].Blue = ll_Blue * 256

Corner[4].Red = ll_Red * 256
Corner[4].Green = ll_Green * 256
Corner[4].Blue = ll_Blue * 256

// Change the color for the starting corner
of_SplitRGB (al_Color1, ll_Red, ll_Green, ll_Blue)
CHOOSE CASE as_StartingCorner
	CASE TOPLEFT
		Corner[1].Red = ll_Red * 256
		Corner[1].Green = ll_Green * 256
		Corner[1].Blue = ll_Blue * 256
	CASE TOPRIGHT
		Corner[2].Red = ll_Red * 256
		Corner[2].Green = ll_Green * 256
		Corner[2].Blue = ll_Blue * 256
	CASE BOTTOMRIGHT
		Corner[3].Red = ll_Red * 256
		Corner[3].Green = ll_Green * 256
		Corner[3].Blue = ll_Blue * 256
	CASE BOTTOMLEFT
		Corner[4].Red = ll_Red * 256
		Corner[4].Green = ll_Green * 256
		Corner[4].Blue = ll_Blue * 256
	CASE ELSE
		// Invalid corner... return
		RETURN
END CHOOSE

CHOOSE CASE as_StartingCorner
	CASE TOPLEFT, BOTTOMRIGHT
		l_Gradient[1].Vertex1 = 0
		l_Gradient[1].Vertex2 = 1
		l_Gradient[1].Vertex3 = 2
		l_Gradient[2].Vertex1 = 0
		l_Gradient[2].Vertex2 = 2
		l_Gradient[2].Vertex3 = 3
	CASE TOPRIGHT, BOTTOMLEFT
		l_Gradient[1].Vertex1 = 1
		l_Gradient[1].Vertex2 = 3
		l_Gradient[1].Vertex3 = 2
		l_Gradient[2].Vertex1 = 1
		l_Gradient[2].Vertex2 = 0
		l_Gradient[2].Vertex3 = 3
END CHOOSE

ll_DC = GetDC (HDC)
GradientTriangle (ll_DC, Corner, 4, l_Gradient, 2, GRADIENT_FILL_TRIANGLE)
ReleaseDC (HDC, ll_DC)

end subroutine

public function boolean of_setdevicecontext (dragobject ado_palette);IF NOT IsValid (ado_Palette) THEN RETURN FALSE

// Get the object's handle
HDC = Handle (ado_Palette)

// Get the object's dimensions
GetClientRect (HDC, DC_RECT)

// Initialize the vertices
Corner[1].X = DC_RECT.Left
Corner[1].Y = DC_RECT.Top
Corner[1].Alpha = 0
Corner[2].X = DC_RECT.Right
Corner[2].Y = DC_RECT.Top
Corner[2].Alpha = 0
Corner[3].X = DC_RECT.Right
Corner[3].Y = DC_RECT.Bottom
Corner[3].Alpha = 0
Corner[4].X = DC_RECT.Left
Corner[4].Y = DC_RECT.Bottom
Corner[4].Alpha = 0

RETURN TRUE
end function

public subroutine of_splitrgb (long al_color, ref long red, ref long green, ref long blue);Red = Mod (al_Color, 256)

al_Color /= 256
Blue = al_Color / 256

Green	= Mod (al_Color, 256)

end subroutine

on cn_gradient.create
call super::create
TriggerEvent( this, "constructor" )
end on

on cn_gradient.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

