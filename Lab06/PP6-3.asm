include Irvine32.inc

.data
	scores DWORD 5 dup(?)
	grades BYTE 5 dup(?)

	string1 BYTE "Score: ",0
	string2 BYTE "Grade: ",0
.code
main proc
	
	mov ESI, OFFSET scores
	mov EDI, OFFSET grades
	mov ECX, LENGTHOF scores
	push ESI
	push EDI
	push ECX
	
	randomScore:
		mov EAX, 101
		call RandomRange
		mov [ESI], EAX
		call CalcGrade
		mov [EDI], AL

		add ESI, TYPE scores
		add EDI, TYPE grades
		loop randomScore

	mov ESI, OFFSET scores
	mov EDI, OFFSET grades
	mov ECX, LENGTHOF scores
	print:
		mov EDX, OFFSET string1
		call WriteString
		mov EAX, [ESI]
		call WriteDec
		mov AL, ' '
		call WriteChar

		mov EDX, OFFSET string2
		call WriteString
		mov EAX, 0
		mov AL, [EDI]
		call WriteChar
		call CRLF

		add ESI, TYPE scores
		add EDI, TYPE grades
		loop print
		

	invoke ExitProcess,0
main endp

CalcGrade proc 
	cmp EAX, 90
	JG A
	JE A
	cmp EAX, 80
	JG B
	JE B
	cmp EAX, 70
	JG Ce
	JE Ce
	cmp EAX, 60
	JG D
	JE D
	jmp F

	A:
		mov AL, 'A'
		ret
	B:
		mov AL, 'B'
		ret
	Ce:
		mov AL, 'C'
		ret
	D:
		mov AL, 'D'
		ret
	F:
		mov AL, 'F'
		ret

	ret
CalcGrade endp
end main