assume cs:code,ds:data,ss:stack
;修改0号中断，使其调用时全屏显示"!"
;实现思路：在0:7E00处写入我们自己实现的中断处理代码；
;将0:7E00这4个字节的数据写入到中断向量表0的位置处，目的是使其发生0号中断时跳转到0:7E00处
data segment
	db 16 dup (0)
data ends

stack segment stack
	db 128 dup (0)
stack ends

code segment
start:
	call cpy_code
	call set_new_int0
	int 0			;调用0号中断
	mov ax,4c00H	;这里的代码将调用不到
	int 21H
	
;---------------------------------------
set_new_int0:
	mov bx,0
	mov es,bx
	cli
	mov word ptr es:[0*4],7E00H	;ip
	mov word ptr es:[0*4+2],0	;cs
	sti
	ret
	
;---------------------------------------
int0_handler_start:
	push ax
	push es
	push si
	push cx
	push bx
	mov ax,0B800H
	mov es,ax
	mov si,0
	mov cx,2000
	mov bl,'!'							;设置要写的字符
set_acsii:
	mov byte ptr es:[si],bl				;往屏幕上写字符
	mov byte ptr es:[si+1],00000100B	;设置字符颜色
	add si,2
	loop set_acsii
	pop bx
	pop cx
	pop si
	pop es
	pop ax
	mov ax,4c00H	;退出程序
	int 21H
int0_handler_end:
	nop
	
;---------------------------------------
cpy_code:
	;源地址
	mov ax,cs
	mov ds,ax
	mov si,OFFSET int0_handler_start
	
	;目的地址
	mov ax,0
	mov es,ax
	mov di,7E00H
	
	;复制大小
	mov cx,OFFSET int0_handler_end - int0_handler_start
	cld
	rep movsb
	ret
code ends
end start
