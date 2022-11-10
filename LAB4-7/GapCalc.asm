.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword
DumpRegs PROTO

.data
	arr DWORD 0, 2, 5, 9, 10
	sum DWORD 0
.code
main proc
	mov ESI, OFFSET arr			;Setting Address of array
	mov ECX, LENGTHOF arr - 1	;Loop Iterations
	L1:
		mov EAX, [ESI + TYPE arr]
		sub EAX, [ESI]

		add sum, EAX
		add ESI, TYPE arr
		loop L1

	mov EAX, sum				;Display sum of distances

	call DumpRegs
	invoke ExitProcess,0
main endp
end main