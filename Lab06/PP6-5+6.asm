include Irvine32.inc

.data
	OptionPanel		BYTE '1'
					DWORD AND_process
					BYTE '2'
					DWORD OR_process
					BYTE '3'
					DWORD NOT_process
					BYTE '4'
					DWORD XOR_process
					BYTE '5'
					DWORD EXIT_process

	numOfEntries = 5
	x BYTE 1h
	y BYTE 1h
	choice BYTE ?
	prompt BYTE "Press 1,2,3,4,5: ",0
	MenuMsg BYTE "1| AND", 13,10, "2| OR", 13, 10, "3| NOT", 13, 10, "4| XOR", 13, 10, "5| EXIT",0

	Xmsg BYTE "X: ",0
	Ymsg BYTE "Y: ",0

	ERRORmsg BYTE "ERROR: Out of Selection Range!",0

	GetterMsg BYTE "Please insert an Integer Hex Value: ",0
.code

main proc
	Looping:
		call displayMenu
		mov ESI, OFFSET choice
		call ObtainCommand
		mov AL, choice
		call WriteChar
		call CRLF

		mov EBX, OFFSET OptionPanel
		mov ECX, numOfEntries
		mov ESI, OFFSET X
		mov EDI, OFFSET Y
		call ExecuteCommand
		jmp Looping

	invoke ExitProcess,0
main endp

ExecuteCommand proc uses EAX ECX
	L1:
		cmp AL, [EBX]
		JNE L2
		call NEAR PTR [EBX + 1]
		jmp L3

	L2:
		add EBX, 5
		loop L1
	
	L3:
	ret
ExecuteCommand endp

displayMenu proc uses EAX EDX
	mov EDX, OFFSET Xmsg
	call WriteString
	movzx EAX, x
	call WriteBinB
	call CRLF

	mov EDX, OFFSET Ymsg
	call WriteString
	movzx EAX, y
	call WriteBinB
	call CRLF

	mov EDX, OFFSET MenuMsg
	call WriteString
	call CRLF
	ret
displayMenu endp

ObtainCommand proc uses EAX EDX ESI
	reset:
	mov EDX, OFFSET prompt
	call WriteString
	call ReadChar

	cmp AL, '1'
	JL ERROR				;Jmp to error set
	cmp AL, '5'
	JG ERROR

	mov [ESI],AL
	ret
	
	ERROR:
		mov EDX, OFFSET ERRORmsg
		call WriteString
		call CRLF
		jmp reset			;Resets the area
ObtainCommand endp

TakeHexIntInput proc uses ESI EDI
	mov EDX, OFFSET GetterMsg
	call WriteString
	mov EDX, OFFSET Xmsg
	call WriteString
	call ReadHex
	mov [ESI], EAX

	mov EDX, OFFSET GetterMsg
	call WriteString
	mov EDX, OFFSET Ymsg
	call WriteString
	call ReadHex
	mov [EDI], EAX
	ret
TakeHexIntInput endp

AND_process proc uses EAX ESI EDI			;ESI: X | EDI: Y
	call TakeHexIntInput

	mov EAX, [ESI]
	AND EAX, [EDI]
	mov [ESI],EAX
	ret
AND_process endp

OR_process proc uses EAX ESI EDI			;ESI: X | EDI: Y
	call TakeHexIntInput

	mov EAX, [ESI]
	OR EAX, [EDI]
	mov [ESI], EAX
	ret
OR_process endp

NOT_process proc uses ESI				;ESI: X 
	call TakeHexIntInput
	mov EAX, [ESI]
	NOT EAX
	mov [ESI], EAX
	ret
NOT_process endp

XOR_process proc uses ESI EDI			;ESI: X | EDI: Y
	call TakeHexIntInput
	mov EAX, [ESI]
	XOR EAX, [EDI]
	mov [ESI], EAX
	ret
XOR_process endp

EXIT_process proc
	invoke ExitProcess,0
EXIT_process endp

end main