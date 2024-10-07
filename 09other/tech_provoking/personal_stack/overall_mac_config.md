# 2024 My Mac Config

>

## Foreword

## Applications

### [Bruno](https://www.usebruno.com/)

> Replace for postman
>
> `#open_source`

[github](https://github.com/usebruno/bruno)

### [Bob](https://bobtranslate.com/)

> Selection, OCR Translator

### [Charles](https://www.charlesproxy.com/)

> HTTP proxy / HTTP monitor / Reverse Proxy
>
> `#pricing`

### [Dato](https://sindresorhus.com/dato)

> Menu bar calendar and world clocks, plus fullscreen meeting notifications
>
> `#login_start`

### [Espanso](https://espanso.org/)

> One of my favourite apps! Supercharge my editing efficiency!
>
> Written by rust.
>
> `#open_source` `#login_start`

[github](https://github.com/espanso/espanso)

### [Gifski](https://gif.ski/)

> Highest-quality GIF encoder.
>
> `#open_source`

### [IINA](https://iina.io/)

> Best video player for macOS
>
> `#open_source`

[github](https://github.com/iina/iina)

### [MonitorControl](https://github.com/MonitorControl/MonitorControl)

> Control display's brightness & volume on your Mac
>
> `#open_source` `#mac_only` `#login_start`

Installation:

```shell
brew install MonitorControl
```

### [Obsidian](https://obsidian.md/)

> Note application and more
>
> `#icloud_sync`

Installation:

Download from the official website.

### [Raycast](https://www.raycast.com/)

> Shortcut to everything!
>
> `#mac_only` `#login_start`

Installation:

Download from the official website.

Extension store

### [Rectangle](https://rectangleapp.com/)

> Move and resize windows in macOS using keyboard shortcuts or snap areas
>
> `#mac_only` `#open_source`

### [Shottr](https://shottr.cc/)

> Screenshot tool for developers, designers with rich features.
>
> However, I mostly use its "scrolling captrue"
>
> Pricing? Not strickly needed. (single-time purchase)
>
> `#screen_shot` `#mac_only` `#login_start`

Installation:

Download from the website

### [Safari Technology Preview](https://developer.apple.com/safari/technology-preview/)

> Safari Debug for Simulator
>
> `#mac_only`

### [Typora](https://typora.io/)

> Best markdown editor ever.
>
> `#pricing`

### [Visual Studio Code - Insiders](https://code.visualstudio.com/insiders/)

> Clean Green VSC, Yes!

#### user config

```json
{
  "editor.fontSize": 14,
  "editor.fontFamily": "'Monaspace Neon', monospace, 'MesloLGS NF', Menlo, Monaco, 'Courier New', monospace",
  "terminal.external.osxExec": "Warp.app",
  "terminal.integrated.env.osx": {},
  "workbench.sideBar.location": "right",
  "workbench.iconTheme": "icons",
  // 🌟🌟
  "explorer.autoRevealExclude": {
    "**/node_modules": false
  },
  "editor.tabSize": 2,
  "workbench.editor.wrapTabs": true,
  "explorer.fileNesting.enabled": true,
  // 🌟🌟
  "editor.fontLigatures": "'calt', 'ss01', 'ss02', 'ss03', 'ss05', 'ss06', 'ss07', 'ss08', 'ss09', 'liga'",
  "[typescript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[javascript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  // 🌟🌟
  "typescript.referencesCodeLens.enabled": true,
  "terminal.integrated.localEchoStyle": "dim"
}
```

### [Warp](https://www.warp.dev/)

> Yes! terminal App.

### [Xnip](https://xnipapp.com/)

> My favourite Screenshot Tool
>
> `#pricing` `#mac_only`

## Shell Settings

### zsh

### oh my zsh

### starship

### CLI Tools

#### git-extras

> [github](https://github.com/tj/git-extras/blob/main/Installation.md)

Install via brew

```bash
brew install git-extras
```

[Commands](https://github.com/tj/git-extras/blob/main/Commands.md)

### Terminal Prompt

## Programming Settings

### Nodejs

### Rust

### Android

#### ADB

```bash
brew install --cask android-platform-tools
```

## Other

### fonts

#### [Monaspace](https://github.com/githubnext/monaspace#macos)

vscode