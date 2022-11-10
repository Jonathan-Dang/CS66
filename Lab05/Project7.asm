;7. Random Screen Locations
;Write a program that displays a single character at 100 random screen locations, using a timing
;delay of 100 milliseconds. Hint: Use the GetMaxXY procedure to determine the current size of
;the console window.

INCLUDE Irvine32.inc

.data
	AMOUNT = 100
	randomChar BYTE 'x',0

	rows BYTE ?
	cols BYTE ?
	RandRow BYTE ?
	RandCol BYTE ?
.code
main proc

	mov EAX, 0
	mov EBX, 0
	mov ECX, 0
	mov EDX, 0
	call GetMaxXY

	mov rows, AL
	mov cols, DL

	mov ECX, AMOUNT
	L1:
		movzx EAX, rows
		call RandomRange
		mov RandRow, AL
		movzx EAX, cols
		call RandomRange
		mov RandCol, AL

		mov DH, RandRow
		mov DL, RandCol
		call Gotoxy
		
		mov EDX, OFFSET randomChar
		mov EAX, AMOUNT
		call WriteString
		call delay
		loop L1

	invoke ExitProcess,0
main endp
end main