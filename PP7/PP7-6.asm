Include Irvine32.inc

.data
	array SDWORD -5,-20,18,24,11,7,438,226,13,-26
	str1 byte "Greatest common divisor is: ",0
.code
main PROC
	mov ECX, LENGTHOF array /2
	mov ESI,OFFSET array
	L1:
		mov EDI,2
		L3:
			mov EAX,[ESI]
			add ESI,4
			cmp EAX,0
			jl L5
			jmp L2

		L5:
			neg EAX

		L2:
			push EAX
			dec EDI
			cmp EDI,0
			jne L3

		call gcd
		mov EDX, offset str1
		call WriteString
		call WriteDec
		call CRLF
		loop L1
invoke ExitProcess,0

main ENDP

GCD proc
	pop EDI
	pop EAX
	pop EBX
	gcd1:
		mov EDX,0
		div EBX
		mov EAX,EBX
		mov EBX,EDX
		cmp EBX,0
		jg gcd1
	push EDI
	ret
gcd endp

END main

