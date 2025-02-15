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

<br/>

<details>
  <summary>
    Click to toggle directory structure view.
  </summary>

```bash
./
├── lua/
│   └── tt/
│       ├── _plugins/
│       │   ├── format/
│       │   │   ├── conform.lua
│       │   │   └── utils.lua
│       │   ├── git/
│       │   │   ├── diffview.lua
│       │   │   ├── git-conflict.lua
│       │   │   ├── git-messenger.lua
│       │   │   └── gitsigns.lua
│       │   ├── lsp/
│       │   │   ├── config/
│       │   │   │   ├── attach.lua
│       │   │   │   ├── handlers.lua
│       │   │   │   ├── highlight.lua
│       │   │   │   ├── init.lua
│       │   │   │   ├── inlay_hints.lua
│       │   │   │   ├── keymaps.lua
│       │   │   │   └── servers.lua
│       │   │   ├── lsp-saga.lua
│       │   │   ├── mason.lua
│       │   │   └── nvim-navic.lua
│       │   ├── snacks/
│       │   │   ├── commands.lua
│       │   │   ├── custom_pickers.lua
│       │   │   ├── dashboard.lua
│       │   │   ├── init.lua
│       │   │   ├── keymaps.lua
│       │   │   ├── picker.lua
│       │   │   ├── scratch.lua
│       │   │   ├── styles.lua
│       │   │   └── zen.lua
│       │   ├── telescope/
│       │   │   ├── commands.lua
│       │   │   ├── extensions.lua
│       │   │   ├── init.lua
│       │   │   ├── keymaps.lua
│       │   │   ├── pickers.lua
│       │   │   ├── previewers.lua
│       │   │   └── utils.lua
│       │   ├── barbecue.lua
│       │   ├── comment.lua
│       │   ├── dial.lua
│       │   ├── dressing.lua
│       │   ├── flash.lua
│       │   ├── grapple.lua
│       │   ├── grug-far.lua
│       │   ├── hydra.lua
│       │   ├── indent-blankline.lua
│       │   ├── lualine.lua
│       │   ├── mini-surround.lua
│       │   ├── neogen.lua
│       │   ├── nightfox.lua
│       │   ├── noice.lua
│       │   ├── numb.lua
│       │   ├── nvim-autopairs.lua
│       │   ├── nvim-cmp.lua
│       │   ├── nvim-ufo.lua
│       │   ├── oil.lua
│       │   ├── resession.lua
│       │   ├── rose-pine.lua
│       │   ├── smart-splits.lua
│       │   ├── statuscol.lua
│       │   ├── treesitter.lua
│       │   ├── treesj.lua
│       │   └── trouble.lua
│       ├── utils/
│       │   ├── init.lua
│       │   └── set.lua
│       ├── abbreviations.lua
│       ├── autocommands.lua
│       ├── common.lua
│       ├── globals.lua
│       ├── helper.lua
│       ├── icons.lua
│       ├── init.lua
│       ├── lazy.lua
│       ├── mappings.lua
│       ├── plugins.lua
│       └── settings.lua
├── init.lua
└── lazy-lock.json
```

</details>

<h2 align="center">Installer</h2>

The installer is a text-based user-interface (TUI) made with
[`whiptail`](https://linux.die.net/man/1/whiptail) in bash.
It allows for easy installation of the commonly used packages/binaries that I
use in my setup.

| Installer intro screen  | Installer selective installation |
|:-----------------------:|:--------------------------------:|
| ![Installer intro screen](https://user-images.githubusercontent.com/20475201/183304609-1e02a470-c541-4d6c-97ff-f5f99b64327d.png) | ![Installer selective installation](https://user-images.githubusercontent.com/20475201/183304610-a45c9482-c59b-4513-89fe-ce51ddc0c6f7.png) |
