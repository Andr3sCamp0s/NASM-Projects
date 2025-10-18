;-------------------------------------------------------------------------------------
;Este código le solicita al usuario hasta 20 números enteros y los almacena en un
;arreglo. El programa se detiene si se ingresa un 0 o si se alcanza el límite de
;numeros, luego calcula la suma total de los valores y verifica si ocurre un
;overflow en la suma. Al final muestra la lista de números ingresados, la suma 
;y un mensaje indicando si hubo o no overflow
;-------------------------------------------------------------------------------------

%include "io.mac"                  ;Incluye la libreria del libro de Sivarama

.DATA
    PedirNumero    db "Ingrese un número (0 para terminar): ",0   ;Msj para pedir numero
    Valores        db "Valores leídos: ",0                        ;Msj para mostrar los valores
    Total          db "Suma total: ",0                            ;Msj para mostrar la suma
    Overflow       db "Hubo overflow en la suma.",0               ;Msj si hubo overflow
    NoOverflow     db "No hubo overflow.",0                       ;Msj si NO! hubo overflow
    flecha         db "->",0                                      ;Adorno para la impresion
    contador       dd 0                                           ;Aca se va a guardar la cantidad de valores leidos
    suma           dd 0                                           ;Aca se va a guardar la suma 
    overflow       db 0                                           ;Bandera de overflow No 0  /// Si 1

.UDATA
    arreglo     resd 20          ;Reserva 20 DoubleWords = 4Bytes c/u= 32bits

.CODE
;Lectura de numeros
leer_valor:
    PutStr PedirNumero                 ;Muestra el Msj para pedir un número
    nwln                               ;Salto de línea
    GetLInt EAX                        ;Guarda el entero de 32bits en EAX 
    cmp EAX, 0                         ;Compara el numero con 0
    je mostrar_valores                 ;Salta fuera de lectura si es 0
    mov ECX, [contador]                ;Guarda en ECX la cantidad de valores que se llevan
    cmp ECX, 20                        ;Verifica si ya alcanzo el maximo
    jae mostrar_valores                ;Si ya leyo 20 valores salta fuera de lectura
    mov [arreglo + ECX*4], EAX         ;Si aun no hay 20 vaores, guarda el dato en el arreglo 
    inc dword [contador]               ;Incrementa el contador de valores leídos
    mov EBX, [suma]                    ;Guarda la suma actual en EBX
    add EBX, EAX                       ;Suma el valor ingresado
    jo hubo_overflow                   ;Si ocurre overflow, salta a hubo_overflow
    mov [suma], EBX                    ;Actualiza la variable de suma
    jmp leer_valor                     ;Lee el siguiente valor

;Si hubo overflow al sumar
hubo_overflow:
    mov byte [overflow], 1  ;Activa la marca
    mov [suma], EBX         ;Guarda la suma 
    jmp leer_valor          ;Sigue con el siguiente numero

;Muestra todos los valores leidos
mostrar_valores:
    nwln                    ;Salto de linea
    PutStr Valores          ;Muestra el Msj "Valores leídos:"
    nwln                    ;Salto de linea
    mov ECX, 0              ;Inicializa índice ECX en 0

;Va avanzando en el arreglo
siguiente_valor:
    cmp ECX, [contador]            ;Compara la cantidad de valores que se leyeron con el indice del valor actual
    jge mostrar_suma               ;Si se recorrieron todos los valores muestra la suma
    mov EAX, [arreglo + ECX*4]     ;Carga el valor actual en EAX
    inc ECX                        ;Se incrementa para que la impresion empieze de 1->
    PutLInt ECX                    ;Indica el orden del numero del valor
    dec ECX                        ;Devuelve ECX a la normalidad
    PutStr flecha                  ;Elemento meramente visual ->
    PutLInt EAX                    ;Imprime el valor
    nwln                           ;Salto de línea para que no queden pegados
    inc ECX                        ;Incrementa el índice para ir con el otro valor
    jmp siguiente_valor            ;Repite hasta mostrar todos los valores

;Mostrar la suma 
mostrar_suma:
    nwln                      ;Salto de linea
    PutStr Total              ;Muestra el Msj "Suma total:"
    PutLInt [suma]            ;Muestra el valor de la suma
    nwln                      ;Salto de linea
    cmp byte [overflow], 0    ;Verifica el estado de la bandera de overflow
    je no_hubo_overflow       ;Si no hubo overflow, saltar a no_hubo_overflow
    PutStr Overflow           ;Si si hubo overflow, muestra el Msj de overflow
    jmp salir                 ;Salta a salir, este salto es necesario para que no salgan ambos mensajes

no_hubo_overflow:
    PutStr NoOverflow         ;Muestra el Msj "No hubo overflow"

salir:
    nwln                     ;Salto de linea para que no quede pegado con el mensaje de la terminal
.EXIT                        ;Termina la ejecución del programa
