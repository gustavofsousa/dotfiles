return {
    "neovim/nvim-lspconfig",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    config = function()
        local lspconfig = require("lspconfig")
        lspconfig.lua_ls.setup({
            settings = {
                Lua = {
                    diagnostics = { globals = { "vim" } },
                    workspace = { library = vim.api.nvim_get_runtime_file("", true) },
                },
            },
        })
        lspconfig.omnisharp.setup({
	cmd = { "mono", vim.fn.expand("~/.local/bin/omnisharp/OmniSharp.exe"), "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
            root_dir = lspconfig.util.root_pattern("*.csproj", "*.sln"),
        })
    end,
}
