assume cs:code,ds:data,ss:stack
data segment
	dw 12345		;把此数据显示到屏幕上
data ends

stack segment stack
	db 128 dup (0)
stack ends

code segment
start:
	mov ax,data
	mov ds,ax
	
	mov ax,0B800H
	mov es,ax
	
	call Show_div
	
	mov ax,4c00H	;程序返回
	int 21H
	
;----------------------------------------
Show_div:
	mov di,160*10
	add di,40*2
	mov ax,ds:[0]
calc_div:
	mov dx,0
	mov bx,10
	div bx		;ax商，dx余
	add dl,30H
	mov byte ptr es:[di+0],dl
	mov byte ptr es:[di+1],00000010B
	mov cx,ax
	jcxz show_ret
	sub di,2
	inc cx
	loop calc_div
	
show_ret:
	ret
	
code ends
end start
