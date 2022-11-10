.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword
WriteString PROTO

.data
	source BYTE "This is the source string",0
    spacer BYTE " | ",0
	target BYTE SIZEOF source DUP('#')
.code
main proc
    mov ESI, 0
    mov EDI, LENGTHOF source - 2
    mov ECX, LENGTHOF source

    L1:
        mov AL, source[ESI]
        mov target[EDI], AL
        inc ESI
        dec EDI
        loop L1

    mov EDX, OFFSET source  
    call WriteString
    mov EDX, OFFSET spacer
    call WriteString
    mov EDX, OFFSET target     
    call WriteString

	invoke ExitProcess,0
main endp
end main