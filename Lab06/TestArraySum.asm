; Testing the ArraySum procedure	(TestArraySum.asm)

include Irvine32.inc
.386
.model flat,stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:dword

.data
array dword 10000h,20000h,30000h,40000h,50000h
theSum dword ?
arrayWORD WORD 1000h, 2000h, 3000h, 4000h, 5000h

.code
main proc
	mov   esi,OFFSET arrayWORD 			; ESI points to array
	mov   ecx,LENGTHOF arrayWORD		; ECX = array count
	mov EBX, TYPE arrayWORD
	call  ArraySum2						; calculate the sum
	mov   theSum,eax					; returned in EAX
	call DumpRegs

	invoke ExitProcess,0
main endp
		
;-----------------------------------------------------
ArraySum proc
;
; Calculates the sum of an array of 32-bit integers.
; Receives: ESI = the array offset
; ECX = number of elements in the array
; Returns: EAX = sum of the array elements
;-----------------------------------------------------
	push  esi 				; save ESI, ECX
	push  ecx
	mov   eax,0				; set the sum to zero

L1:
	add   eax,[esi]			; add each integer to sum
	add   esi,TYPE DWORD	; point to next integer
	loop  L1				; repeat for array size
	pop   ecx				; restore ECX, ESI
	pop   esi
	ret 					; sum is in EAX
ArraySum endp

;-----------------------------------------------------
ArraySum2 proc uses esi ecx ebx
;
; Calculates the sum of an array of 32-bit integers.
; Receives: ESI = the array offset
; ECX = number of elements in the array
; EBX = type of the variable
; Returns: EAX = sum of the array elements
;-----------------------------------------------------
	mov   eax,0				; set the sum to zero

L1:
	add   eax,[esi]			; add each integer to sum
	add   esi, EBX			; point to next integer
	loop  L1				; repeat for array size
	ret 					; sum is in EAX
ArraySum2 endp


end main	