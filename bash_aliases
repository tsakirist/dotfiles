alias ls='ls --color -h --group-directories-first'
alias lf='ls | grep'
alias llf='ls -l | grep'
alias ll='ls -l'
alias la='ls -a'
alias laf='ls -a | grep'
alias l1='ls -1'
alias la1='ls -a1'
alias li='ls -i'
alias hf='history | grep'
alias h='history'
alias fstat='stat --format "%a"'
alias pf='ps aux | grep'
alias lsize='du -sh *'
alias lsizesort='du -sh * | sort -hr'
alias showkernels='dpkg --list | grep linux-image'

# This is to change launcher position
alias lpos='gsettings set com.canonical.Unity.Launcher launcher-position'

# This is for OpenVPN
alias vpn='sh $HOME/Documents/OpenVPN_UTH_Config/start.sh'

# This is for neofetch
alias neo='neofetch'

# This is to check bootup services
alias blame='systemd-analyze blame'
alias blameh='systemd-analyze blame | head'
alias blamecritical='systemd-analyze critical-chain'

# This is for xclip to properly copy to clipboard
alias xclip='xclip -selection clipboard'

# This is to prompt before every removal with 'rm'
alias rm='rm -i'
