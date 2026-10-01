return {
    "neovim/nvim-lspconfig",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    config = function()
        -- nvim-lspconfig only ships server defaults (lsp/*.lua); vim.lsp.config merges our overrides on top.
        vim.lsp.config("lua_ls", {
            settings = {
                Lua = {
                    diagnostics = { globals = { "vim" } },
                    workspace = { library = vim.api.nvim_get_runtime_file("", true) },
                },
            },
        })
        -- The default omnisharp root_dir already matches *.sln/*.slnx/*.csproj.
        vim.lsp.config("omnisharp", {
            cmd = { vim.fn.expand("~/.local/bin/omnisharp/OmniSharp"), "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
        })
        vim.lsp.enable({ "lua_ls", "omnisharp" })
    end,
}
