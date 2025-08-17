# Neovim Dev Setup — Go + TypeScript (Monokai, LSP, FZF, Tree, DAP, Copilot, Markdown)

A compact manual for the config we built together. Drop this in your repo as `README.md`.

---

## Table of Contents

* [Requirements](#requirements)
* [Install](#install)
* [What’s Included](#whats-included)
* [Keybindings (Cheat Sheet)](#keybindings-cheat-sheet)
* [LSP & Completion](#lsp--completion)
* [Formatting](#formatting)
* [Fuzzy Finder (fzf-lua)](#fuzzy-finder-fzf-lua)
* [File Tree (nvim-tree)](#file-tree-nvim-tree)
* [Debugging (nvim-dap)](#debugging-nvim-dap)

  * [Go Debug](#go-debug)
  * [Node/TypeScript Debug](#nodetypescript-debug)
* [Go Extras (vim-go)](#go-extras-vim-go)
* [Markdown Preview](#markdown-preview)
* [Theme (Monokai)](#theme-monokai)
* [Maintenance & Updates](#maintenance--updates)
* [Troubleshooting](#troubleshooting)
* [Customize](#customize)

---

## Requirements

* **Neovim** ≥ 0.9
* **Git**
* **Go** ≥ 1.20 (`go version`)
* **Node.js** ≥ 18 (`node -v`)
* **ripgrep** (`rg`) for fast search
* Optional but nice: **fd** (`fd`)

Examples:

```bash
# macOS (Homebrew)
brew install neovim go node ripgrep fd

# Ubuntu/Debian
sudo apt-get update
sudo apt-get install -y neovim golang nodejs npm ripgrep fd-find
```

---

## Install

1. Put the provided `init.lua` at `~/.config/nvim/init.lua`.

2. Launch Neovim once to bootstrap plugins:

   ```
   nvim
   :Lazy sync
   ```

3. Open **Mason** to install LSPs/formatters:

   ```
   :Mason
   ```

   Install: `gopls`, `typescript-language-server`, `prettierd` (or `prettier`), `stylua`.
   (Optional) Install `jq`, `goimports`, `gofumpt`.

4. Treesitter grammars:

   ```
   :TSUpdate
   ```

5. Copilot sign-in:

   ```
   :Copilot auth
   ```

6. Go debug tool:

   ```bash
   go install github.com/go-delve/delve/cmd/dlv@latest
   ```

7. (JS/TS debug) Install Microsoft’s js-debug (two choices):

   * **Via Lazy (recommended)**: add the plugin

     ```lua
     { "microsoft/vscode-js-debug", build = "npm i && npm run compile" }
     ```

     then `:Lazy sync`.
   * **Or** run the helper if provided by your setup:

     ```
     :JsDebugInstall
     ```

---

## What’s Included

* **LSP**: `gopls`, `ts_ls` (TypeScript/JavaScript)
* **Completion**: `nvim-cmp` + LSP + snippets + **Copilot** via `copilot-cmp`
* **Formatting**: `conform.nvim` with on-save formatting
* **Search**: `fzf-lua` (files, live grep, buffers, help)
* **File tree**: `nvim-tree`
* **Debug**: `nvim-dap`, `dap-ui`, `dap-virtual-text`, `dap-go`, `nvim-dap-vscode-js`
* **Syntax**: `nvim-treesitter`
* **Theme**: **Monokai**
* **Go extras**: `vim-go` (testing, tags, if-err, coverage) without taking over LSP/formatting

---

## Keybindings (Cheat Sheet)

| Action                                     | Keys                        |
| ------------------------------------------ | --------------------------- |
| **Find files**                             | `<leader>ff`                |
| **Live grep**                              | `<leader>fg`                |
| **Buffers**                                | `<leader>fb`                |
| **Help tags**                              | `<leader>fh`                |
| **File tree toggle**                       | `<leader>e`                 |
| **LSP: Definition**                        | `gd`                        |
| **LSP: References**                        | `gr`                        |
| **LSP: Implementation**                    | `gi`                        |
| **LSP: Hover**                             | `K`                         |
| **LSP: Rename**                            | `<leader>rn`                |
| **LSP: Code Action**                       | `<leader>ca`                |
| **Format (manual)**                        | `<leader>f`                 |
| **Diagnostics (workspace)**                | `<leader>xx`                |
| **Diagnostics (buffer)**                   | `<leader>xb`                |
| **DAP: Continue / Step Over / Into / Out** | `F5 / F10 / F11 / F12`      |
| **DAP: Toggle Breakpoint**                 | `<leader>db`                |
| **DAP UI**                                 | `<leader>du`                |
| **vim-go: Test**                           | `<leader>gt`                |
| **vim-go: Test Func**                      | `<leader>gT`                |
| **vim-go: Add/Remove Tags**                | `<leader>ga` / `<leader>gr` |
| **vim-go: If Err**                         | `<leader>ge`                |
| **vim-go: Mod Tidy**                       | `<leader>gm`                |
| **Quit all**                               | `<leader>qq`                |

*Completion menu*:

* Open menu: `Ctrl-Space`
* Confirm: `Enter`
* Next/Prev item: `Tab` / `Shift-Tab`

---

## LSP & Completion

* Managed by `mason.nvim` + `mason-lspconfig.nvim` + `lspconfig`.
* Servers ensured: **gopls**, **ts\_ls** (note: `tsserver` was renamed to `ts_ls`).
* `nvim-cmp` provides suggestions from LSP, path, buffer, snippets, and **Copilot**.

Check LSP status:

```
:LspInfo
```

---

## Formatting

**conform.nvim** formats on save (2s timeout) with LSP fallback.

Per-language:

* **Go**: `goimports` + `gofumpt` (then falls back to LSP if not found)
* **TS/JS/React**: `prettierd` (or `prettier`)
* **Lua**: `stylua`
* **JSON**: `jq`

Manual format: `<leader>f`

> To disable format-on-save for a filetype, edit `format_on_save` condition in the config.

---

## Fuzzy Finder (fzf-lua)

* Files: `<leader>ff`
* Live Grep (requires `ripgrep`): `<leader>fg`
* Buffers: `<leader>fb`
* Help: `<leader>fh`

---

## File Tree (nvim-tree)

* Toggle: `<leader>e`
* Width defaults to 34 columns. Hidden/dotfiles are shown by default.

---

## Debugging (nvim-dap)

Debug UI: `<leader>du`
Breakpoints: `<leader>db`
Run/Step: `F5/F10/F11/F12`

### Go Debug

1. Install **dlv**:

   ```bash
   go install github.com/go-delve/delve/cmd/dlv@latest
   ```
2. In Neovim:

   * Open a Go file, set breakpoints (`<leader>db`).
   * `F5` to start debugging (`dap-go` config is pre-wired).

### Node/TypeScript Debug

1. Install **vscode-js-debug** (see [Install](#install) step 7).
2. The config provides two launch types per `javascript`/`typescript`:

   * **Launch file** (runs the current file with Node)
   * **Attach to process** (choose a running Node PID)
3. Set breakpoints and press `F5`.

> For TypeScript via ts-node/ESM, enable the commented “TS Node (esm)” config in `init.lua`.

---

## Go Extras (vim-go)

We use `vim-go` as a toolbelt **without** conflicting with LSP/formatting.

Helpful binaries (optional but recommended):

```bash
go install github.com/fatih/gomodifytags@latest
go install github.com/cweill/gotests/gotests@latest
go install github.com/josharian/impl@latest
```

Common commands:

* `:GoTest`, `:GoTestFunc`
* `:GoAddTag` / `:GoRemoveTag`
* `:GoIfErr`
* `:GoCoverageToggle`
* `:GoModTidy`

---

## Markdown Preview

* Command: `:MarkdownPreview` (opens in your browser)
* Requires a working Node runtime.

---

## Theme (Monokai)

* Plugin: `tanvirtin/monokai.nvim`
* Enabled automatically in the config:

  ```lua
  vim.cmd.colorscheme("monokai")
  ```
* If you prefer **Monokai Pro** palettes, swap to `loctvl842/monokai-pro.nvim`.

---

## Maintenance & Updates

* **Update plugins**: `:Lazy sync` (or `:Lazy update`)
* **Update Mason tools**: `:Mason`, then press `U` to update
* **Update Treesitter parsers**: `:TSUpdate`
* **Health check**: `:checkhealth`

---

## Troubleshooting

**“formatter not found” / formatting does nothing**

* Open `:Mason` and install the formatter (e.g., `prettierd`, `stylua`).
* Check `:ConformInfo` to see which formatter runs.

**TypeScript LSP not starting**

* Ensure `typescript-language-server` is installed in `:Mason`.
* We use `ts_ls` (new name). Check `:LspInfo`.

**fzf-lua grep finds nothing**

* Install `ripgrep` (`rg`) and ensure it’s on `$PATH`.

**JS/TS debugging fails to start**

* Ensure `vscode-js-debug` is installed and compiled.
* In config: `debugger_path = stdpath("data") .. "/lazy/vscode-js-debug"` — verify this directory exists.

**Go debugging fails**

* Install `dlv`. If using modules, run from project root.

**Copilot suggestions don’t appear**

* Run `:Copilot auth` and sign in.
* Confirm `copilot` appears in the `nvim-cmp` menu (top source).

---

## Customize

* **Toggle format-on-save**: edit `format_on_save` in the `conform.nvim` opts.
* **Add more LSP servers**:

  * `:Mason` → install server
  * Add to `ensure_installed` in `mason-lspconfig` or call `lspconfig.<server>.setup{...}`
* **Keymaps**: search for `vim.keymap.set` in `init.lua`.
* **Theme**: replace `monokai` with any installed colorscheme.
* **File tree defaults**: tweak `require("nvim-tree").setup({ ... })`.

