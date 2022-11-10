;1. Draw Text Colors
;Write a program that displays the same string in four different colors, using a loop.
;Call the SetTextColor procedure from the book’s link library. Any colors may be chosen, but you may find
;it easiest to change the foreground color.

.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword
INCLUDE Irvine32.inc

.data
	string BYTE 'Testing',13,10,0
.code
main proc
	mov ECX, 4
	mov EDX, OFFSET string
	L1:
		mov EAX, ECX
		call SetTextColor
		call WriteString
		loop L1

	invoke ExitProcess,0
main endp
end main