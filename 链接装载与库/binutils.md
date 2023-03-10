# objdump
选项|说明
|:--|:--|
-a|列举.a文件中所有的目标文件
-b bfdname|指定BFD名
-C|对于C++符号名进行反修饰
-g|显示调试信息
-d|对包含机器指令的段进行反汇编
-D|对所有的段进行反汇编
-f|显示目标文件文件头
-h|显示段表
-l|显示行号信息
-p|显示专有头部信息，具体内容取决于文件格式
-r|显示重定位信息
-R|显示动态链接重定位信息
-s|显示文件所有内容
-S|显示源代码和反汇编代码(包含-d参数)
-W|显示文件中包含有DWARF调试信息格式的段
-t|显示文件中的符号表
-T|显示动态链接符号表
-x|显示文件的所有文件头

```
objdump -h test.o   // -h 就是把ELF文件的各个段的基本信息打印出来(虚拟地址/加载地址，段大小等)
objdump -x test.o   // -x 也可以打印各个段的信息，只不过更为详细，更为复杂

-s 可以将所有段的内容以十六进制的方式打印出来
-d 可以将所有包含指令的段反汇编(输出反汇编结果)
objdump -s -d test.o

-r 查看目标文件的重定位表
-t 可以查看目标文件/库文件中的符号表内容(readelf -s也可以)
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

# gcc

|选项|说明|
|:--|:--|
-E|只进行预处理并把预处理结果输出
-c|只编译不链接
-o \<filename\> |指定输出文件名
-S|输出编译后的汇编代码文件
-I|指定头文件路径
-e name|指定name为程序的入口地址
-ffreestanding|编译独立的程序，不会自动链接C运行库、启动文件等
-finline-functions,-fno-inline-functions|启用/关闭内联函数
-g|在编译结果中加入调试信息，-ggdb就是加入GDB调试器能够识别的格式
-L \<directory\>|指定链接时查找路径，多个路径之间用冒号隔开
-nostartfiles|不要链接启动文件，比如crtbegin.o， crtend.o
-nostdlib|不要链接标准库文件，主要是C运行库
-O0|关闭所有优化选项
-shared|产生共享对象文件
-static|使用静态链接
-Wall|对源代码中的多数编译警告进行启用
-fPIC|使用地址无关代码模式进行编译
-fPIE|使用地址无关代码模式编译可执行文件
-XLinker \<option>|把option传递给链接器
-Wl \<option>|把option传递给链接器，与上面的选项类似
-fomit-frame-pointer|禁止使用EBP作为函数帧指针
-fno-builtin|禁止GCC编译器内置函数
-fno-stack-protector|是指关闭堆栈保护功能
-ffunction-sections|将每个函数编译到独立的代码段
-fdata-sections|将全局/静态变量编译到独立的数据段

## --ffunction-sections/--fdata-sections
由于现在的程序和库通常来讲都非常庞大，一个目标文件可能包含成千上百个函数或变量。当我们须要用到某个目标文件中的任意一个函数或变量是，就须要把它整个地链接进来，也就是那些没有用到的函数也被一起链接了进来。这样的后果就是链接输出文件会变得很大，所有用到的没用到的变量和函数都一起塞到了输出文件中。

GCC提供了 **\-\-ffunction-sections, \-\-fdata-sections** 编译选项叫 **函数级别链接**，这个选项的作用就是让每个函数或变量单独保存到一个段里面，当链接器须要用到某个函数时，它就将它合并到输出文件中，对于那些没有用到的函数则将它们抛弃。这种做法可以很大程度上减小输出文件的长度，减少空间浪费。但是这个优化选项会减慢编译和链接过程，因为链接器须要计算各个函数之间的依赖关系，并且所有函数都保存到独立的段中，目标函数的段的数量大大增加，重定位过程也会因为段的数目的增加而变得复杂，目标文件随着段数目的增加也会变得相对较大。

## -fno-builtin
假设我们有一个利用 printf 输出 "Hello world" 的程序，其名叫 hello.c，使用如下编译：

```
gcc -c -fno-builtin hello.c
```

我们可以得到目标文件 hello.o，这里的 -fno-builtin 参数是因为默认情况下，GCC 会自作聪明地将"Hello world"程序中只使用一个字符串参数的printf替换成puts函数，以提高运行速度。-fno-builtin 就是关闭这个内置函数优化选项。

## -verbose
GCC编译时添加此参数可以把整个编译链接的中间过程都打印出来。

# ld
选项|说明|
|:--|:--|
-static|静态链接
-l \<libname>|指定链接某个库
-e name |指定name为程序入口
-r|合并目标文件，不进行最终链接
-L \<directory>|指定链接时查找路径，多个路径之间用冒号隔开
-M|将链接时的符号和地址输出成一个映射文件
-o|指定输出文件名
-s|清除输出文件中的符号信息
-S|清除输出文件中的调试信息
-T \<scriptfile>|指定链接脚本文件
-version-script \<file>|指定符号版本脚本文件
-soname \<name>|指定输出共享库的SONAME
-export-dynamic|将全局符号全部导出
-verbose|链接时输出详细信息
-rpath \<path>|指定链接时库查找路径
```
-e main表示将main函数作为程序入口，ld链接器默认的程序入口为_start
-o ab表示链接输出文件名为ab，默认为a.out
ld a.o b.o -e main -o ab

-T 后跟链接控制脚本，如 -Tlnk.script，告诉链接器使用lnk.script链接脚本来进行链接

-verbose     //查看默认的链接控制脚本 ld -verbose
-static     //表示ld将使用静态链接的方式来链接程序
```

# ar

ar 工具通常是把多个目标文件压缩到一起，并且对其进行编号和索引，以便于查找和检索，形成静态库文件。

```
ar -t libc.a    // 查看静态库中包含的目标文件
ar -x libc.a    // 把libc.a中包含的所有目标文件解压到当前目录下
```