INCLUDE Irvine32.inc

PrimeNumbers PROTO, counter: DWORD
FirstNumber = 2
LastNumber = 1000 
.data
	commaStr BYTE " ", 0
	sieve BYTE LastNumber DUP (?)
.code
	main proc
	mov ecx, LastNumber
	mov edi, OFFSET sieve
	mov al, 0
	cld
	rep stosb
	mov esi, FirstNumber
	.WHILE Esi <LastNumber
			.IF Sieve [esi * TYPE sieve] == 0 
			call Multiple 
			.ENDIF
		inc esi
		.ENDW
	INVOKE PrimeNumbers, LastNumber 
	invoke ExitProcess,0

main ENDP

Multiple PROC
	push eax
	push esi
	mov eax, esi ;prime number
	add esi, eax ;start with first multiple number
	L1: 
		cmp esi, LastNumber
		ja L2
		mov sieve [esi * TYPE sieve], 1
		add esi, eax
		jmp L1
	L2: 
		pop esi
		pop eax
	ret
Multiple ENDP


PrimeNumbers PROC,
	counter: DWORD ;number of values to display
	mov esi, 1
	mov eax, 0
	mov ecx, counter
	L1: 
		mov al, sieve [esi * TYPE sieve]
		.IF Al == 0
			mov eax, esi
			call WriteDec
			mov edx, OFFSET commaStr
			call WriteString
			.ENDIF
	inc esi
	loop L1
	ret
PrimeNumbers ENDP

END main