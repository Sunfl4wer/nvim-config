-- =============== bootstrap lazy.nvim ===============
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

-- =============== basics ===============
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true
vim.opt.updatetime = 250

-- =============== plugins ===============
require("lazy").setup({
	-- core
	{ "nvim-lua/plenary.nvim", lazy = true },

	-- treesitter (better syntax, folding, etc.)
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"go",
					"lua",
					"javascript",
					"typescript",
					"tsx",
					"json",
					"yaml",
					"bash",
					"markdown",
				},
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},

	-- ===== LSP =====
	{ "neovim/nvim-lspconfig" },
	{ "williamboman/mason.nvim", config = true },
	{ "williamboman/mason-lspconfig.nvim" },

	-- ===== vim-go =====
	{
		"fatih/vim-go",
		ft = { "go", "gomod", "gowork", "gotmpl" },
		-- Optional: build = ":GoInstallBinaries",  -- installs vim-go extras
		init = function()
			-- We already use nvim-lspconfig + gopls + conform; keep vim-go as a toolbelt
			vim.g.go_gopls_enabled = 0 -- avoid a 2nd LSP client from vim-go
			vim.g.go_fmt_autosave = 0 -- let conform do formatting
			vim.g.go_imports_autosave = 0 -- handled by conform (goimports/gofumpt)
			vim.g.go_doc_keywordprg_enabled = 0 -- keep K mapped to LSP hover
		end,
		config = function()
			-- Handy commands/keymaps
			local map = function(lhs, rhs, desc)
				vim.keymap.set("n", lhs, rhs, { silent = true, desc = desc })
			end
			map("<leader>gt", ":GoTest<CR>", "Go: Test")
			map("<leader>gT", ":GoTestFunc<CR>", "Go: Test Func")
			map("<leader>ga", ":GoAddTag<CR>", "Go: Add json tags")
			map("<leader>gr", ":GoRemoveTag<CR>", "Go: Remove tags")
			map("<leader>ge", ":GoIfErr<CR>", "Go: Insert if err")
			map("<leader>gm", ":GoModTidy<CR>", "Go: mod tidy")
			map("<leader>gc", ":GoCoverageToggle<CR>", "Go: coverage toggle")
		end,
	},

	-- ===== LuaSnip =====
	{
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!).
		build = "make install_jsregexp",
	},

	-- ===== Completion (suggestions) =====
	{ "hrsh7th/nvim-cmp" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-buffer" },
	{ "hrsh7th/cmp-path" },
	{ "L3MON4D3/LuaSnip" },
	{ "saadparwaiz1/cmp_luasnip" },
	{ "rafamadriz/friendly-snippets" },

	-- ===== Formatting =====
	{
		"stevearc/conform.nvim",
		opts = {
			notify_on_error = false,
			format_on_save = function(buf)
				local ignore = { "cpp", "c" }
				if vim.tbl_contains(ignore, vim.bo[buf].filetype) then
					return
				end
				return { timeout_ms = 2000, lsp_fallback = true }
			end,
			formatters_by_ft = {
				go = { "goimports", "gofumpt" }, -- falls back to LSP if missing
				javascript = { "prettierd", "prettier" },
				typescript = { "prettierd", "prettier" },
				javascriptreact = { "prettierd", "prettier" },
				typescriptreact = { "prettierd", "prettier" },
				json = { "jq" },
				lua = { "stylua" },
				["_"] = { "trim_whitespace" },
			},
		},
	},

	-- ===== FZF fuzzy finder =====
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local fzf = require("fzf-lua")
			fzf.setup({})
			vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "Files" })
			vim.keymap.set("n", "<leader>fg", fzf.live_grep, { desc = "Grep" })
			vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "Buffers" })
			-- vim.keymap.set("n", "<leader>fh", fzf.helps, { desc = "Help" })
		end,
	},

	-- ===== File tree =====
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("nvim-tree").setup({
				view = { width = 34 },
				renderer = { group_empty = true },
				filters = { dotfiles = false },
			})
			vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "File Tree" })
		end,
	},
	-- GitHub Copilot integrated with nvim-cmp
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		build = ":Copilot auth",
		opts = { suggestion = { enabled = false }, panel = { enabled = false } },
	},
	{
		"zbirenbaum/copilot-cmp",
		dependencies = { "zbirenbaum/copilot.lua" },
		config = function()
			require("copilot_cmp").setup()
		end,
	},

	-- Diagnostics panel
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
		config = function(_, opts)
			require("trouble").setup(opts)
			-- v3 bindings
			local km = vim.keymap.set
			km("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Diagnostics (workspace)" })
			km("n", "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "Diagnostics (buffer)" })
			km("n", "<leader>xq", "<cmd>Trouble qflist toggle<CR>", { desc = "Quickfix list" })
			km("n", "<leader>xl", "<cmd>Trouble loclist toggle<CR>", { desc = "Location list" })
		end,
	},

	-- Markdown preview
	{
		"iamcco/markdown-preview.nvim",
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		init = function()
			vim.g.mkdp_auto_start = 0
			vim.g.mkdp_echo_preview_url = 1
		end,
	},

	-- ===== Debugger =====
	{ "mfussenegger/nvim-dap" },
	{ "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap" } },
	{ "theHamsta/nvim-dap-virtual-text", config = true },
	{ "leoluz/nvim-dap-go", dependencies = { "mfussenegger/nvim-dap" } },
	-- JS/TS debug via VSCode js-debug
	{ "mxsdev/nvim-dap-vscode-js", dependencies = { "mfussenegger/nvim-dap" } },
	-- Optional: theme (comment out if you have one)
	{
		"sainnhe/gruvbox-material",
		config = function()
			vim.cmd.colorscheme("gruvbox-material")
		end,
	},
})

-- =============== LSP setup ===============
local lsp = require("lspconfig")
local cmp_cap = require("cmp_nvim_lsp").default_capabilities()

-- mason ensure servers
require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed = { "gopls", "ts_ls", "lua_ls" }, -- Note: tsserver was renamed to ts_ls
	automatic_installation = true,
})

-- LSP keymaps
local on_attach = function(_, bufnr)
	local map = function(m, lhs, rhs)
		vim.keymap.set(m, lhs, rhs, { buffer = bufnr })
	end
	map("n", "gd", vim.lsp.buf.definition)
	map("n", "gr", vim.lsp.buf.references)
	map("n", "gi", vim.lsp.buf.implementation)
	map("n", "K", vim.lsp.buf.hover)
	map("n", "<leader>rn", vim.lsp.buf.rename)
	map("n", "<leader>ca", vim.lsp.buf.code_action)
	map("n", "<leader>f", function()
		vim.lsp.buf.format({ async = true })
	end)
end

-- gopls
lsp.gopls.setup({
	capabilities = cmp_cap,
	on_attach = on_attach,
	settings = {
		gopls = {
			gofumpt = true,
			analyses = { unusedparams = true, fieldalignment = true },
			staticcheck = true,
			hints = { parameterNames = true, rangeVariableTypes = true },
		},
	},
})

-- typescript
lsp.ts_ls.setup({
	capabilities = cmp_cap,
	on_attach = on_attach,
})

-- lua
lsp.lua_ls.setup({
	capabilities = cmp_cap,
	on_attach = on_attach,
})

-- =============== nvim-cmp (completion) ===============
local cmp = require("cmp")
local luasnip = require("LuaSnip")
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-Space>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	sources = {
		{ name = "nvim_lsp" },
		{ name = "path" },
		{ name = "buffer" },
		{ name = "luasnip" },
	},
})

-- =============== DAP setup ===============
local dap = require("dap")
local dapui = require("dapui")
dapui.setup()
vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		-- Go (needs dlv)
		require("dap-go").setup()
		-- JS/TS (needs vscode-js-debug)
		local js = require("dap-vscode-js")
		js.setup({
			debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
			adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
		})
		for _, lang in ipairs({ "javascript", "typescript" }) do
			dap.configurations[lang] = {
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					cwd = "${workspaceFolder}",
					runtimeExecutable = "node",
				},
				{
					type = "pwa-node",
					request = "attach",
					name = "Attach to process",
					processId = require("dap.utils").pick_process,
					cwd = "${workspaceFolder}",
				},
				-- If you use ts-node (ESM):
				-- {
				--   type = "pwa-node",
				--   request = "launch",
				--   name = "TS Node (esm)",
				--   program = "${file}",
				--   cwd = "${workspaceFolder}",
				--   runtimeExecutable = "node",
				--   runtimeArgs = { "--loader=ts-node/esm" },
				-- }
			}
		end
	end,
})

-- DAP keymaps
vim.keymap.set("n", "<F5>", dap.continue)
vim.keymap.set("n", "<F10>", dap.step_over)
vim.keymap.set("n", "<F11>", dap.step_into)
vim.keymap.set("n", "<F12>", dap.step_out)
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP Breakpoint" })
vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "DAP UI" })

-- =============== small QoL ===============
vim.keymap.set("n", "<leader>qq", "<cmd>qa!<CR>")
