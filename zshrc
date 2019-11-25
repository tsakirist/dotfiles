# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git z)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Source my custom aliases
[ -f ~/.zsh_aliases ] && . ~/.zsh_aliases

# ----------------------------------------------------- Functions -----------------------------------------------------

# NOTE:
# The defined functions below follow the POSIX standard for functions.
# i.e. without using the keyword `function`

# This function returns an approximation of the memory usage of a process
# https://stackoverflow.com/questions/3853655/in-linux-how-to-tell-how-much-memory-processes-are-using
mem () {
    ps -eo rss,pid,euser,args:100 --sort %mem | grep --color=auto -v grep | grep --color=auto -i $@ \
        | awk '{printf $1/1024 " MB"; $1=""; print }'
}

# This function extracts any archive supplied as argument
extract () {
    for archive in $*; do
        if [ -f $archive ] ; then
            case $archive in
                *.tar.bz2)   tar xvjf $archive   ;;
                *.tar.gz)    tar xvzf $archive   ;;
                *.bz2)       bunzip2 $archive    ;;
                *.rar)       rar x $archive      ;;
                *.gz)        gunzip $archive     ;;
                *.tar)       tar xvf $archive    ;;
                *.tbz2)      tar xvjf $archive   ;;
                *.tgz)       tar xvzf $archive   ;;
                *.zip)       unzip $archive      ;;
                *.Z)         uncompress $archive ;;
                *.7z)        7z x $archive       ;;
                *)           echo "Don't know how to extract '$archive' ..." ;;
            esac
        else
            echo "'$archive' is not a valid file!"
        fi
    done
}

# This command serves the contents of the passed directory in an HTTP server at port:8000
serve() {
    if [[ $# -ne 0 ]]; then
        if [ ! -d "$1" ]; then
            echo "ERROR: '$1' is not a valid directory."
            return 1
        fi
        saved_path=$(pwd)
        cd $1
        served_path=$(pwd)
        echo "Serving '$served_path' ..."
        echo "IP: $(hostname -I)"
        python3 -m http.server
        cd $saved_path
    else
        echo "Serving current directory '.'"
        echo "IP: $(hostname -I)"
        python3 -m http.server
    fi
}

# This fixes the permissions on files and directories
perms() {
    if [[ $# -eq 0 ]]; then
        dest=.
    else
        dest=$1
    fi
    find "$dest" -type d | xargs chmod -v 755
    find "$dest" -type f | xargs chmod -v 644
}
