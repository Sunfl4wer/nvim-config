return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"onsails/lspkind-nvim",
		"lukas-reineke/cmp-under-comparator",
	},
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		local lspkind = require("lspkind")
		local types = require("cmp.types")
		local compare = require("cmp.config.compare")
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")

		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

		luasnip.config.setup({})

		local modified_priority = {
			[types.lsp.CompletionItemKind.Variable] = types.lsp.CompletionItemKind.Method,
			[types.lsp.CompletionItemKind.Snippet] = 0, -- top
			[types.lsp.CompletionItemKind.Keyword] = 0, -- top
			[types.lsp.CompletionItemKind.Text] = 100, -- bottom
		}

		local function modified_kind(kind)
			return modified_priority[kind] or kind
		end

		require("cmp").setup({
			preselect = false,
			completion = {
				completeopt = "menu,menuone,preview,noselect",
			},
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			formatting = {
				fields = { "menu", "abbr", "kind" },
				format = lspkind.cmp_format({
					with_text = true,
					menu = {
						buffer = "[Buffer]",
						nvim_lsp = "[LSP]",
						nvim_lua = "[Lua]",
					},
				}),
			},

			sorting = {
				priority_weight = 1.0,
				comparators = {
					compare.offset,
					compare.exact,
					function(entry1, entry2) -- sort by length ignoring "=~"
						local len1 = string.len(string.gsub(entry1.completion_item.label, "[=~()_]", ""))
						local len2 = string.len(string.gsub(entry2.completion_item.label, "[=~()_]", ""))
						if len1 ~= len2 then
							return len1 - len2 < 0
						end
					end,
					compare.recently_used,
					function(entry1, entry2) -- sort by compare kind (Variable, Function etc)
						local kind1 = modified_kind(entry1:get_kind())
						local kind2 = modified_kind(entry2:get_kind())
						if kind1 ~= kind2 then
							return kind1 - kind2 < 0
						end
					end,
					compare.score,
					require("cmp-under-comparator").under,
					compare.kind,
				},
			},

			matching = {
				disallow_fuzzy_matching = true,
				disallow_fullfuzzy_matching = true,
				disallow_partial_fuzzy_matching = true,
				disallow_partial_matching = false,
				disallow_prefix_unmatching = true,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-n>"] = cmp.mapping.select_next_item(),
				["<C-p>"] = cmp.mapping.select_prev_item(),
				["<C-d>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<CR>"] = cmp.mapping.confirm({ select = true }),
				-- Preserving tab for AI completion so disable it C-p and C-n is enough
				-- ["<Tab>"] = cmp.mapping(function(fallback)
				-- 	if cmp.visible() then
				-- 		cmp.select_next_item()
				-- 	elseif luasnip.expand_or_jumpable() then
				-- 		luasnip.expand_or_jump()
				-- 	else
				-- 		fallback()
				-- 	end
				-- end, { "i", "s" }),
				-- ["<S-Tab>"] = cmp.mapping(function(fallback)
				-- 	if cmp.visible() then
				-- 		cmp.select_prev_item()
				-- 	elseif luasnip.jumpable(-1) then
				-- 		luasnip.jump(-1)
				-- 	else
				-- 		fallback()
				-- 	end
				-- end, { "i", "s" }),
			}),
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			view = {
				entries = {
					name = "custom",
					selection_order = "near_cursor",
				},
			},
			confirm_opts = {
				behavior = cmp.ConfirmBehavior.Insert,
			},
			sources = {
				{ name = "nvim_lsp" },
				{ name = "luasnip", keyword_length = 2 },
				{ name = "buffer", keyword_length = 5 },
			},
			performance = {
				max_view_entries = 20,
			},
		})
	end,
}
