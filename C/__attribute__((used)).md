# __attribute__((__unused__)) 和 __attrubute__((__used__)) 的作用
在 gcc 手册中找到了有关的解释：

> ununed: This attribute, attached to a function, means that the function is meant to be possibly unused. GCC will not produce a warning for this function.

ununed 表示该函数或变量可能不使用，这个属性可以避免编译器产生警告信息。

> used: This attribute, attached to a function, means that code must be emitted for the function even if it appears that the function is not referenced. This is useful for example, when the function is referenced only in inline assembly.

used 表示向编译器说明这段代码有用，即使在没有用到的情况下编译器也不会产生警告信息。

