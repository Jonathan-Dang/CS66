INCLUDE Irvine32.inc

DECIMAL_OFFSET = 5
.data
decimal_one BYTE "100123456",0
.code
main proc

	mov EBX, DECIMAL_OFFSET
	mov ECX, LENGTHOF decimal_one 
	mov EDX, OFFSET decimal_one
	call WriteScaled
	
	invoke ExitProcess,0
main endp

;=======================================================
;WriteScaled
;EBX: Decimal Offset
;EDX: Number's Offset
;ECX: Number's Length
;=======================================================
WriteScaled proc uses EAX EBX ECX EDX
	push ECX
	sub ECX, EBX
	mov EBX, ECX
	pop ECX
	mov ESI, 0
	dec EBX
	L1:
		.IF (ESI == EBX)
			mov AL, '.'
			call WriteChar
		.ENDIF
		mov AL, [EDX]
		call WriteChar
		add EDX, TYPE decimal_one
		inc ESI
		loop L1
		call CRLF
	ret
WriteScaled endp

end main