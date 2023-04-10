#!/usr/bin/env bash

## INSTALLATION
# bash -c "$(curl -#fL raw.githubusercontent.com/trandromeda/dotfiles/master/install.sh)"

# more examples:
# https://github.com/dbalatero/dotfiles/blob/0ac645cd02587086af4771d01b01df4006df87a1/tmux.conf#L9

LOG="${HOME}/Library/Logs/dotfiles.log"
GITHUB_USER="trandromeda"
GITHUB_REPO="dotfiles"
DIR="${HOME}/dev/${GITHUB_REPO}"

_process() {
    echo "$(date) PROCESSING:  $@" >> $LOG
    printf "$(tput setaf 6) %s...$(tput sgr0)\n" "$@"
}

_success() {
  local message=$1
  printf "%s✓ Success:%s\n" "$(tput setaf 2)" "$(tput sgr0) $message"
}

download_dotfiles() {
    _process "→ Downloading repository to /tmp directory"
    curl -#fLo /tmp/${GITHUB_REPO}.tar.gz "https://github.com/${GITHUB_USER}/${GITHUB_REPO}/tarball/master"

    _process "→ Extracting files to ${DIR}"
    tar -zxf /tmp/${GITHUB_REPO}.tar.gz --strip-components 1 -C "${DIR}"

    _process "→ Removing tarball from /tmp directory"
    rm -rf /tmp/${GITHUB_REPO}.tar.gz

    [[ $? ]] && _success "${DIR} created, repository downloaded and extracted"

    # Change to the dotfiles directory
    cd "${DIR}"
}

# excluded: ['bin bin', 'configs/Ultisnips .vim/Ultisnips']
link_dotfiles() {
    # Symlink files to the HOME directory.
    if [[ -f "${DIR}/opt/dotfiles" ]]; then
        _process "→ Symlinking dotfiles in /configs"

        # Set variable for list of files
        files="${DIR}/opt/dotfiles"

        # Store IFS separator within a temp variable
        OIFS=$IFS
        # Set the separator to a carriage return & a new line break
        # read in passed-in file and store as an array
        IFS=$'\r\n'
        links=($(cat "${files}"))

        # Loop through array of files
        for index in ${!links[*]}
        do
            for link in ${links[$index]}
            do
                _process "→ Linking ${links[$index]}"
                # set IFS back to space to split string on
                IFS=$' '
                # create an array of line items
                file=(${links[$index]})
                # Create symbolic link
                ln -fs "${DIR}/${file[0]}" "${HOME}/${file[1]}"
            done
            # set separater back to carriage return & new line break
            IFS=$'\r\n'
        done

        # Reset IFS back
        IFS=$OIFS

        [[ $? ]] && _success "All files have been copied"
    fi
}

install_homebrew_and_xcode() {
    _process "→ Installing Homebrew"

    # This step may take a while
    xcode-select --install
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

    _process "→ Running brew doctor"
    brew doctor

    # Add Homebrew to the PATH
    (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> "${HOME}/.zprofile"
    eval "$(/opt/homebrew/bin/brew shellenv)"

    [[ $? ]] \
    && _success "Installed Homebrew"
}

install_formulae() {
  if ! type -P 'brew' &> /dev/null; then
    _error "Homebrew not found"
  else
    _process "→ Installing Homebrew packages"

    # Update and upgrade all packages
    _process "→ Updating and upgrading Homebrew packages"
    brew update
    brew upgrade
    brew bundle install --file "${DIR}/configs/Brewfile"
    brew cleanup

    [[ $? ]] && _success "All Homebrew packages installed and updated"
  fi
}

install_custom() {
  _process "→ Finishing install with custom code"

  # Install custom plugins (and themes) for Oh My Zsh
  git clone https://github.com/davidde/git.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/git
  git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  git clone https://github.com/agkozak/zsh-z ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-z
  git clone https://github.com/jeffreytse/zsh-vi-mode ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-vi-mode
  git clone https://github.com/tmux-plugins/tpm ${HOME}/.tmux/plugins/tpm && chmod 755 ${HOME}/.tmux

  [[ $? ]] && _success "All custom code installed"
}

manual_preadjustments() {
  # Make directories
  _process "→ Creating directory at ${HOME}/.vim"
  mkdir -p ${HOME}/.vim

  _process "→ Creating directory at ${HOME}/.nvm"
  mkdir -p ${HOME}/.nvm
  
  _process "→ Creating directory for dotfiles "
  mkdir -p ${HOME}/dev/${GITHUB_REPO}

  # Oh-My-Zsh 
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  [[ $? ]] && _success "Pre-setup tasks complete"
}

update_macos_settings() {
    # Make .macos executable 
    _process "→ Setting file permissions"
    chmod u+x "${DIR}/bin/.macos"

    # Execute .macos executable 
    _process "→ Updating macOS settings"
    ${DIR}/bin/.macos

    [[ $? ]] && _success "All configured macOS settings have been updated"
}

install() {
  install_homebrew_and_xcode
  download_dotfiles
  manual_preadjustments
  install_formulae
  link_dotfiles
  install_custom
  # TODO: Fix macOS settings setup script
  # update_macos_settings
}

install
