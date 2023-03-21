assume cs:code,ds:data,ss:stack
data segment
	db "welcome to masm!"
	db 00100000B	;绿底
	db 00100100B	;绿底红字
	db 01110001B	;白底蓝字
data ends

stack segment stack
	db 128 dup (0)
stack ends

code segment
start:
	mov ax,stack
	mov ss,ax
	mov sp,128
	
	mov ax,data
	mov ds,ax
	
	mov ax,0B800H
	mov es,ax
	
	mov bx,0
	mov di,160*10 + 30*2	;显示的起始地址(随便定义)
	mov si,16
	mov cx,16
	
showMasm:	
	push bx
	push di
	push si
	push cx
	
	mov cx,16
	mov ah,ds:[si]			;获取属性
showRow:
	mov al,ds:[bx]			;获取字符
	mov es:[di],ax			;输出显示
	inc bx
	add di,2
	loop showRow
	
	pop cx
	pop si
	pop di
	pop bx
	inc si
	add di,160
	loop showMasm
	
	mov ax,4c00H	;程序返回
	int 21H
code ends
end start