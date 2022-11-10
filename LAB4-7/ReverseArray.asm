.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

.data
	arr DWORD 1,2,3,4,5
.code
main proc
	mov ECX, LENGTHOF arr - 1
	mov ESI, OFFSET arr
	mov EDI, OFFSET arr

	pass:
		add EDI, TYPE arr		
		loop pass

	mov ECX, LENGTHOF arr - 1
	L1:
		mov EAX, [ESI]
		XCHG EAX, [EDI]
		mov [ESI], EAX

		add ESI, TYPE arr
		sub EDI, TYPE arr
		dec ECX
		loop L1

	mov ESI, OFFSET arr
	mov ECX, LENGTHOF arr
	L2:
		mov EAX, [ESI]
		add ESI, TYPE arr
		loop L2

	invoke ExitProcess,0
main endp
end main