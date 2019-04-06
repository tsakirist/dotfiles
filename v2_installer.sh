# !/usr/bin/env bash

# This script provides an easy way to install my preferred packages along with my configurations.
# Author: Tsakiris Tryfon
# Version: 2.0
# This version uses local files from github repository.

# -------------------------------------------------------- Font commands -----------------------------------------------
bold=$(tput bold)
start_underline=$(tput smul)
end_underline=$(tput rmul)
black=$(tput setaf 0)
red=$(tput setaf 1)
reset=$(tput sgr0)

# ---------------------------------------------------------- Functions -------------------------------------------------
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
	echo -e "\u2022 Do you want to download/install ${bold}${red}${1//_}${reset} [Y/n] "
	read -n 1 -s input
	if [[ $input =~ ^([yY]) ]]; then
		exec=true
	fi

	if [[ $exec == "true" ]]; then
		$1
	fi
}

function _checkfile() {
	if [ ! -f $1 ]; then
		echo "${bold}${red}ERROR${reset}: Can't find ${1} in this directory. Installer needs all the contents of" \
		"the github repository."
		echo "You should issue the command: > git clone https://github.com/tsakirist/configurations.git"
		exit 1
	fi
}

function _curl() {
	if ! command -v curl > /dev/null 2>&1; then
		echo "Installing ${bold}${red}cURL${reset} ..."
		sudo apt update && sudo apt install -y curl
	fi
}

function _git() {
	if ! command -v git > /dev/null 2>&1; then
		echo "Installing ${bold}${red}git${reset} ..."
		sudo apt update && sudo apt install -y git
	fi
}

function _gitconfig() {
	_checkfile gitconfig
	echo "Setting ${bold}${red}.gitconfig${reset} ..."
	cp -v --backup=numbered gitconfig ~/.gitconfig
}

function _gitsofancy() {
	if ! command -v diff-so-fancy > /dev/null 2>&1; then
		wget -q "https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy"
		chmod +x diff-so-fancy && sudo mv diff-so-fancy /usr/bin/
	fi
}

function _bashaliases() {
	_checkfile bash_aliases
	echo "Setting ${bold}${red}.bash_aliases${reset} ..."
	cp -v --backup=numbered bash_aliases ~/.bash_aliases
}

function _vim() {
	echo "Installing ${bold}${red}vim${reset} ..."
	sudo apt install -y vim vim-gnome
}

function _vimrc() {
	_checkfile vimrc
	echo "Setting ${bold}${red}.vimrc${reset} ..."
    cp -v --backup=numbered vimrc ~/.vimrc
	vim +PlugClean +PlugInstall +qall
}

function _tmux() {
	echo "Installing ${bold}${red}tmux${reset} ..."
	sudo apt update && sudo apt install -y tmux
}

function _tmuxconf() {
	_checkfile tmux.conf
	echo "Setting ${bold}${red}.tmux.conf${reset} ..."
	cp -v --backup=numbered tmux.conf ~/.tmux.conf
}

function _tmuxbashrc() {
	if ! grep -q "exec tmux" ~/.bashrc; then
		_backup ~/.bashrc
		echo "Appending commands (tmux) to ~/.bashrc ..."
		printf "\n%s\n%s\n%s\n\t%s\n%s\n" \
			"# Add this to automatically start tmux with new shell" \
			"tmux attach &> /dev/null" \
			'if [ -z "$TMUX" ]; then' \
			"exec tmux" \
			"fi" >> ~/.bashrc
	fi
}

function _sublimetext() {
	echo "Installing ${bold}${red}Sublime Text 3${reset} ..."
	wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
	echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
	sudo apt update && sudo apt install -y sublime-text
}

function _sublimekeybindings() {
	_checkfile sublime/'Default (Linux).sublime-keymap'
	echo "Setting ${bold}${red}sublime keybindings${reset} ..."
	cp -v --backup=numbered "sublime/Default (Linux).sublime-keymap" "$HOME/.config/sublime-text-3/Packages/User/"
}

function _sublimesettings() {
	_checkfile sublime/Preferences.sublime-settings
	echo "Setting ${bold}${red}sublime settings${reset} ..."
	cp -v --backup=numbered "sublime/Preferences.sublime-settings" "$HOME/.config/sublime-text-3/Packages/User/"
}

function _sublimepackages() {
    _checkfile sublime/Package Control.sublime-settings
    echo "Setting ${bold}${red}sublime packages${reset} ..."
    cp -v --backup=numbered "sublime/Package Control.sublime-settings" "$HOME/.config/sublime-text-3/Packages/User/"
}

function _vscode() {
	echo "Installing ${bold}${red}VSCode${reset} ..."
	curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
	sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/ && rm -f microsoft.gpg
	sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"' > \
        '/etc/apt/sources.list.d/vscode.list'
	sudo apt update && sudo apt install -y code
}

function _googlechrome() {
	ehco "Installing ${bold}${red}Google Chrome${reset} ..."
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	sudo dpkg -i google-chrome-stable_current_amd64.deb
	rm -f google-chrome-stable_current_amd64.deb
	# Remove google chrome keyring pop-up
	sudo sed -i '/^Exec=/s/$/ --password-store=basic %U/' "/usr/share/applications/google-chrome.desktop"
}

function _neofetch() {
	echo "Installing ${bold}${red}neofetch${reset} ..."
	sudo add-apt-repository -y ppa:dawidd0811/neofetch
	sudo apt update && sudo apt install -y neofetch
}

function _xclip() {
	echo "Installing ${bold}${red}xclip${reset} ..."
	sudo apt update && sudo apt install -y xclip
}

function _powerline() {
	echo "Installing ${bold}${red}powerline${reset} ..."
	sudo apt install -y python-pip
	pip install powerline-status
	pip install powerline-gitstatus
	sudo apt install -y fonts-powerline
}

function _powerlinebashrc() {
	if ! grep -q "which powerline-daemon" ~/.bashrc; then
		_backup ~/.bashrc
		echo "Setting ${bold}${red}powerline bashrc${reset} ..."
		printf "\n%s\n%s\n\t%s\n\t%s\n\t%s\n\t%s\n%s\n" \
			"# This is required for powerline to be enabled" \
			"if [ -f \`which powerline-daemon\` ]; then" \
			"powerline-daemon -q" \
			"POWERLINE_BASH_CONTINUATION=1" \
			"POWERLINE_BASH_SELECT=1" \
			'. "${HOME}/.local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh"' \
			"fi" >> ~/.bashrc
	fi
}

function _powerlineconfig() {
	_checkfile powerline_configs/themes/shell/default.json && _checkfile powerline_configs/colorschemes/default.json

	echo "Setting ${bold}${red}themes/shell/default.json${reset} ..."
	cp -v --backup=numbered "powerline_configs/themes/shell/default.json" \
		"$HOME/.local/lib/python2.7/site-packages/powerline/config_files/themes/shell"

	echo "Setting ${bold}${red}colorschemes/default.json${reset} ..."
	cp -v --backup=numbered "powerline_configs/colorschemes/default.json" \
		"$HOME/.local/lib/python2.7/site-packages/powerline/config_files/colorschemes"
}

function _dconfsettings() {
	_checkfile dconf/settings.dconf
	echo "Setting ${bold}${red}dconf_settings${reset} ..."
	dconf load / < dconf/settings.dconf
}

function _preload() {
	echo "Installing ${bold}${red}preload${reset} ..."
	sudo apt update && sudo apt install -y preload
}

function _vmswappiness() {
	echo "Changing ${bold}${red}vm.swappiness${reset} to 10 ..."
	echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf
}

function _showinfo() {
	echo "${bold}${start_underline}This script provides an easy way to install my packages and my configurations." \
    "${end_underline}${reset}"
	echo "Script is executed from: ${bold}$(pwd)${reset}"
}

function _showmenu() {
	echo "What would you like to do?"
	echo "1. ${bold}${red}Fresh${reset} install?"
	echo "2. ${bold}${red}Selectively${reset} install 1-by-1?"
	read -n 1 -s input
}

# ---------------------------------------------------------- Installers ------------------------------------------------------------
function _fresh_install() {
	_curl && _git
	_dconfsettings
	_bashaliases
	_preload
	_vmswappiness
	_xclip
	_neofetch
	_gitconfig && _gitsofancy
	_vim && _vimrc
	_tmux && _tmuxconf && _tmuxbashrc
	_powerline && _powerlineconfig && _powerlinebashrc
	_sublimetext && _sublimekeybindings && _sublimesettings
	_vscode
	_googlechrome
	_reboot
}

function _selective_install_1b1() {
	_curl && _git
	_prompt _dconfsettings
	_prompt _bashaliases
	_prompt _preload
	_prompt _vmswappiness
	_prompt _xclip 
	_prompt _neofetch
	_prompt _gitconfig && _prompt _gitsofancy
	_prompt _vim && _prompt _vimrc
	_prompt _tmux && _prompt _tmuxconf && _prompt _tmuxbashrc
	_prompt _powerline && _prompt _powerlineconfig && _prompt _powerlinebashrc
	_prompt _sublimetext && _prompt _sublimekeybindings && _prompt _sublimesettings
	_prompt _vscode
	_prompt _googlechrome
}

# -------------------------------------------------------------- Main --------------------------------------------------------------
_showinfo
_showmenu

if [[ $input -eq 1 ]]; then
	_fresh_install
elif [[ $input -eq 2 ]]; then
	_selective_install_1b1
else
	echo -e "Wrong input. Available options: [1, 2].\nExiting ..."
	exit
fi
