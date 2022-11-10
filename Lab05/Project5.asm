;5. BetterRandomRange Procedure
;The RandomRange procedure from the Irvine32 library generates a pseudorandom integer between
;0 and N - 1. Your task is to create an improved version that generates an integer between M and
;N-1. Let the caller pass M in EBX and N in EAX. If we call the procedure BetterRandomRange, the
;following code is a sample test:

;mov ebx,-300 ; lower bound
;mov eax,100 ; upper bound
;call BetterRandomRange

;Write a short test program that calls BetterRandomRange from a loop that repeats 50 times.
;Display each randomly generated value.

INCLUDE Irvine32.inc

.data
.code
main proc
	mov EAX, 100
	mov EBX, -300
	mov ECX, 50

	L1:
		call BetterRandomRange
		loop L1

	invoke ExitProcess,0
main endp

BetterRandomRange proc uses EAX EBX ECX			;Takes EAX as upper and EBX as lower and ECX as a buffer
	mov ECX, EAX
	sub EAX, EBX			;Gets total range
	call RandomRange		;Uses EAX as a param

	sub EAX, ECX
	call WriteInt
	call Crlf
	ret
BetterRandomRange endp

end main