### SHELL APPEARANCE / BEHAVIOR ###

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Skip verification of insecure directories for completions
ZSH_DISABLE_COMPFIX="true"

# Paths to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"
ZSH_CUSTOM="${HOME}/.oh-my-zsh/custom/"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME=""

# only needed for non-brew installs e.g. Windows
# fpath+=$HOME/.zsh/pure
fpath+=("$(brew --prefix)/share/zsh/site-functions")

autoload -U promptinit; promptinit
zstyle :prompt:pure:path color white

prompt pure

# Required for some completion plugins (e.g., fzf-tab)
autoload -Uz compinit; compinit

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

plugins=(
    zsh-vi-mode
    git
    colored-man-pages
    fzf
    fzf-tab
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-z
    tmux
)

# Configure fzf, fzf-tab display settings

# disable sort when completing `git checkout`
zstyle ":completion:*:git-checkout:*" sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# preview directory's content with exa when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'

## Run oh-my-zsh script
source $ZSH/oh-my-zsh.sh

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

alias zshconfig="vim ~/.zshrc"
alias vimconfig="vim ~/.vimrc"
alias tmuxconfig="vim ~/.tmux.conf"
alias ohmyzsh="cd ~/.oh-my-zsh"
alias alup="alias | fzf"
alias reload="source ~/.zshrc"
alias python=python3

### THEME/VISUAL CUSTOMIZATION ###

## iTerm 2

# Colorise the top Tabs of Iterm2 with the same color as background
# Just change the 18/26/33 which are the rgb values
# echo -e "\033]6;1;bg;red;brightness;18\a"
# echo -e "\033]6;1;bg;green;brightness;26\a"
# echo -e "\033]6;1;bg;blue;brightness;33\a"

### CUSTOM ###

## Set vim as default editor
# export EDITOR=/usr/local/bin/vim
# export VISUAL=/usr/local/bin/vim

## Auto CD when path is given without command
setopt AUTO_CD

## Add Brew-installed Ruby to PATH
export PATH="/usr/local/opt/ruby/bin:$PATH"

## fzf

# Set main environment variables
export FZF_BASE="/usr/local/bin/fzf"
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --inline-info --border --extended"
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
--color=dark
--color=fg:-1,bg:-1,hl:#5fff87,fg+:-1,bg+:-1,hl+:#ffaf5f
--color=info:#af87ff,prompt:#5fff87,pointer:#ff87d7,marker:#ff87d7,spinner:#ff87d7
'
export FZF_DEFAULT_COMMAND='rg --hidden --no-ignore --files-with-matches --follow "" -g "!{.git}/" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='find . -d -not -path "*/\.git*" 2> /dev/null'

# Keybinding options
export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || bat --color 'always' {} || tree -C {}) 2> /dev/null | head -200'"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

## bat

# Set the syntax highlighting theme for bat
export BAT_THEME="TwoDark"

## Github CLI

# Set main environment variables
export GITHUB_URL="https://github.com"
export GH_HOST="$(echo ${GITHUB_URL} | cut -c 9-)" # removes https://

## nvm

export NVM_DIR="$HOME/.nvm"
    [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" # This loads nvm
    [ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

source $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

### Windows Only ###

# For Loading the SSH key
# /usr/bin/keychain --nogui $HOME/.ssh/id_rsa
# source $HOME/.keychain/DESKTOP-NB83DIC-sh