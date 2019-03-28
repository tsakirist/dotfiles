# !/usr/bin/env bash

# This script provides an easy way to install my preferred packages along with my configurations.
# Author: Tsakiris Tryfon
# Date: Wed, 27 Mar 2019 22:55:29 +0200

# ----------------------------------------- Color commands ---------------------------------------------------------
bold=$(tput bold)
black=$(tput setaf 0)
red=$(tput setaf 1)
reset=$(tput sgr0)

# ----------------------------------------- Backup function ---------------------------------------------------------
function backup() {
	if [ -f ~/$1 ]; then
		echo "Backing up ~/$1 file..."
		cp ~/$1 ~/$1.backup
	fi
}

echo "---------------------- Welcome to my configuration installer ----------------------"
echo "1. Do you want to ${bold}${red}fresh${reset} install everything?"
echo "2. Do you want to ${bold}${red}selectively${reset} install everything?"
read input

if [[ $input -eq 1 ]]; then
    echo "TODO automatically call every function"
elif [[ $input -eq 2 ]]; then
    echo "TODO yes or no answer on every option or list options and then according to numbers call functions"
fi
exit

# ----------------------------------------- Check cURL installation -------------------------------------------------
if ! command -v curl > /dev/null 2>&1; then
	echo "Installing ${bold}${red}cURL${reset}..."
	sudo apt update && sudo apt install -y curl
fi

# ----------------------------------------- Check git installation -------------------------------------------------
if ! command -v git > /dev/null 2>&1; then
	echo "Installing ${bold}${red}git${reset}..."
	sudo apt update && sudo apt install -y git
fi

# ----------------------------------------- Package installations ---------------------------------------------------

echo -en "\u2022 Do you want to download ${bold}${red}.gitconfig${reset} file? [Y/n] "
read input

if [[ $input == "Y" ]] || [[ $input == "y" ]]; then
	backup .gitconfig
	echo "Downloading .gitconfig from google drive..."
	curl -sL -o ".gitconfig" "https://drive.google.com/uc?export=download&id=12o89u5IXSbrrkZdhhd4LVJe9RdXEFDzm"
	echo "Moving .gitconfig to root directory '/' ..."
	mv .gitconfig ~/.

	# Install the git diff-so-fancy module if it doesn't exist
	if ! command -v diff-so-fancy > /dev/null 2>&1; then
		wget -q "https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy"
		chmod +x diff-so-fancy && sudo mv diff-so-fancy /usr/bin/
	fi
fi

echo -en "\u2022 Do you want to download ${bold}${red}.bash_aliases${reset} file? [Y/n] "
read input

if [[ $input == "Y" ]] || [[ $input == "y" ]]; then
	backup .bash_aliases
    echo "Downloading .bash_aliases from google drive..."
    curl -L -o ".bash_aliases" "https://drive.google.com/uc?export=download&id=1SRNgX6n_Q3ZfAEUr2shIFjR1cqMM9I8c"
    echo "Moving .bash_aliases to root directory '/' ..."
    mv .bash_aliases ~/.
fi

echo -en "\u2022 Do you want to install ${bold}${red}vim${reset}? [Y/n] "
read input

if [[ $input == "Y" ]] || [[ $input == "y" ]]; then
	sudo apt install -y vim vim-gnome
fi

echo -en "\u2022 Do you want to download ${bold}${red}vim configuration${reset} file? [Y/n] "
read input

if [[ $input == "Y" ]] || [[ $input == "y" ]]; then
	backup .vimrc
	echo "Downloading .vimrc file from google drive..."
	curl -sL -o ".vimrc" "https://drive.google.com/uc?export=download&id=1ghaarm0vqF8clf8kWtZCnW4rxNcs5MtZ"
	echo "Moving .vimrc to root directory '/' ..."
	mv .vimrc ~/.
fi

echo -en "\u2022 Do you want to install ${bold}${red}tmux${reset}? [Y/n] "
read input

if [[ $input == "Y" ]] || [[ $input == "y" ]]; then
	sudo apt update && sudo apt install -y tmux
fi

echo -en "\u2022 Do you want to download ${bold}${red}tmux's configuration${reset} file? [Y/n] "
read input

if [[ $input == "Y" ]] || [[ $input == "y" ]]; then
	backup .tmux.conf
    echo "Downloading tmux configuration file..."
    curl -sL -o ".tmux.conf" "https://drive.google.com/uc?export=download&id=13odIqawxS_3RZqnajTRm0PD6mgAq6M7J"
    echo "Moving tmux config file to root directory '/' ..."
	mv .tmux.conf ~/.
fi

echo -en "\u2022 Do you want to install ${bold}${red}Sublime Text 3${reset}? [Y/n] "
read input

if [[ $input == "Y" ]] || [[ $input == "y" ]]; then
	wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
	echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
	sudo apt update && sudo apt install -y sublime-text
fi

echo -en "\u2022 Do you want to install ${bold}${red}Microsoft Visual Studio Code${reset}? [Y/n] "
read input

if [[ $input == "Y" ]] || [[ $input == "y" ]]; then
	wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
	sudo apt update && sudo apt install -y code
fi

echo -en "\u2022 Do you want to install ${bold}${red}Google Chrome${reset}? [Y/n] "
read input

if [[ $input == "Y" ]] || [[ $input == "y" ]]; then
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	sudo dpkg -i google-chrome-stable_current_amd64.deb
	rm -i google-chrome-stable_current_amd64.deb
fi

echo -en "\u2022 Do you want to install ${bold}${red}Neofetch${reset}? [Y/n] "
read input

if [[ $input == "Y" ]] || [[ $input == "y" ]]; then
	sudo add-apt-repository ppa:dawidd0811/neofetch && sudo apt install -y neofetch
fi

echo -en "\u2022 Do you want to install ${bold}${red}xclip${reset}? [Y/n] "
read input

if [[ $input == "Y" ]] || [[ $input == "y" ]]; then
	sudo apt update && sudo apt install -y xclip
fi

echo -en "\u2022 Do you want to install ${bold}${red}Powerline${reset} for bash? [Y/n] "
read input

if [[ $input == "Y" ]] || [[ $input == "y" ]]; then
	sudo apt install -y python-pip

	pip -q show powerline-status
	if [[ $? -ne 0 ]]; then
		pip install powerline-status
		echo "Downloading themes/shell/default.json from google drive...."
		curl -sL -o "default.json" "https://drive.google.com/uc?export=download&id=1mo9sQwoqe0iHc31maXtB-CWkqencH3KB"
		echo "Moving default.json to ${HOME}/.local/lib/python2.7/site-packages/powerline/config_files/themes/shell"
		mv default.json "${HOME}/.local/lib/python2.7/site-packages/powerline/config_files/themes/shell"
	else
		echo "Powerline-status is already installed..."
	fi

	pip -q show powerline-gitstatus
	if [[ $? -ne 0 ]]; then
		pip install powerline-gitstatus
		echo "Downloading colorschemes/default.json from google drive..."
		curl -sL -o "default.json" "https://drive.google.com/uc?export=download&id=19ASDQ_jIMxfTzSxlpmv51egsCLzhv0Sh"
		echo "Moving default.json to ${HOME}/.local/lib/python2.7/site-packages/powerline/config_files/colorschemes"
		mv default.json "${HOME}/.local/lib/python2.7/site-packages/powerline/config_files/colorschemes"
	else
		echo "Powerline-gitstatus is already installed..."
	fi

	sudo apt install -y fonts-powerline

	# Add the requirements for powerline in .bashrc
	if ! grep -q "which powerline-daemon" ~/.bashrc; then
		backup .bashrc
		printf "\n%s\n%s\n\t%s\n\t%s\n\t%s\n\t%s\n%s\n" \
			"# This is required for powerline to be enabled" \
			"if [ -f \`which powerline-daemon\` ]; then" \
			"powerline-daemon -q" \
			"POWERLINE_BASH_CONTINUATION=1" \
			"POWERLINE_BASH_SELECT=1" \
			'. "${HOME}/.local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh"' \
			"fi" >> ~/.bashrc
	fi
fi

echo -en "${black}\u2022${reset} Do you want to start tmux with every shell? [Y/n] "
read input

if [[ $input == "Y" ]] || [[ $input == "y" ]]; then
	if ! grep -q "exec tmux" ~/.bashrc; then
		backup .bashrc
		echo "Appending commands to ~/.bashrc ..."
		printf "\n%s\n%s\n%s\n\t%s\n%s\n" \
			"# Add this to automatically start tmux with new shell" \
			"tmux attach &> /dev/null" \
			'if [ -z "$TMUX" ]; then' \
			"exec tmux" \
			"fi" >> ~/.bashrc
	fi
fi
