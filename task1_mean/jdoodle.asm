%macro pushd 0
    push edx
    push ecx
    push ebx
    push eax
%endmacro

%macro minus 0
    push '-'
    mov edx, 1
    mov ecx, esp
    mov ebx, 1
    mov eax, 4
    add esp, 4 
    int 0x80
    popd
    
%endmacro

%macro popd 0
    pop eax
    pop ebx
    pop ecx
    pop edx
%endmacro

%macro print 2
    pushd
    mov edx, %1
    mov ecx, %2
    mov ebx, 1
    mov eax, 4
    int 0x80
    popd
%endmacro

%macro dprint 0
    pushd
    mov ecx, 10
    mov bx, 0
    %%_divide:
        mov edx, 0
        div ecx
        push dx
        inc bx
        test eax, eax
        jnz %%_divide
        
        mov cx, bx
    
    %%_digit:
        pop ax
        add ax, '0'
        mov [count], ax
        print 1, count
        dec cx
        mov ax, cx
        cmp cx, 0
        jg %%_digit
    popd

%endmacro

section .text

global _start

_start:
    mov ebx, 0 
    mov eax, 0
_arrX:
    add al, [x + ebx]
    inc ebx
    cmp ebx, xlen
    jl _arrX

    mov [xSum], eax
    
    mov ebx, 0
    mov eax, 0

_arrY:
    add al, [y + ebx]
    inc ebx
    cmp ebx, ylen
    jl _arrY
    mov ebx, 0
     
    sub [xSum], eax
    mov eax, [xSum]
    cmp eax, 0
    jl _negative
    mov ebx, ylen/4
    div ebx
    
    dprint 
    mov     eax, 1
    mov     ebx, 0   
    int     0x80

    
_negative:
    neg eax
    mov ebx, ylen/4
    div ebx
    minus 

    dprint 
    
    mov     eax, 1
    mov     ebx, 0   
    int     0x80

section .data
    x dd 5, 3, 2, 6, 1, 7, 4
    y dd 0, 10, 1, 9, 2, 8, 5
    xlen equ ($ - x) / 2 
    ylen equ ($ - y) 

section .bss
    count resb 1
    xSum resb 10
