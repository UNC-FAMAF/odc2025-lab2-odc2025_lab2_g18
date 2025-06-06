	.equ SCREEN_WIDTH, 		640
	.equ SCREEN_HEIGH, 		480
	.equ BITS_PER_PIXEL,  	32

	.equ GPIO_BASE,      0x3f200000
	.equ GPIO_GPFSEL0,   0x00
	.equ GPIO_GPLEV0,    0x34

	.equ DELAY_CYCLES,     0xFFFFF
	.equ tiempo_multiplicador, 100

	.globl main

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
	add x5,x28, 100
	bl estrella

	mov x3, 200
	add x5,x28, 150
	bl estrella

	mov x3, 140
	add x5,x28, 200
	bl estrella

	mov x3, 120
	add x5,x28, 60
	bl estrella

	mov x3, 130
	add x5,x28, 460
	bl estrella
	
	mov x3, 80
	add x5,x28, 250
	bl estrella

	mov x3, 170
	add x5,x28, 360
	bl estrella

	mov x3, 200
	add x5,x28, 300
	bl estrella

	mov x3, 180
	add x5,x28, 500
	bl estrella

	mov x3, 65
	add x5,x28, 400
	bl estrella

	mov x3, 200
	add x5,x28, 10
	bl estrella

	mov x3, 30
	add x5,x28, 460
	bl estrella

	mov x3, 50
	add x5,x28, 610
	bl estrella

	mov x3, 300
	add x5,x28, 550
	bl estrella

	mov x3,300
	add x5,x28,60
	bl estrella

	mov x3,240
	add x5,x28,320
	bl estrella
estrellas_end:
piña: 
	mov x9, 34
	mov x10, 176
	mov x11, 36
	mov x12, 130
	mov x13, 89
	mov x14, 216	
	mov x15, 75
	mov x16, 228
	mov x22, 37
	mov x23, 171
	movz x21, 0x1A, lsl 16
	movk x21, 0x991F, lsl 0

	bl cuadradoR 
	mov x9, 49	
	mov x10, 139	
	mov x11, 64
	mov x12, 86
	mov x13, 84
	mov x14, 148	
	mov x15, 89
	mov x16, 216
	mov x22, 55
	mov x23, 136


	bl cuadradoR 
	mov x9, 73	
	mov x10, 150
	mov x11, 84
	mov x12, 90
	mov x13, 101
	mov x14, 148	
	mov x15, 96
	mov x16, 215
	mov x22, 82
	mov x23, 121


	bl cuadradoR 
	mov x9, 87
	mov x10, 136	
	mov x11, 112
	mov x12, 54
	mov x13, 131
	mov x14, 133	
	mov x15, 108
	mov x16, 218
	mov x22, 108
	mov x23, 106
	

	bl cuadradoR 
	mov x9, 118
	mov x10, 136	
	mov x11, 138
	mov x12, 77
	mov x13, 148
	mov x14, 129	
	mov x15, 125
	mov x16, 206
	mov x22, 136
	mov x23, 109

	bl cuadradoR 
	mov x9, 135
	mov x10, 212	
	mov x11, 178
	mov x12, 154
	mov x13, 170
	mov x14, 70	
	mov x15, 131
	mov x16, 184
	mov x22, 150
	mov x23, 162


	bl cuadradoR 
	mov x9, 138
	mov x10, 215	
	mov x11, 180
	mov x12, 134
	mov x13, 193
	mov x14, 177	
	mov x15, 148
	mov x16, 224
	mov x22, 165
	mov x23, 184
	bl cuadradoR 

	movz x11, 0x1A, lsl 16
	movk x11, 0x991F, lsl 0
	mov x3,177
	mov x4,215
	mov x5,69
	mov x6, 155
	bl rectangulo

// Y X HORIZONTAL VERTICAL
	movk x11, 0xF3, lsl 16
	movk x11, 0xAA2E, lsl 0 
	mov x3, 333
	mov x4, 118
	mov x5, 86
	mov x6, 128
	bl elipse
		/*x9   → x0 (posicion actual en X)
        x10  → y0 (posicion actual en Y)
        x11  → x1 (posicion final en X)
        x12  → y1 (posicion final en Y)*/
    movz x21, 0xEC, lsl 16
	movk x21, 0x7012, lsl 0
	mov	x9, 96 
	mov	x10, 456
	mov x11, 202
	mov x12, 358
	bl bresenham
	mov	x9, 56
	mov	x10, 421
	mov x11, 201
	mov x12, 302
	bl bresenham
	mov	x9, 40
	mov	x10, 387
	mov x11, 130
	mov x12, 460
	bl bresenham
	mov	x9, 36
	mov	x10, 371
	mov x11, 180
	mov x12, 244
	bl bresenham
	mov	x9, 85
	mov	x10, 214
	mov x11, 198
	mov x12, 284
	bl bresenham
	mov	x9, 144
	mov	x10, 210
	mov x11, 33
	mov x12, 314
	bl bresenham
	mov	x9, 53
	mov	x10, 250
	mov x11, 202
	mov x12, 368
	bl bresenham
	mov	x9, 35
	mov	x10, 304
	mov x11, 172
	mov x12, 433
	bl bresenham
	end_piña:

	ventanas:
	//ANTES DE LLAMAR CIRCULO ASIGNAR VALORES A xc=X3, yc=X4, radio=X15 y x11 color.
	mov x3, 76
	mov x4, 302
	mov x15, 20
	movz x11, 0x8C, lsl 16
	movk x11, 0xC7D4, lsl 0 
 
	bl circulo

	mov x15, 11
	movz x11, 0x4D, lsl 16
	movk x11, 0xE0FF, lsl 0
	bl circulo

	mov x3, 170
	mov x4, 371
	mov x15, 20
	movz x11, 0x8C, lsl 16
	movk x11, 0xC7D4, lsl 0 
 
	bl circulo

	mov x15, 11
	movz x11, 0x4D, lsl 16
	movk x11, 0xE0FF, lsl 0
	bl circulo

	puerta:
	movz x11, 0x8C, lsl 16
	movk x11, 0xC7D4, lsl 0 
	mov x3, 407
	mov x4, 118
	mov x5, 33
	mov x6, 55
	bl elipse

	movz x11, 0x6c, lsl 16
	movk x11, 0x9EA8, lsl 0 
	mov x3, 407
	mov x4, 118
	mov x5, 30
	mov x6, 53
	bl elipse
	  /*Los registros usados son:
        x9,x10 → x1,y1
        x11,x12 → x2,y2
        x13,x14 → x3,y3
        x15,x16 → x4,y4
        x22 → punto de partida del flood X
        x23 → punto de partida del flood Y */

piso:
	//Isla
	movk x11, 0xC, lsl 16
	movk x11, 0x5961, lsl 0 
	mov x3, 479 
	mov x4, 320
	mov x5, 320
	mov x6, 50
	bl elipse

	//planta
	mov x3, 440
	mov x4, 60//x
	mov x5, 4
	mov x6, 14//v
	bl planta

	mov x3, 440
	mov x4, 100
	mov x5, 5
	mov x6, 15
	bl planta

	mov x3, 450
	mov x4, 200
	mov x5, 3
	mov x6, 13
	bl planta

	mov x3, 450
	mov x4, 200
	mov x5, 5
	mov x6, 15
	bl planta
end_piso:

nave:
	movz x11, 0x73, lsl 16
	movk x11, 0xf6b4, lsl 0
	mov x3, 59
	mov x4, 319
	mov x5, 51
	mov x6, 33
	bl elipse

	mov x15, 9
	mov x3, 319
	mov x4, 61
	movz x11, 0xa993, lsl 00
	movk x11, 0x29, lsl 16
	bl circulo

	mov x9, 339
	mov x10, 50
	mov x11, 342
	mov x12, 50
	mov x13, 338
	mov x14, 63
	mov x15, 333
	mov x16, 63
	movz x21, 0xa993, lsl 00
	movk x21, 0x29, lsl 16
	mov x22, 337
	mov x23, 59
	bl cuadradoR

	mov x9, 299
	mov x10, 50
	mov x11, 305
	mov x12, 63
	mov x13, 300
	mov x14, 63
	mov x15, 296
	mov x16, 50
	movz x21, 0xa993, lsl 00
	movk x21, 0x29, lsl 16
	mov x22, 301
	mov x23, 59
	bl cuadradoR

	movz x11, 0xa993, lsl 00
	movk x11, 0x29, lsl 16
	mov x3, 42
	mov x4, 50
	mov x5, 291
	mov x6, 347
	bl rectangulo

	movz x11, 0xD2, lsl 16
	movk x11, 0xFF1C, lsl 0
	mov x3, 43
	mov x5, 300

	bl odc_2025

	movz x11, 0xa993, lsl 00
	movk x11, 0x29, lsl 16
	mov x3, 46
	mov x4, 51
	mov x5, 344
	mov x6, 351
	bl rectangulo

	movz x11, 0xa993, lsl 00
	movk x11, 0x29, lsl 16
	mov x3, 46
	mov x4, 51
	mov x5, 286
	mov x6, 294
	bl rectangulo

	movz x11, 0x3a, lsl 16
	movk x11, 0x436e, lsl 0
	mov x3, 80
	mov x4, 319
	mov x5, 102
	mov x6, 20
	bl elipse

	movz x11, 0x3a, lsl 16
	movk x11, 0x436e, lsl 0
	mov x3, 86
	mov x4, 319
	mov x5, 42
	mov x6, 21
	bl elipse

	movz x11, 0x64, lsl 16
	movk x11, 0xed7e, lsl 0
	mov x3, 88
	mov x4, 319
	mov x5, 14
	mov x6, 9
	bl elipse

	movz x11, 0x64, lsl 16
	movk x11, 0xed7e, lsl 0
	mov x3, 85
	mov x4, 282
	mov x5, 9
	mov x6, 7
	bl elipse

	movz x11, 0x64, lsl 16
	movk x11, 0xed7e, lsl 0
	mov x3, 79
	mov x4, 252
	mov x5, 9
	mov x6, 7
	bl elipse

	movz x11, 0x64, lsl 16
	movk x11, 0xed7e, lsl 0
	mov x3, 85
	mov x4, 356
	mov x5, 9
	mov x6, 7
	bl elipse

	movz x11, 0x64, lsl 16
	movk x11, 0xed7e, lsl 0
	mov x3, 79
	mov x4, 385
	mov x5, 9
	mov x6, 7
	bl elipse

end_nave:
bl Bobi
luz_rayo:
    movz x11, 0xFF00, lsl 0
    movk x11, 0x8000, lsl 16
    mov x5, 105     //y sup
    mov x6, 448    //y inf
    mov x12, 8   //ancho sup
    mov x7, 319    //centro en x original
    
    mov x2, #32
    mov x19, #3
    mul x19, x28, x19
    add x2, x2, x19
    
    sub x3, x7, x2, lsr 1
    add x4, x7, x2, lsr 1
    bl trapecio

end_luz_rayo:

sombras_elipse:
	//elipses sombra con efecto rayo
	mov x19, 5
	mul x19, x28, x19
	mov x3, 448
	mov x4, 319
	add x5, x19, 65
	mov x6, 18
	movz x11, 0x9429, lsl 0 
	bl elipse

	mov x19, -3
	mov x21, -1
	mul x21, x21, x28
	mul x19, x28, x19
	mov x3, 448
	mov x4, 319
	add x5, x19, 57
	add x6, x21, 18
	movz x11, 0x7b, lsl 16
	movk x11, 0x9684, lsl 0 
	bl elipse

	mov x19, -3
	mov x21, -2
	mul x21, x21, x28
	mul x19, x28, x19
	mov x3, 448
	mov x4, 319
	add x5, x19, 30
	add x6, x21, 15
	movz x11, 0x52, lsl 16
	movk x11, 0x6c5a, lsl 0 
	bl elipse
end_sombras_elipse:

algoritmo_delay:
	mov x25,DELAY_CYCLES //Ver .equ arriba
	mov x24,tiempo_multiplicador
	mul x25,x25,x24
	//mul x25,x25,x25
	L1: 
	SUB x25,x25,#1
	CBNZ x25, L1
	//Primero se va a actualizar el sumador, y cuando llegue a los 6 frames pasa al otro
	   

actualizar_frame:
		// if (x28 < 12 && habilitador == 0)
		cmp x28, #12
		bge check_siguiente
		cbnz x29, check_siguiente   // Si habilitador != 0, salta
		add x28, x28, #1
		b fin_actualizar

	check_siguiente:
		// else if (x28 == 12)
		cmp x28, #12
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

InfLoop:
	b InfLoop
