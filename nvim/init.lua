-- Configurações básicas para Ctrl+C e Ctrl+V no terminal
vim.opt.clipboard = 'unnamedplus'  -- Usa o clipboard do sistema para copiar/colar

-- Atalhos para copiar e colar
vim.api.nvim_set_keymap('n', '<C-c>', '"+y', { noremap = true, silent = true })  -- Ctrl+C no modo normal copia
vim.api.nvim_set_keymap('v', '<C-c>', '"+y', { noremap = true, silent = true })  -- Ctrl+C no modo visual copia
vim.api.nvim_set_keymap('n', '<C-v>', '"+p', { noremap = true, silent = true })  -- Ctrl+V no modo normal cola
vim.api.nvim_set_keymap('i', '<C-v>', '<C-r>+', { noremap = true, silent = true }) -- Ctrl+V no modo insert cola

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Inicialização do lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Configuração dos plugins via lazy.nvim
require("lazy").setup({

  -- Configuração do Nvim-Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',  -- Corrigido o erro de digitação no comando de build
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = { "lua", "python", "javascript", "html", "css" }, -- Adapte para as linguagens desejadas
        highlight = { enable = true },  -- Ativa o destaque de sintaxe
        indent = { enable = true },     -- Ativa a indentação automática
        incremental_selection = { enable = true },  -- Habilita a seleção incremental
      })
    end
  },

  -- LAZYGIT
  {
	"kdheepak/lazygit.nvim",
	 cmd = {
	  "LazyGit",
	  "LazyGitConfig",
	  "LazyGitCurrentFile",
	  "LazyGitFilter",
	  "LazyGitFilterCurrentFile",
	 },
	 -- optional for floating window border decoration
	 dependencies = {
	  "nvim-lua/plenary.nvim",
	 },
	 -- setting the keybinding for LazyGit with 'keys' is recommended in
	 -- order to load the plugin when the command is run for the first time
	 keys = {
	  { "<leader>lg", "<cmd>LazyGit<cr>", desc = "Open lazy git" },
	 },
  },

-- Configuração do Telescope
{
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
"nvim-telescope/telescope-file-browser.nvim",
  },
  config = function()
    require("telescope").setup({
      defaults = {
        -- Adicionar suas configurações personalizadas aqui, se necessário
      },
      extensions = {
	fzf = {
          fuzzy = true,                    -- Habilita fuzzy matching
          override_generic_sorter = true,  -- Substitui o sorter padrão
          override_file_sorter = true,     -- Substitui o sorter de arquivos
          case_mode = "ignore_case",  
      },
file_browser = {
--           Configurações para o file_browser
           theme = "ivy",
	hijack_netrw = true, -- Desabilita netrw e usa o file_browser
	cwd_to_path = true,
	grouped = true,
	files = true,
	auto_depth = 2,
	git_status = true,
	mappings = {
	["i"] = {
--		Mapeamentos personalizados para modo de inserção
		},
	["n"] = {
		-- Mapeamentos personalizados para modo normal
		},
	       },
       },
	}
    })

    -- Carregar as extensões após a configuração
    require("telescope").load_extension("fzf")
require("telescope").load_extension("file_browser") 
  end,

  keys = {
    { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find Files" },
    { "<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "Live Grep" },
    { "<leader>fu", function() require("telescope.builtin").buffers() end, desc = "Find Buffers" },
{ "<leader>fb", function() require("telescope").extensions.file_browser.file_browser() end, desc = "File Browser" },
    { "<leader>fh", function() require("telescope.builtin").help_tags() end, desc = "Find Help Tags" },
  }
},

-- Instalar o telescope-fzf-native e compilar
--{
--  "nvim-telescope/telescope-fzf-native.nvim",
--  build = "make", 
--  config = function()
--    require("telescope").load_extension("fzf")
--  end,
--},


})

-- Enable relative and absolute line numbers
vim.opt.relativenumber = true
vim.opt.number = true

-- Enable and set the width of the sign column
vim.opt.numberwidth = 5
vim.opt.signcolumn = "yes"
vim.opt.signcolumn = "auto:5"

