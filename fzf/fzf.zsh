# Set up fzf key bindings and fuzzy completion.
# Also make sure that timestamps are included according to HIST_STAMPS.
source <(fzf --zsh | sed -e '/zmodload/s/perl/perl_off/' -e '/selected/s/fc -rl/fc -rlt "$HIST_STAMPS"/')
