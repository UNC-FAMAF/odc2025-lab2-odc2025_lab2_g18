Nombre y apellido 
Integrante 1: Máximo Ezequiel Garzón
Integrante 2: Luca Lorenzatti
Integrante 3: Lourdes Maria Vallori
Integrante 4: Paula Andrea Zalazar


Descripción ejercicio 1: un lindo gatito negro dentro de una ventana de paint, con un fondo hacia una ciudad y un cielo con colores entre azules, violetas y anaranjados.


Descripción ejercicio 2: un Bob Esponja siendo abducido por un ovni en Fondo de Bikini.


Justificación instrucciones ARMv8: usamos la instrucción asr (Arithmetic Shift Right) que sirve para realizar divisiones con potencias de dos que conserven signo (realiza un desplazamiento aritmético a la derecha).

Para lograr la transparencia en la subrutina trapecio, primero extraemos el componente alfa del color que le mandamos (los primeros dos bytes), esto lo hacemos aplicando una mascara con and y despues los movemos hacia la derecha para operar con eso más adelante.
En caso de que el componente alfa sea 255 (full opaco), el color se pinta directamente sin más; en caso de que el alfa sea menor a 255 se van a mezclar los componentes RGB del color nuevo con los del fondo (la formula que usamos es colorFinal=(colorFondo*(255-alfa)+colorNuevo*alfa)/255), de nuevo separando cada bytes de color, desplazando, multiplicando, etc. El resultado de esta fórmula nos va a dar el nuevo color que va a simular esa transparencia querida.

