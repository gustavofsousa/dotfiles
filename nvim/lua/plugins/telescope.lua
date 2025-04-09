return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "nvim-telescope/telescope-file-browser.nvim",
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("telescope").setup({
            defaults = {
                hidden = true,
                file_ignore_patterns = { "node_modules", "%.git/" },
                mappings = {
                    n = {
                        ["j"] = require("telescope.actions").move_selection_next,
                        ["k"] = require("telescope.actions").move_selection_previous,
                        ["l"] = require("telescope.actions").select_default,
                        ["h"] = false,
                    },
                },
            },
            extensions = {
                fzf = { fuzzy = true, override_generic_sorter = true, override_file_sorter = true, case_mode = "ignore_case" },
                file_browser = {
                    theme = "ivy",
                    hijack_netrw = true,
                    cwd_to_path = true,
                    grouped = true,
                    files = true,
                    auto_depth = 2,
                    hidden = true,
                    git_status = true,
                    mappings = {
                        ["n"] = {
                            ["j"] = require("telescope.actions").move_selection_next,
                            ["k"] = require("telescope.actions").move_selection_previous,
                            ["l"] = require("telescope.actions").select_default,
                            ["h"] = require("telescope").extensions.file_browser.actions.goto_parent_dir,
                            ["c"] = require("telescope").extensions.file_browser.actions.create,
                            ["r"] = require("telescope").extensions.file_browser.actions.rename,
                            ["q"] = require("telescope").extensions.file_browser.actions.remove,
                        },
                    },
                },
            },
        })
        require("telescope").load_extension("fzf")
        require("telescope").load_extension("file_browser")
    end,
}
