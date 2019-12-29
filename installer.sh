#!/usr/bin/env bash

# This script provides an easy way to install my preferred packages along with my configurations.
# Author: Tsakiris Tryfon

# --------------------------------------------- Whiptail size variables ------------------------------------------------

SIZE=$(stty size)
ROWS=$(stty size | cut -d ' ' -f 1)

# -------------------------------------------------- Font commands -----------------------------------------------------

bold=$(tput bold)
start_underline=$(tput smul)
end_underline=$(tput rmul)
black_fg=$(tput setaf 0)
red_fg=$(tput setaf 1)
green_fg=$(tput setaf 2)
white_fg=$(tput setaf 7)
black_bg=$(tput setab 0)
reset=$(tput sgr0)

# ---------------------------------------------------- Symbols ---------------------------------------------------------

thunder="\u2301"
bullet="\u2022"
cross="\u2718"
tick="\u2714"

# ---------------------------------------------------- Functions -------------------------------------------------------

function _checkppa() {
    for i in "$@"; do
        if ! grep -Rq "^deb.*$i" /etc/apt/sources.list.d/*.list; then
            sudo add-apt-repository -y ppa:$i > /dev/null
            sudo apt-get -qq update
        fi
    done
}

function _install() {
    # Install the package in the background and suppress any outputs from STDOUT
    # -qq: option implies --yes and also is less verbose
    sudo apt-get -qq install "$@" > /dev/null
}

function _backup() {
    echo "Backing up $1 ..."
    cp $1 $1 -v --force --backup=numbered
}

function _reboot() {
    echo "It is recommended to ${bold}${red_fg}reboot${reset} after a fresh install of the packages and configurations."
    read -n 1 -r -p "Would you like to reboot? [Y/n] " input
    if [[ "$input" =~ ^([yY])$ ]]; then
        sudo reboot
    fi
}

function _prompt() {
    local exec=false
    echo -e "${bullet} Do you want to download/install ${bold}${red_fg}${1}${reset} [Y/n] "
    read -n 1 -s input
    if [[ "$input" =~ ^([yY])$ ]]; then
        exec=true
    fi
    if [[ $exec == "true" ]]; then
        $1
    fi
}

function _checkfile() {
    if [ ! -f "$1" ]; then
        echo "${bold}${red_fg}ERROR${reset}: Can't find ${1} in this directory."
        echo "You should run the installer from within the github repository."
             "git clone https://github.com/tsakirist/configurations.git"
        exit 1
    fi
}

function _checkcommand() {
    if ! command -v $1 > /dev/null 2>&1; then
        echo -ne "${thunder} Installing required package ${bold}${red_fg}${1}${reset}..."
        _install $1
    fi
}

function _print() {
    local action
    if [[ $# -gt 1 ]]; then
        case "$1" in
            "s") action="Setting" ;;
            "i") action="Installing" ;;
            "c") action="Changing" ;;
        esac
        echo -e "${black_bg}${thunder} ${action} ${bold}${red_fg}${*:2}${white_fg} ...${reset}"
    fi
}

function _change_shell() {
    local shell
    if [[ $# -eq 1 ]]; then
        case "$1" in
            "bash") shell="bash" ;;
            "zsh" ) shell="zsh" ;;
        esac
    fi
    _print c shell to $(which ${shell})
    # Issue the command to change the default shell
    chsh -s $(which ${shell})
    echo "In order for the ${start_underline}change${end_underline} to take effect you need to" \
         "${bold}${red_fg}logout${reset}."
}

function _gitconfig() {
    _checkfile git/gitconfig
    _print s ".gitconfig"
    cp -v --backup=numbered git/gitconfig ~/.gitconfig
}

function _gitsofancy() {
    if ! command -v diff-so-fancy > /dev/null 2>&1; then
        _print s "git-diff-so-fancy"
        wget -q "https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy"
        chmod +x diff-so-fancy && sudo mv diff-so-fancy /usr/bin/
    fi
}

function _bashrc() {
    _checkfile bash/bashrc
    _print s ".bashrc"
    cp -v --backup=numbered bash/bashrc ~/.bashrc
}

function _bashaliases() {
    _checkfile bash/bash_aliases
    _print s ".bash_aliases"
    cp -v --backup=numbered bash/bash_aliases ~/.bash_aliases
}

function _bashfunctions() {
    _checkfile bash/bash_functions
    _print s ".bash_functions"
    cp -v --backup=numbered bash/bash_functions ~/.bash_functions
}

function _bashconfig() {
    _bashrc && _bashaliases && _bashfunctions
}

function _zsh() {
    _print i "zsh"
    _install zsh
    local msg="Would you like to change the default shell to zsh?\nThis will issue 'chsh -s $(which zsh)' command."
    if (whiptail --title "Change shell" --yesno "${msg}" 8 78); then
        chsh -s $(which zsh)
    fi
}

function _zshrc() {
    _checkfile zsh/zshrc
    _print s ".zshrc"
    cp -v --backup=numbered zsh/zshrc ~/.zshrc
}

function _zshaliases() {
    _checkfile zsh/zsh_aliases
    _print s ".zsh_aliases"
    cp -v --backup=numbered zsh/zsh_aliases ~/.zsh_aliases
}

function _zshfunctions () {
    _checkfile zsh/zsh_functions
    _print s ".zsh_functions"
    cp -v --backup=numbered zsh/zsh_functions ~/.zsh_functions
}

function _zshconfig() {
    _zshrc && _zshaliases && _zshfunctions
}

function _omz() {
    local zsh_custom=${HOME}/.oh-my-zsh/custom
    _print i "oh-my-zsh"
    # Install Oh-my-zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    # Install powerlevel10k theme
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $zsh_custom/themes/powerlevel10k
    # Install zsh autosuggestions
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions $zsh_custom/plugins/zsh-autosuggestions
    # Install zsh syntax highlighting and apply a specific theme
    git clone --depth=1 https://github.com/zdharma/fast-syntax-highlighting.git \
        $zsh_custom/plugins/fast-syntax-highlighting
    _zshrc
}

function _vim() {
    _print i "vim"
    _install vim vim-gnome
}

function _vimrc() {
    _checkfile neovim/vimrc
    _print s ".vimrc"
    cp -v --backup=numbered neovim/vimrc ~/.vimrc
    vim +PlugInstall +qall
}

function _nvim() {
    _print i "neovim"
    # sudo sh -c 'echo "deb http://ppa.launchpad.net/neovim-ppa/stable/ubuntu bionic main" > \
    #             /etc/apt/sources.list.d/neovim.list'
    _checkppa neovim-ppa/stable
    _install neovim
}

function _nvimrc() {
    _checkfile neovim/vimrc && _checkfile neovim/init.vim
    _print s ".vimrc and init.vim"
    cp -v --backup=numbered neovim/vimrc ~/.vimrc
    mkdir -v -p ~/.config/nvim/
    cp -v --backup=numbered neovim/init.vim ~/.config/nvim/
    nvim +PlugInstall +qall
}

function _tmux() {
    _print i "tmux"
    _install tmux
}

function _tmuxconfig() {
    _checkfile tmux/tmux.conf
    _print s ".tmux.conf"
    cp -v --backup=numbered tmux/tmux.conf ~/.tmux.conf
}

function _sublimepkgctrl() {
    # Create the necessary folder for Package Control and install it manually
    if [ ! -f "${HOME}/.config/sublime-text-3/Installed Packages/Package Control.sublime-package" ]; then
        wget -q "https://packagecontrol.io/Package%20Control.sublime-package" \
             -P "${HOME}/.config/sublime-text-3/Installed Packages"
    fi
}

function _sublimeinit() {
    # Create some necessary folders in order to be able to copy settings
    mkdir -v -p "${HOME}/.config/sublime-text-3/Installed Packages"
    mkdir -v -p "${HOME}/.config/sublime-text-3/Packages/User/"
}

function _sublimetext() {
    _print i "SublimeText 3"
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
    sudo sh -c 'echo "deb https://download.sublimetext.com/ apt/stable/" > \
                /etc/apt/sources.list.d/sublime-text.list'
    sudo apt-get -qq update && _install sublime-text
}

function _sublimesettings() {
    _checkfile sublime/Preferences.sublime-settings
    _print s "sublime settings"
    cp -v --backup=numbered "sublime/Preferences.sublime-settings" "$HOME/.config/sublime-text-3/Packages/User/"
}

function _sublimekeybindings() {
    _checkfile "sublime/Default (Linux).sublime-keymap"
    _print s "sublime keybindings"
    cp -v --backup=numbered "sublime/Default (Linux).sublime-keymap" "$HOME/.config/sublime-text-3/Packages/User/"
}

function _sublimepackages() {
    _checkfile "sublime/Package Control.sublime-settings"
    _print s "sublime packages"
    cp -v --backup=numbered "sublime/Package Control.sublime-settings" "$HOME/.config/sublime-text-3/Packages/User/"
}

function _sublimeterminus() {
    _checkfile "sublime/Terminus.sublime-settings"
    _print s "sublime terminus settings"
    cp -v --backup=numbered "sublime/Terminus.sublime-settings" "$HOME/.config/sublime-text-3/Packages/User/"
}

function _sublimeconfig() {
    _sublimeinit && _sublimepkgctrl && _sublimesettings && _sublimekeybindings && _sublimepackages && _sublimeterminus
}

function _vscode() {
    _print i "Visual Studio Code"
    curl -s https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/ && rm -f microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > \
                /etc/apt/sources.list.d/vscode.list'
    sudo apt-get -qq update && _install code
}

function _googlechrome() {
    _print i "Google Chrome"
    wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/google_chrome.deb
    sudo dpkg -i /tmp/google_chrome.deb > /dev/null
    # Remove google chrome keyring pop-up
    sudo sed -i '/^Exec=/s/$/ --password-store=basic %U/' "/usr/share/applications/google-chrome.desktop"
}

function _neofetch() {
    _print i "neofetch"
    _install neofetch
}

function _xclip() {
    _print i "xclip"
    _install xclip
}

function _powerline() {
    _print i "powerline"
    _install python-pip
    pip install powerline-status
    pip install powerline-gitstatus
    _install fonts-powerline
}

function _powerlineconfig() {
    _checkfile powerline_configs/themes/shell/default.json && _checkfile powerline_configs/colorschemes/default.json

    _print s "themes/shell/default.json"
    cp -v --backup=numbered "powerline_configs/themes/shell/default.json" \
        "$HOME/.local/lib/python2.7/site-packages/powerline/config_files/themes/shell"

    _print s "colorschemes/default.json"
    cp -v --backup=numbered "powerline_configs/colorschemes/default.json" \
        "$HOME/.local/lib/python2.7/site-packages/powerline/config_files/colorschemes"
}

function _dconftilix() {
    _checkfile dconf/tilix.dconf
    _print s "tilix dconf settings"
    dconf load /com/gexperts/Tilix/ < dconf/tilix.dconf
}

function _dconfsettings() {
    _checkfile dconf/settings.dconf
    _print s "dconf settings"
    dconf load / < dconf/settings.dconf
}

function _dconfsettingswthemes() {
    _checkfile dconf/settings_with_themes.dconf
    _print s "dconf settings with themes"
    dconf load / < dconf/settings_with_themes.dconf
}

# By default it includes dconf settings with themes applied
function _dconf() {
    _dconfsettingswthemes && _dconftilix
}

function _preload() {
    _print i "preload"
    _install preload
}

function _vmswappiness() {
    local value=10
    local file="/etc/sysctl.conf"
    _print c "vm.swappiness to $value"
    if grep -q "^vm.swappiness" $file; then
        sudo sed -i "s/\(^vm.swappiness=\).*/\1$value/" $file
    else
        echo "vm.swappiness=${value}" | sudo tee -a $file > /dev/null 2>&1;
    fi
    sudo sysctl -q --system
    echo "Swappiness value:" $(cat /proc/sys/vm/swappiness)
}

function _cmake() {
    _print i "cmake"
    _install cmake
}

function _tree() {
    _print i "tree"
    _install tree
}

function _htop() {
    _print i "htop"
    _install htop
}

function _gotop() {
    _print i "gotop"
    sudo snap install gotop-cjbassi
    sudo snap connect gotop-cjbassi:hardware-observe
    sudo snap connect gotop-cjbassi:mount-observe
    sudo snap connect gotop-cjbassi:system-observe
}

function _activitymonitors() {
    _htop
    _gotop
}

function _gnometweaks() {
    _print i "gnome-tweaks"
    _install gnome-tweaks
}

function _arcmenu() {
    _print i "Arc-Menu extension"
    # Install prerequisites
    _install gnome-menus gettext libgettextpo-dev
    git clone --depth=1 https://gitlab.com/LinxGem33/Arc-Menu.git /tmp/Arc-Menu
    pushd /tmp/Arc-Menu
    make install
    popd
}

function _gnomeshellextensions() {
    _print i "gnome-shell-extensions"
    # This installs a minimal set of extensions
    _install gnome-shell-extensions gnome-shell-extension-weather gnome-shell-extension-dashtodock
    _arcmenu
}

function _arctheme() {
    _print i "Arc-theme"
    _install arc-theme
}

function _papirusfolders() {
    _print i "Papirus folders script"
    # sudo add-apt-repository ppa:papirus/papirus -y
    _checkppa papirus/papirus
    _install papirus-folders
    sudo papirus-folders -C deeporange > /dev/null
}

function _papirusicons() {
    _print i "Papirus icons"
    # sudo add-apt-repository ppa:papirus/papirus -y
    _checkppa papirus/papirus
    _install papirus-icon-theme
}

function _papirus() {
    _papirusicons && _papirusfolders
}

function _java() {
    _print i "java and javac"
    _install default-jre default-jdk
}

function _tilix() {
    _print i "tilix: a terminal emulator"
    # sudo add-apt-repository ppa:webupd8team/terminix -y
    # sudo sh -c 'echo "deb http://ppa.launchpad.net/webupd8team/terminix/ubuntu bionic main" > \
    #         /etc/apt/sources.list.d/webupd8team-ubuntu-terminix-bionic.list'
    _checkppa webupd8team/terminix
    _install tilix
}

function _setwlp() {
    local wlp="wallpapers/1.jpg" # my custom default wallpaper
    _checkfile $wlp
    local file="'file://$(readlink -e "${wlp}")'"
    _print s "Wallpaper ${FILE}"
    gsettings set org.gnome.desktop.background picture-uri "$file"
}

function _installfonts() {
    _print i "fonts"
    sudo apt install fonts-firacode
}

function _fzfconfig() {
    _checkfile fzf/fzf.config
    _print s "fzf configuration"
    cp -v --backup=numbered fzf/fzf.config ~/.fzf.config
}

function _fzf() {
    _print i "fzf: Fuzzy finder"
    git clone --depth=1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --key-bindings --completion --no-update-rc
}

function _fd() {
    _print i "fd: an improved version of find"
    wget -q https://github.com/sharkdp/fd/releases/download/v7.4.0/fd-musl_7.4.0_amd64.deb -O /tmp/fd.deb
    sudo dpkg -i /tmp/fd.deb > /dev/null
}

function _bat() {
    _print i "bat: a clone of cat with syntax highlighting"
    wget -q https://github.com/sharkdp/bat/releases/download/v0.12.1/bat-musl_0.12.1_amd64.deb -O /tmp/bat.deb
    sudo dpkg -i /tmp/bat.deb > /dev/null
}

function _rg() {
    _print i "rg: ripgrep recursive search for a pattern in files"
    wget -q https://github.com/BurntSushi/ripgrep/releases/download/11.0.2/ripgrep_11.0.2_amd64.deb -O /tmp/rg.deb
    sudo dpkg -i /tmp/rg.deb > /dev/null
}

function _lazygit() {
    _print i "lazygit: A terminal UI utility for git commands"
    _checkppa lazygit-team/release
    _install lazygit
}

function _checkroot() {
    local msg="$(printf '%s\n' \
               "Would you like to have a completely unattended installation?"  \
               "This will execute the installer with sudo to elevate privileges.")"
    if [ "$EUID" -ne 0 ]; then
        if (whiptail --title "Installer Privileges" --yesno "$msg" 8 78); then
            echo -e "${thunder} Trying to get ${start_underline}${bold}${red_fg}root${reset} access rights... "
            sudo -s "$0" "$@"
            exit $?
        fi
    fi
}

function _validateroot() {
    # This function will validate user's timestamp without running any commnad
    # It will prompt for password and keep it in cache, which is 15 mins by default
    sudo -v
}

# ------------------------------------------------------ Packages ------------------------------------------------------

pkgs=(
    "    dconf settings"
    "    zsh"
    "    zshrc, zsh_aliases, zsh_functions"
    "    oh-my-zsh"
    "    bashrc, bash_aliases, bash_functions"
    "    tilix: terminal emulator"
    "    fzf: fuzzy finder"
    "    fzf configuration"
    "    fd: improved version of find"
    "    bat: a cat clone with syntax highlighting"
    "    rg: ripgrep recursive search for a pattern in files"
    "    neovim"
    "    neovimrc"
    "    tmux: terminal multiplexer"
    "    tmux configuration"
    "    xclip"
    "    neofetch"
    "    htop & gotop: activity monitors"
    "    lazygit: a terminal UI for git commands"
    "    tree"
    "    cmake"
    "    gnome-tweaks"
    "    gnome-shell-extensions"
    "    gitconfig"
    "    gitsofancy"
    "    powerline"
    "    powerline configuration"
    "    java & javac"
    "    sublime text 3"
    "    sublime text 3: settings, keybindings, packages"
    "    vscode"
    "    google chrome"
    "    preload"
    "    vmswappiness"
    "    set wallpaper"
    "    install fonts"
    "    arc-theme"
    "    papirus icons and folder changer script"
    "    Quit"
)

pkgs_functions=(
    _dconfgui
    _zsh
    _zshconfig
    _omz
    _bashconfig
    _tilix
    _fzf
    _fzfconfig
    _fd
    _bat
    _rg
    _nvim
    _nvimrc
    _tmux
    _tmuxconfig
    _xclip
    _neofetch
    _activitymonitors
    _lazygit
    _tree
    _cmake
    _gnometweaks
    _gnomeshellextensions
    _gitconfig
    _gitsofancy
    _powerline
    _powerlineconfig
    _java
    _sublimetext
    _sublimeconfig
    _vscode
    _googlechrome
    _preload
    _vmswappiness
    _setwlp
    _installfonts
    _arctheme
    _papirus
)

# -------------------------------------------------------- Menus -------------------------------------------------------

function _showmenu() {
    _checkcommand whiptail
    local INFO="---------------------- System Information -----------------------\n"
    INFO+="$(hostnamectl | tail -n 3 | cut -c3-)"
    INPUT=$(whiptail --title "This script provides an easy way to install my packages and my configurations." \
        --menu "\nScript is executed from '$(pwd)'\n\n${INFO}" ${SIZE} 3 \
        "1"  "    Fresh installation of everything" \
        "2"  "    Selective installation" \
        "Q"  "    Quit" \
        3>&1 1>&2 2>&3)
}

function _createselectivemenu() {
    # Dynamically populate the GUI menu from the pkgs array, this should be called once
    menu_options=()
    pkgs_count="${#pkgs[@]}"
    
    for ((i=0; i<($pkgs_count - 1); i++)); do
        menu_options+=("$(($i + 1))")
        menu_options+=("${pkgs[$i]}")
    done

    # Special treatment for the 'Q' option, we don't want to have an integer as tag
    menu_options+=("Q")
    menu_options+=("${pkgs[(($pkgs_count - 1))]}")
}

function _guiselectivemenu() {
    OPT=$(whiptail --title "Selectively install packages/configurations" \
        --menu "\nSelect the packages and the configurations that you want to install/set." ${SIZE} $((ROWS-10)) \
        "${menu_options[@]}" \
        3>&1 1>&2 2>&3)
}

function _dconfgui() {
    local opt=$(whiptail --title "dconf settings" --menu "\nWhich dconf settings would you like to apply?" \
                ${SIZE} 3 \
                "1" "    dconf general settings" \
                "2" "    dconf general settings with themes" \
                "3" "    dconf tilix settings" \
                3>&1 1>&2 2>&3)
    case $opt in
        1) _dconfsettings ;;
        2) _dconfsettingswthemes ;;
        3) _dconftilix ;;
    esac
}

# ----------------------------------------------------- Installers -----------------------------------------------------

function _fresh_install() {
    _checkcommand curl && _checkcommand git
    _installfonts
    _zsh && _zshconfig && _omz
    _bashconfig
    _tilix
    _fzf && _fzfconfig
    _fd
    _bat
    _rg
    _nvim && _nvimrc
    _tmux && _tmuxconfig
    _xclip
    _neofetch
    _activitymonitors
    _lazygit
    _cmake
    _tree
    _gnometweaks
    _gnomeshellextensions
    _gitconfig && _gitsofancy
    _powerline && _powerlineconfig
    _java
    _sublimeconfig
    _vscode
    _googlechrome
    _preload
    _vmswappiness
    _arctheme
    _papirus
    _dconf
    _setwlp
    _reboot
}

function _selective_install() {
    _checkcommand curl && _checkcommand git
    _createselectivemenu
    local exit_status=0
    while [ $exit_status -eq 0 ]; do
        _guiselectivemenu
        case $OPT in
            Q) exit_status=1 ;;
            *) ${pkgs_functions[(($OPT - 1))]}
        esac
        # Sleep only when user hasn't selected Quit
        [ $exit_status -eq 0 ] && sleep 2
    done
}

# ------------------------------------------------------- Main ---------------------------------------------------------

_validateroot
_showmenu

if [ $INPUT -eq 1 ]; then
    _fresh_install
elif [ $INPUT -eq 2 ]; then
    _selective_install
else
    exit 0
fi
