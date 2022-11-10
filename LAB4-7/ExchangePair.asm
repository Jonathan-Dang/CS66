.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

.data
	arr DWORD 1,2,3,4
.code
main proc
	mov ECX, LENGTHOF arr / 2 
	mov ESI, OFFSET arr
	L1:
		mov EAX, [ESI]
		XCHG EAX, [ESI + TYPE arr]
		mov [ESI], EAX

		add esi, TYPE arr
		add esi, TYPE arr
		loop L1

	;Checking for corrections
	mov ECX, LENGTHOF arr
	mov ESI, OFFSET arr
	L2:
		mov EAX, [ESI]
		add ESI, TYPE arr
		loop L2

	invoke ExitProcess,0
main endp
end main	