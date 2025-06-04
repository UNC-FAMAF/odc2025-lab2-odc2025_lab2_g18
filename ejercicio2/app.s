	.equ SCREEN_WIDTH, 		640
	.equ SCREEN_HEIGH, 		480
	.equ BITS_PER_PIXEL,  	32

	.equ GPIO_BASE,      0x3f200000
	.equ GPIO_GPFSEL0,   0x00
	.equ GPIO_GPLEV0,    0x34

	.equ DELAY_CYCLES,     0xfFFfFF
	.equ seis, 50

	.globl main
	.global rectangulo
    .global pantalla
    .global circulo
    .global bresenham
    .global cuadradoR
    .global pixel
    .global boton
    .global lineas_boton_expandir_h
    .global lineas_boton_expandir_v
    .global odc_2025
    .global pixel_ventana
	.global elipse
	.global elipses_fondo

mov x28, 0 //CONTADOR o FRAME COUNTER (fachero)
mov x29, #0 //HABILITADOR (se usa para el frame counter)

main:
	// x0 contiene la direccion base del framebuffer
 	mov x20, x0	// Guarda la dirección base del framebuffer en x20
	//---------------- CODE HERE ------------------------------------
fondo:
	mov x3, 10
	mov x4, 320
	mov x5, 480
	mov x6, 80
	movz x11, 0x32, lsl 16
	movk x11, 0x4DBE, lsl 0
	bl elipse


	mov x10, 0          // contador para incremento
loop_fondo:
	mov x12, 5//x12=5
	lsl x12, x12, 8 //x12=0x000500
	add x11, x11, x12//x12 = 0x[00]R,[05]G,[00]B

    bl elipses_fondo

    add x10, x10, 1
    cmp x10, 10
    b.lt loop_fondo
	
end_fondo:

estrellas:
	mov x3, 100
	mov x5, 100
	bl estrella

	mov x3, 200
	mov x5, 150
	bl estrella

	mov x3, 140
	mov x5, 200
	bl estrella

	mov x3, 120
	mov x5, 60
	bl estrella

	mov x3, 130
	mov x5, 460
	bl estrella
	
	mov x3, 80
	mov x5, 250
	bl estrella

	mov x3, 170
	mov x5, 360
	bl estrella

	mov x3, 200
	mov x5, 300
	bl estrella

	mov x3, 180
	mov x5, 500
	bl estrella

	mov x3, 65
	mov x5, 400
	bl estrella

	mov x3, 200
	mov x5, 10
	bl estrella

	mov x3, 30
	mov x5, 460
	bl estrella

	mov x3, 50
	mov x5, 610
	bl estrella

	mov x3, 300
	mov x5, 550
	bl estrella

	mov x3,300
	add x5,x28,60
	bl estrella

estrellas_end:

/*LLAMAR A ELIPSE CON 
X3(YC),
X4(XC),
X5(SEMIEJE H A),
X6(SEMIEJE V B)
Y COLOR EN X11

movz x11, 0x74, lsl 16
movk x11, 0x8E68, lsl 0 
mov x3, 450
mov x4, 1
mov x5, 250
mov x6, 160

 
bl elipse
movz x11, 0x60, lsl 16
movk x11, 0x6060, lsl 0 
mov x3, 450
mov x4, 1
mov x5, 220
mov x6, 160
 
bl elipse

movz x11, 0x74, lsl 16
movk x11, 0x8E68, lsl 0 
mov x3, 450
mov x4, 1
mov x5, 180
mov x6, 160

 
bl elipse*/
//
movz x11, 0xC2, lsl 16
movk x11, 0xD8B8, lsl 0 
mov x3, 479
mov x4, 679
mov x5, 250
mov x6, 160

 
bl elipse
movz x11, 0x47, lsl 16
movk x11, 0x7E7B, lsl 0 
mov x3, 479
mov x4, 679
mov x5, 220
mov x6, 160
 
bl elipse

movz x11, 0xC2, lsl 16
movk x11, 0xD8B8, lsl 0
mov x3, 479
mov x4, 679
mov x5, 180
mov x6, 160

bl elipse

movz x11, 0xC, lsl 16
movk x11, 0x5961, lsl 0

//Isla en la que esta Bob
movk x11, 0xC, lsl 16
movk x11, 0x5961, lsl 0 
mov x3, 479 
mov x4, 319
mov x5, 176
mov x6, 96
bl elipse

BOB:

	//manga derecha
		mov x15, 6
		mov x3, 344 //x
		mov x4, 257 //y
		movz x11, 0xdabf, lsl 00
		movk x11, 0x00de, lsl 16
		bl circulo


	//Frente cara bob
		mov x9, #295     // x1
		mov x10, #216    // y1
		mov x11, #345    // x2
		mov x12, #217    // y2
		mov x13, #343    // x3
		mov x14, #266     // y3
		mov x15, #302     // x4
		mov x16, #266     // y4  
		movz x21, 0xc737, lsl 00
		movk x21, 0x00e3, lsl 16
		mov x22, #302
		mov x23, #235
		bl cuadradoR
	//costado cara bob
		mov x9, #295     // x1
		mov x10, #216    // y1
		mov x11, #285   // x2
		mov x12, #229    // y2
		mov x13, #293    // x3
		mov x14, #268     // y3
		mov x15, #302     // x4
		mov x16, #266     // y4  
		movz x21, 0x8d29, lsl 00
		movk x21, 0x008d, lsl 16
		mov x22, #293
		mov x23, #247
		bl cuadradoR

	//manga izq
		mov x15, 6
		mov x3, 292 //x
		mov x4, 257 //y
		movz x11, 0xdabf, lsl 00
		movk x11, 0x00de, lsl 16
		bl circulo
	//detalle manga izq
		movz x11, 0x83, lsl 16
		movk x11, 0x9386, lsl 0
		mov x3, 257
		mov x4, 289
		mov x5, 3
		mov x6, 5
		bl elipse
	//---------------------------------------------------------------

   //frente superior ropa bob
		mov x9, #302     // x1
		mov x10, #267    // y1
		mov x11, #343    // x2
		mov x12, #267    // y2
		mov x13, #343    // x3
		mov x14, #273     // y3
		mov x15, #302     // x4
		mov x16, #273     // y4  
		movz x21, 0xdabf, lsl 00
		movk x21, 0x00de, lsl 16
		mov x22, #315
		mov x23, #270
		bl cuadradoR
	//costado superior ropa bob
		mov x9, #302     // x1
		mov x10, #267    // y1
		mov x11, #302    // x2
		mov x12, #273    // y2
		mov x13, #293    // x3
		mov x14, #273     // y3
		mov x15, #293     // x4
		mov x16, #269     // y4  
		movz x21, 0x9e8d, lsl 00
		movk x21, 0x0073, lsl 16
		mov x22, #297
		mov x23, #271
		bl cuadradoR

	//frente inferior ropa bob
		mov x9, #302     // x1
		mov x10, #273    // y1
		mov x11, #343    // x2
		mov x12, #273    // y2
		mov x13, #343    // x3
		mov x14, #283     // y3
		mov x15, #302     // x4
		mov x16, #283     // y4  
		movz x21, 0x4218, lsl 00
		movk x21, 0x006d, lsl 16
		mov x22, #309
		mov x23, #275
		bl cuadradoR
	//costado inferior ropa bob
		mov x9, #302     // x1
		mov x10, #273    // y1
		mov x11, #302    // x2
		mov x12, #283    // y2
		mov x13, #293    // x3
		mov x14, #280    // y3
		mov x15, #293     // x4
		mov x16, #273     // y4  
		movz x21, 0x3219, lsl 00
		movk x21, 0x003c, lsl 16
		mov x22, #298
		mov x23, #278
		bl cuadradoR
	//Manga pantalon izquerda 
		mov x3,285 //y
		mov x4,309 //x
		mov x5,6
		mov x6,5
		movz x11, 0x4218, lsl 00
		movk x11, 0x006d, lsl 16
		bl elipse
	//Manga pantalon izquerda 
		mov x3,284 //y
		mov x4,329 //x
		mov x5,6
		mov x6,5
		movz x11, 0x4218, lsl 00
		movk x11, 0x006d, lsl 16
		bl elipse

	//zapato izquierdo
		mov x15, 5
		mov x3, 309
		mov x4, 309
		movz x11, 0x2324, lsl 00
		movk x11, 0x000f, lsl 16
		bl circulo
		mov x15, 5
		mov x3, 305
		mov x4, 314
		movz x11, 0x2324, lsl 00
		movk x11, 0x000f, lsl 16
		bl circulo
		//zapato derecho
		mov x15, 5
		mov x3, 328
		mov x4, 308
		movz x11, 0x2324, lsl 00
		movk x11, 0x000f, lsl 16
		bl circulo
		mov x15, 5
		mov x3, 333
		mov x4, 313
		movz x11, 0x2324, lsl 00
		movk x11, 0x000f, lsl 16
		bl circulo

	//Pierna izquierda
		mov x9, #307     // x1
		mov x10, #290    // y1
		mov x11, #310    // x2
		mov x12, #290    // y2
		mov x13, #310    // x3
		mov x14, #304    // y3
		mov x15, #307     // x4
		mov x16, #306     // y4  
		movz x21, 0xc737, lsl 00
		movk x21, 0x00e3, lsl 16
		mov x22, #308
		mov x23, #294
		bl cuadradoR
	//Pierna derecha
		mov x9, #328     // x1
		mov x10, #289    // y1
		mov x11, #330    // x2
		mov x12, #289    // y2
		mov x13, #330    // x3
		mov x14, #305    // y3
		mov x15, #328     // x4
		mov x16, #303     // y4  
		movz x21, 0xc737, lsl 00
		movk x21, 0x00e3, lsl 16
		mov x22, #328
		mov x23, #295
		bl cuadradoR

	//mano izquierdo parte 1
		mov x9, #265     // x1
		mov x10, #250    // y1
		mov x11, #270    // x2
		mov x12, #255    // y2
		mov x13, #268    // x3
		mov x14, #261    // y3
		mov x15, #260     // x4
		mov x16, #262     // y4  
		movz x21, 0xc737, lsl 00
		movk x21, 0x00e3, lsl 16
		mov x22, #266
		mov x23, #256
		bl cuadradoR
	//mano izquierdo parte 1
		mov x9, #264     // x1
		mov x10, #253    // y1
		mov x11, #260    // x2
		mov x12, #261    // y2
		mov x13, #255    // x3
		mov x14, #258    // y3
		mov x15, #257     // x4
		mov x16, #253     // y4  
		movz x21, 0xc737, lsl 00
		movk x21, 0x00e3, lsl 16
		mov x22, #260
		mov x23, #255
		bl cuadradoR
	//brazo izquierdo
		mov x9, #288     // x1
		mov x10, #255    // y1
		mov x11, #290    // x2
		mov x12, #258    // y2
		mov x13, #269    // x3
		mov x14, #258    // y3
		mov x15, #270     // x4
		mov x16, #255     // y4  
		movz x21, 0xc737, lsl 00
		movk x21, 0x00e3, lsl 16
		mov x22, #275
		mov x23, #256
		bl cuadradoR

	//mano derecho parte 1
		mov x9, #368    // x1
		mov x10, #255    // y1
		mov x11, #373    // x2
		mov x12, #251    // y2
		mov x13, #375    // x3
		mov x14, #254    // y3
		mov x15, #372     // x4
		mov x16, #262     // y4  
		movz x21, 0xc737, lsl 00
		movk x21, 0x00e3, lsl 16
		mov x22, #372
		mov x23, #255
		bl cuadradoR
	//mano derecho parte 1
		mov x9, #375     // x1
		mov x10, #254    // y1
		mov x11, #382    // x2
		mov x12, #254    // y2
		mov x13, #377    // x3
		mov x14, #262    // y3
		mov x15, #372     // x4
		mov x16, #262     // y4  
		movz x21, 0xc737, lsl 00
		movk x21, 0x00e3, lsl 16
		mov x22, #377
		mov x23, #256
		bl cuadradoR
	//brazo derecho
		mov x9, #349     // x1
		mov x10, #255    // y1
		mov x11, #372    // x2
		mov x12, #255    // y2
		mov x13, #372    // x3
		mov x14, #259    // y3
		mov x15, #349     // x4
		mov x16, #259     // y4  
		movz x21, 0xc737, lsl 00
		movk x21, 0x00e3, lsl 16
		mov x22, #358
		mov x23, #257
		bl cuadradoR

	//----DETALLES------------------------------------------------------------------
		//Circulos costado
			mov x3,231 //y
			mov x4,292 //x
			mov x5,3
			mov x6,4
			movz x11, 0x4b16, lsl 00
			movk x11, 0x0041, lsl 16
			bl elipse

			mov x3,240 //y
			mov x4,294 //x
			mov x5,2
			mov x6,2
			movz x11, 0x4b16, lsl 00
			movk x11, 0x0041, lsl 16
			bl elipse

			mov x3,247 //y
			mov x4,296 //x
			mov x5,2
			mov x6,4
			movz x11, 0x4b16, lsl 00
			movk x11, 0x0041, lsl 16
			bl elipse

		//Circulos frente
			mov x3,223 //y
			mov x4,303 //x
			mov x5,3
			mov x6,3
			movz x11, 0x8121, lsl 00
			movk x11, 0x007a, lsl 16
			bl elipse

			mov x3,251 //y
			mov x4,305 //x
			mov x5,2
			mov x6,2
			movz x11, 0x8121, lsl 00
			movk x11, 0x007a, lsl 16
			bl elipse

			mov x3,260 //y
			mov x4,308 //x
			mov x5,2
			mov x6,3
			movz x11, 0x8121, lsl 00
			movk x11, 0x007a, lsl 16
			bl elipse

			mov x3,261 //y
			mov x4,337 //x
			mov x5,2
			mov x6,3
			movz x11, 0x8121, lsl 00
			movk x11, 0x007a, lsl 16
			bl elipse

			mov x3,253 //y
			mov x4,340 //x
			mov x5,2
			mov x6,4
			movz x11, 0x8121, lsl 00
			movk x11, 0x007a, lsl 16
			bl elipse

			mov x3,223 //y
			mov x4,340 //x
			mov x5,2
			mov x6,2
			movz x11, 0x8121, lsl 00
			movk x11, 0x007a, lsl 16
			bl elipse

		//OJOS,NARIZ Y BOCA 
			//OJOS
				mov x3,234 //y
				mov x4,315 //x
				mov x5,8
				mov x6,10
				movz x11, 0xf7ff, lsl 00
				movk x11, 0x00d2, lsl 16
				bl elipse
				mov x3,234 //y
				mov x4,330 //x
				mov x5,8
				mov x6,10
				movz x11, 0xf7ff, lsl 00
				movk x11, 0x00d2, lsl 16
				bl elipse

			//NARIZ
				mov x9, #324     // x1
				mov x10, #242    // y1
				mov x11, #333    // x2
				mov x12, #237    // y2
				mov x13, #338    // x3
				mov x14, #240    // y3
				mov x15, #335     // x4
				mov x16, #246     // y4  
				movz x21, 0xc737, lsl 00
				movk x21, 0x00e3, lsl 16
				mov x22, #333
				mov x23, #240
				bl cuadradoR

				mov x9,322
				mov x10,232
				mov x11,322
				mov x12,238
				movz x21, 0x8d29, lsl 00
				movk x21, 0x008d, lsl 16
				bl bresenham

				mov x9,322
				mov x10,238
				mov x11,324
				mov x12,242
				movz x21, 0x8d29, lsl 00
				movk x21, 0x008d, lsl 16
				bl bresenham

				mov x9,324
				mov x10,242
				mov x11,333
				mov x12,237
				movz x21, 0x8d29, lsl 00
				movk x21, 0x008d, lsl 16
				bl bresenham

				mov x9,333
				mov x10,237
				mov x11,336
				mov x12,239
				movz x21, 0x8d29, lsl 00
				movk x21, 0x008d, lsl 16
				bl bresenham

				mov x9,336
				mov x10,239
				mov x11,335
				mov x12,243
				movz x21, 0x8d29, lsl 00
				movk x21, 0x008d, lsl 16
				bl bresenham

				mov x9,335
				mov x10,243
				mov x11,326
				mov x12,245
				movz x21, 0x8d29, lsl 00
				movk x21, 0x008d, lsl 16
				bl bresenham
			
			//BOCA
				mov x9, #312     // x1
				mov x10, #253    // y1
				mov x11, #315    // x2
				mov x12, #255    // y2
				mov x13, #321    // x3
				mov x14, #253    // y3
				mov x15, #321     // x4
				mov x16, #249     // y4  
				movz x21, 0x2619, lsl 00
				movk x21, 0x0052, lsl 16
				mov x22, #316
				mov x23, #252
				bl cuadradoR

				mov x9, #321     // x1
				mov x10, #249    // y1
				mov x11, #327    // x2
				mov x12, #249    // y2
				mov x13, #327    // x3
				mov x14, #253    // y3
				mov x15, #321     // x4
				mov x16, #253     // y4  
				movz x21, 0x2619, lsl 00
				movk x21, 0x0052, lsl 16
				mov x22, #324
				mov x23, #250
				bl cuadradoR

				mov x9, #327     // x1
				mov x10, #249    // y1
				mov x11, #333    // x2
				mov x12, #251    // y2
				mov x13, #333    // x3
				mov x14, #254    // y3
				mov x15, #327     // x4
				mov x16, #253     // y4  
				movz x21, 0x2619, lsl 00
				movk x21, 0x0052, lsl 16
				mov x22, #331
				mov x23, #252
				bl cuadradoR
//--------------------------------------------

algoritmo_delay:
	mov x25,DELAY_CYCLES //Ver .equ arriba
	mov x24,seis
	mul x25,x25,x24
	//mul x25,x25,x25
	L1: 
	SUB x25,x25,#1
	CBNZ x25, L1
	//Primero se va a actualizar el sumador, y cuando llegue a los 6 frames pasa al otro
	
	    

actualizar_frame:
		// if (x28 < 6 && habilitador == 0)
		cmp x28, #6
		bge check_siguiente
		cbnz x29, check_siguiente   // Si habilitador != 0, salta
		add x28, x28, #1
		b fin_actualizar

	check_siguiente:
		// else if (x28 == 6)
		cmp x28, #6
		bne check_dos
		mov x29, #1
		sub x28, x28, #1
		b fin_actualizar

	check_dos:
		// else if (x28 == 2)
		cmp x28, #2
		bne else_resta
		mov x29, #0
		sub x28, x28, #1
		b fin_actualizar

	else_resta:
		// else
		sub x28, x28, #1

	fin_actualizar:

	b main

InfLoop: //Esto ya no sirve, no se llega nunca
	b InfLoop
