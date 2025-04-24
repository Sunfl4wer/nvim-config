return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local lualine = require("lualine")
		local lazy_status = require("lazy.status") -- to configure lazy pending updates count

		-- configure lualine with modified theme
		lualine.setup({
			options = {
				theme = "gruvbox",
				component_separators = { left = "", right = "" },
				separator = { right = "", left = "" },
				-- section_separators = { left = "", right = "" },
			},
			sections = {
				lualine_a = {
					{
						"mode",
						-- separator = {
						-- 	left = "{",
						-- 	right = "}",
						-- 	-- left = "",
						-- },
						right_padding = 2,
						color = { fg = "#fdc675" },
					},
				},
				lualine_b = {
					-- separator = {
					-- 	left = "{",
					-- 	right = "}",
					-- 	-- left = "",
					-- },
					"filename",
					"branch",
					color = { fg = "#fd9d75" },
				},
				lualine_c = {
					{
						"diagnostics",

						-- Table of diagnostic sources, available sources are:
						--   'nvim_lsp', 'nvim_diagnostic', 'nvim_workspace_diagnostic', 'coc', 'ale', 'vim_lsp'.
						-- or a function that returns a table as such:
						--   { error=error_cnt, warn=warn_cnt, info=info_cnt, hint=hint_cnt }
						sources = { "nvim_lsp", "nvim_diagnostic" },

						-- Displays diagnostics for the defined severity types
						sections = { "error", "warn", "info", "hint" },

						diagnostics_color = {
							-- Same values as the general color option can be used here.
							error = "DiagnosticError", -- Changes diagnostics' error color.
							warn = "DiagnosticWarn", -- Changes diagnostics' warn color.
							info = "DiagnosticInfo", -- Changes diagnostics' info color.
							hint = "DiagnosticHint", -- Changes diagnostics' hint color.
						},
						symbols = { error = "E", warn = "W", info = "I", hint = "H" },
						colored = true, -- Displays diagnostics status in color if set to true.
						update_in_insert = false, -- Update diagnostics in insert mode.
						always_visible = false, -- Show diagnostics even if there are none.
					},
				},
				lualine_x = {
					{
						lazy_status.updates,
						cond = lazy_status.has_updates,
						color = { fg = "#d3fda1" },
					},
				},
				lualine_y = {
					"encoding",
					"fileformat",
					"filetype",
					color = { fg = "#96e3a5" },
				},
				lualine_z = {
					{
						"location",
						left_padding = 2,
						color = { fg = "#41bec2" },
					},
					{
						"progress",
						-- separator = { right = "" },
						left_padding = 2,
						color = { fg = "#41bec2" },
					},
				},
			},
			inactive_sections = {
				lualine_a = { "filename" },
				lualine_b = {},
				lualine_c = { "os.date('%a')", "data", "require'lsp-status'.status()" },
				lualine_x = {},
				lualine_y = {},
				lualine_z = { "location" },
			},
			tabline = {},
			extensions = {},
		})
	end,
}
