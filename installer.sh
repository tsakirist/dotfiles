# !/usr/bin/env bash

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
    echo -e "${bullet} Do you want to download/install ${bold}${red}${1//_}${reset} [Y/n] "
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

function _gitconfig() {
    _checkfile gitconfig
    echo -e "${thunder} Setting ${bold}${red}.gitconfig${reset} ..."
    cp -v --backup=numbered gitconfig ~/.gitconfig
}

function _gitsofancy() {
    if ! command -v diff-so-fancy > /dev/null 2>&1; then
        echo -e "${thunder} Setting ${bold}${red}git-diff-so-fancy${reset} ..."
        wget -q "https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy"
        chmod +x diff-so-fancy && sudo mv diff-so-fancy /usr/bin/
    fi
}

function _bashrc() {
    _checkfile bashrc
    echo -e "${thunder} Setting ${bold}${red}.bashrc${reset} ..."
    cp -v --backup=numbered bashrc ~/.bashrc
    echo -e "You should source the ${bold}${red}~/.bashrc${reset} for the changes to have effect ..."
}

function _bashaliases() {
    _checkfile bash_aliases
    echo -e "${thunder} Setting ${bold}${red}.bash_aliases${reset} ..."
    cp -v --backup=numbered bash_aliases ~/.bash_aliases
}

function _vim() {
    echo -e "${thunder} Installing ${bold}${red}vim${reset} ..."
    sudo apt install -y vim vim-gnome
}

function _vimrc() {
    _checkfile vimrc
    echo -e "${thunder} Setting ${bold}${red}.vimrc${reset} ..."
    cp -v --backup=numbered vimrc ~/.vimrc
    vim +PlugInstall +qall
}

function _nvim() {
    echo -e "${thunder} Installing ${bold}${red}neovim${reset} ..."
    sudo sh -c 'echo "deb http://ppa.launchpad.net/neovim-ppa/stable/ubuntu bionic main" > \
                /etc/apt/sources.list.d/neovim.list'
    sudo apt update && sudo apt install -y neovim
}

function _nvimrc() {
    _checkfile vimrc && _checkfile init.vim
    echo -e "${thunder} Setting ${bold}${red}.vimrc and init.vim${reset} ..."
    cp -v --backup=numbered vimrc ~/.vimrc
    mkdir -v -p ~/.config/nvim/
    cp -v --backup=numbered init.vim ~/.config/nvim/
    nvim +PlugInstall +qall
}

function _tmux() {
    echo -e "${thunder} Installing ${bold}${red}tmux${reset} ..."
    sudo apt install -y tmux
}

function _tmuxconf() {
    _checkfile tmux.conf
    echo -e "${thunder} Setting ${bold}${red}.tmux.conf${reset} ..."
    cp -v --backup=numbered tmux.conf ~/.tmux.conf
}

function _sublimetext() {
    echo -e "${thunder} Installing ${bold}${red}SublimeText 3${reset} ..."
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
    sudo sh -c 'echo "deb https://download.sublimetext.com/ apt/stable/" > \
                /etc/apt/sources.list.d/sublime-text.list'
    sudo apt update && sudo apt install -y sublime-text
}

function _sublimesettings() {
    _checkfile sublime/Preferences.sublime-settings
    echo -e "${thunder} Setting ${bold}${red}sublime settings${reset} ..."
    cp -v --backup=numbered "sublime/Preferences.sublime-settings" "$HOME/.config/sublime-text-3/Packages/User/"
}

function _sublimekeybindings() {
    _checkfile "sublime/Default (Linux).sublime-keymap"
    echo -e "${thunder} Setting ${bold}${red}sublime keybindings${reset} ..."
    cp -v --backup=numbered "sublime/Default (Linux).sublime-keymap" "$HOME/.config/sublime-text-3/Packages/User/"
}

function _sublimepackages() {
    _checkfile "sublime/Package Control.sublime-settings"
    echo -e "${thunder} Setting ${bold}${red}sublime packages${reset} ..."
    cp -v --backup=numbered "sublime/Package Control.sublime-settings" "$HOME/.config/sublime-text-3/Packages/User/"
}

function _sublimeterminus() {
    _checkfile "sublime/Terminus.sublime-settings"
    echo -e "${thunder} Setting ${bold}${red}sublime terminus settings${reset} ..."
    cp -v --backup=numbered "sublime/Terminus.sublime-settings" "$HOME/.config/sublime-text-3/Packages/User/"
}

function _sublimeallconfigs() {
    _sublimesettings && _sublimekeybindings && _sublimepackages && _sublimeterminus
}

function _vscode() {
    echo -e "${thunder} Installing ${bold}${red}Visual Studio Code${reset} ..."
    curl -s https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/ && rm -f microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > \
                /etc/apt/sources.list.d/vscode.list'
    sudo apt update && sudo apt install -y code
}

function _googlechrome() {
    echo -e "${thunder} Installing ${bold}${red}Google Chrome${reset} ..."
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i google-chrome-stable_current_amd64.deb
    rm -f google-chrome-stable_current_amd64.deb
    # Remove google chrome keyring pop-up
    sudo sed -i '/^Exec=/s/$/ --password-store=basic %U/' "/usr/share/applications/google-chrome.desktop"
}

function _neofetch() {
    echo -e "${thunder} Installing ${bold}${red}neofetch${reset} ..."
    sudo apt install -y neofetch
}

function _xclip() {
    echo -e "${thunder} Installing ${bold}${red}xclip${reset} ..."
    sudo apt install -y xclip
}

function _powerline() {
    echo -e "${thunder} Installing ${bold}${red}powerline${reset} ..."
    sudo apt install -y python-pip
    pip install powerline-status
    pip install powerline-gitstatus
    sudo apt install -y fonts-powerline
}

function _powerlineconfig() {
    _checkfile powerline_configs/themes/shell/default.json && _checkfile powerline_configs/colorschemes/default.json

    echo -e "${thunder} Setting ${bold}${red}themes/shell/default.json${reset} ..."
    cp -v --backup=numbered "powerline_configs/themes/shell/default.json" \
        "$HOME/.local/lib/python2.7/site-packages/powerline/config_files/themes/shell"

    echo -e "${thunder} Setting ${bold}${red}colorschemes/default.json${reset} ..."
    cp -v --backup=numbered "powerline_configs/colorschemes/default.json" \
        "$HOME/.local/lib/python2.7/site-packages/powerline/config_files/colorschemes"
}

function _dconfsettings() {
    _checkfile dconf/settings.dconf
    echo -e "${thunder} Setting ${bold}${red}dconf_settings${reset} ..."
    dconf load / < dconf/settings.dconf
}

function _preload() {
    echo -e "${thunder} Installing ${bold}${red}preload${reset} ..."
    sudo apt install -y preload
}

function _vmswappiness() {
    echo -e "${thunder} Changing ${bold}${red}vm.swappiness${reset} to 10 ..."
    echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf > /dev/null 2>&1;
}

function _cmake() {
    echo -e "${thunder} Installing ${bold}${red}cmake${reset} ..."
    sudo apt install -y cmake
}

function _tree() {
    echo -e "${thunder} Installing ${bold}${red}tree${reset} ..."
    sudo apt install -y tree
}

function _htop() {
    echo -e "${thunder} Installing ${bold}${red}htop${reset} ..."
    sudo apt install -y htop
}

function _gnometweaks() {
    echo -e "${thunder} Installing ${bold}${red}gnome-tweaks${reset} ..."
    sudo apt install -y gnome-tweaks
}

function _gnomeshellextensions() {
    echo -e "${thunder} Installing ${bold}${red}gnome-shell-extensions${reset} ..."
    sudo apt install -y gnome-shell-extension-weather gnome-shell-extension-dashtodock
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
    _dconfsettings
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
        "21" "    sublime text 3" \
        "22" "    sublime text 3: settings + keybindings + packages" \
        "23" "    vscode" \
        "24" "    google chrome" \
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
            21) _sublimetext ;;
            22) _sublimeallconfigs ;;
            23) _vscode ;;
            24) _googlechrome ;;
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

