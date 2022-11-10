;Suppose you are given three data items that indicate a starting index in a list, an array of characters, 
;and an array of link index. You are to write a program that traverses the links and locates the
;characters in their correct sequence. 
;For each character you locate, copy it to a new array. 
;Suppose you used the following sample data, and assumed the arrays use zero-based indexes:

;start = 1
;chars: H A C E B D F G
;links: 0 4 5 6 2 3 7 0

;Then the values copied (in order) to the output array would be A,B,C,D,E,F,G,H. Declare the
;character array as type BYTE, and to make the problem more interesting, declare the links array
;type DWORD.

INCLUDE Irvine32.inc

.data
	start DWORD 1							;Position of A
	chars BYTE 'H', 'A', 'C', 'E', 'B', 'D', 'F', 'G'
	links DWORD 0, 4, 5, 6, 2, 3, 7, 0
	output BYTE SIZEOF chars dup(?)			;Should be 8 spaces
	debug BYTE 13,10,0
.code
main proc
	mov ECX, SIZEOF chars
	mov ESI, OFFSET output
	mov EDI, OFFSET links

	L1:
		mov EDX, start
		mov EAX, [EDI + TYPE links * EDX]	;Link Index saved in EAX

		movzx EBX, chars[TYPE chars * EDX]
		mov [ESI], EBX

		mov start, EAX
		add ESI, TYPE output
			loop L1

	mov EDX, OFFSET output
	call WriteString

	invoke ExitProcess,0
main endp
end main