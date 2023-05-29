# storybook 使用

> 用了这个知名 [storybook](https://github.com/storybookjs/storybook)，a frontend workshop for building UI components and pages in isolation，目的是为了进行组件库的开发、测试、文档站

## Intro

## 踩坑

### 开启 dev server 的 proxy

希望在 dev 的时候把接口请求 map 到指定的 api 域名上

搜了很多，也没个啥结果，插件体系说实话感觉也不太好用？最终，在这个 [pr](https://github.com/seek-oss/sku/pull/787) 上找到在 `.storybook/middleware.js`（[intentionally undocumented feature](https://github.com/storybookjs/storybook/issues/15300#issuecomment-866469521), but given that it has been stable for [at least 5 years](https://github.com/storybookjs/storybook/blame/e22ac0d0e8f5cec6cd8e10ef34aa66f758335fbf/code/lib/core-server/src/utils/middleware.ts#L17),）里面写中间件

_离谱的是这个 `middleware.js` 居然没有官方的文档说明，但是也跑了好几年_

这个 [issue](https://github.com/storybookjs/storybook/issues/208) 给出了用 `http-proxy-middleware` 来作为 app（express 应用？）的中间件

```javascript
const { createProxyMiddleware } = require("http-proxy-middleware");

module.exports = function (app) {
  app.use(
    "/api",
    createProxyMiddleware({
      target: "https://xxx.com",
      changeOrigin: true,
    })
  );
};
```
