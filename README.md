![dotfiles](https://user-images.githubusercontent.com/20475201/183306482-caa3360c-d357-4525-b429-a468fb932502.png)

<h2 align="center">Description</h2>

This repository holds all the necessary files needed to install my configurations
and settings on a new Linux based distribution.

### Instructions

* Clone the repository and enter the directory
* Give executable rights to the installer if needed with `chmod +x installer.sh`
* Start the installer `./installer.sh`

<h2 align="center">Neovim</h2>

![Neovim setup](https://user-images.githubusercontent.com/20475201/183304528-10251a43-183a-4181-a08d-cf9d311f2ac8.png)
![Neovim telescope](https://user-images.githubusercontent.com/20475201/183304535-d2516144-4abe-4920-84fe-e3039c295291.png)

The configuration files will be installed to the default configuration directory
of **neovim**, located at: `${HOME}/.config/nvim`

<h3 align="center">Directory Structure</h3>

```bash
./
├── lua/
│   └── tt/
│       ├── _plugins/
│       │   ├── git/
│       │   │   ├── diffview.lua
│       │   │   ├── git-conflict.lua
│       │   │   ├── gitlinker.lua
│       │   │   ├── git-messenger.lua
│       │   │   └── gitsigns.lua
│       │   ├── lsp/
│       │   │   ├── config/
│       │   │   │   ├── format.lua
│       │   │   │   ├── handlers.lua
│       │   │   │   ├── highlight.lua
│       │   │   │   ├── init.lua
│       │   │   │   ├── keymaps.lua
│       │   │   │   ├── servers.lua
│       │   │   │   └── symbols.lua
│       │   │   ├── goto-preview.lua
│       │   │   ├── inlay-hints.lua
│       │   │   ├── lsp-signature.lua
│       │   │   ├── mason.lua
│       │   │   ├── null-ls.lua
│       │   │   └── nvim-navic.lua
│       │   ├── telescope/
│       │   │   ├── commands.lua
│       │   │   ├── extensions.lua
│       │   │   ├── init.lua
│       │   │   ├── keymappings.lua
│       │   │   └── pickers.lua
│       │   ├── barbecue.lua
│       │   ├── bufferline.lua
│       │   ├── comment.lua
│       │   ├── cybu.lua
│       │   ├── dressing.lua
│       │   ├── hydra.lua
│       │   ├── indent-blankline.lua
│       │   ├── mini-indentscope.lua
│       │   ├── neogen.lua
│       │   ├── neo-tree.lua
│       │   ├── nightfox.lua
│       │   ├── notify.lua
│       │   ├── numb.lua
│       │   ├── nvim-autopairs.lua
│       │   ├── nvim-cmp.lua
│       │   ├── nvim-surround.lua
│       │   ├── spectre.lua
│       │   ├── startify.lua
│       │   ├── syntax-tree-surfer.lua
│       │   ├── toggleterm.lua
│       │   ├── treesitter.lua
│       │   ├── treesj.lua
│       │   ├── trouble.lua
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
│       ├── lazy.lua
│       ├── mappings.lua
│       ├── plugins.lua
│       ├── settings.lua
│       └── utils.lua
├── init.lua
└── lazy-lock.json
```

<h2 align="center">Installer</h2>

The installer is a text-based user-interface (TUI) made with
[`whiptail`](https://linux.die.net/man/1/whiptail) in bash.
It allows for easy installation of the commonly used packages/binaries that I
use in my setup.

| Installer intro screen  | Installer selective installation |
|:-----------------------:|:--------------------------------:|
| ![Installer intro screen](https://user-images.githubusercontent.com/20475201/183304609-1e02a470-c541-4d6c-97ff-f5f99b64327d.png) | ![Installer selective installation](https://user-images.githubusercontent.com/20475201/183304610-a45c9482-c59b-4513-89fe-ce51ddc0c6f7.png) |
