return {
	"github/copilot.vim",
	event = "VimEnter",
	init = function()
		vim.g.copilot_no_tab_map = false
		vim.g.copilot_workspace_folders = { vim.fn.getcwd() }
	end,
	keys = {
		{ "<TAB>", "v:lua.copilot#complete()", { expr = true, silent = true, mode = "i" } },
		{ "<M-]>", "v:lua.copilot#Next()", { expr = true, silent = true, mode = "i" } },
	},
}
