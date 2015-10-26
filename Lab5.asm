.model   small
.stack   100
.data
s_error db 'Error! Your input is uncorrect! Repeat:', 13, 10, '$'
s_rows db 'Input ammount of rows:$'
s_columns db 'Input ammount of columns:$'
s_input db 'Input your matrix:$'
s_matrix db 'Your matrix:', 13, 10, '$'
s_number db 'Input number and set to zero all elements that greater than this number:$'
s_space db ' $'
s_newline db 13, 10, '$'
max_length db (?)
length db (?)
number dw (?)
mas dw 255 dup(?)
rows db (?)
columns dw (?)
el_size = 2
source db 255 dup(?)
.code
assume ds:@data,es:@data

;input: number in ax
;output: display input number
;		 length = length of number
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
	
	mov length, cl
	mov ah, 02h
pd_p2:
	pop dx
	int 21h
	loop pd_p2

	pop dx
	pop cx
	pop bx
	pop ax
	ret
print_dec EndP

;input - number in ax
;output - length of number in bx
find_length Proc
	push ax
	push cx
	push dx
	
	xor cx, cx
    mov bx, 10
    fl:
    	xor dx, dx
		div bx
		inc cx
		test ax, ax
	jnz fl
	mov bx, cx

	pop dx
	pop cx
	pop ax
	ret
find_length EndP

;input: dx - pointer on column
;output: max_length - maximum length of number in column
find_max_length Proc
	push si
	push dx
	push cx
	push bx
	xor cx, cx
	xor bx, bx
	lea si, mas
	mov ax, mas[si]
	call find_length
	mov max_length, bl
	mov cl, rows
	find:
		add si, columns
		mov ax, mas[si]
		call find_length
		cmp bl, max_length
		jle lower
		mov max_length, bl
		lower:
	loop find
	push bx
	push cx
	push dx
	push si
	ret
find_max_length EndP

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
    stc   			;CF = 1
 
studw_exit:
    pop di
    pop si
    pop bx
    pop dx
    pop cx
    ret
str_to_udec EndP

;input: dx - adress of string
;output: void
print_str Proc
	push ax
	mov ah, 09h
	int 21h
	pop ax
	ret
print_str EndP

;output number in ax
input_number Proc
p1:
	mov al, 6 
	call input_str
	call str_to_udec
	jc er
	jmp inp_num_exit
er: 
	lea dx, s_error
	call print_str
	jmp p1
inp_num_exit:
	lea dx, s_newline
	call print_str
	ret
input_number EndP

main:
	mov ax, @data    
	mov ds, ax
	mov es, ax

	lea dx, s_rows
	call print_str
	call input_number
	mov rows, al

	lea dx, s_columns
	call print_str
	call input_number
	mov columns, ax

	lea dx, s_input
	call print_str

	xor cx, cx
	xor si, si
	xor ax, ax
	cld
	lea di, mas
	mov cl, rows

cycle_rows:
	push cx
	mov cx, columns
	cycle_columns:
		call input_number
		stos mas
	loop cycle_columns
	pop cx
loop cycle_rows
	
	lea dx, s_matrix
	call print_str
	
	lea si, mas
	xor cx, cx

	mov cl, rows


cycle_rows2:
	push cx
	mov cx, columns
	cycle_columns1:
		lods mas
		call print_dec
		lea dx, s_space
		call print_str
	loop cycle_columns1
	lea dx, s_newline
	call print_str
	pop cx
loop cycle_rows2

	lea dx, s_number
	call print_str
	call input_number
	mov number, ax

	lea si, mas
	xor cx, cx

	mov cl, rows
cycle_rows3:
	push cx
	mov cx, columns
	cycle_columns3:
		lods mas
		cmp ax, number
		jle lower_than_number
		mov ax, 0
	lower_than_number:
		call print_dec
		lea dx, s_space
		call print_str
	loop cycle_columns3
	lea dx, s_newline
	call print_str
	pop cx
loop cycle_rows3

exit:
	mov     ax,4c00h    
	int     21h   
end main