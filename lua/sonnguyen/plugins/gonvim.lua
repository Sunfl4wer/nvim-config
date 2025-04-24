return {
	"fatih/vim-go",
	config = function()
		-- we disable most of these features because treesitter and nvim-lsp
		-- take care of it
		vim.g["go_gopls_enabled"] = 0
		vim.g["go_code_completion_enabled"] = 0
		vim.g["go_fmt_autosave"] = 0
		vim.g["go_imports_autosave"] = 0
		vim.g["go_mod_fmt_autosave"] = 0
		vim.g["go_doc_keywordprg_enabled"] = 0
		vim.g["go_def_mapping_enabled"] = 0
		vim.g["go_textobj_enabled"] = 0
		vim.g["go_list_type"] = "quickfix"
		-- Run gofmt/gofmpt, import packages automatically on save
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = vim.api.nvim_create_augroup("setGoFormatting", { clear = true }),
			pattern = "*.go",
			callback = function()
				local params = vim.lsp.util.make_range_params()
				params.context = { only = { "source.organizeImports" } }
				local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 2000)
				for _, res in pairs(result or {}) do
					for _, r in pairs(res.result or {}) do
						if r.edit then
							vim.lsp.util.apply_workspace_edit(r.edit, "utf-16")
						else
							vim.lsp.buf.execute_command(r.command)
						end
					end
				end

				vim.lsp.buf.format()
			end,
		})

		local function build_go_files()
			if vim.endswith(vim.api.nvim_buf_get_name(0), "_test.go") then
				vim.cmd("GoTestCompile")
			else
				vim.cmd("GoBuild")
			end
		end
		vim.keymap.set("n", "<leader>b", build_go_files)
		-- Go uses gofmt, which uses tabs for indentation and spaces for aligment.
		-- Hence override our indentation rules.
		vim.api.nvim_create_autocmd("Filetype", {
			group = vim.api.nvim_create_augroup("setIndent", { clear = true }),
			pattern = { "go" },
			command = "setlocal noexpandtab tabstop=4 shiftwidth=4",
		})
	end,
}
