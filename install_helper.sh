# !/usr/bin/env bash

# This script provides an easy way to install my preferred packages along with my configurations.
# Author: Tsakiris Tryfon
# Date: Fri, 29 Mar 2019 11:31:29 +0200

# -------------------------------------------------------- Color commands ---------------------------------------------------------
bold=$(tput bold)
start_underline=$(tput smul)
end_underline=$(tput rmul)
black=$(tput setaf 0)
red=$(tput setaf 1)
reset=$(tput sgr0)

# ---------------------------------------------------------- Functions -------------------------------------------------------------
function backup() {
	if [ -f ~/$1 ]; then
		echo "Backing up ~/$1 file..."
		cp ~/$1 ~/$1.backup
	fi
}

function _reboot() {
	echo "It is recommended to ${bold}${red}reboot${reset} after a fresh install of the packages and configurations."
	read -n 1 -r -p "Would you like to reboot? [Y/n] " input
	if [[ $input =~ ^([yY]) ]]; then
		sudo reboot
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
	backup .gitconfig
	echo "Downloading .gitconfig from google drive..."
	curl -sL -o ".gitconfig" "https://drive.google.com/uc?export=download&id=12o89u5IXSbrrkZdhhd4LVJe9RdXEFDzm"
	echo "Moving .gitconfig to root directory '/' ..."
	mv .gitconfig ~/.
}

function _gitsofancy() {
	if ! command -v diff-so-fancy > /dev/null 2>&1; then
		wget -q "https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy"
		chmod +x diff-so-fancy && sudo mv diff-so-fancy /usr/bin/
	fi
}

function _bashaliases() {
	backup .bash_aliases
    echo "Downloading .bash_aliases from google drive..."
    curl -L -o ".bash_aliases" "https://drive.google.com/uc?export=download&id=1SRNgX6n_Q3ZfAEUr2shIFjR1cqMM9I8c"
    echo "Moving .bash_aliases to root directory '/' ..."
    mv .bash_aliases ~/.
}

function _vim() {
	echo "Installing ${bold}${red}vim${reset}..."
	sudo apt install -y vim vim-gnome
}

function _vimrc() {
	backup .vimrc
	echo "Downloading .vimrc file from google drive..."
	curl -sL -o ".vimrc" "https://drive.google.com/uc?export=download&id=1ghaarm0vqF8clf8kWtZCnW4rxNcs5MtZ"
	echo "Moving .vimrc to root directory '/' ..."
	mv .vimrc ~/.

	# After downloading the .vimrc force install of plugins
	vim +PlugClean +PlugInstall +qall
}

function _tmux() {
	echo "Installing ${bold}${red}tmux${reset}..."
	sudo apt update && sudo apt install -y tmux
}

function _tmuxconf() {
	backup .tmux.conf
    echo "Downloading tmux configuration file..."
    curl -sL -o ".tmux.conf" "https://drive.google.com/uc?export=download&id=13odIqawxS_3RZqnajTRm0PD6mgAq6M7J"
    echo "Moving tmux config file to root directory '/' ..."
	mv .tmux.conf ~/.
}

# This function adds commands in the .bashrc to start tmux whenever a new bash is started
function _tmuxbashrc() {
	if ! grep -q "exec tmux" ~/.bashrc; then
		backup .bashrc
		echo "Appending commands(tmux) to ~/.bashrc ..."
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

function _vscode() {
	echo "Installing ${bold}${red}VSCode${reset}..."
	wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
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
		backup .bashrc
		echo "Setting ${bold}${red}powerline bashrc${reset}..."
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
	echo "Downloading themes/shell/default.json from google drive...."
	curl -sL -o "default.json" "https://drive.google.com/uc?export=download&id=1mo9sQwoqe0iHc31maXtB-CWkqencH3KB"
	echo "Moving default.json to ${HOME}/.local/lib/python2.7/site-packages/powerline/config_files/themes/shell"
	mv default.json "${HOME}/.local/lib/python2.7/site-packages/powerline/config_files/themes/shell"

	echo "Downloading colorschemes/default.json from google drive..."
	curl -sL -o "default.json" "https://drive.google.com/uc?export=download&id=19ASDQ_jIMxfTzSxlpmv51egsCLzhv0Sh"
	echo "Moving default.json to ${HOME}/.local/lib/python2.7/site-packages/powerline/config_files/colorschemes"
	mv default.json "${HOME}/.local/lib/python2.7/site-packages/powerline/config_files/colorschemes"
}

function _dconfsettings() {
	echo "Setting ${bold}${red}dconf${reset} settings..."
	curl -sL -o "settings.dconf" "https://drive.google.com/uc?export=download&id=19QoPT0f5-7IgI5ojYCNmU3vVTrrbmM8h"
	dconf load / < settings.dconf
}

function _preload() {
	echo "Installing ${bold}${red}preload${reset}..."
	sudo apt update && sudo apt install -y preload
}

function _vmswappiness() {
	echo "Changing ${bold}${red}vm.swappiness${reset} to 10..."
	echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf
}

# This function is used to install all my packages and configurations
function _fresh_install() {
	_curl
	_dconfsettings
	_bashaliases
	_preload
	_vmswappiness
	_xclip
	_neofetch
	_git ;_gitconfig ; _gitsofancy
	_vim ;_vimrc
	_tmux ; _tmuxconf ; _tmuxbashrc
	_powerline ; _powerlineconfig ; _powerlinebashrc
	_sublimetext
	_vscode
	_googlechrome
	_reboot
}

# This function is used to selectively install packages and configurations
# function _selective_install() {
# }

# -------------------------------------------------------- Installer menu ---------------------------------------------------------

echo "${bold}${start_underline}This script provides an easy way to install my packages and my configurations.${end_underline}${reset}"
echo "What would you like to do?"
echo "1. ${bold}${red}Fresh${reset} install everything?"
echo "2. ${bold}${red}Selectively${reset} install everything?"
read -s input

if [[ $input -eq 1 ]]; then
	_fresh_install
elif [[ $input -eq 2 ]]; then
	_selective_install
else
	echo -e "Wrong input. Available options: [1, 2].\nExiting..."
	exit
fi

# # ----------------------------------------- Package installations ---------------------------------------------------

# echo -en "\u2022 Do you want to download ${bold}${red}.gitconfig${reset} file? [Y/n] "
# read input

# if [[ $input == "Y" ]] || [[ $input == "y" ]]; then
# 	backup .gitconfig
# 	echo "Downloading .gitconfig from google drive..."
# 	curl -sL -o ".gitconfig" "https://drive.google.com/uc?export=download&id=12o89u5IXSbrrkZdhhd4LVJe9RdXEFDzm"
# 	echo "Moving .gitconfig to root directory '/' ..."
# 	mv .gitconfig ~/.

# 	# Install the git diff-so-fancy module if it doesn't exist
# 	if ! command -v diff-so-fancy > /dev/null 2>&1; then
# 		wget -q "https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy"
# 		chmod +x diff-so-fancy && sudo mv diff-so-fancy /usr/bin/
# 	fi
# fi

# echo -en "\u2022 Do you want to download ${bold}${red}.bash_aliases${reset} file? [Y/n] "
# read input

# if [[ $input == "Y" ]] || [[ $input == "y" ]]; then
# 	backup .bash_aliases
#     echo "Downloading .bash_aliases from google drive..."
#     curl -L -o ".bash_aliases" "https://drive.google.com/uc?export=download&id=1SRNgX6n_Q3ZfAEUr2shIFjR1cqMM9I8c"
#     echo "Moving .bash_aliases to root directory '/' ..."
#     mv .bash_aliases ~/.
# fi

# echo -en "\u2022 Do you want to install ${bold}${red}vim${reset}? [Y/n] "
# read input

# if [[ $input == "Y" ]] || [[ $input == "y" ]]; then
# 	sudo apt install -y vim vim-gnome
# fi

# echo -en "\u2022 Do you want to download ${bold}${red}vim configuration${reset} file? [Y/n] "
# read input

# if [[ $input == "Y" ]] || [[ $input == "y" ]]; then
# 	backup .vimrc
# 	echo "Downloading .vimrc file from google drive..."
# 	curl -sL -o ".vimrc" "https://drive.google.com/uc?export=download&id=1ghaarm0vqF8clf8kWtZCnW4rxNcs5MtZ"
# 	echo "Moving .vimrc to root directory '/' ..."
# 	mv .vimrc ~/.
# fi

# echo -en "\u2022 Do you want to install ${bold}${red}tmux${reset}? [Y/n] "
# read input

# if [[ $input == "Y" ]] || [[ $input == "y" ]]; then
# 	sudo apt update && sudo apt install -y tmux
# fi

# echo -en "\u2022 Do you want to download ${bold}${red}tmux's configuration${reset} file? [Y/n] "
# read input

# if [[ $input == "Y" ]] || [[ $input == "y" ]]; then
# 	backup .tmux.conf
#     echo "Downloading tmux configuration file..."
#     curl -sL -o ".tmux.conf" "https://drive.google.com/uc?export=download&id=13odIqawxS_3RZqnajTRm0PD6mgAq6M7J"
#     echo "Moving tmux config file to root directory '/' ..."
# 	mv .tmux.conf ~/.
# fi

# echo -en "\u2022 Do you want to install ${bold}${red}Sublime Text 3${reset}? [Y/n] "
# read input

# if [[ $input == "Y" ]] || [[ $input == "y" ]]; then
# 	wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
# 	echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
# 	sudo apt update && sudo apt install -y sublime-text
# fi

# echo -en "\u2022 Do you want to install ${bold}${red}Microsoft Visual Studio Code${reset}? [Y/n] "
# read input

# if [[ $input == "Y" ]] || [[ $input == "y" ]]; then
# 	wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
# 	sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
# 	sudo apt update && sudo apt install -y code
# fi

# echo -en "\u2022 Do you want to install ${bold}${red}Google Chrome${reset}? [Y/n] "
# read input

# if [[ $input == "Y" ]] || [[ $input == "y" ]]; then
# 	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
# 	sudo dpkg -i google-chrome-stable_current_amd64.deb
# 	rm -i google-chrome-stable_current_amd64.deb
# fi

# echo -en "\u2022 Do you want to install ${bold}${red}Neofetch${reset}? [Y/n] "
# read input

# if [[ $input == "Y" ]] || [[ $input == "y" ]]; then
# 	sudo add-apt-repository ppa:dawidd0811/neofetch && sudo apt install -y neofetch
# fi

# echo -en "\u2022 Do you want to install ${bold}${red}xclip${reset}? [Y/n] "
# read input

# if [[ $input == "Y" ]] || [[ $input == "y" ]]; then
# 	sudo apt update && sudo apt install -y xclip
# fi

# echo -en "\u2022 Do you want to install ${bold}${red}Powerline${reset} for bash? [Y/n] "
# read input

# if [[ $input == "Y" ]] || [[ $input == "y" ]]; then
# 	sudo apt install -y python-pip

# 	pip -q show powerline-status
# 	if [[ $? -ne 0 ]]; then
# 		pip install powerline-status
# 		echo "Downloading themes/shell/default.json from google drive...."
# 		curl -sL -o "default.json" "https://drive.google.com/uc?export=download&id=1mo9sQwoqe0iHc31maXtB-CWkqencH3KB"
# 		echo "Moving default.json to ${HOME}/.local/lib/python2.7/site-packages/powerline/config_files/themes/shell"
# 		mv default.json "${HOME}/.local/lib/python2.7/site-packages/powerline/config_files/themes/shell"
# 	else
# 		echo "Powerline-status is already installed..."
# 	fi

# 	pip -q show powerline-gitstatus
# 	if [[ $? -ne 0 ]]; then
# 		pip install powerline-gitstatus
# 		echo "Downloading colorschemes/default.json from google drive..."
# 		curl -sL -o "default.json" "https://drive.google.com/uc?export=download&id=19ASDQ_jIMxfTzSxlpmv51egsCLzhv0Sh"
# 		echo "Moving default.json to ${HOME}/.local/lib/python2.7/site-packages/powerline/config_files/colorschemes"
# 		mv default.json "${HOME}/.local/lib/python2.7/site-packages/powerline/config_files/colorschemes"
# 	else
# 		echo "Powerline-gitstatus is already installed..."
# 	fi

# 	sudo apt install -y fonts-powerline

# 	# Add the requirements for powerline in .bashrc
# 	if ! grep -q "which powerline-daemon" ~/.bashrc; then
# 		backup .bashrc
# 		printf "\n%s\n%s\n\t%s\n\t%s\n\t%s\n\t%s\n%s\n" \
# 			"# This is required for powerline to be enabled" \
# 			"if [ -f \`which powerline-daemon\` ]; then" \
# 			"powerline-daemon -q" \
# 			"POWERLINE_BASH_CONTINUATION=1" \
# 			"POWERLINE_BASH_SELECT=1" \
# 			'. "${HOME}/.local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh"' \
# 			"fi" >> ~/.bashrc
# 	fi
# fi

# echo -en "${black}\u2022${reset} Do you want to start tmux with every shell? [Y/n] "
# read input

# if [[ $input == "Y" ]] || [[ $input == "y" ]]; then
# 	if ! grep -q "exec tmux" ~/.bashrc; then
# 		backup .bashrc
# 		echo "Appending commands to ~/.bashrc ..."
# 		printf "\n%s\n%s\n%s\n\t%s\n%s\n" \
# 			"# Add this to automatically start tmux with new shell" \
# 			"tmux attach &> /dev/null" \
# 			'if [ -z "$TMUX" ]; then' \
# 			"exec tmux" \
# 			"fi" >> ~/.bashrc
# 	fi
# fi
