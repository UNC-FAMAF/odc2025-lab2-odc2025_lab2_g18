    .equ SCREEN_WIDTH, 		640
	.equ SCREEN_HEIGH, 		480
	.equ BITS_PER_PIXEL,  	32

	.equ GPIO_BASE,      0x3f200000
	.equ GPIO_GPFSEL0,   0x00
	.equ GPIO_GPLEV0,    0x34
    .equ tiempo, 0xFFFFFFF


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
    .global delay
    .global estrella
    .global elipses_fondo
    .global trapecio
    .global planta

    //main:

 	mov x20, x0	

    //ANTES DE LLAMAR A PANTALLA ES NECESARIO ASIGNAR VALOR A X11!!
pantalla:
        sub sp,sp,#40
        stur x0,[sp,#0] 
        stur x1,[sp,#8] 
        stur x2,[sp,#16]
        stur x11,[sp,#24]
        stur x30,[sp,#32]

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
        
        ldur x0,[sp,#0] 
        ldur x1,[sp,#8] 
        ldur x2,[sp,#16]
        ldur x11,[sp,#24]
        ldur x30,[sp,#32]
        add sp,sp,#40
ret


trapecio:
  sub sp, sp, #80
  stur x0, [sp, #0]
  stur x1, [sp, #8]
  stur x2, [sp, #16]
  stur x7, [sp, #24]
  stur x8, [sp, #32]
  stur x9, [sp, #40]
  stur x10, [sp, #48]
  stur x11, [sp, #56]
  stur x12, [sp, #64]
  stur x30, [sp, #72]

  // Parámetros:
  // x12 = ancho superior (debe ser <= ancho inferior)
  // x3 = x_inicial_inferior (esquina inferior izquierda)
  // x4 = x_final_inferior (esquina inferior derecha)
  // x5 = y_inicial (base inferior)
  // x6 = y_final (base superior)
  // x11 = color



  // Extraer componente alpha (0-255)
  and x8, x11, #0xFF000000     // Aislar byte alpha
  lsr x8, x8, #24              // x8 = alpha (0-255)

  cmp x8, #255
  b.eq trapecio_opaco

  // Preparar componentes del nuevo color
  and x0, x11, #0x00FF0000     // Componente R
  lsr x0, x0, #16
  and x1, x11, #0x0000FF00      // Componente G
  lsr x1, x1, #8
  and x2, x11, #0x000000FF      // Componente B

  // Invertir alpha para mezcla (255 - alpha)
  mov x9, #255
  sub x9, x9, x8                // x9 = 255 - alpha

  mov x7, x5                    // y = y_inicial (base inferior)
  sub x11, x6, x5               // Altura del trapecio
  sub x10, x4, x3               // Ancho inferior
  sub x12, x12, x10             // Diferencia de anchos (superior - inferior)
  sub x12, x12, x10
  sub x12, x12, x10
    trapecio_loop_y:
      cmp x7, x6                    // while y <= y_final (base superior)
      b.gt trapecio_end

      // Calcular los límites x para esta fila y
      // x_inicial = x3 + (y - y_inicial) * (ancho_superior - ancho_inferior) / (2 * altura)
      // x_final = x4 - (y - y_inicial) * (ancho_superior - ancho_inferior) / (2 * altura)
       sub x13, x7, x5               // y - y_inicial
      mul x14, x13, x12             // * diferencia de anchos
      asr x14, x14, #1              // / 2 (división por 2 con signo)
      sdiv x14, x14, x11            // / altura
       add x15, x3, x14              // x_inicial para esta fila
      sub x16, x4, x14              // x_final para esta fila

      mov x10, x15                  // x = x_inicial
    trapecio_loop_x:
      cmp x10, x16                  // while x <= x_final
      b.gt trapecio_next_y

      // Calcular posición del pixel
      mov x30, SCREEN_WIDTH
      mul x30, x7, x30              // y * SCREEN_WIDTH
      add x30, x30, x10             // + x
      lsl x30, x30, #2              // * 4 (bytes per pixel)
      add x30, x20, x30             // Dirección de memoria

      // Cargar color actual (background)
      ldur w17, [x30]

      // Extraer componentes del color actual
      and x13, x17, #0x00FF0000     // R
      lsr x13, x13, #16
      and x14, x17, #0x0000FF00      // G
      lsr x14, x14, #8
      and x15, x17, #0x000000FF      // B

      // Mezclar componentes R
      mul x13, x13, x9               // R_background * (255-alpha)
      mul x18, x0, x8                // R_new * alpha
      add x13, x13, x18
      lsr x13, x13, #8               // Dividir por 256

      // Mezclar componentes G
      mul x14, x14, x9               // G_background * (255-alpha)
      mul x18, x1, x8                // G_new * alpha
      add x14, x14, x18
      lsr x14, x14, #8               // Dividir por 256

      // Mezclar componentes B
      mul x15, x15, x9               // B_background * (255-alpha)
      mul x18, x2, x8                // B_new * alpha
      add x15, x15, x18
      lsr x15, x15, #8               // Dividir por 256

      // Reconstruir color mezclado
      lsl x13, x13, #16              // Posición R
      lsl x14, x14, #8               // Posición G
      orr x17, x13, x14              // Combinar R y G
      orr x17, x17, x15              // Combinar con B
      orr x17, x17, #0xFF000000      // Alpha siempre opaco después de mezclar

      // Almacenar pixel mezclado
      stur w17, [x30]

      add x10, x10, #1               // x++
      b trapecio_loop_x

    trapecio_next_y:
      add x7, x7, #1                 // y++
      b trapecio_loop_y

    trapecio_opaco:
      mov x7, x5                     // y = y_inicial
      sub x11, x6, x5                // Altura del trapecio
      sub x10, x4, x3                // Ancho inferior
      sub x12, x12, x10              // Diferencia de anchos

    trapecio_opaco_loop_y:
      cmp x7, x6                     // while y <= y_final
      b.gt trapecio_end

      // Calcular los límites x para esta fila y
      sub x13, x7, x5                // y - y_inicial
      mul x14, x13, x12              // * diferencia de anchos
      asr x14, x14, #1               // / 2
      sdiv x14, x14, x11             // / altura
       add x15, x3, x14               // x_inicial para esta fila
      sub x16, x4, x14               // x_final para esta fila

      mov x10, x15                   // x = x_inicial
    trapecio_opaco_loop_x:
      cmp x10, x16                   // while x <= x_final
      b.gt trapecio_opaco_next_y

      // Calcular posición del pixel
      mov x30, SCREEN_WIDTH
      mul x30, x7, x30               // y * SCREEN_WIDTH
      add x30, x30, x10              // + x
      lsl x30, x30, #2               // * 4
      add x30, x20, x30              // Dirección de memoria

      // Almacenar color directamente (sin mezcla)
      stur w11, [x30]

      add x10, x10, #1               // x++
      b trapecio_opaco_loop_x

    trapecio_opaco_next_y:
      add x7, x7, #1                 // y++
      b trapecio_opaco_loop_y

trapecio_end:
  // Restaurar registros
  ldur x0, [sp, #0]
  ldur x1, [sp, #8]
  ldur x2, [sp, #16]
  ldur x7, [sp, #24]
  ldur x8, [sp, #32]
  ldur x9, [sp, #40]
  ldur x10, [sp, #48]
  ldur x11, [sp, #56]
  ldur x12, [sp, #64]
  ldur x30, [sp, #72]
  add sp, sp, #80
  ret

/*ANTES DE LLAMAR A RECTANGULO ES NECESARIO ASIGNAR VALORES A
 X3 (Y INICIAL),X4(Y FINAL),X5(X INICIAL),X6(X FINAL) Y X11(COLOR!!*/
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


/*ANTES DE LLAMAR A ELIPSE_FONDO  ES NECESARIO ASIGNAR VALORES A 
X3 (YC),X4(YC),X5(SEMI EJE H),X6(SEMI EJE V) Y X11(COLOR)!!*/

elipses_fondo:
    sub sp,sp,#40
    stur x4,[sp,#0]
    stur x5,[sp,#8]
    stur x6,[sp,#16]
    stur x11,[sp,#24]
    stur x30,[sp,#32] 

    add x3, x3, 50
    mov x4, 320
    mov x5, 480
	mov x6, 50
    bl elipse

fin_elipse_fondo:

    ldur x4,[sp,#0]
    ldur x5,[sp,#8]
    ldur x6,[sp,#16]
    ldur x11,[sp,#24]
    ldur x30,[sp,#32]
    add sp,sp,#40

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

//LLAMAR A ELIPSE CON X3(YC), X4(XC), X5(SEMIEJE H A), X6(SEMIEJE V B) Y COLOR EN X11
elipse:
        sub sp,sp,#184
        stur x3,[sp,#0]  
        stur x4,[sp,#8]
        stur x5,[sp,#16] 
        stur x6,[sp,#24]
        stur x7,[sp,#32]
        stur x8,[sp,#40]
        stur x9,[sp,#48]
        stur x10,[sp,#56]
        stur x11,[sp,#64]
        stur x12,[sp,#72]
        stur x13,[sp,#80]
        stur x14,[sp,#88]
        stur x15,[sp,#96]
        stur x16,[sp,#104]
        stur x17,[sp,#112]
        stur x18,[sp,#120]
        stur x19,[sp,#128]
        stur x20,[sp,#136]
        stur x21,[sp,#144]
        stur x22,[sp,#152]
        stur x23,[sp,#160]
        stur x24,[sp,#168]
        stur x30,[sp,#176] 

    sub x9, x3, x6 //y=yc-b (seria indicar el comienzo del elipse verticalmente)
	mov x10, x9
    elipse_y:

	add x24, x3, x6 //y=yc+b (seria indicar el final del elipse verticalmente)
    cmp x10, x24   //mientras x5<=x23 (filas)
    b.ge fin_elipse

	sub x12, x4, x5 //x=xc-a (seria indicar el comienzo del elipse horizontalmente)
    mov x13, x12
    elipse_x:
	add x14, x4, x5 //x=xc+a (seria indicar el final del elipse horizontalmente)
    cmp x13, x14 // mientras x6<=x24 (columnas)
    b.ge siguiente_fila_elipse

	cmp x10, #0
    b.lt no_pintar_pixel_elipse
    cmp x13, #0
    b.lt no_pintar_pixel_elipse

	// Calcular (x - xc)^2/a^2 + (y - yc)^2/b^2 -- describe el interior y borde del elipse
	sub x15, x13, x4
    mul x15, x15, x15      // (x - xc)^2

    sub x16, x10, x3
    mul x16, x16, x16      // (y - yc)^2

	mul x19, x6, x6      // b^2
	mul x18, x15, x19      // (x - xc)^2/b^2

	mul x17, x5, x5      // a^2
	mul x21, x16, x17      // (y - yc)^2/a^2

	add x22, x18, x21      // suma (x - xc)^2/b^2 + (y - yc)^2/a^2

	mul x23,x17,x19      // a^2*b^2

	cmp x22, x23 //mientras el punto este dentro del elipse (x^2/a^2 + y^2/b^2 <= 1)
    b.gt no_pintar_pixel_elipse

 // dirección de pixel
    mov x7, SCREEN_WIDTH
	mov x8, x7
    mul x8, x8, x10
    add x8, x8, x13
    lsl x8, x8, 2
    add x8, x20, x8

    stur w11, [x8] 

    no_pintar_pixel_elipse:
    add x13, x13, 1 //paso a la siguiente columna
    b elipse_x

    siguiente_fila_elipse:
    add x10, x10, 1
    b elipse_y

fin_elipse:
        
        ldur x3,[sp,#0]  
        ldur x4,[sp,#8]
        ldur x5,[sp,#16] 
        ldur x6,[sp,#24]
        ldur x7,[sp,#32]
        ldur x8,[sp,#40]
        ldur x9,[sp,#48]
        ldur x10,[sp,#56]
        ldur x11,[sp,#64]
        ldur x12,[sp,#72]
        ldur x13,[sp,#80]
        ldur x14,[sp,#88]
        ldur x15,[sp,#96]
        ldur x16,[sp,#104]
        ldur x17,[sp,#112]
        ldur x18,[sp,#120]
        ldur x19,[sp,#128]
        ldur x20,[sp,#136]
        ldur x21,[sp,#144]
        ldur x22,[sp,#152]
        ldur x23,[sp,#160]
        ldur x24,[sp,#168]
        stur x30,[sp,#176]
        add sp,sp,#184
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

//PIXEL
//ANTES DE LLAMAR A PIXEL o PIXEL_VENTANA, DAR VALORES DE X3 , X5 Y X11 (ALTURA TOP, ANCHO MIN, COLOR)
pixelde1:
        sub sp,sp,#64
        stur x3,[sp,#0]  
        stur x4,[sp,#8]
        stur x5,[sp,#16] 
        stur x6,[sp,#24]
        stur x7,[sp,#32]
        stur x8,[sp,#40]
        stur x9,[sp,#48]
        stur x30,[sp,#56] 

        add x4, x3, 1
        add x6, x5, 1

        mov x9, x5            // Guarda el valor inicial de x5
    pixel_y1:
        cmp x3, x4           // mientras y  <= x4
        b.ge fin_pixel1 
        
        mov x5, x9
    pixel_x1:
        cmp x5, x6        // mientras x <= x6
        b.ge siguiente_filapix1

       
    // Calcula la dirección del pixel: x7 = framebuffer + ((y * SCREEN_WIDTH) + x) * 4

	mov x8, SCREEN_WIDTH
        mov x7, x3
        mul x7, x7, x8
        add x7, x7, x5
        lsl x7, x7, 2
        add x7, x20, x7

     stur w11, [x7]       // Escribe el color del cuadrado

        add x5, x5, 1
        b pixel_x1

    siguiente_filapix1:
        add x3, x3, 1
        b pixel_y1

    fin_pixel1:
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

FIN:
odc_2025:

        sub sp,sp,#32
        stur x3,[sp,#0]  
        stur x5,[sp,#8]
        stur x7,[sp,#16] 
        stur x30,[sp,#24] 

    mov x7, x5 //guardo el primer valor de x
    //1ra linea de pixeles
	add x5, x5, 1 // el primer pixel lo salteo pq es vacio! //102
	bl pixelde1
	add x5, x5, 1
	bl pixelde1
	add x5, x5, 5 
	bl pixelde1	 
	add x5, x5, 10
	bl pixelde1
	add x5, x5, 1 
	bl pixelde1
	add x5, x5, 1	
	bl pixelde1
	add x5, x5, 4	
	bl pixelde1
	add x5, x5, 1	
	bl pixelde1
	add x5, x5, 3	
	bl pixelde1
	add x5, x5, 1	
	bl pixelde1
	add x5, x5, 1
	bl pixelde1
	add x5, x5, 4	
	bl pixelde1
	add x5, x5, 1	
	bl pixelde1
	add x5, x5, 1	
	bl pixelde1
	add x5, x5, 1
	bl pixelde1
	
    //segunda_linea_de_pixeles:	
    mov x5, x7
	add x3, x3, 1
    bl pixelde1
    add x5, x5, 3
    bl pixelde1
    add x5, x5, 4
    bl pixelde1
    add x5, x5, 13
    bl pixelde1
    add x5, x5, 2
    bl pixelde1
    add x5, x5, 3
    bl pixelde1
    add x5, x5, 5
    bl pixelde1
    add x5, x5, 3
    bl pixelde1
    //3ra linea de pixeles :D
    mov x5, x7
    add x3, x3, 1
    bl pixelde1
    add x5, x5, 3
    bl pixelde1
    add x5, x5, 4
    bl pixelde1
    add x5, x5, 3
    bl pixelde1
    add x5, x5, 1
    bl pixelde1
    add x5, x5, 9
    bl pixelde1
    add x5, x5, 2
    bl pixelde1
    add x5, x5, 3
    bl pixelde1
    add x5, x5, 5
    bl pixelde1
    add x5, x5, 3
    bl pixelde1
    add x5, x5, 1
    bl pixelde1
    add x5, x5, 1
    bl pixelde1
    //4ta linea de pixeles :D
    mov x5, x7
    add x3, x3, 1 
    bl pixelde1
    add x5, x5, 3
    bl pixelde1
    add x5, x5, 3
    bl pixelde1
    add x5, x5, 1
    bl pixelde1
    add x5, x5, 2
    bl pixelde1
    add x5, x5, 10
    bl pixelde1
    add x5, x5, 3
    bl pixelde1
    add x5, x5, 3
    bl pixelde1
    add x5, x5, 4
    bl pixelde1
    add x5, x5, 7
    bl pixelde1
    //5ta linea de pixeles :D
    mov x5, x7
    add x3, x3, 1
	bl pixelde1
	add x5, x5, 3
	bl pixelde1
	add x5, x5, 2 
	bl pixelde1 
	add x5, x5, 2 
	bl pixelde1
	add x5, x5, 2 
	bl pixelde1
	add x5, x5, 9
	bl pixelde1
	add x5, x5, 4
	bl pixelde1
    add x5, x5, 3
	bl pixelde1
    add x5, x5, 3
	bl pixelde1
    add x5, x5, 8
	bl pixelde1
    //6ta linea
    mov x5,x7
    add x3, x3, 1
    add x5, x5, 1
    bl pixelde1
    add x5, x5, 1
	bl pixelde1
	add x5, x5, 4
	bl pixelde1 
	add x5, x5, 1
	bl pixelde1
	add x5, x5, 3
	bl pixelde1
	add x5, x5, 1
	bl pixelde1
	add x5, x5, 3
	bl pixelde1
    add x5, x5, 1
	bl pixelde1
    add x5, x5, 2
	bl pixelde1
    add x5, x5, 1
	bl pixelde1
    add x5, x5, 1
	bl pixelde1
    add x5, x5, 1
	bl pixelde1
    add x5, x5, 3
	bl pixelde1
    add x5, x5, 1
	bl pixelde1
    add x5, x5, 3
	bl pixelde1
    add x5, x5, 1
	bl pixelde1
    add x5, x5, 1
	bl pixelde1
    add x5, x5, 1
	bl pixelde1
    add x5, x5, 3
	bl pixelde1
    add x5, x5, 1
    bl pixelde1
    add x5, x5, 1
    bl pixelde1
    fin_odc_2025:

        ldur x3,[sp,#0]  
        ldur x5,[sp,#8]
        ldur x7,[sp,#16] 
        ldur x30,[sp,#24] 
        add sp,sp,#32
ret
//antes de llamar estrella necesita las coordenadas de altura y desplazamiento-4 :D
estrella:
    sub sp,sp,#48
    stur x3,[sp,#0]
    stur x5,[sp,#8]
    stur x7,[sp,#16]
    stur x11,[sp,#24]
    stur x30,[sp,#32]


    mov x7, x5 //guardo el primer valor de x
                    //1ra linea de pixeles
	add x5, x5, 4 // los primeros dos pixeles no los uso
   
    movz x11, 0xFD, lsl 16
    movk x11, 0xD92B, lsl 0
                   
	bl pixel


    //segunda_linea_de_pixeles:	
    mov x5, x7
	add x3, x3, 2

    add x5, x5, 2
    bl pixel

    movz x11, 0xFF, lsl 16
    movk x11, 0xFFFF, lsl 0
    add x5, x5, 2
    bl pixel

    movz x11, 0xFD, lsl 16
    movk x11, 0xD92B, lsl 0
    add x5, x5, 2
    bl pixel


    //3ra linea de pixeles :D
    mov x5, x7
    add x3, x3, 2

    bl pixel

    movz x11, 0xFF, lsl 16
    movk x11, 0xFFFF, lsl 0
    add x5, x5, 2
    bl pixel
    
    add x5, x5, 2
    bl pixel

    add x5, x5, 2
    bl pixel

    movz x11, 0xFD, lsl 16
    movk x11, 0xD92B, lsl 0
    add x5, x5, 2
    bl pixel

    //4ta linea de pixeles :D
    mov x5, x7
    add x3, x3, 2

    add x5, x5, 2
    bl pixel

    add x5, x5, 2
    movz x11, 0xFF, lsl 16
    movk x11, 0xFFFF, lsl 0
    bl pixel

    movz x11, 0xFD, lsl 16
    movk x11, 0xD92B, lsl 0
    add x5, x5, 2
    bl pixel


    //5ta linea de pixeles :D

    mov x5, x7
    add x3, x3, 2

    add x5, x5, 4
	bl pixel

fin_estrella:
    ldur x3,[sp,#0] 
    ldur x5,[sp,#8]
    ldur x7,[sp,#16] 
    ldur x11,[sp,#24]
    ldur x30,[sp,#32]
    add sp,sp,#48
ret

planta:
    sub sp,sp,#48
    stur x3,[sp,#0]
    stur x4,[sp,#8]
    stur x5,[sp,#16]
    stur x6,[sp,#24]
    stur x11,[sp,#32]
    stur x30,[sp,#40]
    movz x11, 0x42,lsl 16
    movk x11, 0x4242, lsl 0

// --- Tallo principal (elipse vertical) ---
bl elipse

// --- Hojas (elipses) ---
// Hoja abajo
add x3, x3, 15      // Y-centro 365
add x5, X5, 9            // Semieje a 12
sub x6, x6, 11            // Semieje b 4
bl elipse

// Hoja media
sub x3, x3, 9     // Y-centro
sub x5, x5, 3    // Semieje a
bl elipse

//Hoja alta
sub x3, x3, 9      // Y-centro
sub x5, x5, 3           // Semieje a
bl elipse

end_planta:
    ldur x3,[sp,#0]
    ldur x4,[sp,#8]
    ldur x5,[sp,#16]
    ldur x6,[sp,#24]
    ldur x11,[sp,#32]
    ldur x30,[sp,#40]
    add sp,sp,#48

ret

InfLoop:
	b InfLoop

delay: 
        sub sp,sp,#16
        stur x13,[sp,#0] 
        stur x30,[sp,#8]
    mov x13, tiempo       // Copia el valor de x12 a x13 (contador)
    delay_loop:
    subs x13, x13, #1   // Resta 1 a x13 y actualiza los flags
    bne delay_loop      // Si x13 != 0, sigue en el bucle
      
        ldur x13,[sp,#0]  
        ldur x30,[sp,#8]
        add sp,sp,#16
    ret

