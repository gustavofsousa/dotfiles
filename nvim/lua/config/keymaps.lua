local map = vim.keymap.set

-- Configurações do leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Geral
map("n", "<C-c>", '"+y', { desc = "Copiar para o clipboard (normal)" })
map("v", "<C-c>", '"+y', { desc = "Copiar para o clipboard (visual)" })
map("n", "<C-v>", '"+p', { desc = "Colar do clipboard (normal)" })
map("i", "<C-v>", "<C-r>+", { desc = "Colar do clipboard (insert)" })

-- Barbar (navegação de buffers)
map("n", "<leader>l", ":BufferNext<CR>", { desc = "Próxima aba" })
map("n", "<leader>h", ":BufferPrevious<CR>", { desc = "Aba anterior" })
map("n", "<leader>q", ":BufferClose<CR>", { desc = "Fechar aba atual" })
map("n", "<leader><Tab>", ":BufferLast<CR>", { desc = "Ir para o buffer mais recente" })
map("n", "<leader>t", function()
    local oldfiles = vim.v.oldfiles
        if #oldfiles > 0 then
		vim.cmd("e " .. oldfiles[1])
    else
    print("Nenhum arquivo recente encontrado.")
	end
	end, { desc = "Reabrir último arquivo fechado" })

	-- Telescope
	map("n", "<leader>ff", function() require("telescope.builtin").find_files() end, { desc = "Find Files" })
	map("n", "<leader>fg", function() require("telescope.builtin").live_grep() end, { desc = "Live Grep" })
	map("n", "<leader>fu", function() require("telescope.builtin").buffers() end, { desc = "Find Buffers" })
	map("n", "<leader>fb", function() require("telescope").extensions.file_browser.file_browser() end, { desc = "File Browser" })
	map("n", "<leader>fh", function() require("telescope.builtin").help_tags() end, { desc = "Find Help Tags" })

	-- LazyGit
	map("n", "<leader>g", "<cmd>LazyGit<CR>", { desc = "Abrir LazyGit" })

	-- Comment.nvim
	map("n", "<leader>/", function() require("Comment.api").toggle.linewise.current() end, { desc = "Toggle comment (linha)" })
	map("v", "<leader>/", function() require("Comment.api").toggle.blockwise.current() end, { desc = "Toggle comment (bloco)" })

	-- LSP (temporário, será expandido com OmniSharp)
	map("n", "<leader>fr", function() require("telescope.builtin").lsp_references() end, { desc = "Find References" })
	map("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
	map("n", "<leader>gi", vim.lsp.buf.implementation, { desc = "Go to Implementation" })
