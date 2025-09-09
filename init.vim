let mapleader=" "
let &t_ut=''

lua << EOF
local opts = {
    showmode = false,
    backup = false,
    clipboard = "unnamedplus",
    cmdheight = 1,
    fileencoding = "utf-8",
    hlsearch = true,
    ignorecase = true,
    mouse = "a",
    pumheight = 10,
    smartcase = true,
    smartindent = true,
    swapfile = false,
    termguicolors = true,
    timeoutlen = 500,
    undofile = true,
    updatetime = 200,
    writebackup = false,
    expandtab = true,
    shiftwidth = 4,
    tabstop = 4,
    cursorline = true,
    cursorcolumn = false,
    number = true,
    relativenumber = false,
    numberwidth = 4,
    signcolumn = "yes",
    wrap = false,
    scrolloff = 8,
    sidescrolloff = 8,
    spell = false,
}

for k, v in pairs(opts) do
    vim.opt[k] = v
end
EOF

" cursor motion
noremap H 7h
noremap L 7l
noremap K 5k
noremap J 5j
noremap <C-h> 0
noremap <C-l> $

" search selection & nohl
noremap n nzz
noremap N Nzz

noremap <LEADER><CR> :nohlsearch<CR>

" split windows & motion
map sl :set splitright<CR>:vsplit<CR>
map sh :set nosplitright<CR>:vsplit<CR>
map sj :set splitbelow<CR>:split<CR>
map sk :set nosplitbelow<CR>:split<CR>

map <LEADER>h <C-w>h
map <LEADER>j <C-w>j
map <LEADER>k <C-w>k
map <LEADER>l <C-w>l

map <up> :res +2<CR>
map <down> :res -2<CR>
map <left> :vertical resize+5<CR>
map <right> :vertical resize-5<CR>

" save and quit
map q <nop>
map Q <nop>
map s <nop>
map S <nop>
nnoremap <C-s> :w<CR>
nnoremap <C-r> :source $MYVIMRC<CR>
nnoremap <C-q> :q<CR>

" plugin call
call plug#begin()

Plug 'catppuccin/vim', { 'as': 'catppuccin' }
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'windwp/nvim-autopairs'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'mason-org/mason.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'HallerPatrick/py_lsp.nvim'
Plug 'xzbdmw/colorful-menu.nvim'
Plug 'saghen/blink.cmp'
Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'numToStr/Comment.nvim'
Plug 'SmiteshP/nvim-navic'
Plug 'utilyre/barbecue.nvim'
Plug 'akinsho/bufferline.nvim'
Plug 'akinsho/toggleterm.nvim'
Plug 'WhoIsSethDaniel/mason-tool-installer.nvim'
Plug 'MeanderingProgrammer/render-markdown.nvim'

call plug#end()

" lsp attach
lua << EOF
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
    callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        -- keymap
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = event.buf, desc = 'LSP: Go to definition' })
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = event.buf, desc = 'LSP: Go to declaration' })
        -- diagnostics
        vim.diagnostic.config {
            virtual_text = true
        }
        -- show diagnostics a float window
        vim.keymap.set('n', '<leader>ld', function()
            vim.diagnostic.open_float { source = true }
        end, { buffer = event.buf, desc = 'LSP: Show diagnostics' })
        -- toggle diagnostics
        vim.keymap.set('n', '<leader>td', (
            function()
                local diag_status = 1
                return function()
                    if diag_status == 1 then
                        diag_status = 0
                        vim.diagnostic.config { underline = false, virtual_text = false, signs = false, update_in_insert = false }
                    else
                        diag_status = 1
                        vim.diagnostic.config { underline = true, virtual_text = true, signs = true, update_in_insert = true }
                    end
                end
            end
        )(), { buffer = event.buf, desc = 'LSP: Toggle diagnostic' })
    end,
})
EOF

" clangd
lua << EOF
vim.lsp.config['clangd'] = {
    cmd = { 'clangd', '--header-insertion=never' },
    filetypes = { 'c', 'cpp', 'cuda', 'cxx', 'hxx', 'cc', 'h', 'hpp' },
    root_markers = {
        '.clangd',
        '.clang-tidy',
        '.clang-format',
        'compile_commands.json',
        'compile_flags.txt',
        'configure.ac', -- AutoTools
        '.git',
    },
    capabilities = {
        textDocument = {
            completion = {
                editsNearCursor = true,
            },
        },
        offsetEncoding = { 'utf-8', 'utf-16' },
    },
    on_attach = function(client, bufnr)
        if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
    end,
}
vim.lsp.enable('clangd')
EOF

" cmake
lua << EOF
local util = vim.lsp.util

vim.lsp.config['cmake'] = {
    default_config = {
        cmd = { 'cmake-language-server' },
        filetypes = { 'cmake' },
        root_dir = function(fname)
            return util.root_pattern('CMakePresets.json', 'CTestConfig.cmake', '.git', 'build', 'cmake')(fname)
        end,
        single_file_support = true,
        init_options = {
            buildDirectory = 'build',
        },
    },
    docs = {
        description = [[
            https://github.com/regen100/cmake-language-server
            CMake LSP Implementation
        ]],
    },
}
vim.lsp.enable('cmake')
EOF

" pyright
lua << EOF
vim.lsp.config['pyright'] = {
    cmd = { 'pyright-langserver', '--stdio' },
    filetypes = { 'python' },
    root_markers = {
        'pyproject.toml',
        'setup.py',
        'setup.cfg',
        'requirements.txt',
        'Pipfile',
        'pyrightconfig.json',
        '.git',
    },
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = 'openFilesOnly',
            },
        },
    },
    on_attach = function(client, bufnr)
        if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
    end,
}
vim.lsp.enable('pyright')
EOF

" vimscript
lua << EOF
vim.lsp.config['vimscript'] = {
    cmd = { 'vim-language-server', '--stdio' },
    filetypes = { 'vim' },
    root_markers = { '.git' },
    init_options = {
        isNeovim = true,
        iskeyword = '@,48-57,_,192-255,-#',
        vimruntime = '',
        runtimepath = '',
        diagnostic = { enable = true },
        indexes = {
            runtimepath = true,
            gap = 100,
            count = 3,
            projectRootPatterns = { 'runtime', 'nvim', '.git', 'autoload', 'plugin' },
        },
        suggest = { fromVimruntime = true, fromRuntimepath = true },
    },
}
vim.lsp.enable('vimscript')
EOF

" rust analyzer
lua << EOF
local function reload_workspace(bufnr)
  local clients = vim.lsp.get_clients { bufnr = bufnr, name = 'rust_analyzer' }
  for _, client in ipairs(clients) do
    vim.notify 'Reloading Cargo Workspace'
    ---@diagnostic disable-next-line:param-type-mismatch
    client:request('rust-analyzer/reloadWorkspace', nil, function(err)
      if err then
        error(tostring(err))
      end
      vim.notify 'Cargo workspace reloaded'
    end, 0)
  end
end

local function is_library(fname)
  local user_home = vim.fs.normalize(vim.env.HOME)
  local cargo_home = os.getenv 'CARGO_HOME' or user_home .. '/.cargo'
  local registry = cargo_home .. '/registry/src'
  local git_registry = cargo_home .. '/git/checkouts'

  local rustup_home = os.getenv 'RUSTUP_HOME' or user_home .. '/.rustup'
  local toolchains = rustup_home .. '/toolchains'

  for _, item in ipairs { toolchains, registry, git_registry } do
    if vim.fs.relpath(item, fname) then
      local clients = vim.lsp.get_clients { name = 'rust_analyzer' }
      return #clients > 0 and clients[#clients].config.root_dir or nil
    end
  end
end

vim.lsp.config["rust-analyzer"] = {
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local reused_dir = is_library(fname)
    if reused_dir then
      on_dir(reused_dir)
      return
    end

    local cargo_crate_dir = vim.fs.root(fname, { 'Cargo.toml' })
    local cargo_workspace_root

    if cargo_crate_dir == nil then
      on_dir(
        vim.fs.root(fname, { 'rust-project.json' })
          or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
      )
      return
    end

    local cmd = {
      'cargo',
      'metadata',
      '--no-deps',
      '--format-version',
      '1',
      '--manifest-path',
      cargo_crate_dir .. '/Cargo.toml',
    }

    vim.system(cmd, { text = true }, function(output)
      if output.code == 0 then
        if output.stdout then
          local result = vim.json.decode(output.stdout)
          if result['workspace_root'] then
            cargo_workspace_root = vim.fs.normalize(result['workspace_root'])
          end
        end

        on_dir(cargo_workspace_root or cargo_crate_dir)
      else
        vim.schedule(function()
          vim.notify(('[rust_analyzer] cmd failed with code %d: %s\n%s'):format(output.code, cmd, output.stderr))
        end)
      end
    end)
  end,
  capabilities = {
    experimental = {
      serverStatusNotification = true,
    },
  },
  before_init = function(init_params, config)
    -- See https://github.com/rust-lang/rust-analyzer/blob/eb5da56d839ae0a9e9f50774fa3eb78eb0964550/docs/dev/lsp-extensions.md?plain=1#L26
    if config.settings and config.settings['rust-analyzer'] then
      init_params.initializationOptions = config.settings['rust-analyzer']
    end
  end,
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, 'LspCargoReload', function()
      reload_workspace(bufnr)
    end, { desc = 'Reload current cargo workspace' })

    if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end
  end,
}

vim.lsp.enable("rust-analyzer")
EOF

" xml
lua << EOF
vim.lsp.config["lemminx"] =  {
  cmd = { 'lemminx' },
  filetypes = { 'xml', 'xsd', 'xsl', 'xslt', 'svg', 'urdf' },
  root_markers = { '.git' },
}
vim.lsp.enable("lemminx")
EOF

" theme settion
colorscheme catppuccin_mocha

" lualine
lua << EOF
require('lualine').setup {
    options = {
        component_separators = { left = '|', right = '|' },
        section_separators   = { left = '', right = '' },
    }
}
EOF

" nvim-treesitter
lua << EOF
require'nvim-treesitter.configs'.setup {
    auto_install = true,
    sync_install = false,
    ensure_installed = { "c", "lua", "vim", "rust", "cpp", "markdown", "markdown_inline", "xml" },
    highlight = {
        enable = true,
    },
}
EOF

" nvim-tree
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1
lua << EOF
require("nvim-tree").setup {
    view = { width = 25, },
}
EOF
map <LEADER>t :NvimTreeToggle<CR>

" nvim-autopairs
lua << EOF
require("nvim-autopairs").setup {}
EOF

" ibl
lua << EOF
require("ibl").setup {}
EOF

" mason
lua << EOF
require("mason").setup {}
EOF

" mason-tool-installer
lua << EOF
require('mason-tool-installer').setup {
    ensure_installed = {
        'clangd',
        'pyright',
        'cmake-language-server',
        'vim-language-server',
        'rust-analyzer',
        'lemminx'
    },
    auto_update = true,
    run_on_start = true,
    start_delay = 3000,
    debounce_hours = 5,
}
EOF

" py_lsp
lua << EOF
local nvim_lsp = vim.lsp
require("py_lsp").setup {
    language_server = "pyright",
    host_python = "/opt/anaconda3/bin/python",
    default_venv_name = ".venv",
}
EOF

" blink.cmp
lua << EOF
local blink = require("blink.cmp")

blink.setup({
    keymap = {
        preset = 'none',
        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-e>'] = { 'hide', 'fallback' },
        ['<CR>'] = { 'select_and_accept', 'fallback' },
        ['<Tab>'] = {
            function(cmp)
                if cmp.snippet_active() then
                    return cmp.accept()
                else
                    return cmp.select_and_accept()
                end
            end,
            'snippet_forward',
            'fallback',
        },
        ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
        ['<Up>'] = { 'select_prev', 'fallback' },
        ['<Down>'] = { 'select_next', 'fallback' },
        ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
        ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },
        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
        ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
    },

    appearance = {
        nerd_font_variant = 'mono',
    },

    completion = {
        documentation = {
            auto_show = true,
            window = {
                border = "rounded",
            },
        },
        menu = {
            border = "rounded",
            winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
            draw = {
                columns = { { 'kind_icon' }, { 'label', gap = 1 } },
                components = {
                    label = {
                        text = function(ctx)
                            return require('colorful-menu').blink_components_text(ctx)
                        end,
                        highlight = function(ctx)
                            return require('colorful-menu').blink_components_highlight(ctx)
                        end,
                    },
                },
            },
        },
        list = {
            selection = {
                preselect = true,
            },
        },
    },

    sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
    },

    fuzzy = { implementation = "prefer_rust_with_warning" },

    signature = { enabled = true },
})
EOF

" nvim-treesitter-context
lua << EOF
    require'treesitter-context'.setup {
        enable = true,
    }
EOF

" Comment
lua << EOF
require('Comment').setup()
EOF

" barbecue
lua << EOF
require("barbecue").setup()
EOF

" bufferline
lua << EOF
require("bufferline").setup {}
EOF
map <LEADER>x :BufferLineCycleNext<CR>
map <LEADER>z :BufferLineCyclePrev<CR>
map <LEADER>bc :bdelete<CR>
map <LEADER>bz :BufferLineMovePrev<CR>
map <LEADER>bx :BufferLineMoveNext<CR>
map <LEADER>1 :BufferLineGoToBuffer 1<CR>

" toggleterm
lua << EOF
require("toggleterm").setup {
    size = function (term)
        if term.direction == "horizontal" then
            return 10
        elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
        end
    end,
    hide_numbers = true,
    autochdir = true,
}
EOF
nnoremap <C-t> :ToggleTerm<CR>
tnoremap <C-t> <C-\><C-n>:ToggleTerm<CR>

" render-markdown
lua << EOF
require('render-markdown').setup {
    heading = { position = 'inline' },
    bullet = { icons = { '', '' } },
    checkbox = { checked = { scope_highlight = '@markup.strikethrough' } },
    quote = { repeat_linebreak = true },
    sign = { enabled = false },
}
EOF
