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


# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
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
# DISABLE_MAGIC_FUNCTIONS=true

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

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    # sourcing vi-mode first so fzf keybindings don't get overwritten
    vi-mode
    git
    colored-man-pages
    fzf
    ripgrep
    aws
    zsh-autosuggestions
    zsh-syntax-highlighting
    virtualenv
    z
    zsh-z
    fzf-tab
)

# Required for some completion plugins (e.g., fzf-tab)
autoload -U compinit && compinit

# Configure fzf, fzf-tab display settings
zstyle ":completion:*:git-checkout:*" sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'

## Run oh-my-zsh script
source $ZSH/oh-my-zsh.sh

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

alias zshconfig="vim ~/.zshrc"
alias vimconfig="vim ~/.vimrc"
alias tmuxconfig="vim ~/.tmux.conf"
alias ohmyzsh="vim ~/.oh-my-zsh"
alias cls="clear"
alias ctree="tree -C"
alias copa="pbcopy; pbpaste"
alias alup="alias | fzf"
alias reload="source ~/.zshrc"
alias tldr="tldr $1 -t base16"
alias gbol='git fetch --prune && git branch -r | awk "{print \$1}" | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk "{print \$1}"'
alias n='~/bin/makenote.sh'
alias mrn='~/bin/getlastnote.sh'


## General custom functions
function astro_ts_utc_local() {
    # Returns UTC timestamp in Airflow format to local time
    # e.g., 2021-02-13T01:54:59.672021Z ➔ Fri Feb 12 20:54:59 EST 2021
    second_precision_time=$(cut -d'.' -f1 <<< ${1:-$(</dev/stdin)})
    date -j -f "%s" $(date -j -u -f "%Y-%m-%dT%T" "${second_precision_time}" "+%s") | tee >(pbcopy)
}


## DBT custom functions

# Cycle DBT logs
function cycle_logs() {
  suffix=$(date '+%Y-%m-%dT%H:%M:%S')
  mv -v logs/dbt.log logs/dbt.log.${suffix}
}

# Run and test one model and/or its up-/down- stream dependencies
function dbt_run_test() {
    models=$1
    echo "Running & testing: ${models}"
    dbt run --models ${models} | tee && dbt test --models ${models} | tee >(pbcopy);
}

# Build downstream dependencies for all models changes in working directory
# Takes optional argument, +, to build downstream dependencies
function dbt_run_changed() {
    children=$1
    if [ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = "true" ]; then
        models="$(git diff --name-only | grep '\.sql$' | awk -F '/' '{ print $NF }' | sed "s/\.sql$/${children}/g" | tr '\n' ' ')"
        echo "Running models: ${models}"
        dbt run --models ${models};
    else
        git rev-parse --git-dir > /dev/null 2>&1;
    fi;
}

# Open dbt_transform in Github
function ghdbt() {
    cd $DBT_PROFILES_DIR && open $(git remote -v | grep fetch | awk '{print $2}' | sed 's/:/\//' | sed 's/git@/http:\/\//' | sed 's/\.git$/\/tree\/master\/transform\/dbt_transforms/')
}

## Github custom functions

# Github open function
function ogh() {
    if [ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = "true" ]; then
        open $(git config remote.origin.url | sed "s/git@\(.*\):\(.*\).git/https:\/\/\1\/\2/")/$1$2;
    else
        git rev-parse --git-dir > /dev/null 2>&1;
    fi;
}

# Open current branch
alias oghb="ogh tree/\$(git symbolic-ref --quiet --short HEAD)"

# Open current directory/file in current branch
alias oghbf="ogh tree/\$(git symbolic-ref --quiet --short HEAD )/\$(git rev-parse --show-prefix)"

# Open current directory/file in master branch
alias oghmf="ogh tree/master/\$(git rev-parse --show-prefix)"

# Added by astro installer
source <(kubectl completion zsh)
[ -f /Users/rdayabhai/.oh-my-zsh/custom/.kubectl_aliases ] && source /Users/rdayabhai/.oh-my-zsh//custom/.kubectl_aliases

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


### THEME/VISUAL CUSTOMIZATION ###

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

## iTerm 2 visual customization settings

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


### FLEXPORT ###

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

## kmo

export KMO_HOME="~/code/kimono"

## Gist

# TODO: Add gist configurations to allow for posting to personal and work
# Github via CLI
export GITHUB_URL="https://github.flexport.io"

# TODO: Write shell function that will set/unset GitHub URL for personal vs.
# work; also include copy and open in browser flags by default

## Github CLI
export GH_HOST="$(echo ${GITHUB_URL} | cut -c 9-)" # removes https://

## helm2
export PATH="/usr/local/opt/helm@2/bin:$PATH"
source <(helm completion zsh)
source <(kubectl completion zsh)
[ -f /Users/rdayabhai/.oh-my-zsh/.kubectl_aliases ] && source /Users/rdayabhai/.oh-my-zsh/.kubectl_aliases


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

# added by Snowflake SnowSQL installer v1.2
export PATH=/Applications/SnowSQL.app/Contents/MacOS:$PATH

# Changes NVM path (required for Datacoral CLI installation)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Datacoral CLI: add to $PATH variable
if [[ ":$PATH:" != *":$HOME/.datacoral/cli/bin:"* ]];
then
  export PATH=$HOME/.datacoral/cli/bin:$PATH
fi
