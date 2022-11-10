INCLUDE Irvine32.inc

.data
	counter DWORD 0
.code
main proc
	mov EAX, 0
	mov ECX, 20

	call recursive

	mov EAX, counter
	call WriteDec
	call CRLF
	invoke ExitProcess,0
main endp

recursive proc uses ECX
	cmp ECX, 0
	jz endFlag
	
	inc counter
	dec ECX
	call recursive
	
	endFlag:
		ret
recursive endp

end main