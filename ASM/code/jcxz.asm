;从地址2000H处读取字节数据，当数据为0时，把为0时的偏移地址保存到dx寄存器中
assume cs:code,ds:data,ss:stack
data segment
	db 128 dup (0)
data ends

stack segment stack
	db 128 dup (0)
stack ends

code segment
start:
	mov ax,2000H
	mov ds,ax
	mov bx,0
	
s:	mov ch,0
	mov cl,ds:[bx]
	jcxz ok
	inc bx
	jmp short s
	
ok:	mov dx,bx

	mov ax,4c00H	;程序返回
	int 21H
code ends
end start