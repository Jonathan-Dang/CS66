INCLUDE Irvine32.inc
BufSize = 128
.data

   key BYTE -2,4,1,0,-3,5,2,-4,-4,6
   prompt1 BYTE "Enter the data set1: ", 0
   prompt2 BYTE "Enter the data set2: : ", 0
   message1 BYTE "Original text: ", 0
   message2 BYTE "Encrypted text: ", 0
   Set1 BYTE BufSize DUP (?)
   Set2 BYTE BufSize DUP (?)

.code
main PROC
    ; Test 1st data set
    mov edx, OFFSET prompt1
    call WriteString  
    mov edx, OFFSET Set1   
    mov ecx, SIZEOF Set1  
    call ReadString           
    mov edx,OFFSET message1
    call WriteString     
    MOV ESI, OFFSET key     
    mov edx,OFFSET Set1   
    call WriteString        
    call crlf             
    call EcryptText              
    mov edx,OFFSET message2
    call WriteString             
    mov edx,OFFSET Set1
    call WriteString
    call Crlf

    ; Test 2nd data set
    mov edx, OFFSET prompt2
    call WriteString    
    mov edx, OFFSET Set2   
    mov ecx, SIZEOF Set2  
    call ReadString           
    mov edx,OFFSET message1
    call WriteString             
    MOV ESI, OFFSET key        
    mov edx,OFFSET Set2       
    call WriteString            
    call crlf                
    call EcryptText       
    mov edx,OFFSET message2
    call WriteString       
    mov edx,OFFSET Set2
    call WriteString   
    call Crlf    
    exit
main ENDP

EcryptText PROC
   PUSHAD
   mov edi,0
   rotateloop:
       mov al, [edx]           ; copy the byte of the text   into AL
       mov cl, [esi+edi]       ; copy the key into CL
       ror al,cl               ; if CL is positive ROR works as it is
                               ; otherwise, ROR works as ROL
       mov [edx],al           ; save back the encrypted character
       inc edx                   ; point the next character in the text
       inc edi                   ; increment the index to point the next
                               ; character in the key
       cmp edi, 10               ; if all keys are used, reset the index
       JNE continue           ; otherwise continue the loop
       mov edi,0               ; reset index to 0
   continue:
       mov bl,[edx]      
       cmp bl,0               ; cehck the current byte is null
       je endloop               ; if all bytes are encrypted, end the loop
       jmp rotateloop
   endloop:
   popad
   ret
EcryptText ENDP
END main