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

recta_bresenham:
    /* Backup en la pila, para evitar posibles perdidas */
    sub sp, sp, 176 //Añade espacio para guardar en heap/pila
    stur x3, [sp,0]
    stur x4, [sp,16]
    stur x9, [sp,32]
    stur x10, [sp,48]
    stur x11, [sp,64]
    stur x12, [sp,80]
    stur x13, [sp,96]
    stur x14, [sp,112]
    stur x16, [sp,128]
    stur x17, [sp,144]
    stur x18, [sp,160]
    stur x19, [sp,176]

    /*Pequeño resumen: 
        https://saturncloud.io/blog/bresenham-line-algorithm-a-powerful-tool-for-efficient-line-drawing/?_gl=1*1e34fig*_gcl_au*MjEyMzM4MzgwOC4xNzQ3ODY3NjI0*_ga*MTE0MTAzMjE4NS4xNzQ3ODY3NjI1*_ga_9QKGCS5Q41*czE3NDc5NjE0MTgkbzIkZzAkdDE3NDc5NjE0MTgkajYwJGwwJGgwJGRzb1B4QktXb0RDc0NWQWlxRHpkbGhlTDlhWHFZUXhJcGVB#how-does-the-bresenham-line-algorithm-work
        x9, x10 := coordenada inicial (x0, y0)
        x11, x12 := coordenada final (x1, y1) 
        x13 := dx = abs(x1-x0) 
        x14 := dy = abs(y1-y0) 
        x15 := direc. horizontal de la recta desde el punto inicial
        x17 := direc. vertical de la recta desde el punto inicial
        x19 := valor de error (CRITERIO DE SELECCION)
    */

    // x13 := dx = abs(x1-x0) 
    subs x13,x11,x9
	bge abs_x_listo
	sub x13,xzr,x13
	abs_x_listo:

    // x14 := dy = abs(y1-y0) 
    subs x14,x12,x10
	bge abs_y_lsito
	sub x14,xzr,x14
    abs_y_lsito:

    // x15 := sx = (x9 < x11) ? 1 : -1 
	/*Chequea si x0 < x1: 
		si es asi entonces avanza (1)
		si no es asi entonces retrocede (-1)
	*/
    cmp x9, x11
    mov x15, 1
    mov x16, -1
    blt sx_set
    mov x15, x16
	sx_set:

    // x17 := sy = (x10 < x12) ? 1 : -1
	/* Chequea si y0 < y1: 
		si es asi entonces se sube (1)
		si no es asi entonces se baja (-1)
	*/
    cmp x10, x12
    mov x17, 1
    mov x16, -1
    blt sy_set
    mov x17, x16
sy_set:

    // err = dx - dy <--- ESTO DECIDE DESPUES A DONDE MOVER (Criterio de algoritmo voraz)
    sub x19, x13, x14
    /*err representa la diferencia acumulada entre la línea ideal (la que no podemos calcular aca) 
    y la línea que se está pintando pixel por pixel en nuestra cuadrícula. */

recta_bresenham_loop:
    /*Esta parte genera la direccion que se debe pintar, y la pinta */
    mov x16, x9 //x16 = x9 (x0)
    mov x18, x10 //x18 = x10 (y0)
    mov x2, SCREEN_WIDTH //x2 = 640
    mul x3, x18, x2 //x3 = x18 * x2 = Y0 * SCREEN_WIDTH
    add x3, x3, x16 // x3 = Y0 * SCREEN_WIDTH + x0
    lsl x3, x3, 2 // x3 = (Y0 * SCREEN_WIDTH + x0)*4 (No me deja usar mul con un entero¿?)
    add x4, x20, x3 //x4 = dirección base + (Y0 * SCREEN_WIDTH + x0)*4
    stur w21, [x4] //Guarda color en x4, ¿y si hacemos este troncho una funcion llamable?

    // ¿Llegamos al al punto final (x1,y1)? Compara punto actual con final
    cmp x9, x11
    bne not_end_x
    cmp x10, x12
    beq recta_bresenham_end
not_end_x:

    /*¡ACA ENTRA EL CRITERIO DE SELECCION! Para esta parte vean el link porfa*/
    // e2 = 2*err
    lsl x5, x19, 1

    // if e2 > -dy  ¡Recordar: dy = abs(y1-y0)!
    sub x6, xzr, x14
    cmp x5, x6
    ble skip_x
    add x9, x9, x15
    sub x19, x19, x14
skip_x:

    // if e2 < dx ¡Recordar dx = abs(x1-x0)!
    cmp x5, x13 //Compara (2*err) con abs(x1-x0)
    bge skip_y  //Salta si (2*err) >= abs(x1-x0)
    add x10, x10, x17 //x10 (y0) = y0+1 OR y0-1
    add x19, x19, x13 //x19 (err) = err+abs(x1-x0)
skip_y:

    b recta_bresenham_loop


ldur x3, [sp,0] //Devuelvo los valores originales,
ldur x4, [sp,16]
ldur x9, [sp,32]
ldur x10, [sp,48]
ldur x11, [sp,64]
ldur x12, [sp,80]
ldur x13, [sp,96]
ldur x14, [sp,112]
ldur x16, [sp,128]
ldur x17, [sp,144]
ldur x18, [sp,160]
ldur x19, [sp,176]
add sp, sp, 176        //Libera el espacio reservado
recta_bresenham_end:
    ret	


InfLoop:
	b InfLoop

