	.equ SCREEN_WIDTH, 		640
	.equ SCREEN_HEIGH, 		480
	.equ BITS_PER_PIXEL,  	32

	.equ GPIO_BASE,      0x3f200000
	.equ GPIO_GPFSEL0,   0x00
	.equ GPIO_GPLEV0,    0x34

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
	//
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

	mov x3, 300
	mov x5, 60
	bl estrella
estrellas_end:


//LLAMAR A ELIPSE CON X3(YC), X4(XC), X5(SEMIEJE H A), X6(SEMIEJE V B) Y COLOR EN X11

movk x11, 0xC, lsl 16
movk x11, 0x5961, lsl 0 
mov x3, 479 
mov x4, 319
mov x5, 176
mov x6, 96
 
bl elipse

InfLoop:
	b InfLoop
