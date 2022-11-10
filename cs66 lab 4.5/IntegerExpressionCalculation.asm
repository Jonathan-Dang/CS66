.386
.model flat,stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD
DumpRegs PROTO

.data
A BYTE 10
B BYTE 19
varC BYTE 20
D BYTE 5

.code
main PROC

;(A + B)
mov EAX, A
add EAX, B

;(C + D)
mov EBX, varC
add EBX, D

;(A+B) - (C+D)
mov ECX, EAX
sub ECX, EBX

;ECX = (A + B) - (C + D)

call DumpRegs
INVOKE ExitProcess,0
main ENDP
END main