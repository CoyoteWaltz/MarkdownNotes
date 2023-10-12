## Babel 配置 sourceType

> https://babeljs.io/docs/options#sourcetype
>
> 背景：Babel 编译后 'exports is not defined'
>
> 原因是第三方库输出的代码居然还包含了 es6 的语法，显然只是通过打包将 esm 模块打到了 commonjs，并没有完全将 es6 语法转译到 es5 语法

`sourceType` 选项

- Value Type: `"script" | "module" | "unambiguous"`
- Default: `"module"`

Babel 会默认认为处理的所有文件的模块类型都是 ESM（module），不同的 type 会告诉 Babel 如何解析：

- script：会按照 ECMAScript Script 语法来解析。没有 `import`/`export` 声明语句，也不是 strict mode
- module：会按照 ECMAScript Module 语法来解析。有 `import`/`export` 声明语句，自动会加上 strict mode
- unambiguous：如果文件有`import`/`export` 就认为是 ESM，否则就按照 script 来解析

**unambiguous** 在对处理未知类型的模块，可能是 CommonJS 输出的模块来说，会十分有用，但会有匹配失败的可能，因为他对没有 import/export 的文件会无脑认为是 script 类型匹配。

**这个选项不仅对于 input 的文件解析起作用，还对转化过程有用。**比如一些 `@babel/plugin-transform-runtime` 或者 `@babel/preset-env` 都会根据文件类型来决定是插入 `import` 还是 `require`，所以需要设置正确的类型，避免让本是 CommonJS 的文件误插入了 ESM 的 import。

注意：sourceType 属性对于 `.mjs` 的文件，是不起作用的，因为他 hard code 了 "module"（直接从文件名告诉编译器是 esm 类型）。
