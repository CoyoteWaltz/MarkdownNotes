# 2024 My Mac Config

> For work and personal usage.

## Foreword

## Applications

### [Bruno](https://www.usebruno.com/)

> Replacement for postman
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

### [Aerospace](https://github.com/nikitabobko/AeroSpace)

> tiling window manager for macOS
>
> `#mac_only` `#open_source`
>
> TODO: add focus [border](https://github.com/FelixKratz/JankyBorders)

My Config:

```toml
# Place a copy of this config to ~/.aerospace.toml
# After that, you can edit ~/.aerospace.toml to your liking

# You can use it to add commands that run after login to macOS user session.
# 'start-at-login' needs to be 'true' for 'after-login-command' to work
# Available commands: https://nikitabobko.github.io/AeroSpace/commands
after-login-command = []

# You can use it to add commands that run after AeroSpace startup.
# 'after-startup-command' is run after 'after-login-command'
# Available commands : https://nikitabobko.github.io/AeroSpace/commands
after-startup-command = []

# Start AeroSpace at login
start-at-login = true

# Normalizations. See: https://nikitabobko.github.io/AeroSpace/guide#normalization
enable-normalization-flatten-containers = true
enable-normalization-opposite-orientation-for-nested-containers = true

# See: https://nikitabobko.github.io/AeroSpace/guide#layouts
# The 'accordion-padding' specifies the size of accordion padding
# You can set 0 to disable the padding feature
accordion-padding = 30

# Possible values: tiles|accordion
default-root-container-layout = 'tiles'

# Possible values: horizontal|vertical|auto
# 'auto' means: wide monitor (anything wider than high) gets horizontal orientation,
#               tall monitor (anything higher than wide) gets vertical orientation
default-root-container-orientation = 'auto'

# Mouse follows focus when focused monitor changes
# Drop it from your config, if you don't like this behavior
# See https://nikitabobko.github.io/AeroSpace/guide#on-focus-changed-callbacks
# See https://nikitabobko.github.io/AeroSpace/commands#move-mouse
# Fallback value (if you omit the key): on-focused-monitor-changed = []
on-focused-monitor-changed = ['move-mouse monitor-lazy-center']
on-focus-changed = ['move-mouse window-lazy-center'] # Mouse lazily follows any focus (window or workspace)

# You can effectively turn off macOS "Hide application" (cmd-h) feature by toggling this flag
# Useful if you don't use this macOS feature, but accidentally hit cmd-h or cmd-alt-h key
# Also see: https://nikitabobko.github.io/AeroSpace/goodies#disable-hide-app
automatically-unhide-macos-hidden-apps = false

# Possible values: (qwerty|dvorak|colemak)
# See https://nikitabobko.github.io/AeroSpace/guide#key-mapping
[key-mapping]
    preset = 'qwerty'

# Gaps between windows (inner-*) and between monitor edges (outer-*).
# Possible values:
# - Constant:     gaps.outer.top = 8
# - Per monitor:  gaps.outer.top = [{ monitor.main = 16 }, { monitor."some-pattern" = 32 }, 24]
#                 In this example, 24 is a default value when there is no match.
#                 Monitor pattern is the same as for 'workspace-to-monitor-force-assignment'.
#                 See:
#                 https://nikitabobko.github.io/AeroSpace/guide#assign-workspaces-to-monitors
[gaps]
    inner.horizontal = 8
    inner.vertical =   8
    outer.left =       0
    outer.bottom =     0
    outer.top =        0
    outer.right =      0

# 'main' binding mode declaration
# See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
# 'main' binding mode must be always presented
# Fallback value (if you omit the key): mode.main.binding = {}
[mode.main.binding]

    # All possible keys:
    # - Letters.        a, b, c, ..., z
    # - Numbers.        0, 1, 2, ..., 9
    # - Keypad numbers. keypad0, keypad1, keypad2, ..., keypad9
    # - F-keys.         f1, f2, ..., f20
    # - Special keys.   minus, equal, period, comma, slash, backslash, quote, semicolon,
    #                   backtick, leftSquareBracket, rightSquareBracket, space, enter, esc,
    #                   backspace, tab, pageUp, pageDown, home, end, forwardDelete,
    #                   sectionSign (ISO keyboards only, european keyboards only)
    # - Keypad special. keypadClear, keypadDecimalMark, keypadDivide, keypadEnter, keypadEqual,
    #                   keypadMinus, keypadMultiply, keypadPlus
    # - Arrows.         left, down, up, right

    # All possible modifiers: cmd, alt, ctrl, shift

    # All possible commands: https://nikitabobko.github.io/AeroSpace/commands

    # See: https://nikitabobko.github.io/AeroSpace/commands#exec-and-forget
    # You can uncomment the following lines to open up terminal with alt + enter shortcut
    # (like in i3)
    # alt-enter = '''exec-and-forget osascript -e '
    # tell application "Terminal"
    #     do script
    #     activate
    # end tell'
    # '''

    ctrl-alt-enter = 'fullscreen'

    # See: https://nikitabobko.github.io/AeroSpace/commands#layout
    alt-slash = 'layout tiles horizontal vertical'
    alt-comma = 'layout accordion horizontal vertical'

    # See: https://nikitabobko.github.io/AeroSpace/commands#focus
    alt-h = 'focus left'
    alt-j = 'focus down'
    alt-k = 'focus up'
    alt-l = 'focus right'

    # See: https://nikitabobko.github.io/AeroSpace/commands#move
    alt-shift-h = 'move left'
    alt-shift-j = 'move down'
    alt-shift-k = 'move up'
    alt-shift-l = 'move right'

    # See: https://nikitabobko.github.io/AeroSpace/commands#resize
    alt-minus = 'resize smart -50'
    alt-equal = 'resize smart +50'

    # See: https://nikitabobko.github.io/AeroSpace/commands#workspace
    alt-1 = 'workspace 1'
    alt-2 = 'workspace 2'
    alt-3 = 'workspace 3'
    alt-4 = 'workspace 4'
    alt-5 = 'workspace 5'
    alt-6 = 'workspace 6'
    alt-7 = 'workspace 7'
    alt-8 = 'workspace 8'
    alt-9 = 'workspace 9'
    alt-a = 'workspace A' # In your config, you can drop workspace bindings that you don't need
    alt-b = 'workspace B'
    alt-c = 'workspace C'
    # alt-d = 'workspace D'
    alt-e = 'workspace E'
    # alt-f = 'workspace F'
    # alt-g = 'workspace G'
    # alt-i = 'workspace I'
    # alt-m = 'workspace M'
    alt-n = 'workspace N'
    # alt-o = 'workspace O'
    # alt-p = 'workspace P'
    # alt-q = 'workspace Q'
    # alt-r = 'workspace R'
    alt-s = 'workspace S'
    alt-t = 'workspace T'
    # alt-u = 'workspace U'
    # alt-v = 'workspace V'
    # alt-w = 'workspace W'
    # alt-x = 'workspace X'
    # alt-y = 'workspace Y'
    # alt-z = 'workspace Z'

    # See: https://nikitabobko.github.io/AeroSpace/commands#move-node-to-workspace
    alt-shift-1 = 'move-node-to-workspace 1'
    alt-shift-2 = 'move-node-to-workspace 2'
    alt-shift-3 = 'move-node-to-workspace 3'
    alt-shift-4 = 'move-node-to-workspace 4'
    alt-shift-5 = 'move-node-to-workspace 5'
    alt-shift-6 = 'move-node-to-workspace 6'
    alt-shift-7 = 'move-node-to-workspace 7'
    alt-shift-8 = 'move-node-to-workspace 8'
    alt-shift-9 = 'move-node-to-workspace 9'
    alt-shift-a = 'move-node-to-workspace A'
    alt-shift-b = 'move-node-to-workspace B'
    alt-shift-c = 'move-node-to-workspace C'
    # alt-shift-d = 'move-node-to-workspace D'
    alt-shift-e = 'move-node-to-workspace E'
    # alt-shift-f = 'move-node-to-workspace F'
    # alt-shift-g = 'move-node-to-workspace G'
    # alt-shift-i = 'move-node-to-workspace I'
    # alt-shift-m = 'move-node-to-workspace M'
    alt-shift-n = 'move-node-to-workspace N'
    # alt-shift-o = 'move-node-to-workspace O'
    # alt-shift-p = 'move-node-to-workspace P'
    # alt-shift-q = 'move-node-to-workspace Q'
    # alt-shift-r = 'move-node-to-workspace R'
    alt-shift-s = 'move-node-to-workspace S'
    alt-shift-t = 'move-node-to-workspace T'
    # alt-shift-u = 'move-node-to-workspace U'
    # alt-shift-v = 'move-node-to-workspace V'
    # alt-shift-w = 'move-node-to-workspace W'
    # alt-shift-x = 'move-node-to-workspace X'
    # alt-shift-y = 'move-node-to-workspace Y'
    # alt-shift-z = 'move-node-to-workspace Z'

    # See: https://nikitabobko.github.io/AeroSpace/commands#workspace-back-and-forth
    alt-tab = 'workspace-back-and-forth'
    # See: https://nikitabobko.github.io/AeroSpace/commands#move-workspace-to-monitor
    alt-shift-tab = 'move-workspace-to-monitor --wrap-around next'

    # See: https://nikitabobko.github.io/AeroSpace/commands#mode
    alt-shift-semicolon = 'mode service'

# 'service' binding mode declaration.
# See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
[mode.service.binding]
    esc = ['reload-config', 'mode main']
    r = ['flatten-workspace-tree', 'mode main'] # reset layout
    f = ['layout floating tiling', 'mode main'] # Toggle between floating and tiling layout
    backspace = ['close-all-windows-but-current', 'mode main']

    # sticky is not yet supported https://github.com/nikitabobko/AeroSpace/issues/2
    #s = ['layout sticky tiling', 'mode main']

    alt-shift-h = ['join-with left', 'mode main']
    alt-shift-j = ['join-with down', 'mode main']
    alt-shift-k = ['join-with up', 'mode main']
    alt-shift-l = ['join-with right', 'mode main']

    down = 'volume down'
    up = 'volume up'
    shift-down = ['volume set 0', 'mode main']

[[on-window-detected]]
if.app-id = "dev.warp.Warp-Stable"
run = "move-node-to-workspace T"

[[on-window-detected]]
if.app-id = "com.google.Chrome"
run = "move-node-to-workspace B"

[[on-window-detected]]
if.app-id = "abnerworks.Typora"
run = "move-node-to-workspace N"

[[on-window-detected]]
if.window-title-regex-substring = "Cursor"
run = "move-node-to-workspace C"

```

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
  // "editor.fontLigatures": "'calt'", // text healing only
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

Plugins:

- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md)
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)

### oh my zsh

### starship

### CLI Tools

#### [zoxide](https://github.com/ajeetdsouza/zoxide)

> Better `cd`

Config in zshrc:

```bash
eval "$(zoxide init zsh --cmd cd)"  # replace original cd
```

#### [eza](https://github.com/eza-community/eza)

> A modern alternative to `ls`
>
> BTW: [exa](https://github.com/ogham/exa) is unmaintained.

Config in zshrc:

```bash
alias ls="eza"
alias tree="eza -T"
```

#### [SCC](https://github.com/boyter/scc)

> A tool similar to **cloc**, sloccount and tokei. For counting physical the lines of code, blank lines, comment lines, and physical lines of source code in many programming languages.
>
> **S**uccinct **C**ode **C**ounter

#### [git-extras](https://github.com/tj/git-extras/blob/main/Installation.md)

>

Install via brew

```bash
brew install git-extras
```

[Commands](https://github.com/tj/git-extras/blob/main/Commands.md)

### Terminal Prompt

## Programming Language Settings

### Nodejs

Use fnm to install different versions of Nodejs.

### Rust

### Android

#### ADB

```bash
brew install --cask android-platform-tools
```

## Development Env

### VS Code

#### Extensions

#### Themes

## Other

### fonts

#### [Monaspace](https://github.com/githubnext/monaspace#macos)

vscode

#### Meslo Nerd Font

> download source from [powerlevel10k](https://github.com/romkatv/powerlevel10k/blob/master/font.md)
