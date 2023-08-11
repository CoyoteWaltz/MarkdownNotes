# 纯 CSS 实现 modals

> 用 CSS 来实现对话框，没想到吧
>
> 核心原理：CSS 选择器`:target`
>
> 参考来自：https://denic.hashnode.dev/css-tips-you-wont-see-in-most-tutorials

不过这个对话框的出现场景是需要**用户点击**的操作的才出现的

- 关键是让点击操作是一个 a 标签，激活锚点 `#anchor`
- 让锚点的 `:target` 选择器命中之后，让对话框出现，可以是改变 visibility
- 在关闭对话框的操作也需要改变 hash

当然点击操作也可以换成其他的方式，比如直接改变 url 的 hash

这样的方式不足之处就在于需要改变 hash，当然 hash 也只有一个

下面直接看源码吧

### Source code

```html
<!--
 * @Author: CoyoteWaltz <coyote_waltz@163.com>
 * @Date: 2021-01-31 22:23:37
 * @LastEditTime: 2021-01-31 22:34:35
 * @LastEditors: CoyoteWaltz <coyote_waltz@163.com>
 * @Description: css modal
 * @TODO: 
-->
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Document</title>
    <style>
      .wrapper {
        height: 100vh;
        /* This part is important for centering the content */
        display: flex;
        align-items: center;
        justify-content: center;
        /* End center */
        background: -webkit-linear-gradient(to right, #834d9b, #d04ed6);
        background: linear-gradient(to right, #834d9b, #d04ed6);
      }

      .wrapper a {
        display: inline-block;
        text-decoration: none;
        padding: 15px;
        background-color: #fff;
        border-radius: 3px;
        text-transform: uppercase;
        color: #585858;
        font-family: "Roboto", sans-serif;
      }

      .modal {
        visibility: hidden;
        opacity: 0;
        position: absolute;
        top: 0;
        right: 0;
        bottom: 0;
        left: 0;
        display: flex;
        align-items: center;
        justify-content: center;
        background: rgba(77, 77, 77, 0.7);
        transition: all 0.4s;
      }

      .modal:target {
        visibility: visible;
        opacity: 1;
      }

      .modal__content {
        border-radius: 4px;
        position: relative;
        width: 500px;
        max-width: 90%;
        background: #fff;
        padding: 1em 2em;
      }

      .modal__footer {
        text-align: right;
      }

      .modal__footer a {
        color: #585858;
      }
      .modal__footer i {
        color: #d02d2c;
      }
      .modal__close {
        position: absolute;
        top: 10px;
        right: 10px;
        color: #585858;
        text-decoration: none;
      }
    </style>
  </head>
  <body>
    <div class="wrapper">
      <a href="#demo-modal">Open Demo Modal</a>
    </div>

    <div id="demo-modal" class="modal">
      <div class="modal__content">
        <h1>CSS Only Modal</h1>

        <p>
          You can use the :target pseudo-class to create a modals with Zero
          JavaScript. Enjoy!
        </p>

        <div class="modal__footer">
          Made with <i class="fa fa-heart"></i>, by
          <a href="https://twitter.com/denicmarko" target="_blank"
            >@denicmarko</a
          >
        </div>

        <a href="#" class="modal__close">&times;</a>
      </div>
    </div>
    <script>
      setTimeout(() => {
        // window.history.pushState({}, 'test', '#demo-modal');
        window.location.hash = "#demo-modal"; // 改变 hash 就可以激活哦
      }, 2000);
    </script>
  </body>
</html>
```
