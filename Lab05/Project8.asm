;8. Color Matrix
;Write a program that displays a single character in all possible combinations of foreground and
;background colors (16  16  256). The colors are numbered from 0 to 15, so you can use a
;nested loop to generate all possible combinations.

INCLUDE Irvine32.inc
.data
	output BYTE 'TESTING',0
.code
main proc
	mov ECX, 16
	mov EDX, OFFSET output
	mov EAX, white
	L1:
		push ECX
		mov ECX, 16
		L2:
			push EAX
			push EDX
			mov EDX, 0
			mov EAX, ECX
			mov EBX, 16
			mul EBX

			XCHG EBX, EAX
			pop EDX
			pop EAX

			add EAX, EBX

			call SetTextColor
			call WriteString
			call CRLF
			loop L2
		pop ECX
		loop L1

	invoke ExitProcess,0
main endp
end main