### Background

Found lots of custom font face using base64 formatted source in web projects.

```css
@font-face {
  font-family: "Douyin Sans Number";
  // DouyinNumber-CondensedMedium
  src: url("data:font/opentype;charset=utf-8;base64,xxxx...") format("opentype");
}
```

[How Nextm.js13 optimize fonts.](https://blog.logrocket.com/next-js-font-optimization-custom-google-fonts/)

Font rendering process:

1. Download font source file after parsing HTML.
2. Set `font-display` CSS descriptor to tell browser how to behave during the download.

Problems of font loading:

- [a flash of unstyled text](https://fonts.google.com/knowledge/glossary/fout), otherwise called FOUT. A size shift after font loaded.
- [a flash of invisible text](https://fonts.google.com/knowledge/glossary/foit), otherwise called FOIT. Rendering content after the font loaded.(decided by `font-display`)
- [violating the European Union’s General Data Protection Regulation (GDPR)](https://thehackernews.com/2022/01/german-court-rules-websites-embedding.html)(if the font source is hosted by other server e.g. Google)

`font-size-adjust`

- [css-font-size-adjust-how-to](https://blog.logrocket.com/css-font-size-adjust-how-to/)
- [MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/font-size-adjust#browser_compatibility)

> The **`font-size-adjust`** [CSS](https://developer.mozilla.org/en-US/docs/Web/CSS) property provides a way to modify the size of lowercase letters relative to the size of uppercase letters, which defines the overall [`font-size`](https://developer.mozilla.org/en-US/docs/Web/CSS/font-size). This property is useful for situations where font fallback can occur.

Browser compability: Firefox. XD

[What is variable font and its trade-off](https://blog.logrocket.com/variable-fonts-is-the-performance-trade-off-worth-it/)
