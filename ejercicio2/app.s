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
	.global elipse

main:
	// x0 contiene la direccion base del framebuffer
 	mov x20, x0	// Guarda la dirección base del framebuffer en x20
	//---------------- CODE HERE ------------------------------------


	prueba:
		bl pantalla

	mov x3,100 //y
	mov x4,320 //x
	mov x5,70  //h
	mov x6,25  //v
	movz x11, 0x00, lsl 16
	movk x11, 0x0000, lsl 00

	bl elipse

// aaaaaaaaaaaaaaaaaaaaaaaaa


bl delay


movz x11, 0x66, lsl 16
movk x11, 0x66FF, lsl 0
bl pantalla


movz x11, 0xFF, lsl 16
movk x11, 0xFFFF, lsl 0
mov x3, 100
mov x5, 100
bl pixel

bl delay

mov x3, 110
mov x5, 100
bl pixel

bl delay

mov x3, 120
mov x5, 100

bl pixel

bl delay

mov x3, 130
mov x5, 100

bl pixel

bl delay

movz x11, 0x66, lsl 16
movk x11, 0x66FF, lsl 0

bl pantalla

loopp:

movz x11, 0xFF, lsl 16
movk x11, 0xFFFF, lsl 0

add x5, x5, 1

bl delay

bl pixel

bl delay

movz x11, 0x66, lsl 16
movk x11, 0x66FF, lsl 0

bl pantalla

b loopp


InfLoop:
	b InfLoop
