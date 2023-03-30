;编写并安装int 7CH中断程序，功能为显示一个用0结束的字符串，中断程序安装在0:7E00处
;	参数：	dh = 行号
;			dl = 列号
;			cl = 颜色
;			ds:si 指向字符串首地址
assume cs:code,ds:data,ss:stack
data segment
	db 'I love you.',0
data ends

stack segment stack
	db 128 dup (0)
stack ends

code segment
start:
	mov ax,stack
	mov ss,ax
	mov sp,128
	
	call cpy_new_int7ch
	call set_new_int7ch
	call init_reg
	call show_time
	
	mov ax,4C00H
	int 21H
	
;----------------------------------------------------------
init_reg:
	mov ax,data
	mov ds,ax
	mov ax,0B800H
	mov es,ax
	ret
;----------------------------------------------------------
show_time:
	mov si,0
	mov dh,20	;行号
	mov dl,40	;列号
	mov cl,74H	;颜色
	int 7CH		;上面的参数就是 int 7CH的入参
	ret
;----------------------------------------------------------
new_int7ch_start:
	call get_row	;获取行
	call get_col	;获取列
	call show_string
	iret
;----------------------------------------------------------
get_row:
	mov di,0
	mov al,160
	mul dh
	mov di,ax
	ret
;----------------------------------------------------------
get_col:
	mov al,2
	mul dl
	add di,ax
	ret
;----------------------------------------------------------	
show_string:
	push dx
	push ds
	push es
	push si
	push di
showString:
	mov dl,ds:[si]
	cmp dl,0
	je showStringRet
	mov es:[di],dl
	mov es:[di+1],cl
	add di,2
	inc si
	jmp showString
showStringRet:
	pop di
	pop si
	pop es
	pop ds
	pop dx
	ret
new_int7ch_end:
	nop
;----------------------------------------------------------
set_new_int7ch:
	mov bx,0
	mov es,bx
	cli
	mov word ptr es:[7CH*4],7E00H
	mov word ptr es:[7CH*4+2],0
	sti
	ret
;----------------------------------------------------------
cpy_new_int7ch:
	mov bx,cs
	mov ds,bx
	mov si,OFFSET new_int7ch_start
	
	mov bx,0
	mov es,bx
	mov di,7E00H
	
	mov cx,OFFSET new_int7ch_end - OFFSET new_int7ch_start
	cld
	rep movsb
	ret
	
code ends
end start
