.model   small
.stack   100
.data         
space dw ' '
vowels db 'EYUIOAeyuioa' ;12
s_text db 'Input text:', 13, 10, '$'
s_text_output db 'Your text without words which starts with consonant:', 13, 10, '$'
s_new_line db 13, 10, '$'
s_end_of_line db '$'
it_space db 0
it_vowel db 0
length_of_string db (?)
start_point dw (?)
bool db 1
source db 255 dup(?)
dest db 255 dup(?)

.code 
	assume ds:@data,es:@data

;input:  al - maximum length
;output: al - length of input string
;		 dx - adress of string
input_str Proc
    push cx
    mov cx, ax 
    mov ah, 0Ah 
    mov [source], al 	
    mov byte[source+1], 0 
    lea dx, source
    int 21h     
    mov al, [source+1]  ; length of string
    add dx, 2 			; adress of string
    mov ah, ch
    pop cx
    ret
input_str EndP


;input: dx - adress of string
;output: void
print_str Proc
	push ax
	mov ah, 09h
	int 21h
	pop ax
	ret
print_str EndP


main:
	mov ax, @data    
	mov ds, ax

	mov es, ax
	cld

	lea dx, s_text
	call print_str

	mov al, 255
	call input_str
	
	mov si, dx

	lea di, dest

	mov length_of_string, al
	mov start_point, si

	
	mov it_space, 1
l1:	
	mov bl, [si]
	cmp bl, ' '
	jne l2	
	mov it_space, 1
	inc si
	jmp l1
l2:
	push di
	cmp it_space, 1
	jne l3

	mov al, [si]
	lea di, vowels
	mov cx, 12
	
	repne scas vowels
		je found
	
	mov it_vowel, 0
	jmp l3

found:
	mov it_vowel, 1

l3:
	pop di
	cmp bool, 1
	mov bool, 0
	je not_new_word
	cmp it_space, 1
	jne not_new_word
	dec si
	movs dest, source

not_new_word:
	mov it_space, 0
	cmp it_vowel, 1
	jne not_vowel
	movs dest, source
	mov ax, si
	sub ax, start_point
	cmp al, length_of_string
	jnge l1
	jmp exit_from_loop

not_vowel:
	inc si
	mov ax, si
	sub ax, start_point
	cmp al, length_of_string
	jnge l1
	jmp exit_from_loop

exit_from_loop:
	lea si, s_end_of_line
	movs dest, s_end_of_line
	
	lea dx, s_new_line
	call print_str
	
	lea dx, s_text_output
	call print_str

	lea dx, dest
	call print_str

exit:
	mov     ax,4c00h    
	int     21h   
end main