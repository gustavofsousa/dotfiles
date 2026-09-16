-- Monokai clássico — mesma paleta do Dolphin/KDE (kdeglobals) e do Alacritty.
-- Ver STATE.md do repo de dotfiles (2026-09-16).
return {
	"tanvirtin/monokai.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		vim.cmd.colorscheme("monokai")
	end,
}
