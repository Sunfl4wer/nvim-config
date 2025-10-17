return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"f-person/git-blame.nvim",
	},
	config = function()
		local lualine = require("lualine")
		local lazy_status = require("lazy.status")
		local has_git_blame, git_blame = pcall(require, "gitblame")

		local function blame_component()
			if has_git_blame and git_blame.is_blame_text_available() then
				return git_blame.get_current_blame_text()
			end
			return ""
		end

		lualine.setup({
			options = {
				theme = "gruvbox-material",
				globalstatus = true,
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
			},
			sections = {
				lualine_a = {
					{
						"mode",
						icon = "",
						separator = { left = "", right = "" },
						right_padding = 2,
					},
				},
				lualine_b = {
					{ "branch", icon = "" },
					"diff",
				},
				lualine_c = {
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						sections = { "error", "warn", "info", "hint" },
						diagnostics_color = {
							error = "DiagnosticError",
							warn = "DiagnosticWarn",
							info = "DiagnosticInfo",
							hint = "DiagnosticHint",
						},
						symbols = { error = "E", warn = "W", info = "I", hint = "H" },
						update_in_insert = false,
					},
					{ "filename", path = 1, symbols = { modified = " ", readonly = " ", unnamed = "" } },
				},
				lualine_x = {
					{
						lazy_status.updates,
						cond = lazy_status.has_updates,
						icon = "",
					},
					blame_component,
					"encoding",
					"filetype",
				},
				lualine_y = { "progress" },
				lualine_z = {
					{
						"location",
						separator = { right = "" },
						left_padding = 2,
					},
				},
			},
			inactive_sections = {
				lualine_a = { { "filename", path = 1 } },
				lualine_b = {},
				lualine_c = {},
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			extensions = { "quickfix", "trouble", "fugitive", "lazy" },
		})
	end,
}
