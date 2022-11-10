INCLUDE Irvine32.inc

.data
numbers DWORD 87654321h, 45346894h, 193492h, 123h, 3h
buffer BYTE 8 DUP(1), 0

.code
main PROC

   mov ECX, LENGTHOF numbers 
   mov ESI, OFFSET numbers
L1:
   mov EDX, OFFSET buffer
   mov EAX, [ESI]

   call PackedToAsc

   mov EDX, OFFSET buffer
   call WriteString
   call CRLF

   add ESI, TYPE DWORD
   loop L1

main ENDP

;----------------------------------------------------------------
; PackedToAsc
; EAX: packed decimal number
; EDX: pointer to buffer with ASCII | RETURN REGISTER
;------------------------------------------------------------------
PackedToAsc proc uses ECX ESI
   add EDX, 7
   mov ECX, 8

L2:  
   mov EBX, EAX
   and EBX, 0fh
   add EBX, 30h
   mov [EDX], bl
   dec EDX
   shr EAX, 4
   loop L2

   ret

PackedToAsc ENDP


END main