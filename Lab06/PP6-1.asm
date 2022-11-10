INCLUDE Irvine32.inc

.data
	outputArr DWORD 100 dup(?)
	N DWORD ?
	J DWORD ?
	K DWORD	?
	string1 BYTE "Please enter your lower bounds: ",0
	string2 BYTE "Please enter your upper bounds: ",0
	string3 BYTE "Please enter the size of the array: ",0
.code
main proc
	mov EDX, OFFSET string1
	call WriteString
	call ReadInt
	mov J, EAX

	mov EDX, OFFSET string2
	call WriteString
	call ReadInt
	mov K, EAX

	mov EDX, OFFSET string3
	call WriteString
	call ReadInt
	mov N, EAX

	mov ESI, OFFSET outputArr
	mov EDX, TYPE outputArr
	call fillArray
	mov ECX, N

	print:
		mov EAX, [ESI]
		call WriteInt
		call CRLF
		add ESI, EDX
		loop print

	invoke ExitProcess,0
main endp

fillArray proc uses EAX EBX ECX EDX ESI		;EAX:LB|EBX:UB|ECX:Iterations|EDX:Buffer|ESI:Array
	pushf
	mov EAX, J
	mov EBX, K
	mov ECX, N

	Fill:
		push EAX
		call fastRNG
		mov [ESI], EAX
		pop EAX
		add ESI, EDX		;Make EDX the type of the array
		loop Fill

	popf
	ret
fillArray endp

fastRNG proc uses EBX ECX EDX		;EAX: Lower Bounds | EBX: High Bounds | EAX is return
	mov ECX, EBX
	mov EDX, EAX
	sub ECX, EAX
	mov EAX, ECX
	inc EAX					;RR uses 0 -> n-1, inc to now allow 0 -> n
	call RandomRange		;0 -> ECX
	add EAX, EDX			; ECX -> EBX
	ret
fastRNG endp			;Returns into EAX signed 32-bit integer

end main