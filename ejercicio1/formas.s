.equ SCREEN_WIDTH, 		640
	.equ SCREEN_HEIGH, 		480
	.equ BITS_PER_PIXEL,  	32

	.equ GPIO_BASE,      0x3f200000
	.equ GPIO_GPFSEL0,   0x00
	.equ GPIO_GPLEV0,    0x34


    .global rectangulo
    .global pantalla
    .global circulo
    .global cuadrado_b_relleno
    .global bresenham
    .global bresenham_con_punto_fijo

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

//CUADRILATERO
//ANTES DE LLAMAR ASIGNAR LO QUE DICE EN CADA CONJUNTO DE INSTRUCCIONES
cuadrado_b_relleno: 
    /*Sean:
    x9 = x1 //Mide que tan a la derecha debe ir
    x10 = y1 //Mide que tanto debe bajar

    x11 = x2
    x12 = y2

    x13 = x3
    x14 = y3

    x15 = x4
    x16 = y4

    x22 = punto_fijo_x
    x23 = punto_fijo_y
    */
    sub sp, sp, #88
    stur x9, [sp, #0]
    stur x10,[sp, #8]
    stur x11,[sp, #16]
    stur x12,[sp, #24]
    stur x13,[sp, #32]
    stur x14,[sp, #40]
    stur x15,[sp, #48]
    stur x16,[sp, #56]
    stur x22,[sp, #64]
    stur x23,[sp, #72]
    stur x30,[sp, #80] //RE IMPORTANTE, ES EL LR (es PC+4)

    //Primer lado
    //Los puntos coinciden con los registros para el llamdo
    mov x22, x13
    mov x23, x14
    bl bresenham_con_punto_fijo
    //segundo lado
    mov x9,x11
    mov x10,x12
    mov x11,x13
    mov x12,x14
    mov x22, x15
    mov x23, x16
    bl bresenham_con_punto_fijo
    //tercer lado
    mov x9,x13
    mov x10,x14
    mov x11,x15
    mov x12,x16
    ldur x22,[sp,#0]
    ldur x23,[sp,#8]
    bl bresenham_con_punto_fijo
    //cuarto lado
    mov x9,x15
    mov x10,x16
    ldur x11, [sp, #0]
    ldur x12, [sp, #8]
    ldur x22,[sp,#16]
    ldur x23,[sp,#24]
    bl bresenham_con_punto_fijo
    
    
    ldur x9, [sp, #0]
    ldur x10,[sp, #8]
    ldur x11,[sp, #16]
    ldur x12,[sp, #24]
    ldur x13,[sp, #32]
    ldur x14,[sp, #40]
    ldur x15,[sp, #48]
    ldur x16,[sp, #56]
    ldur x22,[sp, #64]
    ldur x23,[sp, #72]
    ldur x30,[sp, #80]
    add sp, sp, #88
    ret


bresenham:
    /* algoritmo de Bresenham 

        ¿Que hace?
            Traza rectas sin calcular la pendiente exacta.

        ¿Como lo hace?
            Es un algoritmo voraz, por lo que su criterio de seleccion
            para avanzar en x o y es la cantidad de error acumulado (dx-dy)
            (almacenado en x19).

            El acumulador de error mide que tan desviado esta el paso actual
            de la linea ideal. El algoritmo evalua las siguientes 
            condiciones para decidir en cada iteracion:

                -> Si 2*x19 > -dy, lo cual significa que el error está más cerca 
                de la siguiente columna, entonces se mueve en X.

                -> Si 2*x19 < dx, lo cual significa que el error está más cerca 
                de la siguiente fila, entonces se mueve en Y.
            
            Para mejor descripcion: https://saturncloud.io/blog/bresenham-line-algorithm-a-powerful-tool-for-efficient-line-drawing/?_gl=1*1e34fig*_gcl_au*MjEyMzM4MzgwOC4xNzQ3ODY3NjI0*_ga*MTE0MTAzMjE4NS4xNzQ3ODY3NjI1*_ga_9QKGCS5Q41*czE3NDc5NjE0MTgkbzIkZzAkdDE3NDc5NjE0MTgkajYwJGwwJGgwJGRzb1B4QktXb0RDc0NWQWlxRHpkbGhlTDlhWHFZUXhJcGVB#how-does-the-bresenham-line-algorithm-work
    */

    /* Registros utilizados:

        x3   → Direccion relativa del píxel a pintar (offset)
        x4   → Direccion absoluta del píxel en memoria (base + offset)
        x5   → 2*err (doble del error actual, usado para criterio de selec)
        x6   → -dy (negativo del delta en Y, para comparaciones)
        
        x9   → x0 (posicion actual en X)
        x10  → y0 (posicion actual en Y)
        x11  → x1 (posicion final en X)
        x12  → y1 (posicion final en Y)

        x13  → dx (|x1 - x0|, distancia en X)
        x14  → dy (|y1 - y0|, distancia en Y)

        x15  → sx (direccion en X: +1 si avanza, -1 si retrocede)
        x16  → auxiliar 
        x17  → sy (direccion en Y: +1 si sube, -1 si baja)

        x18  → auxiliar
        x19  → err (error acumulado, CRITERIO!)

        x21  → Color del pixel
    */

    // Backup de registros alterados
    sub sp, sp, #136 //Se guardan cada 8, pero siempre debe quedar un multiplo de 16!
    stur x2,   [sp, #0]
    stur x3,   [sp, #8]
    stur x4,   [sp, #16]
    stur x5,   [sp, #24]
    stur x6,   [sp, #32]
    stur x9,   [sp, #40]
    stur x10,  [sp, #48]
    stur x11,  [sp, #56]
    stur x12,  [sp, #64]
    stur x13,  [sp, #72]
    stur x14,  [sp, #80]
    stur x15,  [sp, #88]
    stur x16,  [sp, #96]
    stur x17,  [sp, #104]
    stur x18,  [sp, #112]
    stur x19,  [sp, #120]
    stur x30,  [sp, #128]

        // dx = abs(x1 - x0)
        subs x13, x11, x9
        bge abs_dx_done
        neg x13, x13
    abs_dx_done:

        // dy = abs(y1 - y0)
        subs x14, x12, x10
        bge abs_dy_done
        neg x14, x14
    abs_dy_done:

        // sx = (x0 < x1) ? 1 : -1
        cmp x9, x11
        mov x15, 1
        mov x16, -1
        blt set_sx
        mov x15, x16
    set_sx:

        // sy = (y0 < y1) ? 1 : -1
        cmp x10, x12
        mov x17, 1
        mov x16, -1
        blt set_sy
        mov x17, x16
    set_sy:

        // err = dx - dy
        sub x19, x13, x14

    bresenham_loop:
        // Direccion: (y0 * width + x0) * 4 + base
        mov x16, x9
        mov x18, x10
        mov x2, #640
        mul x3, x18, x2
        add x3, x3, x16
        lsl x3, x3, #2
        add x4, x20, x3
        stur w21, [x4]

        // ¿Fin?
        cmp x9, x11
        bne check_y
        cmp x10, x12
        beq bresenham_restore
    check_y:

        lsl x5, x19, #1       //2*err
        neg x6, x14
        cmp x5, x6
        ble skip_x
        add x9, x9, x15
        sub x19, x19, x14
    skip_x:

        cmp x5, x13
        bge skip_y
        add x10, x10, x17
        add x19, x19, x13
    skip_y:

        b bresenham_loop

    bresenham_restore:
        // Restaurar registros
        ldur x2,   [sp, #0]
        ldur x3,   [sp, #8]
        ldur x4,   [sp, #16]
        ldur x5,   [sp, #24]
        ldur x6,   [sp, #32]
        ldur x9,   [sp, #40]
        ldur x10,  [sp, #48]
        ldur x11,  [sp, #56]
        ldur x12,  [sp, #64]
        ldur x13,  [sp, #72]
        ldur x14,  [sp, #80]
        ldur x15,  [sp, #88]
        ldur x16,  [sp, #96]
        ldur x17,  [sp, #104]
        ldur x18,  [sp, #112]
        ldur x19,  [sp, #120]
        ldur x30,  [sp, #128]
        add sp, sp, #136

    bresenham_end:
        ret



bresenham_con_punto_fijo:
    
    /* Registros utilizados:

        x3   → Direccion relativa del píxel a pintar (offset)
        x4   → Direccion absoluta del píxel en memoria (base + offset)
        x5   → 2*err (doble del error actual, usado para criterio de selec)
        x6   → -dy (negativo del delta en Y, para comparaciones)
        
        x9   → x0 (posicion actual en X)
        x10  → y0 (posicion actual en Y)
        x11  → x1 (posicion final en X)
        x12  → y1 (posicion final en Y)

        x13  → dx (|x1 - x0|, distancia en X)
        x14  → dy (|y1 - y0|, distancia en Y)

        x15  → sx (direccion en X: +1 si avanza, -1 si retrocede)
        x16  → auxiliar 
        x17  → sy (direccion en Y: +1 si sube, -1 si baja)

        x18  → auxiliar
        x19  → err (error acumulado, CRITERIO!)

        x21  → Color del pixel
        
        x22 -> Cordenada x a la que se ira todo el tiempo
        x23 -> Cordenada y a la que se ira todo el tiempo
    */

    // Backup de registros alterados
    sub sp, sp, #152 //Se guardan cada 8 y se agrega 8 de mas!
    stur x2,   [sp, #0]
    stur x3,   [sp, #8]
    stur x4,   [sp, #16]
    stur x5,   [sp, #24]
    stur x6,   [sp, #32]
    stur x9,   [sp, #40]
    stur x10,  [sp, #48]
    stur x11,  [sp, #56]
    stur x12,  [sp, #64]
    stur x13,  [sp, #72]
    stur x14,  [sp, #80]
    stur x15,  [sp, #88]
    stur x16,  [sp, #96]
    stur x17,  [sp, #104]
    stur x18,  [sp, #112]
    stur x19,  [sp, #120]
    stur x22,  [sp, #128]
    stur x23,  [sp, #136]
    stur x30,  [sp, #144]

        // dx = abs(x1 - x0)
        subs x13, x11, x9
        bge abs_dx_done_bspj
        neg x13, x13
    abs_dx_done_bspj:

        // dy = abs(y1 - y0)
        subs x14, x12, x10
        bge abs_dy_done_bspj
        neg x14, x14
    abs_dy_done_bspj:

        // sx = (x0 < x1) ? 1 : -1
        cmp x9, x11
        mov x15, 1
        mov x16, -1
        blt set_sx_bspj
        mov x15, x16
    set_sx_bspj:

        // sy = (y0 < y1) ? 1 : -1
        cmp x10, x12
        mov x17, 1
        mov x16, -1
        blt set_sy_bspj
        mov x17, x16
    set_sy_bspj:

        // err = dx - dy
        sub x19, x13, x14

    bresenham_loop_bspj:
        // Direccion: (y0 * width + x0) * 4 + base
        mov x16, x9
        mov x18, x10
        mov x2, #640
        mul x3, x18, x2
        add x3, x3, x16
        lsl x3, x3, #2
        add x4, x20, x3
        stur w21, [x4]

        // -----------TRAZADO----------------------------
        //Guardar registros actuales
        // Guardar coordenadas actuales
        //x16 y x18 eran auxiliares
        mov x16, x9
        mov x18, x10

        // Preparar coordenadas para llamada a bresenham
        mov x9, x16
        mov x10, x18
        mov x11, x22
        mov x12, x23

        bl bresenham

        // Restaurar coordenadas originales para el loop
        mov x9, x16
        mov x10, x18
        //mov x11,x22
        ldur x11,[sp,#56]
        ldur x12,[sp,#64]
        //----------------------------------------------

        // ¿Fin?
        cmp x9, x11
        bne check_y_bspj
        cmp x10, x12
        beq bresenham_restore_bspj
    check_y_bspj:

        lsl x5, x19, #1       //2*err
        neg x6, x14
        cmp x5, x6
        ble skip_x_bspj
        add x9, x9, x15
        sub x19, x19, x14
    skip_x_bspj:

        cmp x5, x13
        bge skip_y_bspj
        add x10, x10, x17
        add x19, x19, x13
    skip_y_bspj:

        b bresenham_loop_bspj

    bresenham_restore_bspj:
        // Restaurar registros
        ldur x2,   [sp, #0]
        ldur x3,   [sp, #8]
        ldur x4,   [sp, #16]
        ldur x5,   [sp, #24]
        ldur x6,   [sp, #32]
        ldur x9,   [sp, #40]
        ldur x10,  [sp, #48]
        ldur x11,  [sp, #56]
        ldur x12,  [sp, #64]
        ldur x13,  [sp, #72]
        ldur x14,  [sp, #80]
        ldur x15,  [sp, #88]
        ldur x16,  [sp, #96]
        ldur x17,  [sp, #104]
        ldur x18,  [sp, #112]
        ldur x19,  [sp, #120]
        ldur x22,  [sp, #128]
        ldur x23,  [sp, #136]
        ldur x30,  [sp, #144]
        
        add sp, sp, #152

    bresenham_end_bspj:
    ret



InfLoop:
	b InfLoop

