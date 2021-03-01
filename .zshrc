### SHELL APPEARANCE / BEHAVIOR ###

# Set environment variable so terminal emulators (JupyterLab)
# can use a richer set of colors and Dracula theme can render italics
export TERM="xterm-256color-italic"

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/rdayabhai/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Use patched Awesome Powerline fonts (for icons)
POWERLEVEL9K_MODE='nerdfont-complete'

# Required for some completion plugins (e.g., fzf-tab)
autoload -U compinit && compinit

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    # sourcing vi-mode first so fzf keybindings don't get overwritten
    vi-mode
    git
    gitfast
    colored-man-pages
    fzf
    fzf-tab
    ripgrep
    aws
    zsh-autosuggestions
    zsh-syntax-highlighting
    virtualenv
    zsh-z
    tmux
)

# Configure fzf, fzf-tab display settings
zstyle ":completion:*:git-checkout:*" sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
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
alias cls="clear"
alias ctree="tree -C"
alias copa="pbcopy; pbpaste"
alias alup="alias | fzf"
alias reload="source ~/.zshrc"
alias tldr="tldr $1 -t base16"
alias gbol='git fetch --prune && git branch -r | awk "{print \$1}" | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk "{print \$1}"'
alias gsdb='~/bin/save_dangling_blob.sh'
alias n='~/bin/makenote.sh'
alias mrn='~/bin/getlastnote.sh'

## Run custom scripts
source ~/bin/airflow_timestamp_conversion_to_local_time.sh
source ~/bin/dbt_helpers.sh
bash ~/bin/localhost_bind.sh


### THEME/VISUAL CUSTOMIZATION ###

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Let vi-mode plugin change cursor based on mode
VI_MODE_SET_CURSOR=true

# Add custom icon to prompt
POWERLEVEL9K_CUSTOM_OS_ICON='echo 🌞'
POWERLEVEL9K_CUSTOM_OS_ICON_BACKGROUND='black'

# Abbreviate long directory paths
POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
POWERLEVEL9K_SHORTEN_STRATEGY='truncate_beginning'

# Elements options of left prompt (remove the @username context)
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(custom_os_icon virtualenv dir)

# Elements options of right prompt
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(vcs command_execution_time status root_indicator background_jobs)

# Add a second prompt line
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_RPROMPT_ON_NEWLINE=true

# Add a space in the first prompt
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX='%F{#8be9fd}╭─%F{black}'
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX='%F{#8be9fd}╰%F{yellow1}%F{khaki1}%F{cornsilk1}%f '

# Virtual environment segment settings
POWERLEVEL9K_VIRTUALENV_BACKGROUND='black'
POWERLEVEL9K_VIRTUALENV_FOREGROUND='white'

# Git status colors
POWERLEVEL9K_VCS_CLEAN_FOREGROUND='black'
POWERLEVEL9K_VCS_CLEAN_BACKGROUND='green'
POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='black'
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='yellow'
POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='white'
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='red'

# Command execution time
POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='grey'

# Add a new line after the global prompt
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

# Date format
POWERLEVEL9K_TIME_FORMAT='%D{%I:%M %p}'

# Remove space on right-side prompt
ZLE_RPROMPT_INDENT=0

## iTerm 2

# Colorise the top Tabs of Iterm2 with the same color as background
# Just change the 18/26/33 which are the rgb values
echo -e "\033]6;1;bg;red;brightness;18\a"
echo -e "\033]6;1;bg;green;brightness;26\a"
echo -e "\033]6;1;bg;blue;brightness;33\a"

### CUSTOM ###

## Set vim as default editor
export EDITOR=/usr/local/bin/vim
export VISUAL=/usr/local/bin/vim

## Auto CD when path is given without command
setopt AUTO_CD

## Add location of custom Python modules to PYTHONPATH
export PYTHONPATH="${PYTHONPATH}:~/code/analysis/custom_scripts/"

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
export BAT_THEME="Dracula"

## AWS

export PATH="/usr/local/opt/awscli@1/bin:$PATH"
export PATH="/usr/local/opt/awscli@1/bin/aws_completer:$PATH"
autoload bashcompinit && bashcompinit
complete -C '/usr/local/opt/awscli@1/bin/aws_completer' aws

## DBT & Snowflake
export SNOWFLAKE_WAREHOUSE_XS="DBT_DEV_XS"
export SNOWFLAKE_WAREHOUSE_M="DBT_DEV_M"
export SNOWFLAKE_WAREHOUSE_L="DBT_DEV_L"
export SNOWFLAKE_USERNAME='rdayabhai@flexport.com'
export DBT_PROFILES_DIR="/Users/rdayabhai/code/kimono/transform/dbt_transforms"
export SNOWFLAKE_USER='RDAYABHAI@FLEXPORT.COM'
export SNOWFLAKE_ROLE='SYSADMIN'
export SNOWFLAKE_PRIVATE_KEY_PATH="~/.ssh/snowflake_key"

# SnowSQL
export PATH=/Applications/SnowSQL.app/Contents/MacOS:$PATH

## Astro
source <(kubectl completion zsh)
[ -f /Users/rdayabhai/.oh-my-zsh/custom/.kubectl_aliases ] && source /Users/rdayabhai/.oh-my-zsh//custom/.kubectl_aliases

## kmo

export KMO_HOME="~/code/kimono"

## helm2
export PATH="/usr/local/opt/helm@2/bin:$PATH"
source <(helm completion zsh)
source <(kubectl completion zsh)
[ -f /Users/rdayabhai/.oh-my-zsh/.kubectl_aliases ] && source /Users/rdayabhai/.oh-my-zsh/.kubectl_aliases

## Github CLI
# TODO: gist is being outcompeted by consolidated github CLI (gh)
export GITHUB_URL="https://github.flexport.io"
export GH_HOST="$(echo ${GITHUB_URL} | cut -c 9-)" # removes https://

## Datacoral CLI

# Changes NVM path (required for Datacoral CLI installation)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Add to $PATH variable
if [[ ":$PATH:" != *":$HOME/.datacoral/cli/bin:"* ]];
then
  export PATH=$HOME/.datacoral/cli/bin:$PATH
fi


### ENVIRONMENT MANAGEMENT ###

## pipenv

# Shell completions
eval "$(pipenv --completion)"

## pyenv + pyenv-virtualenv

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv virtualenv-init -)"
eval "$(pyenv init -)"
export PYTHON_CONFIGURE_OPTS="--enable-framework"
# export WORKON_HOME=~/.virtualenv
# export PROJECT_HOME=~/workspace

## virtualenvwrapper

export VIRTUALENVWRAPPER_PYTHON=/Users/rdayabhai/.pyenv/versions/3.8.6/bin/python3
export WORKON_HOME=$HOME/venvs
export PROJECT_HOME=$HOME/code
source /Users/rdayabhai/.pyenv/versions/3.8.6/bin/virtualenvwrapper.sh

# Working directory changed during the post activate phase
export VIRTUALENVWRAPPER_WORKON_CD=1
