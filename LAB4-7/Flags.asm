.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword
DumpRegs PROTO


.code
main proc
	mov EAX, 0
	call DumpRegs
	
	;Carry Flag
	mov AX, 0FFFFh
	add AX, 1
	call DumpRegs

	mov AX, 0
	add AX, 3
	call DumpRegs

	;Parity Flag
	mov EAX, 0
	add EAX, 3
	call DumpRegs
	mov EAX, 0
	add EAX, 1
	call DumpRegs

	;Auxiliary Flag
	mov EAX, 0FFFFh
	add EAX, 1
	call DumpRegs
	add EAX, 1
	call DumpRegs

	;Zero Flag
	sub EAX, 10001h
	call DumpRegs
	add EAX, 1
	call DumpRegs

	;Sign Flag
	sub EAX, 2
	call DumpRegs
	add EAX, 3
	call DumpRegs

	;Overflow Flag
	mov AL, 127
	add AL, 127
	call DumpRegs
	add AL, 1
	call DumpRegs

	invoke ExitProcess,0
main endp
end main