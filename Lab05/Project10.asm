;10. Fibonacci Generator
;Write a procedure that produces N values in the Fibonacci number series and stores them in an
;array of doubleword. Input parameters should be a pointer to an array of doubleword, a
;counter of the number of values to generate. Write a test program that calls your procedure,
;passing N = 47. The first value in the array will be 1, and the last value will be 2,971,215,073.
;Use the Visual Studio debugger to open and inspect the array contents.

INCLUDE Irvine32.inc

.data
	outputArr DWORD 1, 45 dup(0), 2971215073
.code	
main proc
	mov EAX, 0
	mov ECX, LENGTHOF outputArr
	mov ESI, OFFSET outputArr
	mov EDX, 0
	call FibGen
	
	mov EBX, 0
	mov ESI, OFFSET outputArr
	mov ECX, LENGTHOF outputArr
	Print:
		mov EAX, [ESI]
		call WriteDec
		call CRLF
		add ESI, TYPE outputArr
		loop Print

	call CRLF

	invoke ExitProcess,0
main endp

FibGen proc uses EAX EBX ECX ESI		;Assumes EAX & EDX is 0, Itterations: ECX
	mov EAX, 0
	mov EDX, 0
	L1:
		mov EBX, [ESI]
		add EAX, EBX
		add ESI, TYPE outputArr

		mov [ESI] , EAX
		XCHG EAX, EBX
		
		loop L1
	ret
FibGen endp
end main