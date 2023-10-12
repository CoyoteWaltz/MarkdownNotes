## CSP

Content Security Policy——内容安全协议

**开发者明确告诉客户端（制定比较严格的策略和规则），哪些外部资源是可以加载和执行的 ，即使攻击者发现漏洞，但是它是没办法注入脚本的**，简单来说，就是我们能够规定，我们的网站只接受我们指定的请求资源。

也是基于浏览器同源策略的，防范**跨网站脚本 XSS**

### 开启 CSP

#### 响应头中添加字段：

Content-Security-Policy

```json
"Content-Security-Policy:" 策略
"Content-Security-Policy-Report-Only:" 策略
```

其中 `Content-Security-Policy-Report-Only` 是仅上报，也就是浏览器不会真的拦截这些不在限制策略里的资源，会上报到指定的 endpoint api

- 上报：通过策略中 `report-to xxxxxx` 字段，告诉取 header 中的那个 key
- header 中配置 `reporting-endpoints: "xxxxxx=\"https://xxxx.api.com/path/?query=123\""`

#### `<meta>`标签

```html
<meta http-equiv="Content-Security-Policy" content="script-src 'self'" />
```

这里的 content 就是策略，表示 script 的来源只能是自身的源

### CSP 的作用

防 XSS 等攻击的利器。CSP 的实质就是白名单制度，开发者明确告诉客户端，哪些外部资源可以加载和执行，等同于提供白名单。它的实现和执行全部由浏览器完成，开发者只需提供配置。CSP 大大增强了网页的安全性。攻击者即使发现了漏洞，也没法注入脚本，除非还控制了一台列入了白名单的可信主机。

### 例子

```json
// 限制所有的外部资源，都只能从当前域名加载
Content-Security-Policy: default-src 'self'

// default-src 是 CSP 指令，多个指令之间用英文分号分割；多个指令值用英文空格分割
Content-Security-Policy: default-src https://host1.com https://host2.com; frame-src 'none'; object-src 'none'

// 错误写法，第二个指令将会被忽略
Content-Security-Policy: script-src https://host1.com; script-src https://host2.com

// 正确写法如下
Content-Security-Policy: script-src https://host1.com https://host2.com

// 通过report-uri指令指示浏览器发送JSON格式的拦截报告到某个地址
Content-Security-Policy: default-src 'self'; ...; report-uri /my_amazing_csp_report_parser;
```

响应头的 CSP 字段告诉浏览器这份资源可以让符合什么策略的客户端来加载
