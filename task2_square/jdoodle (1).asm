%macro pushd 0
    push edx
    push ecx
    push ebx
    push eax
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
    mov eax, [val]
    mov ecx, 2
    div ecx
    mov [x1], eax
    add eax, 2
    mov ebx, 2
    mov edx, 0
    div ebx
    mov [x2], eax

    
_while:
    mov eax, [x1]
    mov ebx, [x2]
    sub eax, ebx
    mov ebx, 1
    cmp eax, ebx
    jg _body
    mov eax, [x2]
    dprint
    
    mov     eax, 1
    mov     ebx, 0
    int     0x80
    
_body:
    mov ebx, [x2]
    mov [x1], ebx
    mov eax, [val]
    mov ebx, [x1]
    
    div ebx
    mov edx, 0
    add eax, ebx
    mov ebx, 2
    
    div ebx
    mov edx, 0
    mov [x2], eax
    jmp _while


section .data
    val dd 144

section .bss
    count resb 1
    x1 resb 10
    x2 resb 10