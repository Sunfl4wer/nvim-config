vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one
opt.scrolloff = 999 -- keeping cursor in the middle

opt.wrap = false

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

opt.cursorline = true

-- turn on termguicolors for tokyonight colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false

-- wrapping
opt.formatoptions = "jcroqlnt"
opt.textwidth = 80
opt.colorcolumn = "120"

local group = vim.api.nvim_create_augroup("sonnguyen_text_buffer_settings", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = { "markdown", "gitcommit", "text" },
	callback = function()
		vim.opt_local.colorcolumn = "80"
		vim.opt_local.spell = true
	end,
})
