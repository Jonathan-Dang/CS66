;11. Finding Multiples of K
;In a byte array of size N, write a procedure that finds all multiples of K that are less than N. Initialize the array to all zeros at the beginning of the program, and then whenever a multiple is
;found, set the corresponding array element to 1. Your procedure must save and restore any registers it modifies. Call your procedure twice, with K = 2, and again with K = 3. Let N equal to 50.
;Run your program in the debugger and verify that the array values were set correctly. Note: This
;procedure can be a useful tool when finding prime integers. An efficient algorithm for finding
;prime numbers is known as the Sieve of Eratosthenes. You will be able to implement this algorithm when conditional statements are covered in Chapter 6.

INCLUDE Irvine32.inc

.data
	arr BYTE 51 dup(0)
.code
main proc

	mov EBX, 2
	call FactorFinder
	mov ECX, SIZEOF arr
	mov EBX, 0
	
	Print:
		movzx EAX, arr[EBX]
		call WriteDec
		inc EBX
		loop Print

	mov EBX, 3
	call ResetArr
	call FactorFinder
	call CRLF
	mov ECX, SIZEOF arr
	mov EBX, 0
	
	Print2:
		movzx EAX, arr[EBX]
		call WriteDec
		inc EBX
		loop Print2

main endp

ResetArr proc uses EAX ECX
	mov ECX, LENGTHOF arr
	mov EAX, 0
	Reset:
		mov arr[EAX], 0
		inc EAX
		loop Reset
	ret
ResetArr endp

FactorFinder proc uses EAX ESI EBX EDX		;EBX is K
	mov ECX, LENGTHOF arr
	mov EAX, 0
	L1:
		push EAX
		mov EDX, 0
		div EBX
		pop EAX
		cmp EDX, 0
		jz L2
		add EAX, 1
		loop L1

	L2:
		mov arr[EAX], 1
		add EAX, 1

		cmp ECX, 0
		jz L3
		loop L1

		L3:
			ret
FactorFinder endp

end main