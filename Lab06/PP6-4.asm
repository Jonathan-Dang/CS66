;4. College Registration
;Using the College Registration example from Section 6.7.3 as a starting point, do the following:
;• Recode the logic using CMP and conditional jump instructions (instead of the .IF and
;.ELSEIF directives).
;• Perform range checking on the credits value; it cannot be less than 1 or greater than 30. If an
;invalid entry is discovered, display an appropriate error message.
;• Prompt the user for the grade average and credits values.
;• Display a message that shows the outcome of the evaluation, such as “The student can register” or “The student cannot register”.
;(The Irvine32 library is required for this solution program.)


include Irvine32.inc

.data
TRUE = 1
FALSE = 0
gradeAverage WORD 275 ; test value
credits WORD 12 ; test value
OkToRegister BYTE ?

errorMsgCreditsOOR BYTE "ERROR: Credits Out of Range!",0
gradeAverageMsg BYTE "Please input the grade average: ",0
creditsMsg BYTE "Please input the credit value: ",0
accept BYTE "The student can register",0
denied BYTE "The student cannot register",0

.code
main proc
	mov OkToRegister, FALSE

	mov EDX, OFFSET gradeAverageMsg
	call WriteString
	call ReadDec
	mov gradeAverage, AX
	
	mov EDX, OFFSET creditsMsg
	call WriteString
	call ReadDec
	mov credits, AX

	cmp credits, 1
	JL ERROR_COOR
	cmp credits, 30
	JG ERROR_COOR

	cmp gradeAverage, 350
	JG executeDef

	cmp gradeAverage, 250
	JG secondThing

	cmp credits, 12
	JE executeDef
	Jl executeDef
	jmp endJump

	secondThing:
		cmp credits, 16
		JE executeDef
		JL executeDef
		jmp endJump

	executeDef:
		mov OkToRegister, TRUE
		jmp endJump


	ERROR_COOR:
		mov EDX, OFFSET errorMsgCreditsOOR
		call WriteString
		call CRLF
		invoke ExitProcess,0

	endJump:
		cmp OkToRegister, FALSE
		JE deniedRegister
		JG acceptedRegister
		jmp failure

	deniedRegister:
		mov EDX, OFFSET denied
		jmp print

	acceptedRegister:
		mov EDX, OFFSET accept
		jmp print

	print:
		call WriteString
		call CRLF

	failure:
	invoke ExitProcess,0
main endp

end main