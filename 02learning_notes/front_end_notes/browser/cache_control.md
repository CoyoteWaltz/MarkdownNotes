# Cache Control In Browser

### SWR(stale-while-revalidate)

[MDN](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cache-Control#stale-while-revalidate)

```c++
Cache-Control: max-age=604800, stale-while-revalidate=86400
```

当浏览器收到这个 `stale-while-revalidate` 的返回指令时，会将这份资源在它缓存失效的时候仍作为可用的资源，同时在后台为它重新请求最新资源

上面这个例子就是在 **604800 秒**(7 天)后过期的时候，仍然复用这个资源（最多复用 **86400 秒**（1 天），同时请求新资源，此时页面还是原来的资源，但下一次就用新资源了（如果请求新资源成功）

这样的好处是 _effectively hiding the latency penalty of revalidation from them_ 能够提升在重新请求资源过程中的体验，可能用户看到的是一片空白，但用了这个指令就能优先加载之前虽然已经失效的缓存，用户可以有内容看。
