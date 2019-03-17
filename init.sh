#!/usr/bin/env bash

fail_color="\033[31;1m"
pass_color="\033[32;1m"
color_end="\033[0m"

cask_install () {
   if brew cask install $1 ; then
      printf "%b$1 installed successfully.%b\n" "$pass_color" "$color_end"
   else
      printf "[FAILED] $1\n" >> ~/CastInstallError.log
      printf "%b$1 installation failed.%b\n" "$fail_color" "$color_end"
   fi
}

## Freed0m:)
cask_install surge

brew tap "homebrew/services"
brew tap homebrew/cask-fonts
brew tap ethereum/ethereum


echo "---- Begin Install Packages ----"
brew install zsh git curl wget sqlite watchman coreutils automake autoconf openssl libyaml readline libxslt libtool libxml2 webp openssl pkg-config
brew install libpq && brew link --force libpq
brew install exa prettyping nmap glances jq thefuck ccat youtube-dl gnupg p7zip xz imagemagick hub
cask_install java

## Cloud Providers
brew install awscli
cask_install google-cloud-sdk
brew install kubernetes-cli kubernetes-helm
mkdir -p $HOME/bin && curl -o $HOME/bin/aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-07-26/bin/darwin/amd64/aws-iam-authenticator && chmod +x $HOME/bin/aws-iam-authenticator
echo "---- Begin Install Apps ----"
cask_install squirrel
cask_install google-chrome
cask_install firefox
cask_install 1password
cask_install visual-studio-code
cask_install dash
cask_install slack
cask_install zoomus
cask_install google-backup-and-sync
cask_install the-unarchiver
cask_install wechat
cask_install telegram
#cask_install cleanmymac
#cask_install evernote
cask_install sketch
cask_install microsoft-office
cask_install xmind-zen
cask_install gpg-suite
#cask_install steam

## IDE
cask_install rubymine
cask_install webstorm
cask_install pycharm
cask_install goland
cask_install intellij-idea
cask_install datagrip
cask_install wechatwebdevtools
brew install neovim
cask_install virtualbox && cask_install virtualbox-extension-pack
cask_install docker && cask_install kitematic
#brew install yubikey-personalization ykman

## for Appstore
# todo
# brew install mas

## font
cask_install skyfonts
cask_install font-noto-sans-cjk
cask_install font-noto-serif-cjk
cask_install font-inconsolata
cask_install font-source-code-pro
cask_install font-roboto
cask_install font-raleway


echo "---- Customizing ----"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
wget https://raw.githubusercontent.com/AffanIndo/sunaku-zen/master/sunaku-zen.zsh-theme -o ~/.oh-my-zsh/custom/themes/sunaku-zen.zsh-theme
echo "---- Language Env  ----"
## ruby
curl -sSL https://rvm.io/mpapis.asc | gpg --import -
curl -sSL https://get.rvm.io | bash -s stable
. ~/.bash_profile
rvm install ruby-2.5.1
rvm use 2.5.1 --default
gem install acs2aws heel

## bazel
brew tap bazelbuild/tap
brew tap-pin bazelbuild/tap
brew install bazelbuild/tap/bazel

## nodejs
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install node
nvm use node --default
npm install -g yarn

## python
brew install pyenv
pyenv install 3.7.1
pyenv global 3.7.1

## go
brew install go

## scala
brew install scala

## groovy
brew install groovy

## clojure
brew install clojure

## Terraform
brew install terraform

## rust
#curl https://sh.rustup.rs -sSf | sh
#source $HOME/.cargo/env

# julia
#curl -L https://julialang-s3.julialang.org/bin/mac/x64/1.0/julia-1.0.0-mac64.dmg -o "$HOME/Downloads/julia.dmg"
#hdiutil attach ~/Downloads/julia.dmg && cp -rf /Volumes/Julia-*/Julia-*.app /Applications
#hdiutil detach -force /Volumes/Julia*

## ethereum
cask_install mist
brew install solidity
brew install ethereum
