#!/usr/bin/env bash
#set -o errexit # set -e
#set -o nounset # set -u
#set -o pipefail

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
NC='\033[0m' # No Color

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "${CYAN}Installing homebrew...${NC}"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew update
brew doctor
brew analytics off

apps=(
    aria2
    aspell
    auotconf
    autojump
    automake
    cairo
    carthage
    coreutils
    ffmpeg
    fontconfig
    freetype
    fribidi
    gd
    gdbm
    gdk-pixbuf
    gettext
    git
    glib
    gmp
    gnutls
    gobject-introspection
    graphite2
    gtaphviz
    go
    harfbuzz
    hugo
    icu4c
    imagemagick@6
    jpeg
    lame
    libass
    libcroco
    libffi
    libpng
    librsvg
    libtasn1
    libtiff
    libtool
    lua
    #mas
    #mackup
    mpv
    nettle
    node
    nvm
    openssl
    pandoc
    pango
    pcre
    pixman
    pkg-config
    polipo
    pyenv
    pyenv-virtualenv
    python
    python3
    readline
    sqlite
    terminal-notifier
    textinfo
    the_silver_searcher # A code-searching tool
    tree
    vim
    wakatime-cli
    webp
    wget
    x264
    xvid
    xz
    youtube-dl
    zsh
    zsh-completions
    zsh-autosuggestions
    zsh-syntax-highlighting

    vitorgalvao/tiny-scripts/cask-repair
)

caskapps=(
    alfred
    aliwangwang
    alternote
    android-file-transfer
    android-platform-tools
    archiver
    bartender
    basictex
    caffeine
    calibre
    cheatsheet
    dash
    docker
    dropbox
    flux
    focus
    gpg-suite
    google-chrome
    iina
    iterm2
    java
    karabiner-elements
    keyboard-maestro
    neteasemusic
    omnigraffle
    pdfexpert
    popclip
    rescuetime
    santa
    shortcat
    slack
    snipaste
    #spacelauncher
    sublime-text
    #surge
    telegram
    thunder
    tuck
    typora
    wireshark

    #qlcolorcode
    #qlstephen
    #qlmarkdown
    #quicklook-json
)

masapps=(
    497799835 # Xcode
    443987910 # 1password
    451108668 # QQ
    836500024 # wechat
    408981434 # imovie
    409183694 # Keynote
    409201541 # Pages
    409203825 # Numbers
    441258766 # magnet
    972028355 # Micro Snitch
    1314980676 # iText
    1196268448 # Klib
    1039633667 # Irvue
)

echo "${CYAN}Installing Packages...${NC}"
for app in "${apps[@]}"
do
    brew install $app
done

echo "${CYAN}Building Emacs...\nIt may take a while.${NC}"
brew tap railwaycat/emacsmacport
brew install emacs-mac --with-official-icon --with-natural-title-bar
defaults write org.gnu.Emacs TransparentTitleBar DARK
brew install fcitx-remote-for-osx #--with-input-method=squirrel-rime
#cp -r /usr/local/opt/emacs-mac/Emacs.app /Applications
ln -s /usr/local/opt/emacs-mac/Emacs.app /Applications
echo "${CYAN}Installing Spacemacs...${NC}"
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
cd ~/.emacs.d
git checkout develop
git pull
cd ..

echo "${CYAN}Installing Applications by Homebrew...${NC}"
brew tap caskroom/versions
brew update
for caskapp in "${caskapps[@]}"
do
   # brew cask install --appdir="/Applications" $caskapp
done
brew cleanup
brew cask cleanup

echo "${GREEN}brew install finished\!${NC}"

echo "${CYAN}Installing Applications for Mac App Store...${NC}"
for masapp in "${masapps[@]}"
do
    #mas install $masapp
done

# Use wget to download app
curl -sOL $(jq -r ".assets[] | select(.name | test(\"${spruceType}\")) | .browser_download_url" < <( curl -s "https://api.github.com/repos/youusername/magnetX/releases/latest" )) && unzip -q magnetX.zip && rm magnetX.zip && mv magnetX.app /Applications/
curl -sL $(jq -r ".assets[] | select(.name | test(\"${spruceType}\")) | .browser_download_url" < <( curl -s "https://api.github.com/repos/gggritso/Vimmy.safariextension/releases/latest" )) -o Vimmy.safariextz && open Vimmy.safariextz

echo "${CYAN}Building Squirrel...\nIt may take a while.${NC}"
brew install cmake boost
git clone --recursive https://github.com/rime/squirrel.git
cd squirrel
make deps
make
sudo make install
cd ..
rm -rf squirrel

echo "${CYAN}Tweaking Wechat...${NC}"
git clone https://github.com/Sunnyyoung/WeChatTweak-macOS
cd WeChatTweak-macOS
sudo make install
cd ..
rm -rf WeChatTweak-macOS
