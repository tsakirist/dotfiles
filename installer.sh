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

function _check_ppa() {
    for i in "$@"; do
        if ! grep -Rq "^deb.*$i" /etc/apt/sources.list.d/*.list; then
            sudo add-apt-repository -y ppa:"$i" > /dev/null
            sudo apt-get -qq update
        fi
    done
}

function _check_file() {
    if [ ! -f "$1" ]; then
        echo "${bold}${red_fg}Error${reset}: cannot find ${1} in this directory."
        echo "You should run the installer from within the github repository."
        echo "(git clone https://github.com/tsakirist/configurations.git)"
        exit 1
    fi
}

function _check_dir() {
    if [ ! -d "$1" ]; then
        echo "${bold}${red_fg}Error${reset}: cannot find ${1} in this directory."
        echo "You should run the installer from within the github repository."
        echo "(git clone https://github.com/tsakirist/configurations.git)"
        exit 1
    fi
}

function _check_command() {
    if ! command -v "$1" > /dev/null 2>&1; then
        echo -ne "${thunder} Installing required package ${bold}${red_fg}${1}${reset} ..."
        _install "$1"
    fi
}

function _install() {
    # -qq: option implies --yes and also is less verbose
    sudo apt-get -qq install "$@" > /dev/null
}

function _backup() {
    echo "Backing up $1 ..."
    cp "$1" "$1" -v --force --backup=numbered
}

function _reboot() {
    echo "${black_bg}${bold}It is recommended to ${red_fg}reboot${white_fg} after a fresh installation" \
         "of the packages and configurations.${reset}"
    read -n 1 -r -p "Would you like to reboot? [Y/n] " input
    if [[ "$input" =~ ^([yY])$ ]]; then
        sudo reboot
    fi
}

function _prompt() {
    local exec=false
    echo -e "${bullet} Do you want to download/install ${bold}${red_fg}${1}${reset} [Y/n] "
    read -n 1 -r -s input
    if [[ "$input" =~ ^([yY])$ ]]; then
        exec=true
    fi
    if [[ $exec == "true" ]]; then
        $1
    fi
}

function _print() {
    local action
    if [ $# -gt 1 ]; then
        case "$1" in
            "s") action="Setting" ;;
            "i") action="Installing" ;;
            "c") action="Changing" ;;
        esac
        echo -en "${black_bg}${thunder} ${action} ${bold}${red_fg}${*:2:1}${reset}"
        echo -e  "${black_bg}${*:3} ...${reset}"
    fi
}

function _change_shell() {
    if [ $# -eq 0 ]; then
        echo "Cannot change shell to empty argument. You must provide the ${bold}${red_fg}shell name${reset}."
        return
    fi
    local shell
    case "$1" in
        "bash") shell="bash" ;;
        "zsh" ) shell="zsh" ;;
    esac
    local msg="Do you want to change the default shell to ${shell}?\nThis will issue 'chsh -s $(which ${shell})' command."
    if (whiptail --title "Change shell" --yesno "${msg}" 8 78); then
        chsh -s "$(which ${shell})"
        _print c "shell to $(which ${shell})"
        echo "In order for the ${start_underline}change${end_underline} to take effect you need to" \
             "${bold}${red_fg}re-login${reset}."
    fi
}

function _git_config() {
    _check_file git/gitconfig
    _print s ".gitconfig"
    ln -sv --backup=numbered "$(pwd)/git/gitconfig" $HOME/.gitconfig
}

function _git_so_fancy() {
    if ! command -v diff-so-fancy > /dev/null 2>&1; then
        _print s "git-diff-so-fancy"
        wget -q "https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy"
        chmod +x diff-so-fancy && sudo mv diff-so-fancy /usr/bin/
    fi
}

function _bashrc() {
    _check_file bash/bashrc
    _print s ".bashrc"
    ln -sv --backup=numbered "$(pwd)/bash/bashrc" $HOME/.bashrc
}

function _bash_aliases() {
    _check_file bash/bash_aliases
    _print s ".bash_aliases"
    ln -sv --backup=numbered "$(pwd)/bash/bash_aliases" $HOME/.bash_aliases
}

function _bash_functions() {
    _check_file bash/bash_functions
    _print s ".bash_functions"
    ln -sv --backup=numbered "$(pwd)/bash/bash_functions" $HOME/.bash_functions
}

function _bash_config() {
    _bashrc && _bash_aliases && _bash_functions
}

function _zsh() {
    _print i "zsh"
    _install zsh
    _change_shell zsh
}

function _zshrc() {
    _check_file zsh/zshrc
    _print s ".zshrc"
    ln -sv --backup=numbered "$(pwd)/zsh/zshrc" $HOME/.zshrc
}

function _zsh_aliases() {
    _check_file zsh/zsh_aliases
    _print s ".zsh_aliases"
    ln -sv --backup=numbered "$(pwd)/zsh/zsh_aliases" $HOME/.zsh_aliases
}

function _zsh_functions () {
    _check_file zsh/zsh_functions
    _print s ".zsh_functions"
    ln -sv --backup=numbered "$(pwd)/zsh/zsh_functions" $HOME/.zsh_functions
}

function _zsh_config() {
    _zshrc && _zsh_aliases && _zsh_functions
}

function _oh_my_zsh() {
    local zsh_custom=$HOME/.oh-my-zsh/custom
    _print i "oh-my-zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$zsh_custom"/themes/powerlevel10k
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$zsh_custom"/plugins/zsh-autosuggestions
    git clone --depth=1 https://github.com/zdharma/fast-syntax-highlighting.git \
        "$zsh_custom"/plugins/fast-syntax-highlighting
    _zshrc
}

function _vim() {
    _print i "vim"
    _install vim vim-gnome
}

function _vimrc() {
    _check_file nvim/vimrc
    _print s ".vimrc"
    ln -sv --backup=numbered "$(pwd)/nvim/vimrc" $HOME/.vimrc
    vim +PlugInstall +qall
}

function _nvim() {
    _print i "neovim"
    # _check_ppa neovim-ppa/stable
    _check_ppa neovim-ppa/unstable
    _install neovim
}

function _nvim_autoload() {
    _check_dir nvim/autoload && _check_file nvim/autoload/functions.vim
    mkdir -v -p $HOME/.vim/autoload/
    ln -sv --backup=numbered "$(pwd)/nvim/autoload/functions.vim" $HOME/.vim/autoload/functions.vim
}

function _nvimrc() {
    _check_file nvim/vimrc && _check_file nvim/init.vim
    _print s ".vimrc and init.vim and autoload"
    ln -sv --backup=numbered "$(pwd)/nvim/vimrc" $HOME/.vimrc
    mkdir -v -p $HOME/.config/nvim/
    ln -sv --backup=numbered "$(pwd)/nvim/init.vim" $HOME/.config/nvim/init.vim
    _nvim_autoload
    nvim +PlugInstall +qall
}

function _tmux() {
    _print i "tmux"
    _install tmux
}

function _tmux_config() {
    _check_file tmux/tmux.conf
    _print s ".tmux.conf"
    ln -sv --backup=numbered "$(pwd)/tmux/tmux.conf" $HOME/.tmux.conf
}

function _vscode() {
    _print i "Visual Studio Code"
    curl -s https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/ && rm -f microsoft.gpg
    sudo sh -c "echo 'deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main' > \
                /etc/apt/sources.list.d/vscode.list"
    sudo apt-get -qq update && _install code
}

function _google_chrome() {
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

function _dconf_tilix() {
    _check_file dconf/tilix.dconf
    _print s "tilix dconf settings"
    dconf load /com/gexperts/Tilix/ < dconf/tilix.dconf
}

function _dconf_settings() {
    _check_file dconf/settings.dconf
    _print s "dconf settings"
    dconf load / < dconf/settings.dconf
}

function _dconf_settings_w_themes() {
    _check_file dconf/settings_with_themes.dconf
    _print s "dconf settings with themes"
    dconf load / < dconf/settings_with_themes.dconf
}

function _dconf() {
    _dconf_settings_w_themes && _dconf_tilix
}

function _preload() {
    _print i "preload"
    _install preload
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
    _print i "htop" ": an interactive process viewer"
    _install htop
}

function _gotop() {
    _print i "gotop" ": a terminal UI system monitoring tool"
    sudo snap install gotop-cjbassi
    sudo snap connect gotop-cjbassi:hardware-observe
    sudo snap connect gotop-cjbassi:mount-observe
    sudo snap connect gotop-cjbassi:system-observe
}

function _ncdu() {
    _print i "ncdu" ": a terminal UI disk usage monitoring tool"
    _install ncdu
}

function _monitoring_tools() {
    _htop
    _gotop
    _ncdu
}

function _gnome_tweaks() {
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

function _gnome_shell_extensions() {
    _print i "gnome-shell-extensions"
    _install gnome-shell-extensions gnome-shell-extension-weather gnome-shell-extension-dashtodock
    _arcmenu
}

function _arc_theme() {
    _print i "Arc-theme"
    _install arc-theme
}

function _papirus_folders() {
    _print i "Papirus folders script"
    _check_ppa papirus/papirus
    _install papirus-folders
    sudo papirus-folders -C deeporange > /dev/null
}

function _papirus_icons() {
    _print i "Papirus icons"
    _check_ppa papirus/papirus
    _install papirus-icon-theme
}

function _papirus() {
    _papirus_icons && _papirus_folders
}

function _java() {
    _print i "java and javac"
    _install default-jre default-jdk
}

function _tilix() {
    _print i "tilix" ": a terminal emulator"
    _check_ppa webupd8team/terminix
    _install tilix
}

function _kitty() {
    _print i "kity" ": the fast, featureful, GPU based terminal emulator"
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n
    ln -sv $HOME/.local/kitty.app/bin/kitty /usr/local/bin/
    # Place the kitty.desktop file somewhere it can be found
    cp -v ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
    # Update the path to the kitty icon in the kitty.desktop file
    sed -i "s|Icon=kitty|Icon=/home/$USER/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" \
        ~/.local/share/applications/kitty.desktop
}

function _kitty_config() {
    _check_file kitty/kitty.conf
    _print s "kitty.conf"
    ln -sv --backup=numbered "$(pwd)/kitty/kitty.conf" $HOME/.config/kitty/kitty.conf
}

function _kitty_themes() {
    _print i "kitty-themes"
    git clone --depth=1 https://github.com/dexpota/kitty-themes.git ~/.config/kitty/kitty-themes
}

function _x_profile() {
    _check_file x/xprofile
    _print s "xprofile"
    ln -sv --backup=numbered "$(pwd)/x/xprofile" $HOME/.xprofile
}

function _set_wallpaper() {
    local wlp="wallpapers/1.jpg"
    _check_file "$wlp"

    local path="$(readlink -e $wlp)"
    local uri="'file://$path'"
    _print s "wallpaper" ": $path"
    gsettings set org.gnome.desktop.background picture-uri "$uri"
}

function _install_fonts_from_dir() {
    local fonts_dir="fonts"
    local fonts_dest=$HOME/.local/share/fonts/

    _check_dir $fonts_dir

    for font in "$fonts_dir"/*.ttf; do
        cp -v "$font" "$fonts_dest"
    done
}

function _install_fonts() {
    _print i "fonts"
    _install_fonts_from_dir
}

function _fzf_config() {
    _check_file fzf/fzf.config
    _print s "fzf configuration"
    ln -sv --backup=numbered "$(pwd)/fzf/fzf.config" $HOME/.fzf.config
}

function _fzf() {
    _print i "fzf" ": Fuzzy finder"
    if [ -d $HOME/.fzf ]; then
        pushd $HOME/.fzf && git pull origin && popd
    else
        git clone --depth=1 https://github.com/junegunn/fzf.git $HOME/.fzf
    fi
    $HOME/.fzf/install --key-bindings --completion --no-update-rc
}

function _fd() {
    _print i "fd" ": an improved version of find"
    wget -q https://github.com/sharkdp/fd/releases/download/v7.4.0/fd-musl_7.4.0_amd64.deb -O /tmp/fd.deb
    sudo dpkg -i /tmp/fd.deb > /dev/null
}

function _bat() {
    _print i "bat" ": a clone of cat with syntax highlighting"
    wget -q https://github.com/sharkdp/bat/releases/download/v0.12.1/bat-musl_0.12.1_amd64.deb -O /tmp/bat.deb
    sudo dpkg -i /tmp/bat.deb > /dev/null
}

function _rg() {
    _print i "rg" ": ripgrep recursive search for a pattern in files"
    wget -q https://github.com/BurntSushi/ripgrep/releases/download/11.0.2/ripgrep_11.0.2_amd64.deb -O /tmp/rg.deb
    sudo dpkg -i /tmp/rg.deb > /dev/null
}

function _lazygit() {
    _print i "lazygit" ": a terminal UI utility for git commands"
    _check_ppa lazygit-team/release
    _install lazygit
}

function _vm_swappiness() {
    local value=10
    local file="/etc/sysctl.conf"
    _print c "vm.swappiness" " to $value"
    if grep -q "^vm.swappiness" $file; then
        sudo sed -i "s/\(^vm.swappiness=\).*/\1$value/" $file
    else
        echo "vm.swappiness=${value}" | sudo tee -a $file > /dev/null 2>&1;
    fi
    sudo sysctl -q --system
    echo "Swappiness value:" "$(cat /proc/sys/vm/swappiness)"
}

function _check_root() {
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

function _validate_root() {
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
    "    kitty: the fast, featureful, GPU based terminal emulator"
    "    kitty configuration"
    "    kitty themes"
    "    fzf: fuzzy finder"
    "    fzf configuration"
    "    fd: improved version of find"
    "    bat: a cat clone with syntax highlighting"
    "    rg: ripgrep recursive search for a pattern in files"
    "    nvim"
    "    nvimrc"
    "    xprofile"
    "    tmux: terminal multiplexer"
    "    tmux configuration"
    "    xclip"
    "    neofetch"
    "    htop + gotop + ncdu: monitoring tools"
    "    lazygit: a terminal UI for git commands"
    "    tree"
    "    cmake"
    "    gnome-tweaks"
    "    gnome-shell-extensions"
    "    gitconfig"
    "    gitsofancy"
    "    java and javac"
    "    vscode"
    "    google chrome"
    "    preload"
    "    vmswappiness"
    "    set wallpaper"
    "    install fonts"
    "    arc-theme"
    "    papirus icons and folder changer script"
)

pkgs_functions=(
    _show_dconf_menu
    _zsh
    _zsh_config
    _oh_my_zsh
    _bash_config
    _tilix
    _kitty
    _kitty_config
    _kitty_themes
    _fzf
    _fzf_config
    _fd
    _bat
    _rg
    _nvim
    _nvimrc
    _x_profile
    _tmux
    _tmux_config
    _xclip
    _neofetch
    _monitoring_tools
    _lazygit
    _tree
    _cmake
    _gnome_tweaks
    _gnome_shell_extensions
    _git_config
    _git_so_fancy
    _java
    _vscode
    _google_chrome
    _preload
    _vm_swappiness
    _set_wallpaper
    _install_fonts
    _arc_theme
    _papirus
)

dotfiles_functions=(
    _zsh_config
    _bash_config
    _fzf_config
    _nvimrc
    _tmux_config
    _kitty_config
    _x_profile
)

# -------------------------------------------------------- Menus -------------------------------------------------------

function _show_main_menu() {
    _check_command whiptail
    local INFO="---------------------- System Information -----------------------\n"
    INFO+="$(hostnamectl | tail -n 3 | cut -c3-)"
    INPUT=$(whiptail --title "This script provides an easy way to install my preferred packages and configurations." \
        --menu "\nScript is executed from '$(pwd)'\n\n${INFO}" ${SIZE} 4 \
        "1"  "    Fresh installation of everything" \
        "2"  "    Selective installation" \
        "3"  "    Dotfiles installation" \
        "Q"  "    Quit" \
        3>&1 1>&2 2>&3)
}

function _create_selective_menu() {
    # Dynamically populate the GUI menu from the pkgs array
    menu_options=()
    for (( i=0; i<"${#pkgs[@]}"; i++ )); do
        menu_options+=("$((i + 1))")
        menu_options+=("${pkgs[$i]}")
    done
    # Manually add the Quit option
    menu_options+=("Q")
    menu_options+=("    Quit")
}

function _show_selective_menu() {
    OPT=$(whiptail --title "Selectively install packages/configurations" \
        --menu "\nSelect the packages and the configurations that you want to install/set." ${SIZE} $((ROWS-10)) \
        "${menu_options[@]}" \
        3>&1 1>&2 2>&3)
}

function _show_dconf_menu() {
    local opt=$(whiptail --title "dconf settings" --menu "\nWhich dconf settings would you like to apply?" \
                ${SIZE} 3 \
                "1" "    dconf general settings without themes" \
                "2" "    dconf general settings with themes" \
                "3" "    dconf tilix settings" \
                3>&1 1>&2 2>&3)
    case $opt in
        1) _dconf_settings ;;
        2) _dconf_settings_w_themes ;;
        3) _dconf_tilix ;;
    esac
}

# ----------------------------------------------------- Installers -----------------------------------------------------

function _fresh_install() {
    _check_command curl && _check_command git
    for (( i = 1; i < "${#pkgs_functions[@]}"; i++ )); do
        ${pkgs_functions[$i]}
    done
    _dconf
    _reboot
}

function _selective_install() {
    _check_command curl && _check_command git
    _create_selective_menu
    local exit_status=0
    while [ $exit_status -eq 0 ]; do
        _show_selective_menu
        case $OPT in
            Q) exit_status=1 ;;
            *) ${pkgs_functions[(($OPT - 1))]}
        esac
        # Sleep only when user hasn't selected Quit
        [ $exit_status -eq 0 ] && sleep 2
    done
}

function _dotfiles_install() {
    for (( i = 0;  i < "${#dotfiles_functions[@]}"; i++ )); do
        ${dotfiles_functions[$i]}
    done
}

# ------------------------------------------------------- Main ---------------------------------------------------------

_validate_root
_show_main_menu

if [[ $INPUT -eq 1 ]]; then
    _fresh_install
elif [[ $INPUT -eq 2 ]]; then
    _selective_install
elif [[ $INPUT -eq 3 ]]; then
    _dotfiles_install
else
    exit 0
fi
