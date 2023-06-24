# 移动端的坑们

### 阻止页面滑动

主要场景是在 IOS safari 浏览器，input 聚焦的时候，会顶起页面，并且会让长度溢出 viewport 的 div 变得可滚动，不符合预期

需要禁止滚动

```typescript
// 阻止默认的滚动行为
function preventDefaultScroll(event: Event) {
  event.preventDefault();
}

// 禁止页面滑动 for 移动端
function disableTouchScroll() {
  document.addEventListener("touchmove", preventDefaultScroll, {
    passive: false,
  });
}

// 允许页面滑动
function enableTouchScroll() {
  document.removeEventListener("touchmove", preventDefaultScroll);
}

// 禁止滚动
export function disableScroll() {
  // 获取当前滚动位置
  const scrollTop =
    window.pageYOffset ||
    document.documentElement.scrollTop ||
    document.body.scrollTop;
  const scrollLeft =
    window.pageXOffset ||
    document.documentElement.scrollLeft ||
    document.body.scrollLeft;

  const stopScroll = () => {
    window.scrollTo(scrollLeft, scrollTop);
  };
  // 保持滚动位置不变，并禁用滚动条
  window.addEventListener("scroll", stopScroll);
  disableTouchScroll();
  return () => {
    // 允许滚动
    window.removeEventListener("scroll", stopScroll);
    enableTouchScroll();
  };
}
```
