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
4. Migrate MD files or Make synchronization action or Convert MD repo( Automation for syncing MD repo and publish action)
5. Learn MDX & adapt MDX with local editor(Typora/Obsidian)
6. Polishing content!

## Nextra Page Usage

### How Files Organize

Files(`.md` or `.mdx`) inside `pages` directory will be resolved to a path map which is consumed by the sidebar.

The page title is generate by [title](https://github.com/vercel/title) package or specified in `_meta.json` available in each directory.

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

> Currently I wont use MDX for my Markdown learning notes. And I will use mdx to render some delicate React components for Home/Index/About page directly in the _nextra_ roject.

[MDX](https://mdxjs.com/docs/what-is-mdx/). Writing JSX in markdown for custom components. UI framework agnostic?

Markdown & JSX & JS Expression & ESM & Interleaving.

Interleaving: use markdown “inlines” but not “blocks”(markdown block line) inside JSX if the text and tags are on the same line:

```html
<div># this is not a heading but *this* is emphasis</div>

<div>This is a `p`.</div>
```

#### GFM

Created by [Github](https://github.github.com/gfm/), a markdown extension, support strikethrough, task lists, tables, and more.

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

## Theme Config

https://nextra.site/docs/docs-theme/theme-configuration

## Deploy

I just followed the documentation and created a repo from vercel and it is pretty easy to deploy on vercel.

Use `pnpm next` to publish locally.

Vercel Bot?

## Site Layout

I would like to split the content of this site into several categories as **_Navigations_**:

- _Learning Notes_
- _Reading_
- _Collections/Articles/..._
- _About_

### Navigations

#### Menu

### Pages

### Article

### Homepage

theme config...

## Files Processing

### Universal Rules

1. Cloning Markdown Repo into the project(level 1).
2. File naming convention better be `snake_case`.
3. Each directory better contain a `index` page for introduction.

### Types

Since the config of `meta.json` is complex and abundant, hard for memorizing and batch files manipulate. I need types for precise file-meta generation.

#### Types from Nextra

Found in nextra libs. `packages/nextra/src/normalize-pages.ts`

```typescript
import { PageItem } from "nextra/normalize-pages";
```

### Each Category

#### For learning notes

Every subject directory(depth 1) inside the `02learning_notes` should be flatten to the `pages/` in the project.(Because pages of items in _menu layout_ should be at the first level in Nextra docs)

Then make each subject a `_meta.json` regarding their title & path & hidden route & ...

Important: If a `index` file exists in a directory, there will be the homepage of that directory(topic). And this `index` should be **hidden** in `_meta.json` of that directory.

details:

- subject: first level files/directories under `02learning_notes/`
  - file:

## Trigger Doc Site Build By Markdown Repo

Steps:

- make github actions for _Doc Site Repo_:
  - when PUSH to master branch
  - trigger by _Markdown Repo_
    - refer to [discussion](https://github.com/orgs/community/discussions/26323)
- make github actions for _Markdown Repo_ to trigger

### Details

#### Prerequisite

1. [Github workflow syntax](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions)
2. [Generate personal token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens). Remember grant access permission to all repos(in case of your private repos) and **save the token in somewhere safe**.
3. [Define sercets](https://docs.github.com/en/actions/security-guides/using-secrets-in-github-actions) in Markdown Repo for replace some sensetive info in the workflow dispatch event(below).
4. [Create a workflow dispatch event](https://docs.github.com/en/rest/actions/workflows?apiVersion=2022-11-28#create-a-workflow-dispatch-event).
5. Write actions in Doc Site Repo with [`on workflow_dispatch`](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#workflow_dispatch) to response. You can provide the `ref`(specify the branch or tag) and any `inputs`(you can retrieve the value in context and define inputs in yml)

#### Github Actions Config

Doc Site Repo:

```yml
# .github/workflows/build.yml
on: [workflow_dispatch]
```

Markdown Repo:

```yml
# .github/workflows/notify-portolio.yml
name: Notify Doc Site
run-name: Notify Doc Site To Build 🔧
on:
  push:
    branches:
      - test-workflow
jobs:
  Notify:
    runs-on: ubuntu-latest
    steps:
      - name: Notify
        run: |
          curl -L -X POST -u "${{ secrets.PAT_USERNAME}}:${{ secrets.PAT_TOKEN }}" -H "X-GitHub-Api-Version: 2022-11-28" -H "Authorization: Bearer ${{secrets.PAT_TOKEN}}" -H "Accept: application/vnd.github.everest-preview+json" -H "Content-Type: application/json" https://api.github.com/repos/${{ secrets.PAT_USERNAME }}/${{ secrets.PAT_TRIGGER_REPO_WORKFLOW }}/dispatches --data '{"ref": "main"}'
      - run: echo "🍏 This job's status is ${{ job.status }}."
# Documentation: https://docs.github.com/en/rest/actions/workflows?apiVersion=2022-11-28#create-a-workflow-dispatch-event
```

#### Actions for Vercel build

> refer to [Vercel's document](https://vercel.com/guides/how-can-i-use-github-actions-with-vercel)

## Repo Sundries

eslint-config: https://github.com/antfu/eslint-config

zx with typescript:

- see [issue](https://github.com/google/zx/issues/467#issuecomment-1272383105)
- [tsx](https://github.com/esbuild-kit/tsx)

Nextra Project Example Reference: https://github.com/aidenybai/million/tree/main/website

replace content in file: https://github.com/adamreisnz/replace-in-file
