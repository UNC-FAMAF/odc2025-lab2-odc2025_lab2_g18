.equ SCREEN_WIDTH, 		640
	.equ SCREEN_HEIGH, 		480
	.equ BITS_PER_PIXEL,  	32

	.equ GPIO_BASE,      0x3f200000
	.equ GPIO_GPFSEL0,   0x00
	.equ GPIO_GPLEV0,    0x34


    .global rectangulo
    .global pantalla

	//.global main

    //main:

 	mov x20, x0	
	

// FONDO LISO, color en x11
//ANTES DE LLAMAR A PANTALLA ES NECESARIO ASIGNAR VALOR A X11!!

pantalla:
	    mov x2, SCREEN_HEIGH         // Y Size
    loop1:
	    mov x1, SCREEN_WIDTH         // X Size
    loop0:
	    stur w11,[x0]  // Colorear el pixel N
	    add x0,x0,4	   // Siguiente pixel
	    sub x1,x1,1	   // Decrementar contador X
	    cbnz x1,loop0  // Si no terminó la fila, salto
	    sub x2,x2,1	   // Decrementar contador Y
	    cbnz x2,loop1  // Si no es la última fila, salto
fin_pantalla:
ret

//CUADRADO DEFINIDO x11 color, valores de eje x = x5 hasta x6, valores de y = x3 hasta x4
//ANTES DE LLAMAR A CUADRADO NECESARIO ASIGNAR VALORES A X3,X4,X5,X6 Y X11!!

rectangulo:
        mov x9, x5            // Guarda el valor inicial de x5
    cuadro_y:
        cmp x3, x4           // mientras y  <= x4
        b.ge fin_cuadro 
        
        mov x5, x9
    cuadro_x:
       cmp x5, x6        // mientras x <= x6
        b.ge siguiente_fila

       
    // Calcula la dirección del pixel: x7 = framebuffer + ((y * SCREEN_WIDTH) + x) * 4

	    mov x8, SCREEN_WIDTH
        mov x7, x3
        mul x7, x7, x8
        add x7, x7, x5
        lsl x7, x7, 2
        add x7, x20, x7

     stur w11, [x7]       // Escribe el color del cuadrado

        add x5, x5, 1
        b cuadro_x

    siguiente_fila:
        add x3, x3, 1
        b cuadro_y

fin_cuadro:
ret

//mallado
//ANTES DE LLAMAR A CUADRADO NECESARIO ASIGNAR VALORES A X3,X4,X5,X6 Y X11!!

mallado:
	    mov x9, x5
    malla_y:
	    cmp x3, x4
	    b.ge fin_mallado   

        mov x5, x9  
    malla_x:
	    cmp x5, x6
	    b.ge sig_fila 
  
        mov x8, SCREEN_WIDTH
        mov x7, x3
        mul x7, x7, x8
        add x7, x7, x5
        lsl x7, x7, 2
        add x7, x20, x7

	    stur w11, [x7]
	    add x5, x5, 2
	    b malla_x
    sig_fila:
	    add x3, x3, 2
	    b malla_y

fin_mallado:
ret

InfLoop:
	b InfLoop

