local M = {}

--- Install the passed in servers via Mason.
---@param servers table: A table with server names.
local function ensure_installed(servers)
    local registry = require "mason-registry"

    for _, server in ipairs(servers) do
        if registry.has_package(server) then
            local pkg = registry.get_package(server)
            if not pkg:is_installed() then
                pkg:install():once(
                    "closed",
                    vim.schedule_wrap(function()
                        if pkg:is_installed() then
                            vim.notify(
                                string.format('"%s" was successfully installed.', pkg.name),
                                vim.log.levels.INFO,
                                {
                                    title = "Mason",
                                }
                            )
                        end
                    end)
                )
            end
        else
            vim.schedule(function()
                vim.notify(
                    string.format('Server "%s" could not be found in the registry.', server),
                    vim.log.levels.WARN,
                    {
                        title = "Mason",
                    }
                )
            end)
        end
    end
end

function M.setup()
    local icons = require "tt.icons"
    local utils = require "tt.utils"
    local servers = require "tt._plugins.lsp.config.servers"
    local formatters = require("tt._plugins.conform").get_formatters()

    require("mason").setup {
        -- The directory in which to install packages
        install_root_dir = utils.join_paths(vim.fn.stdpath "data", "mason"),

        -- Controls to which degree logs are written to the log file. It's useful to set this to vim.log.levels.DEBUG when
        -- debugging issues with package installations
        log_level = vim.log.levels.INFO,

        -- Limit for the maximum amount of packages to be installed at the same time. Once this limit is reached, any further
        -- packages that are requested to be installed will be put in a queue
        max_concurrent_installers = 8,

        ui = {
            -- Whether to automatically check for new versions when opening the :Mason window
            check_outdated_packages_on_open = true,

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
                uninstall_package = "x",

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
    }

    -- Bridge between 'mason' and 'lspconfig' allowing for easy installation and setup of LSP severs
    require("mason-lspconfig").setup {
        -- A list of servers to automatically install if they're not already installed
        ensure_installed = vim.tbl_keys(servers.lsp_servers),
    }

    -- Make sure to install required servers
    local ensure_installed_servers = vim.list_extend(formatters, servers.mason_servers)
    ensure_installed(ensure_installed_servers)

    utils.map("n", "<leader>m", vim.cmd.Mason)
end

return M
