.model   small
.stack   100
.data         
r dw ?
s_divider db 'Input divider:', 13, 10, '$'
s_dividend db 'Input dividend:', 13, 10, '$'
s_expretion db 'Result of division:', 13, 10, '$'
s_error db 'Error! Your input is uncorrect! Repeat:', 13, 10, '$'
s_integer db 'Integer part: $'
s_new_line db 13, 10, '$'
s_remainder db 'Remainder: $'
buffer db 7 dup(?)

.code 

;input: number in ax
;output: display input number
print_dec Proc
	push ax
	push bx
	push cx
	push dx

	xor cx, cx
	mov bx, 10

pd_p1:
	xor dx, dx
	div bx
	add dl, '0'
	push dx
	inc cx
	test ax, ax
	jnz pd_p1
	
	mov ah, 02h
pd_p2:
	pop dx
	int 21h
	loop pd_p2

	pop ax
	pop bx
	pop cx
	pop dx
	ret
print_dec EndP


;input: al - maximum length
;output: al - length of input string
input_str Proc
    push cx
    mov cx, ax 
    mov ah, 0Ah 
    mov [buffer], al 
    mov byte[buffer+1], 0 
    lea dx, buffer   
    int 21h     
    mov al, [buffer+1]  ; length of string
    add dx, 2 			; adress of string
    mov ah, ch
    pop cx
    ret
input_str EndP

;input: al - length of string
;dx - adress of string
;output: ax- word
;cf = 1 - error
str_to_udec Proc
    push cx
    push dx
    push bx
    push si
    push di
 
    mov si,dx 
    mov di,10
    mov ch, 0  
    mov cl, al 
    jcxz studw_error
    xor ax,ax
    xor bx,bx
 
studw_lp:
    mov bl,[si]
    inc si
    cmp bl,'0'  
    jl studw_error  
    cmp bl,'9'
    jg studw_error
    sub bl,'0'
    mul di
    jc studw_error
    add ax,bx
    jc studw_error
    loop studw_lp
    jmp studw_exit 

studw_error:
    xor ax,ax
    stc   			;CF = 1
 
studw_exit:
    pop di
    pop si
    pop bx
    pop dx
    pop cx
    ret
str_to_udec EndP

print_str Proc
	push ax
	mov ah,09h
	int 21h
	pop ax
	ret
print_str EndP


main:
	mov ax, @data    
	mov ds, ax
	
	lea dx, s_divider
	call print_str
divider:
	mov al, 6
	call input_str
	call str_to_udec
	test ax, ax
	jz er1
	jnc dividend
er1:
	xor dx, dx
	xor ax, ax
	lea dx, s_error
	call print_str
	jmp divider


dividend:	
	
	mov bx, ax
	lea dx, s_new_line
	call print_str
	lea dx, s_dividend
	call print_str
	

er2:	
	mov al, 6
	call input_str
	call str_to_udec
	jnc division
	xor dx, dx
	xor ax,ax
	lea dx, s_error
	call print_str
	jmp er2

division:
	
	lea dx, s_new_line
	call print_str
	lea dx, s_expretion
	call print_str
	
	lea dx, s_integer
	call print_str
	

	xor dx, dx
	div bx
	mov r, dx
	call print_dec
	
	xor dx, dx
	lea dx, s_new_line
	call print_str
	lea dx, s_remainder
	call print_str
	mov ax,r
	call print_dec
	
	mov     ax,4c00h    
	int     21h   
end main