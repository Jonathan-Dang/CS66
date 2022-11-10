include Irvine32.inc

.data
	;White: 30% 0-2, Blue: 10% 3, Green: 60% 4-9
	sample BYTE "This is a sample String!",0
.code
main proc
	mov ECX, 20
	mov EDX, OFFSET sample

	L1:
		mov EAX, 10
		call RandomRange
		call InterpretColorPick
		call WriteDec
		mov AL, ' '
		call WriteChar
		call WriteString
		call CRLF
		loop L1
	
	invoke ExitProcess,0
main endp

InterpretColorPick proc uses EAX
	.IF EAX >=0 && EAX <= 2
		jmp WhiteStatement
	.ELSEIF EAX == 3
		jmp BlueStatement
	.ELSEIF EAX >= 4 && EAX <= 9
		jmp GreenStatement
	.ELSE
		jmp EX
	.ENDIF

	WhiteStatement:
		mov EAX, WHITE
		jmp EX

	GreenStatement:
		mov EAX, GREEN
		jmp EX

	BlueStatement:
		mov EAX, BLUE
		jmp EX

	EX:
		call SetTextColor
		ret
InterpretColorPick endp
end main	