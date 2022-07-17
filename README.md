# dotfiles

## Description

This repository holds all the necessary files needed to install my configurations and settings on a new Linux based
distribution.

There are currently two branches:

* **master** : Ubuntu  -- Debian based with Gnome desktop environment
* **manjaro**: Manjaro -- Arch based with Gnome desktop environment (@deprecated)

### Instructions

* Clone the repository and enter the directory
* Give executable rights to the installer if needed with `chmod +x installer.sh`
* Start the installer `./installer.sh`

## Neovim

The configuration files will be installed to the default configuration directory of **neovim**, located at:
`${HOME}/.config/nvim`

### Directory Structure

```bash
./
├── lua/
│   └── tt/
│       ├── plugins/
│       │   ├── git/
│       │   │   ├── diffview.lua
│       │   │   ├── gitlinker.lua
│       │   │   ├── git-messenger.lua
│       │   │   └── gitsigns.lua
│       │   ├── lsp/
│       │   │   ├── goto-preview.lua
│       │   │   ├── lsp-signature.lua
│       │   │   ├── null-ls.lua
│       │   │   ├── nvim-lspconfig.lua
│       │   │   ├── nvim-lsp-installer.lua
│       │   │   └── vista.lua
│       │   ├── bufferline.lua
│       │   ├── comment.lua
│       │   ├── git-conflict.lua
│       │   ├── indent-blankline.lua
│       │   ├── neogen.lua
│       │   ├── neo-tree.lua
│       │   ├── nightfox.lua
│       │   ├── notify.lua
│       │   ├── numb.lua
│       │   ├── nvim-autopairs.lua
│       │   ├── nvim-cmp.lua
│       │   ├── nvim-gps.lua
│       │   ├── nvim-surround.lua
│       │   ├── packer.lua
│       │   ├── startify.lua
│       │   ├── syntax-tree-surfer.lua
│       │   ├── telescope.lua
│       │   ├── toggleterm.lua
│       │   ├── treesitter.lua
│       │   ├── trouble.lua
│       │   ├── venn.lua
│       │   └── zen-mode.lua
│       ├── themes/
│       │   ├── evil_lualine.lua
│       │   └── lualine.lua
│       ├── abbreviations.lua
│       ├── autocommands.lua
│       ├── globals.lua
│       ├── helper.lua
│       ├── icons.lua
│       ├── init.lua
│       ├── mappings.lua
│       ├── plugins.lua
│       ├── settings.lua
│       └── utils.lua
└── init.lua
```
