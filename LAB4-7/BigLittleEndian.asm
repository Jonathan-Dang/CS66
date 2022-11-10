
.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword
DumpRegs PROTO

.data
	bigEndian BYTE 12h,34h,56h,78h
	littleEndian DWORD ?
.code
main proc
	mov AH, BYTE ptr [bigEndian + 1]
	mov AL, BYTE ptr [bigEndian]
	mov WORD ptr [littleEndian], AX

	mov AH, BYTE ptr [bigEndian + 3]
	mov AL, BYTE ptr [bigEndian + 2]
	mov WORD ptr [littleEndian + TYPE littleEndian / 2], AX	

	mov EAX, littleEndian
	call DumpRegs
	invoke ExitProcess,0
main endp
end main