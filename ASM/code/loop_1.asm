;将内存FFFF:0~FFFF:F内存单元中的数据复制到0:200~0:20F中
assume cs:code

code segment
	mov ax,0ffffH
	mov ds,ax
	sub bx,bx
	mov cx,16
set_number:	
	push ds
	mov dl,ds:[bx]
	mov ax,20H
	mov ds,ax
	mov ds:[bx],dl
	inc bx
	pop ds
	loop set_number
	
	mov ax,4c00H	;程序返回
	int 21H
code ends
end