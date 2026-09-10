return {
    "romgrk/barbar.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "lewis6991/gitsigns.nvim" },
    config = function()
        require("barbar").setup({
            animation = true,
            clickable = true,
            auto_hide = false,
            tabpages = true,
            hide = { extensions = false, inactive = false },
            icons = {
                buffer_index = true,
                filetype = { enabled = true },
                separator = { left = "▎", right = "" },
                modified = { button = "●" },
            },
            custom_buffer_name = function(bufnr)
                local full_path = vim.api.nvim_buf_get_name(bufnr)
                local relative_path = vim.fn.fnamemodify(full_path, ":p:.")
                local short_path = vim.fn.pathshorten(relative_path)
                return short_path == "" and "[No Name]" or short_path
            end,
        })
    end,
}
