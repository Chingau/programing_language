;将mov ax,4c00H前的所有指令数据复制到内存0:200处
assume cs:code

code segment
	mov ax,cs
	mov ds,ax	;源数据地址
	mov ax,20H
	mov es,ax	;目的数据地址
	mov bx,0
	mov cx,23
	
s:
	mov al,ds:[bx]
	mov es:[bx],al
	inc bx
	loop s
	
	mov ax,4c00H	;程序返回
	int 21H
code ends
end