.equ SCREEN_WIDTH, 		640
	.equ SCREEN_HEIGH, 		480
	.equ BITS_PER_PIXEL,  	32

	.equ GPIO_BASE,      0x3f200000
	.equ GPIO_GPFSEL0,   0x00
	.equ GPIO_GPLEV0,    0x34

	.global main
    .global rectangulo
    .global pantalla
    .global mallado
    .global circulo
    .global pixel
	.global boton
main:

	// x0 contiene la direccion base del framebuffer
 	mov x20, x0	// Guarda la dirección base del framebuffer en x20
	//---------------- CODE HERE ------------------------------------
fondo:

	movz x11, 0x0099, lsl 16
	movk x11, 0x0099, lsl 0

	bl pantalla

	movk x11, 0xFF, lsl 16
	movk x11, 0x00FF, lsl 0

	mov x15, 60
	mov x3, 45
	mov x4, 160

	bl circulo 

	mov x3, 160
	mov x4, 480
	mov x5, 00
	mov x6, 640

	bl rectangulo

	movz x11, 0x0099, lsl 16
	movk x11, 0x0099, lsl 0

	mov x15, 50
	mov x3, 155
	mov x4, 160

	bl circulo

	movz x11, 0xFF, lsl 16
	movk x11, 0x00FF, lsl 0


	mov x15, 120
	mov x3, 325
	mov x4, 160

	bl circulo

	movz x11, 0xFF, lsl 16
	movk x11, 0x00FF, lsl 0

	mov x15, 30
	mov x3, 115
	mov x4, 80

	bl circulo

	movz x11, 0x99, lsl 16
	movk x11, 0x0099, lsl 0

	mov x15, 90
	mov x3, 535
	mov x4, 160

	bl circulo

	movz x11, 0xFF, lsl 16
	movk x11, 0x00FF, lsl 0

	mov x15, 16
	mov x3, 580
	mov x4, 65

	bl circulo

	mov x15, 7
	mov x3, 564
	mov x4, 49

	bl circulo

	///
	

	movk x11, 0x5B, lsl 16
	movk x11, 0x6EE1, lsl 0

	mov x15, 60
	mov x3, 105
	mov x4, 330

	bl circulo 

	mov x3, 330
	mov x4, 480
	mov x5, 00
	mov x6, 640

	bl rectangulo

	movz x11, 0xFF, lsl 16
	movk x11, 0x00FF, lsl 0

	mov x15, 50
	mov x3, 215
	mov x4, 330

	bl circulo

	movk x11, 0x5B, lsl 16
	movk x11, 0x6EE1, lsl 0


	mov x15, 120
	mov x3, 385
	mov x4, 330

	bl circulo

	movk x11, 0x5B, lsl 16
	movk x11, 0x6EE1, lsl 0

	mov x15, 30
	mov x3, 175
	mov x4, 250

	bl circulo

	movz x11, 0xFF, lsl 16
	movk x11, 0x00FF, lsl 0


	mov x15, 90
	mov x3, 595
	mov x4, 330

	bl circulo

	movk x11, 0x5B, lsl 16
	movk x11, 0x6EE1, lsl 0

	mov x15, 16
	mov x3, 640
	mov x4, 235

	bl circulo

	mov x15, 7
	mov x3, 624
	mov x4, 219

	bl circulo
end_fondo:

paint:
	//negro
	mov x3, 50
	mov x4, 420
	mov x5, 150 //204
	mov x6, 488 //434
	movz x11, 0x00, lsl 00 
	bl rectangulo 
	
	
	//casi blanco
	mov x3, 52
	mov x4, 418
	mov x5, 152
	mov x6, 486
	movz x11, 0xF5F1, lsl 00 
	movk x11, 0xFA, lsl 16
	bl rectangulo 
	//gris

	mov x3, 56
	mov x4, 410
	mov x5, 154
	mov x6, 484
	movz x11, 0xCFC6, lsl 00 
	movk x11, 0xD5, lsl 16
	bl rectangulo 
	
	//celestito claro
	// CCE5FF

	mov x3, 52
	mov x4, 70
	mov x5, 152 //206
	mov x6, 486 //432
	movz x11, 0xB9BE, lsl 00 
	movk x11, 0x8E, lsl 16
	bl rectangulo 

	//celestito
	//99CCFF

	mov x3, 54
	mov x4, 70
	mov x5, 154
	mov x6, 484
	movz x11, 0x909E, lsl 00 
	movk x11, 0x7D, lsl 16
	bl rectangulo 
	
	//gris oscuro
	mov x3, 412
	mov x4, 418
	mov x5, 152
	mov x6, 486
	movz x11, 0x4040, lsl 00 
	movk x11, 0x40, lsl 16
	bl rectangulo

	//negro (borde externo)
	mov x3, 74
	mov x4, 406
	mov x5, 156
	mov x6, 482
	movz x11, 0x4040, lsl 00 
	movk x11, 0x40, lsl 16
	bl rectangulo
	
	//blanco (borde)
	mov x3, 76
	mov x4, 404
	mov x5, 158
	mov x6, 480
	movz x11, 0xFFFF, lsl 00 
	movk x11, 0xFF, lsl 16
	bl rectangulo

	//negro (borde)
	mov x3, 78
	mov x4, 402
	mov x5, 160
	mov x6, 478
	movz x11, 0x4040, lsl 00 
	movk x11, 0x40, lsl 16
	bl rectangulo

	//blanco 
	mov x3, 80
	mov x4, 400
	mov x5, 162
	mov x6, 476
	movz x11, 0xFFFF, lsl 00 
	movk x11, 0xFF, lsl 16
	bl rectangulo

	//-------BOTON CRUZ---------//

	//dar las 4 esquinas , x3,x4,x5,x6
	mov x3, 56
	mov x4, 69
	mov x5, 469
	mov x6, 482
	bl boton

	//linea cruz izq a der
	//media
	mov x9,471
	mov x10,58
	mov x11,479
	mov x12,66
	movz x21, 0x4040, lsl 00 
	movk x21, 0x40, lsl 16
	bl bresenham
	//arriba
	mov x9,472
	mov x10,58
	mov x11,479
	mov x12,65
	movz x21, 0x4040, lsl 00 
	movk x21, 0x40, lsl 16
	bl bresenham
	//abajo
	mov x9,471
	mov x10,59
	mov x11,478
	mov x12,66
	movz x21, 0x4040, lsl 00 
	movk x21, 0x40, lsl 16
	bl bresenham

	//linea cruz der a izq
	//media
	mov x9,479
	mov x10,58
	mov x11,471
	mov x12,66
	movz x21, 0x4040, lsl 00 
	movk x21, 0x40, lsl 16
	bl bresenham
	//arriba
	mov x9,478
	mov x10,58
	mov x11,471
	mov x12,65
	movz x21, 0x4040, lsl 00 
	movk x21, 0x40, lsl 16
	bl bresenham
	//abajo
	mov x9,479
	mov x10,59
	mov x11,472
	mov x12,66
	movz x21, 0x4040, lsl 00 
	movk x21, 0x40, lsl 16
	bl bresenham

/* 
odc_2025:
primera_fila_de_pixeles:
	(hay q  reubicarlos!)
	movz x11, 0xFFFF, lsl 00
	movk x11, 0xFF, lsl 16

	mov x3, 104
	mov x5, 102
	bl pixel

	mov x3, 104
	mov x5, 104
	bl pixel

	mov x3, 104
	mov x5, 110
	bl pixel
	
	mov x3, 104
	mov x5, 112
	bl pixel

	mov x3, 104
	mov x5, 114
	bl pixel

	mov x3, 104
	mov x5, 122
	bl pixel

	mov x3, 104
	mov x5, 124
	bl pixel

	mov x3, 104
	mov x5, 140
	bl pixel

	mov x3, 104
	mov x5, 142
	bl pixel

	mov x3, 104
	mov x5, 102
	bl pixel

	mov x3, 104
	mov x5, 150
	bl pixel

	mov x3, 104
	mov x5, 152
	bl pixel

	mov x3, 104
	mov x5, 158
	bl pixel

	mov x3, 104
	mov x5, 160
	bl pixel

	mov x3, 104
	mov x5, 166
	bl pixel
	
	mov x3, 104
	mov x5, 168
	bl pixel

	mov x3, 104
	mov x5, 170
	bl pixel
segunda_linea_de_pixeles:	
*/


InfLoop:
b InfLoop
