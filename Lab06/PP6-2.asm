include Irvine32.inc

.data
	arr DWORD 10 dup(1)
	J DWORD ?
	K DWORD ?
	SUM DWORD ?

	string1 BYTE "Please enter the starting position: ",0
	string2 BYTE "Please enter the ending position: ",0

.code
main proc

	mov EDX, OFFSET string1
	call WriteString
	call ReadDec
	mov J, EAX

	mov EDX, OFFSET string2
	call WriteString
	call ReadDec
	mov K, EAX

	dec J
	dec K

	mov EAX, J
	mov EBX, K
	mov ECX, LENGTHOF arr
	mov ESI, OFFSET arr
	mov EDI, OFFSET SUM
	call ArrSum

	mov EAX, SUM
	call WriteDec
	call Crlf
		

	invoke ExitProcess,0
main endp

ArrSum proc uses EAX EBX ECX EDX ESI EDI		;EAX lower index | EBX upper index | ECX, EDX Buffer | ESI array | EDI sum var
	mov EDX, 0

	L1:
		cmp EDX, J
		JE L2					;EDX == J
		JG L2					;EDX > J

		inc EDX
		add ESI, TYPE [ESI]
		loop L1

	L2:
		cmp EDX, K
		JE ExitLoop					;EDX == K

		push EDX
		mov EDX, [ESI]
		add [EDI], EDX
		pop EDX

		inc EDX
		add ESI, TYPE [ESI]
		dec ECX
		jmp L1

	ExitLoop:
		mov EDX, [ESI]
		add [EDI], EDX
		ret

	ret
ArrSum endp

end main