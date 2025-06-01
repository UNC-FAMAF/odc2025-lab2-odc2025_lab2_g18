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
    .global rectangulos_fondo
    .global pixel_ventana

main:
	// x0 contiene la direccion base del framebuffer
 	mov x20, x0	// Guarda la dirección base del framebuffer en x20
	//---------------- CODE HERE ------------------------------------
movz x11, 0x6666, lsl 16
movk x11, 0xFF, lsl 0
/*  
tanteando algo!
bl pantalla
mov x3, 0
mov x4, 200
mov x5, 100
mov x6, 300 
	loop:
	mov x12, 100000
	mov x10, 23
	movk x11, 0xFF, lsl 16

	bl mallado
	b loop



*/
InfLoop:
	b InfLoop

delay: 
	mov x13, x12       // Copia el valor de x12 a x13 (contador)
	delay_loop:
    subs x13, x13, #1   // Resta 1 a x13 y actualiza los flags
    bne delay_loop      // Si x13 != 0, sigue en el bucle
    ret 