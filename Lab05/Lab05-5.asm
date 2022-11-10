
INCLUDE Irvine32.inc

.data
.code

main proc
	mov AL, -5
	sub AL, +125	;Overflow flag ON
	pushFD
	
	mov AL, 0
	sub AL, 2		;Carry Flag ON
	pushFD

	add AL, 2		;Zero Flag ON
	pushFD

	popFD
	popFD
	popFD
	
	invoke ExitProcess,0
main endp

end main

;Observation: The flags actually go into registers EIP and ESP while any flag activity would be recorded within EFL.
;Poping the stack would result in only changed to the flags rather than the registers itself