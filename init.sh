#!/usr/bin/env bash
#/ Usage: init.sh 
#/ Install Common software on macOS.


fail_color="\033[31;1m"
pass_color="\033[32;1m"
color_end="\033[0m"

ask() {
    # https://gist.github.com/davejamesmiller/1965569
    local prompt default reply

    if [ "${2:-}" = "Y" ]; then
        prompt="Y/n"
        default=Y
    elif [ "${2:-}" = "N" ]; then
        prompt="y/N"
        default=N
    else
        prompt="y/n"
        default=
    fi

    while true; do

        # Ask the question (not using "read -p" as it uses stderr not stdout)
        echo -n "$1 [$prompt] "

        # Read the answer (use /dev/tty in case stdin is redirected from somewhere else)
        read reply </dev/tty

        # Default?
        if [ -z "$reply" ]; then
            reply=$default
        fi

        # Check if the reply is valid
        case "$reply" in
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac

    done
}

success() { printf "%b$* %b\n" "$pass_color" "$color_end" >&2; }
abort() { printf "%b[FAILED] $* %b\n" "$fail_color" "$color_end" >&2; exit 1; }
cask_install () {
   if brew cask install $1 ; then
      success "$1 installed successfully."
   else
      printf "[FAILED] $1\n" >> ~/CastInstallError.log
      printf "%b$1 installation failed.%b\n" "$fail_color" "$color_end"
   fi
}

MACOS_VERSION="$(sw_vers -productVersion)"
  echo "$MACOS_VERSION" | grep $Q -E "^10.(14|15)" || {
  abort "macOS version must be 10.14/15."
}

[ "$USER" = "root" ] && abort "Run init.sh as yourself, not root."
groups | grep $Q admin || abort "Add $USER to the admin group."

cat << "EOF"
   ____             _                _   
  / __ \           | |              | |  
 | |  | | ___  _ __| |_ ___ __ _ ___| |_ 
 | |  | |/ _ \| '__| __/ __/ _` / __| __|
 | |__| | (_) | |  | || (_| (_| \__ \ |_ 
  \____/ \___/|_|   \__\___\__,_|___/\__|

 [https://github.com/brickodc/macos-init]                                                                                                 

EOF
success "Runing system test ...... PASS"
printf "\nStart installing Common library:\n\n"

echo "› Check macOS update"
softwareupdate -i -a


if type xcode-select >&- && xpath=$( xcode-select --print-path ) &&
  test -d "${xpath}" && test -x "${xpath}" ; then
  success "› Skipping Xcode Command Line Tools installation"
else
  echo "› xcode-select --install"
  xcode-select --install
fi


if which brew >/dev/null 2>&1; then
  brew config
  success "› Skipping Homebrew installation"
else
  echo "› /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)""
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew tap homebrew/services
brew tap homebrew/cask-fonts
brew tap homebrew/cask-versions

brew install zsh coreutils git curl wget openssl jq mas thefuck exa hub bat fzf ripgrep prettyping glances

cask_install WebPQuickLook
printf "\nStart installing Common app:\n\n"
cask_install google-chrome
cask_install microsoft-teams
cask_install 1password
cask_install google-backup-and-sync
cask_install wechat
cask_install telegram
cask_install skyfonts
cask_install font-noto-sans-cjk
cask_install font-noto-serif-cjk
cask_install font-inconsolata
cask_install font-source-code-pro
cask_install font-roboto
cask_install font-raleway

if [[ -f ~/.zshrc ]]
then
  success "› Skipping oh-my-zsh installation"
else
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
wget -O ~/.oh-my-zsh/custom/themes/sunaku-zen.zsh-theme  https://raw.githubusercontent.com/AffanIndo/sunaku-zen/master/sunaku-zen.zsh-theme
wget -O  ~./.zshrc https://gist.githubusercontent.com/0xDing/8c46593df591af9e11d5fad397d7ec7c/raw/5c3d3bdcbd33cf6eb002e93fba4f0c55636a7dce/.zshrc
fi

if ask "Do you want install development environment?"; then
brew install sqlite watchman coreutils automake autoconf libyaml readline libxslt libtool libxml2 webp pkg-config gnupg p7zip xz imagemagick aliyun-cli
brew install libpq && brew link --force libpq
brew install kubernetes-cli kubernetes-helm
cask_install visual-studio-code
cask_install docker && cask_install kitematic
cask_install jetbrains-toolbox

## ruby
if [ `ruby -v | grep "2.7" | wc -l` = 1 ]; then
  success "› Skipping ruby installation"
else
curl -sSL https://rvm.io/mpapis.asc | gpg --import -
curl -sSL https://get.rvm.io | bash -s stable
. ~/.bash_profile
rvm install ruby-2.7.2
rvm use 2.7.2 --default
gem install heel
fi


## nodejs
if which nvm >/dev/null 2>&1; then
success "› Skipping nodejs installation"
else
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install node
nvm use node --default
npm install -g yarn
fi
cask_install react-native-debugger

## Terraform
if which terraform >/dev/null 2>&1; then
success "› Skipping terraform installation"
else
brew install terraform
fi

## python
#if which pyenv >/dev/null 2>&1; then
#success "› Skipping python installation"
#else
#brew install pyenv
#pyenv install 3.7.1
#pyenv global 3.7.1
#fi


## rust
#if which rustc >/dev/null 2>&1; then
#success "› Skipping python installation"
#else
#curl https://sh.rustup.rs -sSf | sh
#source $HOME/.cargo/env
#fi

## go
#brew install go

## scala
#brew install scala

## powershell
#cask_install powershell
fi

success "Your macos has completed initialization. Vist https://portal.manage.microsoft.com/devices to get started now";
/usr/bin/open -a "/Applications/Google Chrome.app" 'https://portal.manage.microsoft.com/devices'
exit 0;
