;******************************************************************************
; Ensayos de instrucciones para uCs AVR - ATmega328P
; Angélica Gutiérrez Moreno
;;*****************************************************************************
; Segmentos de código para ensayar instrucciones del uP
; En cada caso agrgegue los comentarios adecuados.
;==============================================================================
; Ejercite el siguiente segmento de código:


.ORG		0x000				; Localidad en donde se ensambla el código que sigue

	jmp		Quinto; Decimo;Noveno;Octavo;Septimo;Sexto;Quinto;Cuarto;Tercero;Segundo;DeNuevo; Salta a la etiqueta que está aquí como operando

DeNuevo:	
	in		R16,PINB			;	R16 <- [PORTB]
	out		PORTC,R16			;	[PORTC] <- R16
	jmp		DeNuevo				; ...continúa en lo mismo...
;==============================================================================
; Ahora este.

;.ORG		0x000				;
Segundo:
	ldi	R20,0x55				;
	out	PORTB, R20				;
L1:	
	com	R20						;
	out	PORTB, R20				;
	jmp	L1						;
;==============================================================================
; Establezca cómo queda al final del segmento el registro R20.
; Modifique el código para que ahora quede 0xBE en el registro R20
			;El código debe cargarse con "0x41" para que el complemento sea "0xBE"
;.ORG		0x000				;
Tercero:
	ldi	R20, 4					;
	dec	R20						;
	dec	R20						;
	dec	R20						;
	dec	R20						;
L2:		
	rjmp	L2					; ¿Cuál es la ventaja de esta instrucción en realción a
								; la anteriormente usada ("jmp")?
								;rjmp es un salto relativo que se puede dar en cierta cantidad 
								;alrededor de donde se esta pidiendo el salto
								;mientras que jmp es un salto absoluto que se puede dar en 
								;cualquier parte de la memoria
;==============================================================================
; Verifique la siguiente suma.
; Agregue el uso del "Carry".
; Haga ejemplos en donde la bandera de "Carry" se ponga a "0" y a "1".

;.ORG		0x000				;
Cuarto:

cero:
	ldi	R16,0x38				;Cargar registro 16 con valor hexagesimal 38
	ldi	R17,0x2F				;Cargar registro 17 con valor hexagesimal 2F
	add	R16,R17					;Sumar registro 16 y 17
	cp R16, R17					;comparar ambos registros
	brcc carry					;saltar a etiqueta carry si C

salto:
	ldi R16, 0xAA
	ldi R18, 0x66
carry:
	adc R16, R18
	cp R16, R18
	brcc salto

L3:
	rjmp	L3					;
;==============================================================================
; Utiliza alguna instrucción distinta a "ldi" en el siguiente segmento y
; realiza una suma parecida

;.ORG		0x000
Quinto:
	ldi	R20, 0x9C			; En lugar de usar la instrución ldi, se puede usar storage load direct from data space
	sts 0x100, R20
	ldi	R21, 0x64			;
	sts 0x101, R21
	add	R20, R21				;
	;sts 0x100, R20
L4:
	rjmp	L4					;
;==============================================================================
; verifica qué realiza lo que continúa.
; Emplea el simulador de Atmel Studio.

;.ORG			0x000			;
Sexto:
	ldi	R20,0x88				;Carga el registro 20 con valor 0x88
	ldi	R21,0x93				;carga el registro 21 con valor 0x93
	add	R20,R21					;suma ambos registros, pero pierde el carry
L5:
	rjmp	L5					;

;==============================================================================
; Ensayo de un programa completo
; Crea un proyecto con tu nombre, agrégale el siguiente segmento de código.
; Simula la ejecución y muestra resultados.

.EQU	SUMA	= 0x300	

;.ORG 00
Septimo:	
	ldi		R16, 0x25			;
	ldi		R17, $34			;
	ldi		R18, 0b00110001		;
	add		R16, R17			;
	add		R16, R18			;
	ldi		R17, 11				;
	add		R16, R17			;
	sts		SUMA, R16			;
PorAca:
	JMP	PorAca
;==============================================================================
;Resta de dos números de 8 bits

.EQU	RESTA = 0x301	

;.ORG 00	
Octavo:							;
	ldi		R19, 0xAA			;
	ldi		R20, $3				;
	ldi		R21, 0b00001011		;
	sub		R19, R20			;
	sub		R19, R21			;
	ldi		R20, 11				;
	sub		R19, R20			;
	sts		RESTA, R19			;
Termina:
	JMP	termina
;==============================================================================
;Multiplicación de dos números de 8 bits
;.ORG 00	
.EQU	MULTI = 0x3002
Noveno:							;
	ldi		R16, 0b00000101		;
	ldi		R17, 0b00001110		;
	mul		R16, R17			;
Aqui:
	JMP	Aqui
;==============================================================================
;Comparación de dos valores, sin signo, para determinar si uno es igual, 
;mayor o menor con relación a otro.
Decimo:
	ldi R16, 0x12
	ldi R17, 0x0A
	ldi R18, 0x10
	ldi R19, 0x10
	cp R16, R17
	brne mayor_que
iguales: 
	cp R19, R18
	breq menor_que
mayor_que:
	cp R16, R18
	brsh iguales
menor_que:
	cp R19, R17
	brlo En_este_lugar
En_este_lugar:
	jmp En_este_lugar
;==============================================================================
;Introducir datos desde un puerto (PORTB, PORTC o PORTD)
datos:
	
;==============================================================================
;Generar el patrón de iluminación de un desplegador de 7 segmentos, para los 
;dígitos hexadecimales.

;-----[ DEFINICIONES de CONSTANTES y VARIABLES ]-----
.DEF Temp1 = r17			; Variables TEMPORALES. Verificar los Rx más adecuados.
.DEF Temp2 = r18			;
.DEF Temp3 = r19			;
.DEF datoa = r20			; Para alojar DATOS
.DEF byte = r21				; Para algún tipo de conversión.
;------------------------------------------------------------------------------
;-----[ ETIQUETAS ]-----
.EQU INPUT = 0x00			;	Todas las terminales son ENTRADAS
.EQU ENTRADAS = 0x00	; Sinónimo
.EQU OUTPUT = 0xFF		; Todas las terminales son SALIDAS
.EQU SALIDAS = 0xFF		; Sinónimo
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
; -----[ AJUSTES PRINCIPALES ]-----
;------------------------------------------------------------------------------
	ldi temp1,0xFF					; Ajuste de terminales de PORTB como SALIDAS
	out DDRB,temp1					;
;-------------------------------------------------------------------------------

patron:
;para prender todos
	call delayXms						; Retardo en tiempo (calcular con herramienta)
	sbi PORTB,0							; El bit "0" de PORTB puesto a "1"
	sbi PORTB,1							; El bit "0" de PORTB puesto a "1"
	sbi PORTB,2							; El bit "0" de PORTB puesto a "1"
	sbi PORTB,3							; El bit "0" de PORTB puesto a "1"
	sbi PORTB,4							; El bit "0" de PORTB puesto a "1"
	sbi PORTB,5							; El bit "0" de PORTB puesto a "1"
	sbi PORTB,6							; El bit "0" de PORTB puesto a "1"

;para 1
	call delayXms						; Retardo en tiempo (calcular con herramienta)
	sbi PORTB,0							; El bit "0" de PORTB puesto a "1"
	cbi PORTB,1							; El bit "0" de PORTB puesto a "0"
	cbi PORTB,2							; El bit "0" de PORTB puesto a "0"
	sbi PORTB,3							; El bit "0" de PORTB puesto a "1"
	sbi PORTB,4							; El bit "0" de PORTB puesto a "1"
	sbi PORTB,5							; El bit "0" de PORTB puesto a "1"
	sbi PORTB,6							; El bit "0" de PORTB puesto a "1"
;para 2
	call delayXms						; Retardo en tiempo (calcular con herramienta)
	cbi PORTB,0							; El bit "0" de PORTB puesto a "0"
	cbi PORTB,1							; El bit "0" de PORTB puesto a "0"
	sbi PORTB,2							; El bit "0" de PORTB puesto a "1"
	cbi PORTB,3							; El bit "0" de PORTB puesto a "0"
	cbi PORTB,4							; El bit "0" de PORTB puesto a "0"
	sbi PORTB,5							; El bit "0" de PORTB puesto a "1"
	cbi PORTB,6							; El bit "0" de PORTB puesto a "0"
;para 3
	call delayXms						; Retardo en tiempo (calcular con herramienta)
	cbi PORTB,0							; El bit "0" de PORTB puesto a "0"
	cbi PORTB,1							; El bit "0" de PORTB puesto a "0"
	cbi PORTB,2							; El bit "0" de PORTB puesto a "0"
	cbi PORTB,3							; El bit "0" de PORTB puesto a "0"
	sbi PORTB,4							; El bit "0" de PORTB puesto a "1"
	sbi PORTB,5							; El bit "0" de PORTB puesto a "1"
	cbi PORTB,6							; El bit "0" de PORTB puesto a "0"
;para 4
	call delayXms						; Retardo en tiempo (calcular con herramienta)
	sbi PORTB,0							; El bit "0" de PORTB puesto a "1"
	cbi PORTB,1							; El bit "0" de PORTB puesto a "0"
	cbi PORTB,2							; El bit "0" de PORTB puesto a "0"
	sbi PORTB,3							; El bit "0" de PORTB puesto a "1"
	sbi PORTB,4							; El bit "0" de PORTB puesto a "1"
	cbi PORTB,5							; El bit "0" de PORTB puesto a "0"
	cbi PORTB,6							; El bit "0" de PORTB puesto a "0"
;para 5
	call delayXms						; Retardo en tiempo (calcular con herramienta)
	cbi PORTB,0							; El bit "0" de PORTB puesto a "0"
	sbi PORTB,1							; El bit "0" de PORTB puesto a "1"
	cbi PORTB,2							; El bit "0" de PORTB puesto a "0"
	cbi PORTB,3							; El bit "0" de PORTB puesto a "0"
	sbi PORTB,4							; El bit "0" de PORTB puesto a "1"
	cbi PORTB,5							; El bit "0" de PORTB puesto a "0"
	cbi PORTB,6							; El bit "0" de PORTB puesto a "0"
;para 6
	call delayXms						; Retardo en tiempo (calcular con herramienta)
	cbi PORTB,0							; El bit "0" de PORTB puesto a "0"
	sbi PORTB,1							; El bit "0" de PORTB puesto a "1"
	cbi PORTB,2							; El bit "0" de PORTB puesto a "0"
	cbi PORTB,3							; El bit "0" de PORTB puesto a "0"
	cbi PORTB,4							; El bit "0" de PORTB puesto a "0"
	cbi PORTB,5							; El bit "0" de PORTB puesto a "0"
	cbi PORTB,6							; El bit "0" de PORTB puesto a "0"
;para 7
	call delayXms						; Retardo en tiempo (calcular con herramienta)
	cbi PORTB,0							; El bit "0" de PORTB puesto a "0"
	cbi PORTB,1							; El bit "0" de PORTB puesto a "0"
	cbi PORTB,2							; El bit "0" de PORTB puesto a "0"
	sbi PORTB,3							; El bit "0" de PORTB puesto a "1"
	sbi PORTB,4							; El bit "0" de PORTB puesto a "1"
	sbi PORTB,5							; El bit "0" de PORTB puesto a "1"
	sbi PORTB,6							; El bit "0" de PORTB puesto a "1"
;para 8
	call delayXms						; Retardo en tiempo (calcular con herramienta)
	cbi PORTB,0							; El bit "0" de PORTB puesto a "0"
	cbi PORTB,1							; El bit "0" de PORTB puesto a "0"
	cbi PORTB,2							; El bit "0" de PORTB puesto a "0"
	cbi PORTB,3							; El bit "0" de PORTB puesto a "0"
	cbi PORTB,4							; El bit "0" de PORTB puesto a "0"
	cbi PORTB,5							; El bit "0" de PORTB puesto a "0"
	cbi PORTB,6							; El bit "0" de PORTB puesto a "0"
;para 9
	call delayXms						; Retardo en tiempo (calcular con herramienta)
	cbi PORTB,0							; El bit "0" de PORTB puesto a "0"
	cbi PORTB,1							; El bit "0" de PORTB puesto a "0"
	cbi PORTB,2							; El bit "0" de PORTB puesto a "0"
	cbi PORTB,3							; El bit "0" de PORTB puesto a "0"
	sbi PORTB,4							; El bit "0" de PORTB puesto a "0"
	cbi PORTB,5							; El bit "0" de PORTB puesto a "0"
	cbi PORTB,6							; El bit "0" de PORTB puesto a "0"
;para A
	call delayXms						; Retardo en tiempo (calcular con herramienta)
	cbi PORTB,0							; El bit "0" de PORTB puesto a "0"
	cbi PORTB,1							; El bit "0" de PORTB puesto a "0"
	cbi PORTB,2							; El bit "0" de PORTB puesto a "0"
	sbi PORTB,3							; El bit "0" de PORTB puesto a "0"
	cbi PORTB,4							; El bit "0" de PORTB puesto a "0"
	cbi PORTB,5							; El bit "0" de PORTB puesto a "0"
	cbi PORTB,6							; El bit "0" de PORTB puesto a "0"
;para B
	call delayXms						; Retardo en tiempo (calcular con herramienta)
	cbi PORTB,0							; El bit "0" de PORTB puesto a "0"
	cbi PORTB,1							; El bit "0" de PORTB puesto a "0"
	cbi PORTB,2							; El bit "0" de PORTB puesto a "0"
	cbi PORTB,3							; El bit "0" de PORTB puesto a "0"
	cbi PORTB,4							; El bit "0" de PORTB puesto a "0"
	cbi PORTB,5							; El bit "0" de PORTB puesto a "0"
	cbi PORTB,6							; El bit "0" de PORTB puesto a "0"
;para C
	call delayXms						; Retardo en tiempo (calcular con herramienta)
	cbi PORTB,0							; El bit "0" de PORTB puesto a "0"
	sbi PORTB,1							; El bit "0" de PORTB puesto a "0"
	sbi PORTB,2							; El bit "0" de PORTB puesto a "0"
	cbi PORTB,3							; El bit "0" de PORTB puesto a "1"
	cbi PORTB,4							; El bit "0" de PORTB puesto a "1"
	cbi PORTB,5							; El bit "0" de PORTB puesto a "0"
	sbi PORTB,6							; El bit "0" de PORTB puesto a "0"
;para D
	call delayXms						; Retardo en tiempo (calcular con herramienta)
	cbi PORTB,0							; El bit "0" de PORTB puesto a "0"
	cbi PORTB,1							; El bit "0" de PORTB puesto a "0"
	cbi PORTB,2							; El bit "0" de PORTB puesto a "0"
	cbi PORTB,3							; El bit "0" de PORTB puesto a "0"
	cbi PORTB,4							; El bit "0" de PORTB puesto a "0"
	cbi PORTB,5							; El bit "0" de PORTB puesto a "0"
	sbi PORTB,6							; El bit "0" de PORTB puesto a "1"
;para E
	call delayXms						; Retardo en tiempo (calcular con herramienta)
	cbi PORTB,0							; El bit "0" de PORTB puesto a "0"
	sbi PORTB,1							; El bit "0" de PORTB puesto a "1"
	sbi PORTB,2							; El bit "0" de PORTB puesto a "1"
	cbi PORTB,3							; El bit "0" de PORTB puesto a "0"
	cbi PORTB,4							; El bit "0" de PORTB puesto a "0"
	cbi PORTB,5							; El bit "0" de PORTB puesto a "0"
	cbi PORTB,6							; El bit "0" de PORTB puesto a "0"
;para F
	call delayXms						; Retardo en tiempo (calcular con herramienta)
	cbi PORTB,0							; El bit "0" de PORTB puesto a "0"
	sbi PORTB,1							; El bit "0" de PORTB puesto a "1"
	sbi PORTB,2							; El bit "0" de PORTB puesto a "1"
	sbi PORTB,3							; El bit "0" de PORTB puesto a "1"
	cbi PORTB,4							; El bit "0" de PORTB puesto a "0"
	cbi PORTB,5							; El bit "0" de PORTB puesto a "0"
	cbi PORTB,6							; El bit "0" de PORTB puesto a "0"
	rjmp patron							; ...repetir...
delayYms:
	ldi Temp1, 66						;para 8mhz ; 1 ciclo
LOOP0:
	ldi temp2, 200						; 1 ciclo    -> 200 ms
LOOP1:
	dec temp2							; 1 ciclo
	brne LOOP1							; 1 si es falso 2 si es verdadero
	dec Temp1							; 1
	brne LOOP0							; 2
	ret
delayXms:
	ldi temp3,10							; ¿para 8mhz?
LazoXms:
	call delayYms
	dec temp3
	brne LazoXms
	ret
;==============================================================================

