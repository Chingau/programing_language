;用 7CH中断完成 jmp near ptr s 指令的功能，完成显示一行以0结尾的字符串。
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
	
	call cpy_new_int0
	call set_new_int0
	call init_reg
	call show_string
	
	mov ax,4C00H
	int 21H

;-----------------------------------------------
init_reg:
	mov ax,data
	mov ds,ax
	mov ax,0B800H
	mov es,ax
	ret

;-----------------------------------------------	
show_string:
	mov dl,0
	mov di,0
	mov si,160*12 + 30*2
	mov bx,OFFSET showString - OFFSET showStringRet
showString:
	mov dl,ds:[di]
	cmp dl,0
	je showStringRet
	mov es:[si],dl
	mov byte ptr es:[si+1],00000100B
	add si,2
	inc di
	int 7CH
showStringRet:
	ret
;-----------------------------------------------
set_new_int0:
	mov bx,0
	mov es,bx
	cli
	mov word ptr es:[7CH*4],7E00H
	mov word ptr es:[7CH*4+2],0
	sti
	ret
		
;-----------------------------------------------
new_int0:
	push bp				;此时栈中从高到低地址依次保存的是 flag、cs、ip、bp
	mov bp,sp
	add ss:[bp+2],bx	;这里直接对保存在栈中的ip进行修改，从而达到跳转的作用; [bp+2]得到的值就是ip
	pop bp
	iret
new_int0_end:
	nop

;-----------------------------------------------
cpy_new_int0:
	mov bx,cs
	mov ds,bx
	mov si,OFFSET new_int0
	
	mov bx,0
	mov es,bx
	mov di,7E00H
	
	mov cx,OFFSET new_int0_end - OFFSET new_int0
	cld
	rep movsb
	ret
	
code ends
end start
