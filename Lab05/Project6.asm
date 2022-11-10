;6. Random Strings
;Create a procedure that generates a random string of length L, containing all capital letters.
;When calling the procedure, pass the value of L in EAX, and pass a pointer to an array of byte
;that will hold the random string. Write a test program that calls your procedure 20 times and displays the strings in the console window. 

INCLUDE Irvine32.inc

.data
	output BYTE ?
.code
main proc
	; write your code here
	mov EAX, 7
	mov ECX, 20
	mov ESI, OFFSET output

	L1:
		call RandomString
		mov EDX, OFFSET output
		call WriteString
		call CRLF
		loop L1

	invoke ExitProcess,0
main endp

RandomString proc uses EAX ECX EBX			;Uses EAX as length | Uses ESI as pointer to an array of BYTE

	mov ECX, EAX
	mov EBX, 0
	LengthLoop:
		mov EAX, 26
		call RandomRange
		add EAX, 'A'
		mov [ESI + EBX], EAX
		inc EBX
		loop LengthLoop
	ret
RandomString endp

end main