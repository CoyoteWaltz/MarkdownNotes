# Linux C 语言 系统编程(文件操作+进程相关)

## 文件操作

### open 打开文件

---

这里有个关键点要记住:

程序启动的时候 0 1 2 三个文件描述符对应如下:

文件描述符 用途 POSIX 名称 stdio 流

- 0 标准输入 STDIN_FILENO stdin
- 1 标准输入 STDOUT_FILENO stdout
- 2 标准错误 STDERR_FILENO stderr

POSIX 标准要求每次打开文件时（含 socket）必须使用当前进程中最小可用的文件描述符号码，因此，在网络通信过程中稍不注意就有可能造成串话

理解 file descriptor:

可以把文件描述符看成是一个结构体

```c
struct fd_t {
    int index;	// 就是fd本身的值
    filelistitem *ptr;	// 指向文件表中文件实例的指针
}
```

---

函数原型:

```c
#include<sys/types.h>
#include<sys/stat.h>
#include<fcntl.h>
int open(const char* pathname, int flags, ...)
```

用不同方式打开一个文件，返回一个文件描述符(int)

参数说明:

- pathname: 文件路径名

- flags: 打开文件的方式有:

  - O_RDONLY: 只读
  - O_WRONLY: 只写
  - O_RDWR: 读写
  - O_APPEND: 追加

  可选标志位，用按位或 | 连接

  - O_TRUNC: truncated，若文件存在，读写方式或者写打开的话，内容被截断，就是长度为 0 的文件
  - O_CREAT: 若文件不存在则创建文件，此时需要第三个参数**mode**,设置权限，8 进制数,e.g. 777
  - O_EXCL: 可用于检测文件是否存在，如果不存在 open 返回值为-1
  - O_NONBLOCK: 对于设备文件，以 O_NONBLOCK 方式打开能够做非堵塞 I/O(不太懂，先复制了)

返回值:

打开成功返回 file descriptor，失败则返回-1

文件描述符和打开文件的关系，Linux 中一切皆为文件。文件又可分为：普通文件、目录文件、链接文件和设备文件。文件描述符（file descriptor）是内核为了高效管理已被打开的文件所创建的索引，其是一个非负整数（通常是小整数），用于指代被打开的文件，所有执行 I/O 操作的系统调用都通过文件描述符。程序刚刚启动的时候，0 是标准输入，1 是标准输出，2 是标准错误。如果此时去打开一个新的文件，它的文件描述符会是 3。

### read 从打开的文件中读取数据

会从文件读写指针的位置开始读取。

函数原型:

```c
#include <unistd.h>
ssize_t read(int fd, void* buf, size_t count);
```

参数说明:

- fd: 文件描述符，通过 open 打开的文件
- buf: 缓冲区指针，通常用 char\*
- count: the count of bytes read from the file

返回值:

- 成功情况下返回读取到的字节数(int)
- 失败返回-1

使用:

可以通过 read 的返回值获得文件的长度`int len = read(fd, buffer, sizeof(buffer))`，多数情况下，从文件实际读取到的字节数是会少于指定的 count 的，有以下几种情况:

- 普通文件在 count 个字节之前就到达了 EOF
- 从终端设备读文件的时候，每次最多读一行
- 网络读取的时候，网络中的缓存机制可能造成返回值小于所要求读出的字节数(没试过)

### close 关闭文件

函数原型:

```c
#include <unistd.h>
int close(int fd);
```

通过传递文件描述符来关闭文件。

返回值:

- 成功返回 0，出错返回-1

### lseek 重定位文件读写位置

函数原型:

```c
#include <sys/types.h>
#include <unistd.h>

off_t lseek(int fd, off_t offset, int whence);
```

repositions 一个读/写文件的指针 offset。fd 是 file descriptor 文件描述符，打开文件的 open 函数会返回一个文件描述符，每一个已打开的文件都有一个读写位置，打开文件之后读写位置(指针)通常都是指向文件开头，如果用 appen 模式**O_APPEND**则指向的是文件末尾。当 read()或者 write()的时候读写位置会随之偏移 offset。通过 lseek 来控制文件的读写位置。

参数说明:

- fd: 文件描述符
- offset: 偏移量大小
- whence: 从哪里开始偏移，这里的参数可以是
  - SEEK_SET: 当前的 offset 即为新的位置
  - SEEK_CUR: 将当前位置加上 offset 得到新的位置(这个参数可以使负值)
  - SEEK_END: 在文件尾后增加 offset 得到新的位置(这个参数可以使负值)

返回值:

- reposition 之后的位置

使用:

1. 将文件读写位置移动到开头 `lseek(fd, 0, SEEK_SET)`
2. 将文件读写位置移动到末尾 `lseek(fd, 0, SEEK_END)` 同时返回值就是文件长度，但是这样获取长度之后会改变文件读写位置，个人感觉不太推荐这样做，在文件刚读完之后就获取长度并立即使用`lseek(fd, 0, SEEK_SET)`恢复位置。
3. 获取当前文件位置`int pos = lseek(fd, 0, SEEK_CUR)`

### fseek 重定位文件*流*的读写位置

### write 向文件写数据

从读写指针的位置开始写入

函数原型:

```c
#include <unistd.h>
ssize_t write(int fd, const void* buff, size_t nbytes);
```

参数说明:

- fd: 文件描述符
- buff: 存放了需要写入的数据的缓冲区指针
- nbytes: 需要写入的字节数

返回值:

- 成功返回实际写入文件的字节数，失败返回-1

出错的原因:

- 磁盘满了
- 没有访问权限
- 超过了进程文件限制的长度

### creat 创建一个新文件

注意不是 create 这个单词，并不知道为什么，可能是 create 有别的函数用了

函数原型:

```c
#include<sys/types.h>
#include<sys/stat.h>
#include<fcntl.h>
int creat(const char* pathname, mode_t mode);
```

参数说明:

- pathname: 文件路径
- mode: 和 open 的第二个参数一样，但是注意这只是文件属性(权限)，这些宏定义可以被数字替换，查看 linux 下`man creat`:
  - S_IRUSR: 可读 400 READ FOR USER
  - S_IWUSR: 可写 200
  - S_IXUSR: 可执行
  - S_IRWXU: 可读可写可运行
  - 4: 可读
  - 2: 可写
  - 1: 可运行
  - 0: no privilege 尝试之后发现居然要 sudo 才能看 真的什么权限都不给 root 才能看

返回值:

- 成功返回文件的描述符，失败返回-1

失败情况:

- 文件名相同的时候权限为 0 出错了
- 其他的还没试过

```c
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>

int main() {
	int fd = creat("created.txt", 400); // 400 用户可读	但是我在外面用了vim修改了也是ok的。。。。
	if (fd >= 0) {
		printf("create file successfully! fd is %d\n", fd);
	}
	else {
		printf("failed to create\n");
	}
	//尝试直接在这个fd上面写东西
	const char* ss = "hahaha";
	if (write(fd, ss, strlen(ss)) < 0) {
		printf("failed to write\n");
	}

	return 0;
}
```

### mmap & munmap memory 映射

这个函数有点难了，这个函数将一个文件或者其他对象映射进入内存，“文件被映射到多个页上，如果文件的大小不是所有页的大小之和，最后一个页不被使用的空间将会清零。mmap 在用户空间映射调用系统中作用很大。”Linux Programmer's Manual 上面的说明是进程通过 mmap 函数创建一个在虚地址上的映射。

**强调必须以 PAGE_SIZE 为单位进行映射，就是页大小，Linux 里面 4KB**。

问题来了：为什么要将文件映射到内存呢？思考思考

内存映射的作用: 通过映射到内存，直接操作内存中的数据提升效率。

函数原型:

```c
#include <sys/mman.h>

void* mmap(void *addr, size_t length, int prot, int flags,
           int fd, off_t offset);
```

参数说明:

- addr: 映射的起始地址，如果为 NULL 的话，内核将自动选择一个地址分配，most portable 的选项。如果非空，内核会把他当做是个 hint，具体不详细说明了，反正内核会搞定一切。
- length: 将文件中多少长度的部分映射到内存。
- prot: protection 映射区域的保护方式:
  - PROT_EXEC: 页可被执行(?说明这段文件是可执行的?)
  - PROT_READ: 页可读
  - PROT_WRITE: 页可写
  - PROT_NONE: 不能存取
- flags: 这个参数决定了这个映射是否对其他进程同样映射在这页区域中的文件可见(visible)，并且 and are not carried through to the underlying file 这句话我没看懂:
  - MAP_SHARED: 共享这个映射，对这个映射写入数据会复制会文件(未验证)
  - MAP_SHARED_VALIDATE: 和上面那个作用一样，不同的是上面那个会无视那些未知的 flag，这个不行，他会 validate，会报错。
  - MAP_PRIVATE: Create a private copy-on-write mapping. copy-on-write，修改映射不会被写回文件。
- offset: 文件的偏移量，通常为 0，但是要给值的时候要遵循上面必须是页大小的倍数，如何获取页大小: `sysconf(_SC_PAGE_SIZE)`

返回值:

- 映射成功则返回起始地址
- 失败返回 MAP_FAILED 这个值是-1，错误原因存在了 errno 中

错误代码:

- EBADF 参数 fd 不是有效的文件描述词
- EACCES 存取权限有误。如果是 MAP_PRIVATE 情况下文件必须可读，使用 MAP_SHARED 则要有 PROT_WRITE 以及该文件要能写入。
- EINVAL 参数 start、length 或 offset 有一个不合法。
- EAGAIN 文件被锁住，或是有太多内存被锁住。
- ENOMEM 内存不足。

用法:

映射文件的流程:

1. `open`系统调用打开文件，获得返回的描述符 fd
2. 使用`mmap`建立内存映射，返回映射的起始地址 start
3. After the mmap() call has returned, the file descriptor, fd, can be closed immediately without invalidating the mapping.也就是说文件可被立刻关闭`close`，可以尝试一下在关闭后修改映射，源文件会不会被修改
4. 对映射文件操作
5. 使用`munmap`关闭内存映射

munmap:

```c
int munmap(void* addr, size_t length);
```

和 mmap 配套的系统调用，作用是删除指定地址范围内的内存映射，addr 就是 mmap 返回的起始地址，length 是映射区的大小。当映射关系解除后，对原来映射地址的访问将导致段错误发生。进程结束后这块映射空间也会自动释放。但是相反的是，关闭文件描述符不会 unmap 这块映射。

补充:

[转自 CSDN](https://blog.csdn.net/notbaron/article/details/80019134)这篇写的很详细，还有父子进程通信的东西。

### dup2 dup 复制 duplicate 一个文件描述符

**dup**

函数原型:

```c
#include <unistd.h>


int dup(int oldfd);
int dup2(int oldfd, int newfd);
```

函数接收一个文件描述符，函数执行成功之后返回一个新的文件描述符，失败则返回-1,。

dup()返回的新的文件描述符是当前可用的 fd 中最小的一个。

说白了文件描述符就像是个 handle，本来 open 创建了一个句柄去操作文件，dup 相当于复制了一个句柄，两个 fd 都指向同一个文件的**文件描述结构体**，可以 interchangeably 的去使用(官方装逼)，还是很好理解的。

**dup2**

dup2 就需要复杂一点了。其作用其实也是创建一个指向 oldfd 所指向的文件的新的文件描述符，但是他的做法并不是返回一个新的最小的 fd，而是将某个指定的(newfd)的 fd 指向这个旧的 oldfd，如果这个 newfd 已经被打开，那他会先被 silently 被关闭，然后重新指向 oldfd 所指的文件。

函数原型:

```c
int dup2(int oldfd, int newfd);
```

返回值:

- newfd 的值

注意的点:

- oldfd 如果是一个不合法的文件描述符，会出错返回-1，同时 newfd 不会被关闭
- 如果 oldfd 和 newfd 的值是一样的，那么什么也不做，会返回 newfd

用法:

将标准输出重定向到文件`dup2(n_fd, STDOUT_FILENO)`，实现过程就是先关闭标准输出的 fd(值为 1)，单后将这个 fd 的文件表的指针指向 n_fd 的文件，在执行`printf`的时候实际操作的是标准输出的句柄，所以这样之后将 stdout 输出到了文件句柄所指向的文件。

但是问题来了，重定向之后又如何将 fd 值为 1 的标准输出重定向回到 stdout 呢？

### sysconf 获取系统变量的函数(系统调用)

函数原型:

```c
#include <unistd.h>
long sysconf(int name);
```

### 文件拷贝实现

```c
/*
 * @Author: CoyoteWaltz
 * @Date: 2019-11-04 13:00:18
 * @LastEditors: CoyoteWaltz
 * @LastEditTime: 2019-11-04 14:47:25
 * @Description: 经典拷贝算法
 */
#include <unistd.h>
#include <stdio.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdlib.h>     // exit

// 拷贝文件 参数src_fd: 源文件描述符 des_fd: 目标文件描述符
int copy_file(const int src_fd, const int des_fd);

int main(int argc, char* argv[]) {
    if (argc < 3) {
        // 需要输入的参数有两个文件名 源文件 目标文件
        printf("input error\n");
        exit(-1);
    }
    // 如果源文件没有 退出
    int src_fd = open(argv[1], O_RDONLY);
    int des_fd = open(argv[2], O_CREAT | O_WRONLY | O_TRUNC, 666);  // O_WRONLY 这个读写仅 不太行
    // 尝试用创建的方式打开目标文件 若存在则截断所有内容，若创建则权限为666所有人可读可写
    if (src_fd < 0 || des_fd < 0) {
        // 出错
        printf("file open error src_fd: %d des_fd: %d\n", src_fd, des_fd);
        exit(-1);
    }
    if (copy_file(src_fd, des_fd) == 0) {
        printf("copy successfully!\n");
    }
    else {
        printf("failed!\n");
    }

    close(src_fd);
    close(des_fd);
    return 0;
}

int copy_file(const int src_fd, const int des_fd) {
    // 算法思想 用一个缓存器做类似缓存文件一样的东西 单通的pipe
    // 每次读取一定数量的字节，然后往目的文件写如，直到这一次写完，再尝试
    // 读取一定量的字节，重复上述过程，直到源文件被读完
    int r_cnt, w_cnt;       // 记录读取文件的字符数和写入成功的字符数
    char buff[128];
    char* temp = NULL;
    while ((r_cnt = read(src_fd, buff, sizeof(buff))) > 0) {
        // 这...r_cnt = read()的部分一定要括号括起来 不然就先read() > 0真 返回给r_cnt就只有1了，天坑
        printf("read %dbytes\n", r_cnt);
        // 读取8个字符 注意读完之后文件读写位置指针的也会随之改变 读取从指针位置开始读取
        temp = buff;    // 循环读取文件 利用buff作为缓冲区 这是关键
        while (r_cnt > 0) {
            // 循环直到第一次读的全部写入des
            w_cnt = write(des_fd, temp, r_cnt);  // 这里写的是temp 写的字节数是读到的剩余 多次循环把它全部写完
            // 我觉得这里要判断一下读取是否成功，不然就会死循环了
            if (w_cnt < 0) {
                printf("write error\n");
                return -1;
            }
            printf("write %dbytes\n", w_cnt);
            r_cnt -= w_cnt;
            temp += w_cnt;      // 如果没有全部写完就进入下次循环
        }
    }
    return 0;
}
```

---

## 进程相关

### BB 几句子进程

进程这个东西学过操作系统都有概念。这里不做概念解释，只提几个 linux 中的特殊进程

- pid 为 1 的进程是根进程，创建所有用户进程用的，算是所有进程的父进程，如果 pid1 挂了，就全挂了，如果一个子进程的父进程挂了，这个子进程会被挂到 pid1 下
- pid 为 0 成为 idle(?集成开发环境?)，这个进程是在内核态的，系统自动创建的第一个进程，唯一一个没有用 fork 或者 kernel_thread 产生的线程，

---

### signal 接收信号并处理

实现进程间互相发送中断信号来通知发生了异步事件。知道了发送信号是用来干什么的就好理解了。

函数原型:

```c
#include <signal.h>
typedef void (*sighandler_t)(int);
sighandler_t signal(int signum, sighandler_t handler);
```

`typedef`这一行是定义了一个函数指针 sighandler_t，返回值为空，参数为一个 int(也就是信号值)，这个函数名一目了然了就是 handle 这个 signal 的 handler 函数了。

参数说明:

- signum: 信号值，可在`kill -l`中查到，也可以发送 kill 中没有的信号值
- handler: 处理信号(int)的函数(方法)，可以自己定义 func，或者用系统的:
  - SIG_IGN: 系统的处理方法是，一个 sighandler_t，ING 表示 ignore，忽略此信号
  - SIG_DFL: 系统的 default 方法，也就是 kill 的默认方法。
  - sets the disposition of the signal signum to handler, which is either SIG_IGN, SIG_DFL, or the address of a **programmer-defined** function(a "signal handler").官方的用词 programmer-defined 哈哈

看个实例吧:

```c
#include <stdio.h>
#include <signal.h>

int main() {

	signal(SIGINT, SIG_IGN);
	// SIGINT信号的值是1 相当于是ctrl+c 前台终端进程 选择IGN无视此信号
	for(;;);
	// 不知道为什么不用while(1) 好多人都写的for 死循环
	return 0;
}
```

运行起来之后 ctrl+c 的操作传入进程的指令是无效的，直到用 ctrl+\来传入 SIGQUIT 信号(3)，是 core dump 进程的操作，才停止了进程。

尝试用自己的函数处理信号:

```c
#include <stdio.h>
#include <signal.h>
#include <unistd.h>

void func(int sig) {
	printf("recieved signal: %d\n", sig);
}

int main() {
	printf("pid: %d\n", getpid());
	signal(30, func);
	signal(SIGINT, SIG_IGN);
	// SIGINT信号的值是1 相当于是ctrl+c 前台终端进程 选择IGN无视此信号
	for(;;);
	// 不知道为什么不用while(1) 好多人都写的for 死循环
	return 0;
}

```

打印 pid，然后在另一个终端里面输入`kill -30 pid`可以看到自定义的操作。

### kill

`man 2 kill`这个 2 应该是第二页的意思？如果 man 打开的不是你想要的函数说明，可以在最后的 SEE ALSO 中找到，有比如 open(2)却在 read 中找到的。。。。总之在后面几页找找就对了

send a signal to a process

函数原型:

```c
#include <sys/types.h>
#include <signal.h>

int kill(pid_t pid, int sig);
```

参数说明:

- pid: 进程 id 分多种情况:
  - positive 就当做是 pid
  - 0 将这个信号发送给所有属于这个组的进程，广播
  - -1 发送给除了 1 号进程和自身 (1 号进程一会说)
  - 小于-1 发送给进程是-pid 的进程(...?)
- sig: 发送的信号 若为 0 不发送信号

返回值:

- 成功返回 0(只少一个信号发送成功)
- 失败-1 errno 设置错误信息

### pipe 创建 unidirectional 管道(管道通信)

IPC，Inter-Process Comnication，进程间通信。管道通信和文件缓存通信的最大区别我觉得在于 pipe 方法利用的是内核中的缓存。

函数原型:

```c
#include <unistd.h>
int pipe(int pipefd[2]);
```

参数说明:

- pipefd: 一个 2 维的整数数组，用来存放管道两端(read, write)的文件描述符，Data written to the write end of the pipe is buffered by the kernel until it is read from the read end of the pipe.
  - pipefd[0]: read end
  - pipefd[1]: write end

[图解](https://blog.csdn.net/qq_42914528/article/details/82023408):

![看图](https://img-blog.csdn.net/20161223173958916)

看一段代码:

```c
/*
 * @Author: CoyoteWaltz
 * @Date: 2019-11-06 11:17:43
 * @LastEditors: CoyoteWaltz
 * @LastEditTime: 2019-11-06 12:59:27
 * @Description: 管道 父子进程通信
 */
#include <stdio.h>
#include <stdlib.h>

#include <sys/types.h>
#include <unistd.h>

int main () {
	int pipfd[2];	// 定义管道的 输入端[0] 和输出端[1] 的两个文件描述符
	// char buf[100];
	pipe(pipfd);	// create a pipe
	int* w_fd = &pipfd[1];	// 1 write
	int* r_fd = &pipfd[0];	// 1 read
	if (fork() == 0) {
		// child process 注意子进程拥有父进程的所有资源 包括两个读写pipefd
		// 将stdin重定向到pipe的读取end 将读到的作为输入
		// sleep(1);
		dup2(*r_fd, STDIN_FILENO);
		close(*w_fd);	// 关闭原本拥有的两个文件
		close(*r_fd);
		execl("/usr/bin/sort", "sort", NULL);
	}
	else {		// parent process 将标准输出写入pipe 子进程读取
		// 将标准输出重定向到pipe的写end
		dup2(*w_fd, STDOUT_FILENO);
		close(*r_fd);
		close(*w_fd);
		execl("/bin/ls", "ls", NULL);	// 原本会输出到stdout
	}
	return 0;
}
```

这一段代码利用了管道 pipe 做父子进程间通信，和终端输入`ls | sort`是一个作用

注意:

- ls 命令的可执行位二进制文件在*/bin/ls*，sort 的命令在*/usr/bin/sort*(`whereis sort`)
- execl 函数的输入和输出，后面会讲

### fork create a child process

创建一个子进程，很重要的一个系统调用，从执行`fork()`开始之后，创建一个新的一模一样的子进程，拥有同样的**另一份**代码，数据，和资源，注意是从**执行之后**。父子进程是运行在 separate 内存空间的，一些操作文件映射(mmap)，unmapping(munmap)都互不影响，子进程有自己唯一的 pid，不会继承父进程的 memory locks(mlock)锁定物理内存，su 用户可用，风险高。

函数原型:

```c
#include <sys/types.h>
#include <unistd.h>
pid_t fork(void);
```

返回值:

- 在父进程中 call fork()返回的是子进程的 pid
- 在子进程中返回的是 0
- 创建失败返回-1，errno 设置

看一个简单的例子去理解一下:

```c
#include <unistd.h>
#include <stdio.h>
#include <sys/types.h>
#include <stdlib.h>

int main() {
	int fid = fork();    // 从这一步开始，创建一个新的进程，给新进程复制所有的资源包括fork的返回值给pid
	if (fid == 0) {  // 通过判断pid这个变量来辨别是父进程还是子进程
		printf("child pid %d getpid %d\n", fid, getpid());

	}
	else {
		printf("father pid %d pid %d\n", fid, getpid());
	}
	return 0;
}
```

运行结果:

`father pid 5871 pid 5870`
`child pid 0 getpid 5871`

父进程返回的是子进程的 pid，子进程返回了 0。

再看一段进阶代码:

```c
#include <unistd.h>
#include <stdio.h>
#include <sys/types.h>

int main() {
	int i = 0;
	printf("i: son/pa: ppid: pid fpid\n");
	// 程序会打印以下的变量 i 父还是子 父pid pid fork返回值
	for (i = 0; i < 2; ++i) {
		pid_t fpid = fork(); // 循环开始创建子进程
		if (fpid == 0) {
			printf("%d child %4d %4d %4d\n", i, getppid(), getpid(), fpid);
		}
		else {
			printf("%d parent %4d %4d %4d\n", i, getppid(), getpid(), fpid);
		}
	}
	return 0;
}
```

人工分析如下:

- 程序开始，命名为进程 p1，i=0，进入循环，开始创建子进程，此时的子进程 p11 拥有变量 fpid(0)，i(0)，之后 p1**_打印_**输出 parent
- p1 进入第二个循环，i 为 1，创建子进程 p12，p12 变量 fpid(0)，i(1)，p1**_打印_**输出一行 1 parent p1 的父进程(应该是编译器的?) p1 的 pid fpid 也就是 p12 的 pid，准备下次循环，退出程序。
- p11 执行`fpid==0`的**_打印_**，然后进入第二次循环，此时 p11 的 i 为 1，执行`fork`之后，创建新的进程 p111，p111 拥有的变量 i(1)，fpid(0)，此时 p11 的 fpid 为 p111 的 pid，p11**_打印_**parent 一行，然后结束循环。
- p111 执行`fpid==0`的**_打印_**，然后退出循环。
- p12 进程执行`fpid==0`的**_打印_**，然后由于 i 已经为 1 了，结束循环。
- 综上会出现 6 次输出，不包括第一次的说明

运行结果:

```shell
i: son/pa: ppid: pid fpid
0 parent 4312 8602 8603
1 parent 4312 8602 8604
0 child 8602 8603    0
1 child 8602 8604    0
1 parent 1373 8603 8605
1 child 8603 8605    0
```

多次实验看出父子进程在操作系统的加持下是异步的。4312 应该是 bash 的进程?`ps -ef | grep 4312`

注意第五行的父进程 pid 是三行的进程 pid。

printf 番外:

```c
/*
 * @Author: CoyoteWaltz
 * @Date: 2019-11-06 11:01:20
 * @LastEditors: CoyoteWaltz
 * @LastEditTime: 2019-11-06 11:01:31
 * @Description: printf 缓存机制
 */
#include <unistd.h>
#include <sys/types.h>
#include <stdio.h>

int main() {
    pid_t fid;
    printf("fork!");
    fid = fork();
    if (fid == 0) {
        printf("son pid: %d\n", getpid());
    }
    else {
        printf("parent pid: %d\n", getpid());
    }
    return 0;
}
/*
输出为:
fork!parent pid: 9850
fork!son pid: 9851
*/
```

观察一下发现照理说"fork!"这句话应该只会被父进程打印，但是为什么两个进程都打印了？

原因是`printf()`的缓存机制，只有扫描到`\n`的时候才会`flush`缓存，否则只是缓存在标准输出文件中。所以在 fork 创建子进程的时候将父进程 stdout 文件一起复制给了子进程。总之只要明白子进程复制了父进程当前拥有的所有资源即可。

将`printf("fork!");`改为`printf("fork!\n");`，看一下输出

```shell
fork!
parent pid: 10656
son pid: 10657
```

趣味题:

看一下这段代码创建了多少个子进程(不算 main)

```c
#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>

int main() {
    fork();
    fork() && fork() || fork();
    fork();
    printf("++\n"); // 做个弊
    return 0;
}
```

以上[参考来自博客园](https://www.cnblogs.com/dongguolei/p/8086346.html)

### wait 等待进程的状态改变

其实进程的状态忽略 cpu 分时系统的时候也就只有运行和终止，挂起。所以子进程发生的结束，收到信号被终止，等 state changes 都会被父进程的 wait()所接收。父进程通过这个函数可以做到回收释放子进程的资源。下面细谈一下这个系统调用函数。

函数原型:

```c
#include <sys/types.h>
#include <sys/wait.h>  // wait.h也是可以的

pid_t wait(int* wstatus);
pid_t waitpid(pid_t pid, int* wstatus, int options);
```

参数说明:

- wstatus: 是一个指向 int 类型的一个指针，用来保存子进程状态的。
- pid(waitpid): 这个函数可以指定需要获取状态的进程，pid 可以通过如下几个范围来确定进程:
  - `< -1`: 等待的进程是属于*绝对值 pid*这个数值代表的进程组 ID 的
  - `-1`: 等待所有的子进程
  - `0`: 等待所有父进程所在进程组的子进程
  - `>0`: 等待进程 pid 为 pid 的进程
- options(waitpid): 可选参数

返回值:

- 如果调用这个函数的进程没有子进程，返回-1
- 正常情况返回子进程的 pid

用法:

- 父进程调用的时候会阻塞自己，直到有子进程发生状态的改变：运行结束，被 kill 发送信号，被信号重启。计算机里面是进程都是异步执行，如果父进程执行到这个函数的时候已经有子进程结束了，那么 wait 函数会立即返回，否则父进程会阻塞自己。
- 父进程通过传递的指针收集子进程的信息，如果不需要，传入`NULL`。
- 通常 wait 都是和 fork 配套使用，如果父进程没有 wait 子进程，那么子进程就进入了 zombie 状态。
- wstatus 这个 int(指针)保存的信息需要用宏(macros)来 inspect，`MACROS(wstatus)`，注意他们的参数是 int:
  - WIFEXITED: 如果正常退出返回 true，exit(3) or \_exit(2) or main()的返回。
  - WEXITSTATUS: 返回子进程的退出状态，返回低 8bit 状态值上的二进制数转为整形。说的那么复杂其实也就是如果子进程 exit(5)，父进程里面的 wstatus 通过宏就可以读到 5
  - WIFSIGNALED: 如果是被信号终止的，返回 true

看个例子:

```c
/*
 * @Author: CoyoteWaltz
 * @Date: 2019-11-13 14:07:16
 * @LastEditors: CoyoteWaltz
 * @LastEditTime: 2019-11-13 14:11:30
 * @Description:
 */
#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>
#include <sys/wait.h>
#include <errno.h>
#include <sys/stat.h>
#include <stdlib.h>		// exit

int main() {
	int stat;
	int fid;
	fid = fork();
	if (fid < 0) {
		printf("fork error for %d\n", errno);
	}
	else if (fid == 0) {
		printf("i am child, pid: %d, ppid: %d\n", getpid(), getppid());
		int count = 0;
		for (int i = 0; i < 5; ++i) {
			count++;
			sleep(1);
			printf("count: %d\n", count);
		}
		exit(5);		// 非零的exit都代表异常退出
	}
	else {	// parent
		printf("parent, pid: %d\n", getpid());
		int cid = wait(&stat);
		printf("wait: %d, status: %d\n", cid, stat); // WEXITSTATUS(stat));
	}

	return 0;
}
```

关于宏:

- 也就是 c 语言里面的宏定义 `#define`

- 看了 WEXITSTATUS 的源码

  - ```c
    /* If WIFEXITED(STATUS), the low-order 8 bits of the status.  */
    #define	__WEXITSTATUS(status)	(((status) & 0xff00) >> 8)
    ```

  - 然后自己做了验证，发现如果 exit(4)，得到的 stat 值是 1024(不经过宏)，二进制`0000 0100 0000 0000`，然后与上`0xff00`在右移八位得到`0100`就是 4，就说明这个状态码的值是从第 9 位开始放的，或者说是往后面加了 8 为 0。用 exit(5)测试的结果是 stat 值为 1280(1024 + 256)

  - WIFEXITED 的源码:

  - ```c
    /* Nonzero if STATUS indicates normal termination.  */
    #define	__WIFEXITED(status)	(__WTERMSIG(status) == 0)
    ```

### exec 族(family)函数 execute 一个可执行的二进制文件

函数原型:

```c
#include <unistd.h>
extern char **environ;

int execl(const char *path, const char *arg, ...
                       /* (char  *) NULL */);
int execlp(const char *file, const char *arg, ...
                       /* (char  *) NULL */);
int execle(const char *path, const char *arg, ...
                       /*, (char *) NULL, char * const envp[] */);
int execv(const char *path, char *const argv[]);
int execvp(const char *file, char *const argv[]);
int execvpe(const char *file, char *const argv[], char *const envp[]);

```

参数说明:

- path: 二进制文件所在的路径，比如*/bin/ls*
- arg: 感觉这是一个类似 C++的多参数(名字我忘了 variadic 可变元函数)，也许里面实现也是递归？，**第一个参数是可执行文件的名字，最后一个需要用一个`(char *) NULL`来做结尾**
- file: 如果字符串中带有"/"，则当成是路径名，否则按照*PATH*环境变量名在其中搜索可执行文件

返回值:

- 成功不返回
- 失败返回-1

函数族:

- l: 结尾的 l 代表 list，使用参数列表
- p: p 代表使用文件名，并从 PATH 环境进行寻找可执行文件
- v: 表示应先构造一个指向各参数的指针数组，然后将该数组的地址作为这些函数的参数。
- e: 多了个 envp[]数组，用新的环境变量替代调用进程的环境变量

execl:

- 传递的参数列表: argv[0],argv[1]... 最后一个参数须用空指针 NULL 作结束。
- e.g. : `execl("/bin/ls", "ls", "-al", "/etc/passwd", (char *) NULL`
- 特点: 当进程调用一种 exec 函数时，该进程完全由新程序代换，而新程序则从其 main 函数开始执行。因为调用 exec 并不创建新进程，所以前后的进程 ID 并未改变。exec 只是用另一个新程序替换了当前进程的正文、数据、堆和栈段。用另一个新程序替换了当前进程的正文、数据、堆和栈段。当前进程的正文都被替换了，那么 execl 后的语句，即便 execl 退出了，都不会被执行。（尚未验证）
- 输出的内容好像是默认到 STDOUT 的
