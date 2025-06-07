return {
	{
		"sainnhe/everforest",
		lazy = false,
		priority = 1000,
		config = function()
			-- if has('termguicolors')
			--   set termguicolors
			-- endif
			-- Optionally configure and load the colorscheme
			-- directly inside the plugin declaration.
			vim.g.everforest_enable_italic = true
			vim.g.everforest_background = "soft"
			vim.g.everforest_dim_inactive_windwows = 1
			vim.cmd.colorscheme("everforest")
		end,
	},
	-- {
	-- 	"sainnhe/gruvbox-material",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	config = function()
	-- 		vim.g.gruvbox_material_better_performance = 1
	-- 		vim.g.gruvbox_material_foreground = "material"
	-- 		vim.g.gruvbox_material_background = "soft"
	-- 		vim.g.gruvbox_material_ui_contrast = "low"
	-- 		vim.g.gruvbox_material_float_style = "dim"
	-- 		vim.g.gruvbox_material_enable_italic = 1
	-- 		vim.g.gruvbox_material_disable_italic_comment = 1
	-- 		vim.g.gruvbox_material_cursor = "red"
	-- 		vim.g.gruvbox_material_disable_terminal_colors = 1
	-- 		-- local function set_highlights()
	-- 		-- 	local highlights_groups = {
	-- 		-- 		Normal = { bg = "#000000" },
	-- 		-- 		Cursor = { bg = "#ffffff" },
	-- 		-- 	}
	-- 		-- 	for group, styles in pairs(highlights_groups) do
	-- 		-- 		vim.api.nvim_set_hl(0, group, styles)
	-- 		-- 	end
	-- 		-- end
	-- 		--
	-- 		-- vim.api.nvim_create_autocmd("ColorScheme", {
	-- 		-- 	callback = function()
	-- 		-- 		if vim.g.colors_name == "gruvbox-material" then
	-- 		-- 			set_highlights()
	-- 		-- 		end
	-- 		-- 	end,
	-- 		-- })
	-- 		vim.cmd("colorscheme gruvbox-material")
	-- 	end,
	-- },
}
