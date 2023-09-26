# Rust
 . "$HOME/.cargo/env"

# Go
export GOPATH=/Users/$USER/go
export PATH=$GOPATH/bin:$PATH

# Ruby
export PATH="/usr/local/opt/ruby/bin:$PATH"
# point to $(brew --prefix openssl@3)
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=/opt/homebrew/opt/openssl@3" # for ruby to use openssl 3

### Set vim as default editor
# export EDITOR=/usr/local/bin/vim
# export VISUAL=/usr/local/bin/vim

# For compilers to find sqlite (brew installed) you may need to set:
export LDFLAGS="-L/opt/homebrew/opt/sqlite/lib"
export CPPFLAGS="-I/opt/homebrew/opt/sqlite/include"

# local/bin
export PATH="$HOME/.local/bin:$PATH"

### Plugins

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

## autoswitch-

export AUTOSWITCH_DEFAULT_PYTHON="/Users/trandromeda/.pyenv/shims/python3"
