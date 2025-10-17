# Neovim Config

A personal Neovim setup powered by `lazy.nvim`, tuned for day-to-day coding with strong language tooling, Git integration, and a polished UI.

## Requirements
- Neovim 0.9 or newer
- Git (used to fetch plugins)
- `make` (compiles the `telescope-fzf-native` extension)
- Optional tooling: `goimports`, `prettier`, `stylua`, `isort`, `black`, `pylint`, `dlv`, `elixir-ls-debugger` — installed automatically when available via Mason

## Installation
1. Back up any existing config: `mv ~/.config/nvim ~/.config/nvim.backup`
2. Clone this repo to `~/.config/nvim`
3. Launch `nvim` once to let `lazy.nvim` bootstrap and install plugins
4. Run `:Mason` and `:MasonToolsInstall` to ensure the language servers, linters, and formatters you need are installed

## Highlights
### Core Defaults
- Relative numbers, cursorline, and aggressive `scrolloff=999` keep the cursor centered
- Tabs auto-convert to two spaces with treesitter-aware indentation
- Markdown buffers toggle an 80-column ruler and `spell`
- `goimports` runs on every Go file save so source files stay formatted

### Plugins
- UI & UX: `gruvbox-material`, `lualine`, `bufferline`, `indent-blankline`, `dressing.nvim`, and `snacks.nvim` for dashboard, explorer, notifications, and status column
- Navigation: `snacks` pickers, `telescope` with FZF, `which-key`, `vim-tmux-navigator`, and `outline.nvim`
- LSP & Completion: `mason.nvim`, `mason-lspconfig`, `nvim-lspconfig`, `cmp` + `luasnip`, and custom tweaks for `lua_ls` and `gopls`
- Editing: Treesitter plus textobjects, auto pairs, surround, contextual comments, todo-highlights, markdown rendering, and the `speedtyper.nvim` mini-game
- Git: `gitsigns`, inline `git-blame`, `neogit`, `diffview`, and `gitgraph` history visualisation
- Quality: `conform.nvim` formatting, `nvim-lint`, and Snacks diagnostics integration
- Debugging: `nvim-dap`, `dap-ui`, `dap-go`, `nvim-dap-virtual-text`, with optional Elixir debugger wiring

### Keymaps
- `jk`: leave insert mode
- `<leader>nh`: clear search highlights
- Snacks pickers: `<leader><space>` smart file search, `<leader>/` live grep, `<leader>,` buffers, `<leader>e` explorer
- Formatting & linting: `<leader>mp` format via Conform, `<leader>l` trigger lint
- Git: `]h/[h` next/prev hunk, `<leader>hb` blame, `<leader>gl` draw commit graph, `<leader>gs` Snacks status picker
- Debugging: `<F1>` continue, `<F2>` step into, `<F3>` step over, `<F4>` step out, `<F5>` step back, `<F13>` restart
- Diagnostics & outline: `<leader>xw` open Trouble, `<leader>o` toggle symbol outline

## Handy Commands
- `:Lazy` to manage plugins
- `:Mason` / `:MasonToolsInstall` for language tooling
- `:ConformInfo` and `:LintInfo` to inspect formatter/linter state
- `:Trouble`, `:TodoTrouble`, and Snacks pickers for quick issue triage
- `:Speedtyper` to launch the typing trainer

## Notes
- Leader defaults to `\`; set `vim.g.mapleader` earlier in your config if you prefer space
- Snacks adds many more discoverable mappings — hit `<leader>?` (WhichKey) or browse `lua/sonnguyen/plugins/snacks.lua`
- Colors assume truecolor; use a terminal that supports `termguicolors`
