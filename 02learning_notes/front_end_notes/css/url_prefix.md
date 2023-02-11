## @-moz-document url-prefix 做了什么

> [stackoverflow](https://stackoverflow.com/questions/3123063/what-does-moz-document-url-prefix-do)

`@-moz-` 是针对 Gecko-engine-specific 的 CSS at rule，Mozilla 定制的插件

`url-prefix` 是针对 url 以某 prefix 开头的规则，如果是 `url-prefix()` 就是对于所有页面

所以可以针对 Mozilla Firefox 做一些 hack
