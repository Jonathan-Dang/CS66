;3. Simple Addition (1)
;Write a program that clears the screen, locates the cursor near the middle of the screen, prompts
;the user for two integers, adds the integers, and displays their sum.

;4. Simple Addition (2)
;Use the solution program from the preceding exercise as a starting point. Let this new program
;repeat the same steps three times, using a loop. Clear the screen after each loop iteration

INCLUDE Irvine32.inc

.data
	msg1 BYTE 'Input the 1st integer: ',0
	msg2 BYTE 'Input the 2nd integer: ',0
	outputmsg BYTE 'SUM: ',0

	num1 SDWORD ?
	num2 SDWORD ?
	sum SDWORD ?

.code
main PROC
	mov EAX, 0
	mov EDX, 0
	mov ECX, 3

	L1:
	call Clrscr
	
	mov DH, 13
	mov DL, 39

	call Gotoxy				;uses values at DH and DL, Y and X respective
	mov EDX, OFFSET msg1
	call WriteString
	call ReadInt
	mov num1, EAX

	mov DH, 14
	mov DL, 39
	call Gotoxy

	mov EDX, OFFSET msg2
	call WriteString
	call ReadInt
	mov num2, EAX

	mov EAX, num1
	add EAX, num2
	mov sum, EAX

	mov DH, 15
	mov DL, 39
	call Gotoxy

	mov edx, OFFSET outputmsg
	call WriteString
	mov EAX, sum
	call WriteInt

	mov DH, 16
	mov DL, 39
	call Gotoxy
	call WaitMsg
		loop L1

	INVOKE ExitProcess, 0
main endp
end main