include Irvine32.inc

.data
	TRUE = 1
	FALSE = 0

	EvenParity BYTE 10 dup(0FFh) 
    OddParity BYTE 9 dup(0FFh),0FBh,    ;array 10 bytes odd parity | Last value is 0FBh

	msg1 BYTE "Even Parity", 0
	msg2 BYTE "Odd Parity", 0
.code
main proc
	mov ECX, LENGTHOF EvenParity
	mov ESI, OFFSET EvenParity
	mov EBX, TYPE EvenParity
	call CheckParity
	call PrintParity


	mov ECX, LENGTHOF OddParity
	mov ESI, OFFSET OddParity
	mov EBX, TYPE OddParity
	call CheckParity
	call PrintParity

	invoke ExitProcess,0
main endp

PrintParity proc uses EAX EDX
	cmp EAX, TRUE
	JE TrueProc
	JNE FalseProc
	ret

	TrueProc:
		mov EDX, OFFSET msg1
		call WriteString
		call CRLF
		ret

	FalseProc:
		mov EDX, OFFSET msg2
		call WriteString
		call Crlf
		ret
PrintParity endp

CheckParity proc uses EBX ECX ESI			;Checks Parity Flag
	mov EAX, TRUE
	mov EBX, 0
	Loop1:
		mov BL, [ESI]
		XOR BL, 0
		JNP Odds
		inc ESI
		loop Loop1
	ret

	Odds:
		call SwapBools
		inc ESI
		loop Loop1

	ret
CheckParity endp

SwapBools proc		;Swaps EAX between True and False
	cmp EAX, TRUE
	JE turn
	JNE reverse
	ret

	reverse:
		mov EAX, TRUE
		ret

	turn:
		mov EAX, FALSE
		ret

SwapBools endp
end main