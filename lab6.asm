.model small
.stack 1000
.data
        old dd 0 
.code
.486
        count dw 0 ;Счетчик гласных букв
 
new_keyboard proc        
        push ds si es di dx cx bx ax 
        
        xor ax, ax 
        in  al, 60h        ;Получаем скан-код символа
        
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
                inc count ;инкремент счетчика с каждой гласной буквой
                mov ax, count         
                mov BX, 1
                xor DX, DX
                div BX
                cmp DX, 0
                je exit
        
        old_keyboard: 
                pop ax bx cx dx di es si ds                       
                jmp dword ptr cs:old        ;вызов стандартного обработчика прерывания
                xor ax, ax
                mov al, 20h
                out 20h, al 
                jmp exit
                
        exit:
                xor ax, ax
                mov al, 20h
                out 20h, al 
                pop ax bx cx dx di es si ds ;восстановление регистров перед выходом из нашего обработчика прерываний
        iret
new_keyboard endp
 
 
new_end:
 
start:
        mov ax, @data
        mov ds, ax
        
        cli ;сброс флага IF
        pushf 
        push 0        ;перебрасываем значение 0 в DS
        pop ds
        mov eax, ds:[09h*4] 
        mov cs:[old], eax ;сохранение системного обработчика
        
        mov ax, cs
        shl eax, 16
        mov ax, offset new_keyboard
        mov ds:[09h*4], eax ;запись нового обработчика
        sti ;Установка флага IF
        
        xor ax, ax
        mov ah, 31h

        MOV DX, (New_end - @code        + 10FH) / 16 ;вычисление размера резидентной части в параграфах(16 байт)
        INT 21H 
end start