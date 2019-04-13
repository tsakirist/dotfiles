# !/usr/bin/env bash

# This script provides an easy way to install my preferred packages along with my configurations.
# Author: Tsakiris Tryfon
# This version uses local files from github repository.

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
        echo "${bold}${red}ERROR${reset}: Can't find ${1} in this directory. Installer needs all the contents of" \
             "the github repository."
        echo "You should issue the command: > git clone https://github.com/tsakirist/configurations.git"
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
    echo "Sourcing ~/.bashrc ..."
    source ~/.bashrc
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
    vim +PlugClean +PlugInstall +qall
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
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
    sudo apt update && sudo apt install -y sublime-text
}

function _sublimekeybindings() {
    _checkfile "sublime/Default (Linux).sublime-keymap"
    echo -e "${thunder} Setting ${bold}${red}sublime keybindings${reset} ..."
    cp -v --backup=numbered "sublime/Default (Linux).sublime-keymap" "$HOME/.config/sublime-text-3/Packages/User/"
}

function _sublimesettings() {
    _checkfile sublime/Preferences.sublime-settings
    echo -e "${thunder} Setting ${bold}${red}sublime settings${reset} ..."
    cp -v --backup=numbered "sublime/Preferences.sublime-settings" "$HOME/.config/sublime-text-3/Packages/User/"
}

function _sublimepackages() {
    _checkfile "sublime/Package Control.sublime-settings"
    echo -e "${thunder} Setting ${bold}${red}sublime packages${reset} ..."
    cp -v --backup=numbered "sublime/Package Control.sublime-settings" "$HOME/.config/sublime-text-3/Packages/User/"
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

function _showinfo() {
    echo "${bold}${start_underline}" \
         "This script provides an easy way to install my packages and my configurations." \
         "${end_underline}${reset}"
    echo "Script is executed from: ${bold}$(pwd)${reset}"
}

function _showmenu() {
    echo "What would you like to do?"
    echo "1. ${bold}${red}Fresh${reset} install?"
    echo "2. ${bold}${red}Selectively${reset} install 1-by-1?"
    echo "3. ${bold}${red}Selectively${reset} install 1-by-1 with GUI?"
    read -n 1 -s input
    echo "---------------------------------------------------------------------------------"
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
    _gitconfig && _gitsofancy
    _vim && _vimrc
    _tmux && _tmuxconf
    _powerline && _powerlineconfig
    _sublimetext && ( _sublimesettings ; _sublimekeybindings ; _sublimepackages )
    _vscode
    _googlechrome
    _reboot
}

function _selective_install_1b1() {
    _checkcommand curl && _checkcommand git
    _prompt _dconfsettings
    _prompt _bashrc ; _prompt _bashaliases
    _prompt _preload
    _prompt _vmswappiness
    _prompt _xclip 
    _prompt _neofetch
    _prompt _htop
    _prompt _cmake
    _prompt _tree
    _prompt _gitconfig ; _prompt _gitsofancy
    _prompt _vim ; _prompt _vimrc
    _prompt _tmux ; _prompt _tmuxconf
    _prompt _powerline ; _prompt _powerlineconfig
    _prompt _sublimetext ; _prompt _sublimesettings ; _prompt _sublimekeybindings ; _prompt _sublimepackages
    _prompt _vscode
    _prompt _googlechrome
}

function _guimenu() {
    local SIZE=$(stty size)
    OPT=$(whiptail --title "Selectively install packages/configurations" \
        --menu "Select the packages and the configurations that you want to install/set." ${SIZE} 25 \
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
        "11" "    gitconfig" \
        "12" "    gitsofancy" \
        "13" "    vim" \
        "14" "    vimrc" \
        "15" "    tmux" \
        "16" "    tmux.conf" \
        "17" "    powerline" \
        "18" "    powerline_config" \
        "19" "    sublime text 3" \
        "20" "    sublime settings" \
        "21" "    sublime keybindings" \
        "22" "    sublime packages" \
        "23" "    vscode" \
        "24" "    google chrome" \
        "Q"  "    Quit" \
        3>&1 1>&2 2>&3)
}

function _selective_install_1b1_gui() {
    _checkcommand curl && _checkcommand git && _checkcommand whiptail
    exit_status=0
    while [[ $exit_status -eq 0 ]]; do
        _guimenu
        case $OPT in
            1 ) _dconfsettings && sleep 3 ;;
            2 ) _bashrc && sleep 3 ;;
            3 ) _bashaliases && sleep 3 ;;
            4 ) _preload ;;
            5 ) _vmswappiness ;;
            6 ) _xclip ;;
            7 ) _neofetch ;;
            8 ) _htop ;;
            9 ) _cmake ;;
            10) _tree ;;
            11) _gitconfig && sleep 3 ;;
            12) _gitsofancy ;;
            13) _vim ;;
            14) _vimrc && sleep 3 ;;
            15) _tmux ;;
            16) _tmuxconf && sleep 3 ;;
            17) _powerline ;;
            18) _powerlineconfig && sleep 3 ;;
            19) _sublimetext ;;
            20) _sublimesettings && sleep 3 ;;
            21) _sublimekeybindings && sleep 3 ;;
            22) _sublimepackages && sleep 3 ;;
            23) _vscode ;;
            24) _googlechrome ;;
            Q | *) exit_status=1 ;;
        esac
    done
}

# ------------------------------------------------------- Main ---------------------------------------------------------

# In case we don't want to update the packages lists for testing we just need to provide a cmd argument
if [[ $# -eq 0 ]]; then
    echo -e "${thunder} Updating apt package lists ..."
    sudo apt update
fi

clear
_showinfo
_showmenu

if [[ $input -eq 1 ]]; then
    _fresh_install
elif [[ $input -eq 2 ]]; then
    _selective_install_1b1
elif [[ $input -eq 3 ]]; then
    _selective_install_1b1_gui
else
    echo -e "[${red}x${reset}] Wrong input. Available options: [1, 2, 3]."
    exit 1
fi

