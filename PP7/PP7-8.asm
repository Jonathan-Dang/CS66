INCLUDE Irvine32.inc

.data
	packed_1 WORD 4536h
	packed_2 WORD 7207h
	packed_3 WORD 3456h
	packed_4 WORD 7030h
	packed_5 DWORD 12345678h
	packed_6 DWORD 87654321h
	sum DWORD ?

.code
main PROC
	mov ESI, OFFSET packed_1
	mov EDI, OFFSET packed_2
	mov EDX, OFFSET sum
	mov ECX, 1
	call AddPacked
	call WriteHex
	call CRLF

	mov ESI, OFFSET packed_3
	mov EDI, OFFSET packed_4
	mov EDX, OFFSET sum
	mov ECX, 2
	call AddPacked
	call WriteHex
	call CRLF

	mov ESI, OFFSET packed_5
	mov EDI, OFFSET packed_6
	mov EDX, OFFSET sum
	mov ECX, 4
	call AddPacked
	call WriteHex
	call CRLF
	
	invoke ExitProcess,0
main ENDP

AddPacked proc uses ECX EDX ESI EDI
	mov sum, 0
	clc

	L1:
		mov AL, BYTE PTR [ESI]
		adc AL, BYTE PTR [EDI]
		daa
		mov BYTE PTR [EDX], AL
		inc ESI
		inc EDI
		inc EDX
		loop L1

	mov AL, 0
	adc AL, 0
	mov BYTE PTR [EDX], AL
	mov EAX, sum
	ret
AddPacked endp
END main