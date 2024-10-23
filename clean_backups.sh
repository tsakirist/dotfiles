#!/usr/bin/env bash

# Do not show any error messages on screen

echo -e "-- Trying to remove backups created by installer.sh. --\n"

cat << EOF
  _
 /  |  _   _. ._  o ._   _    |_   _.  _ |      ._   _
 \_ | (/_ (_| | | | | | (_|   |_) (_| (_ |< |_| |_) _>
                         _|                     |

EOF

RM_OPT="-i"

while [ -n "$1" ]; do
    case "$1" in
        -f | --force)
            RM_OPT="-f"
            ;;
    esac
    shift
done

rm $RM_OPT "$HOME"/.*.~*
rm $RM_OPT "$HOME"/*.toml.~*
rm $RM_OPT "$HOME"/.config/kitty/kitty.conf.~*
rm $RM_OPT "$HOME"/.config/wezterm/wezterm*.lua.~*
