title "Palíndromo"
	.model small
	.386
	.stack 64
	.data
; Cadena a verificar 
cadena db "La ruta natural",0

; Mensajes de salida
msg_es db "Es palindromo",0Dh,0Ah,"$"
msg_no db "No es palindromo",0Dh,0Ah,"$"

; Buffer para almacenar cadena sin espacios y en minusculas
buffer db 100 dup(0)

	.code
inicio:
	mov ax,@data
	mov ds,ax
	mov es,ax

	; Preparar procesamiento de la cadena
	lea si,[cadena]      ; SI apunta al inicio de la cadena original
	lea di,[buffer]      ; DI apunta al buffer destino
	xor cx,cx            ; CX = contador de caracteres validos

procesar_cadena:
	lodsb                ; AL = [SI], SI++
	cmp al,0            
	je fin_procesar
	
	; Ignorar espacios
	cmp al,20h           
	je procesar_cadena
	
	; Convertir a minuscula si es mayuscula
	cmp al,'A'
	jb guardar_char
	cmp al,'Z'
	ja verificar_minuscula
	add al,20h           ; Convertir a minuscula
	jmp guardar_char

verificar_minuscula:
	cmp al,'a'
	jb guardar_char
	cmp al,'z'
	ja guardar_char

guardar_char:
	mov [di],al          ; Guardar caracter procesado
	inc di
	inc cx               ; Incrementar contador
	jmp procesar_cadena

fin_procesar:
	; CX tiene el numero de caracteres validos
	cmp cx,0
	je no_palindromo     ; Si no hay caracteres, no es palindromo
	
	; Verificar si es palindromo
	lea si,[buffer]      ; SI apunta al inicio
	lea di,[buffer]
	add di,cx
	dec di               ; DI apunta al final
	
	mov bx,cx
	shr bx,1             ; BX = CX/2 (número de comparaciones)

comparar:
	cmp bx,0
	je es_palindromo     ; terminamos todas las comparaciones
	
	mov al,[si]
	mov ah,[di]
	cmp al,ah
	jne no_palindromo    ; Si son diferentes, no es palindromo
	
	inc si               ; Avanzar 
	dec di               ; Retroceder 
	dec bx
	jmp comparar

es_palindromo:
	lea dx,[msg_es]
	jmp imprimir

no_palindromo:
	lea dx,[msg_no]

imprimir:
	mov ah,09h
	int 21h

salir:
	mov ah,4Ch
	mov al,0
	int 21h
	end inicio