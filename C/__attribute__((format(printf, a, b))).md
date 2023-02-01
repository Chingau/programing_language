\_\_attribute__((format(printf, a, b))) 

功能：\_\_attribute__((format())) 属性可以给被**声明的函数**加上类似 printf 或者 scanf 的特征，它可以使编译器检查函数声明和函数实际调用参数之间的格式化字符串是否匹配。format 属性告诉编译器，按照 printf, scanf 等标准 C 函数参数格式规则对该函数的参数进行检查。这在我们自己封装调试信息的接口时非常的有用。

format的语法格式为：

`format (archetype, string-index, first-to-check)`

其中，archetype 指定是哪种风格，如 printf, scanf...；string-index 指定传入函数的第几个参数是格式化字符串；first-to-check 指定从函数的第几个参数开始按上述规则进行检查。

具体的使用如下所示：

```c
__attribute__((format(printf, a, b)))
__attribute__((format(scanf, a, b)))
```

```
其中参数 a 与 b 的含义为：
　　　　a：第几个参数为格式化字符串(format string);
　　　　b：参数集合中的第一个，即参数“…”里的第一个参数在函数参数总数排在第几。
```

下面直接给个例子来说明:

```c
#include <stdio.h>
#include <stdarg.h>
 
#if 1
#define CHECK_FMT(a, b) __attribute__((format(printf, a, b)))
#else
#define CHECK_FMT(a, b)
#endif
 
void TRACE(const char *fmt, ...) CHECK_FMT(1, 2);
 
void TRACE(const char *fmt, ...)
{
    va_list ap;

    va_start(ap, fmt);
    (void)printf(fmt, ap);
    va_end(ap);
}
 
int main(void)
{
    TRACE("iValue = %d\n", 6);
    TRACE("iValue = %d\n", "test");
    return 0;
}
```

注意：需要打开警告信息即（-Wall）。编译结果如下所示：
```
main.cpp: In function ‘int main()’:
main.cpp:26:31: warning: format ‘%d’ expects argument of type ‘int’, but argument 2 has type ‘const char*’ [-Wformat=]
  TRACE("iValue = %d\n", "test");
```

如果不使用 \_\_attribute__ format 则不会有警告。
