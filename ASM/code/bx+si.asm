assume cs:code,ds:data,ss:stack

data segment
	db 'abc             '	;将这些字母全转换为大写
	db 'def             '
	db 'ghi             '
	db 'jkl             '
data ends

stack segment stack
	dw 0,0,0,0
	dw 0,0,0,0
	dw 0,0,0,0
	dw 0,0,0,0
stack ends

code segment
start:
	mov ax,stack
	mov ss,ax
	mov sp,32
	
	mov ax,data
	mov ds,ax
	
	mov cx,4
	mov si,0
	mov ax,0
RAW:
	push cx
	mov cx,3
	mov bx,0
UpLetter:
	mov al,ds:[bx+si]
	and al,11011111B
	mov ds:[bx+si],al
	inc bx
	loop UpLetter
	
	pop cx
	add si,16
	loop RAW
	
	mov ax,4c00H	;程序返回
	int 21H
code ends
end start