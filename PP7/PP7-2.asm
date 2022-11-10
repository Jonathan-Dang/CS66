Include Irvine32.inc

.data
	num1 QWORD 0A132453FFFFFFFFFh
	num2 QWORD 1111111111111111h
	difference QWORD 1 DUP(0)
	_Dwords = SIZEOF num1 / TYPE DWORD
.code

main proc
	mov ESI, OFFSET num1
	mov EDI, OFFSET num2
	mov EBX, OFFSET difference
	mov ECX, _Dwords	
	call Extended_Sub

	mov ESI, OFFSET difference
	add ESI, _Dwords * 4
	mov ECX, _Dwords

	L1: 
		sub ESI, TYPE DWORD
		mov EAX, [ESI]
		call WriteHex
		loop L1
		
	call CRLF
	invoke ExitProcess,0
main endp

;===================================
;Extended_Sub
;ESI: Num 1 - QWORD
;EDI: Num 2 - QWORD
;EBX: Local Variable output - QWORD
;ECX: amount of DWORD translations from QWORD
;===================================
Extended_Sub proc
	pushad
	clc

	L1:
		mov EAX, [ESI]
		SBB EAX, [EDI]
		pushfd
		mov [EBX], EAX
		add ESI, TYPE DWORD
		add EDI, TYPE DWORD
		add EBX, TYPE DWORD

		popfd
		loop L1

		SBB WORD ptr [EBX], 0
		popad
		ret
	
	ret
Extended_Sub endp

end main