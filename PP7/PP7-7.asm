INCLUDE Irvine32.inc

.data
statement BYTE "The product is ", 0
num1 DWORD 456
num2 DWORD 52
.code
	main PROC
	mov EBX, num1
	mov EAX, num2
	call BitwiseMultiply

	mov EDX, OFFSET statement
	call WriteString
	call WriteDec
	call Crlf
	invoke ExitProcess,0
main ENDP


BitwiseMultiply PROC uses EDX EBX

	mov EDX, 0
	mov cl, 0

	L1:
		shr EAX, 1
		jc SAA 
		inc cl 
		jmp next

	SAA:
		shl EBX, cl
		add EDX, EBX 
		shl EBX, 1 
		mov cl, 0 

	next:
		cmp EAX, 0 
		je final
		jmp L1 

	final:
		mov EAX, EDX 
		ret
BitwiseMultiply ENDP
END main