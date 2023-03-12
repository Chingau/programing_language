;计算123*236的值，并把结果存放到ax寄存器中

assume cs:code

code segment
	sub ax,ax
	mov cx,123		;loop指令的循环次数
mul_cal:
	add ax,236
	loop mul_cal
	
	mov ax,4c00H	;程序返回
	int 21H
code ends
end