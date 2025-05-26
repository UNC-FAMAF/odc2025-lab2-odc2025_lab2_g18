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

//MALLADO
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

//CIRCULO
//ANTES DE LLAMAR CIRCULO ASIGNAR VALORES A yc=X4, xc=X3, radio=X15 y x11 color.
circulo:

        sub x21, x4, x15 //y=yc-radio (seria indicar el comienzo del circulo verticalmente)
        mov x5, x21
    circulo_y:
        add x23, x4, x15 //y=yc+radio (seria indicar el final del circulo verticalmente)
        cmp x5, x23 //mientras x5<=x23 (filas) 
        b.ge fin_circulo

        sub x22, x3, x15 //x=xc-radio (seria indicar el comienzo del circulo horizontalmente)
        mov x6, x22
    circulo_x:
        add x24, x3, x15 //x=xc+radio (seria indicar el final del circulo horizontalmente)
        cmp x6, x24 // mientras x6<=x24 (columnas)
        b.ge siguiente_fila_circulo

        // Calcular (x - xc)^2 + (y - yc)^2 -- describe el interior y borde del circulo
        sub x16, x6, x3
        mul x16, x16, x16      // (x - xc)^2

        sub x17, x5, x4
        mul x17, x17, x17      // (y - yc)^2

        add x18, x16, x17      // suma

        mul x19, x15, x15      // radio^2

        cmp x18, x19 //mientras el punto este dentro del circulo (x^2 + y^2 <= r^2)
        b.gt no_pintar_pixel

        // dirección de pixel
        mov x7, SCREEN_WIDTH //cant de columnas
        mul x8, x5, x7// x7=x3 (y)
        add x8, x8, x6// x7= y * SCREEN_WIDTH
        lsl x8, x8, 2// x7= (y * SCREEN_WIDTH)+x
        add x8, x20, x8// x7=((y * SCREEN_WIDTH)+x)*2 ^2

        stur w11, [x8] 

    no_pintar_pixel:
        add x6, x6, 1 //paso a la siguiente columna
        b circulo_x

    siguiente_fila_circulo:
        add x5, x5, 1
        b circulo_y

fin_circulo:
ret 

InfLoop:
	b InfLoop

