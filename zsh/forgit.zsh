# Don't set default aliases
export FORGIT_NO_ALIASES=1

# Forgit custom aliases
alias fadd='forgit::add'
alias fbd='forgit::branch::delete'
alias fblame='forgit::blame'
alias fcb='forgit::checkout::branch'
alias fcc='forgit::checkout::commit'
alias fcf='forgit::checkout::file'
alias fclean='forgit::clean'
alias fcp='forgit::cherry::pick::from::branch'
alias fct='forgit::checkout::tag'
alias fdiff='forgit::diff'
alias ffixup='forgit::fixup'
alias fignore='forgit::ignore'
alias flog='forgit::log'
alias frebase='forgit::rebase'
alias freset='forgit::reset::head'
alias frevert='forgit::revert::commit'
alias fstash='forgit::stash::show'

# Forgit custom copy command
export FORGIT_COPY_CMD='xclip -selection clipboard'

# Forgit fzf custom settings
export FORGIT_FZF_DEFAULT_OPTS="
    --ansi
    --bind='?:toggle-preview'
    --bind='ctrl-a:toggle-all'
    --bind='ctrl-s:toggle-sort'
    --bind='alt-w:toggle-preview-wrap'
    --bind='ctrl-u:preview-page-up'
    --bind='ctrl-d:preview-page-down'
    --height='80%'
    --tabstop=4
    --multi
    --layout=reverse
    --border
    --cycle
    --preview-window='right:60%:nohidden:wrap'
    --preview='bat --style=full --color=always {}'
"
