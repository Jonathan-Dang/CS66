include Irvine32.inc

;+------------------------------------------------------------------------------------------+
;|	HANGMAN																				   ;|
;|	BY: Jonathan Dang																	   ;|
;|	This is a proto-type of the game HANGMAN in MASM, Irvine32 x86 assembly				   ;|
;|	There is much room for optimizations but this is the 1 day version					   ;|
;|																						   ;|
;|	There will be inclusions from Chapter 8, Chapter 9, Chapter 10, and Chapter 15 from	   ;|
;|	the book "Irvine Kip R-Assembly language for x86 processors" by Pearson Langara College;|
;|																						   ;|
;+------------------------------------------------------------------------------------------+

.data
	numberOfEntries = 5
	TRUE = 1
	FALSE = 0

	;+----------------------------------------------------------------
	;|Visual
	;+----------------------------------------------------------------
	hangmanVisual BYTE "+-----+", 13, 10,
					   "|     |", 13, 10,
					   4 dup("|", 13, 10),
					   "+----------+", 13, 10,
					   "|          |", 13, 10,
					   "+----------+", 13, 10, 0

	;+----------------------------------------------------------------
	;|Msg Table
	;+----------------------------------------------------------------
	WrongMsg BYTE "No More Attempts!!!", 0
	GameOver BYTE "Game Over!", 13, 10, 0
	displayWord BYTE "The word was ",0
	Menu BYTE "Please Select a length of word from 3->8: ", 0
	ERROR_OOR_MSG BYTE "ERROR: Invalid Input!", 13, 10, 0
	InputMsg BYTE "Guess a letter: ", 0
	LetterGuessedList BYTE "Guessed Letters: ", 0
	ReplayMSG BYTE "Do you wanna play again ? (y/n): ", 0

	;+----------------------------------------------------------------
	;|Data and Storage
	;+----------------------------------------------------------------
	HangmanBuffer BYTE 29 dup (0)
	BufferPos BYTE 0
	winMsg BYTE "Winner!", 0
	CurrentWord BYTE 9 dup(0)
	attempts BYTE 6
	selection BYTE ?
	CoveredCurrent BYTE 9 dup(0)
	
	;--------------------------------------
	;Table for Selection of Word Lengths text docs
	;--------------------------------------
	WordDirectory BYTE 3
				  DWORD length3
				  BYTE 4
				  DWORD length4
				  BYTE 5
				  DWORD length5
				  BYTE 6
				  DWORD length6
				  BYTE 7
				  DWORD length7
				  BYTE 8
				  DWORD length8
	WordEntries = ($ - WordDirectory)
	NumberOfWordEntries = ($ - WordDirectory) / WordEntries

	File1 BYTE "Length3.txt", 0
	File2 BYTE "Length4.txt", 0
	File3 BYTE "Length5.txt", 0
	File4 BYTE "Length6.txt", 0
	File5 BYTE "Length7.txt", 0
	File6 BYTE "Length8.txt", 0

	FileWordBank = 20
	BUFFER_SIZE = 5000
	buffer BYTE BUFFER_SIZE DUP(?)
	bytesRead DWORD ?
	currentFileHandle HANDLE ?
	HasData BYTE 0

.code	
main proc
	playAgain:
	mov ESI, OFFSET selection
	call ObtainWord				;At this point, selection has been chosen from select range
	call Clrscr
	
	mov EDI, OFFSET CurrentWord
	mov EBX, OFFSET WordDirectory
	mov ECX, 6
	L1:
		cmp AL, [EBX]
		JNE	L2
		call NEAR PTR [EBX + 1]		;Uses selection to call relative function, Setting word
		jmp game
	L2:
		add EBX, 5
		loop L1
	Game:
		call HangMan
		call Reset
		call Replay
		cmp AL, TRUE
		JE playAgain
	Exit
main endp

Reset proc uses EAX EDX ECX EBX
	pushAD
	mov attempts, 6
	mov BufferPos, 0
	mov EAX, 0
	mov EDX, OFFSET HangmanBuffer
	mov EBX, OFFSET CoveredCurrent
	mov ECX, 29
	L1:
		mov [EDX], EAX
		mov [EBX], EAX
		inc EDX
		inc EBX
		loop L1
	popAD
	ret
Reset endp

;+---------------------------------------------------+
;|Runs the Game!!
;|EAX: Buffer
;|EDX: Buffer
;|EDI: The Word ptr
;|ECX: Length of the word
; ERROR: upon ret, crash
;+---------------------------------------------------+
HangMan proc
	mov EAX, 0
	mov EDX, OFFSET hangmanVisual
	call WriteString
	call CRLF
	call UpdateCovered
	call HiddenLetters

	inProgress:
		call ReadChar
		call CRLF

		call CheckBuffer				;Checks if the letter is guessed
		cmp BL, TRUE					;BL: 0 | 1
		JE inProgress

		movzx EBX, BufferPos
		mov HangmanBuffer[EBX], AL		;At this point, the letter is not in the buffer, Put it into the buffer
		inc BufferPos
		call ShowList

		mov EDI, OFFSET CurrentWord
		movzx ECX, selection
		cld								;Puts the process mode to Forwards
		REPNE scasb						;Scans the string in EDI for letter in AL, repeats if not found yet and not finished
		jnz notFound

		call HiddenLetters		

		;Check whether the characters in the buffer match all the unique characters in the word
		call CheckWin
		cmp EAX, TRUE
		JE Win
		JNE inProgress

	notFound:
		dec attempts
		cmp attempts, 0
		JNZ warningMsg
		JZ GameEnd
		jmp inProgress

	warningMsg:
		call DrawMan
		jmp inProgress

	Win:
		mov EDX, OFFSET winMsg
		call WriteString
		call CRLF
		ret

	GameEnd:
		call DrawMan
		mov EDX, OFFSET GameOver
		call WriteString
		call CRLF
		mov EDX, OFFSET displayWord
		call WriteString
		mov EDX, OFFSET CurrentWord
		call WriteString
		call CRLF
		ret
HangMan endp

Replay proc uses EDX
	mov EDX, OFFSET ReplayMSG
	call WriteString
	call ReadChar

	.IF (AL == 'y' || AL == 'Y')
		mov AL, TRUE
	.ELSE
		mov AL, FALSE
	.ENDIF
	ret
Replay endp

UpdateCovered proc uses EAX ESI
	movzx ECX, selection
	mov ESI, OFFSET CoveredCurrent
	mov AL, '-'
	L1:
		mov [ESI], AL
		inc ESI
		loop L1
	ret
UpdateCovered endp

ShowList proc uses EAX EDX ESI
	mov DH, 9
	mov DL, 0
	call GoToxy
	mov ESI, OFFSET HangmanBuffer
	movzx ECX, BufferPos
	L1:
		mov AL, [ESI]
		call WriteChar
		mov AL, ','
		call WriteChar
		inc ESI
		loop L1

	mov DH, 10
	call GoToxy
	ret
ShowList endp

;----------------------------------------------
;DrawMan draws the current state of the game
;Uses EDX and EAX for drawing purposes
;Coord system based on arrays: X, Y, X, Y
;headCoord BYTE 7, 3
;BodyCoord BYTE 7, 4
;LegsCoord BYTE 6, 5, 8, 5
;ArmCoord BYTE 6, 4, 8, 4
;----------------------------------------------
DrawMan proc uses EDX EAX
	.IF (attempts <= 5)
		;Head
		mov DH, 2
		mov DL, 6
		call GoToxy
		mov AL, 'O'
		call WriteChar
	.ENDIF

	.IF (attempts <= 4)
		;Torso
		mov DH, 3
		mov DL, 6
		call GoToxy
		mov AL, 0B1h
		call WriteChar
	.ENDIF

	.IF (attempts <= 3)
		;Left Arm
		mov DL, 5
		mov DH, 3
		call GoToxy
		mov AL, '/'
		call WriteChar
	.ENDIF

	.IF (attempts <= 2)
		;Right Arm
		mov DL, 7
		mov DH, 3
		call GoToxy
		mov AL, '\'
		call WriteChar
	.ENDIF
		
	.IF (attempts <= 1)
		;Left Leg
		mov DH, 4
		mov DL, 5
		call GoToxy
		mov AL, '/'
		call WriteChar
	.ENDIF
		
	.IF (attempts <= 0)
		;Right Leg
		mov DL, 7
		mov DH, 4
		call GoToxy
		mov AL, '\'
		call WriteChar
	.ENDIF
	mov DL, 0
	mov DH, 10
	call GoToxy
	ret
DrawMan endp

;We take the current letter from AL, then cross reference it when it is correct
;Run through both and replace the '-' character and then reprint
;Coordinate 7,1
HiddenLetters proc uses EBX ECX EDX EDI ESI
	mov DL, 1
	mov DH, 7
	call GoToxy
	mov EDI, OFFSET CurrentWord
	mov ESI, OFFSET CoveredCurrent
	movzx ECX, selection
	L1:
		mov BL, [EDI]
		cmp BL, AL
		JE fill
		inc EDI
		inc ESI
		loop L1
		jmp ENDPROC
		
	fill:
		mov [ESI], BL
		inc EDI
		inc ESI
		loop L1

	ENDPROC:
		mov EDX, OFFSET CoveredCurrent
		call WriteString

		mov DL, 0
		mov DH, 10
		call GoToxy
	ret
HiddenLetters endp

;+--------------------------------------------------------------------------+
;|Procedure checks for the winning state of Hangman
;|Uses the Buffer and cross references it with the word
;|Assumes both variables, CurrentWord and Buffer, are allocated and filled
;|EDI: The Word
;|EAX: TRUE: 1 FALSE: 0
;|EBX: Calculation Register
;|EDX: Buffer for Checking within Buffer
;|ECX: Buffer for loop
;+--------------------------------------------------------------------------+
CheckWin proc uses EBX EDX EDI ECX ESI
LOCAL counter:BYTE
	mov counter, 0
	mov EDI, OFFSET CurrentWord
	movzx ECX, selection

	WordLoop:
		push ECX
		mov AL, [EDI]		;Each Letter of the current word
		movzx ECX, BufferPos
		mov ESI, OFFSET HangmanBuffer
		BufferLoop:
			mov BL, [ESI]	;Each letter from the buffer
			cmp AL, BL
			JE foundLetter
			inc ESI
			loop BufferLoop
		pop ECX
		inc EDI
		loop WordLoop		;If it exits, we know that its not found!!
		jmp NotWinner

	foundLetter:
		pop ECX
		inc counter

		mov DL, selection
		cmp counter, DL

		JE Winner
		inc EDI
		loop WordLoop

	NotWinner:
		mov EAX, FALSE
		ret

	Winner:
		mov EAX, TRUE
		ret
CheckWin endp

;+---------------------------------------------------+
;|Checks the Buffer for letters already guessed [WIP]
;|BL: TRUE: 1 FALSE: 0 | True is Already Guessed
;|AL: The Char
;|ECX: Buffer
;|ESI: Buffer
;|HangmanBuffer: Has all the characters guessed so far
;+---------------------------------------------------+
CheckBuffer proc
	mov ECX, 27
	mov ESI, OFFSET HangmanBuffer
	L1:
		cmp AL, [ESI]
		JE Guessed
		inc ESI
		loop L1
	mov BL, FALSE
	ret

	Guessed:
		mov BL, TRUE
		ret
	ret
CheckBuffer endp

;+---------------------------------------------------+
;|Sets selection for word length
;|EAX: Buffer for calculations
;|EDX: Buffer for printing to screen
;|ESI: Ptr to selection variable
;+---------------------------------------------------+
ObtainWord proc uses EDX ESI			;ESI is a pointer for the selection variable
	resetp:					;Mark it for OOR error, then return to this position after | OTHER POSSIBLE: Recursion
	mov EAX, 0
	mov EDX, OFFSET Menu
	call WriteString
	call ReadChar
	call WriteChar			;Display the selection to the User
	call CRLF				;At this point, AL is set to the length of the word chosen writen as a char

	.IF (AL < '3') || (AL > '8')
		call ERROR_OOR
		jmp resetp
	.ELSEIF (AL == '3')
		mov AL, 3
		mov [ESI], AL
	.ELSEIF (AL == '4')
		mov AL, 4
		mov [ESI], AL
	.ELSEIF (AL == '5')
		mov AL, 5
		mov [ESI], AL
	.ELSEIF (AL == '6')
		mov AL, 6
		mov [ESI], AL
	.ELSEIF (AL == '7')
		mov AL, 7
		mov [ESI], AL
	.ELSEIF (AL == '8')
		mov AL, 8
		mov [ESI], AL
	.ELSE
	.ENDIF
	ret
ObtainWord endp

;+---------------------------------------------------+
;|Provides error message for selection out of range!
;|EDX: Buffer for printing to screen
;+---------------------------------------------------+
ERROR_OOR proc uses EDX				
	mov EDX, OFFSET ERROR_OOR_MSG
	call WriteString
	ret
ERROR_OOR endp

length3 proc uses EAX EBX ECX EDX, counter:DWORD
	;ensures new seed for word selection
	call Randomize
	;Clear all Registers | XOR on itself is faster than setting to 0
	XOR EAX, EAX
	XOR EBX, EBX
	XOR ECX, ECX
	XOR EDX, EDX

	mov EAX, FileWordBank
	call RandomRange
	inc EAX
	mov counter, EAX
	
	cmp hasData, 1
	JE hasDatajump

	mov EDX, OFFSET File1
	call OpenInputFile
	mov currentFileHandle, EAX

	cmp eax, INVALID_HANDLE_VALUE      ;error opening file?
    je ERROR

	mov edx, OFFSET buffer
	mov ecx, BUFFER_SIZE
	call ReadFromFile 
	JC ERROR

	mov bytesRead, EAX

	mov eax, currentFileHandle
    call CloseFile

	mov hasData, 1

	;At this point, I have the entire file word bank, How to choose one?
	hasDatajump:
	mov ECX, counter
	mov EDX, OFFSET buffer

	push EDX
	XOR EDX, EDX
	mov EAX, TYPE BYTE
	mov EBX, 4
	mul EBX
	mul ECX
	pop EDX
	add EDX, EAX

	mov ECX, 1
	mov EBX, OFFSET currentWord
	L1:
		mov EAX, [EDX]
		mov [EBX], EAX
		inc EDX
		inc EBX
		loop L1
	ret
	ERROR:
		call WriteWindowsMsg
		invoke ExitProcess, 1
length3 endp
	
length4 proc uses EAX ECX EDX, counter:DWORD
	call Randomize
;Clear all Registers | XOR on itself is faster than setting to 0
	XOR EAX, EAX
	XOR EBX, EBX
	XOR ECX, ECX
	XOR EDX, EDX

	mov EAX, FileWordBank
	call RandomRange
	inc EAX
	mov counter, EAX
	
	cmp hasData, 2
	JE hasDatajump

	mov EDX, OFFSET File2
	call OpenInputFile
	mov currentFileHandle, EAX

	cmp eax, INVALID_HANDLE_VALUE      ;error opening file?
    je ERROR

	mov edx, OFFSET buffer
	mov ecx, BUFFER_SIZE
	call ReadFromFile 
	JC ERROR

	mov bytesRead, EAX

	mov eax, currentFileHandle
    call CloseFile

	mov hasData, 2

	;At this point, I have the entire file word bank, How to choose one?
	hasDatajump:
	mov ECX, counter
	mov EDX, OFFSET buffer

	push EDX
	XOR EDX, EDX
	mov EAX, TYPE BYTE
	mov EBX, 5
	mul EBX
	mul ECX
	pop EDX
	add EDX, EAX

	mov ECX, 2
	mov EBX, OFFSET currentWord
	L1:
		mov EAX, [EDX]
		mov [EBX], EAX
		inc EDX
		inc EBX
		loop L1
	ret
	ERROR:
		call WriteWindowsMsg
		invoke ExitProcess, 1
length4 endp

length5 proc uses EAX ECX EDX, counter:DWORD
	call Randomize
	;Clear all Registers | XOR on itself is faster than setting to 0
	XOR EAX, EAX
	XOR EBX, EBX
	XOR ECX, ECX
	XOR EDX, EDX

	mov EAX, FileWordBank
	call RandomRange
	inc EAX
	mov counter, EAX
	
	cmp hasData, 3
	JE hasDatajump

	mov EDX, OFFSET File3
	call OpenInputFile
	mov currentFileHandle, EAX

	cmp eax, INVALID_HANDLE_VALUE      ;error opening file?
    je ERROR

	mov edx, OFFSET buffer
	mov ecx, BUFFER_SIZE
	call ReadFromFile 
	JC ERROR

	mov bytesRead, EAX

	mov eax, currentFileHandle
    call CloseFile

	mov hasData, 3

	;At this point, I have the entire file word bank, How to choose one?
	hasDatajump:
	mov ECX, counter
	mov EDX, OFFSET buffer

	push EDX
	XOR EDX, EDX

	mov EAX, TYPE BYTE
	mov EBX, 6
	mul EBX
	mul ECX

	pop EDX
	add EDX, EAX

	mov ECX, 3
	mov EBX, OFFSET currentWord
	L1:
		mov EAX, [EDX]
		mov [EBX], EAX
		inc EDX
		inc EBX
		loop L1
	ret
	ERROR:
		call WriteWindowsMsg
		invoke ExitProcess, 1
length5 endp

length6 proc uses EAX ECX EDX, counter:DWORD
	call Randomize
	;Clear all Registers | XOR on itself is faster than setting to 0
	XOR EAX, EAX
	XOR EBX, EBX
	XOR ECX, ECX
	XOR EDX, EDX

	mov EAX, FileWordBank
	call RandomRange
	inc EAX
	mov counter, EAX
	
	cmp hasData, 4
	JE hasDatajump

	mov EDX, OFFSET File4
	call OpenInputFile
	mov currentFileHandle, EAX

	cmp eax, INVALID_HANDLE_VALUE      ;error opening file?
    je ERROR

	mov edx, OFFSET buffer
	mov ecx, BUFFER_SIZE
	call ReadFromFile 
	JC ERROR

	mov bytesRead, EAX

	mov eax, currentFileHandle
    call CloseFile

	mov hasData, 4

	;At this point, I have the entire file word bank, How to choose one?
	hasDatajump:
	mov ECX, counter
	mov EDX, OFFSET buffer

	push EDX
	XOR EDX, EDX
	mov EAX, TYPE BYTE
	mov EBX, 7
	mul EBX
	mul ECX
	pop EDX
	add EDX, EAX
	dec EDX

	mov ECX, 4
	mov EBX, OFFSET currentWord
	L1:
		mov EAX, [EDX]
		mov [EBX], EAX
		inc EDX
		inc EBX
		loop L1
	ret
	ERROR:
		call WriteWindowsMsg
		invoke ExitProcess, 1
length6 endp

length7 proc uses EAX ECX EDX, counter:DWORD
	call Randomize
	;Clear all Registers | XOR on itself is faster than setting to 0
	XOR EAX, EAX
	XOR EBX, EBX
	XOR ECX, ECX
	XOR EDX, EDX

	mov EAX, FileWordBank
	call RandomRange
	inc EAX
	mov counter, EAX
	
	cmp hasData, 5
	JE hasDatajump

	mov EDX, OFFSET File5
	call OpenInputFile
	mov currentFileHandle, EAX

	cmp eax, INVALID_HANDLE_VALUE      ;error opening file?
    je ERROR

	mov edx, OFFSET buffer
	mov ecx, BUFFER_SIZE
	call ReadFromFile 
	JC ERROR

	mov bytesRead, EAX

	mov eax, currentFileHandle
    call CloseFile

	mov hasData, 5

	;At this point, I have the entire file word bank, How to choose one?
	hasDatajump:
	mov ECX, counter
	mov EDX, OFFSET buffer

	push EDX
	XOR EDX, EDX
	mov EAX, TYPE BYTE
	mov EBX, 8
	mul EBX
	mul ECX
	pop EDX
	add EDX, EAX

	mov ECX, 5
	mov EBX, OFFSET currentWord
	L1:
		mov EAX, [EDX]
		mov [EBX], EAX
		inc EDX
		inc EBX
		loop L1
	ret
	ERROR:
		call WriteWindowsMsg
		invoke ExitProcess, 1
length7 endp

length8 proc uses EAX ECX EDX, counter:DWORD
	call Randomize
	;Clear all Registers | XOR on itself is faster than setting to 0
	XOR EAX, EAX
	XOR EBX, EBX
	XOR ECX, ECX
	XOR EDX, EDX

	mov EAX, FileWordBank
	call RandomRange
	inc EAX
	mov counter, EAX
	
	cmp hasData, 6
	JE hasDatajump

	mov EDX, OFFSET File6
	call OpenInputFile
	mov currentFileHandle, EAX

	cmp eax, INVALID_HANDLE_VALUE      ;error opening file?
    je ERROR

	mov edx, OFFSET buffer
	mov ecx, BUFFER_SIZE
	call ReadFromFile 
	JC ERROR

	mov bytesRead, EAX

	mov eax, currentFileHandle
    call CloseFile

	mov hasData, 6

	;At this point, I have the entire file word bank, How to choose one?
	hasDatajump:
	mov ECX, counter
	mov EDX, OFFSET buffer

	push EDX
	XOR EDX, EDX
	mov EAX, TYPE BYTE
	mov EBX, 9
	mul EBX
	mul ECX
	pop EDX
	add EDX, EAX

	mov ECX, 6
	mov EBX, OFFSET currentWord
	L1:
		mov EAX, [EDX]
		mov [EBX], EAX
		inc EDX
		inc EBX
		loop L1
	ret
	ERROR:
		call WriteWindowsMsg
		invoke ExitProcess, 1
length8 endp

end main