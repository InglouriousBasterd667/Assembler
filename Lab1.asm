.model   small
.stack   100
.data         
;данные программы
a dw 5
b dw 3
c dw 2
d dw 2
.code 
main:
        mov ax, @data    
        mov ds, ax
  

        mov ax, a
        mov bx, b
        and bx, ax
        
        mov dx,0
		mov ax,c
		mov cx,4
		dec cx
		a1:  mul c
        	loop a1

        cmp bx,ax
        je res1
        
        mov dx,0 
        mov ax,a
        mov cx,3 
        dec cx
        a2:  mul a
            loop a2
        mov bx,ax

        mov ax,b
        mov cx,3
        dec cx
        a3:  mul b
            loop a3
        
        add ax,bx  
        
        mov bx, b
        add bx, c
    
        cmp ax,bx  
        je res2
        
    ;res3
        mov ax, c
        shr ax, 3
        ;shr ax, 1
        ;shr ax, 1
        
        mov ax, 4c00h 
        int 21h

    res2: mov bx, b
        add bx, c
        mov ax, a
        xor ax,bx
        
        mov     ax,4c00h    
        int     21h 
              
    res1:
        mov ax, d
    	mul b
        mov bx,ax
        mov ax,c
        div bx
    	add ax, a

        mov     ax,4c00h    
        int     21h         
end     main