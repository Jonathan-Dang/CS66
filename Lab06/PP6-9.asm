include Irvine32.inc

.data
	LowerBounds BYTE 5,2,4,1,3
	UpperBounds BYTE 9,5,8,4,6

	success BYTE "Valid",0
	failure BYTE "inValid",0

	input1 BYTE 6,3,4,4,4
	input2 BYTE 5,2,4,1,3
	input3 BYTE 1,1,1,1,1
	input4 BYTE 9,9,9,9,9
.code
main proc
	mov EBX, OFFSET input1
	mov ESI, OFFSET LowerBounds
	mov EDI, OFFSET UpperBounds
	call ValidatePin

	cmp EAX, 0
	JE SuccessPro
	JNE FailurePro

	SuccessPro:
		mov EDX, OFFSET success
		call WriteString
		call CRLF
		invoke ExitProcess,0

	FailurePro:
		mov EDX, OFFSET failure
		call WriteString
		call CRLF
		invoke ExitProcess,0
main endp

ValidatePin proc uses ECX EDX ESI EDI
	mov EAX, 0
	mov ECX, LENGTHOF LowerBounds

	L1:
		mov AL, [EBX]
		cmp AL, [ESI]
		JG stage1
		JE stage1
		loop L1

	stage1:
		cmp AL, [EDI]
		JL stage2
		JE stage2
		jmp back

	stage2:
		inc EBX
		inc ESI
		inc EDI
		loop L1

	back:
		mov EAX, 6
		sub EAX, ECX
		jmp L2
		mov EAX, 0
	L2:
		ret
ValidatePin endp

end main