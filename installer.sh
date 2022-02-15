#!/usr/bin/env bash

# This script provides an easy way to install my preferred packages along with my configurations.
# Author: Tsakiris Tryfon

# --------------------------------------------- Disable Shellcheck rules -----------------------------------------------
# shellcheck disable=SC2155
# SC2155: Declare and assign separately to avoid masking return values.

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
        echo -e "${black_bg}${thunder} Installing required package ${bold}${red_fg}${1}${reset} ..."
        _install "$1"
    fi
}

# Function that takes as argument the author/repo and installs the latest deb
# TODO: Fix this function somehow to take arguments for grep? or  some extra pattern
function _install_latest_deb() {
    local repo="https://api.github.com/repos/$1/releases/latest"
    local url=$(curl -s "$repo" | grep "browser_download_url" | grep -v "musl" | grep "amd64" | grep "deb" | cut -d '"' -f 4)
    local filename=$(basename "$url")
    wget -qO /tmp/"$filename" "$url" && sudo dpkg -i /tmp/"$filename" > /dev/null
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
        echo -e "${black_bg}${*:3} ...${reset}"
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
        "zsh") shell="zsh" ;;
    esac
    local msg="Do you want to change the default shell to ${shell}?\nThis will issue 'chsh -s $(command -v ${shell})' command."
    if (whiptail --title "Change shell" --yesno "${msg}" 8 78); then
        chsh -s "$(command -v ${shell})"
        _print c "shell to $(command -v ${shell})"
        echo "In order for the ${start_underline}change${end_underline} to take effect you need to" \
            "${bold}${red_fg}re-login${reset}."
    fi
}

function _git_config() {
    _check_file git/gitconfig
    _print s ".gitconfig"
    ln -sv --backup=numbered "$(pwd)/git/gitconfig" "$HOME"/.gitconfig
}

function _git_delta() {
    _print i "delta" " a better viewer for git and diff output"
    _install_latest_deb dandavison/delta
}

function _bashrc() {
    _check_file bash/bashrc
    _print s ".bashrc"
    ln -sv --backup=numbered "$(pwd)/bash/bashrc" "$HOME"/.bashrc
}

function _bash_aliases() {
    _check_file bash/bash_aliases
    _print s ".bash_aliases"
    ln -sv --backup=numbered "$(pwd)/bash/bash_aliases" "$HOME"/.bash_aliases
}

function _bash_functions() {
    _check_file bash/bash_functions
    _print s ".bash_functions"
    ln -sv --backup=numbered "$(pwd)/bash/bash_functions" "$HOME"/.bash_functions
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
    ln -sv --backup=numbered "$(pwd)/zsh/zshrc" "$HOME"/.zshrc
}

function _zsh_aliases() {
    _check_file zsh/zsh_aliases
    _print s ".zsh_aliases"
    ln -sv --backup=numbered "$(pwd)/zsh/zsh_aliases" "$HOME"/.zsh_aliases
}

function _zsh_functions() {
    _check_file zsh/zsh_functions
    _print s ".zsh_functions"
    ln -sv --backup=numbered "$(pwd)/zsh/zsh_functions" "$HOME"/.zsh_functions
}

function _zsh_p10k() {
    _check_file zsh/p10k.zsh
    _print s ".p10k.zsh"
    cp -v --backup=numbered zsh/p10k.zsh ~/.p10k.zsh
}

function _zsh_forgit() {
    _check_file zsh/forgit.zsh
    _print s ".forgit.zsh"
    cp -v --backup=numbered zsh/forgit.zsh ~/.forgit.zsh
}

function _zsh_config() {
    _zshrc && _zsh_aliases && _zsh_functions && _zsh_p10k && _zsh_forgit
}

function _oh_my_zsh() {
    _print i "oh-my-zsh" ": framework for managing zsh configuration"
    # Do not try to install, if the directory already exists
    [ -d "$HOME/.oh-my-zsh" ] && return
    local zsh_custom="$HOME/.oh-my-zsh/custom"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    git clone --quiet --depth=1 https://github.com/romkatv/powerlevel10k.git "$zsh_custom"/themes/powerlevel10k
    git clone --quiet --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$zsh_custom"/plugins/zsh-autosuggestions
    git clone --quiet --depth=1 https://github.com/zdharma-continuum/fast-syntax-highlighting "$zsh_custom"/plugins/fast-syntax-highlighting
    git clone --quiet --depth=1 https://github.com/wfxr/forgit.git "$zsh_custom"/plugins/forgit
    _zshrc
}

function _build_essential() {
    _print i "build-essential"
    _install build-essential
}

function _node() {
    _print i "node" ": asyncrhonous event-driven JavaScript runtime"
    curl -sSL https://deb.nodesource.com/setup_current.x | sudo -E bash - > /dev/null 2>&1
    _install nodejs
}

function _nvim_nightly() {
    _print i "neovim nightly" ": a superior vim fork focused on extensiblity and usability"
    local url="https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage"
    local download_dir=$(mktemp -d)
    wget -q -O "$download_dir"/nvim.appimage "$url"
    pushd "$download_dir" > /dev/null || return
    [ -f nvim.appimage ] \
        && chmod u+x nvim.appimage \
        && echo -ne "    ${green_fg}${tick}${reset} Installed " \
        && ./nvim.appimage --version | grep --color=always -m 1 NVIM \
        && sudo mv nvim.appimage /usr/bin/nvim
    popd > /dev/null || return
}

function _check_nvim_config_requirements() {
    echo -e "    ${bullet} Checking requirements ..."
    if ! command -v make > /dev/null 2>&1; then
        _build_essential
    fi
    if ! command -v node > /dev/null 2>&1; then
        _node
    fi
}

function _nvim_config() {
    _print s "neovim configuration"
    _check_dir nvim/current

    # Check nvim requirements
    _check_nvim_config_requirements

    # Make symbolic links to the whole nvim directory in the target directory
    # This will force copy the soft-links, thus re-writing the existing ones
    cp -asf "$(pwd)/nvim/current" "$HOME/.config/nvim"

    # Make sure to install packer if needed
    /usr/bin/nvim --headless -c "lua require('tt.plugins.packer').packer_bootstrap()" -c "quitall"

    # Install all plugins and generate compiled loader file
    /usr/bin/nvim --headless -c "autocmd User PackerComplete quitall" -c "PackerSync"

    # Output a newline after Packer:Complete message from NVIM
    echo
}

function _shellcheck() {
    _print i "shellcheck" ": Shell script static analysis tool - linter"
    _install shellcheck
}

function _shfmt() {
    _print i "shfmt" ": Shell formatter"
    # TODO: Since this logic is repeating extract only the url logic to a function?
    # Download latest zip from GitHub releases
    local repo="https://api.github.com/repos/mvdan/sh/releases/latest"
    local url=$(curl -s "$repo" | grep "browser_download_url" | grep "linux" | grep "amd64" | cut -d '"' -f 4)
    local download_dir=$(mktemp -d)
    local filename=$(basename "$url")
    local file="$download_dir/$filename"
    wget -qO "$file" "$url" && chmod u+x "$file" && sudo mv "$file" /usr/local/bin/shfmt
}

function _luacheck() {
    _print i "luacheck" ": Static analysis tool and linter for Lua"
    _install lua-check
}

function _stylua() {
    _print i "stylua" ": An opiniated Lua formatter"
    # Check dependencies
    _check_command unzip
    # TODO: Since this logic is repeating extract only the url logic to a function?
    # Download latest zip from GitHub releases
    local repo="https://api.github.com/repos/JohnnyMorganz/StyLua/releases/latest"
    local url=$(curl -s "$repo" | grep "browser_download_url" | grep "linux" | cut -d '"' -f 4)
    local download_dir=$(mktemp -d)
    local filename=$(basename "$url")
    local file="$download_dir/stylua"
    wget -qO "$download_dir/$filename" "$url" && unzip -q "$download_dir/$filename" -d "$download_dir"
    [ -f "$file" ] && chmod u+x "$file" && sudo mv "$file" /usr/local/bin
}

function _vscode() {
    _print i "visual studio code"
    wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add - > /dev/null 2>&1
    sudo sh -c "echo 'deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main' > \
                /etc/apt/sources.list.d/vscode.list"
    sudo apt-get -qq update && _install code
}

function _google_chrome() {
    _print i "google chrome"
    wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/google_chrome.deb
    sudo dpkg -i /tmp/google_chrome.deb > /dev/null
    # Remove google chrome keyring pop-up
    sudo sed -i '/^Exec=/s/$/ --password-store=basic %U/' "/usr/share/applications/google-chrome.desktop"
}

function _neofetch() {
    _print i "neofetch" ": a command-line system information tool"
    _install neofetch
}

function _xclip() {
    _print i "xclip" ": command line interface to X selections (clipboard)"
    _install xclip
}

function _dconf() {
    _check_file dconf/settings.dconf
    _print s "dconf settings"
    dconf load / < dconf/settings.dconf
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
    _print i "tree" ": list contents of directories in a tree-like format"
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

function _gnome_shell_extensions() {
    _print i "gnome-shell-extensions"
    _install gnome-shell-extensions gnome-shell-extension-dashtodock gnome-shell-extension-arc-menu
}

function _gnome_sushi() {
    _print i "gnome-sushi" ": file previewer"
    _install gnome-sushi
}

function _java() {
    _print i "java and javac"
    _install default-jre default-jdk
}

function _kitty() {
    _print i "kity" ": the fast, featureful, GPU based terminal emulator"
    curl -sSL https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n > /dev/null
    sudo ln -svf "$HOME"/.local/kitty.app/bin/kitty /usr/local/bin/
    # Place the kitty.desktop file somewhere it can be found
    cp -v ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
    # Update the path to the kitty icon in the kitty.desktop file
    sed -i "s|Icon=kitty|Icon=/home/$USER/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" \
        ~/.local/share/applications/kitty.desktop
}

function _kitty_config() {
    _check_file kitty/kitty.conf
    _check_file kitty/kitty.png
    _print s "kitty.conf"
    local destination="$HOME/.config/kitty"
    [ ! -d "$destination" ] && mkdir -p "$destination"
    ln -sv --backup=numbered "$(pwd)/kitty/kitty.conf" "$destination/kitty.conf"
    cp -v kitty/kitty.png "$destination/"
}

function _kitty_themes() {
    _print i "kitty-themes"
    local themes_path="$HOME/.config/kitty/kitty-themes"
    [ ! -d "$themes_path" ] \
        && git clone --quiet --depth=1 https://github.com/dexpota/kitty-themes.git ~/.config/kitty/kitty-themes
}

function _x_profile() {
    _check_file x/xprofile
    _print s "xprofile"
    ln -sv --backup=numbered "$(pwd)/x/xprofile" "$HOME"/.xprofile
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
    local fonts_dest="$HOME/.local/share/fonts/"

    _check_dir $fonts_dir

    # Create directory if necessary
    [ ! -d "$fonts_dest" ] && mkdir -p "$fonts_dest"

    for font in "$fonts_dir"/*.ttf; do
        cp -v "$font" "$fonts_dest"
    done

    # Force rebuild of fc-cache
    fc-cache -f
}

function _install_fonts() {
    _print i "fonts"
    _install_fonts_from_dir
}

function _fzf_config() {
    _check_file fzf/fzf.config
    _print s "fzf configuration"
    ln -sv --backup=numbered "$(pwd)/fzf/fzf.config" "$HOME"/.fzf.config
}

function _fzf() {
    _print i "fzf" ": a command line fuzzy finder"
    if [ -d "$HOME"/.fzf ]; then
        pushd "$HOME"/.fzf || return \
            && git pull origin \
            && popd || return
    else
        git clone --quiet --depth=1 https://github.com/junegunn/fzf.git "$HOME"/.fzf
    fi
    "$HOME"/.fzf/install --key-bindings --completion --no-update-rc
}

function _fd() {
    _print i "fd" ": an improved version of find"
    _install_latest_deb sharkdp/fd
}

function _bat() {
    _print i "bat" ": a clone of cat with syntax highlighting"
    _install_latest_deb sharkdp/bat
}

function _rg() {
    _print i "rg" ": ripgrep recursive search for a pattern in files"
    _install_latest_deb BurntSushi/ripgrep
}

function _glow() {
    _print i "glow" ": markdown renderer for the terminal"
    _install_latest_deb charmbracelet/glow
}

function _vm_swappiness() {
    local value=10
    local file="/etc/sysctl.conf"
    _print c "vm.swappiness" " to $value"
    if grep -q "^vm.swappiness" $file; then
        sudo sed -i "s/\(^vm.swappiness=\).*/\1$value/" $file
    else
        echo "vm.swappiness=${value}" | sudo tee -a $file > /dev/null 2>&1
    fi
    sudo sysctl -q -p
    echo "Swappiness value:" "$(cat /proc/sys/vm/swappiness)"
}

function _check_root() {
    local msg="$(printf '%s\n' \
        "Would you like to have a completely unattended installation?" \
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

function _disable_automatic_apt_updates() {
    _print s "non automatic updates for apt"
    local file="/etc/apt/apt.conf.d/20auto-upgrades"
    local contents=$(
        cat << EOF
APT::Periodic::Update-Package-Lists "0";
APT::Periodic::Download-Upgradeable-Packages "0";
APT::Periodic::AutocleanInterval "0";
APT::Periodic::Unattended-Upgrade "1";
EOF
    )
    echo "$contents" | sudo tee "$file" > /dev/null 2>&1
}

# ------------------------------------------------------ Packages ------------------------------------------------------

pkgs=(
    "    dconf settings"
    "    build-essential"
    "    zsh"
    "    zshrc, zsh_aliases, zsh_functions, zsh_p10k, zsh_forgit"
    "    oh-my-zsh"
    "    bashrc, bash_aliases, bash_functions"
    "    nvim nightly"
    "    nvim configuration"
    "    kitty: the fast, featureful, GPU based terminal emulator"
    "    kitty configuration"
    "    kitty themes"
    "    fzf: fuzzy finder"
    "    fzf configuration"
    "    fd: improved version of find"
    "    rg: ripgrep recursive search for a pattern in files"
    "    bat: a cat clone with syntax highlighting"
    "    glow: markdown renderer for the terminal"
    "    shfmt: shell formatter"
    "    shellcheck: shell static analysis tool"
    "    stylua: an opiniated Lua formatter"
    "    luacheck: lua static analysis tool"
    "    node: asyncrhonous event-driven JavaScript runtime"
    "    xprofile"
    "    xclip"
    "    neofetch"
    "    htop + gotop + ncdu: monitoring tools"
    "    tree"
    "    cmake"
    "    gnome-tweaks"
    "    gnome-shell-extensions"
    "    gnome-sushi"
    "    gitconfig"
    "    git delta"
    "    java and javac"
    "    vscode"
    "    google chrome"
    "    preload"
    "    vmswappiness"
    "    set wallpaper"
    "    install fonts"
    "    disable automatic apt updates"
)

pkgs_functions=(
    _dconf
    _build_essential
    _zsh
    _zsh_config
    _oh_my_zsh
    _bash_config
    _nvim_nightly
    _nvim_config
    _kitty
    _kitty_config
    _kitty_themes
    _fzf
    _fzf_config
    _fd
    _rg
    _bat
    _glow
    _shfmt
    _shellcheck
    _stylua
    _luacheck
    _node
    _x_profile
    _xclip
    _neofetch
    _monitoring_tools
    _tree
    _cmake
    _gnome_tweaks
    _gnome_shell_extensions
    _gnome_sushi
    _git_config
    _git_delta
    _java
    _vscode
    _google_chrome
    _preload
    _vm_swappiness
    _set_wallpaper
    _install_fonts
    _disable_automatic_apt_updates
)

dotfiles_functions=(
    _zsh_config
    _bash_config
    _fzf_config
    _nvim_config
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
        "1" "    Fresh installation of everything" \
        "2" "    Selective installation" \
        "3" "    Dotfiles installation" \
        "Q" "    Quit" \
        3>&1 1>&2 2>&3)
}

function _create_selective_menu() {
    # Dynamically populate the GUI menu from the pkgs array
    menu_options=()
    for ((i = 0; i < "${#pkgs[@]}"; i++)); do
        menu_options+=("$((i + 1))")
        menu_options+=("${pkgs[$i]}")
    done
    # Manually add the Quit option
    menu_options+=("Q")
    menu_options+=("    Quit")
}

function _show_selective_menu() {
    OPT=$(whiptail --title "Selectively install packages/configurations" \
        --menu "\nSelect the packages and the configurations that you want to install/set." ${SIZE} $((ROWS - 10)) \
        "${menu_options[@]}" \
        3>&1 1>&2 2>&3)
}

# ----------------------------------------------------- Installers -----------------------------------------------------

function _fresh_install() {
    _check_command curl && _check_command git
    for ((i = 1; i < "${#pkgs_functions[@]}"; i++)); do
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
            *) ${pkgs_functions[(($OPT - 1))]} ;;
        esac
        # Sleep only when user hasn't selected Quit
        [ $exit_status -eq 0 ] && sleep 2
    done
}

function _dotfiles_install() {
    for ((i = 0; i < "${#dotfiles_functions[@]}"; i++)); do
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
