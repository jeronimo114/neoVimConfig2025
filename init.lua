-- Set leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Side Scroll Settings
vim.o.wrap = false
vim.o.sidescrolloff = 5


-- Agregar directorios al PATH
local home = os.getenv("HOME")
vim.env.PATH = home .. "/.local/share/nvim/mason/bin:" .. home .. "/.local/bin:" .. home .. "/.local/bin:" .. home .. "/go/bin:" .. home .. "/usr/local/bin:" .. home .. "/opt/homebrew/bin:" .. home .. "/opt/homebrew/sbin:" .. home .. "/Applications/iTerm.app/Contents/Resources/utilities:" .. vim.env.PATH


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

" Essential Plugins
Plug 'nvim-lua/plenary.nvim'

" File explorer
Plug 'nvim-tree/nvim-tree.lua'

" Syntax highlighting and more
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Rainbow parentheses
Plug 'p00f/nvim-ts-rainbow'

" Status line
Plug 'nvim-lualine/lualine.nvim'

" Fuzzy finder
Plug 'nvim-telescope/telescope.nvim'

" Git integration
Plug 'tpope/vim-fugitive'

" Auto-save plugin
Plug 'Pocco81/auto-save.nvim'

" Autocomplete plugins
Plug 'hrsh7th/nvim-cmp'         " Autocompletion plugin
Plug 'hrsh7th/cmp-nvim-lsp'     " LSP source for nvim-cmp
Plug 'hrsh7th/cmp-buffer'       " Buffer completions
Plug 'hrsh7th/cmp-path'         " Path completions
Plug 'saadparwaiz1/cmp_luasnip' " Snippet completions

" Snippet engine
Plug 'L3MON4D3/LuaSnip'

" Mason for managing LSP servers
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'

" LSP Configuration
Plug 'neovim/nvim-lspconfig'

" Enhanced Colorscheme
Plug 'folke/tokyonight.nvim'

" Optional: Friendly Snippets
Plug 'rafamadriz/friendly-snippets'

call plug#end()
]]

-- Colorscheme setup
vim.cmd[[colorscheme tokyonight]]

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

-- Treesitter setup with rainbow parentheses
require("nvim-treesitter.configs").setup {
    ensure_installed = { "lua", "python", "javascript", "html", "css" }, -- Add languages you need
    highlight = { 
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    indent = { enable = true },
    rainbow = {
        enable = true,
        extended_mode = true, -- Highlight also non-bracket delimiters
        max_file_lines = nil,
    },
}

-- Lualine setup
require("lualine").setup {
    options = {
        theme = "tokyonight", -- Updated to match the new colorscheme
        section_separators = "",
        component_separators = "",
    },
}

-- Telescope setup with initial_mode set to normal
require('telescope').setup{
    defaults = {
        initial_mode = "normal", -- Start in normal mode
        mappings = {
            i = {
                ["<C-j>"] = "move_selection_next",
                ["<C-k>"] = "move_selection_previous",
                ["<esc>"] = require('telescope.actions').close,
            },
            n = {
                ["<esc>"] = require('telescope.actions').close,
            },
        },
    },
    pickers = {
        -- You can add custom picker configurations here
    },
    extensions = {
        -- You can add extensions here
    },
}

-- Key mappings for Telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find help tags" })

-- Mason and mason-lspconfig setup
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "pyright", "lua_ls", "gopls", "rust_analyzer" }, -- Removed "tsserver"
    automatic_installation = true,
})

-- Import lspconfig
local lspconfig = require('lspconfig')

-- Define capabilities for nvim-cmp
local cmp_nvim_lsp = require('cmp_nvim_lsp')
local capabilities = cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Función común para configurar atajos de LSP
local on_attach = function(client, bufnr)
    -- LSP keybindings
    local opts = { noremap=true, silent=true }
    local buf_set_keymap = function(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

    -- Define LSP keybindings
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

-- Setup para Python (pyright)
lspconfig.pyright.setup{
    capabilities = capabilities,
    on_attach = on_attach,
}

-- Setup para Lua (lua_ls)
lspconfig.lua_ls.setup{
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT', -- Neovim uses LuaJIT
            },
            diagnostics = {
                globals = {'vim'}, -- Recognize the `vim` global
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            telemetry = {
                enable = false,
            },
        }
    },
    on_attach = on_attach,
}

-- Setup para Go (gopls)
lspconfig.gopls.setup{
    capabilities = capabilities,
    on_attach = on_attach,
}

-- Setup para Rust (rust_analyzer)
lspconfig.rust_analyzer.setup{
    capabilities = capabilities,
    on_attach = on_attach,
}

-- Configuración de autocompletado usando nvim-cmp
local cmp = require'cmp'

cmp.setup({
    snippet = {
        -- REQUIRED: Configurar el motor de snippets
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- Para usuarios de `luasnip`
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Confirmar selección
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif require('luasnip').expand_or_jumpable() then
                require('luasnip').expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),

        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif require('luasnip').jumpable(-1) then
                require('luasnip').jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },        -- Autocompletado de LSP
        { name = 'luasnip' },         -- Snippets
    }, {
        { name = 'buffer' },          -- Autocompletado del buffer
        { name = 'path' },            -- Autocompletado de rutas
    }),
    formatting = {
        format = function(entry, vim_item)
            -- Personalizar cómo se muestran los elementos de completado
            vim_item.kind = string.format('%s', vim_item.kind)
            vim_item.menu = ({
                nvim_lsp = "[LSP]",
                luasnip = "[Snippet]",
                buffer = "[Buffer]",
                path = "[Path]",
            })[entry.source.name]
            return vim_item
        end
    },
    experimental = {
        ghost_text = true, -- Mostrar texto fantasma (sugerencias en línea)
        native_menu = false,
    },
})

-- Usar fuente del buffer para `/` y `?` en modo de línea de comandos
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Usar fuentes de cmdline y path para ':' en modo de línea de comandos
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})

-- Configuración de LuaSnip
local luasnip = require 'luasnip'

-- Cargar friendly-snippets o tus snippets personalizados
require("luasnip.loaders.from_vscode").lazy_load()

-- Opcional: Define tus propios snippets aquí
-- Ejemplo:
-- luasnip.snippets = {
--   lua = {
--     luasnip.parser.parse_snippet("fn", "function() \n\t$1 \nend"),
--   },
-- }

-- Autocomando para cerrar nvim-tree cuando es la última ventana
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        local api = require("nvim-tree.api")
        if #vim.api.nvim_list_wins() == 1 and require("nvim-tree.utils").is_nvim_tree_buf() then
            vim.cmd("quit")
        end
    end,
    group = vim.api.nvim_create_augroup("NvimTreeCloseOnOpen", { clear = true }),
})

-- Configuración de Auto-save
require("auto-save").setup {
    enabled = true, -- Iniciar auto-save cuando el plugin se carga
    execution_message = {
        message = "AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"),
        dim = 0.18,
        cleaning_interval = 1000,
    },
    trigger_events = {"InsertLeave", "TextChanged"}, -- Auto-save en estos eventos
    condition = function(buf)
        local fn = vim.fn
        -- No auto-save si es un buffer de terminal
        if fn.getbufvar(buf, "&buftype") == "terminal" then
            return false
        end
        -- No auto-save si el buffer no es modificable
        if not vim.bo[buf].modifiable then
            return false
        end
        -- Opcional: excluir ciertos tipos de archivos
        local excluded_filetypes = {"gitcommit", "gitrebase"}
        if vim.tbl_contains(excluded_filetypes, vim.bo[buf].filetype) then
            return false
        end
        return true
    end,
    write_all_buffers = false, -- Si es true, todos los buffers serán escritos
    debounce_delay = 135, -- Retardo en ms
}

-- Keymap para guardar todo y salir
vim.keymap.set("n", "<leader>q", ":wqall<CR>", { noremap = true, silent = true, desc = "Save all and quit" })

-- Keybindings para guardar
-- Guardar el buffer actual
vim.keymap.set("n", "<leader>w", ":w<CR>", { noremap = true, silent = true, desc = "Save Current Buffer" })

-- Guardar todos los buffers
vim.keymap.set("n", "<leader>S", ":wa<CR>", { noremap = true, silent = true, desc = "Save All Buffers" })

-- Keybinding for running a Python file in a new terminal tab
vim.keymap.set('n', '<leader>r', function()
    if vim.bo.filetype == 'python' then
        vim.cmd('write') -- Save the current file
        local file_path = vim.fn.expand('%:p') -- Get the full path of the current file
        vim.fn.system(string.format("osascript -e 'tell application \"iTerm\" to create window with default profile'"))
        vim.fn.system(string.format("osascript -e 'tell application \"iTerm\" to tell current session of current window to write text \"python3 %s\"'", file_path))
    else
        print("Not a Python file")
    end
end, { noremap = true, silent = true, desc = "Run Python File in New Terminal Tab" })
