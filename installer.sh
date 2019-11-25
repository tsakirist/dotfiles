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
black=$(tput setaf 0)
red=$(tput setaf 1)
reset=$(tput sgr0)

# ---------------------------------------------------- Symbols ---------------------------------------------------------

thunder="\u2301"
bullet="\u2022"

# ---------------------------------------------------- Functions -------------------------------------------------------

function _backup() {
    echo "Backing up $1 ..."
    cp $1 $1 -v --force --backup=numbered
}

function _reboot() {
    echo "It is recommended to ${bold}${red}reboot${reset} after a fresh install of the packages and configurations."
    read -n 1 -r -p "Would you like to reboot? [Y/n] " input
    if [[ $input =~ ^([yY]) ]]; then
        sudo reboot
    fi
}

function _prompt() {
    local exec=false
    echo -e "${bullet} Do you want to download/install ${bold}${red}${1}${reset} [Y/n] "
    read -n 1 -s input
    if [[ $input =~ ^([yY]) ]]; then
        exec=true
    fi
    if [[ $exec == "true" ]]; then
        $1
    fi
}

function _checkfile() {
    if [ ! -f "$1" ]; then
        echo "${bold}${red}ERROR${reset}: Can't find ${1} in this directory."
        echo "You should run the installer from within the github repository."
             "git clone https://github.com/tsakirist/configurations.git"
        exit 1
    fi
}

function _checkcommand() {
    if ! command -v $1 > /dev/null 2>&1; then
        echo -e "${thunder} Installing required package ${bold}${red}${1}${reset} ..."
        sudo apt install -y $1
    fi
}

function _print() {
    local action
    if [[ $# -gt 1 ]]; then
        case "$1" in
            "s" ) action="Setting" ;;
            "i" ) action="Installing" ;;
            "c" ) action="Changing" ;;
        esac
        echo -e "${thunder} ${action} ${bold}${red}${*:2}${reset} ..."
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
}

function _gitconfig() {
    _checkfile gitconfig
    _print s ".gitconfig"
    cp -v --backup=numbered gitconfig ~/.gitconfig
}

function _gitsofancy() {
    if ! command -v diff-so-fancy > /dev/null 2>&1; then
        _print s "git-diff-so-fancy"
        wget -q "https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy"
        chmod +x diff-so-fancy && sudo mv diff-so-fancy /usr/bin/
    fi
}

function _bashrc() {
    _checkfile bashrc
    _print s ".bashrc"
    cp -v --backup=numbered bashrc ~/.bashrc
}

function _bashaliases() {
    _checkfile bash_aliases
    _print s ".bash_aliases"
    cp -v --backup=numbered bash_aliases ~/.bash_aliases
}

function _zsh() {
    _print i "zsh"
    sudo apt install -y zsh
    # Issue chsh -s $(which zsh) to change the default shell
}

function _zshrc() {
    _checkfile zshrc
    _print s ".zshrc"
    cp -v --backup=numbered zshrc ~/.zshrc
}

function _zshaliases() {
    _checkfile zsh_aliases
    _print s ".zsh_aliases"
    cp -v --backup=numbered zsh_aliases ~/.zsh_aliases
}

function _omz() {
    local zsh_custom=${HOME}/.oh-my-zsh/custom
    _print i "oh-my-zsh"
    _zshrc
    sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    sh -c "$(git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${zsh_custom}/themes/powerlevel10k)"
}

function _vim() {
    _print i "vim"
    sudo apt install -y vim vim-gnome
}

function _vimrc() {
    _checkfile vimrc
    _print s ".vimrc"
    cp -v --backup=numbered vimrc ~/.vimrc
    vim +PlugInstall +qall
}

function _nvim() {
    _print i "neovim"
    # sudo sh -c 'echo "deb http://ppa.launchpad.net/neovim-ppa/stable/ubuntu bionic main" > \
    #             /etc/apt/sources.list.d/neovim.list'
    sudo add-apt-repository ppa:neovim-ppa/stable
    sudo apt update && sudo apt install -y neovim
}

function _nvimrc() {
    _checkfile vimrc && _checkfile init.vim
    _print s ".vimrc and init.vim"
    echo -e "${thunder} Setting ${bold}${red}.vimrc and init.vim${reset} ..."
    cp -v --backup=numbered vimrc ~/.vimrc
    mkdir -v -p ~/.config/nvim/
    cp -v --backup=numbered init.vim ~/.config/nvim/
    nvim +PlugInstall +qall
}

function _tmux() {
    _print i "tmux"
    sudo apt install -y tmux
}

function _tmuxconf() {
    _checkfile tmux.conf
    _print s ".tmux.conf"
    cp -v --backup=numbered tmux.conf ~/.tmux.conf
}

function _sublimetext() {
    _print i "SublimeText 3"
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
    sudo sh -c 'echo "deb https://download.sublimetext.com/ apt/stable/" > \
                /etc/apt/sources.list.d/sublime-text.list'
    sudo apt update && sudo apt install -y sublime-text
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

function _sublimeallconfigs() {
    _sublimesettings && _sublimekeybindings && _sublimepackages && _sublimeterminus
}

function _vscode() {
    _print i "Visual Studio Code"
    curl -s https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/ && rm -f microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > \
                /etc/apt/sources.list.d/vscode.list'
    sudo apt update && sudo apt install -y code
}

function _googlechrome() {
    _print i "Google Chrome"
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i google-chrome-stable_current_amd64.deb
    rm -f google-chrome-stable_current_amd64.deb
    # Remove google chrome keyring pop-up
    sudo sed -i '/^Exec=/s/$/ --password-store=basic %U/' "/usr/share/applications/google-chrome.desktop"
}

function _neofetch() {
    _print i "neofetch"
    sudo apt install -y neofetch
}

function _xclip() {
    _print i "xclip"
    sudo apt install -y xclip
}

function _powerline() {
    _print i "powerline"
    sudo apt install -y python-pip
    pip install powerline-status
    pip install powerline-gitstatus
    sudo apt install -y fonts-powerline
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

function _dconfsettings() {
    _checkfile dconf/settings.dconf
    _print s "dconf_settings"
    dconf load / < dconf/settings.dconf
}

function _preload() {
    _print i "preload"
    sudo apt install -y preload
}

function _vmswappiness() {
    _print c "vm.swappiness to 10"
    echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf > /dev/null 2>&1;
}

function _cmake() {
    _print i "cmake"
    sudo apt install -y cmake
}

function _tree() {
    _print i "tree"
    sudo apt install -y tree
}

function _htop() {
    _print i "htop"
    sudo apt install -y htop
}

function _gnometweaks() {
    _print i "gnome-tweaks"
    sudo apt install -y gnome-tweaks
}

function _gnomeshellextensions() {
    _print i "gnome-shell-extensions"
    sudo apt install -y gnome-shell-extension-weather gnome-shell-extension-dashtodock
}

function _java() {
    _print i "java and javac"
    sudo apt install -y default-jre default-jdk
}

function _tilix() {
    _print i "tilix"
    sudo add-apt-repository ppa:webupd8team/terminix -y
    # sudo sh -c 'echo "deb http://ppa.launchpad.net/webupd8team/terminix/ubuntu bionic main" > \
    #         /etc/apt/sources.list.d/webupd8team-ubuntu-terminix-bionic.list'
    sudo apt update && sudo apt install -y tilix 
}

function _setwlp() {
    local wlp_dir="wallpapers"
    local wlp="${wlp_dir}/1.jpg" # default wlp
    if [[ $# -eq 1 ]]; then
        wlp="${wlp_dir}/$1"
    fi
    local FILE="'file://$(readlink -e "${wlp}")'" 
    _print s "Wallpaper ${FILE}"
    gsettings set org.gnome.desktop.background picture-uri "$FILE" 
}

function _showmenu() {
    _checkcommand whiptail
    INPUT=$(whiptail --title "This script provides an easy way to install my packages and my configurations." \
        --menu "\nScript is executed from $(pwd)" ${SIZE} $((ROWS-10)) \
        "1"  "    Fresh installation" \
        "2"  "    Selective installation" \
        "Q"  "    Quit" \
        3>&1 1>&2 2>&3)
}

# ----------------------------------------------------- Installers -----------------------------------------------------

function _fresh_install() {
    _checkcommand curl && _checkcommand git
    _dconfsettings && _setwlp
    _bashrc && _bashaliases
    _preload
    _vmswappiness
    _xclip
    _neofetch
    _htop
    _cmake
    _tree
    _gnometweaks
    _gnomeshellextensions
    _gitconfig && _gitsofancy
    _nvim && _nvimrc
    _tmux && _tmuxconf
    _powerline && _powerlineconfig
    _sublimetext && (_sublimesettings ; _sublimekeybindings ; _sublimepackages ; _sublimeterminus)
    _vscode && _vscodeextensions
    _googlechrome
    _tilix
    _zsh
    _zshrc && _zshaliases
    _omz
    _reboot
}

function _guimenu() {
    OPT=$(whiptail --title "Selectively install packages/configurations" \
        --menu "\nSelect the packages and the configurations that you want to install/set." ${SIZE} $((ROWS-10)) \
        "1"  "    dconf_settings" \
        "2"  "    bashrc" \
        "3"  "    bash_aliases" \
        "4"  "    preload" \
        "5"  "    vmswappiness" \
        "6"  "    xclip" \
        "7"  "    neofetch" \
        "8"  "    htop" \
        "9"  "    cmake" \
        "10" "    tree" \
        "11" "    gnome-tweaks" \
        "12" "    gnome-shell-extensions" \
        "13" "    gitconfig" \
        "14" "    gitsofancy" \
        "15" "    neovim" \
        "16" "    neovimrc" \
        "17" "    tmux" \
        "18" "    tmux.conf" \
        "19" "    powerline" \
        "20" "    powerline_config" \
        "21" "    java & javac" \
        "22" "    sublime text 3" \
        "23" "    sublime text 3: settings + keybindings + packages" \
        "24" "    vscode" \
        "25" "    google chrome" \
        "26" "    tilix" \
        "27" "    zsh" \
        "28" "    zshrc" \
        "29" "    zsh_aliases" \
        "30" "    oh-my-zsh" \
        "31" "    set wallpaper" \
        "Q"  "    Quit" \
        3>&1 1>&2 2>&3)
}

function _selective_install() {
    _checkcommand curl && _checkcommand git
    exit_status=0
    while [[ $exit_status -eq 0 ]]; do
        _guimenu
        case $OPT in
            1 ) _dconfsettings ;;
            2 ) _bashrc ;;
            3 ) _bashaliases ;;
            4 ) _preload ;;
            5 ) _vmswappiness ;;
            6 ) _xclip ;;
            7 ) _neofetch ;;
            8 ) _htop ;;
            9 ) _cmake ;;
            10) _tree  ;;
            11) _gnometweaks ;;
            12) _gnomeshellextensions ;;
            13) _gitconfig ;;
            14) _gitsofancy ;;
            15) _nvim ;;
            16) _nvimrc ;;
            17) _tmux ;;
            18) _tmuxconf ;;
            19) _powerline ;;
            20) _powerlineconfig ;;
            21) _java ;;
            22) _sublimetext ;;
            23) _sublimeallconfigs ;;
            24) _vscode ;;
            25) _googlechrome ;;
            26) _tilix ;;
            27) _zsh ;;
            28) _zshrc ;;
            29) _zshaliases ;;
            30) _omz ;;
            31) _setwlp ;;
            Q | *) exit_status=1 ;;
        esac
        # Sleep only when user hasn't selected Quit
        [ $exit_status -eq 0 ] && sleep 2
    done
}

# ------------------------------------------------------- Main ---------------------------------------------------------

_showmenu

if [[ $INPUT -eq 1 ]]; then
    _fresh_install
elif [[ $INPUT -eq 2 ]]; then
    _selective_install
else
    exit 0
fi

