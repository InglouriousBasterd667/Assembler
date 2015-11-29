.186
.model tiny
.code
org 2Ch
org 80h
cmd_len db ?
cmd_line db ?
org 100h


prog:


jmp start
old dd 0 
count dw 0
active dw 0
new_keyboard proc        
        push ds si es di dx cx bx ax 
        mov dx,777
        cmp cs:active,dx
        jne old_keyboard 
        xor ax, ax 
        in  al, 60h        ;Get scan-code of symbol
        
        cmp al, 0bh
        je p_new_keyboard
        cmp al, 1h    
        je p_new_keyboard
        cmp al, 2h      
        je p_new_keyboard
        cmp al, 3h       
        je p_new_keyboard
        cmp al, 4h
        je p_new_keyboard
        cmp al, 5h     
        je p_new_keyboard
        cmp al, 6h
        je p_new_keyboard
        cmp al, 7h       
        je p_new_keyboard
        cmp al, 8h       
        je p_new_keyboard
        cmp al, 9h       
        je p_new_keyboard
        cmp al, 0ah
        je p_new_keyboard
        jmp old_keyboard
        
        p_new_keyboard: 
                je exit
        
        old_keyboard: 
                pop ax bx cx dx di es si ds                       
                jmp dword ptr cs:old        ;standard handler
                xor ax, ax
                mov al, 20h
                out 20h, al 
                jmp exit

        exit:
                xor ax, ax
                mov al, 20h
                out 20h, al 
                pop ax bx cx dx di es si ds 
                iret
new_keyboard endp

handler_install db "New keyboard handler is successfully installed!$"
handler_removed db "New keyboard handler is successfully removed!$"
already_installed db "Error! New keyboard handler is already installed!$"
wrong_param db "Error! Please write correct parametr!$"
is_not_installed db "New keyboard handler is not installed yet!$"

start:
    
    mov ax, 3509h
    int 21h
    mov word ptr old, bx
    mov word ptr old + 2, es   
    
    mov ah, cmd_len
    cmp ah, 0
    jne param

    mov ax, es:active
    cmp ax, 777
    je alr_inst

    mov dx, offset handler_install
    mov ah, 09h
    int 21h
   
    mov ax, 777
    mov active, ax

    mov ax, 2509h
    mov dx, offset new_keyboard
    int 21h

    mov dx, offset start
    int 27h
    ret

    param:
        mov di, offset cmd_line
        mov al, [di + 1]
        cmp al, '-'
        jne param_error

        mov al, [di + 2]
        cmp al, 'd'
        jne param_error

        mov ax, es:active
        cmp ax, 777
        jne not_installed

        mov ax, 0
        mov es:active, ax 

        mov dx, offset handler_removed
        mov ah, 09h
        int 21h
        
        ret

    not_installed:
        mov dx, offset is_not_installed
        mov ah, 09h
        int 21h
        ret

    param_error:
        mov dx, offset wrong_param
        
        xor bx, bx 
        mov ax, es:active
        cmp ax, 777
        jne not_active 
        mov bx, 1

        mov ax, 0 
        mov es:active, ax

        not_active:
        mov ah, 09h
        int 21h
        
        cmp bx, 1
        jne was_not_active

        mov ax, 777 
        mov es:active, ax

        was_not_active:
        ret

    alr_inst:
        mov dx, offset already_installed

        mov ax, 0 
        mov es:active, ax

        mov ah, 09h
        int 21h

        mov ax, 777
        mov es:active, ax
        ret
end prog