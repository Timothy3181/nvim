local parsers = {
    "c",
    "cpp",
    "python",
    "lua",
    "vim",
    "vimdoc",
    "query",
    "markdown",
    "markdown_inline",
    "yaml",
    "html",
}

local filetypes = {
    "c",
    "cpp",
    "python",
    "lua",
    "vim",
    "vimdoc",
    "query",
    "markdown",
}

return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter").setup({
            install_dir = vim.fn.stdpath("data") .. "/site",
        })

        -- Mason puts tools in its own bin directory. Add that directory before
        -- checking for tree-sitter, otherwise a Mason-installed CLI can be
        -- incorrectly reported as missing on every startup.
        local mason_root = vim.fs.joinpath(vim.fn.stdpath("data"), "mason")
        local mason_bin = vim.fs.joinpath(mason_root, "bin")
        local mason_package = vim.fs.joinpath(mason_root, "packages", "tree-sitter-cli")
        local path_entries = { mason_bin, mason_package }
        for _, path_entry in ipairs(path_entries) do
            if vim.fn.isdirectory(path_entry) == 1 then
                vim.env.PATH = path_entry .. ";" .. (vim.env.PATH or "")
            end
        end

        -- Installing an already-installed parser is a no-op. The current
        -- Treesitter branch needs the tree-sitter CLI to compile parsers.
        local tree_sitter_exe = vim.fs.joinpath(mason_bin, "tree-sitter.exe")
        local tree_sitter_package_exe = vim.fs.joinpath(mason_package, "tree-sitter.exe")
        local missing_parser = false
        for _, parser in ipairs(parsers) do
            if #vim.api.nvim_get_runtime_file("parser/" .. parser .. ".*", true) == 0 then
                missing_parser = true
                break
            end
        end

        if not missing_parser then
            -- All requested parsers are already installed; no compiler is
            -- needed during startup.
        elseif
            vim.fn.executable("tree-sitter") == 1
            or vim.fn.filereadable(tree_sitter_exe) == 1
            or vim.fn.filereadable(tree_sitter_package_exe) == 1
        then
            -- Installation is asynchronous, so the first launch may need a
            -- restart afterwards.
            require("nvim-treesitter").install(parsers)
        else
            -- Do not nag on every startup. If needed, install it manually
            -- with :MasonInstall tree-sitter-cli and restart Neovim.
        end

        local group = vim.api.nvim_create_augroup("user-treesitter", { clear = true })
        vim.api.nvim_create_autocmd("FileType", {
            group = group,
            pattern = filetypes,
            callback = function(args)
                local ok = pcall(vim.treesitter.start, args.buf)
                if ok then
                    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end
            end,
        })
    end,
}
