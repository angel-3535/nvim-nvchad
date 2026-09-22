# NvChad compared with nvim-dotconfig

Comparison made on 2026-09-22 against the local `~/nvim-dotconfig` configuration
and both installed `lazy-lock.json` files. Shared plugins may have different
versions. The original configuration has not been modified.

## Familiar bindings restored

`Space` is the leader. Press sequences one key at a time. Uppercase letters matter.

| Keys | Action |
| --- | --- |
| `Space p v` | Focus file explorer |
| `Space f f`, `Space f g`, `Space f h` | Find files, search project text, help tags |
| `Space a`, `Ctrl-e` | Add a Harpoon bookmark, open Harpoon menu |
| `Ctrl-j/k/l/h` (normal mode) | Harpoon files 1/2/3/4 |
| `Space G P` | Preview Git hunk |
| `Space ?` | Show buffer-local shortcuts |
| `Space r` | Run saved project command |
| `Space r a/e/d` | Add/edit/delete project command |
| `Space r 1` through `Space r 9` | Run a numbered project command |
| `Space t d`, `:Todo` | Project TODO window |
| `J/K` (visual mode) | Move selected lines down/up |
| `Ctrl-d/u` (visual mode) | Half-page movement, keeping selection centered |
| `Ctrl-b` (normal mode) | Increment number, replacing the tmux-conflicting `Ctrl-a` |
| `Ctrl-c` (insert mode) | Return to normal mode |
| `Space y` (visual mode) | Yank to the `*` primary-selection register |
| `Ctrl-q` (terminal mode) | Return to terminal normal mode |
| `Esc` (normal mode) | Clear search highlighting |
| `Ctrl-b/f` (completion) | Scroll completion documentation up/down |
| `Ctrl-Space`, `Ctrl-e`, `Enter` (completion) | Open, abort, accept completion |

When an LSP attaches: `K`, `gd`, `gD`, `gr`, `gs`, `gl`, `[d`, `]d`, `F2`,
`F4`, `Space c a`, `Space g f`, `Space g F`, and `Space o d` have the old
hover/navigation/diagnostic/rename/action/format/definition-in-split behavior.
`Space g f` still uses LSP formatting; NvChad's `Space f m` uses Conform.
These bindings require a working language server for the current file.

NvChad's buffer-local `Space r a` rename binding now adds a project command,
even after LSP attachment. Rename remains on `F2`. Window navigation is still
available through standard `Ctrl-w h/j/k/l`; normal-mode `Ctrl-h/j/k/l` belongs
to Harpoon again. The starter's `;` → `:` and insert-mode `jk` → Escape mappings
were removed, preserving your old/native behavior.

## Old features not brought over

| Plugins or feature | Difference in this NvChad config |
| --- | --- |
| `copilot.lua`, `copilot-cmp` | No Copilot suggestions or panel. Copilot's insert-mode `Ctrl-l`, `Shift-Tab`, `Alt-[`, `Alt-]`, `Ctrl-]`, and `Alt-Enter` bindings are absent. |
| `vim-fugitive` | No Fugitive `:Git` workflow. Gitsigns and the hunk-preview binding remain. |
| `emmet-vim` | No Emmet abbreviation expansion. |
| `nvim-ts-autotag` | No automatic HTML/JSX tag closing or paired-tag renaming. Bracket autopairs is a separate feature. |
| `rainbow-delimiters.nvim` | No multicolor nested delimiters. |
| `nvim-ufo`, `promise-async` | No UFO folding provider; `zR`, `zM`, and `zr` use native folding behavior. |
| `zen-mode.nvim` | No `:ZenMode` or its tmux/statusline integration. |
| `dressing.nvim` | Your Dressing input/select UI and Telescope selector configuration are absent. |
| `telescope-fzf-native.nvim` | No native fzf extension. Your old config declared it but did not explicitly call `load_extension("fzf")`. |
| `lazydev.nvim` | No LazyDev-enhanced Lua workspace integration. NvChad still supplies Lua LSP defaults. |
| `mason-lspconfig.nvim` | No old automatic server-install list. Mason itself is still present. |
| `none-ls.nvim`, `mason-null-ls.nvim` | No Prettier-through-none-ls integration or automatic Prettier installation. |
| `kanagawa.nvim` | Uses NvChad's OneDark theme. Old `:ThemeToggle`, `:ThemeLight`, and `:ThemeDark` commands are absent. |
| `mini.nvim` | NvChad replaces the mini statusline/tabline/icons setup. |
| `ccc.nvim` | NvChad includes Minty color tools instead; `:CccPick` is not available. |

## Language support and formatting

The old config enabled `astro`, `dexter` (Elixir/EEx/HEEx), `ts_ls`, `gopls`,
`lua_ls`, `clangd`, `html`, `ols`, `phpactor`, and `zls`. NvChad currently enables
only `lua_ls`, `html`, and `cssls`. Your custom Dexter settings and Astro
TypeScript SDK path are not ported.

At comparison time NvChad's separate Mason directory has no installed servers
or formatters. The old config's Mason tools are in `~/.local/share/nvim/mason`;
NvChad looks in `~/.local/share/nvim-nvchad/mason`. Enabling a server is not the
same as installing its executable. Use `:Mason` to manage NvChad's tools.

The old config formatted on save through LSP/none-ls, including Prettier for
web files. NvChad currently has **no format-on-save hook**. Conform is configured
for Lua/StyLua only, with LSP fallback when invoked through `Space f m`.

NvChad uses the newer Tree-sitter `main` API with Lua, LuaDoc, printf, Vim, and
Vimdoc parsers installed. The old list included C, query, Markdown,
inline Markdown, and PHP and enabled automatic parser installation. Its
100-KB highlighting cutoff is not carried over.

## NvChad additions

- `NvChad`, `base46`, `ui`: integrated theme picker (`Space t h`), statusline,
  buffer tabs, cheat sheet (`Space c h`), and terminal tools.
- `indent-blankline.nvim`: indentation and scope guides.
- `nvim-autopairs`: automatic bracket/quote pairing integrated with completion.
- `conform.nvim`: formatter framework, replacing the old none-ls setup in role,
  but not yet matching its formatter configuration.
- `cmp-async-path`, `cmp-nvim-lua`, `cmp-buffer`: file-path, Neovim Lua, and
  buffer completion sources. The old config requested a buffer source but did
  not declare `cmp-buffer` in its specs/lockfile.
- `minty`: `:Huefy` and `:Shades` color tools; `volt` and `menu` support NvChad's UI.

Extra shortcuts remain: `Ctrl-n` toggles the tree; `Space e` focuses it;
`Space f w` also searches text; `Space f b` lists buffers; `Space f o` lists
recent files; `Space f a` searches hidden/ignored files; normal-mode
`Tab`/`Shift-Tab` switches buffers; `Space x` closes a buffer; `Space b` opens
an empty buffer; `Ctrl-s` saves. `Space /` toggles comments.

`Alt-i`, `Alt-h`, and `Alt-v` toggle floating/horizontal/vertical terminals;
`Space h/v` creates split terminals. `Ctrl-x` remains an additional terminal
escape. `Space D` opens a type definition, and `Space w a/r/l` manages LSP
workspace folders. `Space d s` lists diagnostics.

In insert mode, NvChad retains `Ctrl-h/j/k/l` cursor movement outside completion.
`Tab`/`Shift-Tab` select completion items or jump through snippets; your old
config did not explicitly set these CMP bindings, and Copilot used `Shift-Tab`
to accept a suggestion line. `Ctrl-d` also scrolls completion documentation up.

## Other behavior and saved data

NvChad's options are retained: relative line numbers start off, line wrapping
is on, `scrolloff` is 0 instead of 12, `updatetime` is 250 instead of 50, and
the old always-block cursor and disabled swapfile settings are not copied.
NvChad also enables smart-case searching, uses the system clipboard for normal
yanks, and allows `h/l` movement across line boundaries. Two-space indentation,
right/below splits, persistent undo, and absolute line numbers are shared.
The old yank-highlight autocmd and custom file/folder icons are not copied.
The file explorer keeps NvChad's automatic focused-file tracking and styling.

Harpoon bookmarks and TODO files are separate under the NvChad data directory;
existing old-config entries are not migrated. Project-runner commands remain
shared because both copies read the project's Git-directory
`nvim-project-runner.json`. UI prompts may look different without Dressing.

The tmux `Ctrl-a`, then `Shift-n` profile toggle and the `nvim`/`nvchad`
launchers are local workstation files, not part of this config repository.
