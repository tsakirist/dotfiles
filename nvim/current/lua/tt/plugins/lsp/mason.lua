local M = {}

function M.setup()
    local icons = require "tt.icons"
    local utils = require "tt.utils"

    require("mason").setup {
        ui = {
            -- Whether to automatically check for new versions when opening the :Mason window.
            check_outdated_packages_on_open = false,

            -- The border to use for the UI window. Accepts same border values as |nvim_open_win()|
            border = "none",

            icons = {
                -- The list icon to use for installed packages
                package_installed = icons.misc.CheckMark,

                -- The list icon to use for packages that are installing, or queued for installation
                package_pending = icons.misc.ArrowRight,

                -- The list icon to use for packages that are not installed
                package_uninstalled = icons.misc.XMark,
            },

            keymaps = {
                -- Keymap to expand a package
                toggle_package_expand = "<CR>",

                -- Keymap to install the package under the current cursor position
                install_package = "i",

                -- Keymap to uninstall a package
                uninstall_package = "d",

                -- Keymap to reinstall/update the package under the current cursor position
                update_package = "u",

                -- Keymap to check for new version for the package under the current cursor position
                check_package_version = "c",

                -- Keymap to update all installed packages
                update_all_packages = "U",

                -- Keymap to check which installed packages are outdated
                check_outdated_packages = "C",

                -- Keymap to cancel a package installation
                cancel_installation = "<C-c>",

                -- Keymap to apply language filter
                apply_language_filter = "<C-f>",
            },
        },

        -- The directory in which to install packages
        install_root_dir = utils.join_paths(vim.fn.stdpath "data", "mason"),

        -- Where Mason should put its bin location in your PATH. Can be one of:
        -- "prepend" (default, Mason's bin location is put first in PATH)
        -- "append" (Mason's bin location is put at the end of PATH)
        -- "skip" (doesn't modify PATH)
        ---@type '"prepend"' | '"append"' | '"skip"'
        PATH = "prepend",

        pip = {
            -- These args will be added to `pip install` calls. Note that setting extra args might impact intended behavior
            -- Example: { "--proxy", "https://proxyserver" }
            install_args = {},
        },

        -- Controls to which degree logs are written to the log file. It's useful to set this to vim.log.levels.DEBUG when
        -- debugging issues with package installations
        log_level = vim.log.levels.INFO,

        -- Limit for the maximum amount of packages to be installed at the same time. Once this limit is reached, any further
        -- packages that are requested to be installed will be put in a queue
        max_concurrent_installers = 8,

        -- The provider implementations to use for resolving package metadata (latest version, available versions, etc.).
        -- Accepts multiple entries, where later entries will be used as fallback should prior providers fail.
        -- Builtin providers are:
        --   - mason.providers.registry-api (default) - uses the https://api.mason-registry.dev API
        --   - mason.providers.client                 - uses only client-side tooling to resolve metadata
        providers = {
            "mason.providers.registry-api",
        },

        -- Customize the download URL when downloading assets from GitHub releases.
        github = {
            -- The template URL to use when downloading assets from GitHub
            -- The placeholders are the following (in order):
            -- 1. The repository (e.g. "rust-lang/rust-analyzer")
            -- 2. The release version (e.g. "v0.3.0")
            -- 3. The asset name (e.g. "rust-analyzer-v0.3.0-x86_64-unknown-linux-gnu.tar.gz")
            download_url_template = "https://github.com/%s/releases/download/%s/%s",
        },
    }

    -- Bridge between 'mason' and 'lspconfig' allowing for easy installation and setup of LSP severs
    require("mason-lspconfig").setup {
        -- Autmatic installation of servers configured via lspconfig
        automatic_installation = true,
    }

    -- Bridge between 'mason' and 'null-ls' allowing for easy installation of non-LSP servers
    require("mason-null-ls").setup {
        -- A list of sources to install if they're not already installed.
        -- This setting has no relation with the `automatic_installation` setting.
        ensure_installed = {
            "clang-format",
            "luacheck",
            "prettierd",
            "shfmt",
            "stylua",
        },

        -- Will automatically install masons tools based on selected sources in `null-ls`.
        -- Can also be an exclusion list.
        -- Example: `automatic_installation = { exclude = { "rust_analyzer", "solargraph" } }`
        -- NOTE: This will have to be run after 'null-ls' has been setup in order for it to work.
        automatic_installation = false,

        -- Whether sources that are installed in mason should be automatically set up in null-ls.
        -- Removes the need to set up null-ls manually.
        -- Can either be:
        -- - false: Null-ls is not automatically registered.
        -- - true: Null-ls is automatically registered.
        -- - { types = { SOURCE_NAME = {TYPES} } }. Allows overriding default configuration.
        -- Ex: { types = { eslint_d = {'formatting'} } }
        automatic_setup = false,
    }

    utils.map("n", "<leader>m", vim.cmd.Mason)
end

return M
