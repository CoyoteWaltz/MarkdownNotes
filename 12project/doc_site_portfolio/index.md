# Build My Own Doc Site With Nextra

> [Nextra](https://nextra.site/) is site generation framework powered by [Nextjs](https://nextjs.org/). Author is Shuding.
>
> The Doc theme is beautiful with good [code syntax highlight](https://github.com/shikijs/shiki) and i18n(probably not using recently) and [MDX](https://mdxjs.com/blog/v2/) support. Support Full-text search out of box. A11y as a top priority.
>
> Also Nextra has a personal site theme :D.

## WHY

Why I build this project?

Since falling into the programming world, I constantly write notes about What I Learn(in markdown file). Those notes are stored both locally and remotely in the Github repo.

As the content become more and rich, I decided to make a online doc site for i)searching-friendly and more approachable, ii)a chance to re-organize, re-write and re-learn, re-arrange which reducing the _entropy_.

The name of the project will be _Portfolio_.

### Steps

0. Re-arrange my work flow: Recording(`.mdx?` with Obsidian/Typora) → Development(`.mdx?` with Nextra) → CI/CD

1. Play with Nextra
2. **Design the content of the site**
3. Deploy online(Vercel)
4. Migrate MD files or Make synchronization action or Convert MD repo
5. Learn MDX & adapt MDX with local editor(Typora/Obsidian)
6. Polishing content!

## Nextra Page Usage

### How Files Organize

Files(`.md` or `.mdx`) inside `pages` directory will be resolved to a path map which is consumed by the sidebar.

The page title is generate by [link](https://github.com/vercel/title) package or specified in `_meta.json` available in each directory.

Can also be nested.

```json
{
  "index": "My Homepage",
  "contact": "Contact Us",
  "about": {
    "title": "About Us",
    "...extra configurations...": "..."
  }
}
```

### Markdown

#### About MDX

[MDX](https://mdxjs.com/docs/what-is-mdx/). Writing JSX in markdown for custom components. UI framework agnostic?

Markdown & JSX & JS Expression & ESM & Interleaving.

Interleaving: use markdown “inlines” but not “blocks”(markdown block line) inside JSX if the text and tags are on the same line:

```html
<div># this is not a heading but *this* is emphasis</div>

<div>This is a `p`.</div>
```

#### [GFM](https://github.github.com/gfm/)

Created by Github, a markdown extension, support strikethrough, task lists, tables, and more.

#### Autolinks

Auto `<a>` with a valid url.

#### Custom Heading Id

Use format `[#custom-id]` to replace the origin id.

```markdown
## Long heading about Nextra [#about-nextra]
```

### Syntax Highlighting

Nextra uses [Shiki](https://shiki.matsu.io/) to do syntax highlighting at build time.

And a bunch of nice features:

#### Inlined Code

Inlined syntax highlighting like `let x = 1{:jsx}` is also supported via the `{:}` syntax:

```markdown
Inlined syntax highlighting is also supported `let x = 1{:jsx}` via:
```

#### Highlighting Lines

Specific lines of code by adding a `{}` attribute to the code block:

`js {1,4-5}`

```js {1,4-5}
import { useState } from "react";

function Counter() {
  const [count, setCount] = useState(0);
  return <button onClick={() => setCount(count + 1)}>{count}</button>;
}
```

#### Copy Button

`js copy`

#### Line Numbers

`showLineNumbers`

#### Filenames and Titles

`js filename="example.js"`

#### Customize The Theme

Check [doc](https://nextra.site/docs/guide/syntax-highlighting#customize-the-theme) to override CSS variables.

#### With Dynamic Content

Amazing. Check [code](https://github.com/shuding/nextra/blob/main/docs/pages/docs/guide/syntax-highlighting.mdx?plain=1) to see how.

#### Disable Syntax Highlighting

By configuring `codeHighlight: false` in Nextra configuration (`next.config.js` file).

### Nextjs's Magic

With Nextjs's power.

#### SSG

Other data can be fetched and rendered at build-time with `getStaticProps` and `useSSG`(Nextra).

https://nextra.site/docs/guide/ssg

#### [i18n](https://nextra.site/docs/guide/i18n)

#### Links and Images

Links and Images will be rendered by Nextjs's `Link` and `Image`

`staticImage: true` in the Nextra config by default.

#### [LaTex](https://nextra.site/docs/guide/latex)

## Nextra Layout

Config top navigation bar, search bar, pages sidebar...

Lets step into the layout of a doc site.

## [Theme Config](https://nextra.site/docs/docs-theme/theme-configuration)

## Deploy

I just followed the documentation and created a repo from vercel and it is pretty easy to deploy on vercel.

Use `pnpm next` to publish locally.

Vercel Bot?