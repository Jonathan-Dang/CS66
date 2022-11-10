.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword
DumpRegs PROTO

.code
main proc
	mov ECX, 6			;First 7 Fibonachi 
	mov EBX, 0			;First fib
	mov EDX, 1			;Second fib

	L1:
		mov EAX, EBX
		add EAX, EDX
		
		mov EBX, EDX
		mov EDX, EAX
		loop L1

	call DumpRegs
	

	invoke ExitProcess,0
main endp
end main