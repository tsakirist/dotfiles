# !/usr/bin/env bash

# This script provides an easy way to install my preferred packages along with my configurations.
# Author: Tsakiris Tryfon

# -------------------------------------------------------- Font commands ----------------------------------------------------------
bold=$(tput bold)
start_underline=$(tput smul)
end_underline=$(tput rmul)
black=$(tput setaf 0)
red=$(tput setaf 1)
reset=$(tput sgr0)

# ---------------------------------------------------------- Functions -------------------------------------------------------------
function _root_check() {
	if [[ "$HOME" == $(pwd) ]]; then
		ROOT_DIR=true
	else
		ROOT_DIR=false
	fi
}

function _movetoroot() {
	if [[ $ROOT_DIR == "false" ]]; then
        echo "Moving $1 to '~/' directory"
		mv $1 ~/$1 -v --backup=numbered
	fi
}

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

function _curl() {
	if ! command -v curl > /dev/null 2>&1; then
		echo "Installing ${bold}${red}cURL${reset}..."
		sudo apt update && sudo apt install -y curl
	fi
}

function _git() {
	if ! command -v git > /dev/null 2>&1; then
		echo "Installing ${bold}${red}git${reset}..."
		sudo apt update && sudo apt install -y git
	fi
}

function _gitconfig() {
	echo "Downloading ${bold}${red}.gitconfig${reset} from google drive..."
	curl -sL -o ".gitconfig" "https://drive.google.com/uc?export=download&id=12o89u5IXSbrrkZdhhd4LVJe9RdXEFDzm"
	_movetoroot .gitconfig
}

function _gitsofancy() {
	if ! command -v diff-so-fancy > /dev/null 2>&1; then
		wget -q "https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy"
		chmod +x diff-so-fancy && sudo mv diff-so-fancy /usr/bin/
	fi
}

function _bashaliases() {
	echo "Downloading ${bold}${red}.bash_aliases${reset} from google drive..."
	curl -sL -o ".bash_aliases" "https://drive.google.com/uc?export=download&id=1SRNgX6n_Q3ZfAEUr2shIFjR1cqMM9I8c"
	_movetoroot .bash_aliases
}

function _vim() {
	echo "Installing ${bold}${red}vim${reset}..."
	sudo apt install -y vim vim-gnome
}

function _vimrc() {
	echo "Downloading ${bold}${red}.vimrc${reset} file from google drive..."
	curl -sL -o ".vimrc" "https://drive.google.com/uc?export=download&id=1ghaarm0vqF8clf8kWtZCnW4rxNcs5MtZ"
    _movetoroot .vimrc
    # After downloading the .vimrc force install of plugins
	vim +PlugClean +PlugInstall +qall
}

function _tmux() {
	echo "Installing ${bold}${red}tmux${reset}..."
	sudo apt update && sudo apt install -y tmux
}

function _tmuxconf() {
	echo "Downloading ${bold}${red}tmux${reset} configuration file..."
	curl -sL -o ".tmux.conf" "https://drive.google.com/uc?export=download&id=13odIqawxS_3RZqnajTRm0PD6mgAq6M7J"
	_movetoroot .tmux.conf
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
	echo "Installing ${bold}${red}Sublime Text 3${reset}..."
	wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
	echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
	sudo apt update && sudo apt install -y sublime-text
}

function _sublimekeybindings() {
	echo "Downloading ${bold}${red}Sublime keybindings${reset}..."
	curl -sL -o "Default (Linux).sublime-keymap" "https://drive.google.com/uc?export=download&id=1lSWPKl_QWBzH2X5ZLgv1bgOV2eka4rL-"
    mv -v "Default (Linux).sublime-keymap" $HOME/.config/sublime-text-3/Packages/User
}

function _vscode() {
	echo "Installing ${bold}${red}VSCode${reset}..."
	curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
	sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/ && rm -f microsoft.gpg
	sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
	sudo apt update && sudo apt install -y code
}

function _googlechrome() {
	ehco "Installing ${bold}${red}Google Chrome${reset}..."
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	sudo dpkg -i google-chrome-stable_current_amd64.deb
	rm -f google-chrome-stable_current_amd64.deb
	# Remove google chrome keyring pop-up
	sudo sed -i '/^Exec=/s/$/ --password-store=basic %U/' /usr/share/applications/google-chrome.desktop
}

function _neofetch() {
	echo "Installing ${bold}${red}neofetch${reset}..."
	sudo add-apt-repository -y ppa:dawidd0811/neofetch
	sudo apt update && sudo apt install -y neofetch
}

function _xclip() {
	echo "Installing ${bold}${red}xclip${reset}..."
	sudo apt update && sudo apt install -y xclip
}

function _powerline() {
	echo "Installing ${bold}${red}powerline${reset}..."
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
	echo "Downloading ${bold}${red}themes/shell/default.json${reset} from google drive..."
	curl -sL -o "default.json" "https://drive.google.com/uc?export=download&id=1mo9sQwoqe0iHc31maXtB-CWkqencH3KB"
	echo "Moving default.json to ${HOME}/.local/lib/python2.7/site-packages/powerline/config_files/themes/shell"
	mv default.json "${HOME}/.local/lib/python2.7/site-packages/powerline/config_files/themes/shell" -v --backup=numbered

	echo "Downloading ${bold}${red}colorschemes/default.json${reset} from google drive..."
	curl -sL -o "default.json" "https://drive.google.com/uc?export=download&id=19ASDQ_jIMxfTzSxlpmv51egsCLzhv0Sh"
	echo "Moving default.json to ${HOME}/.local/lib/python2.7/site-packages/powerline/config_files/colorschemes"
	mv default.json "${HOME}/.local/lib/python2.7/site-packages/powerline/config_files/colorschemes" -v --backup=numbered
}

function _dconfsettings() {
	echo "Setting ${bold}${red}dconf${reset} settings..."
	curl -sL -o "settings.dconf" "https://drive.google.com/uc?export=download&id=1rtyDSK7QNDag3B2AI1DIWCBekg7Jqppo"
	dconf load / < settings.dconf
	rm -f settings.dconf
}

function _preload() {
	echo "Installing ${bold}${red}preload${reset}..."
	sudo apt update && sudo apt install -y preload
}

function _vmswappiness() {
	echo "Changing ${bold}${red}vm.swappiness${reset} to 10..."
	echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf
}

function _showinfo() {
	echo "${bold}${start_underline}This script provides an easy way to install my packages and my configurations.${end_underline}${reset}"
	echo "Script is executed from: ${bold}$(pwd)${reset}"
}

function _showmenu() {
	echo "What would you like to do?"
	echo "1. ${bold}${red}Fresh${reset} install?"
	echo "2. ${bold}${red}Selectively${reset} install?"
	read -n 1 -s input
}

# ---------------------------------------------------------- Installers ------------------------------------------------------------
function _fresh_install() {
	_curl &&
	(
		_dconfsettings
		_bashaliases
		_preload
		_vmswappiness
		_xclip
		_neofetch
		_git && _gitconfig && _gitsofancy
		_vim && _vimrc
		_tmux && _tmuxconf && _tmuxbashrc
		_powerline && _powerlineconfig && _powerlinebashrc
		_sublimetext && _sublimekeybindings
		_vscode
		_googlechrome
		_reboot
	)
}

function _selective_install() {
	_curl &&
	(
		_prompt _dconfsettings
		_prompt _bashaliases
		_prompt _preload
		_prompt _vmswappiness
		_prompt _xclip 
		_prompt _neofetch
		_prompt _git && _prompt _gitconfig && _prompt _gitsofancy
		_prompt _vim && _prompt _vimrc
		_prompt _tmux && _prompt _tmuxconf && _prompt _tmuxbashrc
		_prompt _powerline && _prompt _powerlineconfig && _prompt _powerlinebashrc
		_prompt _sublimetext && _prompt _sublimekeybindings
		_prompt _vscode
		_prompt _googlechrome
	)
}

# -------------------------------------------------------------- Main --------------------------------------------------------------
_root_check
_showinfo
_showmenu

if [[ $input -eq 1 ]]; then
	_fresh_install
elif [[ $input -eq 2 ]]; then
	_selective_install
else
	echo -e "Wrong input. Available options: [1, 2].\nExiting..."
	exit
fi
