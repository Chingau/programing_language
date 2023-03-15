assume cs:code,ds:data,ss:stack

data segment
	db 'abcde'		;将此字符串转化成大写
	db 'ABCDE'		;将此字符串转化为小写
data ends

stack segment stack
	dw 0,0,0,0
	dw 0,0,0,0
	dw 0,0,0,0
	dw 0,0,0,0
stack ends

code segment
start:
	;初始化栈段
	mov ax,stack
	mov ss,ax
	mov sp,32
	
	;初始化数据段
	mov ax,data
	mov ds,ax
	
	mov ax,0
	mov bx,0
	mov cx,5
	
trans_letter:
	;小写转大写
	mov al,ds:[bx]
	and al,11011111B
	mov ds:[bx],al
	;大写转小写
	mov al,ds:[bx+5]
	or al,00100000B
	mov ds:[bx+5],al
	inc bx
	loop trans_letter
	
	mov ax,4c00H	;程序返回
	int 21H
code ends
end start