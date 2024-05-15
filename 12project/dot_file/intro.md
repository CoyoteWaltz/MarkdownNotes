> Simply archive configurations on Mac with [Github](https://github.com/CoyoteWaltz/dotfiles)

### `.zshrc`

From Working Mac

```bash
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Add flutter path
export PATH="$PATH:$HOME/flutter_dev/flutter/bin"

# Path to your oh-my-zsh installation.
export ZSH="/Users/admin/.oh-my-zsh"

# Path to ruby(brew)
export PATH="/usr/local/opt/ruby/bin:$PATH"

# Path to android sdk
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$PATH:$ANDROID_HOME"
export PATH="$PATH:$ANDROID_HOME/tools"
export PATH="$PATH:$ANDROID_HOME/tools/bin"
export PATH="$PATH:$ANDROID_HOME/platform-tools"


# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="robbyrussell"
#ZSH_THEME="powerlevel10k/powerlevel10k"
# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"
HIST_STAMPS="yyyy-mm-dd"
HISTFILESIZE=100000
HISTFILE=~/.zsh_history
# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
git
autojump
zsh-autosuggestions
zsh-syntax-highlighting
)

bindkey '^v' autosuggest-accept
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#1ABDE6"


source $ZSH/oh-my-zsh.sh

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
# To have commands starting with `rm -rf` in red:
ZSH_HIGHLIGHT_PATTERNS=('rm -rf *' 'fg=white,bold,bg=red')

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


alias ls="exa"
alias tree="exa -T"
alias cb="git branch --show-current | xargs | tr -d '\n' | pbcopy"

export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
#[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export PATH=$PATH:/Users/admin/.bitcode-env/current/bctool
alias python="python3"
#if [[ $TERM_PROGRAM != "WarpTerminal" ]]; then
##### WHAT YOU WANT TO DISABLE FOR WARP - BELOW

# test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

##### WHAT YOU WANT TO DISABLE FOR WARP - ABOVE
#fi
#if [[ $TERM_PROGRAM != "WarpTerminal" ]]; then
##### WHAT YOU WANT TO DISABLE FOR WARP - BELOW

    # POWERLEVEL10K

##### WHAT YOU WANT TO DISABLE FOR WARP - ABOVE
#fi

# pnpm
#export PNPM_HOME="/Users/admin/Library/pnpm"
#export PATH="$PNPM_HOME:$PATH"
# pnpm end

# starship
eval "$(starship init zsh)"
eval "$(zoxide init zsh --cmd cd)"

# fzf
fcd() {
    local dir
    dir=$(find ${1:-.} -type d -not -path '*/\.*' 2> /dev/null | fzf +m) && cd "$dir"
}

# my custom command
sb() {
    if [ -z "$1" ]
        then
            echo "Who?"
            exit -1
    fi
    git stash && git checkout $1
   # git stash pop
}



eval "$(atuin init zsh)"

```

### Espanso

From Working Mac

`config/default.yaml`

```bash
# espanso configuration file

# For a complete introduction, visit the official docs at: https://espanso.org/docs/

# You can use this file to define the global configuration options for espanso.
# These are the parameters that will be used by default on every application,
# but you can also override them on a per-application basis.

# To make customization easier, this file contains some of the commonly used
# parameters. Feel free to uncomment and tune them to fit your needs!

# --- Toggle key

# Customize the key used to disable and enable espanso (when double tapped)
# Available options: CTRL, SHIFT, ALT, CMD, OFF
# You can also specify the key variant, such as LEFT_CTRL, RIGHT_SHIFT, etc...
# toggle_key: ALT
# You can also disable the toggle key completely with
# toggle_key: OFF

# --- Injection Backend

# Espanso supports multiple ways of injecting text into applications. Each of
# them has its quirks, therefore you may want to change it if you are having problems.
# By default, espanso uses the "Auto" backend which should work well in most cases,
# but you may want to try the "Clipboard" or "Inject" backend in case of issues.
# backend: Clipboard

# --- Auto-restart

# Enable/disable the config auto-reload after a file change is detected.
# auto_restart: false

# --- Clipboard threshold

# Because injecting long texts char-by-char is a slow operation, espanso automatically
# uses the clipboard if the text is longer than 'clipboard_threshold' characters.
# clipboard_threshold: 100

# For a list of all the available options, visit the official docs at: https://espanso.org/docs/

# Change search bar shortcut
search_shortcut: ALT+SHIFT+SPACE
# toggle disable shortcut (double pressed)
toggle_key: RIGHT_ALT

```

match/base.yaml

```bash
# espanso match file

# For a complete introduction, visit the official docs at: https://espanso.org/docs/

# You can use this file to define the base matches (aka snippets)
# that will be available in every application when using espanso.

# Matches are substitution rules: when you type the "trigger" string
# it gets replaced by the "replace" string.
matches:
  - trigger: ":->"
    replace: "→"
  - trigger: ":<-"
    replace: "←"
  - trigger: ":js"
    replace: "javascript"
  - trigger: ":ts"
    replace: "typescript"
  - trigger: ":JS"
    replace: "JavaScript"
  - trigger: ":TS"
    replace: "TypeScript"
  - trigger: "elps"
    replace: "ellipsis"
    propagate_case: true
    # word: true
  - trigger: ":div"
    replace: "<div>$|$</div>"
  - trigger: ":afn"
    replace: "() => {$|$}"
  - trigger: ":aafn"
    replace: "async () => {$|$}"
  - trigger: ":gm"
    replace: "$|$git merge origin/master"
  - trigger: ":newp"
    replace: "new Promise((resolve) => {$|$})"
  - trigger: ":lh"
    replace: "localhost"

  - trigger: ":expi"
    replace: "export interface $|$ {}"
  - trigger: ":?n"
    replace: "? ($|$) : null"

  - trigger: ":const"
    replace: "const {} = $|$ || {}"

  # NOTE: espanso uses YAML to define matches, so pay attention to the indentation!

  # But matches can also be dynamic:

  # Print the output of a shell command
  - trigger: ":shell"
    replace: "{{output}}"
    vars:
      - name: output
        type: shell
        params:
          cmd: "echo 'Hello from your shell'"

  # And much more! For more information, visit the docs: https://espanso.org/docs/

  # Print the current now time
  - trigger: ":nowtime"
    replace: "{{now}}"
    vars:
      - name: now
        type: date
        params:
          format: "%Y.%m.%d %k:%M:%S"

  # Print the current now time with local timezone
  - trigger: ":znowtime"
    replace: "{{now}}"
    vars:
      - name: now
        type: date
        params:
          format: "%Y.%m.%d %k:%M:%S %z"

```

packages:

- foreign-thanks
- ip64
- lorem
- script-letters

### `starship_config.toml`

> https://gist.github.com/CoyoteWaltz/03012f85507b7459c0032337ecb6005a

From Working Mac

```bash
command_timeout = 60000
[battery]
full_symbol = "🔋"
charging_symbol = "🔌"
discharging_symbol = "⚡"

[[battery.display]]
threshold = 60
style = "bold red"

[cmd_duration]
min_time = 10_000  # Show command duration over 10,000 milliseconds (=10 sec)
format = "  [$duration]($style)"

[directory]
style = "blue"
read_only = " "

[character]
success_symbol = "[✨](purple)"
error_symbol = "[✖︎](red)"
vicmd_symbol = "[❮](green)"

[git_branch]
symbol = " "
format = "[$symbol$branch]($style)™️ "
style = "yellow"

[git_status]
format = "[[(* $conflicted$untracked$modified$staged$renamed$deleted)](218)($ahead_behind$stashed)]($style)"
ahead = "⇡${count} "
diverged = "⇕⇡${ahead_count}⇣${behind_count} "
behind = "⇣${count} "
style = "cyan"
conflicted = "​[💀$count ](red)​"
untracked = "[?$count ](green)​"
modified = "[!$count ](yellow)"
staged = "[+$count ](green)"
renamed = "🖋️ ​"
deleted = "[🗑$count ](bright-black)"
stashed = "[📦$count ](purple)"
up_to_date = "[ ✓ ](purple)"

[git_state]
format = '\([$state( $progress_current/$progress_total)]($style)\) '
style = "bright-black"

# presets icons https://starship.rs/presets/nerd-font.html
[aws]
symbol = "  "

[buf]
symbol = " "

[c]
symbol = " "

[conda]
symbol = " "

[dart]
symbol = " "

[docker_context]
symbol = " "

[elixir]
symbol = " "

[elm]
symbol = " "

[fossil_branch]
symbol = " "


[golang]
symbol = " "

[guix_shell]
symbol = " "

[haskell]
symbol = " "

[haxe]
symbol = "⌘ "

[hg_branch]
symbol = " "

[java]
symbol = " "

[julia]
symbol = " "

[lua]
symbol = " "

[memory_usage]
symbol = " "

[meson]
symbol = "喝 "

[nim]
symbol = " "

[nix_shell]
symbol = " "

[nodejs]
symbol = " "

[os.symbols]
Alpine = " "
Amazon = " "
Android = " "
Arch = " "
CentOS = " "
Debian = " "
DragonFly = " "
Emscripten = " "
EndeavourOS = " "
Fedora = " "
FreeBSD = " "
Garuda = "﯑ "
Gentoo = " "
HardenedBSD = "ﲊ "
Illumos = " "
Linux = " "
Macos = " "
Manjaro = " "
Mariner = " "
MidnightBSD = " "
Mint = " "
NetBSD = " "
NixOS = " "
OpenBSD = " "
openSUSE = " "
OracleLinux = " "
Pop = " "
Raspbian = " "
Redhat = " "
RedHatEnterprise = " "
Redox = " "
Solus = "ﴱ "
SUSE = " "
Ubuntu = " "
Unknown = " "
Windows = " "

[package]
symbol = " "

[pijul_channel]
symbol = "🪺 "

[python]
symbol = " "

[rlang]
symbol = "ﳒ "

[ruby]
symbol = " "

[rust]
symbol = " "

[scala]
symbol = " "

[spack]
symbol = "🅢 "


```
