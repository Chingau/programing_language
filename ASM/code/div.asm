assume cs:code,ds:data,ss:stack

data segment
	db 3,0,16,0,0,0,0,0
data ends

stack segment stack
	dw 0,0,0,0
	dw 0,0,0,0
	dw 0,0,0,0
	dw 0,0,0,0
stack ends

code segment
start:
	mov ax,data
	mov ds,ax
	
	;被除为16位，除数为8位
	mov ax,16
	div byte ptr ds:[0]		;16/3 al存商 ah存余数
	
	;被除数为32位，除数为16位
	mov ax,ds:[2]
	mov dx,ds:[4]
	mov bx,3
	div bx					;16/3 ax存商 dx存余数
	
	mov ax,4c00H	;程序返回
	int 21H
code ends
end start