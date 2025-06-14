.equ SCREEN_WIDTH, 		640
	.equ SCREEN_HEIGH, 		480
	.equ BITS_PER_PIXEL,  	32

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

/*ANTES DE LLAMAR A RECTANGULO ES NECESARIO ASIGNAR VALORES A
 X3 (X INICIAL),X4(X FINAL),X5(Y INICIAL),X6(Y FINAL) Y X11(COLOR!!*/
rectangulo:

        sub sp,sp,#72
        stur x3,[sp,#0]  
        stur x4,[sp,#8]
        stur x5,[sp,#16] 
        stur x6,[sp,#24]
        stur x7,[sp,#32]
        stur x8,[sp,#40]
        stur x9,[sp,#48]
        stur x11,[sp,#56]
        stur x30,[sp,#64] 
    
         
        mov x9, x5      // Guarda el valor inicial de x5
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

    ldur x3,[sp,#0]  
    ldur x4,[sp,#8]
    ldur x5,[sp,#16] 
    ldur x6,[sp,#24]
    ldur x7,[sp,#32]
    ldur x8,[sp,#40]
    ldur x9,[sp,#48]
    ldur x11,[sp,#56]
    ldur x30,[sp,#64]
    add sp,sp,#72
ret

/*ANTES DE LLAMAR A RECTANGULO_FONDO  ES NECESARIO ASIGNAR VALORES A 
X3 (X INICIAL),X4(X FINAL),X5(Y INICIAL),X6(Y FINAL) Y X11(COLOR)!!*/
rectangulos_fondo:
    sub sp,sp,#32
    stur x5,[sp,#0] 
    stur x6,[sp,#8]
    stur x11,[sp,#16]
    stur x30,[sp,#24] 

    add x3, x3, 4
    add x4, x4, 4
    mov x5, 162
	mov x6, 476
    bl rectangulo
fin_cuadrado_fondo:

    ldur x5,[sp,#0] 
    ldur x6,[sp,#8]
    ldur x11,[sp,#16]
    ldur x30,[sp,#24]
    add sp,sp,#32

ret


//CIRCULO
//ANTES DE LLAMAR CIRCULO ASIGNAR VALORES A xc=X3, yc=X4, radio=X15 y x11 color.
circulo:
    sub sp,sp,#120
    stur x3,[sp,#0]  
    stur x4,[sp,#8]
    stur x5,[sp,#16] 
    stur x6,[sp,#24]
    stur x7,[sp,#32]
    stur x8,[sp,#40]
    stur x18,[sp,#48]
    stur x19,[sp,#56]
    stur x20,[sp,#64]
    stur x21,[sp,#72]
    stur x22,[sp,#80]
    stur x23,[sp,#88]
    stur x15,[sp,#96]
    stur x16,[sp,#104]
    stur x17,[sp,#112]
    sub x21, x4, x15 //y=yc-radio (seria indicar el comienzo del circulo verticalmente)
    mov x5, x21

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
    ldur x3,[sp,#0]  
    ldur x4,[sp,#8]
    ldur x5,[sp,#16] 
    ldur x6,[sp,#24]
    ldur x7,[sp,#32]
    ldur x8,[sp,#40]
    ldur x18,[sp,#48]
    ldur x19,[sp,#56]
    ldur x20,[sp,#64]
    ldur x21,[sp,#72]
    ldur x22,[sp,#80]
    ldur x23,[sp,#88]
    ldur x15,[sp,#96]
    ldur x16,[sp,#104]
    ldur x17,[sp,#112]
    add sp,sp,#120 
ret 

//CUADRILATERO
//ANTES DE LLAMAR ASIGNAR LO QUE DICE EN CADA CONJUNTO DE INSTRUCCIONES
cuadradoR:
    /*Los registros usados son:
        x9,x10 → x1,y1
        x11,x12 → x2,y2
        x13,x14 → x3,y3
        x15,x16 → x4,y4
        x22 → punto de partida del flood X
        x23 → punto de partida del flood Y */
    sub sp, sp, #96
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
    //Primero trazo rectas
    bl bresenham
    //segundo lado
    mov x9,x11
    mov x10,x12
    mov x11,x13
    mov x12,x14
    bl bresenham
    //tercer lado
    mov x9,x13
    mov x10,x14
    mov x11,x15
    mov x12,x16
    bl bresenham
    //cuarto lado
    mov x9,x15
    mov x10,x16
    ldur x11, [sp, #0]
    ldur x12, [sp, #8]
    bl bresenham
    //Ahora se rellena, recordar poner a x22,x23 dentro del cuadrado
    bl flood_fill
    add x22,x22,#1
    bl flood_fill_der

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
    add sp, sp, #96
    ret

bresenham:
    /* algoritmo de Bresenham 
        ¿Que hace?
            Traza rectas sin calcular la pendiente exacta.
        ¿Como lo hace?
            Es un algoritmo voraz, por lo que su criterio de seleccion para avanzar en x o y es la cantidad de error acumulado (dx-dy)
            (almacenado en x19).
            El acumulador de error mide que tan desviado esta el paso actual de la linea ideal. El algoritmo evalua las siguientes 
            condiciones para decidir en cada iteracion:

                → Si 2*x19 > -dy, lo cual significa que el error está más cerca de la siguiente columna, entonces se mueve en X.
                → Si 2*x19 < dx, lo cual significa que el error está más cerca de la siguiente fila, entonces se mueve en Y.
            
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
        sub x13, xzr, x13
    abs_dx_done:
        // dy = abs(y1 - y0)
        subs x14, x12, x10
        bge abs_dy_done
        sub x14, xzr, x14
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

flood_fill:
    /*
    IDEA: Se da un punto y un color, si el punto no es del color lo pinta y hace recursion hacia los puntos adyacentes. Si el punto es del color termina.
    Es el metodo de pintado de paint (flood fill).
    Los registros usados son:
        x3 := Auxiliar
        x4 := Guarda coordenada actual
        x5 := Guarda color de coordenada actual 
        x21 := color para rellenar  (No lo guardo en pila porque no se altera)
        x22 = punto de partida del flood X
        x23 = punto de partida del flood Y
        x30 = LR */
    sub sp, sp, #48
    stur x3, [sp, #0]
    stur x4,[sp, #8]
    stur x5,[sp, #16]
    stur x22,[sp, #24]
    stur x23,[sp, #32]
    stur x30,[sp, #40]

    // if (x22 < 0 || x22 >= 640 || x23 < 0 || x23 >= 480) return;
    //Esto verifica que no nos salimos de la pantalla
    cmp x22, #0
    blt no_rellenar
    cmp x22, #640
    bge no_rellenar
    cmp x23, #0
    blt no_rellenar
    cmp x23, #480
    bge no_rellenar
    
    // Tengo que implementar un if que compare el color pixel actual con el elegido
    // Direccion: (y0 * width + x0) * 4 + base SE GUARDA EN X4
    mov x3, #640
    mul x3, x23, x3
    add x3, x3, x22
    lsl x3, x3, #2
    add x4, x20, x3
    //Comparacion con color
    ldur w5, [x4]      // Cargo el color actual del pixel en w5
    cmp w5, w21       // Comparo con el color objetivo
    beq no_rellenar    // Si eran del mismo color
    stur w21, [x4]      // Sino se rellena la ubicacion
    
    sub x22,x22,#1 //Izquierda
    bl flood_fill
    add x22,x22,#1

    add x23,x23,#1 //Arriba
    bl flood_fill
    sub x23,x23,#1
    
    sub x23,x23,#1 //Abajo
    bl flood_fill
    add x23,x23,#1 
    
    no_rellenar:
        ldur x3, [sp, #0]
        ldur x4,[sp, #8]
        ldur x5,[sp, #16]
        ldur x22,[sp, #24]
        ldur x23,[sp, #32]
        ldur x30,[sp, #40]
        add sp, sp, #48
    ret

flood_fill_der:

    sub sp, sp, #48
    stur x3, [sp, #0]
    stur x4,[sp, #8]
    stur x5,[sp, #16]
    stur x22,[sp, #24]
    stur x23,[sp, #32]
    stur x30,[sp, #40]

    cmp x22, #0
    blt no_rellenar_der
    cmp x22, #640
    bge no_rellenar_der
    cmp x23, #0
    blt no_rellenar_der
    cmp x23, #480
    bge no_rellenar_der
    
    mov x3, #640
    mul x3, x23, x3
    add x3, x3, x22
    lsl x3, x3, #2
    add x4, x20, x3

    ldur w5, [x4]      
    cmp w5, w21       
    beq no_rellenar_der    
    stur w21, [x4]      
    //Aca estan los cambios, ahora se va para la derecha en vez de la izquierda
    add x22,x22,#1 //Derecha
    bl flood_fill_der
    sub x22,x22,#1

    add x23,x23,#1 //Arriba
    bl flood_fill_der
    sub x23,x23,#1

    sub x23,x23,#1 //Abajo
    bl flood_fill_der
    add x23,x23,#1
    
    no_rellenar_der:
        ldur x3, [sp, #0]
        ldur x4,[sp, #8]
        ldur x5,[sp, #16]
        ldur x22,[sp, #24]
        ldur x23,[sp, #32]
        ldur x30,[sp, #40]
        add sp, sp, #48
ret

//PIXEL
//ANTES DE LLAMAR A PIXEL o PIXEL_VENTANA, DAR VALORES DE X3 , X5 Y X11 (ALTURA TOP, ANCHO MIN, COLOR)
pixel:
    sub sp,sp,#64
    stur x3,[sp,#0]  
    stur x4,[sp,#8]
    stur x5,[sp,#16] 
    stur x6,[sp,#24]
    stur x7,[sp,#32]
    stur x8,[sp,#40]
    stur x9,[sp,#48]
    stur x30,[sp,#56] 

    add x4, x3, 2
    add x6, x5, 2
    mov x9, x5            // Guarda el valor inicial de x5
    pixel_y:
        cmp x3, x4           // mientras y  <= x4
        b.ge fin_pixel 
        
        mov x5, x9
    pixel_x:
        cmp x5, x6        // mientras x <= x6
        b.ge siguiente_filapix

       
    // Calcula la dirección del pixel: x7 = framebuffer + ((y * SCREEN_WIDTH) + x) * 4

	mov x8, SCREEN_WIDTH
    mov x7, x3
    mul x7, x7, x8
    add x7, x7, x5
    lsl x7, x7, 2
    add x7, x20, x7

    stur w11, [x7]       // Escribe el color del cuadrado

    add x5, x5, 1
    b pixel_x

    siguiente_filapix:
        add x3, x3, 1
        b pixel_y

fin_pixel:
    ldur x3,[sp,#0]  
    ldur x4,[sp,#8]
    ldur x5,[sp,#16] 
    ldur x6,[sp,#24]
    ldur x7,[sp,#32]
    ldur x8,[sp,#40]
    ldur x9,[sp,#48]
    ldur x30,[sp,#56] 
    add  sp,sp,#64
ret

//ANTES DE LLAMAR A PIXEL_VENTANA, DAR VALORES DE X3 , X5 Y X11 (ALTURA TOP, ANCHO MIN, COLOR)
pixel_ventana:
    sub sp,sp,#64
    stur x3,[sp,#0]  
    stur x4,[sp,#8]
    stur x5,[sp,#16] 
    stur x6,[sp,#24]
    stur x7,[sp,#32]
    stur x8,[sp,#40]
    stur x9,[sp,#48]
    stur x30,[sp,#56] 

    add x4, x3, 5
    add x6, x5, 5
    mov x9, x5            // Guarda el valor inicial de x5
    pixel_ventana_y:
        cmp x3, x4           // mientras y  <= x4
        b.ge fin_pixel_ventana
        
        mov x5, x9
    pixel_ventana_x:
        cmp x5, x6        // mientras x <= x6
        b.ge siguiente_filapix_ventana

       
    // Calcula la dirección del pixel: x7 = framebuffer + ((y * SCREEN_WIDTH) + x) * 4

	    mov x8, SCREEN_WIDTH
        mov x7, x3
        mul x7, x7, x8
        add x7, x7, x5
        lsl x7, x7, 2
        add x7, x20, x7

        stur w11, [x7]       // Escribe el color del cuadrado

        add x5, x5, 1
        b pixel_ventana_x

    siguiente_filapix_ventana:
        add x3, x3, 1
        b pixel_y

fin_pixel_ventana:
        ldur x3,[sp,#0]  
        ldur x4,[sp,#8]
        ldur x5,[sp,#16] 
        ldur x6,[sp,#24]
        ldur x7,[sp,#32]
        ldur x8,[sp,#40]
        ldur x9,[sp,#48]
        ldur x30,[sp,#56] 
        add  sp,sp,#64

ret

//ANTES DE LLAMAR A BOTON ASIGNAR X3(Y INICIAL), X4(Y FINAL), X5(X INICIAL), X6(X FINAL) Y X11 (COLOR)
//CREA LOS CUADRADOS PARA LOS BOTONES
boton: 
    sub sp,sp,#48
    stur x3,[sp,#0] 
    stur x4,[sp,#8]
    stur x5,[sp,#16] 
    stur x6,[sp,#24]
    stur x11,[sp,#32]
    stur x30,[sp,#40]
    // negro
	movz x11, 0x4040, lsl 00 
	movk x11, 0x40, lsl 16
	bl rectangulo
	//blanco
	add x3, x3, 1
	sub x4, x4, 1
	add x5, x5, 1
	sub x6, x6, 1
	movz x11, 0xFFFF, lsl 00 
	movk x11, 0xFF, lsl 16
	bl rectangulo
	//gris
	add x3, x3, 1
	sub x4, x4, 1
	add x5, x5, 1
	sub x6, x6, 1
	movz x11, 0x909E, lsl 00 
	movk x11, 0x7D, lsl 16
	bl rectangulo 
fin_boton:
    ldur x3,[sp,#0] //- 
    ldur x4,[sp,#8]//-
    ldur x5,[sp,#16] //-
    ldur x6,[sp,#24]//-
    ldur x11,[sp,#32]
    ldur x30,[sp,#40]
    add sp,sp,#48
ret

//ASIGANR LOS VALORES X10(Y0), X12(Y1) Y X21(COLOR)
//CREA TRES LINEAS HORIZONTALES PARA DIBUJAR EL BOTON EXPANDIR
lineas_boton_expandir_h:

    sub sp,sp,#48
    stur x10,[sp,#0] 
    stur x12,[sp,#8]
    stur x21,[sp,#16] 
    stur x30,[sp,#24]

    movz x21, 0x909E, lsl 00 
	movk x21, 0x7D, lsl 16
    bl bresenham

    add x10, x10, 1
    add x12, x12, 1 
    movz x21, 0x909E, lsl 00 
	movk x21, 0x7D, lsl 16
    bl bresenham

    add x10, x10, 1
    add x12, x12, 1 
    movz x21, 0x909E, lsl 00 
	movk x21, 0x7D, lsl 16
    bl bresenham

fin_lineas_boton_expandir_h:
    ldur x10,[sp,#0] //- 
    ldur x12,[sp,#16] //-
    ldur x21,[sp,#8]//-
    ldur x30,[sp,#24]//-
    add sp,sp,#48

ret

//ASIGANR LOS VALORES X9(X0), X11(X1) Y X21(COLOR)
//CREA TRES LINEAS VERTICALES PARA DIBUJAR EL BOTON EXPANDIR
lineas_boton_expandir_v:

    sub sp,sp,#48
    stur x9,[sp,#0] 
    stur x11,[sp,#8]
    stur x21,[sp,#16] 
    stur x30,[sp,#24]

    movz x21, 0x909E, lsl 00 
	movk x21, 0x7D, lsl 16
    bl bresenham

    add x9, x9, 1
    add x11, x11, 1 
    movz x21, 0x909E, lsl 00 
	movk x21, 0x7D, lsl 16
    bl bresenham

    add x9, x9, 1
    add x11, x11, 1 
    movz x21, 0x909E, lsl 00 
	movk x21, 0x7D, lsl 16
    bl bresenham

fin_lineas_boton_expandir_v:
    ldur x9,[sp,#0] //- 
    ldur x11,[sp,#16] //-
    ldur x21,[sp,#8]//-
    ldur x30,[sp,#24]//-
    add sp,sp,#48

ret

odc_2025:

    mov x7, x5 //guardo el primer valor de x
    //1ra linea de pixeles
	add x5, x5, 2 // el primer pixel lo salteo pq es vacio! //102
	bl pixel

	add x5, x5, 2 //104
	bl pixel

	add x5, x5, 6 //110
	bl pixel	 
	
	add x5, x5, 2 //112
	bl pixel
	
	add x5, x5, 2 //114
	bl pixel

	add x5, x5, 8	//122
	bl pixel
	
	add x5, x5, 2	//124
	bl pixel
	
	add x5, x5, 18	//140
	bl pixel
	
	add x5, x5, 2	//142
	bl pixel
	
	add x5, x5, 8	//150
	bl pixel
	
	add x5, x5, 2	//152
	bl pixel
	
	add x5, x5, 8	//158
	bl pixel
	
	add x5, x5, 2	//160
	bl pixel
	
	add x5, x5, 6	//166
	bl pixel
	
	add x5, x5, 2	//168
	bl pixel
	
	add x5, x5, 2	//170
	bl pixel

    add x5, x5, 2
    bl pixel
	
    //segunda_linea_de_pixeles:	
    mov x5, x7
	add x3, x3, 2

    bl pixel

    add x5, x5, 6
    bl pixel

    add x5, x5, 4
    bl pixel

    add x5, x5, 6
    bl pixel

    add x5, x5, 4
    bl pixel

    add x5, x5, 6
    bl pixel

    add x5, x5, 14
    bl pixel

    add x5, x5, 6
    bl pixel

    add x5, x5, 4
    bl pixel

    add x5, x5, 6
    bl pixel

    add x5, x5, 4
    bl pixel

    add x5, x5, 6
    bl pixel

    add x5, x5, 4
    bl pixel

    //3ra linea de pixeles :D
    mov x5, x7
    add x3, x3, 2

    bl pixel

    add x5, x5, 6
    bl pixel
    
    add x5, x5, 4
    bl pixel

    add x5, x5, 6
    bl pixel

    add x5, x5, 4
    bl pixel

    add x5, x5, 24
    bl pixel

    add x5, x5, 6
    bl pixel

    add x5, x5, 6
    bl pixel

    add x5, x5, 8
    bl pixel

    add x5, x5, 6
    bl pixel

    add x5, x5, 2
    bl pixel

    add x5, x5, 2
    bl pixel

    //4ta linea de pixeles :D
    mov x5, x7
    add x3, x3, 2
    
    bl pixel

    add x5, x5, 6
    bl pixel
    
    add x5, x5, 4
    bl pixel

    add x5, x5, 6
    bl pixel

    add x5, x5, 4
    bl pixel

    add x5, x5, 6
    bl pixel

    add x5, x5, 16
    bl pixel

    add x5, x5, 8
    bl pixel

    add x5, x5, 6
    bl pixel

    add x5, x5, 6
    bl pixel

    add x5, x5, 14
    bl pixel

    //5ta linea de pixeles :D
    mov x5, x7
    add x3, x3, 2

    add x5, x5, 2 
	bl pixel

	add x5, x5, 2 
	bl pixel

	add x5, x5, 6 
	bl pixel	 
	
	add x5, x5, 2 
	bl pixel
	
	add x5, x5, 2 
	bl pixel

	add x5, x5, 8
	bl pixel
	
	add x5, x5, 2
	bl pixel

    add x5, x5, 6
	bl pixel

    add x5, x5, 2
	bl pixel
    
    add x5, x5, 2
	bl pixel

    add x5, x5, 2
	bl pixel

    add x5, x5, 4
	bl pixel

    add x5, x5, 2
	bl pixel
    
    add x5, x5, 2
	bl pixel

    add x5, x5, 2
	bl pixel

    add x5, x5, 6
	bl pixel

    add x5, x5, 2
	bl pixel

    add x5, x5, 6
	bl pixel

    add x5, x5, 2
	bl pixel

    add x5, x5, 2
	bl pixel

    add x5, x5, 2
	bl pixel

    add x5, x5, 4
	bl pixel

    add x5, x5, 2
	bl pixel

    add x5, x5, 2
	bl pixel


fin_odc_2025:
ret

InfLoop:
	b InfLoop

