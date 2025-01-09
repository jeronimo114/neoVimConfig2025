
-- Set leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Yank to Clipboard
vim.opt.clipboard = "unnamedplus"

-- Enable line numbers
vim.o.number = true               -- Show absolute line numbers
vim.o.relativenumber = true       -- Show relative line numbers

-- Tabs and indentation
vim.o.tabstop = 4                 -- Number of spaces that a tab represents
vim.o.shiftwidth = 4              -- Number of spaces used for indentation
vim.o.expandtab = true            -- Use spaces instead of tabs
vim.o.autoindent = true           -- Auto-indent new lines

-- Search settings
vim.o.ignorecase = true           -- Ignore case when searching
vim.o.smartcase = true            -- Override ignorecase if search has uppercase
vim.o.hlsearch = false            -- Do not highlight search results

-- Appearance
vim.o.termguicolors = true        -- Enable true color support
vim.o.cursorline = true           -- Highlight the current line

-- Splits
vim.o.splitright = true           -- Open vertical splits to the right
vim.o.splitbelow = true           -- Open horizontal splits below

-- Save undo history
vim.o.undofile = true             -- Enable persistent undo
vim.opt.undodir = os.getenv("HOME") .. "/.config/nvim/undo"

-- Enable backups
vim.opt.backup = true
vim.opt.backupdir = os.getenv("HOME") .. "/.config/nvim/backup"

-- Enable swap files
vim.opt.swapfile = true
vim.opt.directory = os.getenv("HOME") .. "/.config/nvim/swap"

-- Enable writebackup
vim.opt.writebackup = true

-- Confirmation prompts when closing unsaved buffers
vim.opt.confirm = true

-- Automatically save before certain actions
vim.opt.autowrite = true

-- Initialize vim-plug
vim.cmd [[
call plug#begin('~/.local/share/nvim/plugged')
Plug 'nvim-lua/plenary.nvim'

" File explorer
Plug 'nvim-tree/nvim-tree.lua'

" Syntax highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Status line
Plug 'nvim-lualine/lualine.nvim'

" Fuzzy finder
Plug 'nvim-telescope/telescope.nvim'

" Git integration
Plug 'tpope/vim-fugitive'

" Auto-save plugin
Plug 'Pocco81/auto-save.nvim'

call plug#end()
]]

-- nvim-tree setup with auto-close functionality
require("nvim-tree").setup {
    -- Disable the built-in netrw (optional but recommended)
    disable_netrw = true,
    hijack_netrw = true,

    -- Renderer settings
    renderer = {
        highlight_git = true,
        icons = {
            glyphs = {
                default = "",
                symlink = "",
                git = {
                    unstaged = "✗",
                    staged = "✓",
                    unmerged = "",
                    renamed = "➜",
                    untracked = "★",
                    deleted = "",
                    ignored = "◌",
                },
            },
        },
    },

    -- Update focused file on the tree
    update_focused_file = {
        enable = true,
        update_cwd = true,
    },

    -- Actions related to opening files
    actions = {
        open_file = {
            quit_on_open = false,  -- We'll handle closing manually
            resize_window = false,
        },
    },

    -- View settings without 'mappings'
    view = {
        width = 30,
        side = 'left',
        -- Removed 'mappings' as it's no longer a valid option
    },

    -- Attach function to set up key mappings specific to nvim-tree
    on_attach = function(bufnr)
        local api = require("nvim-tree.api")

        local function opts(desc)
            return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        -- Override the default <CR> mapping to open the file and close the tree
        vim.keymap.set('n', '<CR>', function()
            api.node.open.edit()
            api.tree.close()
        end, opts('Open and Close'))

        -- Similarly, override other mappings if desired
        vim.keymap.set('n', 'o', function()
            api.node.open.edit()
            api.tree.close()
        end, opts('Open and Close'))

        vim.keymap.set('n', '<2-LeftMouse>', function()
            api.node.open.edit()
            api.tree.close()
        end, opts('Open and Close'))
    end,
}

-- Keymap to toggle file explorer
vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

-- Treesitter setup
require("nvim-treesitter.configs").setup {
    ensure_installed = { "lua", "python", "javascript", "html", "css" }, -- Add languages you need
    highlight = { enable = true },
    indent = { enable = true },
}

-- Lualine setup
require("lualine").setup {
    options = {
        theme = "gruvbox", -- You can change this to any theme you like
        section_separators = "",
        component_separators = "",
    },
}

-- Telescope setup
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find help tags" })

-- Autocommand to close nvim-tree when it's the last window
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        local api = require("nvim-tree.api")
        if #vim.api.nvim_list_wins() == 1 and require("nvim-tree.utils").is_nvim_tree_buf() then
            vim.cmd("quit")
        end
    end,
    group = vim.api.nvim_create_augroup("NvimTreeCloseOnOpen", { clear = true }),
})

-- Auto-save setup
require("auto-save").setup {
    enabled = true, -- Start auto-save when the plugin is loaded
    execution_message = {
        message = "AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"),
        dim = 0.18,
        cleaning_interval = 1000,
    },
    trigger_events = {"InsertLeave", "TextChanged"}, -- Auto-save on these events
    condition = function(buf)
        local fn = vim.fn
        -- Don't auto-save if it's a terminal buffer
        if fn.getbufvar(buf, "&buftype") == "terminal" then
            return false
        end
        -- Don't auto-save if the buffer is not modifiable
        if not vim.bo[buf].modifiable then
            return false
        end
        -- Optionally, exclude certain filetypes
        local excluded_filetypes = {"gitcommit", "gitrebase"}
        if vim.tbl_contains(excluded_filetypes, vim.bo[buf].filetype) then
            return false
        end
        return true
    end,
    write_all_buffers = false, -- If true, all buffers will be written
    debounce_delay = 135, -- Delay in ms
}

-- Keymap to save all and quit
vim.keymap.set("n", "<leader>q", ":wqall<CR>", { noremap = true, silent = true, desc = "Save all and quit" })

-- Keybindings for saving
-- Save the current buffer
vim.keymap.set("n", "<leader>w", ":w<CR>", { noremap = true, silent = true, desc = "Save Current Buffer" })

-- Save all buffers
vim.keymap.set("n", "<leader>S", ":wa<CR>", { noremap = true, silent = true, desc = "Save All Buffers" })
