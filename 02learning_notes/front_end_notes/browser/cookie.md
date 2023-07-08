# About Cookie

### 请求返回 set-cookie 的域名是如何生效的

参考[回答](https://stackoverflow.com/questions/1062963/how-do-browser-cookie-domains-work)

cookie 是在 response 的 header 中的 `set-cookie` 字段，告诉浏览器在对应的域名下存储 cookie

比如：

```bash
store-xxx=abc; Path=/; Domain=xxx.com; Max-Age=31536000; HttpOnly
```

对于域名的处理，According to the RFC 2965, the following should apply:

- If the _Set-Cookie_ header field **does not** have a _Domain_ attribute, the effective domain is the domain of the request.
- If there is a _Domain_ attribute present, its value will be used as effective domain (if the value does not start with a `.` **it will be added by the client**).

意思就是两种情况：

1. 没带 Domain 字段的，会将请求的域名作为 effective domain（存 cookie）
2. 带了 Domain 字段就用这个值，并会进行一些处理
   1. Cookie with `Domain=.example.com` **will** be available for _`www.example.com`_ or _`abc.example.com`_
   2. Cookie with `Domain=.example.com` **will** be available for _`example.com`_
   3. Cookie with `Domain=example.com` will be converted to `.example.com` and thus **will** also be available for _`www.example.com`_
   4. Cookie with `Domain=example.com` will **not** be available for _`anotherexample.com`_

**_set cookie 是如此，read cookie 也遵循这个规则_**
