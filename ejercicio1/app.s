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
	.global lineas_boton_expandir_h
	.global lineas_boton_expandir_v
   .global odc_2025
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



botones:
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

	//------BOTON PLAY-------//
	mov x3, 56
	mov x4, 69
	mov x5, 453
	mov x6, 466
	bl boton

	//lineas para hacer triangulo//

	mov x9, 456
	mov x10, 59
	mov x11, 456
	mov x12, 66
	mov x13, 463
	mov x14, 63
	mov x15, 463
	mov x16, 62
	mov x22, 460
	mov x23, 63
	movz x21, 0x4040, lsl 00 
	movk x21, 0x40, lsl 16
	bl cuadradoR

	//--------BOTON AGRANDAR PANTALLA-------//
	mov x3, 56
	mov x4, 69
	mov x5, 437
	mov x6, 450
	bl boton

	//bordes
	mov x3, 59
	mov x4, 66
	mov x5, 440
	mov x6, 447
	movz x11, 0x4040, lsl 00 
	movk x11, 0x40, lsl 16
	bl rectangulo
	//cuadrado del medio
	mov x3, 60
	mov x4, 65
	mov x5, 441
	mov x6, 446
	movz x11, 0x909E, lsl 00 
	movk x11, 0x7D, lsl 16
	bl rectangulo


	mov x9,440
	mov x10,61
	mov x11,447
	mov x12,61
	bl lineas_boton_expandir_h

	mov x9,442
	mov x10,59 
	mov x11,442
	mov x12,65
	bl lineas_boton_expandir_v


gato:
   //cuerpo 1
   mov x3, 386
   mov x4, 400
   mov x5, 162
   mov x6, 262
   movz x11, 0x00, lsl 00
   bl rectangulo


   //pata
   mov x9, #262     // x1
   mov x10, #366     // y1
   mov x11, #272     // x2
   mov x12, #391     // y2
   mov x13, #282     // x3
   mov x14, #400     // y3
   mov x15, #262     // x4
   mov x16, #400     // y4
   mov x21, #0x00     
   mov x22, #268
   mov x23, #394
   bl cuadradoR
   
   //cuerpo 2
   mov x9, #162     // x1
   mov x10, #375     // y1
   mov x11, #265     // x2
   mov x12, #375     // y2
   mov x13, #262     // x3
   mov x14, #386     // y3
   mov x15, #162     // x4
   mov x16, #386     // y4   
   mov x22, #213
   mov x23, #381
   bl cuadradoR

   //cuerpo 3
   mov x3, 338
   mov x4, 375
   mov x5, 162
   mov x6, 265
   movz x11, 0x00, lsl 00
   bl rectangulo

   //cuerpo 4
   mov x9, #162     // x1
   mov x10, #316     // y1
   mov x11, #256     // x2
   mov x12, #316     // y2
   mov x13, #265     // x3
   mov x14, #388     // y3
   mov x15, #162     // x4
   mov x16, #338     // y4
   mov x22, #205
   mov x23, #326  
   bl cuadradoR

   //cuerpo 5
   mov x3, 307
   mov x4, 316
   mov x5, 162
   mov x6, 256
   movz x11, 0x00, lsl 00
   bl rectangulo

   //cuerpo 6
   mov x9, #162     // x1
   mov x10, #307    // y1
   mov x11, #256    // x2
   mov x12, #307     // y2
   mov x13, #274     // x3
   mov x14, #277     // y3
   mov x15, #266     // x4
   mov x16, #240     // y4
   mov x22, #226
   mov x23, #277  
   bl cuadradoR
   
   //cuerpo 7
   mov x9, #162     // x1
   mov x10, #307    // y1
   mov x11, #266    // x2
   mov x12, #240     // y2
   mov x13, #180     // x3
   mov x14, #218     // y3
   mov x15, #162     // x4
   mov x16, #248     // y4 
   mov x22, #196
   mov x23, #238  
   bl cuadradoR
   
   //cuerpo 8
   mov x9, #180     // x1
   mov x10, #218    // y1
   mov x11, #206    // x2
   mov x12, #194     // y2
   mov x13, #278     // x3
   mov x14, #231     // y3
   mov x15, #266     // x4
   mov x16, #240     // y4
   mov x22, #229
   mov x23, #218  
   bl cuadradoR
   
   //cuerpo 9
   mov x9, #206     // x1
   mov x10, #194    // y1
   mov x11, #247    // x2
   mov x12, #173     // y2
   mov x13, #290     // x3
   mov x14, #221     // y3
   mov x15, #277     // x4
   mov x16, #231     // y4  
   mov x22, #251
   mov x23, #202
   bl cuadradoR
   
   //cuerpo 10
   mov x9, #247     // x1
   mov x10, #173    // y1
   mov x11, #325    // x2
   mov x12, #174     // y2
   mov x13, #290     // x3
   mov x14, #221     // y3
   mov x15, #290     // x4
   mov x16, #221     // y4 
   mov x22, #278
   mov x23, #192
   bl cuadradoR

   //cuerpo 11
   mov x9, #247     // x1
   mov x10, #173    // y1
   mov x11, #253    // x2
   mov x12, #149     // y2
   mov x13, #306     // x3
   mov x14, #143     // y3
   mov x15, #325     // x4
   mov x16, #174     // y4
   mov x22, #280
   mov x23, #158
   bl cuadradoR
   
   //oreja 1
   mov x9, #253     // x1
   mov x10, #149    // y1
   mov x11, #258    // x2
   mov x12, #133     // y2
   mov x13, #282     // x3
   mov x14, #112     // y3
   mov x15, #306     // x4
   mov x16, #143     // y4 
   mov x22, #277
   mov x23, #134
   bl cuadradoR
   
   //oreja 2
   mov x9, #282     // x1
   mov x10, #112    // y1
   mov x11, #318    // x2
   mov x12, #103     // y2
   mov x13, #322     // x3
   mov x14, #106     // y3
   mov x15, #306     // x4
   mov x16, #143     // y4
   mov x22, #306
   mov x23, #117
   bl cuadradoR
   
   //oreja 3
   mov x9, #306     // x1
   mov x10, #143    // y1
   mov x11, #342    // x2
   mov x12, #205     // y2
   mov x13, #364     // x3
   mov x14, #181     // y3
   mov x15, #364     // x4
   mov x16, #181     // y4
   mov x22, #344
   mov x23, #178
   bl cuadradoR
   
   //oreja 4
   mov x9, #330     // x1
   mov x10, #158    // y1
   mov x11, #363    // x2
   mov x12, #132     // y2
   mov x13, #369     // x3
   mov x14, #136     // y3
   mov x15, #364     // x4
   mov x16, #181     // y4 
   mov x22, #351
   mov x23, #154
   bl cuadradoR
   
   //oreja interior 1
   mov x9, #261     // x1
   mov x10, #144    // y1
   mov x11, #264    // x2
   mov x12, #134     // y2
   mov x13, #285     // x3
   mov x14, #118     // y3
   mov x15, #295     // x4
   mov x16, #140     // y4  
   movz x21, 0x007B, lsl 00
   movk x21, 0x5CBA, lsl 16
   mov x22, #277
   mov x23, #134
   bl cuadradoR
   
  
   //oreja interior 2
   mov x9, #285     // x1
   mov x10, #118    // y1
   mov x11, #316    // x2
   mov x12, #108     // y2
   mov x13, #316     // x3
   mov x14, #115     // y3
   mov x15, #295     // x4
   mov x16, #140     // y4  
   movz x21, 0x007B, lsl 00
   movk x21, 0x5CBA, lsl 16
   mov x22, #300
   mov x23, #120
   bl cuadradoR
   
   //oreja interior 3
   mov x9, #344     // x1
   mov x10, #194    // y1
   mov x11, #349    // x2
   mov x12, #194     // y2
   mov x13, #359     // x3
   mov x14, #179     // y3
   mov x15, #340     // x4
   mov x16, #176     // y4  
   movz x21, 0x007B, lsl 00
   movk x21, 0x5CBA, lsl 16
   mov x22, #348
   mov x23, #185
   bl cuadradoR
   
   //oreja interior 4
   mov x9, #340     // x1
   mov x10, #176    // y1
   mov x11, #364    // x2
   mov x12, #137     // y2
   mov x13, #366     // x3
   mov x14, #139     // y3
   mov x15, #360     // x4
   mov x16, #178     // y4  
   movz x21, 0x007B, lsl 00
   movk x21, 0x5CBA, lsl 16
   mov x22, #356
   mov x23, #161
   bl cuadradoR

   //cabeza
   mov x11, #0x00
   mov x15, 30
   mov x3, 313 //xc
   mov x4, 200 //yc
   bl circulo

   //ojos 1
   movz x11, 0x06D2, lsl 00
   movk x11, 0x8A, lsl 16
   mov x15, 11
   mov x3, 326 //xc
   mov x4, 199 //yc
   bl circulo

   //PUPILA 1
   mov x11, #0x00
   mov x15, 10
   mov x3, 320 //xc
   mov x4, 200 //yc
   bl circulo

   //ojos 2
   movz x11, 0x06D2, lsl 00
   movk x11, 0x8A, lsl 16
   mov x15, 12
   mov x3, 289 //xc
   mov x4, 178 //yc
   bl circulo 
   
   //PUPILA 2
   mov x11, #0x00
   mov x15, 11
   mov x3, 283 //xc
   mov x4, 180 //yc
   bl circulo 


   //nariz

   movz x11, 0x6285, lsl 00
   movk x11, 0xF3, lsl 16
   mov x15, 6
   mov x3, 309 //xc
   mov x4, 207 //yc
   bl circulo

   movz x11, 0x6285, lsl 00
   movk x11, 0xF3, lsl 16
   mov x15, 6
   mov x3, 301 //xc
   mov x4, 202 //yc
   bl circulo

   movz x11, 0x6285, lsl 00
   movk x11, 0xF3, lsl 16
   mov x15, 6
   mov x3, 304 //xc
   mov x4, 207 //yc
   bl circulo
   
   mov x11, 0x00
   mov x15, 5
   mov x3, 310 //xc
   mov x4, 209 //yc
   bl circulo 

   mov x11, 0x00
   mov x15, 5
   mov x3, 298 //xc
   mov x4, 202 //yc
   bl circulo 

   /*movz x11, 0x6285, lsl 00
   movk x11, 0xF3, lsl 16
   mov x15, 4
   mov x3, 290 //xc
   mov x4, 212 //yc
   bl circulo


   movz x11, 0x6285, lsl 00
   movk x11, 0xF3, lsl 16
   mov x15, 4
   mov x3, 297 //xc
   mov x4, 216 //yc
   bl circulo 

   movz x11, 0x6285, lsl 00
   movk x11, 0xF3, lsl 16
   mov x15, 4
   mov x3, 294 //xc
   mov x4, 216 //yc
   bl circulo 

   mov x11, 0x00
   mov x15, 2
   mov x3, 290 //xc
   mov x4, 215 //yc
   bl circulo 
   mov x11, 0x00
   mov x15, 2
   mov x3, 296 //xc
   mov x4, 218 //yc
   bl circulo 
   */


   //bigotes 
   mov x9,315
   mov x10,213
   mov x11,353
   mov x12,237
   mov x21, 0xffffff
   bl bresenham
   
   mov x9,313
   mov x10,218
   mov x11,336
   mov x12,243
   mov x21, 0xffffff
   bl bresenham

   mov x9, 311
   mov x10,219
   mov x11,321
   mov x12,244
   mov x21, 0xffffff
   bl bresenham
   
   
   mov x9,290
   mov x10,197
   mov x11,261
   mov x12,177
   mov x21, 0xffffff
   bl bresenham

   mov x9,287
   mov x10,200
   mov x11,255
   mov x12,191
   mov x21, 0xffffff
   bl bresenham

   mov x9,285
   mov x10,203
   mov x11,264
   mov x12,206
   mov x21, 0xffffff
   bl bresenham
   
   //pestañas
   mov x9,332
   mov x10,176
   mov x11,359
   mov x12,166
   mov x21, 0xffffff
   bl bresenham
   
   mov x9,332
   mov x10,176
   mov x11,372
   mov x12,144
   mov x21, 0xffffff
   bl bresenham
   
   mov x9,310
   mov x10,171
   mov x11,328
   mov x12,131
   mov x21, 0xffffff
   bl bresenham
   
   mov x9,308
   mov x10,159
   mov x11,314
   mov x12,111
   mov x21, 0xffffff
   bl bresenham
   
   //cejas
   mov x9, #324     // x1
   mov x10, #184    // y1
   mov x11, #329    // x2
   mov x12, #181     // y2
   mov x13, #329     // x3
   mov x14, #176     // y3
   mov x15, #324     // x4
   mov x16, #180     // y4  
   movz x21, 0x6060, lsl 00
   movk x21, 0x60, lsl 16
   mov x22, #327
   mov x23, #180
   bl cuadradoR
   
   mov x9, #306     // x1
   mov x10, #176    // y1
   mov x11, #312    // x2
   mov x12, #172     // y2
   mov x13, #312     // x3
   mov x14, #163     // y3
   mov x15, #306     // x4
   mov x16, #167     // y4  
   movz x21, 0x6060, lsl 00
   movk x21, 0x60, lsl 16
   mov x22, #309
   mov x23, #169
   bl cuadradoR

fin_gato:
   // leyenda odc_2025
mov x3, 58
mov x5,158

bl odc_2025


InfLoop:
b InfLoop
