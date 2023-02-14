# objdump
```
objdump -h test.o   // -h 就是把ELF文件的各个段的基本信息打印出来(虚拟地址/加载地址，段大小等)
objdump -x test.o   // -x 也可以打印各个段的信息，只不过更为详细，更为复杂

-s 可以将所有段的内容以十六进制的方式打印出来
-d 可以将所有包含指令的段反汇编(输出反汇编结果)
objdump -s -d test.o
```

# size
```
size 工具可以用来查看 ELF 文件的代码段、数据段和BSS段的长度
(dec表示3个段长度的和的十进制，hex表示3个段长度和的十六进制)

size test.o
```

# readelf
```
readelf -h test.o       //查看文件头
readelf -S test.o       //查看ELF文件中的段信息，如段的偏移地址，大小，属性等
readelf -s test.o       //查看文件中的符号信息(比nm全)
```

# nm
```
nm test.o   //查看文件中的符号信息
```

# strip
```
strip test.o    //删除目标文件/可执行文件中的调试信息
```

# ld
```
-e main表示将main函数作为程序入口，ld链接器默认的程序入口为_start
-o ab表示链接输出文件名为ab，默认为a.out
ld a.o b.o -e main -o ab
```