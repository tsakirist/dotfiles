#!/usr/bin/env bash

echo -e "-- Trying to remove backups created by installer.sh. --\n"

cat << EOF
  _                                                    
 /  |  _   _. ._  o ._   _    |_   _.  _ |      ._   _ 
 \_ | (/_ (_| | | | | | (_|   |_) (_| (_ |< |_| |_) _> 
                         _|                     |      

EOF

rm -i $HOME/.*.~*
rm -i $HOME/.config/nvim/init.vim.~*
rm -i $HOME/.config/nvim/coc-settings.json.~*
