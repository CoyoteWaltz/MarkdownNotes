### FontFace

[MDN](https://developer.mozilla.org/en-US/docs/Web/API/FontFace/FontFace)

使用浏览器提供的 `FontFace` API 来动态的增加字体

```javascript
async function loadFonts() {
  const font = new FontFace("my-font", "url(my-font.woff)", {
    style: "normal",
    weight: "400",
    stretch: "condensed",
  });
  // wait for font to be loaded
  await font.load();
  // add font to document
  document.fonts.add(font);
  // enable font with CSS class
  document.body.classList.add("fonts-loaded");
}
```

document.fonts 同样能获取到当前全部的字体集（FontFaceSet）

```javascript
document.fonts.ready.then((fontFaceSet) => {
	...
}
```

浏览器兼容性：基本都支持

PS：[检测字体是否加载完成的库](https://github.com/bramstein/fontfaceobserver)

### 字体切割

https://github.com/KonghaYao/cn-font-split
