    .equ SCREEN_WIDTH, 		640
	.equ SCREEN_HEIGH, 		480
	.equ BITS_PER_PIXEL,  	32

	.equ GPIO_BASE,      0x3f200000
	.equ GPIO_GPFSEL0,   0x00
	.equ GPIO_GPLEV0,    0x34

	.equ DELAY_CYCLES,     0xfFFfF
	.equ seis, 50

    .global Bobi

Bobi:
    sub sp, sp, #8
    stur x30, [sp,#0]

	//movimiento vertical
	mov x19, #10
	mul x19, x19, x28

	//manga derecha
		mov x15, 6
		mov x3, 344 //x
		add x4, x19, 247
		//mov x4, 257 //y ORIGINAL 
		movz x11, 0xdabf, lsl 00
		movk x11, 0x00de, lsl 16
		bl circulo


	//Frente cara bob con movimiento
		mov x9, #295     // x1
		add x10, x19, 206 // y1
		//mov x10, #216    // y1
		mov x11, #345    // x2
		add x12, x19, 207 // y2
		mov x13, #343    // x3
		add x14, x19, 256 // y3
		mov x15, #302     // x4
		add x16, x19, 256 // y4  
		movz x21, 0xc737, lsl 00
		movk x21, 0x00e3, lsl 16
		mov x22, #302
		
		add x23, x19, 225 // y1
		bl cuadradoR
	//costado cara bob
		mov x9, #295     // x1
		add x10, x19, 206 // y1
		mov x11, #285   // x2
		add x12, x19, 219 // y2
		mov x13, #293    // x3
		add x14, x19, 258 // y3
		mov x15, #302     // x4
		add x16, x19, 256 // y4  
		movz x21, 0x8d29, lsl 00
		movk x21, 0x008d, lsl 16
		mov x22, #293
		add x23, x19, 237 // y del relleno
		bl cuadradoR

	//manga izq
		mov x15, 6
		mov x3, 292 //x
		add x4, x19, 247 // y
		movz x11, 0xdabf, lsl 00
		movk x11, 0x00de, lsl 16
		bl circulo
	//detalle manga izq
		movz x11, 0x83, lsl 16
		movk x11, 0x9386, lsl 0
		//mov x3, 257
		add x3, x19, 247 // y
		mov x4, 289
		mov x5, 3
		mov x6, 5
		bl elipse
	//---------------------------------------------------------------

   //frente superior ropa bob
		mov x9, #302     // x1
		add x10, x19, 257 // y1
		mov x11, #343    // x2
		add x12, x19, 257 // y2
		mov x13, #343    // x3
		add x14, x19, 263 // y3
		mov x15, #302     // x4
		add x16, x19, 263 // y4 
		movz x21, 0xdabf, lsl 00
		movk x21, 0x00de, lsl 16
		mov x22, #315
		add x23, x19, 260 // y
		bl cuadradoR
	//costado superior ropa bob
		mov x9, #302     // x1
		add x10, x19, 257 // y1
		mov x11, #302    // x2
		add x12, x19, 263 // y2
		mov x13, #293    // x3
		add x14, x19, 263 // y3
		mov x15, #293     // x4
		add x16, x19, 259 // y4  
		movz x21, 0x9e8d, lsl 00
		movk x21, 0x0073, lsl 16
		mov x22, #297
		add x23, x19, 261 // y
		bl cuadradoR

	//frente inferior ropa bob
		mov x9, #302     // x1
		add x10, x19, 263 // y1
		mov x11, #343    // x2
		add x12, x19, 263 // y2
		mov x13, #343    // x3
		add x14, x19, 273 // y3
		mov x15, #302     // x4
		add x16, x19, 273 // y4
		movz x21, 0x4218, lsl 00
		movk x21, 0x006d, lsl 16
		mov x22, #309
		add x23, x19, 265 // y
		bl cuadradoR
	//costado inferior ropa bob
		mov x9, #302     // x1
		add x10, x19, 263 // y1
		mov x11, #302    // x2
		add x12, x19, 273 // y2
		mov x13, #293    // x3
		add x14, x19, 270 // y3
		mov x15, #293     // x4
		add x16, x19, 263 // y4  
		movz x21, 0x3219, lsl 00
		movk x21, 0x003c, lsl 16
		mov x22, #298
		add x23, x19, 268 // y
		bl cuadradoR
	//Manga pantalon izquerda 
		add x3, x19, 275 // y
		mov x4,309 //x
		mov x5,6
		mov x6,5
		movz x11, 0x4218, lsl 00
		movk x11, 0x006d, lsl 16
		bl elipse
	//Manga pantalon izquerda 
		add x3, x19, 274 // y
		mov x4,329 //x
		mov x5,6
		mov x6,5
		movz x11, 0x4218, lsl 00
		movk x11, 0x006d, lsl 16
		bl elipse

	//zapato izquierdo
		mov x15, 5
		mov x3, 309
		add x4, x19, 299 // y
		movz x11, 0x2324, lsl 00
		movk x11, 0x000f, lsl 16
		bl circulo
		mov x15, 5
		mov x3, 305
		add x4, x19, 304 // y
		movz x11, 0x2324, lsl 00
		movk x11, 0x000f, lsl 16
		bl circulo
		//zapato derecho
		mov x15, 5
		mov x3, 328
		mov x4, 308
		add x4, x19, 298 // y
		movz x11, 0x2324, lsl 00
		movk x11, 0x000f, lsl 16
		bl circulo
		mov x15, 5
		mov x3, 333
		add x4, x19, 303 // y
		movz x11, 0x2324, lsl 00
		movk x11, 0x000f, lsl 16
		bl circulo

	//Pierna izquierda
		mov x9, #307     // x1
		add x10, x19, 280 // y1
		mov x11, #310    // x2
		add x12, x19, 280 // y2
		mov x13, #310    // x3
		add x14, x19, 294 // y3
		mov x15, #307     // x4
		mov x16, #306     // y4
		add x16, x19, 296 // y  
		movz x21, 0xc737, lsl 00
		movk x21, 0x00e3, lsl 16
		mov x22, #308
		add x23, x19, 284 // y
		bl cuadradoR

	//Pierna derecha
		mov x9, #328     // x1
		add x10, x19, #279    // y1
		mov x11, #330    // x2
		add x12, x19, #279    // y2
		mov x13, #330    // x3
		add x14, x19, #295    // y3
		mov x15, #328     // x4
		add x16, x19, #293     // y4  
		movz x21, 0xc737, lsl 00
		movk x21, 0x00e3, lsl 16
		mov x22, #328
		add x23, x19, #285
		bl cuadradoR

	//mano izquierda parte 1
		mov x9, #265     // x1
		add x10, x19, #240    // y1
		mov x11, #270    // x2
		add x12, x19, #245    // y2
		mov x13, #268    // x3
		add x14, x19, #251    // y3
		mov x15, #260     // x4
		add x16, x19, #252     // y4  
		movz x21, 0xc737, lsl 00
		movk x21, 0x00e3, lsl 16
		mov x22, #266
		add x23, x19, #246
		bl cuadradoR
	//mano izquierda parte 1
		mov x9, #264     // x1
		add x10, x19, #243    // y1
		mov x11, #260    // x2
		add x12, x19, #251    // y2
		mov x13, #255    // x3
		add x14, x19, #248    // y3
		mov x15, #257     // x4
		add x16, x19, #243     // y4  
		movz x21, 0xc737, lsl 00
		movk x21, 0x00e3, lsl 16
		mov x22, #260
		add x23, x19, #245
		bl cuadradoR
	//brazo izquierdo
		mov x9, #288     // x1
		add x10, x19, #245    // y1
		mov x11, #290    // x2
		add x12, x19, #248    // y2
		mov x13, #269    // x3
		add x14, x19, #248    // y3
		mov x15, #270     // x4
		add x16, x19, #245     // y4  
		movz x21, 0xc737, lsl 00
		movk x21, 0x00e3, lsl 16
		mov x22, #275
		add x23, x19, #246
		bl cuadradoR

	//mano derecho parte 1
		mov x9, #368    // x1
		add x10, x19, #245    // y1
		mov x11, #373    // x2
		add x12, x19, #241    // y2
		mov x13, #375    // x3
		add x14, x19, #244    // y3
		mov x15, #372     // x4
		add x16, x19, #252     // y4  
		movz x21, 0xc737, lsl 00
		movk x21, 0x00e3, lsl 16
		mov x22, #372
		add x23, x19, #245
		bl cuadradoR
	//mano derecho parte 1
		mov x9, #375     // x1
		add x10, x19, #244    // y1
		mov x11, #382    // x2
		add x12, x19, #244    // y2
		mov x13, #377    // x3
		add x14, x19, #252    // y3
		mov x15, #372     // x4
		add x16, x19, #252     // y4  
		movz x21, 0xc737, lsl 00
		movk x21, 0x00e3, lsl 16
		mov x22, #377
		add x23, x19,  #246
		bl cuadradoR
	//brazo derecho
		mov x9, #349     // x1
		add x10, x19, #245    // y1
		mov x11, #372    // x2
		add x12, x19, #245    // y2
		mov x13, #372    // x3
		add x14, x19, #249    // y3
		mov x15, #349     // x4
		add x16, x19, #249     // y4  
		movz x21, 0xc737, lsl 00
		movk x21, 0x00e3, lsl 16
		mov x22, #358
		add x23, x19, #247
		bl cuadradoR

	//----DETALLES------------------------------------------------------------------
		//Circulos costado
			add x3, x19, 221 //y
			mov x4, 292 //x
			mov x5,3
			mov x6,4
			movz x11, 0x4b16, lsl 00
			movk x11, 0x0041, lsl 16
			bl elipse

			add x3, x19, 230 //y
			mov x4,294 //x
			mov x5,2
			mov x6,2
			movz x11, 0x4b16, lsl 00
			movk x11, 0x0041, lsl 16
			bl elipse

			add x3, x19, 237 //y
			mov x4,296 //x
			mov x5,2
			mov x6,4
			movz x11, 0x4b16, lsl 00
			movk x11, 0x0041, lsl 16
			bl elipse

		//Circulos frente
			add x3, x19, 213 //y
			mov x4,303 //x
			mov x5,3
			mov x6,3
			movz x11, 0x8121, lsl 00
			movk x11, 0x007a, lsl 16
			bl elipse

			add x3, x19, 241 //y
			mov x4,305 //x
			mov x5,2
			mov x6,2
			movz x11, 0x8121, lsl 00
			movk x11, 0x007a, lsl 16
			bl elipse

			add x3, x19, 250 //y
			mov x4,308 //x
			mov x5,2
			mov x6,3
			movz x11, 0x8121, lsl 00
			movk x11, 0x007a, lsl 16
			bl elipse

			add x3, x19, 251 //y
			mov x4,337 //x
			mov x5,2
			mov x6,3
			movz x11, 0x8121, lsl 00
			movk x11, 0x007a, lsl 16
			bl elipse

			add x3, x19, 243 //y
			mov x4,340 //x
			mov x5,2
			mov x6,4
			movz x11, 0x8121, lsl 00
			movk x11, 0x007a, lsl 16
			bl elipse

			add x3, x19, 213 //y
			mov x4,340 //x
			mov x5,2
			mov x6,2
			movz x11, 0x8121, lsl 00
			movk x11, 0x007a, lsl 16
			bl elipse

		//OJOS,NARIZ Y BOCA 
			//OJOS
				add x3, x19, 224 //y
				mov x4,315 //x
				mov x5,8
				mov x6,10
				movz x11, 0xf7ff, lsl 00
				movk x11, 0x00d2, lsl 16
				bl elipse
				add x3, x19, 224 //y
				mov x4,330 //x
				mov x5,8
				mov x6,10
				movz x11, 0xf7ff, lsl 00
				movk x11, 0x00d2, lsl 16
				bl elipse

			//NARIZ
				mov x9, #324     // x1
				add x10, x19, #232    // y1
				mov x11, #333    // x2
				add x12, x19, #227    // y2
				mov x13, #338    // x3
				add x14, x19, #230    // y3
				mov x15, #335     // x4
				add x16, x19, #236     // y4  
				movz x21, 0xc737, lsl 00
				movk x21, 0x00e3, lsl 16
				mov x22, #333
				add x23, x19, #230
				bl cuadradoR

				mov x9,322
				add x10, x19, 222
				mov x11,322
				add x12, x19, 228
				movz x21, 0x8d29, lsl 00
				movk x21, 0x008d, lsl 16
				bl bresenham

				mov x9,322
				add x10, x19, 228
				mov x11,324
				add x12, x19, 232
				movz x21, 0x8d29, lsl 00
				movk x21, 0x008d, lsl 16
				bl bresenham

				mov x9,324
				add x10, x19, 232
				mov x11,333
				add x12, x19, 227
				movz x21, 0x8d29, lsl 00
				movk x21, 0x008d, lsl 16
				bl bresenham

				mov x9,333
				add x10, x19, 227
				mov x11,336
				add x12, x19, 229
				movz x21, 0x8d29, lsl 00
				movk x21, 0x008d, lsl 16
				bl bresenham

				mov x9,336
				add x10, x19, 229
				mov x11,335
				add x12, x19, 233
				movz x21, 0x8d29, lsl 00
				movk x21, 0x008d, lsl 16
				bl bresenham

				mov x9,335
				add x10, x19, 233
				mov x11,326
				add x12, x19, 235
				movz x21, 0x8d29, lsl 00
				movk x21, 0x008d, lsl 16
				bl bresenham
			
			//BOCA
				mov x9, #312     // x1
				add x10, x19, #243    // y1
				mov x11, #315    // x2
				add x12, x19, #245    // y2
				mov x13, #321    // x3
				add x14, x19, #243    // y3
				mov x15, #321     // x4
				add x16, x19, #239     // y4  
				movz x21, 0x2619, lsl 00
				movk x21, 0x0052, lsl 16
				mov x22, #316
				add x23, x19,  #242
				bl cuadradoR

				mov x9, #321     // x1
				add x10, x19,  #239    // y1
				mov x11, #327    // x2
				add x12, x19, #239    // y2
				mov x13, #327    // x3
				add x14, x19, #243    // y3
				mov x15, #321     // x4
				add x16, x19, #243     // y4  
				movz x21, 0x2619, lsl 00
				movk x21, 0x0052, lsl 16
				mov x22, #324
				add x23, x19, #240
				bl cuadradoR

				mov x9, #327     // x1
				add x10, x19, #239    // y1
				mov x11, #333    // x2
				add x12, x19, #241    // y2
				mov x13, #333    // x3
				add x14, x19, #244    // y3
				mov x15, #327     // x4
				add x16, x19, #243     // y4  
				movz x21, 0x2619, lsl 00
				movk x21, 0x0052, lsl 16
				mov x22, #331
				add x23, x19, #242
				bl cuadradoR

    ldur x30, [sp,#0]
    add sp, sp, #8
ret
InfLoop: 
	b InfLoop
