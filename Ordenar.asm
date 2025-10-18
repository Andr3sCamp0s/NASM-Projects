;-------------------------------------------------------------------------------------------------
;Este código le solicita al usuario hasta 10 palabras de un máximo de 11 caracteres cada una,
;luego, utiliza el algoritmo de Ordenamiento por Inserción para ordenar todas las palabras 
;alfabéticamente de forma ascendente. La comparación entre palabras no distingue entre letras 
;mayúsculas y minúsculas para que el ordenamiento funcione. Al final el programa muestra primero
;la lista de palabras en el orden original y luego la lista de palabras ya ordenada.
;-------------------------------------------------------------------------------------------------

%include 'io.mac'                        ;Incluye la librería del libro de Sivarama

.DATA
    msg_pedir_palabra   db  "Ingrese una palabra (max 10 chars) o Enter para terminar: ", 0     ;Mensaje para pedir palabra
    msg_originales      db  "Palabras en orden original", 0                                     ;Mensaje para mostrar palabras sin ordenar
    msg_ordenadas       db  "Palabras ordenadas alfabéticamente", 0                             ;Mensaje para mostrar palabras ordenadas

.UDATA
    arreglo_palabras    resb 110          ;10 palabras * 11 bytes = 110 bytes (11 visibles + 1 nulo)
    contador_palabras   resd 1            ;Contador de cuantas palabras se ingresaron
    palabra_temporal    resb 11           ;Espacio para una palabra de 11 chars + nulo

.CODE
    mov     ecx, 0                  ;Limpiar contador
    mov     edi, arreglo_palabras   ;EDI apunta al inicio del arreglo 

;Empieza a leer las palabras
lectura:
    cmp     ecx, 10                     ;Verifica si ya hay 10 palabras
    je      fin_lectura                 ;Si ya hay 10 palabras deja de leer
    PutStr  msg_pedir_palabra           ;Muestra mensaje para ingresar palabra
    GetStr  edi, 11                     ;Lee la palabra y la guarda en EDI (lee 11 chars: 10 visibles + nulo)
    cmp     byte [edi], 0               ;Verifica si la cadena esta vacia (se presiono enter sin texto)
    je      fin_lectura                 ;Si solo presiono enter para de leer
    inc     dword [contador_palabras]   ;Aumenta el contador de palabras ingresadas
    add     edi, 11                     ;Avanza EDI una palabra (11 bytes por palabra)
    inc     ecx                         ;Incrementa el ECX por cada palabra que se ingresa 
    jmp     lectura                     ;Repite todo lo de lectura

;Imprime las palabras en orden original
fin_lectura:
    nwln                                ;Salto de línea
    PutStr  msg_originales              ;Muestra el mensaje de “Palabras originales”
    nwln                                ;Salto de línea
    mov     ecx, [contador_palabras]    ;Pone el contador en la cantidad de palabras leidas para que el bucle coincida 
    mov     esi, arreglo_palabras       ;ESI apunta al inicio del arreglo

imprimir_original:
    test    ecx, ecx                ;Verifica si ya se imprimieron todas las palabras
    jz      ordenar                 ;Si ya imprimio todo pasa al ordenamineto
    PutStr  esi                     ;Imprime la palabra del esi
    nwln                            ;Salto de línea
    add     esi, 11                 ;Avanza el esi a la siguiente palabra (11 bytes)
    dec     ecx                     ;Reduce contador del bucle
    jmp     imprimir_original       ;Repite el proceso de imprimir la palabra

;Comienxa a ordenar
ordenar:
    mov     ecx, 1                  ;Comienza desde la segunda palabra, ecx va a ser i en el ordenamiento de insercion 

;Bucle i de ordenamiento de insercion
ordenamiento_ext:
    cmp     ecx, [contador_palabras]        ;Verifica si ya i recorrio todo el arreglo
    jge     ordenado                        ;Si ya se recorrió todo, imprime el resultado
    push    ecx                             ;Guarda valor de i en la pila para que no se pierda 
    mov     edi, palabra_temporal           ;Deja como destino el arreglo que guarda la palabra temporalmente
    mov     esi, arreglo_palabras           ;Deja el esi al inicio del arreglo para saber donde esta exactamente
    imul    ecx, 11                         ;Multiplica la posicion de i por 11 para obtener su posicion en el arreglo
    add     esi, ecx                        ;Mueve el esi a la casilla de la palabra que tenia i
    mov     ecx, 11                         ;Pone el ecx en 11 para copiar 11 bytes en la siguiente instruccion (rep trabaja con ecx)
    rep     movsb                           ;Copia la palabra en i en la palabra temporal
    pop     ecx                             ;Restaura valor de i que estaba guardado en la pila
    mov     ebx, ecx                        ;EBX va a ser j en el ordenamiento de insercion
    dec     ebx                             ;j = i - 1

;Bucle j de ordenamiento de insercion
ordenamiento_int:
    cmp     ebx, 0                  ;Ve si j quedo en una posicion posible del arreglo
    jl      fin_ordenamiento_int    ;Si la posicion de j no es posible sale del bucle
    push    esi                     ;Guarda el puntero de i en la pila
    push    ebx                     ;Guarda índice j en la pila 
    mov     edi, palabra_temporal   ;Cadena 1: palabra actual
    mov     esi, arreglo_palabras   ;Pone el esi al inicio del arreglo de palabras
    imul    ebx, 11                 ;Multiplica la posicion de j por 11 para obtener su posicion
    add     esi, ebx                ;Desplaza el esi a la posicion de j
    mov     ebx, ecx                ;Devuelve el valor de j que tenia antes
    dec     ebx                     ;intente usar el pop ebx pero no me funciono

;Compara caracter por caracter las palabras 
comparar:
    mov     al, byte [esi]          ;Guarda un caracter de la palabra en la posicion de j
    mov     bl, byte [edi]          ;Guarda un caracter de la palabra temporal 
    test    al, al                  ;Verifica que haya un caracter, si el resultado es cero leyo un espacio vacio
    jz      BL_EsCero               ;Si AL = 0 es el fin de la cadena en la posicion j, ahora verifica la cadena temporal
    cmp     al, 'A'                 ;Compara el caracter con la A mayuscula
    jb      no_mayusculaAL          ;Si es menor no es mayuscula segun ascii
    cmp     al, 'Z'                 ;Compara el caracter con la Z mayuscula 
    ja      no_mayusculaAL          ;Si es mayor no es mayuscula segun ascii
    add     al, 32                  ;Si la letra es mayuscula le suma 32 para hacerla minuscula segun ascii

;Convierte las letras de las palabras en minuscula
no_mayusculaAL:
    cmp     bl, 'A'                 ;Compara el caracter con la A mayuscula
    jb      no_mayusculaBL          ;Si es menor no es mayuscula segun ascii
    cmp     bl, 'Z'                 ;Compara el caracter con la Z mayuscula
    ja      no_mayusculaBL          ;Si es menor no es mayuscula segun ascii
    add     bl, 32                  ;Si la letra es mayuscula le suma 32 para hacerla minuscula segun ascii

no_mayusculaBL:
    cmp     al, bl                  ;Compara los caracteres en minúscula de las 2 palabras
    ja      mayor                   ;Si al es mayor que bl la palabra temporal es mayor que la de la posicion j
    jb      menor                   ;Si al es menor que bl la palabra temporal es menor que la de la posicion j
    inc     esi                     ;Incrementa el esi para seguir con el siguiente caracter de la palabra en la posicion j
    inc     edi                     ;Incrementa el edi para seguir con el siguiente caracter de la palabra temporal
    jmp     comparar                ;Vuelve a comparar pero ahora va con los siguientes caracteres de ambas palabras

;Comprueba si la palabra tiene menor largo con la que se compara o si son iguales
BL_EsCero:
    test    bl, bl                  ;Verifica que haya un caracter, si el resultado es cero leyo un espacio vacio
    jnz     menor                   ;Si BL != 0 significa que si habia un caracter, la palabra temporal es menor ya que tenia menos letras
    jmp     final_comparar_iguales  ;Si BL = 0 significa que era un espacio vacio, por lo tanto las palabras eran iguales

;La palabra es mayor con la que se comparo
mayor:
    mov     eax, 1                  ;Palabra temporal mayor a palabra en posicion j, deja el eax en 1 como una bandera de mayor
    jmp     salir_comparar          ;Salta para que no se ejecuten las lineas de menor ni igual

;La palabra es menor con la que se comparo
menor:
    mov     eax, -1                 ;Palabra temporal menor a palabra en posicion j, deja el eax en 1 como una bandera de menor
    jmp     salir_comparar          ;Salta para que no se ejecuten las lineas de igual

;La palabra es igual con la que se comparo
final_comparar_iguales:
    mov     eax, 0                  ;Son iguales, deja el eax en 0 como bandera de menor

;Termina de comparar los caracteres de las palabras
salir_comparar:
    pop     ebx                     ;Se devuelve el valor de j que estaba en la pila
    pop     edi                     ;Restaura el valor de edi que se uso para leer la palabra temporal
    pop     esi                     ;Restaura el valor de esi que se usó para leer la palabra en la posicion j del arreglo
    cmp     eax, 1                  ;Verifica el estado de la bandera de mayor puesta en el eax
    jne     fin_ordenamiento_int    ;Si la bandera de mayor esta apagada, es menor o igual, por lo tanto no se mueven las palabras
    push    ecx                     ;Guarda el valor de i en la pila
    mov     esi, arreglo_palabras   ;Vuelve a poner al esi al principio del arreglo de las palabras
    mov     eax, ebx                ;Se utiliza el registro eax como auxiliar para que el valor de j no se pierda
    imul    eax, 11                 ;Multiplica la posicion de j por 11 para obtener su posicion en el arreglo (cada palabra ocupa 11 bytes)
    add     esi, eax                ;Mueve al esi a la posicion de la palabra en posicion j en el arreglo
    mov     edi, esi                ;Pone al edi en la misma palabra que el esi
    add     edi, 11                 ;Le suma 11 al edi para que avance una palabra (11 bytes)
    mov     ecx, 11                 ;Se pone el ecx en 11 para copiar 11 bytes en la siguiente instruccion (rep trabaja con ecx)
    rep     movsb                   ;Mueve 11 bytes (palabra en j) a la siguiente casilla
    pop     ecx                     ;Se devuelve el valor de i que estaba en la pila
    dec     ebx                     ;Se le resta uno a la posicion j para que se retrase una casilla
    jmp     ordenamiento_int        ;Repite todo el proceso de ordenamiento

;Termina el bucle de j, incia nuevamente el bucle de i pero en i+1
fin_ordenamiento_int:
    push    ecx                         ;Guarda el valor de i en la pila
    mov     esi, palabra_temporal       ;Pone el esi en la palabra temporal
    mov     edi, arreglo_palabras       ;Pone el edi al principio del arreglo de las palabras
    inc     ebx                         ;Le suma 1 a la posicion de j para que avance una casilla
    mov     eax, ebx                    ;Se utiliza el registro eax como auxiliar para que el valor de j no se pierda
    imul    eax, 11                     ;Multiplica la posicion de j por 11 para obtener su posicion en el arreglo
    add     edi, eax                    ;Pone el edi en la posicion j del arreglo (cada palabra ocupa 11 bytes)
    mov     ecx, 11                     ;Se pone el ecx en 11 para copiar 11 bytes en la siguiente instruccion (rep trabaja con ecx)
    rep     movsb                       ;Mueve 11 bytes (la palabra temporal) a la casilla correspondiente
    pop     ecx                         ;Restaura el valor de i que estaba en la pila
    inc     ecx                         ;Le suma 1 a la posicion de i en el arreglo
    jmp     ordenamiento_ext            ;Repite el ordenamiento con la nueva posicion de i (una casilla adelante)

;Imprime las palabras ordenadas
ordenado:
    nwln                                ;Salto de línea
    PutStr  msg_ordenadas               ;Mensaje de las palabras ordenadas
    nwln                                ;Salto de línea
    mov     ecx, [contador_palabras]    ;Pone el contador en la cantidad de palabras leidas para que el bucle coincida
    mov     esi, arreglo_palabras       ;Mueve el esi al inicio del arreglo para imprimir la primer palabra

imprimir_ordenado:
    test    ecx, ecx                ;Verifica si debe imprimir otra palabra
    jz      fin_programa            ;Si no, termina el programa
    PutStr  esi                     ;Imprime la palabra de la posicion de esi actual
    nwln                            ;Salto de linea para que no salgan pegadas
    add     esi, 11                 ;Avanza el esi a la siguiente palabra (11 bytes)
    dec     ecx                     ;Resta 1 al contador por cada palabra impresa
    jmp     imprimir_ordenado       ;Repite el ciclo de imprimir una palabra

fin_programa:
    nwln                            ;Salto de línea final
.EXIT