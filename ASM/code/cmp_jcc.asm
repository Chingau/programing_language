assume cs:code,ds:data,ss:stack
;把data段中的字符串显示在屏幕上并把所有小写字母转换成大写后显示在屏幕上
data segment
	db "Beginer's ALL - purpose Symbolic Instruction Code.",0
data ends

stack segment stack
	db 128 dup (0)
stack ends

code segment
start:
	call init_reg
	call display_data
	call up_letter
	
	mov ax,4c00H	;程序返回
	int 21H

;------------------------------------------
up_letter:
	push bx
	push di
	push si
	push dx
	mov bx,160*11+10*2
	mov di,0
	mov si,0
up_letter_line:	
	mov dl,ds:[si]
	cmp dl,0
	je up_letter_ret
	cmp dl,'a'			
	jb up_letter_next	;x < 'a'
	cmp dl,'z'
	ja up_letter_next	;x > 'z'
	and dl,11011111B	;转成大写
up_letter_next:
	mov byte ptr es:[bx+di],dl
	mov byte ptr es:[bx+di+1],00000100B	;显示红色	
	add di,2
	inc si
	jmp up_letter_line
up_letter_ret:
	pop dx
	pop si
	pop di
	pop bx
	ret

;------------------------------------------
display_data:
	push dx
	push si
	push di
	push bx
	
	mov di,0
	mov si,0
	mov bx,160*10+10*2
disp_line:
	mov dl,ds:[si]
	cmp dl,0
	je display_data_ret
	mov byte ptr es:[bx+di],dl
	mov byte ptr es:[bx+di+1],00000010B	;显示绿色
	add di,2
	inc si
	jmp disp_line
display_data_ret:
	pop bx
	pop di
	pop si
	pop dx
	ret

;------------------------------------------
init_reg:
	mov ax,stack
	mov ss,ax
	
	mov ax,data
	mov ds,ax
	
	mov ax,0B800H
	mov es,ax

	ret
	
code ends
end start
