; Encryption Program (Encrypt.asm)
INCLUDE Irvine32.inc

BUFMAX = 128 ; maximum buffer size
.data
	KEY BYTE "ABXmv#7",0 ; any value between 1-255
	sPrompt BYTE "Enter the plain text:",0
	sEncrypt BYTE "Cipher text: ",0
	sDecrypt BYTE "Decrypted: ",0
	buffer BYTE BUFMAX+1 DUP(0)
	bufSize DWORD ?
.code
	main PROC
	call InputTheString ; input the plain text
	call TranslateBuffer ; encrypt the buffer
	mov edx,OFFSET sEncrypt ; display encrypted message
	call DisplayMessage
	call TranslateBuffer ; decrypt the buffer
	mov edx,OFFSET sDecrypt ; display decrypted message
	call DisplayMessage
	exit
main ENDP
;-----------------------------------------------------
InputTheString PROC
;
; Prompts user for a plaintext string. Saves the string
; and its length.
; Receives: nothing
; Returns: nothing
;-----------------------------------------------------
	pushad ; save 32-bit registers
	mov edx,OFFSET sPrompt ; display a prompt
	call WriteString
	mov ecx,BUFMAX ; maximum character count
	mov edx,OFFSET buffer ; point to the buffer
	call ReadString ; input the string
	mov bufSize,eax ; save the length
	call Crlf
	popad
	ret
InputTheString ENDP
;-----------------------------------------------------
DisplayMessage PROC
;
; Displays the encrypted or decrypted message.
; Receives: EDX points to the message
; Returns: nothing
;-----------------------------------------------------
	pushad
	call WriteString
	mov edx,OFFSET buffer ; display the buffer
	call WriteString
	call Crlf
	call Crlf
	popad
	ret
DisplayMessage ENDP
;-----------------------------------------------------
TranslateBuffer PROC
;
; Translates the string by exclusive-ORing each
; byte with the encryption key byte.
; Receives: nothing
; Returns: nothing
;-----------------------------------------------------
	pushad
	mov ecx,bufSize ; loop counter
	mov esi,0 ; index 0 in buffer
	mov EDI, 0
	L1:	
		cmp KEY[EDI], 0			
		JNE pass
		mov EDI,0		;No Use in generating more space, infinitely long Raw Text will overload with infinitely long key
	pass:
		mov AL, KEY[EDI]
		xor buffer[esi], AL ; translate a byte
		inc esi ; point to next byte
		inc EDI
		loop L1
	popad
	ret
TranslateBuffer ENDP
END main